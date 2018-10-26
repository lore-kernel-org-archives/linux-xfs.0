Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:55934 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbeJ0E60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 00:58:26 -0400
Received: by mail-wm1-f42.google.com with SMTP id s10-v6so2614091wmc.5
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 13:20:00 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id 193-v6sm7669219wmj.21.2018.10.26.13.19.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Oct 2018 13:19:58 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 0/5] v4 Try to squash metadump data leaks
Date: Fri, 26 Oct 2018 22:19:38 +0200
Message-Id: <20181026201943.24131-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I reorganized the patches as suggested and fixed the btree case.

Stefan Ring (5):
  xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
  xfs_metadump: Zap multi fsb blocks
  xfs_metadump: Zap freeindex blocks in directory inodes
  xfs_metadump: Zap unused space in inode btrees
  xfs_metadump: Zap dev inodes

 db/metadump.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 105 insertions(+), 14 deletions(-)

-- 
2.14.5
