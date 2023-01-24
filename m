Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02114C05027
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 01:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbjAXBgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjAXBgl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2023 20:36:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7611A483
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 17:36:40 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04qRa023718
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=ZCSxSUTnb29Exq7NQvSyJuHMg1yacHwQi9PP3XWqqtr+0jEOBaTaQ3rRZd+gNlzwdSls
 /76CQeVo5djHKb1+uSzR6M/rG4/T9VFmSN2mBzTHSiOMNxDitGD/YxVPPuHPYTD6yGSh
 4ZlRoYd5CqJ+gAe7+NnMHlUIGtU5RCym16X82Us5G2ORb4GWfZhIYUh3ePAWMRcqYbqS
 MMrnTpG6RxrPEWGqB+blaumeWP6kYGipAQb1UUCbAt56k6OuKKnQ7Saq/sQ0j5nbEAYu
 hVFyYLHQZrIRbIIDJiCCMB0TJA+PXtxTdxm5W5Hd0U1/GngjLlQuIDPok6EiICxdQemP pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktv8ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NNWhx5039605
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gb4axj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 01:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Av7wJv16GOMW4Ov0tZV6P6+qOhXmYZ8audt9vxMsLPzXfs9NYTfmU8QlyYFt8bC7jPUtsuoeRQDqL8lX9HsYTCYWVKBCH25O56/nabtw7nV/dyhh4EL1yb/j186qynXDII7YjIM8/0kB23bpHVApiCLWp5jifgVQtqWuJ2GjpgU5Gb076pe6idJc9uS/7P0RgAzMpoWwJDAhZ2gKZGKmkog+7egj5evA9CYcRAyBASSb2+kXTkQ0KCGbq0Cm8gAGnnrVwhgj9UAE66G8r8bg61SR24thN2QzdvyYuoqmQurYy31c+74cAn16kY0k1NzZHmAxF6GOpvrMzFQAg+oF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=a5X8xZV5kLLvVzRqkwxprBzj4Fi+BFXIOtArtQYjd0gBZ+hzP/A0gEEZP/P2v5LWU0nC+QIAuynHTvj1t+N3OcsUjEJi2Cmn0rDRR2tIFCOv4gdtg2qga0iXZ+GPNbUtM511M/+sG9k3XI19M9nKMav4A0dwDWyQxPpZ31tKPBXiZkzvsR/iozjUJ4AMw7RWSY9IsT0HNm3/A+0qBeU9RCZUlGCeUz9aKEaS0u48qvL3WV9XMH6VCy9YLZIQDj72RSHpom5mVVOlIypzHUzjg+ELFLrrnDwke1CapiJWnbT7PHxp5NTmQT0v9gBCAdQ055RtLklfguIpKJIvj6s3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mD/+w/gIEcqSKEpz/PYuGTNBS+UC4p44L++8n5sVQ4=;
 b=wJ4HeXVIaCB2Nwq/CSWITxcSUJ0rg52MLswwu9DXTWegri/4k15CKs+wKZ9RLdUvhefljaogXCmJKNozFHAmPalDZyGlxvmtNMZOs3V3YcjMb6PkjXm7ePHiZXISQTluFzx2z4M1FD8MzcUNTFlgmLiMB0QMcxNuS/HaS9STcKs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 01:36:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 01:36:36 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 08/27] xfs: get directory offset when adding directory name
Date:   Mon, 23 Jan 2023 18:36:01 -0700
Message-Id: <20230124013620.1089319-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124013620.1089319-1-allison.henderson@oracle.com>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BLAPR10MB5041:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ea23feb-3af7-4774-4eaf-08dafdab6ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZpXOgTBu0GfIAMxeejUCxOfTbeciF5HTzbLUTKkj8OrxIcKy+rMlPuXFlIlyARFYV4t/HWHc4VcKda2TNGT6Dwj9WXGci7qf+QxKEeguFaZ5/MQ2B4NdKjdXPgKDm1fUUn4XlcDU7l6prlyVRQEFYjC3tEn2p0mQDunsftNdssu+XXBtL+RpS6MR0lpJiYx+E/PEJdXP1W1DCD2sIHJk12ewkx78yKJkq3Q9PVIugdtb8VjjVWGThgJUvc8GVvzs4KHjieLnQTtI/wjb5pCpWAQPWvNUsph6JIP64f/3B7yGDgl4VvQ91uagbURr5Ntug768pXEzua3sfJcFyn3tUgYdKMzfOlZO+v+vxWMNSg0YM1tqrvfafwQf2oaqMVICjgiyO4Oso89BlkxqlBgfJacPSeO+55SsweAjIcErEJ9sksmzjdpfMA2or6SMlfguoA8MYpt0d8eKE5ezaoLQjn1turmydHwCtp709iUJ4MsZcaZIk8yTuVBDq/TJpT7XcTjNkRaceaAbhwJSw7giSP+YVM0XB7Iv1yY2D5proBN4ZJAE0PsyP5tcSV4XBkFJOqAGSkRS90yn/jDjljM/z1N4PhjfJ+JP/FHXLxw6UcfMntDXmNQqJxX4I54p3h6RygjVfYzyqVh66HAFYKOzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199015)(6486002)(478600001)(6666004)(26005)(6506007)(9686003)(6512007)(186003)(2616005)(38100700002)(1076003)(316002)(86362001)(6916009)(41300700001)(83380400001)(8676002)(66946007)(66556008)(36756003)(66476007)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/UIXyxVHyv8TXubyNoaGBB5WvXBuj7miV5X/HylX7Me2g9Jqu6sqMmOZAD8?=
 =?us-ascii?Q?wDOYcCwsFtpSn3AcRiZmCKUYrYEyQl4byzq5rMwwe8NEr04bLEc0SWCcv6In?=
 =?us-ascii?Q?oCkL3OAAAGiEC+LBOGMWIf9ns76w7KOiz0/R9MPimeTkiCokrRyKyJjcZh/v?=
 =?us-ascii?Q?KUw0walJ+UCvABOEvnTnPLQEEdxLJfMbx5wl6Lk/M5RkL+GAvxChahFZ20+e?=
 =?us-ascii?Q?B4JgmnYpEMycCC8FdCvTkiYTuDq3DN+CrzGRFyYvYYZ7kQX9N7FsnfdDQ4Wq?=
 =?us-ascii?Q?p9ZmoluwiOQyDxjxUWArC2GL8DFe6ESceXrlMEm3RQF6KRBMPRnpvj83zaDW?=
 =?us-ascii?Q?KUW7RyeqFx9dnRVsQ8HmvfrcQl6jHPgEQAnByVCBXr9uGKIjGcTl3MUHZ11/?=
 =?us-ascii?Q?Yis5aNCZJUeFjD2CDVZSqkKNPJ2wRNOol/q4YHzOhrXgqgQEeQRsc4lzZYV9?=
 =?us-ascii?Q?jEzeHtrMDPoTk2Ov3C0+kgGKJLB9Ln8AJsI51+dY5W4sf1dhNLBGgbtDN5yK?=
 =?us-ascii?Q?E9NiTAd7He+lAY9gQXggVYNrFqMHHgTmP8Rq+OfUdM8OmzAwkj6pgBI20Ql4?=
 =?us-ascii?Q?m/iWfvJGXhSlHEmssCuJ5sES1TNfTaxovpLfKd/tVhISBBmTYJM69v8rhCrB?=
 =?us-ascii?Q?SIkmhW0hnDnmWZ/qQJ2jsxCtR01eVTtU/ZI2O8YB7m7t5nDn0j47oY5c7haX?=
 =?us-ascii?Q?A5Rwjl2ifsHePnoe02LTLY9Mi0VnrCf2aFiC/KQpLyt8Rtarr75S2gRkHMZQ?=
 =?us-ascii?Q?n7IibjBRx06T8+5DCjCSUYRnVvt9InHAv0Ylwojm2kvvj1CNwsAqwXGsC/ct?=
 =?us-ascii?Q?rLjnvcuvUPz0/DpJiT21iyS1AhlXD9tAbtE0EM4DEibcEFGHRJ7xRDRVVWC2?=
 =?us-ascii?Q?SBFJi3X/OvqfzgWQIGlOqluHTk66J+1eA/Wsrt2p+TUOncDa70vtXqM6+kd/?=
 =?us-ascii?Q?dIB29hd13dDPpMTmcS/ccjo76Z/zVZixtQ9fCFh3R79YxGHnpEsu69mMnGuE?=
 =?us-ascii?Q?/i6lIdF4b1YiV2BDjgE7jLwjMBAaqlxbL/twSI2IwsuqJQOCX+Vzzx8Yeptb?=
 =?us-ascii?Q?4k+Jcuey1wi+gttyG+KMGxmSKIjiJ0hj5Ky+fp00+8SQ7vNhGX7EyLulwUbU?=
 =?us-ascii?Q?AGwh8B33uF4sRBskEkkfGiFNpe8O1iUK0dN47ARyMVHkP6d3RnWeU5KBNgu9?=
 =?us-ascii?Q?DGgJNpNcFjN0DzASKswCHU+F+YrfMdedq9AnYzqluzNB0yTP99KQW3mn61RA?=
 =?us-ascii?Q?/LV+TEr7OHf2SVYgKYk/3bKV0vQE5D6JgE3Sl9ElTe01KAX6jcG5+WuGGoCa?=
 =?us-ascii?Q?DerLv6Af9LBu7RsLKP3ClQTpEKR9wwVuTDOX0vNXGV1k7ZgpTJJ11okTK7E9?=
 =?us-ascii?Q?lXEmAHjoRyCzobjOXSl6ZRwyFCickXkaO/Q0/HDw9otN1oOFtaBrFMzbnLJr?=
 =?us-ascii?Q?Bk+TVx5DT6Q5pBQTuNz1Efr9Bm1MvpPty7PVE92TjJZYe4KbaUrJA3kXnq1e?=
 =?us-ascii?Q?QA8CXuob/vBARoqV4dCZygHwhHPeiGV4+jfBM5KVwYorkzemy7DJdd4i4z42?=
 =?us-ascii?Q?2fhxWAwr8+dvFzBwgZIMXjTT4iTyAw1peS6+N9s0hbZRZXvxGpcpTV2wDxNE?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ePA4JIzcFWZapNYK9X3p1fo5JP3xyCelXpQfkOXw4JYDLi2Zs4r9ibCm++YI4QhbLTpghWVYncd16FnNU4ak3GGc3rz2zOBXavHzwH/xiHs05vdfPTU/7mMwaJb4Hi5Qr4l3SNeVOBSnOGfEyzKcxXzhNtYB/P2SqP44WnBK19nxsxROcjI/1HybQ7mvw3DM4zCmSTgzIbLm9atdM+CqkHBuxF2UuBMJwtpoUbPjblpWHMBruppkQWPdJx4yNX3cFEnnnF+nHK73C+DIt811qk7vPHB3/Xg+7NjSpOFpqo9BaGfYYZmGWUkMk8+kdWNzOEPqij1HVXLPXuiObJKa4wIM75SfRHGiHQYcGpHisTlOrKq334YHF8fpM8Y7nPmzi/D+avEmP4vkGi0bMqln/jKDnvl9qAaYVYOSuOm3oSPdRPo6rwyr4X84VuK/if4plkUjN3yywsrQdPvzTWdRLelOduKHFvj4TXHNdJxhCBeEtqCqa6em1sAma4fe1dpHWawTglDz5IR1UmqzQnRMX+VLsGbfi/+YGAHODsIptzRBjY9jy2DERpvmadSfvSqcSeW2KPCy6qg1xp/lHy3vtBzv9y3fT147fSSbUXIMb+xvmMWeOJlVdgDM5iMt7wPiOq27Cmt/7zLL7cG62uTf49aKFinIQ/b3LfjVl2NCWJtF6dd+IMCge1Wl1YFNzmoiPKqbpqS2RTKImvegpcT6lLl7Za5znmeCDWNehC91HRLpGSVlqG+9zUfjvdpp9o9lV2Qc/MhUYOKxYCFioqtKaw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea23feb-3af7-4774-4eaf-08dafdab6ec1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:36:36.7149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ET4pPrD6Ovtu80ZTbMFaWrIIvfAABVkuM5mw0qz7vZnQLcZyJL38H5zKJV8I6rcS7PFtLa6OMh1F4v7RE9YPD5CY5sQ63/fUtGwakTN8GM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240010
X-Proofpoint-GUID: g2-0SYxmkP2gWWph_QqlvmBLEk4ytWLV
X-Proofpoint-ORIG-GUID: g2-0SYxmkP2gWWph_QqlvmBLEk4ytWLV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..69a6561c22cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..d96954478696 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..9ab520b66547 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -870,6 +870,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8cd37e6e9d38..44bc4ba3da8a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 267d629a33d9..143de4202cf4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1038,7 +1038,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1264,7 +1264,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -3001,7 +3001,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

