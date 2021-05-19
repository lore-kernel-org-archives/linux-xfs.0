Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EE1C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DA0A610A1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESX60 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhESX6Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F24061007;
        Wed, 19 May 2021 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468625;
        bh=cFicwlFrt0V4AhGjbJ0/9P8jCG5wSmfLw8AAJyqqYPc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hJCoyIgjWWwun6jX88uRGiD6gwxj6B1+hPGOzy4B9yvA4HPACZzy4vMHYj5gAyYgr
         BUGO+re/NRDh+Y90ij2lqRoF25n/T2I3F5fLOFYmyuh7QGF5MiGIN7bypw9XgIq4MR
         WYe2Izm1mQ8C3o/+Kx6Knr0vPEa/N9LvWoo1bqNIYTd8wPFXGa6S+HF3z4SGAtrK7n
         PaAjty5FP/EedejM40hSr9V3WFmyRfhku9y3a5re0FPzPys1CJ0k4oHqxH45fxveoM
         thhc4+cN4I8AXWxtXCCXBk7UKKGEzNQz7N148GWCVSyPne1muhJl9G3YhrlsD9iHv7
         dMkV283dBQM6Q==
Subject: [PATCH 4/6] fsx/fsstress: round blocksize properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:57:04 -0700
Message-ID: <162146862463.2500122.10829551919577698395.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The block sizes reported by stat and DIOINFO aren't required to be
powers of two.  This can happen on an XFS filesystem with a realtime
extent size that isn't a power of two; on such filesystems, certain IO
calls will fail due to alignment issues.  Fix that by providing rounding
helpers that work for all sizes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c |   24 ++++++++++++------------
 ltp/fsx.c      |   22 +++++++++++-----------
 src/global.h   |   13 +++++++++++++
 3 files changed, 36 insertions(+), 23 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index e7cd0eae..b4ddf5e2 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2140,7 +2140,7 @@ do_aio_rw(int opno, long r, int flags)
 			" fallback to stat()\n",
 				procid, opno, f.path, st, errno);
 		diob.d_mem = diob.d_miniosz = stb.st_blksize;
-		diob.d_maxiosz = INT_MAX & ~(diob.d_miniosz - 1);
+		diob.d_maxiosz = rounddown_64(INT_MAX, diob.d_miniosz);
 	}
 	dio_env = getenv("XFS_DIO_MIN");
 	if (dio_env)
@@ -2608,7 +2608,7 @@ clonerange_f(
 
 	/* Calculate offsets */
 	len = (random() % FILELEN_MAX) + 1;
-	len &= ~(stat1.st_blksize - 1);
+	len = rounddown_64(len, stat1.st_blksize);
 	if (len == 0)
 		len = stat1.st_blksize;
 	if (len > stat1.st_size)
@@ -2620,7 +2620,7 @@ clonerange_f(
 	else
 		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
 	off1 %= maxfsize;
-	off1 &= ~(stat1.st_blksize - 1);
+	off1 = rounddown_64(off1, stat1.st_blksize);
 
 	/*
 	 * If srcfile == destfile, randomly generate destination ranges
@@ -2631,7 +2631,7 @@ clonerange_f(
 		lr = ((int64_t)random() << 32) + random();
 		off2 = (off64_t)(lr % max_off2);
 		off2 %= maxfsize;
-		off2 &= ~(stat2.st_blksize - 1);
+		off2 = rounddown_64(off2, stat2.st_blksize);
 	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
 
 	/* Clone data blocks */
@@ -2968,7 +2968,7 @@ deduperange_f(
 
 	/* Never try to dedupe more than half of the src file. */
 	len = (random() % FILELEN_MAX) + 1;
-	len &= ~(stat[0].st_blksize - 1);
+	len = rounddown_64(len, stat[0].st_blksize);
 	if (len == 0)
 		len = stat[0].st_blksize / 2;
 	if (len > stat[0].st_size / 2)
@@ -2981,7 +2981,7 @@ deduperange_f(
 	else
 		off[0] = (off64_t)(lr % MIN(stat[0].st_size - len, MAXFSIZE));
 	off[0] %= maxfsize;
-	off[0] &= ~(stat[0].st_blksize - 1);
+	off[0] = rounddown_64(off[0], stat[0].st_blksize);
 
 	/*
 	 * If srcfile == destfile[i], randomly generate destination ranges
@@ -2997,7 +2997,7 @@ deduperange_f(
 			else
 				off[i] = (off64_t)(lr % MIN(stat[i].st_size - len, MAXFSIZE));
 			off[i] %= maxfsize;
-			off[i] &= ~(stat[i].st_blksize - 1);
+			off[i] = rounddown_64(off[i], stat[i].st_blksize);
 		} while (stat[0].st_ino == stat[i].st_ino &&
 			 llabs(off[i] - off[0]) < len &&
 			 tries++ < 10);
@@ -3406,7 +3406,7 @@ dread_f(int opno, long r)
 			" fallback to stat()\n",
 				procid, opno, f.path, st, errno);
 		diob.d_mem = diob.d_miniosz = stb.st_blksize;
-		diob.d_maxiosz = INT_MAX & ~(diob.d_miniosz - 1);
+		diob.d_maxiosz = rounddown_64(INT_MAX, diob.d_miniosz);
 	}
 
 	dio_env = getenv("XFS_DIO_MIN");
@@ -3483,7 +3483,7 @@ dwrite_f(int opno, long r)
 				" %s%s return %d, fallback to stat()\n",
 			       procid, opno, f.path, st, errno);
 		diob.d_mem = diob.d_miniosz = stb.st_blksize;
-		diob.d_maxiosz = INT_MAX & ~(diob.d_miniosz - 1);
+		diob.d_maxiosz = rounddown_64(INT_MAX, diob.d_miniosz);
 	}
 
 	dio_env = getenv("XFS_DIO_MIN");
@@ -3579,8 +3579,8 @@ do_fallocate(int opno, long r, int mode)
 	 */
 	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
 		(opno % 2)) {
-		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
-		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
+		off = roundup_64(off, stb.st_blksize);
+		len = roundup_64(len, stb.st_blksize);
 	}
 	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
@@ -4186,7 +4186,7 @@ do_mmap(int opno, long r, int prot)
 
 	lr = ((int64_t)random() << 32) + random();
 	off = (off64_t)(lr % stb.st_size);
-	off &= (off64_t)(~(sysconf(_SC_PAGE_SIZE) - 1));
+	off = rounddown_64(off, sysconf(_SC_PAGE_SIZE));
 	len = (size_t)(random() % MIN(stb.st_size - off, FILELEN_MAX)) + 1;
 
 	flags = (random() % 2) ? MAP_SHARED : MAP_PRIVATE;
diff --git a/ltp/fsx.c b/ltp/fsx.c
index d526d294..12c2cc33 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -203,7 +203,7 @@ static void *round_ptr_up(void *ptr, unsigned long align, unsigned long offset)
 {
 	unsigned long ret = (unsigned long)ptr;
 
-	ret = ((ret + align - 1) & ~(align - 1));
+	ret = roundup_64(ret, align);
 	ret += offset;
 	return (void *)ret;
 }
@@ -1948,12 +1948,12 @@ static void generate_dest_range(bool bdy_align,
 
 	TRIM_OFF_LEN(*src_offset, *size, file_size);
 	if (bdy_align) {
-		*src_offset -= *src_offset % readbdy;
+		*src_offset = rounddown_64(*src_offset, readbdy);
 		if (o_direct)
-			*size -= *size % readbdy;
+			*size = rounddown_64(*size, readbdy);
 	} else {
-		*src_offset = *src_offset & ~(block_size - 1);
-		*size = *size & ~(block_size - 1);
+		*src_offset = rounddown_64(*src_offset, block_size);
+		*size = rounddown_64(*size, block_size);
 	}
 
 	do {
@@ -1964,9 +1964,9 @@ static void generate_dest_range(bool bdy_align,
 		*dst_offset = random();
 		TRIM_OFF(*dst_offset, max_range_end);
 		if (bdy_align)
-			*dst_offset -= *dst_offset % writebdy;
+			*dst_offset = rounddown_64(*dst_offset, writebdy);
 		else
-			*dst_offset = *dst_offset & ~(block_size - 1);
+			*dst_offset = rounddown_64(*dst_offset, block_size);
 	} while (range_overlaps(*src_offset, *dst_offset, *size) ||
 		 *dst_offset + *size > max_range_end);
 }
@@ -2156,8 +2156,8 @@ test(void)
 		break;
 	case OP_COLLAPSE_RANGE:
 		TRIM_OFF_LEN(offset, size, file_size - 1);
-		offset = offset & ~(block_size - 1);
-		size = size & ~(block_size - 1);
+		offset = rounddown_64(offset, block_size);
+		size = rounddown_64(size, block_size);
 		if (size == 0) {
 			log4(OP_COLLAPSE_RANGE, offset, size, FL_SKIPPED);
 			goto out;
@@ -2167,8 +2167,8 @@ test(void)
 	case OP_INSERT_RANGE:
 		TRIM_OFF(offset, file_size);
 		TRIM_LEN(file_size, size, maxfilelen);
-		offset = offset & ~(block_size - 1);
-		size = size & ~(block_size - 1);
+		offset = rounddown_64(offset, block_size);
+		size = rounddown_64(size, block_size);
 		if (size == 0) {
 			log4(OP_INSERT_RANGE, offset, size, FL_SKIPPED);
 			goto out;
diff --git a/src/global.h b/src/global.h
index e5e46234..b4407099 100644
--- a/src/global.h
+++ b/src/global.h
@@ -171,4 +171,17 @@
 #include <sys/mman.h>
 #endif
 
+static inline unsigned long long
+rounddown_64(unsigned long long x, unsigned int y)
+{
+	x /= y;
+	return x * y;
+}
+
+static inline unsigned long long
+roundup_64(unsigned long long x, unsigned int y)
+{
+	return rounddown_64(x + y - 1, y);
+}
+
 #endif /* GLOBAL_H */

