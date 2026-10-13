Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2413998B4;
	Tue, 13 Oct 2026 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879308; cv=fail; b=bAVrv2ZHS3Mq+LOhE1YiXHYRRSQTKty9Q/nRj2utBz5UMmAKvUZBR4JaEv3pZsgH+osFPrBhlRJ7Ma3ld4h2awhHXpt4AEpnnHgYV9SgQ+HX880PM4Gpx7FuKhO3RwLsedEYyCqJuf1yTi6xS/1jpWVEF6q7+a7XceYoDoi2C4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879308; c=relaxed/simple;
	bh=m5eagEnd00jy8jEkZ3AalH9G/9jw/5zIh3fvT7O0x38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nywJJ7pzmGBbfozw+zDGII1D3N5Y/9r27xJA2A39y9AcKlOb7PfcTmLh2G4DYa/fDf6PlE1Anakw71A4C/9r5ELeCMNJUD5JiW3UAohSzpdE2nM6gD7i+YYPMM0j5o3KMsdpmEM+02F+NqCh6sb0m0nV2TEV4zXozKvIOkbkk8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rx1emn3X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mzobXZvS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rx1emn3X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mzobXZvS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSKc3201601;
	Tue, 13 Oct 2026 08:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=; b=
	rx1emn3X0U2BEu0gnQKedYHdz3Kde8J/nxE89Y3keGL0KfbFVCoXhJjctPNG0Se6
	KmwXSyPDEz8vsXjP3m7FPvyKyIuw6gftoYuSjyTq3z8CBWPfmiRUd8W+mX1Kpyue
	Ms0KeaW0a8U5XUIX6J2lUCGG0kI/NviNK2ED+QIhWEtLQpBaoTj50qgdzb0toLKy
	naUpyrbKG3kAK1i8v7rSgM0AzlGMZJc17lVjjtTyfsL74UJrBcJjvA/m+kHUnQEr
	uGnCiC6ZMloGjq/FCRRv2iszG30YNr7KBALczYH1C5sH7BYJgUD/UQX/vv1f0xEK
	8a8fOpsK4pZbZcDTwsf55A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PFt024913;
	Tue, 13 Oct 2026 08:15:02 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9arc1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p920CtWeIzhvAvCa5bDTUa4JHy52IJJ1GGgXUyv+X876B/FTWYIJ6f6xZa9PhtesNUGKFMMnZIPNMRzRgFAHL1P+eI1BUe/4jvskp2qngqThrXwdzb+5mvu+ZjbM1wNkv2KoeBWzaKLyNvB1F4MIHSVzK12/GZwRi1WWfVyTDn2gMHoA+Vqc79gL6FR3zTR0nII05oBf4eZePZe5Kbp+uH2F+SkPJXnWvPLTMaLo1nJX3Cqc0xjzzJZ4jxkn78LOumjpGJJhmBoY3TvOahQywu+v+3U8pN2n3ivvtaOcGWr4tRS2xrq5ROW1x1KJBzoZeWjDRzI4YIokWeOtLqID4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=;
 b=W6i+x96ZGVbysQLUDdlvaxC/yqAT4T9+3Cb+x5SyzgOxQK+H4eLrhEZ20Bi2gzufU9QPgFW2IH509mFELoPDAKqPdEpDkFi2g2Mo47uhSA6WNUF7We6Q1NTaS6QtNBPrgFReN7XoR0QxzmYdzMnyB5oKUUCNpuadI+QufWqK8pvXKglwImEBMqPMmnO2DxVagqcCJhBk/5gPeAV1UHIXV2JDiGdiRd/lSWkRNcPMedCSq2jCmTf964ZSU0T27Yvx3hbn5PSa0P1S2fw76LUW5BqwSMLHzSoDGxa9uxyooEJJ6VNU7EBGhyOI5b/Dp5Q71mmuIhQODnwDB/uyublcXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWDd8T1qZifevOSFed+/zh0aAfHicccWWZZo+aELTq0=;
 b=mzobXZvSMb2VwfunZl2BoTcTROUFn8QtKrEiQ/IQlipPiXqB2uNI3qze4eQPQYc1OgB253T4oTidvN9AU4zAIKE0S0ypQiEh+uuK7pD0IvMl9dDCa1Rf8J26tY7wFYgtbc+rByzV5b/TT5LCjwCCzVwWHXju0YIQ/x3NUt9yg0E=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:14:59 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:58 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 8/9] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 13:44:16 +0530
Message-ID: <9d2a6e2bcc831963a988e0bff9b73d9b2c96901e.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0181.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e362222-056d-489c-6bca-08df29021270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PP5qSmoZsvAkKJkRQLqop5YlsPKODpBstDWwObB9lml/85MlKwyxf6VxACl2dvAoynWwpuNqJ0ceWC+QJ9UNsnhvHPBrqG0ff3O3umNy8guLpdS40Q8g3iOzilgurmxZaMwfDmT68WoQksMG0jHrdnEMH8c7ioXRqmYeID0gA+1OYO0iOShUhgZaW8X/lAWp0IrDsIhJgiB4K22ITwQS8C8bfuOATW0zTxa2U5B+zn6znhYu4hkjr1udmxzovQPQwvRP34Awbed58pkQQzps+KIkoq/00SuLUuxLB2Fd298FTiclncrKUBlsISZUQSWzD2gn2Kv3rZ5CVrtn5gU2ziHNa/ZseKbIBM8aXBr7bCK0YPEl42KkQ6Y0oxFzLNjaWTeuq2jBiN7C2C++wJN+hFY8aVAoDAiysyWmh238vEOybywMHicAc6HObNpGSU5GBsj8zOG93jl5yAJK1CPHgW2uuG6jxPCPaTV5xS4v50gjQd8cO84oZyZAJ9vOlnS7nhlx4rB8Xm1UETnphYpPDgGP+p2wJcy/vPWZDhypTXh2fyHdb5+rVhhLZew9Wf50vElk3445FIS8t/uoAt4g1nQFDaOjhWBmRS36TmpiRTQyxFr8S69wGNeiSxLN2hiPXN/uca65Hcs4/q6y3DyYtoYWdNm/syZ1OPWDQIIZIw4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ag4TQB7nuX+huwaRzrpqwRCLumD9HvXKB9/z5pjvLrcDB8xjqLodmbhoSkhv?=
 =?us-ascii?Q?hTroNzsz/9KPo9IZTR7clzaJXBsHKvxYA6wiNnxkSV1kPTSBbbTkUzQJBZlh?=
 =?us-ascii?Q?EjNIPdqLWluvRdf3oMKNzblFjLlq9Ioe1+OE/cJzr1i/y6j1BnZ2VByoo0JT?=
 =?us-ascii?Q?FVzaFGaojmKkBv24oRZb6p6raxDEN7ghqIpjL3rvZ1ja+mckG8fNIj20fLOt?=
 =?us-ascii?Q?PqdmiPamqR8POrSm6ju6lWZjYTd10bFdrMXykwOSMCXcRTuSJWszPuWsM2eX?=
 =?us-ascii?Q?rljbn3oUcUp3oe808/zH3BKDgcILxFuwdA0GcI4CqsrSzAchs8jkbVNaYZm0?=
 =?us-ascii?Q?PNC1SN4DtDARJrKGMDlFRoE9TQbYgPa3y5hQXO0mOV09JrR6aF1ctEZHHfmU?=
 =?us-ascii?Q?FTopgQ83v0PVpJHQ0BV0vxDWK04y4UfIGhYsFhma1hOgtlN4MkprQAxGRcwU?=
 =?us-ascii?Q?qA9fmyRbnC3aiTbeE+eMFjc+h5vx6Tjy/luVAYd3CB/8Gk903rdVmDnwRKZY?=
 =?us-ascii?Q?+AgpLlOI+jnsnhMXIqHsGCQJ0WC2eZ291aPaKj4DY7g8HBbKrtNwGW85opyx?=
 =?us-ascii?Q?M9RPAKdZYiopF1CnpoeX3yXeqteEduqTUkVmxj+0JbwsAJkx3VFKDz/+FvIH?=
 =?us-ascii?Q?187IOFPv+wbvtGYSXgAm4UdDcU/+6IEX6/ZJXhjx/GFDOgPXWN9r9Nm/H4UV?=
 =?us-ascii?Q?u45iZCKV2yBX22Waj+TZziHDgOOxHQq2LtGBwq/VIilvHT+bs2znTktG7KXz?=
 =?us-ascii?Q?WGhZBB+tyy1B2KkURQE030gWzIfdji0ytGDUadt6RmaF+0DH8ZdnK1JUqBQ9?=
 =?us-ascii?Q?kynaWcIWcJwYa9JkRaXdA+54mwp/EPdrK+RrwdanAnamXh4oNorANG9oHq2Z?=
 =?us-ascii?Q?cgUq7myeUwR2OUJhmeMeLIf4zJgCKiwIeRmwAbJwgLPbVaBycBhhYc3Zs5f1?=
 =?us-ascii?Q?u+0TlZztcHRp9xKLNMA3Ubwlt6TwmHUG3NS6sheBXmKVSsAN9YB1ima6z5bn?=
 =?us-ascii?Q?WPd+Y4rUb1sbvGBLj8Ge8yv33458Jh7wQAGTuhduCc02gib6v8+WsJVXkL/X?=
 =?us-ascii?Q?fk/GLGNlI+mggPqFTwJDRaRQUsb2pA3fPWAKcXY7iH+/HVHjP6gEENJyjSH+?=
 =?us-ascii?Q?r90x7laT14fZAYi6k8KiYOA84YfUUmox+icnb4pXroV0fm2czFMabr3ZV6LL?=
 =?us-ascii?Q?hVPMK40hNfpd/n0xwlwmgFlnQMU7dW/O6YM5vuzppMwHA4ArT4Ixk7OHxllf?=
 =?us-ascii?Q?mg13Pwm21yuiGNOKNHHW32ckmg8m/c0ayucU7iFbQbIYF5Xmi4pzU5xxAvUs?=
 =?us-ascii?Q?9XCZJMiZjZ1fTlY0DgHA/8Hpb5fUBFvPlh9LT+h2sNKJroakPEGwd51N9hsD?=
 =?us-ascii?Q?CJ4jBntffFvC+JpR4dwFPikKQ7r+6o87cofNOQdTQyCHwt1TXq6jlU24zwLr?=
 =?us-ascii?Q?WhsfkkEN6Tio0WFqKV6XEQqFzrXtE0ajxp32dG+8hVrDTVnHVo+J/q2Ut1id?=
 =?us-ascii?Q?8pidZbyAKtATqNT+VmgVAmuF5C49b1f65fysO5/gqfyRgRZpR48SY5ll9jtI?=
 =?us-ascii?Q?hjxpXRhdTW3VcsS91/ReVf4uIyq7mpXXpO8HQ0TdUR/68WuqDaMkycsDb1W1?=
 =?us-ascii?Q?bGg5lc1drg+mpZQ1Hn7TPcvM8LmJmOMCPlSa2viO123g+L7bQ6orfFFcB4lU?=
 =?us-ascii?Q?UyxIW6tQD7IcIx87o4FfJMcODGz5iRLo9cnTJioDBmXl7KW86ZQwGwrS2dZF?=
 =?us-ascii?Q?n3AFcwnx9O/nv76pAJ1MntLaOSTvabnJBDiZK6o/DehD0q5PDdkIRC9CTfHH?=
X-MS-Exchange-AntiSpam-MessageData-1: zPT9tpuNPa1PhGXnoepjc6ulDTHnaWWIXiM=
X-Exchange-RoutingPolicyChecked:
	agbDtrwRJLtdwDZwpSQQvUKKhma5VUEDXdDXceFzjDLrOqD3NRge3eoprN9ewdHrYVDmFPsVZV1A2+DKf0xS7BnMjxl9iCJpthAGsFXi7Z2DTRv0t8UiXKymOm5anlq1nsm0AGQS3y8hH1Rj3HCCKx1tYVlE3cnHsuQUIjrDTHxfHWd7myUEBAoVYjnDZXlgWJlGcv5NJnu7GdBdBNRovQ3y5g3WNXvjhD/34ZGh/6eJDrSbGlKn5AqwGaVdG9Le4dsCKnJ5wIiUNPmQR9JTDClDajQNT82qFfjYj7WleW6/gbCu73j0+UHtdP55YxN3dW/iPUxqnipVaYf4yQXgxg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grUVtz6eN6l+4si3zNHQUMXQ8E4cA6zt60/YKayGoWp1EN981cB5x9S0Gormg1ZZbT9eJdD4qlnzX5wt1I/QPkW40FWslys+XhFfhMIxom7WbqwYE2AdvSp2hBBbERK3xMPUiiJLpofcB9kdQx0mtkfo7RzT+eFeMxDTLpQwEhvBN0eGbAhhrvbqaHL9QThQYevmbe45sQmAazxkaMs1DS9V3Y6tM0bPMBG2az6dB+G9wnnNr8Mj3aUBjEqaCo0cDIdUsOLjzZF8/xInpzcoQumsjJEpybH/5ePuknWhvn4FoBQid1PxK8q/YUb4of6MoZFF7Ou/7rO8CxUJDFG708qFz8lYPO23vYY/BvYne+Lzen78UXumCe8Z2Ph0BWu/Bzb1fusYXsPa+aUP4166JlWDLgyDHX63C5FAakI4O2FayeTs6teglF30LbpL8Q3Y9XpT4nKXxuFfHhK9ywyH4iVy97DoH4ykaqQqm47uJkyF5NU0nX6rrwXtzPN853hMjAWE/gydbojWwgOUTVew9ZJd3p0D+sZ/eWnkfmB8rLFJseGBdJzjBAE2fM4acve2OYqgZV9VmOBKyHTmWkEJ4gsh5c9OhpGbN3vU6isjLus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e362222-056d-489c-6bca-08df29021270
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:58.8950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oj59ClAnNroh0ANqfOeqp4E3zL7RNP+QPoQimSm1X5vcdwbSRdXmvuaQqy4jLGVlY/gAfKKSH8vxShkkeahxYmfyHAnuxDTf6YpVZGcz3H8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde887 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: PX2U1RIyxFKurJoc8PnOCTOuzNCQ7tlm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9LgJRjUj2dk8
 cIR3/A+Cwkd4mwgD3kwwx3cb8XeM2gYpUeFyODAcGKdaPqHXoZvqRezg0ifLVE6Uxh+8Opdl5i5
 Vs0jrxiH2IruQsf90XDOFhofYtAYzkojbG2/ISaXuGsCZANkmpvW
X-Proofpoint-ORIG-GUID: PX2U1RIyxFKurJoc8PnOCTOuzNCQ7tlm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXzfk9OGT68D4R
 eVovzXGpfSaLfZTQxAx9t5YWYwOZo3tdQVbjPTeX3AjOkR6x2k2KL5TjYJEDnndpywRfYj5he7D
 vX7LttTWltaSfQD1ZeX10Or9BGKp0uVrU1N21tfatlgCI5PAFW37i62roO1xCoXBAoTTEPiGxfH
 5Gco7i7pleUBJfcJ6Z7//3Y+XFv95gIPp+neic3bh1mGJJUG9QImZrZLB4JIHEIoWaYhdLG1fUw
 dNLvPkJBDMWlMkC6ctd4HDAuE19++UHxaHD03fTOlzB1DZEz6XmKT9UECAjuZq/nbHjE9WttLJj
 /Rr2T7LMWI3XTGE5+SNNHsMoHSZWzo3P8U8NRGoris12x9KlMSoMlLoUhCziooLwa7Mf4g5zebF
 /dLXYKPmokFIGyIkc3ZM/ObnDHq+K+ghVjzSGkiLtNAcYp/DoAZPw32LqltpI8YtZNxukVToJ7/
 YNlcR1XVoHJvKpHcx/A==

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ebcaccc4ad66..9c3918a63a23 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -540,6 +540,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -589,13 +625,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -606,22 +635,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

