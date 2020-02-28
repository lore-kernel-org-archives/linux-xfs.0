Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465CEC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C13246AE
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:39:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SZiPTfn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB1XjU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:39:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1XjU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:39:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXW6m068854;
        Fri, 28 Feb 2020 23:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xlKQLy0fUmVXmSyX1xpoWl2MQZcE6cNk0kYFXnPGBko=;
 b=SZiPTfn+DBc3hDgyx3ACp9TikBEv5+sUR84eSy8PDutSG6Iq9M/dXkaZzGXH22oBu9jX
 ONNwnlRZyI9lTvP3I+YNdOUxrsuPmyhQsnvrjhRKwBrgbVNZVinIXQvQlqfsXjd3tsPO
 ZWlNPtYzdPJDlSDV8l/hvMcfYT5j5JDjZy36ThNT4KZ/eDR3/96YF9Umt7SuZwCDH1JN
 SNcJq98naHNnPeZhoCVdmvxSxoDm8Y6ZN00r1IDZF+RQfq0/Of5dG79AHft1z4Md2HhR
 /SKPiaSazZ/iFHfPAUtlsJGSaejECezAtbhZrljmcbqSmlF5AJsut1RzlPsIqJGQYBeD GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnwxn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:39:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcRjm058642;
        Fri, 28 Feb 2020 23:39:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsgbgy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:39:17 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNdHfI013857;
        Fri, 28 Feb 2020 23:39:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:39:04 -0800
Subject: [PATCH 26/26] libxfs: convert buffer priority get/set macros to
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 15:39:03 -0800
Message-ID: <158293314326.1549542.4350225962633251739.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert these shouty macros to proper functions.  We can't make them
static inline functions unless I f the 'libxfs_bcache' reference.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h |    8 +++-----
 libxfs/rdwr.c      |   14 ++++++++++++++
 repair/prefetch.c  |   22 +++++++++++-----------
 3 files changed, 28 insertions(+), 16 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 957f0396..a0605882 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -107,11 +107,9 @@ typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
 
-#define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
-						libxfs_bcache, \
-						&(bp)->b_node, \
-						(pri))
-#define XFS_BUF_PRIORITY(bp)		(cache_node_get_priority(&(bp)->b_node))
+void libxfs_buf_set_priority(struct xfs_buf *bp, int priority);
+int libxfs_buf_priority(struct xfs_buf *bp);
+
 #define xfs_buf_set_ref(bp,ref)		((void) 0)
 #define xfs_buf_ioerror(bp,err)		((bp)->b_error = (err))
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 79d74583..7430ff09 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1577,3 +1577,17 @@ libxfs_log_header(
 	return BBTOB(len);
 }
 
+void
+libxfs_buf_set_priority(
+	struct xfs_buf	*bp,
+	int		priority)
+{
+	cache_node_set_priority(libxfs_bcache, &bp->b_node, priority);
+}
+
+int
+libxfs_buf_priority(
+	struct xfs_buf	*bp)
+{
+	return cache_node_get_priority(&bp->b_node);
+}
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 7f705cc0..0a317b19 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -127,12 +127,12 @@ pf_queue_io(
 	if (bp->b_flags & LIBXFS_B_UPTODATE) {
 		if (B_IS_INODE(flag))
 			pf_read_inode_dirs(args, bp);
-		XFS_BUF_SET_PRIORITY(bp, XFS_BUF_PRIORITY(bp) +
+		libxfs_buf_set_priority(bp, libxfs_buf_priority(bp) +
 						CACHE_PREFETCH_PRIORITY);
 		libxfs_buf_relse(bp);
 		return;
 	}
-	XFS_BUF_SET_PRIORITY(bp, flag);
+	libxfs_buf_set_priority(bp, flag);
 
 	pthread_mutex_lock(&args->lock);
 
@@ -146,7 +146,7 @@ pf_queue_io(
 		}
 	} else {
 		ASSERT(!B_IS_INODE(flag));
-		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
+		libxfs_buf_set_priority(bp, B_DIR_META_2);
 	}
 
 	pftrace("getbuf %c %p (%llu) in AG %d (fsbno = %lu) added to queue"
@@ -276,7 +276,7 @@ pf_scan_lbtree(
 	if (!bp)
 		return 0;
 
-	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
+	libxfs_buf_set_priority(bp, isadir ? B_DIR_BMAP : B_BMAP);
 
 	/*
 	 * If the verifier flagged a problem with the buffer, we can't trust
@@ -454,7 +454,7 @@ pf_read_inode_dirs(
 		}
 	}
 	if (hasdir)
-		XFS_BUF_SET_PRIORITY(bp, B_DIR_INODE);
+		libxfs_buf_set_priority(bp, B_DIR_INODE);
 }
 
 /*
@@ -502,7 +502,7 @@ pf_batch_read(
 			}
 
 			if (which != PF_META_ONLY ||
-				   !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
+				   !B_IS_INODE(libxfs_buf_priority(bplist[num])))
 				num++;
 			if (num == MAX_BUFS)
 				break;
@@ -548,7 +548,7 @@ pf_batch_read(
 
 		if (which == PF_PRIMARY) {
 			for (inode_bufs = 0, i = 0; i < num; i++) {
-				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
+				if (B_IS_INODE(libxfs_buf_priority(bplist[i])))
 					inode_bufs++;
 			}
 			args->inode_bufs_queued -= inode_bufs;
@@ -598,19 +598,19 @@ pf_batch_read(
 				bplist[i]->b_flags |= (LIBXFS_B_UPTODATE |
 						       LIBXFS_B_UNCHECKED);
 				len -= size;
-				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
+				if (B_IS_INODE(libxfs_buf_priority(bplist[i])))
 					pf_read_inode_dirs(args, bplist[i]);
 				else if (which == PF_META_ONLY)
-					XFS_BUF_SET_PRIORITY(bplist[i],
+					libxfs_buf_set_priority(bplist[i],
 								B_DIR_META_H);
 				else if (which == PF_PRIMARY && num == 1)
-					XFS_BUF_SET_PRIORITY(bplist[i],
+					libxfs_buf_set_priority(bplist[i],
 								B_DIR_META_S);
 			}
 		}
 		for (i = 0; i < num; i++) {
 			pftrace("putbuf %c %p (%llu) in AG %d",
-				B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])) ? 'I' : 'M',
+				B_IS_INODE(libxfs_buf_priority(bplist[i])) ? 'I' : 'M',
 				bplist[i], (long long)XFS_BUF_ADDR(bplist[i]),
 				args->agno);
 			libxfs_buf_relse(bplist[i]);

