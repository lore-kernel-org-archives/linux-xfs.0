Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012009.outbound.protection.outlook.com [52.101.126.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D8C232369;
	Fri,  8 Aug 2025 07:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754637323; cv=fail; b=TaR3tA+ytw4P4t77/Wq6Ban+nbtnFttLOIUIOW6VA3hoT8SKUZ2R25jie50Wxkk4l/Te36xD58jCTDPBZNgtHO/cjhJUeyp6hqU52j9lDllWlwc+sMx+gDmkQEC6sn/P1lBH6KGLLlTQJSz3VEbB74joXv4YHohgQlBF87JDkqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754637323; c=relaxed/simple;
	bh=tBipHRqqAFXg8jRMKt7qJ7zj9sNzcMsXkHU1+m82mYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjXSEJGtFDVmtysKLQ5S7erkRTSVOFzErsvcAsKRwEg83F2JtU+dkYsEzAEC5X/urM4OyRmQ2y3eftA2GCts+yBiavXrOaRJKA3a8/KboD0tTeM3ahA8E+8FkavGc1nKXCGqQiwUCZ8DIrQRqsG6gqExXdZuRpKbBsUJYrQflXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=cxDCClFE; arc=fail smtp.client-ip=52.101.126.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="cxDCClFE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GYsOWaVG0IOQfotIToxvi6mVTz10e2bUDtXiyBfgtWbw/+GErvZFLJW9F7qSqnWqRbyjiJD7MMBEE6XU76VjpuU8peTcRTYdollKWhpYEcHYNXPQDWFT9eV2w8lqWckT1M9jruE15bl1RH9uPBG2XFnGEBHmwb3mFB6MS5DhhdNJFMNCU9fASVe+/We5AabypXsZiMbvH+ly8xTdFKn/hSo5RSMbvE3aMJmzvfxA5gEHZZ//ig28AW+p62i6kPVYM99ZiNo8Lh0Izj7X1409taFvFv6TWDpG2FgFnrgmTAnzXzsGE4I4mPHiIcD6TQBvDbncm3qUGw/IN2eWi5adGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdR+uy7FuLWbBvENjP3S2XQaesRPNG7/ivIC5dKkfXo=;
 b=qiRgdGdhcVzFJeF8UiXHUXca42fljV1Qy7Hn6MGtJVPxrM+M/NfOck0bkf3Oyl5NaaSElEMq59IQpMcVVXp+UInBofEwepDe6gIUfCq/FIM83Ogo+45ItflgiBlDHSEh4pPufM/WeaiMuZWoI/tTHhbS593wTKD/vwSdyvN+RO7mmf34a5xgzgRL5QeojfDRqri6ncks5OHt45hsdi5v3K0ur3ZXSHuSGp8nX1TOVsVkMKJtyy0CeS3N7tjMZgEsDEMmj22C0Qw+H1ImcyWm+KLR0JJ+6zwZKv6a00eXyD36gM+p1z0S3EOaaBHum39YWWkJkAY+WSUn0pfusLNrjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdR+uy7FuLWbBvENjP3S2XQaesRPNG7/ivIC5dKkfXo=;
 b=cxDCClFEBJ4Tjik2nDMLtPMRZeUL+jHLbJYfEIIec9OTPKsCOcpLZ4YnoDCJRz6hp8xxcFItoDS+65Zfmr90Oi8uXCHNqai5m2HUqlfUFCIBZMFr9YEwvBKwuw+xkRJPT821GftvGAIToAQCdZ+ZhtQSzSVMY/ZWIc+7pj3AUCODkFQob+rEImIXomHp2fYZJgqIocg954SKS3W+io0Xz6VddVUPqNL0izAJ/l7XEIIQ75hWCZXMloYL6g3uepVq+E0HxU0KafO+cce6czqvVHtozji9Fsxn9SwjHqGFiBw/V/hcSCptk1necFY5m0wcbPcqDyjgw/6JIfFgDvMXiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by TYZPR06MB6463.apcprd06.prod.outlook.com (2603:1096:400:464::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Fri, 8 Aug
 2025 07:15:14 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 07:15:14 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH 4/6] xfs: fix "acheive"->"achieve"
Date: Fri,  8 Aug 2025 15:14:56 +0800
Message-Id: <20250808071459.174087-5-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250808071459.174087-1-zhao.xichao@vivo.com>
References: <20250808071459.174087-1-zhao.xichao@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::8)
 To KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|TYZPR06MB6463:EE_
X-MS-Office365-Filtering-Correlation-Id: 93eead1a-0ff9-4b73-68d0-08ddd64b521f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BC6zX7p6kYq+mvH5P1nUcvezea3bLWNKzx2iCqLMA3V4Mql94ZAFN0aKZ+fm?=
 =?us-ascii?Q?PYhB1z912Vqab3UZnvFiRnVZNPW378hGwWmXFJVq9TUHQz7wyI1DN9OveN+8?=
 =?us-ascii?Q?rYnY+S0QGjtyVWZVceXZ/frLnlb3/guN9kEcgZpBuAiI+LABEyNYIW9b8tBS?=
 =?us-ascii?Q?MJTfmmTv3kyU29uxNIjbEMqFDq2ViKnyJG39ZRf4gGBo+6pvTRcb9oCdAATQ?=
 =?us-ascii?Q?NdPDQHChRokqJ1TzRbom0fYDyJvpLMTryzfXRfRq/794PZOI131GVUVSuUE8?=
 =?us-ascii?Q?5a3ytIpY6H7jAy+PbnKhnPngvXF3C2OsyGrfSPIIY5E7TVgyvP+GNtwxlAUn?=
 =?us-ascii?Q?703n0ctFBPFsluLpmpgfPZpZGN9SIRxrznokHrsJCFBlYmq8k4gM1uWrT3i7?=
 =?us-ascii?Q?Tn1g9cliJgHxhUJUNu95FxM3n5/URjJZ7lAdgWAn/e/bGt7shGFvCcPIzgP+?=
 =?us-ascii?Q?jDvy5PhwWibMDfj1USJsJdo+RKS19C8ZmhlnkJIjpJb0VNZ9K4/r+2ML0kgW?=
 =?us-ascii?Q?bT7F+2/d3bSlox+6ZEdbVamKESK2Abkzcszz5HoqtnluxOoKU1rpT3C9mYRl?=
 =?us-ascii?Q?FDpUVNfFSQjs93+N2FHzA5I74BZyW8sTPxjV4JZNEOWXP9od8KriMRxSc/FA?=
 =?us-ascii?Q?UAUZe6JBVMjKRgd0wLw6gAq4O6BZp14qEMzlOYUrpSbEE0W2Vj4Vrz1VlJLb?=
 =?us-ascii?Q?zuVMuHPSe8MGZmuk8HSK977pAkKTRwyLKlFNRXH4X4K4vud9XdRmlK1TzH+v?=
 =?us-ascii?Q?ogXy1R8np8v0AAsjLzMAah+OoP1pKIM8DAzwpzi3EuOCnDZBZI7t80bYuuKI?=
 =?us-ascii?Q?6KNF4tMAOauVDnRxvJsfwB/49Vryd7XeQivg+tpMOhq4AjaAEp0PwKY5CZgp?=
 =?us-ascii?Q?A6DXe87fl0ZJ2VKw5cVcBaFLLJZXuUWys/kTOpHpbvJjNlEkeGXbklHCqKVS?=
 =?us-ascii?Q?A/hrA/q/nN82/d2xo3Ywf8+esyPxMEgAT6uNrk5n2tHtewDi6D4vn4xIv8yu?=
 =?us-ascii?Q?veJxdQz9N7KSRUVmWWfSvh42nh+I5Y0lVIZ3SCTJFlkoY7wGJhDQrW29t1Sh?=
 =?us-ascii?Q?cwxBCfS7iRBcM/2oJMA9C7uosQ97F9cAN54Gqlfr0J+0GRsLIT98wiPfxKha?=
 =?us-ascii?Q?0QWYbaKBxFWvcEoN2JRY3nxT6neRsaE1jgBGQChwBpH2c4UOyzOhK4j/j+qc?=
 =?us-ascii?Q?8FUREuTvNANhczTkJlFd/zlb8s72h+fbmGNzzUubhkb+SFx/hMPnUqS/n7oe?=
 =?us-ascii?Q?uDMu07bwxEmraU8sU1lG32KVOGCyYI3Nw/A3y6dw5Hd1Rod5Y17oppvckSnl?=
 =?us-ascii?Q?kVs7WjZXkoZ8/eo+Inizw0xOhBuBaR18rBpEZpkUlSIQcQJEsO16m6GhDeHI?=
 =?us-ascii?Q?+oeHupslX+YS0uIoK7Ff2akh7pvtyhOR6g7AX03iXiQHyy+neFuaTGGsVd+o?=
 =?us-ascii?Q?GMx68aG/hrersFI29h9JYTCD3/T0WtQOrb1jSvnIyxhPxdT+Z8lmrg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KSnR24JaQVvQQB7x+k7qglCVtjHhcZi3mpjmMzszugzIvdowaK9+QvAERLDO?=
 =?us-ascii?Q?TYoU0LJVuRsZP2PDamo+q3puver/2aVNZ8FXFZn2Ox8AduWxG34d7U3TNPHw?=
 =?us-ascii?Q?gsgfVXtw4/L8Z7/UKyU5PResflAbIB9N2jv96ynmuBgKE/NsB/uJD5ehT7Rw?=
 =?us-ascii?Q?BVmX54jy3WmHUnmvU82yws8+eQGiDWd7E0HIFEjPVGaEHV1qgF5pV/qicVpp?=
 =?us-ascii?Q?iu9WbXBTJSJdldhShIPT0qe5GmRVIHxqCiRrZS1h86swFx1Hib6cgm61MYh7?=
 =?us-ascii?Q?x8ZnbvT+u5OE4G3HmGEmbWQDuaCbQ/LRhSk1nx1QY5PFgSiTxvG1tczi3GHL?=
 =?us-ascii?Q?7hAdesuPo8W4E+pC1EfJYiIXNgISrT1vhJJPTh2STbU46/kA5SdCmM+X+uv4?=
 =?us-ascii?Q?rkhkKoTUUejapeAsmK6yLWbn0BALE2fjKGShOYTEYWV+fU3CPRGql1AV4pLg?=
 =?us-ascii?Q?jKOTKd9mG+G9pwr4izi8RD2E3v1tt3QfxvRXgPicK+iTpw6ZP+IGMhyqWi+L?=
 =?us-ascii?Q?8pfdk8e5NEgCpsnMOZ0HeGU+dwT4oc6stdypftNHIFX1/Mlwy/RTWq/YN6Ui?=
 =?us-ascii?Q?D+6lSqPnifO3rcmJp+OLxbnFPdd+rFEalSjsGSBIWn3WOCZJ9yOvG9QiFXdF?=
 =?us-ascii?Q?FYJMDUV4I52rO34/SY3d436jk4Fjhxtnefax8xKIEg6ow1qWt0rZHMFzB8He?=
 =?us-ascii?Q?mTh7tM09qH0Ejsy32N33PLRZ8oFDE4focIOMYzgH3H2pSDyV+wQ/3TZkoPxt?=
 =?us-ascii?Q?nsOhPjA3xmRiKNC/qiE1Np+lzpI8Y4I6/aVPqOoJfIOacUwgOFKg/4gB34DV?=
 =?us-ascii?Q?6/1WDxSBQ/qcfebRG0uU5yN7em+BHESFSePDpVoygXIZct54pF7CAwUHJaIw?=
 =?us-ascii?Q?LSt2udczx05lrb5TwegvNC07hdYVDx5U0McRt3WtWKlmGmD6q+d/DTXoRpX0?=
 =?us-ascii?Q?E4mdsBvnQ8ZGuGNiO6ZGLfuxf16XiJM78UVX95ZeyRlHQ2x7vg2bnOlLfHp7?=
 =?us-ascii?Q?PO2vokZMmGj3aBOH7+W1L4MwQiBuK4KQQV8pvaC4FRmlV/liQ7UgBIrdlM1h?=
 =?us-ascii?Q?NiV4VRnblw/n1iBhGrFOtJDAW/iiQObaFmGemTmxdyCZB9cI0uJbwBxuq8R0?=
 =?us-ascii?Q?brE8S0uxnWh1x3tNkSFR3g0uE1Kz/6pM3Gz4nYM9+NemInzzg7ohbKl6uIy9?=
 =?us-ascii?Q?A/F8mSuTw5NUNCT7eEOF5bVpmUNNvs+dUAgYrqvGRLTGvI9wiKTySMzJDDdP?=
 =?us-ascii?Q?dBU1tTJ5egHh5hX6PEZSWEpn6ZWUurxr7ZSVSQ16d5GFlxuxEzCEcQhz9nVe?=
 =?us-ascii?Q?Jc0Dsne4PO63m/ZaKjCrLjvLTDjehfoB/BuRrfAxzzLPtSR36Kd2YOOORTV2?=
 =?us-ascii?Q?2y3Uwbs46r3G/qaU+9jCHW3hcu4p5gYMApVL+lr8EfETfcRvllFS8Ro72sJ/?=
 =?us-ascii?Q?/Brg/sHLFItAm71IWPBhted4sF1q4F4ZYLr7ZBW50i2jzbLx11NvR3hX0MWw?=
 =?us-ascii?Q?8F0OHMO9FgUhJWEYA4u40byp1kzrG041xcI75KAIM0PiZQHCjJytU8XxEaGF?=
 =?us-ascii?Q?L13FNfh3ZKQCKdkCLCVq92VZZnEGmZM67Lm4fA2N?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93eead1a-0ff9-4b73-68d0-08ddd64b521f
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 07:15:14.7883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73F2j68YU2u+9Q+PrheHBsco0h11cskBCTVZAh/JxbOddcLxBtXU9Ih42TGE8qVjjd5+uiZYjOZEc4pQeDyf+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6463

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

