Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 19:32:20 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7B2VrDW023624
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 19:32:03 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k7B2VFnx015947
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 21:31:16 -0500
Received: from [134.15.0.69] (mtv-vpn-sw-corp-0-69.corp.sgi.com [134.15.0.69])
	by internal-mail-relay1.corp.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k7B2Um8s29050993
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 19:30:48 -0700 (PDT)
Message-ID: <44DBEBD7.7020405@sgi.com>
Date: Thu, 10 Aug 2006 19:30:47 -0700
From: Madan Valluri <mvalluri@sgi.com>
MIME-Version: 1.0
Subject: Review: Repair multi-threading code
Content-Type: multipart/mixed;
 boundary="------------020505020607020101000806"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020505020607020101000806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a patch which implements pthread based multi-threading in 
xfs_repair.

For a small file system, on Irix, I observed the following run times:

With no optimization: 10 minutes 21 seconds
With multi-threading (only): 7 minutes 35 seconds
With lio_listio pre-fetching (only): 3 minutes 59 seconds
With both multi-threading and lio_listio pre-fetching: 3 minutes and 14 
seconds.


For a large fs:
With no optimizations: ~36 hours
With both multi-threading and pre-fetching: ~7 hours.

Thanks.

/Madan Valluri

--------------020505020607020101000806
Content-Type: text/plain;
 name="mt.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mt.txt"


===========================================================================
irix/Makefile
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/irix/Makefile_1.4	Wed Aug  9 12:12:44 2006
+++ irix/Makefile	Sun May 14 23:26:31 2006
@@ -2,7 +2,8 @@
 
 include	$(ROOT)/usr/include/make/commondefs
 
-SUBDIRS	= include libxfs libxlog libxcmd libhandle io quota repair man
+#SUBDIRS	= include libxfs libxlog libxcmd libhandle io quota repair man
+SUBDIRS	= include libxfs libxlog repair
 
 default install $(COMMONTARGS) lint debug: $(_FORCE)
 	$(SUBDIRS_MAKERULE)

===========================================================================
irix/repair/Makefile
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/irix/repair/Makefile_1.3	Wed Aug  9 12:12:44 2006
+++ irix/repair/Makefile	Wed Aug  9 11:30:40 2006
@@ -18,13 +18,13 @@
 LHFILES = \
 	agheader.h attr_repair.h avl.h avl64.h bmap.h dinode.h dir.h \
 	dir2.h dir_stack.h globals.h incore.h protos.h scan.h rt.h \
-	err_protos.h versions.h prefetch.h
+	err_protos.h versions.h prefetch.h threads.h
 LCFILES = \
 	agheader.c attr_repair.c avl.c avl64.c bmap.c dir.c dir2.c \
 	dino_chunks.c dinode.c dir_stack.c globals.c incore.c \
-	incore_bmc.c incore_ext.c incore_ino.c init.c io.c \
+	incore_bmc.c incore_ext.c incore_ino.c init.c \
 	phase1.c phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
-	prefetch.c rt.c sb.c scan.c versions.c xfs_repair.c
+	prefetch.c rt.c sb.c scan.c versions.c xfs_repair.c threads.c
 
 LOBJS = $(LCFILES:.c=.o)
 LDIRT = $(LHFILES) $(LCFILES) Makedepend $(TARGETS)

===========================================================================
xfsprogs/include/libxfs.h
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/include/libxfs.h_1.55	Wed Aug  9 12:12:44 2006
+++ xfsprogs/include/libxfs.h	Wed Aug  9 11:02:10 2006
@@ -577,6 +577,7 @@
 #define	LIBXFS_LIO_TYPE_RAW		0x3
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
+extern int libxfs_nproc(void);
 
 #include <xfs/xfs_ialloc.h>
 #include <xfs/xfs_rtalloc.h>

===========================================================================
xfsprogs/libxfs/darwin.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/darwin.c_1.10	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/darwin.c	Wed Aug  9 10:47:38 2006
@@ -118,3 +118,9 @@
 {
 	return (sizeof(void *));
 }
+
+int
+platform_nproc(void)
+{
+	return 1;
+}

===========================================================================
xfsprogs/libxfs/freebsd.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/freebsd.c_1.13	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/freebsd.c	Wed Aug  9 10:49:45 2006
@@ -178,3 +178,9 @@
 {
 	return (sizeof(void *));
 }
+
+int
+platform_nproc(void)
+{
+	return 1;
+}

===========================================================================
xfsprogs/libxfs/init.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/init.c_1.49	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/init.c	Wed Aug  9 10:54:35 2006
@@ -703,3 +703,9 @@
 	c = asctime(localtime(&t));
 	fprintf(fp, "%s", c);
 }
+
+int
+libxfs_nproc(void)
+{
+	return platform_nproc();
+}

===========================================================================
xfsprogs/libxfs/init.h
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/init.h_1.10	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/init.h	Wed Aug  9 10:42:47 2006
@@ -33,5 +33,6 @@
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
 extern int platform_aio_init (int aio_count);
+extern int platform_nproc(void);
 
 #endif	/* LIBXFS_INIT_H */

===========================================================================
xfsprogs/libxfs/irix.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/irix.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/irix.c	Wed Aug  9 10:59:27 2006
@@ -19,6 +19,7 @@
 #include <xfs/libxfs.h>
 #include <aio.h>
 #include <diskinfo.h>
+#include <sys/sysmp.h>
 
 extern char *progname;
 extern __int64_t findsize(char *);
@@ -102,3 +103,10 @@
 {
 	return (sizeof(void *));
 }
+
+int
+platform_nproc(void)
+{
+	return sysmp(MP_NPROCS);
+}
+

===========================================================================
xfsprogs/libxfs/linux.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/libxfs/linux.c_1.14	Wed Aug  9 12:12:44 2006
+++ xfsprogs/libxfs/linux.c	Wed Aug  9 10:56:29 2006
@@ -207,3 +207,24 @@
 		return getpagesize();
 	return max_block_alignment;
 }
+
+int
+platform_nproc(void)
+{
+	FILE *fp;
+	char buffer[256];
+	int nproc;
+
+	fp = fopen("/proc/stat", "r");
+	if (fp) {
+		nproc = 0;
+		while (fgets(buffer, sizeof(buffer), fp)) {
+			if (strncmp(buffer, "cpu", 3) == 0)
+				nproc++;
+		}
+		fclose(fp);
+		if (nproc > 1)
+			return (nproc - 1);	/* discard the initial aggregate cpu entry */
+	}
+	return 1;
+}

===========================================================================
xfsprogs/repair/Makefile
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/Makefile_1.15	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/Makefile	Wed Aug  9 11:04:02 2006
@@ -9,13 +9,13 @@
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h dinode.h dir.h \
 	dir2.h dir_stack.h err_protos.h globals.h incore.h protos.h rt.h \
-	scan.h versions.h prefetch.h
+	scan.h versions.h prefetch.h threads.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c dino_chunks.c \
 	dinode.c dir.c dir2.c dir_stack.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c rt.c sb.c \
-	prefetch.c scan.c versions.c xfs_repair.c
+	prefetch.c scan.c versions.c xfs_repair.c threads.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)

===========================================================================
xfsprogs/repair/dino_chunks.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/dino_chunks.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/dino_chunks.c	Wed Jul 12 16:24:50 2006
@@ -26,6 +26,7 @@
 #include "dir.h"
 #include "dinode.h"
 #include "prefetch.h"
+#include "threads.h"
 #include "versions.h"
 
 /*
@@ -148,16 +149,19 @@
 		if (check_inode_block(mp, ino) == 0)
 			return(0);
 
+		PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 		switch (state = get_agbno_state(mp, agno, agbno))  {
 		case XR_E_INO:
 			do_warn(
 		_("uncertain inode block %d/%d already known\n"),
 				agno, agbno);
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 			break;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
 			set_agbno_state(mp, agno, agbno, XR_E_INO);
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE:
@@ -170,6 +174,7 @@
 		_("inode block %d/%d multiply claimed, (state %d)\n"),
 				agno, agbno, state);
 			set_agbno_state(mp, agno, agbno, XR_E_MULT);
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 			return(0);
 		default:
 			do_warn(
@@ -176,6 +181,7 @@
 		_("inode block %d/%d bad state, (state %d)\n"),
 				agno, agbno, state);
 			set_agbno_state(mp, agno, agbno, XR_E_INO);
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 			break;
 		}
 
@@ -425,6 +431,7 @@
 	 * user data -- we're probably here as a result of a directory
 	 * entry or an iunlinked pointer
 	 */
+	PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 	for (j = 0, cur_agbno = chunk_start_agbno;
 			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
 		switch (state = get_agbno_state(mp, agno, cur_agbno))  {
@@ -447,9 +454,12 @@
 			break;
 		}
 
-		if (j)
+		if (j) {
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 			return(0);
+		}
 	}
+	PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 
 	/*
 	 * ok, chunk is good.  put the record into the tree if required,
@@ -472,6 +482,7 @@
 
 	set_inode_used(irec_p, agino - start_agino);
 
+	PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 	for (cur_agbno = chunk_start_agbno;
 			cur_agbno < chunk_stop_agbno; cur_agbno++)  {
 		switch (state = get_agbno_state(mp, agno, cur_agbno))  {
@@ -501,6 +512,7 @@
 			break;
 		}
 	}
+	PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 
 	return(ino_cnt);
 }
@@ -700,6 +712,7 @@
 	/*
 	 * mark block as an inode block in the incore bitmap
 	 */
+	PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 	switch (state = get_agbno_state(mp, agno, agbno))  {
 	case XR_E_INO:	/* already marked */
 		break;
@@ -717,6 +730,7 @@
 			XFS_AGB_TO_FSB(mp, agno, agbno), state);
 		break;
 	}
+	PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 
 	while (!done)  {
 		/*
@@ -869,6 +883,7 @@
 			ibuf_offset = 0;
 			agbno++;
 
+			PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 			switch (state = get_agbno_state(mp, agno, agbno))  {
 			case XR_E_INO:	/* already marked */
 				break;
@@ -888,6 +903,7 @@
 					XFS_AGB_TO_FSB(mp, agno, agbno), state);
 				break;
 			}
+			PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 
 		} else if (irec_offset == XFS_INODES_PER_CHUNK)  {
 			/*

===========================================================================
xfsprogs/repair/dinode.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/dinode.c_1.24	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/dinode.c	Wed Jul 12 17:20:16 2006
@@ -30,6 +30,7 @@
 #include "versions.h"
 #include "attr_repair.h"
 #include "bmap.h"
+#include "threads.h"
 
 /*
  * inode clearing routines
@@ -514,6 +515,29 @@
 }
 
 /*
+ * process_bmbt_reclist_int is the most compute intensive
+ * function in repair. The following macros reduce the
+ * the large number of lock/unlock steps it would otherwise
+ * call.
+ */
+#define	PROCESS_BMBT_DECL(type, var)	type var
+
+#define	PROCESS_BMBT_LOCK(agno)							\
+	if (do_parallel && (agno != locked_agno)) {				\
+		if (locked_agno != -1)	/* release old ag lock */		\
+			PREPAIR_RW_UNLOCK_NOTEST(&per_ag_lock[locked_agno]);	\
+		PREPAIR_RW_WRITE_LOCK_NOTEST(&per_ag_lock[agno]);		\
+		locked_agno = agno;						\
+	}
+
+#define	PROCESS_BMBT_UNLOCK_RETURN(val)						\
+	do {									\
+		if (locked_agno != -1) 						\
+			PREPAIR_RW_UNLOCK_NOTEST(&per_ag_lock[locked_agno]);	\
+		return (val);							\
+	} while (0)
+
+/*
  * return 1 if inode should be cleared, 0 otherwise
  * if check_dups should be set to 1, that implies that
  * the primary purpose of this call is to see if the
@@ -552,6 +576,8 @@
 	xfs_dfsbno_t		e;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	PROCESS_BMBT_DECL
+				(xfs_agnumber_t, locked_agno=-1);
 
 	if (whichfork == XFS_DATA_FORK)
 		forkname = _("data");
@@ -574,7 +600,7 @@
 	_("bmap rec out of order, inode %llu entry %d "
 	  "[o s c] [%llu %llu %llu], %d [%llu %llu %llu]\n"),
 				ino, i, o, s, c, i-1, op, sp, cp);
-			return(1);
+			PROCESS_BMBT_UNLOCK_RETURN(1);
 		}
 		op = o;
 		cp = c;
@@ -587,7 +613,7 @@
 			do_warn(
 	_("zero length extent (off = %llu, fsbno = %llu) in ino %llu\n"),
 				o, s, ino);
-			return(1);
+			PROCESS_BMBT_UNLOCK_RETURN(1);
 		}
 		if (type == XR_INO_RTDATA) {
 			if (s >= mp->m_sb.sb_rblocks)  {
@@ -594,13 +620,13 @@
 				do_warn(
 	_("inode %llu - bad rt extent start block number %llu, offset %llu\n"),
 					ino, s, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 			if (s + c - 1 >= mp->m_sb.sb_rblocks)  {
 				do_warn(
 	_("inode %llu - bad rt extent last block number %llu, offset %llu\n"),
 					ino, s + c - 1, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 			if (s + c - 1 < s)  {
 				do_warn(
@@ -607,7 +633,7 @@
 	_("inode %llu - bad rt extent overflows - start %llu, end %llu, "
 	  "offset %llu\n"),
 					ino, s, s + c - 1, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 		} else  {
 			switch (verify_dfsbno_range(mp, s, c)) {
@@ -617,12 +643,12 @@
 				do_warn(
 	_("inode %llu - bad extent starting block number %llu, offset %llu\n"),
 					ino, s, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			case XR_DFSBNORANGE_BADEND:
 				do_warn(
 	_("inode %llu - bad extent last block number %llu, offset %llu\n"),
 					ino, s + c - 1, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			case XR_DFSBNORANGE_OVERFLOW:
 				do_warn(
 
@@ -629,7 +655,7 @@
 	_("inode %llu - bad extent overflows - start %llu, end %llu, "
 	  "offset %llu\n"),
 					ino, s, s + c - 1, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 			if (o >= fs_max_file_offset)  {
 				do_warn(
@@ -636,7 +662,7 @@
 	_("inode %llu - extent offset too large - start %llu, count %llu, "
 	  "offset %llu\n"),
 					ino, s, c, o);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 		}
 
@@ -654,7 +680,7 @@
 				do_warn(
 	_("malformed rt inode extent [%llu %llu] (fs rtext size = %u)\n"),
 					s, c, mp->m_sb.sb_rextsize);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 
 			/*
@@ -676,7 +702,7 @@
 	_("data fork in rt ino %llu claims dup rt extent, off - %llu, "
 	  "start - %llu, count %llu\n"),
 							ino, o, s, c);
-						return(1);
+						PROCESS_BMBT_UNLOCK_RETURN(1);
 					}
 					continue;
 				}
@@ -714,7 +740,7 @@
 					do_warn(
 	_("%s fork in rt inode %llu claims used rt block %llu\n"),
 						forkname, ino, ext);
-					return(1);
+					PROCESS_BMBT_UNLOCK_RETURN(1);
 				case XR_E_FREE1:
 				default:
 					do_error(
@@ -748,6 +774,7 @@
 		agno = XFS_FSB_TO_AGNO(mp, s);
 		agbno = XFS_FSB_TO_AGBNO(mp, s);
 		e = s + c;
+		PROCESS_BMBT_LOCK(agno);
 		for (b = s; b < e; b++, agbno++)  {
 			if (check_dups == 1)  {
 				/*
@@ -761,7 +788,7 @@
 	_("%s fork in ino %llu claims dup extent, off - %llu, "
 	  "start - %llu, cnt %llu\n"),
 						forkname, ino, o, s, c);
-					return(1);
+					PROCESS_BMBT_UNLOCK_RETURN(1);
 				}
 				continue;
 			}
@@ -772,7 +799,7 @@
 			 */
 			if (type == XR_INO_RTDATA && whichfork == XFS_ATTR_FORK) {
 			  if (mp->m_sb.sb_agcount < agno)
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
 
 			/* Process in chunks of 16 (XR_BB_UNIT/XR_BB) 
@@ -809,7 +836,7 @@
 				do_warn(
 			_("%s fork in inode %llu claims metadata block %llu\n"),
 					forkname, ino, (__uint64_t) b);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			case XR_E_INUSE:
 			case XR_E_MULT:
 				set_agbno_state(mp, agno, agbno, XR_E_MULT);
@@ -816,7 +843,7 @@
 				do_warn(
 			_("%s fork in %s inode %llu claims used block %llu\n"),
 					forkname, ftype, ino, (__uint64_t) b);
-				return(1);
+				PROCESS_BMBT_UNLOCK_RETURN(1);
 			default:
 				do_error(
 			_("illegal state %d in block map %llu\n"),
@@ -827,7 +854,7 @@
 		*tot += c;
 	}
 
-	return(0);
+	PROCESS_BMBT_UNLOCK_RETURN(0);
 }
 
 /*

===========================================================================
xfsprogs/repair/dir_stack.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/dir_stack.c_1.9	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/dir_stack.c	Wed Jul 12 23:44:40 2006
@@ -19,6 +19,7 @@
 #include <libxfs.h>
 #include "dir_stack.h"
 #include "err_protos.h"
+#include "threads.h"
 
 /*
  * a directory stack for holding directories while
@@ -29,7 +30,10 @@
 
 static dir_stack_t	dirstack_freelist;
 static int		dirstack_init = 0;
+static pthread_mutex_t	dirstack_mutex;
+static pthread_mutexattr_t dirstack_mutexattr;
 
+
 void
 dir_stack_init(dir_stack_t *stack)
 {
@@ -38,6 +42,11 @@
 
 	if (dirstack_init == 0)  {
 		dirstack_init = 1;
+		PREPAIR_MTX_ATTR_INIT(&dirstack_mutexattr);
+#ifdef PTHREAD_MUTEX_SPINBLOCK_NP
+		PREPAIR_MTX_ATTR_SET(&dirstack_mutexattr, PTHREAD_MUTEX_SPINBLOCK_NP);
+#endif
+		PREPAIR_MTX_LOCK_INIT(&dirstack_mutex, &dirstack_mutexattr);
 		dir_stack_init(&dirstack_freelist);
 	}
 
@@ -85,8 +94,10 @@
 {
 	dir_stack_elem_t *elem;
 
+	PREPAIR_MTX_LOCK(&dirstack_mutex);
 	if (dirstack_freelist.cnt == 0)  {
 		if ((elem = malloc(sizeof(dir_stack_elem_t))) == NULL)  {
+			PREPAIR_MTX_UNLOCK(&dirstack_mutex);
 			do_error(
 		_("couldn't malloc dir stack element, try more swap\n"));
 			exit(1);
@@ -94,6 +105,7 @@
 	} else  {
 		elem = dir_stack_pop(&dirstack_freelist);
 	}
+	PREPAIR_MTX_UNLOCK(&dirstack_mutex);
 
 	elem->ino = ino;
 
@@ -116,7 +128,9 @@
 	ino = elem->ino;
 	elem->ino = NULLFSINO;
 
+	PREPAIR_MTX_LOCK(&dirstack_mutex);
 	dir_stack_push(&dirstack_freelist, elem);
+	PREPAIR_MTX_UNLOCK(&dirstack_mutex);
 
 	return(ino);
 }

===========================================================================
xfsprogs/repair/globals.h
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/globals.h_1.15	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/globals.h	Wed Aug  9 11:05:12 2006
@@ -191,8 +191,10 @@
 EXTERN __uint32_t	sb_unit;
 EXTERN __uint32_t	sb_width;
 
-extern size_t ts_dirbuf_size;
-extern size_t ts_dir_freemap_size;
-extern size_t ts_attr_freemap_size;
+extern size_t 		ts_dirbuf_size;
+extern size_t 		ts_dir_freemap_size;
+extern size_t 		ts_attr_freemap_size;
+
+EXTERN pthread_rwlock_t	*per_ag_lock;
 
 #endif /* _XFS_REPAIR_GLOBAL_H */

===========================================================================
xfsprogs/repair/incore.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/incore.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/incore.c	Wed Jul 12 16:27:08 2006
@@ -23,6 +23,7 @@
 #include "agheader.h"
 #include "protos.h"
 #include "err_protos.h"
+#include "threads.h"
 
 /*
  * push a block allocation record onto list.  assumes list
@@ -64,6 +65,7 @@
 		do_error(_("couldn't allocate block map pointers\n"));
 		return;
 	}
+	PREPAIR_RW_LOCK_ALLOC(per_ag_lock, agno);
 	for (i = 0; i < agno; i++)  {
 		size = roundup((numblocks+(NBBY/XR_BB)-1) / (NBBY/XR_BB),
 		       		sizeof(__uint64_t));
@@ -75,6 +77,7 @@
 			return;
 		}
 		bzero(ba_bmap[i], size);
+		PREPAIR_RW_LOCK_INIT(&per_ag_lock[i], NULL);
 	}
 
 	if (rtblocks == 0)  {

===========================================================================
xfsprogs/repair/incore_ext.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/incore_ext.c_1.10	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/incore_ext.c	Wed Aug  9 10:11:47 2006
@@ -24,6 +24,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "avl64.h"
+#include "threads.h"
 #define ALLOC_NUM_EXTS		100
 
 /*
@@ -92,6 +93,13 @@
 static ba_rec_t		*rt_ba_list;
 
 /*
+ * locks.
+ */
+static pthread_rwlock_t ext_flist_lock;
+static pthread_rwlock_t rt_ext_tree_lock;
+static pthread_rwlock_t rt_ext_flist_lock;
+
+/*
  * extent tree stuff is avl trees of duplicate extents,
  * sorted in order by block number.  there is one tree per ag.
  */
@@ -104,6 +112,7 @@
 	extent_tree_node_t *new;
 	extent_alloc_rec_t *rec;
 
+	PREPAIR_RW_WRITE_LOCK(&ext_flist_lock);
 	if (ext_flist.cnt == 0)  {
 		ASSERT(ext_flist.list == NULL);
 
@@ -130,6 +139,7 @@
 	ext_flist.list = (extent_tree_node_t *) new->avl_node.avl_nextino;
 	ext_flist.cnt--;
 	new->avl_node.avl_nextino = NULL;
+	PREPAIR_RW_UNLOCK(&ext_flist_lock);
 
 	/* initialize node */
 
@@ -145,9 +155,11 @@
 void
 release_extent_tree_node(extent_tree_node_t *node)
 {
+	PREPAIR_RW_WRITE_LOCK(&ext_flist_lock);
 	node->avl_node.avl_nextino = (avlnode_t *) ext_flist.list;
 	ext_flist.list = node;
 	ext_flist.cnt++;
+	PREPAIR_RW_UNLOCK(&ext_flist_lock);
 
 	return;
 }
@@ -658,6 +670,7 @@
 	rt_extent_tree_node_t *new;
 	rt_extent_alloc_rec_t *rec;
 
+	PREPAIR_RW_WRITE_LOCK(&rt_ext_flist_lock);
 	if (rt_ext_flist.cnt == 0)  {
 		ASSERT(rt_ext_flist.list == NULL);
 
@@ -684,6 +697,7 @@
 	rt_ext_flist.list = (rt_extent_tree_node_t *) new->avl_node.avl_nextino;
 	rt_ext_flist.cnt--;
 	new->avl_node.avl_nextino = NULL;
+	PREPAIR_RW_UNLOCK(&rt_ext_flist_lock);
 
 	/* initialize node */
 
@@ -762,6 +776,7 @@
 	xfs_drtbno_t new_startblock;
 	xfs_extlen_t new_blockcount;
 
+	PREPAIR_RW_WRITE_LOCK(&rt_ext_tree_lock);
 	avl64_findranges(rt_ext_tree_ptr, startblock - 1,
 		startblock + blockcount + 1,
 		(avl64node_t **) &first, (avl64node_t **) &last);
@@ -779,6 +794,7 @@
 			do_error(_("duplicate extent range\n"));
 		}
 
+		PREPAIR_RW_UNLOCK(&rt_ext_tree_lock);
 		return;
 	}
 
@@ -802,8 +818,10 @@
 		 * just bail if the new extent is contained within an old one
 		 */
 		if (ext->rt_startblock <= startblock &&
-				ext->rt_blockcount >= blockcount)
+				ext->rt_blockcount >= blockcount) {
+			PREPAIR_RW_UNLOCK(&rt_ext_tree_lock);
 			return;
+		}
 		/*
 		 * now check for overlaps and adjacent extents
 		 */
@@ -831,6 +849,7 @@
 		do_error(_("duplicate extent range\n"));
 	}
 
+	PREPAIR_RW_UNLOCK(&rt_ext_tree_lock);
 	return;
 }
 
@@ -841,10 +860,15 @@
 int
 search_rt_dup_extent(xfs_mount_t *mp, xfs_drtbno_t bno)
 {
-	if (avl64_findrange(rt_ext_tree_ptr, bno) != NULL)
-		return(1);
+	int ret;
 
-	return(0);
+	PREPAIR_RW_READ_LOCK(&rt_ext_tree_lock);
+	if (avl64_findrange(rt_ext_tree_ptr, bno) != NULL)
+		ret = 1;
+	else
+		ret = 0;
+	PREPAIR_RW_UNLOCK(&rt_ext_tree_lock);
+	return(ret);
 }
 
 static __uint64_t
@@ -873,6 +897,9 @@
 
 	ba_list = NULL;
 	rt_ba_list = NULL;
+	PREPAIR_RW_LOCK_INIT(&ext_flist_lock, NULL);
+	PREPAIR_RW_LOCK_INIT(&rt_ext_tree_lock, NULL);
+	PREPAIR_RW_LOCK_INIT(&rt_ext_flist_lock, NULL);
 
 	if ((extent_tree_ptrs = malloc(agcount *
 					sizeof(avltree_desc_t *))) == NULL)

===========================================================================
xfsprogs/repair/incore_ino.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/incore_ino.c_1.13	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/incore_ino.c	Wed Jul 12 16:47:03 2006
@@ -22,8 +22,10 @@
 #include "incore.h"
 #include "agheader.h"
 #include "protos.h"
+#include "threads.h"
 #include "err_protos.h"
 
+static pthread_rwlock_t ino_flist_lock;
 extern avlnode_t	*avl_firstino(avlnode_t *root);
 
 /*
@@ -69,6 +71,7 @@
 	ino_tree_node_t *new;
 	avlnode_t *node;
 
+	PREPAIR_RW_WRITE_LOCK(&ino_flist_lock);
 	if (ino_flist.cnt == 0)  {
 		ASSERT(ino_flist.list == NULL);
 
@@ -92,6 +95,7 @@
 	ino_flist.cnt--;
 	node = &new->avl_node;
 	node->avl_nextino = node->avl_forw = node->avl_back = NULL;
+	PREPAIR_RW_UNLOCK(&ino_flist_lock);
 
 	/* initialize node */
 
@@ -115,6 +119,7 @@
 	ino_rec->avl_node.avl_forw = NULL;
 	ino_rec->avl_node.avl_back = NULL;
 
+	PREPAIR_RW_WRITE_LOCK(&ino_flist_lock);
 	if (ino_flist.list != NULL)  {
 		ASSERT(ino_flist.cnt > 0);
 		ino_rec->avl_node.avl_nextino = (avlnode_t *) ino_flist.list;
@@ -132,6 +137,7 @@
 		if (ino_rec->ino_un.plist != NULL)
 			free(ino_rec->ino_un.plist);
 	}
+	PREPAIR_RW_UNLOCK(&ino_flist_lock);
 
 	return;
 }
@@ -643,6 +649,7 @@
 	int i;
 	int agcount = mp->m_sb.sb_agcount;
 
+	PREPAIR_RW_LOCK_INIT(&ino_flist_lock, NULL);
 	if ((inode_tree_ptrs = malloc(agcount *
 					sizeof(avltree_desc_t *))) == NULL)
 		do_error(_("couldn't malloc inode tree descriptor table\n"));

===========================================================================
xfsprogs/repair/init.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/init.c_1.18	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/init.c	Wed Aug  9 11:06:22 2006
@@ -43,12 +43,17 @@
 }
 
 static void
-ts_init(void)
+ts_create(void)
 {
 	/* create thread specific keys */
 	pthread_key_create(&dirbuf_key, NULL);
 	pthread_key_create(&dir_freemap_key, NULL);
 	pthread_key_create(&attr_freemap_key, NULL);
+}
+
+void
+ts_init(void)
+{
 
 	/* allocate thread specific storage */
 	ts_alloc(dirbuf_key, 1, ts_dirbuf_size);
@@ -136,6 +141,7 @@
 	if (!libxfs_init(args))
 		do_error(_("couldn't initialize XFS library\n"));
 
+	ts_create();
 	ts_init();
 	increase_rlimit();
 	if (do_prefetch) {
@@ -143,4 +149,5 @@
 		if (do_prefetch)
 			libxfs_lio_allocate();
 	}
+	thread_init();
 }

===========================================================================
xfsprogs/repair/phase3.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/phase3.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/phase3.c	Wed Aug  9 11:54:16 2006
@@ -24,6 +24,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "dinode.h"
+#include "threads.h"
 
 /*
  * walks an unlinked list, returns 1 on an error (bogus pointer) or
@@ -57,6 +58,7 @@
 				add_aginode_uncertain(agno, current_ino, 1);
 				agbno = XFS_AGINO_TO_AGBNO(mp, current_ino);
 
+				PREPAIR_RW_WRITE_LOCK(&per_ag_lock[agno]);
 				switch (state = get_agbno_state(mp,
 							agno, agbno))  {
 				case XR_E_UNKNOWN:
@@ -64,8 +66,10 @@
 				case XR_E_FREE1:
 					set_agbno_state(mp, agno, agbno,
 						XR_E_INO);
+					PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 					break;
 				case XR_E_BAD_STATE:
+					PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 					do_error(_(
 						"bad state in block map %d\n"),
 						state);
@@ -84,6 +88,7 @@
 					 */
 					set_agbno_state(mp, agno, agbno,
 						XR_E_INO);
+					PREPAIR_RW_UNLOCK(&per_ag_lock[agno]);
 					break;
 				}
 			}
@@ -144,6 +149,17 @@
 }
 
 void
+parallel_p3_process_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
+{
+	/*
+	 * turn on directory processing (inode discovery) and
+	 * attribute processing (extra_attr_check)
+	 */
+	do_log(_("        - agno = %d\n"), agno);
+	process_aginodes(mp, agno, 1, 0, 1);
+}
+
+void
 phase3(xfs_mount_t *mp)
 {
 	int i, j;
@@ -171,13 +187,9 @@
 	    "        - process known inodes and perform inode discovery...\n"));
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
-		do_log(_("        - agno = %d\n"), i);
-		/*
-		 * turn on directory processing (inode discovery) and
-		 * attribute processing (extra_attr_check)
-		 */
-		process_aginodes(mp, i, 1, 0, 1);
+		queue_work(parallel_p3_process_aginodes, mp, i);
 	}
+	wait_for_workers();
 
 	/*
 	 * process newly discovered inode chunks

===========================================================================
xfsprogs/repair/phase4.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/phase4.c_1.17	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/phase4.c	Wed Aug  9 11:55:37 2006
@@ -28,6 +28,7 @@
 #include "bmap.h"
 #include "versions.h"
 #include "dir2.h"
+#include "threads.h"
 
 
 /* ARGSUSED */
@@ -1119,6 +1120,18 @@
 
 
 void
+parallel_p4_process_aginodes(xfs_mount_t *mp, xfs_agnumber_t agno)
+{
+	do_log(_("        - agno = %d\n"), agno);
+	process_aginodes(mp, agno, 0, 1, 0);
+
+	/*
+	 * now recycle the per-AG duplicate extent records
+	 */
+	release_dup_extent_tree(agno);
+}
+
+void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
@@ -1325,14 +1338,9 @@
 		 * and attribute processing is turned OFF since we did that
 		 * already in phase 3.
 		 */
-		do_log(_("        - agno = %d\n"), i);
-		process_aginodes(mp, i, 0, 1, 0);
-
-		/*
-		 * now recycle the per-AG duplicate extent records
-		 */
-		release_dup_extent_tree(i);
+		queue_work(parallel_p4_process_aginodes, mp, i);
 	}
+	wait_for_workers();
 
 	/*
 	 * free up memory used to track trealtime duplicate extents

===========================================================================
xfsprogs/repair/phase5.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/phase5.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/phase5.c	Wed Aug  9 11:56:01 2006
@@ -26,6 +26,7 @@
 #include "dinode.h"
 #include "rt.h"
 #include "versions.h"
+#include "threads.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -72,6 +73,9 @@
 	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
 } bt_status_t;
 
+static __uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
+static __uint64_t	*sb_ifree_ag;		/* free inodes per ag */
+static __uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
 
 int
 mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
@@ -1415,7 +1419,7 @@
 }
 
 void
-phase5(xfs_mount_t *mp)
+phase5_function(xfs_mount_t *mp, xfs_agnumber_t agno)
 {
 	__uint64_t	num_inos;
 	__uint64_t	num_free_inos;
@@ -1422,7 +1426,6 @@
 	bt_status_t	bno_btree_curs;
 	bt_status_t	bcnt_btree_curs;
 	bt_status_t	ino_btree_curs;
-	xfs_agnumber_t	agno;
 	int		extra_blocks = 0;
 	uint		num_freeblocks;
 	xfs_extlen_t	freeblks1;
@@ -1436,35 +1439,10 @@
 	extern int	count_bcnt_extents(xfs_agnumber_t);
 #endif
 
-	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
-
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_inobt, 0),
-		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_inobt, 0)
-		);
-	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_inobt, 1),
-		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_inobt, 1)
-		);
-	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
-		XR_INOBT_BLOCK_MAXRECS(mp, 0));
-	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
-		XR_INOBT_BLOCK_MAXRECS(mp, 1));
-	fprintf(stderr, "bnobt level 1, maxrec = %d, minrec = %d\n",
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0),
-		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0));
-	fprintf(stderr, "bnobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 1),
-		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_alloc, 1));
-#endif
-
-	/*
-	 * make sure the root and realtime inodes show up allocated
-	 */
-	keep_fsinos(mp);
+	if (verbose)
+		do_log(_("        - agno = %d\n"), agno);
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
+	{
 		/*
 		 * build up incore bno and bcnt extent btrees
 		 */
@@ -1503,8 +1481,8 @@
 		init_ino_cursor(mp, agno, &ino_btree_curs,
 				&num_inos, &num_free_inos);
 
-		sb_icount += num_inos;
-		sb_ifree += num_free_inos;
+		sb_icount_ag[agno] += num_inos;
+		sb_ifree_ag[agno] += num_free_inos;
 
 		num_extents = count_bno_extents_blocks(agno, &num_freeblocks);
 		/*
@@ -1512,7 +1490,7 @@
 		 * are counted as allocated since the space trees
 		 * always have roots
 		 */
-		sb_fdblocks += num_freeblocks - 2;
+		sb_fdblocks_ag[agno] += num_freeblocks - 2;
 
 		if (num_extents == 0)  {
 			/*
@@ -1554,7 +1532,7 @@
 		if (extra_blocks > 0)  {
 			do_warn(_("lost %d blocks in agno %d, sorry.\n"),
 				extra_blocks, agno);
-			sb_fdblocks -= extra_blocks;
+			sb_fdblocks_ag[agno] -= extra_blocks;
 		}
 
 		bcnt_btree_curs = bno_btree_curs;
@@ -1613,6 +1591,67 @@
 		release_agbno_extent_tree(agno);
 		release_agbcnt_extent_tree(agno);
 	}
+}
+
+void
+phase5(xfs_mount_t *mp)
+{
+	xfs_agnumber_t agno;
+
+	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
+
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
+		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_inobt, 0),
+		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_inobt, 0)
+		);
+	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
+		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_inobt, 1),
+		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_inobt, 1)
+		);
+	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
+		XR_INOBT_BLOCK_MAXRECS(mp, 0));
+	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
+		XR_INOBT_BLOCK_MAXRECS(mp, 1));
+	fprintf(stderr, "bnobt level 1, maxrec = %d, minrec = %d\n",
+		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0),
+		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_alloc, 0));
+	fprintf(stderr, "bnobt level 0 (leaf), maxrec = %d, minrec = %d\n",
+		XFS_BTREE_BLOCK_MAXRECS(mp->m_sb.sb_blocksize, xfs_alloc, 1),
+		XFS_BTREE_BLOCK_MINRECS(mp->m_sb.sb_blocksize, xfs_alloc, 1));
+#endif
+	/*
+	 * make sure the root and realtime inodes show up allocated
+	 */
+	keep_fsinos(mp);
+
+	/* allocate per ag counters */
+	sb_icount_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	if (sb_icount_ag == NULL)
+		do_error(_("cannot alloc sb_icount_ag buffers\n"));
+
+	sb_ifree_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	if (sb_ifree_ag == NULL)
+		do_error(_("cannot alloc sb_ifree_ag buffers\n"));
+
+	sb_fdblocks_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	if (sb_fdblocks_ag == NULL)
+		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
+		queue_work(phase5_function, mp, agno);
+	}
+	wait_for_workers();
+
+	/* aggregate per ag counters */
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)  {
+		sb_icount += sb_icount_ag[agno];
+		sb_ifree += sb_ifree_ag[agno];
+		sb_fdblocks += sb_fdblocks_ag[agno];
+	}
+	free(sb_icount_ag);
+	free(sb_ifree_ag);
+	free(sb_fdblocks_ag);
 
 	if (mp->m_sb.sb_rblocks)  {
 		do_log(
@@ -1630,4 +1669,5 @@
 	sync_sb(mp);
 
 	bad_ino_btree = 0;
+
 }

===========================================================================
xfsprogs/repair/phase7.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/phase7.c_1.11	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/phase7.c	Wed Aug  9 11:56:22 2006
@@ -26,6 +26,7 @@
 #include "dinode.h"
 #include "versions.h"
 #include "prefetch.h"
+#include "threads.h"
 
 /* dinoc is a pointer to the IN-CORE dinode core */
 void
@@ -180,8 +181,9 @@
 	libxfs_bcache_purge();
 
 	for (i = 0; i < glob_agcount; i++)  {
-		phase7_alt_function(mp, i);
+		queue_work(phase7_alt_function, mp, i);
 	}
+	wait_for_workers();
 }
 
 void

===========================================================================
xfsprogs/repair/protos.h
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/protos.h_1.9	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/protos.h	Wed Aug  9 11:07:32 2006
@@ -44,4 +44,6 @@
 extern void *ts_attr_freemap(void);
 extern void *ts_dir_freemap(void);
 extern void *ts_dirbuf(void);
+extern void ts_init(void);
+extern void thread_init(void);
 

===========================================================================
xfsprogs/repair/xfs_repair.c
===========================================================================

--- /usr/tmp/TmpDir.3157594-0/xfsprogs/repair/xfs_repair.c_1.25	Wed Aug  9 12:12:44 2006
+++ xfsprogs/repair/xfs_repair.c	Wed Aug  9 11:11:51 2006
@@ -26,6 +26,7 @@
 #include "incore.h"
 #include "err_protos.h"
 #include "prefetch.h"
+#include "threads.h"
 
 #define	rounddown(x, y)	(((x)/(y))*(y))
 
@@ -63,9 +64,13 @@
 	"pfdir",
 #define	PREFETCH_AIO_CNT	6
 	"pfaio",
+#define	THREAD_CNT		7
+	"thread",
 	NULL
 };
 
+static void print_runtime(unsigned);
+
 static void
 usage(void)
 {
@@ -187,7 +192,7 @@
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c = getopt(argc, argv, "o:fl:r:LnDvVdP")) != EOF)  {
+	while ((c = getopt(argc, argv, "o:fl:r:LnDvVdPM")) != EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore = 1;
@@ -228,6 +233,9 @@
 				case PREFETCH_AIO_CNT:
 					libxfs_lio_aio_count = (int) strtol(val, 0, 0);
 					break;
+				case THREAD_CNT:
+					thread_count = (int) strtol(val, 0, 0);
+					break;
 				default:
 					unknown('o', val);
 					break;
@@ -255,7 +263,7 @@
 			dangerously = 1;
 			break;
 		case 'v':
-			verbose = 1;
+			verbose++;
 			break;
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
@@ -263,6 +271,9 @@
 		case 'P':
 			do_prefetch ^= 1;
 			break;
+		case 'M':
+			do_parallel ^= 1;
+			break;
 		case '?':
 			usage();
 		}
@@ -458,7 +469,9 @@
 	xfs_sb_t	*sb;
 	xfs_buf_t	*sbp;
 	xfs_mount_t	xfs_m;
+	time_t		t, start;
 
+	start = time(NULL);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -472,6 +485,10 @@
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
+	if (verbose) {
+		t = time(NULL);
+	        fprintf(stderr, asctime(localtime(&t)));
+	}
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -522,18 +539,23 @@
 	}
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
-
 	phase2(mp);
+	if (verbose) {
+		t = time(NULL);
+	        fprintf(stderr, asctime(localtime(&t)));
+	}
 
-	if (verbose)
-		libxfs_report(stderr);
 	phase3(mp);
-	if (verbose)
-		libxfs_report(stderr);
+	if (verbose) {
+		t = time(NULL);
+	        fprintf(stderr, asctime(localtime(&t)));
+	}
 
 	phase4(mp);
-	if (verbose)
-		libxfs_report(stderr);
+	if (verbose) {
+		t = time(NULL);
+	        fprintf(stderr, asctime(localtime(&t)));
+	}
 
 	/* XXX: nathans - something in phase4 ain't playing by */
 	/* the buffer cache rules.. why doesn't IRIX hit this? */
@@ -541,15 +563,26 @@
 
 	if (no_modify)
 		printf(_("No modify flag set, skipping phase 5\n"));
-	else
+	else {
 		phase5(mp);
+		if (verbose) {
+			t = time(NULL);
+			fprintf(stderr, asctime(localtime(&t)));
+		}
+	}
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
-		if (verbose)
-			libxfs_report(stderr);
+		if (verbose) {
+			t = time(NULL);
+			fprintf(stderr, asctime(localtime(&t)));
+		}
 
 		phase7(mp);
+		if (verbose) {
+			t = time(NULL);
+			fprintf(stderr, asctime(localtime(&t)));
+		}
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
@@ -609,12 +642,14 @@
 		}
 	}
 
-	if (verbose)
+	if (verbose > 1)
 		libxfs_report(stderr);
 
 	if (no_modify)  {
 		do_log(
 	_("No modify flag set, skipping filesystem flush and exiting.\n"));
+		if (verbose)
+			print_runtime(t - start);
 		if (fs_is_dirty)
 			return(1);
 
@@ -661,6 +696,33 @@
 	libxfs_device_close(x.ddev);
 
 	do_log(_("done\n"));
+	if (verbose) {
+		print_runtime(t - start);
+	}
+	return (0);
+}
+
+static void
+print_runtime(unsigned s)
+{
+	unsigned h, m;
 
-	return(0);
+	h = s / 3600;
+	s %= 3600;
+	m = s / 60;
+	s %= 60;
+	if (h) {
+		fprintf(stderr, "Run time %d hour%s %d minute%s %d second%s\n",
+			h, h > 1 ? "s" : "",
+			m, m != 1 ? "s" : "",
+			s, s != 1 ? "s" : "");
+	} else if (m) {
+		fprintf(stderr, "Run time %d minute%s %d second%s\n",
+			m, m > 1 ? "s" : "",
+			s, s != 1 ? "s" : "");
+	}
+	else {
+		fprintf(stderr, "Run time %d second%s\n",
+			s, s != 1 ? "s" : "");
+	}
 }

===========================================================================
xfsprogs/repair/threads.c
===========================================================================

--- /dev/null	Wed Aug  9 12:12:41 2006
+++ xfsprogs/repair/threads.c	Wed Aug  9 11:52:18 2006
@@ -0,0 +1,308 @@
+#include <libxfs.h>
+#include "pthread.h"
+#include "signal.h"
+#include "threads.h"
+#include "err_protos.h"
+#include "protos.h"
+
+int do_parallel = 1;
+int thread_count;
+
+/* A quantum of work */
+typedef struct work_s {
+	struct work_s	*next;
+	disp_func_t	*function;
+	xfs_mount_t	*mp;
+	xfs_agnumber_t	agno;
+} work_t;
+
+typedef struct  work_queue_s {
+	work_t		*next;
+	work_t		*last;
+	int		active_threads;
+	int		work_count;
+	pthread_cond_t	mcv;	/* main thread conditional variable */
+	pthread_cond_t	wcv;	/* worker threads conditional variable */
+	pthread_mutex_t	mutex;
+} work_queue_t;
+
+static	work_queue_t	work_queue;
+static	pthread_t	*work_threads;
+
+static	void	*worker_thread(void *arg);
+
+static void
+init_workers(work_queue_t *wq, int nw)
+{
+	int			err;
+	pthread_mutexattr_t	mtxattr;
+
+	memset(wq, 0, sizeof(work_queue_t));
+	wq->active_threads = nw;
+
+	pthread_cond_init(&wq->mcv, NULL);
+	pthread_cond_init(&wq->wcv, NULL);
+	pthread_mutexattr_init(&mtxattr);
+
+#ifdef	PTHREAD_MUTEX_SPINBLOCK_NP
+	/* NP - Non Portable - Irix */
+	if ((err = pthread_mutexattr_settype(&mtxattr,
+			PTHREAD_MUTEX_SPINBLOCK_NP)) > 0) {
+		do_error(_("init_workers: thread 0x%x: pthread_mutexattr_settype error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+	}
+#endif
+#ifdef	PTHREAD_MUTEX_FAST_NP
+	/* NP - Non Portable - Linux */
+	if ((err = pthread_mutexattr_settype(&mtxattr,
+			PTHREAD_MUTEX_FAST_NP)) > 0) {
+		do_error(_("init_workers: thread 0x%x: pthread_mutexattr_settype error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+	}
+#endif
+	if ((err = pthread_mutex_init(&wq->mutex, &mtxattr)) > 0) {
+		do_error(_("init_workers: thread 0x%x: pthread_mutex_init error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+	}
+}
+
+static void
+quiesce_workers(work_queue_t *wq)
+{
+	int	err;
+
+	if ((err = pthread_mutex_lock(&wq->mutex)) > 0)
+		do_error(_("quiesce_workers: thread 0x%x: pthread_mutex_lock error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+	if (wq->active_threads > 0) {
+		if ((err = pthread_cond_wait(&wq->mcv, &wq->mutex)) > 0)
+			do_error(_("quiesce_workers: thread 0x%x: pthread_cond_wait error %d: %s\n"),
+				pthread_self(), err, strerror(err));
+	}
+	ASSERT(wq->active_threads == 0);
+	if ((err = pthread_mutex_unlock(&wq->mutex)) > 0)
+		do_error(_("quiesce_workers: thread 0x%x: pthread_mutex_unlock error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+}
+
+static void
+start_workers(work_queue_t *wq, unsigned thcnt, pthread_attr_t *attrp)
+{
+	int		err;
+	unsigned long	i;
+
+	init_workers(wq, thcnt);
+
+	if ((work_threads = (pthread_t *)malloc(sizeof(pthread_t) * thcnt)) == NULL)
+		do_error(_("cannot malloc %ld bytes for work_threads array\n"), 
+				sizeof(pthread_t) * thcnt);
+
+	/*
+	**  Create worker threads
+	*/
+	for (i = 0; i < thcnt; i++) {
+		err = pthread_create(&work_threads[i], attrp, worker_thread, (void *) i);
+		if(err > 0) {
+		        do_error(_("cannot create worker threads, status = [%d] %s\n"),
+				err, strerror(err));
+		}
+	}
+	do_log(_("        - creating %d worker thread(s)\n"), thcnt);
+
+	/*
+	**  Wait for all worker threads to initialize
+	*/
+	quiesce_workers(wq);
+}
+
+void
+thread_init(void)
+{
+	int		status;
+	size_t		stacksize;
+	pthread_attr_t	attr;
+	sigset_t	blocked;
+
+	if (do_parallel == 0)
+		return;
+	if (thread_count == 0)
+		thread_count = 2 * libxfs_nproc();
+
+	if ((status = pthread_attr_init(&attr)) != 0)
+		do_error(_("status from pthread_attr_init: %d"),status);
+
+	if ((status = pthread_attr_getstacksize(&attr, &stacksize)) != 0)
+		do_error(_("status from pthread_attr_getstacksize: %d"), status);
+
+	stacksize *= 4;
+
+	if ((status = pthread_attr_setstacksize(&attr, stacksize)) != 0)
+		do_error(_("status from pthread_attr_setstacksize: %d"), status);
+
+	if ((status = pthread_setconcurrency(thread_count)) != 0)
+		do_error(_("Status from pthread_setconcurrency(%d): %d"), thread_count, status);
+
+	/*
+	 *  block delivery of progress report signal to all threads
+         */
+	sigemptyset(&blocked);
+	sigaddset(&blocked, SIGHUP);
+	sigaddset(&blocked, SIGALRM);
+	pthread_sigmask(SIG_BLOCK, &blocked, NULL);
+
+	start_workers(&work_queue, thread_count, &attr);
+}
+
+/*
+ * Dequeue from the head of the list.
+ * wq->mutex held.
+ */
+static work_t *
+dequeue(work_queue_t *wq)
+{
+	work_t	*wp;
+
+	ASSERT(wq->work_count > 0);
+	wp = wq->next;
+	wq->next = wp->next;
+	wq->work_count--;
+	if (wq->next == NULL) {
+		ASSERT(wq->work_count == 0);
+		wq->last = NULL;
+	}
+	wp->next = NULL;
+	return (wp);
+}
+
+static void *
+worker_thread(void *arg)
+{
+	work_queue_t	*wq;
+	work_t		*wp;
+	int		err;
+	unsigned long	myid;
+
+	wq = &work_queue;
+	myid = (unsigned long) arg;
+	ts_init();
+	libxfs_lio_allocate();
+
+	/*
+	 * Loop pulling work from the global work queue.
+	 * Check for notification to exit after every chunk of work.
+	 */
+	while (1) {
+		if ((err = pthread_mutex_lock(&wq->mutex)) > 0)
+			do_error(_("work_thread%d: thread 0x%x: pthread_mutex_lock error %d: %s\n"),
+				myid, pthread_self(), err, strerror(err));
+		/*
+		 * Wait for work.
+		 */
+		while (wq->next == NULL) {
+			ASSERT(wq->work_count == 0);
+			/*
+			 * Last thread going to idle sleep must wakeup
+			 * the master thread.  Same mutex is used to lock
+			 * around two different condition variables.
+			 */
+			wq->active_threads--;
+			ASSERT(wq->active_threads >= 0);
+			if (!wq->active_threads) {
+				if ((err = pthread_cond_signal(&wq->mcv)) > 0)
+					do_error(_("work_thread%d: thread 0x%x: pthread_cond_signal error %d: %s\n"),
+						myid, pthread_self(), err, strerror(err));
+			}
+			if ((err = pthread_cond_wait(&wq->wcv, &wq->mutex)) > 0)
+				do_error(_("work_thread%d: thread 0x%x: pthread_cond_wait error %d: %s\n"),
+					myid, pthread_self(), err, strerror(err));
+			wq->active_threads++;
+		}
+		/*
+		 *  Dequeue work from the head of the list.
+		 */
+		ASSERT(wq->work_count > 0);
+		wp = dequeue(wq);
+		if ((err = pthread_mutex_unlock(&wq->mutex)) > 0)
+			do_error(_("work_thread%d: thread 0x%x: pthread_mutex_unlock error %d: %s\n"),
+				myid, pthread_self(), err, strerror(err));
+		/*
+		 *  Do the work.
+		 */
+		(wp->function)(wp->mp, wp->agno);
+
+		free(wp);
+	}
+	/* NOT REACHED */
+	pthread_exit(NULL);
+	return (NULL);
+}
+
+int
+queue_work(disp_func_t func, xfs_mount_t *mp, xfs_agnumber_t agno)
+{
+	work_queue_t *wq;
+	work_t	*wp;
+
+	if (do_parallel == 0) {
+		func(mp, agno);
+		return 0;
+	}
+	wq = &work_queue;
+	/*
+	 * Get memory for a new work structure.
+	 */
+	if ((wp = (work_t *)memalign(8, sizeof(work_t))) == NULL)
+		return (ENOMEM);
+	/*
+	 * Initialize the new work structure.
+	 */
+	wp->function = func;
+	wp->mp = mp;
+	wp->agno = agno;
+
+	/*
+	 *  Now queue the new work structure to the work queue.
+	 */
+	if (wq->next == NULL) {
+		wq->next = wp;
+	} else {
+		wq->last->next = wp;
+	}
+	wq->last = wp;
+	wp->next = NULL;
+	wq->work_count++;
+
+	return (0);
+}
+
+void
+wait_for_workers(void)
+{
+	int		err;
+	work_queue_t	*wq;
+
+	if (do_parallel == 0)
+		return;
+	wq = &work_queue;
+	if ((err = pthread_mutex_lock(&wq->mutex)) > 0)
+		do_error(_("wait_for_workers: thread 0x%x: pthread_mutex_lock error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+
+	ASSERT(wq->active_threads == 0);
+	if (wq->work_count > 0) {
+		/* get the workers going */
+		if ((err = pthread_cond_broadcast(&wq->wcv)) > 0)
+			do_error(_("wait_for_workers: thread 0x%x: pthread_cond_broadcast error %d: %s\n"),
+				pthread_self(), err, strerror(err));
+		/* and wait for them */
+		if ((err = pthread_cond_wait(&wq->mcv, &wq->mutex)) > 0)
+			do_error(_("wait_for_workers: thread 0x%x: pthread_cond_wait error %d: %s\n"),
+				pthread_self(), err, strerror(err));
+	}
+	ASSERT(wq->active_threads == 0);
+	ASSERT(wq->work_count == 0);
+
+	if ((err = pthread_mutex_unlock(&wq->mutex)) > 0)
+		do_error(_("wait_for_workers: thread 0x%x: pthread_mutex_unlock error %d: %s\n"),
+			pthread_self(), err, strerror(err));
+}

===========================================================================
xfsprogs/repair/threads.h
===========================================================================

--- /dev/null	Wed Aug  9 12:12:41 2006
+++ xfsprogs/repair/threads.h	Fri Jul 14 16:37:50 2006
@@ -0,0 +1,37 @@
+#ifndef	_XFS_REPAIR_THREADS_H_
+#define	_XFS_REPAIR_THREADS_H_
+
+extern int		do_parallel;
+extern int		thread_count;
+/*
+**  locking variants - rwlock/mutex
+*/
+#define PREPAIR_RW_LOCK_ATTR		PTHREAD_PROCESS_PRIVATE
+
+#define	PREPAIR_RW_LOCK_ALLOC(lkp, n)				\
+	if (do_parallel) {					\
+		lkp = malloc(n*sizeof(pthread_rwlock_t));	\
+		if (lkp == NULL)				\
+			do_error("cannot alloc %d locks\n", n);	\
+			/* NO RETURN */				\
+	}
+#define PREPAIR_RW_LOCK_INIT(l,a)	if (do_parallel) pthread_rwlock_init((l),(a))
+#define PREPAIR_RW_READ_LOCK(l) 	if (do_parallel) pthread_rwlock_rdlock((l))
+#define PREPAIR_RW_WRITE_LOCK(l)	if (do_parallel) pthread_rwlock_wrlock((l))
+#define PREPAIR_RW_UNLOCK(l)		if (do_parallel) pthread_rwlock_unlock((l))
+#define PREPAIR_RW_WRITE_LOCK_NOTEST(l)	pthread_rwlock_wrlock((l))
+#define PREPAIR_RW_UNLOCK_NOTEST(l)	pthread_rwlock_unlock((l))
+#define PREPAIR_RW_LOCK_DELETE(l)	if (do_parallel) pthread_rwlock_destroy((l))
+
+#define PREPAIR_MTX_LOCK_INIT(m, a)	if (do_parallel) pthread_mutex_init((m), (a))
+#define PREPAIR_MTX_ATTR_INIT(a)	if (do_parallel) pthread_mutexattr_init((a))
+#define PREPAIR_MTX_ATTR_SET(a, l)	if (do_parallel) pthread_mutexattr_settype((a), l)
+#define PREPAIR_MTX_LOCK(m)		if (do_parallel) pthread_mutex_lock(m)
+#define PREPAIR_MTX_UNLOCK(m)		if (do_parallel) pthread_mutex_unlock(m)
+
+
+typedef void	disp_func_t(xfs_mount_t *mp, xfs_agnumber_t agno);
+extern	int	queue_work(disp_func_t func, xfs_mount_t *mp, xfs_agnumber_t agno);
+extern	void	wait_for_workers(void);
+
+#endif	/* _XFS_REPAIR_THREADS_H_ */

--------------020505020607020101000806--
