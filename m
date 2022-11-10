Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D7C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiKJVFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiKJVFu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C3B7679
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL32JQ013905
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=XGZ4HcbEdERnVUFzWosEIzrJ3B57Mog8WUbEUjM11a8=;
 b=AoBEFPgebaOq3U3kqRz58b2iu29Y53mfNd4XryuMgQKS7HgyIFuoXgdMHjCvNYhpAH1g
 bhcYVeitAklWkVV46Hqp0mMSibn0MVyt6kmLVAKLXLNfLobgmXk4N58m6cGXtaxl6oBF
 thxUV2pqF88C74pLyZzhO1iX0djDKifb9mFOKr6TVlUg60YMNY/Rr7pQJfwXHNyvHaIe
 v6Bpnd5uzBl5GWUHbhx2sV9rzJ5gr8yCQbOJSYereIDnHtQNXH8ZDTTMt5+hhoMJpqf9
 a44da3pJ2anZMSoutHsDLMg44lI1gI87GM1TFT0y9mrU919LaIfh8HMmqSz/AMq99b1v NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vbg084-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKeTiX038169
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fjb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZIMhk8+XTRUFyXIdV5nMuGTGW715NOhiKdvjx0FUvc22Vzc0cIiqBBLlmPEQBY6VoMUAwyQgW3Qyef0exWxi5tx46pXlFOAJt3Eg0WpqDzFHU8tR2dSd4rpMuBF1YhDr8WNVQYdPPTIQbtRV6727G/i5MMtFKYmQwlBtYSKK4K21zbNp6IumK4UP858RY6DV0CmzLQ7TnJAlSI669j6bTFvDGUarBESv2cfcIVcAAXMUFSzw8A6IdTact4C+tLBUiM1rObshpIg6rYfAXNHM+pyFRNef9dfUk5E+EVmwiDsXxsXRVl1BjsTfw7jXZFrTVN/509qe+vFsbDqj39WHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGZ4HcbEdERnVUFzWosEIzrJ3B57Mog8WUbEUjM11a8=;
 b=HpFoBnr2lmR5vJkxuYAiUySwCQxf/Q2MonAhmkNL3h/eIFxbu4gVjKNUF1TS5JekUpgVTxpj1jNRLGq4G/e4lanPpMU6vSz6rL3yBPNfWPmcptgTdGWCnpnuD6+kZcqDREju0BV5yLhB0CAjF/6nnkG0cOFo93kz0JOFn9mixLEbDlHrwAy7hOJhMFYWIpZGnLJGeAnc9wf9PWXDSv7X5q6X2YMIJioDl5Kpj74pz96p9tUmKQW90WOj29mxplDWGe8TQ608ShCdnOc+1FMfoXgenR92GbsA8Gn53ZKm9EWvpv6AuoDgzswYwfDFxwEjC6WM/LGev1Gaft+GW78fiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGZ4HcbEdERnVUFzWosEIzrJ3B57Mog8WUbEUjM11a8=;
 b=iis0IE64RCLvX0ett7vh6i5m3xiRhBzoRXnn7ec7/YQbRFU2cbHbPMYnHVFawIo6bGI6ZcHmPAKvXGfrAUSJxxoQZAsDHyK3aQXyQWvw71hP+iG0r09zwKaKK/VWktUDIYlk8iRChdfpEnzlXFdHOQhgFlnHz9H9fS/pq5xNRq0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:45 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 10/25] xfsprogs: Increase rename inode reservation
Date:   Thu, 10 Nov 2022 14:05:12 -0700
Message-Id: <20221110210527.56628-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 24ce7029-dfb9-492c-6c95-08dac35f54bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRTd2zhm2CBqrVJgrQidRvO4KgRjukcUa1WSrumIk8kh3bU8CAhE0CpBX5Jve2Iew2cEDrOduWTIBomdDCHC6WnY32AieNTacf/eHHDQ0AvvC/ct0qIOsIRUmhoekwpsOoJufpfcF7QfL1+YwVIEqBGjMupT+C0NkwjUE0kAa/hc+fho3KeC+eF7HCOv3O33pgK7sxd63/OV4FgozDGVQ2TjvmgYEZop11B7yaeXLPHHAxSRo8Rx6aw42f99dPoY735UsotppqUQs9bgaXUCiZFRHDcF56LfSvv+BcqjAZTIZojsHvyKI7LYljG++2MTHy51TAbZX1MsyPCcxnE8IRmW0I5jr7OMaxiJ+tJPeRXC9umrmMuTdUVSDnafj+xKLKQYvpJBtXLcImAxGG6hq7n46MaaUPIBSDlq2MN37yE+uIQAUVpCGPK6h2UFoSCOrKMw5DvxrSaNQrN5yxpBhwrTdNDNv86pAXxdpZVGsQtkzUQp448iXgw6IOPlexsncehtPlQNUJtYU/+86GPsiOYfiZroiee4lWHHDkkUbTTXlVzQoOJwzpZH1Xu7PSFB8rECloWcLJ4e7rBoynymyosCnZoltC/n8C1v2l8QIZsMjxoQL42qOThOICyQUyuKUjBawIgGPY1nA5h+ISx6zIyspH3HyG2cytJJSRSakoG37e9DNRID1vj4mCrfJlDfCFAEnQHc4aSQ30sSIt4Baw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UzM0nE3uBukfjGV3k7wmjjeu3Z53Yy+cMXISmGU1X9AdFBWATjOFzRUW4d8U?=
 =?us-ascii?Q?yqgeVwrABllfCBJH6hqGsOzBuyjJxIQ0+D3MhMjAaK42mDm7gcsRvM9K//V8?=
 =?us-ascii?Q?c0BNTAgU3rUS/08wsIFN8J5A/qCpMz4uP4qSD7TSPWPiKc9bp3aW17tMBY14?=
 =?us-ascii?Q?2vzgJ3pxzcTMIpMfKwWfskBijgrOc9N7wveDJz+r9iz9j31Ofrjp/vnSb4so?=
 =?us-ascii?Q?YdMWC1sdjt4VsxG5M4Xyu/vF6+7CyW8YxkRfrcmuaPy/HT8PhSgr1XHzKmwm?=
 =?us-ascii?Q?QIj/vcv3P+5vIxEvTD+QzxBXajzBCTlwc05nqc8LjS8yo7Ih56mu4jmpgQI4?=
 =?us-ascii?Q?SL2LHAgpHZqZmxe2TyRrHwFKHkzcAxJ7+q0yi/UyibD5IEEEApdLWAA2A5Vd?=
 =?us-ascii?Q?oqE70DZDwlHRC3MC1vmgmVRwJaUJsP0SzflyBKHa4PVieNLHo356TjqbtCpl?=
 =?us-ascii?Q?1cT9Bcr/kzbmp/FANskbXUDj0S3dsB/QDQVg0Xv1r7xVPKAUmGwOuP/k9Qp/?=
 =?us-ascii?Q?kFxBqBJA6mIPN9LLDnZhk2tWbgyzfA0WhDZtaoUHQq5s5a8+tuWvaM+CS91V?=
 =?us-ascii?Q?o9ChgtwhMhfiJTHkSkTsyMRupgprXgqL462cTUFsDDje5CRdHly7ULCBVUwz?=
 =?us-ascii?Q?tKbGulZ5l9slxrNfdfRSUulqPkh4KhuL1ej5Vr6npQUBH+P4jagKQ4k7gh9I?=
 =?us-ascii?Q?S+a3MEyQMw0yLV+yrFvVGL6XwKvHWrN37kh6CLbSgEnrtVMBrRgEPoLXDt2M?=
 =?us-ascii?Q?1neUgV4B27EdbmQ9hCObpjjrar55BQ4D2o5WmhVXcqNxq1NRgmORr0QX0fep?=
 =?us-ascii?Q?kl6jfOAOXRF766jcw59+/TZknDiwW0WgUxhflQ36X20u6exuyfqXhhHc5gC8?=
 =?us-ascii?Q?JbNwG0uJFtXQAh5Fxkz9BeW7cIgiGOGufFEizu+RvDQ1yVpPREpLse5kZXNj?=
 =?us-ascii?Q?l4FsL2SI5pBKu2NO2pgMsgqibJZ2EWb5ILI0OCx6dpa+le2WMPT/6H+VyY4q?=
 =?us-ascii?Q?b7ptIv/poHzHWyrQ3tRhKlnFEaRTqfdZIR+WiAh1WG8/r7/D5ok/9row2k1R?=
 =?us-ascii?Q?ElwlZaaTGoLMiQdLa3FEThfvMvHvU3KD6Q/x6g0Uf/P0TPjKKqz/+s0WX4go?=
 =?us-ascii?Q?TU26TZyVTwOXCdA7Vy13fGL4afrmhkjz3/4vOb2yaf/Sv03J+tHmnQVu0lXG?=
 =?us-ascii?Q?BpA856PY3OK8X5EsDN6pa6OWOg1DIoyR9/fSDEIRCaSYU65C4vL7jeQj0blc?=
 =?us-ascii?Q?5azQ3DiQLlZi+t8UmDjWt4wcb0GKXA/bK8TUDjDx74Pmx4Bo38Wiy1naX5KY?=
 =?us-ascii?Q?ZHfjlwO5A7VVao/nFZOUSAUeRDNijuZaK813oQIfCCcRUZS6AXe11ZlJONyv?=
 =?us-ascii?Q?3GP31YgeSocrPpqWMTR5LzX6jxvZoux9WKv23sXj+ufWIQ8vBmnyvdg1ILFv?=
 =?us-ascii?Q?ZIe0OpueG0q571L/l9blqKo4dOCmV5VIINlZhbC1V3LTDcYDXSlWwmc7ploN?=
 =?us-ascii?Q?/PjpYjhj+8Y14Lezu6GmG3t4mxXMYyrmuT3JHXD7lFsTmaqL/1eHvbdantC8?=
 =?us-ascii?Q?dkQrLoOg10umsalcT//sxSz7YBgqCs93R83vp9afnq3zFn7FVexKXhGJn22K?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ce7029-dfb9-492c-6c95-08dac35f54bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:43.8418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yfq7RM5J7n7qdmwlKMcrGo27irSsemJbSpdWO5x3FSSsctNNXjw7UeW2xaPcaqo7HQRPup/TKyz1AdGJM2x3KfMgPd5gb9T3Watx6SlWY84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: EpOF9c0t55ZQ_yo6RssabeTXuhIJGLcW
X-Proofpoint-ORIG-GUID: EpOF9c0t55ZQ_yo6RssabeTXuhIJGLcW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 5350b9280cd22d6deab8b3f4d77c0a4f34ad15e4

xfs_rename can lock up to 5 inodes: src_dp, target_dp, src_ip, target_ip
and wip.  So we need to increase the inode reservation to match.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_trans_resv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 797176d7d3bc..04c444806fe1 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -421,7 +421,7 @@ xfs_calc_itruncate_reservation_minlogsize(
 
 /*
  * In renaming a files we can modify:
- *    the four inodes involved: 4 * inode size
+ *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
@@ -436,7 +436,7 @@ xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 4) +
+		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-- 
2.25.1

