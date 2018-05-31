Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48960 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755691AbeEaQdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 12:33:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VGW0Gn069246
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:53 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2j9ev87tn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:53 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4VGXqWX024875
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:52 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VGXphO001803
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 16:33:52 GMT
Subject: [PATCH 1/4] xfs: xfs_rtword_t should be unsigned, not signed
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 May 2018 09:33:50 -0700
Message-ID: <152778443080.6891.5154502694195176365.stgit@magnolia>
In-Reply-To: <152778442467.6891.15278589749191666547.stgit@magnolia>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_rtword_t is used for bit manipulations in the realtime bitmap file.
Since we're performing bit shifts with this type, we don't want sign
extension and we don't want to be left shifting negative quantities
because that's undefined behavior.

This also shuts up these UBSAN warnings:
UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_rtbitmap.c:833:48
signed integer overflow:
-2147483648 - 1 cannot be represented in type 'int'

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 3c560695c546..ea18449bd732 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -30,7 +30,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
 typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
-typedef int32_t		xfs_rtword_t;	/* word type for bitmap manipulations */
+typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
 typedef int32_t		xfs_tid_t;	/* transaction identifier */

