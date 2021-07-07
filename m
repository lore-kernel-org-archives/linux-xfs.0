Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88259C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C1E61CD6
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhGGWYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36946 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhGGWYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:07 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKVsd029353
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=D5mjuP+PRkBsb4kDxb1pNkJA9122WW5gO9gH+tCYiqM=;
 b=jZf4gNDTGdZwfxDvLGUWpr6wgE27dZ+dUnOa0+3v2eVrRxvqPnZxQynhbJwlafgDhU5C
 VfaMJBQISMqAjPpej1DfOBDxJV8XOw0+1/WBznrlMFhpGN5yYc9ci148pPCcg8Kg4fqF
 pDq9HOGjO9PBNkz1thQ7MxqEKWxXNnejFMstNA5xZS5EyW6yDn6kHm11Sz/hVZbeHAKE
 bfAsI3UPaIsSFa/dBW1FQpI5KHM6Q1zJ0prgk7iXaEYt3rs74PD7++iiRi9TWIq9Nx5I
 jqDJcU22rsdArOW/MrLj1EzBbVz2AsEHM8laHP8XVQglcgWk/Y1QMn1NZPl1+/7QGNmH Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2smn6u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSa092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXkhx+xpNSw2oEptoXTWWppTituoZNKsRjsdGffLiSE7pWXII7CFjNKuTRLC8BccUO5O/x0NlCTTRYjJTChiGqNoeE2rE1o/IWvXB9OxrUUOXfcyQbVQilKYLBhoElzePGEHy6A8L0d2dN9dpXVSNmbQUKWXHUdMgtA3b1UhBAd4R5pasPm6DdcfDc0yRSJCYWFbBr6NJwuq1vVR0hRMeHkigKr6E89+Hjxn5V5HPOZux2rniWDUBTxa0oQTH7L++KXQFjDRbr3ZMFadxf9BJzmk0uNZLN2bordCGbOpOTb86v0ClbUfVZPpgMkgiVIlzZQDqOsuvM3dxOyJafJRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5mjuP+PRkBsb4kDxb1pNkJA9122WW5gO9gH+tCYiqM=;
 b=MCbCcSwK5mCYfGqKUE5JEb6LOtMmfwbZDVXV6uYGqr8g18xKAmzBJI4Md9YXO6LTsM7Ddv+kHRnA033TaobpjLZ49i8cK6M2XVFJN3Nah4FLszOGy5ky0Vzo7EkmhseO9+lI5vLpthC/bRLNbh0grWiPbZOpYjgIMSb5Vf1cLfrcrwOaF6NPN//tkw462Nj9M1wbirWLwt4J4GUn+1pyQCAzujSZixhSoElU2KiK+mMfJOgc6TIFaNWc2eDY0tbJb/ktXzjH2DieFuMEZPN8fCQ5qESM4I+9jC7XYo49BlLzvaxWah7R4f+87ZuEDrPav+vRKblgX7su/KvKxpSipQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5mjuP+PRkBsb4kDxb1pNkJA9122WW5gO9gH+tCYiqM=;
 b=EF0MWEV+JVlCzLkKvQzvedPmXzCfJ5n4PHodFDycLvsZtKBEGK/UXjObdIp5mrw79lYDh4YlJk/FeCu1IZUS3v6biBkSpJ9Pht4GhJ2m9GiPHo3DnRWXu62/BojMHYkmbLPEphHSlSBFvd/iaWPxvfoTEf+DyVUZZKzcouNYX5k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 01/13] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Wed,  7 Jul 2021 15:20:59 -0700
Message-Id: <20210707222111.16339-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bafaa27c-30ea-45c0-ea4d-08d941958d60
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27609B65E5103ED3D1BEEF98951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZLvHhXLJRhvggMLrSlRx/ZH2xM3rJarJnj1UXNSwJyvJGuo9EjYyEzpiGn+pT7qJTEkd5T37OJtIGGHx8Uug36jGWTeNlN7svhf/kgNXm614vxuXPt/t2UoxLVbVd7Jeflm10dWb/mebfpWyx6fUyPCzsVIITJiJd4DG3Epy0pPljwDiDhZM/PXt6+xwi7cmirBCowPsr6RKQFsTbwkT5HC7vaybFFii42UEuiNKRRlW8l7EUaS+j2oH5So5WiO7+jveUXrWDLBFcVY+/f7AOV4Z0oCfBHukM4Xtbygw4YrNwX2ZPxn8TvZ7nFyuhIDw3kTaj1p/s5YeVFYyXgoCJFpRQTqPCXYirOSIVM43C7q60f6LlCd3G/koCjIWJEgMYolRNXSXUE9LL3Y/2gcY6v7RztsXFdtUCUAzSvpM6WhUJpBwEJ5jVJmoK9e3rdpCee3rfYm4SLrwRCiRaLWRxsY3fvPb0pPmfl4LiEgaiLQQPtB0ChppW/N8RwhloxTsRJSJYdOc5xZZ5WEpPBV3N7/SOmbtwWvZht1z297XTpBoxTEnFs5DTuWfEDUnE1FZmj9U0yz/39xHGYQtOA7vX0XVF1P1bRG6S7rFEaGO2coFs8nQIV63CC2kba5yzWSFeZiGTnRTQy8P7/NMBiBAnx71URwj8NXPrXyIKQGtr3ozgudIoXY/0nyFdVFcxIs04iBxngVJacouwazB0DxhTJwm30wVqu0Z4XJ5b9hVDKc4kXNI8oOqEepwnQnjUGgrCgyWWDl5XMA8rfuMwkkZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7HfYkvckE28O9B2V3a6QYjsAaUyBQBnzag/VOoe6kmY225Ggtk6ERqqcvwM5?=
 =?us-ascii?Q?sBjF6ZyKhQSdBLOU5GFsF6dVxMs9W0aVufniF0Sm71ndKBzY/0/xtTX15gXu?=
 =?us-ascii?Q?NHmFGXgi63bENQ648nxZKhgFLK/qyZ4l+ltA8TawyjLrUSswCCzcvMRULcMp?=
 =?us-ascii?Q?GrorR7LMEmuFbmrqaaoADMW/GR8tNpBKq5F8+JcZD+xEZrB3LmUu9LKFuULX?=
 =?us-ascii?Q?kO/d2M2TtGBVUGvyQIk9R9+elnkGhwaVazkA/DrjmdjrQKa7iHNDtgbANlju?=
 =?us-ascii?Q?a6aO3LfGK95TnO+mJsnvf4W9RjfTRo4n6RVqF+nSbNjYBOzZIp/XL3GuibiC?=
 =?us-ascii?Q?mmhIu6YXrUzeyQKN07mvH0DHIYRsmh/tPQxXoSWMXETFx7FK6Lhiz5s75bsP?=
 =?us-ascii?Q?+cSiVnKkHz+Kr0wU5htvjxSGUZbAM9YMck7lKwi0xLxey/VwqghK9k1feyXo?=
 =?us-ascii?Q?kGVojlMauCeSpqzkDFblag82ADXF+mPBZKMg82XAjbSQmI+apNrfnT7DCBxU?=
 =?us-ascii?Q?mAMgE137gz0Z4zqchejTQ+scQ7YzsBViL5E008XGfYZwPbY9Qk+uHB7qIW9g?=
 =?us-ascii?Q?SihOURxw71zW59PnaH4HpKZcXVqSJfPjIHNnF6Y9Oy9MwUwFoINnFxjWMpiu?=
 =?us-ascii?Q?vqxdSdg3XmsMv5BFeh5L7zcnYeyAjjZoCfh2ZN5r2YyD5lgntYr330vLPrt3?=
 =?us-ascii?Q?q1+m/WXg9VbAJLNMQjhDiYK+dYU9gOFM7+F/nyfB2nfwhcUaqcgqQx3q0ApC?=
 =?us-ascii?Q?n/mB1lU3Hmt4/jhzQfydOdBcF5dLI82Rwr0E/E4YpvV5DkSP3dmC4cYSw+k2?=
 =?us-ascii?Q?/FoC+Q212vq0Sk6tQa+LyOCJu35xHfIkEjVmuZs4dXZTMM9C3+P8WFn0prwX?=
 =?us-ascii?Q?U18d14ImgH89qNAgASgE2B7bAXQYrVemLlhWztIIvg3buncXUkajAIU6Flb6?=
 =?us-ascii?Q?2Ge3EEaOU1ZWvXZtmHLBE1JeV2lbHBJ7yq6OZ5sCRp40CnbKC5PEspPsIcDN?=
 =?us-ascii?Q?Uwzf2kl4RPWUI5CxBLDLbI30L9SX31/bLXtsXBkryXpOac78VY4DFO2UGMUE?=
 =?us-ascii?Q?in7k6Nlgodl3P6Zkhx4iT28FV2FNvyr7xbR1IsFb1O/Nu08vgmCMTXm2MeP4?=
 =?us-ascii?Q?gy+Z/wNX1/JgOEU1/3zaiM/Ko2DUSQMEXstgW/gzxBncC6UgdJbtw9ibK9bQ?=
 =?us-ascii?Q?5Hnp3poFMgGGEj+tSILVxMWUHnuEffkEBINsxZ6sEiJsSOGLYb9oOaeJBG2s?=
 =?us-ascii?Q?/heRkGl4pBUhSymitaEA/A5Z8dXubuOXoITAgguV0RWmfNMby+BkZwM1ce7K?=
 =?us-ascii?Q?sF/BOWzR6my9WEMAyeQA6FFo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafaa27c-30ea-45c0-ea4d-08d941958d60
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:23.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 689M3KS/jSrUyUbhsMF2N8HnothaHQK9WOqyMpdFX7ycKxWKXW9j0pBMVq/txzf/5ubCskv+pgg2DKWQEKzWSUG2KpKsZ9VAt/Mt1w1LExc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: OZgO_4elOcwQwJHX0_yNMHGCuQQN_J3X
X-Proofpoint-ORIG-GUID: OZgO_4elOcwQwJHX0_yNMHGCuQQN_J3X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that neither rmtblkno or rmtblkno2 are set, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 611dc67..5e81389 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -409,6 +409,13 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno && !args->rmtblkno2)
+				return error;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		return -EAGAIN;
-- 
2.7.4

