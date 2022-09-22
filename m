Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDCBC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiIVFp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiIVFpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B877B1EE
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3DwSe022580
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=sLK3HmfzVmrJYM1AtyCMZ47tOOiD4I3AHq8n64Cx96M=;
 b=uhzpCUXYwE+Rq6gMwT4Vj1sFGn1vlPXFY/TJslir3oKlvpwBN/pqpkXQfPro3+wPNM9o
 rEdCIH713PVDQkggO8fYfTWuulSvCjUQ8g00vIZw39Y+ZGPV0/6LNyOvHDiAMJj9RqNq
 KEdkXjXLcHh6WczaaCw81BSGfZ2A0wdRjQaPI50yUdOyTGzHK+qgMvYrd4K344xYJf3k
 q2YvvH9a9oxEZ/lfy9vi71fyw8aZW00XHsS+cOg+PBItmlQzE6Jx44cHFWNRFjJPZVyL
 NUepRot/ZWOMlHBmJb5hMz5GDKFHeaVVF+847OZqbfk5CrmAZuq/G4NPgteQll1Y6/sy LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stmkrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M1wiId037824
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sd8vc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h85B5X1Z7x1UR9tmbq1zh2zYWnazzcotuxL4WlsSj1pOOMH6REXJ4RXumZTVM5OpObmyZ0YJCy0xow4cnfS58E2DFzpyVMnmvwRRGyUxc3n09Lkin4rGNJ5vdv+Mz0qcvSI6UWPfFragBH01qXeJSjW4Fsao9ahJwsh9ACFDViUdrAbwQdwE0pjnRdFZFx4ULRqmuih7MpDzwtK4qZ/WYA5DrYItP1PKLQOWFMAuddxRxnFoMJ9SaNHAj71NnFDlw/tnM4b5Ogs1iVR7XdxmGZXxzwWEHlSR82A8cD9jfi0GpS2nioPm9OmBOpYTTku1FzantrYT8t3ZJwSXyWDuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLK3HmfzVmrJYM1AtyCMZ47tOOiD4I3AHq8n64Cx96M=;
 b=Jg9yROMBfq3jzEs6G3d6/BR3r/WWaY1DHTh39xcWSRI70uw1QZeb8fugi8k/HXIjOzvdWszRMnvA7+IJy0O5j2EYX73uMjj1/bpJ8Q61/CY2h4TIK91ZlbAAOI/47DFWdKvHjozpAxLU1E6BOnKvXVQRxU5sqCltzZZhvSoaLUIPBsTMTW+u0zajkpZG8eQ38JGcfT8mozTwCen7yDx/NV15q7dw6rCKLxL6jzw4xnQaunpjVQocXiNtCEmtMTeNEq3XoW3KslkHdO5WkMNeGlnEsWNMLOwzLF2Qu70HvjBD4w5o53m4mFa8n63kG1BWzNu34+RSMdDELzccPvmlag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLK3HmfzVmrJYM1AtyCMZ47tOOiD4I3AHq8n64Cx96M=;
 b=ZQFkNnVQFojVuDAyKKwCL/UwKMmrzgH9xXce54ucRfq5POWLkfNo7z2DVBXamFOOTw3KCqxcDm1OZYrt9kLmDgRq0xq5EbTnLzCZe0sPyTvKYln5tGBF0q5sTO2gyxAzkrVG6wrR2J3PXkSX3DMnIFbt4PwjIk5qaJdKYR6Y26I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:14 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 08/26] xfs: get directory offset when removing directory name
Date:   Wed, 21 Sep 2022 22:44:40 -0700
Message-Id: <20220922054458.40826-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0005.namprd21.prod.outlook.com
 (2603:10b6:a03:114::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d0c092-e65e-4f2d-c1e8-08da9c5d9ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ok4I9jWUXtvUYnRNWIIxetsuWAhYulPMPIsYwv8iN959cxHs0YE8SCMPAJ56I+TtTMIXyG4SD85cBQU5lYaxH3Gp8IrijHDTIwJ4RnOwFO10XHaF/bfHMH9Oj0GPT1Wd2mC6RAVxorHaF+c4KRDdcgGqh4TnK+wXVt1aNl7AUyWkCdq4PmOCYstT+U0x+JdJfZCbBvoKX/Z5PpX47rAU9l7375IT/hHSFzKz2ZocODkX4pujiTHAp7jZPac9NuCTDNQPzbxc7rNgfOziE+Dvj7sUkJORWqbNtBlUYEhjpa/LzOBELOTmd2BkgdFWg8BIAKvQakkuCK9oqSzTjtG20LTzfVaSolNWLN7+MJ+KNmo2Z6bt1MkU6QOPUbjz/ALVaB9voITAxFv9/003zKYG5SemfT6ZoYksvGWsNApL62nAIlsC9bfd1cbUVf7Mhf0gtksJuhLIrpYOm683gIgSCMNA5ae4Wi3YK+mJaVcPqFhWMkhZmWiCou6wU5xIQcOP0ieAm05N/6CvJPHTZXXQiQk14t/sir6+md/CvkgPcOAPQ4IuwKRXEGjsYZpHrTkC8Hv0OKTVg0CYt6aT4wd5+eC8ww2kQ4Uk06GbtGLKCJl6xFOxhZxg/5t5IHh/u0UWPaNDxC2qGqxpImBm0lyj+ZDfS4GpZMkugczudRiIMuRTv60CsfSbepkbJNsNHDBIYm5UGr4e+N+0jgdgGZUK7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2VgMulK/Xjt8wyMYvT0hv5RGvMCqcSwD798wIex3qu5nf3AXlo6J5ryZ/bbv?=
 =?us-ascii?Q?MGpVvEOtlR+j739D1MxiaIe20IvHMhwQC+Do7En3ftBWvcFygqAjYlmxAJ4x?=
 =?us-ascii?Q?aFEhEQOarav3huhNpOp21ga7p2fHmqClz9vr0/rgiH81TqWNFnXTSLa+T9Pa?=
 =?us-ascii?Q?/3KbOHmLLhs8Gu0VuE3jvFdhwOAAmJEwe1izaHtglfF10FThEfemdiFXASvB?=
 =?us-ascii?Q?t4mz/oa6wmSKupWNXtfTN1JxDI8tyFYCaiUwIwl+klhpqNwfmDEDVerbXdHz?=
 =?us-ascii?Q?GeDfLAn4t9iEZFFx+LMTx39fjqLXLn9d42i8eEAB206QMXU4wpclwzvJfNML?=
 =?us-ascii?Q?thZ3xa0adGm5DnRK4heRtAA/1iOMA5sjnwFfq3ayn3effPYLN8UpWWsIwH2e?=
 =?us-ascii?Q?X0tWIFX4Z/yvS9+psBjhsn5ylu2FO+wwpRq5nHYbQV83YmuVk52uEyBuiq+G?=
 =?us-ascii?Q?QRWzeDFtyfxBdzlCELYrv6elxKH3z44nIeo0IEOSr3X/7oBHb7aUgHqByytW?=
 =?us-ascii?Q?tywB2Y2wjwPd760YB0TX8Y3LHiJdfT3cNLk7kKwBbaxIQeCP5w1xa/4HTeHt?=
 =?us-ascii?Q?F+MWNjqJj5sh8HxHDjxoCvrU/B+4TjBWxWgZ1VvTrSP4Ecxx6D2nF5L1y9Z1?=
 =?us-ascii?Q?Wn83LtcodzvyV8lZm839XE/iJrdwc/M3CDJHDF3hIzxXTxDM5HeHllN0YPSA?=
 =?us-ascii?Q?MYl5osM7nY3GPAuGmjVwFD8gQqE8lDzEn1EdxYFAR/5N1Tgs/U56vhcWKGHZ?=
 =?us-ascii?Q?ta8wKfav3gTO0Ba6FuVSOR+qrUZKzNA910rIIjE8wEAkQHvp6wVqg/FGd5U9?=
 =?us-ascii?Q?hjvd/Zs4L9GTPurq9/+yUHt6J0in/BU5l2+/bNRwZry6gge0xF+/6PW5Wkdv?=
 =?us-ascii?Q?hRATuYUUV2ojtETg8p3MnBq37TeTZicsf3qW9UF0d5Ic7g6AsEauAGYs5oqc?=
 =?us-ascii?Q?Pk+HYflsztmiyVyQZmFLwBNtgGl1gUmt1H/XDlsR1oWpSztr1IamqqY8cjSV?=
 =?us-ascii?Q?P9vJ5CLs20xk5x07CWWT8SIGlGUp8Z2+SqTAxEBA7cGzeQHf1ZAHJEajEXv1?=
 =?us-ascii?Q?fpB5EhonbLbKqG4OYL0dxGNiqTNStCemTCkBtG7VqguI+nqUeiYjihoAvOYt?=
 =?us-ascii?Q?jaGPji6izO667raHU66Iz6YYLW49JGXCMC2Jo+XTCsZO0/HdgxxLCyl8WaJF?=
 =?us-ascii?Q?YsX3rFhmy9YWlZ+kRWlQDFcXNZolFkCKEnuEihvefpzQnxzThmaMu5402fQl?=
 =?us-ascii?Q?wSTK26Equ/WrM3ZqBUGMJG53Zdes/S9PHhY1e8HjBII7xHCGADG1t3dPoNKx?=
 =?us-ascii?Q?OqO25WiGiwCTk2RVI2Ge3ebSTZAxJTv9cL9Ctm+IE+gzPlStPYvP1bqd7+PS?=
 =?us-ascii?Q?s9DaJj7Z6S6RiI+RGweBgwaibU0UDiCN5xUtp930da3pKARkyAC/MCD4Uozy?=
 =?us-ascii?Q?AkSlrp5brMeh5iXfD9xErCStOYLPVIFggFS5vkql030QStThJvtZZMKWOPVS?=
 =?us-ascii?Q?d2PcvAlz1/bFz3arcmOybJsbKFwMAJbQ0YUeh6NyUuFGDMqhaKpYMxDDtauT?=
 =?us-ascii?Q?5hwsbpJHiQyi8VciJHQeyxM5oKJPAHRAuR+ckJdUHSYCpudPITR1i1y0OfW9?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d0c092-e65e-4f2d-c1e8-08da9c5d9ee2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:13.8836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjIjTU8JhYWxsD9Q6qCjfQVTGjDOcF6RIOiZ07tQO7N2wUKKq+A0vASXSTbEfXnSCWt0fRXRsTlwrKfPCyD0evwv+8UnfnwfmZ0rc5Pztfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220037
X-Proofpoint-GUID: WHYj33V62LdNAgS3F4n5sM9-pwdnYLlA
X-Proofpoint-ORIG-GUID: WHYj33V62LdNAgS3F4n5sM9-pwdnYLlA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c0629c2cdecc..e62ec568f42d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 4d1c2570b833..c581d3b19bc6 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bd0c2f963545..c13763c16095 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1381,9 +1381,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9d4c9f53c435..d77aec375e38 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2506,7 +2506,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3081,7 +3081,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

