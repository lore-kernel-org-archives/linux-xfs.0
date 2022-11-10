Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B47C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiKJVGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiKJVGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:06:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79224C14
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:06:12 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0bXO006962
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=j0I83/LiO3C0WET0DDm0+GXdAajJb4OgV47KJ3K40HQ=;
 b=bUNk/QTeJhxH5PTlj21pq9cZgtaym0V/K2XQXTQEzJXEZ5myqdoTvFQWTfa9DTnKD94Z
 fzFGgAgJ6CGy4/MRpcf/3vHqx2akadLuTwTMxSy/QBhSqZF+J5SJ/+7tnUSLrqwzUt3B
 AtxUBJvgUCTg609vAKKbuLe+fWmO334RHGXoS1JBJ4wJbVl3TE9jpn3XzoE9p1xmtRuj
 KiQ4R+FS/CTEkS7X9HtYMLpQcL7YJ5lbIORZOgVqj6msAZ9N1txon8E9BDmuqAM5TAdy
 Kts/b6c8Ai3U/Izke4yLl6xmLKcogIOAetr3jYuLpY7NXHpjJSb5PtIrUIzOEAtgJgMN fg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r13u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:06:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKYbkD014968
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctfre42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPCo5NgzBrx+7nbQKWzeq4VJlHeWz2D3u9joQZIspGSa62bpuHdIlyeZhbazx+JJB+CPjuudyOVNdy4KazjsTyq6Q17JGN9N6R+SP6rYJKDpagQFuvwrJ8bkkjqBRznpGLoTPpuIJhkBLBqlRybEu2RYRjbPAy0SkEsfpCQdVuA79Dm9Y6J4qz1rKHzu8UhIN2JNO/Wh1wmwouQPADtfBeDCoopt88krOwYxWW6le8Vrnv72QQSDcULyI5gFAvNB4giKLOV9zgryvrasRxCxVrxSUHrsp7VUtEPxvaI/sXmJEDJUfG8nGT6g6Eg0SckyFrDAvHBL14tANjuu3+pGLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0I83/LiO3C0WET0DDm0+GXdAajJb4OgV47KJ3K40HQ=;
 b=O2fDf5PrE7iv9wA+CcqC1q8WbbvmAbcNGeW960DxgT3L+2uE9Xi+yIjKyQgHHH879K8hJWoULiu3BxD3zYu9tX2Zh45u96i9o1lUcPctJFlDBPOrLgwvau2HcKfTzZFBcczewLog5HnyyOT/a/GhQDNQbJnIAh2SzJfgAdFJSV6X/mRPKdrIKW9HA1Zbw5xhQ8L4fP8pv85pQWL/Rs1y6figWcUeQpEiHsjZdR1Q8+H3FyPKPaI9YxQ9VO9Hwvo8HCxZNIT9izORS3mDZea5wjiBsF3jrobBQ+iP9br7mJ1InTxXwRAGmGQSvop7KNlJj5t8rUI6D6vtUn1jdzi99g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0I83/LiO3C0WET0DDm0+GXdAajJb4OgV47KJ3K40HQ=;
 b=oDS/bbiltRwn20YlQy1aTWPgrSQn6xYGolhI46nFgvIPThIFM8VUPaTM3adGyhapcgBGW6A0rYy3bqMxi1f5T2b0FhhFhSEIxCup8gf/t1buyscOTn60FAZWgJHqILjzQQsTv6q8u+9zVv40+q1hZf0N9oPqN9qzY5qh41ByK6g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:40 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 08/25] xfsprogs: define parent pointer xattr format
Date:   Thu, 10 Nov 2022 14:05:10 -0700
Message-Id: <20221110210527.56628-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 9257eba1-ce39-46ea-53d8-08dac35f52ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4mxmVIihBRxUV4Z8sv/azXatlm7PPwIPAYWLuNInI9wnxmDQosYLbstI934+sYG8LD7LsVvhTwyEeHuHThton1xiSSck+NgkBFHYweOOFNK40zArbW/LjSOdR/jRF4wOomxG9XUdvHVvca2sX5KNqi3Bz29XMnu9mTe5K16d8spJZsjE+8nmmArZ3QmzCXR6VxAoqAZiRdVaL/M3ojsCQxWsCe9WXWbjhNc53csFoXKZwJRwnw7FG/3ljLpaMvNCEEMG/snQy0yldNkr3+4fGcKnyRrAoGi2kTiMp3XrJlZsFyGZTF5oy4AkSO+pBhH17tzfCw9vc2SNUHSsX33GBbyonlHcoLP+Wx2Jz+UAzm/Kj3D3001ZUmHQWbokt8XQI62z5rzoYQV1ZkKf7JxhjA85e+WiLraHnji3eydT9Q4jFQLZZDY0DuxQ5x5mPsMjapL4vN6N8zCtlfTRkS4caVxbJGgsd1uIWwD6amyfN5Hn5pKOJDjaLN/XxgpM24//G3q66xaskUJo0XNYds/xSQ45EHDjFEGPF7w6j8M5EOTtUb5fxKngT3xrOS8hOmeQMMI0T0TEC2EwNc6O6c39IXOeBcibYIRaGT5mLO0VAHCox2Ui2x4yieRhhsAdxsCwheMXH9tK9tXil6rBr1AU48HGr/tSI2BpDpJewFxHWuYahGWPBY9Jsn744M2TSeCCIPgVyz2/Uci1yLDsIoKCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6DrvBQchi+MbuW5DFXhM5RQ/u7Zk1vGCJlMguqg5zTa5yWF36gxcKmq/0hE?=
 =?us-ascii?Q?s9WWkJQB2q/4VCyzzja2O2Ho0E8uxKIPaElvK4M1Q6ai8sly5nslGxyLLLRb?=
 =?us-ascii?Q?MUSeusYjRZ0jJHhrnK7u6QZq8hv+qrcHEKLTn4Tmlg71XlpN7l6T00bylGjN?=
 =?us-ascii?Q?2L9iLx6Du1qL/t516M3C9IUp3K1qOxnbJ5gy4X/oPb4jbX5TFfnEman5BLSV?=
 =?us-ascii?Q?MQfEXc++nY7OFX3vI5GB6QJFkQmeKWUxbPjnGKev5BNl2GVLL58oDCwBqr0+?=
 =?us-ascii?Q?nx2FzVv2a8KP/FilOM9K4EL5TKOQruTJI9b79ok/5pmY2xZJip2i+cVosZKT?=
 =?us-ascii?Q?cjC9DF6pmOhtaIHu7mmHor0SVPHlf8iwENaGE2IX/dTilUGDKMhH96naF9z4?=
 =?us-ascii?Q?By6T6R27+LTKcC3bT8LQOCotQOAug9w/cwoyiCP0LFDt84e29b8htkJ5S8zI?=
 =?us-ascii?Q?K1r/dfPhwboo3Bcq0NKu6mpOWG/RI/j20ZCiDsV0ugSdM5LZjlHoNNhUavZI?=
 =?us-ascii?Q?bD3L9UGupmik20WUWWbG6f0U/hvlSamtGmTOTMN1/zWPEIS7TesvoJ1TeUdl?=
 =?us-ascii?Q?GmDCLclPupVzuUBCuGgXEA+Ec91tBSzv8SgbTgdZK6hI4yvYRXkIQm4rxMVB?=
 =?us-ascii?Q?EFgcpjYd2BN17YO54Gs0zlajYR2+/SJhu1uPCFg/LMwx+LLhKV5oEu9IPAfp?=
 =?us-ascii?Q?0NzrzKl+nMMzPeEeYqdR7Vivv+jItty380lPRafpQXjgU8SBCu8N3YhLMFJZ?=
 =?us-ascii?Q?Z5fGvkcBCCB9vkqLJIvUuZ+Ga6XADHUnNktUeWEBCK442FVeFSRfRvsYAsXy?=
 =?us-ascii?Q?Qp1+P/T7c3tCtNEZkGqMJEOFUcmLOi7c5BuzAqgJcJwuP/kWNvFd1KskoqXV?=
 =?us-ascii?Q?xfIaiYCECu5D/dK8yd4XxJEfaMUry6ndc2/NkOzjxFI/7TzX1UKl1CvmOxNE?=
 =?us-ascii?Q?lxeE9s+mr6Xda8PA4+ZMlSMTiJdcIiqTxPexk0p+u1CdPS+Tnogx6JJxTxi/?=
 =?us-ascii?Q?6S2ZgTyzdfes+PbNUPTexjTnxggRGUv56b068wjipiMcAMAlfh7nJVHQ5axQ?=
 =?us-ascii?Q?UsEuhUJbsw/HD4gfSfZAgv3HRfjCWfFNXpenYVeQEDK3yDEcKWzmbfXfJdBP?=
 =?us-ascii?Q?FPxNlC4179GDN3ani6e7sTQNzrHkkBHB8VPvSGnUDPPsR8ErKl4zrEFt1ucn?=
 =?us-ascii?Q?pnn36uHkqb9bdBlQHqD1zNXA9LMLhGxoM90eokCJ4UCZt4d3fgwRAGjJn0st?=
 =?us-ascii?Q?Ik629+MaZpfaQdjTKWAQCfJ6v7z20jA1xrKkyXAGrV0WSqffZyv6zq5I+sxK?=
 =?us-ascii?Q?L2svHoo+ei86tsWBn39KdoZSDJhoYA6lBWVW9CJxYhp5lYRT/qojXGU1PTW8?=
 =?us-ascii?Q?oKQokpcNiAbYI/uXDVOh0ch2GMOhZFG5bJ33LrHaxsHYgVrjPy3LsIQmROqx?=
 =?us-ascii?Q?tL5BKtJaODCC5fcllImETk/JWnGRxSeoizxUrEkwdOSvCfq1HC6Ke1somogQ?=
 =?us-ascii?Q?q595l5drORx7Rs7UuRXnzKxATMHHVec5V5p3dvK0BW5X0R/jhX6cDMC0EGme?=
 =?us-ascii?Q?w8HcLwF7nG2fvag3A59Qxlipf4fBz1jMCyIIUiCvw4igDOfc62YSTDjqY3TJ?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9257eba1-ce39-46ea-53d8-08dac35f52ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:40.8281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xn67VHE8u1ae9hz3FDoGKHoVDtfjoeJLbZ+MEktu4e803hKVnMRtbE+/cxhWJJ8X+8Gt6/8sfmlsHWlDSQygYAph5aam9Is9ipThosgwEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: sAcj6AxHRLr2oEZF365wV5R5MDJBAf7E
X-Proofpoint-GUID: sAcj6AxHRLr2oEZF365wV5R5MDJBAf7E
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 059f7b9c5aedf18990aaaee05ff9938b8d87a5ef

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
 libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 0201d64b1f82..fbebb55b1621 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
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

