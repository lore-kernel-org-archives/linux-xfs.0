Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22536 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405024AbfFLJKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 05:10:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D1F744CDD0CA
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 17:09:59 +0800 (CST)
From: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Subject: [PATCH] mkfs: remove useless log options in usage
Date: Wed, 12 Jun 2019 17:09:35 +0800
Message-ID: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Yang Xu <xuyang2018.jy@cn.fujitsu.com>

Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
xfsprogs has discarded log options in node_options, remove it in usage.

Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index db3ad38e..91391b72 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -858,7 +858,7 @@ usage( void )
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
 /* force overwrite */	[-f]\n\
-/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
+/* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-- 
2.18.1
