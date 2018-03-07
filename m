Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933106AbeCGJFQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:05:16 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80AEA8185330
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:15 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 260FA10B0F49
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:15 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/4] Get rid of XFS_BUF_TARGET() macro
Date: Wed,  7 Mar 2018 10:05:04 +0100
Message-Id: <20180307090506.30199-3-cmaiolino@redhat.com>
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This macro is unused

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/libxfs_io.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index a1c62071..04bbc9b7 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -101,7 +101,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 #define XFS_BUF_COUNT(bp)		((bp)->b_bcount)
-#define XFS_BUF_TARGET(bp)		((bp)->b_dev)
 #define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
 	(bp)->b_addr = (char *)(p);		\
 	XFS_BUF_SET_COUNT(bp,cnt);		\
-- 
2.14.3

