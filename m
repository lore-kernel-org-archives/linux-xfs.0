Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29869FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E012077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KJPsfo1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbfKGDD5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:03:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45924 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732304AbfKGDD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x9ui049389
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g0TtpK/mAo8ialJHCyZTGurrBWemTbpISaESBFdXTeU=;
 b=KJPsfo1MhuZbwTIWl6OBrjh2CrWA8IfZK06Lg7xAQZWnQijHGFx3gxL6Mn6YXSCAavDv
 cn6gHsGw3XTDEjterAWLuEGt6I2B033g063ZlfJEqfDp4jp+rKGAHhJmQ8bxtDwSbR9r
 Ovu5e3POSCV09R2jipJarI5q9RqwoJ5mTB8HHSPj2njKzkujpgoCvO1tLzqB6rU5PXrM
 OK6Tl0krSoFDoRKt2zEg7owRsZ+tr+QHeJxg4TITEPt3p6Kv1yAaZRn0jLnltxW36vTD
 x7KCV8GClQlzVZ+ISbrsgzh+jc9dRrq2itmHRkLnpLdsrOMMSadFLJkwh3WLXIld5QAs 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w130hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA733sHX164417
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w41w8krde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA733nvJ029528
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:49 -0800
Subject: [PATCH 07/10] xfs: report inode corruption errors to the health
 system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:48 -0800
Message-ID: <157309582866.46704.1404706282622657662.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
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
 

