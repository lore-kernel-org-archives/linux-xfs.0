Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC0BC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiIVFp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIVFpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC88168D
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3E9QZ000704
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=cjAuF/dpUkgbwRxtwDM8qio1QOC0qHtp2ycjS3kPBp1/hACZfkhPFZZucEo/vbZY8YWZ
 0TNiN3SYduP7PFIeLekhRVWC0Ze2HPuZo4Aac4CBh+zll5XBCx8d8HDrX3ZXnzkAcsNP
 yblzDEVqoyOr/iKGZnBAzDSCMJtvLbK2DVKzt1zKTMNd6lYGLwqov0JlBwJ5M2n/D3en
 LC0pvJwkzgvC661zXZEKGcm/lHWuzEIykHXcvvlMQ+xKeFCaIetPGayktJ5vcFqQAUmy
 ieGgNO0kJ4zkSA5ijUxQEqYCK6GE/H+P/51nCemR4uM992NruDP9od9/zLZr97uJChYI jA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0kypx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M20Uj5037797
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8x7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4uWqr/mSoGlxE0oYVkXpq7Ygd2+dSQN4D1Htx6B6//5xvbVD9WuJ+X15xciI2yp609SHyfsQuIc/16WeUFK1ZDL+PKeX/geJsZ4E0q5SaS4pWDfiVE67OCpsckIolt1fWn80L4zPsujjLNb/Pcc/xtCBBVJo7GCEJlEzL3v0yfoxec2uF8MPrq2JGMSjTIGetuvY21c3YQocVWkxPukX1YV5/QY+y3OQAx+yAt2IIBCEJZVg7/5ZR0f5fFs8LXR5cM4nc18VOQoYieA96Fi3GRDQWVgQJUaRIGFJZzkP9ee9ObtXTU5awNXGML7+5R0h3/pX6Cu/NR15i9J9IZZ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=NFYKm/O8v+Dn3ZkeBgwTg7RsnlIoRV8XxVqa9LvFMM8LvZ0Oych2JPEQt714qtc1f3nilqi8RIO8LL4uvyKzH2UnNiAIbxpDd2DKYjLC8xLgXKJlapIDsIbCp1EXBdKIu3BpS+z2N6vdKLAd+MWfycZfaHL+oIlUZERtowqPuJxCG8g6xOCq1J4u9tzGGXRHc1qd+q7m+LlhIujOTej2F6ANcf4qnpOxUv3qzMZtMshQjZzp4nEEk03shEMOjQnyn5j+ca211/CDsSnxj3rluNR6FvK1/B5w651UaBWGNgxY7vGzZ6biw/6fhDcpY02b4AQC31Twt10NHDdUNLNVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEtpVBGiLJA32CBv22PixqhlMYVvPt8pB1mdJHaq1a4=;
 b=hxyX3K2wnJFNFnRP8BiTAu8rZ3BaD7cC/Y1J7juQze5GxyY5UwqtkDBlUDWdgb+ftHHqI16eMktpYeXrJacUT8+WkMsFoyvqHucsMEmSxug8APUpRBcDGIlzg8D/TGSFlaZ1cXTjMPk6jUaA6nr+3yN/SFoJf/jBgyWa1TOCdk4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:16 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 10/26] xfs: add parent pointer support to attribute code
Date:   Wed, 21 Sep 2022 22:44:42 -0700
Message-Id: <20220922054458.40826-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: d697c9d2-e56c-4d47-9f6e-08da9c5da01b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YCm5AMXnv4SeUtKv0ushNndYxK52Ojh0eMGAF/+QuM4O51Cd6Z02Nl6nSozNprs3+51iP0HSlIoXuOSUQLH9hZk5sCXK9vp4qxkY8bCEvR/Lph8eBioekE0pV/pKOZZXPFQSeVY3uYy6VSqLNVDsToU3qIykZRHyK7AXZgorvhhD8jyDs00TheUmfiahhxeHpCPo6SgVASF151Zhf6OOW4ncU+Hge0fVytegfQ7/GdeCGgIck5J9bjm8zXfpZaFIsdq4ytb5JX+Qz53pNf7q7nPFZ08dklUJUzR0yMNv7VskvXyroINB8n2UXGNk2oFFWZGNw7n+R8PupqdLcwcDLo1kKDzxIyuuXv8+0T/UvGiQLR2Vj8cPT9pG/a8BJnKMt6eTV7rAJr693qV5K4em4lgTdIqK6DK3sdl2Aa2/SrculPKP5LUBPAeRwlt5Z9D/i05UZhKcvI35mLWkoLOKFkI/H6rN/2ZFo9My/xQJRb/K22C7+9zQui4dnmPdWHCHcinI4V4r4TR1TbGwr5IBPKG8N9C6wIsbR2LvWBlLrRdd+KX5/aTeZuLBkckU5YLA2F4it6hK70kj7lgomu0zquQnhNfduGpHtGS5iaeBsjkL+KgwQSocMYth9dbSq3wKQ9DQsm5XV9gykClM9Jm18M/TCDhnXR/FXtEpxHH7nJcjdYSR6KW6nSGhf/+NVEF55RxuezoWp81FYhiwAzchAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lpd+FCaeZC7KXEqtdciIK2U7SDYGZvg+yjwqmm9FMRoo17TQP5Dz8DhiK6ri?=
 =?us-ascii?Q?edt7MvDMexzAAIOsQNTcp0jtMECltw7NLsICV0TPaVzHkKChamGmWivHZES5?=
 =?us-ascii?Q?DCOF0ZvFSfyzzVF0orjwU6nI3UIQRcSUYCx0XWFa0aTLPnso1I9TcBP+DLYD?=
 =?us-ascii?Q?vW/VdOmCup4cVDxMZHd2a9KWaSrblq3wvB7daInpvmB7mMxffCKJ4IF9fk3g?=
 =?us-ascii?Q?BFw8T23Jy4ja9dITkqiRw/W//Uae7An43xT79AstDxzC4H39+R5rhHvdIiff?=
 =?us-ascii?Q?nzdooMJUEzmt58j6v9GtICgOzu52/H2WD/MarTLHdKpQ+UToTweEiZfmQXZd?=
 =?us-ascii?Q?wKVdkgShrSoHbeM5/C42kzjtVhy66gmP9W6GniMLh7QrtE7jebnXc0LFaD2E?=
 =?us-ascii?Q?kGcA3WALfsK+BjUiVuEWrfgNN2DqXAMaoWvufcdzo3BLbvLG9mn+3xhGGHwc?=
 =?us-ascii?Q?tc0eozfqbZKKz9y1LUyhGi1IHgqtwb+u1GZUlmkcP8rbBgpEh0IF9PHpW09R?=
 =?us-ascii?Q?VgYAMPtF6KW8h/Q0rvllPwJDiMq9yCCYZFFb7Bd8AHM7BYBTvYqFTRptEOLr?=
 =?us-ascii?Q?fSACkXt4JTDkknMgT18w9YIM8Eovh2HMZEbiJFUjPZZsUSLWzS0R1mtORmR2?=
 =?us-ascii?Q?fCi5VUU+l7BFTvaj9b6G+t3hMfLEnbpAg0VRad00iiM03np/kuRM4XggU4/X?=
 =?us-ascii?Q?WY1dUGqYB0FulfNL8Ul1xXKnc6bd8ELViKsIdHzCQYkgTrjsMtCxRh86Gloi?=
 =?us-ascii?Q?AiG61ciB6py4ni5ITyrciOKOLdEH7eBkwgDyO0937UvjcD5i5dlf+DBcP6hM?=
 =?us-ascii?Q?A/rgvLG8aAdOLKtTqokX8bwLNKWvl8agaj3C4XAgnD3MQCAroOuO3ro/wM5S?=
 =?us-ascii?Q?R+6y1ACIi6V/BilRZ4MSiYO15qxKGaZjmZuNNQSSHrxQBKqyySSTZSl8hkkM?=
 =?us-ascii?Q?Axvg7KV9g3TdGW5KD+oH8diBqnueTrDj1OVWHgNdq42PX+WgOxVZrlaatILE?=
 =?us-ascii?Q?4CPBxEtTE3OFgMSLSiXnVGG4Tk+uyQ5sjvTz98ItayfCPfya17dZjI9f856r?=
 =?us-ascii?Q?i06Lq+cMO9lN5at9eUZjZmX0+Qccz5qHOCrSiLlgu7zgmlB/+udxX3xCKUrm?=
 =?us-ascii?Q?WrElus+3+dAFK8gX6n0ndv7n8aI5qvqmdK8rFQciyZVuXFxkteiDeOjeypLS?=
 =?us-ascii?Q?6AX0+hFiKup98ljPLpuRWPNS9k9Rqhq3ZPQD5jRIbEudb02oxmb7h/kVDObp?=
 =?us-ascii?Q?vr8d2RZqGFq+uQaK1hYfA2a3uu5NghEk6BTW2OnalyzaVzbmnqAU5Tkn9mDH?=
 =?us-ascii?Q?YfwBpFuxytEbTmU6uYwrFOL1LXqNY81cRotnxI/bWNWi2dyFsevSs3ILrW/n?=
 =?us-ascii?Q?bc9pFqULLGw4TnWs67eaUBeITLBhnegMiHmotmUaQdK4gNj4AA3tiL1j2V71?=
 =?us-ascii?Q?VlyydBMF1gu8hkS4Ki8WVvFejFCYjPOKB44lexth4CofMcb6QHthWvoKgG67?=
 =?us-ascii?Q?r5ta38kJTf8dy96zBSxTRrfWQWnlyow/dTP9/nv/CkczglUBtSZ/lySJquK0?=
 =?us-ascii?Q?5fXV0Ob58XMsXGOZ7eMoPw8lu3fynxtLTQSwA7B8s+vj+RrKY5Ntpt0XsS7m?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d697c9d2-e56c-4d47-9f6e-08da9c5da01b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:15.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grZGjkq9M88hmJhDAvnmuwRqkdRSr+hWlQqwA+msw/JwA9k6gISJ2WickA5cP6dDrTiwStmm4OahOdvikY/dAEczZJHnlLnPw/wVYsu0sl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: wOPYmMeL3oOAg1FCtJAir0YK2A--csqT
X-Proofpoint-ORIG-GUID: wOPYmMeL3oOAg1FCtJAir0YK2A--csqT
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
index 62f40e6353c2..57814057934d 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -919,6 +919,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
-- 
2.25.1

