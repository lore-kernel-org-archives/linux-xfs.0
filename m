Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00489C001DE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjGUJsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjGUJrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:47:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434E335A3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:47:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMktZ016224;
        Fri, 21 Jul 2023 09:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=URN+IaPMKMtD1/dGmngv3UHHfmGG+Cc3w8x/25ASdfVnjyJKNV3hwrjOz+NJc+2Kt3xt
 cYAZF4axdzq6HnZAO8A3UcFJZWXlrY26dphQXAeoGE66290+t4s5kt6PNgTLCNrr98kH
 9thqCbgUl/eS5R0u1uJ1oXYepgO7nmvH0znKNauDZuuYcTQXZTUYZReC/Z40kqm9EQU+
 +JgGXKw0oxE5OERYcv4+g0FjFsntrsWE9usJt76+QGr7X9IcV3gYyv/XMztIGcayegu3
 UsexKHtHiGExyfVgSzMJ384wwATm8+hOJtdfIDY5XWDP6DaHB0KQB6Vua/zsCKDqOFAT GA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run783j85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9fVQI038185;
        Fri, 21 Jul 2023 09:47:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9sr58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRM5sNwTCQSAzvFHO0vtS6QfljGw0w9eYl9k2C/+HM4NtSeSY7l3PJ5pV2dWNEBIc/ZoePXGFWYeKq95oAUMzPkvblwzEPHUn9oxIvbjk0b8pS4f8I9KwuylaGknIMuwGvmZdnjp3XFbhDxCJ0gsA247jmIuCcse0LElthsYjnWHLa2KrtBX96Ih6ke7iVAHqYSHn1xZk6d6i5WGD8XBiL8jVjd4GYuRgBPQOpQLNxmWMpJWJ3LVOUlGgTL2rZG8+B2eIJ/wNr9du6JnAOqJMdJU6jz7olSfUyAPJzPzjadC4VnFI+8xZZoBdfIjazlx6W7/gwGJfHJBywfbW8UVew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=RvqHgAJ4wNFvJb3Ua3hAhGvl/jTC8igLg0v8o3BMLz/H6WLJsQw0C0VCRWl1IHQuiZFzeWpIe0PmirnfpZH6OcAISEhsA8q62xF5VRs69xaZhYMVU+R0vjcvd6rCYMqhs5973Va+dEbZuaYJPk/LfBLlDaxzkbd7Kwxu6h/zW5O+7iHZn9mIgXYJglAU4kBc+ck4f17hQgnpS4e9gNRan0hU11r0+cXRt5S25sOEAY3GNduNFjh7PAqxcQjmozSVYn8jUwdow6Af/IBGaVwH9Bh3dBgnSCp/stgpugD7l9AGPVp2QJmA0AjR9f59dXFu+YUqEVOTIekFoWpp+XdzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=lk/jbhh1pJfqjetddpII+3hAyTjV6PDb4BoNsaMwqFSfVBeYQA2BQnMUYpYFNdc6KmhYvWNer6WWzqSYNS0ZHMbftDtKWoHc+qygD3qyx9T9wh10W5zNLGxOhaw8RTrTYn0FmoQN4DF/re9+K+A8eOggEHEgi2bTjTOoiWVZncg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:47:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:47:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 12/23] xfs_db: Add support to read from external log device
Date:   Fri, 21 Jul 2023 15:15:22 +0530
Message-Id: <20230721094533.1351868-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0034.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::21)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b7e2419-b376-4115-5e66-08db89cf76b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kyoaXYFSm+zES/SwlUbmU47u+WjI0X9WqgJp9yQQa26Yx/KuUTkTV2qA/SZs4kFOW0BcUzNp4XNrVUselFkBCzgkCyEycDD7uz4I48L2PvLJswMTBSiNrN1z19ctF1ZCKi2RGOFjITn2gI2TRRjf70DMXnynpUlL+n1O8QvRXtnLn5p4WfWZcrI940Nz1/IafiNFujtmo8DQ0Tpp+Mj3SWt5HclvPDupZ7EKAZtvjBNAm+FhYNlOc47Li3uzMBuZ9QAPpIeNasfk7hdNfK52aqW65iQEW/TMSiv7UiSU4mzlGO01vuk9Sz64+a1Tloll8s0LfDvCzbwQ1FwYcsTbVcaeLNad9TROj8uVdzWI1CX8TTGL4QvjPwI33Da3GywbdMrmlWed3PwSnAZXZVYvz4TjTrOlbowWf/S/d8paXpyQwn0atkctSQEG8hHF/Jou8TsKZI9LwyC8X5N+zegnzcBUEvk/v4cPYq6TodV7IfRDmR+CUO4W5LEbhzDgn3TuSyxSEIWQa5ZRmIAEUhNmMCfG16YYmW1Jfk8T9qR+ZaQgskv9poZ+x2GyMlMb6HQl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NSM/aF6E3eCkGU1jYDBnjeQmnOWU6nCeqcB0BxWvj4Bu8UteNDCxNFNUxsJ5?=
 =?us-ascii?Q?4eaqxnoy+zLlR9PTAnNuzXkpgvDUHhF93+CoH8DJk3Dy15NiidYTZDIsj6Qn?=
 =?us-ascii?Q?inH6xk/x3Ow9NLFg9tPEalMsriO40wqT/6mzc6HyfANc09NlP/olqG/SC6kI?=
 =?us-ascii?Q?6tFiS/Lr/McQrOhzuzN7Q+F70uYVVFXaUB9nJ3ze80JVEDbBEihdzR385hB+?=
 =?us-ascii?Q?7qsr/LvuC9yCKaskOuzpRahe9JOszONI7gi9smk931jQygW3adEbJB9k7vPF?=
 =?us-ascii?Q?fKs5J4OjlsXpqoc7vDS2xpQS5KJzavbzSmUGk1aXFSVxJ/QWlc2atN7XjJDK?=
 =?us-ascii?Q?5OMuK/hiaNUuJEzbgYgZzLVdwhKc8zIvobGzolc1vLOKpoLUS+jI0qBms0P5?=
 =?us-ascii?Q?zEVXtX1iWEPImeZwA0slbUKlrCFQXKvOaQDwpWPqiYI4jK24yKFeVf04AzVq?=
 =?us-ascii?Q?71gKF72tRbKu6GiHJaY3XUl2s38vwrAkBKWXBDqzCg2DhoeZOEmbsoE6m/E7?=
 =?us-ascii?Q?eVeQzUb5XieZgxSPGwclqnJZZP9K19N0o0P9hbyyG2JGDo4XrWD1mydPm931?=
 =?us-ascii?Q?jDZgevPppwpFS9KuZyK6R1hZjf6+HAlWEwzu/n2cu+RPFsqF+rZYK+4lWxQd?=
 =?us-ascii?Q?pKfqeTbkKAW7rb25CqOIC4gnX9FZQsw+C9jMpGdz/E7n/aFhGr2xkklxgjFB?=
 =?us-ascii?Q?O7D95xjgbLy5Ubbfa3XcSwlj9uDvhJha5SRz7oD7K638BUQ7xJT2pbbyylSn?=
 =?us-ascii?Q?iec2R7gnBV4mO0qDppakexpRT8eV0Ln5JTHLlZriOF5tR8xGsuBeI/qnBwSX?=
 =?us-ascii?Q?+FH6guGOAGvflON+n1wR3QupQYhSoPsBLf3rWFfvL9ljCY1JPwWDmsZzQveQ?=
 =?us-ascii?Q?fPoeTNIHsI6P3HIFDnFxycCwL4tieGO3KfyZk3RRlrpMpoelbObWrPCYi9u5?=
 =?us-ascii?Q?a7s/ZfYhCLbU1UwZqSWpPxPAspFKKD5ae8UefXfBtdVa10Qm4g7hoCQK0Tjj?=
 =?us-ascii?Q?bonBVjwKOr6D1ckF8dUzcXwvkjOVzHc74v9B2HPCWnio23SfWyX4qBzuY9Tr?=
 =?us-ascii?Q?wSK//ocgQk/bYNKjlfgNSt90qytM2dvrgVgh7+nb5raPp9DNyiZB2nbnrtA7?=
 =?us-ascii?Q?XTX6n4kkzX5lbAJoDXB4q0Exd1+od03G9LkbV9Ktsa0o5eoeos6D7H1snncZ?=
 =?us-ascii?Q?rgtkBP+2G/xIMQTWxwPwKQliX4Vvceht4YQBaxUIcB0VU6bjsE0s5V4MShIg?=
 =?us-ascii?Q?7uQedv0Vm/KillKMc1WtBWILXShaTt3/9mytDE60aOdWQStVL5+BSFZU3lJE?=
 =?us-ascii?Q?ttmRtH9RCtUz2wcIHJvRaUeco8vx9a6EpV0fqH3xORFr4u0aihxcmvWrIT2e?=
 =?us-ascii?Q?36mGGMJSUG5baQmXxuZ+2w3V0g2ZdjOomVTblp0RnkiBXpBWXQPA0zy3ixAs?=
 =?us-ascii?Q?F36zhao0q/GHGDD6nSkAlifMLHTVLuq7v+Rylzt9Foep1IessAGlTFB/xZsu?=
 =?us-ascii?Q?RGHh4pc+0T45BGEzpS4EO5G63dRyQJ2sllEy0OCEuL+4Ki8G68zb335gAuJo?=
 =?us-ascii?Q?lf//bfbVZEIQjyAoAuVZx7kHd2HhXh1Jd4SxQUXiDEH0pce9PiG32yRVfA1m?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Y9CLUAgISHaRR2IcShkp6GaifjFyVNLuYGKcehB8hRjKv4IwrCkaKJU4r9+u4PmLCpIDDYmLy78D/2eVWJFPlDgQpK18oA1F9p7waFA6PtO6cKhTu8v70UfrxCbt656dsFwEm3qMYxOqbWSekHgVP7EQwoeMPaH7G5y9bDCVm97MRjyR2xZbnIAomDkdZjIa/3tt4wWzuXVMFIa8b+eumAS2hvya2zwBsCF48sK933kkMV0h5pLEGdUomKAD2sHVKd+2kct2T5C868gwH2ULjiRl8QuYu7Dxwz7tUGPXvFs0a2J7Yht3HLCOa5H/SM59JMqjkC1n/k2PUkkNLtuNJ3Uv7aPq0QeH77MUYAw/iFJZIJUuZzkD89LyqFTvVtTM8Ie0kkAWKpHyXHNBFIBzgYWI+7fcf4pWitQnU6A7M2hWEmnPu5m1hTPq/QSy2XRA/cJt4Xqh4RNFKxILGBqZ5hn7y2StTTKnwDN7xrT6+fvg+OFFoj2GjD6XJ45IUly7L9YhaEAhUtvMdI8QgQfZxOA4XSV/Vfinr7AbVY8Kiz+oKPLud9V//3Y9gCkwPS33veSLU3UddWbsuvAXOScBuwbb/hToCgsTK/3RpS1OAwI4lYkp0Q9gfI/YR/2fmqMry4QpR0pKEXnrxtE5wl+VbipPv49eQgfVnJc09fPfnN3GBhdG7eRrsBzUs4RDtcM/EMG6tF+0H9+pc6aM4LkldCi4Sz7e3jjbMWA+rnewwbW8T9ipst9navBncrB+h/DFl0CSt1UlQBgze4c79tsu+ISWE/Lme1VE7LWWOk3RFo4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7e2419-b376-4115-5e66-08db89cf76b6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:47:14.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZEqVDi0W0AB9fu8UbsQSGNnFdB1GWSNBuUYMcjQbOJP0P62yAtkqVWj1ZjgtaPzfGW5p6dcQCGVCZxBXf0z7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: j817lKNbrJ4J9yqulf0Ho0P4wFKsAuxe
X-Proofpoint-ORIG-GUID: j817lKNbrJ4J9yqulf0Ho0P4wFKsAuxe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a new function set_log_cur() allowing xfs_db to read
from an external log device. This is required by a future commit which will
add the ability to dump metadata from external log devices.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 db/io.h |  2 ++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d257236..5ccfe3b5 100644
--- a/db/io.c
+++ b/db/io.c
@@ -508,18 +508,19 @@ write_cur(void)
 
 }
 
-void
-set_cur(
-	const typ_t	*type,
-	xfs_daddr_t	blknum,
-	int		len,
-	int		ring_flag,
-	bbmap_t		*bbmap)
+static void
+__set_cur(
+	struct xfs_buftarg	*btargp,
+	const typ_t		*type,
+	xfs_daddr_t		 blknum,
+	int			 len,
+	int			 ring_flag,
+	bbmap_t			*bbmap)
 {
-	struct xfs_buf	*bp;
-	xfs_ino_t	dirino;
-	xfs_ino_t	ino;
-	uint16_t	mode;
+	struct xfs_buf		*bp;
+	xfs_ino_t		dirino;
+	xfs_ino_t		ino;
+	uint16_t		mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
 	int		error;
 
@@ -548,11 +549,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btargp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btargp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
@@ -589,6 +590,35 @@ set_cur(
 		ring_add();
 }
 
+void
+set_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+void
+set_log_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+		fprintf(stderr, "no external log specified\n");
+		exitcode = 1;
+		return;
+	}
+
+	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+
 void
 set_iocur_type(
 	const typ_t	*type)
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
-- 
2.39.1

