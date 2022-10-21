Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22544C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJUWa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJUWa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B4D2681D6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDuOh010112
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=CTaq0md5thI5OJvZExYtKOztUJlIBDZ9hIcMzmqEf5M=;
 b=IZgx0QUp4worq17DGmW7lscQJA+q+1EHX7oFZh91bdIbjhRr8H1uc8vqhcmGaI4gVUdk
 kJQb+x0fYrQQtAZhiSFyxXDjnObCbtfCeNbn89Wk3RpZaJ9Mw3cdMGrqO+IWHO5e+BM3
 twtcGlv3DtC8/qH/DlhNvAYqaDD23AfDCy2UdWgJP5dvsMKUMIhy4GgC9sCQIy4Tv03n
 CgAGPpfQf7CmB97RdRSA3Em+Cnto+GBsbexyJUXFAiU5HIF1vkN+FTwJVarajrQ7JYRW
 nfXvpcLUKaqjFKpP89Thw8Gkpjo+hlrObyWKXhCH5N6qShcCOUi03u7LJV4ZUTGTLkBl Ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k99ntpm1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLC4nI007193
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hre87rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUfx9OVlH75Jzkp5VtHi1ac7GiuIlVftkv2beGqpK6bWlulwL9cHoB1pzmgzAPZaV2gWHJ7JNL0WcAVKzI0aUo7i0LLWvb/EdIzpou/sJ/7CpthM16HJmHRFjYIGhbkvA1RSWxyfOQLhps2hHuCE6Ao+fQvOb7hB1Y5vEEL/WRSWfTFc3eDXK6vr1h2rANw5CU1cuEXE1EQoGC1VtHizc14JwzDZZJX/xbpYSzouC1uRiQSvzfViIIgFYushIW/JViVcn9RwgfDCqPElJQw7IZKfsaddkQIyZFXjJZ9NP8TQB8q+BFBWZhShO8jE2pkKXEcqUbsrTIBoF5jeLbdFRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTaq0md5thI5OJvZExYtKOztUJlIBDZ9hIcMzmqEf5M=;
 b=heGRCbg3v+POx45Ub7jXfNQ6149GjL9+aDAVt7MgzJCmhHSRDlTebgKaUyTb/MMpP9kiCqfyQH56LpXV3M0AfjFk35NZgTAZPfNIk+hJpHoG8LYi8kmIE/RaMSg97ETCc1dAfcMM9LyYpeguVArfZKgv/Ocze/g7VjQBUDqdtOjt9kseMt9UaRxT68uLh+TN4jQ5xSCPC5qio8jQxPgc0895Awzc1KJi+iNB1QX65aFk3pUxSaK3/+Nd6js4VlDLv3uxmQ304o29vpton6t8Pguhl7q/9+U36uOanKsipltfNRr1T6lFScr9Lfd48jj3QexJb4rT0Upr2pGuU7GTkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTaq0md5thI5OJvZExYtKOztUJlIBDZ9hIcMzmqEf5M=;
 b=NfMzC4TONUnbEc+sFkEj/wtxMrMid9Ud0uexcLq1xYUwEpcU8fXJ5iHoRDUN8MbLb48WPmziLlF8w0nKHx0Ik3OCy26drDluOb8iBCGiMgqheEmI6O654EkywGMO17UxaPK8AXKNdoq6gii97zJgA/PPY2lTvPRJfjwMNxTBgCQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:23 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 26/27] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Fri, 21 Oct 2022 15:29:35 -0700
Message-Id: <20221021222936.934426-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0060.namprd17.prod.outlook.com
 (2603:10b6:a03:167::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 1810812c-b054-4d95-0b9e-08dab3b3d834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3Tz4YBHxkJLAVAFXoD8fE8qaSoqSv0doxb8uRoWmBrPEuT8e6AL+83OBpxQriM88lSvNrOFFcc4Xu8r6Iz7kh1ZvMYhgJuRmf705q8YkClseMqW3UnZGC78xEHXg/TcQ+YKC5N+ZBHlaTIjtcpesxe5p9WQMmN0fSCcZWaAZWA2Y2q1SBG8js/ZaAy4XTdBDFjVvotbxhsCcdbtDvI1KW76AHNQOKDLQz2EtAc4Tcv+q2HSqi9EXzRUCLOa09mWd4yJtuWoRB0gHLdvgqfytv1qwC4rVxmfQQ6N5I+gHkRUPI10nihg5dMVW2T0rnHyqvc4817Dp+r/h8P6mscQ7bBz+tw2ZP/V9XxKQLQZdPPqT3delUaawG5+rMoJirDbaSy+TEJsiUlF2rgzOKnzCu74VKKBw+EebxwojU2GEfXNkpnZM83a7tArcIg0q8wjZKS7nfNSBMj6gDJSP+5B93wWgHslaRXdm5x/iK7JmvgFHJJcs0hW21/LEljdUMhgBzejikAKwUaakxBRJZPCoSJ0329xhI/DGULMmr5kOrMe/uuiehPn2O+07Urqj731mdqX5weBza8Zp4i3fmhF92TDXLS4Ytmn09VXHet5metw5mzsanm4Ff2IEDgnWynk+zZpdeCsfaLuNUD3hZF3IKp1tUmP7Aq4WDg1uZIO4DQpL30eXsJrhiqH4vfDXCNCbQi4jaEQyhxq3ahMYQBKDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/4hcAo7w/J+qAvAMwXulvEr4AlHSFrsgIVDWinvbxqbEczi8uNjnDVElTXfS?=
 =?us-ascii?Q?IgdB6rfATZTU/vI/sGVv/yebB1wCrAvPgjFOA4RBhj+I6smcix9fkId+75zB?=
 =?us-ascii?Q?hs7M76Ch3MYT4QVHKbYf331+IwN7LHR9HCvyixr4I6rzccvayVgjbEqSdfRp?=
 =?us-ascii?Q?ERXOWPcdXmvFww467/hSyOrY23aNKSfivsSYSoKWig92hN1cggi0E2iHn5pp?=
 =?us-ascii?Q?22N+xASDWhJVmFZxakxttek2o8U+uIsJRJF8KVuEFxZW/HbEqCZVaWs+nlBp?=
 =?us-ascii?Q?k40aUl3t7yS5nuEUcW+eRVQzpbNj9LLoeYgUUOYvX1jUII2zjPcl3JIektlf?=
 =?us-ascii?Q?+oIrHXxsC6YKVnf/njLdKNcN2stdWVXPqtigoAitnlPKp2Vjqh3PneP4+VCG?=
 =?us-ascii?Q?WS1b3+fOTE5CE8jfmdb84lojKsSxw/mJbMTPUfRC8YxEhNiIFri5in0wlUMU?=
 =?us-ascii?Q?3w/la30ECctHPAplMVt/zXoLrN3k49S/x6H6MoWbTznYIx9b6JpUYdlu1p5g?=
 =?us-ascii?Q?dsA5Z7zEcDKU4h5rnNBl7HM0UOXBY1MfxOHVadPIG+72C80ALyyOYjmATOEt?=
 =?us-ascii?Q?SecLALWM1xIls9HbhSt8cSEhrAIR4c83biphAJIpQq0qsZLX0EOia7GLmaPS?=
 =?us-ascii?Q?eKD/L7l+Fg3iNoepRWzS/p4/3vHRB9tq5GpJXkx3FsMn3eiivORZpxoCmUAn?=
 =?us-ascii?Q?hUc6/EjMyDhq408gXGxQzkQlAL+WDE01Jmvgyicct/9rlFJhO63v7Z2+oMLq?=
 =?us-ascii?Q?8cnvrpacdnacnLAgd0AoLp9i7PxiBDzeOUz/zA0MVTqnB1xiTIZvdVuZ/h6Y?=
 =?us-ascii?Q?L8IDbIFj8tv2CtEjMt3VQBV10ZQEPkCZ2bIAqlPpS1SdJUE3rPudRJYb3DB6?=
 =?us-ascii?Q?jQQEVaMHHzTIZae2FUvZMuZPY3xPrGheZHFZpqWHJ5ct2nrBoGsq9JNnxhe6?=
 =?us-ascii?Q?upwFSwzvCNR1EoXloZ9VxI7LyxhOkvTNk/T0m+d64fmZ6k9B5CVaVeNn+XMu?=
 =?us-ascii?Q?RBFLOLNQIuS8jCJyaoQEj3Srwgk57Uwfe4SgMVAzLcBDMfhaf7CiCrCgYCzw?=
 =?us-ascii?Q?8OqOcykagzdCCOceDc4oySvCXN7Ie9uTocdfYl/OW0uu6crf0w+c8rQji9e1?=
 =?us-ascii?Q?hveWLD2kV1ObxKzzkuN97xcVDSsch3DQku3GHTjAtwumZcTTissZJAZt5wQ4?=
 =?us-ascii?Q?DnPQ3baXdcLaAM0Oq7JfJfl5sRhAyasT/77zTsGW8ljqC5DSUSJK8V99vqgb?=
 =?us-ascii?Q?/58H8/3B67wdgV5dermhJoFqFUAwRW3oPXgwKNKY/eU7u+fIleD6rMRum1pL?=
 =?us-ascii?Q?Sg3YDy6l0sEmWIVZ53cxvHuL0tWA8TK2cqsbdynutR0mlRH+SO2Gw9J1TRFx?=
 =?us-ascii?Q?QRQA2oKFhRGd38c6R78YlrE0MqdPYOGs1oBNmbAzq53NHfqVIcLoVw+fMobo?=
 =?us-ascii?Q?MNX4SAFIUbuoXDmIrOBdexslNvoRZ+3AsQwuhXPX0+O4Pi7KRgXFpZRsTdLx?=
 =?us-ascii?Q?iyUNGh75JCxsqnvV0tj43VHr0snwUlbe2SzsxziQlqOb+igoVjmRmaQPW7CS?=
 =?us-ascii?Q?viJScgsbs6+FfP8XHe/BNQKoEbhwbD14UWY6Y1DquDKwic9sTqyjCQsTNqZh?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1810812c-b054-4d95-0b9e-08dab3b3d834
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:23.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt/ZEhUWjf6XuDAPPquQbzqPRVzFO4J/ql+o/gmNyLXziNw1mgruzgLgO0aNhTqyknYCaKrkDDm7gH59lZViHXc+2bNJL9hVqZIdcvOtCJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: HTXn7BvvYiWRQU_Z0al_xvwCTriBa22_
X-Proofpoint-GUID: HTXn7BvvYiWRQU_Z0al_xvwCTriBa22_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

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
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
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

