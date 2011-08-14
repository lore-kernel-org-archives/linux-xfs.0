Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EKCoTu260959 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 15:12:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE2C016956B7
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 13:14:32 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zl7DabbfA0FSCTTk for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 13:14:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qsh31-0006si-C5
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 20:12:39 +0000
Date: Sun, 14 Aug 2011 16:12:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs_repair: add printf format checking and fix the fallout
Message-ID: <20110814201239.GA26453@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Add the gcc printf like attribute to the xfs_repair-internal logging helpers,
and fix the massive fallout.  A large part of it is dealing with the correct
format for fixed size 64-bit types, but there were a lot of real bug in there,
including some that lead to crashed when repairing certain corrupted
filesystems on ARM based systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Anisse Astier <anisse@astier.eu>

Index: xfsprogs-dev/repair/err_protos.h
===================================================================
--- xfsprogs-dev.orig/repair/err_protos.h	2011-08-02 03:57:26.019688145 -0700
+++ xfsprogs-dev/repair/err_protos.h	2011-08-14 09:58:48.989272234 -0700
@@ -17,10 +17,14 @@
  */
 
 /* abort, internal error */
-void  __attribute__((noreturn)) do_abort(char const *, ...);
+void  __attribute__((noreturn)) do_abort(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* abort, system error */
-void  __attribute__((noreturn)) do_error(char const *, ...);
+void  __attribute__((noreturn)) do_error(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* issue warning */
-void do_warn(char const *, ...);
+void do_warn(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* issue log message */
-void do_log(char const *, ...);
+void do_log(char const *, ...)
+	__attribute__((format(printf,1,2)));
Index: xfsprogs-dev/repair/xfs_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/xfs_repair.c	2011-08-02 03:57:26.029688090 -0700
+++ xfsprogs-dev/repair/xfs_repair.c	2011-08-14 09:58:48.989272234 -0700
@@ -457,18 +457,18 @@ calc_mkfs(xfs_mount_t *mp)
 	 */
 	if (mp->m_sb.sb_rootino != first_prealloc_ino)  {
 		do_warn(
-_("sb root inode value %llu %sinconsistent with calculated value %lu\n"),
+_("sb root inode value %" PRIu64 " %sinconsistent with calculated value %u\n"),
 			mp->m_sb.sb_rootino,
 			(mp->m_sb.sb_rootino == NULLFSINO ? "(NULLFSINO) ":""),
 			first_prealloc_ino);
 
 		if (!no_modify)
 			do_warn(
-		_("resetting superblock root inode pointer to %lu\n"),
+		_("resetting superblock root inode pointer to %u\n"),
 				first_prealloc_ino);
 		else
 			do_warn(
-		_("would reset superblock root inode pointer to %lu\n"),
+		_("would reset superblock root inode pointer to %u\n"),
 				first_prealloc_ino);
 
 		/*
@@ -480,18 +480,18 @@ _("sb root inode value %llu %sinconsiste
 
 	if (mp->m_sb.sb_rbmino != first_prealloc_ino + 1)  {
 		do_warn(
-_("sb realtime bitmap inode %llu %sinconsistent with calculated value %lu\n"),
+_("sb realtime bitmap inode %" PRIu64 " %sinconsistent with calculated value %u\n"),
 			mp->m_sb.sb_rbmino,
 			(mp->m_sb.sb_rbmino == NULLFSINO ? "(NULLFSINO) ":""),
 			first_prealloc_ino + 1);
 
 		if (!no_modify)
 			do_warn(
-		_("resetting superblock realtime bitmap ino pointer to %lu\n"),
+		_("resetting superblock realtime bitmap ino pointer to %u\n"),
 				first_prealloc_ino + 1);
 		else
 			do_warn(
-		_("would reset superblock realtime bitmap ino pointer to %lu\n"),
+		_("would reset superblock realtime bitmap ino pointer to %u\n"),
 				first_prealloc_ino + 1);
 
 		/*
@@ -503,18 +503,18 @@ _("sb realtime bitmap inode %llu %sincon
 
 	if (mp->m_sb.sb_rsumino != first_prealloc_ino + 2)  {
 		do_warn(
-_("sb realtime summary inode %llu %sinconsistent with calculated value %lu\n"),
-		mp->m_sb.sb_rsumino,
-		(mp->m_sb.sb_rsumino == NULLFSINO ? "(NULLFSINO) ":""),
-		first_prealloc_ino + 2);
+_("sb realtime summary inode %" PRIu64 " %sinconsistent with calculated value %u\n"),
+			mp->m_sb.sb_rsumino,
+			(mp->m_sb.sb_rsumino == NULLFSINO ? "(NULLFSINO) ":""),
+			first_prealloc_ino + 2);
 
 		if (!no_modify)
 			do_warn(
-		_("resetting superblock realtime summary ino pointer to %lu\n"),
+		_("resetting superblock realtime summary ino pointer to %u\n"),
 				first_prealloc_ino + 2);
 		else
 			do_warn(
-		_("would reset superblock realtime summary ino pointer to %lu\n"),
+		_("would reset superblock realtime summary ino pointer to %u\n"),
 				first_prealloc_ino + 2);
 
 		/*
@@ -644,8 +644,8 @@ main(int argc, char **argv)
 			max_mem = MIN(max_mem, (LONG_MAX >> 10) + 1);
 
 		if (verbose > 1)
-			do_log(_("        - max_mem = %lu, icount = %llu, "
-				"imem = %llu, dblock = %llu, dmem = %llu\n"),
+			do_log(
+	_("        - max_mem = %lu, icount = %" PRIu64 ", imem = %" PRIu64 ", dblock = %" PRIu64 ", dmem = %" PRIu64 "\n"),
 				max_mem, mp->m_sb.sb_icount,
 				mp->m_sb.sb_icount >> (10 - 2),
 				mp->m_sb.sb_dblocks,
Index: xfsprogs-dev/include/linux.h
===================================================================
--- xfsprogs-dev.orig/include/linux.h	2011-08-02 03:57:26.229687006 -0700
+++ xfsprogs-dev/include/linux.h	2011-08-14 09:58:48.989272234 -0700
@@ -23,6 +23,7 @@
 #include <sys/param.h>
 #include <sys/sysmacros.h>
 #include <sys/stat.h>
+#include <inttypes.h>
 #include <malloc.h>
 #include <getopt.h>
 #include <endian.h>
Index: xfsprogs-dev/repair/agheader.c
===================================================================
--- xfsprogs-dev.orig/repair/agheader.c	2011-08-02 03:57:26.039688035 -0700
+++ xfsprogs-dev/repair/agheader.c	2011-08-14 09:58:48.992605549 -0700
@@ -73,7 +73,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_
 			if (be32_to_cpu(agf->agf_length) != agblocks)  {
 				retval = XR_AG_AGF;
 				do_warn(
-			_("bad length %d for agf %d, should be %llu\n"),
+	_("bad length %d for agf %d, should be %" PRIu64 "\n"),
 					be32_to_cpu(agf->agf_length),
 						i, agblocks);
 				if (!no_modify)
@@ -87,15 +87,17 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_
 	 * space in the AGFL, we'll reclaim it later.
 	 */
 	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp))  {
-		do_warn(_("flfirst %d in agf %d too large (max = %d)\n"),
-			be32_to_cpu(agf->agf_flfirst), i, XFS_AGFL_SIZE(mp));
+		do_warn(_("flfirst %d in agf %d too large (max = %zu)\n"),
+			be32_to_cpu(agf->agf_flfirst),
+			i, XFS_AGFL_SIZE(mp));
 		if (!no_modify)
 			agf->agf_flfirst = cpu_to_be32(0);
 	}
 
 	if (be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp))  {
-		do_warn(_("fllast %d in agf %d too large (max = %d)\n"),
-			be32_to_cpu(agf->agf_fllast), i, XFS_AGFL_SIZE(mp));
+		do_warn(_("fllast %d in agf %d too large (max = %zu)\n"),
+			be32_to_cpu(agf->agf_fllast),
+			i, XFS_AGFL_SIZE(mp));
 		if (!no_modify)
 			agf->agf_fllast = cpu_to_be32(0);
 	}
@@ -156,7 +158,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_
 			if (be32_to_cpu(agi->agi_length) != agblocks)  {
 				retval = XR_AG_AGI;
 				do_warn(
-			_("bad length # %d for agi %d, should be %llu\n"),
+	_("bad length # %d for agi %d, should be %" PRIu64 "\n"),
 					be32_to_cpu(agi->agi_length),
 						agno, agblocks);
 				if (!no_modify)
Index: xfsprogs-dev/repair/progress.c
===================================================================
--- xfsprogs-dev.orig/repair/progress.c	2011-08-02 03:57:26.053021297 -0700
+++ xfsprogs-dev/repair/progress.c	2011-08-14 09:58:48.992605549 -0700
@@ -261,7 +261,7 @@ progress_rpt_thread (void *p)
 				current_phase, duration(elapsed, msgbuf),
 				(int) (60*sum/(elapsed)), *msgp->format->type);
 			do_log(
-				_("\t- %02d:%02d:%02d: Phase %d: %llu%% done - estimated remaining time %s\n"),
+	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
 				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
 				current_phase, percent,
 				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
Index: xfsprogs-dev/repair/sb.c
===================================================================
--- xfsprogs-dev.orig/repair/sb.c	2011-08-02 03:57:26.063021242 -0700
+++ xfsprogs-dev/repair/sb.c	2011-08-14 09:58:48.995938864 -0700
@@ -488,7 +488,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int
 	if (buf == NULL) {
 		do_error(
 	_("error reading superblock %u -- failed to memalign buffer\n"),
-			agno, off);
+			agno);
 		exit(1);
 	}
 	memset(buf, 0, size);
@@ -497,7 +497,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int
 
 	if (lseek64(x.dfd, off, SEEK_SET) != off)  {
 		do_warn(
-	_("error reading superblock %u -- seek to offset %lld failed\n"),
+	_("error reading superblock %u -- seek to offset %" PRId64 " failed\n"),
 			agno, off);
 		return(XR_EOF);
 	}
@@ -505,7 +505,7 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int
 	if ((rval = read(x.dfd, buf, size)) != size)  {
 		error = errno;
 		do_warn(
-	_("superblock read failed, offset %lld, size %d, ag %u, rval %d\n"),
+	_("superblock read failed, offset %" PRId64 ", size %d, ag %u, rval %d\n"),
 			off, size, agno, rval);
 		do_error("%s\n", strerror(error));
 	}
Index: xfsprogs-dev/repair/bmap.c
===================================================================
--- xfsprogs-dev.orig/repair/bmap.c	2011-08-02 03:57:26.076354505 -0700
+++ xfsprogs-dev/repair/bmap.c	2011-08-14 09:58:48.995938864 -0700
@@ -52,7 +52,7 @@ blkmap_alloc(
 	if (!blkmap || blkmap->naexts < nex) {
 		blkmap = realloc(blkmap, BLKMAP_SIZE(nex));
 		if (!blkmap) {
-			do_warn(_("malloc failed in blkmap_alloc (%u bytes)\n"),
+			do_warn(_("malloc failed in blkmap_alloc (%zu bytes)\n"),
 				BLKMAP_SIZE(nex));
 			return NULL;
 		}
@@ -141,7 +141,7 @@ blkmap_getn(
 		 */
 		bmp = malloc(nb * sizeof(bmap_ext_t));
 		if (!bmp)
-			do_error(_("blkmap_getn malloc failed (%u bytes)\n"),
+			do_error(_("blkmap_getn malloc failed (%" PRIu64 " bytes)\n"),
 						nb * sizeof(bmap_ext_t));
 
 		bmp[nex].startblock = ext->startblock + (o - ext->startoff);
Index: xfsprogs-dev/repair/incore.c
===================================================================
--- xfsprogs-dev.orig/repair/incore.c	2011-08-02 03:57:26.086354450 -0700
+++ xfsprogs-dev/repair/incore.c	2011-08-14 09:58:48.999272179 -0700
@@ -227,7 +227,7 @@ init_rt_bmap(
 	rt_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
 	if (!rt_bmap) {
 		do_error(
-		_("couldn't allocate realtime block map, size = %llu\n"),
+	_("couldn't allocate realtime block map, size = %" PRIu64 "\n"),
 			mp->m_sb.sb_rextents);
 		return;
 	}
Index: xfsprogs-dev/repair/phase7.c
===================================================================
--- xfsprogs-dev.orig/repair/phase7.c	2011-08-02 03:57:26.099687710 -0700
+++ xfsprogs-dev/repair/phase7.c	2011-08-14 09:58:48.999272179 -0700
@@ -40,19 +40,19 @@ set_nlinks(
 
 	if (!no_modify) {
 		*dirty = 1;
-		do_warn(_("resetting inode %llu nlinks from %d to %d\n"),
+		do_warn(_("resetting inode %" PRIu64 " nlinks from %d to %d\n"),
 			ino, dinoc->di_nlink, nrefs);
 
 		if (nrefs > XFS_MAXLINK_1)  {
 			ASSERT(fs_inode_nlink);
 			do_warn(
-_("nlinks %d will overflow v1 ino, ino %llu will be converted to version 2\n"),
+_("nlinks %d will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
 				nrefs, ino);
 
 		}
 		dinoc->di_nlink = nrefs;
 	} else  {
-		do_warn(_("would have reset inode %llu nlinks from %d to %d\n"),
+		do_warn(_("would have reset inode %" PRIu64 " nlinks from %d to %d\n"),
 			ino, dinoc->di_nlink, nrefs);
 	}
 }
@@ -80,11 +80,12 @@ update_inode_nlinks(
 
 	if (error)  {
 		if (!no_modify)
-			do_error(_("couldn't map inode %llu, err = %d\n"),
+			do_error(
+	_("couldn't map inode %" PRIu64 ", err = %d\n"),
 				ino, error);
 		else  {
 			do_warn(
-	_("couldn't map inode %llu, err = %d, can't compare link counts\n"),
+	_("couldn't map inode %" PRIu64 ", err = %d, can't compare link counts\n"),
 				ino, error);
 			return;
 		}
Index: xfsprogs-dev/repair/attr_repair.c
===================================================================
--- xfsprogs-dev.orig/repair/attr_repair.c	2011-08-02 03:57:26.109687657 -0700
+++ xfsprogs-dev/repair/attr_repair.c	2011-08-14 09:58:49.005938810 -0700
@@ -170,7 +170,7 @@ process_shortform_attr(
 			/* whoops there's a discrepancy. Clear the hdr */
 			if (!no_modify) {
 				do_warn(
-		_("there are no attributes in the fork for inode %llu\n"),
+	_("there are no attributes in the fork for inode %" PRIu64 "\n"),
 					ino);
 				asf->hdr.totsize = 
 					cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
@@ -178,7 +178,7 @@ process_shortform_attr(
 				return(1);
 			} else {
 				do_warn(
-	_("would junk the attribute fork since count is 0 for inode %llu\n"),
+	_("would junk the attribute fork since count is 0 for inode %" PRIu64 "\n"),
 					ino);
 				return(1);
 			}
@@ -201,12 +201,12 @@ process_shortform_attr(
 			do_warn(_("zero length name entry in attribute fork,"));
 			if (!no_modify) {
 				do_warn(
-		_(" truncating attributes for inode %llu to %d\n"), ino, i);
+	_(" truncating attributes for inode %" PRIu64 " to %d\n"), ino, i);
 				*repair = 1;
 				break;	/* and then update hdr fields */
 			} else {
 				do_warn(
-		_(" would truncate attributes for inode %llu to %d\n"), ino, i);
+	_(" would truncate attributes for inode %" PRIu64 " to %d\n"), ino, i);
 				break;
 			}
 		} else {
@@ -218,16 +218,16 @@ process_shortform_attr(
 					((remainingspace - currententry->
 					namelen) < currententry->valuelen)) {
 				do_warn(
-			_("name or value attribute lengths are too large,\n"));
+	_("name or value attribute lengths are too large,\n"));
 				if (!no_modify) {
 					do_warn(
-			_(" truncating attributes for inode %llu to %d\n"),
+	_(" truncating attributes for inode %" PRIu64 " to %d\n"),
 						ino, i);
 					*repair = 1;
 					break; /* and then update hdr fields */
 				} else {
 					do_warn(
-			_(" would truncate attributes for inode %llu to %d\n"),
+	_(" would truncate attributes for inode %" PRIu64 " to %d\n"),
 						ino, i);
 					break;
 				}
@@ -263,7 +263,7 @@ process_shortform_attr(
 			if (!no_modify) {
 				/* get rid of only this entry */
 				do_warn(
-			_("removing attribute entry %d for inode %llu\n"),
+	_("removing attribute entry %d for inode %" PRIu64 "\n"),
 					i, ino);
 				tempentry = (xfs_attr_sf_entry_t *)
 					((__psint_t) currententry +
@@ -275,7 +275,7 @@ process_shortform_attr(
 				continue; /* go back up now */
 			} else {
 				do_warn(
-			_("would remove attribute entry %d for inode %llu\n"),
+	_("would remove attribute entry %d for inode %" PRIu64 "\n"),
 					i, ino);
 			}
 		}
@@ -289,12 +289,12 @@ process_shortform_attr(
 
 	if (asf->hdr.count != i)  {
 		if (no_modify)  {
-			do_warn(_("would have corrected attribute entry count "
-				  "in inode %llu from %d to %d\n"),
+			do_warn(
+	_("would have corrected attribute entry count in inode %" PRIu64 " from %d to %d\n"),
 				ino, asf->hdr.count, i);
 		} else  {
-			do_warn(_("corrected attribute entry count in inode "
-				  "%llu, was %d, now %d\n"),
+			do_warn(
+	_("corrected attribute entry count in inode %" PRIu64 ", was %d, now %d\n"),
 				ino, asf->hdr.count, i);
 			asf->hdr.count = i;
 			*repair = 1;
@@ -304,13 +304,13 @@ process_shortform_attr(
 	/* ASSUMPTION: currentsize <= totsize */
 	if (be16_to_cpu(asf->hdr.totsize) != currentsize)  {
 		if (no_modify)  {
-			do_warn(_("would have corrected attribute totsize in "
-				  "inode %llu from %d to %d\n"),
+			do_warn(
+	_("would have corrected attribute totsize in inode %" PRIu64 " from %d to %d\n"),
 				ino, be16_to_cpu(asf->hdr.totsize),
 				currentsize);
 		} else  {
-			do_warn(_("corrected attribute entry totsize in "
-				  "inode %llu, was %d, now %d\n"),
+			do_warn(
+	_("corrected attribute entry totsize in inode %" PRIu64 ", was %d, now %d\n"),
 				ino, be16_to_cpu(asf->hdr.totsize),
 				currentsize);
 			asf->hdr.totsize = cpu_to_be16(currentsize);
@@ -339,16 +339,16 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t in
 	while (amountdone < valuelen) {
 		bno = blkmap_get(blkmap, blocknum + i);
 		if (bno == NULLDFSBNO) {
-			do_warn(_("remote block for attributes of inode %llu"
-				  " is missing\n"), ino);
+			do_warn(
+	_("remote block for attributes of inode %" PRIu64 " is missing\n"), ino);
 			clearit = 1;
 			break;
 		}
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
-			do_warn(_("can't read remote block for attributes"
-				  " of inode %llu\n"), ino);
+			do_warn(
+	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
 			clearit = 1;
 			break;
 		}
@@ -391,8 +391,8 @@ process_leaf_attr_local(
 	local = xfs_attr_leaf_name_local(leaf, i);
 	if (local->namelen == 0 || namecheck((char *)&local->nameval[0], 
 							local->namelen)) {
-		do_warn(_("attribute entry %d in attr block %u, inode %llu "
-			"has bad name (namelen = %d)\n"),
+		do_warn(
+	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
 		return -1;
 	}
@@ -408,8 +408,9 @@ process_leaf_attr_local(
 	if (be32_to_cpu(entry->hashval) != libxfs_da_hashname(
 				&local->nameval[0], local->namelen) ||
 				be32_to_cpu(entry->hashval) < last_hashval) {
-		do_warn(_("bad hashvalue for attribute entry %d in "
-			"attr block %u, inode %llu\n"), i, da_bno, ino);
+		do_warn(
+	_("bad hashvalue for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
+			i, da_bno, ino);
 		return -1;
 	}
 
@@ -417,8 +418,8 @@ process_leaf_attr_local(
 	if (entry->flags & XFS_ATTR_ROOT) {
 		if (valuecheck((char *)&local->nameval[0], NULL, 
 				local->namelen, be16_to_cpu(local->valuelen))) {
-			do_warn(_("bad security value for attribute entry %d "
-				"in attr block %u, inode %llu\n"), 
+			do_warn(
+	_("bad security value for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
 				i, da_bno, ino);
 			return -1;
 		}
@@ -450,8 +451,8 @@ process_leaf_attr_remote(
 						remotep->namelen) ||
 			be32_to_cpu(entry->hashval) < last_hashval ||
 			be32_to_cpu(remotep->valueblk) == 0) {
-		do_warn(_("inconsistent remote attribute entry %d in "
-			"attr block %u, ino %llu\n"), i, da_bno, ino);
+		do_warn(
+	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
 		return -1;
 	}
 
@@ -460,21 +461,24 @@ process_leaf_attr_remote(
  
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
-		do_warn(_("cannot malloc enough for remotevalue attribute "
-			"for inode %llu\n"), ino);
+		do_warn(
+	_("cannot malloc enough for remotevalue attribute for inode %" PRIu64 "\n"),
+			ino);
 		do_warn(_("SKIPPING this remote attribute\n"));
 		goto out;
 	}
 	if (rmtval_get(mp, ino, blkmap, be32_to_cpu(remotep->valueblk),
 				be32_to_cpu(remotep->valuelen), value)) {
-		do_warn(_("remote attribute get failed for entry %d, "
-			"inode %llu\n"), i, ino);
+		do_warn(
+	_("remote attribute get failed for entry %d, inode %" PRIu64 "\n"),
+			i, ino);
 		goto bad_free_out;
 	}
 	if (valuecheck((char *)&remotep->name[0], value, remotep->namelen,
 				be32_to_cpu(remotep->valuelen))) {
-		do_warn(_("remote attribute value check failed for entry %d, "
-			"inode %llu\n"), i, ino);
+		do_warn(
+	_("remote attribute value check failed for entry %d, inode %" PRIu64 "\n"),
+			i, ino);
 		goto bad_free_out;
 	}
 	free(value);
@@ -510,7 +514,7 @@ process_leaf_attr_block(
 	if (be16_to_cpu(leaf->hdr.count) * sizeof(xfs_attr_leaf_entry_t)
 			+ sizeof(xfs_attr_leaf_hdr_t) > XFS_LBSIZE(mp)) {
 		do_warn(
-	_("bad attribute count %d in attr block %u, inode %llu\n"),
+	_("bad attribute count %d in attr block %u, inode %" PRIu64 "\n"),
 			be16_to_cpu(leaf->hdr.count), da_bno, ino);
 		return (1);
 	}
@@ -525,7 +529,7 @@ process_leaf_attr_block(
 		/* check if index is within some boundary. */
 		if (be16_to_cpu(entry->nameidx) > XFS_LBSIZE(mp)) {
 			do_warn(
-		_("bad attribute nameidx %d in attr block %u, inode %llu\n"),
+	_("bad attribute nameidx %d in attr block %u, inode %" PRIu64 "\n"),
 				be16_to_cpu(entry->nameidx), da_bno, ino);
 			clearit = 1;
 			break;
@@ -534,7 +538,7 @@ process_leaf_attr_block(
 		if (entry->flags & XFS_ATTR_INCOMPLETE) {
 			/* we are inconsistent state. get rid of us */
 			do_warn(
-	_("attribute entry #%d in attr block %u, inode %llu is INCOMPLETE\n"),
+	_("attribute entry #%d in attr block %u, inode %" PRIu64 " is INCOMPLETE\n"),
 				i, da_bno, ino);
 			clearit = 1;
 			break;
@@ -545,8 +549,7 @@ process_leaf_attr_block(
 		stop = start + sizeof(xfs_attr_leaf_entry_t);
 		if (set_da_freemap(mp, attr_freemap, start, stop))  {
 			do_warn(
-		_("attribute entry %d in attr block %u, inode %llu claims "
-		  "already used space\n"),
+	_("attribute entry %d in attr block %u, inode %" PRIu64 " claims already used space\n"),
 				i, da_bno, ino);
 			clearit = 1;
 			break;	/* got an overlap */
@@ -568,8 +571,8 @@ process_leaf_attr_block(
 
 		if (set_da_freemap(mp, attr_freemap, be16_to_cpu(entry->nameidx),
 				be16_to_cpu(entry->nameidx) + thissize)) {
-			do_warn(_("attribute entry %d in attr block %u, "
-				  "inode %llu claims used space\n"),
+			do_warn(
+	_("attribute entry %d in attr block %u, inode %" PRIu64 " claims used space\n"),
 				i, da_bno, ino);
 			clearit = 1;
 			break;	/* got an overlap */
@@ -594,7 +597,7 @@ process_leaf_attr_block(
 			if (!no_modify)  {
 				do_warn(
 	_("- resetting first used heap value from %d to %d in "
-	  "block %u of attribute fork of inode %llu\n"),
+	  "block %u of attribute fork of inode %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.firstused), 
 					firstb, da_bno, ino);
 				leaf->hdr.firstused = cpu_to_be16(firstb);
@@ -602,7 +605,7 @@ process_leaf_attr_block(
 			} else  {
 				do_warn(
 	_("- would reset first used value from %d to %d in "
-	  "block %u of attribute fork of inode %llu\n"),
+	  "block %u of attribute fork of inode %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.firstused), 
 					firstb, da_bno, ino);
 			}
@@ -612,7 +615,7 @@ process_leaf_attr_block(
 			if (!no_modify)  {
 				do_warn(
 	_("- resetting usedbytes cnt from %d to %d in "
-	  "block %u of attribute fork of inode %llu\n"),
+	  "block %u of attribute fork of inode %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.usedbytes), 
 					usedbs, da_bno, ino);
 				leaf->hdr.usedbytes = cpu_to_be16(usedbs);
@@ -620,7 +623,7 @@ process_leaf_attr_block(
 			} else  {
 				do_warn(
 	_("- would reset usedbytes cnt from %d to %d in "
-	  "block %u of attribute fork of %llu\n"),
+	  "block %u of attribute fork of %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.usedbytes), 
 					usedbs, da_bno, ino);
 			}
@@ -668,16 +671,17 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		ASSERT(da_bno != 0);
 
 		if (dev_bno == NULLDFSBNO) {
-			do_warn(_("can't map block %u for attribute fork "
-				  "for inode %llu\n"), da_bno, ino);
+			do_warn(
+	_("can't map block %u for attribute fork for inode %" PRIu64 "\n"),
+				da_bno, ino);
 			goto error_out;
 		}
 
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
 					XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
-			do_warn(_("can't read file block %u (fsbno %llu) for"
-				" attribute fork of inode %llu\n"),
+			do_warn(
+	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
 				da_bno, dev_bno, ino);
 			goto error_out;
 		}
@@ -686,8 +690,8 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 
 		/* check magic number for leaf directory btree block */
 		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) {
-			do_warn(_("bad attribute leaf magic %#x "
-				  "for inode %llu\n"),
+			do_warn(
+	_("bad attribute leaf magic %#x for inode %" PRIu64 "\n"),
 				 leaf->hdr.info.magic, ino);
 			libxfs_putbuf(bp);
 			goto error_out;
@@ -717,8 +721,8 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		da_cursor->level[0].dirty = repair;
 
 		if (be32_to_cpu(leaf->hdr.info.back) != prev_bno)  {
-			do_warn(_("bad sibling back pointer for block %u in "
-				  "attribute fork for inode %llu\n"),
+			do_warn(
+	_("bad sibling back pointer for block %u in attribute fork for inode %" PRIu64 "\n"),
 				da_bno, ino);
 			libxfs_putbuf(bp);
 			goto error_out;
@@ -744,7 +748,8 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		/*
 		 * verify the final path up (right-hand-side) if still ok
 		 */
-		do_warn(_("bad hash path in attribute fork for inode %llu\n"),
+		do_warn(
+	_("bad hash path in attribute fork for inode %" PRIu64 "\n"),
 			da_cursor->ino);
 		goto error_out;
 	}
@@ -843,21 +848,23 @@ process_longform_attr(
 		if (dip->di_aformat == XFS_DINODE_FMT_EXTENTS && 
 				be16_to_cpu(dip->di_anextents) == 0)
 			return(0); /* the kernel can handle this state */
-		do_warn(_("block 0 of inode %llu attribute fork is missing\n"), 
+		do_warn(
+	_("block 0 of inode %" PRIu64 " attribute fork is missing\n"),
 			ino);
 		return(1);
 	}
 	/* FIX FOR bug 653709 -- EKN */
 	if (mp->m_sb.sb_agcount < XFS_FSB_TO_AGNO(mp, bno)) {
-		do_warn(_("agno of attribute fork of inode %llu out of "
-			  "regular partition\n"), ino);
+		do_warn(
+	_("agno of attribute fork of inode %" PRIu64 " out of regular partition\n"), ino);
 		return(1);
 	}
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp) {
-		do_warn(_("can't read block 0 of inode %llu attribute fork\n"),
+		do_warn(
+	_("can't read block 0 of inode %" PRIu64 " attribute fork\n"),
 			ino);
 		return(1);
 	}
@@ -871,14 +878,15 @@ process_longform_attr(
 	if (be32_to_cpu(leaf->hdr.info.forw) != 0 || 
 				be32_to_cpu(leaf->hdr.info.back) != 0)  {
 		if (!no_modify)  {
-			do_warn(_("clearing forw/back pointers in block 0 "
-				  "for attributes in inode %llu\n"), ino);
+			do_warn(
+	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+				ino);
 			repairlinks = 1;
 			leaf->hdr.info.forw = cpu_to_be32(0);
 			leaf->hdr.info.back = cpu_to_be32(0);
 		} else  {
-			do_warn(_("would clear forw/back pointers in block 0 "
-				  "for attributes in inode %llu\n"), ino);
+			do_warn(
+	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
 		}
 	}
 
@@ -907,7 +915,8 @@ process_longform_attr(
 			libxfs_putbuf(bp);
 		return (process_node_attr(mp, ino, dip, blkmap)); /* + repair */
 	default:
-		do_warn(_("bad attribute leaf magic # %#x for dir ino %llu\n"),
+		do_warn(
+	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
 			be16_to_cpu(leaf->hdr.info.magic), ino);
 		libxfs_putbuf(bp);
 		return(1);
@@ -974,7 +983,7 @@ process_attributes(
 			/* if err, convert this to shortform and clear it */
 			/* if repair and no error, it's taken care of */
 	} else  {
-		do_warn(_("illegal attribute format %d, ino %llu\n"),
+		do_warn(_("illegal attribute format %d, ino %" PRIu64 "\n"),
 			aformat, ino);
 		err = 1;
 	}
Index: xfsprogs-dev/repair/dino_chunks.c
===================================================================
--- xfsprogs-dev.orig/repair/dino_chunks.c	2011-08-02 03:57:26.119687603 -0700
+++ xfsprogs-dev/repair/dino_chunks.c	2011-08-14 09:58:49.009272126 -0700
@@ -56,8 +56,8 @@ check_aginode_block(xfs_mount_t	*mp,
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
 			XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp) {
-		do_warn(_("cannot read agbno (%u/%u), disk block %lld\n"), agno,
-			agbno, (xfs_daddr_t)XFS_AGB_TO_DADDR(mp, agno, agbno));
+		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
+			agno, agbno, XFS_AGB_TO_DADDR(mp, agno, agbno));
 		return(0);
 	}
 
@@ -444,14 +444,14 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		case XR_E_INUSE_FS:
 		case XR_E_FS_MAP:
 			do_warn(
-		_("inode block %d/%d multiply claimed, (state %d)\n"),
+	_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, cur_agbno, state);
 			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
 			pthread_mutex_unlock(&ag_locks[agno]);
 			return 0;
 		case XR_E_INO:
 			do_error(
-		_("uncertain inode block overlap, agbno = %d, ino = %llu\n"),
+	_("uncertain inode block overlap, agbno = %d, ino = %" PRIu64 "\n"),
 				agbno, ino);
 			break;
 		default:
@@ -490,7 +490,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		switch (state) {
 		case XR_E_INO:
 			do_error(
-		_("uncertain inode block %llu already known\n"),
+		_("uncertain inode block %" PRIu64 " already known\n"),
 				XFS_AGB_TO_FSB(mp, agno, cur_agbno));
 			break;
 		case XR_E_UNKNOWN:
@@ -593,6 +593,7 @@ process_inode_chunk(
 	int			ibuf_offset;
 	xfs_agino_t		agino;
 	xfs_agblock_t		agbno;
+	xfs_ino_t		ino;
 	int			dirty = 0;
 	int			isa_dir = 0;
 	int			blks_per_cluster;
@@ -626,21 +627,21 @@ process_inode_chunk(
 
 	bplist = malloc(cluster_count * sizeof(xfs_buf_t *));
 	if (bplist == NULL)
-		do_error(_("failed to allocate %d bytes of memory\n"),
-			cluster_count * sizeof(xfs_buf_t*));
+		do_error(_("failed to allocate %zd bytes of memory\n"),
+			cluster_count * sizeof(xfs_buf_t *));
 
 	for (bp_index = 0; bp_index < cluster_count; bp_index++) {
 		pftrace("about to read off %llu in AG %d",
-			(long long)XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
+			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
 
 		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp, blks_per_cluster), 0);
 		if (!bplist[bp_index]) {
-			do_warn(_("cannot read inode %llu, disk block %lld, cnt %d\n"),
+			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
 				XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
 				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				(int)XFS_FSB_TO_BB(mp, blks_per_cluster));
+				XFS_FSB_TO_BB(mp, blks_per_cluster));
 			while (bp_index > 0) {
 				bp_index--;
 				libxfs_putbuf(bplist[bp_index]);
@@ -757,7 +758,7 @@ process_inode_chunk(
 		break;
 	default:
 		set_bmap(agno, agbno, XR_E_MULT);
-		do_warn(_("inode block %llu multiply claimed, state was %d\n"),
+		do_warn(_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
 			XFS_AGB_TO_FSB(mp, agno, agbno), state);
 		break;
 	}
@@ -769,6 +770,7 @@ process_inode_chunk(
 		 */
 		dino = xfs_make_iptr(mp, bplist[bp_index], cluster_offset);
 		agino = irec_offset + ino_rec->ino_startnum;
+		ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 		is_used = 3;
 		ino_dirty = 0;
@@ -792,10 +794,9 @@ process_inode_chunk(
 		if (is_used)  {
 			if (is_inode_free(ino_rec, irec_offset))  {
 				if (verbose || no_modify)  {
-					do_warn(_("imap claims in-use inode "
-						  "%llu is free, "),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("imap claims in-use inode %" PRIu64 " is free, "),
+						ino);
 				}
 
 				if (verbose || !no_modify)
@@ -842,55 +843,48 @@ process_inode_chunk(
 		}
 
 		if (status)  {
-			if (mp->m_sb.sb_rootino ==
-					XFS_AGINO_TO_INO(mp, agno, agino))  {
+			if (mp->m_sb.sb_rootino == ino) {
 				need_root_inode = 1;
 
 				if (!no_modify)  {
-					do_warn(_("cleared root inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("cleared root inode %" PRIu64 "\n"),
+						ino);
 				} else  {
-					do_warn(_("would clear root inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("would clear root inode %" PRIu64 "\n"),
+						ino);
 				}
-			} else if (mp->m_sb.sb_rbmino ==
-					XFS_AGINO_TO_INO(mp, agno, agino))  {
+			} else if (mp->m_sb.sb_rbmino == ino) {
 				need_rbmino = 1;
 
 				if (!no_modify)  {
-					do_warn(_("cleared realtime bitmap "
-						  "inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("cleared realtime bitmap inode %" PRIu64 "\n"),
+						ino);
 				} else  {
-					do_warn(_("would clear realtime bitmap "
-						  "inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("would clear realtime bitmap inode %" PRIu64 "\n"),
+						ino);
 				}
-			} else if (mp->m_sb.sb_rsumino ==
-					XFS_AGINO_TO_INO(mp, agno, agino))  {
+			} else if (mp->m_sb.sb_rsumino == ino) {
 				need_rsumino = 1;
 
 				if (!no_modify)  {
-					do_warn(_("cleared realtime summary "
-						  "inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("cleared realtime summary inode %" PRIu64 "\n"),
+						ino);
 				} else  {
-					do_warn(_("would clear realtime summary"
-						  " inode %llu\n"),
-						XFS_AGINO_TO_INO(mp, agno,
-						agino));
+					do_warn(
+	_("would clear realtime summary inode %" PRIu64 "\n"),
+						ino);
 				}
 			} else if (!no_modify)  {
-				do_warn(_("cleared inode %llu\n"),
-					XFS_AGINO_TO_INO(mp, agno, agino));
+				do_warn(_("cleared inode %" PRIu64 "\n"),
+					ino);
 			} else  {
-				do_warn(_("would have cleared inode %llu\n"),
-					XFS_AGINO_TO_INO(mp, agno, agino));
+				do_warn(_("would have cleared inode %" PRIu64 "\n"),
+					ino);
 			}
 		}
 
@@ -940,8 +934,8 @@ process_inode_chunk(
 				break;
 			default:
 				set_bmap(agno, agbno, XR_E_MULT);
-				do_warn(_("inode block %llu multiply claimed, "
-					  "state was %d\n"),
+				do_warn(
+	_("inode block %" PRIu64 " multiply claimed, state was %d\n"),
 					XFS_AGB_TO_FSB(mp, agno, agbno), state);
 				break;
 			}
Index: xfsprogs-dev/repair/phase6.c
===================================================================
--- xfsprogs-dev.orig/repair/phase6.c	2011-08-02 03:57:26.133020863 -0700
+++ xfsprogs-dev/repair/phase6.c	2011-08-14 09:58:49.012605442 -0700
@@ -60,7 +60,7 @@ add_dotdot_update(
 	dotdot_update_t		*dir = malloc(sizeof(dotdot_update_t));
 
 	if (!dir)
-		do_error(_("malloc failed add_dotdot_update (%u bytes)\n"),
+		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
 			sizeof(dotdot_update_t));
 
 	dir->next = dotdot_update_list;
@@ -171,7 +171,7 @@ dir_hash_add(
 	}
 
 	if ((p = malloc(sizeof(*p))) == NULL)
-		do_error(_("malloc failed in dir_hash_add (%u bytes)\n"),
+		do_error(_("malloc failed in dir_hash_add (%zu bytes)\n"),
 			sizeof(*p));
 
 	p->nextbyaddr = hashtab->byaddr[byaddr];
@@ -238,7 +238,7 @@ dir_hash_check(
 		seeval = DIR_HASH_CK_NOLEAF;
 	if (seeval == DIR_HASH_CK_OK)
 		return 0;
-	do_warn(_("bad hash table for directory inode %llu (%s): "),
+	do_warn(_("bad hash table for directory inode %" PRIu64 " (%s): "),
 		ip->i_ino, seevalstr[seeval]);
 	if (!no_modify)
 		do_warn(_("rebuilding\n"));
@@ -546,7 +546,7 @@ fill_rbmino(xfs_mount_t *mp)
 					&first, 1, &map, &nmap, NULL);
 		if (error || nmap != 1) {
 			do_error(
-		_("couldn't map realtime bitmap block %llu, error = %d\n"),
+	_("couldn't map realtime bitmap block %" PRIu64 ", error = %d\n"),
 				bno, error);
 		}
 
@@ -559,7 +559,7 @@ fill_rbmino(xfs_mount_t *mp)
 
 		if (error) {
 			do_warn(
-_("can't access block %llu (fsbno %llu) of realtime bitmap inode %llu\n"),
+_("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %" PRIu64 "\n"),
 				bno, map.br_startblock, mp->m_sb.sb_rbmino);
 			return(1);
 		}
@@ -615,7 +615,7 @@ fill_rsumino(xfs_mount_t *mp)
 					&first, 1, &map, &nmap, NULL);
 		if (error || nmap != 1) {
 			do_error(
-	_("couldn't map realtime summary inode block %llu, error = %d\n"),
+	_("couldn't map realtime summary inode block %" PRIu64 ", error = %d\n"),
 				bno, error);
 		}
 
@@ -628,7 +628,7 @@ fill_rsumino(xfs_mount_t *mp)
 
 		if (error) {
 			do_warn(
-_("can't access block %llu (fsbno %llu) of realtime summary inode %llu\n"),
+_("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode %" PRIu64 "\n"),
 				bno, map.br_startblock, mp->m_sb.sb_rsumino);
 			return(1);
 		}
@@ -1156,11 +1156,11 @@ map_first_dblock_fsbno(xfs_mount_t	*mp,
 	if (error || nmap != 1)  {
 		if (!no_modify)
 			do_error(
-_("can't map block %d in %s inode %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map block %d in %s inode %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 				da_bno, ftype, ino, error, nmap);
 		else  {
 			do_warn(
-_("can't map block %d in %s inode %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map block %d in %s inode %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 				da_bno, ftype, ino, error, nmap);
 			return(NULLDFSBNO);
 		}
@@ -1168,10 +1168,12 @@ _("can't map block %d in %s inode %llu,
 
 	if ((fsbno = map.br_startblock) == HOLESTARTBLOCK)  {
 		if (!no_modify)
-			do_error(_("block %d in %s ino %llu doesn't exist\n"),
+			do_error(
+	_("block %d in %s ino %" PRIu64 " doesn't exist\n"),
 				da_bno, ftype, ino);
 		else  {
-			do_warn(_("block %d in %s ino %llu doesn't exist\n"),
+			do_warn(
+	_("block %d in %s ino %" PRIu64 " doesn't exist\n"),
 				da_bno, ftype, ino);
 			return(NULLDFSBNO);
 		}
@@ -1196,7 +1198,7 @@ _("can't map block %d in %s inode %llu,
 
 		if (!bp) {
 			do_warn(
-	_("can't read block %u (fsbno %llu) for directory inode %llu\n"),
+	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
 					da_bno, fsbno, ino);
 			return(NULLDFSBNO);
 		}
@@ -1206,7 +1208,7 @@ _("can't map block %d in %s inode %llu,
 		if (be16_to_cpu(node->hdr.info.magic) != XFS_DA_NODE_MAGIC)  {
 			libxfs_putbuf(bp);
 			do_warn(
-_("bad dir/attr magic number in inode %llu, file bno = %u, fsbno = %llu\n"),
+_("bad dir/attr magic number in inode %" PRIu64 ", file bno = %u, fsbno = %" PRIu64 "\n"),
 				ino, da_bno, fsbno);
 			return(NULLDFSBNO);
 		}
@@ -1226,11 +1228,11 @@ _("bad dir/attr magic number in inode %l
 		if (error || nmap != 1)  {
 			if (!no_modify)
 				do_error(
-_("can't map block %d in %s ino %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map block %d in %s ino %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 					da_bno, ftype, ino, error, nmap);
 			else  {
 				do_warn(
-_("can't map block %d in %s ino %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map block %d in %s ino %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 					da_bno, ftype, ino, error, nmap);
 				return(NULLDFSBNO);
 			}
@@ -1238,11 +1240,11 @@ _("can't map block %d in %s ino %llu, xf
 		if ((fsbno = map.br_startblock) == HOLESTARTBLOCK)  {
 			if (!no_modify)
 				do_error(
-				_("block %d in %s inode %llu doesn't exist\n"),
+	_("block %d in %s inode %" PRIu64 " doesn't exist\n"),
 					da_bno, ftype, ino);
 			else  {
 				do_warn(
-				_("block %d in %s inode %llu doesn't exist\n"),
+	_("block %d in %s inode %" PRIu64 " doesn't exist\n"),
 					da_bno, ftype, ino);
 				return(NULLDFSBNO);
 			}
@@ -1385,8 +1387,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 
 		if (irec == NULL)  {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" in dir inode %llu "
-					"points to non-existent inode %llu"),
+			if (entry_junked(
+	_("entry \"%s\" in dir inode %" PRIu64 " points to non-existent inode %" PRIu64),
 					fname, ino, lino)) {
 				namest->name[0] = '/';
 				*dirty = 1;
@@ -1403,8 +1405,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		 */
 		if (is_inode_free(irec, ino_offset))  {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" in dir inode %llu "
-					"points to free inode %llu"),
+			if (entry_junked(
+	_("entry \"%s\" in dir inode %" PRIu64 " points to free inode %" PRIu64),
 					fname, ino, lino)) {
 				namest->name[0] = '/';
 				*dirty = 1;
@@ -1419,8 +1421,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 			 * trash it, otherwise, assign it */
 			if (!inode_isadir(irec, ino_offset)) {
 				nbad++;
-				if (entry_junked(_("%s (ino %llu) in root "
-						"(%llu) is not a directory"),
+				if (entry_junked(
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
 						ORPHANAGE, lino, ino)) {
 					namest->name[0] = '/';
 					*dirty = 1;
@@ -1441,8 +1443,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 					+ be16_to_cpu(entry->nameidx), lino,
 					entry->namelen, namest->name)) {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
-					"%llu is a duplicate name"),
+			if (entry_junked(
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 					fname, lino, ino)) {
 				namest->name[0] = '/';
 				*dirty = 1;
@@ -1472,8 +1474,8 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		 */
 		if (is_inode_reached(irec, ino_offset))  {
 			junkit = 1;
-			do_warn(_("entry \"%s\" in dir %llu points to an "
-				"already connected dir inode %llu,\n"),
+			do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " points to an already connected dir inode %" PRIu64 ",\n"),
 				fname, ino, lino);
 		} else if (parent == ino)  {
 			add_inode_reached(irec, ino_offset);
@@ -1481,16 +1483,16 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		} else if (parent == NULLFSINO) {
 			/* ".." was missing, but this entry refers to it,
 			   so, set it as the parent and mark for rebuild */
-			do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
-				" .. entry, will set it in ino %llu.\n"),
+			do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " doesn't have a .. entry, will set it in ino %" PRIu64 ".\n"),
 				fname, ino, lino);
 			set_inode_parent(irec, ino_offset, ino);
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
 		} else {
 			junkit = 1;
-			do_warn(_("entry \"%s\" in dir ino %llu not consistent"
-				" with .. value (%llu) in ino %llu,\n"),
+			do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " not consistent with .. value (%" PRIu64 ") in ino %" PRIu64 ",\n"),
 				fname, ino, parent, lino);
 		}
 
@@ -1551,7 +1553,8 @@ longform_dir_entry_check(xfs_mount_t	*mp
 	fsbno = map_first_dblock_fsbno(mp, ino, ip, &da_bno);
 
 	if (fsbno == NULLDFSBNO && no_modify)  {
-		do_warn(_("cannot map block 0 of directory inode %llu\n"), ino);
+		do_warn(
+	_("cannot map block 0 of directory inode %" PRIu64 "\n"), ino);
 		return;
 	}
 
@@ -1564,7 +1567,7 @@ longform_dir_entry_check(xfs_mount_t	*mp
 
 		if (!bp) {
 			do_error(
-	_("can't read block %u (fsbno %llu) for directory inode %llu\n"),
+	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
 					da_bno, fsbno, ino);
 			/* NOTREACHED */
 		}
@@ -1574,7 +1577,7 @@ longform_dir_entry_check(xfs_mount_t	*mp
 		if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR_LEAF_MAGIC) {
 			if (!no_modify)  {
 				do_error(
-_("bad magic # (0x%x) for dir ino %llu leaf block (bno %u fsbno %llu)\n"),
+_("bad magic # (0x%x) for dir ino %" PRIu64 " leaf block (bno %u fsbno %" PRIu64 ")\n"),
 					be16_to_cpu(leaf->hdr.info.magic),
 					ino, da_bno, fsbno);
 				/* NOTREACHED */
@@ -1611,11 +1614,11 @@ _("bad magic # (0x%x) for dir ino %llu l
 			if (error || nmap != 1)  {
 				if (!no_modify)
 					do_error(
-_("can't map leaf block %d in dir %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map leaf block %d in dir %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 						da_bno, ino, error, nmap);
 				else  {
 					do_warn(
-_("can't map leaf block %d in dir %llu, xfs_bmapi returns %d, nmap = %d\n"),
+_("can't map leaf block %d in dir %" PRIu64 ", xfs_bmapi returns %d, nmap = %d\n"),
 						da_bno, ino, error, nmap);
 					return;
 				}
@@ -1624,11 +1627,11 @@ _("can't map leaf block %d in dir %llu,
 			if (fsbno == HOLESTARTBLOCK)  {
 				if (!no_modify)
 					do_error(
-				_("block %d in %s ino %llu doesn't exist\n"),
+	_("block %d in %s ino %" PRIu64 " doesn't exist\n"),
 						da_bno, ftype, ino);
 				else  {
 					do_warn(
-				_("block %d in %s ino %llu doesn't exist\n"),
+	_("block %d in %s ino %" PRIu64 " doesn't exist\n"),
 						da_bno, ftype, ino);
 					return;
 				}
@@ -1667,7 +1670,7 @@ longform_dir2_rebuild(
 	 * name/inode pairs in the hash table
 	 */
 
-	do_warn(_("rebuilding directory inode %llu\n"), ino);
+	do_warn(_("rebuilding directory inode %" PRIu64 "\n"), ino);
 
 	/*
 	 * first attempt to locate the parent inode, if it can't be
@@ -1741,7 +1744,7 @@ longform_dir2_rebuild(
 						&firstblock, &flist, nres);
 		if (error) {
 			do_warn(
-_("name create failed in ino %llu (%d), filesystem may be out of space\n"),
+_("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
 				ino, error);
 			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 						XFS_TRANS_ABORT);
@@ -1806,7 +1809,7 @@ dir2_kill_block(
 		error = libxfs_dir2_shrink_inode(&args,
 				xfs_dir2_da_to_db(mp, da_bno), bp);
 	if (error)
-		do_error(_("shrink_inode failed inode %llu block %u\n"),
+		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
 			ip->i_ino, da_bno);
 	libxfs_bmap_finish(&tp, &flist, &committed);
 	libxfs_trans_commit(tp, 0);
@@ -1887,7 +1890,7 @@ longform_dir2_entry_check_data(
 		*freetabp = freetab = realloc(freetab, FREETAB_SIZE(db + 1));
 		if (!freetab) {
 			do_error(
-	_("realloc failed in longform_dir2_entry_check_data (%u bytes)\n"),
+	_("realloc failed in longform_dir2_entry_check_data (%zu bytes)\n"),
 				FREETAB_SIZE(db + 1));
 		}
 		e.v = NULLDATAOFF;
@@ -1944,10 +1947,11 @@ longform_dir2_entry_check_data(
 	if (ptr != endptr) {
 		if (junkit) {
 			do_warn(
-			_("empty data block %u in directory inode %llu: "),
+	_("empty data block %u in directory inode %" PRIu64 ": "),
 				da_bno, ip->i_ino);
 		} else {
-			do_warn(_("corrupt block %u in directory inode %llu: "),
+			do_warn(_
+	("corrupt block %u in directory inode %" PRIu64 ": "),
 				da_bno, ip->i_ino);
 		}
 		if (!no_modify) {
@@ -1977,8 +1981,8 @@ longform_dir2_entry_check_data(
 	libxfs_da_bhold(tp, bp);
 	xfs_bmap_init(&flist, &firstblock);
 	if (be32_to_cpu(d->hdr.magic) != wantmagic) {
-		do_warn(_("bad directory block magic # %#x for directory inode "
-			"%llu block %d: "),
+		do_warn(
+	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
 			be32_to_cpu(d->hdr.magic), ip->i_ino, da_bno);
 		if (!no_modify) {
 			do_warn(_("fixing magic # to %#x\n"), wantmagic);
@@ -2005,8 +2009,8 @@ longform_dir2_entry_check_data(
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
 			if (lastfree) {
-				do_warn(_("directory inode %llu block %u has "
-					  "consecutive free entries: "),
+				do_warn(
+	_("directory inode %" PRIu64 " block %u has consecutive free entries: "),
 					ip->i_ino, da_bno);
 				if (!no_modify) {
 					do_warn(_("joining together\n"));
@@ -2049,8 +2053,8 @@ longform_dir2_entry_check_data(
 					XFS_INO_TO_AGINO(mp, inum));
 		if (irec == NULL)  {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" in directory inode "
-					"%llu points to non-existent inode %llu"),
+			if (entry_junked(
+	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
 					fname, ip->i_ino, inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2066,8 +2070,8 @@ longform_dir2_entry_check_data(
 		 */
 		if (is_inode_free(irec, ino_offset))  {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" in directory inode "
-					"%llu points to free inode %llu"),
+			if (entry_junked(
+	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode " PRIu64),
 					fname, ip->i_ino, inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2084,8 +2088,8 @@ longform_dir2_entry_check_data(
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
 				nbad++;
-				if (entry_junked(_("%s (ino %llu) in root "
-						"(%llu) is not a directory"),
+				if (entry_junked(
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
 						ORPHANAGE, inum, ip->i_ino)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2105,8 +2109,8 @@ longform_dir2_entry_check_data(
 		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
 							dep->name)) {
 			nbad++;
-			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
-					"%llu is a duplicate name"),
+			if (entry_junked(
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 					fname, inum, ip->i_ino)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2136,9 +2140,8 @@ longform_dir2_entry_check_data(
 			if (da_bno != 0) {
 				/* ".." should be in the first block */
 				nbad++;
-				if (entry_junked(_("entry \"%s\" (ino %llu) "
-						"in dir %llu is not in the "
-						"the first block"), fname,
+				if (entry_junked(
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
 						inum, ip->i_ino)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2162,8 +2165,8 @@ longform_dir2_entry_check_data(
 			if (da_bno != 0 || dep != (xfs_dir2_data_entry_t *)d->u) {
 				/* "." should be the first entry */
 				nbad++;
-				if (entry_junked(_("entry \"%s\" in dir %llu is "
-						"not the first entry"),
+				if (entry_junked(
+	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
 						fname, inum, ip->i_ino)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(tp, bp, dep);
@@ -2198,7 +2201,7 @@ longform_dir2_entry_check_data(
 		if (is_inode_reached(irec, ino_offset))  {
 			junkit = 1;
 			do_warn(
-_("entry \"%s\" in dir %llu points to an already connected directory inode %llu\n"),
+_("entry \"%s\" in dir %" PRIu64" points to an already connected directory inode %" PRIu64 "\n"),
 				fname, ip->i_ino, inum);
 		} else if (parent == ip->i_ino)  {
 			add_inode_reached(irec, ino_offset);
@@ -2206,8 +2209,8 @@ _("entry \"%s\" in dir %llu points to an
 		} else if (parent == NULLFSINO) {
 			/* ".." was missing, but this entry refers to it,
 			   so, set it as the parent and mark for rebuild */
-			do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
-				" .. entry, will set it in ino %llu.\n"),
+			do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " doesn't have a .. entry, will set it in ino %" PRIu64 ".\n"),
 				fname, ip->i_ino, inum);
 			set_inode_parent(irec, ino_offset, ip->i_ino);
 			add_inode_reached(irec, ino_offset);
@@ -2217,7 +2220,7 @@ _("entry \"%s\" in dir %llu points to an
 		} else  {
 			junkit = 1;
 			do_warn(
-_("entry \"%s\" in dir inode %llu inconsistent with .. value (%llu) in ino %llu\n"),
+_("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 ") in ino %" PRIu64 "\n"),
 				fname, ip->i_ino, parent, inum);
 		}
 		if (junkit)  {
@@ -2270,7 +2273,8 @@ longform_dir2_check_leaf(
 
 	da_bno = mp->m_dirleafblk;
 	if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK)) {
-		do_error(_("can't read block %u for directory inode %llu\n"),
+		do_error(
+	_("can't read block %u for directory inode %" PRIu64 "\n"),
 			da_bno, ip->i_ino);
 		/* NOTREACHED */
 	}
@@ -2287,7 +2291,7 @@ longform_dir2_check_leaf(
 			    	(char *)&leaf->ents[be16_to_cpu(
 					leaf->hdr.count)] > (char *)bestsp) {
 		do_warn(
-		_("leaf block %u for directory inode %llu bad header\n"),
+	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 			da_bno, ip->i_ino);
 		libxfs_da_brelse(NULL, bp);
 		return 1;
@@ -2305,7 +2309,8 @@ longform_dir2_check_leaf(
 		badtail = freetab->ents[i].v != be16_to_cpu(bestsp[i]);
 	}
 	if (badtail) {
-		do_warn(_("leaf block %u for directory inode %llu bad tail\n"),
+		do_warn(
+	_("leaf block %u for directory inode %" PRIu64 " bad tail\n"),
 			da_bno, ip->i_ino);
 		libxfs_da_brelse(NULL, bp);
 		return 1;
@@ -2344,7 +2349,7 @@ longform_dir2_check_node(
 		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
 				XFS_DATA_FORK)) {
 			do_warn(
-			_("can't read leaf block %u for directory inode %llu\n"),
+	_("can't read leaf block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ip->i_ino);
 			return 1;
 		}
@@ -2355,8 +2360,8 @@ longform_dir2_check_node(
 				libxfs_da_brelse(NULL, bp);
 				continue;
 			}
-			do_warn(_("unknown magic number %#x for block %u in "
-				  "directory inode %llu\n"),
+			do_warn(
+	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
 				be16_to_cpu(leaf->hdr.info.magic),
 				da_bno, ip->i_ino);
 			libxfs_da_brelse(NULL, bp);
@@ -2365,8 +2370,8 @@ longform_dir2_check_node(
 		if (be16_to_cpu(leaf->hdr.count) > xfs_dir2_max_leaf_ents(mp) ||
 					be16_to_cpu(leaf->hdr.count) <
 						be16_to_cpu(leaf->hdr.stale)) {
-			do_warn(_("leaf block %u for directory inode %llu bad "
-				  "header\n"),
+			do_warn(
+	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
 			libxfs_da_brelse(NULL, bp);
 			return 1;
@@ -2390,7 +2395,7 @@ longform_dir2_check_node(
 		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bp,
 				XFS_DATA_FORK)) {
 			do_warn(
-		_("can't read freespace block %u for directory inode %llu\n"),
+	_("can't read freespace block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ip->i_ino);
 			return 1;
 		}
@@ -2402,8 +2407,8 @@ longform_dir2_check_node(
 						XFS_DIR2_MAX_FREE_BESTS(mp) ||
 				be32_to_cpu(free->hdr.nvalid) <
 					be32_to_cpu(free->hdr.nused)) {
-			do_warn(_("free block %u for directory inode %llu bad "
-				  "header\n"),
+			do_warn(
+	_("free block %u for directory inode %" PRIu64 " bad header\n"),
 				da_bno, ip->i_ino);
 			libxfs_da_brelse(NULL, bp);
 			return 1;
@@ -2415,7 +2420,7 @@ longform_dir2_check_node(
 						free->hdr.firstdb)].v !=
 			    			be16_to_cpu(free->bests[i])) {
 				do_warn(
-		_("free block %u entry %i for directory ino %llu bad\n"),
+	_("free block %u entry %i for directory ino %" PRIu64 " bad\n"),
 					da_bno, i, ip->i_ino);
 				libxfs_da_brelse(NULL, bp);
 				return 1;
@@ -2424,8 +2429,8 @@ longform_dir2_check_node(
 			freetab->ents[i + be32_to_cpu(free->hdr.firstdb)].s = 1;
 		}
 		if (used != be32_to_cpu(free->hdr.nused)) {
-			do_warn(_("free block %u for directory inode %llu bad "
-				  "nused\n"),
+			do_warn(
+	_("free block %u for directory inode %" PRIu64 " bad nused\n"),
 				da_bno, ip->i_ino);
 			libxfs_da_brelse(NULL, bp);
 			return 1;
@@ -2435,8 +2440,8 @@ longform_dir2_check_node(
 	for (i = 0; i < freetab->nents; i++) {
 		if ((freetab->ents[i].s == 0) &&
 		    (freetab->ents[i].v != NULLDATAOFF)) {
-			do_warn(_("missing freetab entry %u for "
-				  "directory inode %llu\n"),
+			do_warn(
+	_("missing freetab entry %u for directory inode %" PRIu64 "\n"),
 				i, ip->i_ino);
 			return 1;
 		}
@@ -2476,7 +2481,7 @@ longform_dir2_entry_check(xfs_mount_t	*m
 	freetab = malloc(FREETAB_SIZE(ip->i_d.di_size / mp->m_dirblksize));
 	if (!freetab) {
 		do_error(
-		_("malloc failed in longform_dir2_entry_check (%u bytes)\n"),
+		_("malloc failed in longform_dir2_entry_check (%" PRId64 " bytes)\n"),
 			FREETAB_SIZE(ip->i_d.di_size / mp->m_dirblksize));
 		exit(1);
 	}
@@ -2506,13 +2511,13 @@ longform_dir2_entry_check(xfs_mount_t	*m
 			bplist = realloc(bplist, num_bps * sizeof(xfs_dabuf_t*));
 			if (!bplist)
 				do_error(
-		_("realloc failed in longform_dir2_entry_check (%u bytes)\n"),
+		_("realloc failed in longform_dir2_entry_check (%zu bytes)\n"),
 					num_bps * sizeof(xfs_dabuf_t*));
 		}
 		if (libxfs_da_read_bufr(NULL, ip, da_bno, -1, &bplist[db],
 				XFS_DATA_FORK)) {
-			do_warn(_(
-			"can't read data block %u for directory inode %llu\n"),
+			do_warn(
+	_("can't read data block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			*num_illegal += 1;
 			continue;	/* try and read all "data" blocks */
@@ -2617,7 +2622,8 @@ shortform_dir_entry_check(xfs_mount_t	*m
 	sf_entry = next_sfe = &sf->list[0];
 	if (sf == NULL) {
 		junkit = 1;
-		do_warn(_("shortform dir inode %llu has null data entries \n"),
+		do_warn(
+	_("shortform dir inode %" PRIu64 " has null data entries \n"),
 			ino);
 
 		}
@@ -2684,8 +2690,8 @@ shortform_dir_entry_check(xfs_mount_t	*m
 		irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino));
 		if (irec == NULL) {
-			do_warn(_("entry \"%s\" in shortform dir %llu "
-				"references non-existent ino %llu"),
+			do_warn(
+	_("entry \"%s\" in shortform dir %" PRIu64 " references non-existent ino %" PRIu64 "\n"),
 				fname, ino, lino);
 			goto do_junkit;
 		}
@@ -2697,8 +2703,9 @@ shortform_dir_entry_check(xfs_mount_t	*m
 		 * really is free.
 		 */
 		if (!is_inode_free(irec, ino_offset))  {
-			do_warn(_("entry \"%s\" in shortform dir inode %llu "
-				"points to free inode %llu"), fname, ino, lino);
+			do_warn(
+	_("entry \"%s\" in shortform dir inode %" PRIu64 " points to free inode %" PRIu64"\n"),
+				fname, ino, lino);
 			goto do_junkit;
 		}
 		/*
@@ -2709,8 +2716,9 @@ shortform_dir_entry_check(xfs_mount_t	*m
 			 * if it's not a directory, trash it
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
-				do_warn(_("%s (ino %llu) in root (%llu) is not "
-					"a directory"), ORPHANAGE, lino, ino);
+				do_warn(
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
+					ORPHANAGE, lino, ino);
 				goto do_junkit;
 			}
 			/*
@@ -2750,8 +2758,8 @@ shortform_dir_entry_check(xfs_mount_t	*m
 			 */
 			if (is_inode_reached(irec, ino_offset))  {
 				junkit = 1;
-				do_warn(_("entry \"%s\" in dir %llu references "
-					"already connected dir ino %llu,\n"),
+				do_warn(
+	_("entry \"%s\" in dir %" PRIu64 " references already connected dir ino %" PRIu64 ".\n"),
 					fname, ino, lino);
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2759,17 +2767,16 @@ shortform_dir_entry_check(xfs_mount_t	*m
 			} else if (parent == NULLFSINO) {
 				/* ".." was missing, but this entry refers to it,
 				so, set it as the parent and mark for rebuild */
-				do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
-					" .. entry, will set it in ino %llu.\n"),
+				do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " doesn't have a .. entry, will set it in ino %" PRIu64 ".\n"),
 					fname, ino, lino);
 				set_inode_parent(irec, ino_offset, ino);
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
 			} else  {
 				junkit = 1;
-				do_warn(_("entry \"%s\" in dir %llu not "
-					"consistent with .. value (%llu) in "
-					"dir ino %llu"),
+				do_warn(
+	_("entry \"%s\" in dir %" PRIu64 " not consistent with .. value (%" PRIu64 ") in dir ino %" PRIu64".\n"),
 					fname, ino, parent, lino);
 			}
 		}
@@ -2813,7 +2820,7 @@ do_junkit:
 				else
 					do_warn("\n");
 			} else  {
-				do_warn(_("would junk entry\n"), fname);
+				do_warn(_("would junk entry\n"));
 			}
 		}
 
@@ -2852,7 +2859,7 @@ do_junkit:
 		ip->i_d.di_size = (xfs_fsize_t)
 				((__psint_t) next_sfe - (__psint_t) sf);
 		do_warn(
-		_("setting size to %lld bytes to reflect junked entries\n"),
+		_("setting size to %" PRId64 " bytes to reflect junked entries\n"),
 				ip->i_d.di_size);
 		*ino_dirty = 1;
 	}
@@ -2903,10 +2910,12 @@ shortform_dir2_entry_check(xfs_mount_t	*
 	if (dotdot_update) {
 		parent = get_inode_parent(current_irec, current_ino_offset);
 		if (no_modify) {
-			do_warn(_("would set .. in sf dir inode %llu to %llu\n"),
+			do_warn(
+	_("would set .. in sf dir inode %" PRIu64 " to %" PRIu64 "\n"),
 				ino, parent);
 		} else {
-			do_warn(_("setting .. in sf dir inode %llu to %llu\n"),
+			do_warn(
+	_("setting .. in sf dir inode %" PRIu64 " to %" PRIu64 "\n"),
 				ino, parent);
 			xfs_dir2_sf_put_inumber(sfp, &parent, &sfp->hdr.parent);
 			*ino_dirty = 1;
@@ -3009,8 +3018,8 @@ shortform_dir2_entry_check(xfs_mount_t	*
 					XFS_INO_TO_AGINO(mp, lino));
 
 		if (irec == NULL)  {
-			do_warn(_("entry \"%s\" in shortform directory %llu "
-				  "references non-existent inode %llu"),
+			do_warn(
+	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 "\n"),
 				fname, ino, lino);
 			goto do_junkit;
 		}
@@ -3023,8 +3032,8 @@ shortform_dir2_entry_check(xfs_mount_t	*
 		 * really is free.
 		 */
 		if (is_inode_free(irec, ino_offset))  {
-			do_warn(_("entry \"%s\" in shortform directory "
-				  "inode %llu points to free inode %llu"),
+			do_warn(
+	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 "\n"),
 				fname, ino, lino);
 			goto do_junkit;
 		}
@@ -3036,8 +3045,9 @@ shortform_dir2_entry_check(xfs_mount_t	*
 			 * if it's not a directory, trash it
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
-				do_warn(_("%s (ino %llu) in root (%llu) is not "
-					"a directory"), ORPHANAGE, lino, ino);
+				do_warn(
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
+					ORPHANAGE, lino, ino);
 				goto do_junkit;
 			}
 			/*
@@ -3074,9 +3084,9 @@ shortform_dir2_entry_check(xfs_mount_t	*
 			 */
 			if (is_inode_reached(irec, ino_offset))  {
 				junkit = 1;
-				do_warn(_("entry \"%s\" in directory inode %llu"
-					  " references already connected inode "
-					  "%llu,\n"),
+				do_warn(
+	_("entry \"%s\" in directory inode %" PRIu64
+	  " references already connected inode %" PRIu64 ".\n"),
 					fname, ino, lino);
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -3084,8 +3094,8 @@ shortform_dir2_entry_check(xfs_mount_t	*
 			} else if (parent == NULLFSINO) {
 				/* ".." was missing, but this entry refers to it,
 				so, set it as the parent and mark for rebuild */
-				do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
-					" .. entry, will set it in ino %llu.\n"),
+				do_warn(
+	_("entry \"%s\" in dir ino %" PRIu64 " doesn't have a .. entry, will set it in ino %" PRIu64 ".\n"),
 					fname, ino, lino);
 				set_inode_parent(irec, ino_offset, ino);
 				add_inode_reached(irec, ino_offset);
@@ -3094,9 +3104,10 @@ shortform_dir2_entry_check(xfs_mount_t	*
 							irec, ino_offset);
 			} else  {
 				junkit = 1;
-				do_warn(_("entry \"%s\" in directory inode %llu"
-					  " not consistent with .. value (%llu)"
-					  " in inode %llu,\n"),
+				do_warn(
+	_("entry \"%s\" in directory inode %" PRIu64
+	  " not consistent with .. value (%" PRIu64
+	  ") in inode %" PRIu64 ",\n"),
 					fname, ino, parent, lino);
 			}
 		}
@@ -3165,7 +3176,8 @@ do_junkit:
 
 	if (sfp->hdr.i8count != i8) {
 		if (no_modify) {
-			do_warn(_("would fix i8count in inode %llu\n"), ino);
+			do_warn(_("would fix i8count in inode %" PRIu64 "\n"),
+				ino);
 		} else {
 			if (i8 == 0) {
 				tmp_sfep = next_sfep;
@@ -3177,7 +3189,8 @@ do_junkit:
 			} else
 				sfp->hdr.i8count = i8;
 			*ino_dirty = 1;
-			do_warn(_("fixing i8count in inode %llu\n"), ino);
+			do_warn(_("fixing i8count in inode %" PRIu64 "\n"),
+				ino);
 		}
 	}
 
@@ -3196,8 +3209,8 @@ do_junkit:
 				((__psint_t) next_sfep - (__psint_t) sfp));
 		ip->i_d.di_size = (xfs_fsize_t)
 				((__psint_t) next_sfep - (__psint_t) sfp);
-		do_warn(_("setting size to %lld bytes to reflect junked "
-			  "entries\n"),
+		do_warn(
+	_("setting size to %" PRId64 " bytes to reflect junked entries\n"),
 			ip->i_d.di_size);
 		*ino_dirty = 1;
 	}
@@ -3235,10 +3248,12 @@ process_dir_inode(
 	error = libxfs_iget(mp, NULL, ino, 0, &ip, 0);
 	if (error) {
 		if (!no_modify)
-			do_error(_("couldn't map inode %llu, err = %d\n"),
+			do_error(
+	_("couldn't map inode %" PRIu64 ", err = %d\n"),
 				ino, error);
 		else  {
-			do_warn(_("couldn't map inode %llu, err = %d\n"),
+			do_warn(
+	_("couldn't map inode %" PRIu64 ", err = %d\n"),
 				ino, error);
 			/*
 			 * see below for what we're doing if this
@@ -3355,15 +3370,15 @@ process_dir_inode(
 		if (num_illegal > 0)  {
 			ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_LOCAL);
 
-			do_warn(_("%d bad entries found in dir inode %llu, "
-				"cannot fix in V1 dir filesystem\n"),
+			do_warn(
+	_("%d bad entries found in dir inode %" PRIu64 ", cannot fix in V1 dir filesystem\n"),
 				num_illegal, ino);
 		}
 		if (need_dot) {
 			add_inode_ref(irec, ino_offset);
 
-			do_warn(_("missing \".\" entry in dir ino %llu, "
-				"cannot in fix V1 dir filesystem\n"), ino);
+			do_warn(
+	_("missing \".\" entry in dir ino %" PRIu64 ", cannot in fix V1 dir filesystem\n"), ino);
 		}
 		goto out;
 	}
@@ -3400,8 +3415,8 @@ process_dir_inode(
 		error = libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
 					ip->i_ino, &first, &flist, nres);
 		if (error)
-			do_error(_("can't make \"..\" entry in root inode "
-				"%llu, createname error %d\n"), ino, error);
+			do_error(
+	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
 
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
@@ -3435,14 +3450,15 @@ process_dir_inode(
 		add_inode_ref(irec, ino_offset);
 
 		if (no_modify)  {
-			do_warn(_("would create missing \".\" entry in dir ino %llu\n"),
+			do_warn(
+	_("would create missing \".\" entry in dir ino %" PRIu64 "\n"),
 				ino);
 		} else if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)  {
 			/*
 			 * need to create . entry in longform dir.
 			 */
-			do_warn(_("creating missing \".\" entry in dir ino %llu\n"),
-				ino);
+			do_warn(
+	_("creating missing \".\" entry in dir ino %" PRIu64 "\n"), ino);
 
 			tp = libxfs_trans_alloc(mp, 0);
 			ASSERT(tp != NULL);
@@ -3465,8 +3481,8 @@ process_dir_inode(
 			error = libxfs_dir_createname(tp, ip, &xfs_name_dot,
 					ip->i_ino, &first, &flist, nres);
 			if (error)
-				do_error(_("can't make \".\" entry in dir ino "
-					"%llu, createname error %d\n"),
+				do_error(
+	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
 					ino, error);
 
 			libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -3555,9 +3571,9 @@ check_for_orphaned_inodes(
 
 		ino = XFS_AGINO_TO_INO(mp, agno, i + irec->ino_startnum);
 		if (inode_isadir(irec, i))
-			do_warn(_("disconnected dir inode %llu, "), ino);
+			do_warn(_("disconnected dir inode %" PRIu64 ", "), ino);
 		else
-			do_warn(_("disconnected inode %llu, "), ino);
+			do_warn(_("disconnected inode %" PRIu64 ", "), ino);
 		if (!xfs_sb_version_hasdirv2(&mp->m_sb)) 
 			do_warn(_("cannot fix in V1 dir filesystem\n"));
 		else if (!no_modify)  {
Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2011-08-02 03:57:26.143020810 -0700
+++ xfsprogs-dev/repair/scan.c	2011-08-14 09:58:49.015938757 -0700
@@ -196,15 +196,16 @@ scanfunc_bmap(
 	 * highly unlikely.
 	 */
 	if (be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) {
-		do_warn(_("bad magic # %#x in inode %llu (%s fork) bmbt "
-			"block %llu\n"), be32_to_cpu(block->bb_magic),
-			ino, forkname, bno);
+		do_warn(
+_("bad magic # %#x in inode %" PRIu64 " (%s fork) bmbt block %" PRIu64 "\n"),
+			be32_to_cpu(block->bb_magic), ino, forkname, bno);
 		return(1);
 	}
 	if (be16_to_cpu(block->bb_level) != level) {
-		do_warn(_("expected level %d got %d in inode %llu, (%s fork) "
-			"bmbt block %llu\n"), level,
-			be16_to_cpu(block->bb_level), ino, forkname, bno);
+		do_warn(
+_("expected level %d got %d in inode %" PRIu64 ", (%s fork) bmbt block %" PRIu64 "\n"),
+			level, be16_to_cpu(block->bb_level),
+			ino, forkname, bno);
 		return(1);
 	}
 
@@ -222,8 +223,8 @@ scanfunc_bmap(
 			 */
 			if (bno != bm_cursor->level[level].right_fsbno)  {
 				do_warn(
-_("bad fwd (right) sibling pointer (saw %llu parent block says %llu)\n"
-  "\tin inode %llu (%s fork) bmap btree block %llu\n"),
+_("bad fwd (right) sibling pointer (saw %" PRIu64 " parent block says %" PRIu64 ")\n"
+  "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
 					bm_cursor->level[level].right_fsbno,
 					bno, ino, forkname,
 					bm_cursor->level[level].fsbno);
@@ -232,8 +233,8 @@ _("bad fwd (right) sibling pointer (saw
 			if (be64_to_cpu(block->bb_u.l.bb_leftsib) !=
 					bm_cursor->level[level].fsbno)  {
 				do_warn(
-_("bad back (left) sibling pointer (saw %llu parent block says %llu)\n"
-  "\tin inode %llu (%s fork) bmap btree block %llu\n"),
+_("bad back (left) sibling pointer (saw %llu parent block says %" PRIu64 ")\n"
+  "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
 					be64_to_cpu(block->bb_u.l.bb_leftsib),
 					bm_cursor->level[level].fsbno,
 					ino, forkname, bno);
@@ -247,7 +248,7 @@ _("bad back (left) sibling pointer (saw
 			if (be64_to_cpu(block->bb_u.l.bb_leftsib) != NULLDFSBNO) {
 				do_warn(
 _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
-  "\tin inode %llu (%s fork) bmap btree block %llu\n"),
+  "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
 					be64_to_cpu(block->bb_u.l.bb_leftsib),
 					ino, forkname, bno);
 				return(1);
@@ -286,15 +287,15 @@ _("bad back (left) sibling pointer (saw
 			 */
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-		_("inode 0x%llx bmap block 0x%llx claimed, state is %d\n"),
-				ino, (__uint64_t) bno, state);
+_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+				ino, bno, state);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE_FS:
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-		_("inode 0x%llx bmap block 0x%llx claimed, state is %d\n"),
-				ino, (__uint64_t) bno, state);
+_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+				ino, bno, state);
 			/*
 			 * if we made it to here, this is probably a bmap block
 			 * that is being used by *another* file as a bmap block
@@ -308,8 +309,8 @@ _("bad back (left) sibling pointer (saw
 		case XR_E_BAD_STATE:
 		default:
 			do_warn(
-		_("bad state %d, inode 0x%llx bmap block 0x%llx\n"),
-				state, ino, (__uint64_t) bno);
+_("bad state %d, inode 0x%" PRIu64 " bmap block 0x%" PRIu64 "\n"),
+				state, ino, bno);
 			break;
 		}
 		pthread_mutex_unlock(&ag_locks[agno]);
@@ -335,7 +336,7 @@ _("bad back (left) sibling pointer (saw
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-	_("inode 0x%llx bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode 0x%" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);
@@ -365,7 +366,7 @@ _("bad back (left) sibling pointer (saw
 					bm_cursor->level[level].last_key !=
 					NULLDFILOFF)  {
 				do_warn(
-_("out-of-order bmap key (file offset) in inode %llu, %s fork, fsbno %llu\n"),
+_("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" PRIu64 "\n"),
 					ino, forkname, bno);
 				return(1);
 			}
@@ -385,7 +386,7 @@ _("out-of-order bmap key (file offset) i
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[1])) {
 		do_warn(
-	_("inode 0x%llx bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode 0x%" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmnr[1], mp->m_bmap_dmxr[1]);
 		return(1);
 	}
@@ -401,7 +402,8 @@ _("out-of-order bmap key (file offset) i
 		 * we'll bail out and presumably clear the inode.
 		 */
 		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
-			do_warn(_("bad bmap btree ptr 0x%llx in ino %llu\n"),
+			do_warn(
+_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 				be64_to_cpu(pp[i]), ino);
 			return(1);
 		}
@@ -428,8 +430,8 @@ _("out-of-order bmap key (file offset) i
 					bm_cursor->level[level-1].first_key)  {
 			if (!no_modify)  {
 				do_warn(
-		_("correcting bt key (was %llu, now %llu) in inode %llu\n"
-		  "\t\t%s fork, btree block %llu\n"),
+_("correcting bt key (was %llu, now %" PRIu64 ") in inode %" PRIu64 "\n"
+  "\t\t%s fork, btree block %" PRIu64 "\n"),
 					be64_to_cpu(pkey[i].br_startoff),
 					bm_cursor->level[level-1].first_key,
 					ino,
@@ -439,8 +441,8 @@ _("out-of-order bmap key (file offset) i
 					bm_cursor->level[level-1].first_key);
 			} else  {
 				do_warn(
-	_("bad btree key (is %llu, should be %llu) in inode %llu\n"
-	  "\t\t%s fork, btree block %llu\n"),
+_("bad btree key (is %llu, should be %" PRIu64 ") in inode %" PRIu64 "\n"
+  "\t\t%s fork, btree block %" PRIu64 "\n"),
 					be64_to_cpu(pkey[i].br_startoff),
 					bm_cursor->level[level-1].first_key,
 					ino, forkname, bno);
@@ -456,8 +458,8 @@ _("out-of-order bmap key (file offset) i
 			bm_cursor->level[level].right_fsbno == NULLDFSBNO &&
 			bm_cursor->level[level - 1].right_fsbno != NULLDFSBNO) {
 		do_warn(
-	_("bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"
-	  "\tin inode %llu (%s fork) bmap btree block %llu\n"),
+_("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLDFSBNO)\n"
+  "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
 			bm_cursor->level[level - 1].right_fsbno,
 			ino, forkname, bm_cursor->level[level - 1].fsbno);
 		return(1);
@@ -600,13 +602,13 @@ _("%s freespace btree block claimed (sta
 
 			if (b == 0 || !verify_agbno(mp, agno, b)) {
 				do_warn(
-	_("invalid start block %u in record %u of %d btree block %u/%u\n"),
+	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
 			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
 				do_warn(
-	_("invalid length %u in record %u of %d btree block %u/%u\n"),
+	_("invalid length %u in record %u of %s btree block %u/%u\n"),
 					len, i, name, agno, bno);
 				continue;
 			}
@@ -748,7 +750,7 @@ scan_single_ino_chunk(
 	     off % XFS_INODES_PER_CHUNK != 0) ||
 	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0))  {
 		do_warn(
-	_("badly aligned inode rec (starting inode = %llu)\n"),
+	_("badly aligned inode rec (starting inode = %" PRIu64 ")\n"),
 			lino);
 		suspect++;
 	}
@@ -764,7 +766,7 @@ scan_single_ino_chunk(
 	 */
 	if (verify_aginum(mp, agno, ino))  {
 		do_warn(
-_("bad starting inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
+_("bad starting inode # (%" PRIu64 " (0x%x 0x%x)) in ino rec, skipping rec\n"),
 			lino, agno, ino);
 		return ++suspect;
 	}
@@ -772,9 +774,10 @@ _("bad starting inode # (%llu (0x%x 0x%x
 	if (verify_aginum(mp, agno,
 			ino + XFS_INODES_PER_CHUNK - 1))  {
 		do_warn(
-_("bad ending inode # (%llu (0x%x 0x%x)) in ino rec, skipping rec\n"),
+_("bad ending inode # (%" PRIu64 " (0x%x 0x%zx)) in ino rec, skipping rec\n"),
 			lino + XFS_INODES_PER_CHUNK - 1,
-			agno, ino + XFS_INODES_PER_CHUNK - 1);
+			agno,
+			ino + XFS_INODES_PER_CHUNK - 1);
 		return ++suspect;
 	}
 
@@ -818,7 +821,7 @@ _("inode chunk claims used block, inobt
 		 * already in the tree
 		 */
 		do_warn(
-_("inode rec for ino %llu (%d/%d) overlaps existing rec (start %d/%d)\n"),
+_("inode rec for ino %" PRIu64 " (%d/%d) overlaps existing rec (start %d/%d)\n"),
 			lino, agno, ino, agno, first_rec->ino_startnum);
 		suspect++;
 
@@ -866,7 +869,7 @@ _("inode rec for ino %llu (%d/%d) overla
 
 	if (nfree != be32_to_cpu(rp->ir_freecount)) {
 		do_warn(_("ir_freecount/free mismatch, inode "
-			"chunk %d/%d, freecount %d nfree %d\n"),
+			"chunk %d/%u, freecount %d nfree %d\n"),
 			agno, ino, be32_to_cpu(rp->ir_freecount), nfree);
 	}
 
@@ -1124,7 +1127,7 @@ validate_agf(
 
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
 	    be32_to_cpu(agf->agf_btreeblks) != agcnts->agfbtreeblks) {
-		do_warn(_("agf_btreeblks %u, counted %u in ag %u\n"),
+		do_warn(_("agf_btreeblks %u, counted %" PRIu64 " in ag %u\n"),
 			be32_to_cpu(agf->agf_btreeblks), agcnts->agfbtreeblks, agno);
 	}
 }
@@ -1162,7 +1165,7 @@ validate_agi(
 
 		if (agino != NULLAGINO) {
 			do_warn(
-	_("agi unlinked bucket %d is %u in ag %u (inode=%lld)\n"),
+	_("agi unlinked bucket %d is %u in ag %u (inode=%" PRIu64 ")\n"),
 				i, agino, agno,
 				XFS_AGINO_TO_INO(mp, agno, agino));
 		}
@@ -1355,17 +1358,17 @@ scan_ags(
 	 * Validate that our manual counts match the superblock.
 	 */
 	if (mp->m_sb.sb_icount != icount) {
-		do_warn(_("sb_icount %lld, counted %lld\n"),
+		do_warn(_("sb_icount %" PRIu64 ", counted %" PRIu64 "\n"),
 			mp->m_sb.sb_icount, icount);
 	}
 
 	if (mp->m_sb.sb_ifree != ifreecount) {
-		do_warn(_("sb_ifree %lld, counted %lld\n"),
+		do_warn(_("sb_ifree %" PRIu64 ", counted %" PRIu64 "\n"),
 			mp->m_sb.sb_ifree, ifreecount);
 	}
 
 	if (mp->m_sb.sb_fdblocks != fdblocks) {
-		do_warn(_("sb_fdblocks %lld, counted %lld\n"),
+		do_warn(_("sb_fdblocks %" PRIu64 ", counted %" PRIu64 "\n"),
 			mp->m_sb.sb_fdblocks, fdblocks);
 	}
 }
Index: xfsprogs-dev/repair/phase4.c
===================================================================
--- xfsprogs-dev.orig/repair/phase4.c	2011-08-02 03:57:26.156354070 -0700
+++ xfsprogs-dev/repair/phase4.c	2011-08-14 09:58:49.015938757 -0700
@@ -267,7 +267,8 @@ phase4(xfs_mount_t *mp)
 		switch (bstate)  {
 		case XR_E_BAD_STATE:
 		default:
-			do_warn(_("unknown rt extent state, extent %llu\n"),
+			do_warn(
+	_("unknown rt extent state, extent %" PRIu64 "\n"),
 				bno);
 			/* fall through .. */
 		case XR_E_UNKNOWN:
Index: xfsprogs-dev/repair/dir.c
===================================================================
--- xfsprogs-dev.orig/repair/dir.c	2011-08-02 03:57:26.166354016 -0700
+++ xfsprogs-dev/repair/dir.c	2011-08-14 09:58:49.019272072 -0700
@@ -150,27 +150,27 @@ process_shortform_dir(
 			 * junk the entry, mark lino as NULL since it's bad
 			 */
 			do_warn(
-	_("invalid inode number %llu in directory %llu\n"), lino, ino);
+	_("invalid inode number %" PRIu64 " in directory %" PRIu64 "\n"), lino, ino);
 			lino = NULLFSINO;
 			junkit = 1;
 		} else if (lino == mp->m_sb.sb_rbmino)  {
 			do_warn(
-	_("entry in shortform dir %llu references rt bitmap inode %llu\n"),
+	_("entry in shortform dir %" PRIu64 " references rt bitmap inode %" PRIu64 "\n"),
 				ino, lino);
 			junkit = 1;
 		} else if (lino == mp->m_sb.sb_rsumino)  {
 			do_warn(
-	_("entry in shortform dir %llu references rt summary inode %llu\n"),
+	_("entry in shortform dir %" PRIu64 " references rt summary inode %" PRIu64 "\n"),
 				ino, lino);
 			junkit = 1;
 		} else if (lino == mp->m_sb.sb_uquotino)  {
 			do_warn(
-	_("entry in shortform dir %llu references user quota inode %llu\n"),
+	_("entry in shortform dir %" PRIu64 " references user quota inode %" PRIu64 "\n"),
 				ino, lino);
 			junkit = 1;
 		} else if (lino == mp->m_sb.sb_gquotino)  {
 			do_warn(
-	_("entry in shortform dir %llu references group quota inode %llu\n"),
+	_("entry in shortform dir %" PRIu64 " references group quota inode %" PRIu64 "\n"),
 				ino, lino);
 			junkit = 1;
 		} else if ((irec_p = find_inode_rec(mp,
@@ -191,7 +191,7 @@ process_shortform_dir(
 
 			if (!ino_discovery && is_inode_free(irec_p, ino_off))  {
 				do_warn(
-	_("entry references free inode %llu in shortform directory %llu\n"),
+	_("entry references free inode %" PRIu64 " in shortform directory %" PRIu64 "\n"),
 					lino, ino);
 				junkit = 1;
 			}
@@ -210,7 +210,7 @@ process_shortform_dir(
 			 * phase) so this is clearly a bogus entry.
 			 */
 			do_warn(
-	_("entry references non-existent inode %llu in shortform dir %llu\n"),
+	_("entry references non-existent inode %" PRIu64 " in shortform dir %" PRIu64 "\n"),
 					lino, ino);
 			junkit = 1;
 		}
@@ -234,17 +234,17 @@ process_shortform_dir(
 					 (__psint_t) sf);
 				if (!no_modify)  {
 					do_warn(
-		_("zero length entry in shortform dir %llu, resetting to %d\n"),
+		_("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
 						ino, namelen);
 					sf_entry->namelen = namelen;
 				} else  {
 					do_warn(
-		_("zero length entry in shortform dir %llu, would set to %d\n"),
+		_("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),
 						ino, namelen);
 				}
 			} else  {
 				do_warn(
-		_("zero length entry in shortform dir %llu, "),
+		_("zero length entry in shortform dir %" PRIu64 ", "),
 					ino);
 				if (!no_modify)
 					do_warn(_("junking %d entries\n"),
@@ -268,7 +268,7 @@ process_shortform_dir(
 					((__psint_t) &sf_entry->name[0] -
 					 (__psint_t) sf);
 				do_warn(
-	_("size of last entry overflows space left in in shortform dir %llu, "),
+	_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);
 				if (!no_modify)  {
 					do_warn(_("resetting to %d\n"),
@@ -281,7 +281,7 @@ process_shortform_dir(
 				}
 			} else  {
 				do_warn(
-	_("size of entry #%d overflows space left in in shortform dir %llu\n"),
+	_("size of entry #%d overflows space left in in shortform dir %" PRIu64 "\n"),
 					i, ino);
 				if (!no_modify)  {
 					if (i == num_entries - 1)
@@ -318,7 +318,7 @@ process_shortform_dir(
 			 * junk entry
 			 */
 			do_warn(
-		_("entry contains illegal character in shortform dir %llu\n"),
+		_("entry contains illegal character in shortform dir %" PRIu64 "\n"),
 				ino);
 			junkit = 1;
 		}
@@ -372,11 +372,11 @@ process_shortform_dir(
 				*repair = 1;
 
 				do_warn(
-		_("junking entry \"%s\" in directory inode %llu\n"),
+		_("junking entry \"%s\" in directory inode %" PRIu64 "\n"),
 					name, ino);
 			} else  {
 				do_warn(
-		_("would have junked entry \"%s\" in directory inode %llu\n"),
+		_("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 					name, ino);
 			}
 		}
@@ -402,11 +402,11 @@ process_shortform_dir(
 	if (sf->hdr.count != i)  {
 		if (no_modify)  {
 			do_warn(
-	_("would have corrected entry count in directory %llu from %d to %d\n"),
+	_("would have corrected entry count in directory %" PRIu64 " from %d to %d\n"),
 			ino, sf->hdr.count, i);
 		} else  {
 			do_warn(
-	_("corrected entry count in directory %llu, was %d, now %d\n"),
+	_("corrected entry count in directory %" PRIu64 ", was %d, now %d\n"),
 			ino, sf->hdr.count, i);
 			sf->hdr.count = i;
 			*dino_dirty = 1;
@@ -417,14 +417,14 @@ process_shortform_dir(
 	if ((__psint_t) next_sfe - (__psint_t) sf != ino_dir_size)  {
 		if (no_modify)  {
 			do_warn(
-	_("would have corrected directory %llu size from %lld to %lld\n"),
-				ino, (__int64_t) ino_dir_size,
-			(__int64_t)((__psint_t) next_sfe - (__psint_t) sf));
+	_("would have corrected directory %" PRIu64 " size from %" PRId64 "to %" PRIdPTR "\n"),
+				ino, ino_dir_size,
+				(intptr_t)next_sfe - (intptr_t )sf);
 		} else  {
 			do_warn(
-	_("corrected directory %llu size, was %lld, now %lld\n"),
-				ino, (__int64_t) ino_dir_size,
-			(__int64_t)((__psint_t) next_sfe - (__psint_t) sf));
+	_("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
+				ino, ino_dir_size,
+				(intptr_t)next_sfe - (intptr_t)sf);
 
 			dip->di_size = cpu_to_be64((__psint_t)next_sfe 
 							- (__psint_t)sf);
@@ -444,7 +444,7 @@ process_shortform_dir(
 		*parent = NULLFSINO;
 
 		do_warn(
-	_("bogus .. inode number (%llu) in directory inode %llu, "),
+	_("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 				*parent, ino);
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
@@ -461,7 +461,7 @@ process_shortform_dir(
 		 */
 		if (!no_modify)  {
 			do_warn(
-	_("corrected root directory %llu .. entry, was %llu, now %llu\n"),
+	_("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64 "\n"),
 				ino, *parent, ino);
 			*parent = ino;
 			xfs_dir_sf_put_dirino(parent, &sf->hdr.parent);
@@ -469,7 +469,7 @@ process_shortform_dir(
 			*repair = 1;
 		} else  {
 			do_warn(
-	_("would have corrected root directory %llu .. entry from %llu to %llu\n"),
+	_("would have corrected root directory %" PRIu64 " .. entry from %" PRIu64 " to %" PRIu64 "\n"),
 				ino, *parent, ino);
 		}
 	} else if (ino == *parent && ino != mp->m_sb.sb_rootino)  {
@@ -478,7 +478,7 @@ process_shortform_dir(
 		 * to .
 		 */
 		*parent = NULLFSINO;
-		do_warn(_("bad .. entry in dir ino %llu, points to self, "),
+		do_warn(_("bad .. entry in dir ino %" PRIu64 ", points to self, "),
 			ino);
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
@@ -570,7 +570,7 @@ verify_da_freemap(xfs_mount_t *mp, da_fr
 		if (start >= mp->m_sb.sb_blocksize ||
 				start + len > mp->m_sb.sb_blocksize)  {
 			do_warn(
-	_("hole (start %d, len %d) out of range, block %d, dir ino %llu\n"),
+	_("hole (start %d, len %d) out of range, block %d, dir ino %" PRIu64 "\n"),
 				start, len, da_bno, ino);
 			return(1);
 		}
@@ -581,7 +581,7 @@ verify_da_freemap(xfs_mount_t *mp, da_fr
 				 * bad news -- hole claims a used byte is free
 				 */
 				do_warn(
-			_("hole claims used byte %d, block %d, dir ino %llu\n"),
+			_("hole claims used byte %d, block %d, dir ino %" PRIu64 "\n"),
 					j, da_bno, ino);
 				return(1);
 			}
@@ -696,7 +696,7 @@ compare_da_freemaps(xfs_mount_t *mp, da_
 	if ((holemap->lost_holes > 0 ? 1 : 0) != block_hmap->lost_holes)  {
 		if (verbose)  {
 			do_warn(
-		_("- derived hole value %d, saw %d, block %d, dir ino %llu\n"),
+		_("- derived hole value %d, saw %d, block %d, dir ino %" PRIu64 "\n"),
 				holemap->lost_holes, block_hmap->lost_holes,
 				da_bno, ino);
 			res = 1;
@@ -715,7 +715,7 @@ compare_da_freemaps(xfs_mount_t *mp, da_
 		if (!found)  {
 			if (verbose)  {
 				do_warn(
-_("- derived hole (base %d, size %d) in block %d, dir inode %llu not found\n"),
+_("- derived hole (base %d, size %d) in block %d, dir inode %" PRIu64 " not found\n"),
 					holemap->hentries[i].base,
 					holemap->hentries[i].size,
 					da_bno, ino);
@@ -791,12 +791,12 @@ traverse_int_dablock(xfs_mount_t	*mp,
 				XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
 			if (whichfork == XFS_DATA_FORK)
-				do_warn(_("can't read block %u (fsbno %llu) "
-					"for directory inode %llu\n"),
+				do_warn(
+	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
 					bno, fsbno, da_cursor->ino);
 			else
-				do_warn(_("can't read block %u (fsbno %llu) "
-					"for attrbute fork of inode %llu\n"),
+				do_warn(
+	_("can't read block %u (fsbno %" PRIu64 ") for attrbute fork of inode %" PRIu64 "\n"),
 					bno, fsbno, da_cursor->ino);
 			goto error_out;
 		}
@@ -804,15 +804,15 @@ traverse_int_dablock(xfs_mount_t	*mp,
 		node = (xfs_da_intnode_t *)XFS_BUF_PTR(bp);
 
 		if (be16_to_cpu(node->hdr.info.magic) != XFS_DA_NODE_MAGIC)  {
-			do_warn(_("bad dir/attr magic number in inode %llu, "
-				  "file bno = %u, fsbno = %llu\n"),
+			do_warn(_("bad dir/attr magic number in inode %" PRIu64 ", "
+				  "file bno = %u, fsbno = %" PRIu64 "\n"),
 				da_cursor->ino, bno, fsbno);
 			libxfs_putbuf(bp);
 			goto error_out;
 		}
 		if (be16_to_cpu(node->hdr.count) >
 						mp->m_dir_node_ents)  {
-			do_warn(_("bad record count in inode %llu, "
+			do_warn(_("bad record count in inode %" PRIu64 ", "
 				  "count = %d, max = %d\n"),
 				da_cursor->ino,
 				be16_to_cpu(node->hdr.count),
@@ -832,11 +832,11 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			} else  {
 				if (whichfork == XFS_DATA_FORK)
 					do_warn(_("bad directory btree for "
-						  "directory inode %llu\n"),
+						  "directory inode %" PRIu64 "\n"),
 						da_cursor->ino);
 				else
 					do_warn(_("bad attribute fork btree "
-						  "for inode %llu\n"),
+						  "for inode %" PRIu64 "\n"),
 						da_cursor->ino);
 				libxfs_putbuf(bp);
 				goto error_out;
@@ -950,7 +950,7 @@ get_first_dblock_fsbno(xfs_mount_t	*mp,
 	fsbno = get_bmapi(mp, dino, ino, bno, XFS_DATA_FORK);
 
 	if (fsbno == NULLDFSBNO)  {
-		do_warn(_("bmap of block #%u of inode %llu failed\n"),
+		do_warn(_("bmap of block #%u of inode %" PRIu64 " failed\n"),
 			bno, ino);
 		return(fsbno);
 	}
@@ -969,8 +969,8 @@ get_first_dblock_fsbno(xfs_mount_t	*mp,
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
-			do_warn(_("can't read block %u (fsbno %llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("can't read block %u (fsbno %" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				bno, fsbno, ino);
 			return(NULLDFSBNO);
 		}
@@ -979,8 +979,8 @@ get_first_dblock_fsbno(xfs_mount_t	*mp,
 
 		if (XFS_DA_NODE_MAGIC !=
 		    be16_to_cpu(node->hdr.info.magic))  {
-			do_warn(_("bad dir/attr magic number in inode %llu, "
-				  "file bno = %u, fsbno = %llu\n"),
+			do_warn(
+	_("bad dir/attr magic number in inode %" PRIu64 ", file bno = %u, fsbno = %" PRIu64 "\n"),
 				ino, bno, fsbno);
 			libxfs_putbuf(bp);
 			return(NULLDFSBNO);
@@ -995,7 +995,7 @@ get_first_dblock_fsbno(xfs_mount_t	*mp,
 		fsbno = get_bmapi(mp, dino, ino, bno, XFS_DATA_FORK);
 
 		if (fsbno == NULLDFSBNO)  {
-			do_warn(_("bmap of block #%u of inode %llu failed\n"),
+			do_warn(_("bmap of block #%u of inode %" PRIu64 " failed\n"),
 				bno, ino);
 			return(NULLDFSBNO);
 		}
@@ -1064,7 +1064,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 		bad++;
 	}
 	if (bad) {
-		do_warn(_("bad directory block in dir ino %llu\n"),
+		do_warn(_("bad directory block in dir ino %" PRIu64 "\n"),
 			cursor->ino);
 		return(1);
 	}
@@ -1096,7 +1096,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 		if (!no_modify)  {
 			do_warn(_("correcting bad hashval in non-leaf "
 				  "dir/attr block\n\tin (level %d) in "
-				  "inode %llu.\n"),
+				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 			node->btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
@@ -1104,7 +1104,7 @@ verify_final_da_path(xfs_mount_t	*mp,
 		} else  {
 			do_warn(_("would correct bad hashval in non-leaf "
 				  "dir/attr block\n\tin (level %d) in "
-				  "inode %llu.\n"),
+				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 		}
 	}
@@ -1241,7 +1241,7 @@ verify_da_path(xfs_mount_t	*mp,
 
 		if (fsbno == NULLDFSBNO) {
 			do_warn(_("can't get map info for block %u "
-				  "of directory inode %llu\n"),
+				  "of directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			return(1);
 		}
@@ -1249,8 +1249,8 @@ verify_da_path(xfs_mount_t	*mp,
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
-			do_warn(_("can't read block %u (%llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("can't read block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				dabno, fsbno, cursor->ino);
 			return(1);
 		}
@@ -1262,29 +1262,29 @@ verify_da_path(xfs_mount_t	*mp,
 		 */
 		bad = 0;
 		if (XFS_DA_NODE_MAGIC != be16_to_cpu(newnode->hdr.info.magic)) {
-			do_warn(_("bad magic number %x in block %u (%llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("bad magic number %x in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.info.magic),
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
 		if (be32_to_cpu(newnode->hdr.info.back) != 
 						cursor->level[this_level].bno) {
-			do_warn(_("bad back pointer in block %u (%llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("bad back pointer in block %u (%"PRIu64 ") for directory inode %" PRIu64 "\n"),
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
 		if (be16_to_cpu(newnode->hdr.count) > mp->m_dir_node_ents) {
-			do_warn(_("entry count %d too large in block %u (%llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("entry count %d too large in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.count),
 				dabno, fsbno, cursor->ino);
 			bad++;
 		}
 		if (be16_to_cpu(newnode->hdr.level) != this_level) {
-			do_warn(_("bad level %d in block %u (%llu) "
-				  "for directory inode %llu\n"),
+			do_warn(
+	_("bad level %d in block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.level),
 				dabno, fsbno, cursor->ino);
 			bad++;
@@ -1343,7 +1343,7 @@ verify_da_path(xfs_mount_t	*mp,
 		if (!no_modify)  {
 			do_warn(_("correcting bad hashval in interior "
 				  "dir/attr block\n\tin (level %d) in "
-				  "inode %llu.\n"),
+				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 			node->btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
@@ -1351,7 +1351,7 @@ verify_da_path(xfs_mount_t	*mp,
 		} else  {
 			do_warn(_("would correct bad hashval in interior "
 				  "dir/attr block\n\tin (level %d) in "
-				  "inode %llu.\n"),
+				  "inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 		}
 	}
@@ -1444,7 +1444,7 @@ process_leaf_dir_block(
 	unsigned char			*dir_freemap = ts_dir_freemap();
 
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "\tprocess_leaf_dir_block - ino %llu\n", ino);
+	fprintf(stderr, "\tprocess_leaf_dir_block - ino %" PRIu64 "\n", ino);
 #endif
 
 	/*
@@ -1460,7 +1460,7 @@ process_leaf_dir_block(
 	i = stop = sizeof(xfs_dir_leaf_hdr_t);
 	if (set_da_freemap(mp, dir_freemap, 0, stop))  {
 		do_warn(
-_("directory block header conflicts with used space in directory inode %llu\n"),
+_("directory block header conflicts with used space in directory inode %" PRIu64 "\n"),
 			ino);
 		return(1);
 	}
@@ -1489,7 +1489,7 @@ _("directory block header conflicts with
 
 				if (be16_to_cpu(leaf->hdr.count) > 1)  {
 					do_warn(
-_("nameidx %d for entry #%d, bno %d, ino %llu > fs blocksize, deleting entry\n"),
+_("nameidx %d for entry #%d, bno %d, ino %" PRIu64 " > fs blocksize, deleting entry\n"),
 						be16_to_cpu(entry->nameidx),
 						i, da_bno, ino);
 					ASSERT(be16_to_cpu(leaf->hdr.count) > i);
@@ -1526,7 +1526,7 @@ _("nameidx %d for entry #%d, bno %d, ino
 					entry--;
 				} else  {
 					do_warn(
-_("nameidx %d, entry #%d, bno %d, ino %llu > fs blocksize, marking entry bad\n"),
+_("nameidx %d, entry #%d, bno %d, ino %" PRIu64 " > fs blocksize, marking entry bad\n"),
 						be16_to_cpu(entry->nameidx),
 						i, da_bno, ino);
 					entry->nameidx = cpu_to_be16(
@@ -1541,7 +1541,7 @@ _("nameidx %d, entry #%d, bno %d, ino %l
 				}
 			} else  {
 				do_warn(
-_("nameidx %d, entry #%d, bno %d, ino %llu > fs blocksize, would delete entry\n"),
+_("nameidx %d, entry #%d, bno %d, ino %" PRIu64 " > fs blocksize, would delete entry\n"),
 					be16_to_cpu(entry->nameidx),
 					i, da_bno, ino);
 			}
@@ -1578,7 +1578,7 @@ _("nameidx %d, entry #%d, bno %d, ino %l
 			 * since it's still structurally intact.
 			 */
 			do_warn(
-	_("invalid ino number %llu in dir ino %llu, entry #%d, bno %d\n"),
+_("invalid ino number %" PRIu64 " in dir ino %" PRIu64 ", entry #%d, bno %d\n"),
 				lino, ino, i, da_bno);
 			if (!no_modify)  {
 				do_warn(
@@ -1594,7 +1594,7 @@ _("nameidx %d, entry #%d, bno %d, ino %l
 			}
 		} else if (lino == mp->m_sb.sb_rbmino)  {
 			do_warn(
-_("entry #%d, bno %d in directory %llu references realtime bitmap inode %llu\n"),
+_("entry #%d, bno %d in directory %" PRIu64 " references realtime bitmap inode %" PRIu64 "\n"),
 				i, da_bno, ino, lino);
 			if (!no_modify)  {
 				do_warn(
@@ -1611,7 +1611,7 @@ _("entry #%d, bno %d in directory %llu r
 			}
 		} else if (lino == mp->m_sb.sb_rsumino)  {
 			do_warn(
-_("entry #%d, bno %d in directory %llu references realtime summary inode %llu\n"),
+_("entry #%d, bno %d in directory %" PRIu64 " references realtime summary inode %" PRIu64 "\n"),
 				i, da_bno, ino, lino);
 			if (!no_modify)  {
 				do_warn(
@@ -1627,7 +1627,7 @@ _("entry #%d, bno %d in directory %llu r
 			}
 		} else if (lino == mp->m_sb.sb_uquotino)  {
 			do_warn(
-_("entry #%d, bno %d in directory %llu references user quota inode %llu\n"),
+_("entry #%d, bno %d in directory %" PRIu64 " references user quota inode %" PRIu64 "\n"),
 				i, da_bno, ino, lino);
 			if (!no_modify)  {
 				do_warn(
@@ -1644,7 +1644,7 @@ _("entry #%d, bno %d in directory %llu r
 			}
 		} else if (lino == mp->m_sb.sb_gquotino)  {
 			do_warn(
-_("entry #%d, bno %d in directory %llu references group quota inode %llu\n"),
+_("entry #%d, bno %d in directory %" PRIu64 " references group quota inode %" PRIu64 "\n"),
 				i, da_bno, ino, lino);
 			if (!no_modify)  {
 				do_warn(
@@ -1681,7 +1681,7 @@ _("entry #%d, bno %d in directory %llu r
 			if (!ino_discovery && is_inode_free(irec_p, ino_off))  {
 				if (!no_modify)  {
 					do_warn(
-_("entry references free inode %llu in directory %llu, will clear entry\n"),
+_("entry references free inode %" PRIu64 " in directory %" PRIu64 ", will clear entry\n"),
 						lino, ino);
 					lino = NULLFSINO;
 					xfs_dir_sf_put_dirino(&lino,
@@ -1689,7 +1689,7 @@ _("entry references free inode %llu in d
 					*buf_dirty = 1;
 				} else  {
 					do_warn(
-_("entry references free inode %llu in directory %llu, would clear entry\n"),
+_("entry references free inode %" PRIu64 " in directory %" PRIu64 ", would clear entry\n"),
 						lino, ino);
 				}
 			}
@@ -1697,7 +1697,7 @@ _("entry references free inode %llu in d
 			add_inode_uncertain(mp, lino, 0);
 		} else  {
 			do_warn(
-	_("bad ino number %llu in dir ino %llu, entry #%d, bno %d\n"),
+	_("bad ino number %" PRIu64 " in dir ino %" PRIu64 ", entry #%d, bno %d\n"),
 				lino, ino, i, da_bno);
 			if (!no_modify)  {
 				do_warn(_("clearing inode number...\n"));
@@ -1725,7 +1725,7 @@ _("entry references free inode %llu in d
 
 			if (be16_to_cpu(leaf->hdr.count) > 1)  {
 				do_warn(
-	_("entry #%d, dir inode %llu, has zero-len name, deleting entry\n"),
+	_("entry #%d, dir inode %" PRIu64 ", has zero-len name, deleting entry\n"),
 					i, ino);
 				ASSERT(be16_to_cpu(leaf->hdr.count) > i);
 
@@ -1763,7 +1763,7 @@ _("entry references free inode %llu in d
 				 * inode number for now
 				 */
 				do_warn(
-	_("entry #%d, dir inode %llu, has zero-len name, marking entry bad\n"),
+	_("entry #%d, dir inode %" PRIu64 ", has zero-len name, marking entry bad\n"),
 					i, ino);
 				entry->nameidx = cpu_to_be16(
 						mp->m_sb.sb_blocksize -
@@ -1776,7 +1776,7 @@ _("entry references free inode %llu in d
 		} else if (be16_to_cpu(entry->nameidx) + entry->namelen > 
 							XFS_LBSIZE(mp))  {
 			do_warn(
-_("bad size, entry #%d in dir inode %llu, block %u -- entry overflows block\n"),
+_("bad size, entry #%d in dir inode %" PRIu64 ", block %u -- entry overflows block\n"),
 				i, ino, da_bno);
 
 			return(1);
@@ -1787,7 +1787,7 @@ _("bad size, entry #%d in dir inode %llu
 
 		if (set_da_freemap(mp, dir_freemap, start, stop))  {
 			do_warn(
-_("dir entry slot %d in block %u conflicts with used space in dir inode %llu\n"),
+_("dir entry slot %d in block %u conflicts with used space in dir inode %" PRIu64 "\n"),
 				i, da_bno, ino);
 			return(1);
 		}
@@ -1826,13 +1826,13 @@ _("dir entry slot %d in block %u conflic
 			 */
 			if (!no_modify)  {
 				do_warn(
-_("illegal name \"%s\" in directory inode %llu, entry will be cleared\n"),
+_("illegal name \"%s\" in directory inode %" PRIu64 ", entry will be cleared\n"),
 					fname, ino);
 				namest->name[0] = '/';
 				*buf_dirty = 1;
 			} else  {
 				do_warn(
-_("illegal name \"%s\" in directory inode %llu, entry would be cleared\n"),
+_("illegal name \"%s\" in directory inode %" PRIu64 ", entry would be cleared\n"),
 					fname, ino);
 			}
 		} else if (!nm_illegal &&
@@ -1846,13 +1846,13 @@ _("illegal name \"%s\" in directory inod
 				fname);
 			if (!no_modify)  {
 				do_warn(
-		_("\t\tin directory inode %llu.  resetting hash value.\n"),
+		_("\t\tin directory inode %" PRIu64 ".  resetting hash value.\n"),
 					ino);
 				entry->hashval = cpu_to_be32(hashval);
 				*buf_dirty = 1;
 			} else  {
 				do_warn(
-		_("\t\tin directory inode %llu.  would reset hash value.\n"),
+		_("\t\tin directory inode %" PRIu64 ".  would reset hash value.\n"),
 					ino);
 			}
 		}
@@ -1886,14 +1886,14 @@ _("illegal name \"%s\" in directory inod
 				fname);
 			if (!no_modify)  {
 				do_warn(
-			_("\t\tin directory inode %llu.  will clear entry\n"),
+			_("\t\tin directory inode %" PRIu64 ".  will clear entry\n"),
 					ino);
 				entry->hashval = cpu_to_be32(last_hashval);
 				namest->name[0] = '/';
 				*buf_dirty = 1;
 			} else  {
 				do_warn(
-			_("\t\tin directory inode %llu.  would clear entry\n"),
+			_("\t\tin directory inode %" PRIu64 ".  would clear entry\n"),
 					ino);
 			}
 		}
@@ -1909,18 +1909,18 @@ _("illegal name \"%s\" in directory inod
 					+ sizeof(xfs_dir_leaf_name_t)
 					+ entry->namelen - 1))  {
 			do_warn(
-_("name \"%s\" (block %u, slot %d) conflicts with used space in dir inode %llu\n"),
+_("name \"%s\" (block %u, slot %d) conflicts with used space in dir inode %" PRIu64 "\n"),
 				fname, da_bno, i, ino);
 			if (!no_modify)  {
 				entry->namelen = 0;
 				*buf_dirty = 1;
 
 				do_warn(
-		_("will clear entry \"%s\" (#%d) in directory inode %llu\n"),
+		_("will clear entry \"%s\" (#%d) in directory inode %" PRIu64 "\n"),
 					fname, i, ino);
 			} else  {
 				do_warn(
-		_("would clear entry \"%s\" (#%d)in directory inode %llu\n"),
+		_("would clear entry \"%s\" (#%d)in directory inode %" PRIu64 "\n"),
 					fname, i, ino);
 			}
 			continue;
@@ -1945,7 +1945,7 @@ _("name \"%s\" (block %u, slot %d) confl
 				(*dotdot)++;
 				*parent = lino;
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "process_leaf_dir_block found .. entry (parent) = %llu\n", lino);
+	fprintf(stderr, "process_leaf_dir_block found .. entry (parent) = %" PRIu64 "\n", lino);
 #endif
 				/*
 				 * what if .. == .?  legal only in
@@ -1956,7 +1956,7 @@ _("name \"%s\" (block %u, slot %d) confl
 						ino != mp->m_sb.sb_rootino)  {
 					*parent = NULLFSINO;
 					do_warn(
-			_("bad .. entry in dir ino %llu, points to self"),
+			_("bad .. entry in dir ino %" PRIu64 ", points to self"),
 						ino);
 					if (!no_modify)  {
 						do_warn(
@@ -1975,14 +1975,14 @@ _("name \"%s\" (block %u, slot %d) confl
 					 */
 					if (!no_modify)  {
 						do_warn(
-		_("correcting .. entry in root inode %llu, was %llu\n"),
+		_("correcting .. entry in root inode %" PRIu64 ", was %" PRIu64 "\n"),
 							ino, *parent);
 						xfs_dir_sf_put_dirino(
 							&ino, &namest->inumber);
 						*buf_dirty = 1;
 					} else  {
 						do_warn(
-		_("bad .. entry (%llu) in root inode %llu should be %llu\n"),
+		_("bad .. entry (%" PRIu64 ") in root inode %" PRIu64 " should be %" PRIu64 "\n"),
 							*parent,
 							ino, ino);
 					}
@@ -1999,13 +1999,13 @@ _("name \"%s\" (block %u, slot %d) confl
 				 */
 				if (!no_modify)  {
 					do_warn(
-_("multiple .. entries in directory inode %llu, will clear second entry\n"),
+_("multiple .. entries in directory inode %" PRIu64 ", will clear second entry\n"),
 						ino);
 					namest->name[0] = '/';
 					*buf_dirty = 1;
 				} else  {
 					do_warn(
-_("multiple .. entries in directory inode %llu, would clear second entry\n"),
+_("multiple .. entries in directory inode %" PRIu64 ", would clear second entry\n"),
 						ino);
 				}
 			}
@@ -2018,33 +2018,33 @@ _("multiple .. entries in directory inod
 				if (lino != ino)  {
 					if (!no_modify)  {
 						do_warn(
-_(". in directory inode %llu has wrong value (%llu), fixing entry...\n"),
+_(". in directory inode %" PRIu64 " has wrong value (%" PRIu64 "), fixing entry...\n"),
 							ino, lino);
 						xfs_dir_sf_put_dirino(&ino,
 							&namest->inumber);
 						*buf_dirty = 1;
 					} else  {
 						do_warn(
-			_(". in directory inode %llu has wrong value (%llu)\n"),
+_(". in directory inode %" PRIu64 " has wrong value (%" PRIu64 ")\n"),
 							ino, lino);
 					}
 				}
 			} else  {
 				do_warn(
-			_("multiple . entries in directory inode %llu\n"),
+_("multiple . entries in directory inode %" PRIu64 "\n"),
 					ino);
 				/*
 				 * mark entry as to be junked.
 				 */
 				if (!no_modify)  {
 					do_warn(
-			_("will clear one . entry in directory inode %llu\n"),
+_("will clear one . entry in directory inode %" PRIu64 "\n"),
 						ino);
 					namest->name[0] = '/';
 					*buf_dirty = 1;
 				} else  {
 					do_warn(
-			_("would clear one . entry in directory inode %llu\n"),
+_("would clear one . entry in directory inode %" PRIu64 "\n"),
 						ino);
 				}
 			}
@@ -2054,7 +2054,7 @@ _(". in directory inode %llu has wrong v
 			 */
 			if (lino == ino)  {
 				do_warn(
-		_("entry \"%s\" in directory inode %llu points to self, "),
+		_("entry \"%s\" in directory inode %" PRIu64 " points to self, "),
 					fname, ino);
 				if (!no_modify)  {
 					do_warn(_("will clear entry\n"));
@@ -2079,7 +2079,7 @@ _(". in directory inode %llu has wrong v
 		if (!no_modify)  {
 			if (verbose)
 				do_warn(
-_("- resetting first used heap value from %d to %d in block %u of dir ino %llu\n"),
+_("- resetting first used heap value from %d to %d in block %u of dir ino %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.firstused),
 					first_used, da_bno, ino);
 			leaf->hdr.firstused = cpu_to_be16(first_used);
@@ -2087,7 +2087,7 @@ _("- resetting first used heap value fro
 		} else  {
 			if (verbose)
 				do_warn(
-_("- would reset first used value from %d to %d in block %u of dir ino %llu\n"),
+_("- would reset first used value from %d to %d in block %u of dir ino %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.firstused),
 					first_used, da_bno, ino);
 		}
@@ -2097,7 +2097,7 @@ _("- would reset first used value from %
 		if (!no_modify)  {
 			if (verbose)
 				do_warn(
-_("- resetting namebytes cnt from %d to %d in block %u of dir inode %llu\n"),
+_("- resetting namebytes cnt from %d to %d in block %u of dir inode %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.namebytes),
 					bytes_used, da_bno, ino);
 			leaf->hdr.namebytes = cpu_to_be16(bytes_used);
@@ -2105,7 +2105,7 @@ _("- resetting namebytes cnt from %d to
 		} else  {
 			if (verbose)
 				do_warn(
-_("- would reset namebytes cnt from %d to %d in block %u of dir inode %llu\n"),
+_("- would reset namebytes cnt from %d to %d in block %u of dir inode %" PRIu64 "\n"),
 					be16_to_cpu(leaf->hdr.namebytes),
 					bytes_used, da_bno, ino);
 		}
@@ -2140,7 +2140,7 @@ _("- would reset namebytes cnt from %d t
 		if (holemap.lost_holes > 0)  {
 			if (verbose)
 				do_warn(
-	_("- found unexpected lost holes in block %u, dir inode %llu\n"),
+	_("- found unexpected lost holes in block %u, dir inode %" PRIu64 "\n"),
 					da_bno, ino);
 
 			reset_holes = 1;
@@ -2148,14 +2148,14 @@ _("- would reset namebytes cnt from %d t
 				XFS_DIR_LEAF_MAPSIZE, ino, da_bno))  {
 			if (verbose)
 				do_warn(
-		_("- hole info non-optimal in block %u, dir inode %llu\n"),
+		_("- hole info non-optimal in block %u, dir inode %" PRIu64 "\n"),
 					da_bno, ino);
 			reset_holes = 1;
 		}
 	} else if (verify_da_freemap(mp, dir_freemap, &holemap, ino, da_bno))  {
 		if (verbose)
 			do_warn(
-		_("- hole info incorrect in block %u, dir inode %llu\n"),
+		_("- hole info incorrect in block %u, dir inode %" PRIu64 "\n"),
 				da_bno, ino);
 		reset_holes = 1;
 	}
@@ -2166,7 +2166,7 @@ _("- would reset namebytes cnt from %d t
 		 */
 		if (verbose)  {
 			do_warn(
-_("- existing hole info for block %d, dir inode %llu (base, size) - \n"),
+_("- existing hole info for block %d, dir inode %" PRIu64 " (base, size) - \n"),
 				da_bno, ino);
 			do_warn("- \t");
 			for (i = 0; i < XFS_DIR_LEAF_MAPSIZE; i++)  {
@@ -2180,7 +2180,7 @@ _("- existing hole info for block %d, di
 		if (!no_modify)  {
 			if (verbose)
 				do_warn(
-			_("- compacting block %u in dir inode %llu\n"),
+			_("- compacting block %u in dir inode %" PRIu64 "\n"),
 					da_bno, ino);
 
 			new_leaf = (xfs_dir_leafblock_t *) ts_dirbuf();
@@ -2221,7 +2221,7 @@ _("- existing hole info for block %d, di
 						sizeof(xfs_dir_leaf_entry_t)
 						+ (__psint_t) d_entry)  {
 					do_warn(
-	_("not enough space in block %u of dir inode %llu for all entries\n"),
+	_("not enough space in block %u of dir inode %" PRIu64 " for all entries\n"),
 						da_bno, ino);
 					break;
 				}
@@ -2289,7 +2289,7 @@ _("- existing hole info for block %d, di
 		} else  {
 			if (verbose)
 				do_warn(
-			_("- would compact block %u in dir inode %llu\n"),
+			_("- would compact block %u in dir inode %" PRIu64 "\n"),
 					da_bno, ino);
 		}
 	}
@@ -2333,7 +2333,7 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 	xfs_dahash_t		greatest_hashval;
 
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "process_leaf_dir_level - ino %llu\n", da_cursor->ino);
+	fprintf(stderr, "process_leaf_dir_level - ino %" PRIu64 "\n", da_cursor->ino);
 #endif
 	*repair = 0;
 	da_bno = da_cursor->level[0].bno;
@@ -2351,7 +2351,7 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 
 		if (dev_bno == NULLDFSBNO) {
 			do_warn(
-			_("can't map block %u for directory inode %llu\n"),
+			_("can't map block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
@@ -2362,9 +2362,9 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 					XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
 			do_warn(
-			_("can't read file block %u (fsbno %llu, daddr %lld) "
-			  "for directory inode %llu\n"),
-				da_bno, dev_bno, (__int64_t) bd_addr, ino);
+	_("can't read file block %u (fsbno %" PRIu64 ", daddr %" PRId64 ") "
+	  "for directory inode %" PRIu64 "\n"),
+				da_bno, dev_bno, bd_addr, ino);
 			goto error_out;
 		}
 
@@ -2376,7 +2376,7 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 		if (XFS_DIR_LEAF_MAGIC !=
 		    be16_to_cpu(leaf->hdr.info.magic)) {
 			do_warn(
-			_("bad directory leaf magic # %#x for dir ino %llu\n"),
+	_("bad directory leaf magic # %#x for dir ino %" PRIu64"\n"),
 				be16_to_cpu(leaf->hdr.info.magic),
 				ino);
 			libxfs_putbuf(bp);
@@ -2415,8 +2415,8 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 		da_cursor->level[0].dirty = buf_dirty;
 
 		if (be32_to_cpu(leaf->hdr.info.back) != prev_bno)  {
-			do_warn(_("bad sibling back pointer for directory "
-				  "block %u in directory inode %llu\n"),
+			do_warn(
+	_("bad sibling back pointer for directory block %u in directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			libxfs_putbuf(bp);
 			goto error_out;
@@ -2447,7 +2447,7 @@ process_leaf_dir_level(xfs_mount_t	*mp,
 		/*
 		 * verify the final path up (right-hand-side) if still ok
 		 */
-		do_warn(_("bad hash path in directory %llu\n"), da_cursor->ino);
+		do_warn(_("bad hash path in directory %" PRIu64 "\n"), da_cursor->ino);
 		goto error_out;
 	}
 
@@ -2508,7 +2508,7 @@ process_node_dir(
 	da_bt_cursor_t			da_cursor;
 
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "process_node_dir - ino %llu\n", ino);
+	fprintf(stderr, "process_node_dir - ino %" PRIu64 "\n", ino);
 #endif
 	*repair = *dot = *dotdot = 0;
 	*parent = NULLFSINO;
@@ -2557,16 +2557,16 @@ process_node_dir(
 		if ((xfs_fsize_t) da_cursor.greatest_bno
 				* mp->m_sb.sb_blocksize > UINT_MAX)  {
 			do_warn(
-	_("out of range internal directory block numbers (inode %llu)\n"),
+_("out of range internal directory block numbers (inode %" PRIu64 ")\n"),
 				ino);
 			return(1);
 		}
 
 		do_warn(
-_("setting directory inode (%llu) size to %llu bytes, was %lld bytes\n"),
+_("setting directory inode (%" PRIu64 ") size to %" PRIu64 " bytes, was %" PRId64 " bytes\n"),
 			ino, (xfs_dfiloff_t) (da_cursor.greatest_bno + 1)
 				* mp->m_sb.sb_blocksize,
-			be64_to_cpu(dip->di_size));
+			(__int64_t)be64_to_cpu(dip->di_size));
 
 		dip->di_size = cpu_to_be64((da_cursor.greatest_bno + 1) 
 						* mp->m_sb.sb_blocksize);
@@ -2610,21 +2610,21 @@ process_leaf_dir(
 	int		buf_dirty = 0;
 
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "process_leaf_dir - ino %llu\n", ino);
+	fprintf(stderr, "process_leaf_dir - ino %" PRIu64 "\n", ino);
 #endif
 	*repair = *dot = *dotdot = 0;
 	*parent = NULLFSINO;
 
 	bno = blkmap_get(blkmap, 0);
 	if (bno == NULLDFSBNO) {
-		do_warn(_("block 0 for directory inode %llu is missing\n"),
+		do_warn(_("block 0 for directory inode %" PRIu64 " is missing\n"),
 			ino);
 		return(1);
 	}
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 			XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp) {
-		do_warn(_("can't read block 0 for directory inode %llu\n"),
+		do_warn(_("can't read block 0 for directory inode %" PRIu64 "\n"),
 			ino);
 		return(1);
 	}
@@ -2637,7 +2637,7 @@ process_leaf_dir(
 	 * check magic number for leaf directory btree block
 	 */
 	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_DIR_LEAF_MAGIC) {
-		do_warn(_("bad directory leaf magic # %#x for dir ino %llu\n"),
+		do_warn(_("bad directory leaf magic # %#x for dir ino %" PRIu64 "\n"),
 			be16_to_cpu(leaf->hdr.info.magic), ino);
 		libxfs_putbuf(bp);
 		return(1);
@@ -2661,13 +2661,13 @@ process_leaf_dir(
 	if (leaf->hdr.info.forw || leaf->hdr.info.back)  {
 		if (!no_modify)  {
 			do_warn(_("clearing forw/back pointers for "
-				  "directory inode %llu\n"), ino);
+				  "directory inode %" PRIu64 "\n"), ino);
 			buf_dirty = 1;
 			leaf->hdr.info.forw = 0;
 			leaf->hdr.info.back = 0;
 		} else  {
 			do_warn(_("would clear forw/back pointers for "
-				  "directory inode %llu\n"), ino);
+				  "directory inode %" PRIu64 "\n"), ino);
 		}
 	}
 
@@ -2731,7 +2731,7 @@ process_dir(
 	 * bad . entries in all directories will be fixed up in phase 6
 	 */
 	if (dot == 0) 
-		do_warn(_("no . entry for directory %llu\n"), ino);
+		do_warn(_("no . entry for directory %" PRIu64 "\n"), ino);
 
 	/*
 	 * shortform dirs always have a .. entry.  .. for all longform
@@ -2740,14 +2740,14 @@ process_dir(
 	 * fixed in place since we know what it should be
 	 */
 	if (dotdot == 0 && ino != mp->m_sb.sb_rootino) {
-		do_warn(_("no .. entry for directory %llu\n"), ino);
+		do_warn(_("no .. entry for directory %" PRIu64 "\n"), ino);
 	} else if (dotdot == 0 && ino == mp->m_sb.sb_rootino) {
-		do_warn(_("no .. entry for root directory %llu\n"), ino);
+		do_warn(_("no .. entry for root directory %" PRIu64 "\n"), ino);
 		need_root_dotdot = 1;
 	}
 
 #ifdef XR_DIR_TRACE
-	fprintf(stderr, "(process_dir), parent of %llu is %llu\n", ino, parent);
+	fprintf(stderr, "(process_dir), parent of %" PRIu64 " is %" PRIu64 "\n", ino, parent);
 #endif
 	return(res);
 }
Index: xfsprogs-dev/repair/dir2.c
===================================================================
--- xfsprogs-dev.orig/repair/dir2.c	2011-08-02 03:57:26.176353963 -0700
+++ xfsprogs-dev/repair/dir2.c	2011-08-14 09:58:49.022605387 -0700
@@ -53,7 +53,7 @@ dir2_add_badlist(
 
 	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
 		do_error(
-		_("malloc failed (%u bytes) dir2_add_badlist:ino %llu\n"),
+_("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
 			sizeof(dir2_bad_t), ino);
 		exit(1);
 	}
@@ -300,8 +300,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		if (bmp != &lbmp)
 			free(bmp);
 		if (bp == NULL) {
-			do_warn(_("can't read block %u for directory inode "
-				  "%llu\n"),
+			do_warn(
+_("can't read block %u for directory inode %" PRIu64 "\n"),
 				bno, da_cursor->ino);
 			goto error_out;
 		}
@@ -310,8 +310,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 
 		if (be16_to_cpu(info->magic) == XFS_DIR2_LEAFN_MAGIC)  {
 			if ( i != -1 ) {
-				do_warn(_("found non-root LEAFN node in inode "
-					  "%llu bno = %u\n"),
+				do_warn(
+_("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
 					da_cursor->ino, bno);
 			}
 			*rbno = 0;
@@ -319,8 +319,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 			return(1);
 		} else if (be16_to_cpu(info->magic) != XFS_DA_NODE_MAGIC)  {
 			da_brelse(bp);
-			do_warn(_("bad dir magic number 0x%x in inode %llu "
-				  "bno = %u\n"),
+			do_warn(
+_("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 				be16_to_cpu(info->magic),
 					da_cursor->ino, bno);
 			goto error_out;
@@ -328,8 +328,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		node = (xfs_da_intnode_t*)info;
 		if (be16_to_cpu(node->hdr.count) > mp->m_dir_node_ents)  {
 			da_brelse(bp);
-			do_warn(_("bad record count in inode %llu, count = %d, "
-				  "max = %d\n"), da_cursor->ino,
+			do_warn(
+_("bad record count in inode %" PRIu64 ", count = %d, max = %d\n"), da_cursor->ino,
 				be16_to_cpu(node->hdr.count),
 				mp->m_dir_node_ents);
 			goto error_out;
@@ -340,8 +340,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		if (i == -1) {
 			i = da_cursor->active = be16_to_cpu(node->hdr.level);
 			if (i >= XFS_DA_NODE_MAXDEPTH) {
-				do_warn(_("bad header depth for directory "
-					  "inode %llu\n"),
+				do_warn(
+_("bad header depth for directory inode %" PRIu64 "\n"),
 					da_cursor->ino);
 				da_brelse(bp);
 				i = -1;
@@ -351,8 +351,8 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 			if (be16_to_cpu(node->hdr.level) == i - 1)  {
 				i--;
 			} else  {
-				do_warn(_("bad directory btree for directory "
-					  "inode %llu\n"),
+				do_warn(
+_("bad directory btree for directory inode %" PRIu64 "\n"),
 					da_cursor->ino);
 				da_brelse(bp);
 				goto error_out;
@@ -487,7 +487,7 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 		bad++;
 	}
 	if (bad)  {
-		do_warn(_("bad directory block in inode %llu\n"), cursor->ino);
+		do_warn(_("bad directory block in inode %" PRIu64 "\n"), cursor->ino);
 		return(1);
 	}
 	/*
@@ -507,15 +507,17 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 	if (cursor->level[p_level].hashval !=
 				be32_to_cpu(node->btree[entry].hashval))  {
 		if (!no_modify)  {
-			do_warn(_("correcting bad hashval in non-leaf dir "
-				  "block\n\tin (level %d) in inode %llu.\n"),
+			do_warn(
+_("correcting bad hashval in non-leaf dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 			node->btree[entry].hashval = cpu_to_be32(
 						cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
-			do_warn(_("would correct bad hashval in non-leaf dir "
-				  "block\n\tin (level %d) in inode %llu.\n"),
+			do_warn(
+_("would correct bad hashval in non-leaf dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 		}
 	}
@@ -645,8 +647,8 @@ verify_dir2_path(xfs_mount_t	*mp,
 		nex = blkmap_getn(cursor->blkmap, dabno, mp->m_dirblkfsbs,
 			&bmp, &lbmp);
 		if (nex == 0) {
-			do_warn(_("can't get map info for block %u of "
-				  "directory inode %llu\n"),
+			do_warn(
+_("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			return(1);
 		}
@@ -656,8 +658,8 @@ verify_dir2_path(xfs_mount_t	*mp,
 			free(bmp);
 
 		if (bp == NULL) {
-			do_warn(_("can't read block %u for directory inode "
-				  "%llu\n"),
+			do_warn(
+_("can't read block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			return(1);
 		}
@@ -669,29 +671,29 @@ verify_dir2_path(xfs_mount_t	*mp,
 		 */
 		bad = 0;
 		if (XFS_DA_NODE_MAGIC != be16_to_cpu(newnode->hdr.info.magic)) {
-			do_warn(_("bad magic number %x in block %u for "
-				  "directory inode %llu\n"),
+			do_warn(
+_("bad magic number %x in block %u for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.info.magic),
 				dabno, cursor->ino);
 			bad++;
 		}
 		if (be32_to_cpu(newnode->hdr.info.back) !=
 					cursor->level[this_level].bno)  {
-			do_warn(_("bad back pointer in block %u for directory "
-				  "inode %llu\n"),
+			do_warn(
+_("bad back pointer in block %u for directory inode %" PRIu64 "\n"),
 				dabno, cursor->ino);
 			bad++;
 		}
 		if (be16_to_cpu(newnode->hdr.count) > mp->m_dir_node_ents)  {
-			do_warn(_("entry count %d too large in block %u for "
-				  "directory inode %llu\n"),
+			do_warn(
+_("entry count %d too large in block %u for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.count),
 				dabno, cursor->ino);
 			bad++;
 		}
 		if (be16_to_cpu(newnode->hdr.level) != this_level)  {
-			do_warn(_("bad level %d in block %u for directory "
-				  "inode %llu\n"),
+			do_warn(
+_("bad level %d in block %u for directory inode %" PRIu64 "\n"),
 				be16_to_cpu(newnode->hdr.level),
 				dabno, cursor->ino);
 			bad++;
@@ -733,15 +735,17 @@ verify_dir2_path(xfs_mount_t	*mp,
 	if (cursor->level[p_level].hashval !=
 				be32_to_cpu(node->btree[entry].hashval))  {
 		if (!no_modify)  {
-			do_warn(_("correcting bad hashval in interior dir "
-				  "block\n\tin (level %d) in inode %llu.\n"),
+			do_warn(
+_("correcting bad hashval in interior dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 			node->btree[entry].hashval = cpu_to_be32(
 					cursor->level[p_level].hashval);
 			cursor->level[this_level].dirty++;
 		} else  {
-			do_warn(_("would correct bad hashval in interior dir "
-				  "block\n\tin (level %d) in inode %llu.\n"),
+			do_warn(
+_("would correct bad hashval in interior dir block\n"
+  "\tin (level %d) in inode %" PRIu64 ".\n"),
 				this_level, cursor->ino);
 		}
 	}
@@ -966,8 +970,8 @@ process_sf_dir2(
 		}
 		namelen = sfep->namelen;
 		if (junkit)
-			do_warn(_("entry \"%*.*s\" in shortform directory %llu "
-				  "references %s inode %llu\n"),
+			do_warn(
+_("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRIu64 "\n"),
 				namelen, namelen, sfep->name, ino, junkreason,
 				lino);
 		if (namelen == 0)  {
@@ -986,20 +990,18 @@ process_sf_dir2(
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
 				if (!no_modify)  {
-					do_warn(_("zero length entry in "
-						  "shortform dir %llu, "
-						  "resetting to %d\n"),
+					do_warn(
+_("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
 						ino, namelen);
 					sfep->namelen = namelen;
 				} else  {
-					do_warn(_("zero length entry in "
-						  "shortform dir %llu, "
-						  "would set to %d\n"),
+					do_warn(
+_("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),
 						ino, namelen);
 				}
 			} else  {
-				do_warn(_("zero length entry in shortform dir "
-					  "%llu"),
+				do_warn(
+_("zero length entry in shortform dir %" PRIu64 ""),
 					ino);
 				if (!no_modify)
 					do_warn(_(", junking %d entries\n"),
@@ -1022,8 +1024,8 @@ process_sf_dir2(
 				namelen = ino_dir_size -
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
-				do_warn(_("size of last entry overflows space "
-					  "left in in shortform dir %llu, "),
+				do_warn(
+_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);
 				if (!no_modify)  {
 					do_warn(_("resetting to %d\n"),
@@ -1035,8 +1037,8 @@ process_sf_dir2(
 						namelen);
 				}
 			} else  {
-				do_warn(_("size of entry #%d overflows space "
-					  "left in in shortform dir %llu\n"),
+				do_warn(
+_("size of entry #%d overflows space left in in shortform dir %" PRIu64 "\n"),
 					i, ino);
 				if (!no_modify)  {
 					if (i == num_entries - 1)
@@ -1072,15 +1074,15 @@ process_sf_dir2(
 			/*
 			 * junk entry
 			 */
-			do_warn(_("entry contains illegal character "
-				  "in shortform dir %llu\n"),
+			do_warn(
+_("entry contains illegal character in shortform dir %" PRIu64 "\n"),
 				ino);
 			junkit = 1;
 		}
 
 		if (xfs_dir2_sf_get_offset(sfep) < offset) {
-			do_warn(_("entry contains offset out of order in "
-				  "shortform dir %llu\n"),
+			do_warn(
+_("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 				ino);
 			bad_offset = 1;
 		}
@@ -1136,12 +1138,12 @@ process_sf_dir2(
 				*dino_dirty = 1;
 				*repair = 1;
 
-				do_warn(_("junking entry \"%s\" in directory "
-					  "inode %llu\n"),
+				do_warn(
+_("junking entry \"%s\" in directory inode %" PRIu64 "\n"),
 					name, ino);
 			} else  {
-				do_warn(_("would have junked entry \"%s\" in "
-					  "directory inode %llu\n"),
+				do_warn(
+_("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 					name, ino);
 			}
 		} else if (lino > XFS_DIR2_MAX_SHORT_INUM)
@@ -1167,12 +1169,12 @@ process_sf_dir2(
 
 	if (sfp->hdr.count != i) {
 		if (no_modify) {
-			do_warn(_("would have corrected entry count "
-				  "in directory %llu from %d to %d\n"),
+			do_warn(
+_("would have corrected entry count in directory %" PRIu64 " from %d to %d\n"),
 				ino, sfp->hdr.count, i);
 		} else {
-			do_warn(_("corrected entry count in directory %llu, "
-				  "was %d, now %d\n"),
+			do_warn(
+_("corrected entry count in directory %" PRIu64 "u, was %d, now %d\n"),
 				ino, sfp->hdr.count, i);
 			sfp->hdr.count = i;
 			*dino_dirty = 1;
@@ -1182,12 +1184,12 @@ process_sf_dir2(
 
 	if (sfp->hdr.i8count != i8)  {
 		if (no_modify)  {
-			do_warn(_("would have corrected i8 count in directory "
-				  "%llu from %d to %d\n"),
+			do_warn(
+_("would have corrected i8 count in directory %" PRIu64 " from %d to %d\n"),
 				ino, sfp->hdr.i8count, i8);
 		} else {
-			do_warn(_("corrected i8 count in directory %llu, "
-				  "was %d, now %d\n"),
+			do_warn(
+_("corrected i8 count in directory %" PRIu64 ", was %d, now %d\n"),
 				ino, sfp->hdr.i8count, i8);
 			if (i8 == 0)
 				process_sf_dir2_fixi8(sfp, &next_sfep);
@@ -1198,19 +1200,17 @@ process_sf_dir2(
 		}
 	}
 
-	if ((__psint_t) next_sfep - (__psint_t) sfp != ino_dir_size)  {
+	if ((intptr_t)next_sfep - (intptr_t)sfp != ino_dir_size)  {
 		if (no_modify)  {
-			do_warn(_("would have corrected directory %llu size "
-				  "from %lld to %lld\n"),
-				ino, (__int64_t) ino_dir_size,
-				(__int64_t)((__psint_t)next_sfep -
-					    (__psint_t)sfp));
+			do_warn(
+_("would have corrected directory %" PRIu64 " size from %" PRId64 " to %" PRIdPTR "\n"),
+				ino, ino_dir_size,
+				(intptr_t)next_sfep - (intptr_t)sfp);
 		} else  {
-			do_warn(_("corrected directory %llu size, was %lld, "
-				  "now %lld\n"),
-				ino, (__int64_t) ino_dir_size,
-				(__int64_t)((__psint_t)next_sfep -
-					    (__psint_t)sfp));
+			do_warn(
+_("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
+				ino, ino_dir_size,
+				(intptr_t)next_sfep - (intptr_t)sfp);
 
 			dip->di_size = cpu_to_be64(
 					(__psint_t)next_sfep - (__psint_t)sfp);
@@ -1220,17 +1220,17 @@ process_sf_dir2(
 	}
 	if (offset + (sfp->hdr.count + 2) * sizeof(xfs_dir2_leaf_entry_t) +
 			sizeof(xfs_dir2_block_tail_t) > mp->m_dirblksize) {
-		do_warn(_("directory %llu offsets too high\n"), ino);
+		do_warn(_("directory %" PRIu64 " offsets too high\n"), ino);
 		bad_offset = 1;
 	}
 	if (bad_offset) {
 		if (no_modify) {
-			do_warn(_("would have corrected entry offsets in "
-				  "directory %llu\n"),
+			do_warn(
+_("would have corrected entry offsets in directory %" PRIu64 "\n"),
 				ino);
 		} else {
-			do_warn(_("corrected entry offsets in "
-				  "directory %llu\n"),
+			do_warn(
+_("corrected entry offsets in directory %" PRIu64 "\n"),
 				ino);
 			process_sf_dir2_fixoff(dip);
 			*dino_dirty = 1;
@@ -1248,8 +1248,8 @@ process_sf_dir2(
 	 */
 	if (verify_inum(mp, *parent))  {
 
-		do_warn(_("bogus .. inode number (%llu) in directory inode "
-			  "%llu, "),
+		do_warn(
+_("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 				*parent, ino);
 		*parent = NULLFSINO;
 		if (!no_modify)  {
@@ -1266,16 +1266,16 @@ process_sf_dir2(
 		 * root directories must have .. == .
 		 */
 		if (!no_modify)  {
-			do_warn(_("corrected root directory %llu .. entry, "
-				  "was %llu, now %llu\n"),
+			do_warn(
+_("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64 "\n"),
 				ino, *parent, ino);
 			*parent = ino;
 			xfs_dir2_sf_put_inumber(sfp, parent, &sfp->hdr.parent);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
-			do_warn(_("would have corrected root directory %llu .. "
-				  "entry from %llu to %llu\n"),
+			do_warn(
+_("would have corrected root directory %" PRIu64 " .. entry from %" PRIu64" to %" PRIu64 "\n"),
 				ino, *parent, ino);
 		}
 	} else if (ino == *parent && ino != mp->m_sb.sb_rootino)  {
@@ -1284,8 +1284,8 @@ process_sf_dir2(
 		 * to .
 		 */
 		*parent = NULLFSINO;
-		do_warn(_("bad .. entry in directory inode %llu, points to "
-			  "self, "),
+		do_warn(
+_("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 			ino);
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
@@ -1397,7 +1397,7 @@ process_dir2_data(
 	 * Phase 6 will kill this block if we don't kill the inode.
 	 */
 	if (ptr != endptr) {
-		do_warn(_("corrupt block %u in directory inode %llu\n"),
+		do_warn(_("corrupt block %u in directory inode %" PRIu64 "\n"),
 			da_bno, ino);
 		if (!no_modify)
 			do_warn(_("\twill junk block\n"));
@@ -1485,20 +1485,21 @@ process_dir2_data(
 		ASSERT((clearino == 0 && clearreason == NULL) ||
 			(clearino != 0 && clearreason != NULL));
 		if (clearino)
-			do_warn(_("entry \"%*.*s\" at block %u offset %d in "
-				  "directory inode %llu references %s inode "
-				  "%llu\n"),
+			do_warn(
+_("entry \"%*.*s\" at block %d offset %" PRIdPTR " in directory inode %" PRIu64
+  " references %s inode %" PRIu64 "\n"),
 				dep->namelen, dep->namelen, dep->name,
-				da_bno, (char *)ptr - (char *)d, ino,
+				da_bno, (intptr_t)ptr - (intptr_t)d, ino,
 				clearreason, ent_ino);
 		/*
 		 * If the name length is 0 (illegal) make it 1 and blast
 		 * the entry.
 		 */
 		if (dep->namelen == 0) {
-			do_warn(_("entry at block %u offset %d in directory "
-				  "inode %llu has 0 namelength\n"),
-				da_bno, (char *)ptr - (char *)d, ino);
+			do_warn(
+_("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
+  "has 0 namelength\n"),
+				da_bno, (intptr_t)ptr - (intptr_t)d, ino);
 			if (!no_modify)
 				dep->namelen = 1;
 			clearino = 1;
@@ -1508,16 +1509,16 @@ process_dir2_data(
 		 */
 		if (clearino) {
 			if (!no_modify) {
-				do_warn(_("\tclearing inode number in entry at "
-					  "offset %d...\n"),
-					(char *)ptr - (char *)d);
+				do_warn(
+_("\tclearing inode number in entry at offset %" PRIdPTR "...\n"),
+					(intptr_t)ptr - (intptr_t)d);
 				dep->inumber = cpu_to_be64(BADFSINO);
 				ent_ino = BADFSINO;
 				bp->dirty = 1;
 			} else {
-				do_warn(_("\twould clear inode number in entry "
-					  "at offset %d...\n"),
-					(char *)ptr - (char *)d);
+				do_warn(
+_("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
+					(intptr_t)ptr - (intptr_t)d);
 			}
 		}
 		/*
@@ -1528,9 +1529,9 @@ process_dir2_data(
 		junkit = ent_ino == BADFSINO;
 		nm_illegal = namecheck((char *)dep->name, dep->namelen);
 		if (ino_discovery && nm_illegal) {
-			do_warn(_("entry at block %u offset %d in directory "
-				  "inode %llu has illegal name \"%*.*s\": "),
-				da_bno, (char *)ptr - (char *)d, ino,
+			do_warn(
+_("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),
+				da_bno, (intptr_t)ptr - (intptr_t)d, ino,
 				dep->namelen, dep->namelen, dep->name);
 			junkit = 1;
 		}
@@ -1558,8 +1559,8 @@ process_dir2_data(
 				if (ino == ent_ino &&
 						ino != mp->m_sb.sb_rootino) {
 					*parent = NULLFSINO;
-					do_warn(_("bad .. entry in directory "
-						  "inode %llu, points to self: "),
+					do_warn(
+_("bad .. entry in directory inode %" PRIu64 ", points to self: "),
 						ino);
 					junkit = 1;
 				}
@@ -1569,9 +1570,8 @@ process_dir2_data(
 				 */
 				else if (ino != ent_ino &&
 						ino == mp->m_sb.sb_rootino) {
-					do_warn(_("bad .. entry in root "
-						  "directory inode %llu, was "
-						  "%llu: "),
+					do_warn(
+_("bad .. entry in root directory inode %" PRIu64 ", was %" PRIu64 ": "),
 						ino, ent_ino);
 					if (!no_modify) {
 						do_warn(_("correcting\n"));
@@ -1589,8 +1589,8 @@ process_dir2_data(
 			 * seem equally valid, trash this one.
 			 */
 			else {
-				do_warn(_("multiple .. entries in directory "
-					  "inode %llu: "),
+				do_warn(
+_("multiple .. entries in directory inode %" PRIu64 ": "),
 					ino);
 				junkit = 1;
 			}
@@ -1602,8 +1602,8 @@ process_dir2_data(
 			if (!*dot) {
 				(*dot)++;
 				if (ent_ino != ino) {
-					do_warn(_("bad . entry in directory "
-						  "inode %llu, was %llu: "),
+					do_warn(
+_("bad . entry in directory inode %" PRIu64 ", was %" PRIu64 ": "),
 						ino, ent_ino);
 					if (!no_modify) {
 						do_warn(_("correcting\n"));
@@ -1614,8 +1614,8 @@ process_dir2_data(
 					}
 				}
 			} else {
-				do_warn(_("multiple . entries in directory "
-					  "inode %llu: "),
+				do_warn(
+_("multiple . entries in directory inode %" PRIu64 ": "),
 					ino);
 				junkit = 1;
 			}
@@ -1624,8 +1624,8 @@ process_dir2_data(
 		 * All other entries -- make sure only . references self.
 		 */
 		else if (ent_ino == ino) {
-			do_warn(_("entry \"%*.*s\" in directory inode %llu "
-				  "points to self: "),
+			do_warn(
+_("entry \"%*.*s\" in directory inode %" PRIu64 " points to self: "),
 				dep->namelen, dep->namelen, dep->name, ino);
 			junkit = 1;
 		}
@@ -1650,8 +1650,9 @@ process_dir2_data(
 	 * Check the bestfree table.
 	 */
 	if (freeseen != 7 || badbest) {
-		do_warn(_("bad bestfree table in block %u in directory inode "
-			  "%llu: "), da_bno, ino);
+		do_warn(
+_("bad bestfree table in block %u in directory inode %" PRIu64 ": "),
+			da_bno, ino);
 		if (!no_modify) {
 			do_warn(_("repairing table\n"));
 			libxfs_dir2_data_freescan(mp, d, &i);
@@ -1694,7 +1695,8 @@ process_block_dir2(
 	*parent = NULLFSINO;
 	nex = blkmap_getn(blkmap, mp->m_dirdatablk, mp->m_dirblkfsbs, &bmp, &lbmp);
 	if (nex == 0) {
-		do_warn(_("block %u for directory inode %llu is missing\n"),
+		do_warn(
+_("block %u for directory inode %" PRIu64 " is missing\n"),
 			mp->m_dirdatablk, ino);
 		return 1;
 	}
@@ -1702,7 +1704,8 @@ process_block_dir2(
 	if (bmp != &lbmp)
 		free(bmp);
 	if (bp == NULL) {
-		do_warn(_("can't read block %u for directory inode %llu\n"),
+		do_warn(
+_("can't read block %u for directory inode %" PRIu64 "\n"),
 			mp->m_dirdatablk, ino);
 		return 1;
 	}
@@ -1711,8 +1714,8 @@ process_block_dir2(
 	 */
 	block = bp->data;
 	if (be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)
-		do_warn(_("bad directory block magic # %#x in block %u for "
-			  "directory inode %llu\n"),
+		do_warn(
+_("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n"),
 			be32_to_cpu(block->hdr.magic), mp->m_dirdatablk, ino);
 	/*
 	 * process the data area
@@ -1755,16 +1758,16 @@ process_leaf_block_dir2(
 
 	for (i = stale = 0; i < be16_to_cpu(leaf->hdr.count); i++) {
 		if ((char *)&leaf->ents[i] >= (char *)leaf + mp->m_dirblksize) {
-			do_warn(_("bad entry count in block %u of directory "
-				  "inode %llu\n"),
+			do_warn(
+_("bad entry count in block %u of directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			return 1;
 		}
 		if (be32_to_cpu(leaf->ents[i].address) == XFS_DIR2_NULL_DATAPTR)
 			stale++;
 		else if (be32_to_cpu(leaf->ents[i].hashval) < last_hashval) {
-			do_warn(_("bad hash ordering in block %u of directory "
-				  "inode %llu\n"),
+			do_warn(
+_("bad hash ordering in block %u of directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			return 1;
 		}
@@ -1772,8 +1775,8 @@ process_leaf_block_dir2(
 					be32_to_cpu(leaf->ents[i].hashval);
 	}
 	if (stale != be16_to_cpu(leaf->hdr.stale)) {
-		do_warn(_("bad stale count in block %u of directory "
-			  "inode %llu\n"),
+		do_warn(
+_("bad stale count in block %u of directory inode %" PRIu64 "\n"),
 			da_bno, ino);
 		return 1;
 	}
@@ -1820,8 +1823,8 @@ process_leaf_level_dir2(
 		ASSERT(da_bno != 0);
 
 		if (nex == 0) {
-			do_warn(_("can't map block %u for directory "
-				  "inode %llu\n"),
+			do_warn(
+_("can't map block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
@@ -1830,8 +1833,8 @@ process_leaf_level_dir2(
 			free(bmp);
 		bmp = NULL;
 		if (bp == NULL) {
-			do_warn(_("can't read file block %u for directory "
-				  "inode %llu\n"),
+			do_warn(
+_("can't read file block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
@@ -1841,8 +1844,8 @@ process_leaf_level_dir2(
 		 */
 		if (be16_to_cpu(leaf->hdr.info.magic) !=
 		   XFS_DIR2_LEAFN_MAGIC) {
-			do_warn(_("bad directory leaf magic # %#x for "
-				  "directory inode %llu block %u\n"),
+			do_warn(
+_("bad directory leaf magic # %#x for directory inode %" PRIu64 " block %u\n"),
 				be16_to_cpu(leaf->hdr.info.magic),
 				ino, da_bno);
 			da_brelse(bp);
@@ -1871,8 +1874,8 @@ process_leaf_level_dir2(
 		da_cursor->level[0].dirty = buf_dirty;
 
 		if (be32_to_cpu(leaf->hdr.info.back) != prev_bno) {
-			do_warn(_("bad sibling back pointer for block %u in "
-				  "directory inode %llu\n"),
+			do_warn(
+_("bad sibling back pointer for block %u in directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			da_brelse(bp);
 			goto error_out;
@@ -1897,7 +1900,7 @@ process_leaf_level_dir2(
 		/*
 		 * Verify the final path up (right-hand-side) if still ok.
 		 */
-		do_warn(_("bad hash path in directory %llu\n"), ino);
+		do_warn(_("bad hash path in directory %" PRIu64 "\n"), ino);
 		goto error_out;
 	}
 	/*
@@ -2001,8 +2004,8 @@ process_leaf_node_dir2(
 		nex = blkmap_getn(blkmap, dbno, mp->m_dirblkfsbs, &bmp, &lbmp);
 		ndbno = dbno + mp->m_dirblkfsbs - 1;
 		if (nex == 0) {
-			do_warn(_("block %llu for directory inode %llu is "
-				  "missing\n"),
+			do_warn(
+_("block %" PRIu64 " for directory inode %" PRIu64 " is missing\n"),
 				dbno, ino);
 			continue;
 		}
@@ -2010,15 +2013,15 @@ process_leaf_node_dir2(
 		if (bmp != &lbmp)
 			free(bmp);
 		if (bp == NULL) {
-			do_warn(_("can't read block %llu for directory inode "
-				  "%llu\n"),
+			do_warn(
+_("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				dbno, ino);
 			continue;
 		}
 		data = bp->data;
 		if (be32_to_cpu(data->hdr.magic) != XFS_DIR2_DATA_MAGIC)
-			do_warn(_("bad directory block magic # %#x in block "
-				"%llu for directory inode %llu\n"),
+			do_warn(
+_("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 				be32_to_cpu(data->hdr.magic), dbno, ino);
 		i = process_dir2_data(mp, ino, dip, ino_discovery, dirname,
 			parent, bp, dot, dotdot, (xfs_dablk_t)dbno,
@@ -2095,14 +2098,14 @@ process_dir2(
 			dirname, parent, blkmap, &dot, &dotdot, &repair,
 			last > mp->m_dirleafblk + mp->m_dirblkfsbs);
 	} else {
-		do_warn(_("bad size/format for directory %llu\n"), ino);
+		do_warn(_("bad size/format for directory %" PRIu64 "\n"), ino);
 		return 1;
 	}
 	/*
 	 * bad . entries in all directories will be fixed up in phase 6
 	 */
 	if (dot == 0) {
-		do_warn(_("no . entry for directory %llu\n"), ino);
+		do_warn(_("no . entry for directory %" PRIu64 "\n"), ino);
 	}
 
 	/*
@@ -2112,9 +2115,9 @@ process_dir2(
 	 * fixed in place since we know what it should be
 	 */
 	if (dotdot == 0 && ino != mp->m_sb.sb_rootino) {
-		do_warn(_("no .. entry for directory %llu\n"), ino);
+		do_warn(_("no .. entry for directory %" PRIu64 "\n"), ino);
 	} else if (dotdot == 0 && ino == mp->m_sb.sb_rootino) {
-		do_warn(_("no .. entry for root directory %llu\n"), ino);
+		do_warn(_("no .. entry for root directory %" PRIu64 "\n"), ino);
 		need_root_dotdot = 1;
 	}
 
Index: xfsprogs-dev/repair/dinode.c
===================================================================
--- xfsprogs-dev.orig/repair/dinode.c	2011-08-02 03:57:26.189687223 -0700
+++ xfsprogs-dev/repair/dinode.c	2011-08-14 09:58:49.025938702 -0700
@@ -82,11 +82,11 @@ clear_dinode_attr(xfs_mount_t *mp, xfs_d
 	ASSERT(dino->di_forkoff != 0);
 
 	if (!no_modify)
-		fprintf(stderr, _("clearing inode %llu attributes\n"),
-			(unsigned long long)ino_num);
+		fprintf(stderr,
+_("clearing inode %" PRIu64 " attributes\n"), ino_num);
 	else
-		fprintf(stderr, _("would have cleared inode %llu attributes\n"),
-			(unsigned long long)ino_num);
+		fprintf(stderr,
+_("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 
 	if (be16_to_cpu(dino->di_anextents) != 0)  {
 		if (no_modify)
@@ -487,22 +487,29 @@ process_rt_rec(
 	 * check numeric validity of the extent
 	 */
 	if (irec->br_startblock >= mp->m_sb.sb_rblocks) {
-		do_warn(_("inode %llu - bad rt extent start block number "
-				"%llu, offset %llu\n"), ino,
-				irec->br_startblock, irec->br_startoff);
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent start block number %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			irec->br_startblock,
+			irec->br_startoff);
 		return 1;
 	}
 	if (irec->br_startblock + irec->br_blockcount - 1 >= mp->m_sb.sb_rblocks) {
-		do_warn(_("inode %llu - bad rt extent last block number %llu, "
-				"offset %llu\n"), ino, irec->br_startblock +
-				irec->br_blockcount - 1, irec->br_startoff);
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			irec->br_startblock + irec->br_blockcount - 1,
+			irec->br_startoff);
 		return 1;
 	}
 	if (irec->br_startblock + irec->br_blockcount - 1 < irec->br_startblock) {
-		do_warn(_("inode %llu - bad rt extent overflows - start %llu, "
-				"end %llu, offset %llu\n"), ino,
-				irec->br_startblock, irec->br_startblock +
-				irec->br_blockcount - 1, irec->br_startoff);
+		do_warn(
+_("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
+  "end %" PRIu64 ", offset %" PRIu64 "\n"),
+			ino,
+			irec->br_startblock,
+			irec->br_startblock + irec->br_blockcount - 1,
+			irec->br_startoff);
 		return 1;
 	}
 
@@ -513,9 +520,11 @@ process_rt_rec(
 	if (xfs_sb_version_hasextflgbit(&mp->m_sb) == 0 &&
 			(irec->br_startblock % mp->m_sb.sb_rextsize != 0 ||
 			 irec->br_blockcount % mp->m_sb.sb_rextsize != 0)) {
-		do_warn(_("malformed rt inode extent [%llu %llu] (fs rtext "
-				"size = %u)\n"), irec->br_startblock,
-				irec->br_blockcount, mp->m_sb.sb_rextsize);
+		do_warn(
+_("malformed rt inode extent [%" PRIu64 " %" PRIu64 "] (fs rtext size = %u)\n"),
+			irec->br_startblock,
+			irec->br_blockcount,
+			mp->m_sb.sb_rextsize);
 		return 1;
 	}
 
@@ -532,12 +541,13 @@ process_rt_rec(
 
 		if (check_dups == 1)  {
 			if (search_rt_dup_extent(mp, ext) && !pwe)  {
-				do_warn(_("data fork in rt ino %llu claims "
-						"dup rt extent, off - %llu, "
-						"start - %llu, count %llu\n"),
-						ino, irec->br_startoff,
-						irec->br_startblock,
-						irec->br_blockcount);
+				do_warn(
+_("data fork in rt ino %" PRIu64 " claims dup rt extent,"
+  "off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
+					ino,
+					irec->br_startoff,
+					irec->br_startblock,
+					irec->br_blockcount);
 				return 1;
 			}
 			continue;
@@ -550,26 +560,29 @@ process_rt_rec(
 			set_rtbmap(ext, XR_E_INUSE);
 			break;
 		case XR_E_BAD_STATE:
-			do_error(_("bad state in rt block map %llu\n"), ext);
+			do_error(
+_("bad state in rt block map %" PRIu64 "\n"),
+				ext);
 		case XR_E_FS_MAP:
 		case XR_E_INO:
 		case XR_E_INUSE_FS:
-			do_error(_("data fork in rt inode %llu found "
-				"metadata block %llu in rt bmap\n"),
+			do_error(
+_("data fork in rt inode %" PRIu64 " found metadata block %" PRIu64 " in rt bmap\n"),
 				ino, ext);
 		case XR_E_INUSE:
 			if (pwe)
 				break;
 		case XR_E_MULT:
 			set_rtbmap(ext, XR_E_MULT);
-			do_warn(_("data fork in rt inode %llu claims "
-					"used rt block %llu\n"),
-					ino, ext);
+			do_warn(
+_("data fork in rt inode %" PRIu64 " claims used rt block %" PRIu64 "\n"),
+				ino, ext);
 			return 1;
 		case XR_E_FREE1:
 		default:
-			do_error(_("illegal state %d in rt block map "
-					"%llu\n"), state, b);
+			do_error(
+_("illegal state %d in rt block map %" PRIu64 "\n"),
+				state, b);
 		}
 	}
 
@@ -636,8 +649,10 @@ process_bmbt_reclist_int(
 		else
 			*last_key = irec.br_startoff;
 		if (i > 0 && op + cp > irec.br_startoff)  {
-			do_warn(_("bmap rec out of order, inode %llu entry %d "
-	  			"[o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"),
+			do_warn(
+_("bmap rec out of order, inode %" PRIu64" entry %d "
+  "[o s c] [%" PRIu64 " %" PRIu64 " %" PRIu64 "], "
+  "%d [%" PRIu64 " %" PRIu64 " %" PRIu64 "]\n"),
 				ino, i, irec.br_startoff, irec.br_startblock,
 				irec.br_blockcount, i - 1, op, sp, cp);
 			goto done;
@@ -650,9 +665,11 @@ process_bmbt_reclist_int(
 		 * check numeric validity of the extent
 		 */
 		if (irec.br_blockcount == 0)  {
-			do_warn(_("zero length extent (off = %llu, fsbno = "
-				"%llu) in ino %llu\n"), irec.br_startoff,
-				irec.br_startblock, ino);
+			do_warn(
+_("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64 "\n"),
+				irec.br_startoff,
+				irec.br_startblock,
+				ino);
 			goto done;
 		}
 
@@ -679,30 +696,35 @@ process_bmbt_reclist_int(
 				break;
 
 			case XR_DFSBNORANGE_BADSTART:
-				do_warn(_("inode %llu - bad extent starting "
-					"block number %llu, offset %llu\n"),
-					ino, irec.br_startblock,
+				do_warn(
+_("inode %" PRIu64 " - bad extent starting block number %" PRIu64 ", offset %" PRIu64 "\n"),
+					ino,
+					irec.br_startblock,
 					irec.br_startoff);
 				goto done;
 
 			case XR_DFSBNORANGE_BADEND:
-				do_warn(_("inode %llu - bad extent last block "
-					"number %llu, offset %llu\n"), ino,
-					irec.br_startblock + irec.br_blockcount
-					- 1, irec.br_startoff);
+				do_warn(
+_("inode %" PRIu64 " - bad extent last block number %" PRIu64 ", offset %" PRIu64 "\n"),
+					ino,
+					irec.br_startblock + irec.br_blockcount - 1,
+					irec.br_startoff);
 				goto done;
 
 			case XR_DFSBNORANGE_OVERFLOW:
-				do_warn(_("inode %llu - bad extent overflows - "
-					"start %llu, end %llu, offset %llu\n"),
-					ino, irec.br_startblock,
-					irec.br_startblock + irec.br_blockcount
-					- 1, irec.br_startoff);
+				do_warn(
+_("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
+  "end %" PRIu64 ", offset %" PRIu64 "\n"),
+					ino,
+					irec.br_startblock,
+					irec.br_startblock + irec.br_blockcount - 1,
+					irec.br_startoff);
 				goto done;
 		}
 		if (irec.br_startoff >= fs_max_file_offset)  {
-			do_warn(_("inode %llu - extent offset too large - "
-				"start %llu, count %llu, offset %llu\n"),
+			do_warn(
+_("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
+  "count %" PRIu64 ", offset %" PRIu64 "\n"),
 				ino, irec.br_startblock, irec.br_blockcount,
 				irec.br_startoff);
 			goto done;
@@ -733,9 +755,9 @@ process_bmbt_reclist_int(
 			 * block bitmap
 			 */
 			if (search_dup_extent(agno, agbno, ebno)) {
-				do_warn(_("%s fork in ino %llu claims "
-					"dup extent, off - %llu, "
-					"start - %llu, cnt %llu\n"),
+				do_warn(
+_("%s fork in ino %" PRIu64 " claims dup extent, "
+  "off - %" PRIu64 ", start - %" PRIu64 ", cnt %" PRIu64 "\n"),
 					forkname, ino, irec.br_startoff,
 					irec.br_startblock,
 					irec.br_blockcount);
@@ -752,8 +774,8 @@ process_bmbt_reclist_int(
 			switch (state)  {
 			case XR_E_FREE:
 			case XR_E_FREE1:
-				do_warn(_("%s fork in ino %llu claims free "
-					"block %llu\n"),
+				do_warn(
+_("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 					forkname, ino, (__uint64_t) b);
 				/* fall through ... */
 			case XR_E_UNKNOWN:
@@ -761,26 +783,27 @@ process_bmbt_reclist_int(
 				break;
 
 			case XR_E_BAD_STATE:
-				do_error(_("bad state in block map %llu\n"), b);
+				do_error(_("bad state in block map %" PRIu64 "\n"), b);
 
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
-				do_warn(_("%s fork in inode %llu claims "
-					"metadata block %llu\n"),
-					forkname, ino, (__uint64_t) b);
+				do_warn(
+_("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
+					forkname, ino, b);
 				goto done;
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
-				do_warn(_("%s fork in %s inode %llu claims "
-					"used block %llu\n"),
-					forkname, ftype, ino, (__uint64_t) b);
+				do_warn(
+_("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
+					forkname, ftype, ino, b);
 				goto done;
 
 			default:
-				do_error(_("illegal state %d in block map %llu\n"),
+				do_error(
+_("illegal state %d in block map %" PRIu64 "\n"),
 					state, b);
 			}
 		}
@@ -858,7 +881,7 @@ get_agino_buf(xfs_mount_t	 *mp,
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno,
 		XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)), size, 0);
 	if (!bp) {
-		do_warn(_("cannot read inode (%u/%u), disk block %lld\n"),
+		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
 			agno, irec->ino_startnum,
 			XFS_AGB_TO_DADDR(mp, agno,
 				XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)));
@@ -969,7 +992,7 @@ getfunc_btree(xfs_mount_t		*mp,
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				XFS_FSB_TO_BB(mp, 1), 0);
 	if (!bp) {
-		do_error(_("cannot read bmap block %llu\n"), fsbno);
+		do_error(_("cannot read bmap block %" PRIu64 "\n"), fsbno);
 		return(NULLDFSBNO);
 	}
 	block = XFS_BUF_TO_BLOCK(bp);
@@ -989,16 +1012,16 @@ getfunc_btree(xfs_mount_t		*mp,
 		prev_level = be16_to_cpu(block->bb_level);
 #endif
 		if (numrecs > mp->m_bmap_dmxr[1]) {
-			do_warn(_("# of bmap records in inode %llu exceeds max "
-				  "(%u, max - %u)\n"),
+			do_warn(
+_("# of bmap records in inode %" PRIu64 " exceeds max (%u, max - %u)\n"),
 				ino, numrecs,
 				mp->m_bmap_dmxr[1]);
 			libxfs_putbuf(bp);
 			return(NULLDFSBNO);
 		}
 		if (verbose && numrecs < mp->m_bmap_dmnr[1]) {
-			do_warn(_("- # of bmap records in inode %llu less than "
-				  "minimum (%u, min - %u), proceeding ...\n"),
+			do_warn(
+_("- # of bmap records in inode %" PRIu64 " less than minimum (%u, min - %u), proceeding ...\n"),
 				ino, numrecs, mp->m_bmap_dmnr[1]);
 		}
 		key = XFS_BMBT_KEY_ADDR(mp, block, 1);
@@ -1026,7 +1049,8 @@ getfunc_btree(xfs_mount_t		*mp,
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 					XFS_FSB_TO_BB(mp, 1), 0);
 		if (!bp) {
-			do_error(_("cannot read bmap block %llu\n"), fsbno);
+			do_error(_("cannot read bmap block %" PRIu64 "\n"),
+				fsbno);
 			return(NULLDFSBNO);
 		}
 		block = XFS_BUF_TO_BLOCK(bp);
@@ -1038,15 +1062,15 @@ getfunc_btree(xfs_mount_t		*mp,
 	 */
 	ASSERT(be16_to_cpu(block->bb_level) == 0);
 	if (numrecs > mp->m_bmap_dmxr[0]) {
-		do_warn(_("# of bmap records in inode %llu greater than "
-			  "maximum (%u, max - %u)\n"),
+		do_warn(
+_("# of bmap records in inode %" PRIu64 " greater than maximum (%u, max - %u)\n"),
 			ino, numrecs, mp->m_bmap_dmxr[0]);
 		libxfs_putbuf(bp);
 		return(NULLDFSBNO);
 	}
 	if (verbose && numrecs < mp->m_bmap_dmnr[0])
-		do_warn(_("- # of bmap records in inode %llu less than minimum "
-			  "(%u, min - %u), continuing...\n"),
+		do_warn(
+_("- # of bmap records in inode %" PRIu64 " less than minimum (%u, min - %u), continuing...\n"),
 			ino, numrecs, mp->m_bmap_dmnr[0]);
 
 	rec = XFS_BMBT_REC_ADDR(mp, block, 1);
@@ -1062,7 +1086,7 @@ getfunc_btree(xfs_mount_t		*mp,
 	libxfs_putbuf(bp);
 
 	if (final_fsbno == NULLDFSBNO)
-		do_warn(_("could not map block %llu\n"), bno);
+		do_warn(_("could not map block %" PRIu64 "\n"), bno);
 
 	return(final_fsbno);
 }
@@ -1096,7 +1120,7 @@ get_bmapi(xfs_mount_t *mp, xfs_dinode_t
 		fsbno = getfunc_btree(mp, ino_num, dino_p, bno, whichfork);
 		break;
 	case XFS_DINODE_FMT_LOCAL:
-		do_error(_("get_bmapi() called for local inode %llu\n"),
+		do_error(_("get_bmapi() called for local inode %" PRIu64 "\n"),
 			ino_num);
 		fsbno = NULLDFSBNO;
 		break;
@@ -1104,7 +1128,7 @@ get_bmapi(xfs_mount_t *mp, xfs_dinode_t
 		/*
 		 * shouldn't happen
 		 */
-		do_error(_("bad inode format for inode %llu\n"), ino_num);
+		do_error(_("bad inode format for inode %" PRIu64 "\n"), ino_num);
 		fsbno = NULLDFSBNO;
 	}
 
@@ -1168,12 +1192,14 @@ process_btinode(
 		 * to by the pointers in the fork.  For now
 		 * though, we just bail (and blow out the inode).
 		 */
-		do_warn(_("bad level %d in inode %llu bmap btree root block\n"),
+		do_warn(
+_("bad level %d in inode %" PRIu64 " bmap btree root block\n"),
 			level, XFS_AGINO_TO_INO(mp, agno, ino));
 		return(1);
 	}
 	if (numrecs == 0) {
-		do_warn(_("bad numrecs 0 in inode %llu bmap btree root block\n"),
+		do_warn(
+_("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
 			XFS_AGINO_TO_INO(mp, agno, ino));
 		return(1);
 	}
@@ -1183,7 +1209,7 @@ process_btinode(
 	if (XFS_BMDR_SPACE_CALC(numrecs) > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		do_warn(
 	_("indicated size of %s btree root (%d bytes) greater than space in "
-	  "inode %llu %s fork\n"),
+	  "inode %" PRIu64 " %s fork\n"),
 			forkname, XFS_BMDR_SPACE_CALC(numrecs), lino, forkname);
 		return(1);
 	}
@@ -1202,7 +1228,7 @@ process_btinode(
 		 * problem, we'll bail out and presumably clear the inode.
 		 */
 		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
-			do_warn(_("bad bmap btree ptr 0x%llx in ino %llu\n"),
+			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
 				be64_to_cpu(pp[i]), lino);
 			return(1);
 		}
@@ -1221,8 +1247,8 @@ process_btinode(
 					be64_to_cpu(pkey[i].br_startoff))  {
 			if (!no_modify)  {
 				do_warn(
-	_("correcting key in bmbt root (was %llu, now %llu) in inode "
-	  "%llu %s fork\n"),
+	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
+	  "%" PRIu64" %s fork\n"),
 					be64_to_cpu(pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
@@ -1232,8 +1258,8 @@ process_btinode(
 					cursor.level[level-1].first_key);
 			} else  {
 				do_warn(
-	_("bad key in bmbt root (is %llu, would reset to %llu) in inode "
-	  "%llu %s fork\n"),
+	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
+	  "%" PRIu64 " %s fork\n"),
 					be64_to_cpu(pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
@@ -1248,7 +1274,7 @@ process_btinode(
 			if (last_key != NULLDFILOFF && last_key >=
 			    cursor.level[level-1].first_key)  {
 				do_warn(
-		_("out of order bmbt root key %llu in inode %llu %s fork\n"),
+	_("out of order bmbt root key %" PRIu64 " in inode %" PRIu64 " %s fork\n"),
 					first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
@@ -1265,7 +1291,7 @@ process_btinode(
 	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) /
 			sizeof(xfs_bmbt_rec_t)) {
 		do_warn(
-	_("extent count for ino %lld %s fork too low (%d) for file format\n"),
+	_("extent count for ino %" PRIu64 " %s fork too low (%" PRIu64 ") for file format\n"),
 				lino, forkname, *nex);
 		return(1);
 	}
@@ -1276,10 +1302,10 @@ process_btinode(
 	if (check_dups == 0 &&
 		cursor.level[0].right_fsbno != NULLDFSBNO)  {
 		do_warn(
-	_("bad fwd (right) sibling pointer (saw %llu should be NULLDFSBNO)\n"),
+	_("bad fwd (right) sibling pointer (saw %" PRIu64 " should be NULLDFSBNO)\n"),
 			cursor.level[0].right_fsbno);
 		do_warn(
-	_("\tin inode %u (%s fork) bmap btree block %llu\n"),
+	_("\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
 			XFS_AGINO_TO_INO(mp, agno, ino), forkname,
 			cursor.level[0].fsbno);
 		return(1);
@@ -1347,7 +1373,7 @@ process_lclinode(
 	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
-	_("local inode %llu data fork is too large (size = %lld, max = %d)\n"),
+	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %d)\n"),
 			lino, be64_to_cpu(dip->di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
@@ -1355,14 +1381,14 @@ process_lclinode(
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			do_warn(
-	_("local inode %llu attr fork too large (size %d, max = %d)\n"),
+	_("local inode %" PRIu64 " attr fork too large (size %d, max = %d)\n"),
 				lino, be16_to_cpu(asf->hdr.totsize),
 				XFS_DFORK_ASIZE(dip, mp));
 			return(1);
 		}
 		if (be16_to_cpu(asf->hdr.totsize) < sizeof(xfs_attr_sf_hdr_t)) {
 			do_warn(
-	_("local inode %llu attr too small (size = %d, min size = %d)\n"),
+	_("local inode %" PRIu64 " attr too small (size = %d, min size = %zd)\n"),
 				lino, be16_to_cpu(asf->hdr.totsize),
 				sizeof(xfs_attr_sf_hdr_t));
 			return(1);
@@ -1385,15 +1411,17 @@ process_symlink_extlist(xfs_mount_t *mp,
 	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
 		if (dino->di_format == XFS_DINODE_FMT_LOCAL)  
 			return 0;
-		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink ino %llu\n"), dino->di_format, 
-			be64_to_cpu(dino->di_size), lino);
+		do_warn(
+_("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
+			dino->di_format,
+			(__int64_t)be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
 	if (dino->di_format == XFS_DINODE_FMT_LOCAL) {
-		do_warn(_("mismatch between format (%d) and size (%lld) in "
-			"symlink inode %llu\n"), dino->di_format,
-			be64_to_cpu(dino->di_size), lino);
+		do_warn(
+_("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu64 "n"),
+			dino->di_format,
+			(__int64_t)be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
 
@@ -1406,7 +1434,7 @@ process_symlink_extlist(xfs_mount_t *mp,
 	 */
 	if (numrecs > max_symlink_blocks)  {
 		do_warn(
-		_("bad number of extents (%d) in symlink %llu data fork\n"),
+_("bad number of extents (%d) in symlink %" PRIu64 " data fork\n"),
 			numrecs, lino);
 		return(1);
 	}
@@ -1419,13 +1447,13 @@ process_symlink_extlist(xfs_mount_t *mp,
 
 		if (irec.br_startoff != expected_offset)  {
 			do_warn(
-		_("bad extent #%d offset (%llu) in symlink %llu data fork\n"),
+_("bad extent #%d offset (%" PRIu64 ") in symlink %" PRIu64 " data fork\n"),
 				i, irec.br_startoff, lino);
 			return(1);
 		}
 		if (irec.br_blockcount == 0 || irec.br_blockcount > max_blocks) {
 			do_warn(
-		_("bad extent #%d count (%llu) in symlink %llu data fork\n"),
+_("bad extent #%d count (%" PRIu64 ") in symlink %" PRIu64 " data fork\n"),
 				i, irec.br_blockcount, lino);
 			return(1);
 		}
@@ -1480,7 +1508,7 @@ process_symlink(
 	 * for that
 	 */
 	if (be64_to_cpu(dino->di_size) >= MAXPATHLEN)  {
-		do_warn(_("symlink in inode %llu too long (%lld chars)\n"),
+		do_warn(_("symlink in inode %" PRIu64 " too long (%lld chars)\n"),
 			lino, be64_to_cpu(dino->di_size));
 		return(1);
 	}
@@ -1513,7 +1541,7 @@ process_symlink(
 						XFS_FSB_TO_BB(mp, 1), 0);
 			if (!bp || fsbno == NULLDFSBNO) {
 				do_warn(
-		_("cannot read inode %llu, file block %d, disk block %llu\n"),
+_("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 					lino, i, fsbno);
 				return(1);
 			}
@@ -1535,7 +1563,7 @@ process_symlink(
 	 */
 	if (null_check(symlink, be64_to_cpu(dino->di_size)))  {
 		do_warn(
-		_("found illegal null character in symlink inode %llu\n"),
+_("found illegal null character in symlink inode %" PRIu64 "\n"),
 			lino);
 		return(1);
 	}
@@ -1549,7 +1577,7 @@ process_symlink(
 		while (cptr != NULL)  {
 			if (cptr - symlink >= MAXNAMELEN)  {
 				do_warn(
-			_("component of symlink in inode %llu too long\n"),
+_("component of symlink in inode %" PRIu64 " too long\n"),
 					lino);
 				return(1);
 			}
@@ -1559,7 +1587,7 @@ process_symlink(
 
 		if (strlen(symlink) >= MAXNAMELEN)  {
 			do_warn(
-			_("component of symlink in inode %llu too long\n"),
+_("component of symlink in inode %" PRIu64 " too long\n"),
 				lino);
 			return(1);
 		}
@@ -1584,7 +1612,8 @@ process_misc_ino_types(xfs_mount_t	*mp,
 	 * probably require a superblock version rev, sigh).
 	 */
 	if (type == XR_INO_MOUNTPOINT)  {
-		do_warn(_("inode %llu has bad inode type (IFMNT)\n"), lino);
+		do_warn(
+_("inode %" PRIu64 " has bad inode type (IFMNT)\n"), lino);
 		return(1);
 	}
 
@@ -1594,24 +1623,24 @@ process_misc_ino_types(xfs_mount_t	*mp,
 	if (be64_to_cpu(dino->di_size) != 0)  {
 		switch (type)  {
 		case XR_INO_CHRDEV:
-			do_warn(_("size of character device inode %llu != 0 "
-				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_size));
+			do_warn(
+_("size of character device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
+				(__int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_BLKDEV:
-			do_warn(_("size of block device inode %llu != 0 "
-				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_size));
+			do_warn(
+_("size of block device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
+				(__int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_SOCK:
-			do_warn(_("size of socket inode %llu != 0 "
-				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_size));
+			do_warn(
+_("size of socket inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
+				(__int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_FIFO:
-			do_warn(_("size of fifo inode %llu != 0 "
-				  "(%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_size));
+			do_warn(
+_("size of fifo inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
+				(__int64_t)be64_to_cpu(dino->di_size));
 			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
@@ -1641,22 +1670,22 @@ process_misc_ino_types_blocks(xfs_drfsbn
 		switch (type)  {
 		case XR_INO_CHRDEV:
 			do_warn(
-		_("size of character device inode %llu != 0 (%llu blocks)\n"),
+_("size of character device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
 				lino, totblocks);
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(
-		_("size of block device inode %llu != 0 (%llu blocks)\n"),
+_("size of block device inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
 				lino, totblocks);
 			break;
 		case XR_INO_SOCK:
 			do_warn(
-		_("size of socket inode %llu != 0 (%llu blocks)\n"),
+_("size of socket inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
 				lino, totblocks);
 			break;
 		case XR_INO_FIFO:
 			do_warn(
-		_("size of fifo inode %llu != 0 (%llu blocks)\n"),
+_("size of fifo inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
 				lino, totblocks);
 			break;
 		default:
@@ -1734,7 +1763,7 @@ process_check_sb_inodes(
 {
 	if (lino == mp->m_sb.sb_rootino) {
 	 	if (*type != XR_INO_DIR)  {
-			do_warn(_("root inode %llu has bad type 0x%x\n"),
+			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			*type = XR_INO_DIR;
 			if (!no_modify)  {
@@ -1748,7 +1777,7 @@ process_check_sb_inodes(
 	}
 	if (lino == mp->m_sb.sb_uquotino)  {
 		if (*type != XR_INO_DATA)  {
-			do_warn(_("user quota inode %llu has bad type 0x%x\n"),
+			do_warn(_("user quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			mp->m_sb.sb_uquotino = NULLFSINO;
 			return 1;
@@ -1757,7 +1786,7 @@ process_check_sb_inodes(
 	}
 	if (lino == mp->m_sb.sb_gquotino)  {
 		if (*type != XR_INO_DATA)  {
-			do_warn(_("group quota inode %llu has bad type 0x%x\n"),
+			do_warn(_("group quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
 			mp->m_sb.sb_gquotino = NULLFSINO;
 			return 1;
@@ -1766,7 +1795,8 @@ process_check_sb_inodes(
 	}
 	if (lino == mp->m_sb.sb_rsumino) {
 		if (*type != XR_INO_RTSUM) {
-			do_warn(_("realtime summary inode %llu has bad type 0x%x, "),
+			do_warn(
+_("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
 				lino, dinode_fmt(dinoc));
 			if (!no_modify)  {
 				do_warn(_("resetting to regular file\n"));
@@ -1777,7 +1807,8 @@ process_check_sb_inodes(
 			}
 		}
 		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
-			do_warn(_("bad # of extents (%u) for realtime summary inode %llu\n"),
+			do_warn(
+_("bad # of extents (%u) for realtime summary inode %" PRIu64 "\n"),
 				be32_to_cpu(dinoc->di_nextents), lino);
 			return 1;
 		}
@@ -1785,7 +1816,8 @@ process_check_sb_inodes(
 	}
 	if (lino == mp->m_sb.sb_rbmino) {
 		if (*type != XR_INO_RTBITMAP) {
-			do_warn(_("realtime bitmap inode %llu has bad type 0x%x, "),
+			do_warn(
+_("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
 				lino, dinode_fmt(dinoc));
 			if (!no_modify)  {
 				do_warn(_("resetting to regular file\n"));
@@ -1796,7 +1828,8 @@ process_check_sb_inodes(
 			}
 		}
 		if (mp->m_sb.sb_rblocks == 0 && dinoc->di_nextents != 0)  {
-			do_warn(_("bad # of extents (%u) for realtime bitmap inode %llu\n"),
+			do_warn(
+_("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
 				be32_to_cpu(dinoc->di_nextents), lino);
 			return 1;
 		}
@@ -1830,13 +1863,14 @@ process_check_inode_sizes(
 	case XR_INO_DIR:
 		if (size <= XFS_DFORK_DSIZE(dino, mp) &&
 				dino->di_format != XFS_DINODE_FMT_LOCAL) {
-			do_warn(_("mismatch between format (%d) and size "
-				"(%lld) in directory ino %llu\n"),
+			do_warn(
+_("mismatch between format (%d) and size (%" PRId64 ") in directory ino %" PRIu64 "\n"),
 				dino->di_format, size, lino);
 			return 1;
 		}
 		if (size > XFS_DIR2_LEAF_OFFSET) {
-			do_warn(_("directory inode %llu has bad size %lld\n"),
+			do_warn(
+_("directory inode %" PRIu64 " has bad size %" PRId64 "\n"),
 				lino, size);
 			return 1;
 		}
@@ -1844,7 +1878,7 @@ process_check_inode_sizes(
 
 	case XR_INO_SYMLINK:
 		if (process_symlink_extlist(mp, lino, dino))  {
-			do_warn(_("bad data fork in symlink %llu\n"), lino);
+			do_warn(_("bad data fork in symlink %" PRIu64 "\n"), lino);
 			return 1;
 		}
 		break;
@@ -1864,8 +1898,8 @@ process_check_inode_sizes(
 		 * to be a real-time file is bogus
 		 */
 		if (mp->m_sb.sb_rblocks == 0)  {
-			do_warn(_("found inode %llu claiming to be a "
-				"real-time file\n"), lino);
+			do_warn(
+_("found inode %" PRIu64 " claiming to be a real-time file\n"), lino);
 			return 1;
 		}
 		break;
@@ -1873,9 +1907,10 @@ process_check_inode_sizes(
 	case XR_INO_RTBITMAP:
 		if (size != (__int64_t)mp->m_sb.sb_rbmblocks *
 					mp->m_sb.sb_blocksize) {
-			do_warn(_("realtime bitmap inode %llu has bad size "
-				"%lld (should be %lld)\n"),
-				lino, size, (__int64_t) mp->m_sb.sb_rbmblocks *
+			do_warn(
+_("realtime bitmap inode %" PRIu64 " has bad size %" PRId64 " (should be %" PRIu64 ")\n"),
+				lino, size,
+				(__int64_t) mp->m_sb.sb_rbmblocks *
 					mp->m_sb.sb_blocksize);
 			return 1;
 		}
@@ -1883,8 +1918,8 @@ process_check_inode_sizes(
 
 	case XR_INO_RTSUM:
 		if (size != mp->m_rsumsize)  {
-			do_warn(_("realtime summary inode %llu has bad size "
-				"%lld (should be %d)\n"),
+			do_warn(
+_("realtime summary inode %" PRIu64 " has bad size %" PRId64 " (should be %d)\n"),
 				lino, size, mp->m_rsumsize);
 			return 1;
 		}
@@ -1911,8 +1946,9 @@ process_check_inode_forkoff(
 	switch (dino->di_format)  {
 	case XFS_DINODE_FMT_DEV:
 		if (dino->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
-			do_warn(_("bad attr fork offset %d in dev inode %llu, "
-				"should be %d\n"), dino->di_forkoff, lino,
+			do_warn(
+_("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
+				dino->di_forkoff, lino,
 				(int)(roundup(sizeof(xfs_dev_t), 8) >> 3));
 			return 1;
 		}
@@ -1921,8 +1957,9 @@ process_check_inode_forkoff(
 	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
 		if (dino->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
-			do_warn(_("bad attr fork offset %d in inode %llu, "
-				"max=%d\n"), dino->di_forkoff, lino,
+			do_warn(
+_("bad attr fork offset %d in inode %" PRIu64 ", max=%d\n"),
+				dino->di_forkoff, lino,
 				XFS_LITINO(mp) >> 3);
 			return 1;
 		}
@@ -1948,52 +1985,59 @@ process_inode_blocks_and_extents(
 {
 	if (nblocks != be64_to_cpu(dino->di_nblocks))  {
 		if (!no_modify)  {
-			do_warn(_("correcting nblocks for inode %llu, "
-				"was %llu - counted %llu\n"), lino,
+			do_warn(
+_("correcting nblocks for inode %" PRIu64 ", was %llu - counted %" PRIu64 "\n"), lino,
 				be64_to_cpu(dino->di_nblocks), nblocks);
 			dino->di_nblocks = cpu_to_be64(nblocks);
 			*dirty = 1;
 		} else  {
-			do_warn(_("bad nblocks %llu for inode %llu, "
-				"would reset to %llu\n"),
+			do_warn(
+_("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 				be64_to_cpu(dino->di_nblocks), lino, nblocks);
 		}
 	}
 
 	if (nextents > MAXEXTNUM)  {
-		do_warn(_("too many data fork extents (%llu) in inode %llu\n"),
+		do_warn(
+_("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
 		return 1;
 	}
 	if (nextents != be32_to_cpu(dino->di_nextents))  {
 		if (!no_modify)  {
-			do_warn(_("correcting nextents for inode %llu, "
-				"was %d - counted %llu\n"), lino,
-				be32_to_cpu(dino->di_nextents), nextents);
+			do_warn(
+_("correcting nextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+				lino,
+				be32_to_cpu(dino->di_nextents),
+				nextents);
 			dino->di_nextents = cpu_to_be32(nextents);
 			*dirty = 1;
 		} else  {
-			do_warn(_("bad nextents %d for inode %llu, would reset "
-				"to %llu\n"), be32_to_cpu(dino->di_nextents),
+			do_warn(
+_("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+				be32_to_cpu(dino->di_nextents),
 				lino, nextents);
 		}
 	}
 
 	if (anextents > MAXAEXTNUM)  {
-		do_warn(_("too many attr fork extents (%llu) in inode %llu\n"),
+		do_warn(
+_("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
 		return 1;
 	}
 	if (anextents != be16_to_cpu(dino->di_anextents))  {
 		if (!no_modify)  {
-			do_warn(_("correcting anextents for inode %llu, "
-				"was %d - counted %llu\n"), lino,
+			do_warn(
+_("correcting anextents for inode %" PRIu64 ", was %d - counted %" PRIu64 "\n"),
+				lino,
 				be16_to_cpu(dino->di_anextents), anextents);
 			dino->di_anextents = cpu_to_be16(anextents);
 			*dirty = 1;
 		} else  {
-			do_warn(_("bad anextents %d for inode %llu, would reset"
-				" to %llu\n"), be16_to_cpu(dino->di_anextents),
+			do_warn(
+_("bad anextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
+				be16_to_cpu(dino->di_anextents),
 				lino, anextents);
 		}
 	}
@@ -2046,12 +2090,12 @@ process_inode_data_fork(
 		err = 0;
 		break;
 	default:
-		do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
+		do_error(_("unknown format %d, ino %" PRIu64 " (mode = %d)\n"),
 			dino->di_format, lino, be16_to_cpu(dino->di_mode));
 	}
 
 	if (err)  {
-		do_warn(_("bad data fork in inode %llu\n"), lino);
+		do_warn(_("bad data fork in inode %" PRIu64 "\n"), lino);
 		if (!no_modify)  {
 			*dirty += clear_dinode(mp, dino, lino);
 			ASSERT(*dirty > 0);
@@ -2084,7 +2128,7 @@ process_inode_data_fork(
 			err = 0;
 			break;
 		default:
-			do_error(_("unknown format %d, ino %llu (mode = %d)\n"),
+			do_error(_("unknown format %d, ino %" PRIu64 " (mode = %d)\n"),
 				dino->di_format, lino,
 				be16_to_cpu(dino->di_mode));
 		}
@@ -2122,7 +2166,7 @@ process_inode_attr_fork(
 	if (!XFS_DFORK_Q(dino)) {
 		*anextents = 0;
 		if (dino->di_aformat != XFS_DINODE_FMT_EXTENTS) {
-			do_warn(_("bad attribute format %d in inode %llu, "),
+			do_warn(_("bad attribute format %d in inode %" PRIu64 ", "),
 				dino->di_aformat, lino);
 			if (!no_modify) {
 				do_warn(_("resetting value\n"));
@@ -2159,7 +2203,7 @@ process_inode_attr_fork(
 				XFS_ATTR_FORK, check_dups);
 		break;
 	default:
-		do_warn(_("illegal attribute format %d, ino %llu\n"),
+		do_warn(_("illegal attribute format %d, ino %" PRIu64 "\n"),
 				dino->di_aformat, lino);
 		err = 1;
 		break;
@@ -2174,7 +2218,7 @@ process_inode_attr_fork(
 		 * XXX - put the inode onto the "move it" list and
 		 *	log the the attribute scrubbing
 		 */
-		do_warn(_("bad attribute fork in inode %llu"), lino);
+		do_warn(_("bad attribute fork in inode %" PRIu64), lino);
 
 		if (!no_modify)  {
 			if (delete_attr_ok)  {
@@ -2215,7 +2259,7 @@ process_inode_attr_fork(
 				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		default:
-			do_error(_("illegal attribute fmt %d, ino %llu\n"),
+			do_error(_("illegal attribute fmt %d, ino %" PRIu64 "\n"),
 				dino->di_aformat, lino);
 		}
 
@@ -2234,7 +2278,8 @@ process_inode_attr_fork(
 	/* get this only in phase 3, not in both phase 3 and 4 */
 	if (extra_attr_check &&
 			process_attributes(mp, lino, dino, ablkmap, &repair)) {
-		do_warn(_("problem with attribute contents in inode %llu\n"),
+		do_warn(
+	_("problem with attribute contents in inode %" PRIu64 "\n"),
 			lino);
 		if (!repair) {
 			/* clear attributes if not done already */
@@ -2284,22 +2329,23 @@ process_check_inode_nlink_version(
 				 * cause sb to be updated later.
 				 */
 				fs_inode_nlink = 1;
-				do_warn(_("version 2 inode %llu claims > %u links, "),
+				do_warn
+	(_("version 2 inode %" PRIu64 " claims > %u links, "),
 					lino, XFS_MAXLINK_1);
 				if (!no_modify)  {
-					do_warn(_("updating superblock "
-						"version number\n"));
+					do_warn(
+	_("updating superblock version number\n"));
 				} else  {
-					do_warn(_("would update superblock "
-						"version number\n"));
+					do_warn(
+	_("would update superblock version number\n"));
 				}
 			} else  {
 				/*
 				 * no, have to convert back to onlinks
 				 * even if we lose some links
 				 */
-				do_warn(_("WARNING:  version 2 inode %llu "
-					"claims > %u links, "),
+				do_warn(
+	_("WARNING:  version 2 inode %" PRIu64 " claims > %u links, "),
 					lino, XFS_MAXLINK_1);
 				if (!no_modify)  {
 					do_warn(_("converting back to version 1,\n"
@@ -2327,7 +2373,7 @@ process_check_inode_nlink_version(
 			 *
 			 * the case where we lost links was handled above.
 			 */
-			do_warn(_("found version 2 inode %llu, "), lino);
+			do_warn(_("found version 2 inode %" PRIu64 ", "), lino);
 			if (!no_modify)  {
 				do_warn(_("converting back to version 1\n"));
 				dino->di_version = 1;
@@ -2348,14 +2394,14 @@ process_check_inode_nlink_version(
 	if (dino->di_version > 1 &&
 			dino->di_onlink != 0 && fs_inode_nlink > 0) {
 		if (!no_modify) {
-			do_warn(_("clearing obsolete nlink field in "
-				"version 2 inode %llu, was %d, now 0\n"),
+			do_warn(
+_("clearing obsolete nlink field in version 2 inode %" PRIu64 ", was %d, now 0\n"),
 				lino, be16_to_cpu(dino->di_onlink));
 			dino->di_onlink = 0;
 			dirty = 1;
 		} else  {
-			do_warn(_("would clear obsolete nlink field in "
-				"version 2 inode %llu, currently %d\n"),
+			do_warn(
+_("would clear obsolete nlink field in version 2 inode %" PRIu64 ", currently %d\n"),
 				lino, be16_to_cpu(dino->di_onlink));
 		}
 	}
@@ -2425,7 +2471,7 @@ process_dinode_int(xfs_mount_t *mp,
 	if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)  {
 		retval = 1;
 		if (!uncertain)
-			do_warn(_("bad magic number 0x%x on inode %llu%c"),
+			do_warn(_("bad magic number 0x%x on inode %" PRIu64 "%c"),
 				be16_to_cpu(dino->di_magic), lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
@@ -2442,7 +2488,7 @@ process_dinode_int(xfs_mount_t *mp,
 	    (!fs_inode_nlink && dino->di_version > 1))  {
 		retval = 1;
 		if (!uncertain)
-			do_warn(_("bad version number 0x%x on inode %llu%c"),
+			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
 				(__s8)dino->di_version, lino,
 				verify_mode ? '\n' : ',');
 		if (!verify_mode) {
@@ -2460,8 +2506,10 @@ process_dinode_int(xfs_mount_t *mp,
 	 */
 	if ((xfs_fsize_t)be64_to_cpu(dino->di_size) < 0)  {
 		if (!uncertain)
-			do_warn(_("bad (negative) size %lld on inode %llu\n"),
-				be64_to_cpu(dino->di_size), lino);
+			do_warn(
+_("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
+				(__int64_t)be64_to_cpu(dino->di_size),
+				lino);
 		if (verify_mode)
 			return 1;
 		goto clear_bad_out;
@@ -2491,7 +2539,8 @@ process_dinode_int(xfs_mount_t *mp,
 		 * clear the inode just to be safe and mark the inode
 		 * free.
 		 */
-		do_warn(_("imap claims a free inode %llu is in use, "), lino);
+		do_warn(
+	_("imap claims a free inode %" PRIu64 " is in use, "), lino);
 		if (!no_modify)  {
 			do_warn(_("correcting imap and clearing inode\n"));
 			*dirty += clear_dinode(mp, dino, lino);
@@ -2513,7 +2562,8 @@ process_dinode_int(xfs_mount_t *mp,
 	 */
 	if (di_mode != 0 && check_dinode_mode_format(dino) != 0) {
 		if (!uncertain)
-			do_warn(_("bad inode format in inode %llu\n"), lino);
+			do_warn(
+	_("bad inode format in inode %" PRIu64 "\n"), lino);
 		if (verify_mode)
 			return 1;
 		goto clear_bad_out;
@@ -2527,15 +2577,16 @@ process_dinode_int(xfs_mount_t *mp,
 		uint16_t flags = be16_to_cpu(dino->di_flags);
 
 		if (flags & ~XFS_DIFLAG_ANY) {
-			do_warn(_("Bad flags set in inode %llu"), lino);
+			do_warn(_("Bad flags set in inode %" PRIu64), lino);
 			flags &= ~XFS_DIFLAG_ANY;
 		}
 
 		if (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT)) {
 			/* need an rt-dev! */
 			if (!rt_name) {
-				do_warn(_(
-	"inode %llu has RT flag set but there is no RT device"), lino);
+				do_warn(
+	_("inode %" PRIu64 " has RT flag set but there is no RT device"),
+					lino);
 				flags &= ~(XFS_DIFLAG_REALTIME |
 						XFS_DIFLAG_RTINHERIT);
 			}
@@ -2543,7 +2594,8 @@ process_dinode_int(xfs_mount_t *mp,
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
-				do_warn(_("inode %llu not rt bitmap"), lino);
+				do_warn(_("inode %" PRIu64 " not rt bitmap"),
+					lino);
 				flags &= ~XFS_DIFLAG_NEWRTBM;
 			}
 		}
@@ -2553,8 +2605,8 @@ process_dinode_int(xfs_mount_t *mp,
 			     XFS_DIFLAG_NOSYMLINKS)) {
 			/* must be a directory */
 			if (di_mode && !S_ISDIR(di_mode)) {
-				do_warn(_(
-			"directory flags set on non-directory inode %llu"),
+				do_warn(
+	_("directory flags set on non-directory inode %" PRIu64 ),
 					lino);
 				flags &= ~(XFS_DIFLAG_RTINHERIT |
 						XFS_DIFLAG_EXTSZINHERIT |
@@ -2565,8 +2617,9 @@ process_dinode_int(xfs_mount_t *mp,
 		if (flags & (XFS_DIFLAG_REALTIME | XFS_XFLAG_EXTSIZE)) {
 			/* must be a file */
 			if (di_mode && !S_ISREG(di_mode)) {
-				do_warn(_(
-			"file flags set on non-file inode %llu"), lino);
+				do_warn(
+	_("file flags set on non-file inode %" PRIu64),
+					lino);
 				flags &= ~(XFS_DIFLAG_REALTIME |
 						XFS_XFLAG_EXTSIZE);
 			}
@@ -2628,7 +2681,7 @@ process_dinode_int(xfs_mount_t *mp,
 		type = XR_INO_FIFO;
 		break;
 	default:
-		do_warn(_("bad inode type %#o inode %llu\n"),
+		do_warn(_("bad inode type %#o inode %" PRIu64 "\n"),
 				di_mode & S_IFMT, lino);
 		goto clear_bad_out;
 	}
@@ -2651,8 +2704,8 @@ process_dinode_int(xfs_mount_t *mp,
 				 XFS_DIFLAG_EXTSIZE)))  {
 			/* s'okay */ ;
 		} else {
-			do_warn(_("bad non-zero extent size %u for "
-					"non-realtime/extsize inode %llu, "),
+			do_warn(
+_("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 					be32_to_cpu(dino->di_extsize), lino);
 			if (!no_modify)  {
 				do_warn(_("resetting to zero\n"));
@@ -2714,14 +2767,16 @@ process_dinode_int(xfs_mount_t *mp,
 						dirty, "", parent, dblkmap) :
 				process_dir(mp, lino, dino, ino_discovery,
 						dirty, "", parent, dblkmap)) {
-			do_warn(_("problem with directory contents in "
-				"inode %llu\n"), lino);
+			do_warn(
+	_("problem with directory contents in inode %" PRIu64 "\n"),
+				lino);
 			goto clear_bad_out;
 		}
 		break;
 	case XR_INO_SYMLINK:
 		if (process_symlink(mp, lino, dino, dblkmap) != 0) {
-			do_warn(_("problem with symbolic link in inode %llu\n"),
+			do_warn(
+	_("problem with symbolic link in inode %" PRIu64 "\n"),
 				lino);
 			goto clear_bad_out;
 		}
Index: xfsprogs-dev/repair/phase2.c
===================================================================
--- xfsprogs-dev.orig/repair/phase2.c	2011-08-02 03:57:26.199687168 -0700
+++ xfsprogs-dev/repair/phase2.c	2011-08-14 09:58:49.029272017 -0700
@@ -67,7 +67,8 @@ zero_log(xfs_mount_t *mp)
 			error);
 	} else {
 		if (verbose) {
-			do_warn(_("zero_log: head block %lld tail block %lld\n"),
+			do_warn(
+	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
 				head_blk, tail_blk);
 		}
 		if (head_blk != tail_blk) {
Index: xfsprogs-dev/repair/phase3.c
===================================================================
--- xfsprogs-dev.orig/repair/phase3.c	2011-08-02 03:57:26.213020431 -0700
+++ xfsprogs-dev/repair/phase3.c	2011-08-14 09:58:49.029272017 -0700
@@ -107,7 +107,7 @@ process_agi_unlinked(xfs_mount_t *mp, xf
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE, 0);
 	if (!bp)
-		do_error(_("cannot read agi block %lld for ag %u\n"),
+		do_error(_("cannot read agi block %" PRId64 " for ag %u\n"),
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)), agno);
 
 	agip = XFS_BUF_TO_AGI(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
