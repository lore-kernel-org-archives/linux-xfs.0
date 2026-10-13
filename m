Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C174B3B14A3;
	Tue, 13 Oct 2026 08:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879400; cv=fail; b=V/MfrHfR6CQnhkUBp+wR9AaGpWViXiGgojP8gqG9ykiO7w6nzUoJb9KNvZz3pcu7RVkjnANsHfZHRGALOvfF7eTslGqz2Y5yVdymlCr7FVfBDPtOVAcHeV4s9dc2esc2HYb44RkwY7W5MkziU6OlAL5Yn9d78MqvkfoEFJu9U+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879400; c=relaxed/simple;
	bh=aoE4z7mrIG+VYx0AXaN+MMFeFXr08Okye1x7UB152/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ShKPMBimKSPko2TXKdVgxyNVJuHp4oGPB/sIPARwYGJVEBC1MG9e5D4NYQ77x8MmPSuEirelMapzRsNu/yTGh4eTiUaStdSvZ3bnKx50Zv535C7ZsUyufjDae0BaykgBt7O1vYuz4/zuJ/YrCTN6Dt6zC/x78miMK34Loh367rU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KEcmJZEX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qAmlmXqW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KEcmJZEX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qAmlmXqW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2v6sO4135007;
	Tue, 13 Oct 2026 08:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=; b=
	KEcmJZEXiLhFHIX9ibfah/6s1NfNRGsRIAQm2NBIv0CyFhtwtT5Ver4VClcCOPk6
	FY1SHTnbl/KGQN3g8gpye2Y0AcJw/kJnKFzPCKtM3/n9gmD9j7/5jmjcxNZ+8Ffb
	NRY88FYlY1qU4WQxjoUN89v0jBxhcB1sH8I+b/5p+/YXU80rehB0NtrBk+VodArr
	D/rlolvJFth7257rz9g9edRTCdmTifecY+1ElJFmrbwya/O4gjUErH9sPOiMK//n
	A2b0/6Mtq3lovpxoCYEBBInidzA4oU9OMOUblrk8LIKbi9PrLM4i6V46Y/PHjrou
	vzH/Mmith8CR95tEStJ8Sg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86Ygd024157;
	Tue, 13 Oct 2026 08:16:34 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta00hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zGzvf4LpVUA1FbcDpyFhBN9ZKJ4FBhXfWt2r24k1r2YCiNv6+5kYc7wx/h1oxhBsFRqI/kKZkegXGlyGnjt1QmJt7k6Y1mgK46JNR81fvn7vdPjM0q2iGo7ieFM9KKovI/BMggYYTjT6gsMBi0qom4mXIFSZpWf5ujj+2J9zGW0ndTnWgn9gvTAotL2A32RI9o6cYsP18oHu68y5TEqJwf9wLg0Tfo1jjkuD6yGvPlhkOASkFI7vxqfPtKn+RuAu6cYWF6qmplfju9WzRl2RfU6FPvmjB3jrOGz8BUT3j3zqD0oYPNqpDOQvYLRhLIOdSMONoTPZOJ/j6GS7KtZXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=;
 b=xOgid3FW0gBUN6WS5U8BnD5nLPDzirFLETl5z0ZoloULbOS+Pzmcz6Vb4YFuQePG6xZUf/qZ/QecBLTWP60MD27u4DuX973j1TXeR0R/1hParJ/lBRzOlQSVGsaZ0x8xmG7DxXtwFJOzRpSlYG+sqkFiknSmygaMeT4+txz/q094sdxkOeWzhCIhpSju6CnHzNemAFxWQAEEyqNiktw8xsZj0FadJiSoFkn2/vphAjARHFJRbxekxFo0ZxhGu6eqwOWU/cFRAA2+TkrqOzvjAvpLL0F9CKVO7yRlwCb5wulhdGdvl3uBflRbrmSHZq4r5ozh3OmB1EBTsBxuCTSBbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoHvOTW192irl/rAMFnXJELl5aPdanZ8jdEmfVC+OTo=;
 b=qAmlmXqW4M6kGf61rxmRbIDTFHgNn/6y5g0Ao0cdTRuwkIET0BKHWheZUHOXuwpZkU5xA3B56uS7a5EYDj/rmD5Ya2KWvYYDv3aC9PSE0xD1mZq9HhC9S6zi+2t4nVEGg8fmWBM0qZCWvxOEj8exTgn52/ZibBG+nQFv/7bksU0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB6507.namprd10.prod.outlook.com (2603:10b6:510:202::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Tue, 13 Oct
 2026 08:16:29 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:28 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 17/19] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 13:45:01 +0530
Message-ID: <308d53fdb1acca14d32b86f6224c9d0febc7d7a2.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0053.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::22)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: ae2dfd96-70ea-4da7-aba5-08df29024794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hgeCENQwJvAqPx1RvOHix3cG4SU1V5LU2UnXBfxUoiNWidAeHAmzru1zu0WsjEYoSqgF8gqfZzMVpbtZmySQqxzrtF3WCiM0X3qy7rz2xBUyjPMzIGNKVVeavHiYJqq92fZkh88ywdAi9G4DjdBCP6xqGok5i3+1Jrd/4Kz3/BLyN6s93PkBqcXXOGcezGTJjzdl/LCkcg0cepMZYzfvskPMCCR6txQNjOtHNvc7iCrqUTxH8avT0vwRiT7ADgJsfbyR8RFtxdH/MdcYHZjAyh2nXNgqpWSXe5FjyiGRJJz8Qf0H0xrqdg/7UMOGMwmjFIoIfLRkqLqCg1/+rl+X2dGO6V4G+47sQCI4SjjPRslJBrPiUbxSzj+e8t5TwAzC23JKUCUh7JjFGz/K6RnOQeivXddpqwbZ5dZBtD/723VVcZTN4HtAUKTEIvRK3fyWIHt8cA6gDlmguQLAFyzdvDxfyBzTrvfkwgPCeS7BODcBN5yXnYf63C28wBj1g/MTQXDeKfTuMLcwtY19TKO4WbV89a96oCjq4Flne1yCIGQ9BS4hZxpX20xoIiUDrikt1SiCz9q+4gFttIobyNS3Uld1qzCiFh2k/WJldiNMyuLUpRlw3yIMA0Ny4/bkw952eLWKPxSohWOjC1JV3gM1t89Iyb9dYo6ccQ80/agRPXY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mWtntM4V1IPv18P5/Zi6is6/Z8ULADvPm8+qy9UcJ5E+qYdhDWpnuSMWE51d?=
 =?us-ascii?Q?svgScIYMTlkR5w50cFqLJgh2fNfKOzUUAWAK2DQzTOvFv3lS8gEYfrZGw5YO?=
 =?us-ascii?Q?0KGlvMIBaemQjJBQS59khn87Xv9ssNN012bEjdugdVpYlBW3VqFDTc9d7i8W?=
 =?us-ascii?Q?BjC9O68mh4uDTkdU6JpbDUbiNbxu3Rw+meGH8iD11QmZthhMz8EpCEz8u9Uz?=
 =?us-ascii?Q?MfINkWnV5+0IiNUv85g2pQLA11xnWk4DeVPD1D2h8uwC5RADWkhk6v+A2XkB?=
 =?us-ascii?Q?VTEL4EOa1AbvDwgB0JDQUHhZ9nJ5FxQQuDWnunbjt+VdiPgQuQ72yWg/X0Vk?=
 =?us-ascii?Q?/vTlYQStY5H6xf3ELTOtdxNuiMS/4J3fNwzdJFdVYeYo/BGt/y1qzYeX+ry2?=
 =?us-ascii?Q?2U4hiFENVP85MMqeMsF09kaLTEb42kKiyxDaclYfymhHjpJQWT0r+EHBjP1x?=
 =?us-ascii?Q?eo0T07DMC2yIETe21g2Qf8bU3oI2lN19M9sBoJA5X/aafa+7QI/xUK+RtIf/?=
 =?us-ascii?Q?N58o4IVvwiPAgnxd3Mw/Y/moFiAqsOsfZbj09GWYrwVMdyJQM6XYqAnFhR0a?=
 =?us-ascii?Q?1qvWhbA3iHSfIYzRSqPEF9+pil0E0UuI5VUX1GVJrTv0MWMa21qDYaoXkUK/?=
 =?us-ascii?Q?/vVlEdm/xaO2y5Kz8iYFMMs16s16HHlI28cNn+qMXDZkP4ODhm2pulrE3SY6?=
 =?us-ascii?Q?xtYusHpaReFkC+H6S4ifeax8ezYVz3r0cHqz9vJgg3jgXwAsZPiFB1c26vaI?=
 =?us-ascii?Q?blKR5ScsOhTJ8fIKROwHpTXKGAR+iFs2OzSmGgR0DZJatOY2TUbg+JPrmsXE?=
 =?us-ascii?Q?KWy+w+sDDBEwRFwScvu3ElnfVoYfCdy7VfXWsfGJDSsJWGTOoVB86cQ60GDN?=
 =?us-ascii?Q?jgVboi+c5joKvpGAZ0ZENhjmsmmUpsmD+VOm/tPjherH4H3eQi07on7S64ZT?=
 =?us-ascii?Q?CQ/zFA2Ml3ztBrhDoIGnmWAB68s7jrNq73+B3Sz+vb9BO4LYnBKmZzfoqW/F?=
 =?us-ascii?Q?tRMQtYdXHSATkjXYYIsccwVRkCXln81hI6VKNfGxXAZB+hjVmpifVDGB5Uy/?=
 =?us-ascii?Q?XdIoxqIpIP22Ooqe4/95dtr32Xw0JWN42Y5ImhjqgZbND5r1bih03nmfiRXE?=
 =?us-ascii?Q?9J6GvfZ0GfwmY/IMEKC0lSIs4JcNacfpViIyLCFmQ71nlfdHWNlL0Pqc0hYm?=
 =?us-ascii?Q?678kWSFW8c5aumwHc4fOiFdzHzck0nuQA13X4UgZh+2VXL91wgVpUL45VJIj?=
 =?us-ascii?Q?ohMq8pZ631XnW7RoLviOpwTJRD2rh8VZdcoE5BMeHM/0ROcTbFVqEo/GxnwU?=
 =?us-ascii?Q?bnbcRVGmparTHFZbcheMoZccFdBQIO2tY9EEC9tN+Fwwn+y86B/lADzw+hBK?=
 =?us-ascii?Q?ZKHMRm3zyawpv9tebU1ZDtRgyLGy+dLT8RBd1NOa8l83jYUn6Cj8xt3jqIqI?=
 =?us-ascii?Q?Cf1DbtFJCwJATth7Ksy1zMpTgyiu+v9Lv9C5wHLAyHTEQ+uWtBiHMPxaghom?=
 =?us-ascii?Q?AobNc6fYfRdQ7BeqlkWeM/GVTynfAMCw7fw+4/zajr5gFMiu9s2avM03WSVb?=
 =?us-ascii?Q?LAXXSGp41kMOZdi1/d7EfW8zv9Hy12x56zmsU1uLD8fXQwoNOfJQf8olO4nP?=
 =?us-ascii?Q?SViAC9IV2EcxkzW3cfoqZ7c4kzD5PKtX1YsrIyAF23X1YmWePurQE7NmQGH+?=
 =?us-ascii?Q?Ma8AVKTbR4UzSkRFCdRPdHEyg/tUnS5iQq/sYe1rd28GEOScVexQc9x+eKE/?=
 =?us-ascii?Q?YOEwtcfj1LBnvlQVHkNDQ/gnzwEurT9cJvoE4r3FWO1odB4uCazivprEJz47?=
X-MS-Exchange-AntiSpam-MessageData-1: GuaLI1JsfvesuYEvcvLqV37JWB3CqkiwyCs=
X-Exchange-RoutingPolicyChecked:
	GMW8WJ4id0uJt6r/OM0RdmZrGXN0LVwKD2/r2RKo2gdqC3OY33IEXnYQF/1KxTDk1papsj77UfZDHiSwQ1iRFpBFbXOZIC9/FYYECdlnHHJV5OPPu342WzzQwSuYJxwl2mF3Kh5FJRtqReliAMP6vO2FcRK1Z+tBq4E326xAhzdRSKriM7dIHw9CxBTA17AahrNWejDjJ0PbUNYiV4dYFomjMCP5hsJzipGsFvIDOAMljJNBx2DFSu8v22M6r18WlZzUa921NIym/4O2sKTY2ywT+naKBqaWmTRv2BH+OlJGQeIARel9T1Cw6QVTcPOrKgQ96/kGooVysZixIKETAA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ANXYsv5EcQq83RXfpTKcssUwvzgO2lqv4VWOzP7eYOa6cprSDbSft9dHyKxMjM0LPeLP9XdozxlKuqitanaXcfZohyF2SVC6R6s+zwwcZ2TWj5a4tlBsNB8RafGjkBdcmr3AVbB8WPydUrbKMRlaZXIfV7PlWi3p7b0qLpE5scNZFZElX8MvBmVPqB7RUG8TIQS4zBNHxq3b3fyv5KbrgxI0A1R1DXKQatWpoOocAyVwZFmvG48oyCQ7Zru1Fsncw3JLCjSaMbE6pD+XP6JkM7Rd58tjd6gp8vKL0PabGhZoK9SEVTxuqLVYqXstJOJBLVO8+bbfqfmo2mGbJTqVJdOH1umTQTln+r7Al4UIB9v9Ptid0B3QpgOBBP3Mw+SAmod++Ov7NM5chY+wjvwrsjCNeSs2ppLYALAAbLFfF9jdpqa7rBRp8t52YONOkylsVkl5ah9qmf6L/OKzrsSMMvOhXnMQn5X3UX7cg7Mec9uKzssAyrsPSry9/B+ZzjVJna6pD8Q5uEKGJ4wHDmwfbYceqT/0vnNQmAzGov3NwdUy0JEJotqDUATbh0Ee+ROuEn8g92GDVYyQXe6we07774E1YL5N23k8UuvwQR9MQ1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2dfd96-70ea-4da7-aba5-08df29024794
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:28.0891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1W5Uaq9WVg27w4BvfT8UqKVla/G8+qVsoYHfcdg4vR3cutj02cUgJdRx5chIyrNuziakNZW9sQ/zzT9MlDNeEFTxNt43KY5xamLp9Ce584s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde8e3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-GUID: Wcu904un-8gkPh3Af9s-GmMsLxttXPcI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX6zJ/cmUFOwVh
 +LHGRTALhiabcSIereuKUwciaQ04hbUoqHLyrZPNKFJPWA97mcAP+1h+uN+0z6bNdRa69CTkbKj
 isNu6Om10BT2xg7Y1+rNT+I2sOpVRCJje7ibr/tMo3FIYU/f/aBUMgHPXtauHKFcA8eS6r5cUmt
 kl4CjnhUpg4SnypeFRuobIC6MJi+8MxN59prdB6NwJSngu9tLJVhXY0G5ZPqV2JP3w1havs2zMk
 VrWxMjBVYqnEQ1we818bpLJ+4XlFWVDHAJIL5Gl+5mV781pFfXDB08KEaKJBHxQ9J+XRmmJ7S9L
 zZWRHK0COve6IZJ8t4lM1vAkElxXVb/JXTJg3PSO/9Shy9JxR2PmASf2o1/WEHR3q6gtB4P2Y7S
 NMsQd4T7R74ka8kPz9m+VNEzn3wGl3gSPtJf7Tbi+2jSCN+Pm58NnmfL11M9XI4S5RjEBk2DUrz
 KWskt6sKarwoef17rSg==
X-Proofpoint-ORIG-GUID: Wcu904un-8gkPh3Af9s-GmMsLxttXPcI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX4hdhaeubfrvx
 fTyVj6OTfZezIZQozDAM20tlCNrWAjpZMCujLrdtbk55HoOkeq8sRV7EGQkVwtGljNSkrpuUgR6
 W7wQW1ovdHI9BA+F38wSlfOhW5ufOObUGfT85HBwYJsyTaIYr8oN

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

5.15:

Fixed conflict due to the following missing commit:
	182696fb021f ("xfs: rename _zone variables to _cache")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f864e0b8a805..3124f96ad6b3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -31,6 +31,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_zone, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -481,7 +538,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -591,7 +648,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -711,33 +768,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -959,34 +989,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_zone, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1006,5 +1008,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e3ccbf3ca801 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

