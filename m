Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40222C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiLaDKB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiLaDKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:10:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EC51054D;
        Fri, 30 Dec 2022 19:10:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C3D161CFF;
        Sat, 31 Dec 2022 03:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C07DC433F0;
        Sat, 31 Dec 2022 03:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456199;
        bh=ZAmV0qeIna3RO54L+knjByCCv3gz5nrG33VZjLMC66M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uREiY+JlUFUk0QCt8jpDEUtVHM7qmc3kqiSoAJOpudnRQprnhljG+ufE8GPnJwnn6
         sSLPTzBVUSn4+pNH9vuuuVEQNcuEHIKpH/cScmw6mae8BxSJUDKvWlEmMtf9B0HNuS
         sGZ+c/r0iZ0JQ0FmL7u19WDqJjDdFwvIDnQgpKzJZAa2n99RlnNog8x1fu47wJwmkn
         4kOiSqA1ULiaf1Yb3Dngm4cHDVpoyfNNBXfzRuDZC1sHcPiKH8j9Tl8eXgUt3FPRgN
         Vu+nr8LOoz1RXqbHXEwal/qMc8JmJv5gHmpSsD0jTYip+gX8qKqnvnoQ1l+S7OhYmS
         3553BpyJYuuUA==
Subject: [PATCH 02/12] punch-alternating: detect xfs realtime files with large
 allocation units
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:39 -0800
Message-ID: <167243883973.739029.13588431902885797694.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For files on the XFS realtime volume, it's possible that the file
allocation unit (aka the minimum size we have to punch to deallocate
file blocks) could be greater than a single fs block.  This utility
assumed that it's always possible to punch a single fs block, but for
these types of files, all that does is zeroes the page cache.  While
that's what most *user applications* want, fstests uses punching to
fragment file mapping metadata and/or fragment free space, so adapt this
test for that purpose by detecting realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 src/punch-alternating.c |   28 +++++++++++++++++++++++++++-
 tests/xfs/114           |    4 ++++
 tests/xfs/146           |    2 +-
 tests/xfs/187           |    3 ++-
 tests/xfs/341           |    4 ++--
 5 files changed, 36 insertions(+), 5 deletions(-)


diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 18dd215197..d2bb4b6a22 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -20,6 +20,28 @@ void usage(char *cmd)
 	exit(1);
 }
 
+/* Compute the file allocation unit size for an XFS file. */
+static int detect_xfs_alloc_unit(int fd)
+{
+	struct fsxattr fsx;
+	struct xfs_fsop_geom fsgeom;
+	int ret;
+
+	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, &fsgeom);
+	if (ret)
+		return -1;
+
+	ret = ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
+	if (ret)
+		return -1;
+
+	ret = fsgeom.blocksize;
+	if (fsx.fsx_xflags & XFS_XFLAG_REALTIME)
+		ret *= fsgeom.rtextsize;
+
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	struct stat	s;
@@ -82,7 +104,11 @@ int main(int argc, char *argv[])
 		goto err;
 
 	sz = s.st_size;
-	blksz = sf.f_bsize;
+	c = detect_xfs_alloc_unit(fd);
+	if (c > 0)
+		blksz = c;
+	else
+		blksz = sf.f_bsize;
 
 	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 	for (offset = start_offset * blksz;
diff --git a/tests/xfs/114 b/tests/xfs/114
index 0e8a0529ab..7ecb4d217c 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -49,6 +49,10 @@ $XFS_IO_PROG -f \
 	-c "pwrite -S 0x68 -b 1048576 0 $len2" \
 	$SCRATCH_MNT/f2 >> $seqres.full
 
+# The arguments to punch-alternating must be specified in units of file
+# allocation units, so we divide the argument by $file_blksz.  We already
+# verified that $blksz is congruent with $file_blksz, so the fpunch parameters
+# will always align with the file allocation unit.
 $here/src/punch-alternating -o $((16 * blksz / file_blksz)) \
 	-s $((blksz / file_blksz)) \
 	-i $((blksz * 2 / file_blksz)) \
diff --git a/tests/xfs/146 b/tests/xfs/146
index 123bdff59f..c1ef5e7e1b 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -68,7 +68,7 @@ _xfs_force_bdev realtime $SCRATCH_MNT
 # Allocate some stuff at the start, to force the first falloc of the ouch file
 # to happen somewhere in the middle of the rt volume
 $XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
-$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+$here/src/punch-alternating "$SCRATCH_MNT/b"
 
 avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
 toobig="$((avail * 2))"
diff --git a/tests/xfs/187 b/tests/xfs/187
index 7c34d8e630..14c3b37670 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -132,7 +132,8 @@ $XFS_IO_PROG -f -c "truncate $required_sz" -c "falloc 0 $remap_sz" $SCRATCH_MNT/
 # Punch out every other extent of the last two sections, to fragment free space.
 frag_sz=$((remap_sz * 3))
 punch_off=$((bigfile_sz - frag_sz))
-$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
+rtextsize_bytes=$((fsbsize * rtextsize_blks))
+$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / rtextsize_bytes))
 
 # Make sure we have some free rtextents.
 free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep statfs.f_bavail | awk '{print $3}')
diff --git a/tests/xfs/341 b/tests/xfs/341
index 1f734c9015..7d2842b579 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -43,8 +43,8 @@ len=$((blocks * rtextsz))
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
-$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f1 >> "$seqres.full"
-$here/src/punch-alternating -i $((2 * rtextsz_blks)) -s $rtextsz_blks $SCRATCH_MNT/f2 >> "$seqres.full"
+$here/src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+$here/src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
 echo garbage > $SCRATCH_MNT/f3
 ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount

