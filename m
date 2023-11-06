Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54B6C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjKFNLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjKFNLl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0F110B
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:35 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx7XA030861;
        Mon, 6 Nov 2023 13:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=rCAE7aiZoefjvXfmb2BVxPwAFfqlbW1yfVTJNh58tnfnoZvGIhEaUQ5NCQBgCneHeUq8
 5VTynZgVBL1V/TRndfavEOkjbAfUo6dyEDOWQkHG+E1vJdy4o/bgSgdS2cVWB9MZfs4Z
 OL8nNYPEAobW9VKigo57lPB3uZOlAkojBmwQjghqtrBudwRPHBAp76DVGkGBb45D0uS2
 QcXNgEMteBT02GBuoZAgjSpHNt0fi71FFhnyPbJ+rIhc4WkjcVC+Yw+Drq5GhHvC5IWW
 3Gs8dINrXfWIZV5wXDeCAqAQl9x8/iwwguBXig72GSokS9kmK413DLr/pJ8us8MOizvS hw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679thnxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D0mOb023561;
        Mon, 6 Nov 2023 13:11:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4t8w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRVQIgjO3MY9coX0yGiiBf/erFAXuK6OuzUh4S7k77+qHO7JOe1N/9U8M3VbTm6IcgMYdjZIUnjKav+nSNYSycXkIXrH3Io3w/A63px2QcApU7zqSxbWuxWo+R6em7wca4jZFPWtXSH3NQJnNigfkMdtilGbc32rgMlI8T6ssL8Qlgr1x0DpWOfUzyvFbt80Wh3jbcTc3NEqfTh8CCfb2xoaaaZAnaZMldI21TTAMG0cAg2XNtgbnsGrJB7v5rTA84JQ+aCrIlp4G1h4nt7JwSFykL+cMQM+rhfoZ0xTeYYyZdHfTUFVDocQ5EHkxEDUK5kCdEdwHNpEhBt5GzVVRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=CeT8um1cKCKwDdnz9RFSv5uP/wDUPLjwV60oNNEKn9BwIoWlL1BOlWWGuzjRn5waHBsDJghJdJ/eY+6cmii0w2sEp3kSM1qgOjkGdCzzeaNjPttGkVxf1gdNoBOGeQzKCUGJzR6bqiGvrOzo6/5a9Xfb9oaiYQH5wh2HFYr4ymeRX7HClOVLaoDy+ZvxiAzmsaWu3PQaDZpsQrjnGBL2uQIE7bEJU6SdfsAzpCY8vr+8i2HqG1Q5DQQOCpm9qW/QXgrBMcjjE8JiU8buexMY+2Sn/4YzcTTxXK4Al/+HoR5zuY+ZOlsZFA+h2ziCkvVN3V4qeSs7cEsbmBwKELYiaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=HtaFBn5lIgkd/URe359XHRwi6XOqPn0oz26XsqKWMUbUnzzKBc/Rfzruns2VHqP9ukkROgWlecoVreKvOzhk5OaOF2+k6A2ovQOmeXZQOrZqOBV/WCqVyFF3lz6K+/T9yNr3DcV7d+ArkXROi5S7UHSPFxXQ6BBf1f3txuSg66A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 03/21] metadump: Declare boolean variables with bool type
Date:   Mon,  6 Nov 2023 18:40:36 +0530
Message-Id: <20231106131054.143419-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:3:18::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 430954ee-5b00-43d2-b0ea-08dbdec9e370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ebfOfsjfe5LyhLVAaE/I3zO6rbcwVUIbFgIFY8s8M1UceqJN0ugMJL3ZHc0CTy3W2+x2kxwH7rphWEKH9xcq5AVrKXWyjOh1e6Izcbmpj2VsrvZPHn+Th0Tu3YWkaaz1qvnREYBcB21E9w74Hii7Q9WpAVJZnzpYRDTBhbj3o7wjQq4qPdUbWG5/P/MDZP/rB/gJYb5cHSziNq6WI5GvkYebroJrZ7spDOd9m6JumN3984eYWLwdmbVGeVZjJ5ci3jk5Afc/MQohrugyuBzuawQcZeVqbpKezx/HlNVed6iWfO27WkXci39MlmeX4lN68YtQRpzebsmlkjVKZ/oIg2WVnqP5ZpAOUw7mIWSeThAcnzykYlfhxyk6ns01KmKyzTiKiA7MnHQjlr4y7DlT/6R7eJEYtbm5k5VJj9M6FXgztI8/UerqadlAJcZ+huh4TNGzG/EIdOhUkkviSRex7Q5V4MxiQTx3ZZMfdYp98TBmu6v7IcV13pcKOg0w9OURsRluwmnm3BV9/BBJOfYH58y78HaOqgzNkls3xiaPJYLY5njHxdxIdygzSjLxe1Zm6YoruXX9qNScSRRu8eeIKMuekaefYibXq7uXV2eS2hmbabQIgP2rAqyUQGq7CbyL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PDSp/bpC/BdKdK7dWTZ/xII3Vi+zGMbjit3hA0SzcFbIByaIhhY/ArpIknpd?=
 =?us-ascii?Q?A5eBV5xsMZpZwKGzatueuqH/9urOm0UBakpVVPmOY4Oe9XZN6SgZq7waRD+I?=
 =?us-ascii?Q?xybcsBwvVTs7LosBscqLPCMGg/V0SHdhZcHM9n0rAdl7/4JYcQhbrSU9poTd?=
 =?us-ascii?Q?1mrwAdRI+ZqAgVR1bCN15Zl4YHcdcxp5+NhjD1fBoSpfSqmZC/aNe/Ke4x5l?=
 =?us-ascii?Q?uzJX5D4sDiLKB9sbha0rPqxovSrlFvMQNdem0DB1CfvC3QtPGBSttkCl19M1?=
 =?us-ascii?Q?P0/1yWPWJpvBruS6zTAvtPgWtCC0/nvj1VZbsOCJx6eUqmdlclcXv7NT1N/Q?=
 =?us-ascii?Q?a7r75GZ6OQYFcY0nJvawn0VA1lMmP6/jYU1mCeUWTCFBj8KsG5EBCTnPU34m?=
 =?us-ascii?Q?laG4qnE47usQ7XIQW7OzNFV0VlJ8ZoqIlRRqcC2oFCcvvggddT6t5UISYVyq?=
 =?us-ascii?Q?I6hRfiCx/ZYz7FbNdrqjypJSnI0RhX7t182zl4JrUNXxB/iDoG79mlIJf/XI?=
 =?us-ascii?Q?rtAn4rmgBhrsxIdSBPKK26GYajZ/PRNlZh30K2vO95v6fHTJqvGm21SG4rq+?=
 =?us-ascii?Q?/9AAhm2fXtC9mqUl/t7fX2M9sU9rxBs/zvmL3bHvO6QWZQffzYK7REYfEkcz?=
 =?us-ascii?Q?n7tmy0FkSnAiP4y/meOobDp0HgBbo9DYk1sWMk0KG5BQhpxFH+U+Q/xk73up?=
 =?us-ascii?Q?a2FInQoge1+5A2K0ThtyjSYC/hehPlxRD3jP6yUBZkVnPN1Al84YJooidNX5?=
 =?us-ascii?Q?GzOpkxP5a37zLPXYxn2qoEBtK5HdV2cYxjZukUAifieXqYq4jd1Fae5VI88P?=
 =?us-ascii?Q?kTmT1w3bwMNotDbWSwMIzOcxRsAJprbjoBoyspY0S9meWDZB0Ls2TwXSN9f2?=
 =?us-ascii?Q?tr+wc1jUUe6GV7o065ZktonuFJR+pULfZt9VSIgYF58b/RAFOpk3ka2BKsY+?=
 =?us-ascii?Q?4h6cSxmoCAMtYNKrUyehwDpfvySKTpykhs+9gHkBTAx8MoHLhKByNxjux09x?=
 =?us-ascii?Q?ZgaQxaRgtLC0Iw+845GzooT/MHWk9jPpzrU1rToYtfsevWAduWzyyH/SHLcU?=
 =?us-ascii?Q?RwTLaNlxdG3MN6ghRltZZLPZvOFNj1ZNR0zNDotia+lXvjAyNJprlqCNPpS/?=
 =?us-ascii?Q?hJ77mxMV5e2cLDahdCooWHBQ3P/YF5NobZ2Vdc0TgZ3bnkcP20ZjWFtWcTtr?=
 =?us-ascii?Q?krBuHnnH3GgE3/JedY40PZmGz8G+pODRrmpStPz9uNMIsQsa+zzMRlM97FYw?=
 =?us-ascii?Q?n2543gIRkhmJnSoMwNX9073ufSnIaNaMfvdAC3wEjN+cSxRuvavhBdjdJuXB?=
 =?us-ascii?Q?ms20W07417MsZv9tDbCr8JWAuJGNQttD3cPg8USuVmDESUkPCZSQvhDiGxxY?=
 =?us-ascii?Q?y1r5Z6qnxB6RbgecdRutFX1SxGrDtxr1un/4O+0iWCN3tcvOorr7UoYjoGAT?=
 =?us-ascii?Q?tvCTuV+v5NGudDSpL1LcOrZzwudqiLSU+tQ7JPlu55rcZOneLV21Iq8XFj58?=
 =?us-ascii?Q?hPI86nx7zrxBx8x8SRu9PGNcrvtqBqkTDkhiKDc58V46SqAXXnM6tZvD+A1J?=
 =?us-ascii?Q?0zgQ6B8SQf+aXXGA4znYVxHM41gkg+4FSDXv2+L7113HuH+3iuor9tLCmgkw?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: C1Am2fR8xFjmnGwgcHiy96uQnqj3uZs5RbJyhkX1E/shCvmdSUihXqk2R1WmrJBTgCdYE2NzZtAxhupe86fZ1vNHcPFR7bs33Eh7CNnCTJhM5qAbjBKKkxrQcMbpzRtaUn/FRWDvNExUc8N4VFRTJKT/C3dyuMjrGk/DmGwdUu/8xgXohIesoXbnpKnWvQ8aee5DJDYxW4wGyB4hnEZtd9rc79l8DtAkr8Qlymb9hjiryaKM0KxiXRW8qYLcOLcbdcEepKNeXd+b+CPp2+cs6D1KwUs1bnUth1OntaPev6Il7GfPjE9Jd+PpLMz0SzKMtpcFWsmaWvkbZw1Z8coGyb9jc/FJ0ytQA8aeYc5QKEAOWtpDq5PsPktCOMotH/TdnOjpgJbnDYboyJ7CAmtM41hjmM0rZuRksecnzRnnX3fSO13w2Cz4DzGHLHdzjjTvc4QIAtlR25AZhOWTk6ysak/msMbpad5hm7HvNI+0UE2MyyJ+ooHfPoyCSbLLjGHK6FOCa2SFqmNnWL4X62vkt7ezFPATSKUxXeakB3KTSfkDUOXA8SJSKvXzX3rL26lbpwY3xTaklxWDo9Warz8QY88znzi+zu9TVQsiatYAj1UPxVYBjD83CBXvUgVMG8ommAt91TybVY3sgaHyYOPzeLQSEorlkr5DPOQgKDSCA1DrtN2GlBCncY0aEyij9YtBd5qqIaFdd7ewINZa8n+OGfHKAMW7jaKTTam/aFicf88KgJINf22LbTleJb3YDloevbAqnWVmni4Kz0C34xRECJxDA0gEHx9owQpYU5P1z3k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430954ee-5b00-43d2-b0ea-08dbdec9e370
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:28.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfBm0CoKVpdeCDLNULDrhNmrgV0gXegNm7jf3DgkeRgY7af9DlbBEs61fTeXZhnWo2Pl615tGYskfa/9iA2grw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: C7WwFRuKQgJuJOsmzLxJpq7fAHBpU0X2
X-Proofpoint-GUID: C7WwFRuKQgJuJOsmzLxJpq7fAHBpU0X2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index dab14e59..14eda688 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -52,13 +52,13 @@ static int		cur_index;
 
 static xfs_ino_t	cur_ino;
 
-static int		show_progress = 0;
-static int		stop_on_read_error = 0;
+static bool		show_progress = false;
+static bool		stop_on_read_error = false;
 static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
-static int		obfuscate = 1;
-static int		zero_stale_data = 1;
-static int		show_warnings = 0;
-static int		progress_since_warning = 0;
+static bool		obfuscate = true;
+static bool		zero_stale_data = true;
+static bool		show_warnings = false;
+static bool		progress_since_warning = false;
 static bool		stdout_metadump;
 
 void
@@ -101,7 +101,7 @@ print_warning(const char *fmt, ...)
 
 	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
 			progname, buf);
-	progress_since_warning = 0;
+	progress_since_warning = false;
 }
 
 static void
@@ -122,7 +122,7 @@ print_progress(const char *fmt, ...)
 	f = stdout_metadump ? stderr : stdout;
 	fprintf(f, "\r%-59s", buf);
 	fflush(f);
-	progress_since_warning = 1;
+	progress_since_warning = true;
 }
 
 /*
@@ -2659,9 +2659,9 @@ metadump_f(
 	char		*p;
 
 	exitcode = 1;
-	show_progress = 0;
-	show_warnings = 0;
-	stop_on_read_error = 0;
+	show_progress = false;
+	show_warnings = false;
+	stop_on_read_error = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -2682,13 +2682,13 @@ metadump_f(
 	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
 		switch (c) {
 			case 'a':
-				zero_stale_data = 0;
+				zero_stale_data = false;
 				break;
 			case 'e':
-				stop_on_read_error = 1;
+				stop_on_read_error = true;
 				break;
 			case 'g':
-				show_progress = 1;
+				show_progress = true;
 				break;
 			case 'm':
 				max_extent_size = (int)strtol(optarg, &p, 0);
@@ -2699,10 +2699,10 @@ metadump_f(
 				}
 				break;
 			case 'o':
-				obfuscate = 0;
+				obfuscate = false;
 				break;
 			case 'w':
-				show_warnings = 1;
+				show_warnings = true;
 				break;
 			default:
 				print_warning("bad option for metadump command");
-- 
2.39.1

