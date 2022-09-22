Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944ACC6FA82
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 05:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiIVFpc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 01:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIVFpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 01:45:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53514844D0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2022 22:45:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28M3EdcB005902
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=B1EuJTcz5NHwuGrJQZW2MftKQkvAI0wnC5x+NVW/izJN0UH3tLN88aUgf2VZzwMNs7ts
 a1MEl/cmmYQBLSHjiqVtohjTDcj9GTk8wreauKs5LSrphbbBu3fjv4Z0j0qjbi4dDqFY
 CY5bVKcmkKCtWRzl+Lm2nZ2wSNV4aPHCMTgj+lpy7F1shjX3vdDtndm/lxK/+Gd3MmU5
 5QbRpl8w4LzLvbwn8+GN8UDJa/ARUcpihuBNWhuJmM8aMj/ujfuUzzVTyzbWaXj9ohaw
 UWIp3O5xIox/eAKLGMvJOh2QsOn0kmDzVyej8SVut56I7O/1UkBk5SNIW+PUR4oCLSzn qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68mccuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M5e6Ca034206
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fmur1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 05:45:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H25FTAsV5k9Vo33Vf1EzSsAMVPBdNAQ3Yi3Lx5ZnK/Zj2jmZ9TVnnar/VDLeBp5/GK7QOqO8UeBpKPOvgZk51jrTzFY5IZSUxULZXdePu1495iuTo2hJ+Oiowc0p5rZ6IeQRp49Z847QFcO6ouzkvafW1oJ5WFgay50dhEGLPabSnGl5Ip7krGvYAbqTzPdROKdk/TVdzlB1lUtYxny9NbASqpcl37hdZSnLAJ1dyAsP/JiwHmY3/iiXs+xyzu1UobUP4BoTYqeiWoAJpskU2V1egeA3QGhs9vHEbv5mYSgzeybGunyq45cuxpM6dG9YklaVFMBL+pCUb4wL9DdrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=A+o7QDJd1d5shaP7zPPIKbhQ+Se/7Y5juufqd6KSc1W98XfkB64G/In/A0jirwrsC4qBPik3K4gRerL6axl140o+CBL25/6C/4gUuIswnEbehlrwaYsgTuWRTGP68SsFc6VdyreH7jgDta36g7MmlmetDVeEuz5XvDyHN8MRKy2hpQJwcnCaQQ5gsoQyIkrThG/tj5brqFs3BjRjn0xNhIVld5FA22513KGOrRKZOcvIoEExR/ScUKiqpZpf7CKSPEJhxUxTGwMnVbIHkCUm+yt+9qZ02STQ6BIhsE/JvkDYV+T4rsVeT8FJqlNlLnYJecSj5zRxp/riiKk0dnfMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=qPbTy++r2ClYsABH4W1XIMzyiVs/HmRmUi6VotWJUoWFXK6qaEwVYNbi90qZGAcHtVBcFm0xPowwJZ19b+aKiWIrs62c46k3uj23N3zcIzCQxWucahAnhIj04Iarjear2EVkIm51PL5jzJMLPMK9ZWdapX2jwQzCn3nkjI+qI9A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 05:45:17 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 11/26] xfs: define parent pointer xattr format
Date:   Wed, 21 Sep 2022 22:44:43 -0700
Message-Id: <20220922054458.40826-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922054458.40826-1-allison.henderson@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: f888d9b7-0473-4b21-350a-08da9c5da0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bCo4tqiKkdYcckltl2i09Dsh7wbVZiElKwkMTUsrgY64uks5Jj0Mghvlu2n6796RkF8L4G6ePhHqsdETwcGraem7me+qS5JElNDYWiuGSUj/rgwYA5ol3BHPdFATED07YXckFqiLVyH4R2ogypOIEPbJQ7bC8lhgmnhnPqm7ttMxkQopdMpZy14WRzoGgVej3yW+or8L4F0YlmS/z61oftWTR7WKiq9ULgkard3yj+bed/nlZudPB0pJaZr/o78+vnNTL0Rfatmo0ya1f0FQm8LXVrIz00GBWbdcdRHsuvMNUao1gFJDzhfygeaJIO3T0mboZuPWp6HPZrM0fJtKDv/09IYP8hF6WGwOqpLfHQQ2qmDsSPDPpYUscT54019cJrQ1pjgtb540CfZ+UC13BLV7nxkQtD+TIRNnL8a81VI452jIlO5cz4fbGk+PbOzFiR4DUcntQyBZrK8fzW5nPdM04JS4Af/hceXADc8N7fH7Z0kxTfZRO5bRGWig0eNsnj/ghKPdnLgaw4AGdhgJ29J1epFyK9lUiU5rU9hUT3m0XByM/a6m5tviEP6TxCK17bMTBTDLkctLWbRpKqz1GuNEcr2rsLWYPrOxV08ULJwECM6xd41n2zpJju/tT7UT+dbdVIxjC/7erh0YRTriqYt4+Kq5an7AasKf78QDTgg72bI0dBpZD+4sK42xfFnBn7DpznShTL6odPXHM6QflA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(38100700002)(86362001)(66556008)(6916009)(66476007)(8676002)(41300700001)(66946007)(2906002)(5660300002)(316002)(8936002)(186003)(83380400001)(1076003)(2616005)(6486002)(478600001)(6512007)(36756003)(26005)(6506007)(9686003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uxHhaW15GMWCXQAMyPcPRRM4cA1J57i4E9x0b6z8/H5Tz9Fbg6a5SoN5JMvm?=
 =?us-ascii?Q?PEv/ufQLaNdUMnY+iWvKCRBn9K6i4WOcm6UB2aL/HaLrhELjUrAkiWoPqaPX?=
 =?us-ascii?Q?vdlgegH2hXNcaINdfR470RwgF/4pDorYqTZ5aQCGaQg5nBL1KCS0mMjLZtzS?=
 =?us-ascii?Q?GCr+S/gdDjpUhjV6UTqDzdcE47yL6HB5iU+kpSEEz2kqpkzRmOq3UyKunXZg?=
 =?us-ascii?Q?YST8yyDbeHTDh7zwYDRSUMz/wBjEgdnfoQDD7r3C6xt5XXf2LlrlCiJVaYx8?=
 =?us-ascii?Q?jMtrt6FKjh3ud+/wKFn3D5FEOfDm5tPOBHvUdqSJwMHV0/olVAnDv+BkuFH6?=
 =?us-ascii?Q?hsJTx5INr69zp424KeBcpl7tkP3T25IYUfRRFutZBS4P6WbJakhPtefALH+E?=
 =?us-ascii?Q?PUrp0ZRD624luv/gg1rpD1Hgm89RS4iRXsX0BqxvFYr1O1gXnRpc61VvXPBc?=
 =?us-ascii?Q?ByVMroiEzeq+/ays+tqgTKs/RP+DwlC5YbjiKln1Wimi9ud2FgYDnjUQV21L?=
 =?us-ascii?Q?b4nsAS0kuY5+cmEUAvvYGLNrPM8mFOuETibBu0NE1RHK0tgFRsagv0mz0juj?=
 =?us-ascii?Q?C5H2LlndRwjVWD3maKFDFmQ+QlxEtKT+ZwScj1qOhlhHoWGbzJzkvVZ5DiiO?=
 =?us-ascii?Q?le35M3k83ciZ3eVwWqrzdjTz7dcNnMdzJQK0PZ5JhI6AxBzYyFAK2UrCPs6y?=
 =?us-ascii?Q?NPO2uqNcRPwrztv6z4Eb/6PM3XK/+Ue+XO4SsO+A1x48BTGBL+vqdW2BHbFD?=
 =?us-ascii?Q?6wNDHMPpnXohxPeGyqmDXGCr2o0xoZl/JQLIb+Uk5xSBT98TwTIuBuiDunf6?=
 =?us-ascii?Q?WMZG/dHks5RHe1/W7SCDwtSjrQlVw/9n2Yb2h7yFiXCuRfDIZpD1+GsGS/JO?=
 =?us-ascii?Q?r4/eEBSq9TM7wqsEL3DJhoTS2Tp3MDUIyhUdorUHjtemYO4YOpXlIuyzOFAG?=
 =?us-ascii?Q?B3CUby55rxopi7mDkMysid0F/1ImcXKB0XLEYEum7tAGK+kspgqzBR8tZcp9?=
 =?us-ascii?Q?6CDH8V/YMlIzPWsPSCn5Lu+1LTihZJo248nDEGiwLx889sab1buZvK9nZ5r6?=
 =?us-ascii?Q?93DmMiki6ywvANiH3WesCXcew/NwPtVnmRxaDU3TjM6V3zr+gKaIbWfmzoxN?=
 =?us-ascii?Q?vDJjyaGBreIVRz0df0cMCDPfggLIVB1pzOiZGf0FOlXpbZvdWRjBEQsyadSO?=
 =?us-ascii?Q?RkLh2CPtZehVaXgzafCRjNPJrCv5cktk0PqPqhWSe/7i+2yQyqSa9NzU/2So?=
 =?us-ascii?Q?dPtC+UbA7ZuGwLf3lAqGcQd9ULWFp97aaFEC2/Pj3QWlKDPQkXYSesSVwbpW?=
 =?us-ascii?Q?7zaUudjmQ/M7v9LeVgp0KoyS1H7nZE+PZmliPn7+4XtFm0zjvwIDWxNRNfan?=
 =?us-ascii?Q?Q2aKyu2FczUR8XvmwatoN4LXv++aYiJnrNZ69NPRzhafjUzbORMqMwbhVjnD?=
 =?us-ascii?Q?YPxBKKhdDgHvAgFY8nSQgtCkT8R6LGuvinuBOfQBJDk41DTfI4WwaQUgsW4Y?=
 =?us-ascii?Q?EgOqpMsyWVZDzIYKpW9M8WiGBfRrIqo60gecOJ9OYslI7bZuzrUJ1zhhVZIT?=
 =?us-ascii?Q?hhocGhRGMjJQQWeAx+rVFfzYXXakMDniVrP6d5VVeRbyage2tJ3tdhhlcr0M?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f888d9b7-0473-4b21-350a-08da9c5da0cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:17.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cKhqv42kWIEFNZK2xieq7ewdiYcIxxiPCUqOpN5ouvLtvr7ubMVLdNPVZZx157ZOf5BYFMnuD7UCxJ2KjxIXFJo4WZ39ZKAt2kXLp5F1JGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220037
X-Proofpoint-ORIG-GUID: IDsqRIrH3pQyuvnVz4kwFWNuuSQa1Qv2
X-Proofpoint-GUID: IDsqRIrH3pQyuvnVz4kwFWNuuSQa1Qv2
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

