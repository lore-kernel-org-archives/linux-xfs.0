Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A04EC4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E093F2072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dm0jRGHZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgBZUZJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgBZUZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UA8DE4OLKOVvsSlS/t5RFbdB8Hwbjk5JQWfur4LKtPE=; b=Dm0jRGHZgxQ29KAN+QB+R8K0P+
        1o6nyZuYJTFlsTINAV3gnbsuJlomvQJ9xXUaeWoEnanvwUfl9mykiJ8FcZMVoKg8RGn+mE38YyWaC
        IC1k1hU5qoS5XDrayyrjgmHQ2Td1ovrklflp1swtDXH2PtJHIk5K4+0YdfIdJxoi2gocTIyjH1RiW
        jLRXqvcxq/gfduigzXv5TOPF7wTEXTEATjhmqlV0TabAJPk2BMI5J7/DeduZ+M5Vl4T5yBKfr7hOI
        com2vRnCigb2xoJ0Jd3oFpR2fOos7J4QchdHW/fCEeF1gOWmb4H0jP+5XQaeOW98JIUqTAfjdkefx
        eYace0wg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Ez-0001JR-7P; Wed, 26 Feb 2020 20:25:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/32] xfs: lift common checks into xfs_ioc_attr_list
Date:   Wed, 26 Feb 2020 12:22:56 -0800
Message-Id: <20200226202306.871241-23-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the flags and bufsize checks from both callers into the common code
in xfs_ioc_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 23 ++++++++++++-----------
 fs/xfs/xfs_ioctl32.c | 11 -----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a8fe9553b432..508326f6ec67 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -361,6 +361,18 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist		*alist;
 	int				error;
 
+	if (bufsize < sizeof(struct xfs_attrlist) ||
+	    bufsize > XFS_XATTR_LIST_MAX)
+		return -EINVAL;
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+	if (flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+
 	/*
 	 * Validate the cursor.
 	 */
@@ -415,17 +427,6 @@ xfs_attrlist_by_handle(
 		return -EPERM;
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 10ea0222954c..840d17951407 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -366,17 +366,6 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

