Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5674AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Feb 2022 07:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiBBHmp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Feb 2022 02:42:45 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45201 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231256AbiBBHmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Feb 2022 02:42:45 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5334810C4BCB;
        Wed,  2 Feb 2022 18:42:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nFAHq-00777U-4r; Wed, 02 Feb 2022 18:42:42 +1100
Date:   Wed, 2 Feb 2022 18:42:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] metadump: handle corruption errors without aborting
Message-ID: <20220202074242.GA59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202024430.GZ59729@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61fa35f3
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=20KFwNOVAAAA:8
        a=Smc0GFfahXnFiY_P0jYA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

Sean Caron reported that a metadump terminated after givin gthis
warning:

xfs_metadump: inode 2216156864 has unexpected extents

Metadump is supposed to ignore corruptions and continue dumping the
filesystem as best it can. Whilst it warns about many situations
where it can't fully dump structures, it should stop processing that
structure and continue with the next one until the entire filesystem
has been processed.

Unfortunately, some warning conditions also return an "abort" error
status, causing metadump to abort if that condition is hit. Most of
these abort conditions should really be "continue on next object"
conditions so that the we attempt to dump the rest of the
filesystem.

Fix the returns for warnings that incorrectly cause aborts
such that the only abort conditions are read errors when
"stop-on-read-error" semantics are specified. Also make the return
values consistently mean abort/continue rather than returning -errno
to mean "stop because read error" and then trying to infer what
the error means in callers without the context it occurred in.

Reported-by: Sean Caron <scaron@umich.edu>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

Sean,

Can you please apply this patch to your xfsprogs source tree and
rebuild it? This should let metadump continue past the corrupt
inodes it aborted on and run through to completion.

-Dave.

 db/metadump.c | 94 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 96b098b0eaca..9b32b88a3c50 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1645,7 +1645,7 @@ process_symlink_block(
 {
 	struct bbmap	map;
 	char		*link;
-	int		ret = 0;
+	int		rval = 1;
 
 	push_cur();
 	map.nmaps = 1;
@@ -1658,8 +1658,7 @@ process_symlink_block(
 
 		print_warning("cannot read %s block %u/%u (%llu)",
 				typtab[btype].name, agno, agbno, s);
-		if (stop_on_read_error)
-			ret = -1;
+		rval = !stop_on_read_error;
 		goto out_pop;
 	}
 	link = iocur_top->data;
@@ -1682,10 +1681,11 @@ process_symlink_block(
 	}
 
 	iocur_top->need_crc = 1;
-	ret = write_buf(iocur_top);
+	if (write_buf(iocur_top))
+		rval = 0;
 out_pop:
 	pop_cur();
-	return ret;
+	return rval;
 }
 
 #define MAX_REMOTE_VALS		4095
@@ -1843,8 +1843,8 @@ process_single_fsb_objects(
 	typnm_t		btype,
 	xfs_fileoff_t	last)
 {
+	int		rval = 1;
 	char		*dp;
-	int		ret = 0;
 	int		i;
 
 	for (i = 0; i < c; i++) {
@@ -1858,8 +1858,7 @@ process_single_fsb_objects(
 
 			print_warning("cannot read %s block %u/%u (%llu)",
 					typtab[btype].name, agno, agbno, s);
-			if (stop_on_read_error)
-				ret = -EIO;
+			rval = !stop_on_read_error;
 			goto out_pop;
 
 		}
@@ -1925,16 +1924,17 @@ process_single_fsb_objects(
 		}
 
 write:
-		ret = write_buf(iocur_top);
+		if (write_buf(iocur_top))
+			rval = 0;
 out_pop:
 		pop_cur();
-		if (ret)
+		if (!rval)
 			break;
 		o++;
 		s++;
 	}
 
-	return ret;
+	return rval;
 }
 
 /*
@@ -1952,7 +1952,7 @@ process_multi_fsb_dir(
 	xfs_fileoff_t	last)
 {
 	char		*dp;
-	int		ret = 0;
+	int		rval = 1;
 
 	while (c > 0) {
 		unsigned int	bm_len;
@@ -1978,8 +1978,7 @@ process_multi_fsb_dir(
 
 				print_warning("cannot read %s block %u/%u (%llu)",
 						typtab[btype].name, agno, agbno, s);
-				if (stop_on_read_error)
-					ret = -1;
+				rval = !stop_on_read_error;
 				goto out_pop;
 
 			}
@@ -1998,18 +1997,19 @@ process_multi_fsb_dir(
 			}
 			iocur_top->need_crc = 1;
 write:
-			ret = write_buf(iocur_top);
+			if (write_buf(iocur_top))
+				rval = 0;
 out_pop:
 			pop_cur();
 			mfsb_map.nmaps = 0;
-			if (ret)
+			if (!rval)
 				break;
 		}
 		c -= bm_len;
 		s += bm_len;
 	}
 
-	return ret;
+	return rval;
 }
 
 static bool
@@ -2039,15 +2039,15 @@ process_multi_fsb_objects(
 		return process_symlink_block(o, s, c, btype, last);
 	default:
 		print_warning("bad type for multi-fsb object %d", btype);
-		return -EINVAL;
+		return 1;
 	}
 }
 
 /* inode copy routines */
 static int
 process_bmbt_reclist(
-	xfs_bmbt_rec_t 		*rp,
-	int 			numrecs,
+	xfs_bmbt_rec_t		*rp,
+	int			numrecs,
 	typnm_t			btype)
 {
 	int			i;
@@ -2059,7 +2059,7 @@ process_bmbt_reclist(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	bool			is_multi_fsb = is_multi_fsb_object(mp, btype);
-	int			error;
+	int			rval = 1;
 
 	if (btype == TYP_DATA)
 		return 1;
@@ -2123,16 +2123,16 @@ process_bmbt_reclist(
 
 		/* multi-extent blocks require special handling */
 		if (is_multi_fsb)
-			error = process_multi_fsb_objects(o, s, c, btype,
+			rval = process_multi_fsb_objects(o, s, c, btype,
 					last);
 		else
-			error = process_single_fsb_objects(o, s, c, btype,
+			rval = process_single_fsb_objects(o, s, c, btype,
 					last);
-		if (error)
-			return 0;
+		if (!rval)
+			break;
 	}
 
-	return 1;
+	return rval;
 }
 
 static int
@@ -2331,7 +2331,7 @@ process_inode_data(
 	return 1;
 }
 
-static int
+static void
 process_dev_inode(
 	xfs_dinode_t		*dip)
 {
@@ -2339,15 +2339,13 @@ process_dev_inode(
 		if (show_warnings)
 			print_warning("inode %llu has unexpected extents",
 				      (unsigned long long)cur_ino);
-		return 0;
-	} else {
-		if (zero_stale_data) {
-			unsigned int	size = sizeof(xfs_dev_t);
+		return;
+	}
+	if (zero_stale_data) {
+		unsigned int	size = sizeof(xfs_dev_t);
 
-			memset(XFS_DFORK_DPTR(dip) + size, 0,
-					XFS_DFORK_DSIZE(dip, mp) - size);
-		}
-		return 1;
+		memset(XFS_DFORK_DPTR(dip) + size, 0,
+				XFS_DFORK_DSIZE(dip, mp) - size);
 	}
 }
 
@@ -2365,11 +2363,10 @@ process_inode(
 	xfs_dinode_t 		*dip,
 	bool			free_inode)
 {
-	int			success;
+	int			rval = 1;
 	bool			crc_was_ok = false; /* no recalc by default */
 	bool			need_new_crc = false;
 
-	success = 1;
 	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* we only care about crc recalculation if we will modify the inode. */
@@ -2390,32 +2387,34 @@ process_inode(
 	/* copy appropriate data fork metadata */
 	switch (be16_to_cpu(dip->di_mode) & S_IFMT) {
 		case S_IFDIR:
-			success = process_inode_data(dip, TYP_DIR2);
+			rval = process_inode_data(dip, TYP_DIR2);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 				need_new_crc = 1;
 			break;
 		case S_IFLNK:
-			success = process_inode_data(dip, TYP_SYMLINK);
+			rval = process_inode_data(dip, TYP_SYMLINK);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 				need_new_crc = 1;
 			break;
 		case S_IFREG:
-			success = process_inode_data(dip, TYP_DATA);
+			rval = process_inode_data(dip, TYP_DATA);
 			break;
 		case S_IFIFO:
 		case S_IFCHR:
 		case S_IFBLK:
 		case S_IFSOCK:
-			success = process_dev_inode(dip);
+			process_dev_inode(dip);
 			need_new_crc = 1;
 			break;
 		default:
 			break;
 	}
 	nametable_clear();
+	if (!rval)
+		goto done;
 
 	/* copy extended attributes if they exist and forkoff is valid */
-	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
+	if (XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
@@ -2425,11 +2424,11 @@ process_inode(
 				break;
 
 			case XFS_DINODE_FMT_EXTENTS:
-				success = process_exinode(dip, TYP_ATTR);
+				rval = process_exinode(dip, TYP_ATTR);
 				break;
 
 			case XFS_DINODE_FMT_BTREE:
-				success = process_btinode(dip, TYP_ATTR);
+				rval = process_btinode(dip, TYP_ATTR);
 				break;
 		}
 		nametable_clear();
@@ -2442,7 +2441,8 @@ done:
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-	return success;
+
+	return rval;
 }
 
 static uint32_t	inodes_copied;
@@ -2541,7 +2541,7 @@ copy_inode_chunk(
 
 			/* process_inode handles free inodes, too */
 			if (!process_inode(agno, agino + ioff + i, dip,
-			    XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
+					XFS_INOBT_IS_FREE_DISK(rp, ioff + i)))
 				goto pop_out;
 
 			inodes_copied++;
@@ -2800,7 +2800,7 @@ copy_ino(
 	xfs_agblock_t		agbno;
 	xfs_agino_t		agino;
 	int			offset;
-	int			rval = 0;
+	int			rval = 1;
 
 	if (ino == 0 || ino == NULLFSINO)
 		return 1;
