Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D9A1EE005;
	Fri, 21 Mar 2025 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592459; cv=none; b=GTjOb4h5jEewYqAbrgJ+51VoMGCm4n5mrGVsbeEH0ZERhFDGbJVbmT5ura5hFE0X/MRONd8n3pMTRdSKRkl9+PYvSseGgq4c2YaPrtrgefCbmezqwOIl6NVLS9EFpVy0gY17gwPLw+i2s8S7p59SADyTixIqnNe6ASqb3DjHTJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592459; c=relaxed/simple;
	bh=oydxMkyc0hiknia09FS2tFcW+lBSuiAv++SGfwgd+xw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTtyiJ63uvwvHWABkc7ITjW9z6qXcamD/DWV/LBHvwbbPaP+mv0xKfxksWCdtuBF/lX0H4So/wnlVajNyUg3K0Ry224qt4ytS6OOFiTIZA+Kc0rQoXvlJ3M6jeSEEPyhygu0eNP8UwszDSEDPvDSM+l+dbbT7ZRELGkM8ikl6uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBUeVaMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBUeVaMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA7C4CEE3;
	Fri, 21 Mar 2025 21:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592459;
	bh=oydxMkyc0hiknia09FS2tFcW+lBSuiAv++SGfwgd+xw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NBUeVaMyosMbghyqOOtm5JfkbrdDDPnTJewG2WvZP6vDWke8Vb/of0gjCV1NC4jPg
	 cf9UBVLX7TEa5NHGHUBG13TQBIOtp9HaJ/ArG+ZPH06xht59gpe29oSGGBs4KaGtOY
	 WjqYrGOwNn0NlRlddapEDe4P7RREwMfvtgYNnGMYc9A2hrMXTP2z0/5bHUKtJC9Gsx
	 8235WwtNvoZgKb8YafgjS96meOI4JabGgWr2OIHZA9/dRRoZHYFZD+NQA3p/vJIK+o
	 F5skqf5jqcbdqTbz/20bqojFn/ubSIgig2YPMvj2uuquwSc5vs+Q9+HU5AmP7/D+Dc
	 k2Y3LrA7oVyaA==
Date: Fri, 21 Mar 2025 14:27:38 -0700
Subject: [PATCH 1/4] xfs/614: determine the sector size of the fs image by
 doing a test format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233981.743619.4539343498817899229.stgit@frogsfrogsfrogs>
In-Reply-To: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
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

