Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B53ECA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D12FF2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PJN+4BOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfKCWZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:25:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfKCWZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:25:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOFLa061247
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g0TtpK/mAo8ialJHCyZTGurrBWemTbpISaESBFdXTeU=;
 b=PJN+4BOCK9RSs7IgygzEUBN1bszlDIYKictZBDNKKwxdodphl4TU/YHEX/X4HYe5usYt
 OMpRfAGXZlqYB52MnUlnXgT/3e/LoAi0oxmG+lu4gEYjAZXxzAJoExKv1TyNahpwVP55
 7JIX5M3K00KLqwk0nQqswHh2cJQ86ZqP+G6ABxIkzHgC4Ew/LRAyFZHcZoFf5tnCwgHC
 NUGd1h66EF5YAp6xn7UnOfHab+WEYlhezymTRecgh/7wkTdUfO+SXWQSZUXERzap2Fgy
 rbjilaHqYMkx/0QaJSCI/7gBOBP7vfKnP5eEVbWincdBkRXWsxADrPau2RICcMlSdJuB jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12eqv068-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOAhE071472
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w1ka8e7re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:25:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MPTu1005732
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:25:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:25:29 -0800
Subject: [PATCH 07/10] xfs: report inode corruption errors to the health
 system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:25:28 -0800
Message-ID: <157281992801.4152102.7357389240554985478.stgit@magnolia>
In-Reply-To: <157281988489.4152102.1632857939932700344.stgit@magnolia>
References: <157281988489.4152102.1632857939932700344.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt inode records, we should report that to
the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |    5 +++++
 fs/xfs/libxfs/xfs_inode_fork.c |    8 ++++++++
 fs/xfs/xfs_icache.c            |    4 ++++
 fs/xfs/xfs_inode.c             |    2 ++
 4 files changed, 19 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 28ab3c5255e1..d4f0c4948750 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -182,6 +183,9 @@ xfs_imap_to_bp(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
 				   (int)imap->im_len, buf_flags, &bp,
 				   &xfs_inode_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
+				XFS_SICK_AG_INOBT);
 	if (error) {
 		if (error == -EAGAIN) {
 			ASSERT(buf_flags & XBF_TRYLOCK);
@@ -651,6 +655,7 @@ xfs_iread(
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
 				sizeof(*dip), fa);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		goto out_brelse;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 15d6f947620f..6698161b581b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -23,6 +23,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_health.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -77,6 +78,7 @@ xfs_iformat_fork(
 		default:
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
 		}
 		break;
@@ -84,6 +86,7 @@ xfs_iformat_fork(
 	default:
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 	if (error)
@@ -116,6 +119,7 @@ xfs_iformat_fork(
 	default:
 		xfs_inode_verifier_error(ip, error, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		break;
 	}
@@ -189,6 +193,7 @@ xfs_iformat_local(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -226,6 +231,7 @@ xfs_iformat_extents(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
@@ -245,6 +251,7 @@ xfs_iformat_extents(
 				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 						"xfs_iformat_extents(2)",
 						dp, sizeof(*dp), fa);
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
 			}
 
@@ -304,6 +311,7 @@ xfs_iformat_btree(
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,
 				__this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 944add5ff8e0..655d587f3980 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -22,6 +22,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -321,6 +322,7 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
 				ip->i_ino, VFS_I(ip)->i_mode);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
 		}
 
@@ -328,6 +330,7 @@ xfs_iget_check_free_state(
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			return -EFSCORRUPTED;
 		}
 		return 0;
@@ -511,6 +514,7 @@ xfs_iget_cache_miss(
 		goto out_destroy;
 
 	if (!xfs_inode_verify_forks(ip)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		goto out_destroy;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d02246e2fb21..5167b8ceb219 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3637,6 +3637,7 @@ xfs_iflush_cluster(
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 
 	/* abort the corrupt inode, as it was not attached to the buffer */
+	xfs_inode_mark_sick(cip, XFS_SICK_INO_CORE);
 	xfs_iflush_abort(cip, false);
 	kmem_free(cilist);
 	xfs_perag_put(pag);
@@ -3934,6 +3935,7 @@ xfs_iflush_int(
 	return 0;
 
 corrupt_out:
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 	return -EFSCORRUPTED;
 }
 

