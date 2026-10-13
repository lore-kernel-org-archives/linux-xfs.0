Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E23E3AEB2D;
	Tue, 13 Oct 2026 08:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879244; cv=fail; b=uLJyJwkHVlPDSXdUZwKeAiOWA6vZjNjWOUwYIyuivhJWPLS2c5N+4kDrs3nEJRxAVLLEgFDZ/x17w9HyFF/kC5hcFPPlk5yH0tAuRwoNFebRWJpYJpjr2MXQTKGUOGWP91DGQGIkHq7eIcHH5RHGJzgnaGN2nve5GkJCDpGTwLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879244; c=relaxed/simple;
	bh=ovNzdCLyjOI1vKAxD3SR+VqG7tmjFzWY+NOQirvDrIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P81VjjZcgdbglYhJhqToshQ92J9AIpXO+3MxnEr8jygyOtMwzpYCqQQ46Jx1Ky3I5DCgHBP+Kp9/r1wlrC4hSu384cE+upaTaUbfDg+zwsoFbOJmBe2FDv+KTCk3jOeMImUpq3Qh+0OrbkjHmAFIYkKchUqGkFXIMN8mq4Ye6o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EBQHsTfk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CFDdcbp2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBQHsTfk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CFDdcbp2"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C1953200799;
	Tue, 13 Oct 2026 08:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QjqlkrmMmRNc8LN6P639Qn8Fzpn6V3eBuO/XqkA3bBg=; b=
	EBQHsTfk1jeSSpCIw2i0vdg1RpLZoy+QoOwkNgtUyU8cp/EH2VjqVQC5fxPpUCef
	IQkc25xp+jRKAnJ9EZCsWArFDbYPpiEiSxY0Xa7uCd18S8ZdpZDHzdqbkv8G7k+5
	hPGF8pIYJYF3WjC3+Dc+quOvy2bWBMHy4w6/7TbZhDdqKTrG6fpW6/8gDXZACTT5
	u32ZE5DiDrvwRRarDi6gqTDoMcrrANx1kBkmwNgcRBTVktMpcNqNCH3pOLj65IdQ
	SkcBKidq/6TdbuJuQEeMRvFWRt0scTpR/Mfy5BAF8dWrQKX8jz3AMFpaXCfafIap
	Q7xFirqmHlAlBEFoYaGgqQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86Q8X024991;
	Tue, 13 Oct 2026 08:13:57 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9aqmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iP93CmZPazPTinL6O0ZI0Y9k/vuV7WjAHDR5p9DN/itrCzIgtyFj8Gq+MxPR8M3OCSL6SeWr9xuz51wn6MUX+YCjMtBdxNJzR0uP97ZCja8YGndQ1cKwbg9jRuggn/Iq574b1XWMcvWBe71xWDHTOj4TQhwIzmjAhJJy+a97rqQVkBsD3ldRXNmf4x6kw3QdengkRgJhF8gfgUK6GxELdwQoRPQOe+HE2N92PPzk+yITC/WskQh24vGMKc5qe/A+zlu6TEThtytgqhSCD0k4IGyAfeB4PPdqfKUScEz3WrUD42o3tVAkBKv55YUyfiduXAcjtD7xkCmiBiymwn+YbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjqlkrmMmRNc8LN6P639Qn8Fzpn6V3eBuO/XqkA3bBg=;
 b=e/OaJ2QXQQOfcww/14F3qCOrHNAADpt1o6OimdMhJaCvTeEqOLX5d0JD4hoalygsaZHNDsbCy4oYm7WFMWBAmco6dG0JEzfID59dbQEkxplbgIkaUQ4POYTz2ZqKgCU1S4qFyRyKb91ixbIMiXvxnxj3qtlbH0YUE5gHrY7DpSz6+z1quE4gKnHEyyovvhrQarJA6y+pFXUIrp4SxhuOVszV54nOQHB9VsQ5q3nTnTQKvG4yqzAsujh7i+TabzAt5N4trJdIhxKr+7YKthj1NCZ3AaXyI0WQoh/pPaXxfeAd88ecnAhO2D00H9ZGg063Xf20H/xPeLlgrtWwqKG+sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjqlkrmMmRNc8LN6P639Qn8Fzpn6V3eBuO/XqkA3bBg=;
 b=CFDdcbp2HjZbqSq7o0R9ABuqQ+edz8b9zDrtO/4wmlYH4I9u14WTcuS/1GNlM/PVZmxcfUmJWeOuyI4rEJ7lMPqJQJIz3ZsJzJD2CKZVMdBeFOOUCUsLl+5zuTpcSLMrlZugjXL7epi8BB+tkycJHmQ5g3LYucQR6vKjwGpP8ko=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:53 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:53 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 v2 0/5] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 13:43:44 +0530
Message-ID: <cover.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f48240-1d30-4f62-ad6d-08df2901eb97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3xAhFiTwl6mWkLUQ0zNeXYnoyHMeh9aaUtFpZLyVxsBga0M5ljC1q+SpEhMIWk2DuQ+wkbiU9eisB6hXZnJI2eYQA2mRsjF/0r9uE6cSUx0XmMVLpB/ipn54AXN/6c4VEy6da6X2oaYrAh16pvygMCOuYF5A6YRX3BZC+eKtdJxbkHJVEGrznFG5Q1N+TN+1/V4oBmgMsG8vAcSQjs1OKL53xtHx5TbGG+Je/MlBCb6laSsOofQ4IsefFG085LhNIPmTu+jmqu1wChfm8IN6/e/3mXrZlcdi/QlOSezmfwowXKq4Oql+fQnWDtDFAq9hJgu+1C2MWPG1v/BVLvr4n7h8HYWk2SFcZFJ/vKAnjtTzMh0I1e1E//mkdrnQ3+0yQkPzWT3AuGHPhvHr7axY04YJgYpGQYKLK5bye+KSvjF90/9/GQaFnqidqFM3mvihncFOod0tA7iSQZjufr7O8yReGza5sxskCrrCtdidvbcAEW7V56ZIL1zSGBZkwiI4y+auqKp9rkCjdYOHHaTJ6sKHVGXUxg5h2XY95DyGXHibkOt7ZvRB5CYPMtR8Zkxlb563LSTe+WQRr+mT2VAtX7by47AUIyYoVAiYJTqGavEKF2/M+gHutYjyDwhmAO2z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5jQXF7/P3u5enM/ooTSASkxsbSVOLtZAc0ESbUCkJCY07h+XJejYB/zW2HiE?=
 =?us-ascii?Q?3t/HDoxZCgfDJPhexrvLa4+qEcblw29Y7qkzz8LS2KIsV77nrxdNxANy+0Pa?=
 =?us-ascii?Q?yM92rBU4DtVwfuWG75kdYdvE7SzzMeejktzvKBkZNe2v98FfaiKmeaNlwn71?=
 =?us-ascii?Q?gxzHE5RAMfrejAxr0R7YEdku4wdvFfmM9lP6U6xnXZ1SjaHv4zp+fch1J67r?=
 =?us-ascii?Q?ApOos9vrc7ALm61rHtqBooeETDGEM26HtILhQO5aHJbSDbgF1LDXSutiZ7cp?=
 =?us-ascii?Q?H1XwNgXG4HU5MFZJcnflEs7SdeJIQdUwxd2/+f9+QLCcZS/MESfTgJq8i7Sw?=
 =?us-ascii?Q?Rukq7mjMpsV4UYRibuoERorqFsLK5/oJoguLOl4Bk21r817lldWZkooRmfXT?=
 =?us-ascii?Q?N0T1V1pGOT5Vodoyacw/qDIZOsHAhWKXQSbmIK5Xl7vsoq8Xc3Im1eWMW3zU?=
 =?us-ascii?Q?oR78pnQ9bbFtC9d8OeTgK2ayuxBD0k8+SkELPYMiY87T7aoz0MjvbKsA4UNQ?=
 =?us-ascii?Q?6OeUp4Bi10H8j7ud1rEQhwKJwqdAtHAt9dzlbmnMIF17rAIfJ3mOtuNgr+p3?=
 =?us-ascii?Q?/gW7GqAaFfva0HI6WkuJ/v6NxaJvpKbvk35IY/sose7VMBWIHOSWoiUIpF9a?=
 =?us-ascii?Q?wIkuC2yJwPdpHgehbOTQC7Zf7dFtXBATXDtdvu5qhiCux4wPu8GAicXfIK/f?=
 =?us-ascii?Q?Rdkpa6b86F4RUDdIiZbdpUBrRHMNmRwPOmZ356shNwPqtcIhvqTyzpFBldv4?=
 =?us-ascii?Q?SsUTBFptkk2QAV5t/5OBl+NrjJMZrOD4kHgLWi9eQJscdp09j3iyEepQHtaX?=
 =?us-ascii?Q?F7znh1xY4gW52jvDnhh1p1ONPHppZoEHAgnI2OpF6c0rRSL5xPLRrfyFdsKk?=
 =?us-ascii?Q?MB5M8bx52QWEgajveoySLWrUDzNdAWZNTZzBj3UdDfWLwUWximtpYQbfjk+8?=
 =?us-ascii?Q?NgvWH1FEf6qSgwVbZxgU9mWHcjfz5qV6KUOYjNAum515UJUMzo+sMcYCBQGx?=
 =?us-ascii?Q?xBpLEIOJzMaSbYbCRDxw55d+SPBKXXZvgWfacMGTSlJ++Nd80Od2s5avwhqH?=
 =?us-ascii?Q?YyKhUhQzjOvEL8/Sf1dVMqQy6TWHa3IBuVEonkK7guM6ca/VBumh3ZwrBl2T?=
 =?us-ascii?Q?60r837SDTKJGGXeDCfNZ8FO/EG1/vlcF20pAjBt8wytzlR8DB1/bnfwx5fT5?=
 =?us-ascii?Q?nPb6dDyM3aL8AucBDlECnbheHNIl16qhZPDweRfGEncaYcVHySMv6vBAECFR?=
 =?us-ascii?Q?BrdgCCjmLMSFXibZIVLEiV66UwLhkyddgmN0YFFrHPQru/2tJxI2plSQZ8u0?=
 =?us-ascii?Q?3py4oLuSTGUzrvUeuNrc0Z8v1eKTMjIg6jokUwocmEjEU0h4WnCKF2f+/ZY3?=
 =?us-ascii?Q?/nB45NMxdec8m92tHYRJ9tdzVoKrQDqtDf8bz//nVN3ZwqK3VN49404IPUZs?=
 =?us-ascii?Q?Z7Yshwtx1ma/4nQo16eRyiVewHHu4Nun64yTFdZ5JNuxsDisgoT772IM1oe7?=
 =?us-ascii?Q?K2ewlJV3E9yx4brFPMXGyiZ5dgIFJVFcqW30ZkOE+0FvaJwqD9MLjrnvaxk7?=
 =?us-ascii?Q?wqfEIGYWjFaX6INbnrexeuMM9zFHE/iJ+bMtaqGi7pPIoiu6tHqcl7kEgDc5?=
 =?us-ascii?Q?xWkl/3OdC7H4X0TqNbDL3EjDy6B8AVldKdDxCzbaRizBu6UA2tpRKXSqIZdU?=
 =?us-ascii?Q?SIIV1e+K//DQKas+4R0jiv/e9sHBOepuB8sT8k5DmptpaJ4k/9O0nkF8sQyO?=
 =?us-ascii?Q?zSOjmeEwLC4EYOkSzR0XLpcacf14wJIvq6qylXuo6lT4RfrZakzLMX55fvQg?=
X-MS-Exchange-AntiSpam-MessageData-1: qvzB4oWALxhXRb86ecI9PfDeEiwlvwPt2tI=
X-Exchange-RoutingPolicyChecked:
	OFlftG7f2njf/fyvRUTzLpdnb8AUpFduqMItSnuX7eb16lzCvsBlyWJSg2cA6GwapZRQzHXEPFP8ZIwvwRDcjoDzk9eSQ2m8ZVlldGQw//EhH1ltgvyTaXc24v+L8IYpoWBQI37QNfyYfqzCc67qPz6rMtPWrcawmgqvnl7IVU4RTS8V+Rt/F5NeHrfYSUK9QE308jE/zv8F+luEbGy14HtRBYquM/WLLU4nhg/D13IztrRUW1YhZjC85SwVhqouwUIZfKBc+oOm6/DTDT9m7PRmQMgbAae2dQ5kViNQhAavjFlH55BVamE46yxj7AVWWoKRVU/BZJ3lmGkVUyTPaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qoNosL/nnT5WcMvIW0l4b8XeGbV3zB6w0qYc2Oe8gVelTlIB6ccolqXKGadd8UsTfQxPRdvlHjlz9Z6d3DHUO5SFa6X3GF6XPnbtIjeI9lzTPsHjFL2UXH2KbNap0Y2iZ75+JOuFTSg7A+4k0kuOhpw95WummGIwqAtXHqNTWhSxMsM3BAGDRiHhBlsYjmvsxHEI8KgkrfDYVpg8erb6EEVaaXWO0H6mUxpmbtbkOxV9/ll6dtOPhEdMkOucgYP5H6U12RlZFQHoD+CrrkBat2+eCGfVA1ArD75yWxT38knmc/43T81ZqKjtneNd8lOlUs6eUBaWHlEbAbXxdZJQX9p/sPEBM9qpzW2HU7lq6EPcBhp7EVyg/oIM9198kEiji1f2WF+SDUZIYH9eYhl7AxFXcJvEZnjyK6WT8+VhMwKo1ZBWjnb9cSg69bZJ1IhbcxkB2JrO/eTNLqs0IBhGd6SQaaKtTq2cnoG3HlzAzTa72C+VMGQagu610O4AeJd/HrkigdeZljKKn5mcppPp+wcc21yhH5gJNqYxZjUxZPownlkTwFw/0qmbBlp15WsmsFkexcTmU2Ir/5TVtr6vhV0gCQkT6ub3pMPhy8w3Tk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f48240-1d30-4f62-ad6d-08df2901eb97
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:53.5770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Sad61dAK+bGNa73jCHAuYAhOR4mWhMgOVJMqaGDskgn2ovnewJPNBnXy2G5hwFSvprDm12h1Gmi4bFuc5ZNSwhRpfr4I42tq+mijFL2u1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde846 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=WmVTiCyuxqgg3mnwYu6p:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-GUID: h2kLGlPOm8gMFAo4loPbcb0qpgehM877
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+vtCdi/SGDLa
 jG0Z/Tv7f8nDADOgVbYonqwjSn/CMKFGQYeOGac4onR3DHLY1iMqgTJkNFEPlTZkD4VPDWCSGpy
 tLcmkqggk2+LA2EShLz9fI8/UAL68Yodvq2zJyRmBd0+gP9unsT9
X-Proofpoint-ORIG-GUID: h2kLGlPOm8gMFAo4loPbcb0qpgehM877
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/Oabk6cJwTyv
 howUjKKXfQ81vBYL97YAmavdrpPH1OLHWNHr+/94ULI/ZUbecs0jALWQvHyKE0La0lsR2WIljjy
 cElyCWh+Xnm0UpYRZXNMQV0rpYIVbO4cyDK0J35JxRM5nI5D3Anq/nKrwdh0bwY5sr77SClQklP
 tQISjMfX8UyvOWUEe7x7sA8KD46xuZp6jm5mDqw1q6pW5H1wnySzxyZwWI5n/Tc5znknqA+SCpw
 ogOoMF6itkrAq/SL9WeRy7smpgERrRjz2+iPtjUu7kFr8NG8lVnbycwCUb6J4z4oFUWLZ+wKHeQ
 aBK5J53E1zm5fUkOSOSEeg0HAAAdJl1TLsvQwcTWW5dK2vA3jebgm7hJYiVdKL6CGLdnHuw/t8P
 mgXPxCVFfw4nt8sABw+AVGzakz78DTgYACcho4+qBHAR/8kBIN1VftJ6qNfkEXaVFOGEOAu7sYf
 ZyQoCrMGXf9grwQbqLw==

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 15
			IDs: 075, 083, 091, 112, 127, 231, 263,
			     269, 270, 363, 365, 645, 753, 759,
			     760

		Failures after changes:
			Count: 13
			IDs: 075, 083, 091, 127, 263, 269, 270,
			     363, 365, 645, 753, 759, 760

		New successes after changes:
			Count: 2
			IDs: 112, 231

		No new failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 7
			IDs: 104, 168, 300, 442, 597, 598, 609

		Failures after changes:
			Count: 7
			IDs: 104, 168, 300, 442, 597, 598, 609

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (5):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  46 ++++--
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_buf_item.c      | 299 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 6 files changed, 256 insertions(+), 134 deletions(-)

-- 
2.53.0

