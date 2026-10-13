Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851213E2AD8;
	Tue, 13 Oct 2026 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884294; cv=fail; b=aghcfusYJ21wvecBxVteZ+rU2dwqe1MNk/vZ2XfHtIfqGeIDIxwkPeR/7hxopPVAyV4zoximE+8NFXOJGlyomiTZ72RyaUk8CunSNp5vrqJo7Wb49kLuVQGl8vjcQSb//3jygZzIf9gYpkbo/pZ9hAGbp1hG61XNhVGRI+Y5wps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884294; c=relaxed/simple;
	bh=vP2lcNz3qNxZ4iM8n17DN0ClyMLn8BPYfoxiBi2JSew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QhWA1nnoqNARzpX4xZS5ZALT9KnKfeYHcT+1rZlx0NrtS/LwqQ0bEieYNOac3EJwbimyctnE0Rgw/UEtvk9+PwkfZECVIV4APz9OWas2y37WnOmOECy9fnrpuVE4oXQU2JWaqaSnyMxTvnpixyhUnKDnJI7jzQ+NgQVSKd5osR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JBn6AI3h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZIFeCU1Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JBn6AI3h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZIFeCU1Q"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bpsp3197994;
	Tue, 13 Oct 2026 09:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GOGJDwyGm24ae2XJqmw8l6iCWhEnqPqocJnbTAM167U=; b=
	JBn6AI3h+I4ppGudPFaik/JFc/kNGfPLcIcJ8TGOJfasOxvo5J5j2rs1iouzAFmm
	a8TXVCUifAJt+oFcYDlskh6spgtlvl4U4ec21pPruAbNqWPXSKsgZAmmBL8oA8g5
	iWT14LdnFdD9v0HdHvsjBt8fGfCsoU7k3CSzxFRD9c1d8Z64mHPVycZ+BbluPgFX
	YFFLAv0x7akSc9FapUfJe53/m9sz08zW4q+N9w1UnbeYUxkArJLBlS8ERAv+2HPB
	o7TNDL1r+WWQbKET9CBj5ij8syruA7p1npaOXeU4RagxyZhbE+WHdtJLOBvtZdtG
	DvydB/a1k1nK/nab/8F6iw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9agmO016109;
	Tue, 13 Oct 2026 09:38:06 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012058.outbound.protection.outlook.com [40.107.200.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp14yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zIbnc470MNKsVZuwqZlK6fb4h8Qjtfd7D2xjpyrSYvVfRoLlYNGlK2cZo0z18uvIm8ES3WEofI+LhO4T8RMw4cMPjDbLrfEiOk1/B9Zo08roFLB8jftJ1iryH7ywBgrxGH3nTcMqNq3iR0GYITg60CGZ1bEYsNbf8mA6mnV9I/qMg1jU98bH4rRCrnlTa2NnAF2zwGp5L85yuJu4o/DPfhvWKldviElhsXE3ki4Oo0PDwNs2Yz4J4YbtNMUKRmQOkQM0NnG7b3obLtVgrG6vYG6Z03BNlbtRd5NuMqii6uSrh1CECvp99Pcfv0gYgfgIsfjg95ZYHld9q+ECpQ4Ddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOGJDwyGm24ae2XJqmw8l6iCWhEnqPqocJnbTAM167U=;
 b=Aqoz49bpeedMu+XHIm4K4RMj5XaJA6mp3Qwgh/FZDiWAFrUyvKOJe7Q0vGg/IZldTqpuD2wwEY2uZbu230csPRU3WsnHLuwvKrDRv5bm96XZpQy6rsC3EM8Vr5Pk2TBmP//ME4rvRJeXQGQjpbf0M0bBYhMQDhHc6H4fulmWgD6LOuIJbPQKbkRepK8kYpJ1J3DWWl01knw1vXHlKE2VhdScuMdHSUgfr1yZOeDvFy+7ZJC8D3j3MY7Jn3l1rH/RPui1jZfXzhvmDOUDRT4wtV+pqE5VHLlD89ipfk16yUDb7uIVMUIm10w1joc/nGIxn/g3IMeQ0Zzc82YglBFk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOGJDwyGm24ae2XJqmw8l6iCWhEnqPqocJnbTAM167U=;
 b=ZIFeCU1QUznjhWblKmpRBBJtQY8u1x7SoG2UDZwfiA2AMNbsxx2pSKjcfMZvEMkkR4DBB+KzF0qC5KIpEGayVWxDUqccncrJ2AyqZk9vqCmlj7Br7Ojk1E/fN+ibD89k+862Qc7G1vUyTdSnHBbp/ACw+Wcp8INOBjKy25ZfzE4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:03 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:03 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 6/6] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 15:07:29 +0530
Message-ID: <466b3645659299c3bbabe14c477493becac0c519.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0213.apcprd04.prod.outlook.com
 (2603:1096:4:187::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: e82a4006-c3b4-4249-d957-08df290dad9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ClAomaW/O0w5PV2f0329ryDYehdP9d+LAtfvgU6qi8sCpwdT/QuLaXPVsOJPwsfcRY1ZyiABiSUapksUpQ45/GjUooHTHyEqKsPRZle11ppMi9BFjasW1YgEsWXRwB46X3pKoUXMyJA9Sbe2MDiEa8tJSeA8wMABlFx8h+fnAVeBWPNEjfYNJ0Y/shdTV2BiiryxtGKg4h5oRx0D5NzxGF1yWnvyjrEog3bLxhsIwzg9vaypJmWnYGiy0UJYIsP/dcxosc0FsiPEoJ9fjycOQHlQ+BYjfi11UAMKI3VaRZ7dJSrcDw4MhAqUhCqPBY3KR8vuqF6H3Rm06yAGbhMg+/ZnblWaY7pj5Ndhe388vecj4dKQiriH5VnSMEl/OWeemveH/qkkt9l4MNptTTvHxw4jYqNe2qAtzuHXUAhkbw3GzTxfCznDC/66sVzJN+7pP3MyOJUDE7wG+jYFccYTXwRaGRfnmuxwqbx+/AM0atfIrZVoyGAELuBPmYZDfSHBtptuYPSbSNBd/YVe/u0M63WlibjSwbVHLmXWvmOsvecZfcBF+H51FgV5k9mQGMpOxgxKktsxXRxG0z1jvGzhWiqstvrFccRjOVcKZACvtkKNsLF+BPBHJVTHCHs6dYS9V1ywRzbY8UsrNDO+nmFnErJ2GdNTGmjlu61QuKYaVAc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c/QWPmpMZbbzhuy/LnKLP+lojrFdLoyhRjR+C4Kb53aD4/sqwm1ifbof8XPV?=
 =?us-ascii?Q?A6Cduv5pd2f7Jqq7TTT2s5v88+BrEYBtAUJgP7tLtz7QZ8ET7LoBPLCBJNrK?=
 =?us-ascii?Q?yC5Hukb1IwNME1MpaojwKeycChZ9lcW4IrhN5AwHRRueeaxUr7SEy4qRCnWr?=
 =?us-ascii?Q?yaHiGFVMcGuoJEAETtuKXUv+gRZk7nxNphH00iXSP6GjDYg6pMRs5PWBMGYn?=
 =?us-ascii?Q?FGwZ7QqzBCe8Gj2GmN2Hp7ip7oPDkr8a5dfSvJDaCiKJV3X2goKSxrktjk7d?=
 =?us-ascii?Q?tMq1UCFqD92yLLfTejhIDQgUAMvTIQLRFetik4sL+3GhBn8DCFR5RdNhep3K?=
 =?us-ascii?Q?RcN/0kmVg7p2oQkxuA5uYj1bJiAWlag1jwIE/14AbFYT7dIwUv02u/MIvgZX?=
 =?us-ascii?Q?SpaMPIECfO/Z1ZEs41hejFqyB4oQMjXDaPiXH6czUxPKZ8aMfiPYHmnn+DDu?=
 =?us-ascii?Q?kdHluxDf9VCpSHoSwhULyE+Gjv8fgBdNLQ7Byt8i4QPevc5cI4/2ly6F6Plx?=
 =?us-ascii?Q?2JG7G4cGT0KtXYvK4ltn4cVB+Q7Cx1gkpjpK5iXfbRsqC7htnV5gWa5uFa9z?=
 =?us-ascii?Q?LIgWQ9LZW/vHB5C8BnDTRxzIhm9V0u6XhcTm2u0V8e9vU+1Jul73GpiuUBpL?=
 =?us-ascii?Q?hYA+656z5GbCTyCgmlX7ePM5AOO8xTRvT1doCFKtyZIV2hpyYtQWOHwKqusM?=
 =?us-ascii?Q?YVg7qxB+yIQDwGIyckmCoDs4XkYkaXhN8aylDBJgUFiaIYE5HJIKp3iRHA+c?=
 =?us-ascii?Q?dVwySaRUdlFMWOzFBxtyt/MGUuirkbjjXhCxOiKGJNAxyPwKXKsgxEliuM23?=
 =?us-ascii?Q?DsL6yva7SoJmRow6tKhU4Rpd1eO71V0z06Cyh/zRI78QdoqCeDrFwZybI5Rf?=
 =?us-ascii?Q?915cXpnxJ9aw49DJxFAmVvZNUQhgMl42NxwrXzHaM4jl4i9MU7LSpiFyaNxM?=
 =?us-ascii?Q?fxNFMR1/0b9WAN03atdmfoV/13JQf2QQ0fjvVNMeXqzhioWr9kI9DRhQv8Ig?=
 =?us-ascii?Q?+Zues4/qyzICGcxmlqu7vOKMAzGiVSn8YOf9fVecAfI7U2ggNJCjd41VVNbg?=
 =?us-ascii?Q?2ES+0NfqufGhaCF0nca0urZ0khdCP/BcL7Q7x//QmERayLc25Fyg+uj/dg29?=
 =?us-ascii?Q?ETNk9YK0TXAieinfHW2mwMjBHEmVzQ1nPaNEuyB4tf8fasboG4PH8WWY2oYf?=
 =?us-ascii?Q?A4qNTVGFhtoGnZUUfGerw9I+GDtZAjesyOOzUSujINaB93YbS0+FzAy624kL?=
 =?us-ascii?Q?cYXKZUhitV0z6Fiuog36TWYWJuYtPgofCbcYNVVBo/BHwc+0EBt1TIsZnfwl?=
 =?us-ascii?Q?VQU1IxnrxlYs4fYfby3ZJgKPW+fIHqbikkh5aNCW1YfoELbh5gLXUK56nXze?=
 =?us-ascii?Q?k83V/VCUVfTfgbZgTNSHaUzEeuKlW+fzelkf8kpbDndKsZNxhMciHp52QZMn?=
 =?us-ascii?Q?stOjHp822hhSkPDAZfwse4o7tkRdkYiLs7NzG0M31KU9vGypoEJ9SpatPy78?=
 =?us-ascii?Q?RQuDFbM1K8Pdx1F14LK2anFWUuwnXMNo/y+E8LNQwTVz/FhrCTDPD2QHecqi?=
 =?us-ascii?Q?Z1GzTnnCw2dYnAfbFFGAnfFZHMC1obKGY17QzX+fmsE5GVowHrK+l2tSmWxC?=
 =?us-ascii?Q?T6ZsN8HuQpwczFMjVzPSYXG2iN9HgIyfuaA2EcU5SGJ71puZyGuqga3fpNwt?=
 =?us-ascii?Q?anAQeeRgT2HWlJA1+5MqKax8ljmb4Ln1BLxIK899NF2P6QWC1jgbgLHqoKP8?=
 =?us-ascii?Q?AvN+E7/A0fkbjWTuuAMx53Of4Z9Z9hEXFxD8ZCazkUoYY43NTYCw40VxzwSW?=
X-MS-Exchange-AntiSpam-MessageData-1: F4Eh1q1XeFF8EnOAOiEjJuvl3oIaRY5cRWQ=
X-Exchange-RoutingPolicyChecked:
	VnW5GPJC2p7niZ+jfaIBJ/YrEn8nq9YFjyLXbVxzGGz0Gp4Ior46uRxY25x7nf8EFPzyV1fm/79SgZfDqamFK/2hx3ECnRvkWivR72cWpGPJ8+UKDtXeel2EVAnL/kCV0CgVNPAe5z6zawXVPBZqsHz/5Ao06C+/cAHVDnhHGvWnaMhFI/9qTDLz7xOMHCM/euyvDzJv4e2cUycPSXvzbHVAuzu7qPm4yOWFDCZ5e1oQMZH3bi7f60lSc5NooTRohO1S8quIW9JGgF3HP4yOdqZUICRw3vbwObjHsm6z5jSfG3a5xZdxGCbA9Exr58DKtRJDEgmlmTJArsDJIzCTuQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TkAcfQVQM6+dHSvj/tFlk0qmJjiCtBeLEjZnIstd7r8DBhOVG073X/RM8WN00CusyUWIFs8YyAcM8JQZyRayAkJ+h9n7t0AY1+1HPipUKZdxPnl4YkFwx20jFHYCRKQfENYDc8H2apWJ1gRWLuX23MqcGwVZTgiEzFg1x9gqtFwuK+6e5GIk7178Y9QsHWy6v7NYcB4NE1r5RElpsJYsQeK1LjcdaFhxeUI2WJYSG2j8wOY2cOLY+q8gL0nA98ZbLWBvn+nnGhfyulLUXOEi7hwSmzzgFeI7BImRPTW7XEvWaBbtJOLzgBJQk/Zh3Ypur50WcQQgG/JCcbZgJKSanIA06hvQ36PBxPK8kL1JRVNfLAb+b8MuWDLs+UUQasg0qbxQ0z8PPRCq1dmsKgvWvI33HtxGEvc7WLwTdcfGO50Vdy6Tr1jcewEyymd0UaqJ2IE68WsPUYO4+K9sW3yveoFxEhI+au+VYQIfmjOxv1L9JeRrLw5ZxIlhaq8+KN2bm6U9EyOCpQue/ehPWAh/zmlXNscI/7d+vctqBb07du1TkPGKgruOlaKJClyyG99Cd2ITb4soGKzDpmx8Qa47OqYt8rgNfWAkv3w3mKQ1yH0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82a4006-c3b4-4249-d957-08df290dad9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:03.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzawQ1kjprCXhvP45ir9UpEBoyJIAGfQYifFjX248Cmnh91ca+Mbj6R8ou+v6u8/I7D70/OBgaPgRuyh9xu0JofMgwalYEejn2bFwM/uJK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXyMsKmsBI2ZS7
 6qKazFS/ZUyVLMweslJjZe6E3XimA/f7RjPAZzM5lLO5CqEuoXqCIHw74AHZsJQwfFZy8jtkUHi
 vtNT1qBPELR6tpJBmNsJzYL9SJulkhkxypujp2k11DwdoVhcguyB
X-Proofpoint-GUID: ixHdIsMeI6ySt9jjV7yCXfOvvoVWbZae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0NJfe9+Yid4e
 fOk3OMi0jub6ByLqCx9K+LpyDvjXDCkw7U+kC2/JLmNu+2/Oo/Nhc91QW2masfjyGXn12cwSdVv
 rv4dDnQ2kqV18XaoxvbVrLMCKdTKm/Q5JF972Qnam41ANOLqxknplX9ymkpx9/IJ6Bueg2hfQ+K
 eILAo/8Fqn48UT140Zgepd2UBoMAC+lAEpLkkVAjjX+O2yEs2bziR6t7+VYMGDPlKYuuaSCBgM0
 Vj/zZjiWUzvnULniyeX58zMeAj07XF1mgsHObzbFWkuB04znhLnjEiQM0HjHpm5tmY0TD3PTmPz
 N/aVhEv59r/4jI5XhYxdFi+spvSrPutQ7TqC0n8GYUZEWqGe1vJBEdThF6KZTpOphvzUlzUOHcq
 cRNMGeAnJQU6oak56VBNWDR5U/v091J0/K3tBAOqNB3T3zDA7mnfKJDQQ36ZTT3Pm+w30zU8lL7
 BTWO9pQMJMCJDlPOZz6srh/BkMWtjS2vzouCagEA=
X-Proofpoint-ORIG-GUID: ixHdIsMeI6ySt9jjV7yCXfOvvoVWbZae
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfbff b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 9e6a68367ca9..aa1108e81c22 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -707,43 +707,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -764,6 +763,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -771,18 +779,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -798,16 +807,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8a8a46e698be..141c3780a36b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

