Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IIQNKG116663 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 13:26:23 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107181826.p6IIQK5r029492@stout.americas.sgi.com>
Date: Mon, 18 Jul 2011 13:26:20 -0500
Subject: xfsprogs: fix some printf() warnings that show up for ia64
 builds.
MIME-Version: 1.0
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

A few notes:
  - This applies on top of Christoph Hellwig's recent "xfs_repair:
    add printf format checking and fix the fallout" patch.
  - I don't like the long lines in this code.  This change made more
    of more of them--and I tried some formatting conventions to
    improve the look--but it's still not great and I'm open to
    suggestions.
  - Christoph, even though you supplied it earlier I did not add
    your sign-off because I did these formatting changes.

  					-Alex
 ------------
xfsprogs: fix some printf() warnings that show up for ia64 builds.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 io/parent.c              |   28 ++++++++++++++++------------
 logprint/log_misc.c      |   34 ++++++++++++++++++++--------------
 logprint/log_print_all.c |   16 ++++++++++------
 repair/dinode.c          |   33 +++++++++++++++++++--------------
 repair/scan.c            |   14 +++++++++-----
 5 files changed, 74 insertions(+), 51 deletions(-)

Index: b/io/parent.c
===================================================================
--- a/io/parent.c
+++ b/io/parent.c
@@ -52,12 +52,12 @@ check_parent_entry(xfs_bstat_t *bstatp, 
 	if (sts != 0) {
 		fprintf(stderr,
 			_("inode-path for inode: %llu is incorrect - path \"%s\" non-existent\n"),
-			bstatp->bs_ino, fullpath);
+			(unsigned long long) bstatp->bs_ino, fullpath);
 		if (verbose_flag) {
 			fprintf(stderr,
 				_("path \"%s\" does not stat for inode: %llu; err = %s\n"),
 				fullpath,
-				bstatp->bs_ino,
+				(unsigned long long) bstatp->bs_ino,
 				strerror(errno));
 		}
 		err_status++;
@@ -71,7 +71,7 @@ check_parent_entry(xfs_bstat_t *bstatp, 
 	if (statbuf.st_ino != bstatp->bs_ino) {
 		fprintf(stderr,
 			_("inode-path for inode: %llu is incorrect - wrong inode#\n"),
-			bstatp->bs_ino);
+			(unsigned long long) bstatp->bs_ino);
 		if (verbose_flag) {
 			fprintf(stderr,
 				_("ino mismatch for path \"%s\" %llu vs %llu\n"),
@@ -101,7 +101,7 @@ check_parent_entry(xfs_bstat_t *bstatp, 
 		if (parent->p_ino != statbuf.st_ino) {
 			fprintf(stderr,
 				_("inode-path for inode: %llu is incorrect - wrong parent inode#\n"),
-				bstatp->bs_ino);
+				(unsigned long long) bstatp->bs_ino);
 			if (verbose_flag) {
 				fprintf(stderr,
 					_("ino mismatch for path \"%s\" %llu vs %llu\n"),
@@ -113,7 +113,8 @@ check_parent_entry(xfs_bstat_t *bstatp, 
 			return;
 		} else {
 			if (verbose_flag > 1) {
-				printf(_("parent ino match for %llu\n"), parent->p_ino);
+				printf(_("parent ino match for %llu\n"),
+					(unsigned long long) parent->p_ino);
 			}
 		}
 	}
@@ -135,7 +136,7 @@ check_parents(parent_t *parentbuf, size_
 			parentbuf = (parent_t *)realloc(parentbuf, *parentbuf_size);
 		} else if (error) {
 			fprintf(stderr, _("parentpaths failed for ino %llu: %s\n"),
-				statp->bs_ino,
+				(unsigned long long) statp->bs_ino,
 				strerror(errno));
 			err_status++;
 			break;
@@ -145,7 +146,8 @@ check_parents(parent_t *parentbuf, size_
 
 	if (count == 0) {
 		/* no links for inode - something wrong here */
-		fprintf(stderr, _("inode-path for inode: %llu is missing\n"), statp->bs_ino);
+		fprintf(stderr, _("inode-path for inode: %llu is missing\n"),
+				(unsigned long long) statp->bs_ino);
 		err_status++;
 	}
 
@@ -190,13 +192,13 @@ do_bulkstat(parent_t *parentbuf, size_t 
 				if (xfsctl(mntpt, fsfd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq) < 0) {
 				    fprintf(stderr,
 					  _("failed to get bulkstat information for inode %llu\n"),
-					  p->bs_ino );
+					  (unsigned long long) p->bs_ino);
 				    continue;
 				}
 				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
 				    fprintf(stderr,
 					  _("failed to get valid bulkstat information for inode %llu\n"),
-					  p->bs_ino );
+					  (unsigned long long) p->bs_ino);
 				    continue;
 				}
 			}
@@ -207,7 +209,8 @@ do_bulkstat(parent_t *parentbuf, size_t 
 			}
 
 			if (verbose_flag > 1) {
-				printf(_("checking inode %llu\n"), p->bs_ino);
+				printf(_("checking inode %llu\n"),
+					(unsigned long long) p->bs_ino);
 			}
 
 			/* print dotted progress */
@@ -264,7 +267,8 @@ parent_check(void)
 	if (err_status > 0)
 		fprintf(stderr, _("num errors: %d\n"), err_status);
 	else
-		printf(_("succeeded checking %llu inodes\n"), inodes_checked);
+		printf(_("succeeded checking %llu inodes\n"),
+			(unsigned long long) inodes_checked);
 
 	free(bstatbuf);
 	free(parentbuf);
@@ -274,7 +278,7 @@ parent_check(void)
 static void
 print_parent_entry(parent_t *parent, int fullpath)
 {
-	printf(_("p_ino    = %llu\n"),	parent->p_ino);
+	printf(_("p_ino    = %llu\n"),	(unsigned long long) parent->p_ino);
 	printf(_("p_gen    = %u\n"),	parent->p_gen);
 	printf(_("p_reclen = %u\n"),	parent->p_reclen);
 	if (fullpath)
Index: b/logprint/log_misc.c
===================================================================
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -306,12 +306,14 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr
 			 */
 			memmove(&x, *ptr, sizeof(__be64));
 			memmove(&y, *ptr+8, sizeof(__be64));
-			printf(_("icount: %lld  ifree: %lld  "),
-				be64_to_cpu(x), be64_to_cpu(y));
+			printf(_("icount: %llu  ifree: %llu  "),
+				(unsigned long long) be64_to_cpu(x),
+				(unsigned long long) be64_to_cpu(y));
 			memmove(&x, *ptr+16, sizeof(__be64));
 			memmove(&y, *ptr+24, sizeof(__be64));
-			printf(_("fdblks: %lld  frext: %lld\n"),
-				be64_to_cpu(x), be64_to_cpu(y));
+			printf(_("fdblks: %llu  frext: %llu\n"),
+				(unsigned long long) be64_to_cpu(x),
+				(unsigned long long) be64_to_cpu(y));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
@@ -394,18 +396,22 @@ xlog_print_trans_buffer(xfs_caddr_t *ptr
 				dq->d_version, dq->d_flags,
 				be32_to_cpu(dq->d_id));
 			printf(_("blk limits  hard: %llu  soft: %llu\n"),
-				be64_to_cpu(dq->d_blk_hardlimit),
-				be64_to_cpu(dq->d_blk_softlimit));
+				(unsigned long long)
+					be64_to_cpu(dq->d_blk_hardlimit),
+				(unsigned long long)
+					be64_to_cpu(dq->d_blk_softlimit));
 			printf(_("blk  count: %llu  warns: %d  timer: %d\n"),
-				be64_to_cpu(dq->d_bcount),
-				be16_to_cpu(dq->d_bwarns),
-				be32_to_cpu(dq->d_btimer));
+				(unsigned long long) be64_to_cpu(dq->d_bcount),
+				(int) be16_to_cpu(dq->d_bwarns),
+				 be32_to_cpu(dq->d_btimer));
 			printf(_("ino limits  hard: %llu  soft: %llu\n"),
-				be64_to_cpu(dq->d_ino_hardlimit),
-				be64_to_cpu(dq->d_ino_softlimit));
+				(unsigned long long)
+					be64_to_cpu(dq->d_ino_hardlimit),
+				(unsigned long long)
+					be64_to_cpu(dq->d_ino_softlimit));
 			printf(_("ino  count: %llu  warns: %d  timer: %d\n"),
-				be64_to_cpu(dq->d_icount),
-				be16_to_cpu(dq->d_iwarns),
+				(unsigned long long) be64_to_cpu(dq->d_icount),
+				(int) be16_to_cpu(dq->d_iwarns),
 				be32_to_cpu(dq->d_itimer));
 		}
 	} else {
@@ -573,7 +579,7 @@ xlog_print_dir_sf(xfs_dir_shortform_t *s
 	printf(_("SHORTFORM DIRECTORY size %d count %d\n"),
 	       size, sfp->hdr.count);
 	memmove(&ino, &(sfp->hdr.parent), sizeof(ino));
-	printf(_(".. ino 0x%llx\n"), be64_to_cpu(*(__be64 *)&ino));
+	printf(_(".. ino 0x%llx\n"), (unsigned long long) be64_to_cpu(ino));
 
 	count = (uint)(sfp->hdr.count);
 	sfep = &(sfp->list[0]);
Index: b/logprint/log_print_all.c
===================================================================
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -108,12 +108,16 @@ xlog_recover_print_buffer(
 			printf(_("	SUPER Block Buffer:\n"));
 			if (!print_buffer) 
 				continue;
-			printf(_("		icount:%Ld  ifree:%Ld  "),
-			       be64_to_cpu(*(__be64 *)(p)),
-			       be64_to_cpu(*(__be64 *)(p+8)));
-			printf(_("fdblks:%Ld  frext:%Ld\n"),
-			       be64_to_cpu(*(__be64 *)(p+16)),
-			       be64_to_cpu(*(__be64 *)(p+24)));
+			printf(_("		icount:%llu ifree:%llu  "),
+				(unsigned long long)
+					be64_to_cpu(*(__be64 *)(p)),
+				(unsigned long long)
+					be64_to_cpu(*(__be64 *)(p+8)));
+			printf(_("fdblks:%llu  frext:%llu\n"),
+				(unsigned long long)
+					be64_to_cpu(*(__be64 *)(p+16)),
+				(unsigned long long)
+					be64_to_cpu(*(__be64 *)(p+24)));
 			printf(_("		sunit:%u  swidth:%u\n"),
 			       be32_to_cpu(*(__be32 *)(p+56)),
 			       be32_to_cpu(*(__be32 *)(p+60)));
Index: b/repair/dinode.c
===================================================================
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1232,7 +1232,7 @@ _("bad numrecs 0 in inode %" PRIu64 " bm
 		 */
 		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
 			do_warn(_("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
-				be64_to_cpu(pp[i]), lino);
+				(unsigned long long) be64_to_cpu(pp[i]), lino);
 			return(1);
 		}
 
@@ -1252,7 +1252,8 @@ _("bad numrecs 0 in inode %" PRIu64 " bm
 				do_warn(
 	_("correcting key in bmbt root (was %llu, now %" PRIu64") in inode "
 	  "%" PRIu64" %s fork\n"),
-					be64_to_cpu(pkey[i].br_startoff),
+					(unsigned long long)
+						be64_to_cpu(pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
@@ -1263,7 +1264,8 @@ _("bad numrecs 0 in inode %" PRIu64 " bm
 				do_warn(
 	_("bad key in bmbt root (is %llu, would reset to %" PRIu64 ") in inode "
 	  "%" PRIu64 " %s fork\n"),
-					be64_to_cpu(pkey[i].br_startoff),
+					(unsigned long long)
+						be64_to_cpu(pkey[i].br_startoff),
 					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
@@ -1377,7 +1379,7 @@ process_lclinode(
 						XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
 	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %d)\n"),
-			lino, be64_to_cpu(dip->di_core.di_size),
+			lino, (unsigned long long) be64_to_cpu(dip->di_core.di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
 	} else if (whichfork == XFS_ATTR_FORK) {
@@ -1417,14 +1419,14 @@ process_symlink_extlist(xfs_mount_t *mp,
 		do_warn(
 _("mismatch between format (%d) and size (%lld) in symlink ino %" PRIu64 "\n"),
 			dino->di_core.di_format,
-			be64_to_cpu(dino->di_core.di_size), lino);
+			(unsigned long long) be64_to_cpu(dino->di_core.di_size), lino);
 		return 1;
 	}
 	if (dino->di_core.di_format == XFS_DINODE_FMT_LOCAL) {
 		do_warn(
 _("mismatch between format (%d) and size (%lld) in symlink inode %" PRIu64 "\n"),
 			dino->di_core.di_format,
-			be64_to_cpu(dino->di_core.di_size), lino);
+			(unsigned long long) be64_to_cpu(dino->di_core.di_size), lino);
 		return 1;
 	}
 
@@ -1514,7 +1516,7 @@ process_symlink(
 	if (be64_to_cpu(dinoc->di_size) >= MAXPATHLEN)  {
 		do_warn(
 _("symlink in inode %" PRIu64 " too long (%lld chars)\n"),
-			lino, be64_to_cpu(dinoc->di_size));
+			lino, (unsigned long long) be64_to_cpu(dinoc->di_size));
 		return(1);
 	}
 
@@ -1630,22 +1632,22 @@ _("inode %" PRIu64 " has bad inode type 
 		case XR_INO_CHRDEV:
 			do_warn(
 _("size of character device inode %" PRIu64 " != 0 (%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				(unsigned long long) be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(
 _("size of block device inode %" PRIu64 " != 0 (%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				(unsigned long long) be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_SOCK:
 			do_warn(
 _("size of socket inode %" PRIu64 " != 0 (%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				(unsigned long long) be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_FIFO:
 			do_warn(
 _("size of fifo inode %" PRIu64 " != 0 (%lld bytes)\n"), lino,
-				be64_to_cpu(dino->di_core.di_size));
+				(unsigned long long) be64_to_cpu(dino->di_core.di_size));
 			break;
 		default:
 			do_warn(
@@ -1992,13 +1994,16 @@ process_inode_blocks_and_extents(
 		if (!no_modify)  {
 			do_warn(
 	_("correcting nblocks for inode %" PRIu64 ", was %llu - counted %" PRIu64 "\n"),
-				lino, be64_to_cpu(dinoc->di_nblocks), nblocks);
+				lino, (unsigned long long)
+						be64_to_cpu(dinoc->di_nblocks),
+				nblocks);
 			dinoc->di_nblocks = cpu_to_be64(nblocks);
 			*dirty = 1;
 		} else  {
 			do_warn(
 	_("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
-				be64_to_cpu(dinoc->di_nblocks), lino, nblocks);
+				(unsigned long long) be64_to_cpu(dinoc->di_nblocks),
+				lino, nblocks);
 		}
 	}
 
@@ -2526,7 +2531,7 @@ process_dinode_int(xfs_mount_t *mp,
 		if (!uncertain)
 			do_warn(
 	_("bad (negative) size %lld on inode %" PRIu64 "\n"),
-				be64_to_cpu(dinoc->di_size), lino);
+				(unsigned long long) be64_to_cpu(dinoc->di_size), lino);
 		if (verify_mode)
 			return 1;
 		goto clear_bad_out;
Index: b/repair/scan.c
===================================================================
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -235,7 +235,8 @@ _("bad fwd (right) sibling pointer (saw 
 				do_warn(
 _("bad back (left) sibling pointer (saw %llu parent block says %" PRIu64 ")\n"
   "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
-					be64_to_cpu(block->bb_u.l.bb_leftsib),
+					(unsigned long long)
+						be64_to_cpu(block->bb_u.l.bb_leftsib),
 					bm_cursor->level[level].fsbno,
 					ino, forkname, bno);
 				return(1);
@@ -249,7 +250,8 @@ _("bad back (left) sibling pointer (saw 
 				do_warn(
 _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
   "\tin inode %" PRIu64 " (%s fork) bmap btree block %" PRIu64 "\n"),
-					be64_to_cpu(block->bb_u.l.bb_leftsib),
+					(unsigned long long)
+						be64_to_cpu(block->bb_u.l.bb_leftsib),
 					ino, forkname, bno);
 				return(1);
 			}
@@ -404,7 +406,7 @@ _("inode 0x%" PRIu64 " bad # of bmap rec
 		if (!verify_dfsbno(mp, be64_to_cpu(pp[i])))  {
 			do_warn(
 _("bad bmap btree ptr 0x%llx in ino %" PRIu64 "\n"),
-				be64_to_cpu(pp[i]), ino);
+				(unsigned long long) be64_to_cpu(pp[i]), ino);
 			return(1);
 		}
 
@@ -432,7 +434,8 @@ _("bad bmap btree ptr 0x%llx in ino %" P
 				do_warn(
 _("correcting bt key (was %llu, now %" PRIu64 ") in inode %" PRIu64 "\n"
   "\t\t%s fork, btree block %" PRIu64 "\n"),
-					be64_to_cpu(pkey[i].br_startoff),
+					(unsigned long long)
+						be64_to_cpu(pkey[i].br_startoff),
 					bm_cursor->level[level-1].first_key,
 					ino,
 					forkname, bno);
@@ -443,7 +446,8 @@ _("correcting bt key (was %llu, now %" P
 				do_warn(
 _("bad btree key (is %llu, should be %" PRIu64 ") in inode %" PRIu64 "\n"
   "\t\t%s fork, btree block %" PRIu64 "\n"),
-					be64_to_cpu(pkey[i].br_startoff),
+					(unsigned long long)
+						be64_to_cpu(pkey[i].br_startoff),
 					bm_cursor->level[level-1].first_key,
 					ino, forkname, bno);
 			}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
