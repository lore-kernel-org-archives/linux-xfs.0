Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B4713CFB6;
	Wed, 19 Feb 2025 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926768; cv=none; b=JAsCCWunDtGe+w2G/dl+DZ403tZEMk2VVrmCn7LLKK2v4opjCEpVRULdSg2AeEoutyphu9Cu3cBdcQxBNKbHz+ohq0Ok/w7kRm/ZYBYUxPle2VJidjlUn6TYsM7+LT7L7RRZ6F61Nirs9JnADQQVbeaDmMor1kFJFz0ZNoyuzQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926768; c=relaxed/simple;
	bh=w9l5oe9KrYAocr3lXFRNF6FqOuQwVPQ9y4X2JWHYETc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MxikS4+3tX+b7nPjhS7o2NYvHsHYBz8NF8DuqWc4KROWEgyUkqq4k9Ag0H7sH3bT0pdCyt0YXkbIva6DEXG+bFRhOsOtpzfG5VyozPKE/E+mJr2OgXVfqIMCgJd58SGZvIAVpoW86SWZ32K4/zBvzdOox51H0qhN73XwbLI17aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjcWFxcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjcWFxcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FA4C4CEE2;
	Wed, 19 Feb 2025 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926767;
	bh=w9l5oe9KrYAocr3lXFRNF6FqOuQwVPQ9y4X2JWHYETc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cjcWFxcg7OsH0wg/bo64gh32xiTTn2fHWhVsnnchzJFSQNPZrHFQ2TnvRd7xWcFsC
	 MpR/7NoQDgsbYfn5CuPQiRLnFS7tKPQH3xu+Zi065RHTbD+4gpOLE9g8HXVTy++9dg
	 rHspyVpuvEoi64ToaErzE3Ts+rlWPXWk0jCCELqxFpeNgZHfpvtKfKuCWP8ZyiZTTv
	 B/MUU8qo8QsYZr5WLD/QNLk4u7haPaLP/weDAOgaUWLGoFEmNXQMlgMvijgjxZmAlC
	 T241BKydUGlpSxMI+iLwgLlNv2UdSU76vhO1MvuxzcekQjywV5geozZ3Nw1qy5z2Mq
	 pEtz0UKrIQAcg==
Date: Tue, 18 Feb 2025 16:59:26 -0800
Subject: [PATCH 07/15] punch-alternating: detect xfs realtime files with large
 allocation units
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589308.4079457.15370995926162762676.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For files on the XFS realtime volume, it's possible that the file
allocation unit (aka the minimum size we have to punch to deallocate
file blocks) could be greater than a single fs block.  This utility
assumed that it's always possible to punch a single fs block, but for
these types of files, all that does is zeroes the page cache.  While
that's what most *user applications* want, fstests uses punching to
fragment file mapping metadata and/or fragment free space, so adapt this
test for that purpose by detecting realtime files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/punch-alternating.c |   28 +++++++++++++++++++++++++++-
 tests/xfs/114           |    4 ++++
 tests/xfs/146           |    2 +-
 tests/xfs/187           |    3 ++-
 tests/xfs/341           |    4 ++--
 5 files changed, 36 insertions(+), 5 deletions(-)


diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 18dd215197db2b..d2bb4b6a2276c9 100644
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
index 510d31a4028598..f764cad73babb7 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -47,6 +47,10 @@ $XFS_IO_PROG -f \
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
index b6f4c2bd093d45..1cd7076d2426ee 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -67,7 +67,7 @@ _xfs_force_bdev realtime $SCRATCH_MNT
 # Allocate some stuff at the start, to force the first falloc of the ouch file
 # to happen somewhere in the middle of the rt volume
 $XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
-$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+$here/src/punch-alternating "$SCRATCH_MNT/b"
 
 avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
 toobig="$((avail * 2))"
diff --git a/tests/xfs/187 b/tests/xfs/187
index 56a9adc164eab2..1d32d702f629c9 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -130,7 +130,8 @@ $XFS_IO_PROG -f -c "truncate $required_sz" -c "falloc 0 $remap_sz" $SCRATCH_MNT/
 # Punch out every other extent of the last two sections, to fragment free space.
 frag_sz=$((remap_sz * 3))
 punch_off=$((bigfile_sz - frag_sz))
-$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
+rtextsize_bytes=$((fsbsize * rtextsize_blks))
+$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / rtextsize_bytes))
 
 # Make sure we have some free rtextents.
 free_rtx=$(_xfs_statfs_field "$SCRATCH_MNT" statfs.f_bavail)
diff --git a/tests/xfs/341 b/tests/xfs/341
index 6e25549b2b3d08..9b12febf8d5c49 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -41,8 +41,8 @@ len=$((blocks * rtextsz))
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

