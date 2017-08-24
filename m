Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57711 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751840AbdHXKnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 06:43:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7OAd3DO027981
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 06:43:00 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2chsgcy35u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2017 06:43:00 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <khandual@linux.vnet.ibm.com>;
        Thu, 24 Aug 2017 20:42:57 +1000
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH] xfs: Drop setting redundant PF_KSWAPD in kswapd context
Date: Thu, 24 Aug 2017 16:12:47 +0530
Message-Id: <20170824104247.8288-1-khandual@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dchinner@redhat.com, bfoster@redhat.com, sandeen@sandeen.net

xfs_btree_split() calls xfs_btree_split_worker() with args.kswapd set
if current->flags alrady has PF_KSWAPD. Hence we should not again add
PF_KSWAPD into the current flags inside kswapd context. So drop this
redundant flag addition.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e0bcc4a..b3c85e3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2895,7 +2895,7 @@ struct xfs_btree_split_args {
 	 * in any way.
 	 */
 	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE;
 
 	current_set_flags_nested(&pflags, new_pflags);
 
-- 
1.8.5.2

