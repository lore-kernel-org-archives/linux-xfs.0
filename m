Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971F6C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7368720740
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 18:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AerbAIp2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfKNSUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:20:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbfKNSUC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 13:20:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEIK0cF073060
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IdNxkamMSPl0Tw6FdCaYPHZ/RJFnxXg7Ke2tsJGjI3A=;
 b=AerbAIp2e3EXyS9Jj3y7m0yv5VKR99AFp61IO1u6EbfQWCOlYk2HbMrEZ9Tde8/r7faM
 N9hfWbVZxqEkZhJCU8/gJXuayA92hnwggiRKXiEG/Paj1RyJ4qZ1ndQF6l3FW4RVqa3+
 QJM2IpPLlOkwBouOkbv84aJazQzv5VeGuQjzKiKfQmI/5vRayqzSRUGGah5UjuDfviZa
 DJ3hyttM33s82uEUwAbJBgQ1CyKbv/O1P+oGvSrMRk9L41HbUoRnIJLEds6iiWT/VbcI
 3HhJhFVzp5ann+zG5M+kCoXJESrY56ZmwUdM9iHO3KznDDrKdNucvrlL5g61pPqZpfgf 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3r4wcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEI44SL106969
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w8g19tn5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAEIK01f031548
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 18:20:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 10:19:59 -0800
Subject: [PATCH 7/9] xfs: report inode corruption errors to the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Nov 2019 10:19:59 -0800
Message-ID: <157375559910.3692735.16877132028535941668.stgit@magnolia>
In-Reply-To: <157375555426.3692735.1357467392517392169.stgit@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140156
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
index 8afacfe4be0a..10dab755abe0 100644
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
@@ -648,6 +652,7 @@ xfs_iread(
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
index ec302b7e48f3..3e6c27d69132 100644
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
index a2812cea748d..e49712f073ff 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3653,6 +3653,7 @@ xfs_iflush_cluster(
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 
 	/* abort the corrupt inode, as it was not attached to the buffer */
+	xfs_inode_mark_sick(cip, XFS_SICK_INO_CORE);
 	xfs_iflush_abort(cip, false);
 	kmem_free(cilist);
 	xfs_perag_put(pag);
@@ -3950,6 +3951,7 @@ xfs_iflush_int(
 	return 0;
 
 corrupt_out:
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 	return -EFSCORRUPTED;
 }
 

