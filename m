Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D84C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 00:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiERAMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 20:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiERAMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 20:12:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4988649F22
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 17:12:44 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKMwc6019084
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=0Zo/2a//f32v3wLLT8vrH9EDTd08H1oEGypSDx1KZjM=;
 b=t5FqG1bipFUXaKcpbhUDmc9hGYJcQrD4Wh8U3HL7tQfOsyx60RLGmbspCWcBIyVKH4x/
 iuXHRW8eVSDBKmXOPlilTxnjgsw2HqqCFdy56JUNvdE0KwYpOH6kKlvWWfgTZbwOxIg6
 a4EOtHh3VZR6Wsv7nCm7tT1tH2vr1nf2tz7tHHOq/Dool9iDnxYlptqzut4V9CEIIDyZ
 BNk6v6wSHzV6OaItufQ5EBNiGkoXFcCJw0I3HRAW/mFlJ4JScc2fyWZQ3WywW55ua4PV
 39NUPh5XipAH4lwdrRyVp7Q3dZ5327wm0AA/LWvCWfnJzWZsAzNvvJK47yd/TkI8Rb2Q Mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371ywdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I0B1WQ030795
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3p4kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 00:12:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiehjiU4D/WhCVYX86EK+pBnO6jvcr8vmdhwUb9dTwoAe7xijRsh3l6PZsMGl0tE30hnOG0K/fLSosiRH93q+vlcMefKz+oOFwAiqY+frqli561ikBgWXxA9sAeQ2jccXwUv5jyKM+uNxHeFsUytGHMK0mKmh98BE7j2fW9uJoldOINRNq/CXRW8fBRqssdugq1iWM4ifMatKqRJJlvX+JOkyBTJyQ08L6rPNAtzyWJksuugIBGtKPPqIQzhMoZ0dLgfVjU7AKnONbnCrKRcBh3AGPqoIj54uNX7gOpMXK5B+fltGZ9AVXUnTbaWqTXNiJjygcXhLuT/MF2mL25qsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Zo/2a//f32v3wLLT8vrH9EDTd08H1oEGypSDx1KZjM=;
 b=EJ+G1GC3t/TDR2nG6jzzI468OsHvB4SoRH45+GPsHh5YBaLbMY1OKOZsp9sOo3u1butMP3iTfRYrG9i9a75iLXtOFqfTbnKt/GNWebDUWn1cnWJFxkyCApFI4I4trSP+FNuZOaHEixyEbKiEoplGxuJTtJlrfIwV+deDbfkzq3K9Fv1uwlnXgi2iqvoAtBbXdsB0Mfi3bSIvrg6RABsiyD1EAuoPloF9/mmqW+5mfyhFzjsD8/kVjZMP/NJ5PUZ8npYY+072Fu5GDSs/Z+XxEIPqh+wGm96UdaGOWQxF0edIOza5J286plTe+av8MNEDIELcH+weAGOR02xgv/sOFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zo/2a//f32v3wLLT8vrH9EDTd08H1oEGypSDx1KZjM=;
 b=s/bW/4pd9NwSCxw/jvZB0+RPuRd2T06Tj50SF5l4gK1flvqegflPgkEHq4tTYo0G+wo3x4691mFL4tGG7RQwSsCAO8Z5LwQuUPqIql7J6gnz82NfUxr2vRtKLI4a0GF5GcNqFRVFoCdUPpyYWU+ZlbGxM2URBgm6atUml9VU9Hc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1528.namprd10.prod.outlook.com (2603:10b6:903:2a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 00:12:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 00:12:39 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/18] xfsprogs: Add log attribute error tag
Date:   Tue, 17 May 2022 17:12:21 -0700
Message-Id: <20220518001227.1779324-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518001227.1779324-1-allison.henderson@oracle.com>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 361f2d55-eace-432f-94da-08da38631e7d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1528:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB15284BAABF86CFBC9D40E9ED95D19@CY4PR10MB1528.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mjsr1VrPmul0Bc9jzv7ErO/QLR/A6lSoTeOX8SuRiiKK4aZsE8qaiklz6oXS83iMWGOj2rGzbE27qXJNXNTVpj2RK1twKf8vHj+yWw0c19fD1ZpUKjLR9QGKFOvtQWyirXBchqzJ0EWFHM/IZvtGMgmPI4rnfTvUdM+wArIkU6MBS5ibSQKQ//qeQLs/WtMclGh6Yje75QQd5HtMrWAy5NKS23VnYj0qWOiQfliMCV+wZq43dZjn1n3KcxtwvNS6YypK3Gb6TukHbRC04neGkeeM4SMj0dZNmQJr3zGKkU7FEKF9yEc/D8MDR9fMC4jHq9ahPZf+I55mUkrwDzTUzEQUDox1iKm6o9uJhSiFKeTp7rV45ALTZNIR9MStFqCrEdKmysB6tSTQq0CdNK1ZAgWW+FDuG5Ki+Xx3Y0HQJtG05Mx/2rmdJfr0IBORIIHSjQNzYnZC7Dc3nIJh7c0VDwg7AUZh5bSP8NLYg0+UjsLvd9F7R+fWi7+mk+wcesz1Y8n5Ndlf3HK6qO73/RdVXfORaC4nRdsgluSWTCBXdC4Bkrz2/iyhYQMc42Z4gDEVLys2aanMRuu6Ovzi1t23fzMgUifZZY4WDcP2rz3MYhYfGgwtr9Ltl1FbbHiGCzve+HAhcqOI225R1dX0W2FMYEV3FuX8Qcqn5fEXpCkS666bhHtCUuanNThVLZkbMF/0MApa/nqXVw24w0WqoLMnmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(508600001)(38350700002)(38100700002)(6506007)(26005)(6666004)(6916009)(66946007)(44832011)(2616005)(2906002)(5660300002)(52116002)(316002)(66556008)(8676002)(66476007)(6512007)(6486002)(186003)(86362001)(1076003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ly+fXUSNCncjFKAmMDtcWgJeXm1F8lghSqcv6fzmm1FhByL35Tz7bW2qhp9L?=
 =?us-ascii?Q?Son37/EFHJG19afaKNntQGjewZ2BhQk8nl2UHT2Dy/ounHENbpGFXWfn5vJR?=
 =?us-ascii?Q?tClR3OC/LB7MxBkZmSIxTUpV5A4YffJZy+SlpVxsF8RBBc5K/BIlAFCFumO5?=
 =?us-ascii?Q?ugl/+zSzeNeuocajUFx5Qr1T26VOsTNdy3lJWFEgzBiIt24CrJ8CKoDK/o0n?=
 =?us-ascii?Q?4ZWUR9AX/2S5/hu7MPd3rXPZLREK12LdcBRP3gSYhVtJf1H8I6NsOkMSjX78?=
 =?us-ascii?Q?LDdYP/VV6pRt0vy91izj4H8d5a9G3EivfR2xjKwC/N1WBPIi9SKbe4PRx6jy?=
 =?us-ascii?Q?H7pGa1aWZVtu4LTokQYSXjaIXw1Cz2bE+g7jSYlFZ+hQyZgeJMvqSsW9cy5I?=
 =?us-ascii?Q?JkkN0z6VYDVu38qhMEfE9KGA2kBWZ0+CqjmJ4eDw5Yg8BANJ+CJ5I6crXYIp?=
 =?us-ascii?Q?1cUcItNmbUS++8lC9KjDaXt7x8h4jS9dk/rtHbLON+Gh8IHmTkCc/gLdG2Kw?=
 =?us-ascii?Q?ZFXUBCL6QxEdswgZQAqS9vsczn6K8tOA+txgcRP1QWjeXSEJb/PxL/HK3RE9?=
 =?us-ascii?Q?+g0JC5rwbREX2kuUOWIfca6XGHYmcqxa4SKIVrNDf93p5VoAX1zwj4a/mwE/?=
 =?us-ascii?Q?jAzHq5y9GPuhGUQkaGxkl1StbXKo0S2LA9toD7LL05qiZKLrl+PaKYFVGZpU?=
 =?us-ascii?Q?XM5sVJQhL/W15XcT10/i3D3nkAmTw4fjKCdiGcWnqZ0WdC/1K3bykDHgz2n4?=
 =?us-ascii?Q?YZj3xCmOFlb6hsnsApXOyw6uCJ2lcr7ottQXf+eBWFRIrbsyWIAdxtygA3RM?=
 =?us-ascii?Q?726P8sJrMl6OQ1xuXxyECAiwuZ3cYTbiOKLG3mUuI0mZ1K9cxd+JzsrtgY9S?=
 =?us-ascii?Q?pIe+cxtEzqsB/WGGtoyZ+pjFQnb65VVZj+KC87HS6OWoowmNb47v0IEBQu1o?=
 =?us-ascii?Q?8Tj/TcAHdpOqMqN5H6/79PIaW5XFIOtytDBh/oMGk8VkEBVvQ7XXr0mqRr7t?=
 =?us-ascii?Q?hYdnEMMhR/BRgXkKuSf12gJLer7Qepfp8gKpKW+MrFr/76lmgyBYInPisRrA?=
 =?us-ascii?Q?+w3GbJ/IqxC1eiSwPBpoim+J5d02OOBdOudLcOiLjmGyTWNrKBodH29W5T2b?=
 =?us-ascii?Q?BdgsIiuY6WZtysO3hNABByiMVmDwgAZ/nKz5lafFof/4D8mPyNvCGGoMn9wR?=
 =?us-ascii?Q?QnASs76vP0udUsYfy7ITV65ncpljyRNzUq+nuGAi1J/tjsHur1hOI7MA2Q1R?=
 =?us-ascii?Q?9J01OQPliCfyCjRsyQNvCBQLkHnOSLiBWhgI6s6jr6uo6ruQWTetI8Fpmuk8?=
 =?us-ascii?Q?S+o5SROzoRpTzNpTNzlFo2lPq1BhqF+V7ufX5jdjBxv4KCpiGHA8NxJsGQMA?=
 =?us-ascii?Q?Cdi6+PU3piYH0Tmp4/wT6tLyOlVeJMh5CooCobgkqdOGqsinBgv5atvopuaZ?=
 =?us-ascii?Q?5zDL2FINddhZjyZjD2f58iVS55TUmWAUIPG+JudD/0DaehCRvbN2HE+0N6QI?=
 =?us-ascii?Q?bwH3EqhnrRUJYVK0zeXaJYBEmn66npNf7X12d/fQ1zC7dm2oZbE70COKTlEk?=
 =?us-ascii?Q?/GXQUrUMW+QMVjezelG1C3O5vFRy5gQt94QSlBQmXvpploQWlnF6naliDud7?=
 =?us-ascii?Q?poKtx/+1YqRwOHgdT2sUuta+No1Uee8sHUR4rlonnRx7TLeF4ER0EZBfo56n?=
 =?us-ascii?Q?8XPZ02cKdZ1dhN3xnlBn7BBVYrhPstmuLclIUN7WZXse6ML8J8BtNrJ4hvB5?=
 =?us-ascii?Q?bFn1ldKpE5Dakqn4cJSzt+Ixq17EeAs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361f2d55-eace-432f-94da-08da38631e7d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 00:12:39.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMdJcPm6JMsJFQnFSeO7qQsXS5UIy6uF8AX56tSyakQj3wgrgVsI2oeT3oZ33y8Nc/FycJS02Jqp5F5O49x6klfWx5Ppwm9e/XFjJpsPKZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170143
X-Proofpoint-GUID: K0NcHPB8aMhczocS1_DqLRnEMmaTIBh7
X-Proofpoint-ORIG-GUID: K0NcHPB8aMhczocS1_DqLRnEMmaTIBh7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: abd61ca3c333506ffa4ee73b78659ab57e7efcf7

This patch adds an error tag that we can use to test log attribute
recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/defer_item.c   | 6 ++++++
 libxfs/xfs_errortag.h | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index b8b0977e139e..43b51db5b9cc 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -58,6 +58,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_REDUCE_MAX_IEXTENTS,	"reduce_max_iextents" },
 		{ XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT,	"bmap_alloc_minlen_extent" },
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
+		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index c6dd6f235124..a6ba75fbfd8b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -136,6 +136,11 @@ xfs_trans_attr_finish_update(
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
 
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
+
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		error = xfs_attr_set_iter(dac);
@@ -149,6 +154,7 @@ xfs_trans_attr_finish_update(
 		break;
 	}
 
+out:
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index a23a52e643ad..c15d2340220c 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -59,7 +59,8 @@
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
-#define XFS_ERRTAG_MAX					39
+#define XFS_ERRTAG_LARP					39
+#define XFS_ERRTAG_MAX					40
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -103,5 +104,6 @@
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
+#define XFS_RANDOM_LARP					1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

