Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADFDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347248AbiAUFVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16114 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348649AbiAUFVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:21:08 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L043Ox017784;
        Fri, 21 Jan 2022 05:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=qn5WXgegbVLOqyHnYSHKddpGLoiQEXKGO1kzs0FbasgPXsTijn4g64qcrtGNFUAcWOfv
 Wva8o/x0s6kcfFVYJ1NBrNmQsB0jnSb2I3sXSZGkV4B/2/qipciW0Zo54yRtyT3vqSMN
 2McSpaxBRvPnUKL0wdFTD9OG2ak/i/bGprKEfo65htSs9Xv1w54UVkpbdIlOIb+M0/Ce
 8NEaMHug40sKZwrDdTafBFJ3IZQyuM1LFaynWGDFURJkHpsUkWWMRspdSS1GXUZLO439
 Lr7127FYFRrxtIscbf4q44tvxO+EZl1U22gSSrlbdnuE1P3RHgw4m1I+lwRkjVJ8yQmv vQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhyc0d45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KAFt170203;
        Fri, 21 Jan 2022 05:21:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3020.oracle.com with ESMTP id 3dqj0mawpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ6V/g6yYjerIuXM72wzsd1rMI1rmNdE6rZRR7s8SwIMKlv23jGLsXQcQ2/UyTgF2cuSn3aoNgYGgEeAjojHZBj8UGW0Eh/6UrV4UIHpVIKLCkH3MMlal3cOCffxtKcCM2hQNDSheGTFiyRRmutZ7fMdgzKBxOqaDQ1qzX+AEEveFNq38ladd/y222NEVEr4cWOB8/uv23SfYmuf7UIG9/v+L4634MDWmaKykQ/sS4Ke8s1VrX/itLUSuR1kMznGpqiE/gQfndrA+A5m1qMSh4t1jhRzPb9awtQZx1stMMiF7yuxp75SbQwWDqUKDzAOJKNiIHoUuCg+QjMGFuNR0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=MnFMEYPgB2k0wyu5Pr4ccrReNwPVYSOqE3hVUYdkQTVyYJJHsyhEVZ9OsQFJcWFCTlXSZ1S0ln+T4q4WpOkqgbNE50/NeW147Pr6Uz/YOthNxsbpgdvMn8bq7I1NVWc7x3//EciXhF3mYLpLoK49UIrTxBzZqJ/9CwTo+d9J0LrLENwxifyl5VqQWecSSsuTYD0GEjfxIHdyNb7Iw8WiHkVLQ47AAkSleRQjELBFapgDuwH9ioNns6VQ5Mp4xBPNgXOV72LbQA6mbmQ5cjE5uuLT/GEI0n6kih/Fuci5M7xc+UmObe/FZ2y04bXbAu2KeFI6P4zl71fiTBCkRnokpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVPwax96ToO0SjPGa+LWZoYm7AYQ1hXnJPj4S/mPhFE=;
 b=h/KRUIW7GDYTg6EgWsRt7amX8b9bFV8WWg8iJLCema78mX9LKJpIxHGEzIOmtsL0SIEi6E5w9uyI36rE0F6zp9AXs+ha/z9aRqkALnAECfFJin35hClMgN+Wr1a8kioVhKRsKWP2RDJVJ3Byx71s0SlplXM+QiWZoWJKu4zevw0=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 05:21:02 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:21:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 11/20] xfsprogs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Fri, 21 Jan 2022 10:50:10 +0530
Message-Id: <20220121052019.224605-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1c0970c-6f0a-413f-107c-08d9dc9dd0e9
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB53226907BB69102C4796603DF65B9@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNWrMcFiyCgs6jA8AeCEhFpdQUa5PDdSZ+wDcC9v9dbvzvPsJdWyTbXHxtrPw30odTi/uOhKWRgX8rjQHFD7g57wtXUBRRAESTIpHTslQqOTPtkRPKjr/jDcou1IAJ9SBNDGeFM+DkyhWlW1MNg3zlBRIgBBTn6kmkUEFlZjlO51m/G5VM+mdi9Kb1co6xyL7CJV9UX7dplC/kV86uSovuQr6vQUFH/lB9trGn84KSOzoCbiSWBkeZfeQXRnceUzA0LHTy7n52TJLqqy5k8HNssLyTK6wleyPC3eadsVk+01rj6u90OxDYn8EXTQCoQL0QjvP5yId5wqCfeNWuNUfyofetD9M6qQuhRbILpsvT3cKEUSmUSN9tyLnwWK42fvvk4fFhnLuBFK6EpKNTsW1+6Ggjvrg9H81ruTcURTJKzu0ZWHQfCUgvOt1Cyenhvq53y1/QANO+2LVe4/cG7w6kn2Zg1hwzWuKqkR3NpWI703qQgl56iB5kEq0Bs24zy5P3x6SZT6DQtRGeAmQjmJF7MJDcJebXsIEvTBM3WGUr9M1v4ou9Wza6DctrheJG1K+nHfwJOvQyvKpvJSpYHajzwxqbHrSB3oz7WQI7gtxQfTN16opyT5s7Ys53OYGyzi6G2Hd4zlUJJ74+ca4PtIdJHIhi2jTpi/ys87/7gpVEBHv1rQ8pU0JAC1qk6evLHfPonES31nK2GcMwekpi6bRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(4326008)(316002)(8936002)(36756003)(38350700002)(38100700002)(6916009)(1076003)(2906002)(508600001)(6506007)(66946007)(66556008)(66476007)(83380400001)(5660300002)(6512007)(8676002)(6486002)(86362001)(52116002)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhgrsVBFjog4SKMeRqqVnvWs2iF4WxnagiWO/i5TLbsgezgpf7hEh7143CCM?=
 =?us-ascii?Q?behEw9KY8aWTqb5sYuNsTM1KMKZykdOzL2Um/cxGJ9JBPa2pFUTBRqmLPJJF?=
 =?us-ascii?Q?taVgwIf346o6+NZxubgiOJFxEpb3IdGa674sj9imSWJduRsX1kL7pApWsMEw?=
 =?us-ascii?Q?2gp8VtO5OIfcl7pvyOXT4slJp9VTebAyaEqHQo1ihnvnfGA6tpL178zV8so+?=
 =?us-ascii?Q?27yZH+6szDJCFFCiPBgOeGjGa4NRICD2yP4CfbxxkBvRFvA4R/IKvdwanEns?=
 =?us-ascii?Q?PWEbAQ5t1iOoIzVd5ZnJvk1SzZuOBpswJidWPdGKqMQNUFc2lOWAH+w48yg6?=
 =?us-ascii?Q?f2suSrpO5x/UQWtgNKkKoxra2AAdnxbmGEAI6LdlYeXPraKOw67Mg1Qwh0wa?=
 =?us-ascii?Q?UIRV1Ctgy2KkbGEca9NN3ZIwhrNIrMWGmgkTYgTsjUfLXY7WemBWL7JPcWyk?=
 =?us-ascii?Q?3xaYEk9Kc1Ywz++aW48kzT18KCplLGx/xkUx9TtGbkPS4TYFxwQ8fTDjpOMT?=
 =?us-ascii?Q?ATkghOOVWw2UxwJFiNHGmAQDl7o3u63mNzJMR+MaTIlrM9zXu04OIh0l+hgl?=
 =?us-ascii?Q?df/+o5yYTpjz9cVA9M/AY6XaChFzEwKttLwsrHOtJiGaS+fmFep1ZSYEXBs0?=
 =?us-ascii?Q?ANfFgQjO5HaVMwna1D7k1dOfPJXDbFNAwzS0WoCPkckUCG9BofHRFl7j1XdW?=
 =?us-ascii?Q?G4S0Sdlc/EFfp73Mqu1cbQQe17a6kbngRav946LozOHJ/FgqdKq55+10fzj5?=
 =?us-ascii?Q?LdYtWE2C+I3whMsJxMX5CJJa6bZ8IHmWYH1LjTcDY9zdSwMeRcic19icrmWl?=
 =?us-ascii?Q?KVexmONlrTO31BJF+Sc6KctEq/jCpKmoFu5NF0idh8rGmfPFAJu5I17xRZh/?=
 =?us-ascii?Q?fSD2D+r3AE5HTJs7D76WE+v3NrC12tAlmVPQYwxCIt+kc+nqTxpk6Ea2VAIP?=
 =?us-ascii?Q?C0R/5ODlPg/VoqHYAjEJ7gCQWpAvJiSsQkHsYXRLU05hCVxaUYiU78tfwpcM?=
 =?us-ascii?Q?IxmNrOql9bJhL1HdJphJYktWXwXkuxTU3DFU8WHthhbQ2yOtE0uBJwOWXOFY?=
 =?us-ascii?Q?aaed5PnAoEe8KlipMxpWSq/Zr+lRojIjurwZhEwyGqK9Z7j73IgOt8tK38VP?=
 =?us-ascii?Q?dtUxH+PcZrogYnTPf7hUYuvG4/lhjm7faf/XtqsYSULc1xriraruM9iLtwxt?=
 =?us-ascii?Q?tVOL43y/bNLCo8pwppxFVYYbPBMSC1ozNgm8JS5eImjvsD2iuXsbVTP+/cff?=
 =?us-ascii?Q?5djbZYFJJCVN7ZLRYsulTWNQ9BQmyWdP+EZf5LGzwy5xiDGxp1EpfEUwkkwW?=
 =?us-ascii?Q?0yJxYfmp+iyJaDVWO2LPg+6NrzEcHUAeaxsQ4U1OJCwlvcMohA4jWSLyjnp5?=
 =?us-ascii?Q?1fskm6S90ruaKHyrQ0O+r4oD9vLrtg7AhvwG/K+8yQpbFxjHS7TUAZsS2/VM?=
 =?us-ascii?Q?KCRUrhPMJcjNNBcA4Pf2MeK+T4NGbg0soVKuFhvjtKZZ9xS6m5yOcN4oX5Aa?=
 =?us-ascii?Q?UlfbY8PTLV0yzWYw9pkoScOrtrMblvNsDe5h35N9eM+K1MILUzT/7OKaTUJ+?=
 =?us-ascii?Q?8+kVaB/AN5RY5UIdzdiIKvMu5oBkZZlU08eLeFOqcGVdWPTnsnI01cBqwBa2?=
 =?us-ascii?Q?tFbgl6kfByPzfvH+RtuJKNg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c0970c-6f0a-413f-107c-08d9dc9dd0e9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:21:02.5359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3UrwRl6e0U4VmwB3cI9CI9QtoWBwjFLrJhOOayd5y1cQQT5wBvxE3jXhHkvjaVJ8nCYIAbzRJuioR65bN2a4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210038
X-Proofpoint-ORIG-GUID: -aLo6QxF62abLFPanh_dS-VuA7KjVR-N
X-Proofpoint-GUID: -aLo6QxF62abLFPanh_dS-VuA7KjVR-N
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 42694956..51e9b6ce 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -46,8 +46,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

