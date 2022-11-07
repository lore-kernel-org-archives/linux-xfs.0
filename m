Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9EFC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiKGJDJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiKGJDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2ED1659D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:05 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A790jkE001570
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=o8CWbSEqwj6Umwt7KTTA/bcMkjKpKoHEYzr/HFUvGFg=;
 b=HTEsmndGmNR49XHvZX4wjfXYaj9xtU7if+9bA2BTCPc6/dj4EKIL0rG6/8BkAbSgJ5N7
 sAU/h5QhX5G6x6vlfmJtHMFK44J0A6ChAdVGKs7y7ottfb4Qgwo23yEBtmOV21DK3DHX
 WkmOmXcFGlFaSR8zifuIVUuGo6WVJuHglGJq7ZNm43emceV0odS+SVsdvoQkf0Ft+ASZ
 xHImA/6Y9vYWnBSSOBox40R76BNFCwhjCLnF3jLOtj7DH8+j6GX6RgeUuJcm/4vnYNrl
 1fROa/ySishpWB409mzfbH17mYQZWjxQRnnUjZVgJ/USdFxgdyinE8EjQlKpx1T7s8pn RQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6b7q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77fB75025283
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqek6f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDjgY/XBgbFz1XmgJnl4p38fiSqlkWQd27vkM0RuIHJanE9GPm99Qdpq35h7jciLE7xJq/HoBMgwyaH/RCZiC/PH2DczrCYFIYFBQcHfpehm5GpqrgYCQRck2bbzSM85XZsqxb1Tip9vf2Pz9/YTyn65WrZ4zMshpTOc4q9pk8JAD+HV+9LUCE82WJ2UVJhbSdw3r7V3GY80RB18Y6hK3fwZ3WKnHVwGW0cPCniJTuFwIBueGtEEuCAVx+fbQPQ4UbgmCdnM8C0+5uybrzQjf1d5yoH8mPZFj4HQGIJVoSbDtgTuzkZpZgK/XkHkZz7GDHgQFnFapQ2mtI8u9nwHWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8CWbSEqwj6Umwt7KTTA/bcMkjKpKoHEYzr/HFUvGFg=;
 b=Wkgx8HCUeshmeDAk6A6mNKE3RFXxiRuw3HLYiSUHK0LdZjsv6VROkNfKHRcPr5KKlVaJB9PKbCf6IQs825piAdlaGaBcc67lAHrw9OdHKxfNFYSo9h/TW1m8A05XysNTQirgIFQmJEO6J6PtwHFES9UiJTM8NhrgIOB1uZQEaKjRDQztYui5cvRYnNl9UmDRW/jvcsaYHrxmdLw3iC1rO2wFy3RoWBiOwvTFVAIFDu+F9OhXXiq4GdDMxqh5UkZrQODljfY3LpcFu11sE+4hOh+PfIt+ARYmcDGyCbxGjRWGL9aQJf4/59nfhSnSmfpZ80iXrzzeod/PX93ggh4XEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8CWbSEqwj6Umwt7KTTA/bcMkjKpKoHEYzr/HFUvGFg=;
 b=aMTYFHcU/W0Dz11P5K0M1iypFq5Aj5L+wQ15FzZQAN2Gz4Q2lRxYZEM6icqFmvJsqBkr9xHMZWCrPlXKkT0xAZtV5k0oAERTFjtZZLCmU0QNzTpfSNqTM0+hEUhcBrG1M2V0NP3pjD09vZ84Gc6RpsfI/Z0PnQyW6Avmxp9Li0M=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:01 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 09/26] xfs: get directory offset when replacing a directory name
Date:   Mon,  7 Nov 2022 02:01:39 -0700
Message-Id: <20221107090156.299319-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: ae11d8b3-4d43-4e6d-26fa-08dac09edf74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yXoI62Cf5TgxrLRqI7LBDRrosJWxap/iFB25FxgRlJvLBolhOzBIDTK8pOJNWf5ef2Dnm34vERhQAQ/gx4TWilP4uMorDcWeC8mKIv2xspLGH4nbx6+dldok29JMl4rZG9tSaAwnTrp/DOrZ5K53aLzyc3xn7KrU5+RhTJsR13Lk4SugVDgC+cve0GrUiNNTeXFdcQ+ClN/vy0T2K4CWyxXeoTJpbozdODfNA+Lb6NQjtI7JNUtQFAccUIBZOvZctkxHSFPZO+HeG0w/jAYVxsggQucyuOayQfLLg4I2cHhguJFet1I5iRnzoy5aZxh9H+Y4RrytSO/Lzex2/Ota4YhBZtKmtmerABELimi9KQZ2THLDfgkXw7vbHDMN5Y7QzSHUSDq26OusGTeLE33vWOPjQHJoKSdUIo4XT3vXsoR5r8rgRaUu9JBZnK2zpdgHoITjiL/Wqak28kVnif4orUhsyiG52IwhtPH4+I7GHQpa11Bd1eLZouCDshbngZF83LtNwp50CwmkALTXo53KUrjUjqUvXg1L8K4zQNAB58K9y4WoD6QJxUcAYy301zRWkv84VLPFUp1/06fnXwMyO2aifXqC5amEZ4HY0oiZTIS3svaSay2Xra2sZtoteCvFzL8WbJWtsOBh96TDjvBTyLuyFKx5VGxgutN5mN6QBe0CtAiKUv5SRlTBy85AY/0d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nuXgKVChBl28e9QQJPvyz6YrDSDIRkaceq0YP5dUS8+oEZwnHmaQF082Kkvn?=
 =?us-ascii?Q?VXIk1hZPrX+bdmphlzn/LLsDlvqJaJoHGyCZm5UBooZA7gNIn9PsQcLL8aKu?=
 =?us-ascii?Q?NOVfGQqT51rXiMSwhH5oVwKAfk1oVfaDFcO3izr/BGcq28dLoBPwjKVMGzKm?=
 =?us-ascii?Q?VM8VoEzsj0YK3pbe3M3a2Ui8pyQ7d3mqoIonhAHERHa63KDNyfB1Ao+5XTcd?=
 =?us-ascii?Q?rangBLP05y1lWIewWUoP2qZ2aDghj3IAKHfLE2O/fPuJKqXSq5JXTMda0EhR?=
 =?us-ascii?Q?Vs+EidtwWq9+QaZmEYvwfA1wHmwObcHsvOnp80nVAYr0IbbyhE/4HNSEU33G?=
 =?us-ascii?Q?q1yw3AqXSdl1KRV4vUlK/4jXp7xVNKG969eabVf0BQZcXLgnt3SUySU95Kc3?=
 =?us-ascii?Q?1/eTxhnF4kuiS4HhgkrqTL8gt6qs6zJnSR88bdDfY7ZT7K5XTzYhavmrbcKT?=
 =?us-ascii?Q?0SL69GPp7IMt6jm8eDAfzD4gAee2ev+3fuT4JLFVO7PQeZ1OLxf8TkmNCc/P?=
 =?us-ascii?Q?RkxocQJlNamgZG0ghuXgAiJyMsmmaPyOmSs2/AZnnX6LHKq/FjMpp6yuMb4D?=
 =?us-ascii?Q?hdUuBpqU/4K8EQGGq5wUnrunD/sElO8VVMLmeNYAtT4O8KRBJE4OetiFeERp?=
 =?us-ascii?Q?TEpUp6VJke6LLaIXnkN6q/3F/4fozHgSrXg9b/AM46/9qhthII0SxbSiyI78?=
 =?us-ascii?Q?zeDqG/sJRxN6uBTnUqQhn0cxJrAED01U8217CAeWJJufi064r4BpqfiN+Fud?=
 =?us-ascii?Q?MngqJzGRCpt3g6lvkIDmVy5OPjVdqENhQGrpXasgQcg59MAUq3j2cu1RqPrC?=
 =?us-ascii?Q?M75fMGs2b9My/B7B4XHn164bjqSa+daj1oetD9pqBkDuyIvakAFzuG5I9mPI?=
 =?us-ascii?Q?hLxxGioHIzYSUE9xP/0e8get2LZN8fP1HiS9ZdN71y8qF7yTlEUHfzo/yigE?=
 =?us-ascii?Q?U1lffqA3IMMbTNk0zr1fUzpbTmO+tqv2SmkCNkZglbw3N4TTNLZfjhGVnhMs?=
 =?us-ascii?Q?CRQ2HTtzAMe2LOGSMwQRij/Cr5N7T/MnbVZoxlL2GhE77DJv6Vg0W4GTKV9U?=
 =?us-ascii?Q?8U3131X2KhPrKv9x2jILt+p0thtLDQ6Y97lfAYEmxIwiQAtZA1SzRFATtBrI?=
 =?us-ascii?Q?SYayLLTT/ZVCUMEHobJ6fNWi8T5+8dniRfbioOqtL5oLGU23IVAOG6O+Myx3?=
 =?us-ascii?Q?uTyX9J+krkEPfG9BFqblPEQEaeLBVPSdqcTTRTIhIMWYPMoGeOvbqcsl5k7a?=
 =?us-ascii?Q?weIUgBAxaMeI4hLAsfWbVwVrZAuhgXvxmU5/x9LZsZPCnh8rt160i+oyGU8l?=
 =?us-ascii?Q?aZnLJedq4t7QCqGU2e6AOJ2ZlsY0L+9sphM74o0GrG2AIm5F4a8PdmOkgKHq?=
 =?us-ascii?Q?HAktjkfo5KidjMdgXaec41hBTRHLQRQ4ktLkWDIqwSjs0KRPqFEu+Ob9rvha?=
 =?us-ascii?Q?jd9EXtgqjqWmVHfoJHonIPyVdIgxnSVDne71BUYP5hr6RVZ8pdMHXw2hJc4u?=
 =?us-ascii?Q?ZfoFxT6jEgW2P1lNcLqyRViD0iK0vd3a0QnMFt4aOFAcR70lEMsFKH5mfw1t?=
 =?us-ascii?Q?XCo7OkMYExdfiChqarj55LnXbgnb2uQzdwppRr8dncnNnTlcB29aiu/0q9v7?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae11d8b3-4d43-4e6d-26fa-08dac09edf74
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:01.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dSdekVbzbdsAh/pwbKlnw5qc6V3xyKtXSB0HkWwTs/BJsEpqKgcuEEV5jHjRr8rO+MxSkUGkFbDyHSt6IXI03I409OORFwMVn54FCH1BfSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=979 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-ORIG-GUID: 0XFnwXdrxhcUueZ0VlYQFqIcF5bNGd-s
X-Proofpoint-GUID: 0XFnwXdrxhcUueZ0VlYQFqIcF5bNGd-s
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8e4fa5d6096d..ea7aeab839c2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2487,7 +2487,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				return error;
 		}
@@ -2642,12 +2642,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2661,7 +2661,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2685,7 +2685,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3019,7 +3019,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3053,7 +3053,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3092,7 +3092,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

