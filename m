Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABDDC43217
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiKGJDH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiKGJDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC531658C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:03 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77gxeU017796
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=O8ju6B4JkTyF7KNclxpPdxAFjfrgSIkDa8KRlW2zvZg=;
 b=BVkb3QbfkXOIYyJay7QZMMy4Lk5K7rsJOGa2L518Q3PsBOUfHP2v4qaOg1bQoT/BbcAd
 vot03F3DoBuEOf9fMduysjdivro7WtnvldpY26efh1vau8i+qV9Q31X6YRiIKMnWdK5D
 C8gm71RtviEOTWz6t8scfBfHSZp+2LHFNtFyo23Is6+06hC4nGWn2nV1lLzLcjnq9jSc
 rlTLKhI30ssmm1MjHnEnPhwuEySxl8dGxhXbfq0e+rQ3xbZN8OeTa4OpTadfuxGXq86K
 ym+Q6E58+HIB8Pq5MJhHsbuEtqfvRbVhyk8310gkYv95oI1MdjFxT4N3ZBKzUSvOTo8y ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngnuu33p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A76oQJd001605
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:01 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jkw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLS9u0AskEpF04jH7iT5WhqJYoFMRVrU1RBtoqOHZIGJUOM9sxSlJs97ReGm11PqQBXCPcEouQxvmAdL8VyyERxGMDn1mzXC5YOwuekghkCZkIKib0/uvd/sMEqxuujssAwoZ1k8SDJDUXWvygumRH9kbsJaubsbjpYa3r/mUPUsmK/9FXCbRSYl7u8ijE1NIUXDiLORybg7LHkLH9nHFrxeEI6MJHR59QlPqu8UVllY9+JRTGNKTAP38EEFJwmrkbN/gfGa717+1nXbIeeHNe3GCb/z+ZdtIijL6CKgnp/E7XOnbmb3cYsBQ9UzVnz7DJs4UWD4VyRk9GamG7SpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8ju6B4JkTyF7KNclxpPdxAFjfrgSIkDa8KRlW2zvZg=;
 b=Yp+j4ifJAVzo7VjS6lmj+ix9lIeQuX4QBJxstNMkA5vdIX1y/QEUST3PcB70012Qklk7ugnc8NXBIGPM3d3AvumrpJ2faczf4OcNJvMfzbAP0NKgaHCLt3RRNnDlcWtwVHv3Cw8CmF+BLME4FnmizOI9l29AcIFurT7RqGyrHtKRdVBNGxu0BY+XszUys625z7lHV0/QHIRsi7elK90C1NOCZ3KrRfZCPCN5IeZ+DKGYqH4tPppfBCh5KnLRhY/buKDr+hhnxcGP9bKwtc/+0qL2st4Eb/IG5xKIWKLtmwo+tzDTrXUeSteDBLfdDG8pfbR8yU3y7861lHlKl/3ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8ju6B4JkTyF7KNclxpPdxAFjfrgSIkDa8KRlW2zvZg=;
 b=EJ1clDaN4Z3MC96aLd0ojaJKyI46mAyvUfg8bhyXwvo5qs0pPBiHKImaF9L64CoLJdCsRuYCEkMpXEv2rDUE9G2MKZs3fkGdD7ajHqiGcQeSsYE+V/WPTJRMHTiRx9cqHEDJSW74ClTjF96xfT0zKcfMkndOVIHnrmz/j2ciADE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:59 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 08/26] xfs: get directory offset when removing directory name
Date:   Mon,  7 Nov 2022 02:01:38 -0700
Message-Id: <20221107090156.299319-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: c294f7c2-77fd-4ce7-24ff-08dac09ede8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /c8TI4+2ObLozkmmiwva5emY4lOrzSMubC4x7z6WvGdOkDILvV4VAssPUZS3DP9aWKHl/o/96aLXXRh6RJRgncSI5prD3yanfw0LSPJvybb2wFTdIkEWgJ44o6s2NM/wklRb+/gOzq7ixsxGUKsCqBL7q49etcZO+R2U6wo566sEzd3/ZUbV0lsef5BB//iF31X8barmQKh8e1kud9vSyiWuiS74DASVraQx1D8bp2lOES93hPCZdkN9MubBgiKHZh8V4TkkCu1LO3/kWChB6lWuJfIUAG/HSpsltwjlIYFd3mQK0nvba9TFMVIRPEb3nTCFTieTkUfR3avsksXq0d52NORgUs7eu5x82yH0d6YMZJm82z+jR8HH507j+3usfB1g0uKf3P7BmtkBsVTtSR/DQgYfS2j21kDhvOOi+PSzWjdz/4sfsRS+zdr9v6OnOuV/Kb357Zfp4/MjuCR2vooPOJzX88x1Tt9LDJ+Td53SWajnx36J9Gs/p2BA+V56BMb4WmI+XhmnNFbZ/jVOnCPxUfAKW237nXkVhFz+Jsyk75hmcJRD6DPlgGVVqzPzK2RFIBUs1haIdkAQJ6yrjr6YCS4CxT/upxJA8Mnd4spMY0r2/yAbspALliL7DlwNHEXXldGl+jZXJAvY7D0kDN7TT+TKi9qRkvSk+Hj8lpxNbu8fIFwigk7PFGzQ0/5xt14LJLVuK/CSAWNsshAynw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aweUV7hi5isJLX0OlJnmdcwQQGsolpH9BijmqOwwiietUl5QFh7+b402zsgQ?=
 =?us-ascii?Q?Xq6cisP59wmsXzHEzWkvC/3MkjpZRsyFHmoXlq9wBHvs4Wc4tC0iOrSemUq9?=
 =?us-ascii?Q?IbP1b8kjhqkFefD04x6BaOSOnAnV46+vlmxDKkS2nyqjcr6nju28XOa0jb+H?=
 =?us-ascii?Q?l3BrUIXljPI9cgIoWU1Dyi+yzkj9r2OF0OG8HbxvUSnaslYHr/QFpRUoGP38?=
 =?us-ascii?Q?YesKYy/SdbXQh/mC0og0qkFCOITWlToWgbEovthxtQdb2d/YPjTzu1Q/cmJo?=
 =?us-ascii?Q?8t5L4+VeBj9bEjGKHBKm0CPLiKjG/w/EG8SKA0Qtsg0ADdDTqbSj1lfPk7tP?=
 =?us-ascii?Q?XlY8FwMsQ+n70SnDKPm4Ib02sEtcvVzMJEEA1WNwEyzwSNWbG93xJJynCEgM?=
 =?us-ascii?Q?BPYs0/5MvDfgVzPNJXGpOg5CkRmumo2wFIoTOe9ignUnTbdrBtqrgytt19xZ?=
 =?us-ascii?Q?TnunP5qt4hIVfOUusMHa2QDQt9v9YJaHwz6su++bKFVc6MpKzqlY4A1g92z9?=
 =?us-ascii?Q?hIfavd1tYdf57tP6Noyo94R/OjcPMXshFDf4C5Tdq7Ey+wGiv/uqNoYYLbCM?=
 =?us-ascii?Q?ZJb35Uc8y6fDrojXPy7bA6jNr3usRgcnWDiIJ8+7fGJhYPg+R9ySMilUNN0n?=
 =?us-ascii?Q?gTdBLa+32C9JLz8hOqUW5gl3IDhwiHo6Q9vdwWtQOujJFHARLzjwbM4Kn11+?=
 =?us-ascii?Q?EB2uK98szJ85DVha1sOuvW6b4jtZKbHj/xCrZlGt0TbPbZnlOK1XaPXZATkW?=
 =?us-ascii?Q?xse3AFjfB82SwBmnjU1uZ+60ImPYry1XuHO3dcGMZX6SQEQfNUJ88hSk94/w?=
 =?us-ascii?Q?NIHy/FM7uDo88Oamo5k02eo+44CNy6cDubF/KVpsjfc4ltVwwUEBtnGyHwch?=
 =?us-ascii?Q?QljVHve9BGFsHj/iApUiFrjO3/YpnOIvSS10EkdiL1CFcErMbTWpwQHfF6Rb?=
 =?us-ascii?Q?dGpRvw2NFZG3zfiJOBgsiGT1Rrj6xKeYHefpiQCoc+6AYMwaSKCurxO6COql?=
 =?us-ascii?Q?Y3Q9ypQKSEzAL1/erNJp7dEqN1rdlUK05+zx3+cULZd6PGcATSup5FyG9rGx?=
 =?us-ascii?Q?J8uVDmk2MhtuVzZljSSy0gnnNUp6uNAxi5h2BPTQqqpZo3WPzYH8UDW8ic6O?=
 =?us-ascii?Q?3aO5R4s4HquFdXiZq/Xh8x5auY6e83xYi1WfPF+pxJl1iYrveeynEVDE+AdI?=
 =?us-ascii?Q?9br5WFqg8GKMPYGTvS8SFoPAzuZhBj3u6hCwn/OIAZ13h/gSTTS8ihVqBqxW?=
 =?us-ascii?Q?ogCrRUfyFlvNjGFO+m2W5OIuR0LKiKbHQhbnm8UkfOlXDuL38Bg0Dq0mXBt8?=
 =?us-ascii?Q?NZinP0kPbG+fecsMUDnTzZzVw/PX72vHYT4LrhPpTcQnC7ECX0Mc0cTvOAXc?=
 =?us-ascii?Q?OAEZ83E4aMT6VphZ2Xw1Lkvw8yCGTcedQR58OeFdBOs//3V/t7u77CF4Dhmj?=
 =?us-ascii?Q?EAUwPWTig9RXQ3M6FgNSs2su7J/67+ctwKQXAetSL1FfpeZsdh3OO/7nLsWu?=
 =?us-ascii?Q?eh81NL0Txv9soiXhZa9qqNo763QHvWlMZsaLq3KLQygrut9mFS7Dkq1OTBib?=
 =?us-ascii?Q?mv5t0xQPSWVaqMoCTsRb9LKfTv2v/hXLn/1ORHni+qcp3dlfGjdrwEzOt1cp?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c294f7c2-77fd-4ce7-24ff-08dac09ede8f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:59.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oYyxnPWFAqZvHH/NsvtvrtltCM4/tB5/JKzYtjFRBRntf56dQrnr2ZL0qV1Ey5U7+u80mGKLh1RPNHAQj5sZUwa89l09XFzYIGXEKTAQsE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: esOUjgvI8ZJhuln9n_maOgD-0ve236n3
X-Proofpoint-ORIG-GUID: esOUjgvI8ZJhuln9n_maOgD-0ve236n3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7f8c99695140..8e4fa5d6096d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2506,7 +2506,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3095,7 +3095,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

