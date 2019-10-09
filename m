Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA03ECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA17F21848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FGsELX0K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbfJIQt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:49:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIQt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:49:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99Gjcr0003549
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=hQ+lKnTERpzIcIBS1QXBXMC5jywWBD9kib2Ub0diBXY=;
 b=FGsELX0KKGcMcePHbJPcI31Q6QkXcyfHYOcJ+/rrvB+ndxomjDULJ04zE8RYKNed+6y0
 p0A/IbJCdMwPOVBTS65it4WEXug7ZNsjtaX9hWLme75gPx32v0yq+jitsAVPuBnUWFFc
 W8GDQIRAH0amxZ0R00sD5Jpvg9PYuZE524ORJksjNKtQ4g04dbpppfthF1BqqC6OlwPe
 Chr9ZCNTrIkYAqOy1gycKqKMxHQKa3X838JQaCaimP9ysKarzZk3OiwDXZiMxc0KkADr
 AmG/A+RQqOwu41j3qVyiqEUv0YlmY0kaX3AfryeUcmJEjkbt7JcynoDDhyyQ4Wy9o1Y7 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4qnyw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjWgi054889
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vh5cb20jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:49:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GnsmH027856
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:49:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:49:54 -0700
Subject: [PATCH 1/3] xfs: add debug knobs to control btree bulk load slack
 factors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:49:53 -0700
Message-ID: <157063979364.2914891.5142110960507331172.stgit@magnolia>
In-Reply-To: <157063978750.2914891.14339604572380248276.stgit@magnolia>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some debug knobs so that we can control the leaf and node block
slack when rebuilding btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_globals.c |    6 ++++++
 fs/xfs/xfs_sysctl.h  |    2 ++
 fs/xfs/xfs_sysfs.c   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)


diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index fa55ab8b8d80..8f67027c144b 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -43,4 +43,10 @@ struct xfs_globals xfs_globals = {
 #ifdef DEBUG
 	.pwork_threads		=	-1,	/* automatic thread detection */
 #endif
+
+	/* Bulk load new btree leaf blocks to 75% full. */
+	.bload_leaf_slack	=	-1,
+
+	/* Bulk load new btree node blocks to 75% full. */
+	.bload_node_slack	=	-1,
 };
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 8abf4640f1d5..aecccceee4ca 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -85,6 +85,8 @@ struct xfs_globals {
 #ifdef DEBUG
 	int	pwork_threads;		/* parallel workqueue threads */
 #endif
+	int	bload_leaf_slack;	/* btree bulk load leaf slack */
+	int	bload_node_slack;	/* btree bulk load node slack */
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f1bc88f4367c..673ad21a9585 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -228,6 +228,58 @@ pwork_threads_show(
 XFS_SYSFS_ATTR_RW(pwork_threads);
 #endif /* DEBUG */
 
+STATIC ssize_t
+bload_leaf_slack_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	xfs_globals.bload_leaf_slack = val;
+	return count;
+}
+
+STATIC ssize_t
+bload_leaf_slack_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_leaf_slack);
+}
+XFS_SYSFS_ATTR_RW(bload_leaf_slack);
+
+STATIC ssize_t
+bload_node_slack_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	xfs_globals.bload_node_slack = val;
+	return count;
+}
+
+STATIC ssize_t
+bload_node_slack_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bload_node_slack);
+}
+XFS_SYSFS_ATTR_RW(bload_node_slack);
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
@@ -236,6 +288,8 @@ static struct attribute *xfs_dbg_attrs[] = {
 #ifdef DEBUG
 	ATTR_LIST(pwork_threads),
 #endif
+	ATTR_LIST(bload_leaf_slack),
+	ATTR_LIST(bload_node_slack),
 	NULL,
 };
 

