Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A9EC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 16:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9FA2073B
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 16:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omfljF0d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgEDQQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 12:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgEDQQQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 12:16:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2EC061A0E;
        Mon,  4 May 2020 09:16:16 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a32so3986pje.5;
        Mon, 04 May 2020 09:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mJxATeoW9r1Ijzs0Cv12TCPDgNZzSbmxIdXoWB9J3wU=;
        b=omfljF0dC/ATvmTsC2aJI+kHBhsxfZzHuKUdvPV/DvDvlRI/fZO15ItSIynzHh8WQ5
         bbH7N1bQL2FjjPAEIrEd0PFWOz8TBebD0eBDMXALia6+1uXwoCkCVV+uX1/gi1jZHP2z
         OGSFKCTO881EK7uqpI1LWSBPKKz3A4hHD7y4W4PAbbuwAb5/WlOnF2MxmaKNiQel42ZG
         eRZSeaz3GqZDN5Mz76/vMH5GDJKd6nGUwDo2o/AUfrXkZ+qIkvN9oMVNVlUd0hjv/Cnl
         PXQnP2kYOYpLYIc4NXyguUo6khYx8Yzkb3qeP6sWEgYTKcCU10jAgwRJCaS3O5Hyk/KT
         SSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mJxATeoW9r1Ijzs0Cv12TCPDgNZzSbmxIdXoWB9J3wU=;
        b=EQHJJhgWysNJ6/rQjKChZEgXad57ZHVPLcDPT1TIw3FFAa77zyeNVJbDB1nlciUvzk
         4FNPr9RaPXqyanEOLZKRKlNUUa84+RuWYIILHOCFUy7TAyzm3NhObMPpyRU3lUxedMmZ
         IWCzA9Zqo02gjoXTEMzZvuPGCwYQ0PvB/RqoD/D7cxehHEiqH/3WBcPRcZbN9aJT0TzD
         i9yzDDk4OzouA1rCOv04ZjTrstv7vjypKE8FP6/EiMj5L4F7+lnX66mzxE9YUnE+6XyJ
         zVNOM1VfSvhGvC8hdjJCS5T796liOVAaJJKNRAphQCdnYlHKw41tl8s2vXiEDObRgq8w
         MtHg==
X-Gm-Message-State: AGi0Puahozn6ZJPkMyroCIzr7pgujMNvPhihdyOW+EwDle1tP4X2+Jdn
        FdBPmJzGvZ3PySD8//+U/qA=
X-Google-Smtp-Source: APiQypKyG4mJ/QDG3KcoaV0DVI3jvg+MGkPaCDGlrIosbApPc0EPrPqH0uGoRpOpc+3ULNyzpJbiVg==
X-Received: by 2002:a17:90a:4ce5:: with SMTP id k92mr71565pjh.192.1588608975646;
        Mon, 04 May 2020 09:16:15 -0700 (PDT)
Received: from localhost.localdomain ([120.244.110.63])
        by smtp.gmail.com with ESMTPSA id 4sm9515257pff.18.2020.05.04.09.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 09:16:14 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] fs: xfs: fix a possible data race in xfs_inode_set_reclaim_tag()
Date:   Tue,  5 May 2020 00:15:30 +0800
Message-Id: <20200504161530.14059-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We find that xfs_inode_set_reclaim_tag() and xfs_reclaim_inode() are
concurrently executed at runtime in the following call contexts:

Thread1:
  xfs_fs_put_super()
    xfs_unmountfs()
      xfs_rtunmount_inodes()
        xfs_irele()
          xfs_fs_destroy_inode()
            xfs_inode_set_reclaim_tag()

Thread2:
  xfs_reclaim_worker()
    xfs_reclaim_inodes()
      xfs_reclaim_inodes_ag()
        xfs_reclaim_inode()

In xfs_inode_set_reclaim_tag():
  pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
  ...
  spin_lock(&ip->i_flags_lock);

In xfs_reclaim_inode():
  spin_lock(&ip->i_flags_lock);
  ...
  ip->i_ino = 0;
  spin_unlock(&ip->i_flags_lock);

Thus, a data race can occur for ip->i_ino.

To fix this data race, the spinlock ip->i_flags_lock is used to protect
the access to ip->i_ino in xfs_inode_set_reclaim_tag().

This data race is found by our concurrency fuzzer.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8bf1d15be3f6..a2de08222ff5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -229,9 +229,9 @@ xfs_inode_set_reclaim_tag(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
 
+	spin_lock(&ip->i_flags_lock);
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
 
 	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			   XFS_ICI_RECLAIM_TAG);
-- 
2.17.1

