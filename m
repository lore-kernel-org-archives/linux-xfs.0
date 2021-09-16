Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69316C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5AD60EB6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbhIPKIl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43312 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235287AbhIPKIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:40 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xufN030707;
        Thu, 16 Sep 2021 10:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dOgoxV2HmK9w65+TMPFtmO3rEYaIuBbWlmVcmi/EpAI=;
 b=TarBAthfkYFZ6m9EPN/na0KIeIq+KV1lUVzevTtff00T/wqJgtVy1/w9SwLRbgyzC6MX
 2ql609TYmy+j8fJrsgH4l277hLeSMtnl6nGwbQepKe6awHt1xxXq/WkXSk12fAUmqDNJ
 Plei34pUzByLIr6RbvqHlDMkskIs6xto+4WmG8Cv9Vr3djIt9BQ4T908QsQ/rA7RadMo
 LhLw7V4bJLLimQ/377RWAEi6dVQeYEPgCKGpiMuHBTqSdLBQBhDa03Y9MEOLKFqKuBC3
 4aGTZqvYdVXHhq/bXXZVFMJjoqXFwH0vv7xLoj6Kt59o66FMX0IXf86F5dQgFJQN4OMa Xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=dOgoxV2HmK9w65+TMPFtmO3rEYaIuBbWlmVcmi/EpAI=;
 b=SwK7Rp+1GCva8t0Oj1E7RGYsET0EDuZ+ZS7+EzhofmLN1B3qHnCzFGs9w8hgLAsCh2gc
 2xi3qhEpH4MNYnZ8oemw0COeZMOh91t2bfDHv2F7zBlbTtkJlPjbM0Q1ZktoEnkSImqh
 bF2xS9Ive6lHmowezc45UXiKB3+PFYj2PswABr3QYwNhGy87QOzN1ihLHVeHfS6ZIBFu
 gUu0E/u3d1bB89aZ/ehFLZAZL7t5ou0uJdmKsU3wA2QQbAe2FYdD8Nlw82JZXnpC7P7s
 1xwDgjrA0UDVvqEIWjeGaTCqWV2uk4OtGn1MNCqsKMnYDOqul3p+iAhw6la0Jfcrww4X bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhsbgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5J1R031124;
        Thu, 16 Sep 2021 10:07:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3b0hjxybhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yc3vXnrvyR3A6C+yY56hSopaWJvsVOW6Ch6nAU2Qc6zFHR0lEH37DLB21NmE2JgeLSj2+r7uacNVIp4nb5ilKm+5IZNMTu7ogMK+TCzER442E+b284KmrIifWf7bGGYVv17iMtXpBED+nP5YRN0YzKZ2A9CugaNIzy9m7hjhtl7ZJZhA6n+06Zy/tuIOXOE8iuh6ONyNNdcZ1g9L6C5QXSbB8Gf69vZd4t5Pjub1hAnKn5+xXvA2Ch1w8y3S7u3KCwFjxjJq6r9Apxtk3wqQ2d+dIpF34gTu/umSQRnorxKfegmvwbrffjs0lkwSHrgm5GnN2s5jWAtzS7f5SjHksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dOgoxV2HmK9w65+TMPFtmO3rEYaIuBbWlmVcmi/EpAI=;
 b=faJyA4q5vtFvCwvh7xUCqHL687+9aKLiYs5H42VFG645WQuUOHCsFe/N3egM74Mp/nW015PKVq6uBG3Sq+vah4O0kkbhfXP7DcwrsApLYqjKMNcrsv64AlfdiJlzsrPzC9jbrkomYBFZrP2xOGm6S5AXrXvO0XlKaC+Wk+5ry/NT53IzRgEu4k+uHNBkioP76rlNGmIbXsV5KJDfJIGLV4BB3AoB1QVG0vIo142yuTuSodxI+08QBmsBkOGLK6I03h/24cug6q9DostdwTc808KHpqv4xCRmGTdUHfq9vU2D//17UogcFkOAIGmlAs0Y0KmgaTtYVvM6CcMuIT3IBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOgoxV2HmK9w65+TMPFtmO3rEYaIuBbWlmVcmi/EpAI=;
 b=nNB+yWtlRigGSgXe0f7fd9qOeDiSXzMSOTuafZa1SYrzfxSW/pBSvSttkGUvt6EAi9422Aawy+Pf12f2Y7e+5pZZPWedx0N7DaIaar65vQXPsq1ZlqRzoFPMvE5epKfv1bSMnScMFrSqcDz+2Ick7dZAkViiy8t92iNuLwqvE0w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4505.namprd10.prod.outlook.com (2603:10b6:806:112::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:07:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 01/12] xfs: Move extent count limits to xfs_format.h
Date:   Thu, 16 Sep 2021 15:36:36 +0530
Message-Id: <20210916100647.176018-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d705c502-789d-4114-3401-08d978f9c2f0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4505:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB450578D4D15ADF8906154F96F6DC9@SA2PR10MB4505.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDcq6YtUwL/G762bhgtwOct87Abv4e/g882VtNKcOs0+58p4W1S86SF985WiPJ/Siherka/cmEfNOVRjKGhK6pFUSQ38YPKJPDXpzmdSKQyV7IDcB7e+6OhGPsjVrXgGFhozXBKKIqptJq6fu8g6dKAYr/6lsQhmWd+wHBlPOqOvxrh3tuXatT9ClttFLTT8bARbMGjNzDWElRb7RqiUx13KaJPjMIDnWneDOX9Fw0M85em/6mVQm6WIrl7WvKBzGvVJCAK3TFi6f3E6kEywuXjM8NXsehv7Kc57jtKbRc6aX3RdUatABw/+M9oVEPBYlOjdc8M2DqNInnsLiMHUUTgcjMy7h1Eu+Fc9FF/ANf7ZuSlDb7s2kvxjqvUhEX2o8QUqNO2WxmoAxMrqg8hZzziV+2UDAWo7ace4MGJKnObVHQu8WYUu7pfe1kbvkqOQA4dRbahDjQo5Ms33L3O9eTLWU2Qu/JhnIOEzmd/nIHs1MHPIWluvnuI9n2O1PhkNnri2//QeJgovvD4L8MLtsiFow+nZMSAkkAI852r7EwsXtIm25wYktET3tA8pNtTX9pisUogU21IT55xKr6iFYxRynH/s8hIOxcuPu+Pgr3ec5Ppu1z+iKk2mtqP4Cxc1ucipHRDm0muvH1Y61RX05kmeHvQIuJfkZYfW4xHUhGvrz8h2O3ErTrx9VmVd48q7LW88zNR23ojgl5PCPxElKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(478600001)(83380400001)(86362001)(2906002)(6506007)(36756003)(8936002)(8676002)(2616005)(6666004)(186003)(6916009)(52116002)(6486002)(956004)(6512007)(5660300002)(316002)(4326008)(1076003)(66476007)(66556008)(26005)(66946007)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ox52AKYswyDzI2M91o6GEsuMdZXdYrQ/fuxRZcjSWdB1fbTG3tPz+N6GB05?=
 =?us-ascii?Q?LhJpd7C6af71gHoGySyPguzBBQlVbZWVKU6pchLEinxz7QP4eiAiFemH7V4z?=
 =?us-ascii?Q?LnnF2CJvrHBGv2ofMXnuwulJ7mOEjqA6QFcc3DbS+a7YQDIBw0G9vJLhfuU2?=
 =?us-ascii?Q?aaehgjqnflzqJ47YUgmHg4MzeM6nvfhfUExwDS7k/jqNBI5SnTV5rLqLTF57?=
 =?us-ascii?Q?ONo7Xaq+vVyTHzGIDd6Cq4bYfhqQSHVACwiv9EGux1GnolpCqolp/ND3xZpC?=
 =?us-ascii?Q?uj6AspOPAyGbrkEbo9eH4hkHmSxz66CsinEdlTicl/TuHkczzpFClqH8eo8+?=
 =?us-ascii?Q?WSo71tXZS1PG5Ig1uJxMtEZVfAXsYk0nlddrnQSIYa9nlPusgqlA/J+lzjQm?=
 =?us-ascii?Q?xMzB7zBvCEHtcSFyOf5h73nQQDZI7tA2mlDmHf3MzvpjpLh38/374cVtIilI?=
 =?us-ascii?Q?fvaBMjjshOLMOB+AymBqoPwyhn9Rwc47CfvKfo9Hhu3k+HCG9OeTmp3Xe+NN?=
 =?us-ascii?Q?cVpY+kGbPNrFye1VGIO1+j1hPIImLwVwY5fOcdPPiBofp2sMIMYFQFOtdS+S?=
 =?us-ascii?Q?U3/kPNRxKi/ZEv5cAosyRoOY70ioTEWcEI6oVWpp0IzoZqEdQ7hkdZ6/pbvG?=
 =?us-ascii?Q?ks6y1Tcf87+wOGTezXbBvkPfzm7v+pgFveU7edQqkwS3kWxi2Otc3lEVNdJS?=
 =?us-ascii?Q?G1+tHLAxcHVh3Au7D4TSwSgsl9yKEtMsFxfFdS6vWpl3d8oHKU5h2de4a0Ym?=
 =?us-ascii?Q?FX77/oog4V0QS6CqL2MzGf1lAgC9SB3qcNlFqeYsQMMIo0J/wPIj6r4AKDfh?=
 =?us-ascii?Q?LXmaHXvGv3JY+9dpiMXmqB411dhdVzQxP3FMtr/5J37i0dsp99gSlJ2HXMJG?=
 =?us-ascii?Q?LXFFFLWjAjeXEEswNU1nbIOp+7YiIO6RXKFPnvUHWjEbBzpOAhJr0Gz1ar0j?=
 =?us-ascii?Q?1IbQM3saMohcyG8jwA85YRB6r14vo/2DCiisHQIO5lu7UDnPa1V06uF/8cJ6?=
 =?us-ascii?Q?3nYM+GzEp8CtIZyGgykuEgnXf3+B9dZAJ4Rlx1UXWbqjnnQyJp+IY+rDvNin?=
 =?us-ascii?Q?V21TWuH4/oQZqKlhEG2Md0SBaH5Qa6oYiXOXuc6FviekyUFisvV4SkRqS8y6?=
 =?us-ascii?Q?pknYrTernlZKz0SvPt+qt+K8JyXgYkG47ZCuJDUR4euXmpHkslcOj0OmHyBn?=
 =?us-ascii?Q?pV+0TIAXzqDcexqkppGiQykk8jO7tz3sQdRKfKH+7Pa+C9dZtOWKQGV+n2UT?=
 =?us-ascii?Q?8pQxCumR6qouUizEeomHZg75HguI+/Zms4Vzi2kC18inTtOK0gbl3F5IzZ0r?=
 =?us-ascii?Q?Gq+v1JAL8sfafqmsxJn0QNSt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d705c502-789d-4114-3401-08d978f9c2f0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:16.5653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3U7pHpEc2SeqZMubotco1/zsrhYVzNrSi29UzzqP+ymzr8idOmLUjXOzkERBWDsbeIQjjgZo9Zj3otseLUVdfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4505
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: 8pf_4OfSL6WnujRVD0bjKC7lreTW06oF
X-Proofpoint-ORIG-GUID: 8pf_4OfSL6WnujRVD0bjKC7lreTW06oF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0bc5410491ac..bef1727bb182 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,6 +872,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d0afc3d11e37..dbe5bb56f31f 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

