Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF15C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjKFNW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjKFNW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:22:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197D294
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:22:26 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx4TD005757;
        Mon, 6 Nov 2023 13:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=yjnzXOG61hinucQwKMkEY+2BNlzTlPih/JIcPGx19yuBs5Obs0j8bLoMI686uMZVsIn3
 uQuqTumHNiZ6DiPjnItH1e8nnfDW/l0GOSIUY7Z1m2IiCymYLY8eqLVdhLpFmKbAQi64
 djuypEGQ766WvBeqIVNHJYSDUp8aD/VaLxXWkvUOJF2PUIuzTLW0UFFtLaDBIEsO8M9z
 dz5XmtmUYDKcvsAJFBPjNmNZa9GQJ8VtgKXfanpLbE/cE32Bm1h7bMfAgXHPYGXtxGXE
 SWibdZNDcrnDSy3qXPeKR5VXL6VFmRXjCl1mT8A2swMeXxU+nFWPYqPaV60GvHuC3ePn MA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dtxmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:22:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CDfWU020831;
        Mon, 6 Nov 2023 13:22:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdbbcrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1xK02MNWnuOM+GFVXpyK769GDWmKcATor3etv+iIgxnzz45zLkMnQ3Ffe+E0CVfQGXW9MDjNo3Z2OWkRMFRUZNwBH4L72r7iSnKDchc/625h/6ySXM7w7BEMYAEPy/BKd0whxKOHeZZ55xB9Byui6LYt/ibcW6IE1BPSj80GmzdPghczqOggEjUpWXZociyOcAPJvAjkxLCN7yGp+HL82RnuGBKFIVLMxPuohN5YRZm1k97Ogb9HKuWVNrOOxvhdIJ9INvakMtY5kpCVl3YBXRZTlzwNmmtP30ZDw7/q9jYMLOgp14YdKq5Gp6+q9xgretfSjnyGic0aL4at7xFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=G96jVyX3Gf8WoERAPIuXzeh37LqbFMzgHqW0uVnFNHY5zQMpxCK8rcx7nV4ytQ+vFsPrLjoMgctn8SutVVuCVr5z8w0KjJ/W9atr/lWF50Vi7gkxzI4FRxDuWktkGkVieIqaH9Io9JrTBVsFAdEb/r9DBwCBJHsVShnMRJCwCiFFd3xqTw2yIGMJcfQ6eK9gGflrSTDpymr3e2EncJZDrLElOr0J8o5FkCzz8VWqbkvsH6RYWePw5UD073Mq2vjBN7DAj9jLOj16JUpu0ESAgVnJb6wqUlpme77vPX0THOz94TRS6lQGWiSOxBMbcZ90UJXOIoRQ8PYnS8ineHgmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sWPsHf4B64Pr/t52OZHeWWJQP3zpANECsn1YdJIY1E=;
 b=neS79BAZ5k9MipCUUy4wXCgXMiXgWVD9iKajr+TUfSLPuy4iDF62GAtQPUcfV2SZNkGqw1Yqv9NAiSXoH18196djCHZrp4WDLv1ZcGnXcEQFymaAbauztHkX92CDVwO3EUUbUTJhxXAYo+B6lqtWXqCNsSMGM2bamvr6y3R6Go0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:22:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:22:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V1 1/2] metadump.asciidoc: Add description for version v1's mb_info field
Date:   Mon,  6 Nov 2023 18:51:57 +0530
Message-Id: <20231106132158.183376-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106132158.183376-1-chandan.babu@oracle.com>
References: <20231106132158.183376-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0081.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7b::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 99abcb73-72a1-48fc-1a90-08dbdecb67dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DY9gudFugJcVWC5HeSVGIaV+eCQ3AHCRiVG+E2GzNaxZCI653+wKpAD+682kiKFfi6kWxnEq7CDTb71+FpwKx2J84suMyI1+2Vfu0g85nt8YqN93+T8wasAqrdujtOcQC1BfAwYha8BD6IS2/FEn3ivLBzHS+qywuHN1CcFBeE5W+J0ifJofK73YvWrigliwKuiFQ/hIaIB6FlSlvEKGyoM3iR1KF9V3biBPZgm27gI1rmW+dx4fqH420BifSC3qiO3rf+mcV2KNOxFTnFiMEnNB+KhtwXbBvlsFDeiI7KG5UfPCjpLUPN2IcwKFQcULePK0t53okjOmiwQgauA8xmCaYyP1W5El6uQ1DHDSyiM8W2WptH5WHGM4wNMIO1arf7c9U88EKm3rxKPa9prT5KBr0+DA5ozJMTjhXp4BpzDZ5HlLsvW6cBmbCTvOhct5rzGQB/N5GerxJs15GGLqh3nrSaPqEDgWWKIG6h/twteBJLdRaK7799QC8PR5SCRHMiPw9ic23nS2WbsNzE+eBVC8IRirYEWCpofLecdoEN0snhQVD5/sIAgglM3nkvl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(366004)(346002)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(38100700002)(5660300002)(41300700001)(2906002)(86362001)(36756003)(478600001)(83380400001)(6512007)(66946007)(26005)(2616005)(1076003)(316002)(6916009)(66476007)(66556008)(6486002)(6666004)(6506007)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XFU4O4Y3f7GOr+wU0hVq73hgvwqkNZIPAO3psig0epDzD4ql2nT/cVyQkYQF?=
 =?us-ascii?Q?ATmqAvLA1x0KbfbaHkvaFe1OpwCdcHT7XGt7ZEIrFOk/YN/5XB36tnS423D3?=
 =?us-ascii?Q?N/V0owH7ZiOMrwhdVkxvep0dtxDx30fRDqUsV5tSi5Yzn0b5VcNsCybQp0f4?=
 =?us-ascii?Q?X3LRJPJqOLhwrO3ks4Gw1tmRQ0vq6yI9MxZfitvZep6EZHY1W3i2arCboREO?=
 =?us-ascii?Q?ygp3zMBJON25Dn5OiXMenl9vKSkzKf3bgOBl/u1YssQwfHfuNd1XWxDf7M4h?=
 =?us-ascii?Q?kGvOLl5cMcKprCyVaLv65AMgzIXga9zgNJvSIKpMvDOBQzExrO3ZjvL6xsPl?=
 =?us-ascii?Q?oKoHCg8X/XdQnAS+JqRKBVf79krPFhrSJhomYXRsvmHhi7xq/yymkgZLENHY?=
 =?us-ascii?Q?7747oATqM01XM/RC7lqTFpN3kyihof1mYKBUKUfhM7jRUpIkSHrxSFrJBlow?=
 =?us-ascii?Q?e5JfEEd3EbJadcAB5xxEMVBXmbKx3cGyGJPos0lsIT2dCvy8DH0aB5ej2Ldx?=
 =?us-ascii?Q?c5rSjnzKMv7fwidGzSev2UysvU3qvvPZ7E5+r3hEsLjztqGhy8HvdINdiFSb?=
 =?us-ascii?Q?4r0khcEvw2uuH49IXX6DRBADz+Danbx84naOYF+CpwBaFuH8f5FzV+UTATpz?=
 =?us-ascii?Q?Gx0YLvkPVNmfAWjv5uscVg9kSiicsvjttq2daUlB8f6sbFGAM93EC8Qi4bOt?=
 =?us-ascii?Q?0W1XhCjzt9p6A0VknBpnx4PzFTGRz/s214wu2JW+A5/HuB+wAtvMOK/5jjms?=
 =?us-ascii?Q?/slmWu28suJ7P9aEz+Sw30HP9NTHE8QvsOE8Rc3HK2R+xAoB1/NPzozrxm7G?=
 =?us-ascii?Q?M2NOhFVIgd5oN8bhjozUWu5HTKY3pKdC5xMtegk1wBnJxmAM/C9XF9cAE9JR?=
 =?us-ascii?Q?Gi35iWLPYR1AZIWZKBgnWNDIKPKVRqrP3mEGHiY2oS+lz1OajThLTieJp5pB?=
 =?us-ascii?Q?eq9pKvYH6dZ9fZbKBxsUYztR3Y9XUki4+hdoDawoURNCmIw/qn1dV+Rprase?=
 =?us-ascii?Q?a9zQNZHv7GMr0eiKCy23tfs9zm81NEXe0gP5cpn1TIetejVRy+jRydKCSURo?=
 =?us-ascii?Q?9AUxYN6PXZVJ1hjeu/JoZHUPUcMhUTHbMP0hbWBJ5HQU/1pVEC4nCLNUV5h1?=
 =?us-ascii?Q?H3hz1OzNGq5M9hpp6FYAJMPuCkPeffsc95keFQEkaxxVGKSgs+eeqpszJVhR?=
 =?us-ascii?Q?J8h0zp8P7ONS/MBVBBCinERN00Q2qie1WOVfll0wbxeA0tyLf9FTb9Cxsw6X?=
 =?us-ascii?Q?ZSY50lv3mcifQaEtr6S2AoT2V1nh9RJCBfBbngZ9LDTuFMcQLS6TfnrR9kaM?=
 =?us-ascii?Q?TAz0S0JTAxv5eNeHqyc0hLbB5+3ot81JyBuwbE8ypH8TD7OWrErykNSADKC9?=
 =?us-ascii?Q?GIS9zO/wPmIKzMdkCaIOfq9+D37cIqH5Y3gfjz9Lv90gZ7bzT0a/0DS1ZC1Z?=
 =?us-ascii?Q?hGi5ff6MXbOU+Tgpngljl/J2/mbSX/F6WoOo8C1p4JzMih2Lfgi97hfn/9Qe?=
 =?us-ascii?Q?j4iExgrZkG/rw8cpubdAQpUO9YXgPicVaIngg924xpQ0PSjXBSDNaqZuVVDw?=
 =?us-ascii?Q?qkHyagr2NryXnpB60R4/+QA1bH556Oz6TKObVxLlBNinG0mVzZo6w+omCefb?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /cob9m0HrlnF1w3csudl3L/OtI5mK3jhzP00V/SirddE77zS/w/bndeGukRpesUfRGVEfaf4bLNhNQuA0XGuA+CmGWgj+oAtjiWFzFm5HZIjYk9vHRLiboMkcURiEgklRTuU8Kgz0ce3/fmk67vlZHYzunE8MyYILOclrvXkCr2tvmCW56F0MC9A71uoRrAqg7z9VwqihP+67ZktTyybn7TwjJNNh1Dw14nbULUm65ESG+Vvgh6kOYXInRaQwZ+leXX0Bu+OYwHOUQ9v/MawPlRdRM7R0Ez69UYFUTdopk+nUlcpdZBtITCVTYWnINkYcYdsQod1HRpooowlDaqErqWNEK13yhkVmtvPXq5XPrDP8rZuBszdNOobFRdSzfW2ZZ84OJMcJgVFd+OvM60idx/nIpYn4vW4cXjw2cOk9AlDm2hedKdA6kjx0z5zL8rtsbGzzVZq9abK1jExATa7xobq8Eti5q4Qz27f/UO24adC27IDuWCvIxBylj6t40Pdfm6AFRB7bZq0JI1d5YScO9mnyw0WGBrCM8lUjle9nLcRumd2ax0ogykC9b+VAEge2JuPpEBnhRANT0TQ97M1gbC5eBNH9ZW7GX/wGE56fclIT9S4kBL8ejz8L3PEtwRKvhQJFnLuzAZFxIvizfTmoqPqTMx2RyWjMYYdMJFVp9xITPFcyZZH1R8rs7aky9WFI6tKHRXTfz9rRubtpfwfEfF33KYCaKwAwWNKkAHekUdHF7RizPypuU9/j5CO5LKm59mqXZjJL95BGu9b9qkFtTyg3354PeKyibVzJTAaf0s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99abcb73-72a1-48fc-1a90-08dbdecb67dc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:22:20.7310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xU/m4fQLToMaxdZ/kjTKyDpzmE+Uen4reMwTI2lu0G9y/6f/OBsqBeWv7B2LoDvpYSQCNITbO+4WS/AeO3/GHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060108
X-Proofpoint-GUID: krh3G8YMMRHkd2fYBrGjQAVKSwz7XQjY
X-Proofpoint-ORIG-GUID: krh3G8YMMRHkd2fYBrGjQAVKSwz7XQjY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mb_reserved has been replaced with mb_info in upstream xfsprogs. This commit
adds description for valid bits of mb_info field.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 .../metadump.asciidoc                         | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/metadump.asciidoc b/design/XFS_Filesystem_Structure/metadump.asciidoc
index 2bddb77..2f35b7e 100644
--- a/design/XFS_Filesystem_Structure/metadump.asciidoc
+++ b/design/XFS_Filesystem_Structure/metadump.asciidoc
@@ -21,7 +21,7 @@ struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
 	uint8_t		mb_blocklog;
-	uint8_t		mb_reserved;
+	uint8_t		mb_info;
 	__be64		mb_daddr[];
 };
 ----
@@ -37,8 +37,25 @@ Number of blocks indexed by this record.  This value must not exceed +(1
 The log size of a metadump block.  This size of a metadump block 512
 bytes, so this value should be 9.
 
-*mb_reserved*::
-Reserved.  Should be zero.
+*mb_info*::
+Flags describing a metadata dump.
+
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_METADUMP_INFO_FLAGS+ |
+The remaining bits in this field are valid.
+
+| +XFS_METADUMP_OBFUSCATED+ |
+File names and extended attributes have been obfuscated.
+
+| +XFS_METADUMP_FULLBLOCKS+ |
+Metadata blocks have been copied in full i.e. stale bytes have not
+been zeroed out.
+
+| +XFS_METADUMP_DIRTYLOG+ |
+Log was dirty.
+|=====
 
 *mb_daddr*::
 An array of disk addresses.  Each of the +mb_count+ blocks (of size +(1
-- 
2.39.1

