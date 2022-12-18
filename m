Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0E5C10F1E
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiLRKDf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiLRKDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEEF6352
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:29 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI6o2HD027811
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=hQSGeVxMg9Oxa7zMHPoLfKmlpChEMa4ibrl58i9jUcE5JtetLqPPi8xDvRIXWlf7+0L+
 yA+v59UJJNbo60V4/l2gMbl+icenkGaBK6cZFuxCGspFWE8YNMZ2+kAZ2tE8RcuutLt9
 Ui8RQcfVgAUSyLyNWHqCdScRFoDqtRzIg2hZ6vDBkghwAJrA9rvlOvfhMhRrbHwDGOSJ
 GBLFXHknDB8DqaLsTWOif/ih4lRWruzqiORNcqMb0x0TE43HhRBAT3jzhD99qdoBfdrT
 krD+ak0UBoLTH+z2ql+3l9Yv6WxMf9hgzOeQ6vHxVeWdnUJulBq7vfrgmz9bGitEeJfL yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn99gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI7XHr6012665
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472cfty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFL2jJbJv5zgFoa06ypFQ6WxcQQU4qoWCCX0xEpzHDfng/3dyxc4NpSgAGdOO3zLf9DVuEGAcnL7H3TLLKp9qN5QrzOUH3zsQIgrnh1Ns9OlWT8HZATJz5AaIJwYfhGbRes/JzbVl6VACU/nI5Wmb0OGLkw0vI/jKu7bvMB1CiGObGR9wEGjuJsx+rRM1HT+aS5cx9mxCot1OrySK5KuG2nW3SDey974vURBqsUcbpGlrs+GshKSeTqfPQMH+2jsrHnHPUUHCYX5FkEqppyIyUiVYNzdK4jdiP0RFIbplcO1gnqQL+zMysSCvCc1magSOMSt+v7fFL2qJe6gZMNKAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=KJkPNgvWn/yyTc4DNojS0ccXxPIkHu05XUpf5hHy8pNNTbUvnv8fybgp9VoxUMOf63oIFEhIMEAHue5vRKOaIRx42Vdstk0ieCY7yDPaPRul0WRswE6HOdH0CmodKYfzBWbl/bY1bkZOwdR1uqEHE7kGG16+OX/CUfw2iGPfqub7t9Rflb30jjTosjF/xBVRqgtTuqsWaD3OoRJXRZDxoeFBRM1ATPH/lBkkRvlY3GDfDYoSFZrxkOQfVAA51bzT7gxcYfY7uDVeoYN88JhdKskWsPORRkMtFbcuGo51njAeydfUtfo/oV3GSJOR92IBtovL/9uQPyW/IIwhVP6fmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=PmxbVrDY902e2/UectKW0KlXD1Vm+NA1kuuRgWaxKZt7h0C5NNQfUfrNEKlvAKgFX3JLQP0p88wB33Oe71vu5IK1fWV36hNOjjgcPzwIlC2Ads7AU4Sot7qn9A+zfpyQYlU8eRGzw+6pAafkiYlNYIjL3zHXHKhm9cjsb82f6mk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 12/27] xfs: define parent pointer xattr format
Date:   Sun, 18 Dec 2022 03:02:51 -0700
Message-Id: <20221218100306.76408-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7d1cf4-d878-4c3d-5ec0-08dae0df1b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9TqdlN7elzx6ZRVD/f3gSoma2vZ7Vgt8C2wlc/cjhvq2fZgO+ora+9M+t+XE2MB43FWvPIF7TX49aZI08HhYhqdkCNwEgWRR42W2Ir6F5UA/a8MQnfnF0B7jLco/8cEnYWAFGwC6J5LNcE9TRYVEVgQjt/RivbksTF2O4T8HWZpFRnQZnNes9OgTMRm0VoHnFkit+c8P70CTiDo3L3d4jKGLfZau3zd5TL6s3XlBozFzge5nTnQ95Y+1sJXdlWen1k+46F1g1aPbVv6zl+mV4s3tyrUmcZZSYdlFui1DMUIgWgtbcFPio3w2Fsp2G3EWbi1xVu55pRq9bSXQzUPgAPE/gqZWkPGjAPvv9K7tgcODN275b76dViDrSD6JHe4zj++e+mJKHfsZWK8p0Vx17LBE+MnnSIRWqTgsjlL0oB/otf6YdWHVpCdAKXMLdulIYkurgMJNbXFSB5U4l7Xm1OnJ5o/YXQQ6sl6qDk0i1zpU5zaGFZaWVF4Wv0jbYiybaw1LJFDr1mRNNgSVMJr6xU4r0UGXoe6go6zsoZKkRn2TGd/R7rhZq7pkxrstRdt8OrXc39YHQL4gyJxw7RjmV7fLyxJSRLaCMajlhJugw5DA/COEpTs+AMt3ydQhw/t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FA7FmYEalscKPb7ltYZAxRBhdJPTVaqAPqIgF3y3ZQ7Ow3B7xVjRkAxKtHO5?=
 =?us-ascii?Q?QL54V7cllc4xWwMHW1KmbXvx+IOJnjPXKxN40ACAYc5C/VUBqyNlgET2x7uh?=
 =?us-ascii?Q?UEN/Mtq1ti30Y70ZiqGXbXnKNkNejp2bfiTsswXHt7XVAQS6Kg9BW4S995Gp?=
 =?us-ascii?Q?wIiLuO+PcL5xhGo0djN+cFeRZ4T/WubfT8LgcfD2qHm2m58luSPfCeke17dE?=
 =?us-ascii?Q?2YzaDrfDFSF6L9ZTxxTI9lTII484las4dXNThJrzy4aTzPlxLd7F1dlh9kdO?=
 =?us-ascii?Q?B/TOfqdqmJk/aLzbAwVpfrsokUlIJy+psGJKyFCe3dLjkiAcTOqm0QucCffZ?=
 =?us-ascii?Q?aMjg66+Eyz4+HuyGXW3gywCkeiMijORXtZlWRc460M7tt2QG0iwi4/+JPHEF?=
 =?us-ascii?Q?OV0CYr1DRSPuuRaSerU2PBCkljxEWDRz0nNuLYRIMSPjQSz70xuWUqTzbRSS?=
 =?us-ascii?Q?5izOaWrLN9UmKmB15AIohJVSloPCX+6KDv73A1cWvZybxxkG+bzsNnW9IXcS?=
 =?us-ascii?Q?xrMGHDN14AT4PUd9B8Rgb187+BkPAijRup76ldFYPuvm0cNcvFsiGPTbCPwS?=
 =?us-ascii?Q?MZ/OWPFp6gpRkP9zzCIBUnoBEtjYEFUT18Z1VA4J41uNp65fJnJKf3ihUaI8?=
 =?us-ascii?Q?ZsF2kG3gcu5RbuA1wnr/umA1GpqLXsUJH6STsvM6BRtGxIvlDATGonpBenSy?=
 =?us-ascii?Q?x5wwXIGSpUwb3OCLOkS5TBd5EhzhS+sgeCuEn1iGA5OsX3TUTKmXReokKLgL?=
 =?us-ascii?Q?pJMVA4b/yOf8ZC7HzGghr7dpuhtksvE4ia3U7G7rNdmIMGMStt//KCMufNCG?=
 =?us-ascii?Q?wwISBh9UZ2b8kkRvrF8/bvLSYf8cI1A19WJV4T4a32F3q6tjgLK4WUaVK+Td?=
 =?us-ascii?Q?c3MuO35WlXHg/EVBwQuTia+Tty/HtbvP9qp0isgn0mpcNc6DKPcKYa+0yfZs?=
 =?us-ascii?Q?vhRMcKk5KCJ3d9RnAxJNmva0zlWiwiCoE9xo1/Hr/zCsJd8j91tV8LxRcWop?=
 =?us-ascii?Q?AUpp0al4O6ZnMdzN74qkJijrPiz5jmc5wzzhaP6v+1Bd9vjcvBtfjkXljdG5?=
 =?us-ascii?Q?MB3BLFUJ+5wTXqceRpGWGju8BebfTqqFfiqFabc5ulLNxli3YpFBYFG2fCjQ?=
 =?us-ascii?Q?LCSoWMRyJxGcWdRAeScr5FD6hrUKpPbwLGzzB1PKHLO3sFtkyO1ocLGxxvl3?=
 =?us-ascii?Q?08lN3dnfFWJiaB6qcQnBpsXRozTAldNyfRm3SM7xw+wea+4m2ePfKiG5/QtS?=
 =?us-ascii?Q?sLKqVA1FWpG8RrzhPMlAQZx8EpTROwATwDwKAJiGINRlJBpuEWltOrOhNy2s?=
 =?us-ascii?Q?Fpb/iRBfmqEeHPC0QP3u1+HcJLiWsu2QablvxVziO+CBcBDJPNlNNpVFPH+z?=
 =?us-ascii?Q?o5oDrSwQQF89cCk4Ue8hxdqKHw76WcS0fC4DQpbjevVn8nFzPA87GiC6flBN?=
 =?us-ascii?Q?kOxselW5cxp3fxez79FntTmdNBxpHNfkOFS0Vc4YApeTfM5EBiYSQQJGzauW?=
 =?us-ascii?Q?JvPkSox8GtyzBrJweOPHvzNdORmOl4xokBfz2uX4jjVJe/e31AmOi4UPn4nm?=
 =?us-ascii?Q?j2984qUE0WXZ4NAF6IjkLruG27WpHNkB//tXekTEBn6raw7ftE2wzZXdbs9C?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7d1cf4-d878-4c3d-5ec0-08dae0df1b72
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:26.9780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKzN2O17+HHQko0cFNwJpbfnjdtRMYA5zGx28+tjP3a3+u7/OQYIM1DmvYPhYDdsnzIdfq/hqSp/FJAhay2M227AhNmAkay6l4aiszxNWXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: 1OhRuohPXyx2pNmtEhuUeWkJyx8XD73R
X-Proofpoint-GUID: 1OhRuohPXyx2pNmtEhuUeWkJyx8XD73R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

