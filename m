Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D77DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D3BE61606
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhBRSrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhBRQrp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:47:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGTBFZ155845
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=pyPkGsE9LtCNd1wGUmUWCFc+X/Od/eso9pjU6a4Mfd4=;
 b=iaRp2R2kP3sbmHfEsuZrzgM74mhYQcWAX8W0OqhKfTN6atyZXbiAIxhONTGO+3SCFZVs
 owOGqVyYwpsiVoROSVh2RQ41HBKiIQgU63ZRTN81ozINTVJ4kdoQxWBpkfHRd0VXBkn+
 fnqjepMoA+Uhz0jXAUfFzu8oc4lkJv8NwOjYyGfRtblVf9pv4fnUUvgbuClWfmZ0ishy
 giZfO57V6MzcgCGCubjFQwzo/jRk7ridlgon3VD5jNC6Wvs9RdlACX9bOvXPdAmQG7dd
 u3GOkMzH9/dD8fjCC1wCPhiIMFg9/REfv2U6hi3LYdkkGvJQwP3d2bbxm075FgegORYn vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r6m7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGUJtG067888
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 36prp1rkpw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:46:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJ4w8hWhDFIKZdU0HnOWaNpoBm8MAP6IeyvC5jqDLyNTTfgB5mIZlrtIeAQLY8vLu/zUY32zY8Io03bFIM5kqMzTvxQ6M7Em0dQvJCNrwZy5X8bs9lrOvlMIskF2cxviWtQGukdLYwZbt6UWQ0q2ozEyT6rqzNPMvZjW+gPBttsVJoukG9prTUBPCO0wn1lVTVrHj95BvnuySyHK9je+hHtwmckEJUeemwCJZMTexwoiVM4ePfJRPO05kYUEH2T2Rc8LAP+GJuHjjsf9L0nRxbQAuQrpYGRXLhCeXkR+UfmQVpgCAIwWLAWNPgqEIjsExLAb2OFG4T9W8wNfgZGEww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyPkGsE9LtCNd1wGUmUWCFc+X/Od/eso9pjU6a4Mfd4=;
 b=dy1sCq7x6MAu69Mz779g92lm5FfvS62lnbTnft3NR0INGnXA3Fth5el0wzXJ8Pve//9C+i996ZybBD1ooJWS7tohmOvBeRjc9518a2rk9pU3sjSwRJuMNta68O3EmysUCzNinr51x1lkfmc+SQk3tqN8RBAekbMw/dc+aP5TDZw/rmAE2zCdjuIscUBZg5IfzMubWBt48v4Tua72z1CBXOsBR7bgq5vXTVjbP36mvGoPYtv62Vs1dzaL2w8UcKsI4ufI+/vua98RTWi1I6+V4Kpz++plVbuc+yFcATChzUEPejQA+PMJgCxcJlToJ0JYzpMbB8xxoOsje3aCXkz2+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyPkGsE9LtCNd1wGUmUWCFc+X/Od/eso9pjU6a4Mfd4=;
 b=cTZeoTJ13GmEQGjG+1HPxDCgLz2/oZfeWaLEhh+MEhaVztYR+3SX34WXOYFWfu7k6E2EyX++XiP4LG+3EjsbZcqsuBVzq3qcfh6yYm2yUBRzgDpAE+DjjssdT1WZ2Qw77QgLKSRsi/eNyPDrFTzbkzQNDt9aaaehNntcCYuHIxc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 18 Feb
 2021 16:46:20 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:46:20 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 37/37] xfsprogs: Merge xfs_delattr_context into xfs_attr_item
Date:   Thu, 18 Feb 2021 09:45:12 -0700
Message-Id: <20210218164512.4659-38-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218164512.4659-1-allison.henderson@oracle.com>
References: <20210218164512.4659-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR11CA0088.namprd11.prod.outlook.com (2603:10b6:a03:f4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e6d4640-5c4c-40e8-793c-08d8d42ca4bb
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813477FA817E5E2231B1F0895859@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:561;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KeyV1CdCPDx7e0ekYIJ63MGLm3Gkw6mqlDO8xMgRL6qQD/FjgqOX92aCl8RZnz9L3EpCq6dQ266m4+9sDCsONUSRbORwIqAhkqoG4M+523vaKmc8vLILWUjj4xpnv0UKceR2ODIN1MwcP09NiBT4ymcydcZ57ABikOK8B627ZIl87j0cXEGM3PzPbaLv9lrry/AUE1SpfCIXDgRJHoanJromPA7GUf/aJZj2FMxkIDDTi+8fAa/Rgo0Y6RYUKAWzDMo2RqzaevZhceZJdaEGj590OYqE+rHGyr/uGAHQdVMe4tD/AwuMs04QdeFwt6aBPRziLxvfRduB/INZBBzpiIuWKBb3D8sgO8B0vg+Sgt2BdWmr6cOeOfZLfwnS51Q4SCDI3E+8wfpWKgCA7t9XWiakBMqFp02jhOJGaiQEQC2CNp/dbPih2++TIp2e74NoZ0ms075xjyoIwMJercm3ZXlYu9cRT6uFB4auN8373LbO37jyU2pDmoiM+hQtns2VYvFsIvkxZC+4zppSUTbrmHBLBUihrKLSzR7XcauPPbwZ0gV4skk9qG1ufKSWAWen30E9wchEnb2VSyAZNWBnf1lB6c76TVYQpKUHyjvLgnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(6506007)(83380400001)(478600001)(2616005)(2906002)(66946007)(66556008)(16526019)(956004)(8676002)(86362001)(26005)(1076003)(52116002)(6916009)(30864003)(66476007)(8936002)(6486002)(6666004)(316002)(6512007)(5660300002)(186003)(44832011)(36756003)(69590400012)(334744004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EUnuuO4O18S0dyHum4KsWSQN+OiSZKwCRv3lypDU2ShA0lIK2Qv5DQACiLwa?=
 =?us-ascii?Q?MQDnjnAL8KntCXDL4r/0RD5x29YBY4O5W7tORFbY3MZyvNQfnaTdMDaF/q1V?=
 =?us-ascii?Q?VRNgoU0Np5Uv6Ja9LUUWij8x+vTuPG4GNiJVrNaeYmXgJgUGFgBQs3IknJpv?=
 =?us-ascii?Q?N6+V6X3fZNa5RbHTmM9K/XY2ps+FAHjbX7JDVULT3LKVtFbpjqlwVV76K/hz?=
 =?us-ascii?Q?S2cY1XsTH5TzEqmP3t6Wd7L74bSPsDJrBVxHgpn7x1f8YBiv1onnJx2q9t5x?=
 =?us-ascii?Q?s944ZbgHzSIAh6ffNXl3lSdhIIb/VrsbO1TDHslB0BJyLh7h4I8cX3ZgbutL?=
 =?us-ascii?Q?0Y9aM7gLEaoCKeJ4Fm5DTYXwlWunbBhbl797C+pRf1Eo68nhgn8HHOBjPafZ?=
 =?us-ascii?Q?RqaoHuRG7h7/qNMgaC9DLFkJHeuY04TRLewg5a9TCrS5yFKObs+UPPPTZLtZ?=
 =?us-ascii?Q?uKRRruxZJx1wuBQOqU5sGQ8LB2ewzIRld9PfVEf7fjeQfLYmCKuYH94qXED0?=
 =?us-ascii?Q?VuKkJPNrFi9AAGIaYs9bXc37ozrFEAQ7SvXe0PUDbyPcZtz/n/ABqKGu8l2t?=
 =?us-ascii?Q?j4KQ56sYdicjo+M3j2gnskIqVlg+k2VjL5JMu4bMO9/IZjVjs0k0TiN/RK4C?=
 =?us-ascii?Q?K9aKflwEuRJDe3Ysj1snWQq6mkCogXetQ3De6BcaRte/ft8CMce46DzvmJQC?=
 =?us-ascii?Q?vVnYU0uxVt0hHO7jo2m3JiwdwICFKbj8WAyDaLmX3jBn+Kl05BYZyU4B7/LN?=
 =?us-ascii?Q?qpyQ0zt9jKiwgQT8PkOOKJSERSnfdkwaRo2thGl3as+glASaGw9ApZEn2L00?=
 =?us-ascii?Q?2zmRKAf58jOdIRqS+R3V/m1VNY/+rk1jKfpKmges0qX63P0239Zs0WKY35Q5?=
 =?us-ascii?Q?zDW5OGBb6DfmPu4Y8jbCzfWPgkzofNjlbEQG6UWxpfHI6o4Biuclgv20xdA0?=
 =?us-ascii?Q?7/0DHiU/y307iAxvzURLjKENTGzPFzJb0Njv/Ag/jA7blUlgPbw/9HAscuX0?=
 =?us-ascii?Q?D4sH66Bys99schff9DY4Zel/Nqnth+WDBPOPHf9IvAII0Bze0TdmI5s6a0Kf?=
 =?us-ascii?Q?YX/SrlFB7HDIipKpeos2zVQQ8g0bz3/PcZ3mljf4b1R/9Z8im5slWP7rHZPF?=
 =?us-ascii?Q?5RHxpHR0p57+fgKpbdMuNctfo4ZE3B9biYmlCW6tzNYj8k2s1PXtPqscJfhZ?=
 =?us-ascii?Q?zMO85Hh7+XdNUq32Y93wUoVRJQdotai+37TjQj8e4wqW83h6VUosWpEXKZeh?=
 =?us-ascii?Q?KImeaVxSi1jr8/lwnGGdgCScPgzdus860WqBfrulZ6p2bbldPJ7lW1hB0Ftq?=
 =?us-ascii?Q?z06LYvyRkJV5kk875HCUPIL0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6d4640-5c4c-40e8-793c-08d8d42ca4bb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:45:48.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fjg+Ah41oQMB84TVwnnZo8pIGGfMU7EmG5kFgrHEGGpdSwLOetVGPNxkPmWs4gpBAJsVR+fOr2pOH3jjtv5obIKSkpRFy8zvy95QY0idhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102180141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/defer_item.c      |  14 ++---
 libxfs/xfs_attr.c        | 159 ++++++++++++++++++++++++-----------------------
 libxfs/xfs_attr.h        |  40 +++++-------
 libxfs/xfs_attr_remote.c |  35 ++++++-----
 libxfs/xfs_attr_remote.h |   6 +-
 5 files changed, 124 insertions(+), 130 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 054d158..04a7534 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -129,11 +129,11 @@ static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
  */
 int
 xfs_trans_attr(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error;
 
 	error = xfs_qm_dqattach_locked(args->dp, 0);
@@ -143,11 +143,11 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -204,18 +204,16 @@ xfs_attr_finish_item(
 {
 	struct xfs_attr_item		*attr;
 	int				error;
-	struct xfs_delattr_context      *dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 
 	/*
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_trans_attr(dac, ATTRD_ITEM(done), attr->xattri_op_flags);
+	error = xfs_trans_attr(attr, ATTRD_ITEM(done), attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8f638ee..91d5107 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,10 +54,10 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_work(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_work(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -222,11 +222,11 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_set_fmt(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	int				error = 0;
 
 	/*
@@ -271,10 +271,10 @@ xfs_attr_set_fmt(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
-	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
+	struct xfs_da_args              *args = attr->xattri_da_args;
+	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	struct xfs_da_state		*state = NULL;
@@ -283,10 +283,10 @@ xfs_attr_set_iter(
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_set_fmt(dac);
+			return xfs_attr_set_fmt(attr);
 
 		/*
 		 * After a shortform to leaf conversion, we need to hold the
@@ -324,18 +324,18 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 			else if (error)
 				return error;
 		}
 		else {
-			error = xfs_attr_node_addname_find_attr(dac);
+			error = xfs_attr_node_addname_find_attr(attr);
 			if (error)
 				return error;
 
-			error = xfs_attr_node_addname(dac);
+			error = xfs_attr_node_addname(attr);
 			if (error)
 				return error;
 
@@ -346,14 +346,15 @@ xfs_attr_set_iter(
 			if (!args->rmtblkno && !args->rmtblkno2)
 				return error;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
 
-		dac->dela_state = XFS_DAS_FOUND_LBLK;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 
         case XFS_DAS_FOUND_LBLK:
@@ -365,10 +366,10 @@ xfs_attr_set_iter(
 		 */
 
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(dac);
+				error = xfs_attr_rmtval_find_space(attr);
 				if (error)
 					return error;
 			}
@@ -378,12 +379,12 @@ xfs_attr_set_iter(
 		 * Roll through the "value", allocating blocks on disk as
 		 * required.
 		 */
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
 
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -421,8 +422,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series.
 			 */
-			dac->dela_state = XFS_DAS_FLIP_LFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -440,15 +441,15 @@ xfs_attr_set_iter(
 			return error;
 
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 
 		/* fallthrough */
 	case XFS_DAS_RM_LBLK:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			if (error)
 				return error;
 		}
@@ -486,7 +487,7 @@ xfs_attr_set_iter(
 			 * Open coded xfs_attr_rmtval_set without trans
 			 * handling
 			 */
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 
@@ -495,19 +496,19 @@ xfs_attr_set_iter(
 			 * as required.  Set the state in case of -EAGAIN return
 			 * code
 			 */
-			dac->dela_state = XFS_DAS_ALLOC_NODE;
+			attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		}
 
 		/* fallthrough */
 	case XFS_DAS_ALLOC_NODE:
 		if (args->rmtblkno > 0) {
-			if (dac->blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(dac);
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
 
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -544,8 +545,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series
 			 */
-			dac->dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -563,21 +564,21 @@ xfs_attr_set_iter(
 			return error;
 
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 
 		/* fallthrough */
 	case XFS_DAS_RM_NBLK:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 
 			if (error)
 				return error;
 		}
 
-		error = xfs_attr_node_addname_work(dac);
+		error = xfs_attr_node_addname_work(attr);
 
 out:
 		if (state)
@@ -587,7 +588,7 @@ out:
 		return retval;
 
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
 		break;
 	}
 
@@ -635,13 +636,13 @@ xfs_has_attr(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 
 	/* If we are shrinking a node, resume shrink */
-	if (dac->dela_state == XFS_DAS_RM_SHRINK)
+	if (attr->xattri_dela_state == XFS_DAS_RM_SHRINK)
 		goto node;
 
 	if (!xfs_inode_hasattr(dp))
@@ -656,7 +657,7 @@ xfs_attr_remove_iter(
 		return xfs_attr_leaf_removename(args);
 node:
 	/* If we are not short form or leaf, then proceed to remove node */
-	return  xfs_attr_node_removename_iter(dac);
+	return  xfs_attr_node_removename_iter(attr);
 }
 
 /*
@@ -820,7 +821,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1133,16 +1134,16 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_delattr_context	*dac)
+	 struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &dac->da_state);
+	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		return retval;
 
@@ -1170,8 +1171,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 out:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1192,10 +1193,10 @@ out:
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
@@ -1226,7 +1227,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1255,9 +1256,9 @@ out:
 
 STATIC
 int xfs_attr_node_addname_work(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_da_state_blk		*blk;
 	int				retval = 0;
@@ -1365,10 +1366,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1396,7 +1397,7 @@ out:
 
 STATIC int
 xfs_attr_node_remove_rmt (
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_da_state		*state)
 {
 	int				error = 0;
@@ -1404,10 +1405,10 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(attr);
 	if (error == -EAGAIN)
-		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
-						      dac->da_args->dp);
+		trace_xfs_attr_node_remove_rmt_return(attr->xattri_dela_state,
+						      attr->xattri_da_args->dp);
 	if (error)
 		return error;
 
@@ -1451,10 +1452,10 @@ xfs_attr_node_remove_cleanup(
  */
 STATIC int
 xfs_attr_node_remove_step(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				error = 0;
 
 	/*
@@ -1466,7 +1467,7 @@ xfs_attr_node_remove_step(
 		/*
 		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
 		 */
-		error = xfs_attr_node_remove_rmt(dac, state);
+		error = xfs_attr_node_remove_rmt(attr, state);
 		if (error)
 			return error;
 	}
@@ -1487,29 +1488,29 @@ xfs_attr_node_remove_step(
  */
 STATIC int
 xfs_attr_node_removename_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	int				retval, error;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	if (!dac->da_state) {
-		error = xfs_attr_node_removename_setup(dac);
+	if (!attr->xattri_da_state) {
+		error = xfs_attr_node_removename_setup(attr);
 		if (error)
 			goto out;
 	}
-	state = dac->da_state;
+	state = attr->xattri_da_state;
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * repeatedly remove remote blocks, remove the entry and join.
 		 * returns -EAGAIN or 0 for completion of the step.
 		 */
-		error = xfs_attr_node_remove_step(dac);
+		error = xfs_attr_node_remove_step(attr);
 		if (error)
 			break;
 
@@ -1525,9 +1526,9 @@ xfs_attr_node_removename_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_node_removename_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1548,7 +1549,7 @@ xfs_attr_node_removename_iter(
 
 	if (error == -EAGAIN) {
 		trace_xfs_attr_node_removename_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 		return error;
 	}
 out:
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index f82c0b1..ddcbfda 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -370,7 +370,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -391,7 +391,7 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 #define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
@@ -399,32 +399,25 @@ enum xfs_delattr_state {
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -432,7 +425,10 @@ struct xfs_attr_item {
 	 */
 	uint32_t			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -451,12 +447,10 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index d5c2ce7..b8f9fa7 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -633,14 +633,14 @@ xfs_attr_rmtval_set(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -649,8 +649,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -663,17 +663,17 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)attr->xattri_lblkno,
+				attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 				map, &nmap);
 	if (error)
 		return error;
@@ -683,8 +683,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -737,9 +737,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -761,7 +761,8 @@ xfs_attr_rmtval_remove(
 	 * by the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 6ae91af..d3aa27d 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,9 +13,9 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

