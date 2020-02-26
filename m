Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93774C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E32124656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s2cZBGdk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgBZUXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4mPP/ff5n2vZ4KoU4urQYSn7o751n+nX5PbXfXPmoHg=; b=s2cZBGdkiDRqtbqupJQzdmh2kS
        hA/S8A/wSWL/lpTUl5jrObTiId5QoMByOAI2vXTXG8vEoytddQlStbnW8SV4IM5sfeptFBogm4lRi
        mk/w+2YsSVwruPxbGcrpvJQZd6vC26GW8tThShTJwXHtQrWOj3NlxVxQ16jlX++sgl/U992YCDMBi
        DkbOgaoTCBxB4eXGIyAePjfub28P8WjjWKZQa5Y6XErV+SOxvGG6ApCxPneDw9P1M+W74PnOMusAs
        Sv+wKWN8V3cBJI6vBNsZ+Obk4AaQpcuB/EVuBwHCt47f/rJrKLg6K9ZuyfByiusoGvHTUStoWrBw5
        T3/6sd5Q==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73DG-0008DK-KF; Wed, 26 Feb 2020 20:23:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/32] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
Date:   Wed, 26 Feb 2020 12:22:35 -0800
Message-Id: <20200226202306.871241-2-hch@lst.de>
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

While the flags field in the ABI and the on-disk format allows for
multiple namespace flags, an attribute can only exist in a single
namespace at a time. Hence asking to list attributes that exist
in multiple namespaces simultaneously is a logically invalid
request and will return no results. Reject this case early with
-EINVAL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 2 ++
 fs/xfs/xfs_ioctl32.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42de92cb283..d974bf099d45 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -317,6 +317,8 @@ xfs_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 769581a79c58..9705172e5410 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -375,6 +375,8 @@ xfs_compat_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

