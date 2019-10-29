Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA2ECA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E76720659
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qRLzHNrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfJ2Xbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xbm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNTvTR038733
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9CGuBjr3UAsfokoR+PiLn/VXRGOf+cvF0NEqQmKbw2k=;
 b=qRLzHNrEt1sqddHJUmW72vG5UxcyMSeC8UUk/VCYOJXwJ1WyguVlQmlffU/vGW/jSAyT
 YRYnWdf36T+vM8MCDBZC116JO+YAD0a6w821nWUFZ6dx18vdto0psjWGS64I58awiT0w
 71rEjZFTAf47QXU31lDfB2qy8X1NS2uorw99NDOIB4BWQqDRuacYUG4fG/N1Oi+J/LT/
 59d5A10Y91wN168+1GAHTMZEFchyhmeA0q9mKHJzgI6nuHqKaBFpbeVRYK4qxwOWXQr5
 qjBhn7KYHAq0w5G+ZhL9HdebBtm9hrK7QzS/W3a3qUmHtKVPPEZmdP83oI6YTxMPGihI MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSFPf039088
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vxwj8v13t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:40 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNVcP4007173
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:38 -0700
Subject: [PATCH 2/3] xfs: add debug knobs to control btree bulk load slack
 factors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:37 -0700
Message-ID: <157239189794.1267186.12862100367979112764.stgit@magnolia>
In-Reply-To: <157239188567.1267186.13893450077789311842.stgit@magnolia>
References: <157239188567.1267186.13893450077789311842.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some debug knobs so that we can control the leaf and node block
slack when rebuilding btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   10 ++++++---
 fs/xfs/xfs_globals.c  |   12 +++++++++++
 fs/xfs/xfs_sysctl.h   |    2 ++
 fs/xfs/xfs_sysfs.c    |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f1aba01aba9d..c38ff20b8fa9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -639,9 +639,13 @@ xrep_bload_estimate_slack(
 	uint64_t		free;
 	uint64_t		sz;
 
-	/* Let the btree code compute the default slack values. */
-	bload->leaf_slack = -1;
-	bload->node_slack = -1;
+	/*
+	 * The xfs_globals values are set to -1 (i.e. take the bload defaults)
+	 * unless someone has set them otherwise, so we just pull the values
+	 * here.
+	 */
+	bload->leaf_slack = xfs_globals.bload_leaf_slack;
+	bload->node_slack = xfs_globals.bload_node_slack;
 
 	if (sc->ops->type == ST_PERAG) {
 		free = sc->sa.pag->pagf_freeblks;
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index fa55ab8b8d80..4e747384ad26 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -43,4 +43,16 @@ struct xfs_globals xfs_globals = {
 #ifdef DEBUG
 	.pwork_threads		=	-1,	/* automatic thread detection */
 #endif
+
+	/*
+	 * Leave this many record slots empty when bulk loading btrees.  By
+	 * default we load new btree leaf blocks 75% full.
+	 */
+	.bload_leaf_slack	=	-1,
+
+	/*
+	 * Leave this many key/ptr slots empty when bulk loading btrees.  By
+	 * default we load new btree node blocks 75% full.
+	 */
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
 

