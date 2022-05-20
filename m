Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC83C4167D
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353120AbiETTBK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353155AbiETTA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF4C3151F
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIpY7U004407
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=uAcKtnbRW9X4Gywf4BqHAtkhV7n/jsxtKQjn1oELhVQXI3o0xIovHVdjtUeHbsgVIAQO
 ZYXAS20URWKkwlU7VXfL2u3mneVjtFHCEtyJordWtSOdxYXXU8Hiwxl0qVnIj1r2Z8uX
 TBfZieWf4oOJie+c2NCb40DgoaNTFARZaRUIlUk+qa1iYdmHK6y4qnaxMgtGdzwLc69v
 S92oB3+z+Sm5MkuJFGDwa7DRrWz+zbTWDKmpuBUVqs38Pe9OHWtUNiIwcK1CusbR5tp4
 fTtBddDtob3KfwnwpgoJPHg0jqxZafrRpuTDlgXzz8jYJtMF8MyiS8ykY1hf4tbfulSB Vw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfe40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo9u3034597
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6mhfm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxFxB144NYwSagMCmCcZOXjjM8QdzWFheZlKKwyq08Wnz26Ptdq7pu6Nj/kZxbeBBW6wpnd/yjz+mPQ5LRWxcEOK1KTz/npf0/gdqlCHayLGzFvTuAub1OOmx+NC4O1Rxja//8XRcLS14wXP3VZ3a3UNrEoYiMH87OvZbX2gNOQkhsPADd0h08+SIqh9v8ZE0q74802gwhTX/NT6QZt2cClmvr36yu2cmATlMAg8rkF0Z9DZTeSGEPgCKx5awS7jOEBreaqRtjl3u0g5sDyjj7TunWi6+ecdeyZOCJ8loF9+wy95qrVcH2v0Te5dcQ/tbn6DbkP5O3JHBGO0C9nrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=WZ/c8iQcXL8gDEw9gmKxA0n8Gv0kAcepVc10LLWzpUSF8XfJPN+Bvhhj8T3/wbeJD6Ku4rrV04rjFxY0h/XqsH+jb99EWrqa21mk0a4KCspmONnPEKpBAlNQ2JaCzdJXjSp2hZgS8NG4NSOh22O7ZDv8rpffwGZi0grIH1PKE4+BnOPiqSHGsuD06YmF4LUUgqoQHMMY112FeBg6MepnNGJW5PfdXBinEPEAfeHHreFNTJZSqIQTI+v9yBYq2BI5O7avFTiIzIHGHqvFh8Yfmx/jDWIH/RFP50m50qfitlLYTpVBtkSkgu6G7be+3IEvdQE4XutCe45AlGYPknxslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbngtfzYyfpNTe0D1vPVep7igmHNQZ63vwmOjhc/7YY=;
 b=ZGBHkOi0FED2nAOZXkwXZ1EArpKkH9kxLAjXTkXwV6bsUTD9+aKdg/wvcGF6rbrHyw9z7PCGg0hEbGPafnAtCdNo/QtL+bCpP2UH01NbLuZ7GS966V2TataBBH2Svp+R00iMp3IY0CLuFLgnFXFoXS9hmw/qQqHFy2Lw+QxS9mc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3399.namprd10.prod.outlook.com (2603:10b6:a03:15b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 19:00:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:43 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/18] xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Fri, 20 May 2022 12:00:23 -0700
Message-Id: <20220520190031.2198236-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40a9c077-8204-4f21-379d-08da3a930874
X-MS-TrafficTypeDiagnostic: BYAPR10MB3399:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB33995AF0EFF3D8C12DD9E9A395D39@BYAPR10MB3399.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FbKwemGuCl1g4pNPRWdSE2exFKToGVRhtflvlIGVpdpZduS2TKcK7jc+w6FOWFDfdA1TGVCEt879HKaWfPw8tFRwzvNmUtBtdlPRGmWMTCCqi1IPl6+3G6OJlZhOxxchhY9TzFYRPWHiqdJsMnOF58/RL45uRAuXRIdVErBlGS5ZSRi4IsHqlnoUOJ5Qy1XxG8wiA93gWeaxwMajxOPpUqzj6V5PPj0BR29DEjDAWkJC/BE18SnozD+kAB2AMWsPzMIwYIGjexv2dDEs05vMBcSb69MrqwbX0Rm4LGoIPzlVxDpzIfrK+FWT88bfJPQWeTCEUZKcQ6XMJWp5/Y+3c9hnTj+tTd0QglsAbaJhvcX6+1E60D39RwYPhljAJjC2GeM9DZZRJjyfbNaExZbi9dogsDhd9s+CGPw1klgV7g6HFA3k2j9U76R+Gvp5SXSrjPzkpsIF90Jb4cwSfqByLhgxCmIgW2weIb8smYOm1tv5uJkzCceslaYIF37AcAD+hyZjIMwprLPUJ4MMMVuidJqSrjfcPyHGrYarTHIiH/SpT7p8cu435IKB6BUs0l87InMrBtfd1S/qDKNtrV/DB7VeokoB9sIwEMP+wzSHNqEq6AcKeirbzhSjf6Vxt8a6bam46JkQR3CroKF42TN4oM1G2B7+rTq+EvrxMSLvP31iwFU7svs+SWLcFJ+jeSuEsoKl/nho2SdV+Su6zq8ahQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(6666004)(66556008)(1076003)(2906002)(66476007)(83380400001)(52116002)(26005)(6916009)(316002)(36756003)(6512007)(6506007)(66946007)(6486002)(8936002)(38100700002)(38350700002)(5660300002)(186003)(8676002)(508600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i3hSgjd9dZkugSnogHjf5wdJC8/3VuXeHQ595GFE64HhHjo9F/NC7VGANnz3?=
 =?us-ascii?Q?8hJeaj2lGjwGZt1Q19eECb88MeqD+NMhFjUDAaRq5BDhA1uJJgcZbitCPwyp?=
 =?us-ascii?Q?ztClIvWxpZuyu0tOKB2AhLsoGjSfoZ43VZtVSuci4vLDREbG94wjvpyN+5am?=
 =?us-ascii?Q?KO04lJlHjSSXtYS5kmzyFoJph1DvdLUlV5rB79cSlYfTum3/C/xDITUS4wf/?=
 =?us-ascii?Q?IvznRX2b2RVoEwUuAZUQw3aMu5C9CH0SPB+z66/98KNIRXOpo3M77f3e8ROf?=
 =?us-ascii?Q?0ysep48WLA1sjGfC0NduL/iCIqfYk4UwxUfPz0E8sTDMAHe+A440nn50quTM?=
 =?us-ascii?Q?lA+Jw6kFB7h3lJUOuFQ0NO5UxLaxiyEp793+IhH6MZvxLKr9wD4xrKYK7c71?=
 =?us-ascii?Q?gjvc56KkyjyMVZbOGTsa1krnxG+R3Y/pouyhLEi9EqbUT38A6V0lV8HoA3wA?=
 =?us-ascii?Q?zRrzIGDX68d7D8E/v1q4s/ZApE69i3Jm/yZBisDnlc3DrSqgOvGukotjyStm?=
 =?us-ascii?Q?/WEY2QueXdSSuldDk0TbuFhTOT5FvyMMJXwgud7bq58X9zs2pjMZJ2ZeL+/B?=
 =?us-ascii?Q?CFxbEidjcRRkPcsar+AHQRxgoqCOPvhx2RtPw7Ld5HiHcngQrw9KSX7RYDef?=
 =?us-ascii?Q?F9mFMEvQ2ztxoPZJeXN99Eqz6buiTMh2Mzz81nE51tAD3NZsexolweoAdrf8?=
 =?us-ascii?Q?gcJAn1UsGsyJLfD4ZTSk9aw2d8Ip6UXrNkrzFqkvmIBw9gtTTFVJR55fj2y7?=
 =?us-ascii?Q?e6pVF8bu5vt51qu5ptPyZg3lvtJxHlq0uuKVKGzqXRPF8gzcyLCblFMFlv5D?=
 =?us-ascii?Q?a2/Ml/qcU/PBY2+onqhiMyS4GPCB81AYBwiJg1diMZWBod/iaXFRBZecO3Qx?=
 =?us-ascii?Q?zMXjqdg0O2teAdh3uwemO2ZxZawB2uJZS0luVt8B1Lj9eQ7larCxuwCfB1E/?=
 =?us-ascii?Q?L+w3nPiB7wtRuWkAqIIKCrxV8bfk79l5ihOVvgiUW5p8cd3fWseJwhkd/XK1?=
 =?us-ascii?Q?fRMLQO8FWi3cCMZ0gGMn9y7D7wn+p0s6vprpHWQy0WaXzVYUngu45Kg4E8Uy?=
 =?us-ascii?Q?upES3rxTE94MePaKWx9hiW25AwMwo5xMz+vw5dSoq4MmlQ7PRwASgmTqON+G?=
 =?us-ascii?Q?/m9QEleQP0xJDfwGfIxRavwpC2mRUGNG4u8AFtbsB8aQ90+qUqWZMjyqKWLH?=
 =?us-ascii?Q?0PGCex5U5OTpxjISZAy+tkOLJtFh9Q3M7nBIVJDTpQqQjFdbyrJXc+g4+YJV?=
 =?us-ascii?Q?SJDdgT9aHx/xOMkIxXj9o4ZysoohLrUajSMXVRjGWByTz4ndFPRUiBYZBYJl?=
 =?us-ascii?Q?0x0mGdZG+n0nrDopYApJPSx3lWV7qtDOexzzuYHySMLDkxbN3xGzyGNMLnhI?=
 =?us-ascii?Q?yhtTfwgMNIXkwPxRIBRPRpUHT9eS3xRnWZVkV9SKpYRiNqFu3Te/URZ2IeYk?=
 =?us-ascii?Q?Onoz1MgZfAb9Y/8rPvIgAfUCied2IrWLlPcJ1C8uIvnYve+oePEfOVCc3BWv?=
 =?us-ascii?Q?phLHHtCxH3GyaBDwH2zSjAvjT1JGC6lAtqpRRFx9ri/dYJjLND+cm/SAGcdz?=
 =?us-ascii?Q?reH5bo7d2Upcozxrk79n5vDFdD9v8r0pPDiRu5TT/lgezr9hEMELX0bcBeo0?=
 =?us-ascii?Q?7AttPXEyH/sC9DZ2394UJHPQT/RVjeQIt4sUeqJON/QhjeNVsZp0vH5hcWdw?=
 =?us-ascii?Q?JuLAKwdoeD6TQapnuTc2QDTs2Fvt7OGp4qTcp0BZywk6y4aLsHZeBksm3q+s?=
 =?us-ascii?Q?x0IG8D1OpU8TyO4c0Rshc9QZRgvjsZI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a9c077-8204-4f21-379d-08da3a930874
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:40.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0UQTqG9qd0XajCtLYIWNKRn8dFdZLCaGE90m/MfhEn90Lfuhb/Qnx58FqWw/8jNFagY8f1CdUk8mX5VNBmIlS1y1nwCdF75PQMmT+vigQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3399
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: IQE7uV6fJSSe0q8KugF9XN0vjzR9nbjW
X-Proofpoint-ORIG-GUID: IQE7uV6fJSSe0q8KugF9XN0vjzR9nbjW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: f3f36c893f260275eb9229cdc3dabb4c79650591

These routines set up and queue a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/libxfs_priv.h |  4 +++
 libxfs/xfs_attr.c    | 69 ++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_attr.h    |  2 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 12028efbf802..718fecf72614 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -601,9 +601,13 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
+/* xfs_log.c */
+struct xlog;
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
+int xfs_attr_use_log_assist(struct xfs_mount *mp);
+void xlog_drop_incompat_feat(struct xlog *log);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6cda61adaca3..4550e0278d06 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -725,6 +725,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
+	int			delayed	= xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -781,13 +782,19 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
+	if (delayed) {
+		error = xfs_attr_use_log_assist(mp);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
-		return error;
+		goto drop_incompat;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
@@ -805,9 +812,10 @@ xfs_attr_set(
 		if (error != -ENOATTR && error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_set_deferred(args);
 		if (error)
 			goto out_trans_cancel;
+
 		/* shortform attribute has already been committed */
 		if (!args->trans)
 			goto out_unlock;
@@ -815,7 +823,7 @@ xfs_attr_set(
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_remove_deferred(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -837,6 +845,9 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+drop_incompat:
+	if (delayed)
+		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
 out_trans_cancel:
@@ -845,6 +856,58 @@ out_trans_cancel:
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_da_args	*args,
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+
+	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
+	new->xattri_op_flags = op_flags;
+	new->xattri_dac.da_args = args;
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_da_args	*args)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_da_args	*args)
+{
+
+	struct xfs_attr_item	*new;
+	int			error;
+
+	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b8897f0dd810..8eb1da085a13 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -525,5 +525,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_da_args *args);
+int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.25.1

