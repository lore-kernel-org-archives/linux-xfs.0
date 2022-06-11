Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6971DC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiFKJm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E436FD25
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1uTH9025474
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=pSeCaSqfRZVqqmeIpTq9APffMY8QowTFI0cbOfoab84=;
 b=O3SKXk6P998azEMUJpqGguMTI4zgHDR7+GFkjNEBr9NvSzB9VBo8FpeCuym4eJ2L/mAN
 rEk96PooYRRmbpHgKlUVyDAIL+U61lSu02HXpfn1QCqCPoedjXGo2diV+ql0OVsB4A47
 UwhTAjhFPk1YhpE77azzWo9srayaUIRKdLALVIGe5blCQaS1Huyo19C7wznyrkUPN/0O
 6bDkjXWewqDCuSWw8Gx1tvI2qhLyWa6DnpXbWhPy1OVFrCoEa6cQN9OVU+wKbitiwlhx
 z2SvkmNlIbJ2xksajEw/MFhRnfwr+K108ETlnTErIHyMTyJBAqRWzxJtRHjAh6b9kXDL yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2gbyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9allG001303
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0m9ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAhdDdYPcjsaDgy0cl9H3PkoSDjQ/0ex/fo+sP1nKvUDeIP5AxdO5YLV4LvCCP/PtMel5Ktt8ulcVJ1W6UL98fDSq89Z51FFda0PFDcfe7phOvchKYUnkiEUoqY72OkKuMCpnbP2Gnt48HBAApx0S+BesLsoB8H7OUZSgTDEvLRWwan/SNYnOmzcGq7VaRshEQfPOH+BZIv5AckM9OqKrfpYN8CiSY9lxF/3EQSSfEFIH7caSXHvti83GYJyaevsjpsp8YYsVk//a4xlLiZHB854KNyMlhLFKXrSosrAukl3kmODKEIu9nW4gZwuVTAYUuCnacBhEGecVOMsJx4sSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSeCaSqfRZVqqmeIpTq9APffMY8QowTFI0cbOfoab84=;
 b=GqVHSyQHXfiW7QB3Vr83WCo38IQoIn8KWTWoOSPAYDgr2M+FOfw10cRFYLZTZ6R/5mdqz+3HessBS52bP4uBGxPFEAJ3foaIJWDnfGV3wHem24skX9gwFXaKRZ+xYC509ay+BoBZ+5QF5BkThZ77Fx/ArcdBCxYcargcYXwu2L4k0wDBM/LohLJJiA46S2lGLEhCOCGfve/aw8S/onu20W4jAA3KR4HASRzQthyu0z9h5Ir3VoQtHNP5+B+jfeZPlE5fag6FOlC9ZoYlqTetvQHA7RqdNhXQdIvtDT3850Gx+5592CkHkRyY4miv/XcJIINENXTxdMnRS/l6p8htMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSeCaSqfRZVqqmeIpTq9APffMY8QowTFI0cbOfoab84=;
 b=F+Ock1k2MOyvLMuw3oOTUic4DxIa6TidbljlSJfZbTH7KCTU5DLR8Lxht8ZQom1Me9G1Dda4BC2Ml0PsYLil7HxODVlku5CCoBmAGCPznpkfcuf9qUQ5AOUJxOENIx0HDqD9YfR3Pzg/BQ35FNp3MT+JkBKksUgvg5N1DOK2ZFw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 07/17] xfs: define parent pointer xattr format
Date:   Sat, 11 Jun 2022 02:41:50 -0700
Message-Id: <20220611094200.129502-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a70e475-3e37-4e37-cd7c-08da4b8ea6a5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4606413C928961BF25FE1C4C95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5kwcGi5gm1SGKyZquuFLeoJIXdqTgL6o/HX9rbO9682LxLoMiAXemPGHCvFpMonEUQIG+wEDJLpOzhc4syXHc/Vh/IwWhvqFWTfwkiDhClWCz9X5RDWN4nrTE8gsfel/9R1wOmu7SsT/hd901fPUqnC2eLhDN1a2Ih3U2z5jPk0h6EYlKFqT4EeaGwOUf/0X6XBJKrUKOQ5/2wSBxql/l3f9NHpnofu2CGkfUZYA5nwOJJWBh7xuqR/7tj0wX/NQepRCixfyghS+KL5pxsqNt3MgBQcOkAmX4jJj8f/szME1qrGTeIyqnYKuqxsNDVDmc+NLQIUeZdGb7/M7LVage4qk246t5pFGf5pHeb1rioFWZBScUK0u6zUFW5CMy9ps25omvg7OdEdIxYBGy2uK7meIxNMiMaft5bRJz9v6bHiURBOAFvdaOzgZr1xQ/+yCQI9G5aIpBgbMC/a6HEhNwNnftHQypcHPQrKoutps6MLc61S60338RoTlLpYYHojUSOh3WTq9mzbrO1udXWL0f++174teqzL4Hhz2hVqR45qrbHhCzBOtNWyOsBQC3KlThPcaLAQPlUorInVV5J36gBcl68nglP8IWqqPppM7dxYJR0OR+Da8unqG8xIN8aqvTNVyMed0KVEMBQgXeUn9+0ynHcpulUnT4gNQcsXhQxkNhLjQmloPaBlHywkudvCaMWQqHRl7UHSRscmstUEZBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?txH/0E4mIH2YlykxRXcCFWR6GE0vWKlRuq6qzHArKo6b1D7wc/Ext8f9v+sq?=
 =?us-ascii?Q?7gaDFkhqqZa8V7y1dlWCIrv/OAJcLZdyDm8KuBG5+siXxqZG/4KzEc+SyOlE?=
 =?us-ascii?Q?vTX8OQHfOpf2i0DXVKJ0VCMtn0Wx6d93doOFoC2WGlLh99lXVIOohjJSHQL6?=
 =?us-ascii?Q?Ll5eGFYgS947ePMn52Io9G60DAcOfUpgWyunTq4U5hqsEIU0JsBndIVBBaZD?=
 =?us-ascii?Q?iXmBBBm4eOdHQ0SaHryz5XavaTQjVUhVrUCZ3sfYRJxhsFlkN4OtDg3LB6BN?=
 =?us-ascii?Q?OUldqMoIigbV+dCBGkCmpgWq2wtWTwf3WzMzdn3Brfq5z+rNgqk0RzBCYxg8?=
 =?us-ascii?Q?FCP5n51jKKruCcJx2VWw+jA2ub+LXZvXPDVrjKyXdPOR1BbTQknma+Y47h2h?=
 =?us-ascii?Q?DSM1wzwl04060yJasnfT65ZsdZpp6y2/u1LG/I0galfo0VVoCer1KV7hpsvA?=
 =?us-ascii?Q?TjX74AU5Zh1Kp3rpm5KV1Nmw/r4JkW/y/a/iOhUXEe4heQ5xY4aWVSt06AVS?=
 =?us-ascii?Q?B07pOOEaCMv+8I2xFrbmTcFtyawYuAJ94ZW26WVAHoWtN5M1v94L3jMbZ4WE?=
 =?us-ascii?Q?6p+slIzlAXsGisqKN38YYBMidjH1jLAYaTTrt6//2tdPfg27xMB3jK8lAhEi?=
 =?us-ascii?Q?oEo7fAFeSx0jMX8hfPUTC5R+d2CA93WjmWuwMerREgW9AXzTUAEg8NmSKW3t?=
 =?us-ascii?Q?iuadYXCveG+m6F+Qj2J+TOAegu3M+BLSAtWXvCL0Blb1FtY37j2KqCieZOLN?=
 =?us-ascii?Q?LtAntx8twJN2wl780/bJoKPmsR9Ym6hbQqOBzg1OFbtQ0d4V3CDKeMEa0cpM?=
 =?us-ascii?Q?02rUdekIkx+frtr6zKKeWgfiJYRyskjPa1tCNqlbeCmpCBNMsNFcRWAkAyuk?=
 =?us-ascii?Q?LC6RcVJSfh8WoISbc1vRu+KmzBUSU16KBRZ2dpTUKbuNBrv2XHPcxsAQmGWu?=
 =?us-ascii?Q?iUe7TfUzMmbjZAbg4s1H7yZPjUjheSjhpWGLWhjRTr7h2r9vwmKGHte9m09C?=
 =?us-ascii?Q?hymXpC8tbq4fdzHZlweckr038eV1x9VYrn+C62tqDxno/eOt0gqM2ieamCY/?=
 =?us-ascii?Q?y13dBnSRbTispgTBUvqAfS7swWEjjAUiSlSRfNWnYqYn8B8DtyvZWFOk6aTC?=
 =?us-ascii?Q?1h5YdSAmY429f1voRbe1462aWTWXiN8aN/VQ8rkD1MhxQqX23eG6nxQoI/7W?=
 =?us-ascii?Q?U8/HE/PhgY9U2lGl5dLEsVYrarJS2z/l0QcnKLPE0JwINBdc/YIK6ISWG4YB?=
 =?us-ascii?Q?Mt4YUEfclKpWcym4pmD9obH9pOFubCtpW7sX+Ear6bVm/DVb6slhHMY4+iRJ?=
 =?us-ascii?Q?jE09OgVQgl+XwK6ngCO6LtIBpgS/SJJQT9qxDNJvlcf7CSvXwzyIBsL7wMLs?=
 =?us-ascii?Q?Xt/khfgj80KwsMcupmKOYwujjcVmEB0RXPjBU4GNr8zdX44zoW9nva0hMDwT?=
 =?us-ascii?Q?kj3W7FuN/QrvgoffCNFii9NzpdAmJJHm6YMIiXgtXqk4OR31/IhJgWdGNIv7?=
 =?us-ascii?Q?5gxv9dCUk2OnnKGUiAQeLj4vKNxadxsKBys63IkaMK2MMA46YBZQHSO626YV?=
 =?us-ascii?Q?tA0Se7PHZ8u34FvPx+sF0iIwfGzdzu/Y98jrx3Z7wL9n14uwaQmInZmNsEZJ?=
 =?us-ascii?Q?Uc9E/VqBoH/8YhfyKwi6zLRzS9WoUq4VDkE6N6CHc2HGB75lEyuUAQ4M9O1C?=
 =?us-ascii?Q?KNGOY4/zftLUT/uKpXdB5KJPsOFs6YJMtKTE40VFRZuVQCaYTGX3gLssx3K9?=
 =?us-ascii?Q?tgNrlkAWRtcXjdYgGtYqaTCDCsCeyyg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a70e475-3e37-4e37-cd7c-08da4b8ea6a5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:08.0762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3xWXTibxOjRvmhJXWTveXQl53xOYqOE6a3RP+kJe+Twq6yHOWBqRLTQLOgWbi1TH8gI2tzmRqcBBE+E1ekOpEyKzjho6UwEODeMYb4qW0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: 3-zKHRA3IpG_nb3mMylDdEIN6Ch_edX1
X-Proofpoint-ORIG-GUID: 3-zKHRA3IpG_nb3mMylDdEIN6Ch_edX1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           changed p_ino to xfs_ino_t and p_namelen to uint8_t,
           moved to xfs_da_format for xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 2d771e6429f2..6ac8c8dd4aab 100644
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

