Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27049 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeKJAMq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:46 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFC972D7E5
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:55 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 13/24] xfsdump: (2/4)(style) add first empty line for multiline comments
Date: Fri,  9 Nov 2018 15:29:53 +0100
Message-Id: <20181109143004.24963-14-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Change the multiline comment style from /* foo to /*
 * foo

Created by this script:

#!/usr/bin/env bash
# change the multiline comment style from /* foo to /*
 * foo

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/^\(\s*\)\/\* \(.\+[^*][^/]\)$/\1\/*
\1 * \2/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 dump/content.c | 885 ++++++++++++++++++++++++++++++++-----------------
 dump/getopt.h  |   3 +-
 dump/inomap.c  | 168 ++++++----
 dump/inomap.h  |  27 +-
 dump/var.c     |   9 +-
 5 files changed, 728 insertions(+), 364 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index f351e78..fe52a70 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -71,16 +71,19 @@
 #include "getdents.h"
 #include "arch_xlate.h"
 
-/* max "unsigned long long int"
+/*
+ * max "unsigned long long int"
  */
 #define ULONGLONG_MAX	18446744073709551615LLU
 
-/* legal range of dump levels
+/*
+ * legal range of dump levels
  */
 #define LEVEL_DEFAULT	0
 #define LEVEL_MAX	9
 
-/* ordinary files as big or bigger than this many pages will be
+/*
+ * ordinary files as big or bigger than this many pages will be
  * preceeded in the dump by enough padding to align the first byte
  * of that file's data to a page boundary
  */
@@ -89,15 +92,18 @@
 
 /* structure definitions used locally ****************************************/
 
-/* number of bstats bstat_iter fetches at a time
+/*
+ * number of bstats bstat_iter fetches at a time
  */
 #define BSTATBUFLEN	4096
 
-/* if the source file system type can't be determined, assume it is this
+/*
+ * if the source file system type can't be determined, assume it is this
  */
 #define FS_DEFAULT	"xfs"
 
-/* marks consist of a opaque drive layer cookie and a startpoint.
+/*
+ * marks consist of a opaque drive layer cookie and a startpoint.
  * the drive layer requires that it be passed a pointer to a drive_markrec_t.
  * we tack on content-specific baggage (startpt_t). this works because we
  * allocate and free mark_t's here.
@@ -109,7 +115,8 @@ struct mark {
 
 typedef struct mark mark_t;
 
-/* Media_mfile_begin() entry state.
+/*
+ * Media_mfile_begin() entry state.
  */
 enum bes { BES_INIT,	/* in the beginning */
 	   BES_ENDOK,   /* last media file successfully flushed to media */
@@ -118,81 +125,100 @@ enum bes { BES_INIT,	/* in the beginning */
 
 typedef enum bes bes_t;
 
-/* per-stream context
+/*
+ * per-stream context
  */
 struct context {
 	filehdr_t *cc_filehdrp;
-			/* pre-allocated buffer: heads each dumped file
+			/*
+			 * pre-allocated buffer: heads each dumped file
 			 */
 	extenthdr_t *cc_extenthdrp;
-			/* pre-allocated buffer: heads each dumped file extent
+			/*
+			 * pre-allocated buffer: heads each dumped file extent
 			 */
 	void *cc_inomap_contextp;
-			/* pre-allocated context to speed inomap iteration
+			/*
+			 * pre-allocated context to speed inomap iteration
 			 */
 	char *cc_getdentsbufp;
 	size_t cc_getdentsbufsz;
-			/* pre-allocated buffer for getdents() syscall
+			/*
+			 * pre-allocated buffer for getdents() syscall
 			 */
 	char *cc_mdirentbufp;
 	size_t cc_mdirentbufsz;
-			/* pre-allocated buffer for on-media dirent
+			/*
+			 * pre-allocated buffer for on-media dirent
 			 */
 	char *cc_extattrlistbufp;
 	size_t cc_extattrlistbufsz;
-			/* pre-allocated buffer for retrieving a
+			/*
+			 * pre-allocated buffer for retrieving a
 			 * list of extended file attributes
 			 */
 	attr_multiop_t *cc_extattrrtrvarrayp;
 	size_t cc_extattrrtrvarraylen;
-			/* pre-allocated array of ops for retrieving the
+			/*
+			 * pre-allocated array of ops for retrieving the
 			 * values for a list of extended file attributes
 			 */
 	char *cc_extattrdumpbufp;
 	size_t cc_extattrdumpbufsz;
-			/* pre-allocated buffer for dumping the names and
+			/*
+			 * pre-allocated buffer for dumping the names and
 			 * values for a list of extended file attributes
 			 */
 	hsm_f_ctxt_t *cc_hsm_f_ctxtp;
-			/* pre-allocated HSM context used for holding HSM
+			/*
+			 * pre-allocated HSM context used for holding HSM
 			   state information about a file across subroutine
 			   calls.
 			*/
 	char *cc_readlinkbufp;
 	size_t cc_readlinkbufsz;
-			/* pre-allocated buffer for readlink()
+			/*
+			 * pre-allocated buffer for readlink()
 			 */
 	off64_t cc_mfilesz;
-			/* total bytes dumped to media file
+			/*
+			 * total bytes dumped to media file
 			 */
 	size_t cc_markscommitted;
-			/* number of marks committed in mfile. only useful
+			/*
+			 * number of marks committed in mfile. only useful
 			 * info is if greater than zero.
 			 */
 	xfs_ino_t cc_stat_lastino;
-			/* monotonic strm nondir ino dumped
+			/*
+			 * monotonic strm nondir ino dumped
 			 */
 	bool_t cc_completepr;
-			/* set if stream completely dumped. useful for
+			/*
+			 * set if stream completely dumped. useful for
 			 * determining if dump was interrupted
 			 */
 	bool_t cc_Media_useterminatorpr;
-			/* true if stream terminators are expected and
+			/*
+			 * true if stream terminators are expected and
 			 * will be used
 			 */
 	char *cc_Media_firstlabel;
-			/* optional command line media label. only used
+			/*
+			 * optional command line media label. only used
 			 * for first media object in stream, and only if
 			 * media object does not already have a label
 			 */
 	bes_t cc_Media_begin_entrystate;
-			/* Media_mfile_begin context entry state
+			/*
+			 * Media_mfile_begin context entry state
 			 */
 };
 
 typedef struct context context_t;
 
-/* extent group context, used by dump_file()
+/*
+ * extent group context, used by dump_file()
  */
 #define BMAP_LEN	512
 
@@ -208,29 +234,34 @@ struct extent_group_context {
 typedef struct extent_group_context extent_group_context_t;
 
 
-/* minimum getdents() buffer size
+/*
+ * minimum getdents() buffer size
  */
 #define GETDENTSBUF_SZ_MIN	(2 * pgsz)
 
 
-/* minimum sizes for extended attributes buffers
+/*
+ * minimum sizes for extended attributes buffers
  */
 #define EXTATTR_LISTBUF_SZ	(XATTR_LIST_MAX)
 #define EXTATTR_RTRVARRAY_LEN	(1 * pgsz)
 #define EXTATTR_DUMPBUF_SZ	(4 * pgsz)
 
-/* for printing ext attr namespace
+/*
+ * for printing ext attr namespace
  */
 #define EXTATTR_NAMESPACE(flag)	(((flag) & ATTR_ROOT) ? _("root") : \
 				(((flag) & ATTR_SECURE) ? _("secure") : \
 				  _("non-root")) )
 
-/* for printing file type
+/*
+ * for printing file type
  */
 #define FILETYPE(statp)		(((statp)->bs_mode & S_IFMT) == S_IFDIR \
 				  ? _("dir") : _("nondir"))
 
-/* per-drive status descriptor
+/*
+ * per-drive status descriptor
  */
 struct pds {
 	enum { PDS_NULL,		/* per-drive activity not begun */
@@ -259,7 +290,8 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
-/* file dumpers
+/*
+ * file dumpers
  */
 static rv_t
 dump_dirs(ix_t strmix,
@@ -413,28 +445,35 @@ bool_t allowexcludefiles_pr = BOOL_FALSE;
 /* definition of locally defined static variables *****************************/
 
 static bool_t sc_preerasepr = BOOL_FALSE;
-	/* pre-erase media
+	/*
+	 * pre-erase media
 	 */
 static inv_idbtoken_t sc_inv_idbtoken = INV_TOKEN_NULL;
-	/* handle to inventory
+	/*
+	 * handle to inventory
 	 */
 static inv_sestoken_t sc_inv_sestoken = INV_TOKEN_NULL;
-	/* handle to inventory session
+	/*
+	 * handle to inventory session
 	 */
 static inv_stmtoken_t *sc_inv_stmtokenp = 0;
-	/* array of inventory session stream handles
+	/*
+	 * array of inventory session stream handles
 	 */
 static bool_t sc_inv_updatepr = BOOL_TRUE;
-	/* set if ok to update online inventory with stats of this dump
+	/*
+	 * set if ok to update online inventory with stats of this dump
 	 */
 static ix_t sc_level = LEVEL_DEFAULT;
-	/* dump level requested
+	/*
+	 * dump level requested
 	 */
 static bool_t sc_incrpr = BOOL_FALSE;
 static time32_t sc_incrbasetime;
 static ix_t sc_incrbaselevel;
 static uuid_t sc_incrbaseid;
-	/* if an incremental dump, the base, level and time of the incremental
+	/*
+	 * if an incremental dump, the base, level and time of the incremental
 	 * base dump. TRICKY: if resuming an incremental dump, this is the
 	 * base of the original incremental.
 	 */
@@ -443,75 +482,95 @@ static time32_t sc_resumebasetime = 0;
 static uuid_t sc_resumebaseid;
 static size_t sc_resumerangecnt = 0;
 static drange_t *sc_resumerangep = 0;
-	/* if a resumed dump, the id, time and undumped ino/offset ranges
+	/*
+	 * if a resumed dump, the id, time and undumped ino/offset ranges
 	 * of the interrupted dump being resumed.
 	 */
 static jdm_fshandle_t *sc_fshandlep = 0;
-	/* dmi file system handle
+	/*
+	 * dmi file system handle
 	 */
 static int sc_fsfd = -1;
-	/* open file descriptor for root directory
+	/*
+	 * open file descriptor for root directory
 	 */
 static xfs_bstat_t *sc_rootxfsstatp = 0;
-	/* pointer to loaded bulkstat for root directory
+	/*
+	 * pointer to loaded bulkstat for root directory
 	 */
 static startpt_t *sc_startptp = 0;
-	/* an array of stream ino/offset start points
+	/*
+	 * an array of stream ino/offset start points
 	 */
 static time32_t sc_stat_starttime = 0;
-	/* for cacluating elapsed time
+	/*
+	 * for cacluating elapsed time
 	 */
 static ix_t sc_stat_inomapphase = 0;
 static ix_t sc_stat_inomappass = 0;
 static size64_t sc_stat_inomapcnt;
 static size64_t sc_stat_inomapdone;
 static size64_t sc_stat_dircnt = 0;
-	/* total number of directory inodes to be dumped (strm 0)
+	/*
+	 * total number of directory inodes to be dumped (strm 0)
 	 */
 static pds_t sc_stat_pds[STREAM_SIMMAX];
-	/* per-drive stream status
+	/*
+	 * per-drive stream status
 	 */
 static size64_t sc_stat_nondircnt = 0;
-	/* total number of non-directory inodes to be dumped (all strms)
+	/*
+	 * total number of non-directory inodes to be dumped (all strms)
 	 */
 static size64_t sc_stat_nondirdone = 0;
-	/* total number of non-directory inodes dumped (all strms)
+	/*
+	 * total number of non-directory inodes dumped (all strms)
 	 */
 static size64_t sc_stat_datasz = 0;
-	/* total size in bytes of non-dirs to be dumped (all strms)
+	/*
+	 * total size in bytes of non-dirs to be dumped (all strms)
 	 */
 static size64_t sc_stat_datadone = 0;
-	/* total size in bytes of non-dirs dumped (all strms)
+	/*
+	 * total size in bytes of non-dirs dumped (all strms)
 	 */
 static size_t sc_thrdsarrivedcnt = 0;
-	/* each thread checks in by bumping this count under lock.
+	/*
+	 * each thread checks in by bumping this count under lock.
 	 * used to decide when its ok to begin waiting for all threads
 	 * to arrive at sync pt for session inventory dump.
 	 */
 static size_t sc_thrdsdonecnt = 0;
-	/* number of threads which are ready to dump the session inventory.
+	/*
+	 * number of threads which are ready to dump the session inventory.
 	 * when equal to the number of streams remaining (stream_cnt()),
 	 * can proceed with inventory dumps
 	 */
 static context_t *sc_contextp;
-	/* an array of per-stream context descriptors
+	/*
+	 * an array of per-stream context descriptors
 	 */
 static bool_t sc_mcflag[STREAM_SIMMAX];
-	/* media change flag
+	/*
+	 * media change flag
 	 */
 static bool_t sc_dumpextattrpr = BOOL_TRUE;
-	/* dump extended attributes
+	/*
+	 * dump extended attributes
 	 */
 static bool_t sc_dumpasoffline = BOOL_FALSE;
-	/* dump dual-residency HSM files as offline
+	/*
+	 * dump dual-residency HSM files as offline
 	 */
 static bool_t sc_use_old_direntpr = BOOL_FALSE;
-	/* dump dirents as dirent_v1_t instead of dirent_t
+	/*
+	 * dump dirents as dirent_v1_t instead of dirent_t
 	 * (for compat with dump format 2)
 	 */
 
 static bool_t sc_savequotas = BOOL_TRUE;
-/* save quota information in dump
+/*
+ * save quota information in dump
  */
 static quota_info_t quotas[] = {
 	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
@@ -584,7 +643,8 @@ content_init(int argc,
 	uint64_t filesz;
 	uint64_t size_estimate;
 
-	/* basic sanity checks
+	/*
+	 * basic sanity checks
 	 */
 	assert(sizeof(mode_t) == MODE_SZ);
 	assert(sizeof(timestruct_t) == TIMESTRUCT_SZ);
@@ -599,7 +659,8 @@ content_init(int argc,
 		sizeof(content_inode_hdr_t));
 	assert(sizeof(extattrhdr_t) == EXTATTRHDR_SZ);
 
-	/* calculate offsets of portions of the write hdr template
+	/*
+	 * calculate offsets of portions of the write hdr template
 	 */
 	dwhdrtemplatep = (drive_hdr_t *)gwhdrtemplatep->gh_upper;
 	mwhdrtemplatep = (media_hdr_t *)dwhdrtemplatep->dh_upper;
@@ -610,7 +671,8 @@ content_init(int argc,
 		sc_use_old_direntpr = BOOL_TRUE;
 	}
 
-	/* process command line args
+	/*
+	 * process command line args
 	 */
 	optind = 1;
 	opterr = 0;
@@ -736,7 +798,8 @@ content_init(int argc,
 		return BOOL_FALSE;
 	}
 
-	/* the user may specify stdout as the destination, by a single
+	/*
+	 * the user may specify stdout as the destination, by a single
 	 * dash ('-') with no option letter. This must appear between
 	 * all lettered arguments and the source file system pathname.
 	 */
@@ -744,7 +807,8 @@ content_init(int argc,
 		optind++;
 	}
 
-	/* the last argument must be either the mount point or a
+	/*
+	 * the last argument must be either the mount point or a
 	 * device pathname of the file system to be dumped.
 	 */
 	if (optind >= argc) {
@@ -760,7 +824,8 @@ content_init(int argc,
 		return BOOL_FALSE;
 	}
 
-	/* allocate space for the subtree pointer array and load it
+	/*
+	 * allocate space for the subtree pointer array and load it
 	 */
 	if (subtreecnt) {
 		subtreep = (char **)calloc(subtreecnt, sizeof(char *));
@@ -782,7 +847,8 @@ content_init(int argc,
 		subtreep = 0;
 	}
 
-	/* call a magic function to figure out if the last argument is
+	/*
+	 * call a magic function to figure out if the last argument is
 	 * a mount point or a device pathname, and retrieve the file
 	 * system type, full pathname of the character special device
 	 * containing the file system, the latest mount point, and the file
@@ -806,7 +872,8 @@ content_init(int argc,
 		return BOOL_FALSE;
 	}
 
-	/* verify that the file system is mounted. This must be enhanced
+	/*
+	 * verify that the file system is mounted. This must be enhanced
 	 * to mount an unmounted file system on a temporary mount point,
 	 * if it is not currently mounted.
 	 */
@@ -817,7 +884,8 @@ content_init(int argc,
 		return BOOL_FALSE;
 	}
 
-	/* place the fs info in the write hdr template
+	/*
+	 * place the fs info in the write hdr template
 	 */
 	(void)strncpyterm(cwhdrtemplatep->ch_mntpnt,
 			     mntpnt,
@@ -859,11 +927,13 @@ content_init(int argc,
 	}
 
 
-	/* create my /var directory if it doesn't already exist.
+	/*
+	 * create my /var directory if it doesn't already exist.
 	 */
 	var_create();
 
-	/* get two session descriptors from the inventory: one for the last
+	/*
+	 * get two session descriptors from the inventory: one for the last
 	 * dump at this level, and one for the last dump at a lower level.
 	 * the former will be used to check if the last dump at this level
 	 * was prematurely terminated; if so, for those inos already dumped
@@ -875,14 +945,16 @@ content_init(int argc,
 		return BOOL_FALSE;
 	}
 
-	/* briefly open the online dump inventory, so it can be used
+	/*
+	 * briefly open the online dump inventory, so it can be used
 	 * to calculate incremental and resumed dumps.
 	 */
 	inv_idbt = inv_open((inv_predicate_t)INV_BY_UUID,
 			     INV_SEARCH_ONLY,
 			     (void *)&fsid);
 
-	/* if a based request, look for the indicated session.
+	/*
+	 * if a based request, look for the indicated session.
 	 * if found, and not interrupted, this will be used as an
 	 * incremental base. if interrupted, will be used as
 	 * resume base.
@@ -966,7 +1038,8 @@ content_init(int argc,
 						      p->dr_begin.sp_offset);
 					}
 				} else {
-					/* set the range start pt's END flag to
+					/*
+					 * set the range start pt's END flag to
 					 * indicate the range was not interrupted.
 					 */
 					p->dr_begin.sp_flags = STARTPT_FLAGS_END;
@@ -998,7 +1071,8 @@ content_init(int argc,
 		goto baseuuidbypass;
 	}
 
-	/* look for the most recent dump at a level less than the level
+	/*
+	 * look for the most recent dump at a level less than the level
 	 * of this dump. extract the time, level, id, and predicates partial
 	 * and interrupted.
 	 */
@@ -1042,7 +1116,8 @@ content_init(int argc,
 		}
 	}
 
-	/* look for the most recent dump at a level equal to the level
+	/*
+	 * look for the most recent dump at a level equal to the level
 	 * of this dump. extract the time, level, id, and predicates partial
 	 * and interrupted, and for each stream the range of ino/offset
 	 * values not dumped.
@@ -1112,7 +1187,8 @@ content_init(int argc,
 					      p->dr_begin.sp_offset);
 				}
 			} else {
-				/* set the range start pt's END flag to
+				/*
+				 * set the range start pt's END flag to
 				 * indicate the range was not interrupted.
 				 */
 				p->dr_begin.sp_flags = STARTPT_FLAGS_END;
@@ -1125,7 +1201,8 @@ content_init(int argc,
 
 baseuuidbypass:
 
-	/* now determine the incremental and resume bases, if any.
+	/*
+	 * now determine the incremental and resume bases, if any.
 	 */
 	if (samefoundpr && ! sameinterruptedpr) {
 		free((void *)sc_resumerangep);
@@ -1292,7 +1369,8 @@ baseuuidbypass:
 		}
 	}
 
-	/* don't allow interrupted dumps of a lesser level to be bases
+	/*
+	 * don't allow interrupted dumps of a lesser level to be bases
 	 */
 	if (sc_incrpr && underinterruptedpr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1303,7 +1381,8 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* reject if resume (-R) specified, but base was not interrupted
+	/*
+	 * reject if resume (-R) specified, but base was not interrupted
 	 */
 	if (! sc_resumepr && resumereqpr) {
 		mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1313,7 +1392,8 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* announce the dump characteristics
+	/*
+	 * announce the dump characteristics
 	 */
 	if (sc_incrpr) {
 		if (sc_resumepr) {
@@ -1366,13 +1446,15 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* announce the dump time
+	/*
+	 * announce the dump time
 	 */
 	mlog(MLOG_VERBOSE, _(
 	      "dump date: %s\n"),
 	      ctimennl(&gwhdrtemplatep->gh_timestamp));
 
-	/* display the session UUID
+	/*
+	 * display the session UUID
 	 */
 	{
 		char string_uuid[UUID_STR_LEN + 1];
@@ -1382,13 +1464,15 @@ baseuuidbypass:
 		      string_uuid);
 	}
 
-	/* display the session label
+	/*
+	 * display the session label
 	 */
 	mlog(MLOG_VERBOSE, _(
 	      "session label: \"%s\"\n"),
 	      gwhdrtemplatep->gh_dumplabel);
 
-	/* get a file descriptor for the file system. any file
+	/*
+	 * get a file descriptor for the file system. any file
 	 * contained in the file system will do; use the mntpnt.
 	 * needed by bigstat.
 	 */
@@ -1401,7 +1485,8 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* figure out the ino for the root directory of the fs
+	/*
+	 * figure out the ino for the root directory of the fs
 	 * and get its xfs_bstat_t for inomap_build().  This could
 	 * be a bind mount; don't ask for the mount point inode,
 	 * find the actual lowest inode number in the filesystem.
@@ -1441,7 +1526,8 @@ baseuuidbypass:
 			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 
-	/* alloc a file system handle, to be used with the jdm_open()
+	/*
+	 * alloc a file system handle, to be used with the jdm_open()
 	 * functions.
 	 */
 	sc_fshandlep = jdm_getfshandle(mntpnt);
@@ -1457,7 +1543,8 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* If GETOPT_DUMPASOFFLINE was specified, allocate a filesystem context
+	/*
+	 * If GETOPT_DUMPASOFFLINE was specified, allocate a filesystem context
 	 * for use by the HSM routines.
 	 */
 
@@ -1465,11 +1552,13 @@ baseuuidbypass:
 		hsm_fs_ctxtp = HsmInitFsysContext(mntpnt, HSM_API_VERSION_1);
 	}
 
-	/* set now so statline can be displayed
+	/*
+	 * set now so statline can be displayed
 	 */
 	sc_stat_starttime = gwhdrtemplatep->gh_timestamp;
 
-	/* allocate storage for the stream startpoints, and build inomap.
+	/*
+	 * allocate storage for the stream startpoints, and build inomap.
 	 * inomap_build() also fills in the start points. storage only needed
 	 * until the startpoints are copied into each streams header. will
 	 * be freed at the end of this function.
@@ -1502,12 +1591,14 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* ask var to ask inomap to skip files under var if var is in
+	/*
+	 * ask var to ask inomap to skip files under var if var is in
 	 * the fs being dumped
 	 */
 	var_skip(&fsid, inomap_skip);
 
-	/* fill in write header template content info. always produce
+	/*
+	 * fill in write header template content info. always produce
 	 * an inomap for each media file. the dirdump flag will be set
 	 * in content_stream_dump() for streams which dump the directories.
 	 */
@@ -1548,7 +1639,8 @@ baseuuidbypass:
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
 	inomap_writehdr(scwhdrtemplatep);
 
-	/* log the dump size. just a rough approx.
+	/*
+	 * log the dump size. just a rough approx.
 	 */
 	dircnt = scwhdrtemplatep->cih_inomap_dircnt;
 	nondircnt = scwhdrtemplatep->cih_inomap_nondircnt;
@@ -1587,14 +1679,16 @@ baseuuidbypass:
 	      GLOBAL_HDR_SZ, inomapsz, direntsz,
 	      filesz, datasz);
 
-	/* extract the progress stat denominators from the write hdr
+	/*
+	 * extract the progress stat denominators from the write hdr
 	 * template. placed there by inomap_writehdr()
 	 */
 	sc_stat_dircnt = scwhdrtemplatep->cih_inomap_dircnt;
 	sc_stat_nondircnt = scwhdrtemplatep->cih_inomap_nondircnt;
 	sc_stat_datasz = scwhdrtemplatep->cih_inomap_datasz;
 
-	/* allocate and populate per-stream context descriptors
+	/*
+	 * allocate and populate per-stream context descriptors
 	 */
 	sc_contextp = (context_t *)calloc(drivecnt, sizeof(context_t));
 	assert(sc_contextp);
@@ -1660,7 +1754,8 @@ baseuuidbypass:
 		contextp->cc_inomap_contextp = inomap_alloc_context();
 	}
 
-	/* look for command line media labels. these will be assigned
+	/*
+	 * look for command line media labels. these will be assigned
 	 * to each stream as found. this label is only for the media
 	 * object currently in the drive. subsequently inserted media
 	 * objects must get a label via prompting.
@@ -1709,7 +1804,8 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
-	/* open the dump inventory and a dump inventory write session
+	/*
+	 * open the dump inventory and a dump inventory write session
 	 * if an inventory update is to be done.
 	 */
 	if (sc_inv_updatepr) {
@@ -1733,7 +1829,8 @@ baseuuidbypass:
 		}
 	}
 
-	/* set media change flags to FALSE;
+	/*
+	 * set media change flags to FALSE;
 	 */
 	{
 		ix_t ix;
@@ -1746,7 +1843,8 @@ baseuuidbypass:
 	}
 	content_media_change_needed = BOOL_FALSE;
 
-	/* initialize the per-drive status
+	/*
+	 * initialize the per-drive status
 	 */
 	{
 		ix_t driveix;
@@ -1774,7 +1872,8 @@ content_statline(char **linespp[])
 	struct tm *tmp;
 	ix_t i;
 
-	/* build and supply the line array
+	/*
+	 * build and supply the line array
 	 */
 	for (i = 0; i < STREAM_SIMMAX + 1; i++) {
 		statline[i] = &statlinebuf[i][0];
@@ -1782,22 +1881,26 @@ content_statline(char **linespp[])
 	*linespp = statline;
 	statlinecnt = 0;
 
-	/* if start time not initialized, return no strings
+	/*
+	 * if start time not initialized, return no strings
 	 */
 	if (! sc_stat_starttime) {
 		return 0;
 	}
 
-	/* calculate the elapsed time
+	/*
+	 * calculate the elapsed time
 	 */
 	now = time(0);
 	elapsed = now - sc_stat_starttime;
 
-	/* get local time
+	/*
+	 * get local time
 	 */
 	tmp = localtime(&now);
 
-	/* if inomap phase indicated, report on that
+	/*
+	 * if inomap phase indicated, report on that
 	 */
 	if (sc_stat_inomapphase && sc_stat_inomapcnt) {
 		if (sc_stat_inomappass) {
@@ -1833,7 +1936,8 @@ content_statline(char **linespp[])
 		return 1;
 	}
 
-	/* get the accumulated totals for non-dir inos and data bytes dumped
+	/*
+	 * get the accumulated totals for non-dir inos and data bytes dumped
 	 */
 	lock();
 	nondirdone = sc_stat_nondirdone;
@@ -1842,7 +1946,8 @@ content_statline(char **linespp[])
 
 	/* non-dir dump phase */
 	if (nondirdone || datadone) {
-		/* calculate percentage of data dumped
+		/*
+		 * calculate percentage of data dumped
 		*/
 		if (sc_stat_datasz) {
 			percent = (double)datadone
@@ -1856,7 +1961,8 @@ content_statline(char **linespp[])
 			percent = 100.0;
 		}
 
-		/* format the status line in a local static buffer (non-re-entrant!)
+		/*
+		 * format the status line in a local static buffer (non-re-entrant!)
 		*/
 		sprintf(statline[0],
 				"status at %02d:%02d:%02d: %llu/%llu files dumped, "
@@ -1881,7 +1987,8 @@ content_statline(char **linespp[])
 
 	assert(strlen(statline[0]) < STATLINESZ);
 
-	/* optionally create stat lines for each drive
+	/*
+	 * optionally create stat lines for each drive
 	 */
 	statlinecnt = 1;
 	for (i = 0; i < drivecnt; i++) {
@@ -1983,7 +2090,8 @@ create_inv_session(
 		return BOOL_FALSE;
 	}
 
-	/* open an inventory stream for each stream
+	/*
+	 * open an inventory stream for each stream
 	*/
 	sc_inv_stmtokenp = (inv_stmtoken_t *)
 				calloc(drivecnt, sizeof(inv_stmtoken_t));
@@ -2043,7 +2151,8 @@ mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
 static void
 mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 {
-	/* get context
+	/*
+	 * get context
 	 */
 	ix_t strmix = (ix_t)p;
 	context_t *contextp = &sc_contextp[strmix];
@@ -2055,21 +2164,25 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 				       (void *)
 				       cwhdrp->ch_specific;
 
-	/* this is really a mark_t, allocated by mark_set()
+	/*
+	 * this is really a mark_t, allocated by mark_set()
 	 */
 	mark_t *markp = (mark_t *)dmp;
 
 	if (committed) {
-		/* bump the per-mfile mark committed count
+		/*
+		 * bump the per-mfile mark committed count
 		 */
 		contextp->cc_markscommitted++;
 
-		/* copy the mark into the write header: this establishes the
+		/*
+		 * copy the mark into the write header: this establishes the
 		 * starting point should we need to retry the non-dir portion
 		 * of the dump
 		 */
 
-		/* log the mark commit
+		/*
+		 * log the mark commit
 		 */
 		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
 			mlog(MLOG_DEBUG,
@@ -2100,7 +2213,8 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 			scwhdrp->cih_startpt = markp->startpt;
 		}
 	} else {
-		/* note the mark was not committed
+		/*
+		 * note the mark was not committed
 		 */
 		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
 			mlog(MLOG_DEBUG,
@@ -2117,12 +2231,14 @@ mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 		}
 	}
 
-	/* get rid of this mark (it was allocated by mark_set())
+	/*
+	 * get rid of this mark (it was allocated by mark_set())
 	 */
 	free((void *)markp);
 }
 
-/* begin - called by stream process to invoke the dump stream
+/*
+ * begin - called by stream process to invoke the dump stream
  */
 int
 content_stream_dump(ix_t strmix)
@@ -2144,11 +2260,13 @@ content_stream_dump(ix_t strmix)
 	int rval;
 	rv_t rv;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(RV_OK == 0); /* bigstat_iter depends on this */
 
-	/* allocate a buffer for use by bstat_iter
+	/*
+	 * allocate a buffer for use by bstat_iter
 	 */
 	bstatbufp = (xfs_bstat_t *)calloc(bstatbuflen,
 					     sizeof(xfs_bstat_t));
@@ -2158,18 +2276,21 @@ content_stream_dump(ix_t strmix)
 	inomap_contextp = inomap_alloc_context();
 	assert(inomap_contextp);
 
-	/* determine if stream terminators will be used and are expected.
+	/*
+	 * determine if stream terminators will be used and are expected.
 	 * this will be revised each time a new media file is begun.
 	 */
 	update_cc_Media_useterminatorpr(drivep, contextp);
 
-	/* check in
+	/*
+	 * check in
 	 */
 	lock();
 	sc_thrdsarrivedcnt++;
 	unlock();
 
-	/* fill in write hdr stream start and end points
+	/*
+	 * fill in write hdr stream start and end points
 	 */
 	scwhdrp->cih_startpt = sc_startptp[strmix];
 	if (strmix < drivecnt - 1) {
@@ -2183,25 +2304,30 @@ content_stream_dump(ix_t strmix)
 		scwhdrp->cih_dumpattr |= CIH_DUMPATTR_DIRDUMP;
 	}
 
-	/* fill in inomap fields of write hdr
+	/*
+	 * fill in inomap fields of write hdr
 	 */
 	inomap_writehdr(scwhdrp);
 
-	/* used to decide if any non-dirs not yet on media
+	/*
+	 * used to decide if any non-dirs not yet on media
 	 */
 	all_nondirs_committed = BOOL_FALSE;
 
-	/* used to guarantee we don't count the same ino more than once
+	/*
+	 * used to guarantee we don't count the same ino more than once
 	 * in the progress stats
 	 */
 	contextp->cc_stat_lastino = 0;
 
-	/* used to detect generation of an empty media file;
+	/*
+	 * used to detect generation of an empty media file;
 	 * contains at most an inomap and dirdump and null file hdr.
 	 */
 	empty_mediafile = BOOL_FALSE;
 
-	/* get the inventory stream token
+	/*
+	 * get the inventory stream token
 	 */
 	if (sc_inv_stmtokenp) {
 		inv_stmt = sc_inv_stmtokenp[strmix];
@@ -2209,7 +2335,8 @@ content_stream_dump(ix_t strmix)
 		inv_stmt = INV_TOKEN_NULL;
 	}
 
-	/* loop, dumping media files, until the entire stream is dumped.
+	/*
+	 * loop, dumping media files, until the entire stream is dumped.
 	 * each time we hit EOM/EOF, repeat the inomap and directory dump.
 	 * dump the non-dirs beginning with the current startpoint.
 	 * The current startpoint will be updated each time a media mark
@@ -2225,37 +2352,44 @@ content_stream_dump(ix_t strmix)
 		off64_t ncommitted;
 		bool_t done;
 
-		/* used to decide whether or not to go back for more.
+		/*
+		 * used to decide whether or not to go back for more.
 		 */
 		stop_requested = BOOL_FALSE;
 
-		/* TRUE if hit EOM while dumping
+		/*
+		 * TRUE if hit EOM while dumping
 		 */
 		hit_eom = BOOL_FALSE;
 
-		/* used to decide if the media file contains all
+		/*
+		 * used to decide if the media file contains all
 		 * of the inomap and dirdump.
 		 */
 		all_dirs_committed = BOOL_FALSE;
 
-		/* used to decide if all non-dirs were sent (not necessarily
+		/*
+		 * used to decide if all non-dirs were sent (not necessarily
 		 * committed)
 		 */
 		all_nondirs_sent = BOOL_FALSE;
 
-		/* always clear the NULL flag from the stream startpoint
+		/*
+		 * always clear the NULL flag from the stream startpoint
 		 * before beginning the media file. allows detection
 		 * of null file hdr commit.
 		 */
 		scwhdrp->cih_startpt.sp_flags &= ~STARTPT_FLAGS_NULL;
 
-		/* save the original start points, to be given to
+		/*
+		 * save the original start points, to be given to
 		 * the inventory at the end of each media file.
 		 */
 		startino = scwhdrp->cih_startpt.sp_ino;
 		startoffset = scwhdrp->cih_startpt.sp_offset;
 
-		/* set the accumulated file size to zero.
+		/*
+		 * set the accumulated file size to zero.
 		 * this will be monitored by dump_file() to decide
 		 * if the current dump file is too long. if so,
 		 * it will set a startpoint and spoof an EOF.
@@ -2264,7 +2398,8 @@ content_stream_dump(ix_t strmix)
 		 */
 		contextp->cc_mfilesz = 0;
 
-		/* tell the Media abstraction to position a media object
+		/*
+		 * tell the Media abstraction to position a media object
 		 * and begin a new media file. This will dump the media
 		 * file header if successful.
 		 */
@@ -2302,7 +2437,8 @@ content_stream_dump(ix_t strmix)
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
-		/* sync up here with other streams if reasonable
+		/*
+		 * sync up here with other streams if reasonable
 		 */
 		mlog(MLOG_VERBOSE, _(
 		      "creating dump session media file %u "
@@ -2311,12 +2447,14 @@ content_stream_dump(ix_t strmix)
 		      mwhdrp->mh_mediaix,
 		      mwhdrp->mh_mediafileix);
 
-		/* initialize the count of marks committed in the media file.
+		/*
+		 * initialize the count of marks committed in the media file.
 		 * will be bumped by mark_callback().
 		 */
 		contextp->cc_markscommitted = 0;
 
-		/* first dump the inomap
+		/*
+		 * first dump the inomap
 		 */
 		mlog(MLOG_VERBOSE, _(
 		      "dumping ino map\n"));
@@ -2348,7 +2486,8 @@ content_stream_dump(ix_t strmix)
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
-		/* now dump the directories, if this is a stream that dumps
+		/*
+		 * now dump the directories, if this is a stream that dumps
 		 * directories. use the bigstat iterator capability to call
 		 * my dump_dir function for each directory in the bitmap.
 		 */
@@ -2385,7 +2524,8 @@ content_stream_dump(ix_t strmix)
 			}
 		}
 
-		/* finally, dump the non-directory files beginning with this
+		/*
+		 * finally, dump the non-directory files beginning with this
 		 * stream's startpoint. Note that dump_file will set one or
 		 * more media marks; the callback will update the hdr's
 		 * startpoint; thus each time a demarcated portion of a
@@ -2445,7 +2585,8 @@ content_stream_dump(ix_t strmix)
 			}
 		}
 
-		/* if we got here, all files were sent without hitting
+		/*
+		 * if we got here, all files were sent without hitting
 		 * the end of the current media object, or hitting the
 		 * media file size limit. send the special END mark.
 		 * this is only send at the end of the last media file in the
@@ -2461,7 +2602,8 @@ content_stream_dump(ix_t strmix)
 			  STARTPT_FLAGS_END);
 
 decision_more:
-		/* write a null file hdr, to let restore recognize
+		/*
+		 * write a null file hdr, to let restore recognize
 		 * the end of the media file. the flags indicate
 		 * whether or not this is intended to be the last
 		 * media file in the stream. don't bother if we hit
@@ -2492,7 +2634,8 @@ decision_more:
 				return mlog_exit(EXIT_ERROR, rv);
 			}
 
-			/* send a mark to detect if the null file header made
+			/*
+			 * send a mark to detect if the null file header made
 			 * it. mark callback will adjust start pt before this
 			 * call returns if the null file header made it.
 			 */
@@ -2506,7 +2649,8 @@ decision_more:
 				  STARTPT_FLAGS_NULL);
 		}
 
-		/* tell the Media abstraction to end the media file.
+		/*
+		 * tell the Media abstraction to end the media file.
 		 * this is done before the inventory update, to
 		 * see how much was actually committed to media.
 		 * will invoke drive end_write, which will flush
@@ -2532,12 +2676,14 @@ decision_more:
 		      "media file size %lld bytes\n"),
 		      ncommitted);
 
-		/* if at least one mark committed, we know all of
+		/*
+		 * if at least one mark committed, we know all of
 		 * the inomap and dirdump was committed.
 		 */
 		all_dirs_committed = (contextp->cc_markscommitted > 0);
 
-		/* at this point we can check the new start point
+		/*
+		 * at this point we can check the new start point
 		 * to determine if all nondirs have been committed.
 		 * if this flag was already set, then this is a
 		 * inomap and dirdump-only media file.
@@ -2549,13 +2695,15 @@ decision_more:
 			all_nondirs_committed = BOOL_TRUE;
 		}
 
-		/* we are done if all nondirs have been committed.
+		/*
+		 * we are done if all nondirs have been committed.
 		 * it is not necessary for the null file header to have
 		 * been committed.
 		 */
 		done = all_nondirs_committed;
 
-		/* tell the inventory about the media file
+		/*
+		 * tell the inventory about the media file
 		 */
 		if (inv_stmt != INV_TOKEN_NULL) {
 			bool_t ok;
@@ -2596,7 +2744,8 @@ decision_more:
 				       scwhdrp->cih_startpt.sp_offset);
 			}
 
-			/* already thread-safe, don't need to lock
+			/*
+			 * already thread-safe, don't need to lock
 			 */
 			ok = inv_put_mediafile(inv_stmt,
 						&mwhdrp->mh_mediaid,
@@ -2618,24 +2767,28 @@ decision_more:
 		}
 		if (done) {
 			contextp->cc_completepr = BOOL_TRUE;
-			    /* so inv_end_stream and main will know
+			    /*
+			     * so inv_end_stream and main will know
 			     */
 		}
 
-		/* don't go back for more if done or stop was requested
+		/*
+		 * don't go back for more if done or stop was requested
 		 */
 		if (done || stop_requested) {
 			break;
 		}
 	} /* end main dump loop */
 
-	/* check in
+	/*
+	 * check in
 	 */
 	lock();
 	sc_thrdsdonecnt++;
 	unlock();
 
-	/* dump the session inventory and terminator here, if the drive
+	/*
+	 * dump the session inventory and terminator here, if the drive
 	 * supports multiple media files. must wait until all
 	 * streams have completed or given up, so all media files
 	 * from all streams have been registered.
@@ -2648,17 +2801,20 @@ decision_more:
 			sc_stat_pds[strmix].pds_phase = PDS_INVSYNC;
 		}
 
-		/* first be sure all threads have begun
+		/*
+		 * first be sure all threads have begun
 		*/
 		while (sc_thrdsarrivedcnt < drivecnt) {
 			sleep(1);
 		}
-		/* now wait for survivors to checkin
+		/*
+		 * now wait for survivors to checkin
 		*/
 		while (sc_thrdsdonecnt < stream_cnt()) {
 			sleep(1);
 		}
-		/* proceeed
+		/*
+		 * proceeed
 		 */
 		sc_stat_pds[strmix].pds_phase = PDS_INVDUMP;
 		if (dump_session_inv(drivep, contextp, mwhdrp, scwhdrp)) {
@@ -2680,7 +2836,8 @@ decision_more:
 	return mlog_exit(EXIT_NORMAL, rv);
 }
 
-/* indicates if the dump was complete.
+/*
+ * indicates if the dump was complete.
  * easy to tell: initially contextp->cc_completepr is false for each stream.
  * only set true if stream complete. if any stream NOT complete,
  * dump is not complete.
@@ -2836,7 +2993,8 @@ dump_dirs(ix_t strmix,
 
 	inomap_reset_context(inomap_contextp);
 
-	/* begin iteration at ino zero
+	/*
+	 * begin iteration at ino zero
 	 */
 	lastino = 0;
 	for (bulkstatcallcnt = 0;; bulkstatcallcnt++) {
@@ -2851,13 +3009,15 @@ dump_dirs(ix_t strmix,
 		}
 		sc_stat_pds[strmix].pds_phase = PDS_DIRDUMP;
 
-		/* check for interruption
+		/*
+		 * check for interruption
 		 */
 		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
-		/* get a bunch of bulkstats
+		/*
+		 * get a bunch of bulkstats
 		 */
 		mlog(MLOG_NITTY,
 		      "dump_dirs SGI_FS_BULKSTAT %u buf len %u\n",
@@ -2883,13 +3043,15 @@ dump_dirs(ix_t strmix,
 		      "dump_dirs SGI_FS_BULKSTAT returns %d entries\n",
 		      buflenout);
 
-		/* check if done
+		/*
+		 * check if done
 		 */
 		if (buflenout == 0) {
 			return RV_OK;
 		}
 
-		/* step through each node, dumping if
+		/*
+		 * step through each node, dumping if
 		 * appropriate
 		 */
 		for (p = bstatbufp, endp = bstatbufp + buflenout
@@ -2961,24 +3123,28 @@ dump_dir(ix_t strmix,
 	gen_t gen;
 	rv_t rv;
 
-	/* no way this can be non-dir, but check anyway
+	/*
+	 * no way this can be non-dir, but check anyway
 	 */
 	assert((statp->bs_mode & S_IFMT) == S_IFDIR);
 	if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 		return RV_OK;
 	}
 
-	/* skip if no links
+	/*
+	 * skip if no links
 	 */
 	if (statp->bs_nlink < 1) {
 		return RV_OK;
 	}
 
-	/* see what the inomap says about this ino
+	/*
+	 * see what the inomap says about this ino
 	 */
 	state = inomap_get_state(inomap_contextp, statp->bs_ino);
 
-	/* skip if not in inomap
+	/*
+	 * skip if not in inomap
 	 */
 	if (state == MAP_INO_UNUSED
 	     ||
@@ -2994,7 +3160,8 @@ dump_dir(ix_t strmix,
 		return RV_OK;
 	}
 
-	/* note if map says a non-dir
+	/*
+	 * note if map says a non-dir
 	 */
 	if (state == MAP_NDR_CHANGE) {
 		mlog(MLOG_DEBUG,
@@ -3004,11 +3171,13 @@ dump_dir(ix_t strmix,
 		return RV_OK;
 	}
 
-	/* bump the stats now. a bit early, but fewer lines of code
+	/*
+	 * bump the stats now. a bit early, but fewer lines of code
 	 */
 	sc_stat_pds[strmix].pds_dirdone++;
 
-        /* if bulkstat ino# occupied more than 32 bits and
+        /*
+         * if bulkstat ino# occupied more than 32 bits and
          * linux ino# for getdents is 32 bits then
          * warn and skip.
          */
@@ -3023,7 +3192,8 @@ dump_dir(ix_t strmix,
 	      "dumping directory ino %llu\n",
 	      statp->bs_ino);
 
-	/* open the directory named by statp
+	/*
+	 * open the directory named by statp
 	 */
 	fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (fd < 0) {
@@ -3033,7 +3203,8 @@ dump_dir(ix_t strmix,
 		return RV_OK; /* continue anyway */
 	}
 
-	/* dump the file header.
+	/*
+	 * dump the file header.
 	 */
 	rv = dump_filehdr(drivep, contextp, statp, 0, 0);
 	if (rv != RV_OK) {
@@ -3041,7 +3212,8 @@ dump_dir(ix_t strmix,
 		return rv;
 	}
 
-	/* dump dirents - lots of buffering done here, to achieve OS-
+	/*
+	 * dump dirents - lots of buffering done here, to achieve OS-
 	 * independence. if proves to be to much overhead, can streamline.
 	 */
 	for (gdcnt = 1, rv = RV_OK; rv == RV_OK; gdcnt++) {
@@ -3051,7 +3223,8 @@ dump_dir(ix_t strmix,
 
 		nread = getdents_wrap(fd, (char *)gdp, gdsz);
 
-		/* negative count indicates something very bad happened;
+		/*
+		 * negative count indicates something very bad happened;
 		 * try to gracefully end this dir.
 		 */
 		if (nread < 0) {
@@ -3061,7 +3234,8 @@ dump_dir(ix_t strmix,
 			      gdcnt,
 			      statp->bs_ino,
 			      strerror(errno));
-			/* !!! curtis looked at this, and pointed out that
+			/*
+			 * !!! curtis looked at this, and pointed out that
 			 * we could take some recovery action here. if the
 			 * errno is appropriate, lseek64 to the value of
 			 * doff field of the last dirent successfully
@@ -3070,13 +3244,15 @@ dump_dir(ix_t strmix,
 			nread = 0; /* pretend we are done */
 		}
 
-		/* no more directory entries: break;
+		/*
+		 * no more directory entries: break;
 		 */
 		if (nread == 0) {
 			break;
 		}
 
-		/* translate and dump each entry: skip "." and ".."
+		/*
+		 * translate and dump each entry: skip "." and ".."
 		 * and null entries.
 		 */
 		for (p = gdp,
@@ -3096,14 +3272,16 @@ dump_dir(ix_t strmix,
 						    offsetofmember(struct dirent,
 								    d_name);
 
-			/* getdents(2) guarantees that the string will
+			/*
+			 * getdents(2) guarantees that the string will
 			 * be null-terminated, but the record may have
 			 * padding after the null-termination.
 			 */
 			assert(namelen < nameszmax);
 #endif
 
-			/* skip "." and ".."
+			/*
+			 * skip "." and ".."
 			 */
 			if (*(p->d_name + 0) == '.'
 			     &&
@@ -3126,7 +3304,8 @@ dump_dir(ix_t strmix,
 				continue;
 			}
 
-			/* lookup the gen number in the ino-to-gen map.
+			/*
+			 * lookup the gen number in the ino-to-gen map.
 			 * if it's not there, we have to get it the slow way.
 			 */
 			if (inomap_get_gen(NULL, p->d_ino, &gen)) {
@@ -3164,7 +3343,8 @@ dump_dir(ix_t strmix,
 		}
 	}
 
-	/* write a null dirent hdr, unless trouble encountered in the loop
+	/*
+	 * write a null dirent hdr, unless trouble encountered in the loop
 	 */
 	if (rv == RV_OK) {
 		rv = dump_dirent(drivep, contextp, statp, 0, 0, 0, 0);
@@ -3180,7 +3360,8 @@ dump_dir(ix_t strmix,
 
 	close(fd);
 
-	/* if an error occurred, just return the error
+	/*
+	 * if an error occurred, just return the error
 	 */
 	return rv;
 }
@@ -3197,7 +3378,8 @@ dump_extattrs(drive_t *drivep,
 	rv_t rv;
 	bool_t abort;
 
-	/* dump a file header specially marked as heading extended attributes
+	/*
+	 * dump a file header specially marked as heading extended attributes
 	 */
 	mlog(MLOG_NITTY,
 	      "dumping %s ino %llu extended attributes filehdr\n",
@@ -3209,7 +3391,8 @@ dump_extattrs(drive_t *drivep,
 		return rv;
 	}
 
-	/* loop three times: once for the non-root, once for root, and
+	/*
+	 * loop three times: once for the non-root, once for root, and
 	 * again for the secure attributes.
 	 */
 	for (pass = 0; pass < 3; pass++) {
@@ -3228,7 +3411,8 @@ dump_extattrs(drive_t *drivep,
 		      FILETYPE(statp),
 		      statp->bs_ino);
 
-		/* loop dumping the extended attributes from the namespace
+		/*
+		 * loop dumping the extended attributes from the namespace
 		 * selected by the outer loop
 		 */
 		memset(&cursor, 0, sizeof(cursor));
@@ -3270,7 +3454,8 @@ dump_extattrs(drive_t *drivep,
 		} while (more && !abort);
 	}
 
-	/* finally, dump a dummy extattr hdr so restore will know
+	/*
+	 * finally, dump a dummy extattr hdr so restore will know
 	 * we're done.
 	 */
 	/*DBG*/mlog(MLOG_NITTY,
@@ -3305,11 +3490,13 @@ dump_extattr_list(drive_t *drivep,
 			    +
 			    contextp->cc_extattrdumpbufsz;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(listp->al_count >= 0);
 
-	/* fill up a retrieve array and build a dump buffer;
+	/*
+	 * fill up a retrieve array and build a dump buffer;
 	 * can run out of entries in the name list, space in the
 	 * retrieve buffer, or space in the dump buffer
 	 */
@@ -3328,7 +3515,8 @@ dump_extattr_list(drive_t *drivep,
 			entp = ATTR_ENTRY(listp, nameix);
 			opp = &contextp->cc_extattrrtrvarrayp[rtrvix];
 
-			/* Offer the HSM a chance to avoid dumping certain
+			/*
+			 * Offer the HSM a chance to avoid dumping certain
 			 * attributes.
 			 */
 
@@ -3378,7 +3566,8 @@ dump_extattr_list(drive_t *drivep,
 			nameix++;
 		}
 
-		/* Either the retrieve buffer is full, the dump buffer is full,
+		/*
+		 * Either the retrieve buffer is full, the dump buffer is full,
 		 * or we just put the last attribute into the dump buffer.  In
 		 * any case, fill in the values for any attributes added so far.
 		 */
@@ -3408,7 +3597,8 @@ dump_extattr_list(drive_t *drivep,
 				if (opp->am_error) {
 					if (opp->am_error == ENOATTR &&
 					     flag & ATTR_SECURE) {
-				/* Security attributes are supported by
+				/*
+				 * Security attributes are supported by
 				 * the kernel but jdm_attr_multi() returns
 				 * ENOATTR for every 'user' space attribute
 				 * during the 'security' pass of the extended
@@ -3433,7 +3623,8 @@ dump_extattr_list(drive_t *drivep,
 			}
 		}
 
-		/* The values for all attributes in the dump buffer have been
+		/*
+		 * The values for all attributes in the dump buffer have been
 		 * filled in.  If the dump buffer isn't full yet, let's wait
 		 * and put some more attributes in.
 		 */
@@ -3473,7 +3664,8 @@ dump_extattr_list(drive_t *drivep,
 		endp = dumpbufp;
 	}
 
-	/* All existing attributes are in the dump buffer.  See if the HSM
+	/*
+	 * All existing attributes are in the dump buffer.  See if the HSM
 	 * needs to add any addtional attributes.
 	 */
 
@@ -3553,7 +3745,8 @@ dump_extattr_list(drive_t *drivep,
 		}
 	}
 
-	/* If any attributes remain unwritten in the dump buffer, write them
+	/*
+	 * If any attributes remain unwritten in the dump buffer, write them
 	 * now.
 	 */
 
@@ -3720,7 +3913,8 @@ dump_extattrhdr(drive_t *drivep,
 	return rv;
 }
 
-/* this function is called by the bigstat iterator for all non-directory
+/*
+ * this function is called by the bigstat iterator for all non-directory
  * files. it passes the buck to file type-specific dump functions.
  * return value is RV_EOF if the media file is getting too big,
  * RV_... if trouble encountered with the media/drive,
@@ -3749,7 +3943,8 @@ dump_file(void *arg1,
 	int state;
 	rv_t rv;
 
-	/* skip if no links
+	/*
+	 * skip if no links
 	 */
 	if (statp->bs_nlink < 1) {
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
@@ -3760,7 +3955,8 @@ dump_file(void *arg1,
 		return RV_OK;
 	}
 
-	/* skip if prior to startpoint
+	/*
+	 * skip if prior to startpoint
 	 */
 	if (statp->bs_ino < startptp->sp_ino) {
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
@@ -3771,7 +3967,8 @@ dump_file(void *arg1,
 		return RV_OK;
 	}
 
-	/* skip if at or beyond next startpoint. return non-zero to
+	/*
+	 * skip if at or beyond next startpoint. return non-zero to
 	 * abort iteration.
 	 */
 	if (! (endptp->sp_flags & STARTPT_FLAGS_END)) {
@@ -3796,11 +3993,13 @@ dump_file(void *arg1,
 		}
 	}
 
-	/* see what the inomap says about this ino
+	/*
+	 * see what the inomap says about this ino
 	 */
 	state = inomap_get_state(contextp->cc_inomap_contextp, statp->bs_ino);
 
-	/* skip if not in inomap
+	/*
+	 * skip if not in inomap
 	 */
 	if (state == MAP_INO_UNUSED
 	     ||
@@ -3823,7 +4022,8 @@ dump_file(void *arg1,
 		return RV_OK;
 	}
 
-	/* note if map says a dir
+	/*
+	 * note if map says a dir
 	 */
 	if (state == MAP_DIR_CHANGE || state == MAP_DIR_SUPPRT) {
 		mlog(MLOG_NORMAL | MLOG_WARNING, _(
@@ -3837,7 +4037,8 @@ dump_file(void *arg1,
 		      "map says unchanged dir");
 	}
 
-	/* if GETOPT_DUMPASOFFLINE was specified, initialize the HSM's file
+	/*
+	 * if GETOPT_DUMPASOFFLINE was specified, initialize the HSM's file
 	 * context for use in other routines.  If the context can't be
 	 * initialized, don't dump the file.
 	 */
@@ -3855,14 +4056,17 @@ dump_file(void *arg1,
 		}
 	}
 
-	/* pass on to specific dump function
+	/*
+	 * pass on to specific dump function
 	 */
 	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:
-		/* ordinary file
+		/*
+		 * ordinary file
 		 */
 
-		/* filter out any files that have grown beyond the
+		/*
+		 * filter out any files that have grown beyond the
 		 * max file size since the initial scan.
 		 */
 		if (maxdumpfilesize) {
@@ -3908,7 +4112,8 @@ dump_file(void *arg1,
 #endif
 	case S_IFLNK:
 	case S_IFSOCK:
-		/* only need a filehdr_t; no data
+		/*
+		 * only need a filehdr_t; no data
 		 */
 		rv = dump_file_spec(drivep, contextp, fshandlep, statp);
 		if (statp->bs_ino > contextp->cc_stat_lastino) {
@@ -3920,7 +4125,8 @@ dump_file(void *arg1,
 		break; /* drop out of switch to extattr dump */
 	case S_IFDIR:
 	default:
-		/* don't know how to dump these
+		/*
+		 * don't know how to dump these
 		 */
 		mlog(MLOG_VERBOSE, _(
 		      "don't know how to dump ino %llu: mode %08x\n"),
@@ -3933,7 +4139,8 @@ dump_file(void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		return RV_OK;
-	/* not yet implemented
+	/*
+	 * not yet implemented
 	case S_IFMNT:
 	 */
 	}
@@ -3951,7 +4158,8 @@ dump_file(void *arg1,
 	return rv;
 }
 
-/* a regular file may be broken into several portions if its size
+/*
+ * a regular file may be broken into several portions if its size
  * is large. Each portion begins with a filehdr_t and is followed by
  * several extents. each extent begins with an extenthdr_t. returns RV_OK
  * if all extents dumped, RV_... on drive errors, or RV_INTR if
@@ -3975,7 +4183,8 @@ dump_file_reg(drive_t *drivep,
 	off64_t maxextentcnt;
 	rv_t rv;
 
-	/* determine the offset within the file where the dump should begin.
+	/*
+	 * determine the offset within the file where the dump should begin.
 	 * it must have been aligned to the basic fs block size by the
 	 * startpoint calculations done during strategy initialization.
 	 */
@@ -3986,7 +4195,8 @@ dump_file_reg(drive_t *drivep,
 		offset = 0;
 	}
 
-	/* if this is a resumed dump and the resumption begins somewhere
+	/*
+	 * if this is a resumed dump and the resumption begins somewhere
 	 * within this file, and that point is greater than offset set
 	 * above, and that file hasn't changed since the resumed dump,
 	 * modify offset.
@@ -4013,7 +4223,8 @@ dump_file_reg(drive_t *drivep,
 		assert((offset & (off64_t)(BBSIZE - 1)) == 0);
 	}
 
-	/* determine the offset within the file where the dump should end.
+	/*
+	 * determine the offset within the file where the dump should end.
 	 * only significant if this is an inode spanning a startpoint.
 	 */
 	if (endptp->sp_flags & STARTPT_FLAGS_END) {
@@ -4037,13 +4248,15 @@ dump_file_reg(drive_t *drivep,
 	      sosig ? stopoffset : statp->bs_size,
 	      statp->bs_size);
 
-	/* calculate the maximum extent group size. files larger than this
+	/*
+	 * calculate the maximum extent group size. files larger than this
 	 * will be broken into multiple extent groups, each with its own
 	 * filehdr_t.
 	 */
 	maxextentcnt = drivep->d_recmarksep;
 
-	/* initialize the extent group context. if fails, just return,
+	/*
+	 * initialize the extent group context. if fails, just return,
 	 * pretending the dump succeeded.
 	 */
 	rv = init_extent_group_context(fshandlep,
@@ -4060,7 +4273,8 @@ dump_file_reg(drive_t *drivep,
 		return RV_OK;
 	}
 
-	/* loop here, dumping marked groups of extents. each extent group
+	/*
+	 * loop here, dumping marked groups of extents. each extent group
 	 * is preceeded by a filehdr_t. this is required so that the
 	 * recovery side can identify the fs file at each marked point
 	 * in the stream. it sets by reference offset, bytecnt, and cmpltflg.
@@ -4075,21 +4289,24 @@ dump_file_reg(drive_t *drivep,
 		off64_t bytecnt = 0;
 		off64_t bc;
 
-		/* see if we are done.
+		/*
+		 * see if we are done.
 		 */
 		if (cmpltflg) {
 			assert(rv == RV_OK);
 			break;
 		}
 
-		/* set a mark - important to do this now, before deciding
+		/*
+		 * set a mark - important to do this now, before deciding
 		 * the media file is to big or the operator asked to
 		 * interrupt the dump. this mark, if committed, indicates
 		 * the previous fs file / extent group was completely dumped.
 		 */
 		mark_set(drivep, statp->bs_ino, offset, 0);
 
-		/* spoof EOF if the media file size is getting too big.
+		/*
+		 * spoof EOF if the media file size is getting too big.
 		 * note that the most we can go over is d_recmarksep.
 		 */
 		if (contextp->cc_mfilesz >= drivep->d_recmfilesz){
@@ -4097,7 +4314,8 @@ dump_file_reg(drive_t *drivep,
 			break;
 		}
 
-		/* check if the operator has requested to interrupt the dump.
+		/*
+		 * check if the operator has requested to interrupt the dump.
 		 */
 		if (cldmgr_stop_requested()) {
 			mlog(MLOG_NORMAL, _(
@@ -4109,7 +4327,8 @@ dump_file_reg(drive_t *drivep,
 			break;
 		}
 
-		/* dump the file header
+		/*
+		 * dump the file header
 		 */
 		mlog(MLOG_DEBUG,
 		      "dumping extent group ino %llu offset %lld\n",
@@ -4121,7 +4340,8 @@ dump_file_reg(drive_t *drivep,
 		}
 		bytecnt += sizeof(filehdr_t);
 
-		/* dump a group of extents. returns by reference
+		/*
+		 * dump a group of extents. returns by reference
 		 * the offset of the next extent group (to be placed
 		 * in the next mark), the total number of bytes written
 		 * to media (headers and all), and a flag indicating
@@ -4144,13 +4364,15 @@ dump_file_reg(drive_t *drivep,
 			break;
 		}
 
-		/* update global stat
+		/*
+		 * update global stat
 		 */
 		lock();
 		sc_stat_datadone += (size64_t)bc;
 		unlock();
 
-		/* dump LAST extent hdr. one of these is placed at the
+		/*
+		 * dump LAST extent hdr. one of these is placed at the
 		 * end of each dumped file. necessary to detect the
 		 * end of the file.
 		 */
@@ -4165,7 +4387,8 @@ dump_file_reg(drive_t *drivep,
 		}
 		bytecnt += sizeof(extenthdr_t);
 
-		/* update the media file size
+		/*
+		 * update the media file size
 		 */
 		contextp->cc_mfilesz += bytecnt;
 
@@ -4175,7 +4398,8 @@ dump_file_reg(drive_t *drivep,
 	return rv;
 }
 
-/* dumps character, block, and fifo - special files. no data, just meta-data,
+/*
+ * dumps character, block, and fifo - special files. no data, just meta-data,
  * all contained within the filehdr_t. also handles symbolic link files:
  * appends a variable-length string after the filehdr_t.
  */
@@ -4193,24 +4417,28 @@ dump_file_spec(drive_t *drivep,
 	      statp->bs_ino,
 	      statp->bs_mode);
 
-	/* set a mark - important to do this now, before deciding
+	/*
+	 * set a mark - important to do this now, before deciding
 	 * the media file is to big. this mark, if committed,
 	 * indicates the previous fs file was completely dumped.
 	 */
 	mark_set(drivep, statp->bs_ino, 0, 0);
 
-	/* dump the file header
+	/*
+	 * dump the file header
 	 */
 	rv = dump_filehdr(drivep, contextp, statp, 0, 0);
 	if (rv != RV_OK) {
 		return rv;
 	}
 
-	/* update the media file size
+	/*
+	 * update the media file size
 	 */
 	contextp->cc_mfilesz += sizeof(filehdr_t);
 
-	/* if a symbolic link, also dump the link pathname.
+	/*
+	 * if a symbolic link, also dump the link pathname.
 	 * use an extent header to represent the pathname. the
 	 * extent sz will always be a multiple of SYMLINK_ALIGN.
 	 * the symlink pathname char string will always  be NULL-terminated.
@@ -4219,7 +4447,8 @@ dump_file_spec(drive_t *drivep,
 		int nread;
 		size_t extentsz;
 
-		/* read the link path. if error, dump a zero-length
+		/*
+		 * read the link path. if error, dump a zero-length
 		 * extent. in any case, nread will contain the number of
 		 * bytes to dump, and contextp->cc_direntbufp will contain
 		 * the bytes.
@@ -4235,12 +4464,14 @@ dump_file_spec(drive_t *drivep,
 			nread = 0;
 		}
 
-		/* null-terminate the string
+		/*
+		 * null-terminate the string
 		 */
 		assert((size_t)nread < contextp->cc_readlinkbufsz);
 		contextp->cc_readlinkbufp[nread] = 0;
 
-		/* calculate the extent size - be sure to include room
+		/*
+		 * calculate the extent size - be sure to include room
 		 * for the null-termination.
 		 */
 		extentsz = ((size_t)nread + 1 + (SYMLINK_ALIGN - 1))
@@ -4248,7 +4479,8 @@ dump_file_spec(drive_t *drivep,
 			   ~ (SYMLINK_ALIGN - 1);
 		assert(extentsz <= contextp->cc_readlinkbufsz);
 
-		/* dump an extent header
+		/*
+		 * dump an extent header
 		 */
 		rv = dump_extenthdr(drivep,
 				     contextp,
@@ -4260,7 +4492,8 @@ dump_file_spec(drive_t *drivep,
 			return rv;
 		}
 
-		/* dump the link path extent
+		/*
+		 * dump the link path extent
 		 */
 		rval = write_buf(contextp->cc_readlinkbufp,
 				  extentsz,
@@ -4291,7 +4524,8 @@ dump_file_spec(drive_t *drivep,
 	return RV_OK;
 }
 
-/* contrives the initial state of the extent group context such that
+/*
+ * contrives the initial state of the extent group context such that
  * dump_extent_group() will fetch some extents from the kernel before it
  * does anything else.
  */
@@ -4323,7 +4557,8 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 		return RV_ERROR;
 	}
 
-	/* Check if a mandatory lock is set on the file to try and
+	/*
+	 * Check if a mandatory lock is set on the file to try and
 	 * avoid blocking indefinitely on the reads later. Note that
 	 * someone could still set a mandatory lock and hose xfsdump
 	 * after this check but before all reads have completed.
@@ -4391,7 +4626,8 @@ dump_extent_group(drive_t *drivep,
 		}
 	}
 
-	/* dump extents until the recommended extent length is achieved
+	/*
+	 * dump extents until the recommended extent length is achieved
 	 */
 	nextoffset = *nextoffsetp;
 	bytecnt = 0;
@@ -4401,7 +4637,8 @@ dump_extent_group(drive_t *drivep,
 		off64_t offset;
 		off64_t extsz;
 
-		/* if we've dumped to the stop point return.
+		/*
+		 * if we've dumped to the stop point return.
 		 */
 		if (sosig && nextoffset >= stopoffset) {
 			mlog(MLOG_NITTY,
@@ -4412,7 +4649,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if we've dumped the entire file, return
+		/*
+		 * if we've dumped the entire file, return
 		 */
 		if (nextoffset >= statp->bs_size) {
 			mlog(MLOG_NITTY,
@@ -4423,7 +4661,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if we've exceeded the desired per-extent group byte count,
+		/*
+		 * if we've exceeded the desired per-extent group byte count,
 		 * call it quits. we'll be called back for more because the
 		 * completion flag is set FALSE.
 		 */
@@ -4436,7 +4675,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if we are not looking at a valid bmap entry,
+		/*
+		 * if we are not looking at a valid bmap entry,
 		 * get one.
 		 */
 		if (gcp->eg_nextbmapp >= gcp->eg_endbmapp) {
@@ -4444,7 +4684,8 @@ dump_extent_group(drive_t *drivep,
 
 			assert(gcp->eg_nextbmapp == gcp->eg_endbmapp);
 
-			/* get a new extent block
+			/*
+			 * get a new extent block
 			 */
 			mlog(MLOG_NITTY,
 			      "calling getbmapx for ino %llu\n",
@@ -4482,7 +4723,8 @@ dump_extent_group(drive_t *drivep,
 				return RV_OK;
 			}
 
-			/* The F_GETBMAPX call succeeded.  Give the HSM a chance
+			/*
+			 * The F_GETBMAPX call succeeded.  Give the HSM a chance
 			 * to massage the extents.  (It can change the number
 			 * of extents remaining, even setting them to zero.
 			 */
@@ -4525,14 +4767,16 @@ dump_extent_group(drive_t *drivep,
 		      gcp->eg_nextbmapp->bmv_offset,
 		      gcp->eg_nextbmapp->bmv_length);
 
-		/* if the next bmap entry represents a hole, go to the next
+		/*
+		 * if the next bmap entry represents a hole, go to the next
 		 * one in the bmap, and rescan to check above assumptions.
 		 * bump nextoffset to after the hole, if beyond current value.
 		 */
 		if (gcp->eg_nextbmapp->bmv_block == -1) {
 			off64_t tmpoffset;
 
-			/* extract the offset and extent size from this
+			/*
+			 * extract the offset and extent size from this
 			 * entry
 			 */
 			offset = gcp->eg_nextbmapp->bmv_offset
@@ -4544,7 +4788,8 @@ dump_extent_group(drive_t *drivep,
 			      "hole extent offset = %lld size = %lld\n",
 			      offset, extsz);
 
-			/* Encode the hole - dump the extent header
+			/*
+			 * Encode the hole - dump the extent header
 			 * with the right extent type.
 			 */
 			rv = dump_extenthdr(drivep,
@@ -4574,7 +4819,8 @@ dump_extent_group(drive_t *drivep,
 			continue;
 		}
 
-		/* if the next bmap entry has a zero size, go to the next
+		/*
+		 * if the next bmap entry has a zero size, go to the next
 		 * one in the bmap, and rescan to check above assumptions.
 		 */
 		if (gcp->eg_nextbmapp->bmv_length <= 0) {
@@ -4593,7 +4839,8 @@ dump_extent_group(drive_t *drivep,
 			continue;
 		}
 
-		/* extract the offset and extent size from this
+		/*
+		 * extract the offset and extent size from this
 		 * entry
 		 */
 		offset = gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE;
@@ -4604,7 +4851,8 @@ dump_extent_group(drive_t *drivep,
 		      extsz,
 		      nextoffset);
 
-		/* if the new bmap entry begins below the stop offset
+		/*
+		 * if the new bmap entry begins below the stop offset
 		 * but does not contain any data above the current
 		 * offset, go to the next one and rescan.
 		 */
@@ -4618,7 +4866,8 @@ dump_extent_group(drive_t *drivep,
 			}
 		}
 
-		/* if the new bmap entry begins beyond the end of the file,
+		/*
+		 * if the new bmap entry begins beyond the end of the file,
 		 * we are done.
 		 */
 		if (offset >= statp->bs_size) {
@@ -4630,7 +4879,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if the new bmap entry begins at or above the stop offset,
+		/*
+		 * if the new bmap entry begins at or above the stop offset,
 		 * stop. we are done.
 		 */
 		if (sosig && offset >= stopoffset) {
@@ -4642,7 +4892,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if the new entry begins below the range of
+		/*
+		 * if the new entry begins below the range of
 		 * interest, modify offset to begin at the
 		 * beginning of the range of interest, and shorten
 		 * extsz accordingly.
@@ -4659,7 +4910,8 @@ dump_extent_group(drive_t *drivep,
 		}
 		assert(extsz > 0);
 
-		/* if the resultant extent would put us over maxcnt,
+		/*
+		 * if the resultant extent would put us over maxcnt,
 		 * shorten it, and round up to the next BBSIZE (round
 		 * upto d_miniosz for realtime).
 		 */
@@ -4684,7 +4936,8 @@ dump_extent_group(drive_t *drivep,
 			      maxcnt);
 		}
 
-		/* if the shortened extent is too small, return; we'll
+		/*
+		 * if the shortened extent is too small, return; we'll
 		 * pick it up next time around. exception: if the file
 		 * size is zero, indicate we are done.
 		 * !!! I don't believe this rule can ever fire!
@@ -4705,7 +4958,8 @@ dump_extent_group(drive_t *drivep,
 			return RV_OK;
 		}
 
-		/* if the resultant extent extends beyond the end of the
+		/*
+		 * if the resultant extent extends beyond the end of the
 		 * file, shorten the extent to the nearest BBSIZE alignment
 		 * at or beyond EOF.  (Shorten to d_miniosz for realtime
 		 * files).
@@ -4731,7 +4985,8 @@ dump_extent_group(drive_t *drivep,
 			      statp->bs_size);
 		}
 
-		/* if the extent extends beyond the stop offset,
+		/*
+		 * if the extent extends beyond the stop offset,
 		 * shorten it to the stop offset.
 		 */
 		if (sosig && (extsz > stopoffset - offset)) {
@@ -4747,7 +5002,8 @@ dump_extent_group(drive_t *drivep,
 			      statp->bs_size);
 		}
 
-		/* I/O performance is better if we align the media write
+		/*
+		 * I/O performance is better if we align the media write
 		 * buffer to a page boundary. do this if the extent is
 		 * at least a page in length. Also, necessary for real time
 		 * files
@@ -4759,7 +5015,8 @@ dump_extent_group(drive_t *drivep,
 				cnt_to_align += PGSZ;
 			}
 
-			/* account for the DATA header following the alignment
+			/*
+			 * account for the DATA header following the alignment
 			 */
 			cnt_to_align -= sizeof(extenthdr_t);
 
@@ -4789,13 +5046,15 @@ dump_extent_group(drive_t *drivep,
 			}
 			bytecnt += (off64_t)cnt_to_align;
 		}
-		/* adjust the next offset
+		/*
+		 * adjust the next offset
 		 */
 		assert((offset & (off64_t)(BBSIZE - 1)) == 0);
 		assert((extsz & (off64_t)(BBSIZE - 1)) == 0);
 		nextoffset = offset + extsz;
 
-		/* dump the extent header
+		/*
+		 * dump the extent header
 		 */
 		rv = dump_extenthdr(drivep,
 				     contextp,
@@ -4811,7 +5070,8 @@ dump_extent_group(drive_t *drivep,
 		}
 		bytecnt += sizeof(extenthdr_t);
 
-		/* dump the extent. if read fails to return all
+		/*
+		 * dump the extent. if read fails to return all
 		 * asked for, pad out the extent with zeros. necessary
 		 * because the extent hdr is already out there!
 		 */
@@ -4862,7 +5122,8 @@ dump_extent_group(drive_t *drivep,
 			      actualsz,
 			      nread);
 
-			/* must return entire buffer supplied by call to
+			/*
+			 * must return entire buffer supplied by call to
 			 * do_get_write_buf; so pad end with zeros. below
 			 * we assume the short read implies EOF, so will
 			 * then pad out remainder of extent as well.
@@ -4902,7 +5163,8 @@ dump_extent_group(drive_t *drivep,
 			extsz -= (off64_t)actualsz;
 			offset += (off64_t)actualsz;
 
-			/* if we got a short read, assume we are at the
+			/*
+			 * if we got a short read, assume we are at the
 			 * end of the file; pad out the remainder of the
 			 * extent to match the header.
 			 */
@@ -4931,7 +5193,8 @@ dump_extent_group(drive_t *drivep,
 			}
 		}
 
-		/* made it! advance to the next extent if the current
+		/*
+		 * made it! advance to the next extent if the current
 		 * extent is completely dumped.
 		 * !!! not be necessary, taken care of near the
 		 * !!! top of the loop.
@@ -5231,7 +5494,8 @@ dump_session_inv(drive_t *drivep,
 	bool_t ok;
 	bool_t done;
 
-	/* if the inventory session token is null, skip
+	/*
+	 * if the inventory session token is null, skip
 	 */
 	if (sc_inv_sestoken == INV_TOKEN_NULL) {
 		return BOOL_TRUE;
@@ -5240,7 +5504,8 @@ dump_session_inv(drive_t *drivep,
 	mlog(MLOG_VERBOSE, _(
 	      "dumping session inventory\n"));
 
-	/* get a buffer from the inventory manager
+	/*
+	 * get a buffer from the inventory manager
 	 */
 	inv_sbufp = 0;
 	inv_sbufsz = 0;
@@ -5252,11 +5517,13 @@ dump_session_inv(drive_t *drivep,
 	}
 	assert(inv_sbufp);
 
-	/* modify the write header to indicate the media file type.
+	/*
+	 * modify the write header to indicate the media file type.
 	 */
 	scwhdrp->cih_mediafiletype = CIH_MEDIAFILETYPE_INVENTORY;
 
-	/* loop attempting to write a complete media file,
+	/*
+	 * loop attempting to write a complete media file,
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
@@ -5393,7 +5660,8 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 	off64_t ncommitted;
 	bool_t done;
 
-	/* if the drive doesn't support use of stream terminators, don't bother
+	/*
+	 * if the drive doesn't support use of stream terminators, don't bother
 	 */
 	if (! contextp->cc_Media_useterminatorpr) {
 		return;
@@ -5402,11 +5670,13 @@ dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 	mlog(MLOG_VERBOSE, _(
 	      "writing stream terminator\n"));
 
-	/* modify the write header to indicate a terminator
+	/*
+	 * modify the write header to indicate a terminator
 	 */
 	MEDIA_TERMINATOR_SET(mwhdrp);
 
-	/* loop attempting to write a complete media file header
+	/*
+	 * loop attempting to write a complete media file header
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
@@ -5556,7 +5826,8 @@ inv_cleanup(void)
 	}
 }
 
-/* This function returns with the proper media positioned at the proper place
+/*
+ * This function returns with the proper media positioned at the proper place
  * in the specified drive, with a write header layed down. The caller can
  * immediately dump. The caller is expected to call Media_mfile_end when
  * the media file is complete or EOM is encountered.
@@ -5584,14 +5855,16 @@ Media_mfile_begin(drive_t *drivep, context_t *contextp, bool_t intr_allowed)
 	int rval;
 	bool_t ok;
 
-	/* sanity checks
+	/*
+	 * sanity checks
 	 */
 	assert(BES_INIT == 0);
 
 	mlog(MLOG_DEBUG | MLOG_MEDIA,
 	      "Media op: begin media file\n");
 
-	/* the command line-specified media label is good only for the
+	/*
+	 * the command line-specified media label is good only for the
 	 * first media object written to. after that, the operator will
 	 * be prompted for a label. To enforce this, cc_Media_firstlabel
 	 * is saved in a temp var and NULLed.
@@ -5599,7 +5872,8 @@ Media_mfile_begin(drive_t *drivep, context_t *contextp, bool_t intr_allowed)
 	cmdlinemedialabel = contextp->cc_Media_firstlabel;
 	contextp->cc_Media_firstlabel = 0;
 
-	/* dispatch based on entry state. invalidate entry state to assert
+	/*
+	 * dispatch based on entry state. invalidate entry state to assert
 	 * each Media_mfile_begin is followed by and Media_mfile_end.
 	 */
 	prevmediapresentpr = BOOL_UNKNOWN;
@@ -5638,7 +5912,8 @@ Media_mfile_begin(drive_t *drivep, context_t *contextp, bool_t intr_allowed)
 	}
 
 position:
-	/* loop until we are positioned either at end of recorded data
+	/*
+	 * loop until we are positioned either at end of recorded data
 	 * or at a terminator, as appropriate, of some media object, or hit EOM.
 	 * goto write or changemedia to get out of loop (or return on
 	 * catastrophic condition). ensure that all but the first media file
@@ -5647,17 +5922,20 @@ position:
 	 * contiguous.
 	 */
 	for (;;) {
-		/* check if a stop has been requested
+		/*
+		 * check if a stop has been requested
 		 */
 		if (intr_allowed && cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
-		/* do a begin_read to see the disposition of the drive/media.
+		/*
+		 * do a begin_read to see the disposition of the drive/media.
 		 */
 		rval = (*dop->do_begin_read)(drivep);
 
-		/* update cc_Media_useterminatorpr after every begin_read,
+		/*
+		 * update cc_Media_useterminatorpr after every begin_read,
 		 * since begin_read will cause some unknown drive params
 		 * to be resolved.
 		 */
@@ -5681,7 +5959,8 @@ position:
 			      mrhdrp->mh_mediaix);
 			mlog_unlock();
 
-			/* successfully read media file header.
+			/*
+			 * successfully read media file header.
 			 * we know media must be present in drive, and
 			 * contains at least one valid xfsdump, hence
 			 * is not virgin.
@@ -5690,7 +5969,8 @@ position:
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 
-			/* do an end_read. the next begin_read will
+			/*
+			 * do an end_read. the next begin_read will
 			 * position in preparation for appending.
 			 * if terminator, back up, we'll overwrite it.
 			 * also be sure we can append dumps.
@@ -5959,13 +6239,15 @@ erasemedia:
 	goto position;
 
 changemedia:
-	/* if the drive does not support media change, quit.
+	/*
+	 * if the drive does not support media change, quit.
 	 */
 	if (! (dcaps & DRIVE_CAP_REMOVABLE)) {
 		return RV_ERROR;
 	}
 
-	/* first eject the current media object if capability supported
+	/*
+	 * first eject the current media object if capability supported
 	 */
 	assert(mediapresentpr != BOOL_UNKNOWN);
 	if (mediapresentpr == BOOL_TRUE) {
@@ -5977,18 +6259,21 @@ changemedia:
 		}
 	}
 
-	/* if dialogs not allowed, we are done.
+	/*
+	 * if dialogs not allowed, we are done.
 	 */
 	if (! dlog_allowed()) {
 		return RV_QUIT; /* this return value will cause approp. msg */
 	}
 
-	/* If an alert program has been specified, run it
+	/*
+	 * If an alert program has been specified, run it
 	 */
 	if (media_change_alert_program != NULL)
 	   system(media_change_alert_program);
 
-	/* if media change prompt declined or times out,
+	/*
+	 * if media change prompt declined or times out,
 	 * we are done
 	 */
 	if (drivecnt > 1 && ! stdoutpiped) {
@@ -6017,7 +6302,8 @@ changemedia:
 		return RV_QUIT;
 	}
 
-	/* we know nothing about the media after a media change
+	/*
+	 * we know nothing about the media after a media change
 	 */
 	prevmediapresentpr = mediapresentpr;
 	mediapresentpr = BOOL_UNKNOWN;
@@ -6034,7 +6320,8 @@ write:
 		return RV_INTR;
 	}
 
-	/* bump the media header indices here. NOTE: will rescind these
+	/*
+	 * bump the media header indices here. NOTE: will rescind these
 	 * if the subsequent do_begin_write fails. this will be done by
 	 * making a copy of the global write header, and copying it
 	 * back on failure.
@@ -6071,7 +6358,8 @@ write:
 	assert(mwhdrp->mh_mediaix != (uint32_t)(-1));
 	assert(mwhdrp->mh_dumpfileix != (uint32_t)(-1));
 
-	/* do not allow interleaving of media files from different xfsdumps.
+	/*
+	 * do not allow interleaving of media files from different xfsdumps.
 	 */
 	if (mwhdrp->mh_mediaix != 0
 	     &&
@@ -6085,7 +6373,8 @@ write:
 		goto changemedia;
 	}
 
-	/* update the media object previous id and label
+	/*
+	 * update the media object previous id and label
 	 */
 	if (! mediawrittentopr && mwhdrp->mh_dumpfileix != 0) {
 		uuid_copy(mwhdrp->mh_prevmediaid, mwhdrp->mh_mediaid);
@@ -6094,7 +6383,8 @@ write:
 				     sizeof(mwhdrp->mh_medialabel));
 	}
 
-	/* update the media object current id and label
+	/*
+	 * update the media object current id and label
 	 */
 	if (! mediawrittentopr) {
 		if (mwhdrp->mh_mediafileix == 0) {
@@ -6144,7 +6434,8 @@ write:
 
 	mediawrittentopr = BOOL_TRUE;
 
-	/* write hdr is prepared. place it on media
+	/*
+	 * write hdr is prepared. place it on media
 	 */
 	if (intr_allowed && cldmgr_stop_requested()) {
 		return RV_INTR;
@@ -6185,7 +6476,8 @@ Media_mfile_end(drive_t *drivep,
 
 	assert(contextp->cc_Media_begin_entrystate == BES_INVAL);
 
-	/* call drive's end_write op to flush the tail of the media file
+	/*
+	 * call drive's end_write op to flush the tail of the media file
 	 * if has previously hit EOM, this is moot.
 	 */
 	rval = (dop->do_end_write)(drivep, ncommittedp);
@@ -6245,7 +6537,8 @@ retry:
 	assert(preamblecnt <= PREAMBLEMAX);
 	dlog_begin(preamblestr, preamblecnt);
 
-	/* query: ask if overwrite ok
+	/*
+	 * query: ask if overwrite ok
 	 */
 	sprintf(question,
 		 "overwrite data on media in "
@@ -6383,7 +6676,8 @@ retry:
 	assert(preamblecnt <= PREAMBLEMAX);
 	dlog_begin(preamblestr, preamblecnt);
 
-	/* query: ask if overwrite ok
+	/*
+	 * query: ask if overwrite ok
 	 */
 	sprintf(question,
 		 "pre-erase (-%c) option specified "
@@ -6462,7 +6756,8 @@ Media_prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
 	drive_t *drivep = (drive_t *)uctxp;
 
-	/* query: ask for a label
+	/*
+	 * query: ask for a label
 	 */
 	(*pcb)(pctxp,
 		   "please enter label for media in "
diff --git a/dump/getopt.h b/dump/getopt.h
index dd798d8..06c9ab0 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -18,7 +18,8 @@
 #ifndef GETOPT_H
 #define GETOPT_H
 
-/* getopt.h	common getopt  command string
+/*
+ * getopt.h	common getopt  command string
  *
  * several modules parse the command line looking for arguments specific to
  * that module. Unfortunately, each of the getopt(3) calls needs the
diff --git a/dump/inomap.c b/dump/inomap.c
index ca287d8..7280ad4 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -48,11 +48,13 @@
 /* structure definitions used locally ****************************************/
 
 #define BSTATBUFLEN	pgsz
-	/* length (in bstat_t's) of buf passed to bigstat_iter
+	/*
+	 * length (in bstat_t's) of buf passed to bigstat_iter
 	 */
 
 #define GETDENTBUFSZ	pgsz
-	/* size (in bytes) of buf passed to diriter (when not recursive)
+	/*
+	 * size (in bytes) of buf passed to diriter (when not recursive)
 	 */
 
 /* declarations of externally defined global symbols *************************/
@@ -65,7 +67,8 @@ extern bool_t allowexcludefiles_pr;
 
 /* forward declarations of locally defined static functions ******************/
 
-/* inomap construction callbacks
+/*
+ * inomap construction callbacks
  */
 static int
 cb_context(bool_t last,
@@ -101,14 +104,16 @@ supprt_prune(void *,
 static off64_t quantity2offset(jdm_fshandle_t *, xfs_bstat_t *, off64_t);
 static off64_t estimate_dump_space(xfs_bstat_t *);
 
-/* inomap primitives
+/*
+ * inomap primitives
  */
 static int inomap_init(int igrpcnt);
 static void inomap_add(void *, xfs_ino_t ino, gen_t gen, int);
 static int inomap_set_state(void *, xfs_ino_t ino, int);
 static void inomap_set_gen(void *, xfs_ino_t, gen_t);
 
-/* subtree abstraction
+/*
+ * subtree abstraction
  */
 static int
 subtree_descend_cb(void *,
@@ -142,7 +147,8 @@ static uint64_t inomap_exclude_skipattr = 0;
 
 /* definition of locally defined global functions ****************************/
 
-/* inomap_build - build an in-core image of the inode map for the
+/*
+ * inomap_build - build an in-core image of the inode map for the
  * specified file system. identify startpoints in the non-dir inodes,
  * such that the total dump media required is divided into startptcnt segments.
  */
@@ -174,7 +180,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 	int stat;
 	int rval;
 
-        /* do a sync so that bulkstat will pick up inode changes
+        /*
+         * do a sync so that bulkstat will pick up inode changes
          * that are currently in the inode cache. this is necessary
          * for incremental dumps in order to have the dump time
          * accurately reflect what inodes were included in this dump.
@@ -182,13 +189,15 @@ inomap_build(jdm_fshandle_t *fshandlep,
          */
 	sync();
 
-	/* copy stat ptrs
+	/*
+	 * copy stat ptrs
 	 */
 	inomap_statphasep = statphasep;
 	inomap_statpassp = statpassp;
 	inomap_statdonep = statdonep;
 
-	/* allocate a bulkstat buf
+	/*
+	 * allocate a bulkstat buf
 	 */
 	bstatbuflen = BSTATBUFLEN;
 	bstatbufp = (xfs_bstat_t *)memalign(pgsz,
@@ -197,7 +206,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 					       sizeof(xfs_bstat_t));
 	assert(bstatbufp);
 
-	/* count the number of inode groups, which will serve as a
+	/*
+	 * count the number of inode groups, which will serve as a
 	 * starting point for the size of the inomap.
 	 */
 	rval = inogrp_iter(fsfd, cb_count_inogrp, (void *)&igrpcnt, &stat);
@@ -206,7 +216,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 		return BOOL_FALSE;
 	}
 
-	/* initialize the callback context
+	/*
+	 * initialize the callback context
 	 */
 	rval = cb_context(last,
 			   lasttime,
@@ -224,7 +235,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
  		return BOOL_FALSE;
  	}
 
-	/* the inode map requires that inodes are added in increasing
+	/*
+	 * the inode map requires that inodes are added in increasing
 	 * ino order. in the case of a subtree dump, inodes would be
 	 * added in whatever order they were discovered when walking the
 	 * subtrees. so pre-populate the inomap with all the inode groups
@@ -238,7 +250,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
  		return BOOL_FALSE;
  	}
 
-	/* construct the ino map, based on the last dump time, resumed
+	/*
+	 * construct the ino map, based on the last dump time, resumed
 	 * dump info, and subtree list. place all unchanged directories
 	 * in the "needed for children" state (MAP_DIR_SUPPRT). these will be
 	 * dumped even though they have not changed. a later pass will move
@@ -297,7 +310,8 @@ inomap_build(jdm_fshandle_t *fshandlep,
 		      inomap_exclude_skipattr);
 	}
 
-	/* prune directories unchanged since the last dump and containing
+	/*
+	 * prune directories unchanged since the last dump and containing
 	 * no children needing dumping.
 	 */
 	if (pruneneeded) {
@@ -329,11 +343,13 @@ inomap_build(jdm_fshandle_t *fshandlep,
 		      "skipping (no pruning necessary)\n"));
 	}
 
-	/* initialize the callback context for startpoint calculation
+	/*
+	 * initialize the callback context for startpoint calculation
 	 */
 	cb_spinit();
 
-	/* identify dump stream startpoints
+	/*
+	 * identify dump stream startpoints
 	 */
 	if (startptcnt > 1) {
 		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
@@ -424,7 +440,8 @@ inomap_skip(xfs_ino_t ino)
 
 /* definition of locally defined static functions ****************************/
 
-/* callback context and operators - inomap_build makes extensive use
+/*
+ * callback context and operators - inomap_build makes extensive use
  * of iterators. below are the callbacks given to these iterators.
  */
 static bool_t cb_last;		/* set by cb_context() */
@@ -447,7 +464,8 @@ static off64_t cb_nondircnt;	/* number of non-dirs CHANGED */
 static bool_t *cb_pruneneededp; /* set by cb_context() */
 static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
 
-/* cb_context - initializes the call back context for the add and prune
+/*
+ * cb_context - initializes the call back context for the add and prune
  * phases of inomap_build().
  */
 static int
@@ -501,7 +519,8 @@ cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 	return 0;
 }
 
-/* cb_add - called for all inodes in the file system. checks
+/*
+ * cb_add - called for all inodes in the file system. checks
  * mod and create times to decide if should be dumped. sets all
  * unmodified directories to be dumped for supprt. notes if any
  * files or directories have not been modified.
@@ -524,13 +543,15 @@ cb_add(void *arg1,
 
 	(*inomap_statdonep)++;
 
-	/* skip if no links
+	/*
+	 * skip if no links
 	 */
 	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
-	/* if no portion of this ino is in the resume range,
+	/*
+	 * if no portion of this ino is in the resume range,
 	 * then only dump it if it has changed since the interrupted
 	 * dump.
 	 *
@@ -555,7 +576,8 @@ cb_add(void *arg1,
 		changed = BOOL_TRUE;
 	}
 
-	/* this is redundant: make sure any ino partially dumped
+	/*
+	 * this is redundant: make sure any ino partially dumped
 	 * is completed.
 	 */
 	if (cb_resume && cb_inoresumed(ino)) {
@@ -574,7 +596,8 @@ cb_add(void *arg1,
 		} else {
 			estimated_size = estimate_dump_space(statp);
 
-			/* skip if size is greater than prune size. quota
+			/*
+			 * skip if size is greater than prune size. quota
 			 * files are exempt from the check.
 			 */
 			if (maxdumpfilesize > 0 &&
@@ -688,7 +711,8 @@ cb_inoresumed(xfs_ino_t ino)
 	return BOOL_FALSE;
 }
 
-/* supprt_prune -  does supprt directory entry pruning.
+/*
+ * supprt_prune -  does supprt directory entry pruning.
  * recurses downward looking for modified inodes, & clears supprt
  * (-> nochng) on the way back up after examining all descendents.
  */
@@ -781,7 +805,8 @@ cb_accuminit_sz(void)
 	cb_hdrsz = 0;
 }
 
-/* cb_spinit - initializes context for the startpoint calculation phase of
+/*
+ * cb_spinit - initializes context for the startpoint calculation phase of
  * inomap_build. cb_startptix is the index of the next startpoint to
  * record. cb_incr is the dump space distance between each startpoint.
  * cb_target is the target accum value for the next startpoint.
@@ -796,7 +821,8 @@ cb_spinit(void)
 	cb_accum = 0;
 }
 
-/* cb_startpt - called for each non-directory inode. accumulates the
+/*
+ * cb_startpt - called for each non-directory inode. accumulates the
  * require dump space, and notes startpoints. encodes a heuristic for
  * selecting startpoints. decides for each file whether to include it
  * in the current stream, start a new stream beginning with that file,
@@ -829,13 +855,15 @@ cb_startpt(void *arg1,
 
 	(*inomap_statdonep)++;
 
-	/* skip if no links
+	/*
+	 * skip if no links
 	 */
 	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
-	/* skip if not in inomap or not a non-dir
+	/*
+	 * skip if not in inomap or not a non-dir
 	 */
 	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
 	if (state != MAP_NDR_CHANGE) {
@@ -847,13 +875,15 @@ cb_startpt(void *arg1,
 	estimate = estimate_dump_space(statp);
 	cb_accum += estimate + (EXTENTHDR_SZ * (statp->bs_extents + 1));
 
-	/* loop until no new start points found. loop is necessary
+	/*
+	 * loop until no new start points found. loop is necessary
 	 * to handle the pathological case of a huge file so big it
 	 * spans several streams.
 	 */
 	action = (action_t)HOLD; /* irrelevant, but demanded by lint */
 	do {
-		/* decide what to do: hold, bump, or split. there are
+		/*
+		 * decide what to do: hold, bump, or split. there are
 		 * 8 valid cases to consider:
 		 * 1) accum prior to this file is way too short of the
 		 *    target, and accum incl. this file is also shy: HOLD;
@@ -907,7 +937,8 @@ cb_startpt(void *arg1,
 			}
 		}
 
-		/* perform the action selected above
+		/*
+		 * perform the action selected above
 		 */
 		switch (action) {
 		case (action_t)HOLD:
@@ -947,10 +978,12 @@ cb_startpt(void *arg1,
 	return 0;
 }
 
-/* map context and operators
+/*
+ * map context and operators
  */
 
-/* define structure for ino to gen mapping.
+/*
+ * define structure for ino to gen mapping.
  */
 struct i2gseg {
 	uint64_t s_valid;
@@ -1047,14 +1080,16 @@ SEG_GET_BITS(seg_t *segp, xfs_ino_t ino)
 	return state;
 }
 
-/* context for inomap construction - initialized by map_init
+/*
+ * context for inomap construction - initialized by map_init
  */
 static int
 inomap_init(int igrpcnt)
 {
 	assert(sizeof(hnk_t) == HNKSZ);
 
-	/* lastseg must be initialized with -1 offsets since
+	/*
+	 * lastseg must be initialized with -1 offsets since
 	 * no segments have been added yet */
 	inomap.lastseg.hnkoff = -1;
 	inomap.lastseg.segoff = -1;
@@ -1118,7 +1153,8 @@ inomap_lastseg(int hnkoff)
 		return SEGPERHNK - 1;
 }
 
-/* called for every inode group in the filesystem in increasing inode
+/*
+ * called for every inode group in the filesystem in increasing inode
  * order. adds a new segment to the inomap and ino-to-gen map.
  */
 static int
@@ -1167,7 +1203,8 @@ cb_add_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 	return 0;
 }
 
-/* called for every ino to be added to the map.
+/*
+ * called for every ino to be added to the map.
  */
 static void
 inomap_add(void *contextp, xfs_ino_t ino, gen_t gen, int state)
@@ -1200,7 +1237,8 @@ inomap_free_context(void *p)
 	free(p);
 }
 
-/* use binary search to find the hunk containing the given inode.
+/*
+ * use binary search to find the hunk containing the given inode.
  * use the supplied addr as the starting point for the search.
  */
 static bool_t
@@ -1230,7 +1268,8 @@ inomap_find_hnk(seg_addr_t *addrp, xfs_ino_t ino)
 	return BOOL_FALSE;
 }
 
-/* use binary search to find the hunk containing the given
+/*
+ * use binary search to find the hunk containing the given
  * inode, and then binary search the hunk to find the correct
  * segment, if any. use the supplied addr as the starting
  * point for the search.
@@ -1413,7 +1452,8 @@ inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
 void
 inomap_writehdr(content_inode_hdr_t *scwhdrp)
 {
-	/* update the inomap info in the content header
+	/*
+	 * update the inomap info in the content header
 	 */
 	scwhdrp->cih_inomap_hnkcnt = inomap.lastseg.hnkoff + 1;
 	scwhdrp->cih_inomap_segcnt = inomap_addr2segix(&inomap.lastseg) + 1;
@@ -1431,7 +1471,8 @@ inomap_dump(drive_t *drivep)
 	hnk_t *hnkp;
 	hnk_t tmphnkp;
 
-	/* use write_buf to dump the hunks
+	/*
+	 * use write_buf to dump the hunks
 	 */
 	for (addr.hnkoff = 0;
 	      addr.hnkoff <= inomap.lastseg.hnkoff;
@@ -1484,11 +1525,13 @@ subtreelist_parse(jdm_fshandle_t *fshandlep,
 {
 	ix_t subtreeix;
 
-	/* add the root ino to the dump
+	/*
+	 * add the root ino to the dump
 	 */
 	cb_add(NULL, fshandlep, fsfd, rootstatp);
 
-	/* do a recursive descent for each subtree specified
+	/*
+	 * do a recursive descent for each subtree specified
 	 */
 	for (subtreeix = 0; subtreeix < subtreecnt; subtreeix++) {
 		int cbrval = 0;
@@ -1524,18 +1567,21 @@ subtreelist_parse_cb(void *arg1,
 {
 	int cbrval = 0;
 
-	/* arg1 is used to carry the tail of the subtree path
+	/*
+	 * arg1 is used to carry the tail of the subtree path
 	 */
 	char *subpath = (char *)arg1;
 
-	/* temporarily terminate the subpath at the next slash
+	/*
+	 * temporarily terminate the subpath at the next slash
 	 */
 	char *nextslash = strchr(subpath, '/');
 	if (nextslash) {
 		*nextslash = 0;
 	}
 
-	/* if the first element of the subpath doesn't match this
+	/*
+	 * if the first element of the subpath doesn't match this
 	 * directory entry, try the next entry.
 	 */
 	if (strcmp(subpath, name)) {
@@ -1545,13 +1591,15 @@ subtreelist_parse_cb(void *arg1,
 		return 0;
 	}
 
-	/* it matches, so add ino to list and continue down the path
+	/*
+	 * it matches, so add ino to list and continue down the path
 	 */
 	cb_add(NULL, fshandlep, fsfd, statp);
 
 	if (nextslash) {
 
-		/* if we're not at the end of the path, yet the current
+		/*
+		 * if we're not at the end of the path, yet the current
 		 * path element is not a directory, complain and abort the
 		 * iteration in a way which terminates the application
 		 */
@@ -1560,11 +1608,13 @@ subtreelist_parse_cb(void *arg1,
 			return 2;
 		}
 
-		/* repair the subpath
+		/*
+		 * repair the subpath
 		*/
 		*nextslash = '/';
 
-		/* peel the first element of the subpath and recurse
+		/*
+		 * peel the first element of the subpath and recurse
 		*/
 		(void)diriter(fshandlep,
 				 fsfd,
@@ -1577,7 +1627,8 @@ subtreelist_parse_cb(void *arg1,
 		return cbrval;
 
 	} else {
-		/* we've reached the specified subpath, so if we're
+		/*
+		 * we've reached the specified subpath, so if we're
 		 * at a directory, recurse down and add all children
 		 * to the inomap.
 		 */
@@ -1624,7 +1675,8 @@ subtree_descend_cb(void *arg1,
 	return cbrval;
 }
 
-/* uses the extent map to figure the first offset in the file
+/*
+ * uses the extent map to figure the first offset in the file
  * with qty real (non-hole) bytes behind it
  */
 #define BMAP_LEN	512
@@ -1638,7 +1690,8 @@ quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 	off64_t offset_next;
 	off64_t qty_accum;
 
-	/* If GETOPT_DUMPASOFFLINE was specified and the HSM provided an
+	/*
+	 * If GETOPT_DUMPASOFFLINE was specified and the HSM provided an
 	 * estimate, then use it.
 	 */
 
@@ -1709,14 +1762,16 @@ estimate_dump_space(xfs_bstat_t *statp)
 {
 	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:
-		/* very rough: must improve this.  If GETOPT_DUMPASOFFLINE was
+		/*
+		 * very rough: must improve this.  If GETOPT_DUMPASOFFLINE was
 		 * specified and the HSM provided an estimate, then use it.
 		 */
 		if (hsm_fs_ctxtp) {
 			off64_t	bytes;
 			int accurate;
 
-			/* if -z or multiple streams are being used,
+			/*
+			 * if -z or multiple streams are being used,
 			 * we need an accurate estimate. otherwise a
 			 * quick estimate will do.
 			 */
@@ -1735,7 +1790,8 @@ estimate_dump_space(xfs_bstat_t *statp)
 	case S_IFBLK:
 	case S_IFSOCK:
 	case S_IFLNK:
-	/* not yet
+	/*
+	 * not yet
 	case S_IFUUID:
 	*/
 		return 0;
diff --git a/dump/inomap.h b/dump/inomap.h
index 64b769a..b9619f6 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -18,7 +18,8 @@
 #ifndef INOMAP_H
 #define INOMAP_H
 
-/* inomap.[hc] - inode map abstraction
+/*
+ * inomap.[hc] - inode map abstraction
  *
  * an inode map describes the inode numbers (inos) in a file system dump.
  * the map identifies which inos are in-use by the fs, which of those are
@@ -31,7 +32,8 @@
  */
 struct xfs_bstat;
 
-/* inomap_build - this function allocates and constructs an in-memory
+/*
+ * inomap_build - this function allocates and constructs an in-memory
  * representation of the bitmap. it prunes from the map inos of files not
  * changed since the last dump, inos not identified by the subtree list,
  * and directories not needed to represent a hierarchy containing
@@ -68,25 +70,29 @@ extern bool_t inomap_build(void *fshandlep,
 
 extern uint64_t inomap_getsz(void);
 
-/* inomap_skip - tell inomap about inodes to skip in the dump
+/*
+ * inomap_skip - tell inomap about inodes to skip in the dump
  */
 extern void inomap_skip(xfs_ino_t ino);
 
 
-/* inomap_writehdr - updates the write header with inomap-private info
+/*
+ * inomap_writehdr - updates the write header with inomap-private info
  * to be communicated to the restore side
  */
 extern void inomap_writehdr(content_inode_hdr_t *scwhdrp);
 
 
-/* inomap_dump - dumps the map to media - content-abstraction-knowledgable
+/*
+ * inomap_dump - dumps the map to media - content-abstraction-knowledgable
  *
  * returns error from media write op
  */
 extern rv_t inomap_dump(drive_t *drivep);
 
 
-/* map state values
+/*
+ * map state values
  */
 #define MAP_INO_UNUSED	0       /* ino not in use by fs */
 #define MAP_DIR_NOCHNG	1       /* dir, ino in use by fs, but not dumped */
@@ -97,7 +103,8 @@ extern rv_t inomap_dump(drive_t *drivep);
 #define MAP_RESERVED1	6       /* this state currently not used */
 #define MAP_RESERVED2	7       /* this state currently not used */
 
-/* the inomap is implemented as a linked list of chunks. each chunk contains
+/*
+ * the inomap is implemented as a linked list of chunks. each chunk contains
  * an array of map segments. a map segment contains a start ino and a
  * bitmap of 64 3-bit state values (see MAP_... in inomap.h). the SEG_macros
  * index and manipulate the 3-bit state values.
@@ -125,7 +132,8 @@ struct hnk {
 
 typedef struct hnk hnk_t;
 
-/* functions to get state and gen information from the inomap.
+/*
+ * functions to get state and gen information from the inomap.
  * requires a pointer to a context block, obtained from
  * inomap_alloc_context(), and released by inomap_free_context().
  */
@@ -136,7 +144,8 @@ extern int inomap_get_state(void *contextp, xfs_ino_t ino);
 extern int inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen);
 
 
-/* generators returning the next dir or non-dir ino selected in this dump.
+/*
+ * generators returning the next dir or non-dir ino selected in this dump.
  * returns INO64MAX when no more inos.
  * requires a pointer to a context block, obtained from
  * inomap_alloc_context(), and released by inomap_free_context().
diff --git a/dump/var.c b/dump/var.c
index 8ea38af..a195693 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -85,7 +85,8 @@ var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino))
 	uuid_t fsid;
 	int rval;
 
-	/* see if the fs uuid's match
+	/*
+	 * see if the fs uuid's match
 	 */
 	rval = fs_getid(XFSDUMP_DIRPATH, &fsid);
 	if (rval) {
@@ -105,7 +106,8 @@ var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino))
 		return;
 	}
 
-	/* traverse the xfsdump directory, getting inode numbers of it
+	/*
+	 * traverse the xfsdump directory, getting inode numbers of it
 	 * and all of its children, and reporting those to the callback.
 	 */
 	var_skip_recurse(XFSDUMP_DIRPATH, cb);
@@ -149,7 +151,8 @@ var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 	while ((direntp = readdir(dirp)) != NULL) {
 		char *path;
 
-		/* skip "." and ".."
+		/*
+		 * skip "." and ".."
 		 */
 		if (*(direntp->d_name + 0) == '.'
 		     &&
-- 
2.19.1
