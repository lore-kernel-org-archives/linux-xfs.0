Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 16:21:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3JNLgfB001650
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 16:21:44 -0700
Date: Fri, 20 Apr 2007 09:21:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: review [3 of 3]: lazy superblock counters - userspace bits
Message-ID: <20070419232133.GZ48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


userspace tool support for lazy superblock accounting.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 xfsprogs/db/agf.c                 |    1 
 xfsprogs/db/check.c               |   25 +++++++++++++++++
 xfsprogs/db/sb.c                  |    2 +
 xfsprogs/growfs/xfs_growfs.c      |   13 ++++++---
 xfsprogs/include/libxfs.h         |    1 
 xfsprogs/include/xfs_ag.h         |    8 ++++-
 xfsprogs/include/xfs_alloc.h      |    6 ++--
 xfsprogs/include/xfs_fs.h         |    1 
 xfsprogs/include/xfs_ialloc.h     |   10 +++++++
 xfsprogs/include/xfs_mount.h      |    5 ++-
 xfsprogs/include/xfs_sb.h         |   15 +++++++++-
 xfsprogs/include/xfs_trans.h      |    3 +-
 xfsprogs/libxfs/init.c            |   14 ++++++++++
 xfsprogs/libxfs/xfs.h             |    6 ++--
 xfsprogs/libxfs/xfs_alloc.c       |   49 +++++++++++++++++++++++++++--------
 xfsprogs/libxfs/xfs_alloc_btree.c |    8 ++---
 xfsprogs/libxfs/xfs_ialloc.c      |   21 +++++++++++++++
 xfsprogs/libxfs/xfs_mount.c       |   53 ++++++++++++++++++++++++++++++++++++++
 xfsprogs/man/man8/mkfs.xfs.8      |   23 +++++++++++++++-
 xfsprogs/mkfs/xfs_mkfs.c          |   22 ++++++++++++---
 xfsprogs/repair/phase5.c          |   22 +++++++++++++++
 21 files changed, 273 insertions(+), 35 deletions(-)

Index: xfs-cmds/xfsprogs/db/agf.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/agf.c	2006-11-15 19:00:28.000000000 +1100
+++ xfs-cmds/xfsprogs/db/agf.c	2007-04-03 14:52:51.659780004 +1000
@@ -68,6 +68,7 @@ const field_t	agf_flds[] = {
 	{ "flcount", FLDT_UINT32D, OI(OFF(flcount)), C1, 0, TYP_NONE },
 	{ "freeblks", FLDT_EXTLEN, OI(OFF(freeblks)), C1, 0, TYP_NONE },
 	{ "longest", FLDT_EXTLEN, OI(OFF(longest)), C1, 0, TYP_NONE },
+	{ "btreeblks", FLDT_UINT32D, OI(OFF(btreeblks)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
Index: xfs-cmds/xfsprogs/db/check.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/check.c	2006-12-22 11:49:54.000000000 +1100
+++ xfs-cmds/xfsprogs/db/check.c	2007-04-03 14:52:51.675777913 +1000
@@ -110,6 +110,9 @@ typedef struct dirhash {
 
 static xfs_extlen_t	agffreeblks;
 static xfs_extlen_t	agflongest;
+static __uint64_t	agf_aggr_freeblks;	/* aggregate count over all */
+static __uint32_t	agfbtreeblks;
+static int		lazycount;
 static xfs_agino_t	agicount;
 static xfs_agino_t	agifreecount;
 static xfs_fsblock_t	*blist;
@@ -854,6 +857,12 @@ blockget_f(
 				mp->m_sb.sb_fdblocks, fdblocks);
 		error++;
 	}
+	if (lazycount && mp->m_sb.sb_fdblocks != agf_aggr_freeblks) {
+		if (!sflag)
+			dbprintf("sb_fdblocks %lld, aggregate AGF count %lld\n",
+				mp->m_sb.sb_fdblocks, agf_aggr_freeblks);
+		error++;
+	}
 	if (mp->m_sb.sb_frextents != frextents) {
 		if (!sflag)
 			dbprintf("sb_frextents %lld, counted %lld\n",
@@ -3886,6 +3895,7 @@ scan_ag(
 	xfs_sb_t	*sb=&tsb;
 
 	agffreeblks = agflongest = 0;
+	agfbtreeblks = -2;
 	agicount = agifreecount = 0;
 	push_cur();
 	set_cur(&typtab[TYP_SB],
@@ -3914,6 +3924,9 @@ scan_ag(
 		error++;
 		sbver_err++;
 	}
+	if (!lazycount && XFS_SB_VERSION_LAZYSBCOUNT(sb)) {
+		lazycount = 1;
+	}
 	if (agno == 0 && sb->sb_inprogress != 0) {
 		if (!sflag)
 			dbprintf("mkfs not completed successfully\n");
@@ -4010,6 +4023,15 @@ scan_ag(
 				agflongest, agno);
 		error++;
 	}
+	if (lazycount &&
+	    INT_GET(agf->agf_btreeblks, ARCH_CONVERT) != agfbtreeblks) {
+		if (!sflag)
+			dbprintf("agf_btreeblks %u, counted %u in ag %u\n",
+				INT_GET(agf->agf_btreeblks, ARCH_CONVERT),
+				agfbtreeblks, agno);
+		error++;
+	}
+	agf_aggr_freeblks += agffreeblks + agfbtreeblks;
 	if (INT_GET(agi->agi_count, ARCH_CONVERT) != agicount) {
 		if (!sflag)
 			dbprintf("agi_count %u, counted %u in ag %u\n",
@@ -4086,6 +4108,7 @@ scan_freelist(
 		error++;
 	}
 	fdblocks += count;
+	agf_aggr_freeblks += count;
 	pop_cur();
 }
 
@@ -4242,6 +4265,7 @@ scanfunc_bno(
 		return;
 	}
 	fdblocks++;
+	agfbtreeblks++;
 	if (INT_GET(block->bb_level, ARCH_CONVERT) != level) {
 		if (!sflag)
 			dbprintf("expected level %d got %d in btbno block "
@@ -4317,6 +4341,7 @@ scanfunc_cnt(
 		return;
 	}
 	fdblocks++;
+	agfbtreeblks++;
 	if (INT_GET(block->bb_level, ARCH_CONVERT) != level) {
 		if (!sflag)
 			dbprintf("expected level %d got %d in btcnt block "
Index: xfs-cmds/xfsprogs/db/sb.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/sb.c	2006-11-15 19:00:29.000000000 +1100
+++ xfs-cmds/xfsprogs/db/sb.c	2007-04-03 14:52:51.683776868 +1000
@@ -608,6 +608,8 @@ version_string(
 		strcat(s, ",MOREBITS");
 	if (XFS_SB_VERSION_HASATTR2(sbp))
 		strcat(s, ",ATTR2");
+	if (XFS_SB_VERSION_LAZYSBCOUNT(sbp))
+		strcat(s, ",LAZYSBCOUNT");
 	return s;
 }
 
Index: xfs-cmds/xfsprogs/growfs/xfs_growfs.c
===================================================================
--- xfs-cmds.orig/xfsprogs/growfs/xfs_growfs.c	2006-12-22 11:49:54.000000000 +1100
+++ xfs-cmds/xfsprogs/growfs/xfs_growfs.c	2007-04-03 14:52:51.703774255 +1000
@@ -59,6 +59,7 @@ report_info(
 	char		*logname,
 	char		*rtname,
 	int		unwritten,
+	int		lazycount,
 	int		dirversion,
 	int		logversion,
 	int		attrversion)
@@ -70,7 +71,7 @@ report_info(
 	    "         =%-22s sunit=%-6u swidth=%u blks, unwritten=%u\n"
 	    "naming   =version %-14u bsize=%-6u\n"
 	    "log      =%-22s bsize=%-6u blocks=%u, version=%u\n"
-	    "         =%-22s sectsz=%-5u sunit=%u blks\n"
+	    "         =%-22s sectsz=%-5u sunit=%u blks, lazy-count=%u\n"
 	    "realtime =%-22s extsz=%-6u blocks=%llu, rtextents=%llu\n"),
 
 		mntpoint, geo.inodesize, geo.agcount, geo.agblocks,
@@ -81,7 +82,7 @@ report_info(
   		dirversion, geo.dirblocksize,
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
-		"", geo.logsectsize, geo.logsunit / geo.blocksize,
+		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
 		!geo.rtblocks ? _("none") : rtname ? rtname : _("external"),
 		geo.rtextsize * geo.blocksize, (unsigned long long)geo.rtblocks,
 			(unsigned long long)geo.rtextents);
@@ -115,6 +116,7 @@ main(int argc, char **argv)
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
 	int			unwritten; /* unwritten extent flag */
+	int			lazycount; /* lazy superblock counters */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
 	char			*datadev; /* data device name */
@@ -235,6 +237,7 @@ main(int argc, char **argv)
 	}
 	isint = geo.logstart > 0;
 	unwritten = geo.flags & XFS_FSOP_GEOM_FLAGS_EXTFLG ? 1 : 0;
+	lazycount = geo.flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
 	dirversion = geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2 ? 2 : 1;
 	logversion = geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
 	attrversion = geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
@@ -242,7 +245,8 @@ main(int argc, char **argv)
 
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
-				unwritten, dirversion, logversion, attrversion);
+				unwritten, lazycount, dirversion, logversion,
+				attrversion);
 		exit(0);
 	}
 
@@ -278,7 +282,8 @@ main(int argc, char **argv)
 	}
 
 	report_info(geo, datadev, isint, logdev, rtdev,
-			unwritten, dirversion, logversion, attrversion);
+			unwritten, lazycount, dirversion, logversion,
+			attrversion);
 
 	ddsize = xi.dsize;
 	dlsize = ( xi.logBBsize? xi.logBBsize :
Index: xfs-cmds/xfsprogs/include/xfs_fs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_fs.h	2007-02-08 00:43:21.546422620 +1100
+++ xfs-cmds/xfsprogs/include/xfs_fs.h	2007-04-03 14:52:51.731770597 +1000
@@ -240,6 +240,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 
 
 /*
Index: xfs-cmds/xfsprogs/include/xfs_sb.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_sb.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_sb.h	2007-04-03 14:52:51.739769552 +1000
@@ -87,7 +87,8 @@ struct xfs_mount;
 							   PROM and SASH */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
-	(XFS_SB_VERSION2_ATTR2BIT)
+	(XFS_SB_VERSION2_ATTR2BIT |	\
+	 XFS_SB_VERSION2_LAZYSBCOUNTBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -189,6 +190,9 @@ typedef enum {
 #define XFS_SB_SHARED_VN	XFS_SB_MVAL(SHARED_VN)
 #define XFS_SB_UNIT		XFS_SB_MVAL(UNIT)
 #define XFS_SB_WIDTH		XFS_SB_MVAL(WIDTH)
+#define XFS_SB_ICOUNT		XFS_SB_MVAL(ICOUNT)
+#define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
+#define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
@@ -196,7 +200,7 @@ typedef enum {
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
 
 
 /*
@@ -428,6 +432,13 @@ static inline int xfs_sb_version_hasmore
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
+#define XFS_SB_VERSION_LAZYSBCOUNT(sbp)	xfs_sb_version_haslazysbcount(sbp)
+static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_HASMOREBITS(sbp) &&
+		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
+}
+
 #define XFS_SB_VERSION_HASATTR2(sbp)	xfs_sb_version_hasattr2(sbp)
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
Index: xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
===================================================================
--- xfs-cmds.orig/xfsprogs/mkfs/xfs_mkfs.c	2006-12-22 11:49:54.000000000 +1100
+++ xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c	2007-04-03 14:52:51.771765371 +1000
@@ -118,6 +118,8 @@ char	*lopts[] = {
 	"file",
 #define	L_NAME		10
 	"name",
+#define	L_LAZYSBCNTR	11
+	"lazy-count",
 	NULL
 };
 
@@ -602,6 +604,7 @@ main(
 	libxfs_init_t		xi;
 	int 			xlv_dsunit;
 	int			xlv_dswidth;
+	int			lazy_sb_counters;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -631,6 +634,7 @@ main(
 	extent_flagging = 1;
 	force_overwrite = 0;
 	worst_freelist = 0;
+	lazy_sb_counters = 0;
 	bzero(&fsx, sizeof(fsx));
 
 	bzero(&xi, sizeof(xi));
@@ -1082,6 +1086,15 @@ main(
 						libxfs_highbit32(lsectorsize);
 					lssflag = 1;
 					break;
+				case L_LAZYSBCNTR:
+					if (!value)
+						reqval('l', lopts,
+								L_LAZYSBCNTR);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "l lazy-count");
+					lazy_sb_counters = c;
+					break;
 				default:
 					unknown('l', value);
 				}
@@ -1914,7 +1927,7 @@ an AG size that is one stripe unit small
 		   "         =%-22s sunit=%-6u swidth=%u blks, unwritten=%u\n"
 		   "naming   =version %-14u bsize=%-6u\n"
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
-		   "         =%-22s sectsz=%-5u sunit=%d blks\n"
+		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion,
@@ -1923,7 +1936,7 @@ an AG size that is one stripe unit small
 			"", dsunit, dswidth, extent_flagging,
 			dirversion, dirversion == 1 ? blocksize : dirblocksize,
 			logfile, 1 << blocklog, (long long)logblocks,
-			logversion, "", lsectorsize, lsunit,
+			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
 			(long long)rtblocks, (long long)rtextents);
 		if (Nflag)
@@ -1985,7 +1998,7 @@ an AG size that is one stripe unit small
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
-	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(0, attrversion == 2, 0);
+	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(lazy_sb_counters, attrversion == 2, 0);
 	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(
 			iaflag, dsunit != 0, extent_flagging,
 			dirversion == 2, logversion == 2, attrversion == 1,
@@ -2457,7 +2470,8 @@ usage( void )
 			    sectlog=n|sectsize=num,unwritten=0|1]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-			    sunit=value|su=num,sectlog=n|sectsize=num]\n\
+			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
+			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
 /* naming */		[-n log=n|size=num,version=n]\n\
 /* prototype file */	[-p fname]\n\
Index: xfs-cmds/xfsprogs/repair/phase5.c
===================================================================
--- xfs-cmds.orig/xfsprogs/repair/phase5.c	2006-11-15 19:00:34.000000000 +1100
+++ xfs-cmds/xfsprogs/repair/phase5.c	2007-04-03 14:52:51.795762235 +1000
@@ -333,6 +333,10 @@ write_cursor(bt_status_t *curs)
 #endif
 		if (curs->level[i].prev_buf_p != NULL)  {
 			ASSERT(curs->level[i].prev_agbno != NULLAGBLOCK);
+#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
+			fprintf(stderr, "writing bt prev block %u\n",
+						curs->level[i].prev_agbno);
+#endif
 			libxfs_writebuf(curs->level[i].prev_buf_p, 0);
 		}
 		libxfs_writebuf(curs->level[i].buf_p, 0);
@@ -1285,6 +1289,24 @@ build_agf_agfl(xfs_mount_t	*mp,
 			bcnt_bt->num_levels);
 	INT_SET(agf->agf_freeblks, ARCH_CONVERT, freeblks);
 
+	/*
+	 * Count and record the number of btree blocks consumed if required.
+	 */
+	if (XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb)) {
+		/*
+		 * Don't count the root blocks as they are already
+		 * accounted for.
+		 */
+		INT_SET(agf->agf_btreeblks, ARCH_CONVERT,
+			(bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
+			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) -
+			2);
+#ifdef XR_BLD_FREE_TRACE
+		fprintf(stderr, "agf->agf_btreeblks = %u\n",
+				INT_GET(agf->agf_btreeblks, ARCH_CONVERT));
+#endif
+	}
+
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "bno root = %u, bcnt root = %u, indices = %u %u\n",
 			INT_GET(agf->agf_roots[XFS_BTNUM_BNO], ARCH_CONVERT),
Index: xfs-cmds/xfsprogs/include/xfs_mount.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_mount.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_mount.h	2007-04-03 14:52:51.799761713 +1000
@@ -383,7 +383,7 @@ typedef struct xfs_mount {
 						   for space allocations */
 #define	XFS_MOUNT_INO64		(1ULL << 1)
 			     /* (1ULL << 2)	-- currently unused */
-			     /* (1ULL << 3)	-- currently unused */
+#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
 						   disk errors in metadata */
@@ -460,6 +460,8 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 
 #define XFS_MAXIOFFSET(mp)	((mp)->m_maxioffset)
 
+#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
+				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
 #define xfs_force_shutdown(m,f)	\
 	VFS_FORCE_SHUTDOWN((XFS_MTOVFS(m)), f, __FILE__, __LINE__)
@@ -540,6 +542,7 @@ typedef struct xfs_mod_sb {
 
 extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
+extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern void	xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
 extern int	xfs_mountfs(struct vfs *, xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
Index: xfs-cmds/xfsprogs/include/xfs_trans.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_trans.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_trans.h	2007-04-03 14:52:51.803761190 +1000
@@ -98,7 +98,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_GROWFSRT_ZERO		38
 #define	XFS_TRANS_GROWFSRT_FREE		39
 #define	XFS_TRANS_SWAPEXT		40
-#define	XFS_TRANS_TYPE_MAX		40
+#define	XFS_TRANS_SB_COUNT		41
+#define	XFS_TRANS_TYPE_MAX		41
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 
Index: xfs-cmds/xfsprogs/include/xfs_ag.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ag.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_ag.h	2007-04-03 14:52:51.811760145 +1000
@@ -68,6 +68,7 @@ typedef struct xfs_agf {
 	__be32		agf_flcount;	/* count of blocks in freelist */
 	__be32		agf_freeblks;	/* total free blocks */
 	__be32		agf_longest;	/* longest free space */
+	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -81,7 +82,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FLCOUNT		0x00000100
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
-#define	XFS_AGF_NUM_BITS	11
+#define	XFS_AGF_BTREEBLKS	0x00000800
+#define	XFS_AGF_NUM_BITS	12
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 /* disk block (xfs_daddr_t) in the AG */
@@ -186,11 +188,13 @@ typedef struct xfs_perag
 	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
+	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
+	xfs_agino_t	pagi_count;	/* number of allocated inodes */
+	int		pagb_count;	/* pagb slots in use */
 #ifdef __KERNEL__
 	lock_t		pagb_lock;	/* lock for pagb_list */
 #endif
-	int		pagb_count;	/* pagb slots in use */
 	xfs_perag_busy_t *pagb_list;	/* unstable blocks */
 } xfs_perag_t;
 
Index: xfs-cmds/xfsprogs/include/xfs_ialloc.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_ialloc.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_ialloc.h	2007-04-03 14:52:51.815759622 +1000
@@ -149,6 +149,16 @@ xfs_ialloc_read_agi(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	struct xfs_buf	**bpp);		/* allocation group hdr buf */
 
+/*
+ * Read in the allocation group header to initialise the per-ag data
+ * in the mount structure
+ */
+int
+xfs_ialloc_pagi_init(
+	struct xfs_mount *mp,		/* file system mount structure */
+	struct xfs_trans *tp,		/* transaction pointer */
+        xfs_agnumber_t  agno);		/* allocation group number */
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_IALLOC_H__ */
Index: xfs-cmds/xfsprogs/include/xfs_alloc.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/xfs_alloc.h	2006-11-15 19:00:30.000000000 +1100
+++ xfs-cmds/xfsprogs/include/xfs_alloc.h	2007-04-03 14:52:51.815759622 +1000
@@ -114,7 +114,8 @@ int				/* error */
 xfs_alloc_get_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop);	/* block address retrieved from freelist */
+	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	int		btreeblk); /* destination is a AGF btree */
 
 /*
  * Log the given fields from the agf structure.
@@ -143,7 +144,8 @@ xfs_alloc_put_freelist(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*agbp,	/* buffer for a.g. freelist header */
 	struct xfs_buf	*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t	bno);	/* block being freed */
+	xfs_agblock_t	bno,	/* block being freed */
+	int		btreeblk); /* owner was a AGF btree */
 
 /*
  * Read in the allocation group header (free/alloc section).
Index: xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_alloc_btree.c	2006-11-15 19:00:31.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c	2007-04-03 14:52:51.839756487 +1000
@@ -188,7 +188,7 @@ xfs_alloc_delrec(
 			 * Put this buffer/block on the ag's freelist.
 			 */
 			if ((error = xfs_alloc_put_freelist(cur->bc_tp,
-					cur->bc_private.a.agbp, NULL, bno)))
+					cur->bc_private.a.agbp, NULL, bno, 1)))
 				return error;
 			/*
 			 * Since blocks move to the free list without the
@@ -513,7 +513,7 @@ xfs_alloc_delrec(
 	 * Free the deleting block by putting it on the freelist.
 	 */
 	if ((error = xfs_alloc_put_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			NULL, rbno)))
+			NULL, rbno, 1)))
 		return error;
 	/*
 	 * Since blocks move to the free list without the coordination
@@ -1279,7 +1279,7 @@ xfs_alloc_newroot(
 	 * Get a buffer from the freelist blocks, for the new root.
 	 */
 	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&nbno)))
+			&nbno, 1)))
 		return error;
 	/*
 	 * None available, we fail.
@@ -1563,7 +1563,7 @@ xfs_alloc_split(
 	 * If we can't do it, we're toast.  Give up.
 	 */
 	if ((error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
-			&rbno)))
+			&rbno, 1)))
 		return error;
 	if (rbno == NULLAGBLOCK) {
 		*stat = 0;
Index: xfs-cmds/xfsprogs/libxfs/xfs_alloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_alloc.c	2006-11-15 19:00:31.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/xfs_alloc.c	2007-04-03 14:52:51.843755964 +1000
@@ -1355,7 +1355,8 @@ xfs_alloc_ag_vextent_small(
 	else if (args->minlen == 1 && args->alignment == 1 && !args->isfl &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
-		if ((error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno)))
+		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
 			if (args->userdata) {
@@ -1819,7 +1820,7 @@ xfs_alloc_fix_freelist(
 	while (be32_to_cpu(agf->agf_flcount) > need) {
 		xfs_buf_t	*bp;
 
-		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno)))
+		if ((error = xfs_alloc_get_freelist(tp, agbp, &bno, 0)))
 			return error;
 		if ((error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1)))
 			return error;
@@ -1865,7 +1866,7 @@ xfs_alloc_fix_freelist(
 		 */
 		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
 			if ((error = xfs_alloc_put_freelist(tp, agbp, agflbp,
-					bno)))
+					bno, 0)))
 				return error;
 		}
 	}
@@ -1882,13 +1883,15 @@ int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop)	/* block address retrieved from freelist */
+	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	int		btreeblk) /* destination is a AGF btree */
 {
 	xfs_agf_t	*agf;	/* a.g. freespace structure */
 	xfs_agfl_t	*agfl;	/* a.g. freelist structure */
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	int		error;
+	int		logflags;
 #ifdef XFS_ALLOC_TRACE
 	static char	fname[] = "xfs_alloc_get_freelist";
 #endif
@@ -1923,8 +1926,16 @@ xfs_alloc_get_freelist(
 	be32_add(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
-	TRACE_MODAGF(NULL, agf, XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT);
-	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT);
+
+	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
+	if (btreeblk) {
+		be32_add(&agf->agf_btreeblks, 1);
+		pag->pagf_btreeblks++;
+		logflags |= XFS_AGF_BTREEBLKS;
+	}
+
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
 
 	/*
@@ -1962,6 +1973,7 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_flcount),
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
+		offsetof(xfs_agf_t, agf_btreeblks),
 		sizeof(xfs_agf_t)
 	};
 
@@ -1997,12 +2009,14 @@ xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
 	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
 	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t		bno)	/* block being freed */
+	xfs_agblock_t		bno,	/* block being freed */
+	int			btreeblk) /* block came from a AGF btree */
 {
 	xfs_agf_t		*agf;	/* a.g. freespace structure */
 	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	xfs_agblock_t		*blockp;/* pointer to array entry */
 	int			error;
+	int			logflags;
 #ifdef XFS_ALLOC_TRACE
 	static char		fname[] = "xfs_alloc_put_freelist";
 #endif
@@ -2023,11 +2037,19 @@ xfs_alloc_put_freelist(
 	be32_add(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
+
+	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
+	if (btreeblk) {
+		be32_add(&agf->agf_btreeblks, -1);
+		pag->pagf_btreeblks--;
+		logflags |= XFS_AGF_BTREEBLKS;
+	}
+
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
 	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
-	INT_SET(*blockp, ARCH_CONVERT, bno);
-	TRACE_MODAGF(NULL, agf, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
-	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);
+  	INT_SET(*blockp, ARCH_CONVERT, bno);
+	TRACE_MODAGF(NULL, agf, logflags);
+	xfs_alloc_log_agf(tp, agbp, logflags);
 	xfs_trans_log_buf(tp, agflbp,
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
 		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
@@ -2048,6 +2070,7 @@ xfs_alloc_read_agf(
 {
 	xfs_agf_t	*agf;		/* ag freelist header */
 	int		agf_ok;		/* set if agf is consistent */
+	int		agf_length;	/* ag length from agf */
 	xfs_buf_t	*bp;		/* return value */
 	xfs_perag_t	*pag;		/* per allocation group data */
 	int		error;
@@ -2070,10 +2093,12 @@ xfs_alloc_read_agf(
 	 * Validate the magic number of the agf block.
 	 */
 	agf = XFS_BUF_TO_AGF(bp);
+	agf_length = be32_to_cpu(agf->agf_length);
 	agf_ok =
 		be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC &&
 		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
+		be32_to_cpu(agf->agf_freeblks) <= agf_length &&
+		be32_to_cpu(agf->agf_btreeblks) <= agf_length &&
 		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
 		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
@@ -2087,6 +2112,7 @@ xfs_alloc_read_agf(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
+		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
@@ -2101,6 +2127,7 @@ xfs_alloc_read_agf(
 #ifdef DEBUG
 	else if (!XFS_FORCED_SHUTDOWN(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
+		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
 		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
 		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
Index: xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_ialloc.c	2006-11-15 19:00:32.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c	2007-04-03 14:52:51.851754919 +1000
@@ -1128,6 +1128,7 @@ xfs_ialloc_read_agi(
 	pag = &mp->m_perag[agno];
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
+		pag->pagi_count = be32_to_cpu(agi->agi_count);
 		pag->pagi_init = 1;
 	} else {
 		/*
@@ -1135,6 +1136,7 @@ xfs_ialloc_read_agi(
 		 * we are in the middle of a forced shutdown.
 		 */
 		ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
+			pag->pagi_count == be32_to_cpu(agi->agi_count) ||
 			XFS_FORCED_SHUTDOWN(mp));
 	}
 
@@ -1151,3 +1153,22 @@ xfs_ialloc_read_agi(
 	*bpp = bp;
 	return 0;
 }
+
+/*
+ * Read in the agi to initialise the per-ag data in the mount structure
+ */
+int
+xfs_ialloc_pagi_init(
+	xfs_mount_t	*mp,		/* file system mount structure */
+	xfs_trans_t	*tp,		/* transaction pointer */
+	xfs_agnumber_t	agno)		/* allocation group number */
+{
+	xfs_buf_t	*bp = NULL;
+	int		error;
+
+	if ((error = xfs_ialloc_read_agi(mp, tp, agno, &bp)))
+		return error;
+	if (bp)
+		xfs_trans_brelse(tp, bp);
+	return 0;
+}
Index: xfs-cmds/xfsprogs/libxfs/xfs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs.h	2006-11-15 19:00:31.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/xfs.h	2007-04-03 14:52:51.851754919 +1000
@@ -86,6 +86,7 @@
 
 #define xfs_mount_common		libxfs_mount_common
 #define xfs_initialize_perag		libxfs_initialize_perag
+#define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_rtmount_init		libxfs_rtmount_init
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
 #define xfs_idata_realloc		libxfs_idata_realloc
@@ -352,10 +353,10 @@ static inline int __do_div(unsigned long
  */
 
 /* xfs_alloc.c */
-int  xfs_alloc_get_freelist (xfs_trans_t *, xfs_buf_t *, xfs_agblock_t *);
+int  xfs_alloc_get_freelist (xfs_trans_t *, xfs_buf_t *, xfs_agblock_t *, int);
 void xfs_alloc_log_agf (xfs_trans_t *, xfs_buf_t *, int);
 int  xfs_alloc_put_freelist (xfs_trans_t *, xfs_buf_t *, xfs_buf_t *,
-			xfs_agblock_t);
+			xfs_agblock_t, int);
 int  xfs_alloc_read_agf (xfs_mount_t *, xfs_trans_t *, xfs_agnumber_t,
 			int, xfs_buf_t **);
 int  xfs_alloc_vextent (xfs_alloc_arg_t *);
@@ -372,6 +373,7 @@ int  xfs_dialloc (xfs_trans_t *, xfs_ino
 void xfs_ialloc_log_agi (xfs_trans_t *, xfs_buf_t *, int);
 int  xfs_ialloc_read_agi (xfs_mount_t *, xfs_trans_t *, xfs_agnumber_t,
 			xfs_buf_t **);
+int  xfs_ialloc_pagi_init (xfs_mount_t *, xfs_trans_t *, xfs_agnumber_t);
 int  xfs_dilocate (xfs_mount_t *, xfs_trans_t *, xfs_ino_t, xfs_fsblock_t *,
 			int *, int *, uint);
 
Index: xfs-cmds/xfsprogs/libxfs/xfs_mount.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/xfs_mount.c	2006-11-15 19:00:32.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/xfs_mount.c	2007-04-03 14:52:51.859753874 +1000
@@ -313,3 +313,56 @@ xfs_initialize_perag(xfs_mount_t *mp, xf
 	}
 	return index;
 }
+
+/*
+ * xfs_initialize_perag_data
+ *
+ * Read in each per-ag structure so we can count up the number of
+ * allocated inodes, free inodes and used filesystem blocks as this
+ * information is no longer persistent in the superblock. Once we have
+ * this information, write it into the in-core superblock structure.
+ */
+STATIC int
+xfs_initialize_perag_data(xfs_mount_t *mp, xfs_agnumber_t agcount)
+{
+	xfs_agnumber_t	index;
+	xfs_perag_t	*pag;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	__uint64_t	ifree = 0;
+	__uint64_t	ialloc = 0;
+	__uint64_t	bfree = 0;
+	__uint64_t	bfreelst = 0;
+	__uint64_t	btree = 0;
+	int		error;
+	int		s;
+
+	for (index = 0; index < agcount; index++) {
+		/*
+		 * read the agf, then the agi. This gets us
+		 * all the information we need and populates the
+		 * per-ag structures for us.
+		 */
+		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
+		if (error)
+			return error;
+
+		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		if (error)
+			return error;
+		pag = &mp->m_perag[index];
+		ifree += pag->pagi_freecount;
+		ialloc += pag->pagi_count;
+		bfree += pag->pagf_freeblks;
+		bfreelst += pag->pagf_flcount;
+		btree += pag->pagf_btreeblks;
+	}
+	/*
+	 * Overwrite incore superblock counters with just-read data
+	 */
+	s = XFS_SB_LOCK(mp);
+	sbp->sb_ifree = ifree;
+	sbp->sb_icount = ialloc;
+	sbp->sb_fdblocks = bfree + bfreelst + btree;
+	XFS_SB_UNLOCK(mp, s);
+	return 0;
+}
Index: xfs-cmds/xfsprogs/include/libxfs.h
===================================================================
--- xfs-cmds.orig/xfsprogs/include/libxfs.h	2006-12-22 11:49:54.000000000 +1100
+++ xfs-cmds/xfsprogs/include/libxfs.h	2007-04-03 14:52:51.863753351 +1000
@@ -197,6 +197,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mo
 				dev_t, dev_t, dev_t, int);
 extern void	libxfs_mount_common (xfs_mount_t *, xfs_sb_t *);
 extern xfs_agnumber_t	libxfs_initialize_perag (xfs_mount_t *, xfs_agnumber_t);
+extern int	libxfs_initialize_perag_data (xfs_mount_t *, xfs_agnumber_t);
 extern void	libxfs_umount (xfs_mount_t *);
 extern int	libxfs_rtmount_init (xfs_mount_t *);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
Index: xfs-cmds/xfsprogs/libxfs/init.c
===================================================================
--- xfs-cmds.orig/xfsprogs/libxfs/init.c	2006-12-22 11:49:54.000000000 +1100
+++ xfs-cmds/xfsprogs/libxfs/init.c	2007-04-03 14:52:51.879751261 +1000
@@ -649,6 +649,20 @@ libxfs_mount(
 		libxfs_iput(mp->m_rootip, 0);
 		return NULL;
 	}
+
+	/*
+	 * mkfs calls mount before the AGF/AGI structures are written.
+	 */
+	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
+	    XFS_SB_VERSION_LAZYSBCOUNT(&mp->m_sb)) {
+		error = libxfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error) {
+			fprintf(stderr, _("%s: cannot init perag data (%d)\n"),
+				progname, error);
+			return NULL;
+		}
+	}
+
 	return mp;
 }
 
Index: xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8
===================================================================
--- xfs-cmds.orig/xfsprogs/man/man8/mkfs.xfs.8	2006-11-15 19:00:33.000000000 +1100
+++ xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8	2007-04-03 14:52:51.907747603 +1000
@@ -335,8 +335,9 @@ The valid suboptions are:
 \f3logdev=\f1\f2device\f1,
 \f3size=\f1\f2value\f1,
 \f3version=\f1\f2[1|2]\f1,
-\f3sunit=\f1\f2value\f1, and
-\f3su=\f1\f2value\f1.
+\f3sunit=\f1\f2value\f1,
+\f3su=\f1\f2value\f1 and
+\f3lazy-count=\f1\f2[0|1]\f1.
 .IP
 The
 .B internal
@@ -415,6 +416,24 @@ The suboption value has to be specified 
 This value must be a multiple of the filesystem block size.
 Version 2 logs are automatically selected if the log \f3su\f1
 suboption is specified.
+.IP
+The
+.B lazy-count
+suboption changes the method of logging various persistent counters
+in the superblock.  Under metadata intensive workloads, these
+counters are updated and logged frequently enough that the
+superblock updates become a serialisation point in the filesystem.
+.IP
+With
+.BR lazy-count=1 ,
+the superblock is not modified or logged on every change of the
+persistent counters. Instead, enough information is kept in
+other parts of the filesystem to be able to maintain the persistent
+counter values without needed to keep them in the superblock.
+This gives significant improvements in performance on some configurations.
+The default value is 0 (off) so you must specify
+.B lazy-count=1
+if you want to make use of this feature.
 .TP
 .B \-n
 Naming options.
