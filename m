Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3CFC3DA78
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiLRKDe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiLRKD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1603A6559
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:28 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI7njZs016744
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=L0yzmk97EvdvbhkvhqurgZQJG8NKXtBJSRdnbsId+hOi9/wGjySFA+SeTCZ2nZinYu83
 L8wab66ZWMMb0wfdo29dYXVh6lONLTjT0YIDbrw0Ex3HrUawP1Ufb7S6jJ28i1kYMGoc
 HF9TJtLPv9/d5VYtqfBTztT1wDtpDGTbOSQ6ZjTBUQlNoOZbweGjTSDszUDaUivUmdal
 kVeWqtdxVfTHKEvC3OhISAUamR63bH944IXZTCSBuRvC3RUnck65cNVEj47hWyZQE/Tp
 AmiKnn9g9X8pV9Ur+jtOqmEajxUT0Kj0SxNUnY9at1jtcahwRTbhLVun7YLJblXMEwy4 FA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn196s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8mHqY024871
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTmTp0toELZMYARifKaS1Hw0pk81LHfcjTc133aGTY9o4QKrJ+CczR5eOVuzfLg1wxTs+WXrPgyI2bpCm9WNfL3B0vuq0tge/9zPDxw/z1oz/zj3zfal/PNs6fm3tUE9DHC5qXb2FsqEbuZKflMchWWytP3LSQ69zzyLtBrfAvkU/L3iunX6K4cPtAk4N+Vv375EKvCu+QmQJOymB1YY+RpRlrUmfzK5zQsGTX3aaOFnv7pH4kgi5iQwkr1wBGgq8Lj8yeHutUKxW7FMaTJ/co4PXZqp2YGlw7YmEcXM7s2MVYkmryONR09kxctzfegWi5/DwxTFCwHUzst05H1KqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=nYu7b9KHd+0vhISVqlI0fLzJsXMLmnvqbQqH93vbbgqqkdF3kYoi/cAThux4R+KigTxWM2YIJECJ9KN+cyxokBgjgnQskeFLzn/SgfTZ0hPJ9dCKvgoqQfY2A8Cs6t88rr5JnMwH5q02B/LANXnWi+x4ELCyoJcNDCbi7LCykRVZOr5gICYcmsvx+LQfySFu/VTeiRmh4c+NnpqCQ2wma0/o0TwHIq52Wd8jBEExXfFbMn18kPu2ZbYueLhmVi6aYiLIYCVrGMzs6BkkEECmL58FHpKN6Ll6YcxwctFcMQ5vxWp+sKmXLf+20m02z7KDsrVYfBPz6pcTJiPO1EM/hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T0GlrN+YfkG79YJEffUTVVFSrGIFrV+2zA2f1qX1ts=;
 b=dSnDJWj5XrydSQuctfIXHGk8c1oWTQRcYyH3LCf2F+yzDANgqCm2/rdsqKau4LrYFFUuI+R/xLMqasZZcWv5IBsmSxrLlB+56XVKeqxkZsuL5jAU5uv/L7geCznJj88cg87v0Il2YfFgRgUWilj7NF7nGi9zCzmBLYeTw+2wgLI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:25 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 11/27] xfs: add parent pointer support to attribute code
Date:   Sun, 18 Dec 2022 03:02:50 -0700
Message-Id: <20221218100306.76408-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ecd909b-a25c-40a5-6d40-08dae0df1a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjSaKWFv27J5xPKax7PaNITCPkNIEBnUoOx2Jp5QaQM7auJP+4uGeMd5qCmxJxdLCU04RGCcm/XOr6iV5JpszIVFJYBA/V5J55gvLjjjx92e9BK0p0PLI7TofV6EyxR4SwUx/+/zw2ZDws+QaHjAocISutTqP2hXy/t1W6En3/r4nfWCcwbJwD0OHQXF4gGdWAhtg2cZJxaHw6i+nqyhK//Lq3bZvbotLL5wO4sN73gAb2osnHw9zYTd3Wk4eozUgbxRGLoOmFVr7MkXwPHts5OKtSls5/InIUeMM07YB1jRS41jJWC4P10P2b6T1jt/1Phs0I5uwg99dYbZ604RjZ/A8BqjwYKCI5r5JKSykzyTTZXClYiRfGFSkOCop3pWWa/ib07ZzX+1hhHOWyGn9w4Rtu8E8va7+tifF7OUlDTDz2g1liVc/im/To61tpAlcHc3sjTBy9UnPg2tFpnhs7R9YUV+lgZjmbjOozTFJKY3CnKjoq3U25oYz0uQHJBMuGlOVkcFIOoPIOrHz9lQ6YeUoNQdAu3fuM6gBpJAMG1tkes38glGH74IiEZG5Jcmoa1YyUVCR5V6NYmy7t54oLPCKNUz/OisEliP24ByKwlG2kFwbNAZYWZ5RVNlMP4m500rtUvREuwtwCdpjYKwRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTG4yCVKy8t/62ul/hWOj9qZBm6ZTBTBjC6RH3gi5A/JS4gFG+Vk8zzoGWee?=
 =?us-ascii?Q?4eCBT3TaWQ9HMNjJ7+9QYqewr5J1k824r8lmd7H30IO8AVUDXtHV+YAM+DnM?=
 =?us-ascii?Q?YtLwuhH3/+nXbqxgCN2z3eajLjsbRk63Hw7d+mhAE2bA9sq8zHvOP+CtRxZB?=
 =?us-ascii?Q?NZWwIuOpx92D6u8CEfQ6goqgFDm+QmG+ZpWNGaAuDCmrS1RQ8zhL5N6I94YE?=
 =?us-ascii?Q?SdEZPztF58IemJE+UU/ppNFhUccH3DSwd6mM5EkQ2ywf4pviwdo8sgipNDZ1?=
 =?us-ascii?Q?ApiS8tley1e6Sk06H09I7H68Oanf+1DjmQ2ZGXfvkjKBnxrgZ+vOfzE8noqF?=
 =?us-ascii?Q?TqC13VRknLXHmogfeKsPgBYWigT9kiAGmMps2+1pUJen6aF8DPR/Ace59JwL?=
 =?us-ascii?Q?AUzIi3tGq1lwiL0Qzj3n6QrXBlKhTlHshHK1j2gKG5D/8lg+cuXWdtXudeC7?=
 =?us-ascii?Q?ISOLnon1rqQ+KWfF15YXaKUEGgvxxyImhmAfYJGT91NuzOO9ukm1uaRWsf1a?=
 =?us-ascii?Q?qj9nKpobeb9JFIPDIZC4Q0FvTIcbMib2fC/B/jEVKWY8MumAUvN9RE1HLdCn?=
 =?us-ascii?Q?AKL+ZSYre81pR5Pswn+s4GuO2j78En6jRSoz15E/csDcyeWJSZf3Vr81ClW1?=
 =?us-ascii?Q?A72iXzQ9ceJ5DNm52mYT4YhSxmiNkWvfZTooyVwSPp5RCP0oB5SDC/9nOIZP?=
 =?us-ascii?Q?zO5vHuJCDfWvkI4X7Hugaz+4ndeX6DAj3brPQos1SvX9I9nCBYTx6uFM6kH3?=
 =?us-ascii?Q?QZk2pO56jKvK3az3IXss+7Jh8YK5m1nNn9sgnay2umnnMCa3iJLPOBVJdtAE?=
 =?us-ascii?Q?2HDCW6LuwAjCzZ8yQJIZqvYxt6WzKsq8gbMufy4ciDHB2CdGZkZwtNPO/xee?=
 =?us-ascii?Q?oeWz8r0iYJpG9N0rTYXp9+DA1McBf5i8A5AKAx/ZXSbmR+M5XRfXHA2GEvUs?=
 =?us-ascii?Q?US2VDevORD4k0hDOWIS4CvWowDIZs+1QajlSzAtHdToMKXC+VqJLNK6h9Xkl?=
 =?us-ascii?Q?PlLQh/pIFaV0mai6yxAI+hULJqRWpPUZNW+uLyIPlyjdWZTR6umGXNMsrbJT?=
 =?us-ascii?Q?qF30k8NFbgQN1mj+sl4WG2HXwVmIzlEbu/0tsKEnWVJ3KXSC7pDLpYF6Nlip?=
 =?us-ascii?Q?Y6oAhw11kIPvO52+DLc2aXWecQyaHTjUEABTY7Z3zGMhZ9oq+1qbdrrubrkB?=
 =?us-ascii?Q?YPLOULXDb0tpjvxw2UQsvWsrringVqZamLOZ+q2ekaUzQegd04sZwEajWlYX?=
 =?us-ascii?Q?KAXvm7r+9IkYvlwuHgk8uZ25KqfgTEu4QPQEoKuPkMnHX5XyktIId/iidU32?=
 =?us-ascii?Q?ehMd5oFUbU+xTPu7lpG/dQCboTPJxmtxaSLmKQaxsWh+wfH9urMVCPjjp003?=
 =?us-ascii?Q?PjZqtHrYaUSZuIES0RVGQwAKJPdjQMq6INZR98kic94VG3pteN3iUqzu4dZf?=
 =?us-ascii?Q?Kp3dc5ZDTrWWBiiaqP8b4xmBpXs4CoA/bTh3kLjtdwrX+SHkpWmkOArYflut?=
 =?us-ascii?Q?JPDi5MsxmxeU+TlY5AKhfOeuRurfrl1ZWWfxf6dcsfztKb1QSMgtOZr7FGFj?=
 =?us-ascii?Q?joOGFYdjbxV40utMrTwKrpKW2vPMcKi1sD3VGeJ57tK0xVA2i03Zg7+ZaTl2?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecd909b-a25c-40a5-6d40-08dae0df1a43
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:24.9926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07WgQvwOvYjyjPUIlSQNeRJkOVdBWJ2+QaS5nCSeQyZ2Pr+JTrMgus1KDrrrGITLEND2wR3CM+Hpjf4bo90kYp5iTjgwvGZZ79d8aZ4wocY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: mYWmNnT7ep70pFm42EcYBOMAbrduLXBv
X-Proofpoint-GUID: mYWmNnT7ep70pFm42EcYBOMAbrduLXBv
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

