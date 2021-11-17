Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345FFC43219
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C706608FE
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhKQEQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:16:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48914 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233006AbhKQEQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:16:55 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH2dGuA030703
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=m+pWZv4dcmPUXPWxtyt+HDdPKvQ2PCfFk9aZFr/hUvc=;
 b=LCdQS3jIUyW6EvgDUxT+HgYyFo/TAUofrOE4hlBcsrmmSyOUop4GnveY0yh3EIyU5C30
 tNte4+jkyHHcXc0JvGyrYrvOcbNfNO89VPqBbJ+JM4MGTjd1bg+YqSepUr5NwqPAWN5U
 xJSdJnRChECdhdWq34YKVAQZrKLR+Y52BzsoGcyycRAGnmhfS/CYIgZWF0lIl2kO2sdk
 AXfea1psNwD9mgcLhrBfXl54bHQE6aLENmxIdOcT8nOnlDK3J73JhtFxiniyziKBQUyN
 0eLbMpPK9+XpZdPa1fDNj9ZaqBz9LQJP+SeAHZz/ywdNfM6wJ8W5okCG2fO+60vnPJJE wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3e5ba1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4AEJa180636
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3ca2fx68vt-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:13:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTtc7DeDOeiKU/Pm2vN3k1gDgtM8HoqyWNjruPcpiQaesqElYJpv0h3+mAlyWrgziPyOR2alc2T73ezRD0qMDb3G67CSvyMURMJHNZ+lUM/uvb/uRkfDyCQgYy2nnKc7B9IYc4G7pc8i51GIwZXLZnjGGe9yMfxSva+97HhnsFdRsjKkXTPjZp+UB3CCkV4wOkVE0pOnAurQsvkNv+BmuIJbl2eONpRMXfu4h6Fr2bny0gETEEEdcUge4nmP1D3odLWi7Kw94FfbVG6NbKYNv5tsOmDdCkZs5w38R0V87a0mA+fcZwxuILVyA7ObAOwrOmZv+sWgmEg28X2VYuXUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+pWZv4dcmPUXPWxtyt+HDdPKvQ2PCfFk9aZFr/hUvc=;
 b=nHGHVJSOHCv4wa9xPTxhLxizQyMNBfgHRhoAv+8wq5UonFZ0qhhtb0wb4RpuUfLw0Hje4x8fMlss24KA3SzjQdgUpmXYZ2PzQ4Eds24QzRGsARhz2XHki+FrXld6BpGj77jkymuGyT3pb4YQN3pwz0AydAcjuMgsd+Wh7pXi+LRrvt60pr+iSPSFMbcqZSqShBqBzSJSflOuyWIVqy5dxuYCjJALtoH6KoO8IL8ckA36IEXeRGwXpM0koDQ2zWiWGzjiB1FotUKy/sQzdsJavwQf4wKTWmA1yc/i/zQZoHq0xlWTKT+vsjM6Z5KBhKzRtkQq64slcrLdlJniuEsb0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+pWZv4dcmPUXPWxtyt+HDdPKvQ2PCfFk9aZFr/hUvc=;
 b=gOXQtB/sUlH40ITchwi6LcLEG6vWJXaqAyixQ3cBpO0TxpgFBv3QhwhJAOhRgsIO5BBi2Ahzd4yIrH1DaHNxmKBgw9/X9nHGJFi2gVg192z2le6V1RhL+lsDeE6dvtxcE1cPttppuhPziv/P8YHr1/ZJZJvX45PHS+ZCBBeDGaA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:13:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:13:52 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 10/12] xfs: Add larp debug option
Date:   Tue, 16 Nov 2021 21:13:41 -0700
Message-Id: <20211117041343.3050202-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041343.3050202-1-allison.henderson@oracle.com>
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY5PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:1d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Wed, 17 Nov 2021 04:13:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 463e122b-8ba5-49a0-8127-08d9a980a9be
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39212156993A2168AC72672A959A9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OIo1K1lv4YGp0X8cexhcScguKA8wdpv6+Hr3khRI45kyRtu6QsFIlTT8cNWQ6yeMQvF1LHl3+NxNDk/r8Gn7gd0vHUnFnCpjuimmMkLhRd2ItCO5ElhuN6XAdd0cn+iF5DqyVwLNNwOH6hy3M8gU/IrCTfHX0Q42YG+G06HVBIoMEdkilB5JGYTF4DL+oe01lKMLyBhf4jU1wQd0cKzH6y5bIFzgJeqNtK7FYsGFU1hpCgCMvRLW1CEzQLXHRnakaGleqf6aYg0j3MUYnyb1RdhwkrMrouYWFdt7LwgQ5LoqlGPAB88HjR/67+o99tajXcsibAy45FtITvpq5aBcxeVw0kPa9nxU3HM2gILH/2y61fjGwQcSrD2vSoKh9yFwYXyyZOC4s/t9dR3JhVSkz1c4FzLkpIz6J0qlOz3aEWNbKRJMNUCD/jQqwp8WSqpPznwTWLKRL1YnQEy0KjT39XDoUyiZjSez3NgtK5SD2xAxHKrRvrEAjwMrNPyUTvgWK8HeFrwkF1Shm9XToZBb4pNJf71OMImHrkGsD4k0rKtNQgv2stcpeA2doQGUE4Mtpt6KGAgKvTkcKCYvPM/vDHk3x2L7eqq2qXPv6qU8NNlgpN4L4JHHlUDtakiCzeLcyXu2+wzpaPWRP0q5bPyMN+0Se0NyLiOTFl94gz7TbmDAufgd1ySAMiX3jVanfjlJ0GP71XG2Igy4FiOZQM6zOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(38350700002)(6506007)(2616005)(86362001)(6512007)(5660300002)(8676002)(2906002)(36756003)(83380400001)(508600001)(52116002)(186003)(66946007)(38100700002)(6486002)(316002)(6666004)(44832011)(66556008)(1076003)(66476007)(6916009)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R1fbCmopiBT0W61q++FMjAZ7ZNhgLL1uy1pczjAuhKJtrIpZ6CY7EPEXyb5a?=
 =?us-ascii?Q?EkVZlcuiKNPeqkZwXorkZJRCkR05tFr6a1ilr9fd1w4CaOd+l5m4k+VlICRz?=
 =?us-ascii?Q?sAS3AC/Sx9Y8zQe4PTsyGnPMSHL0sUkaC4Ae9k6DGqa7qZIbg19Q/c9xeaSH?=
 =?us-ascii?Q?31D27F6UF7PbEaQOEZ0I1IKVicCmTcHHGDMFqcpLyocCaTqsCwn5rafHmtsq?=
 =?us-ascii?Q?jpVpBnjaF7S3/YrsydFah5MZvwuzcfW8AkI8cmApNL7H6tm0G2ymhcQ1rFg6?=
 =?us-ascii?Q?RMBZ3eRQwBOOi/brvoLDPAHfpVocfBNbiLKvyGLFawQyO1rNnfqgkzddIbph?=
 =?us-ascii?Q?z7ED8sueDbcmo6m4ZDVFSh5YfOpROOJRKTxgAD2On44ZevjVFKRLspeLZdN0?=
 =?us-ascii?Q?MD0rthOq5nmvTUe9/CM7O3AlW35Z9hFNI9pRUdo8ijGwNmC8L76wXnHgcYa3?=
 =?us-ascii?Q?CMUWDp4XByCUqYDGupjpXFJ9k8jK5zx13PglbQ3a2rTidvibk9srxaLtUMnt?=
 =?us-ascii?Q?o256mak/iBOEGDA7VCYCVqgSVyVEr9M+bSmvsYZVB/wbgq1A1G2o6nGz2Sic?=
 =?us-ascii?Q?M9iTMq+0RNhJwEBH9kzUQ2/Up7CtWodWL/3kizaBn7BN3n4hU7xJamm7r8h2?=
 =?us-ascii?Q?JHq6MuzFsNAkOWiR/LMASEXBSL+4DFwBTtxNepVvCLmdKQFux2uJdyGasE6/?=
 =?us-ascii?Q?C0ETSDMWhAMVz0NQBI3jf/idL4sBbKJpjVr1uiTvEmemTAVxwa9rSN4Tp42W?=
 =?us-ascii?Q?4btFt5i1fYQ/yisE/i8P2jJBhs/niGqURQgeCNgcVVEaIHLzwzJN7xcTrZku?=
 =?us-ascii?Q?BmvPP5gdiMgH35WVHe65eaXAoL56HCWFVXu+XbPtzbgEvXuy8eTuvJje36k5?=
 =?us-ascii?Q?LHLUkdYrwTz7fPsdbd9K5xoklArPKRsM4Vl4epIBbCYXRtfIpQToYovnnnU1?=
 =?us-ascii?Q?wxLFbxs9WA/OL6TljGhIY+HluR9IXdFn3HVtm61ya/m1fBCYvyz1W2Y6+AGS?=
 =?us-ascii?Q?Coub4vijM9fvfbsk8UY2L+Zz7nilke/4388CB5LKNV63GGPW5hFTY/n2jfGF?=
 =?us-ascii?Q?BwHBOpWxxIlfEKyzJpAjXGNFiYjXq9I3UIO98T3mED2MSTzS/yZU71ppuwyW?=
 =?us-ascii?Q?2ENI/YUBkkTNfM3/seoV3jodc9rb5OjBbFfGvrbEpVUGcTZZf5h5Yc6CJQwV?=
 =?us-ascii?Q?REhjk9V9YJMDEfEfdzuCu8aOttxtgVwUtJr76nh99plazWaF6r+QRrAAE6VW?=
 =?us-ascii?Q?BYvrD4ETwPRkZY0goMdK6jvwGux9yLZWy7C2OGi+GzfXoEMtNJKEzQDjosen?=
 =?us-ascii?Q?wDiLpnSI5e4a/eehbqKg9RclnN6QpJhdloSp3ImxAsRSGRE7IMdGrtQJYmwQ?=
 =?us-ascii?Q?evwrfSZsSaaRrJBtnNVxXEqVjUIy4UfFJ9LsSAG6aF2MXytaDTWHNuOhACjp?=
 =?us-ascii?Q?bf3655S0/jdcGWvZFUbeBJ8+TKBBRv9g7ZVVx66NS4dsRXH7Br3HgWEuNcqj?=
 =?us-ascii?Q?gzq3i05hjKe/Clq4y+HMVnLO1B41TZy250q3j1jVh4biYFKYpqKWdod4Kyw2?=
 =?us-ascii?Q?h7VLgXO+reqYHEAkM5R9XmpQzXFFa3dClIptjfCGh1oG+SR36u5e/gb7RTnt?=
 =?us-ascii?Q?IRx83Ul5PCTBgr3v75nLrlCERbjMZLaZzMps1y4RArFVSkoRexDIYx3XT73l?=
 =?us-ascii?Q?DVCx7Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463e122b-8ba5-49a0-8127-08d9a980a9be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:13:52.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /PW+2Z8SZiUa5Npq0lHG2OXFajoxV6o2YM+SfNxDNPeVUZ4fPMI1l31ToVdhPvtBk1IX0ZoUqMt5pwoTqTW1qcuJbxrLwSYKXDQgZ+4bKpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-GUID: TiUXiZL3Ai4brOOTEEMYc23mvLG-OukG
X-Proofpoint-ORIG-GUID: TiUXiZL3Ai4brOOTEEMYc23mvLG-OukG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a debug option to enable log attribute replay. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.h |  4 ++++
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 977434f343a1..6f5a150565c7 100644
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
index 8608f804388f..02a0b55e26b3 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -227,6 +227,29 @@ pwork_threads_show(
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
@@ -236,6 +259,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(always_cow),
 #ifdef DEBUG
 	ATTR_LIST(pwork_threads),
+	ATTR_LIST(larp),
 #endif
 	NULL,
 };
-- 
2.25.1

