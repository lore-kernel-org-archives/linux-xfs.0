Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9127CC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FCCB20866
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MtocGqPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgIBC76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:59:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBC7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:59:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822tDdg124970;
        Wed, 2 Sep 2020 02:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fL8wUvKuhAv9AfP2AFWw/HQW+KazjCx3ahpL5ryvJGo=;
 b=MtocGqPADfhCgzXj/2pSKQq4v7Nn/IL01N5cdiPCPJTwslYcIF3UHmI2cw8JwMRMenJh
 wOeOUlY83/ai8EwEF2NPD3Q4c3msO5uDswRonZ+FGoPtGAK8HKb0/ZXi/4R+ZdXlYrIT
 eKT6ufS1QIeWrI3PRTYnp+1ygm78MFBzeY46/sRSKAXYZxZOPD8VAHUQUaIgBZVPA1PK
 WNT6WCH+8ySFkHCy+1Z716EpTczOJctOzMun6jTk7+fXQb61XAyi4zZaHjpjOlXvkjhV
 yl8Lw4QiAOwZJQKw2KRKmfoIU/1QCuHBpZOGEu8BY7sYRErR1rChi2MXBmVN9wktgr9A Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 339dmmxa7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:57:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822thDv177228;
        Wed, 2 Sep 2020 02:57:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3380xxr0f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:57:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822veUV005138;
        Wed, 2 Sep 2020 02:57:40 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:57:40 -0700
Subject: [PATCH 10/11] xfs: trace timestamp limits
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Date:   Tue, 01 Sep 2020 19:57:38 -0700
Message-ID: <159901545812.548109.17681490755116905605.stgit@magnolia>
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
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
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
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

