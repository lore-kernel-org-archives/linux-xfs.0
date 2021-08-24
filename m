Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A0CC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBD561265
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhHXWpk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33656 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230488AbhHXWpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJtIwn001072
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=/0dXR9byPBxXJGdH0D70AkdSpS2zdUPV7HM9V/ZdeUk=;
 b=YzeqQK+W0NMIKaRI2f8ffaavTEHQl4a+Nsne06t1hf1xUKKtady54WE/lN0snjKVYdw1
 T22dZn+ohfGUZ2eSBOmNAXXzr1ORJmF0/HOzEUHIzRShdHAR/ynZXhWQi58G4rImDyuA
 Nxgvr6nIL51rB6iESbaafi0I8ipZ0XeOkIycJDZCl3oSOs3tvwGmvBG1M1Gn9vpEUwhc
 pzh/PUAqyQqfrvRxILv23Vv6iE2dgsWFaIagI5eO1ZoG/nH3UenG/isZgamf7uLYP2UV
 8JW6wFaNxYjxO/WYZqXxXHZgul4kBk1rUDqoIamatluB2wU5znexnH7qKtVZVRAVI2Hr pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=/0dXR9byPBxXJGdH0D70AkdSpS2zdUPV7HM9V/ZdeUk=;
 b=VOboEcvXE1H7xsFkEZyY8un4ID2l6p5rix8S8zx18axvzlYZw/FIPEqvhuLWlpwnf9Lo
 ybmkN7dIlqdkQTMCyqx+Y4fAr/bXwXtc5foM31mlPPv9SX//SOLS8D4sqIj/0nBjVDQp
 oit7zuK+WekTtjLirLPcvozZvyqKZXQzB5/RIj8wCLeLN3sv3S4+rDo0fWXgMgxB/PWg
 wmOfmvrneA08GHs2k7RKDmfUU9NJZgrPzs04yVzLxVWtFeQ5EZfa0VJ9mfWMdlQx/z8f
 EAmwmv66epA0+kF6gaSwwZj/XPk+ASUbqDvujGWqPys53beQLq8+pWKml4Aq3HjccJzM 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt4uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQA025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7Uqz2gNjb5GMyW9PCHivDvXoyAeizS8Z5vBmyoZdxwfqHaX3QLHSXwLWaCVJH4aJGJK9FSoHTf2VpjkCGXrrnBi6YKrcbiRH86PQXD+B0ezsaMm+XAwbLFzCYVeZL7v8aVYks18jRvz+X6ef0g3KAbY78wH4u7qWaAApoCKPG7gvUu25ffFCgUSuCVS7WapUnqGlYmXYMrxwboKNeP0HxTxErA6dSQnjaweSH3qOkBx7/twNKJbJybvfWyng0J9TWzbDmlJIeD6Sd2TKt6qZKwrtL4NINdy70n8IAoeep37WOwlsbhLnFlnFC73KXC3rsJ+jZ5oY7LsUlM3lI4JZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0dXR9byPBxXJGdH0D70AkdSpS2zdUPV7HM9V/ZdeUk=;
 b=XoC2QzaDf/zNr9qO0alpg4blCy/NdEswBXZYlM04ZWPunTni3yBnLEpXr8gTChF/yBIYx+vaqH+L7hH8ORTYY1InYdB+NXpS9oPpi1jXvzcnveV3kTd8u9p5wmGRHHF+m/lx18GekP9gmmHp7dRUIq08wuflUTVZR1KBhjINMxB1tkd13vySReNqnQsPtEgkWlm2x1rcocZxRJzmBMLVog8NpbSoVcubK+qjluI6hUCAM47mSyRyh4ESQutlMGi1eh8wrztTXImJkx54tu+5DtQjxFG4D1roAuYapTgSuMei47fy27SpT/9w4vc45fMQruVC9KmincN2RRHJFIA7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0dXR9byPBxXJGdH0D70AkdSpS2zdUPV7HM9V/ZdeUk=;
 b=J0wSnAexfYX7H0ahRfHM5Q+SJVjwHuVSF+nilgiTFfSRi9hw9pdDaiLeRUg4gPq6+98/7YleY0BYg4u+T1n07pHDZdke4JFW+NzQdrjVpx41avEcRZw81InSGWrK4qmyvQwgD2sFvLX2n9sr8oaioEknr8qFEJKJgM8+EtjYUQM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 09/11] xfs: Add larp debug option
Date:   Tue, 24 Aug 2021 15:44:32 -0700
Message-Id: <20210824224434.968720-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4fa82d7-53da-43a6-89fd-08d96750c51f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB465373D12795EBB92452A09695C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: InOQkKxnNfCE6pINNiDmzsZC8RYay5VCzH4uyjC/X8wcVhkzpxSdmwKYlRxY57rrCULG9JWM/QChf/QvNAAqHpyJ3Mt6gYy3dQBzsyvdkr2fJQm1xRYgJIDzxTc+5fIVeCRrQ1MT1llfaRhEbF1DZyJyXPUsDb1I+Ej8Scrddq3wXDaDhJJ2xYToEERhkR6wvxODsoNrfmCll7ySjnfhm5rXtsUeUTidSfCjKElnKl6r4fF6jgVc1v8bjpHoWbX2wVqPkk2QsF/Y9sDG0Iq5BOpH8NQpcFljAkbcRmOf1jJPntWGn9ZwmH0CJQLf0s17BwMWB4AXf+ZTUBV71pYeXgj/1MnGJVtCq7Uf5zhQecax7elDIMA3fcpt3TXZ+X3J1n/XJrzEnXgNyQrDbYTU5YCQ0cs8R6ZWQsaIZLdOywoZm5fxUlvm7YpLl/EEsaGU7/fjOAzQQKqfrpP9HQ65gkOJtqtNr19smZ4GDjEkxd523Y47Q/TF6YvmtcWXL8c7PWnMK5d7U712sSV8tt+v5QSL+b2V4kRmucIdeT7iObS9rBWnnLnHXlrNfho3CtD0IX6KdyHM2Te6hjOn9o6XSW3YfovHjUnEJdbj8NkgSpdrQ+xY4aZIHmy+Bd6408zoJ2tYb+TZEF8UYh92T8f6Uw8XxeibgCDIcBgZcggmMj2ekeCIAY1i6YxWdJ9SY7VlPVz0K8XV0e+P4SKEM9I20w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CglD6wG9BWqs9UQmEMKCa/kbcL/QGrB1U7fSxptQEPa3P1yF6QjFcwwOi87S?=
 =?us-ascii?Q?28mKdaTfrgDmRTW/hZO7N3HBjQzWpy///62mOHZKwr0K5Uih229Lx+3mM1mA?=
 =?us-ascii?Q?Lk7WeIodt/8QlBdZLDoom5RtPYivi66b8VLQNqi5QqnYDFQtX9dw1jYbgj7K?=
 =?us-ascii?Q?ie8WikRhk19BXZCw+WIJAreS6Vdre6NQ+NlZOjSH521F7pHrLaNPkcc/VbHF?=
 =?us-ascii?Q?7ni/1OJxwgowYuZtaFDzS7XD3zyck1LrmGrjvb355iSeWhsGp59N1/H94gDx?=
 =?us-ascii?Q?jexSm7lfkqnx8MSA1DQAuXYpWov4A074HHKE33GuO4bL+8LRofwZvnGzbhqa?=
 =?us-ascii?Q?VfOyP6ya3H2mrNukHrkxX8M7uekDUzzP1BC67xif/2n6Iq7g65bsxb2+lH7I?=
 =?us-ascii?Q?TOle7YOiIyDoTR6Rk3oAC4gWCCZTfCme+UWLIAFGJZT9krVPkfgeYw7f6FwQ?=
 =?us-ascii?Q?hd93GH/QbS1boKNzEePbiJ4D3qxzUcVpX5+A/UhGWU2IRdvX2wnmRj30aAzn?=
 =?us-ascii?Q?kn273Kg/ODKD5pZi87lBvnh6vJcZInbOQ8Tg7iNKAf+3RkGhyoM31wclcqAA?=
 =?us-ascii?Q?SLW9IcbDkOIgHfyKLmdQ2t7XxYo+FHc1FxIdaDOtC+hX9SwA6LydGghSfA7H?=
 =?us-ascii?Q?dx4C2vyWIHij/UMu+t9auaJoRE1bpqWXsP82ac6a4kaWGyEk2tZhAsArBaP4?=
 =?us-ascii?Q?+X3a4wirlKj1v/VumBUUUlBOiT86phIX6PA+bD6iWwcFUQILeQ6xi8bWH3e6?=
 =?us-ascii?Q?bSp/lGSrqMsNvXq16pu4NBCJV1dWfXyYQMAXxon+hhzT/g8IEXxbGiBqZmu6?=
 =?us-ascii?Q?qVqRtxOYN2QNTPr+XdneHlHfXkJCFbQOVcy1ti51bGXzMNLCQmM69vttm9DJ?=
 =?us-ascii?Q?sZf0nf4/tlPusBsOmxrmfcPZCPv2KkUoRqUl30zpUzoWGGpelyk+pcrGmDar?=
 =?us-ascii?Q?YFL7Rq1FwTmWhDC0a2gg8TT1zP5S4V1LstwDrNEXjzRCxKtntaY+TLQqS/xi?=
 =?us-ascii?Q?wBgcxnglwACfLKl0k8unN7QvFUj20z0k66a21u0OY/gj6L4espTCZ7IurZOx?=
 =?us-ascii?Q?CYAOjScV4alfwuQ4DRFssBxkWdqu0vseuMF2bbjRvwY2p3qpmLlGy0xWYyYD?=
 =?us-ascii?Q?osLfYJsRgxlonC95S/xfLmPpzNglmedqlr+DTgUcI1fn+FRcTR3jQErwuNR8?=
 =?us-ascii?Q?A7CVlFTF5LCIqbuBQdlaP+Aouk1IQehAZqm6HyM4DsRNpN7XZtVyqv87j0ea?=
 =?us-ascii?Q?5j/cqdOSggMBHTnf0+OBXena6P5Wrr+7Nmnb3ACJB46lRVVINgbC9/UkkkLx?=
 =?us-ascii?Q?u8+WOklcSuPDYBbUbATYGQwr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fa82d7-53da-43a6-89fd-08d96750c51f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:45.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RuegMSIK0JUwftF9bLoLoiIiIufX/jtgKTqEPeY+2hsHEkktvL7HP73SG+peBcsuODEMnpWFmCBb8UEoSl0eBgPXA0Z8Yo3FvpqcEiFMvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: sEUqAcOhl4vEoJU6Ci1PEnqWGUfZ2nki
X-Proofpoint-GUID: sEUqAcOhl4vEoJU6Ci1PEnqWGUfZ2nki
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a mount option to enable log attribute replay. Eventually
this can be removed when delayed attrs becomes permanent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h |  2 +-
 fs/xfs/xfs_globals.c     |  1 +
 fs/xfs/xfs_sysctl.h      |  1 +
 fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index efb7ac4fc41c..492762541174 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -30,7 +30,7 @@ struct xfs_attr_list_context;
 
 static inline bool xfs_has_larp(struct xfs_mount *mp)
 {
-	return false;
+	return xfs_globals.larp;
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
index 18dc5eca6c04..74180e05e8ed 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -227,6 +227,29 @@ pwork_threads_show(
 	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
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

