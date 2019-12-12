Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EADC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0EC22077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dtS2B24C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfLLKyl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:54:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbfLLKyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xehu0LlEwf1pIZjWsM7yTB7w5XDHtUpHAW23Wexhw9w=; b=dtS2B24C5zystQ4IAWG/vSwdEz
        lNXGQBfF2F0virnNZNX8UtotPzLWqrhIx/cJqfGFu2G92obNj/6uHGMgEi0+ANuwJqnGom+1AHYrr
        OpfwcdRN0S9RxJVT1/pEeRzFvVrpL3jKmS9rP80UMI5vRSGHGEEexkOjwnbOgeq8fItY/vE3YDPOy
        WQjA9x2BotL6EOoXBj4upQnKvzLv1/vseVYzD+8dORom4cfmTOseVn9xxbBbdlfeLIdhKFdTmnQI3
        dz/QprcewkLj1fIHHX/M4aYK9kraAS9Bk2WUyolhnmWlIXFJvrHt/PhqyuJ1J4diKeHjZjS4eY0Rq
        art4PP5w==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7E-00017p-Sm; Thu, 12 Dec 2019 10:54:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 02/33] xfs: reject invalid flags combinations in XFS_IOC_ATTRMULTI_BY_HANDLE
Date:   Thu, 12 Dec 2019 11:54:02 +0100
Message-Id: <20191212105433.1692-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
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
---
 fs/xfs/xfs_ioctl.c   | 5 +++++
 fs/xfs/xfs_ioctl32.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2f76d0a7b818..f3a53e0db2cf 100644
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
 		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
 
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 8b5acf8c42e1..720eb72f3be3 100644
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
 		ops[i].am_flags &= ATTR_KERNEL_FLAGS;
 
 		ops[i].am_error = strncpy_from_user((char *)attr_name,
-- 
2.20.1

