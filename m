Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EF4C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BDEB20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aoNoy4hw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407279AbgJZXi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39310 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407277AbgJZXi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPLiZ158051;
        Mon, 26 Oct 2020 23:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bBdzV4Fmq+eR0nmQChN77rRJQVFuWrAhwex16xzdcMo=;
 b=aoNoy4hw1S6FyuTTm2bmfh+hShcie5L3QTZ8cS6XOarjbUWWhE5fBhUT/OnUV0A4usPI
 8AgH8IOq0tN1/Mm+8Kgnu0eg8HcUlC8k4Wo9/deRJqKMI/SXsulCV/vTjWomRSHbzvF1
 iQtFHOBOmvJ18HKkKpeZLxcIiAbrPfwRYWSUm/6p2YIO7JZHDwt8vcbeoEra06FIqMXR
 PoFB+RkinPDnsD+J2qGs2VqcvhFUxuyv2jRne83Le6bQzH0oW+1p5HrANVYNtyfN17Z0
 s+cW4zhI9enoPxx4RSkqm1JVQHpxaYJOLVf5sSG9wHCeXX2D5bBgJ8LZRAfZYeVi91ol ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPHgZ121186;
        Mon, 26 Oct 2020 23:38:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6va7um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNcq0A007338;
        Mon, 26 Oct 2020 23:38:52 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:52 -0700
Subject: [PATCH 18/21] xfs: periodically relog deferred intent items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:50 -0700
Message-ID: <160375553085.882906.7937700095322305400.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 4e919af7827a6adfc28e82cd6c4ffcfcc3dd6118

There's a subtle design flaw in the deferred log item code that can lead
to pinning the log tail.  Taking up the defer ops chain examples from
the previous commit, we can get trapped in sequences like this:

Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
chain will look like the following if the transaction rolls succeed:

t1: D0(t0), D1(t0), D2(t0), D3(t0)
t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

In transaction 9, we finish d9 and try to roll to t10 while holding onto
an intent item for D3 that we logged in t0.

The previous commit changed the order in which we place new defer ops in
the defer ops processing chain to reduce the maximum chain length.  Now
make xfs_defer_finish_noroll capable of relogging the entire chain
periodically so that we can always move the log tail forward.  Most
chains will never get relogged, except for operations that generate very
long chains (large extents containing many blocks with different sharing
levels) or are on filesystems with small logs and a lot of ongoing
metadata updates.

Callers are now required to ensure that the transaction reservation is
large enough to handle logging done items and new intent items for the
maximum possible chain length.  Most callers are careful to keep the
chain lengths low, so the overhead should be minimal.

The decision to relog an intent item is made based on whether the intent
was logged in a previous checkpoint, since there's no point in relogging
an intent into the same checkpoint.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h |    2 ++
 include/xfs_trans.h |    3 +++
 libxfs/xfs_defer.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 91f2b98b6c30..a1002638f39a 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -63,6 +63,8 @@
 #define trace_xfs_iext_insert(a,b,c,d)		((void) 0)
 #define trace_xfs_iext_remove(a,b,c,d)		((void) 0)
 
+#define trace_xfs_defer_relog_intent(a,b)	((void) 0)
+
 #define trace_xfs_dir2_grow_inode(a,b)		((void) 0)
 #define trace_xfs_dir2_shrink_inode(a,b)	((void) 0)
 
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index f19914068030..1784b8b64cf8 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -148,4 +148,7 @@ libxfs_trans_read_buf(
 	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1, flags, bpp, ops);
 }
 
+#define xfs_log_item_in_current_chkpt(lip)	(false)
+#define xfs_trans_item_relog(lip, tp)		(NULL)
+
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 58b229e4054e..abee6d4260e2 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -342,6 +342,42 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Prevent a log intent item from pinning the tail of the log by logging a
+ * done item to release the intent item; and then log a new intent item.
+ * The caller should provide a fresh transaction and roll it after we're done.
+ */
+static int
+xfs_defer_relog(
+	struct xfs_trans		**tpp,
+	struct list_head		*dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is not a part of
+		 * the current log checkpoint, relog the intent item to keep
+		 * the log tail moving forward.  We're ok with this being racy
+		 * because an incorrect decision means we'll be a little slower
+		 * at pushing the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
+			continue;
+
+		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
+		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+	}
+
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
+}
+
 /*
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
@@ -428,6 +464,11 @@ xfs_defer_finish_noroll(
 		if (error)
 			goto out_shutdown;
 
+		/* Possibly relog intent items to keep the log moving. */
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
+
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
 		error = xfs_defer_finish_one(*tp, dfp);

