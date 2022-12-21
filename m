Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290C8C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 15:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiLUPXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 10:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiLUPXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 10:23:14 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597282339C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 07:23:13 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id q10so10495330qvt.10
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 07:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7Igu/3MchCXKLzDBdD3GPkaU5cX53uLzAFQpMQw/1Hk=;
        b=YFrm6DHnid2OMstuS0QkDlSjNzxZvkTVkXp2IribXmOfIgLeDCbGKAY36at7Nm7p2l
         m5nTtk2CcBjuSPGL7Gt9QUXliFkiuki5zmitjKpxkkhCWeIOKqnZyaJ15GwsgQcbysS8
         xm0KwQ2e8DQrXw7td/sPJxKe0mPUMQhKQKDFkPh2ykwzb/Ug/Exoh5Px2bA4xFWswH7Q
         nbu7cPs/W9H3Q5KG0ddgYji+qSjDgIppZVBfQPa2uk3vI0v+fST5UKaf4cDfInIg7olq
         lNuZIqS5oNkvDZ+wuYA8E5ZgdSl4e0txfNzYitdWCzcH4hE8d9msal/ZoG/pKpPSdG54
         HXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Igu/3MchCXKLzDBdD3GPkaU5cX53uLzAFQpMQw/1Hk=;
        b=3F144gz3nuuHy5keT2mQh+g9RdPKz7Fkc/YQe7wHKOfGPZ6zHILCVfhEj0krcOOJJe
         9pCkrG31Xs99GkEkM9aICmtrguveTcUzphkuwge3sTDBZJv5NPZzx5RHRbUmmoxW/Sst
         Q4+Chu0aap0afqi1/aIkNO4cOtmxdrE80eYLMZ9RYCan9wqeIuUW7bf9S8XvUfK4X8qj
         WRxrGqK2ZUAJLzw4xRcq1gZquMpNvih6OR8CFaILATpmCKwdheVh99TPG77yKlAuaojV
         QCOMP+/1pJ2OyIf+YSEBXpZgr10sDSFMDbF4HJ0yibMcX5/zalX7cDflrwokB5004qq6
         vdTw==
X-Gm-Message-State: AFqh2krTEIbGYdk/p3txa15j83CWj81B2dYm4yTVwcRRrOgVfAz+HhHw
        DPG9mQfxLvY3UpVXkEQNC7CYuHzhCno=
X-Google-Smtp-Source: AMrXdXvoTYnKvXO6DCXaO8l3WAzQuTwnzCGiDysEVCmHvx5UN3/9TqaQcOp76AC3lTMiw6IxoPLaXA==
X-Received: by 2002:a05:6214:5e10:b0:4c7:9adf:3637 with SMTP id li16-20020a0562145e1000b004c79adf3637mr3410057qvb.13.1671636192529;
        Wed, 21 Dec 2022 07:23:12 -0800 (PST)
Received: from shiina-laptop.hsd1.ma.comcast.net ([2601:18f:47f:7270:54c1:7162:1772:f1d])
        by smtp.gmail.com with ESMTPSA id v18-20020a05620a0f1200b006cf38fd659asm11296220qkl.103.2022.12.21.07.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:23:12 -0800 (PST)
From:   Hironori Shiina <shiina.hironori@gmail.com>
X-Google-Original-From: Hironori Shiina <shiina.hironori@fujitsu.com>
To:     linux-xfs@vger.kernel.org
Cc:     Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [PATCH] xfs: get root inode correctly at bulkstat
Date:   Wed, 21 Dec 2022 10:22:21 -0500
Message-Id: <20221221152221.120005-1-shiina.hironori@fujitsu.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The root inode number should be set to `breq->startino` for getting stat
information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
Otherwise, the inode search is started from 1
(XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
filesystem is returned.

Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 13f1b2add390..020111f0f2a2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -780,7 +780,7 @@ xfs_bulk_ireq_setup(
 
 		switch (hdr->ino) {
 		case XFS_BULK_IREQ_SPECIAL_ROOT:
-			hdr->ino = mp->m_sb.sb_rootino;
+			breq->startino = mp->m_sb.sb_rootino;
 			break;
 		default:
 			return -EINVAL;
-- 
2.38.1

