Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbeBVVdF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 16:33:05 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C64CE28216
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 21:33:05 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C8FF5C892
        for <linux-xfs@vger.kernel.org>; Thu, 22 Feb 2018 21:33:05 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: don't return cnt as failure from XFS_BUF_SET_PTR
Message-ID: <7514683c-3a04-5fd6-a455-c09a5b370bc5@redhat.com>
Date: Thu, 22 Feb 2018 15:33:04 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

We must not get here very often, because any test of an error
from XFS_BUF_SET_PTR will fail because it  returns whatever
is sent in as cnt.  Fix the macro to return 0 so that
"error = XFS_BUF_SET_PTR()" works as expected.

Should probably make this xfs_buf_associate_memory() to be
more like kernelspace, but for now just fix up the bug.

Found this via xfs_logprint failing for no good reason.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 81d2804..0ae7a28 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -105,6 +105,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
 	(bp)->b_addr = (char *)(p);		\
 	XFS_BUF_SET_COUNT(bp,cnt);		\
+	0;					\
 })
 
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))

