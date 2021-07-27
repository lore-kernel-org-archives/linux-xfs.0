Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10278C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F5461009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhG0GVP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2958 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235477AbhG0GVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GBw6024367
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=d1sCAdWBFcGBE05IqsrXgHrGQD/WMlr7Q1eC240FMLw=;
 b=V++TdBeLe8gJLDLOdYITFLBbfCz3uw4Zp8hPtkzg4EwabQ+deCuv9rqtORjD47SNT7TH
 BKEwqc9bM1J6ynFIU/3XY0udLQ3gNi+rPyVTMa9xGX9dRF3RYIha1GJB5WqsEDlkFSI9
 o8vLh7tXebTk7DL0J+Ad4DKTJrGE+JBvsRUdXZsw5OcdgFyL8OipQhkoo9IUBwVVwxL5
 JdkdQxvA1i8CQnRWtHtnltmJ7HY2+6YpjAtjfHmK7EWacjqTSwok57vA7BjHP8lu4nlE
 F0wJZNYfTF/WRZZpSvMyDteA5Fc2RBQoAsEgZIcKWviB0nIvADcyeHRPc7PPPTaP/VAK VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=d1sCAdWBFcGBE05IqsrXgHrGQD/WMlr7Q1eC240FMLw=;
 b=vydoD2+3m2y8jzWGNQw7nh1QjaQ8qdlS+a8sCN3tAqdE5/rynDlrTL6qgIYbxXW7NSki
 ZYPiYJQpxygAWkEXqvt863OModJp/ehjnqlUow6C4fh3NpCmkX/Y2BWztyHH4/pDBC/t
 2CNq5zn1raTlrLdLzqKlkJg6DP8H/SqdgDlVsIuJh1GnLf7idKSDmE/SD0aBIXS6rnO5
 7i0s9EOq+sknulQFhRNxlYIHf3dCTiwyi8HnBPB0mIsNS9qxB5gu/jscFgkldZnb516B
 f9qF/zf4iy9tRW6mjgr4I3C1HxQE9YhM6clMf7NnCkDP2B4lhhTLZ1gLTbBREsoMTqWH Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drupv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUt4019936
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3a2347k08d-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3Dh52OZBJWgM657rC4YiI0LrJRM5Kreq7aAaVDQI6YXvXYuxfzp28v+6vYOKPdbngifAsgTMn/3nuJTUU/duBCsHvzUox2S19vpxjzt2JpFTQQuggb8X7j4rEeLRPRztYpvPftpLQ87Mm3BiLL0YUUNBcKshUbWDyi2MCjAAvXN9iikogCDkp9/y1exf/uya4uHWN1uBISQsLMiWSQHfJGMQtUv1PiFIM6DiAdUqYXy/Xq5MjUmodYi+tdTjJg7hP3y+5KshypbluNc7q1FjdJ3yJL3XiV0+uhBoKNgFMt7yHa1G1ajzB8w7SfuBMvLn5T975a99AClkj6yc3iDeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1sCAdWBFcGBE05IqsrXgHrGQD/WMlr7Q1eC240FMLw=;
 b=U3WMmWhtsQnA97hRRcye8Eu7zFGicp5fuTOAQIpt3u/ioQo2BuH2bybBNoM4nty28uB6dCwzedJAonstYnG6hMlMWSQw28keoq2iQKCYCd3gUKLyB3BiV1Eo8L47olcPYQKHXcAJNiLIe1X41bx+mVeyCxNMJxN/IPt8+fZU4Xhr9tzJrRjcPqpkwikl+UaEwSvcfhrBc0ranJzynlFpK4TXlF6xfSv+FwKXD9KNcNAo80lxFfY8jC2qX6si4h9W6m7Sal4NTXMCfd+VwiER0FW0dMmO08RyPDQOeizSOWHlYulgLl9LAfkSbMzXKc5eO7VKYgjsU0l2Z2/eZ/PAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1sCAdWBFcGBE05IqsrXgHrGQD/WMlr7Q1eC240FMLw=;
 b=h17FH4zzX7c7NZIOxLo9cAg7BxGyJWo6iv8YoVzdJOmwwq7pYx2uaEBs7/s0SE55CvEF4Rg5eMnWTeYEO13njrt95oe1aNE7EhFLL9RcIXlA6Ll9iDoMggEtfe24Wwn3n5E8rxLGz8roY6ELTph2Q1Wr8HzYTos0ReD3wXGuUfA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2647.namprd10.prod.outlook.com (2603:10b6:a02:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 04/16] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Mon, 26 Jul 2021 23:20:41 -0700
Message-Id: <20210727062053.11129-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f195aee-0a65-4f97-8194-08d950c6b965
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB26478868B794AA241D1A135795E99@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EvwFZCLNhLnYz69YgPAmg8Vvrnu1JkbKuosbAdKuHRKQuQuh+y6bpe5DTegPqhj0gg81Sy0sF0/q9x8jNmDvIbu3e2IlWUISIaNU+lnqoM8ANgtKI5c1o/VRQI8Lh3CDo4c4g0pKxaW30ZvUQxHiYtQx//31Ir31QGnX+BU/jednpHCj5kiC84png1GLkgG2jW5u+vvXmi7946fQAQXHWenMUNVuEiIsZm+cFgTk0TRSljdARSGt3HxFooLtl3NY/5B/tNHAi9jqAF0A/JKidRY42jZNTEvCSIMGNUcVab4WdJ7WhaJXRwdhou0pmvFZQnySYYn29i0HE8214KqOh2H/mBecevJkXCwt7Yj4Rnz0KTYrHQnX+2dLLBWZDoBsE+kNJ0xfXoUDP8DqicBf90gv8ElKCuKuyLu4xCMsMJQS0S89ci9XWFPb/0lI431Fjlx6qUF6Qe/FnnwMCzw7aMTldd7AlRhl+vumk6IJmNmLPURfOD6HZ+oiDl7HBst2bACUOnu2HNMMevFEvtMWJgtUnaKAVS2P/VRoWcEQjPs3YRdb0ispWMQNPX0xFF2oipiFW01fQr7aK/P0O6G/L0O7T7vqHjw24VjLnSelRAw3gxpD9a9Oiu33yE73md+mZZk7KSb7dVBngI0KoYWdNgnv1iz/RjMz0RsGJcOWWuNw8Bt5pBbtybaeybZqbH/aBQFWW3VZHslWR/h2FGQLZx2riBObuRzxmjLE5yYldcJq7x16AYLt+14MsrOSmz4UPxC35WbF6sQNpqWX1/3rkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(2906002)(6666004)(316002)(38100700002)(52116002)(5660300002)(36756003)(86362001)(8676002)(38350700002)(6916009)(44832011)(83380400001)(26005)(8936002)(6486002)(478600001)(6506007)(1076003)(186003)(2616005)(66556008)(956004)(66476007)(66946007)(6512007)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cFK1w+bYAXUtowayAYsj7oLPvGxD3VqTixCAeRRK8oZke6B6pUGWUO8kscZZ?=
 =?us-ascii?Q?h5DQhruXfSPkhruofgMUliCsnjzJBU50sSTfaEttWlwxIs87aFXNZL+e2mTw?=
 =?us-ascii?Q?r494/dt2BqAxrQ5UN8icWcvb+FQ5vGtK04/uu/5tpA2/ud/BW0T37Ps7s/i4?=
 =?us-ascii?Q?r6qxZ6YICMytWtYvjA6Kz7lsDpXg9zDtFGN45T8WKH4E2Yuu7NUv+SrbaHFu?=
 =?us-ascii?Q?sRysk+9/bLHbCMXlceFbOHW2hKvUUyqveZlFMUJyJB24YayeTIG0g2FScxjV?=
 =?us-ascii?Q?Z+D2Q8robKWsBwPeU/ULkpEtp+8EYJ8A6WHGryWLVpMUuNG7gZtIZ2qMwDd5?=
 =?us-ascii?Q?5XElMd2uPCMVwXe2vEL6yku66YMAjUq/gb9GmT7NHEDCV8HFnYj/M0p67Juo?=
 =?us-ascii?Q?ieZ+KWKoSOqK7XQ1mKAqTjSFwRZCmP9QL2ckFKHo8pwH+LCrMBn7avzHBaGH?=
 =?us-ascii?Q?6IrRzS28KRwg6JktAgMLFncJp4ppa7S074rSv3obT/XbyN73iy9yG6OshZEP?=
 =?us-ascii?Q?VwFhWxSuyYzg9KXvYpjcesu65RFc7toQjmAOPUAaSYl8CSnJmklEuOVnmtr3?=
 =?us-ascii?Q?iA/3o0cvIdiy3jzM80UOoZKSLWGnW2wQOqUY8n+8Jkum4gOaQj9umFViGBeH?=
 =?us-ascii?Q?9f9WbnQJcOu8Z31kKdtz6O10WxXFg5rAczXRFO1SaZgq+mX1f9WsmOBUDjB9?=
 =?us-ascii?Q?nqdDRHAwnoLASDnpqLqoAjRaujrTkcr/WRe/T+RivtltkAzVdCU9qtaaRPzH?=
 =?us-ascii?Q?X9tn1W7mRPmLugWihonkTkYE5KV+31V3dql6cXn6lbUk0Kx5nsoDEkV0iYEw?=
 =?us-ascii?Q?qkHstciRrweA714I7ClJ/17dwlK10p84qsRCeZ++FK02tbn/mnjVb+N7LLfs?=
 =?us-ascii?Q?DvUsRY+Kob/OtUbmWWhbrUkOINq2at3cDJWOomg+X3C48RyXzExaRNC9Ty9j?=
 =?us-ascii?Q?kAVCJ5BGm2XnrWPPAcBiM0o4LgqY1XIXHs5dyXhmkYhlU37jJsPm6CNG+7d+?=
 =?us-ascii?Q?KUFJ1Xhz+egUfmkQM4qU68p/wTo5jY1ruS51N0wHmf8I/tVckWN/A4NrvSjI?=
 =?us-ascii?Q?WMZ+MpP+mE0uF45HorGD75q/o+SC2sgIXgekmIXkUZPl7tbcnVTja4Ofrq7p?=
 =?us-ascii?Q?UhSA1c8E0tjmV5AQNLr/Qu7xSU9HhEqDc8Vmk6zHVROVP/mSWiWZiyRGqjpH?=
 =?us-ascii?Q?HT+17n1vxayVTqUwImY/jkuuCAv4INZRss1qH5IuxZY27w5iNX+TSoNrjLNa?=
 =?us-ascii?Q?sThtYa9rl4sjdI3RE0LC7Yv6PtyzIiFNz1gX7vMIkCbTZQzW2XhJ3JZJH+iL?=
 =?us-ascii?Q?fPHmyZ7Bbfghdpe/BbLNnKOd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f195aee-0a65-4f97-8194-08d950c6b965
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:09.5482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JUVuAYswZRRCTaG4RJKyXqj6v0l8aBKEYjsSHRGwsLzypCuoPs0hhKozjCHG1EMliIFuBh24ZawtmnzAZ+q3nmErxnYC2i/wGEAfX/y/6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: V1e2dJVFKYvUuMPH2Wgsb-6IRXVQOjBX
X-Proofpoint-ORIG-GUID: V1e2dJVFKYvUuMPH2Wgsb-6IRXVQOjBX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that neither rmtblkno or rmtblkno2 are set, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d9d7d51..5040fc1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -409,6 +409,13 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno && !args->rmtblkno2)
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		return -EAGAIN;
-- 
2.7.4

