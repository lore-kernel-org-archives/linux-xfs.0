Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44525 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387913AbeKFGx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 01:53:57 -0500
Received: by mail-wr1-f43.google.com with SMTP id j17-v6so6029374wrq.11
        for <linux-xfs@vger.kernel.org>; Mon, 05 Nov 2018 13:32:15 -0800 (PST)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x18-v6sm38861711wrs.50.2018.11.05.13.32.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Nov 2018 13:32:13 -0800 (PST)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH v5 0/5] Try to squash metadump data leaks
Date: Mon,  5 Nov 2018 22:31:40 +0100
Message-Id: <20181105213145.7560-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Another round... I'm starting to feel quite confident about it this time.

Since last time:

- Fixed the attribute corruption in the last patch.
- Changed the accidental 'a' and 'b' I had left in the code back to zeroes.
- Brought the flag for crc recalc a tiny bit more in line with the single_fsb code.
- Fixed the wrong control flow in the interim patch which duplicates a TODO comment in the code only to get rid of it in the next patch.


Stefan Ring (5):
  xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_MAGIC blocks
  xfs_metadump: Zap multi fsb blocks
  xfs_metadump: Zap freeindex blocks in directory inodes
  xfs_metadump: Zap unused space in inode btrees
  xfs_metadump: Zap dev inodes

 db/metadump.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 113 insertions(+), 15 deletions(-)

-- 
2.14.5
