Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SHgqtr208317 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 11:42:53 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7FjIN9wtwelZiQJQ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 09:42:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S2R4d-0001bm-78
	for xfs@oss.sgi.com; Tue, 28 Feb 2012 17:42:51 +0000
Date: Tue, 28 Feb 2012 12:42:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] repair: fix messages from set_nlinks
Message-ID: <20120228174251.GB6148@infradead.org>
References: <20120228174223.GA6148@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228174223.GA6148@infradead.org>
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

Link counts are unsigned and need to be printed as such.  Also only
print the varning about upgrading the inode version if the inode was
version 1 before.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/phase7.c
===================================================================
--- xfsprogs-dev.orig/repair/phase7.c	2012-02-28 12:45:52.627849317 +0100
+++ xfsprogs-dev/repair/phase7.c	2012-02-28 14:03:20.475986024 +0100
@@ -40,19 +40,20 @@ set_nlinks(
 
 	if (!no_modify) {
 		*dirty = 1;
-		do_warn(_("resetting inode %" PRIu64 " nlinks from %d to %d\n"),
+		do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
 			ino, dinoc->di_nlink, nrefs);
 
-		if (nrefs > XFS_MAXLINK_1)  {
+		if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
 			ASSERT(fs_inode_nlink);
 			do_warn(
-_("nlinks %d will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
+_("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to version 2\n"),
 				nrefs, ino);
 
 		}
 		dinoc->di_nlink = nrefs;
 	} else  {
-		do_warn(_("would have reset inode %" PRIu64 " nlinks from %d to %d\n"),
+		do_warn(
+_("would have reset inode %" PRIu64 " nlinks from %u to %u\n"),
 			ino, dinoc->di_nlink, nrefs);
 	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
