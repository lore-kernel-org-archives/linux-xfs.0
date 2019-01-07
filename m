Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:37514 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfAGUOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 15:14:34 -0500
Received: by mail-wr1-f49.google.com with SMTP id s12so1797540wrt.4
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jan 2019 12:14:33 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id j124sm3194818wmb.48.2019.01.07.12.14.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:14:31 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH v6 0/5] Try to squash metadump data leaks
Date: Mon,  7 Jan 2019 21:13:50 +0100
Message-Id: <20190107201355.18996-1-stefanrin@gmail.com>
In-Reply-To: <20181105213145.7560-1-stefanrin@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

After the (hopefully) final round of reviews:

- Changed the control flow logic in patch 2
- Added the newline in patch 5

As a consequence of the former, patch 3 has minimally changed and does
not remove the write: label anymore. I applied Reviewed-by anyway; I
hope that's ok.

Also here, if this is more convenient:
https://github.com/Ringdingcoder/xfsprogs-dev/commits/metadump-stale-data-v6

Stefan Ring (5):
  xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
  xfs_metadump: Zap multi fsb blocks
  xfs_metadump: Zap freeindex blocks in directory inodes
  xfs_metadump: Zap unused space in inode btrees
  xfs_metadump: Zap dev inodes

 db/metadump.c | 132 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 117 insertions(+), 15 deletions(-)

-- 
2.19.2
