Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB03FC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86ACA20707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 06:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ih8sFGgs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgHaGKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:10:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGKB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:10:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5rXL5018908;
        Mon, 31 Aug 2020 06:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fltcJ1UcU4+dPhhAkmcuxKKsIcGRqWQ0lHD3nuHMCTo=;
 b=Ih8sFGgsMZJCdT33fi4kkGRGIIUhXpscGsHWPU0Ru8W02pyvBD1KfY0AJzaJTsbxdk6E
 dHVXqhpyvKbU65ZN2LodcywooYa5yeGTxjOdA8iF1O/KZAyWH0Xyh9PSIupdd78CjQY7
 nmOU8pJ1AQBTd3iH4qt4a2xJcDhUnDfRL5D1r9Hg1jFF6ijClNjSL/Su0rOKE+mPtk+L
 WCR8wP0YiyiIDqFUKXUgvFsLreoUX6uckP5+hMBlpj11+79qm1aDmg0LfVIP5O3/At1H
 PFfKPCmuwNrMlTyFLIQJnFSgweerKEcfhDsD0K1n5r8P3+dJZex8oSvDJQNiYG37pC+B Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhbdad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:07:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5t83R021686;
        Mon, 31 Aug 2020 06:07:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kk6vhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:07:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07V67nSb005115;
        Mon, 31 Aug 2020 06:07:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:07:49 -0700
Subject: [PATCH 10/11] xfs: trace timestamp limits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:07:52 -0700
Message-ID: <159885407279.3608006.14001785784663274058.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of tracepoints so that we can check the timestamp limits
being set on inodes and quotas.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_qm.c    |    2 ++
 fs/xfs/xfs_super.c |    1 +
 fs/xfs/xfs_trace.h |   26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 259588a4227d..3f82e0c92c2d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -670,6 +670,8 @@ xfs_qm_init_quotainfo(
 		qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
 		qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
 	}
+	trace_xfs_quota_expiry_range(mp, qinf->qi_expiry_min,
+			qinf->qi_expiry_max);
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 58be2220ae05..8230c902a813 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1491,6 +1491,7 @@ xfs_fc_fill_super(
 		sb->s_time_min = XFS_LEGACY_TIME_MIN;
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
+	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
 	sb->s_iflags |= SB_I_CGROUPWB;
 
 	set_posix_acl_flag(sb);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index abb1d859f226..a3a35a2d8ed9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3844,6 +3844,32 @@ TRACE_EVENT(xfs_btree_bload_block,
 		  __entry->nr_records)
 )
 
+DECLARE_EVENT_CLASS(xfs_timestamp_range_class,
+	TP_PROTO(struct xfs_mount *mp, time64_t min, time64_t max),
+	TP_ARGS(mp, min, max),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(long long, min)
+		__field(long long, max)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->min = min;
+		__entry->max = max;
+	),
+	TP_printk("dev %d:%d min %lld max %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->min,
+		  __entry->max)
+)
+
+#define DEFINE_TIMESTAMP_RANGE_EVENT(name) \
+DEFINE_EVENT(xfs_timestamp_range_class, name, \
+	TP_PROTO(struct xfs_mount *mp, long long min, long long max), \
+	TP_ARGS(mp, min, max))
+DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
+DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

