Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B9FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKJVF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiKJVFz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4E6C14
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6Y006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=5JiKJfvBh2RZXPzYP/w21o0F7Tul2AU5c7RcxYx90kw=;
 b=Ch18tfLZjRxVkksVe2wFhQUjq5+cCPyMGbzZZWE7b46QgyfriqNe1GvnBcRXlFWQTVSQ
 TE1+Dxnja7NBh9Vild2gTJf4w1ZHLZyfT77axPORNTbU4uYY9dUsxLjBfoPtPsH3ycw/
 3v8DZpSTVopaSG4zP+Vq5GLO1e0jdMIRSbS0TWMRUrFmjekqR4228hCmJsx0zYpvovuk
 Hu2puhgxml0nhTjdZ6lpMtH+FkMh8tVYsApOB4I57c53uOrVfsoaWVPuDEue/bbZqs3o
 3kzbB2zcUHi6e4U17uPW2LmjZkBXl/mt7udoDco7Dg4KMhf7FkgkDJM4ISa5qmC1lrZP 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r127-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKTUmH019793
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqkmngh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBBcQXJf0r196jqtzrcW4GeDQ35lkF3HGQv4d8gPZP+S/6Z9mWR7Vm427oeQkhbywm3R7HETdAiIqNFarY55OAADeOoWSkTwOJCUwSkBqj3QvLIrajUEzQGMfTbwFdcPwh5TEXPAy7nWQZRXaKUMH2DM/Tgt6MAV8nSC56dqzqo/OUWMZl+7hGk+SHhWanVGhxnHys8DGx2rEAZQYr1thc4effA8gPOuqG2u7K2eoP2sZnPjeMkxgxLebfKlaegMqGRLWDhhE5oHvdWlEgn9gquB6nmDdplPi9MNhiI7BtxLivzc9MHmFXdnqg2i0N4PKJzf5ZJ3VthoccgWZ7JLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5JiKJfvBh2RZXPzYP/w21o0F7Tul2AU5c7RcxYx90kw=;
 b=nOf/EvzoL0lKMxoduf1PCEUdL7QP0lwAC95xxXz+ks/Kpe2Hqekb/somBUzy7Z02YrKxVp5+Cva9HxcqJk+PsjbpQGNlZeYowAufNDe05KL3cvHxDTFwElhHNGi2QnTLtEZNgjJrI4jOFqL7rMRqEzlkkDc4SM0MQx8aDehxhU8M07EmKCN06BJ3K/V7Hz4PkluhOxtSeYV8oBAXqSMseveq7AH2aq4KUWoAys83YwEAKPN+hYKc7ivgMi4kxskQvjSPZhaPRd6BwpOPy6bxYybULpCTwgNlzjAUODmOv1hysOgrpJX4V3x9l2txMmEe6YPyioUSA5K0C9pGytDO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JiKJfvBh2RZXPzYP/w21o0F7Tul2AU5c7RcxYx90kw=;
 b=eTKfecW/o1EThIanVvp1p9NN8ZNi3fDLfO3xI9oestxzZ8u/v6r5LKMZ5gbdiZK5pX7ExGbN1gN57kAv73H52BNud80RzJGmRCDCEmSG38kxqjH0x2u3n2wlncqY1TRcAeFBw7ibLuKkG6i9hWyhK0l6dv4rQpPXXZJhU8595to=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 21:05:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:31 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 01/25] xfsprogs: Fix default superblock attr bits
Date:   Thu, 10 Nov 2022 14:05:03 -0700
Message-Id: <20221110210527.56628-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff6a5a6-9317-42c3-584c-08dac35f4cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62/WoPh7UaDsNdhibJnMNcLY5d8AzB96YLF3zsP9Wes9kwfAjLxV1dBNgiH5/gtaea02lJpvRHapuA4DRqomqgRa5EEioPTwZ1N1x8yzuDysoPT+CC3iWJkxJrArsIK1ZwOsIv9kXaV4/BR8Sce9jrvAcXbHbv7hQf5//ryKsWrgfR/V9zvjaA33jl0HqMwnmQzX3Ad/WmSuYt/lSFL62g6kUekLGHFcI4xc6ahOaK/HNj03KfWnCMRl89r8P+Y+8RNRUQEizWRnhObFAeb0q41jN9tKyosZA3e4sleMmNa5itqiy7Yp3uMAKwzEzTuloB79I//2fx+ZRQ2T64gTK74ijI+mGsb0DJj6+HQWyoOVYKzYZeyg201nPXITCStOm7xEwGP3FEL40FZCd83dzcN0fwO1sytHRNanQQdjqrAdG+x/B4DwZWKraxhzDZnPTjMp2sYWTLTj7p/atwQ3qTUZ2qZELeOjicr8EP+1ohX3tzTPtT0g7sO5CgbLGOi42XhB+22am4zIV5wVAHNMBIfpRMHx1OIlU25y9sXL2chWXXQweRHJwFkyU8APEMouoxO0BlX2ydkPXh6+MHMbNqmH7Qa56OxLdjFDWvI063lgy40zehFferPKKGHZGtG4PDdO0xLgEOhf6U3inHA6spN3trxvTPJiZFroC8wEBuo3WfcutRgOtXlazZzbrgIjFLQkXC0quONGRRIFaPvBcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(8676002)(6506007)(66556008)(66476007)(316002)(66946007)(2616005)(186003)(1076003)(6916009)(5660300002)(2906002)(478600001)(86362001)(36756003)(6486002)(41300700001)(26005)(6512007)(9686003)(8936002)(83380400001)(38100700002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eYcoh9b50mV90gXIzQS93oAgi6cIleIy++Y+WXcAj/QrlI9Sh6Nio6AuE3J0?=
 =?us-ascii?Q?8g8GjZ+pkIgbNkogjDx3RlHPKGh0zJe56/qIQi/oFolITE8QHtj74rFhssQ9?=
 =?us-ascii?Q?2Y8WR+Q4pmIdoTNnTvir4VmcLfMWOM5bgqlCT4a3O+4PGFV7Ijx2wZ4p+GRH?=
 =?us-ascii?Q?69YD2UzraGJxf/6l0Q4GMDZqs9qGGIqOK4tMmZ/V/KqrICdrxk6zFoNaUNcC?=
 =?us-ascii?Q?mbUdjy87B/hx9sJ51+tKgyL1TdsfsWA9L/Y0z8DRo5megTxJX5GasMG/B8do?=
 =?us-ascii?Q?bE8kE2UUIoWF0gYllyjjAck8ZuCJPVvKGGmtmWfc4pbIWSTMtZlVIDJ+LRpe?=
 =?us-ascii?Q?jVDolHPMBhgkXNv45Qrt2KTTGFhb4Y6ikFDAo3JRxKsYVaeJWgzG6lVDs2Ij?=
 =?us-ascii?Q?lo3iBy9oWOOyIUIEp8MrO+XhjttmQM/TNnWOJ/eBaM0hUHwFPKNQWPMHuPhh?=
 =?us-ascii?Q?iDjz4zyMzz5Sm5FPgTMrFrxHkgSkBZBAsxOee7L4weFjK5utvxV7rXfaXEu0?=
 =?us-ascii?Q?sDgKR18nQf+1lFaCxRL+7SmzopEUvsYLyw/jzUfBi9IgDZhHMud25nGt2L/o?=
 =?us-ascii?Q?AjkcMK0brqR9YgUWb61UYIj2Ul+X7GzKLwuYwl5P3xObI0mwS42shJ+JjW2s?=
 =?us-ascii?Q?KChx1wIp7/7UcaZthOGCAKp2UbUpJ7F3uTMsuzPdxheZ+9THDnqOumWW60NN?=
 =?us-ascii?Q?Tn9nH/fc36H9JhYlzkPgru7S2kS7SEl7g8OHmDzN/zjfjQzxEncI4DAbRtMD?=
 =?us-ascii?Q?8e67H7aWPCM6e3MlJH6qKT3O6losY1EM9FCfJw1HM5BUgYXIf+f6/KSjUDEO?=
 =?us-ascii?Q?xIDJSfvfJYy5ij5HFDzdAc4yNNzar25xxNKrUOMhJDdwd6UmVh84DhpH5lQQ?=
 =?us-ascii?Q?Mivyb4jWQPf5PWgoNjmql0qFxlV0yD7nU4p+Q2EbiVoze6AuvPa4jtJFvZl/?=
 =?us-ascii?Q?aXJidgWSjkNTIF+bg5jImSlThYy92M7n4y83WuAHJFlvYX8cbGmFtyIGHXpE?=
 =?us-ascii?Q?KWdXm2J1dsCXEtIYm78bL5tpXpmVweHAP1I0PDBoTWcgONg14eIsIDGS7Gef?=
 =?us-ascii?Q?WyXyxdqA2qaI4yFwVufqfE1M4fRRUJjUjeP9zh3nOe8M4M08EwcIGL6k9UoY?=
 =?us-ascii?Q?A/Odf9jYKYfHXXXOmUmCbLw/ABnlG8O0NB3Cr6ZNFyiKiJCn8jS59iVYNQps?=
 =?us-ascii?Q?1fFwT7Z8O12Y4dMjp74CZ12bT/WFulB9icNvdlo8XzprlUSQCtScY5Pl6hmd?=
 =?us-ascii?Q?Wck5Nr44viZiDv776cNf6arQuELAKbOn46G95XFlRPr+UPvmYp2URSciS4X5?=
 =?us-ascii?Q?J8sbsm4s926Pdm5Da109WK9H8bNcWxSpfo9D5T5PoCwaKE06fs2bReQduX8Q?=
 =?us-ascii?Q?ruVpMwvhSfpBqqRTxYVlyVPe2bCWK+T6guOZ4YYUb9Pk8iTPBK2EbU6DY9HA?=
 =?us-ascii?Q?Tx2If2vGRp6yaHI3lEv4PAbdiUa9Lu4h3M+pL07bn7Vr4GbHtusLR8P6SgwP?=
 =?us-ascii?Q?4c6fhyj3j16cRcGWtU3jQNEz5yHZb3te11qXNT+96ywaygbsvAj1Lo7ccyFT?=
 =?us-ascii?Q?oLD3lN9S8KbgIk41bMkrR3SROgBSQqdM6dd4MbnSmaZ0RXkkTjQEvbIJWiKZ?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff6a5a6-9317-42c3-584c-08dac35f4cec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:30.7775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEbQlxZg8AvZDX9KznNZgxof+Thc8Aih4E7OlmyxUHCHM9CkYfmYsAqJmDuKkAqEfpVeeb7i/4T+qQzS+V1iV5raGAR+7E6r+7ihJ2nBLrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: gXmxizy1kAlt1qIpnYZPAkmKUmf5idjR
X-Proofpoint-GUID: gXmxizy1kAlt1qIpnYZPAkmKUmf5idjR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Recent parent pointer testing discovered that the default attr
configuration has XFS_SB_VERSION2_ATTR2BIT enabled but
XFS_SB_VERSION_ATTRBIT disabled.  This is incorrect since
XFS_SB_VERSION2_ATTR2BIT describes the format of the attr where
as XFS_SB_VERSION_ATTRBIT enables or disables attrs.  Fix this
by enableing XFS_SB_VERSION_ATTRBIT for either attr version 1 or 2

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9dd0e79c6bac..e3cd61626186 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3205,7 +3205,7 @@ sb_set_features(
 		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
 	if (fp->log_version == 2)
 		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
+	if (fp->attr_version >= 1)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	if (fp->nci)
 		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;
-- 
2.25.1

