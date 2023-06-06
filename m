Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DDBC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbjFFJaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbjFFJaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CB7126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566LAlq009960;
        Tue, 6 Jun 2023 09:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=07h4OUrfhmpPO8gZtIcQLLl+RexBBOVYbmLN1mh99i4=;
 b=REt1hTTAI5/n7jU61jC+xEMYhM4/ShuQCoK92w6cEQLnSh6/YwbUb1GAcPq49eJC1aAQ
 CP+zUB1JZNQvsAf4bOeL70dEaFQI+b/V441PmVP9K8k5En0OoplzEnF1Hw1EOc7cWuUN
 uB1Ut4SV7bBvgKYZ7lCtKsVTYA84oWqm2k3tqCXnjA6lFjCGlS0yTzxlOTg87b+UGnhF
 uY0u+cXyK7HRbxBhCnKjTG/qwqc/gkUvAiRoLfQySjF3D6fV5mvL+0o2/qStf7ZZq6jO
 kHCypG9IL2T9TayrICfLDL5UoknjfxYE5bLGScoNsm8im0Jrw+gh9gxdkz9S4Pwok1ds 7w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx43vvp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569RUNY010876;
        Tue, 6 Jun 2023 09:30:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tk04rn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ks+w217imQs9CyXmWJonrdrIYm1lbsXkbAyCDwnAyn+9o32u8asP7J/CaiS1Hgy6HfhQKcPdf/bJKlp44b+uR1vVd8XtiFTaxZcsdnAdmcAltqT+jj2BXkV0b5EdgZNePJeS6q27aiOqoSi/el5+bPPpxvnpgVMEv+1H/ngXXk4hQJF2Gk6bwN4++i9z/PjKnC2N9jO+6Rnx+w3xobsQdcM7aPB87B0vyVJJG4jzvgqRFL3m3Wnk1FGE8GaPEiBHl8j3QibNAB7S3bLQyGsDAlDK9k9lKOcBHCTlls3R/aWq43ROGiHaDawPz+9TQCTUR8Nb6K6Ep77mYNLN2A2I8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07h4OUrfhmpPO8gZtIcQLLl+RexBBOVYbmLN1mh99i4=;
 b=ANh6fI2fEfZeIKVPIbi6Dleq0J6Ub3EQkkcm0NsMn8SPnsYMzNuvUXN/Zf1lAxEen5YMqjhCmE4UhZhQ1AyISbLjd7LCtbeamCmqVp6GAc3akQ5FgO4ftOnrF3HyY48+aL/fyhwOjN1K0eJz4S2EzLel5JBr4EjFPxpgHg+BfLrYUgU7l8zEG/AuxeGazRYjbPmwTJso8ANYCuj8hzbX1SeroclHEeXkSSevjbFG2zDcu2A4uHixtwM1oQTkLES44oxjfBwD2i9THX4+5eC/jmU2wMjwXaW5rwpLhSzUcUPlf/qvx5TT0cTNfpOxQYeyDABpfELtN/1ynYbWjwxoVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07h4OUrfhmpPO8gZtIcQLLl+RexBBOVYbmLN1mh99i4=;
 b=C8+xBfq1EQRVE0V6RblCA5PNXCZwAYXko6irrnclqqRh1LS6gzDlUHk37Kf+/7nQuk02Xil4L0FYbJ1s0MGcQ7YWZymhoq30ZYH90v8BdpoFtRlljDITTskt/JVDCRxN4DznBfcaD0LRLGWRVqq8sr/lNmOzu+QrC2us+vPaX4s=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 13/23] metadump: Add support for passing version option
Date:   Tue,  6 Jun 2023 14:57:56 +0530
Message-Id: <20230606092806.1604491-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0011.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 70cab119-b367-4ce2-7d96-08db66709890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ojMp2pTqocFMPT1/u9NpJxc1yUtATpFd7BiigC55kFdLmXD+g3H/FDwoiaz+c+RZOjpEBR0V48kuLjnwG+APS7Ap2RGtxNa5RWeqoSl9+9zHKNUHVL2X/IZg1PEa9EjhSBdkIdwfeug0P63QKq/MjqnNjd5n8D2XEoORuj4aZ4cYLkhAUBjdrVVWIBl6WW+LyFhRJIENEwRNIgVM3B0aA+XYiUQKjLf6HrwGgUkeN/nM6HuXpfhJc3rYRpHG/BMG7YoxaenOsqJydYRzJZ9V7yBL3TDNBRGKE2ReHtvE9rHt4PXjuCZGXeTuEU1raYo0QklYKbAvQGgjfgLDc4OkXEnWkr7EqqKEWPAjnS7++HY/iGr2LjQqm8sxaqO2hWb6A2ySfajp9edIV6W+nekGsIssjkaDzHBGzqoQY2BM3JXOHQJ7gPbRwG70Rmg3/Ldglvtw8KpTDVlqxnb3ZKLIiaCG0WYZ9vzIMTnR3nMSH62lxtpeJ5ZkXwacHwpqKOhjLX9oWxInXl7chczftw6uxW8YDZQW0FPu/q+OvM6td1q3ygIyKKJuEuPSoR7huqK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bkGecSthyIsxE4lR3uAKR5nTb3B0PmMjT2H+1Qx3sJN5Q5PDwE0t4+zPa2nq?=
 =?us-ascii?Q?Inkn64BIX/MxWiZI2nFwCy8Xgdp67ncfA9f9DnZNj4whBqUX33ICtDe/4PN8?=
 =?us-ascii?Q?bqrl2po9Tb/PjqON2oGxchA1jqrRCfH8yDKjuadFw53dA7ujKKHFkQcrJZbw?=
 =?us-ascii?Q?YtrwdGDrgRgwh326EFZRPCxpnrMREqv71/q/yYQE7cQj4Gz92xb90rXTLj+d?=
 =?us-ascii?Q?JfIDm+obyaOPFEwQo+HhbkaOolByfyOYhAQWa+8XqVc8wAtI7D+bxb6YnZSw?=
 =?us-ascii?Q?1qWf4bNeVFRmMv5McXjjte9dpiBU3+xFGcBpnticpRezq5DMv0wGupp7j0kl?=
 =?us-ascii?Q?B3PuvZi5149Z/Z3bxClCQiD/yuAdXygEek3ZZW9/Ousyx35tmvUIHuAbeTqG?=
 =?us-ascii?Q?a1QTBUMyjsEESq68fSBvej3uuibU/f1TGvNU4ddZpV5wYUfqNwyhQ+lGrpHG?=
 =?us-ascii?Q?aVdA4k6ag6Wlt4TWTBkLSfZG1d1/W5SGJUrSK8ZRxdZ/+V3qVOmD7SNhnXxc?=
 =?us-ascii?Q?3uCRbRE6fCPUuAVCXwvSadfwvkvG8vwSCntcr1t7zk/TnnFUmA4Xrft0sgXf?=
 =?us-ascii?Q?F8DUOdk7u34s7Cqr+SCne2FbO6ESqmekKTll9XbFueENgiVo5fNFRVIucxmn?=
 =?us-ascii?Q?ysA/07dP60syey/omH0f47csDqCIVk8l55c21e4ty7CyRCUslWUi4zEmPB93?=
 =?us-ascii?Q?Npd8BcVewPEC8bDDGFVE+HeM5rQtrQn0NF7+gkiS1NWyEa0YgxJXXAyze83H?=
 =?us-ascii?Q?7fKa5Gv9YJeYqEtUWnuUNEzySJDGY75BrhwtoJMk++6A6Vq2k2hzpXnEt2QT?=
 =?us-ascii?Q?5bu+ZWz8Y4s5zdfH1XkYK5pPcvHpDKJLxMxeY9z+800Bum1oXEivQZxTITpv?=
 =?us-ascii?Q?sR6GPSfrqRSwcFrR8prUEXpC3gjTz7mFIgt/iLfS3ql5b8O0ovY2CaXTdWcN?=
 =?us-ascii?Q?gx02pAMR2/pes+qqP+/Ot17BRn5W/YaeQ810FbQ2X/ohwSw5MD5rnWFXJYlC?=
 =?us-ascii?Q?/Aibl2qxnkxLKon032kvDLOOI1k3g+c6vvxR/bqYKwTJeUvyBxeKPgdTCI6Y?=
 =?us-ascii?Q?8Uh2cjqOCO18BM1jMKU7drKYrgoSJ10SvckhxAOgypDYpZ5I3ZqE8M4w6f95?=
 =?us-ascii?Q?rPdmzXW0t/pv39xmolkGMihxMX61ZeVdIeMKmOgRSJXItaebof7c13l636uW?=
 =?us-ascii?Q?Cy7AUTmzZKYnPMaYYzSy4m1xjqNUDKkb7EkFwW/g2rYxMwCn8qB5T7F3KOIP?=
 =?us-ascii?Q?Fe6+AOdUL/WWQ3KdxIXoa3gRGpTNGXfRGBSsCnEQo2YPifKI375k2ZdYHHNA?=
 =?us-ascii?Q?WUzg70wcf9WyFT3dBpyy+oTAiWtlzlyItdfyga0igQl3jq3pw3lqgPtgXIPC?=
 =?us-ascii?Q?6x3R4HnNSgZIPqae4bhWSxhjh/92QztL8oIgmW3KMYQUOGr1okEelN9wwS44?=
 =?us-ascii?Q?6/o1vGYFAJJbddVuUwfnlnM7H7bXN+Ceg31VsHYEbN41X1umIVO2twq403AK?=
 =?us-ascii?Q?s8KxS+eKHhQ2tWy3HNBeC0yJL7uUwT2sB+9ditUseZVn6nq7zUEY4EAKFz1O?=
 =?us-ascii?Q?O14h2vR73MXfLyUdmyDYZtQCjxiXd6A6crlb3H0BYqfhJhZrwO1ye4qx0Mzo?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yz4Hot3CtGZbYBUixMWHO8AxA15miG3+UxNU4ubMHOMZr43X0cWeR6d1gSRA/fccvlQmpjVpJz0r/wqUVmXYIa7mzpAON3LBoTQB4cCcf3JBugqCdUXVfn3HzrmgXfV1uA2chMkB7Qy9r/dvc+9L5iCOlH3gdpd89hAXrzJMDoVnXh3YHEr6llR2F35LGoETAKkHllpXq9NU4TzZlCtiEkpmPYwEek84Owa9mSjVU/lp53rLpqSLNlcf0nZxxPZaIUTAbAA5Vf73xV8qCAf5/uWzIEJSegFUbgmXclTYi31FhTwpd0IhINJv6o+uPnbYdY4R+j1JJbQ+Tx7Ya8YzmmBe13sdhMHEhflHTtkNX9rPD5zQI7OPuZFnuQS2DcG0DKExmrVQV+UDJU8oUh9TvrtJHQ98TVUG5DYaaDq2jbQy/59SsQMjmb40twtlEhIPFWrvSRtUH1Jj3U7ay0DP+hNTz6KypQm+NXz03d4caJbPm0OauDOmGyAR3CstEJUyXhF+r/CNC4fSxGdaj5LaxpaD23XSnapKAZrhyb/NE7CPaowROWf0beJ+klhhhrcSD2ZKTjJhBSYlss48mbJeFN9xBtAbT9c+ByoqF3XZq/2IRFIfIWPs8nNP6BVSeWkHMZOdyhjePtpqtoVaBkrFwfMFb4Nn2FMiQwZAMfHHnAYjZIpORMZQrVUYPzcTVN9GAvLNl/wvGLa0IqJK3UzPxeYPQxyHztYU88Q6fZT4dthqR3NZOSmNvdkDx1B4IODkel/+6zhVi+ZcTGtWb2wU9QTQ5Hv2uBPv8KwBSHx7t3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cab119-b367-4ce2-7d96-08db66709890
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:58.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6WzmN3XU454CvwpNNfRaxILsFCGkzOkrwRe5eKXHM3FIkEO2jo+sfO9PuzmnVmGvTuQORztcwBj++AKFIRFsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: nlnpiE3ib8PRp3M2GEiplcissH0pB1xh
X-Proofpoint-GUID: nlnpiE3ib8PRp3M2GEiplcissH0pB1xh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new option allows the user to explicitly specify the version of metadump
to use. However, we will default to using the v1 format.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.h                 |  2 ++
 db/metadump.c           | 53 ++++++++++++++++++++++++++++++++++-------
 db/xfs_metadump.sh      |  3 ++-
 man/man8/xfs_metadump.8 | 14 +++++++++++
 4 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/db/io.h b/db/io.h
index c29a7488..bd86c31f 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/metadump.c b/db/metadump.c
index 537c37f7..a9b27e95 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -37,7 +37,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -74,6 +74,7 @@ static struct metadump {
 	bool			zero_stale_data;
 	bool			progress_since_warning;
 	bool			dirty_log;
+	bool			external_log;
 	bool			stdout_metadump;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
@@ -107,6 +108,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -2907,8 +2909,9 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	set_log_cur(&typtab[TYP_LOG],
+		XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+		mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
@@ -3069,6 +3072,8 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
 	if (metadump.dirty_log)
 		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+	if (metadump.external_log)
+		compat_flags |= XFS_MD2_INCOMPAT_EXTERNALLOG;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
 
@@ -3129,6 +3134,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -3140,6 +3146,7 @@ metadump_f(
 	metadump.obfuscate = true;
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
+	metadump.external_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3157,7 +3164,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = false;
@@ -3181,6 +3188,17 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = false;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+					(metadump.version != 1 &&
+						metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = true;
 				break;
@@ -3195,10 +3213,27 @@ metadump_f(
 		return 0;
 	}
 
-	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		metadump.external_log = true;
+
+	if (metadump.external_log && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
+		!metadump.external_log) {
+		print_warning("external log device not loaded, use -l");
+		return -ENODEV;
+	}
+
+	/*
+	 * If we'll copy the log, see if the log is dirty.
+	 *
+	 * Metadump v1 does not support dumping the contents of an external
+	 * log. Hence we skip the dirty log check.
+	 */
+	if (!(metadump.version == 1 && metadump.external_log)) {
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
+		set_log_cur(&typtab[TYP_LOG],
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
 		if (iocur_top->data) {	/* best effort */
@@ -3276,8 +3311,8 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
+	/* copy log */
+	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
 	/* write the remaining index */
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc..9e8f86e5 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -8,7 +8,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -20,6 +20,7 @@ do
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
 	F)	DBOPTS=$DBOPTS" -F";;
+	v)	OPTS=$OPTS"-v "$OPTARG" ";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77..1732012c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format.
+Metadump in v2 format can be generated by passing the "-v 2" option.
+Metadump in v2 format is generated by default if the filesystem has an
+external log and the metadump version to use is not explicitly mentioned.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced.
+Valid values are 1 and 2.
+The default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

