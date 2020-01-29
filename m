Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD86C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CDF2071E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eBCdRlyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgA2RDx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:03:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9VcPjEBiEgl9rR8IfLEBpu2EtOaMPfv2JCiJjpD+ZY0=; b=eBCdRlytGd6UlayvicrbdSKq7V
        J3X3+uZmbLPwYeBw4Kb+oIkFJZzNWiWH4m/uJqMNoUKhWvtefYqz9PEtxqi2Z8Y67dR1JrLq8fZv7
        sLnwuMwgXCnJ48aMPRmvhevuzTPtLqyCAu0tN8YtL4asTvydxXrZR/5OqZt7cbpYZupgljF2llGjH
        bvHW0Kz0qVCPTtJF/okGeN++Md+rx8/B60ABqh0qQR1lkGoXxWgC9rPkrB6rniITHS6quZ9WW4mW+
        tP98UIvdLF7YZQgAphs4dg3rT7QeQukviep+4VekEKCOrZV3FTEwTTo+yvguJrE9LXY3rWKVahpmV
        hRbjFrAg==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkq-0006vf-Jv; Wed, 29 Jan 2020 17:03:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/30] xfs: replace ATTR_KERNOTIME with XFS_DA_OP_NOTIME
Date:   Wed, 29 Jan 2020 18:02:55 +0100
Message-Id: <20200129170310.51370-17-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

op_flags with the XFS_DA_OP_* flags is the usual place for in-kernel
only flags, so move the notime flag there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  | 4 ++--
 fs/xfs/libxfs/xfs_attr.h  | 8 +-------
 fs/xfs/libxfs/xfs_types.h | 2 ++
 fs/xfs/scrub/attr.c       | 2 +-
 fs/xfs/xfs_ioctl.c        | 1 -
 5 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1382e51ef85e..3b1db2afb104 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -186,7 +186,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && (args->flags & ATTR_KERNOTIME) == 0)
+	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
@@ -389,7 +389,7 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	if ((args->flags & ATTR_KERNOTIME) == 0)
+	if (!(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index a6de050675c9..0f369399effd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -33,19 +33,13 @@ struct xfs_attr_list_context;
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
 
-#define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
-
-#define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME)
-
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
 	{ ATTR_ROOT,		"ROOT" }, \
 	{ ATTR_TRUST,		"TRUST" }, \
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
-	{ ATTR_REPLACE,		"REPLACE" }, \
-	{ ATTR_KERNOTIME,	"KERNOTIME" }
+	{ ATTR_REPLACE,		"REPLACE" }
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 3379ebc0c7c5..1594325d7742 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -223,6 +223,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
+#define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
 #define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
@@ -231,6 +232,7 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
+	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f983c2b969e0..05537627211d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -147,7 +147,7 @@ xchk_xattr_listent(
 		return;
 	}
 
-	args.flags = ATTR_KERNOTIME;
+	args.op_flags = XFS_DA_OP_NOTIME;
 	if (flags & XFS_ATTR_ROOT)
 		args.flags |= ATTR_ROOT;
 	else if (flags & XFS_ATTR_SECURE)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2da22595f828..dd1cb8c50518 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -436,7 +436,6 @@ xfs_ioc_attrmulti_one(
 
 	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
 		return -EINVAL;
-	flags &= ~ATTR_KERNEL_FLAGS;
 
 	name = strndup_user(uname, MAXNAMELEN);
 	if (IS_ERR(name))
-- 
2.24.1

