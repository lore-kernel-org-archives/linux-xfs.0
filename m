Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013050.outbound.protection.outlook.com [40.107.44.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E67A1990C7;
	Fri,  8 Aug 2025 08:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754642617; cv=fail; b=MhuUVpmyZkvU0b7llLyXxj6ErldXz3bdB7wcqFpK4hNE2i3akYpjRdrDmFSyjb/+QMrm6LFu/2LK++OrJVVX5Ukel3qBi1go9CVcJ45aZTixIAluutf+RwOdV5hxwFk8A1ObQuc48bxx8Zgof8MgvXyVIDgOdEHU1pRz44m5b2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754642617; c=relaxed/simple;
	bh=tBipHRqqAFXg8jRMKt7qJ7zj9sNzcMsXkHU1+m82mYw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=YWqjKpMUkEfnFCOigzko8JVp2yCxIcYgl61CGEy9ppwDKXVhgP/eBjCuYd9tJgom2Q3AhT6BCeqyhcaBfJQsXxuMGa/G/pXftKFCqatnKZsj0SiEZ8VETk+SXWGGI1393gzycrgFaFiXm7yeWpwFrSkZvOrtIOuEelTWy1P2ewU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=DIASophM; arc=fail smtp.client-ip=40.107.44.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="DIASophM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qs/fUcrdtmoTzAL/+xLFqAqX1C/U+JHEYvHdeSfyp+3MAYQDtpEqLBHesw1p4PCvRSvbwM8fVmuek6sjy0EkxdX1aPqLi8mlH9IqArlv/iNE0KcgIBw2DAv9JPdfDy7P5dL6ogAnU7TrVwO3Tpicydeh6vBjPBzUTkRbu5bbD9Y8/FcCuzEMDF2RPbPSysc9vpzl28AnijIunjqJahHc+JTDSayWcMZxBLz8Ie3B3yKRIz1PiLhthKUlsgFlloGuPR0/g0IIXh8oEZhQYz+WYZRIgcBB1UXAsTRLEPF0r2HCWkYLvr0LANY4tdl0CMHZe+ShSsTgznPHaAS+wXa1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdR+uy7FuLWbBvENjP3S2XQaesRPNG7/ivIC5dKkfXo=;
 b=VXw5UeV5m7Xzuln6Yd9TG4sbweJ/hLLTuxqfccIDCFdyiTSPedQrwWN421cbVFJSrJFHhaLEu2PHkoypt94p6PSsNipodzC0tUlTmZ11gH4FqO2rv+l35net63y22GlER67C+a/CVqldDfnFV06w5eVurVKeDp+0M5z3xeYzNn2OoE5pObBNh0iCBF6iZMVdyTBKJ71f3xRJVplN0rY9AnzhL5cpSh9yn565p0kgSAH/KgNJ37uRYLBq+4Q0K6IAzT5Gakmcrw80q52vPBtTWER2WJm61+sedwRP2VSB7XNHfEVZxLfjy6oOiCI4Z76q2uvI6yVgMc3LDbV3/OEt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdR+uy7FuLWbBvENjP3S2XQaesRPNG7/ivIC5dKkfXo=;
 b=DIASophMhYCUA9X9aF/Yq1F9BxI3GkQqZUMXBfLbgtYLGTUsO1mHV033f0qdlzsttnd9VjhLRPe8a0NmlqnnehdsGED7AOQB+4OMww3dM+J65ynwGqdAjIT6iWdoJ5ibIvQCyDErbl7UWWeip1DNprBB6l1ZLTf1UCiC0w8HjHgZ+N0h2zwy4bo0sWJeOXFAiduBVREeqUms5IH93rljwb3CqWs9b0t4S6vbAY8yGZnsCJYPPWSjCHmGzO2+igoBytGz4RaG4kCYRogpM5W8bkKQJeML7OkNmS9zgL6tYAa++3gcGb25V6rv7Vq1bI9C02jMQTlOq8unyni5opkrGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by SI2PR06MB4994.apcprd06.prod.outlook.com (2603:1096:4:1a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Fri, 8 Aug
 2025 08:43:31 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 08:43:30 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH v2] xfs: fix "acheive"->"achieve"
Date: Fri,  8 Aug 2025 16:43:21 +0800
Message-Id: <20250808084321.230969-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0156.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::20) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|SI2PR06MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f93a102-3141-4b22-6dbc-08ddd657a6da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eT222T68T1ZdC1ttkH+iqAAqqr0bdlMBQ2FrRy2XKkLMZAxPqngA3wCEXjom?=
 =?us-ascii?Q?OyrXSwHupqadt3sO8BruU2O0teza5+iftI0YsfvxBzoytwF4CTyrWFynrZao?=
 =?us-ascii?Q?pB6+OrDDpHGN0NcAA2MB/ZK2ByjLUtaz+OQtvgg7UIrWm8FCmpTGlk5RW9Cb?=
 =?us-ascii?Q?TXJlXobSe9BQcIyTjDUTLukjtgs5H+dEB4bctPlNQei+YQvtS8tHL1qnF/xA?=
 =?us-ascii?Q?d/iTlIhizM253YVyjdmzIfHV/KUarcgWrA/C2FoEEZpxe6U3FjJ/wtcAqRnG?=
 =?us-ascii?Q?V9811j2yLoY9YfZLAJqhgCvZCNhwhR4lnqexVPp5yTAuGbyiLQ485ioZEtpk?=
 =?us-ascii?Q?fIJm7RCZZ4H48LqPfoA0ySJabBefEvoOJn+AD9pnK0RNv1N+X6AbcWs7hcES?=
 =?us-ascii?Q?gmUQyyO3oPmKx31KWcDu47iHMe3d9saSwukeTQwTdEqQvH0jUOAUg7zzS6Ik?=
 =?us-ascii?Q?ael9MS0FX0JcQSIiPfw9cohbsi8JNdLkMkCp/skDMJ3sTEBjMifIpHqGdmW/?=
 =?us-ascii?Q?R6blqUsVP0CMheQ0/4a4v5jJh7L+EYLCd40spA+CswA2k+bikgduAcr2IV9c?=
 =?us-ascii?Q?eBMthPskoZ8xb+rjWoTCYuBQFwz0EoAhwr2Xw1o455phBwoOUOAamoUFtvFA?=
 =?us-ascii?Q?O5BjRdL01+QdHpeifbhfan/O3wxH8rDeOUGeVtgZi5QwTyilPxRwQaO1ENFj?=
 =?us-ascii?Q?IpD6z0mHjZY4paBj741sJyS2g1Xnz+MKESClru5T/6E9qoC6hXLQsYL+IMFf?=
 =?us-ascii?Q?feFmCSSkeHm/qANSmT4YnTrJDh/PezJKexgC5SZcBWW93l1v9yxQlJPweBm6?=
 =?us-ascii?Q?+NLFHtn60AgqvpjKC5l/CpBt0HixKhHYLD/opvD2KsxCOWGEITilvE22nb37?=
 =?us-ascii?Q?/ubuuWesZc1H6/I6ouKfkV/hXWlX4Y7vZSXVePQ9wHgacxkn7Rpw7gMjFPfj?=
 =?us-ascii?Q?nk0ZY0rmtGdixVMHY42jZ086dKrB/P3ymAWUC+Cx92psbKc+4JbIKY7yIGUo?=
 =?us-ascii?Q?hQv+Dc6td1jdZiSuSf5C8qW9U23qNRyp9H5WHjNt2w9ugDYyOnVHp9XCLI11?=
 =?us-ascii?Q?KOc7XQpljGWhH3rlBsaaCFpN0w5s2YCb1qV3/J8vgYLFHXgD2NEVbOHnDXlV?=
 =?us-ascii?Q?ERe0NXT0cETx3k+bVg28vocir77oXC9Ixq/jWyJwHgLd5ITDBKWMeWKwDpio?=
 =?us-ascii?Q?UZwVfNGp2rC7bVLadbKKdm3s+aiByYxBXzbHnsz4aqN09fm7Lfhn7TxWKSfu?=
 =?us-ascii?Q?0Twz0DHsc89yBfCkojD5O+lG7eumtlQklNwJL6rCyRwozeLUfdRE/UV6/Dgh?=
 =?us-ascii?Q?hcpcCQig924qD0Yer7E1L6xasYEWGcLjEyjHJxb+nErGOuWetf+bnAirEKvr?=
 =?us-ascii?Q?gSwUJetQgTKCiC9MQJz2MMd7hTErhe0HjKsIQkFgOYOvsyHYQsFxQi2wZwTn?=
 =?us-ascii?Q?Oh0LSuvMW5xmas0kxFMyNeR/tSoTGyfur2jUhiOuvBmNTLK38JxNzw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZSdesVkzeYpy+MXCZeS+1pgAdOrW8IvMJRv+6zWiZ3iOeZT9khfwSP6TjE3U?=
 =?us-ascii?Q?YOoaIotJbuc+Wippm20jNtixYJcKVP4BhFI1IzcIWb16vFsbkdLkf2lM7YdF?=
 =?us-ascii?Q?uP9i/dW/UERYPqV+2cbRnMeXGnNOQJy3jp1q36Zrtd3YXsb0mIul6WaA3c9U?=
 =?us-ascii?Q?QmDBW+NNCodddYxQbSVu+39LE2NXYLOXzbOaZf4bmR6cryDMQHA+12lnJVZZ?=
 =?us-ascii?Q?5fPwFiuqcL/PPbV6zL3kIXHKP+n3rF4hdrePJgDqHsKKc3eZtogE/foDdtdK?=
 =?us-ascii?Q?3/Zt6dUHByXICFXHclrx71MXT3kuEH+AexpAoQfSVLTyo5G8Igk/OPDncAwu?=
 =?us-ascii?Q?J5UE3ZHXVjanZaHDjBrYQec6Otca+a4D8Xx+d6Wzu6DksTLVPfybTWYQ1XDW?=
 =?us-ascii?Q?R6wTX1rEF4ujdTD00vxOqzgLWRjU59u3P6jGkL7IvhBIGwBu9Bwu2cxMZv8W?=
 =?us-ascii?Q?HVzwPqj3EL2GKRhg0f88To7U3CBeeNofNdrQxWFN3SRibQXXLuuKCr9IxPJX?=
 =?us-ascii?Q?2qFmx4MSzIzhMnAMFeU2DOiiw26yZIF9YFagvMIuPpT4RM/cbtbveCvKloPO?=
 =?us-ascii?Q?do2/D2LSFfIJ1UsgtQF+GSoynLY03VyDr0QEwvDL11ieQlG8EjItq6IHJ/32?=
 =?us-ascii?Q?JM7oIuUr0Zpq8kX5p0RHMX8pG+WYz2Xby8B3HaGShnkWPxugeiaf3J9t9G65?=
 =?us-ascii?Q?IhAfH/kVfP318gXkkd7zyl52ulpj2bfD15ImDEbLC4Do4l/O82VqOrsjEyoc?=
 =?us-ascii?Q?l/EP+5y9xMJoUPC3OlnTG/GMu1dclCGqQI4GonhYKjHePESjxxIQRk4vy7eV?=
 =?us-ascii?Q?BdB39UUM+A8LT+le5p6icS7rbucV4CFxra9V17tIxiTih2p27ZgOjC45JSJn?=
 =?us-ascii?Q?ur7E/WHSW7W4Ago0Wt09g3knyzKQGYC/ScTe9O4oOvh+6SM+MkPuqbJIkRRS?=
 =?us-ascii?Q?12cwRgjGNyLA7iWX+FhHauwpMc5VMLjSkWAlY/XXcRh2YgmbRtY6Ow7EMddK?=
 =?us-ascii?Q?RsWFEKn6j5iY6yknzFTzM04ZckxKxdHc01JsuVi6DlCkovHJeQ+hCohTNgMe?=
 =?us-ascii?Q?o3Mtc9mpkipfR42p5Pq7u9VTLjEjZqZplS6a97lHCEN9+q+17XHC9Xv91bVt?=
 =?us-ascii?Q?k0qs4R1dLQLRb7u9EHgR0+p9mdKBgEX85++CTKB1ziQsFc/u7iPgYdFigMSk?=
 =?us-ascii?Q?+++nvz8dYg6Q5DGI1EicJWJqNmzChnyGy4NBDq4P04QEADm/v880JhUB6QAA?=
 =?us-ascii?Q?pXL+RS4eE2LPwPd+q4r82bNoup7QAJmIs+m7CVFGfnEwXfgJqt5cqtAqOwGg?=
 =?us-ascii?Q?JAB9f3aRGNs5mBKgX9NS1hYTXyocUxUaOv/SGw0sRvW6178HPTGsRwSm4z7z?=
 =?us-ascii?Q?gLu4hrIwcxaYwgWnbvToTjH96VTOSDW4gJlzEr4qidVukg51oYUGenMYFusT?=
 =?us-ascii?Q?NlaO2L1U9o5Fmoks+b+gx1f0foEfsAT/0Gt2xZx9Bflf0DKyNXrgjlDlewn9?=
 =?us-ascii?Q?LL4C8Em6MGKif9LduiBJxkKS+Lxu5RQjcAYDmYNYF8prBkguAin0BX3E6rMR?=
 =?us-ascii?Q?4UlluzDSLJXotY/Vp893WnAQHU/kCvY766U5oS8x?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f93a102-3141-4b22-6dbc-08ddd657a6da
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 08:43:30.8442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idU8g/vKphY/Ej+u3pbheW7bBAF9If4rpFvByGdwb6PJp+KsUY6nQqWaCZX6MHBO3RpNjytCbYJJm60G69aw8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4994

Trivial fix to spelling mistake in comment text.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c39251961a3..4c66bbe23001 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1745,7 +1745,7 @@ xfs_ifree_cluster(
 		 * IO and it won't be unlocked until the cluster freeing has
 		 * been committed to the journal and the buffer unpinned. If it
 		 * is written, we want to know about it, and we want it to
-		 * fail. We can acheive this by adding a write verifier to the
+		 * fail. We can achieve this by adding a write verifier to the
 		 * buffer.
 		 */
 		bp->b_flags |= XBF_DONE;
-- 
2.34.1

