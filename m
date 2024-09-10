Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010042.outbound.protection.outlook.com [52.101.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E9191484;
	Tue, 10 Sep 2024 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971353; cv=fail; b=LOuUJw5HtJ/0BGNi9mwYmUSaTscZPEpFBnhcZsh7HlotuPchVQuwLeoFdWPQdy4I/aLTJHBm5wj2UE9UqTGFa1iFNgEfQRveSasOqJQSOmHOyFy942GDrmWxp1ox5E1sUmwOsveNPkDv7CI+Ue2B8T6dG7aX3u5prknf0xHu2rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971353; c=relaxed/simple;
	bh=iJ4VBeovxXiQyhYRvFx/CNhnJg9oSMvDuGSSh1aoPKc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CLhPsLyHzDt5Fy6N+UJe5wGooUUMtABReZlxAwYM74ogyLN4nVdRHunfPx4yTxi6Icsr7jUD5XFM4O4j/gcnXKurtWQQebZEy2XPiMwfbF2TB8/EJUrS/WaspNYD05rrPpskqh/Rs41Xus0EUBvWK/4x5uMEH7XTl65IBVo8rlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=pMQ4ThON; arc=fail smtp.client-ip=52.101.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="pMQ4ThON"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6+IOkVeRfT84wkKAV15RpyPFO/RkOVtM+VR3nHM+OaumveiezhSQzmnyfb9/TYgXniQOrNs2/Bw8/Qq1UyuX2DK6Ekjsm5rMKvMxJnV2TEQv8g7j7lyF3koZ0Q7MOlPFmmuT3gyczbYm0nz6jsxF1SfNWJdUlvK6iU5ddt7nfmYL9uH23oZVR6M95vW6CZEmKx5BrVVoqUZzf3+VzNdHKi76Oy0mpXOpzO7kxGwscUdsywjH/vF/BHrTNIZh4uxhifb66ghmngb2mDfrWmjZLdftREyTNVEvj7X3rtpCWOqoHJ/fCVEp2qIlufelrAxwMbTLq7N8dUOBPXUdQ+J+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A1ro3QwgJGjf+5vk49ssAoHTTxZsuukUSZTP9tf/wUk=;
 b=CKMGcojKgo64pO5/lg7dM5AweokIpK1hj+dZvuN/i2zqb16xQzwc7722ScCHmYnWJvExfTDGfH3ZYEQlxjLxRmnIdqh1ogofWISOMNB56ysQvoO1lxRAxgkMBB4ev+WnsK2H4f6c/hj4xEWZwNrbnAD5nMzVrMdtVYfl20xY0D7pEZ2t99OodfjzqUv21q3c2OLqy6Rl98eI2Haj3BnF/YPzeTmfbvebW/AI3JPiVpM/YBmko68FhKSvLIAiW6qA3PzE6f40BsoZoSJmDT4LOe1kgwwVe/N/rNNH5TG7EiR5cjlI4j02X6Jz4lvdXmRISbphI7VPiteKzX09qdKxZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1ro3QwgJGjf+5vk49ssAoHTTxZsuukUSZTP9tf/wUk=;
 b=pMQ4ThON1f11eeI263oHjGyQJqJkCKtYIwpM1VqgsDK5XeUhgzVlrySn1VMo8pFToncQK6JUwCUMdPknNc4GpHUuRt8U3nuXvhVsEXneIlhJkNS2j+/WMsaOr01o5Jh/LZQq4rb1zwSzc2I+qrs4kpnVXB45Y+uQ2l3xB0zMLrxXIXLVOiPoqEbzgW3phUyY5b2eDnNZfRYt7V5KuDvdlTtszvpIXmvmS+E1Cci2U+WmHrUmuICiyds1hCGLt+X4k+U2ko8zf1K7kseRR/yZ5PqVab4UcOpRMNKsBK9Y7ZMrCTyb83fXt9wHuu6E9T6TpnAw/ikxtRa0+5bja7n/oQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7)
 by PUZPR06MB5553.apcprd06.prod.outlook.com (2603:1096:301:ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Tue, 10 Sep
 2024 12:29:06 +0000
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1]) by KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1%4]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 12:29:05 +0000
From: Yan Zhen <yanzhen@vivo.com>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yan Zhen <yanzhen@vivo.com>
Subject: [PATCH v1] xfs: scrub: convert comma to semicolon
Date: Tue, 10 Sep 2024 20:28:42 +0800
Message-Id: <20240910122842.3269966-1-yanzhen@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0080.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::20) To KL1PR0601MB4113.apcprd06.prod.outlook.com
 (2603:1096:820:31::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_|PUZPR06MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a5cb6b-0673-4b91-ff8a-08dcd19428ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YSDs5MrGUVYYFE497G0JcQGBwH+7j+C9DDpM6icYW7Q2cH7nZruOxKVOf1Jh?=
 =?us-ascii?Q?frpRgvH2TDcvkFp/wCrJWWlJ/77uQcqX6rDHtH3ebyivz3rAnuPwDmp6UGnA?=
 =?us-ascii?Q?i8zZO8/tvSpNyuQBICBb6fLof1hK1NaN1rrrdq/CE3lrkwdqcXJjlJjXaE6h?=
 =?us-ascii?Q?SM2o3TXa/A8Q8Q+SML2igsI77dL55Ocp2qtCexhFoNhOU41IGMtaW8T4u96J?=
 =?us-ascii?Q?jBhqL/50gp+BmgYU5kUtkh9pivtQBtr3GtZExTUUtN6Su9LigwXUwmhmQEYH?=
 =?us-ascii?Q?veu+my37x4/xsQ480K0vG7dDD7SLBMhfoSrwONvH0GPVhxxuTFnhk3XjS/XH?=
 =?us-ascii?Q?+DPAuIjoCa9UrkFQMZ9OY2iZyC+JBJHPPpLM4IaLrvRb9uFbLauFohBwDPJ+?=
 =?us-ascii?Q?6Ry9WSvazzhqLRXIuYHdJShY7PKOX9IShtdc+3kHLa6nt2YgDNO3H1e6EW7i?=
 =?us-ascii?Q?MZWwZz/MJY150QB09KpyUpQ506GGIhrdd06cLMYRK18Lr+6WuIszGg9p+WYT?=
 =?us-ascii?Q?Bi6T+BDh/byzzzenI41jGrpaj3FDAjgzRDZL41IScRqa0tz/uVFpt5epat0V?=
 =?us-ascii?Q?JYjGrOasz7xYixtAY4GaxctM7qGO3Y1Vq58eoQaDhKPeT313g265izsTNdJD?=
 =?us-ascii?Q?Xtv0z5uH6qE6mbEM4O3yU8WRwxsZYFVgsVOtw/bsuMKtXFzcTetI7LYl7/aT?=
 =?us-ascii?Q?q534WvZI7ymCcv5aNXlT2Jst1QVbXG2Qzyv+kD70+bD3HxMka/g5emM0TyLJ?=
 =?us-ascii?Q?QLqFYn8+Te0YJpYy3Nf6wvtq1adzTsqhREiqXGKVOv3S4KZ9bBwigzNtg5Kd?=
 =?us-ascii?Q?wzoam4ZAf7k1aq3XOSTwk08nOimuLFo/HBSitnzy8/Va5qct6In5bQQqFvPH?=
 =?us-ascii?Q?4VLOHdsia/hW9RymoZOjP5+WfF8gebbTY/hDmBdMYX3Gnw22x/gsa8XH+h4U?=
 =?us-ascii?Q?P6pW2i27NrCYx8+0UlmqV3YY2SRH9OPB5I5bRBOvDPviC6tTMKHZBORkJTMh?=
 =?us-ascii?Q?7vUy2Ke+schWojqbDgGtz6x3KNKoWICS/3urYxqkFtVFTvmnViS2UEugbXZk?=
 =?us-ascii?Q?jMkRkiZ/QQ/7OnZe+sUzanO21Jqo7PjI+/C+j9muREiyZgogtSJ4KWP0/YtY?=
 =?us-ascii?Q?GHpsdtmf6JuZfvEJskgugiVdZBoKUYfv20PrAqt0dpteSkwMy8cFdl5W3jSF?=
 =?us-ascii?Q?Wd1hJ7AKKFgAqPNEEIeagQcrWJQ3688e8A08fvZeFbgVn1b/NZJ5lIrAdM/x?=
 =?us-ascii?Q?jaDB/Dx5yLassL5K9tnYDLITGMdmH6GwMaRHvgluZsVq79OCy1F6SFaUjcvw?=
 =?us-ascii?Q?wWV1K5LcA/r3teTEboJl/tBkZ3KJodhwTgA4TM0nG2nBH8oRfhsuXCeNuZtX?=
 =?us-ascii?Q?X8i/96ZYr2H5OP7cWXf+C22cRR3oS5sKKgzblsJ3eMw0r8c8yw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4113.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fvVaqK8eqSXpg39LIKYiCQsO4g+6lO9s28uyK0w4ybbE7TihAjdU+9XM/mcH?=
 =?us-ascii?Q?KFjqzBHrIRHZnzRIu5SXvzkVJidwnuWLEKTupS16bWeRH9S4NhirNuIWanri?=
 =?us-ascii?Q?bLN4yPdl4/TS+14X9vcAnsrD+DHAtZFkfJBAkuYQRq4EIf0kgaG6w9m6L7wP?=
 =?us-ascii?Q?Nm+MJqC69YNqa6gvp5TGopu85avhyapOyLTlLN07lUV9vZc4NYTvdgvbSEyd?=
 =?us-ascii?Q?H9Rc/yaqgXcXAFJb3aOQPxK+woGDHo48kd6+woo1OB+Z2jzIxTQnTx+lELPu?=
 =?us-ascii?Q?mHlp0Q9Qs43iKse7bMNNepWYg7dxPc/TdePZGeT/yqaEbaULcd6bUYEjbsw/?=
 =?us-ascii?Q?AxWdbgERQD848bMxBYcIO3M6qNSZqb1YW6nQOpmHVVg7tVKJF1bWv7Gq3/6c?=
 =?us-ascii?Q?BRMVKszD8Qu5WwJliTC5++pf+ceJ85LYExOwvTiIWl1NIW4O2Bt8FYdvXl6O?=
 =?us-ascii?Q?nWjtvWWiWnznGmfVxCBx8I3+uW9EwtIKJdu560iEg39XHWPuz3Eiv3K+JFXE?=
 =?us-ascii?Q?wDSHFqZoEVdQbOJgvZBgmiZCmRik3gB/7FcceKLqbHL6ivoOzUjWNQvUesF/?=
 =?us-ascii?Q?QoiByBQIaCmTQGQ2fXGZT371d0pLfnSVOfoBfqfAt53NWdtM9k02LasMR5vS?=
 =?us-ascii?Q?wW5WuypdJIPlkIgRe93QsV2obhuI2pRCNs4TZdM8GYuEgGflg85aUjgBLkN9?=
 =?us-ascii?Q?Uzp3E3e/Q+1Vpv9GZD8vBgfLMx4flyNGjea0eTb9pZRqV6M3lKTp7ZjA7cLz?=
 =?us-ascii?Q?25hEWkBvelmNO90xneDEV5lFPaiAE3OEYFPCkoJIo0ZkYX24N8MVDs0Nm3HP?=
 =?us-ascii?Q?9AypslOvh1CnmNuVornHe2nNWt+DftHpI0+G/Thw4+imM5CsXnDK3L8CSNVz?=
 =?us-ascii?Q?T6bOIbQJqboQCYOBnk/mpG2RhMZOKtoB2HddSshbSFUh3y410as+0NISbGD4?=
 =?us-ascii?Q?fn0ltB0pWr698KG4hsvd9Dq/fJnkGdQtAOUYEnS67FvPvxIlrmk9G6WG8xOK?=
 =?us-ascii?Q?lq6sIXLGaeYYGO3n+2sAsIwX0vAmiVpO8RDXq8b76m+BavAr4L5s4wiPEaFt?=
 =?us-ascii?Q?ZKy5rglXeYPARtwlYsSN0qlpi/qIslgXTvRXXPoPaE6OJ4IBGty1t14eo8Fv?=
 =?us-ascii?Q?ogumb6/Ra8+SlE5wahix4PGFXa5XNNf+wzh01tY/93tj1iAewVfpNiL+V0yY?=
 =?us-ascii?Q?tLnmnZpchh5xlC+GvtOdGEmvGVZ+qtnOharc8nrNp/uwUxha1GSguofxrOuF?=
 =?us-ascii?Q?4M5mLnIWzIZmT9jX5Pd6ROiSJHLxwDB/H8zgWN8SB+GwrIT8mGGsLz2i9ENV?=
 =?us-ascii?Q?m/oJ3zrXSBK0vl9qntbQSdDjHi7Kpwua5zj9UupxCc/FDCjX5f7lCObDrXKw?=
 =?us-ascii?Q?kdGXaI2zZZ3msLPG9fagYuJXMkgcnuoM0ma2Urou/b3q3qDKyEYNvrXk0Y77?=
 =?us-ascii?Q?MI0QSiTQ+5FzYTYn2kjV95L9init1ir6ZjQbBfPItTbRKgghCojN8NnWm1Om?=
 =?us-ascii?Q?oAO3BwE7QgP376RmYIx3hp9eyznFri4turVUvV80PXzg+2mJrYqSyIimABMo?=
 =?us-ascii?Q?Pd7cQ5/syGzdTWB857bpSoCPN3+1+fDxA3nVrJnN?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a5cb6b-0673-4b91-ff8a-08dcd19428ef
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4113.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 12:29:05.5157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzWLaKrh1F067/XjTA1vInzD3h8IsjVBpJOxNveizGGBU2Rr3twfR06HSbKjiz0wXbrq+DGn7pExX64Zv8YfHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5553

Replace a comma between expression statements by a semicolon.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
---
 fs/xfs/scrub/ialloc_repair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index a00ec7ae1..c8d2196a0 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -657,7 +657,7 @@ xrep_ibt_build_new_trees(
 	 * Start by setting up the inobt staging cursor.
 	 */
 	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
-			XFS_IBT_BLOCK(sc->mp)),
+			XFS_IBT_BLOCK(sc->mp));
 	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT, fsbno,
 			XFS_AG_RESV_NONE);
 	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
@@ -678,7 +678,7 @@ xrep_ibt_build_new_trees(
 			resv = XFS_AG_RESV_NONE;
 
 		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
-				XFS_FIBT_BLOCK(sc->mp)),
+				XFS_FIBT_BLOCK(sc->mp));
 		xrep_newbt_init_ag(&ri->new_finobt, sc, &XFS_RMAP_OINFO_INOBT,
 				fsbno, resv);
 		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
-- 
2.34.1

