Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013029.outbound.protection.outlook.com [40.107.44.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7683451DC;
	Tue, 19 Aug 2025 04:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755576279; cv=fail; b=nXG3Kix2xcby+5uyGkaQHFMpxwywSqh8rjvhLQeL6R1lYBNHRRZ+2x904tSPXuqgIA/YTXrwHrJ/IrodMNFMKi0PflOa2gUo3w6RqpIeehBlOXroe1wwpzr5KdS3QDUaOUOWe7ozU3NSCBAuHTdQiAfggt1n2JlNw1Qjjlv+4ow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755576279; c=relaxed/simple;
	bh=omQ05GeykVSdepH9bVqPBk2AQpgF9AP/Gwd0QWUIJEo=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=gPk22++8msHhZr+NjhbxAcR7QzGvnJQP0LP1L9Hy2Cr4QGUoux++zWtl9Jhkg+WmF8G+IOZdsVrsPIrraRTAr7B2czyQdXiDTW7hs9fiitR2BsGyX3fRm8SE0yBUbzJxfpzgrKxM65tzGSVwkjyqhYL/ijP+rRIO+NeCtn1QJwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=KgI4mdZO; arc=fail smtp.client-ip=40.107.44.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="KgI4mdZO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HPcmYW65NlZBWCi8mJ+1T791zBC52MHA5tflyKgdYlL9bU/ZUJ8bDkhIi2vB/XueU6pfcagrIaGrAMMUH6tYEdvblFHyzPr614/CXkK8JKoL2NWZhlPn4F3EgIik/smx/nAZhh2YK3j6h0Rx4S15CgJ9gAob36eip+PbRStnsqg4g7PP3ByZHDPrZWgIHdDAu8Ac7dqdby5oLSuF5i5bcQB5LULpJT8BCBdLq/9g6feZbDfaRHbGZ5L6PfCNJM7isLzRXg/2YP3Nc0Lj1FcIdQ3sAflWYYn4FWbrsI8OiX7eHQ0BUVtXlqKZYZG11Ih19RLcoHRFSjsLPWP+CJ6GDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hDvCv3fT7/pvakfUgwyzWZuoNvk2PGxC8NczjlOAVk=;
 b=GT8FEc7hSSpUmPB0rdX+YDCAFmBsE5oJ3pNYsvwsRi6Tlpz29juS+ey6yTOdaQVtWkw21CCKBcBcc2MYox7kgflp5vqhiv+eBjKTNT/HM1nsngUr/sdo0EdHJIyZe500YilZPfl6pHzjFiICnv179J7f8mDCfO7aRBgF786942c3vw3Var1ZlExtz6ecCTMjSwpbdR6E4eVsVagoraskRcIf9Cymvnk2JX2BAGR3y5dSwEPgzLtR+YlXKh4OCm4pvYbZJ4AeO70zAQYS0ab86PgipGmcQSfCUB2CZjNoPgyYqvbONXG0N+9ej1QV5dsxEpG7o9EqWKzU9cFnwCkNFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hDvCv3fT7/pvakfUgwyzWZuoNvk2PGxC8NczjlOAVk=;
 b=KgI4mdZO47tyCSEsQPmXQeas1bKR0UjDXisW7ZMfCutJ1PiTeMG2mpmnCFtnLbC7r4Mma1ChdrTesfugZ6Pas9r27BcTm+HgSDLetCGjM6jPt+tE187WuzpouQOWG9PVY81doq3Bn+dRtLTsSiivGDrvYuMtXuq8jj9eHE1WdilXbnx5jJ+d/X6EuDx/lpY+BL6wTpkjoOp1Kb9Al2Xs6jj/7ctPeOl7fiiRW487R143U80DhyJPXWspyWhDzPcHcXENn72uvnfSSizmVML++TH1g8beDnbdpuNF2CYqTIcfKODi+1DEHsG3cqdExAZu/RVhJH0vRQ+Dojc9W5gArA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 KL1PR06MB6591.apcprd06.prod.outlook.com (2603:1096:820:f8::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Tue, 19 Aug 2025 04:04:32 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 04:04:32 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Carlos Maiolino <cem@kernel.org>,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: use kcalloc() and kmalloc_array() to allocate array space
Date: Tue, 19 Aug 2025 12:04:18 +0800
Message-Id: <20250819040420.435324-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::7) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|KL1PR06MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: 82505f81-f050-44ba-6de5-08ddded58005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uXYtjWhGmWXqDkg114QjqRljoVgoBXVn+rT1A/tdo0axM6ejUzPKiBpqhLCc?=
 =?us-ascii?Q?e/+4Q+LqmejKMqxD6UDLtMtJJZv3uXMZAgyy3jZSA3Au7+f8fgFpMincBh6g?=
 =?us-ascii?Q?05IodSJgdlasiWbYs4hHI2U0IYmPUT7rXxL9mW53fD3QVRj3+hoXZ4MFM/bo?=
 =?us-ascii?Q?CSbbDHXBWtsTa2hygHuUHkXSw90eKrFbA/Ir3neDc1WT672wP97Ae6X2Gkj4?=
 =?us-ascii?Q?BKtKk9sc056Fro8PuAGFG4JZ0i+HJex9sFnGqlqyBJcgmwmOrS4SvdbkoA9H?=
 =?us-ascii?Q?b2XGZbA/TqZVT5Ag66dAQMZKN2HRb1KIKvbTbwKqnPbopZIB3jijrZ7iuFY3?=
 =?us-ascii?Q?yD2BH+YosoB9YEaVUhWLUfDalSDkVGrn0FamvObIX6V5YvHahLRBNbSulwZg?=
 =?us-ascii?Q?0oSzua7xGQuDOanTdR5Rn4Zd0xLPeCVW0ZrWF8yovln8yR3Ccc251CSZJ/Ti?=
 =?us-ascii?Q?AIWjYEkTqkKgGp/eH4kMX8mF9euwNdcuJhN5RlVX61KJHHhLu+cFNkkUGuRO?=
 =?us-ascii?Q?qU8QZwiAaZhP8Lxuo5ut5vgujrbXIKUTZsqfMR28LjyfVy8gk2wsWd6351kj?=
 =?us-ascii?Q?OcGdNxV/gF8tpcaqcZ4mC94J2vOQz50CatZKkiPYw7sqobfhpFrkSCk/jpk9?=
 =?us-ascii?Q?iZ9eKqKW85JjySR3+1XJRBia1GJv5BGI9Lwxx+qZl/6gG/n93xg3tPWoa9hq?=
 =?us-ascii?Q?J2UPjbwjaWY7CIRm3AxwFaINR4ERfAExBUTSfkg1VPiA9fddQB3DhyXCN60d?=
 =?us-ascii?Q?L2MHUlx8LyMreKheMdOz+avFBc+A/9s94SnVXXggpHQ1nfI2+LmBXmGUVsa9?=
 =?us-ascii?Q?+wuqX/HLqtP1zuLuGk16BkV/lae7e5PkxShIjXC/4G+DLpUAClXKTgeCf6Jz?=
 =?us-ascii?Q?0Bgwcrq2wihF8OslRgTxpfA7T7ZKA8+B0/CZcWBQK+rYFVwwmGHhg203kTmi?=
 =?us-ascii?Q?G6nRyQjLr0SI0G9zCQwcp1eniJAfOaKMwSGEJdU5qk9JiqRYaAaCqHaG0X/j?=
 =?us-ascii?Q?G3pBh8fU5xl0ksthPag/pfS23ajsyF2TdyR25/n0b4Ikp/Af0y4e7knXyn6N?=
 =?us-ascii?Q?e2QDWM+sUNmn1sMvvCb3KjTC2a/8oJhRqVON7rHrVGeV92ivxTNFj7okj8Mx?=
 =?us-ascii?Q?QbdsO3C8JBG9xA6Fs/4xWcLGCwKmqAMEI3HsHWx+7nH9Nkl4sB6ohHcnpjSV?=
 =?us-ascii?Q?K0W+NQ+Z9vTIGV9gXoPSXlc4gXWeKcH340U0FusaHyjmy0hIa0RBEbW/hQsq?=
 =?us-ascii?Q?uGlE9f2VD02+gLM0J2couhK2uijyb5HIVcQlsWPZAvgCBPnQ6kCBPm+8iH/u?=
 =?us-ascii?Q?c0OLdtTwAv4irtn/svDcAPfWK1TLfPAcYNZGty1JY61EKNQRI1UpR1un1XVv?=
 =?us-ascii?Q?fJrr5be/0RuMyDGkyjtrA1w7vydAClFuGF2LzOOPTM0lGurGmZfEJ/vhIpmG?=
 =?us-ascii?Q?h4k8prlbv0BQM6A0zCySj4BO88isgBEfHB1lrf+T1FVM+37pKQsqy28/W8nb?=
 =?us-ascii?Q?C6BrDfe+kVGW7DQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oZFSQgc64af8CDZpQJMyH77itTG9FISqC831zhfkNGr4XxwKhNzxpftxRgsk?=
 =?us-ascii?Q?F+vkloU9Dr6QoAf6ZckF4Oa48iPCmXnDcnPxR3cwyvtCJjwzg5UpfKnwVzhC?=
 =?us-ascii?Q?x4UtiAZ/KWPHbJMsp0fIsuKUe/XRCBL0TBQKUwupUPtffH9LBGWp6ib8MPUU?=
 =?us-ascii?Q?i5+vl2Ke8gwbywCmw/Ewu89BAfIrCxYA1yWZ5oqDSegTyJusTDWye7/Pr82e?=
 =?us-ascii?Q?Mld0UH8p3p0uVQ8N212HvtcBlX4Hc4YOXz4upiMW7Yf/utw7RqpcgnEtjttp?=
 =?us-ascii?Q?0iaXwvG+qJTU35UzUbcQMatgp5VfsbvuTzPGadZQplI88CWpSERict4ZBo6R?=
 =?us-ascii?Q?Cmc6ZOeXn+VKk538UqgBBDft1pP8XVY5njNX32vxZr3HgnXpMkQAoWXW3iKm?=
 =?us-ascii?Q?TIO2gSmWT/Q3192taBDX43yikFh/btlKZ7kEu2ftENLsYPOr9FbeupI/l82r?=
 =?us-ascii?Q?aRV2VwNlXq0Dis8OqUfU9wI+msHReHtwVLpX54CR3254REQUqgb3klzAYWDF?=
 =?us-ascii?Q?dmBHakYpDOB9uETT3HSnVn5astBvkUBFw2JqPtuHe+TvU9qrHny+fWQ2fvhw?=
 =?us-ascii?Q?H/GV62VvsKJUtE1TfwQHc/l8THn6+vzP6eA37V47An+vhqVG/xf5+lwB9Foa?=
 =?us-ascii?Q?ezAtjn4gzPCeb2afRJZkFf4f+eCv3+q9khhmTudRtWuPuNvfEuZjqxHaLtYk?=
 =?us-ascii?Q?Wl1jf0CBW1j5o++h8oLRczR9LektfiBnDZhayf8eb2mSdLgSjy5spQIF+b9a?=
 =?us-ascii?Q?0Yssc49QcTTeXBDkimTV2EfaNjqZjVd/ei7o/hz/T8vuIWXI4I9bnbj+WJbF?=
 =?us-ascii?Q?FHOhj/U69RFs5RccR7tOh2h+9t99U1t0VXg9MQgnac1Hkpv/Zc8e33JbeJXl?=
 =?us-ascii?Q?6LC5dqiP5t/+YylfqC6QKEcCHa8z3IfXrDTE8VU2rXlEL87Lyo4XJ/yL0s60?=
 =?us-ascii?Q?skg/+gzVOPLN6D9j55qUJakiw/0EQeu5QkRRLNIeE1IlubXljIiJDPqrskja?=
 =?us-ascii?Q?CYgE7eswJgazLssfCwFeqKM/qnn25dXNSH1S5UbSN3mfVjdJo0fWaRsTAZPr?=
 =?us-ascii?Q?A5IKyeEyzOKjw1DyGDajIr88IMENEgXUqXnajG8ralpzD5jOzPuhH+xMyemd?=
 =?us-ascii?Q?cTxtRj2L0GuOwM40f/V0FIhfuiQlTJ4OkCzj+UVAYVQfzxn/Uj0EUVuhDqtA?=
 =?us-ascii?Q?kBA4lmMMrianUvhe2vOGLKV+ti67bWso3g0LQCEWWGs1C/pCH+ROyd6mNlYb?=
 =?us-ascii?Q?Qz6xixARZ0LfWf7lzKis7tR1U4ftGLyiMPjuJB7w+mh9dhxI1tUwN9nTabII?=
 =?us-ascii?Q?aO3ZAN0JPiZAXecOzZgSqWeWgfAEP9Jdi5vXXUFJezxylJR9lxfxUCfwxDXZ?=
 =?us-ascii?Q?aQARJmm6WZ8YhkwnkPvYW9mjgmK8XyGBUZG7yDJxWRRTxLeE33Ac45W3VJIG?=
 =?us-ascii?Q?h43xoPCIjO7NpT9Y/lDK2AI+FTP/n43HS77YK2IZ8coBGstNNEusR6rcw3kY?=
 =?us-ascii?Q?lbVIYwmocY2yRTpSVc4RmiJaVqNpSGx5At5utgNPuRywfjZssa0TBZ9ONyOZ?=
 =?us-ascii?Q?/DN7w7+NO1JBrSMeqiKg7bRD3NyWVMrW6PWVx65c?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82505f81-f050-44ba-6de5-08ddded58005
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 04:04:32.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKRe0o/zWsVYjTSzW3wPI4RKZyZSMqK7YJYA03GGsX9RIFdKKvfQiLIBsegrJZOT7YIJGWoLhoIuf2IqbWy3tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6591

Use kmalloc_array() and kcalloc() in xfs_da_grow_inode_int() and
xfs_dabuf_map() for safer memory allocation with built-in overflow
protection.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f19..9313ca167421 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2323,8 +2323,8 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmalloc(sizeof(*mapp) * count,
-				GFP_KERNEL | __GFP_NOFAIL);
+		mapp = kmalloc_array(count, sizeof(*mapp),
+				     GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
 			nmap = min(XFS_BMAP_MAX_NMAP, c);
@@ -2702,7 +2702,7 @@ xfs_dabuf_map(
 	int			error = 0, nirecs, i;
 
 	if (nfsb > 1)
-		irecs = kzalloc(sizeof(irec) * nfsb,
+		irecs = kcalloc(nfsb, sizeof(irec),
 				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 	nirecs = nfsb;
@@ -2716,8 +2716,8 @@ xfs_dabuf_map(
 	 * larger one that needs to be free by the caller.
 	 */
 	if (nirecs > 1) {
-		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
-				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+		map = kcalloc(nirecs, sizeof(struct xfs_buf_map),
+			      GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		if (!map) {
 			error = -ENOMEM;
 			goto out_free_irecs;
-- 
2.34.1

