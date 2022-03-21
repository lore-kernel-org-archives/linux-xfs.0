Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96873C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiCUFTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiCUFTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B336D344C4
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KI01QU017476;
        Mon, 21 Mar 2022 05:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=E0PdgIR8ZEVPzFE5qqyOOgJ2po2wSe7h6y85ATO9fZs=;
 b=wFzSKklfBkMk/uz87S4rNSfkr5qObIW1ihU6C42OboFBfGNJHTzGgOBaRgEEDLO1Udps
 Jc9KNhkWw78qe8Pn9nyiAqCsAEiWfoVQ+7w5Kr+pw0DQHJScUl0FISCJ1Leqke1SYiCJ
 wDFW76j2w6Lk8hxRKIFrGvdxugbAutsl+X/iZdJGs6NZQuRefNX+Xk2TNxe9VBPIR2yB
 stjS0s5PPB0fRVOvdfluP4IHl2yOzrwpMGjTJfZ4X+I8NSAc0mR5mDFJyURIqrsgcusi
 Wh1z2qRg/ji1y9PWHnliP6cWyl6plzO1lBXy/tQNZDXFofzZiADs2+0A/mRmXTptqM+F WQ== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcj4rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5IFdI121142;
        Mon, 21 Mar 2022 05:18:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by aserp3030.oracle.com with ESMTP id 3ew578rnsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPqvMEVpee5ckeewRSdz/3HbsR/y2K4wqW3nJ9BxwDz9dh3A/tIRMHUPcpKsuQq8ahjEEDUsASamJinCTtVrntZuP4hzB/ZYjx2MD5dQyAhY3lDxKsWJFWzQKEifZ6Q5yJ9hL+T/lscpxXq+bp3+TFY2k6tBLSCoiHgI7lmy6TeY3I51suaG7hsw80DFqDz351QENAkETSVSVHwaj90cyZMzuZM5SZuE9beMDTYxk9s5dVw9BInGaRysM/JtSppq6//Sv83oDf100FF86kJI0Hga1liuwgDLIrpLG8bG2zmdkByQL96A2fr1U8DHvQZltjAsSPYTpT7aqUueniZ5Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0PdgIR8ZEVPzFE5qqyOOgJ2po2wSe7h6y85ATO9fZs=;
 b=Dee32+SlocuFNtUHrL6bHhUKSfbKqcr0Buhernjmv8KTofcgDPo1VQmho3bbyPYl3zQwQDjmXRpFu2r8hf80t2OjJgSRJny0CUM08Jsz5cEMOxhTcNGhnMsCBwQI/T/LprWu3wP6yhnfcVprq1rTgHRmq+GG3c5LkJ3bK3eJqqcwwLlGiuePZeyvC3FlTF6j0RPPxsLdKMY/flA9qI211Og/TC6pBo8FviikvggxQeprXZyMYp8G6ruIoz3nXzaYeRdhaNhIk6rshNloGpn3S/yZzUowWsguTWUjoEB5VfflmoMll6AxSM6kw6x7XWoqguEsH7SWlihGlUth4f1nbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0PdgIR8ZEVPzFE5qqyOOgJ2po2wSe7h6y85ATO9fZs=;
 b=pP2DU0JonlzGKDcm2MwQHwyFO6Ayz+95grdR+fNROFnuVLydkl7G54CAoV3TSgVo+vTICNi6Sw5TEOvWrdVEoiER8NaqnB7ZNsZh5cEPeM7Yl3KNQqagQnyjM6vmXw6rfm+GR/OGjFOssmj86lkmpCBana6ErreUi1WmMO8xcvw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 05/19] xfs: Introduce xfs_dfork_nextents() helper
Date:   Mon, 21 Mar 2022 10:47:36 +0530
Message-Id: <20220321051750.400056-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f55be79-ac7b-4e85-7fb0-08da0afa37b5
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55372962C68271594AF86ECFF6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ETFSw5Jt917h4yWIG1mHsTmBozRuf1rvGwWhc2UHqjOuRs+nRMpAC3VhmQQBRxQjEMk8AVxbmZReq6VecCBahwKDzVqv1FEcPXMIk7r+VbreV7Qfy5gNvEJEOpYPknDintOkKMEVWPHnPYuvuCH9dyL1hwrXFkElJ1w3c5TqqAvr2NuyZFPV35thTGZV7c53g+uyIB4zudR03nPY/uksDO4WYQB5SJxsi/0HbgNcyoHRwwgDY0oYbWffpiVM61CxuAR9NS/aDYrEr4h6buKLvZtqSqnMqFLEkylpexf5Kn49DmtJcrwJwKgA+l5KCbcrPgdXA2wYE3QMyTqgNLrxd1nniz00wpiAhZSvFRsfb4U7HOg9sMaVDcOhTNIXlcRbjppS8HaOMtfhRBGzRiNvqXeQza5IXt6b6mz0uumQRACFQQHYcxv/oLnPlDuxo+V/dqBe3zJptd5q4Dsq0uYj1xVwU+zh15qFucji8NKyHOTK9W6NuAycpHrEJa4FBNBJbztoIxJxTAREJ3bQr4PIh9v37251uDuIZrsLw+1kPLcsDaziBZWBrAgL0h9MWUap3/z8lIXI/a57Qvt300ocBPlsf26kckdm+5a7WgZlpJu3yC4T3CkZXEh3a+lPhxtclbcAnpRh6f5Xy7d0doYBo5UgKP92MvNUhthRFXNdGJmJbLYk3ArmN0Cfuy7Gs4+al79frk1Y6CSkDcz39UNWXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?azrLxKoYwqrpStGNmQodmtmG3Y7Lfwx1lI3QQspI4pwekWpofmcrY5ZTSpRk?=
 =?us-ascii?Q?ERVMipmQM3e9r07irVnQ/P4FPtHSVMPN9kKeeParuniY/7qPVKLGE01rA0FN?=
 =?us-ascii?Q?ZgWoXpjgUfgHnqfRiSRT8DS6rfK9jOtG4XH58yOvPKsSw+lnfMCOHXlQWc5u?=
 =?us-ascii?Q?B9LUyg73H7+0uspq9PDLovXS2rQSiKCUPBb5in+zBCOlkNms+h855G+wG0Ak?=
 =?us-ascii?Q?y5LlNKPRpaZBfTja2W7OBjy+7SUIUjxcWMEIbsYukXp0/Un2+3I7dWpSyFL2?=
 =?us-ascii?Q?uySH7W2mRGNpBlx84+/5Rgz9aZaQFW+lg+rHKYAdhdw2L3S5WeZPN16V5dSz?=
 =?us-ascii?Q?LYickP8XK/4qhmKdUpqcVOaNdOROaHazqEWL4vxmCPtc39JLRaw5sLlAKYnT?=
 =?us-ascii?Q?1Pt7wIlVHMoLLUXJhmrcNCJ+4cOUzzxDXzWG5KExx2c3t8G50X8bI5Li0AEi?=
 =?us-ascii?Q?zJKBFnirWNxYHZ0/FbbUpFt46Z4dNOnUs8/zrDGfRt7y8hY2jjBXHcnNUAxp?=
 =?us-ascii?Q?ExU/V1JySQHCLuvyx+/nLNN8XEox7cv1y79dYAMK4XmF8da3LbDXL+aiObiN?=
 =?us-ascii?Q?zy0dDJVzeofaqdCpPK4fnjCG6PA8+7XwkAdVOJC2tmLm35VJ2i0fvKhJYB+m?=
 =?us-ascii?Q?ZfEgLQg+wkl2vq/Kr363Fq4SjP0ODtCFHs4pQd41Txl9IAKSUmjMqxrA+XVl?=
 =?us-ascii?Q?+ejzeiN4KQ7m+Qg0OySka02KKYMQf8F37p8sNOZkSXHJmWX/TkDm4iGGx/Yt?=
 =?us-ascii?Q?NbzfZBm015uO2Zi/cYntlyBla6iXgffRTfT5087Hi0cGlqxcuhj7vYia7LTt?=
 =?us-ascii?Q?vqJA6FkwidlurI/2XTfhWhVgM01au6lnQV6IpJK10+ZATm20YXolXxG63au9?=
 =?us-ascii?Q?/nZGLE4qyCDBpcZe9JK/aTmpO9N37lzAjm4Omxn2McJZwnLp5Vw3SB/00zVK?=
 =?us-ascii?Q?tNsmQzPGhkvzGeXSXdBN3iC0uNNOlrKDwSy5bne3mgYeo11W8tSW3//l6G8e?=
 =?us-ascii?Q?CeG0T4uOenMFrgf2Cp9zvFNBI8kt1Gm+c/IJJ+hNrI6ttXkC9Wn7TIlE9WaL?=
 =?us-ascii?Q?zR/zJxBUzYnvpSN5J+GEsTgM5h8lNTy7Ch1MWZKD2uZnr5x2QB4PMqq1gj9p?=
 =?us-ascii?Q?n5gk88h6F0Wla91CgZLP37xw+0hu008V5PaqPaIxL8PftPJ4eTTVTaMcnKdP?=
 =?us-ascii?Q?QF8qTI0QIjX0L/XlLvCKzyAsDYHkJczoFOYWZIWlqTSDLVnqnWB50AyQp9Sy?=
 =?us-ascii?Q?jQy37XMT6Y1oDYoHPNOVYh7oUoszmFawgk94jVYpG1hhVboJe8q1xjjMXi38?=
 =?us-ascii?Q?sMLWXtJmWKV06u3yol3h6xZgmTpJXs53gaWS15r7q8U7tmgdHybYBCgIa0Vb?=
 =?us-ascii?Q?61InHrF85pqyw5LIB+MKbnzrc4f5eCFUK1ClsXuzVScTGXt9U38+YnsQgNI2?=
 =?us-ascii?Q?Uw+Bb6gwhLPDSxI4KwsLphc9gunYlNiCnOwfWUr0XH2oi4FEVRqntA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f55be79-ac7b-4e85-7fb0-08da0afa37b5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:21.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aj6Ixr5dGA2cpT0sdssSEfz4WQmiKexNQ0LUcaOd+BI0B9fAtKNBWtrGNtCOruQrX5xvjiPQWFOI1IO4HA0KJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: X-VmZ8SiH6KuPtov5kH8hKjIKT19GUK3
X-Proofpoint-ORIG-GUID: X-VmZ8SiH6KuPtov5kH8hKjIKT19GUK3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
counter fields will add more logic to this helper.

This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
with calls to xfs_dfork_nextents().

No functional changes have been made.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ----
 fs/xfs/libxfs/xfs_inode_buf.c  | 17 ++++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c           | 18 ++++++++++--------
 5 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 66594853a88b..b5e9256d6d32 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -924,10 +924,6 @@ enum xfs_dinode_fmt {
 	((w) == XFS_DATA_FORK ? \
 		(dip)->di_format : \
 		(dip)->di_aformat)
-#define XFS_DFORK_NEXTENTS(dip,w) \
-	((w) == XFS_DATA_FORK ? \
-		be32_to_cpu((dip)->di_nextents) : \
-		be16_to_cpu((dip)->di_anextents))
 
 /*
  * For block and character special files the 32bit dev_t is stored at the
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 7cad307840b3..f0e063835318 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents;
 	xfs_extnum_t		max_extents;
 
+	di_nextents = xfs_dfork_nextents(dip, whichfork);
+
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
@@ -405,6 +407,9 @@ xfs_dinode_verify(
 	uint16_t		flags;
 	uint64_t		flags2;
 	uint64_t		di_size;
+	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
+	xfs_filblks_t		nblocks;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return __this_address;
@@ -435,10 +440,12 @@ xfs_dinode_verify(
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
 		return __this_address;
 
+	nextents = xfs_dfork_data_extents(dip);
+	naextents = xfs_dfork_attr_extents(dip);
+	nblocks = be64_to_cpu(dip->di_nblocks);
+
 	/* Fork checks carried over from xfs_iformat_fork */
-	if (mode &&
-	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
-			be64_to_cpu(dip->di_nblocks))
+	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
@@ -495,7 +502,7 @@ xfs_dinode_verify(
 		default:
 			return __this_address;
 		}
-		if (dip->di_anextents)
+		if (naextents)
 			return __this_address;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a17c4d87520a..1cf48cee45e3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
@@ -230,7 +230,7 @@ xfs_iformat_data_fork(
 	 * depend on it.
 	 */
 	ip->i_df.if_format = dip->di_format;
-	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
+	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFIFO:
@@ -295,14 +295,14 @@ xfs_iformat_attr_fork(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*dip)
 {
+	xfs_extnum_t		naextents = xfs_dfork_attr_extents(dip);
 	int			error = 0;
 
 	/*
 	 * Initialize the extent count early, as the per-format routines may
 	 * depend on it.
 	 */
-	ip->i_afp = xfs_ifork_alloc(dip->di_aformat,
-				be16_to_cpu(dip->di_anextents));
+	ip->i_afp = xfs_ifork_alloc(dip->di_aformat, naextents);
 
 	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 2605f7ff8fc1..7ed2ecb51bca 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -141,6 +141,38 @@ static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
 	return MAXAEXTNUM;
 }
 
+static inline xfs_extnum_t
+xfs_dfork_data_extents(
+	struct xfs_dinode	*dip)
+{
+	return be32_to_cpu(dip->di_nextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_attr_extents(
+	struct xfs_dinode	*dip)
+{
+	return be16_to_cpu(dip->di_anextents);
+}
+
+static inline xfs_extnum_t
+xfs_dfork_nextents(
+	struct xfs_dinode	*dip,
+	int			whichfork)
+{
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return xfs_dfork_data_extents(dip);
+	case XFS_ATTR_FORK:
+		return xfs_dfork_attr_extents(dip);
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	return 0;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 87925761e174..51820b40ab1c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	xfs_extnum_t		nextents;
+	xfs_extnum_t		naextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
@@ -390,8 +391,10 @@ xchk_dinode(
 
 	xchk_inode_extsize(sc, dip, ino, mode, flags);
 
+	nextents = xfs_dfork_data_extents(dip);
+	naextents = xfs_dfork_attr_extents(dip);
+
 	/* di_nextents */
-	nextents = be32_to_cpu(dip->di_nextents);
 	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -411,7 +414,7 @@ xchk_dinode(
 	/* di_forkoff */
 	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
 		xchk_ino_set_corrupt(sc, ino);
-	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
+	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
 	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
 		xchk_ino_set_corrupt(sc, ino);
@@ -423,19 +426,18 @@ xchk_dinode(
 		xchk_ino_set_corrupt(sc, ino);
 
 	/* di_anextents */
-	nextents = be16_to_cpu(dip->di_anextents);
 	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
-		if (nextents > fork_recs)
+		if (naextents > fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (nextents <= fork_recs)
+		if (naextents <= fork_recs)
 			xchk_ino_set_corrupt(sc, ino);
 		break;
 	default:
-		if (nextents != 0)
+		if (naextents != 0)
 			xchk_ino_set_corrupt(sc, ino);
 	}
 
@@ -513,14 +515,14 @@ xchk_inode_xref_bmap(
 			&nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents < be32_to_cpu(dip->di_nextents))
+	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
 			&nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
-	if (nextents != be16_to_cpu(dip->di_anextents))
+	if (nextents != xfs_dfork_attr_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
 	/* Check nblocks against the inode. */
-- 
2.30.2

