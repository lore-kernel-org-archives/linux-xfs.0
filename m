Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A638C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiKGJDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiKGJDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DF51659D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A764BZt018998
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=mHRCUwxjd+KrpG2o7Ku7PbS+w2hzlVYb0cOL/Drjq6w=;
 b=pSayD/Qr0Vvnm7CObmdnSO9VPp2SipE/fuGFrOkFRbAyDKRLPBZhcdHp0cRiZFkb85hp
 css881UGVhwITUmKaS9K10eHYCT3taSSB4PN6sinrCDnPyXR3rYqBw7+KOfQkHarKHi+
 M/iJCb44RbZzGj7ZoE1PMdgb9DAgtOAtm+7jv2xWyEBskQqfk6cEYiY8LOBB2qN9gZ0k
 TV4DzcqeNtMYSpUkecEJQdmGxc51YSgvE9XCvdNAm4LhopMom6AknylJoKfjwKexagmY
 UdrlL8ZuvHnjkvhySLlXW8BwP+8FlQsUO4RKYyoHnLHML6FqDLr6KtJ9lla6HGwc9S2M vA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77atQ7001448
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:10 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jm01-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMLe3sh5ST6UgTKYg3/ACi2395clqijr0PFljth2opTcw5Ci0MtIptNZXgeREzvU+Uww+NOHrx3RJ197dqzslqhIQmQqm03OnQj22sqiqNW0CzrHIsUh6PoSVcz+KnyIN7/GE+C//Wb+pwJT3JyMW7emWnCIav+TlebP3tkqgH09jyUWmS6wXO88vNJRB6hB+LfsvHIhZgJ8eBKwDg5lYZND1JA7mJef2DXxOBcMBHt17iMCzon7DboC7jX8lErIOgreYi/QqvgoNfgmi5YiMWKgZ1rxShnvFzsQZziE1GVCbmPcQfKMbmpA+Bt7ce60/Uu6oodQ1LmlHmGkzkDPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHRCUwxjd+KrpG2o7Ku7PbS+w2hzlVYb0cOL/Drjq6w=;
 b=h8FtJrhP+FdOzMHo2xGFojBfnd1hiekDaZGUe6gVTln72IXIbD1cN+B2qja66mxWjgfNvRA9Z/FKAPmyrQzskLtD/KuZCefkJhVQxO7aJ/WNgq//hb3EVgyL0J0GAhbUPd3gmadZae1ApTjBaj4if/MpBGXo88BmesZfT12C2Yis1UHdo92b/nqU8o04lVfcjxSfrLzV/3Q7Tl0fHnhG7cEuz72ezBL9k6tYcoDIlNjZiupXGRGLXVUaTEsu9qaX2uQuntA9J89yFzFRQJ7MP5ck0xue0ktst0sbHu9lauZluv1t/riPF0zgHWVFk5cgCYos7ALSgfhxSMjpawHwpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHRCUwxjd+KrpG2o7Ku7PbS+w2hzlVYb0cOL/Drjq6w=;
 b=YeFDNyXVr3qQdByciImh3s8laPuem4MrMh/lv2UmOy56wo4m1GSBTgeommWcbAYkzXeAwMO64ASGMIG5F7flCs53QJzXe0ByFwdGv/7pvBAH2/fUKKpO/Usf/Zjeg06V4OIcFWx5+4dDNZXUL6rJqlLr5TjiEuVgi8WG07BBaBo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 15/26] xfs: add parent attributes to link
Date:   Mon,  7 Nov 2022 02:01:45 -0700
Message-Id: <20221107090156.299319-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0110.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: bec2ce8b-8c42-4e1c-16cc-08dac09ee3ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+LQsyBOnauZGQHc8JPqbx/8QWkRQYtRuu+uo2p4UgBOzqR36uMlnFUk7kJv53zQT+EV+JupiDhJ29CUVbQOONly2ss0HjCCJNRj0WoW2mzaFJlv6hCmDwnCBwiE4BSozjDBrv5wCA9/fOMqg+Q887cdCuaJhGSc4RgnDmENi3jv6YECL0LQp6zkZnwjxcwOFHNHJ7gNCPajbGt+xXHBKoMx53af3IV7ZyacXZFsYrq3NocASvF7QPegxwRHppJxN02HDQlDYU5GCiXrRqqV89J2QTZ8a0myNhXOYYFf3rUxTuH+wTpJBx3gjGhErnN1cAEQc1f8Hz6A2LSnF+oUIcNVajw3yE8dywFSTnjlHoP0Ygz9lZEXisMc7tUqr0zN4dnMcLEeoH1gT/NlUbIUtTzJ+Ech6oRhQqoA+FMaJ2U2BplEiGhuyGs7gyqbyqLr9XJO1BPQEKJTxX5tJ4n0+5gIbGDqBLSO6dtZaKOD2u/SXazKni3PvuVO+qCK7BmbI92W0/oxeNBVnHKNXGyKWfOa2Kw6ZyHaCNccpUQ6nk1Uu09LYZOLgtSrL2puRwtQWuNQLhIcpYxiKZSZT2f+PN+Uru4iL5FCAsbRfOV8DjsMhfQ7cVPp2bodQ+L6QDj+9N8xJLkqByHWYBPg4HcttBKvlRUCx2m3kaIo/P52JlE5EdNZFvZW82mfGf8de4pE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?et+j/ouXn5PwHLcI+msAAgsCQjPfHkZcizWQGZbY0vb2Gvls8iB1lZpwn2R7?=
 =?us-ascii?Q?Xa13dPXhpH1XI0lJrkDnjnZT0mGMLDnWHT/TEM8aOSkXXPSbvlXEehH3OpOT?=
 =?us-ascii?Q?iF05bAxYPCizqGVS29MHkN8q6LfbJkciiSADgEm/t1Y5Odc8mHAiN+/1gxlt?=
 =?us-ascii?Q?Pzo/KdtCigqyijxWmRpNFt/JgQEOBCX0ki8LJ5/PSiwLQ5dcgqMEgosT1vrh?=
 =?us-ascii?Q?3pbQh/9FgoLcGiuavW/+lQq127eRgn+ROZG2DUZJYrQDeGOsDhebHpJXxRAI?=
 =?us-ascii?Q?6r03suzMFU/tU/taUrJzfGE43U5bjKDEJ5AwFlbZm1d1PQp/zVFvuVtflBte?=
 =?us-ascii?Q?5WRqoGhUrx3n1v8Gz2jKe5AV91m6uj654kY72IjcLDbC1u5YYCP6HFepljgr?=
 =?us-ascii?Q?KwpziBCusPaJ+e1Z4pPR7m/aAO9sYLkwlPzC4mO7UBPwC0fNddAQNOJRaL0z?=
 =?us-ascii?Q?Kzag7SzOi5CmxwN13LpDZ7v3cyR5mDrKWnWsF96EYcskwNEwmm+yJ3aAmsck?=
 =?us-ascii?Q?s18R3PLehZZbeWQlDPo9Wnb2DVCjX1lewRHUUlBrNEl9l15dMpuaLVN3a/Zv?=
 =?us-ascii?Q?hCxfvTzG1vs4FH2AZGf6SnWfiFyd7r4lbA3okv9h4w1A6snlfBfzCFWtpIwR?=
 =?us-ascii?Q?ymFiVJzS4Lk3uSvEofq7yMIEuURgAnHGUMZqRNCBiKnPRvMMGd49ieXj8OCz?=
 =?us-ascii?Q?VnpgmWAEn3zkHlp/kRRtd+y+kHI0qRrAI0OmivsrcLVHhUF2L+yakRaAt7wK?=
 =?us-ascii?Q?5HfYEG/qWJrWaOBRQ4jaS7uyTmirtP8PLfTOq4Dyvm9EMdTPmXnWdcaN3e5u?=
 =?us-ascii?Q?OOYxl1T6AAvJf2/KiTnCCckcioX6SpIqIaEBJJD41+GeNhB79MX5ciQU+jUJ?=
 =?us-ascii?Q?f+VRYhApaFlUr054vNoT99caxgJR+ajRYIuXNPJbk1vLqFQjSm4ok1kAGzV4?=
 =?us-ascii?Q?mfe/PrJ5xtskyicjiZqEIkIGz6gqnpHMnGlriq69NgdNIprkVTd2RjAzY2OD?=
 =?us-ascii?Q?GcqQHfapOHVJXROJ9wRdcddzixARtlzN6MdY/bV286O7CCt47UwPotglKWjh?=
 =?us-ascii?Q?p1ipCO7AB7GAYKj8buLbt21ShCegw25e8WyCDTx3uh6hNua1r3EOEt79/9G9?=
 =?us-ascii?Q?5z7cT5bL0TyMJRCfp8LU50aFOFpJIvVyadsxCys7gsvNEvMthWEbl9E1csoZ?=
 =?us-ascii?Q?hYHaoNewPKBD04Kq9DNqZdC9xtVADAZIVoer9JJrWq4U2bKQS//DnYwfXRH/?=
 =?us-ascii?Q?8yNZ1s4EvlYlxQp4bOfEBLlSJ6uYfJXvPLbUlhpapZBACmDnUtgjmy/4Jxvb?=
 =?us-ascii?Q?zAS6Rvkxqc1F5WzMRWuyMVEvy/zF9/kPOmrF+g8aq9vx2Cg/ZYwHJm/NNb+Z?=
 =?us-ascii?Q?4G4AZBSDOVRgkBN+KvzNh7sxGfjV1sxWjkWDDhf/E9PdZKx989Kcd3wwFTyM?=
 =?us-ascii?Q?xgO08iEIOSN2cmm/o2qd5In6OYvj9gsYrtXdyTYUgROmwXxybwMmlq9WdMm4?=
 =?us-ascii?Q?OHXd7wSx/7AmvVEouRRsbFYDodhk726tjujUSpLKTKBdME6aUgK1hlYpXheZ?=
 =?us-ascii?Q?S8agqHtgbNU3bwlb7CaWzy9lw21eW2QB45v0FcNJV55+v5r2RvuMmN6F1Y/x?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec2ce8b-8c42-4e1c-16cc-08dac09ee3ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:08.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcVf0xU5w+ljblMcrvUfRjYWb3CQ7po6USyoCcBuNaydOmzIUEknJ7znl1r7X1EdNzROFqquxI+vNHFFIpmqHFVC6/s9DzjeF/ZfPTvXNEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: 9ECprsP-hAQn-PivYiFYx03clxlp98ZP
X-Proofpoint-ORIG-GUID: 9ECprsP-hAQn-PivYiFYx03clxlp98ZP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.h |  2 --
 fs/xfs/xfs_inode.c              | 52 ++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 87b31c69a773..f72207923ec2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae6604f51ce8..c780ab3a04d2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1248,16 +1248,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1274,11 +1290,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1311,7 +1333,7 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
 		goto error_return;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
@@ -1319,6 +1341,19 @@ xfs_link(
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto error_return;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1336,6 +1371,9 @@ xfs_link(
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+ drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
-- 
2.25.1

