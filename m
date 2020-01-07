Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B019C33C9B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681802073D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 16:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0Go5j7n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgAGQyu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:54:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGQyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kUPZOML+uLnYPgpjQGR/7/Zmj/V06a0odfpumk93+aY=; b=B0Go5j7njJv3ksxpg0Jy7rSa3E
        VtQPuhAtrbGYErIjWI9UN7o68zkImHVZjTKOsn8Hw30aTPR/jhfkbw97eOVr6kKkMmSNB0APDkKFe
        1ueR11dI+gMSUqtzZKkSeG9R85Ib4nS6I+PQyotwJMKjH6+4PPVVeKIT5uXfLdihehYGBM5cHD7UY
        uuJexy+oOXHVSZBKYw7Kr5XcV/XCPsOwvGFwn1p6cU3rh+0gsFBd+RWGJ9ZFl5KIsxbMBMugFbhO+
        4plz9NTM9l4ZDCC4qNR5SH+QYXY80a+YZLiy6yQGmrtu8QtsactsX9ZtA+i3rlQOZlS6z7OfVD1XV
        c8+517Ng==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios80-0002Pn-TW; Tue, 07 Jan 2020 16:54:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/4] xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Tue,  7 Jan 2020 17:54:40 +0100
Message-Id: <20200107165442.262020-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107165442.262020-1-hch@lst.de>
References: <20200107165442.262020-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While the flags field in the ABI and the on-disk format allows for
multiple namespace flags, that is a logically invalid combination that
scrub complains about.  Reject it at the ioctl level, as all other
interface already get this right at higher levels.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 5 +++++
 fs/xfs/xfs_ioctl32.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index edfbdb8f85e2..17b4a981be4d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -462,6 +462,11 @@ xfs_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		if ((ops[i].am_flags & ATTR_ROOT) &&
+		    (ops[i].am_flags & ATTR_SECURE)) {
+			ops[i].am_error = -EINVAL;
+			continue;
+		}
 		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
 
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index bd9d9ebf85d8..565c6404ee94 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -450,6 +450,11 @@ xfs_compat_attrmulti_by_handle(
 
 	error = 0;
 	for (i = 0; i < am_hreq.opcount; i++) {
+		if ((ops[i].am_flags & ATTR_ROOT) &&
+		    (ops[i].am_flags & ATTR_SECURE)) {
+			ops[i].am_error = -EINVAL;
+			continue;
+		}
 		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
 
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
-- 
2.24.1

