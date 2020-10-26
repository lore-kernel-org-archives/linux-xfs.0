Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E61C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2342120809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DFdOTnM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407253AbgJZXic (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407243AbgJZXic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNRVQ8178130;
        Mon, 26 Oct 2020 23:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FasFLPm8wvobKvntM6PJhsjlR0POhoWoR6iGm+nDhc0=;
 b=DFdOTnM1SXoohix9w8eRc8AftunqhYdUjY8vqePbdoiqB79pW7ZrG3CVSayjOV6RaEVy
 pBRIVTZuYobGbUL2/plS2YnMemwZvA4Ns/GJIjc7gmVShWCxtFLnlc7vUSTL8Z+QNXkR
 vjtO9kD4QZgWQXHvjgUtTI9lx456Yqx+Z9118sA80qdtTFKbg8pJZtNxgQhqCu96cebU
 WgWsSIX7SezweQevfLwdAQPGAUsZJWwZkoov3dhjjGi793a3pWrI6a2oklMNu6fKwNuD
 7jLaF0A0mYVxzGCAWLlnqfxBEwA+1S92NBhyD3emTa+eUJvsoWrZIoSnk1O3HPEAW6zR tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqdb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxG5110502;
        Mon, 26 Oct 2020 23:38:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wftva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNcQEn009017;
        Mon, 26 Oct 2020 23:38:26 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:26 -0700
Subject: [PATCH 14/21] xfs: xfs_defer_capture should absorb remaining block
 reservations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:25 -0700
Message-ID: <160375550572.882906.4778143498429867343.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 4f9a60c48078c0efa3459678fa8d6e050e8ada5d

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the remaining block reservations so
that when we continue the dfops chain, we can reserve the same number of
blocks to use.  We capture the reservations for both data and realtime
volumes.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trans.h |    2 ++
 libxfs/trans.c      |    1 +
 libxfs/xfs_defer.c  |    4 ++++
 libxfs/xfs_defer.h  |    4 ++++
 4 files changed, 11 insertions(+)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 9292a4a54237..f19914068030 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -64,9 +64,11 @@ typedef struct xfs_trans {
 	unsigned int	t_log_res;		/* amt of log space resvd */
 	unsigned int	t_log_count;		/* count for perm log res */
 	unsigned int	t_blk_res;		/* # of blocks resvd */
+	unsigned int	t_rtx_res;
 	xfs_fsblock_t	t_firstblock;		/* first block allocated */
 	struct xfs_mount *t_mountp;		/* ptr to fs mount struct */
 	unsigned int	t_blk_res_used;		/* # of resvd blocks used */
+	unsigned int	t_rtx_res_used;
 	unsigned int	t_flags;		/* misc flags */
 	long		t_icount_delta;		/* superblock icount change */
 	long		t_ifree_delta;		/* superblock ifree change */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6838b727350b..6499a30aef05 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -230,6 +230,7 @@ xfs_trans_reserve(
 			error = -ENOSPC;
 			goto undo_blocks;
 		}
+		tp->t_rtx_res += rtextents;
 	}
 
 	return 0;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 90dc9ce92106..fc5c860e5d56 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -573,6 +573,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the remaining block reservations along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
+
 	return dfc;
 }
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 3af82ebc1249..5c0e59b69ffa 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -75,6 +75,10 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+
+	/* Block reservations for the data and rt devices. */
+	unsigned int		dfc_blkres;
+	unsigned int		dfc_rtxres;
 };
 
 /*

