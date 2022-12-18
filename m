Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F74C4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiLRKEC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiLRKEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:04:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CAC6597
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI4nAa7000922
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=ki6jJqgbEo1d1hHZa8//4+1R6rAryQMB0diTh88Yx/UDGP3loNoqrlg7w9DW2difiPgk
 +pbfyTcta/9SWwoHRc+RXcl2eTTf0NkmimJndwN+IZrlKEEvUyZS3f7qj+gXq8D4qrHj
 aijKvH1EmvmK1DR0YNGA/Vxl0tGRbaP3i8uXSJVULxM5y7cMS3qYE/L7FIvW3nozRPj/
 KlyLp7xRWdKP6mMlq5wk8hYAv4x5RmHhPhFK3+TYwxMf/d5GQ/qoPts5YhsLeMmBp3JI
 8WVCfChm6LQ7rkmybH1OYUjUVAlvFkFNKqQzDBVbpfe27WNaNjLvzf6UXtnXWGbfZ2Tc 6A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm19ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI8JeXH024870
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh478mxs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyECK8/kPhO3ShNvdW3L5+LY15BfP2TLEd7XRsopVfWdmx97oisHBZ0N3QKCzn8kqYm/kDb6mfIO1hLPJOevIM82HpOCWIXN5ueBxaGMgU3fRbmGzirnPLnDqb3yp1bpW2166xphVnckeHFZzUF8YTj5sLUG+PGSlpvBdJu6GyYM+E1clrXuRt++9RCRG2uNdnYtKG1/LSroMxdXgAdLZmyPAP5H39UlAH3u6IxCwvsQXo/wmxxuF6uz2aJM9XUCcxpAws8YtjTgencZAFJYs07tTAfSOWT0pjRJMzGWRXKDik7id2/mRCMvPHF2HR8E1/MVhWse7YR4B/D2mCm3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=KSgSL40OgZ63JyzUfGITMtJJeUQumgNq2wsICRgjQaYE71muGMYuU6M+33uH4JAPZIOEFFpdFcfqNknVqJKV14rm+0JpZb5AFvXUkpWe/RGfNwy5xpoK5umXtDz/dIvlNV7LJx/ikhnnqnvL1j8SSF4Sxk+nFXXeoD9DYr3eLTKBfmdxFLp7dEJ7eMM6fa1+SCa0xn8WCKL0lDbdKLvfVHaamXSxvjJDM8VaLQ7dzV2CrGRZbTW0Tl8kY01vNjpdrdXH059PunG9HIFJo1tH62NldUEj8Bbs+aOW7gMpb/vCB51ITy+UAO2RwRjIg6U/oMhAZgrStsMJmJ3ZTtck2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r5E+jUVmqy2GQaGZCtwPHOxi4Rm8gm673bMX9XGoY0=;
 b=PUBrdMHOlq0bQwwQyOlekOTIlzMlviXRPKMhiljXC3yC3EwybCI6mPKgjyCy2cqYWPYF6x3zXl5IgPt6xtDBL2SNhB6VMPC2CY3Eb/HdDoJX1/+/R35Hzv2WGF1gIE5q8hZCQ8QHbgt0iMjkAgzg/+nafmztjfo/nNCs3BudXJE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:44 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 24/27] xfs: Filter XFS_ATTR_PARENT for getfattr
Date:   Sun, 18 Dec 2022 03:03:03 -0700
Message-Id: <20221218100306.76408-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 5871f842-6c5b-4c3e-882b-08dae0df25dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/d4dynlFpi5++OL8XzKB+1iuugzQhFR2UdW7o0Fonct/R1cfUPPoVlgdYDhnwariCtucUEZwSrGyLZBRCmGoupL3sU+TBVZ2lTZCstFMIlCHWJvHUinXX44GAxj6/oNsMH344srk2eqFtOvG6XzHMfpBik+jiqNOR+j6oomleyCY5gI2vZ2YDI5fKHcQqC8pQe+8OHiKpzHtAmIkyxo++wChnDfLm8l+9xgeFBxf4V4GBZG+gC0kUYNJX4diSC164U5v+nRimyr+XG3rBXUE3D4/6q7dNsVpZ4Ic3DOEWi6zKFjVwXyjjaiPHtp5n+KDw4IPkmUZ4T9pHz+OdEVcAUGNVmLgDjjPjKwTC4XQI87K/pSKl/2oVm1OLVwxo9bqD2jV7ElXhudq50fm4bfDJ96ZlJehJyKqzs95WZrA/9OKZ4DxUnRg5o0Abe/RdLKtVxF2FFJLalznVhgBDtkx73vCfEE3W8eVBm9HtQs5h15DLRX/o7lEj6oW3FPwVl/58YWkxlWdoUR2JOkXWQq7o1+dgZ1ylya6KR81IjBqr0Sbyjjk7u5EF+T9g8RqynQBew46hq59qBc22CgToTSDVEDA0Ni1bALlDZJXH2765x6UvSqqt5bHo4tAy1PkDr6/gC3QOHHpen0fqobRQtGrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(4744005)(2906002)(41300700001)(8936002)(5660300002)(86362001)(38100700002)(36756003)(316002)(6506007)(6916009)(478600001)(6486002)(186003)(26005)(6512007)(66946007)(9686003)(2616005)(66476007)(8676002)(6666004)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/mcp2s3uXaj3ek4RsL9YbzRYEFUoPhOgpS1k7h3/l3vW9Yg7/cA9g9ZFORQB?=
 =?us-ascii?Q?3HqIlgCcWevJuwc+oe+DyeAIuk6yFLzt98x34rjRDBELcXqQCLsBQ6ix55pC?=
 =?us-ascii?Q?k0dU3+4xgVPgou3w6+hSpSifmqfjZt19owVhTwEAYxizI3rLD69YDZsc4ZaV?=
 =?us-ascii?Q?xAX1z4Kz2RxaKIgOXXL3h+rGhf17bPQ5SFl0bok3AKWde6A94UM7KHsiikKS?=
 =?us-ascii?Q?l4l6a1pi4d5JJLTqJI7wm2oyRGZDvwpeA4cCU6azzjgmoLAKC81VYHW6PE8Q?=
 =?us-ascii?Q?oy/RuO7hlr8UbRvb1wsW01oGzTdpfLM2dzD2uCYbRPmHYLwCLvc+SSRwyhTM?=
 =?us-ascii?Q?QRqIoQhvvfWo3iJki/d+X+2LeJPqUHP1ytdfN8Ay2mvI2kLoeS3hinN1hNG7?=
 =?us-ascii?Q?RPvPaC8qDheJhZZD7zW/4jsQpGKXoYdbzSdP/Dvh+z9d7m3Zc/T4wSClVE3T?=
 =?us-ascii?Q?AN14oNc9zS47sPioFagn2AzR8f8o/XGdAoqtDHQ/LqKvCD8WDWzS8tRGTWK7?=
 =?us-ascii?Q?suT8+1+SQaySakqL+6qAbgPfY2SYiLSeT/DxciV1dzr9gbudBjC6iuv5IUmn?=
 =?us-ascii?Q?byBHuYhx6usLX3wTQMXU9ZIo6lUm1qQ1JOazS6OHzHr6CD8E3nq8qBtNjXlj?=
 =?us-ascii?Q?BN5NilUHvsQSPoqARRGeOfrLsaxJLO7OOMLGst2T53/7L8b3vqKJ6CUop9BC?=
 =?us-ascii?Q?BR4o8vacAXgA6Qhh/gomQklbwRrMZxtUNf7nlTGIjLKRE3cWGA6SU/K1jmw5?=
 =?us-ascii?Q?hHgwDlYPOi7rLIAP/87Mq/NeipgtAKerkGgk3QNt1GU4gceaCI0UjifybyHb?=
 =?us-ascii?Q?Hr4xkH4FmqpeEHOGCfS4I+Zk7qiwwTzYWQeG/9ikwTSFavfPwHKDVDvNFalI?=
 =?us-ascii?Q?PF46xZ9sR+h+LUObGJWBwXDg/1+qNcGSvY6K9r+LNBNF5mKtrHGPtDssP3+6?=
 =?us-ascii?Q?7XDLdtuDjKzHc1qxh0OTOSGtc/PugEcEG6TxOvp2Lp5mGuYbklfSKrd7CSVh?=
 =?us-ascii?Q?ADbQUrA3H0udPLf37WFbzVl8LB11TPf5/y+bK0qIpJtCrljiM0A4+iKuD9c9?=
 =?us-ascii?Q?Ruj+Xlz3Q2712obr9dFX0bsF8+pQ5l/+ocoBhduvI03BmGSQzBfy4p7C5W3f?=
 =?us-ascii?Q?NbxAlQLjTrjq4qgY6P3M9qbrAMUdb5SMPsml4hVuRs+NceCwfRMUOlUh62C4?=
 =?us-ascii?Q?s1pyeDhRZdJdwuhIdhLzr473hjTajDjNPi0O2CgNUh5Cggsd5ApWkR5QGTkX?=
 =?us-ascii?Q?JoK8cc/9ni5p78aeB3OtMtwoKb2UIqCLnb+IW/jLkFrqKzTESIPMreSBMrjO?=
 =?us-ascii?Q?09dtQ2zV/uUqN9rRU6APViLJHoUUdmcXzbMXrpqcuCHStk64uTxT6VIHU13T?=
 =?us-ascii?Q?HKQoCTdfXMZwVsmTUCxK9MNXav5K7A2Ii/PzXnAy9Zg5LdOiKKcooRQ/dA+j?=
 =?us-ascii?Q?RntXn2UvPhJhE2PWAfXZ94wtLNRalwl9DheQ1nAAk2tB/Sqi1OuSaNe10iyQ?=
 =?us-ascii?Q?MhKR13MV3YtfzQ1lOX6M9+e5YHjez4JHjBOitZkH1sgCMcmg5gAFD7tzoiOp?=
 =?us-ascii?Q?3LWJhktXNHoHgBkGbKlamNEsd0cTB0kqcHPC7EqCrTrDgZBtIXLzH58cClX3?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5871f842-6c5b-4c3e-882b-08dae0df25dc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:44.4665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TI+APPz+n4aZHpAzCHJ9w69iWivqNLPwQOSs8Psw55AQwu82Rx0acpeEn8ueW5w6qjXfrH2denQKRNYkqGovanFvED3Mf11VQZg1rKrdpYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-GUID: y6iq9CU_-4kuuRBBxHRELOmXBH7y0CZs
X-Proofpoint-ORIG-GUID: y6iq9CU_-4kuuRBBxHRELOmXBH7y0CZs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 3644c5bcb3c0..3d54701716ab 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,6 +234,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.25.1

