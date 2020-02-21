Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C2EC35657
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA42222C4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D/MOFX3X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgBUOL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:11:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgBUOLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4mPP/ff5n2vZ4KoU4urQYSn7o751n+nX5PbXfXPmoHg=; b=D/MOFX3XdXyHG/j145TBkiaeQK
        T12BMv9/WF6Hp9iVtMOsuDBeGegCakfb9JpudvmnxJqemkupGt4ZjvZmFRWccLTzk6iI1TWauFV7f
        Ln+HBo7Km7n9I2g2JSagQ0/rDItgLrR/mppvgZzY+aMZat3c/0ejdaD+r/oX9FCrHBoy0uCqF1DeS
        P1DVWJMjXzEywg/Vf3jHkD+ot1QjMEsNJU/KUOyme6aE1o3SgJxdaqH40VrC8zW4OmF+8LlC/7KTt
        4w1ptfbr3kAOSuBJ+AvvdQlbCw29+qZN1PlYPgDF40/Lz5ptbnuUn2yAqJPJnB040MfkimOVTNflJ
        N3URErQg==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5923-0000GB-3w; Fri, 21 Feb 2020 14:11:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/31] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
Date:   Fri, 21 Feb 2020 06:11:24 -0800
Message-Id: <20200221141154.476496-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
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

