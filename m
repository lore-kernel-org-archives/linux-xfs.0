Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50733C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiKGJDI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiKGJDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D11659E
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:05 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75aXBF015141
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=Gag6Map7Z7GY0F3pMh7egwQLr6Pg9DeQ4TN4gdzh3882f338F6VivSufOJOTfAdZPtoQ
 ZIXVbfkb7i0AOD9BzVnaOjH/nucD1+apFOK3/muMGL2PQyGQ9dA0ZSecWD2wkUe8610t
 nn0EVhpXLa7L9qTngJV9bqM/SzAYzTcXHxqNNdEfnsxUdDl+uLCGQNKl6JLfYr9BOdeA
 dfffo4UWKFRVi2NVkOIDcRKySODoymEAXQYQRbTIy+fYFuPv5j8IkTkTU3PBMNVXL4TN
 9xWqaBeJWaVHZNhHgstNWVB/i2VU5XibZAiwvp1OIRE50ip3Y8krgo4d8mORXU56JVIC JA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngnuu33t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77fB76025283
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6f5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGthWSkh+GN4Q6s4uCrCwToNdSelZ5HLXgpy7L3SI+UAEjCcvzuuXEdlQV6o854fShBpW/TPNiRyi/JIVqJf5YMZAm6DezGhm94znYbTZq0mucN2Ga16l8MhKANU9LYiYxQqhxpRvb9FfrO7wQO0qWz/rCxfQ0HYoTnWz8uQgh7ggJiA8IswJ8Zk08/KTzu+Q/5B6kDtFrnBdIgDTNjDJjobAQ1T9g2pjnmjOrqJVJpOYQFuAdw/DAvqzRW3LQFoAXgxev9aBuU+HyJXGwfOTjiDRrNb3LxTmpWsbjEhXLBZelEMmJPtCut4j8UwgcBlND9ktedMrbQcK3A4q74yrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=CT4cZ689ZQ2pgY958H+t3KVIPkEcHSvPaQp8R2lX+aXcmDxS8h7o5mGiIFZmmD/z0eazLtiHNEdflBAYslq6wnvwuHyk4Kc7bX6mAh4VEzh5PN3AdEvr1XQ8W/pUuWeb3caIhwFCvoe/IRod2rw4fuFjBANrcZbSNRy1rNvIDH5n6NhQwSQfK2jKTrHE8SqAZ5Og/IdT5cZ4o0aeCOcLbpBWWIjVk6JB6TtssCKzObrvbEuNSoGTCKG849kU2InUgU4HgVdnEEKNEfQBg4vYOWso8HmldIAOaMfl5iQIAQixfhiz4/0lZxyx5I95RMXz+zQGtOWFaiegrcSTjXABww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=baYMDIDYQGOd6xO4JQs/t8dYd9bnqTOgKuEmjCwzynLUzIryGv1M69lQu24ycJYKYS8mlKJWa4SYaZIPQ3FyAnU8zGMa9D95QQFpevhAwN2qrD20gLm8SVRWl9nTh8AGTbU7woCkoQehndJjRrApGHBD/4lenKpzXv0UzvBWUiM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:02 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 10/26] xfs: add parent pointer support to attribute code
Date:   Mon,  7 Nov 2022 02:01:40 -0700
Message-Id: <20221107090156.299319-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d251d2-cded-4f1c-659b-08dac09ee01d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqlUzilURloKOLNTsWQzyb1EZ8XOdKWZysdeYsknMPKAdlCMFRDIiC/DPrjSnxqPLV3tV68N3JCgBwk9hd2Ne1kRjdJtU7kgJt/si+SRNZc//ZREhBIC/v6odtDXyLA+h7ZNNSuGrnOuRnxn5w/Kv73YiWcSb10ny8wnxTPmnRuuULJ6H0WzwiA04m9ef4zvB4PEL9EdWaE8L0h5EMmeBYiLMLCsm9yHWup0P4onACPioUqiwdhhRqMKtdQOcoTeRIu7G2P/ugDujA47xFVT6IW+e7bi8B2K4UTIDGZ6VuirEVIbRlVkYVsGhwud8kTn3khdRZqR0KBeAyuDTP0tptn/ByTOEV5DGyMoHDL/6mIuTv+0QR+zk9RkRbHvEIMMxW7KI1B1rIxMRl7VRMh5bo05kqVEZI4uk9jKuSiD04T5qs/oY+k0ifWKIZpCTzN7C/3IDs+aZl4NDK8NP6JeQFR76Bd89V0XHPwhDaQB94kL4KEuk7S3oeQhdz7IDFJVhGKbAuGdJZd3mmnUn6XEhSE5Tkm2YFS+Rpg1v/wva++2ff8ze16sw3WZhXOhsbtrEX0rIt3TqfQgBK/kuX/vNZB52zGFjY9DmNl1AYjtXJQ9+yB06caT2q6E9yavJhpYz8AE0xSQYDAF3enSvM1iexyPUQ1meozgTzCvMuuW3RXJuJs82vz+5YEmFOgQQhVdBHp+K+9/3v3BMNF6LgDhTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U+ctb/w6d8BTcKTX8oLG89kNIKUentuvSmBii6a5VtSFHs6hoC9zPMo2p0dD?=
 =?us-ascii?Q?2Cr9SjNzG+/h0f+/R2SWUPLSg2lgTLt2W3qL4UE1ECfPPS98jUkaNVKe2B1j?=
 =?us-ascii?Q?ZEev7p2jRIkDwnat1xfenB/D4qzW0pWKiHlt2fQ2aWmxz6kH0x4nl+pSapZq?=
 =?us-ascii?Q?g8jdLJf7nZdn78rjur4hWmfAoxvJoQw4T53fE6rTZaJidyXSb+E1eBBVneHq?=
 =?us-ascii?Q?SntmimnH+iyHMc9POQ3wF5WF1FnYzz1BdLp43VysdXEQ0Kj5rqfIp/6g4Yjl?=
 =?us-ascii?Q?jPdhmveb9P15f/HiPW7TdWY0RgLgKXchmQMHdTwEzNUSROTULzNX5l6r6m2B?=
 =?us-ascii?Q?h8fPDc1pQm8lbUHr5YGx2JRzpm6dn0ct3uK0VfGQ+YWtaQBZm+mONc4yFhnf?=
 =?us-ascii?Q?QIu7GmyOTHGQECT8lbYA+j1mtzxQ+aHrLOf5aK0bv/8rRsEjfCAxkAYv3xPQ?=
 =?us-ascii?Q?CBrdfeqzvVzwTJGukNfdz5Xp41Yx+r9vnvOuoeO7Zcc35LV/ZXu/66xwhrC+?=
 =?us-ascii?Q?hFxmgETPH2eI30gFejPKi+Fl1PN1sl7FXn7A5B6Isx7kJfQ5fFQ6haujLsPc?=
 =?us-ascii?Q?v77fOL+zL7hAPFn1tdAnEd3rgKMA0lF5k33bIXjwYcVYSbnTcco/6QMV5JrF?=
 =?us-ascii?Q?L5u91kUpqqQ2poUY+AD0zPqtRfn+25hnYVubv2DwiDuulsSEDlQMAUHrAd2Q?=
 =?us-ascii?Q?Viui2HHO7OtB0FymYDYnlU3biC1WqP+KiiHwlezU0DR9YjlYbM7KCB6o6k0V?=
 =?us-ascii?Q?6zBU5tmzCSWGmsUjE9BtPxKSHr12vUXlSBnXPv0nZ9cSQkWyGI1D5kf4QKJd?=
 =?us-ascii?Q?TGI8248SohmvUcaa8uNU6L8ewrt5nI/1I4q1HOtwsDBU1hY8s4GLxX43dXl+?=
 =?us-ascii?Q?5TUY2gLw9vo7O8fSLzmZAT7M/Ps7PWJtEvdfRD2BDKawfeL9WvpEttsnkKbx?=
 =?us-ascii?Q?9BhyWySye2nIIa7ChfeflQ8WiJOi9h2vHNjSXYDRCNFxk0whDJa3n+l2AipH?=
 =?us-ascii?Q?RLcPOHQFcLys7NLJC+CsmoecD2rPF7vMcanjKbXCJ6CO9rNJfHqCLn/KX5dO?=
 =?us-ascii?Q?cVcq06AxyU6kwe54sstW74rjmP0W3WED/tILoeBWYXd34jjtQD7QlPJwlodz?=
 =?us-ascii?Q?vEQLrflSGPBo3bIt9IyMQGVU/HkrcFGT2+3nVdvuc2WO73q/upmYfDI9Yqg0?=
 =?us-ascii?Q?br4pPQAaB/7tywzSKDJJ/3qmGW7EKiY2IwPkKaizrGHpXK6kriFkYaVQerVQ?=
 =?us-ascii?Q?eKVXiyfYcw5US4EHteqXVQtiIi4SnoayVM+iTlhN7onrA8kHBkjvO6V0uNBM?=
 =?us-ascii?Q?JPXFLB8jt5tZWGTMTNR0x9rbdEXi2CQ2gnUYzZWRgrVN9AtnWU1j8N/2VFlA?=
 =?us-ascii?Q?sjwt4ZRCtJrwGZUCQjo1MGgdmZbLPiLvkyB0OGsvYadVAxrEWU7u1QPREe0E?=
 =?us-ascii?Q?XKzRcXy/lbFpuQkvVfgbomqgQal6x4lx1Ecqbi6PRgwEoaE2bSkfsDYJpId9?=
 =?us-ascii?Q?Rx+pYK0p4ZWaQU0wqstZMx6qWd2yhKpivONrz4IyoPWuOj4XUJHML9+uko7V?=
 =?us-ascii?Q?L3+79T0qliiWWaRcPYnQqoxGP2MWi+vfN6i8Cux6SVi8PZd8I0GrVP69yt4n?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d251d2-cded-4f1c-659b-08dac09ee01d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:02.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BjKxnMpuq2995jHuhXT/sChrWw4w3Jj0hffJNV9bM+sz4txcm2ZJHB54QvvVrsouNITI3kSpscoavRp8cBGpXwbgEMoxL4t6EEfE2BXY9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: doY5KDcyoLaaGwNBBsZsQvEH2UcYyaAD
X-Proofpoint-ORIG-GUID: doY5KDcyoLaaGwNBBsZsQvEH2UcYyaAD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
 fs/xfs/libxfs/xfs_log_format.h | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b1dbed7655e8..101823772bf9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -976,11 +976,13 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			rsvd;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
 
+	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT)) != 0;
+
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..3dc03968bba6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK \
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index ae9c99762a24..727b5a858028 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -967,6 +967,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

