Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9PBqYqV169387 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 06:52:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83C0C1CB8C8E
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 04:52:33 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3qeNLbIcsfnoSYea for <xfs@oss.sgi.com>;
	Tue, 25 Oct 2011 04:52:33 -0700 (PDT)
Date: Tue, 25 Oct 2011 07:52:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: fix various incorrect printf formats
Message-ID: <20111025115233.GB22103@infradead.org>
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
Cc: Jakub Bogusz <qboosh@pld-linux.org>


Reported-by: Jakub Bogusz <qboosh@pld-linux.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs/libxfs/freebsd.c
===================================================================
--- xfsprogs.orig/libxfs/freebsd.c	2011-10-25 13:44:11.614603520 +0200
+++ xfsprogs/libxfs/freebsd.c	2011-10-25 13:44:48.465103324 +0200
@@ -126,15 +126,13 @@ platform_findsizes(char *path, int fd, l
 	}
 
 	if ((st.st_mode & S_IFMT) != S_IFCHR) {
-		fprintf(stderr, _("%s: "
-			"Not a device or file: \"%s\"n"),
+		fprintf(stderr, _("%s: Not a device or file: \"%s\"\n"),
 			progname, path);
 		exit(1);
 	}
 
 	if (ioctl(fd, DIOCGMEDIASIZE, &size) != 0) {
-		fprintf(stderr, _("%s: "
-			"DIOCGMEDIASIZE failed on \"%s\": %s\n"),
+		fprintf(stderr, _("%s: DIOCGMEDIASIZE failed on \"%s\": %s\n"),
 			progname, path, strerror(errno));
 		exit(1);
 	}
Index: xfsprogs/repair/dinode.c
===================================================================
--- xfsprogs.orig/repair/dinode.c	2011-10-25 13:43:54.206603804 +0200
+++ xfsprogs/repair/dinode.c	2011-10-25 13:44:06.421658714 +0200
@@ -1439,7 +1439,7 @@ _("mismatch between format (%d) and size
 	}
 	if (dino->di_format == XFS_DINODE_FMT_LOCAL) {
 		do_warn(
-_("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu64 "n"),
+_("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu64 "\n"),
 			dino->di_format,
 			(__int64_t)be64_to_cpu(dino->di_size), lino);
 		return 1;
Index: xfsprogs/repair/dir2.c
===================================================================
--- xfsprogs.orig/repair/dir2.c	2011-10-25 13:46:25.830602794 +0200
+++ xfsprogs/repair/dir2.c	2011-10-25 13:46:51.049603282 +0200
@@ -1174,7 +1174,7 @@ _("would have corrected entry count in d
 				ino, sfp->hdr.count, i);
 		} else {
 			do_warn(
-_("corrected entry count in directory %" PRIu64 "u, was %d, now %d\n"),
+_("corrected entry count in directory %" PRIu64 ", was %d, now %d\n"),
 				ino, sfp->hdr.count, i);
 			sfp->hdr.count = i;
 			*dino_dirty = 1;
Index: xfsprogs/repair/phase6.c
===================================================================
--- xfsprogs.orig/repair/phase6.c	2011-10-25 13:44:53.826603054 +0200
+++ xfsprogs/repair/phase6.c	2011-10-25 13:46:21.041603352 +0200
@@ -2071,7 +2071,7 @@ longform_dir2_entry_check_data(
 		if (is_inode_free(irec, ino_offset))  {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode " PRIu64),
+	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
 					fname, ip->i_ino, inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(tp, bp, dep);
Index: xfsprogs/repair/scan.c
===================================================================
--- xfsprogs.orig/repair/scan.c	2011-10-25 13:46:56.562602076 +0200
+++ xfsprogs/repair/scan.c	2011-10-25 13:47:31.369102715 +0200
@@ -289,14 +289,14 @@ _("bad back (left) sibling pointer (saw
 			 */
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+_("inode 0x%" PRIu64 "bmap block %" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE_FS:
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+_("inode 0x%" PRIu64 " bmap block %" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
 			/*
 			 * if we made it to here, this is probably a bmap block
@@ -311,7 +311,7 @@ _("inode 0x%" PRIu64 " bmap block 0x%" P
 		case XR_E_BAD_STATE:
 		default:
 			do_warn(
-_("bad state %d, inode 0x%" PRIu64 " bmap block 0x%" PRIu64 "\n"),
+_("bad state %d, inode 0x%" PRIu64 " bmap block %" PRIx64 "\n"),
 				state, ino, bno);
 			break;
 		}
@@ -338,7 +338,7 @@ _("bad state %d, inode 0x%" PRIu64 " bma
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode 0x%" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIx64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
