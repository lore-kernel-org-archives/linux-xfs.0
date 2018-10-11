Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:56223 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeJLCvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 22:51:50 -0400
Received: by mail-wm1-f44.google.com with SMTP id 206-v6so10107267wmb.5
        for <linux-xfs@vger.kernel.org>; Thu, 11 Oct 2018 12:23:14 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id e133-v6sm27193999wma.42.2018.10.11.12.23.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:23:12 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH v2 0/2] Try to squash metadump data leaks
Date: Thu, 11 Oct 2018 21:23:05 +0200
Message-Id: <20181011192307.18553-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Since the initial version, I have added the handling of v3 dirs, done
some reformatting, added a second changeset because some parts where
not processed for zapping on file systems with multi-fsb dir blocks,
and also adapted my new code to cope with multi-fsb (which amounted to
nothing more than swapping m_sb.sb_blocksize for
m_dir_geo->blksize). I tested all my changes with a v3 image and made
sure to hit all the touched code paths.

Stefan Ring (2):
  xfs_metadump: Extend zapping to multi fsb dir blocks
  xfs_metadump: Zap more stale data

 db/metadump.c | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 107 insertions(+), 14 deletions(-)

-- 
2.14.4
