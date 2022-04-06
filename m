Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C78C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356227AbiDFJk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585196AbiDFJgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742112A913D
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235NsEIf000758;
        Wed, 6 Apr 2022 06:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=XN4PhAiXX/0m50HEzMnrjUS/VVXDxEI/XGA1o4p3J1JMSaLfF7wd6z6RS/GRnwaC++7L
 c5QBBeIuqlHNM07wcYeDPqJmYRAfPzeoTe+GtvcDqGXbb/ESaXb99RR5kRaOPy7qfxuf
 Zx/xVtEgovi4o4Kdh6D/2gvO3nvTb5xsgpMQjAa3cov1VT12iXpjaoQc4f4yzHZG39Le
 IicFF/Ad1SPoOqYOAnK8f27MEZXRUnkhtX0D4NENTPXmW3XEuon/ovouZ0DbSh8G66lb
 bXJybkLDODGND/sNYtmVxMRzm/z7hHvrWVKyEK0UpzOR2+BEk6vox5pA5A+eCeq9FR+D 1A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3squyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366BkYh026045;
        Wed, 6 Apr 2022 06:20:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx4cusm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDwp1qhHaQZd1ckt8wTUK+20OXIKARwwcCatL04XHwA3TSvOiwiwkEF8+qdSzuQDMts228Oi96k3a2chKz5gB6u8iW8NISrguJUFJwAJMKKPK9ltPqblGP9MtrU66RX4ZrujoWc7ujxc12+0U8YV4F2zznyw0pmSDXgA2So5VHC8hdHlT3PM/Yj8qX/Yh8h9waVBtANx56Mq5ZIGCIDOf8iCDxq12c3tSg7t3Q4BQxsQoEGIS32/z+4hERAcOy0kbSCvosS0Hc2RlOY/IXoYIfAlslHExvwIREJUdi4OSl4BA2JmfnKIIJMzWO+41A5mcVfPf2QD8mjXFZCzilMVJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=gUNYqljv6QkCY+zZZVHfzCLIIDThzK9VFdcZwDLGy6FuK7Xx1UEyPdBN/019LmUCGNX+w1Y/aPvaZuTTyGm2OsxcKhNFAJLgtO6HP3kmNIk04yrGYOd4pxb1hksjf4g+Jepuf3HoelFP7g/EbXANpz8UdXjRFhCU092VjiXUu0UZEoE/Pej9mU1TZZx0t7nPP5EjVy2anf3n9FjL648vYtmjisZZQ84Gvn4iVReoWUobCFXt4J6LmxLcAUT35E+/pVNsf/k/JSO5dkO75dTHbFnCBjKecGP6/PXLNtnufp2JvlOmzkJzfTeUikHcbxe+KB6U9A8zYelXxcKWwaQnmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/lx11/gHIVK6FDz75L65J9fOCcnJAbqsmARSxwEjE8=;
 b=M+YXqp5xZY1+/hKG9H7YIBxzmBeYVICR1ORb9pe64iM8kt3llgRzW5Cf8Y2AfsrVfDswss0NAhrR/aqbsjK9l2m3a6PfSxM7LCnAt49ju2oi36zI0Q+3TkGCgHOu+LEIhH4vhPu6xKaGzWHpYwMjhQ1Fs7DIk6FhCcvx6UV3yDQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 06/19] xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Wed,  6 Apr 2022 11:48:50 +0530
Message-Id: <20220406061904.595597-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5883c8d8-7e4b-4fca-a5c9-08da179584a1
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564099CDE220F5B8AAF73A4F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWZsmZuWtNXr948mTjDYlIAjBaQ9dUY0rqqvItb15NHCeGQ1AT3FWpVxUlzD6SnAwYLRcgMsf4+5QRBTAxT7HvWoBwxe8Hf6QQfXNu1tR4QJ4Gs506zPDFxJpWtQKFzoeDVxIY5kMp5uuBkC1M0r7oXKs2ybxqf1lBxqyMAS0fW1ZSyMNeTnqfq8Sv2tGyrRoTbYZZZSqtpzX0yXzpWeo96PpgB8XcIWAk9x5fjiqN19J9wjpjvbXiFW5Unb5P8aCUm2YMakTZZ/o2Ig1Lkqzrv0mOGhAK/2b9XabGsAuqnFhZG5rB/htWJfi6WQtNtQM5rPcyHYfKrCN1uhHjWUjYTsRcx1mIY7mdQLWEU5Hfj7qqm2ibWe0JgdKNhEWq2keYdMxC5JGCgmWNPa/oBOaII8fFU9az4wNx2m/sFFd7PTg9ctUuYK20cg+qvt/RIZrX+RXt/HcpWyURVHiCF4XsnDVI+l8tti7iZGRPsAdNqaNGemoxzEAPaOxdatuUqUqXHMHZVlkuknMBeB5H8lyCfeYHga3C+vzc53ZO/enSjQ4ls1npiiXHLCUAOnZYgN/Htgp24yZYSYC34sKVmTGru7IW3vnDyJ00RQ2jnUTZqJJ/TnuzvvXjgoB8c68IwHsPpFH44Cy4lWCr4rOxa5A5fX3yCsIqD4/rXuNEIdlarRbixsNxvZ+RIZkU35T4w19WDPKcy9eZOGGcTzyMHHpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VxhJnz44RdnJsIuovt4uQtknSQBjo45WvoF5Voa/su7eG018ByxEHPYI2WpT?=
 =?us-ascii?Q?OlIWuHxfKWijx4WJJ4ckVNMHY3qfvoLw3lpJjvWHBa5vkU+UaVotFOIR6ZP3?=
 =?us-ascii?Q?qs0i46FpVl3aIMuk4T02VujJf3E95O4uKath8uAR9j0xq5WSnfZ4tY91L7c/?=
 =?us-ascii?Q?Ex4/Qh21L0dA0xfkAyoFLCYbmbXTk3paWGPIwZ+zNaa+gzQxbwUfYWzP7bub?=
 =?us-ascii?Q?D+HQsIO+v1kWBjOIx4qvPfl0auATTil3QzL681NfIjuvFHnCtv0QPJrdI5jb?=
 =?us-ascii?Q?sdhlxnyVut34moFT47ApXLLBNiAoa+p7XDAeUAueZf4x+TNavcKrcQvOq5rO?=
 =?us-ascii?Q?tdEBXS4mHTK7d+ZsY0+8YKMKVikNq6VZUuxsi6NwFtlN78pKHL22e+ddR7qX?=
 =?us-ascii?Q?bS/ZTqTrCigOiGhyJKClD2sLqPSkFawxlvPHvxWp8d5fKzFeKd3artf+fKbZ?=
 =?us-ascii?Q?RSuXob1Zg6JzjVyGjcw5njTZjiCiPWNmqpeaMHSHi7VlcztxjiBh30neMKY6?=
 =?us-ascii?Q?ikdMEEucZxwWgpY6QFIXYrTUYLRliCXepBVeMrzO6N+qKk8z9QsrEc5+3c+b?=
 =?us-ascii?Q?ftJkPjeCLSUI4KBm/HAvi0jmtCNryn6s9ezCFFaD6JmHaW+4tTDVQwXwOhn8?=
 =?us-ascii?Q?fdLZNm4ez4tY8wDXG+b3B/yqd40R1Xu0il4UD0TEl5hpUfd0IJKHYieidH/l?=
 =?us-ascii?Q?OFhwpJ+r1nfgqcYR9P9rJOKAVWsl5qxNLb1WuLK6YexZ41ce6eUfhfwxt2m+?=
 =?us-ascii?Q?G8/X/dmNvw53UlAP7GR9J+CF0ZjxKXe10Pr5+00YmugfJ6uEYOKqVr+oEFz0?=
 =?us-ascii?Q?+4XcYA7UKMfhHRNqdCqataVTB8e3QeX/5eARdpXg/rITRK6zzODgJuG+2HfD?=
 =?us-ascii?Q?h9dRhoe00QXhz8HISmJZxFH81QqrKPDDUVWG5WfMiw2Zw+vJ8+eLNLUTpIr9?=
 =?us-ascii?Q?SjNmrXiRORmEYBDsJLFe9eGG+tsZUuDI3SfG1gUQ/MmrvPD+YczvmLzunJQA?=
 =?us-ascii?Q?dYLuT7Rjt5QjdEfY4X8TRu1pkPatLEThuXOWgTyTswfn08j3FgDGxFCe9FRq?=
 =?us-ascii?Q?9fnOhF//f8MdR82w5Ll09Q3+FRYFJF9y4KA1CiDbvfSwJVCPU7mnTAMbozLj?=
 =?us-ascii?Q?Voot7ReYXJpyDtyoa8e/oTSUKoAVRtH+SCZUnLkAZM97sh5cpUecNeQ8bMiX?=
 =?us-ascii?Q?i+G85zjEeEJ0CtumvTX2Huu6+T3ESJZJAeXYVK66c3bAJA4CkD10SRxCnpbW?=
 =?us-ascii?Q?2HAwvhP47+2chGoXkAlE23Pwf3nb2AicPoNZpYfxBwWxbdzXm99PTUoTa8kv?=
 =?us-ascii?Q?FuCsex2U1Lkl+iu7mvntTA7Epv19VnD2AUybCqMvChokMO1NQ77p1mOru/9A?=
 =?us-ascii?Q?zJgWdkkdcc+4CVrask1WHRovjRpCfnUAqQ0XO5H5qGJt2LG/M4APb1XS1n/+?=
 =?us-ascii?Q?jEwbRw5D0n6OwRSiktz72NKgEQ3e9N6KAfHcgZmcPOXiTWh/wPvvfILKwXIn?=
 =?us-ascii?Q?bWFpF6ZBSZTDAi5tFbYih/S0J7DwzZ5qZhh/Y7EQ7o7g0h5Ud9gzk96wCq9r?=
 =?us-ascii?Q?DF+UZlBJe3bqiR8CLtxZ/qGGsYbfMaJxmm9fkAwITXa98h/wXh73j26diY+i?=
 =?us-ascii?Q?epmA0rojT9T+qLejLEXdmJWTMwK5PSJXQNQbrda7vj5nl1lYeRiIODDe/5YB?=
 =?us-ascii?Q?bw1oSlKIv1Zq2wQ7xS1AQIF8Ogi24aFk4/NoMPHqpeEi/HuGREdFNvx05Fa7?=
 =?us-ascii?Q?/G0XQAj3lGnkTaUH2QRVgeeRHSAsuQc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5883c8d8-7e4b-4fca-a5c9-08da179584a1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:16.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XV+2CJOo0t274kfHxn+ZYGFbGpOeNccE07m3oUIdAbSyUXjd4WwwnPHHt+HeiP0YjmnK9YhS/JmhpH4xx2gSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: p0FmEQ64Vs-mN6pBbWRLWNwU80ThXOj-
X-Proofpoint-GUID: p0FmEQ64Vs-mN6pBbWRLWNwU80ThXOj-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b322db523d65..fd66e70248f7 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

