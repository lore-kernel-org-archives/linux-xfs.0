Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbfHMJDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 05:03:12 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Minor cleanups
Date: Tue, 13 Aug 2019 12:03:03 +0300
Message-Id: <20190813090306.31278-1-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

While digging around xfs' buf code I spotted a couple of cleanup candidates
which resulted in this patch. It should hopefully make the code easier to inspect
by reducing the 'hops' to the actual implementation of buffer submission. 

Nikolay Borisov (3):
  xfs: Use __xfs_buf_submit everywhere
  xfs: Rename __xfs_buf_submit to xfs_buf_submit
  xfs: Opencode and remove DEFINE_SINGLE_BUF_MAP

 fs/xfs/xfs_buf.c         | 16 +++++++++-------
 fs/xfs/xfs_buf.h         | 16 ++++------------
 fs/xfs/xfs_buf_item.c    |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 fs/xfs/xfs_trans.h       |  6 ++++--
 5 files changed, 19 insertions(+), 23 deletions(-)

-- 
2.17.1
