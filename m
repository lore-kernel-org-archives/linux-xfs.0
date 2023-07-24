Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6A7EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjGXEgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjGXEgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:36:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225BD1A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:36:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NNjJVs015795;
        Mon, 24 Jul 2023 04:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=E3VJifj3h1HlWIaromhXnHwGijkMCYmZgYrZWVnJzw+nMYR+WSxzXfEmqW3EC/xxyVuK
 dZDmgGqr0QV1Iopw+LiP/c4s7ofPU4jHQF8JdnVnXk5pZ4ieWAztJmJxAPdCn4tJpKML
 iu7MvGGuGHKOQ+dmqIO8hv/s+slP5RUbEW0ZqDGIz98FU0YdHDoyD4wnnWPPbqJP+NR5
 EXBUz4fJmmf3vRyrkMRFfXOfAT+Uz15aC4ETUWAKRYTQR1oc5U2LaCfxqMvQh6JDcbqJ
 y4+7+cqRFtEZOWYf77CzGF/is14t5XeZaJCtGEWZ+2eIa1SBDg2jIuTIJILhBTT5pmNF Vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qtstrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O20q0C028691;
        Mon, 24 Jul 2023 04:36:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j35xh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj88UYN0OI/62O1UZ/GrZ0L0cjHTpMPk0A3WiNHjCnzuesRwWObInUpoRtr/K/jSCAj/1KeVU/i3Kl5bgQHrf1nFQ4Q8dhRwHCm7ro1529fZPSMIX7Kr+1uHh9ImsR3/Mz1GN1twvtnJhtG0BtRsAuOBfrdxyjwA+ukJO4gWe0H4alNW+Lint49Ceif/mTgc36+XzolR+UyflE7VvrIqtX/g4ttvvSELxx6wYTVxwFucp0ZwKk/OWU07dejuxoZPcXPyHtmSpmMAIHx/r2cPoOwB8KR1lXMFdSZ4LwAPPj/bQc5wQ3d9Tpqkw3cZiW0pkoxT/4SmGkiIT/msUjAMrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=BEq35Z0nRgb4oBB7d2a6IoaAH3spf9+ziU+gYV+vQQRMkbReH7Gv3LF2M4CU6pXhJQmHGhGgD+S55zoGpVyLGT/VsbFsTI1OYU+012kCLQROGNKi7MTPmaq6Yoa32X/d34KVrVcA43ql7W956eTym2gOI+AFgr/M0kggzLCdkyRlaMJmQPj5X+VDhUa53TAvHvioAFBoSqLP40BMNTaejhpVsWAWJLtJr1CUz7af2Cfnh34gYcmuEuhoI5clmOm4D9LqHMZtiKCvULvLxtYN/bgXcQooc7L+jIao3yjh7ta4VUoVXCh1YUKkeAvQ6aBuABRhYkmh0wd2BDatY+71OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=xiE2s9sSgexkKtkUCgARbEZ5XV0MNoeor0qkfbEGh7XkS5A9lOjHKgtr7NE1RfKXu4ESJ0pYmW5hHccSpbno084VwRC0243u/AFj5A/o/HZKisb0OttqgJNEUPHr8LQjNrjw2gipzTBtyR2qofPUlTfRGGfEF7NIk2Rl7Utb4NU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 02/23] mdrestore: Fix logic used to check if target device is large enough
Date:   Mon, 24 Jul 2023 10:05:06 +0530
Message-Id: <20230724043527.238600-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0039.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 180bd9da-4793-4df9-41a1-08db8bff8d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUq/bLXVcvVBPkCtxbnTdID3cUCbuAFT5uky9Du3eRtlZwFbRPsrD2A04tEZtpmxr2hNrxj89IjhLXQEYAB2xlZ662pa0J/wfA5PbPB9c7azzU8dDWX0i6MNav65sHMIbWmDJihhq1wH4RXRM2ylWpk+qmDhGK6eUtN5EkbcFr7EkNNihOzr4VOZjtwhImJ+OguSJn+IpQE1JPom9XQYwzd3rDzhkMqBePBSrOYV9eOYJ1dLNMsnP8fsFdTpqhhuinvgV3czhRYL0JQfFT2q9FUVOt5T4OnJMifN9ze1rCJf8TqkdA4PlHdSIqpVnXwtiKanWBqhx38Fzp+MnTvDdUwdEnF6PnVLSBNVJqlsRBBSMZ8YWdcWEsRVitg8C1W0fIVaJO+X0EAdK0i7o7Cf09UdJ4t9D8gCBAJbUhzvDlvjlR4e4mwWDjAo08ng32vj+IY6iMkn9o1uadaz+1i+8LdMlKPRkRo53ljOqy4POXwFrCscvGbYoo9SYj7dB8qoeUh3kQ43WX3fbaNMhdaDiXyuUMDrEaEELom4kUEJhgD7TVRYphnzbe7QHTEVeVHJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(4744005)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YfEX31MuQ+6X5HDA2MSepRYtBPom+Vz2vOeKHDwr1FIDnB2yP4wtQolA+1hj?=
 =?us-ascii?Q?wq/d9aJytasm9IctXlVpABcDDjANJ9tD7uhB2w3qic4+gT0/OvcbHX+tionU?=
 =?us-ascii?Q?iG5KuRmvLv0N7TUE11bDfegJ3GFp4apkRbkUpfkA0bNFPvDCuEuFt68bjIfL?=
 =?us-ascii?Q?nQv0SF8JZnJDspK8Rwyk0W1jRm7kVz9UfyvZ0uGnURy90G54GI200gdhZH8A?=
 =?us-ascii?Q?odkhYaS82dkkTRsFLxVZ1/d7L4D2eNFqslbMkSBlA/3s4DEkYuJImiB7pser?=
 =?us-ascii?Q?KnydKI0ZIN6heDuZjTTypMNnYkkJDFZGC0qj6RtskqLTKVrBEJjfqDv8/dIo?=
 =?us-ascii?Q?CDiTq50sWLaJSVcHJeFNeFLt+0PlX0jfsj0nlItj1OMK7EmeW3nY49NYt3My?=
 =?us-ascii?Q?vlH9pYOmB2BmFKmYIYiI3qjidOW/M5jarhBdJpciTjWSbuvUt8S85TCTit8F?=
 =?us-ascii?Q?i2jT118on4xzs2bq1juJ1DAak8TE2Y1SzK3kWZpdfKOo/yijbaqctF4JwZqr?=
 =?us-ascii?Q?0PHNX9bJdPOM8MrGhdWdssdDffbDKHu+EmI6LSeu1Qb6A37dF0+6gIYSNyOw?=
 =?us-ascii?Q?liDsDPaaR7Rb+P7KxZIVhUTV9ASIKCmzrr8iyVJ0dBE8ikemnCK1e8reAASe?=
 =?us-ascii?Q?xNOaOkeCjIJwZh0o2ewL1AZgXnek7FSYM9Vk0fuxfXAq9hyxM8G3KHOo/xLt?=
 =?us-ascii?Q?YcSUW9Jhzqs6pTxqkK1siA/Y1rStlFMOz5zZ3+M3tuLZt10aA0IYBNX5KI5Y?=
 =?us-ascii?Q?TSXvPiVCURf3V2D3vEQuZqsLKwtpUTmMQZ6EF4JxaObpaIPfsQ0vtUyv3IZl?=
 =?us-ascii?Q?ZnyyQtrB+AvidbhIOtov5X7/WBnEUs+W0TSMqwkXQI4a7hXLO+GEss83IcGf?=
 =?us-ascii?Q?cN6Ermv4BNcO2wEqGiPBb9l1o3uVrI9s1b0S5Sip/u2JkZergxyMKQoao5VU?=
 =?us-ascii?Q?mqPeAcdTP96tBiJtiIjxqIxL2VGMWauP+1jGeIzsKBZOkFSdY5MqGL6gMI7G?=
 =?us-ascii?Q?H2BBivUy5dGCxLABlmCCtLXjPbIpkOChWxd2GU+Z4mt59hRoh+3d9+MGmLpk?=
 =?us-ascii?Q?fPAsrJdTZfHBHkhhwtkFYF9ChqIYcIch0M/q5vg73L4fQONKXAv7sF2dj5hz?=
 =?us-ascii?Q?okSTm2uoVp92prHfMSI+cQACBhfba3Db0zdC9R1QaKiaQ/Mbb4CYsXBGGAzE?=
 =?us-ascii?Q?ePdIOPVR3rxpZi42gjGHFfXSNtEq6JfrrSghL2sZu+CUVYms1CePahKCItbI?=
 =?us-ascii?Q?ktH5cxkmpriJTAR3zVFteBOp4p6CAXhSMGr2upiVtuRlMZ/AuxIXotXEyRBt?=
 =?us-ascii?Q?rLw81SA7Wd+OZFbjN+7wq8J0oB+mgla0XJFr43GVQYvIl+axS9wbefLKNtIz?=
 =?us-ascii?Q?r04hwg7t4YSXKrvAkDLlnu46mPove2seiY3CMxIj870R+toYNQwC5zrNEg7C?=
 =?us-ascii?Q?BN937/+U1vSjwor3h6KBYkqYnM/jwwa88vBJepAvee4oMMAB7AytoMcW4sbZ?=
 =?us-ascii?Q?HJKaC7BGlFF7jZiyoe2Pjjh4QdmENoijGXisXJ92N9IRAjY0wikSBbFyb0j2?=
 =?us-ascii?Q?rm2cp6xWO4fl3CeHQeI11rfWeAJPTFH/AJph5q+v?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pyYZ3eKAGNpjU5ppA36PKyBHpmwrt7pbfhwK1yIh2InWUC3nb0/xr2e6KipddcgzG5HWl19wGgf/ESqaho6B1ycg3mgXlh+AxTmrQdXrdDBI102+1dBCQSXQ7Dqx12WlOWVVnfgQ1LBXPJ03uV8rFhaqlA16wPLtlgIKTYaqCN6uvkyjQlN/koSqWhVT4Y6dC1c43EtrIZYBVO+Si9aF359TAkChTSh5PRIUe1LZyuMMFdPpfNlgMiO1IZbkt9N2p0jb8aUbdHOrmW1qZtUtqm+QkbMAAHMD/S+W1tUPeSKcoim59Q5ZhdkBXFWQF8JABOPTrCDg9zGLbWDmpwOZkaphEFk6kXDkPFRJflhXJBez9ie6e4kvnzL5b6Kh2C44He61oJrO/LRoNJDp3rKJjp7k1IW9PUuc9FcHA8E4HtjSCV1u4YRv8GX0KgoGji3bOnHeYUUsiopGcAAzLKQGf0naN6eovGt9MOqyLQwD6RlVfduu3R7uOEfsTYle0cUVPVgXVj5GO2MjY4EYMlZzPaswVbnUq987uEgQ/SLi8gXBscTBXlXpMd1yQN3Ws7PtPm+X2kieW1Sf2Kezw3S/NrzBY5kNaO4HCEUos0yJZjrRhpfSxapwk0BUtGziRRQ22+XkDUFgVyPj5hAej92AA22YI5el/WPA2fSSQvHhcwH3EvdE2M6JL8dFhPFrNVu45C3+aK7AXFoEC54G66ekXLsW0XzMeqBpx2Tfxw2aU1QWduL1bI5M9SfmpPHebILJxZn2x9SrYLrGcnkyvBH0SCgu5AP7g0eAOYbxc/z3enQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180bd9da-4793-4df9-41a1-08db8bff8d0e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:30.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHcFStxUY4XuO8S2dPI0enRyAH3hKffISmDqjJ+1nAXsqPIwAy2cj+UJYkN86SflyntH69V6bP2KshKnVQNF9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=973 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: 5uKAuLiGAeExCFMRHUKtVe3b89Vd3DkZ
X-Proofpoint-GUID: 5uKAuLiGAeExCFMRHUKtVe3b89Vd3DkZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The device size verification code should be writing XFS_MAX_SECTORSIZE bytes
to the end of the device rather than "sizeof(char *) * XFS_MAX_SECTORSIZE"
bytes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4..333282ed 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -115,7 +115,7 @@ perform_restore(
 	} else  {
 		/* ensure device is sufficiently large enough */
 
-		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-- 
2.39.1

