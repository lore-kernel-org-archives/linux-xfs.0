Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A146CCA481
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiGRUUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiGRUUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3D72CDD2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHXEeJ023346
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=P8b7B1NTzD65r+vZnKz9nGPyp0RAb1K9u3ZLCQde0PshCU8xjU+zhg1unksr9twXfarc
 CPyXFFbqsZT/HLkPyttbFVLQAJGiSBJQKZ4EVo3bKfCHT5doYehdttOPgIix2fbL82LO
 hcYdb0nILQMY3/k4pwYwZTak3iz8kFq0TkaOWUXfHN7eRdzXSWkbYXv8fKvFPj6GVN1A
 WzmrR1S3yg8+qhc9C9MxffMvx8znGjvUjLsPafYFB8HP6j9WSOFvzC/hIvHF+l8bB1re
 EW8jNNLjfagiaEyvme6kCJvcKkunEaEHfu0jnJX/sokCEqhdpPvc+dxOTV0R7fOGmRET /w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtce47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHVRRw007937
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1ekx2da-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zh20/Ay3zzSuwRFjF68o15dq1RAx3EEjtP+48xHhO5tYKMHm3A6gWurNb2uwro565JJkhoCzsbqGQsIyF4LR3vuITh1o5NlX/yCAQ7X0daRvSIWkJcHqOKbrIs3RwT2BKuymk/40Q4JXB0tFkPi0HVuP6KsTA/2HELiFUw/+mCl8dClSdDS9l2Ez+g7D8+nTqMIrHiH6uv0qusyG1fE7kVVHmmlgj/pbdgO9Dtu+yQpS/JZLXq303RE8t+p9NIS2BGH1xEmawqtee2LKHCArCbaJd/MhDCJCjXV4+PnLTtk7Sft7w1qLD0mpVU+mF8R+cq3MnSGCUj3GGZhRP5Iyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=FW6K2yIRlvDd9bCPAly3z4fVk0sPW8zKvNcplRyh9+/nixNP7ZztvkL5t8RFF7f7qbWO+gy3pc5aZ/+lz6++Ax4j83C6KAyvtSUJNpk4DpCzEwsUM2xcl3EaZFzfqF+gFCKyee1ok4Uxcr9AB7NInltq8BaaXtaIY/VwM4HIfsMFRCQQwXNimOQb97OiJznKJy3jEcA1pDlS75c4EzLFfoLCg6JzWQq5k7UJtSUpifOLTPaFS1NwlQDjraM2vnMBNWHzSs9Wn5/uKzFz95Aew0RoEf5HNngYG3YCaI/f8wj+Ts4qTPiXvdVaIOlUcQL8Pues0y/aDFY9Udr4lTtMBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOMCi0kif4HgweEAl9oe4JTtLWQrwgjrJVBb62jZI/8=;
 b=dQ1PR/I57rLjdQe2lrJns5yASiyyPT9700d1+3hCeVUzUqLsFGoIpu3XPbQpLt/xsnyvwd1znpNX83FkaknT4Gj/HGPFvdYH9ir2q4zVVA1fj0rlCXvOAA5mHaCWrRmteaaovYP0NXoETyT6vjeQtbPb2y3qpQeepVSCaWxSf2Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2717.namprd10.prod.outlook.com (2603:10b6:805:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Mon, 18 Jul
 2022 20:20:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:35 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 13/18] xfs: add parent attributes to link
Date:   Mon, 18 Jul 2022 13:20:17 -0700
Message-Id: <20220718202022.6598-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0572e256-a844-4623-1d9f-08da68faf742
X-MS-TrafficTypeDiagnostic: SN6PR10MB2717:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t37hBhLKB5I4QShinhi1tSKEhahM4DOQZeC70a2uTx6H9V+JTjXJzzn5WUEFWPvpB46CzGuH2JNJFhyHqSDx6lNtVOqANzRN1775W4e/2wqpmqO/00ZWCumNGLPaVaFmxM5JdLcuch34sl7fPGgUEguy6Dmz5ldc2igaJCWP2VbkXpiOLeZjMXE6KmLF8qqW6m9g0N0BI0qHolG6szAKfIP3lX/ZK9Ubxs0voyrTIoHQ2IwfmUrnyMNJie/fAxVDlT10+e6jQm4Mu3p+Vi7VUN1QXnOcn2xDu98h6yxY/C6vRIGcRzsu2dl3jEeax8kh1nNuJucp7zPAaT2dUmZoVXHK1IED7Iei/x6S0c8zjefAu/x1Zxxdx1tDwGBcnMBirG/UQhPEZwIRuFyrzuew7iB/570n/eDgQVwwbWU5inYpbphUzQG3hZXAAZilT28YdlUVLYXSPBtVAWw+BX/mwAJuq9oEYKTdw5sbJg8Bk/NV+KMDkSq207L1tDTf3VX++UlQwhpdFBGxydp8Jt79TJsRZTMTaVGhBoj/aUWVjKeYEseynR5a1WJkLNVUHWeuUsg8i0BbVI/YtYc8+rnrSjM6sYasS+n+squb2yqXfGlPx+ZfLAw/1ppoJ5z8JnzBev3Byc4w4AiiYYf5zrJj/kzrZpZt/pjiNH1tO+qIX3z9ZczOlwctVTlcboaVoSrpykSwJ01cdd/CFA5GqLiCdr5HbA2zhWLxYeQMtjV+klMa1WosGH2OgCQDW8jAwdzPc8FQppnXk61rsyIXMorxgipNU04GDKrBOCsjUaOGs94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(2616005)(1076003)(83380400001)(66946007)(8936002)(186003)(5660300002)(2906002)(36756003)(6666004)(44832011)(316002)(6916009)(6506007)(26005)(6512007)(8676002)(86362001)(41300700001)(478600001)(52116002)(6486002)(38100700002)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?75a1jx1GIVLzj9zgluqLN51rh6smnFNtWGX5Uc/PFpRJigkBuxKN20Ssy/mR?=
 =?us-ascii?Q?6dcT4NoqtfE3uzp46jOAVor7Ol7CnhcAe8p/RDKJa7163Cre7jxu33+oy1iB?=
 =?us-ascii?Q?imgUcal/FpdrJPYAasnIg++BVPgH7dt2Z9bnPhfl6PzD5s/w/VKYWbEnMNev?=
 =?us-ascii?Q?Bc3cc0u9d00GkhXBKiQz1LuKj6+KwO6U50ODQlgDJ5gyX3zUVnmgvdEoKR9D?=
 =?us-ascii?Q?4mQYEd9nlR5BavFE0G3uXVlFPyjLGZvssXZsV04Ll07mV3KAIt7Q3tkkBP2+?=
 =?us-ascii?Q?/hQ96yX3eU2jfagyqbWhr+E74UDssN7OLEV61nyYCEadYjFbzdxuP+VeTJMT?=
 =?us-ascii?Q?XeOpw+Xb/aRuHv2INsnmsmlBjKhh1P3gKCH7EdHo2XJm2V+9E/8EJee3Imgn?=
 =?us-ascii?Q?VzAaTyaUlzOonyW9iCGEZN94SZoLWZHmmENuW3fb+FE377gmYRpXGB7seXO2?=
 =?us-ascii?Q?+FlNaG9sFABOCVhKpd4p5XSQTNGRYiuGBChDnzUSYDgiGvruut6kyFb2gEN7?=
 =?us-ascii?Q?O8wlBMoM7Hzee98KPm+mOYx2m28DZXKUQjJDl8xhbbNn80VLGAcLEt0Bnot/?=
 =?us-ascii?Q?jw+JcLmPruf6+EhDIJIeLqbfFz+RnOP97uqLykKd+RXAsiKvJm2GYzMr32Wj?=
 =?us-ascii?Q?uQUtW6U0IbOgjdl2pHgJoiaebYjdzHz5bQWYbgZSu77HoRAuLAmB7UEKaaaB?=
 =?us-ascii?Q?Tzlrtz0lhkgZgEF6TTXG6WQtOsLeQ0dYL2wJRqZjxkyVxpXrGYnitm34hRln?=
 =?us-ascii?Q?Pj/aa29DHWjRbrp4sRklEbFzVWPDiusRhaGtJf8PZ4gwmILZnNp8uBNHCv2Y?=
 =?us-ascii?Q?vwOz1YOIzxj2VBFlMskfnSJgdkkkBsPepRzgIv4omh4T7PhFGTDlEDIuOEc4?=
 =?us-ascii?Q?dLZteIBTbbP0N8CaHke/kpL8oDdOTY56sgWNfj6vfFoNR1dUxu3AoAjxLt0/?=
 =?us-ascii?Q?vR+2cYPSZOyO/3CX6ozgvJTPHhHoKxJ9Fo6M3rmpF1yOT9BkeUHUBsWIXrMj?=
 =?us-ascii?Q?IfFIEyaghiajN9GhnKjGugkDvbv73G1G7Sth3ju7ArphCqG0caBh388iU6P/?=
 =?us-ascii?Q?/ryk4huYlfTF38i9unLSxXFMPwIcJSmTR856T0x4gn4/9KckDFoyxQUXlbah?=
 =?us-ascii?Q?tUg2SjfcOW4uqTnzA1ZLBShJG5C1DcH5B7qHlBW9y5kiaNcapNSUpvS+T0gV?=
 =?us-ascii?Q?2ukxZ3/MafnTKihJ1IERu3nvj04oTkjflB/p4/m7d6EJuuNwBzS5odZEWh/y?=
 =?us-ascii?Q?APxQftrpNHr/wm0FMCVKfqmTxFB4Xq5EYPr+XG9B/6RLhV4/uCa5XDIWlTCR?=
 =?us-ascii?Q?7l+++wX5+xFr7olCQ+R0g8g3X1sHgamTYaj5NBvWnLINmxTFaifSoDHEUGZO?=
 =?us-ascii?Q?2cn0Wlapq0m6MyW1YNItvvz20Ex7l1PI9JoDqGFBlHsN1w2gUfA50yaFZktM?=
 =?us-ascii?Q?DlZjForwGtREWaRY9UODJcX7lqcve9SY0WSD6ywMFe9toKmcTFRmGYKyWuZ8?=
 =?us-ascii?Q?T5I13bw/xXCu5w9lCa827F5SZi87xnroGr/hf9Xy+PLpBpP7MljnT/eh13ME?=
 =?us-ascii?Q?jm6z9t3R43otBDh+U3Kg0bKjl8GOQWWTpEFW2V6m3ziekdLQrJpF3cTagw7t?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0572e256-a844-4623-1d9f-08da68faf742
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:32.6858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1wxeG7w8e0K7xBm0QavkzLNy5PDGPnH8guau3iJ3QVQN+Js23c15QeHhyLT52sKfxFjW5Djv/yol3UmwOD0M6BcX4V+Htf3Fa32858zBfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: 6gW6-0OK3ugGTPfSZPTuw_89vZ40jgqL
X-Proofpoint-ORIG-GUID: 6gW6-0OK3ugGTPfSZPTuw_89vZ40jgqL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies xfs_link to add a parent pointer to the inode.

[bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           fixed null pointer bugs]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ef993c3a8963..6e5deb0d42c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1228,14 +1228,16 @@ xfs_create_tmpfile(
 
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1252,11 +1254,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, sip, target_name, &parent);
+		if (error)
+			goto std_return;
+	}
+
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1289,14 +1297,26 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, tdp, parent, diroffset);
+		if (error)
+			goto out_defer_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1310,11 +1330,16 @@ xfs_link(
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
 	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
- std_return:
+drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;
-- 
2.25.1

