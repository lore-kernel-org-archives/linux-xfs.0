Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1573129DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 14:46:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA3B4AC007
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 12:46:39 -0700 (PDT)
Received: from mail-ve0-f171.google.com (mail-ve0-f171.google.com
	[209.85.128.171]) by cuda.sgi.com with ESMTP id
	huwK0TGvKwKx7fh0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 12:46:38 -0700 (PDT)
Received: by mail-ve0-f171.google.com with SMTP id b10so8078456vea.2
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 12:46:37 -0700 (PDT)
Received: from [192.168.0.129] (rrcs-97-78-60-146.se.biz.rr.com.
	[97.78.60.146])
	by mx.google.com with ESMTPSA id h14sm4669483vdf.4.2013.06.13.12.46.36
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Thu, 13 Jun 2013 12:46:36 -0700 (PDT)
Message-ID: <51BA219B.4070503@gmail.com>
Date: Thu, 13 Jun 2013 15:46:35 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: replace umode_t with xfs_mode_t
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch was made after applying the most recent 3.11-related 
patchset for xfsprogs.  It was applied against the crc-dev branch, 
in order to get CRC-enabled xfsprogs to build without complaining 
about a lack of "umode_t".  The systems used were both 32-bit 
slackware-current systems, against public kernel headers of kernel 
3.8.x and 3.9.x vintage.

This is an "idea" patch, a way of getting CRC-enabled xfsprogs to 
build on kernels later than 3.2 while staying within the conventions 
of my test systems.  The idea may be bad, and the XFS crew might be 
solving it in a different way while moving header files and functions.

Anyway, I don't know how the Debian and Red Hat crews solve header-
related issues like these, so comments and flames are welcome.  In 
particular, I'm open to a better name than "xfs_mode_t" that does 
not match the grep term "umode_t".

Thanks!

Michael

>From 6f34f385d3e6e748999f26638bd8608b5ff8f022 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Thu, 13 Jun 2013 03:08:30 -0400
Subject: [PATCH] xfsprogs: replace umode_t with xfs_mode_t

umode_t has not been exported to the public kernel headers by
the kernel `make headers_install` process since about 3.2.0-rc7.
For that matter, a `grep -rl umode_t /usr/include` can return nothing,
as if authors are avoiding the term "umode_t" altogether.  Follow this
convention by changing umode_t to xfs_mode_t.

The simple hack way through this problem is to do this instead:

typedef unsigned short umode_t;

However, when xfsprogs is installed by `make install-qa`, this can
be exported to /usr/include, which is not desired behavior.

Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>
---
 include/xfs_ialloc.h  | 8 +++++++-
 include/xfs_symlink.h | 3 ++-
 libxfs/xfs_ialloc.c   | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index 68c0732..2cc3e93 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -25,6 +25,12 @@ struct xfs_mount;
 struct xfs_trans;
 
 /*
+ * Provide a replacement for a variable that has not been exported 
+ * to public kernel headers since about kernel 3.2.0-rc7.
+ */
+typedef unsigned short xfs_mode_t;
+
+/*
  * Allocation parameters for inode allocation.
  */
 #define	XFS_IALLOC_INODES(mp)	(mp)->m_ialloc_inos
@@ -72,7 +78,7 @@ int					/* error */
 xfs_dialloc(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
+	xfs_mode_t	mode,		/* mode bits for new inode */
 	int		okalloc,	/* ok to allocate more space */
 	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
 	xfs_ino_t	*inop);		/* inode number allocated */
diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
index 4818edf..93801ec 100644
--- a/include/xfs_symlink.h
+++ b/include/xfs_symlink.h
@@ -59,7 +59,8 @@ extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 #ifdef __KERNEL__
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
-		const char *target_path, umode_t mode, struct xfs_inode **ipp);
+		const char *target_path, xfs_mode_t mode, 
+		struct xfs_inode **ipp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index ce32dfa..2ce06c8 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -490,7 +490,7 @@ STATIC xfs_agnumber_t
 xfs_ialloc_ag_select(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_ino_t	parent,		/* parent directory inode number */
-	umode_t		mode,		/* bits set to indicate file type */
+	xfs_mode_t	mode,		/* bits set to indicate file type */
 	int		okalloc)	/* ok to allocate more space */
 {
 	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
@@ -936,7 +936,7 @@ int
 xfs_dialloc(
 	struct xfs_trans	*tp,
 	xfs_ino_t		parent,
-	umode_t			mode,
+	xfs_mode_t		mode,
 	int			okalloc,
 	struct xfs_buf		**IO_agbp,
 	xfs_ino_t		*inop)
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
