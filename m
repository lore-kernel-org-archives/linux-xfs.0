Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F976C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiBPBhq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245525AbiBPBho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563F819C28
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:33 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMpU3e008678
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=ooL3kR91MFSLHezAL6PQj4sBpEvCrRKSG0MAxP3URu6CKndsNkQNcHGs81LrjXXwAQkY
 qjLxRWZRSR2OXoF6zkQrLC4H67E+61fykgMIULF1omvMkpOxcHBpDGPfI2N8kLYhgM3t
 fnokrdrbUYG4nNV0I4Fpg50x2J4Vbjj35u6tzV4g5Bp9ZXOZpZQipqJqNB93PvJcUaJ7
 o5fzst/yol5K5inr9lNz45QwNTAzb97Q9DpdkcSvUgG77NOWZgLeww1aPdJQt9QUXAqz
 qdJxdn19X19jB6qpIdu3FRhPcffeRkfBHcjOIP+h7kuWoCFKO/gVJdwqHq1yIs++EGwO WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3g7ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G1UZxQ165528
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 3e8n4tuxvp-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 01:37:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k59I4RXr3TQgXvPIMc/mdnzGK9a3DEnjqv787lh4trICkNSFMjmb3tcB/iUrpoSPkFuvGL6Fv+k3Xbeuu7D1i7E2pOYKpRmxhC9SAqhYd9ojTAtWxJJYewU1lNAfqE4ZHnnM7f5iFN9zHeNd8rvdxwOdiQRDsv9gKKP9kMECVYH+RZSi+MbESxJYZBHSZGkhLgWQ6wTSwKijNizSXZYwIESGEigSnuZ10B1hgFDGd/TcsVFf4Y6REuEdzvvxqikjw+qyng59e6u7q2i2yEhDCRBXTYiCCcwUU7fZRTPi4UuJ20gE14DwIONLgMNl7L3h4mOjeta4ihsX7e7aiP0ykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=aXUsIhKGiVT5wgg8a98hYz0hxyNrmJE8s2d3h/lkXkRsUmV0MhByTHDb4ytBjxC5OMcRfr4pp69vV/3RlG15bSnUkbQ9Rc8ONc1XMS5kaH4/sMHNb1TW1L6kwY3xGjZKRo51Vv96UmVE1CMXVcKpwMmOboC2mHKHJMtJLVV1UQTdLEmBJgyIcKu3sxmbeFoIHJ87ZHnXO9ZODPq2xCNK14UWZc16OlSWF5E1TbGg10xAyVwVjYmg5dkNZtUj0Z5J/dGlzCyXzCNKP+Rpa1U854Ic6hNy1EwXk1OX/ft01WGWrKhAgzK05Hnr/xcHOouRsMVpBOWGlAFBZKGpw/W4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=uIiY8P3r50ksmX3GvQqyHkcO0zbfslee93F4u0pIkjLRsQyLq+1smBtxtdr/6T0kIlNntV6oW5rF9yDFDVr3pGrH4PwO4ciWiDpCQ+6JvAa+PBOaYheGwFy9LVLmBPegTQ+kz5xIvzt6ggDonNERmbJOf/CZA+7z4++O/8GAAmU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 01:37:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 01:37:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v27 10/15] xfs: Add larp debug option
Date:   Tue, 15 Feb 2022 18:37:08 -0700
Message-Id: <20220216013713.1191082-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216013713.1191082-1-allison.henderson@oracle.com>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aac39917-990d-444f-d205-08d9f0ece177
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802A4B261CB23181A2430E195359@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C48PAXBNHic4yb9opdjQsk0U0/nJD1YeNBDOpWWjEFt+PQizys6GKcLO33gMl+5g2gVnuKfDBuwFAaN39VzKe6leB5JN5TJ2kgyMgS5/rpXhzqcx6VSH9/rYW/P+8EXF3ihaqbCud8mpqFidF4zaaFdnA+8NziTNm8roLVTggcXP4AFU5oNn8xccsCPComKnqYAGQHWfVWg3hCJUweENi2S5P/wbCPAxF/k/Bv4RlGmIsU+Qwa7o2P9BbegltkjJvH90kv6GeJ9S2zFXXPjYRfqVSTEKgyaRq4KKRR8RpuX8yueNxqYYPU8NBKXSdSbzMIaXGw0vPwygeVkRx9LtPsS3qgwsz3t9ze8uGYBDFdli6VdsyM1jLltoDXKS7vYK4WVpSGrETKwDWTzAT0IsQ4+9ROg1LeTpJ7LqN/c2ddYHWqMrTGm8JmUubNb0vdKZaLzhoOriFbXNfWj2XwNGMIWJhOGv647M0FV9eq775IYOcAQYsblUd2s9WaBnsQLOBjU3UjSgnFdD4kmIoN8AgPIv/ERyAZ6daovwPxWqqrsqkd1SKpJhehlW1FVK4vqyhN2HY61JqFN3rUmoUqdTIgOv3QnT4PLiyxTUdprhtit0mERvYFg5gdHHRB8Rwkbq+5+cFRlep0TFSvV7EJXvtZANaEaL1rjrm+aMb1QYD4xKdgoP7jyUdAm4RgZdej9vTf8v/zLUQBFdq/ghUasToA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(26005)(1076003)(6512007)(508600001)(2616005)(6666004)(66946007)(5660300002)(44832011)(38350700002)(38100700002)(6916009)(6486002)(66476007)(52116002)(36756003)(316002)(8936002)(86362001)(2906002)(8676002)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erJZCgHQ66nEXbK1uNBJ8vOwu3VYt/vO81LmKIG6ZWSimE5Z/sY4taPzEv1E?=
 =?us-ascii?Q?xWa0+vYROrzFwdH1Q3SQumOMJ9PZz97saY1tqralaqyc2VAMrj/IASy5tpPt?=
 =?us-ascii?Q?kmzEzHNKHWlwA/JEBoadEJAmvZtwFaeEc71tn+X+HGrXc/4IThWWafBVVY+E?=
 =?us-ascii?Q?uNwny8tI3eJguuJroJKcxaZLeEJi0WfBZXyLQVeBGd1tQmhcisduIoYqup8F?=
 =?us-ascii?Q?LmxqaMuhQgUAlTuxz+Izkg3mR1A8RDmiKEQsF0qqIORGkMDZQiTpsZD0G2n8?=
 =?us-ascii?Q?giBKa8NxN1FPj8XPyY1UQTlhKEpZP+FMKjDRV3rrp9399/oUwpM/nE/Hkh6D?=
 =?us-ascii?Q?GFHgu12waEU8Deu0+7BAoEyzQ1gj4lK49yMsGjX8Gk4WA5V+VJA6LlYJXsUf?=
 =?us-ascii?Q?dWEW/KS/sFmWr8JEcxIg+d7q9giGqFjbO36AH4RrQ9ZPZd6FnOVG7zCi8WE7?=
 =?us-ascii?Q?hjQ9lzqCI51rNECEHlHEb7o6+pbrFfNFW9PnDUdQgYHBv8MHH1LMF23MnrzJ?=
 =?us-ascii?Q?CfdUZO1VUt4gpTs1N03YuTqtosWvkOLc19rEHGF4AtrnwjO3WS81AGvYyg1j?=
 =?us-ascii?Q?FNkJUzB66uemNK6QvnindbRhfT0PTrzOxybNyZtBAcz4k5SYLmj+U1+OGSzj?=
 =?us-ascii?Q?DAZ5WKDHlqWf8heqau6Wyqo8QonfFJlUx0XhFimMTGFlEskf0S0fOiL7Ev3j?=
 =?us-ascii?Q?PqyR2BEst/YPoKYU18W3wVTCn0MFmhlLwZE/XjJLes6fAy+HB1mLKc0vYse+?=
 =?us-ascii?Q?MAMt1XbmHfu9Vhhy80mGhMQc8+StnEDoyNDE/wtAuVK6BtcsWK3qLT7o9AOJ?=
 =?us-ascii?Q?xKwIrVemqVuXT9aDAXO8rEWxp3RcompNFaTKgrJam/0P1JKgS1QOTa7Md43V?=
 =?us-ascii?Q?JcgTSNeaHHvmciFaU2ukQUicF8R0Vc/9ZE8qiHaDbJY6lsu9DFXPuWFIW1Dw?=
 =?us-ascii?Q?ALWyitnD4qmbrzT4srPKRFnEPJQSkbZZ5rxqVLe6vM53sv2G02Kwg3kKRtZW?=
 =?us-ascii?Q?MdKen5vBfsGGEJNKhi7VgEU+wGgXDPOjarecqGSAy/eb2XVv6GEpybNrZwLB?=
 =?us-ascii?Q?u2UodvOt74V7m8FkUy/BM8Sp2WKfHZMJULY/c3zWxg5JSD0b/HV73/ZMNwzn?=
 =?us-ascii?Q?32n0howu6lqVdcrhUmSNyLRhAN47weIVk+HHPfZd7RNgrQXl8jThhZJWBsXC?=
 =?us-ascii?Q?a9wrD+/ieKuDJ9jsW5v2jyt4LAfKYqMihEf6uJnVCGpyBcUttfo2Kq7QH8oB?=
 =?us-ascii?Q?hfp1E4hoT5egMlCw0UhVP0/4wg3S87WJuvVXEz7QD9frsGIo4B7b3a6Wn6hE?=
 =?us-ascii?Q?fouGsJ7zBFwkGvAQCRdlXIo6i3hZWrJjANpUjqedQ/dXXEMLcZGpHZCUIMtL?=
 =?us-ascii?Q?j6063yBNn8dY24Yv3/m5xKvH9FcIZnLXpcH6nifOrFyzK0kbfZWk1BJgQ1SL?=
 =?us-ascii?Q?JIWPSQMh5K/qFzL5ccSQW0ki4oQTw+Nd1QHJVwVcj31IUw4FBcHMZbX2kYoJ?=
 =?us-ascii?Q?8B4PraP8pJdn6F7XN3QzK2YsAq7kZfv3PhJfM1DvZ0bV1Qe2L22BbQb6U+ho?=
 =?us-ascii?Q?Wvw11rEsZyodBdrcAtJs5uTAZTBF3fOlA9FloFOy9+8Yi4GzfJMhDHA53mXX?=
 =?us-ascii?Q?0K4SSBjiKzs1kOxrX0CqqjWfiyRMgocu2H0WkNw/T/0IxTe01lMTZxE2Zy2I?=
 =?us-ascii?Q?hJmRkg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aac39917-990d-444f-d205-08d9f0ece177
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:37:23.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcAQP9OWT5U9uBtPPRnTwO/T6ar7u4DyU07jzTdIDrPhQCgW/ejxulRIKWKPK853oBkKrgBxKE5ybiB48go2spSDnvlqFUq+SvbjCbfXL/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160007
X-Proofpoint-GUID: k2-GcXHHiOK8gHL_1nSrtHA75-sFThoM
X-Proofpoint-ORIG-GUID: k2-GcXHHiOK8gHL_1nSrtHA75-sFThoM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a debug option to enable log attribute replay. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.h |  4 ++++
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5331551d5939..78884e826ca4 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,11 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_has_larp(struct xfs_mount *mp)
 {
+#ifdef DEBUG
+	return xfs_globals.larp;
+#else
 	return false;
+#endif
 }
 
 /*
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f62fa652c2fd..4d0a98f920ca 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
 #endif
 #ifdef DEBUG
 	.pwork_threads		=	-1,	/* automatic thread detection */
+	.larp			=	false,	/* log attribute replay */
 #endif
 };
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 7692e76ead33..f78ad6b10ea5 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
 struct xfs_globals {
 #ifdef DEBUG
 	int	pwork_threads;		/* parallel workqueue threads */
+	bool	larp;			/* log attribute replay */
 #endif
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 574b80c29fe1..f7faf6e70d7f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -228,6 +228,29 @@ pwork_threads_show(
 	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
+
+static ssize_t
+larp_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	ssize_t		ret;
+
+	ret = kstrtobool(buf, &xfs_globals.larp);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+STATIC ssize_t
+larp_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
+}
+XFS_SYSFS_ATTR_RW(larp);
 #endif /* DEBUG */
 
 static struct attribute *xfs_dbg_attrs[] = {
@@ -237,6 +260,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(always_cow),
 #ifdef DEBUG
 	ATTR_LIST(pwork_threads),
+	ATTR_LIST(larp),
 #endif
 	NULL,
 };
-- 
2.25.1

