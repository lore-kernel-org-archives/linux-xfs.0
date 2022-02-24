Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC7AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiBXNEp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbiBXNEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B942A37B591
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYKAl000960;
        Thu, 24 Feb 2022 13:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=ZdUh8PqyWZQlW6jw0ljCbRH0KrMx73UgoSJSmlml0rLejVh3MpCGrwj/Lap93oNeraDJ
 LzSre2a24c+X9Tos6Y1rXWItYNRkQxzpGB/qHHsDyvV6wFMKUyjJkSDvbNkd5B2rRrhf
 lhvuijoFOcqm/v81UynZkVQol1lb7E/4aRu0XUKdFebFUbP4D7qBrz2lrw3fgxLy0Qy7
 bbNKN7S9yBXtKnznFHwpnDG7smo612TvkphuzA75bWtvAlemgteBcP6mngRilbBk+M/P
 bJSttIkYDi8+V13TMgYjznq4SrBD0tQbwp4iugmy7E1koevEdzjFIFxGNWc3HftpCf7C 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqab6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1h3l039659;
        Thu, 24 Feb 2022 13:04:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3eannxdev8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIRXpvi1QuqrGqX/8/KuDNEK7HwOswQfEgbAJCGQsPGslDetoLz0W+SVz5wxt/3MxXO9+KJE/PFc8QwSu3zljeB/Mi1lyUg9AhssRYMDGyNdX6r2PNpTcU9bSCBrnq69z4F5OQZOZd4zqLEqiWjXsviBYAm5Q+ohtGnDwGSHAGsenus0KGx3kY1yWQd+MvV5S/9aRPqZwM6KD65ENMLGM2uHrJpgbLWrVwmfTj5KeU1WepYj++epjKIeGj17lsHxsae6HN5LX8bRhDoiNN/HlOotG/ZePWX2xVnh6i3ko2vZ3M+BhWH+nIN3ZKBZqQ3E98bzMYjDlnjHDZ0yeFZPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=LNgIVqf2Dk5nKOJC0ZDFHJAZAyaL4DrC3LEWG7FHCsQQdlNdZh+Zjw5u/rBdQDuEX32nnQMrRUNpOLMlcLyBmRED38dIKhw1aUezV7oWB0pIXrWn+6hFyKVPknaGkz5N5aVxspSACjZtOtIhP+q9PXWVCzZ3GTGCuIYiwr/Sk3kJ4LRDjXrDcdjx6wKQI2G6QGbhEGYP5uszLtoHEGSGuL7NL1vohKstOqrj8KBL/0d+IXfPUyhVZBKNaN5ib7P/93Q5rdZy58k6UOKdlg2P99eIWkI2Nzma2qoTbfHOQ3MLwAsJArEkA7JkSRglTvgXEyIfL7aakSIvbGaVu7POjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQdrDts9NMaxLdvDSYtURgqoR4Ox9mvNpJPCLdOvNuM=;
 b=ZwXaEH1mx4z4DAL8vV1zoJtIXv1r3fHNzsnuPfk5auKyCSyeCNpwDb72qtiYPRWA15Sz6qG9b6SXF91TIxLXIObk3MK+2GnJBlnNfv2sdr5lvirj3EOp+KUE8wyFcvAQ2tfPiWJpLAhUKzNgi57zLO0WLpPUaEHiPOXT+K0X2gc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:06 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 04/19] xfsprogs: Use xfs_extnum_t instead of basic data types
Date:   Thu, 24 Feb 2022 18:33:25 +0530
Message-Id: <20220224130340.1349556-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4645a4-cee2-4c0f-c0ae-08d9f7962341
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46343BBF515ECD7FBE496B3BF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Thc4robw9zJd3zltq2LrQ+YmuOl9UxC25perSQVoE2+N/q28t7ti6CMxCDJiUr+5LsOLqpV1DyFbp7XgNaJQ401kWu7lyEqA5lOREhFSzPDNuh/DXOFcW6SZqkRPwJNcR6YmbkX+HLVjE7Brwt3OghhGKpDA0faC3QAF7ZtHG9ptkWS3sytA8jVr8dGR73dnqdk6kOLRjxqxICaRcFbHY0QO7wDq0YIcGWI+y1x6LQ0k5YIohL2qJcuj1jLDSPjKjcFFvSGH6g3lwsoO9dhstkO1SwHrUujbiacjvfuxZidk7Y4phrj2sW50Q0O7PKDzFc7WqRhY8fDIN5RFHId5NfNOU8mtMi6llVpTYB9hvAdoQqmXRcSnxBWXbYdC77QscdIN2lA3phByxLMArYNTJJSN2vpY3dAL9WAMzXnaKTmlRA2GnjLWD/P/QVn1cZ1CIuZyN9tqJg0v+Cu33eiRWhgmcINxdj08puSl6Mtsj8XRBXIuFPjZXqUDfZLVs28xtEu2mKzYY86ljRs5k/Kr8xmDyXY3WDga8MC2O0ekfkNKvSj4Z0pO2uHr+lqcbwI5oCodPcz/X/jWb84jqipmTNSnWERuS4JDWs3s8pqwtZWJLrYdaH0xpcLQ7LbtaOlipqLgEuH6LgIG3NqDnknQBgZNQU1jaeTDafcozDQsp1PvS4eewUWAMw9Aa3OWKOeWIJqES8ImzqPZl+oAxSx3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BPDvzcecDoH3rZmqPnZvSuuhZu1zI9uKm+h9cwwAay0+bFAxcONdt9EVaewg?=
 =?us-ascii?Q?g45Oh+WYq/cNM0D2WZ2YwLd6gxkjakC9I9f4K/wp8I+qTSk6sjnGMPsboETc?=
 =?us-ascii?Q?ELG7Qhg64uQ2KDiXhN+19uI6gV5/cZisz6fbIekTVrCpA/Xc+wNRZakR9EYQ?=
 =?us-ascii?Q?w3EPeU3T5fXdjlhEi7hSEnZgIxvWAPvX/lqc6gYMt4GcYMUH8Nv9iJXysnba?=
 =?us-ascii?Q?KL0rHiyEpt2eRORo+/OZHlrDn/wTHOWy26GLpAXEz8Fy0q26vLVm3obFK7wK?=
 =?us-ascii?Q?ofw/IQJATQFYBh7Z1FOkDBVeIOYKG3WHpwC7BAwRTG3w+wL4o2ToURERFlKE?=
 =?us-ascii?Q?kGwYcm4gh0FXJSJSayj1SyvA428cJZnDNzSw2Mi/d5HTq/Y4a/cHMYy/ohTT?=
 =?us-ascii?Q?R4cVqj72sHSamGHqwNSmqgYQCg6azD18O8Oj0Zu04XQrk2BGAt/hFo7Tb0SX?=
 =?us-ascii?Q?Pxj1fguVEIMPBgO2IsXHAlyrdv9y/XWDfJ/nOi4LOyo6vl57p5ZFHjTd4bm0?=
 =?us-ascii?Q?7NDRtnfB3du1ThQ3kKILzDNKv+9YQ3PUPcm50HroEnBgJZ5CRAfz7rzUcCsF?=
 =?us-ascii?Q?qbjtOfIxPjC6Dx2X2ANVkk3sRbe8HJ4nSf/fnLBCOT9mLXmnmDYsjb91KCtr?=
 =?us-ascii?Q?kz6a0o7fPmfbJCMN3zYY/1enGxb/cxyDUs+gXdgUC9+lQb81QCSW3F79tB9j?=
 =?us-ascii?Q?xQyAV+PF9HRT11tA/Fo2ykuSCGkym9rluvrZW+Bk4syagv8gMysOEpClWSCQ?=
 =?us-ascii?Q?X9vgiFNLWdKLen3ZKgbhUh0Hu1pPzjHMP+Klg2fGO3DkvseyEkXsgLTm7g2c?=
 =?us-ascii?Q?98vtPrcGhNrBHHQ8BcVEdrkP2ZDTp3dLlGqvRbcTcuqzC2MQ8jEvfgxx4F7V?=
 =?us-ascii?Q?At2Ha9ou5+0Wjh3LMocVFR+h2Pwcbd+3Gsbzl1q7PzUYPspo6OrRzUuoJyE2?=
 =?us-ascii?Q?QEpwh+lD/5TWGIkcx5wYWPAuIDnApnu0PbnuyXSbLF0OzHbToBWgW113URUS?=
 =?us-ascii?Q?DfOQAolz8hOD/may6jI48d6uCWAm2LxEQ2ykzfeOD43smcA5hsj5hLsVwpXr?=
 =?us-ascii?Q?mRplVzxngadqv4InLLrUcb941TS4lYLP/o76LQrIWQ+sr6YyTXnaf1qhIWMd?=
 =?us-ascii?Q?Zu0jS8gh/Q484A2eaEeykPyRw4drQkGrwiruUi6jf7/E9Erhb1Q4Jeu1uOTr?=
 =?us-ascii?Q?C99XivClgKP89mEdT+nJqsWYQtYBhOIzGP4X5rqHxc859sF/7STbYeYR4jZI?=
 =?us-ascii?Q?PqklcT91CqqVK4MKk9Jl4vLn/SIyBtQ2tA6fNsOQH8dBGifDi1NydyXaKpEX?=
 =?us-ascii?Q?2Ph6pvRiIlEvbK+H8PcGK31dAn3CwOhc0it06Wo45TE1E81e7mb1xrYQOGgh?=
 =?us-ascii?Q?OUPHv082N3itKpmpkIMNESvhbNWAenPFXwiyupAvBCQ1BXv9xEG7j0/Y+wtb?=
 =?us-ascii?Q?DypcXaEVZbYiBF7lHSMY8BzvJ1dUiE0v13XSwlyPHCWksadsUbi/8jBm4zcx?=
 =?us-ascii?Q?55uFWV2hHAnSkr+CI8oNKUt6VFPIFoA73f347HPU2uYrcQDuVu+/ElzNqnyi?=
 =?us-ascii?Q?a7JJddg+0Rg4ww2u83HzoRR79YfivdpZwsKg3VippPKL2byfZJ2N9OUa0+Jy?=
 =?us-ascii?Q?sI+VIdvEeKFzGV6Nxp9nNZ8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4645a4-cee2-4c0f-c0ae-08d9f7962341
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:06.0958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/om5ZfoH0X2/d6tWcOF4NH5uvTdKUNKFF6LgzDg1EJzWnSnskk/8EvAMX1LvMsOQAVAieAZFxFsZ1mOQf2B3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: ebJ02RpLEP_vBDmUmnnHfqjYpFeF9dWB
X-Proofpoint-ORIG-GUID: ebJ02RpLEP_vBDmUmnnHfqjYpFeF9dWB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/bmap.c               | 2 +-
 db/frag.c               | 2 +-
 libxfs/xfs_bmap.c       | 2 +-
 libxfs/xfs_inode_buf.c  | 2 +-
 libxfs/xfs_inode_fork.c | 2 +-
 repair/dinode.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index 43300456..8fa623bc 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -47,7 +47,7 @@ bmap(
 	int			n;
 	int			nex;
 	xfs_fsblock_t		nextbno;
-	int			nextents;
+	xfs_extnum_t		nextents;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmdr_block_t	*rblock;
 	typnm_t			typ;
diff --git a/db/frag.c b/db/frag.c
index ea81b349..f30415f6 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -273,7 +273,7 @@ process_fork(
 	int		whichfork)
 {
 	extmap_t	*extmap;
-	int		nex;
+	xfs_extnum_t	nex;
 
 	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	if (!nex)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index d6c672d2..8da8aaab 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -47,7 +47,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 855f1b3d..b15a0166 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -333,7 +333,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 625d8173..4d908a7a 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -103,7 +103,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/repair/dinode.c b/repair/dinode.c
index 1c5e71ec..e0b654ab 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -932,7 +932,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	int32_t			numrecs;
+	xfs_extnum_t		numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
-- 
2.30.2

