Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbeDRCj6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:39:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2cGwH098191
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2duhJ012132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:57 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2duSq030188
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:56 GMT
Subject: [PATCH 03/11] xfs: report failing address when dquot verifier fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:39:46 -0700
Message-ID: <152401918598.11465.13251754451621038930.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the failing address through to the corruption report when dquot
verifiers fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 8b7a6c3..a1e6cf1 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -229,7 +229,7 @@ xfs_dquot_buf_read_verify(
 	else {
 		fa = xfs_dquot_buf_verify(mp, bp);
 		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 	}
 }
 
@@ -266,7 +266,7 @@ xfs_dquot_buf_write_verify(
 
 	fa = xfs_dquot_buf_verify(mp, bp);
 	if (fa)
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {

