Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A24C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiAXF13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39268 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240871AbiAXF1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:25 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NJY1QA007840
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=TqUq58udoq0B8Cklo13ow1wxk7sTRt+eoSm36ysfozmyQZvFLZCQPrQIEjpLINF0u5s6
 3Jd0gAdjERi0noUqO2oEXQx6SwUb7JY9xHv2hNnYTnlB3EvpqoGrHEvWcSJZcgLFdaRW
 4vthD0OlfracXvKbn5gcggmjmh3NM3TvdwhBmFV5W0A1I1dm/UuZrDA+Y9njU9M9NlG1
 sL8NmAO4wpf9DyYfWd3e1IYX3bChLmklf5elhIOxGii3vHbKLO7GcRUzHCyl+EYWnLFg
 9qC/oVZoF+oNkHuqv0HIEKBVb4AJGzTeVoK8yS/DMBOaCsNbD50VIlXEM+1x0ARQ2rip OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8bdk30c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5REW9139905
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3dr7yd4xn2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJf9rBkGJ/eBMheYrcEoGSVc4cRt9MGGjKeN/5ADOPErImrcpBf/T/n0TOyBG5EygLyLNP+ZD1rsWGHDMIXc6TQMx/AzLkI6lcSA3HPgWYrop4ga6pcdJ183SVk6H4l02p3kdtUCd66ZcLnprzxAkH8fD05ahpTKhqbyd4auEYb6OxB+FotX4hRsTb6vzI3hKJJhCkR/vnEj+z6YOhCBc3xwrJTEGelsvP/O3ZW52/eBHUBQS+1Oj/xqF/BbDdvvSEr4iPCmJ+I1p3yaFvMs8JCBbxl1yUXUp9NV+QX9zxJWRzc7UEoK6ZSmcRzEN7co4psqej4XNEQVHqvI/FRMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=lUUv+vyM+1QJDhiAXpLA6J8+B2Fwl/RC7ayxYX+nxy8MhHshVRWWG/Zk6ChlIdLhSGqQani1Af5cU+ct8MrzprljBR1ii04FTc2rr30KOq1psrV7sat7O7TmpMMKeiPM05Ns6Vkq4/owYjJ9yRdLPSmgaMFyR/QEpLBVnZRgDsWdZWaGqPj1b5f+Ov02QCTnG1/zTg0Jh8Bh575d6QiKBGNtaDFnKfsR//C1wFdY/UPLb6EXQyPxV82SZZiWVD1ct6x0hMv+ccZxw32Y33r+N+r6EGOdPVgE2Bp5pYiuzzPv4XAnaDWElwksBqaUdM0P7wc1+bE3eyERAf/gVS7xeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CKt3Kwzn19dUSRfAM8d8zKP6m2jL9pOOdLbeTl0s6g=;
 b=gv94+12mjN7TL8J5XtbZ5aSGDyg2Lk8N4G2Qy4Tb24Fdp5Si/wWOPhcmLJSaQ6/kPoRPKXLVpYC1MpFvuLAtB2q+8ZnkliycjaLQipEsGPKunTimtybrG1khOyP/x9glXxCRjFkJeSGU0wp2QISFR4s1UemAWUM3Wbta6ZTU7/8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 05:27:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 10/12] xfs: Add larp debug option
Date:   Sun, 23 Jan 2022 22:27:06 -0700
Message-Id: <20220124052708.580016-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff4701d8-f16b-4d6a-77fc-08d9defa3090
X-MS-TrafficTypeDiagnostic: BN0PR10MB4821:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB4821E6997B6B2DE1F3DC5330955E9@BN0PR10MB4821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iv9KBYE4wzb/PVBWoZI9puWk9BWUB4FPkeVJAu6Oi6HAL4DBVF34Cigyg+S1+pWQUm/TohzUx/5p/4JZsaPjX1Wm2Mq3s0YfpfbKv67D+fw9qicqTE1zU+PwsDJcTMq3WTB9AKTXa6crXiHshgvfi9sUPSU+ZLXYaPTDIZZVlXxycH5tpm+GC05y4UXvgQRnfle2WbSDomwOggeub4KGgplBx6ID9v3r2gAaohGmu0nVZxFlGhyJ7NDNTyyQAQyJefFId5krKwoa6aYBx6o+tT1Lj1gqAjRd/2V+eo35Cvjt1kaL7eStEvM2w61X3Df5jTZWjVESvp4ixMr9/Svt4T7Np6MxmpTNyqBo7/Xe95eYI5SgBLPoB7cVr/+Mb5GqmStn1dxl4YQneM0rB8ZFC+VWGxbBWJxFWusKsBP7YAyE9cuNXOl9Is78dZtW6UWR5ubmrVgQ5H4lo5mC0C5+ddkkLWs5/VtWtYExu2WcyMKJMKMdkqvm199TA+7xy2UllLIbksjr8cUXmgbXs1v5PfZB/u9ihDUe8HVanctetvfUB9I5+wvSwjUrheTupfGqHx0M0gYN8vp3BwZDddsD+sUH1vnFsdzs13IxYYyD1czoAfarvc0zohNB6JUxxCWmvisgfAcHdVjvVJ/ZPJ4SKyXaUC0BcmsBtEicRNnHBnPNij0KmXADxNNx65ewLFmTHPnsz8VZdnK5i6gWEfT3/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(186003)(6666004)(52116002)(6512007)(2616005)(83380400001)(66946007)(66476007)(66556008)(38100700002)(5660300002)(26005)(2906002)(36756003)(86362001)(6486002)(1076003)(38350700002)(316002)(44832011)(508600001)(6506007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HH+xvCO6G8YRVAilDjR3Tl/g/kFdpPfjr+w8/KSrHzbyBH3pen7gzIRDhP9v?=
 =?us-ascii?Q?mAfWQuOruLqXo4E0ytxpzjJ2f8s5voFx9SDaAxCokyAArA5Lhmri/7AEMK77?=
 =?us-ascii?Q?v76Jo/ERnhuofIt8OCoPvE7HYsDFrRbPxVTw81TbBsFmRe+IAmawYi3ubj9b?=
 =?us-ascii?Q?5z6QXQMy2LaC9O7EuMi67hxSPKFY9HlvZPvpWqe1Jp0JRgZfbh7vf5fChZwg?=
 =?us-ascii?Q?8qSk1K7IpSvoGkKl7Stb14lFtna/fKIIwc0MJc0mJkP1TJhF+omPVlF2ETv4?=
 =?us-ascii?Q?/7aPF5wWqvd2uftp46pQni6hkMUkIjWvYg8VfFd29E98T86rTEgfkHFM7eGR?=
 =?us-ascii?Q?s+5x8Yuvpsx8u2jeFrL/1sqQgrCF8oQoQk7Q+hVxDN+XJpRiJBpZTRMMLc8y?=
 =?us-ascii?Q?DBZvFXizTcqWkPFRGsMomM3wpRA5l1GqrwefPHtNXxmq71p8guLY7anCP/WH?=
 =?us-ascii?Q?4LWnRuHFO2GNcAbtKhLYcV9YLmWRD7UkxOQK3Gx7ehBwOw2JE9rbEB8AzWM1?=
 =?us-ascii?Q?PLEZjN+GihUq5GuPtzoUigFe55miS6xMnOB0DcEO1K3G9XeKXU+sLGNucb8w?=
 =?us-ascii?Q?CSuulEo8WbOr/OVUIjFYEuXnPdrt5HB+IHPYfRfIT4WudGYgzznciB28zc9W?=
 =?us-ascii?Q?E4/5H7rLsR7nwSWLbupM/rQkcxLkJK7stWUVz1zdaQ6nfWtRFgs+2FuBOHyd?=
 =?us-ascii?Q?pEY+3V69tdTnQC8keDB4HxFepSuzjgqdGo0leN7X6PODekO0clUpMisJHykv?=
 =?us-ascii?Q?Z3zcbIKM6E5jT/enZfB0MYAxCLEjetZVHeqHWLknhUVDfbncJuw+I5ISF1E4?=
 =?us-ascii?Q?+XoCqCIFNTcIYXit5yOOwuqmqbgkxliO1oKfxNvJQTDm5VOb4pV39eLRS9Cg?=
 =?us-ascii?Q?DAyiXxe1A8h4cWuRQvdo3L50yaKvbOXPwN+HiHJ+HCEMeniA69ypYp15BEp7?=
 =?us-ascii?Q?tFg6F+AFeqbZhNaVIRzncn2qHwws11jNpUDzpjQ53XN4hKGxK22Ff+mko+JK?=
 =?us-ascii?Q?4KIKHxEi1OrbZAg8SeCARKPiDhD/JTg3309j+QS4CyeA0zMHBBUKHgWpYLrl?=
 =?us-ascii?Q?HvuRMwJXbUTH9UYRK4SPQ26gm6HpaCVqKlpsAwkcdh6zNwCWLsOKLB69iF5d?=
 =?us-ascii?Q?knLLcMeoJcG2mVsHjHveI8wpolxhBM9/RCB7/iGmvGMGy/AK2RBqGQrtguQU?=
 =?us-ascii?Q?Q6lPB4u3PrkGOcljDEfksJW2+JMokk8ng6rSyXKgSwKhLuhIuM08qgL3l0k6?=
 =?us-ascii?Q?8o3dq70YGoPSBZHDiSlHJR2DWNTH3IDvY1ZorWL68xXsPg9oTV2wR7z7O09c?=
 =?us-ascii?Q?WkQD4rmW33MHaq4Z4pptPbu/71AfI+SggZZhUXSul44yJInhfm00x/544GMA?=
 =?us-ascii?Q?pGOTWQ3BYO+n5jnNFARMT0kJTvGLvU6RMtQ7hCXuTKh+f3lqQBx+h3zTAcEB?=
 =?us-ascii?Q?242dGi1wZpTfJKZQgTRIPaMbBRqlXF7mC1Ko+3QVC719aTopVi9QpX2p86Py?=
 =?us-ascii?Q?1j25ceTfgR/M4eaGQAJpIXmzb0VDTFsibzqSO+ut4xhPt5Jz+LfuCFIOKXQr?=
 =?us-ascii?Q?FZN65RwdpPuES0gG/bPag1LYaiUC1SsFCIiBWv9dQRsSsAms2JxTdx5oQxmO?=
 =?us-ascii?Q?9C/mXt7V7ohBhSd6KNuFVF9RTOzrzQ+kp08cJzINmtg0UyKBOlma6tO0FXPx?=
 =?us-ascii?Q?nWSD8Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4701d8-f16b-4d6a-77fc-08d9defa3090
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:18.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sicTmO8w6gX3fuQ8H6dAxzLfmKDeoRKySnUdxmOBnAmVfojz0Uw3UlNYjajjXY7G9aELfhyV3Z4W0GGaWDql5088p3ok14iy4d3gj0pwwfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: xDjqWn0r99y5PVPGpzmfh5w3UrR5X7do
X-Proofpoint-GUID: xDjqWn0r99y5PVPGpzmfh5w3UrR5X7do
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

