Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0D31B0406;
	Wed, 12 Mar 2025 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821093; cv=none; b=GBuUiIojEaydTBxAdcWJs/JpilzJzqO0TUDskau/Gh4AJpswRiPR+KHuvARujYYe2l6NnED3vTLdk5GJGfV9pJZFDiU52ej7K1nEBJsPIZTRbe5DYpv72gVAjOEYxfEdU2dirdF0UR3EbR3PyaiAeTOh5YU5oHLeo2sQPagkp4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821093; c=relaxed/simple;
	bh=oydxMkyc0hiknia09FS2tFcW+lBSuiAv++SGfwgd+xw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXFzeDFbIywL0+uwOfTyiXrhsizLkHCMZlBKoAsuaLvE3CxvT+vlkXTCIFhJKwj+78D1CswR5/vG6J0VQ07kMy90HnVmkXmEjgwQK51vN97eJonweiV7+h7JLj17/wkN8BpJguQVkNeSdUUphZ1N6540gGx9iTbdbBgMf+TFtFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UClANw0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UClANw0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34424C4CEDD;
	Wed, 12 Mar 2025 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821093;
	bh=oydxMkyc0hiknia09FS2tFcW+lBSuiAv++SGfwgd+xw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UClANw0Ca0uBUY8gzHqPhVql7DnXlQNZd1NtKLslySba1AQhaFcJi7p1XWru8HHg/
	 FqVcDN9bLvccAeZkU1rvB4mXE9g7kgvnGyoT5J01NEYco85bl3X98MDBsiBg/Pu5MO
	 IfWkTZE4Sxp2SJ5q6MwGNal30Hfeuydn9JKeDOm8aY2nw0J+yglbOWQXhbdmcekm4G
	 dzmqnobrsC5M+gnpWc+LFwtPok8d32Him9cydbIRBZY6bXBcurTsDTuEzr0g0uNETR
	 Vj17UkpnJkdMq02nlPIDEZrv6wWFXH9NsH5m1dHCOoCWPRRL95hZUkFk2ruxYOzgAI
	 9fNKlOynZGKMQ==
Date: Wed, 12 Mar 2025 16:11:32 -0700
Subject: [PATCH 1/3] xfs/614: determine the sector size of the fs image by
 doing a test format
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182089124.1400713.2560711587518324233.stgit@frogsfrogsfrogs>
In-Reply-To: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
References: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In some cases (such as xfs always_cow=1), the configuration of the test
filesystem determines the sector size of the filesystem that we're going
to simulate formatting.  Concretely, even if TEST_DEV is a block device
with 512b sectors, the directio geometry can specify 4k writes to avoid
nasty RMW cycles.  When this happens, mkfs.xfs will set the sector size
to that 4k accordingly, but the golden output selection is wrong.  Fix
this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/614 |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/614 b/tests/xfs/614
index 2a799fbf3ed71c..e182f073fddd64 100755
--- a/tests/xfs/614
+++ b/tests/xfs/614
@@ -25,13 +25,16 @@ _require_test
 $MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
 	_notrun "mkfs does not support concurrency options"
 
-test_dev_lbasize=$(blockdev --getss $TEST_DEV)
-seqfull=$0
-_link_out_file "lba${test_dev_lbasize}"
-
+# Figure out what sector size mkfs will use to format, which might be dependent
+# upon the directio write geometry of the test filesystem.
 loop_file=$TEST_DIR/$seq.loop
-
 rm -f "$loop_file"
+truncate -s 16M "$loop_file"
+$MKFS_XFS_PROG -f -N "$loop_file" | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+seqfull=$0
+_link_out_file "lba${sectsz}"
+
 for sz in 16M 512M 1G 2G 16G 64G 256G 512G 1T 2T 4T 16T 64T 256T 512T 1P; do
 	for cpus in 2 4 8 16 32 40 64 96 160 512; do
 		truncate -s "$sz" "$loop_file"

