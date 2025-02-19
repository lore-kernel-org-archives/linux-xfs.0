Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE3D25A34B;
	Wed, 19 Feb 2025 22:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740004711; cv=none; b=MAG07/M4Gyj/Mgxf7bhd/IySwmQaieMimDylCXCbrQi5yqcFK+90+x3iyY3V7lhzjoGXzu53QtwEHREsi/tqnsxeTTlKbxpWyWO6gaAyQLrB6bOajZk1cd41PsCODa8KPGQ65WAUuw9yB8eFSgvOPHOR2ZIPhe4wwQlIR4BxRYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740004711; c=relaxed/simple;
	bh=IFsGmcKl5mstMnklYa87R2b2J/0j+W0vyJqrrnl36aI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=syx0WNONyKzqVBU8LgR/PTo+dIarxow1qErYx9Of/RWVqiasMnV2GQAZuCLgEK94OkOfr3D1TkSbU9aNFJPGkrHVgHG2FokIMe+iSXoFXCuegLDtdwUaf66MlL9lTwZAP5mm6Li9gLxlzwClORg22RfxNSjxoqD7j9mXa/nuWCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLcJdE4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLcJdE4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A2BC4CED1;
	Wed, 19 Feb 2025 22:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740004710;
	bh=IFsGmcKl5mstMnklYa87R2b2J/0j+W0vyJqrrnl36aI=;
	h=Date:From:To:Cc:Subject:From;
	b=DLcJdE4H4pcdhj64RBlxwdenokP6nbwKCWAFaT55EJgnmVpSOcg0F1IQ+b2/MxhZ3
	 xELek5wNyGt0kj/z5SwKwVZGxe5+Ud7eIRw5bdCk2FDsVnBoIlzmuAdtnJDKTR7UXU
	 C+4oYLRYmbG6aqLCpsIhLAK9cT3QDAjcOoFCSBcoOr44Ab1ZHSODoUpblRDpEhcsTy
	 KAOh++yIbUrTdGdBHW2/iS4HRi9eN13HBO52PiWdNlPw7WUc7epD0OHJzaKFMOpJrw
	 yzrTioRuFIELmty+z/GjNrCjHIoUOWPiAYlft42ywe34oVjDyO9NKD0KyfFd4A0Xbg
	 aZbqli3ZspDDA==
Date: Wed, 19 Feb 2025 14:38:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] xfs/614: determine the sector size of the fs image by doing
 a test format
Message-ID: <20250219223830.GS21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In some cases (such as xfs always_cow=1), the configuration of the test
filesystem determines the sector size of the filesystem that we're going
to simulate formatting.  Concretely, even if TEST_DEV is a block device
with 512b sectors, the directio geometry can specify 4k writes to avoid
nasty RMW cycles.  When this happens, mkfs.xfs will set the sector size
to that 4k accordingly, but the golden output selection is wrong.  Fix
this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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
