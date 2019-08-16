Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E773C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09E522077C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZN3J5hQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfHPGf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:35:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPGf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tgoC4KxRN7NwrYeIcYnDsJgRhDtmzJy7npt/CVH5uaY=; b=ZN3J5hQ9JWVXSj2t4BE6S4bEUw
        X+47IxSlms9K/Xcf4W5Bd8RJNOwTF0VDUtvKrAw1tcs63ekC4A9ORE0ehjsi0TOjnp5yrsyQLYWfm
        8DjS8rGEbWegky2FTclyrmpHyBCkXZd5dQO7tc0gz337TzRzENdOI5dCpZtR6gx+rSwbhboWntKlK
        fxZTFtRFWlfk3NFWeSBXE+TRi6TQxRejR+HhkGc+IIeNCSZfNBQIXgA+MEuI1/eY41/D1Sy9K0M/S
        mM7U+PLc2Sts1bJo+vlLaVN7h+g7UVvArYB7DbGuNdoZZS+1AxRyU/oRAMQFZqq/5uQd7a/M7MAkV
        bKlkugMw==;
Received: from [2001:4bb8:18c:28b5:44f9:d544:957f:32cb] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hyVq8-0001uv-VT; Fri, 16 Aug 2019 06:35:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/2] xfs: compat_ioctl: use compat_ptr()
Date:   Fri, 16 Aug 2019 08:35:47 +0200
Message-Id: <20190816063547.1592-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816063547.1592-1-hch@lst.de>
References: <20190816063547.1592-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For 31-bit s390 user space, we have to pass pointer arguments through
compat_ptr() in the compat_ioctl handler.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index bae08ef92ac3..7bd7534f5051 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	void			__user *arg = (void __user *)p;
+	void			__user *arg = compat_ptr(p);
 	int			error;
 
 	trace_xfs_file_compat_ioctl(ip);
@@ -655,6 +655,6 @@ xfs_file_compat_ioctl(
 		return xfs_compat_fssetdm_by_handle(filp, arg);
 	default:
 		/* try the native version */
-		return xfs_file_ioctl(filp, cmd, p);
+		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
 	}
 }
-- 
2.20.1

