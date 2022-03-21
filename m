Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72945C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiCUFTs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiCUFTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB8533E3B
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KKUL1s014720;
        Mon, 21 Mar 2022 05:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=MPXPEkLq0TRSvvnrqyXT/HhuwZAJcP8Bfbd3K5+eAFcK4WPMpTcnc/3GTQkK1PbIxrVp
 sFnsYo7+yO2NP1vFw23U+9H5ozLoW/4/MzElr+bazzJ/19boJSUAT+iZsP/N2Cd3GeuC
 az1TwwUYqHRlOy2Ya66A6z9Rw82v5fwd+q7bwZGiiOxPX9Fb0k4Anyy3gfDgt7UzF0ak
 KGN+9ADSdeAbSTO/ytlc4q2i+t8+vG9hW4yEWs40JIjBwhRACInfmTmVESsXtJE32ZjK
 +Bs7vWHR7FlZtVhLrDzKDN1FQQIg21EWD2hmHAU8Tfrw93Y9LboeA9gcLomghi5mgAO7 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss23gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5GIHF155800;
        Mon, 21 Mar 2022 05:18:14 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by aserp3020.oracle.com with ESMTP id 3ew70096gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nc0MqkdV0Cb1g9Qg6ZcHBKDjy8P2Zn/aACk+QYTqyeRTpvU1kL93WDDS8KigfArsMKJ/lSaJDMtONTDyrEco6N9RaiBOj3IProQ0W6T90BrtoLHDG9sArd3YB5npzzBlf5sL7nWcEm6OXd1X0xu5NAZqQtoeFfRwTt+ye8WhqqfTWrdX3/hlDtXPRkfcLfnwOxjhcY9CDFGWFB4nTeFHfQ1aZ7cTD5SBleU6Yf4hxyb8FQJkN7ld0Cn63DGBKg6oBsmFCUrG3BLSb/ggA47NEnxzLD3XYSPmdDkWmoTbzbL8FQz3BDsVD2EANkHyTPuC5KIcuWGNF2gVi9zLrcFK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=VX4jiPkoPfpeFp6xSzih4jEVpYlls8IrE3Usq8OjLEk1hahtIxDCkNMDJ59dgB/A7b/3DbzjPf6Oy712U2Ayy4WrNq/LlZ/M2s9SmB09sZXGslCco0SoKqT48VvYzeipfTvU5kmQSPMFAPVXI54Ev7dOVFu/n9cRRPkXASqjnXsn6bEpwdOi90bcUJiXhwnrI/ssjjR5k+FVOuFTFL4zzzuI0Jq4f/tnrkEVZnX2ARXN/spmxApYJQvwjjd9gTOD8x8or872O0tgS5RG4gtQAHWuLfo2I/VOOFz/LcOWKft7DYw/+FcSDKWzfRw8OaYy2JrytYHskKM79YWWsXwpdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7Yt3yFtrQG0i+Xe0ApYS7Wfz2lWrJEMLwKwrrUHkLY=;
 b=G6NMxzLVkYYWELu6INoOF8rH6/MFG8ypFfNr0YllAj9BG4ZC6oFaNgE6mgik6uyR4hO/2Y7QPRLLM2fsW71rgZpz6FuHmOhA/EfP/UH0lIw+LsB0OH5q7IDHwLFniZzg8I2A/InofAnDhlIgpeToAahstq4yOadRF4zdbmXK6Gk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2105.namprd10.prod.outlook.com (2603:10b6:4:2b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 05:18:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 01/19] xfs: Move extent count limits to xfs_format.h
Date:   Mon, 21 Mar 2022 10:47:32 +0530
Message-Id: <20220321051750.400056-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05a1756a-5a47-45a1-97e2-08da0afa3225
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2105:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2105489A2354AE8274980CFFF6169@DM5PR1001MB2105.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qvg3CNUvU0UxBhcGKBeSfwd/kl3+cuSmRuJsZoysKX4iC2eL9EhBo4tDgzroGVLAH/8YORNT4kGqMmzOaTQL+edFZF+w1dEQDTk+o2ZDSzv3mV5eASI12sV65g2PyXWu6ACZeum0BlUQuB/uPM3XBILbsCq/6dMzxWCQUXnJf0FFfl7gOjoAFNNMiEjMelfQ2CR8RkUu/+rt51bXJHEwvH39tyuBGz+edN5/8jNLO3XRzZ0CXr7g5JLn+CeM+l7xaYrS3cSo6s+A5Hxtt/fxnAKoxRwpJ/cu+S2/bfZ0TiUcaRoOBmlUS2/QuhzR0bmDMXAWMBZ8JxmELAR3nRSUX6YLank0Hqi5AOxhCi0oVXew7bog4cKNsu9NFdM5p/cthP2ScS5nIw0iyBOEEm6c9b/D/FauXB2gerq9alDTxL/rY9JPCnjGJRuXNr30lp9HJCeruT+3FWa0P1ns+VZeGDgkZmpGli6nXmUeHlztHADWoQ69KbCDhGoDunMPFSHQZyLg2LfwbUjst2jAT5M6BnQCYF/u0lyGa2ShdB8Bo/mhsiKskNk4yC2r2L9fSYhg8kwaeODKsY5+SbT4H2HMBYOpXxs9+jT8/VD696BYuj0WTvFDtzYxAFehUjGt3PnMa7j7Xu8HLh9+xNOy+s/7z72VJEXq6j/obmnYFRr/0I3ad/T1a0XbBTr0J/KhowxQEt7C4p290Bpum0G28BVBNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(86362001)(8936002)(508600001)(6666004)(186003)(1076003)(26005)(83380400001)(52116002)(2906002)(6506007)(6512007)(2616005)(38350700002)(38100700002)(54906003)(316002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VuLsAf0r1jctJ1CQ8kgyTFZivSrCsAEWW4ig7QogCaxIA+3wSxJWs6I542WM?=
 =?us-ascii?Q?yBByR0XlDDOuBr2QwWPKrwQkskHL/lXVIgfAsvewmtpdwy4a8GLHSQf+MLlA?=
 =?us-ascii?Q?2+wBr8CmD0WLWzE2HvYRV8EO5x4o/u0P5vteyRQeR72EFiORddm1pMiOaPLe?=
 =?us-ascii?Q?HhRW3UfeA0r5rrh0w7bVfbY2E8FUbuqMDrIuDnCo/ZjCHBk2c24isjW+kX9n?=
 =?us-ascii?Q?iDI39lOlBfB1m4wtllBdzhf8r4lQPC1X6ctYS88Wy1HL7AZxJzADnHjuYISo?=
 =?us-ascii?Q?lu3GMhe7k7jzDQNqCtJSKqtnXM03LeW/b5iWnRUme/a5UDQn+1TJA35WvR2B?=
 =?us-ascii?Q?YYJ+UgxkWorP2y0B8BJ4BYde/IGc6g4DdI1QSxo3w/S5RZBconGDKLlqdb79?=
 =?us-ascii?Q?u617zKcXaYN0F6R0yRyRpjrBgxn5fg/qjYaod/eWw40KUtiE02UKLMjbgDKt?=
 =?us-ascii?Q?gW0iHa0mdpUnOJqWBwEkUcoXS8l3yhY3O0C4Tje+07SzycdNe+6VKIwpH0fs?=
 =?us-ascii?Q?YIQodOwZYzoCYl7oZs7WeFk+crwuawqNgFDp7JjC39t8+GJpjX+cbXUbye+4?=
 =?us-ascii?Q?ldVBKmPxlPkCOrQk/2sGbOw+6QNkzKxl1wl5V79JiyGEtyyjMMgQkfDAuOGo?=
 =?us-ascii?Q?5PbB7qBm/sx9o5Y+UEKxz5gTCt9Qh/wBw945rRHeO3tCy5disxTITUXH+V39?=
 =?us-ascii?Q?Mfp5fqK4PgWGbw/z/HpJypMajKqINCEi6ymU5TIJNNK48m9I9kWnSdj1hGoP?=
 =?us-ascii?Q?DcQuCEi0jKOa0fEWb4xXd6q/b0jeix4v1mxoRfrL2ymFZx/ucKcSPNAdyoLG?=
 =?us-ascii?Q?RFQn2JKK3sQWxF5Df+X3M8cxPVHNwkfDxpxZlliQLE0V3OS5uWaA59psw4Xa?=
 =?us-ascii?Q?0O1VuehuMT8kCoK33jHdNZGLxEqfswUJ5PldPqFHs9JV2e+BELA3pmzB8wQL?=
 =?us-ascii?Q?9HNxGu3DFnTQu3XYktdA3RvO9K/YLokoUdC66gJrPSsHJ4Vl+KrlEwuiVwck?=
 =?us-ascii?Q?UO1AOJIjZI1ar+DCx0ZDs3vonOkjokg+9ZsD6YjB+7BC95ZGM8zPOKgkFiGq?=
 =?us-ascii?Q?Ie60cAs1bgjZyREuBkYqRFaaB+AsyRdraK19YSO10IN8ea7ZCXxWTHun90ey?=
 =?us-ascii?Q?spVxx22Rl+gDJMmnxLGsEyCssT2DWa9hg0C8kWI/JBi4LmnzI/DKfKun9jvS?=
 =?us-ascii?Q?9YgxMIJ8y4aO8fG8InqUKx/bywqlAMQ815Ir+o/DyMtEjR/s64gOlST3oWq1?=
 =?us-ascii?Q?spn5qLsCuFu5mqCZ9QJNR9jdPlj8aEARPSbMiRPkxewldF+N1oOWXAEEIs6k?=
 =?us-ascii?Q?cfLZ1bcHeKP31ncn9FfbBfIL5oah1dkT/PkVadBIRlKHZ8wjDj2uULMznPMh?=
 =?us-ascii?Q?N2D6gaQ8li13yLve+QJNyidtuQiR/B/iBFzOkdhd1TTPLMrwa0VC5R83EaX+?=
 =?us-ascii?Q?LTFCyOE/dekGzepZjayw33MXXAl6bEnVZo1vkIbLuR7UfJnVs5yRmw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a1756a-5a47-45a1-97e2-08da0afa3225
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:12.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHly47VJaxqJop84IMC9Q99QMdEbfWBVCFLseG2ReuRgcKiUsGmRuHteCY2OP0ib2AImTe4R4NHIwWingLzpZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2105
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-ORIG-GUID: alo7yjGqBLGz0oRJs9_F-nwpBd8RKaVr
X-Proofpoint-GUID: alo7yjGqBLGz0oRJs9_F-nwpBd8RKaVr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
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
index b6da06b40989..794a54cbd0de 100644
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

