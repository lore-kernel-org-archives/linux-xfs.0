Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA590VdN145849 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 04:00:32 -0500
Received: from mail.qboosh.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C041A2230BA
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 02:00:26 -0700 (PDT)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id QmM0OudoMVg00jFT for <xfs@oss.sgi.com>;
	Sat, 05 Nov 2011 02:00:26 -0700 (PDT)
Date: Sat, 5 Nov 2011 10:00:29 +0100
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Re: [PATCH v2] xfsprogs: fix various incorrect printf formats
Message-ID: <20111105090029.GA15258@stranger.qboosh.pl>
References: <20111025115233.GB22103@infradead.org>
	<20111025155916.GA19818@stranger.qboosh.pl>
	<20111102092012.GA3808@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20111102092012.GA3808@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 02, 2011 at 05:20:12AM -0400, Christoph Hellwig wrote:
> Index: xfsprogs/repair/scan.c
> ===================================================================
> --- xfsprogs.orig/repair/scan.c	2011-10-30 05:56:36.168127218 +0100
> +++ xfsprogs/repair/scan.c	2011-10-30 05:57:45.981169953 +0100
> @@ -289,14 +289,14 @@ _("bad back (left) sibling pointer (saw
>  			 */
>  			set_bmap(agno, agbno, XR_E_MULT);
>  			do_warn(
> -_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> +_("inode 0x%" PRIu64 "bmap block 0x%" PRIx64 " claimed, state is %d\n"),
>  				ino, bno, state);
>  			break;
>  		case XR_E_MULT:
>  		case XR_E_INUSE_FS:
>  			set_bmap(agno, agbno, XR_E_MULT);
>  			do_warn(
> -_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
> +_("inode 0x%" PRIu64 " bmap block 0x%" PRIx64 " claimed, state is %d\n"),
>  				ino, bno, state);
>  			/*
>  			 * if we made it to here, this is probably a bmap block

These two entries still need fix in the first format strings of both
msgids...

I'm attaching my version of the whole patch.


-- 
Jakub Bogusz    http://qboosh.pl/

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs-msgids.patch"

Reported-by: Jakub Bogusz <qboosh@pld-linux.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs/libxfs/freebsd.c
===================================================================
--- xfsprogs.orig/libxfs/freebsd.c	2011-10-30 05:56:36.180125966 +0100
+++ xfsprogs/libxfs/freebsd.c	2011-10-30 05:57:45.957126722 +0100
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
--- xfsprogs.orig/repair/dinode.c	2011-10-30 05:56:36.132124261 +0100
+++ xfsprogs/repair/dinode.c	2011-10-30 05:57:45.957126722 +0100
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
--- xfsprogs.orig/repair/dir2.c	2011-10-30 05:56:36.156126568 +0100
+++ xfsprogs/repair/dir2.c	2011-11-02 10:16:46.593593447 +0100
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
--- xfsprogs.orig/repair/phase6.c	2011-10-30 05:56:36.144127454 +0100
+++ xfsprogs/repair/phase6.c	2011-10-30 05:57:45.973171205 +0100
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
--- xfsprogs.orig/repair/scan.c	2011-10-30 05:56:36.168127218 +0100
+++ xfsprogs/repair/scan.c	2011-10-30 05:57:45.981169953 +0100
@@ -289,14 +289,14 @@ _("bad back (left) sibling pointer (saw
 			 */
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-_("inode 0x%" PRIu64 "bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+_("inode %" PRIu64 "bmap block 0x%" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
 			break;
 		case XR_E_MULT:
 		case XR_E_INUSE_FS:
 			set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
-_("inode 0x%" PRIu64 " bmap block 0x%" PRIu64 " claimed, state is %d\n"),
+_("inode %" PRIu64 " bmap block 0x%" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
 			/*
 			 * if we made it to here, this is probably a bmap block
@@ -311,7 +311,7 @@ _("inode 0x%" PRIu64 " bmap block 0x%" P
 		case XR_E_BAD_STATE:
 		default:
 			do_warn(
-_("bad state %d, inode 0x%" PRIu64 " bmap block 0x%" PRIu64 "\n"),
+_("bad state %d, inode 0x%" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 				state, ino, bno);
 			break;
 		}
@@ -338,7 +338,7 @@ _("bad state %d, inode 0x%" PRIu64 " bma
 		if (numrecs > mp->m_bmap_dmxr[0] || (isroot == 0 && numrecs <
 							mp->m_bmap_dmnr[0])) {
 				do_warn(
-_("inode 0x%" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
+_("inode %" PRIu64 " bad # of bmap records (%u, min - %u, max - %u)\n"),
 					ino, numrecs, mp->m_bmap_dmnr[0],
 					mp->m_bmap_dmxr[0]);
 			return(1);

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--WIyZ46R2i8wDzkSu--
