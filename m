Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832883D88F0;
	Tue, 13 Oct 2026 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879324; cv=fail; b=fyXz5Q8bdW0/67PSqH3Wp4XZ9bOQWeXeuMaUTaeCyYfpAzzqCPYpDK1YXWu4IkqVTdA1vp9296CE93We58iR2njeYtbVwmIF3CuyvI2eULJE123QT0jbQx40RO9qfG4MuOxMeCSRFkdojyo1aFbg8IQ/RcEW1Gn5XobZYm263JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879324; c=relaxed/simple;
	bh=nXnaWiMhrm3ZxgcvIq9cijtpK2BcssziuPFx2OQqc9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nyfruMEUTyNAlYa8jxO0NCysGkjCIlEokL1+ymAjDUHOgkS0RTerWsraAmD3ucupFW9Iqy8Vx6iOdrJGxFnJVIHwcf8InXxFFEIihO+7igDGneQ5M0vHxhBrEVD5aFFISTJFRkBskpYlA+GNajRdLJ7+a4PkQ+G/+wialXAiDE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kgc+g29L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xDKWZrtL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kgc+g29L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xDKWZrtL"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BqMr3109942;
	Tue, 13 Oct 2026 08:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=; b=
	kgc+g29LnEN/c5b4MQfdCQdb4NoeD+YyydGxPmTNL142wzW6mYi2AVzSGZTIchuY
	uWHPQVZ5YvJfvEVCnHl0RMmokDakqz1gid7EMCfdZqP5navG2bhn87x//vvulnZC
	U6U3zuFTJ+3yKiYI2gQCzeRcI//J3gdglHhvk8pobgEXR6Y7QqaRLZ+RF5rbTgII
	0iQ8963lwrW2s4SBtoSOuwYOVJwAXVTD90tqcGjyIHGbLJ8CbWH+1sT0Qft1BOrT
	oLbKxTlXhjNaYiB+f+2UHfcitxj/q/KL4Z40+t40lBHhiyKGvsmMZM9uRBtiT56O
	7TKyxdfcslMq0XgfsFcagg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hjq033504;
	Tue, 13 Oct 2026 08:15:19 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btnxru6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vs5YX/N6Wij6vzUBloBlQw1FOxIwhEHUjV8SfZC7E0ovb/U0U0DPCxYBG1jsPmYX1CgLbcyWCcQ4K7YI27ij2E20Lru1qKr9lKH3q8qf2AJj1SwqI28OkOGC0Kzap5XF+SCSSgbuxByg5ST2P9fGq2gNC+HXSt9DtM3MUG03gTSTkXNT2stXrRD/EyNvDH1/8tU9br7VDO8HI9QNgKHBLAI93/3HRShdGtCQUL2GqlUR/cX12SUeeLjojEnUrEULvDb7wzZWEnVZgtoZEeQCUpc8RIeS0HCL2ubq1dJg/JRTnbm4q9QNGjobK+VL9kq2nDJ+jL0XTwctW4nNd3PAQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=;
 b=j4mwvfWuVKxvw+lXtuXWvwpV+d7aHJEr6QvgNvgcqpZ81jS2pJXM2eOSjmtDRQIMLJML8fYz4/a4PoZfnxW5soN4uggoScNOgG6gFM2nndHYFJI+lWbx/AjwA/gNAS7b9vuAOI2iy1kIkPi1qqFfXfFIi40CjX7cwdtlQLNHAvScRC5uMA383K2bjHUCLNf4tqUyxGJICgG0Ig/o4mBOavH2udDcNcdqFuTjKQlbHrkjAPkn4EDKvREwj/LEu3OPm6F+pCVoJlWuM7kk3AAoOsCenwH8H6fd5FgibT90m3wtlDRjledonWFv3nrDJy4zj9vw44/JQFi3Xu9nHVOeWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQiAUrjCanqx/q3uMtAg8xUAwEeSX3fhwvrC/aSGxFI=;
 b=xDKWZrtLFSpGtHeEEDORLraFNoO1a21L75H8r7Sz/h0Mwj1ezPKgsKGR4TcCQ6zJD++DPRRBOYMe8WgjXbhqWanwNbCrpKR8nVKR28mMQ6TgTKhDwo/ayjcvcDSwdcievu61RyJJPi5tJjUCh9gJUVlUorPLUMqA8N/COAekHQs=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:17 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:16 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 02/19] xfs: improve the code that checks recovered bmap intent items
Date: Tue, 13 Oct 2026 13:44:46 +0530
Message-ID: <f7f261c7d47f6aef6ab7e7225825211bdc719b7a.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0051.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::20)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d36890-abb4-445f-db13-08df29021d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XWngFEUbahr+vVz0x+2B7P1HSJQWgyezVbK++lIXSOQ+FFhfvbjiRx2s2B9l92J7aWV/nvbF4YRHhEXTYWFr6exmtSu2zn2tRw3R/lmbuCoTRJ0xPloS+SDoLRMyMXWGGdjZRZzubI0o2q5ogM/RncFOTyJGVGuLud9DHBkZukWLkEp1lE1COW1LuVwMgcYj5Gy258HmAZZS5DkeH3d8OJsPH6duheIfSkr2wbJzD0XlQpmpbKtI4Jb7B3RX3YtuIH9tuxllzrkQnvHngnCGqR2lX9ctmqop/IZJNsxCW7r4F9+15mpdjz6Oru2ST+FliFbVCNcQEoORS8lr9+qMCGHU/Z5GueeVvqkkUAXSaMF6EEJYLiZxkIcZQXWIMHkYsebYSm5cIMxqTcrYUdZDV167uh4K+kD3b5UIEFFS8D65GcthQ3w6EPNB5ooHRuLNFjgqr5x25XxyJd2X8JWz+SQIFmO1+Wcdn6GDOX6vAMkQUsxfJvzIkTBDcraG19KIoDU5/gYAVn49haJXF07kYUkypNE4hk72yqPXq8cRHhyM2lVGSMi693XHdmxHgwUSDhSOh2Byrz5Ew2xLSpbRO5EI3KkieF9LKZDNWLpkrIJN2HhbpUANHtSqEB4uVmhyJ1AkfiZRJ+BUPWZEQjJhc9EIXqZQ75orEUXPcaIUOhQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rli4qveKWTERlCkWRVltJ94G/SAvq3bpiY1w6zbahOIyKqEImtHRe0zKgOCz?=
 =?us-ascii?Q?AynJ7VfDH36Jg+SitJSw4hxBFs+5t4xejbB4KPEYwQ3yhqCeeY/3OkoqSI7o?=
 =?us-ascii?Q?1FlGe0CxLFbySylYi2WSI35JCf6B+SpOzArAiyoQ2eY3+JCOQBeEM6iheQbO?=
 =?us-ascii?Q?jcN3CTm1WSt6m/B3D5qZKtLC733a0pNNaaZNPDayGBM8yt+D6TT7B5I5X/YM?=
 =?us-ascii?Q?23o6bHwR6iqucFYykm83YGoJjjmJARnpDf3TSokOMVlmPydUFU1qITdfLE3g?=
 =?us-ascii?Q?5IOS1yP0pF9Je+WPi4OUI6k1SBDYXAdntTS8/Mu+GZeHUKtVKHSFrh6Isd7n?=
 =?us-ascii?Q?OfR46bdD6eLcJ3aCDY7HH4XIfZpK44t+J2RgRTBynDlRmYBQ8lzC4ojk6iL7?=
 =?us-ascii?Q?5f7Yv+yHdtR1+xGBlF3NBpYisZ49XoRqjtZudGGELkKHDf0PjA7DWvy9WOiE?=
 =?us-ascii?Q?aehD9ThfWsX0oHE8voeR9Y/oRENc4faPcXbH9Yb6LLlCNzZ/2sH4C2v6hJeP?=
 =?us-ascii?Q?h/ud9tBCfFmfAMhC0Fx6pyIIcSOAWONvOcub3PtPKFnaJ+e4yt/J0oFm2aXc?=
 =?us-ascii?Q?iIoe+ZFJE5rHALKbmwVVyoHVavWp6xJ0NjLkhXrv+tiQ0a/CAZQNvEvVsyXE?=
 =?us-ascii?Q?B54RnjRFxOky5l7Pg/kI9scvbg575kCHDI+LNWCvyfzzeE/hKcMNN45bAHkj?=
 =?us-ascii?Q?wljQ7v8l9a01oudtADfqrxItRNPI0Bry1coJB53bC7beJl3Fd6eqR8xBwA1H?=
 =?us-ascii?Q?8cwZDvLVvqmsGonnDHvMVuzMMOCYYZkd1n7qFEoZ4EwbxroXORpeM2dGc6LS?=
 =?us-ascii?Q?vkz539FFHU8XP8BTjiYw3bTqnkdJaAih3RuQ4NIo5pmPgbZRdYeWXa6LtXT+?=
 =?us-ascii?Q?LBGXA/RuWI+O0VOMDJox5KkNy9NvBfJJ7w6WHLvmVZFZA6/ZAxOpoPH0T+7D?=
 =?us-ascii?Q?oyc9pwXb1LagA9aF2Fiuc7G2+wi7Fe/uXg4DlmuZzvOOkT1S3t18juLQ3JXx?=
 =?us-ascii?Q?/a+tQlhm8kZwJkpUGtEZgr+ASjXByAR2h2R063oHGzUOrx25UWHnbhS69tYM?=
 =?us-ascii?Q?K+toKmg62HjM8Vy/93yIQOXfJ2lI1zpWgiOM240zIxOY2jEg5XlnzfmHC36i?=
 =?us-ascii?Q?LDHSH0aTJHGhWyz3urnGXmjH+CxWjOPtcrk5EeksXMY3jcBwDJA/TAQZnI1c?=
 =?us-ascii?Q?bSURmBuWr1o1e892wTpHiLZzateGA5eEd4tq19k+zGz90X0Wz/mfbNGT8u4I?=
 =?us-ascii?Q?TSIFJTIxhRtyCWAbFH822j6Ofvk+9MFZh0wdRyE0I30Ix+GB0hn3W8Ug3EN1?=
 =?us-ascii?Q?H6Pb5EjvcplB7RwJUr8n5aQmgy38C3XzyAWcmhKtrRBMO2e5vb+Be3X6D5ou?=
 =?us-ascii?Q?VWj7+PK9wPDGBKlBr6PLHcgKfLefFwmA8hl3fmM01JpHzwX14VYeOq/aumpo?=
 =?us-ascii?Q?uihtAl8rNKKqjERCMxAYM2ugsIqu+0R1gUVN9lEdvgEAgTzuhykTE0QAnap+?=
 =?us-ascii?Q?LbQXd2si9paI32jS27M6nO0OQKa2eKjP8A+ae3WaHfJPazzD1/XvZV/C/n++?=
 =?us-ascii?Q?sawjRzaotaMfr1CbmEIYgIMYivsJx5o6Uyaj+9R3DFPA8IFX5U8MUH+HQzL8?=
 =?us-ascii?Q?4BBlTfRg1z+GlLgh3Smfu7/CJFqalTcUVey31tOM3E0rIqGBA23j52tPjULM?=
 =?us-ascii?Q?CFIfVK2eiGb+7r7RswbCiYvDZdnDO2rVZ4WkQ3x73qxTHQKNs0uMm0RYAdIM?=
 =?us-ascii?Q?9b91wYj507X2APZmkay0/aKtNT/5Zh/kDNpeCnWa/iQ9/douIgx+/N6KrV7S?=
X-MS-Exchange-AntiSpam-MessageData-1: myv5a6cKR+0XMlDd7KVRbBd2ssuVY8o4InI=
X-Exchange-RoutingPolicyChecked:
	108GeH9KgCb7XIrMarqIQ+7z1aDK6RNVlfp6KzP1hY4b8wsMEMwj8HuMPlQBOtXic3aawXbEcHVOPgHY69VQfOCL2rICIgbbFzfQFlJzxiXFGudn4vX1Ao+ezA/x4druClae11kZKRE90cJai5HT8+MSzvui9HJD6xnMldQe5E7s3L8eLWw57i2IzGeBSOMlzYVPRMgHmxKRT+TDOdRLIT2G+ZvTOC636y7NwbsNbmdcWOwMM4gQjW6qrFA3a9pHlVR0dFixmH2oHhSh6lF70AHUUD1PuS/iYe9dPwynbDNQWhASA48ON6L1XvfHx0+S6v0c0ynzp8S6z8bipshmwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1B5KQDoOp2l7pK/gOxw/hE2dLRUoCdRnTikiCXbrxoP4eQRVAB4MX5WBK93KUMX6foEPR+rtNGWZZMH7FnW0e/GeYoOdU1oOenw2UaE14L9HRuQk44yLtP5EXr4GggLAArZtgNEsp2VBA+8JKqmapFXSl8EC6BnqQ9W+0VKdreSC+8etJDMyA4j3yXIWt5DjSkRfCeTgRJnsoNY3gQx7yv0zoryHJxkjuGBtk3w/5HkcjeR2IU/Im5q6RKBM7ocKsRELMbsugvu4M6z1g+BOel3gcthxhw0r/HD698lb+HsgXYPpZcjmCCbfl65/e2huaVsJiMcF/A1YJpB4oQWX1yUGUQJ8c5fy3aZ2E3WoMhzJE89j9pi2iaQWet4Ny27YRGcKbAh8KFIprSIKhS6Cd7UIF1aHM1IiVf1HJCxno1LqlMB6ZA0HZhKhUmnrZYaikeW3TWy789TfaBX1+4CdZlh6ED8iEfEKtVepVixSdOY/BghiVTI3m84rGTjtwp80feE1MbY/VzIxZdWJSC8SxphPTXOjsejxfPCeQu3lUy7JoN9eUY3wE0wloPw9yY3O+foIi2efw64g+Z8dNZQ7HufCsP0jG6z1HvdiAwKzzjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d36890-abb4-445f-db13-08df29021d3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:16.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFuUtx4UAqhozkVp956H/aRQR7Y7+11Z0CvSpWPxGY2Hcw7WJdFkqMUbJkwqMnp8wKhArhDoBCcToSv9S7VwNLiaaaq9jUhjXTFEvFXHlaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde898 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=Ye-bxb6B3qct8UqmZkUA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: ZGa94Q0t-rVV36RzU2NMBgn3wiRZEWof
X-Proofpoint-GUID: ZGa94Q0t-rVV36RzU2NMBgn3wiRZEWof
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX34HmSQY/8ugT
 Ak9DHAvgun3ob2bJk8cpWjjUM1uMP8qxKY3HYo6hbTL+7iGr0rh/KEHl5/fiV67xNKeA/ca2YSK
 sAy58JneyKkcn2mC2HW73U2RBat7KFEv39cBt6Hza6d44VRtlwT3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9O3Ylcu/EvSf
 afmxsmhixJw78qtUWKv/qC0+FEj2N0Up0cjxzAjQ5Lw/EhywkRPKQpDNB/D+n/SCgN40s47wg6G
 TkyhVHY+dY0/kqfvaGWI4jQ/MK87mHSCZarAANjk8Lw4rei1+aGbizy6ryWSbGf1eFHE9N7ggJ2
 shOB+SN3tV8shq1WS09YBnan+lhXXTOEyx8Odgb7xdMXEKc2g8slfCzv3IwgNRzKK+UB7sb7/Z9
 IC5RzfruoXQyZ+mHbC9NEeSYzpvTB/OueaXX3WvYCi/50VDpVubZd85Ned90yHAo9ZsZ7AW95BE
 YGAuQPW3RYI57z6vVEAdQyS71JUUVAIaE0GX8h3EAhDttSaDVqE+gdAF1WX8ROIPC/ADGKY+rbg
 AA7ZKebfu+giF6pv0ardtPaPVdVzmJAM94E4+yboThrwWS2s5qc7bxrrIQnOIzfGpjluaylbhD8
 tIVzTehlZ+PeHKKoZKaHE+iOulWtmJ3XfB2GrGM0=

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered bmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit 67d8679bd3913d2c4ec5f32ade778881b93af766)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 88d28a862f52..5f1c2fda8e4e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,18 +425,12 @@ xfs_bui_validate(
 	struct xfs_bui_log_item		*buip)
 {
 	struct xfs_map_extent		*bmap;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 
 	/* Only one mapping operation per BUI... */
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
 		return false;
 
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 
 	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
 		return false;
@@ -449,13 +443,19 @@ xfs_bui_validate(
 		return false;
 	}
 
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+	if (!xfs_verify_ino(mp, bmap->me_owner))
+		return false;
+
+	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+		return false;
+
+	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

