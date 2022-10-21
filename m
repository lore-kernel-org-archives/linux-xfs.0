Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA74EC38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJUW3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJUW3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7C750B8C
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDkIK003800
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=QLBYD72cZ4JL+uw0x1P61QzFyL0eWYeML6DQFsDBXUo=;
 b=cOi4nSh2cdua94RggGG/kQKv+wdQ6vpUC0SDzYP7Q26ud9DXTihcKBxlmO39rDGQfv+t
 5yigAENHAAZu81yhK50qhYAWAnquS8/wo+1LHXpttQ92pSpRGF0Z0l+An7WdvEmuj1S+
 fTV4K3QAQmxqaX1ISeOYvMPKIteANvFfq6t/VJ2By9e1EiL6CHkSQqAhoh/GadJ2w04X
 66KynEuqjQFx5j7IwqjxiqiLCi2FAlQpl0xL6/MX5EX98buTJhKa0b0RgFxiNN1znKhJ
 Y75Kk72zzyn18YgVcsG9btmn8shYbMUGSioX3XV7y6j2qcrrA7+7b6/f76II5WgbsNHM zA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LK4fZ5017046
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hub8j6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg33y4OTwoFtqRbjW0WGKL7gRT0eKbcU94ea+X9JrLtJBTjKoYbhXeuZ7r3PBDyS1SnqB6SPQEUnd12upJ9Fu8XdgearpI55UPYvCa0S272jt1jhrHw5D7n8kM0uG7EmC2J2IsRFTgjq+36cy7IIpS1Y3rBVtUhxNeqO/F3ci5CedKIPGhmOTXAbOFd4NSjC0Fgg4GCUdCEYXSoHeFMl6u5JsCON7TIS5/7bKrBv+pjf0/Lar5elzy66xtmlDkhxMQZD3v5uRI9DCxVejYj8bSxoFG2jt0CKVJehyt38nONWJ1nZEpdA2TaaXHWMgqfJAYRGjZYp6DTisKxbAnjrTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLBYD72cZ4JL+uw0x1P61QzFyL0eWYeML6DQFsDBXUo=;
 b=HEX1SBgmm5cfhhsPxZzUj9JjdD38UbLIr9k8Vp97KldYIUnYUMn+x7D/l51kOTKTAqFhdtXl6ADwKFRSX89Ou/ucwe3G4Enr1QFhFAMKZ+xhMCrlRUDimv2MIRinlkm400c/TehltD+yarCEgpTnfMuhNCJ5gLWy3DrSlAmytWVIfKr31cKmp1SsA2dQfA4dI8j129Fq9XRoB5GhOWkefQQMGKfaiHVilMPYp7rrIBUQrKSk9DZ3Tb1FOhoB/7UbiheUL7SDqCAKQPtnyUp2q0BhMmGNIeBVff6ZJOTnQtOQ6UGSZBzLwNh0yADNNKQIxCnEfGqef+pqeQvXfWH6fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLBYD72cZ4JL+uw0x1P61QzFyL0eWYeML6DQFsDBXUo=;
 b=Df/5kY6p/8/5IURR2NqKLcGCAF0xrhgq1keJaqVHc5Ln34CSGG5ZcmX4Yx5hpttlVWkNUCvc/cmYc0vqHjjM51niWyZjknB9s3mS21XXqrW4NacAYFP03NHoGyqiwldOZmAV5e+0IHtKeTlAjXcIvrDvrUHzf0MBT96/PfC0VdU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6701.namprd10.prod.outlook.com (2603:10b6:8:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Fri, 21 Oct
 2022 22:29:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:39 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 01/27] xfs: Add new name to attri/d
Date:   Fri, 21 Oct 2022 15:29:10 -0700
Message-Id: <20221021222936.934426-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0185.namprd05.prod.outlook.com
 (2603:10b6:a03:330::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS0PR10MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 2026a133-242b-4cbc-107d-08dab3b3bdb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bViCCdX9os3IeyQFrZTxbPXa7VJKwGKXy4Wjv8DCaF5id1B1cH3WoobKkmGkQbMd2f7FYpSupgmoO3umZll5pDEAnR4wjaZp5QALoAeHbBd/SRM//RHo8/xIsSWc4K/l6vuKDKRXRzVgyr7U0nx6/veTgeUMd13YEk+5NQeQ/DwRBpbC1pcfOCkUUgXuqlI9ymJPNVtchpJBeupjUhdIg5EwbanA5Y9hpp13mkqNnD/RjGlBdLJHSFCYY+Rs+BGrtldGXibeEhExgfFjz8CjOKUahmAZhIZ/nyqzmQxup4dzTacd1zFcQFVS+SWs2MRWbiqQ27q7Wj8kY1rv2ZWmUK5CIAieq6daR+1TXZ//zPnnQGXoPj52wY7yNDHYuWTjNFKnkUzhToaFWHMV4Y7iA6ZOsF1X2HJHbHj5xh1ZDmnN4oZxk1ruiUcEVvG7dokvmsMsnFQCScFxIwYAh53IUINrVCqt8qT1sFOXHXudLb93JcyadyHiW4pRIS1PV0im0FvubQEnNVpp+rPSE1BwBNBJPVVVJaAF/ywB+hVM18cnQVNq4NMwnLDyCIHgZ1jVD2ySlMxHPu0uCbii5uVagv6de0O0yoH/QxAcYkTaaf0bpyhOgdfYTLaICmIwBsz7H7ZJc/fhF0TkVvHhuY6srkm/63cOUNZrNp3XpTDzzqLc+H7vfzPMEQIelmU7V3uOiOU+FjhwE+juqi+f5KmbSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(316002)(66556008)(6916009)(6666004)(66946007)(66476007)(8676002)(6486002)(478600001)(36756003)(5660300002)(2616005)(41300700001)(30864003)(186003)(1076003)(9686003)(8936002)(83380400001)(86362001)(6506007)(2906002)(26005)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQaNvjtlT7fnQALfhCgbig1eVOD5oJGzkSYtrRu3guOMgZD4uP8uELhEzOHn?=
 =?us-ascii?Q?dqV1m/XxMtqxNZOP6ygr4ZIMnLJBBkryO/Upi/SXgkoAlXxek5uBubH0cN1I?=
 =?us-ascii?Q?ptFGnIS3YDGKZoR5bsYPOftluR9j7ZiODxO1vBB2BcQoPwIbGmJikH+oTF6s?=
 =?us-ascii?Q?5yjZvs6RZHHLQtZ66vcy2oVPGHuqVFM9uySyNbYosNebpp7Q2BCd6HZ8KTrJ?=
 =?us-ascii?Q?2KVaK12pg3kCaY1j+FxN+Mlczd4Ca55Gs4TnetJuEk82td8thIjfatnpPKN9?=
 =?us-ascii?Q?CqdJgq4Oh0y8tQilduXeVq652dWraaEfJCiaQ1SXlRR1aLxMpvzesDxZCBHk?=
 =?us-ascii?Q?GckBRsR3AI9qpr1AytprYyVi5n+mmEURGIRXfqn+buLoYRpp8tw90YC+rHgc?=
 =?us-ascii?Q?rj9k3ieWAVfM6CImdy1CXwwykaf4LZpscC6clAkDfgGlfjyFFkxbo5xuObzF?=
 =?us-ascii?Q?ZKUPsfIhYRZfXsV6y77llQeIPu+Ikv98vkSneEMcD6Rq8WD8L1nfEXNrMA5b?=
 =?us-ascii?Q?W4/22LOV+5WdNnofkWv463TVAfjJvbnQqihOGEaQ/np1kLbBh391XjDcseVk?=
 =?us-ascii?Q?rZFO2/QBBzMwtS+S1ZO6g1fGrtD6wjPy/SiYXDYYCeV6hgxQO2QCDCX6B40v?=
 =?us-ascii?Q?Y5jGP4gTUKRRPPikI4w33ya24WBn5PeqpB/SPv86scFg1+DRTSYWIOh4nE8Z?=
 =?us-ascii?Q?HfYTjenis08p5nm9FdUWXVSXoL6FffiTm8haGYV0DRRt65+QdLOEY/4J+eIG?=
 =?us-ascii?Q?CzjkPEth7vzBrrBFiKuni4qBpUBrHYPYLvQEf29wWvrsJ9GkHC/P8A6TEIoR?=
 =?us-ascii?Q?ECH6K/MEcAJ23iOtN2qwjWMWfk1+RZEeo9zVPqcY4Rj78uy0Zv4MMLzsHpE6?=
 =?us-ascii?Q?OX2vm2i5d3R0CGfzRyX4ym4x6aF9DEYQ38p8XbmE1yoXBlY5NU1B/XRuZMD4?=
 =?us-ascii?Q?SXKEpU8fG1QRIjmmO4esshlOolkk180p+FRvFr7jQZFmB++phqgnA9JpyyV+?=
 =?us-ascii?Q?GURw+HS9I+oU9X7sO1XGxkzPpyt9yJWm7BcEbhUcd6HE/ZAmmDyJ32ANnco+?=
 =?us-ascii?Q?XCeNHYg+koOn9RnwXSPpEqAKYrGQzDPtMklijetNFiXriIiNRT2v9GnjpAUI?=
 =?us-ascii?Q?jQsdyRY+U5o2SqEp83vO/GltFuY19Hi9Yq3AaGSwUZzH1nCGc3AgiRI80QkB?=
 =?us-ascii?Q?qtyqQ5ZFyhqMmiDnQ8GvWAjmqcHDTwHkgITCDQX8KT9DQ0V2uBZvbqS6QbhU?=
 =?us-ascii?Q?bNagsxG6qLDU02jpGJgWumdsSN6DHb0e37ab0MzD5xacHuPFJueTQkyW2RTS?=
 =?us-ascii?Q?GGtgoX7ieOMidytJ8rs/kOPZj/xD8EyPgRO+c76e98dpN5wspyKIDMbnxn5r?=
 =?us-ascii?Q?KDvKnsdNxMQFEltvNW/9o6fYHiHxBuopRNqq850RluzNZb06rgFQgzVTHvZt?=
 =?us-ascii?Q?SQ4D6g9eGehda9YgnueE8ChNOmBmc+HY1DTZpjk7/5dQvOt1QyqaoOHZtUVD?=
 =?us-ascii?Q?DSopGTRS+wr3nwD5jE/ifme/+X39Fw+L4Z0faJ1hszDvwO8KiBnNW4Xhv5mu?=
 =?us-ascii?Q?tkrN5HB1EDiw6ai38G8mxESkitjzn9a1pZv60CC10YxDOwuLtsDSA5dtHgBk?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2026a133-242b-4cbc-107d-08dab3b3bdb8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:39.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOaw1aU6l8cPSaO/cp/F+vSrmL+ZXXyCFrOEsnKb6GkspW6rf0vsmwBkTen6qysvOs7FIgCk5Vg9o41Xx5jeHsf1B9NwTmZcNRuauapEfHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: Omg9f4zQwdXy-7y5loDUhignVIsa0xMX
X-Proofpoint-GUID: Omg9f4zQwdXy-7y5loDUhignVIsa0xMX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds two new fields to the atti/d.  They are nname and
nnamelen.  This will be used for parent pointer updates since a
rename operation may cause the parent pointer to update both the
name and value.  So we need to carry both the new name as well as
the target name in the attri/d.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  12 +++-
 fs/xfs/libxfs/xfs_attr.h       |   4 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   2 +
 fs/xfs/libxfs/xfs_log_format.h |   6 +-
 fs/xfs/xfs_attr_item.c         | 108 +++++++++++++++++++++++++++++----
 fs/xfs/xfs_attr_item.h         |   1 +
 6 files changed, 115 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e28d93d232de..b1dbed7655e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -423,6 +423,12 @@ xfs_attr_complete_op(
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	if (do_replace) {
 		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		if (args->new_namelen > 0) {
+			args->name = args->new_name;
+			args->namelen = args->new_namelen;
+			args->hashval = xfs_da_hashname(args->name,
+							args->namelen);
+		}
 		return replace_state;
 	}
 	return XFS_DAS_DONE;
@@ -922,9 +928,13 @@ xfs_attr_defer_replace(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
+	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
+		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..3e81f3f48560 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..a4b29827603f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	int		namelen;	/* length of string (maybe no NULL) */
+	int		new_namelen;	/* new attr name len */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index b351b9dc6561..62f40e6353c2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
+#define XLOG_REG_TYPE_ATTR_NNAME	31
+#define XLOG_REG_TYPE_MAX		31
 
 
 /*
@@ -909,6 +910,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -926,7 +928,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_nname_len;	/* attr new name length */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index cf5ce607dc05..0c449fb606ed 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*nname,
+	unsigned int			nname_len,
 	const void			*value,
 	unsigned int			value_len)
 {
@@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + nname_len + value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (nname_len) {
+		nv->nname.i_addr = nv->name.i_addr + name_len;
+		nv->nname.i_len = nname_len;
+		memcpy(nv->nname.i_addr, nname, nname_len);
+	} else {
+		nv->nname.i_addr = NULL;
+		nv->nname.i_len = 0;
+	}
+	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -147,11 +159,15 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->nname.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
 }
 
 /*
@@ -181,6 +197,9 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->nname.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
@@ -188,6 +207,10 @@ xfs_attri_item_format(
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->nname.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
 }
@@ -396,6 +419,7 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -437,7 +461,8 @@ xfs_attr_create_intent(
 		 * deferred work state structure.
 		 */
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+				args->namelen, args->new_name,
+				args->new_namelen, args->value, args->valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -525,7 +550,8 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
-	if (attrp->__pad != 0)
+	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
+	    attrp->alfi_nname_len != 0)
 		return false;
 
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
@@ -539,6 +565,7 @@ xfs_attri_validate(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		break;
 	default:
 		return false;
@@ -548,9 +575,14 @@ xfs_attri_validate(
 		return false;
 
 	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
 	    (attrp->alfi_name_len == 0))
 		return false;
 
+	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    attrp->alfi_value_len != 0)
+		return false;
+
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -611,6 +643,8 @@ xfs_attri_item_recover(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->nname.i_addr;
+	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
@@ -621,6 +655,7 @@ xfs_attri_item_recover(
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		args->value = nv->value.i_addr;
 		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
@@ -710,6 +745,7 @@ xfs_attri_item_relog(
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -731,10 +767,41 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int                             error;
+	const void			*attr_nname = NULL;
+	int				i = 0;
+	int                             op, error = 0;
 
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	if (item->ri_total == 0) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	attri_formatp = item->ri_buf[i].i_addr;
+	i++;
+
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (item->ri_total != 3)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (item->ri_total != 2)
+			error = -EFSCORRUPTED;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (item->ri_total != 4)
+			error = -EFSCORRUPTED;
+		break;
+	default:
+		error = -EFSCORRUPTED;
+	}
+
+	if (error) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return error;
+	}
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	if (!xfs_attri_validate(mp, attri_formatp)) {
@@ -742,13 +809,27 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
+	i++;
+
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		return -EFSCORRUPTED;
 	}
 
+	if (attri_formatp->alfi_nname_len) {
+		attr_nname = item->ri_buf[i].i_addr;
+		i++;
+
+		if (!xfs_attr_namecheck(attr_nname,
+				attri_formatp->alfi_nname_len)) {
+			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (attri_formatp->alfi_value_len)
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
 
 	/*
 	 * Memory alloc failure will cause replay to abort.  We attach the
@@ -756,7 +837,8 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
+			attri_formatp->alfi_name_len, attr_nname,
+			attri_formatp->alfi_nname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a7930287..24d4968dd6cc 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,6 +13,7 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	nname;
 	struct xfs_log_iovec	value;
 	refcount_t		refcount;
 
-- 
2.25.1

