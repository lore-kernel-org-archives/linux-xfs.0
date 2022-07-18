Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7810CCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiGRUUl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiGRUUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716E2CDC8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHgTpw008482
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=WDeUKl9qAsbrvkPUIg0j9Uu0AVZ9B78HKBO3pTPuib/q9EPyuEbXlJyrY2WECdKx+wsx
 fKJTFXs8X3amp1gYZh9nCM/2Ssh65davokphZheaRWk4jvLVzqPqg/6fL5lb0JQtwImA
 GkgrMy0N/QaIXp73VKNfP1YcyTyfilRxjt1jlQSQTx8Dp4LoSDF7HOM7+8l/ceWQN7v6
 fQvHazxl0+xod6uhub9by38oDx30ChkTgan0ByX61hCEtGJGdYigcRGuW1GeGwxp7PmV
 ibiWtEgESLSJwfYAAyHyhQHpKiJdVjE10rl86q5VsANfgMB0bFbxfMFldln45cSFyh78 qg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4cv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t8001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In6p2xOMqpOkGdzcJXrYk+XESKPPBRnHn69iiF4xYAEa8ngilgD8++5uImckFfoZEW53x68k/Q9+jBGoT+LEryj/cCpsEhRsL7vvhlox+Xe9Pnk0G1ZBj5aLASrmIzEzxWIvNh2whO1CGyTkRBhlUSQJ8RVk9sO9oEs9UDHnYypr+ugUf3G676l3HT74o11S8oV69r5FWq59GM3zT+jqZDq5hMbYYVN6Fm8SewjpGMZ7brxfbvAqvXtMRuVxuyDM9zrw3GGBT/Gvcz5f+O5OUffCIHZeGt4jQxSGTXYJyv8S96YGNyEJ+GcBwJe2UgQWKS5yDiD53pPOve69rXDw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=UozqVM2ZdNlasF9dOiHvzwBXp2khZlCMx8/ZzxEj1+mnHSPsqHDC+bHAKg0L9Moi8sHMgYZWcT8cMKW6tcSFRr0x6NxOmrPRrOY5GC0VBW9Bs40bTi76o7EhhDP9Jr+W5xthhdzsL4+kD2hJO94oCSTmZzBLYgqB4kU3DmxIV5MCeFdfhT/q0l9345MigMu3DC+tvUE8+UYpdRHfVICs4x6i1X6f34GpEEolVM1nxXF3hk7GS8D0f175NWeh9K4JA3iZoKsjPJk5R0Q4nPbpoD8RW0Uqs4ghjtMpwR4Rj371NFMvI9VYp5WcBCFu74kHVCTB3c85D/rm2at5ab7jYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5aHvGd5hQuc9cRs1aPWAQAXl6QR4yycUZQor0R62N4=;
 b=DIKyUHhdFYbnHhQRiTnO1E/jzMBD7zOIEIVVVOCfzItteqDtNGtNFR16D5aMUt4ZbyDm7JvBR11PK1LftjDm2nnPCWPBP6ZnM+XQ3XJ8ynqth/4i9rIjdjfCEhHumEbVRbI60sAlVWlpE/g+lKl9X68Ez2LO4UaxDrXYrMZNwU4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:31 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/18] xfs: get directory offset when adding directory name
Date:   Mon, 18 Jul 2022 13:20:09 -0700
Message-Id: <20220718202022.6598-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718202022.6598-1-allison.henderson@oracle.com>
References: <20220718202022.6598-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53002c78-c929-42be-2cb5-08da68faf5e1
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qIV4tSp/0toflgrG3fGNcZ3Ew/Oq+VoclnQr+8j30UpI6Jg34KrUZnTJg3zz+/Ll2hPYt8rxbD6+TkeVElh/wd6FgkPKooMhCFVOwMLN8+lxjWYj65e/8KnZVOs6THGXUUIYwdTNpipGEWxzbkedScK7kbW9Q2KvD15T3MxrVvmtB7+D9/L/lVMOVyGzZYemlcfGaFjaMtDLqGNwWNWU7TVwLBj7QIkTxjs6Z6I7yARyYK0/yW5RMudaTBdO62gVYiOz7lZMZJL/akaQcW0Q//ewHshe05i0PT8TMGB4nKmVDK4anYoGd9qTFOPpnJaVYgX+eRZrLXMirsO0MCrxStzgEidJHzmYMRLy9cf+YlWgbQEhUTmMemiRNh9nEpb7/qaHxSkc9R/eDs+gCggqeQwYQh8sO0fgLFfF6AxSOLw3Ol5hKo4EityKpwphncNCMRK55mPgGUbIsq48/KVHKy2y42KzJanDTJJY+m5ba4KJvpnpZr+KUyIwvzY2X3Xd3OeWlii/MBWY0bZlwZEc2kyXDQoVpkPi5Ul7QAGxjzRFZraZ5yzm297wtg0tOBXSGrTO69qEqEr7cocvxFNCdYqEqEVMg1LYKmq/FaiVDg3OVB+KRNx0w3seo04vY0/VvsJ8XKmT8yvzlRMbCrvsH+tVshMz+1P8BdZjT8DhpyigoXj23uWZ+AeFGR2WxvG8E5O5YGpYaViKujefxznKtqp5LiSh15eLyqDtdw19u+wdGw6z80zR6Okgf1ygiGcSfywMT6r01Ww9bjD731Afzmxtgklk30jg8t6SYEW5/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?24aZw3NNoAFFSlH+cI8z+jdaeb9cSNOoLURH3Z6+gxHrd3v1yoMOrO1qZlPd?=
 =?us-ascii?Q?Z6lVjGVy3LqozeJA677t6ZAWr/eOurN8AEr/QUnvJV2bR3P8/wWojvURP+aw?=
 =?us-ascii?Q?nOwqBxsaM97b9C/y7yrBfCzvCufBRbLL7uumz8OdD4LT4z0JRItXYcPD2kOn?=
 =?us-ascii?Q?/OpRC0d9hTupxfSec595uiBElHCvK7ALli9nv6ENDprpiD43euiXCyN9fj3x?=
 =?us-ascii?Q?laBdBBgE5x200pGW/Ns9/5XqvFzR8KNve81JGJxL7BU2g4HNm7Zgsw3x6Cq1?=
 =?us-ascii?Q?nGOoraTNxIiUo52a+wP/teM9qFvxZrkKEK0kazFPm9j6jTIxECU3z4MIgCiQ?=
 =?us-ascii?Q?49ew1Fg3GreFvBR6BskOxftg+LZui32YM8wUPJlA4AwXSVsiz/fi0FrL9mmW?=
 =?us-ascii?Q?qPva4cEttLCE/MpbvhT69pcbDv/Wiu0nkJlhVLFxRTJxEvZQP4TUoruLlGAc?=
 =?us-ascii?Q?zwL6SkFF9aYprhvI1PnEBFwIISrqntdSsgrvMOWEOGRZ/ESQiloaDWbUX6kN?=
 =?us-ascii?Q?7LS3Rop4ZyCmBVwNa3tHH32mKrM6rSZ/UI969yEl/Ve9xugSFcghQI+6y8jE?=
 =?us-ascii?Q?Vd9aWBNPBALXy1XZol4GC9kp5Y20CmBiF1Kxlq8utCFf2vTYbEbgMncQ6UCU?=
 =?us-ascii?Q?UBx0DDRaemaRPidqQMLeSxaLuX6hPWhR07AvNcgZv/VvseuVkTWsur11CP+B?=
 =?us-ascii?Q?jxwdeiN03indFeFeN9Ugp/UG95z1LSk5LjzTSoSiYoJEFlgTSMnoNcxCPXn2?=
 =?us-ascii?Q?YYO07xCcr27+Ec/do5k2/RwnZ+Z8+8fiVmm93tynheEkDDevH+5tXsfXkxIy?=
 =?us-ascii?Q?COWmoYdDMuXERywTaRqw/fo7Hg+hTtNxf9FX+r2fxocildD68NxZaSDeV2AQ?=
 =?us-ascii?Q?k6gzB2oFmsq21Po3CuBqNs013pKEyCn4m1EHTf7kBsvP87juoZmk9ZtJR+my?=
 =?us-ascii?Q?FpcR6RTk9iD39By9qsOjKWDL6JTftc5EP23k9CaVjRVQYDXLr6PkXDvxpK1q?=
 =?us-ascii?Q?cKm90zM9XkufqGoy+1EFTW/PndwpdFsanvtDbHp0PRrn6GTN05hLKuWgueMx?=
 =?us-ascii?Q?Hb22pAKdfruvV7S/BfivBiXUY6CXgurgY86dc5kJNrCxr+Nc9pNklE7+Zw5e?=
 =?us-ascii?Q?seVA6TP9gR8aTQx55NT5qcJA1C2I153ikuayBxnsSjWMgzY1eNy85OwWzq4p?=
 =?us-ascii?Q?AmkxvWFO+M6eAWN9PnDXKzb3b/fxZNnK00CxW2mzXHXmNabXsA9nPKlwL8NG?=
 =?us-ascii?Q?NbDT6OMBN/WU9aGRCEPhjQLTNHKTc/J4+n3BPXOfAc/mV5RMhliMsA7LigIG?=
 =?us-ascii?Q?gT2Nie/vmKel9v5T81dguX618vokNaHzNZywX9oqk9RbZ2CFUcaaxkJjo6y3?=
 =?us-ascii?Q?Ztm8d0w+DC7UDyeemMk4nrd+k6ilXJXCzOgHEiQmJmlCWNt9gnvJwclWXOMZ?=
 =?us-ascii?Q?C5GbTGSOC7WWxu2UQuGcz2OyUUphy6/UC3Hbd5x2MjIPaElW+suOQzmrJEUG?=
 =?us-ascii?Q?gcMxS/2rX9kQvW/GSoCmCn7EWMWiL2mQD4RBzo85k79tCoz0kbXRa6w5YCwZ?=
 =?us-ascii?Q?BOP0paUQjdyDOYbrMvGg7jz0P0kQUgB2epxEzXp03MvKaoqIEL8J/gLRnVMo?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53002c78-c929-42be-2cb5-08da68faf5e1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:30.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zoI+R7sk0fsmuLRd1LQqn5eZi2hPWqvHnY4g0LrSfyz+nIfoFt1vrhK2f2YYNFD2N8v57lOvDIAR2UUSRcGn7tWk0nbM8l2QrpHJ2RZsyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-GUID: X2gIIWZE2ddMkCo2p-OtROvJe3M4I1gK
X-Proofpoint-ORIG-GUID: X2gIIWZE2ddMkCo2p-OtROvJe3M4I1gK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

[dchinner: forward ported and cleaned up]
[dchinner: no s-o-b from Mark]
[bfoster: rebased, use args->geo in dir code]
[achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.h   | 1 +
 fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
 fs/xfs/libxfs/xfs_dir2.h       | 2 +-
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_symlink.c           | 3 ++-
 9 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..3692de4e6716 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 76eedc2756b3..c0629c2cdecc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -257,7 +257,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -312,6 +313,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -550,7 +555,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index b6df3c34b26a..4d1c2570b833 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..70aeab9d2a12 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -573,6 +573,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d9b66306a9a7..bd0c2f963545 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -865,6 +865,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..5a9513c036b8 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 003812fd7d35..541235b37d69 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2703473b13b1..08550f579551 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1039,7 +1039,7 @@ xfs_create(
 	unlock_dp_on_error = false;
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-					resblks - XFS_IALLOC_SPACE_RES(mp));
+				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1262,7 +1262,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+				   resblks, NULL);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -2983,7 +2983,7 @@ xfs_rename(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d8e120913036..27a7d7c57015 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -314,7 +314,8 @@ xfs_symlink(
 	/*
 	 * Create the directory entry for the symlink.
 	 */
-	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, link_name,
+			ip->i_ino, resblks, NULL);
 	if (error)
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-- 
2.25.1

