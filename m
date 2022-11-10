Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97045C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiKJVGj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiKJVGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69EF5654F
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:34 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0bY9006962
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=VS6yeFSWejYTGTeoPTEA7ZHQiXWHfuo8EVwUd98ue58=;
 b=pLcON5n8QBElAj5Y7boiSTgCyzgwRO03sxuqRmJHMKQmJfiUXdiCcaIuAXx3uakDTux9
 vYy4o+4a+trCu8AMMiFhRL/e1voF7P08m3Zk5FZRtuV3pyzuntyAtvCdhQuDaH5lJje0
 pCXKdDWIqLX9O7FrfrSEXWppCTi/oIgmQEttlDxiZggqXpTbA3jBTOmourC0xPJQJyXn
 a/eCDcSJ5Dau7aQVtSdsXOkoxWRKHA8Cxwd/AyN7TRXFEzmu4R18a2bPnmfnE4wFL6M9
 jj1FS7K3kmy5Xxw2r7rXwueVWgU5DlEZJuAXqcd3uCBrGUio7RVx78qhWMILjYKlfw1N gQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r1aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKpxba014959
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctfrek5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dV8jKMLGIiLK7rIjbHyDiWnczOLVb3thHvPYP0GRwxpRKyHb2f0AHn33WlvLRJd2ww0lrnfSBGTBa+aIesFEdVuO5a2DOAloU8CXZsnpNjQELIhOeSs4oApcmlfEEZFBQV/N5QZAL7R+BJUmue26UavyDDmx7uy2ym7WdiW+9baCpT6mbJ07J560PCntia46+pqlUy40UntV8GHFQNbgF8wibI43sPht1D/ILQFeQBNCLnfUkTZHjSy0o/alrf4jKtdtbXfI4krEIA/MRpv/TR/l5vFNJAvv6vKQ+2n2EcrhBQz5o95M6HIXbv9+uBImZ6myYekCql1v3cr3wepTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VS6yeFSWejYTGTeoPTEA7ZHQiXWHfuo8EVwUd98ue58=;
 b=j8xEdoFkEB6QORfnZQ3k2yfKIMXS0RRzqa5eNT9Ny5ofIptE81v6OyTsBXg2pgY4kMVk3rzXVOF12e968RaeU18b0BjmeNUO3a9vxYyg80hu1AHuEmFNihvP1f22W4noeobtH0IDXmHQSofyYRt9lSEtpc+0DAgXs+xnz02wj3y0hB7Em1TljSUUeIitC21wEQKtF0NxQybuCNGuyX6Hs7by2QocSfU0csz1rZ6Dq6JgIqarg5cyy2eFpDx8nk82uevz/8KhS4jKQ3VywpdYgbBUapwBAqVOb89G6MhWYBZMwFh+rv7JuhDeLyJSosi6NsZMeLIQPymVi6k/z+tkvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VS6yeFSWejYTGTeoPTEA7ZHQiXWHfuo8EVwUd98ue58=;
 b=EGvJYMKvWOfi+GIOgLl5X6fyLIT36mWjim0QVSCJhJwbEMIbX92pQhD9x3FLbpEJTYyd+4SiJj6nQp/AJhe90pCByqTqOLKgkVPH9FH+RCAoXz7XQf7ZcmZiweUVxvjYAqb2DE67hVOF1Vo6TBln/57iaNCOVMlvsFYSUyrXzus=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:06:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:06:07 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 19/25] xfsprogs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Thu, 10 Nov 2022 14:05:21 -0700
Message-Id: <20221110210527.56628-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0129.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 50989bb4-e0d9-4725-3c1e-08dac35f62c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hbKMy2MrYAWjA+KWzXahRvUQ0SGDCOuBmoIXSJaRwHWjU1RQaRajU5p6F+sGKaXs2ZOCUhJhD9HNWlQ9W+HNlZjTj/t3OpULyyqKId68/OoGFAQ/+7WbtUHVkf56f21atRQ79LjG5bjmLYuIGOZjfkso4nWmLYolx483Mk1ZuRpCcEbxc0CMI7tbhWOFKuDH4HQdgF8BpH9q9Lvn9LNblrVsf1SCLrjTcQ9gSKHs0nZXYX9JoJqiCioJ74Exal3rhc6XVjGiQsTLXP+BF77eeZuFgs4GSyg0eLhzQWf9AiE/gSVbliPv+5euQHKmHPIOyeKQjy4uoozjCLvB79DWsP/5RwKqxGIyRgWnViKKtO9+4edqM9lVYWajtRG+xBFzxx1MAdjx0VB7GrHzqH5xaTDbfW61lNgiLapnj+bdEiIMIhsqexp19kV+Vcxcn8nBsUY2RVaxcZTUU8sCYiFZ5zUq3IoWxw1aRn5mJoIfEG3oxT5h30UrTUQPvmU6eINcMV8CoLxTOgR+nD1nKoGp8DxVkkcAWTyduJKmrcQ5DhyEcQCyhhRRS+aZQjSef+VL2Tdz9wRPl+y1W5Ct3uu/o7Tkcrv9F4Ot16eXsyWDJWPTcBSgrGwIjCvnyPPI5mdKaGbw8Z8mLXGbUrl+Ec3jmvTmU+TfFXsWkU7MLKwcqCGM3DpXkplIJpv2SQcOWsIC8gsg6PVDoPNjFcQx6Y2Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5reSyOEIMYWz7/b6xQ55XZ/CkGc0hQWwhnRbERTv7UjA7bKGROVk4v1rJHX5?=
 =?us-ascii?Q?xGpp7MGEgfCEHt53Xh4IAsS2VCENZJz+kA7/DOTUuJsXQ2VrVLcVB5UeXvKS?=
 =?us-ascii?Q?26sQrAOHNPTsyf0g77/d+oLJhhSfAFTn2KhNB3C2awXR9g6bfsmRd5ePHPn9?=
 =?us-ascii?Q?kVIecJhXjrSwDz4rfvwlN3liC8efJvN9U5XaO5mLb1SJPy9yFEsj43XYvxpn?=
 =?us-ascii?Q?sFrpculud+IpVvqOOcvL/Sqf0srq0JesJ8BJT5DEVX8OAMydX3D8CGew5PN0?=
 =?us-ascii?Q?7JA+LLdhD5SYc+RXRwa81tbi6/eC+UjurvuRvC7P+RLfx+nRFVhnPAlGYSQs?=
 =?us-ascii?Q?I+GN1iGRYTqSwfAQcof/fWeQRyAWCBkOMCC27gs0LNK1ZxM3Si1wASOVXVe4?=
 =?us-ascii?Q?hgk6FDtmp7EFU1ASUSYHvsDxn7dZF3Efoez9/MIQV1S442PRKVnDbz56Xute?=
 =?us-ascii?Q?rmGcqlkJB8rp+5lMT+FCviIGH3wRQfDM4d3I6egVeL+OIfdfee6dKHv8sc/P?=
 =?us-ascii?Q?JKYjKIkbXNjNjRWPgQbgkbnp6bxOckd747wmJ+wEYRLb/YLWSSezIK8etfeU?=
 =?us-ascii?Q?d4sPVZyAJY1TpU9l6qtnW+v+KEr3iPt70MHKWAA9IuveINb3UES1vLRJ/gwd?=
 =?us-ascii?Q?RyIbfEGzlMCuFd9qUlO7MvZ/3FXAlsMTcHd4Uci9Kj42gXd8Ptl5I6cJFgDh?=
 =?us-ascii?Q?+Cp5Aekr8JOy0gfAqwieyj6b68FXJD0K3Tyxt+ag/1gaMYVFiByygNVMC13F?=
 =?us-ascii?Q?vnGtwJWkiLnIsG7S8WK8Ns8Ly6oDy6mzsLNzZ8zIqlX7me3ptZ0Zc7xvau2h?=
 =?us-ascii?Q?rpnMbGgP5HKx7iMovrGoR6TviuVlwJ3drF1qT4TwCddPcB9bz0r1NK+1xAE2?=
 =?us-ascii?Q?6ir7dJLw1XP5vqt9LYTaxr+jKJznXPWXmVA5+yujHbi+iR3JwRx4EwontMgL?=
 =?us-ascii?Q?nK0JXblJoLx2qJcwWCtHri5nbuJnC3CqVKIA0PrAeifDQSeU4Dd5Dr/ErFVM?=
 =?us-ascii?Q?mv4BIE24hx4m6Z7L7Gwu9SU4NB+DV9nFePk66I9lJrEQ7yAz+AoKNu12cvnq?=
 =?us-ascii?Q?GaJQdaV08qqWH/iTS+1/N50EJgZLEstEpnxeyJxoFVgr7Sw2MvfBs4Tsgq/H?=
 =?us-ascii?Q?l2v6P4fqaYFo52VmubphjZwUfO99/t48shrV7a8hA9SIaipkpeX8JYMzr5Mj?=
 =?us-ascii?Q?kDe+0XEv055W6uzOQSewfKh28/CiJ2zfiwt0GARhvGgGxtjpp2f2JEOPTp8q?=
 =?us-ascii?Q?TgfsiOa+wY5Pn5ufGZ/oPnUZeHNi16R8+TDab22RSPtPLHvNQXpmu3ipLoMR?=
 =?us-ascii?Q?ilOL/K3gcx7tPzF52oll3ONg6nluA0i6ukdQPWmNnQg+A1EYWYZf2WUUMaIc?=
 =?us-ascii?Q?Xq0iM19U+in6iBjWS9jiRYaYvaD8r9Q/eJHAsVKQQM1hwCKPFQIIVj2Otmf/?=
 =?us-ascii?Q?ettJhbS5TeSu4aDzr/gsDPGpdV4VSi76CpIDa2wFBSibb1EeSDIBYvKNY0yq?=
 =?us-ascii?Q?eR3KJ5vsX2wr2Vr8Iu93nN9JtmlVeJbgFmmqcvN3luC3k4rqtktTaGTtUZEF?=
 =?us-ascii?Q?TUKBU/pROtlbt8Lq5xxJAALCdKukzxfoJyrD33sZTfe5tjpz8sQphRr+KUkG?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50989bb4-e0d9-4725-3c1e-08dac35f62c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:06:07.3620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsPwpo7Ec2wmPU6CPBYaTHZ6bYNWxWb+XghI0aZLPoPZ0nRKFeWqS2bJHx/JCWzMEyz09Q+9HZNgRJP8QSVuOilgfk/evASI642sO03GAMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: RbYriQC8bCAlWDU2LG-wFG61TX97TGZL
X-Proofpoint-GUID: RbYriQC8bCAlWDU2LG-wFG61TX97TGZL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 46f34ae75a2ef5ca24104377a10a57f9d4151e1d

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_log_rlimit.c | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index cba24493f86b..6ecb9ad51117 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

