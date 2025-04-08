Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC531FECDF;
	Tue,  8 Apr 2025 07:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744099181; cv=fail; b=sm3PEWOm+EXhtyRRwYsRn1ZEp8oiAeawaIYf63SytcPRJ3DB2UD8/4bFwo1VN7QLnQHlsrJbPthRt3ZBCGqU6MuqFqtPeq3FZCCJ3lpKgO1F1Fv1OODxqrCdp1M0WBQ1ce835qVSIb36oR1fYV3HOS+9zdLN5/5vhSAhTfvmqG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744099181; c=relaxed/simple;
	bh=6hMYuhRdKUkloOk8Is9iX+t5R/07IOg2LDKTicZbCmk=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JELQph9pT5waXJRelBeC04Ue4RLiXAy9yX186XtHHlZIDDBy0eXkbMPBSJ8kDg5TD29YjbHRe/LjQwOAcvz4pDRvusRFawEBh/hDq7IyYKlFAMZQ9dq+L0ZhC6DAkdcCFsVJ2OsEZuZQpGKnO7O0aeFIb/NMcnZpOCOqwKuSNfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eYarZSxk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=W7XD/1az; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eYarZSxk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="W7XD/1az"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5381uVgv008056;
	Tue, 8 Apr 2025 07:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=LeHGJY7S8CsBNBxR
	gXD43Sm54zsYcJb+REt782V6/mw=; b=eYarZSxkXRmitgo0NJJfwZHJjwPBRFAf
	AY8HvK9Pwv0e/EqSbTQfROR/AOtPP2HQOinIckYk+ebW1WybbTKniPtYW1YRukqa
	KSj0vxcUJeHyAHgIQasWH9AluKVzGqqG7nvs55w+vkB9wdAk101LijQBaN/GNGIt
	Q5/OvDIRixnN0WTywqHp6osVK3Egh3QhYdKH6XlawQ3/DA2R2S9XP10RnAhCim6w
	XgKP/lKDCYkYxI3FWPH0LHiVq/dlF4VtqhFH933lJNRvbGTinzb2kR7TMKPCZeEv
	MhdnIKlh4KGJToPDpGMEwA23DWHFlidIpS0UDtUKyTEE0DpFez8GZw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvjcv7xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 07:59:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5386UEZu021102;
	Tue, 8 Apr 2025 07:59:37 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010000.outbound.protection.outlook.com [40.93.20.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyf7am1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 07:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUTNiI4v+GhnmLnby5F8FprwZc6aHCNalWoICvQcYBHoku1eaq27nBKbvA5Lsn+5m7gbTLN8BFZoZOEmcN0UrGTvQw1R0JNXwiDU201d4BOvFEPFaliQA4TPiGedyAcWvtIGlT5v0T9AQBu+NPKGSstH4Z2wlXwIyTem6ui0tqZxuSSWIlvcz7WFa3NU9esqbnc2ur2Do6L2RWR4rpWDvVFaccVzpg+3oqTu+XBDYk1npKtYkYjDekV94PDL5R9NUNAPEQMQlzcB53Ic/+/o9pAmyKxdRoHeUVJMyTGAZ9yMztNj+c1OSyzuovMX6RJCVxrnahNPc4Ur7QRJOHysAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeHGJY7S8CsBNBxRgXD43Sm54zsYcJb+REt782V6/mw=;
 b=stGUEDTGGwbvjsggc053aDYkjp5fi7uotf8ZHP01pT2YT/7ulYh/EVaCILGOf6xAJHEqXs8Yny3yX9oLJ7BJuRCoaReeQtMkp6FCiUSyihYCVgV3wzqnTMSZ9LUoQ3Da8WPtbpP+nglTQ4gB3jkez1Bym7k/VPHsrik1wn4m2T5EE11nrJW6G7/H7iOog69ES2MQh6UW1vKkmvOIJ2BYZ5GSC95tpuXV+eTsxPrs+kDbRpKofIbuTbT3P1NWfDp1WDtuxfrHiiyrHZyR9I1KBXFOffq1Zff0vyj1HRgF7/Yfy8mYy1K4Zqc2JxHNjgsIG1qwbsGYLkOSybehBkfB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeHGJY7S8CsBNBxRgXD43Sm54zsYcJb+REt782V6/mw=;
 b=W7XD/1azUx2WzKMt+mLeEjtiGdm7Ixo+sSg/rUT8rjX+7Wvm8UhC4mtkiQ4nYPqlgMFMiYfW2uRI0YEEgU+ijVvvVPfuzQ7mT6KFUgc9T2PL+gufIdvkiOrYhLGhX5aBLooQBsIhcIbldbiB2nFRdkl5n7YoX4ms7Qy1Y9T9oxg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7641.namprd10.prod.outlook.com (2603:10b6:208:484::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Tue, 8 Apr
 2025 07:59:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 07:59:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v4] generic: add a test for atomic writes
Date: Tue,  8 Apr 2025 00:59:33 -0700
Message-Id: <20250408075933.32541-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0bca53-5122-461d-00ab-08dd76734d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pHlXEnMsIR+ajVYdu4z66/WlMR41tLjyusDutjrCExqMd+T1G1YeltI8aX/A?=
 =?us-ascii?Q?72t72cb1Wrd5rtMm2mZyty7Om0jubKJP9LlFFaZLvoqAbMRTc+ZTax9fTxUe?=
 =?us-ascii?Q?GW0S1LQJTZtsor/cLcYYC5+woQoaRSXsrFuq4zqY59od1E8+5BI6UuXLEG1E?=
 =?us-ascii?Q?Guil7FH3X+vwBjBmztt6MbaTz5FoBeb72s5xbT/Wn/KYdDPzNnUHF3g8Htd8?=
 =?us-ascii?Q?I6Weuf8/dVww41QqCnKCOctJvOK8FdcDUD9e4H7JALDw4WYgRPMvw2Ypwjtz?=
 =?us-ascii?Q?4loh2EI33TWpYdmUKqi2cV64UZwLdEuEnq6vloTYMc7XLRnOAxypLRRAUtUY?=
 =?us-ascii?Q?Aoy+CXQU9aFuBmgYXCTPFcJZj2O4rAGgSClKpZyyPLO+KqCfyC6GjN3VNzw6?=
 =?us-ascii?Q?ua4hQ6XmB3G6+QUZbI44NquZpXxYYDuNErjppj9MeIOchqym1kNMFEMMDy5d?=
 =?us-ascii?Q?5PqpfY+tIg/QFB8dFnNDEOQkOGfhgIk7q+9qk8IVQsuHkwF20iMGcRWQ4M7Z?=
 =?us-ascii?Q?3Ga2CQtn2NmFtW0WAKODm5BGOz65SM6l3zJsfxcmjKNwadCwVZRswdj28+SU?=
 =?us-ascii?Q?+qqtBRMqER+cSJVOWi7/bbhWN59gp5y6uaAoFqoZU7EMxO/QDJB9MQV6HJ8U?=
 =?us-ascii?Q?jHHl5PcwyM0aY8b3n9JbegkHwX5+H5rKhPYuOh4ij2oKaJWFoXMWELdr6F2S?=
 =?us-ascii?Q?Ger0fWaO0jHuJ6mAJLti2T3EzhiYg1GLOCLFKAEq8y+SY40kpnvO4z2Xwm3H?=
 =?us-ascii?Q?PGz2VsF2Y4/eJBJLVM/viUMUUASs/mndiCa6GFA47jHC7ai9wc+vPOAdctYc?=
 =?us-ascii?Q?XQP/QcMFrPaVf/ECyvjjZjUasAS/Vl4QK88UhQMlRkb9DVD43IfjR0gc6BlN?=
 =?us-ascii?Q?foHRaiQD9uHkPJh6BynZqFNtDBxjpXIdBaY8BdttyzT+UXi9QOsfM9wzk07h?=
 =?us-ascii?Q?R0bFUN+wjRPsA1rRiCs9IY1RVCU5Ie0coIXetDweWlRb6B5+B1Srg85ain+4?=
 =?us-ascii?Q?L1KmdqrIgRqKyppTLi1EwYQzKoqNSs1bmqrN0Gsc8/KeUYIrifN2MbRU5UlB?=
 =?us-ascii?Q?bTFYuo0+shAHAepnUSyQqfKLqBvJLRJ4FZG1z1/d3+sxxmpMrsVCUylhP5ja?=
 =?us-ascii?Q?mAPWU2zJqlAkoAp852PtySDhjf719+KA/2v6yCVJdXyPdEF2ZKDBNbM27qw/?=
 =?us-ascii?Q?Svz4el+F1xkm31PIF489J4yf8LXoSWkzZG6C79VLKw6n5bJQ6bScLMgHeWdF?=
 =?us-ascii?Q?EoXoslKjyhGOCEbMuWDb9PvRxRgwq91BOQ77UoB85blWRWWbMGGuSDgq7Bzv?=
 =?us-ascii?Q?fIOL7w3jzVYA+E1VhREPxW/RYg/1nt3NaGb7TCE9AtatTGM9o0bWmahhieP6?=
 =?us-ascii?Q?+av6WksUIk9qgSzUyCJYPwF0FUTw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bGcA9ggwBBCAkmN2K7yyHu3sSDw25Lnb4ity6q0lXwEBvKXJpxfhZObzZ6yD?=
 =?us-ascii?Q?4MBSSjSI2yaR4qwx3irlgjA6ZV6wjrhZedAZ6aHREaTl5imb/LsFFrsVziJv?=
 =?us-ascii?Q?2+yKfO5oTWO+QV94hItEHi3uYme4HPns1pH2+mIfGh2Hvrs63mDIOEPqD9l8?=
 =?us-ascii?Q?bcJ5apon0Gj8LhFGdJUp5yRVJ6K0V2z37Zxkniy/5CLKRlU0rF35iM2AUsmG?=
 =?us-ascii?Q?KVjwtvOQknLavhc9ARSiri5eTufjbvNhqMF9k0bNkYm7AAr4Fubhb0zdPA6s?=
 =?us-ascii?Q?71stiyJHtJe/LT4x3XwZdQseJpHouuhehFxS53vlvWZwiXbV15iU/0LWRd6R?=
 =?us-ascii?Q?wlTKLlIlTbL49NO3Q2QtjQteruRlL2C50OOTIiHlTrhGv/ypl1WeyD39NmWw?=
 =?us-ascii?Q?MxJ7K0U8YKP5/qBZh9F8L89vmPivb6IOO7QlmT2IKU+SOqShFvXWiamVLApa?=
 =?us-ascii?Q?VQ71Dql9mHnw4dmJHfGVvd3TJYKXbHUNkKi6/Vlqu/MnSvFaX1Z8h7YfOPJ4?=
 =?us-ascii?Q?sg1oTaUVRYKLbpGNHWzBZaG056Qb1GgsiqnWbiPsuqAElehgzCw+WCMnHoNj?=
 =?us-ascii?Q?KXC3OiU+A8dzmBwQov+JRdAg5a/ZbvUgPEwcDo34+tgFVHflXC1lc8HxMG9p?=
 =?us-ascii?Q?V9u1B0Wyl7rXo8EXV21iKjXtcVoajFTKb9/b0dpkeHnp643UHzreq3YDVX8T?=
 =?us-ascii?Q?7ssj51SKXVVyD1++t3GYIUZa3KO4rxVRmelsF3LCmrLt9MyNdi4rLK361kKt?=
 =?us-ascii?Q?vmyc0857ziezQYcuCHnW9S3kPg8DQXyVMWkeDWJkNxSqM/+rf9ITYk1rVZsJ?=
 =?us-ascii?Q?0qNeGd4lBzBN43cwHwgve6ZinrtPAWYG8h+HremuY61RgQQ7VRvOOKa0/5Im?=
 =?us-ascii?Q?Aaxvuq9OE3lX3xzRDqjKPgavrOePTAghdJHDG9ZlkzVzlPDBOG0ETOUqt31/?=
 =?us-ascii?Q?eOQLC3SVQL2ADhA0VRc5OmC9lkj37DXWTkzXV+NwiNyGmzByICdLKS65/8sq?=
 =?us-ascii?Q?5xn7yDEoPtuxm8keT8d9g/9i2T9KrTWAzTnYR5k1ms1rq8tS9UtC718HixV0?=
 =?us-ascii?Q?Wkx0KJyA6Em7/ZLuOFnCO03YSQeEOlRAk5F83ie3C+movbPO6YuGwzttf8Wl?=
 =?us-ascii?Q?qmT+NIniAM0ir04BhZXBO5FvLSo326XFIpSCAquVUMinQtWn5iTz6LP3o6Z/?=
 =?us-ascii?Q?SfuZwXkcMRO3fGrgYFMoLMJd2lnRCeRHQkAe20AYOcvzem7pLuQEkuGO74Zk?=
 =?us-ascii?Q?CCils+tO1iTKUj0wjRpjVguPBm9/MOb7tgyAkyXHx9Uq3csPmB2MDsSPvMH5?=
 =?us-ascii?Q?6pEawtQEQIR3lFMQ0UbV8L9QQbp4pXs02qsw3iQze3eTwetsIbQcqCxY6ZHV?=
 =?us-ascii?Q?pJLVhiY6H0ca1WA2U6Pb9Lm2++Gb7jq3iDVrtMKi6qwRJwmBbvRcefOJjt/V?=
 =?us-ascii?Q?x76M94KgHvGiigAiSpQhMbRwkIt5UnOV8lMiWDj91XAGfAKZZruKyRUu169d?=
 =?us-ascii?Q?6gQO7hDGhqM1Bs7C9Vz9VWQeZzIiZ9awx+dPZRWfIF++fd/bMfB2i0S+8tiB?=
 =?us-ascii?Q?+z6RRtkDanLfM0ObxW5GsMn4CBGPwmqu3fxZJUM0fwBEnYuD2wBu34mYvGII?=
 =?us-ascii?Q?gW1n2QQnJR523yAfNlG5qZvmSWz8QhIwnbItoY8K0VRc3A1jh0KhkRQguefE?=
 =?us-ascii?Q?VXyfzQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bll3DlGsNt7TweFX+YYDZwuiimD9A4SBG34kI9V5NcymICsJCAkyIOKXTqZwqXeA+B/mT7r7ywMlwj+COxZbDLQxNMXQ49H/N1q4g2KTW2ejbHC0sZ03l4x/kTnMuOVcg4omqO69nB+FGooCEkHVPY8H2ermWbpo2UuFJd2DUo9gmKnp/cvP6HrwVrSzZ1LnR457i6LrFHxcTkxhvc4SPzNMoD6VVlz511Ox1IxSUAZKs5+i8kNV1emsIkjxbVsibuFHJ4zARJiWhVBN0wH/FIw628bR2nEsvepDGi4IHC0m7GgwgCCHM2bPHLQt3uUx0AI1ZKQ4dsJuGJX5fPu8/H66L/b0C4AW5cL/UzdvWdo9ThaYdAMM4n4E5WRJD3cWyrYfjMkSWr7TXNIj7Ng32KJFHpnuUMcpfq3r5j10aahLbFvkeKim9xMSQhe4BeSjy8S/ekXgChfsL6cFnFyRlSC+6lXwQ+O5TasbmMt9FrGZCuAWuwpcjtz4kcL2zSocJ7uzCeg/c10PVohWHHtVhM4PKV5gjEc1fB8pqcH+bAXRaFBGOLuFu5ytYFbMHkXBFd6b7WABLOU8NRyrX3WuiUK3oxxrQQYbdQlLDl64obk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0bca53-5122-461d-00ab-08dd76734d78
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 07:59:35.1175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AM54pUAadHjuqAYDxrnejP5RIJUmaTwMVQTJQb4A7wamjpL9Ey2RoA/GA1cbklBpc1UgaHoWGVKaNFQF1PsKDHkldH/FBzWty+ouepUmS/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_03,2025-04-07_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504080056
X-Proofpoint-ORIG-GUID: xXJXz9KVk6jWVD7fqQxXF4PMq_Sl2C42
X-Proofpoint-GUID: xXJXz9KVk6jWVD7fqQxXF4PMq_Sl2C42

Add a test to validate the new atomic writes feature.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 common/rc             |  51 +++++++++++++
 tests/generic/765     | 172 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/765.out |   2 +
 3 files changed, 225 insertions(+)
 create mode 100755 tests/generic/765
 create mode 100644 tests/generic/765.out

diff --git a/common/rc b/common/rc
index 16d627e1..25e6a1f7 100644
--- a/common/rc
+++ b/common/rc
@@ -2996,6 +2996,10 @@ _require_xfs_io_command()
 			opts+=" -d"
 			pwrite_opts+="-V 1 -b 4k"
 		fi
+		if [ "$param" == "-A" ]; then
+			opts+=" -d"
+			pwrite_opts+="-D -V 1 -b 4k"
+		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
 		param_checked="$pwrite_opts $param"
@@ -5443,6 +5447,53 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/765 b/tests/generic/765
new file mode 100755
index 00000000..f54f2e2e
--- /dev/null
+++ b/tests/generic/765
@@ -0,0 +1,172 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 765
+#
+# Validate atomic write support
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_require_scratch_write_atomic
+_require_xfs_io_command pwrite -A
+
+check_supported_bsize()
+{
+    local bsize=$1
+
+    case "$FSTYP" in
+    "xfs")
+        min_bsize=1024
+        knob="/sys/kernel/mm/transparent_hugepage/shmem_enabled"
+        test -w "$knob" && max_bsize=65536 || max_bsize=4096
+        mkfs_opts="-b size=$bsize"
+        ;;
+    "ext4")
+        min_bsize=1024
+        max_bsize=4096
+        mkfs_opts="-b $bsize"
+        ;;
+    *)
+        _notrun "$FSTYP does not support atomic writes"
+        ;;
+    esac
+
+    if [ "$bsize" -lt "$min_bsize" ] || [ "$bsize" -gt "$max_bsize" ]; then
+        return 1
+    fi
+
+    return 0
+}
+
+test_atomic_writes()
+{
+    local bsize=$1
+
+    if ! check_supported_bsize $bsize; then
+        return
+    fi
+
+    _scratch_mkfs $mkfs_opts >> $seqres.full
+    _scratch_mount
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    file_min_write=$(_get_atomic_write_unit_min $testfile)
+    file_max_write=$(_get_atomic_write_unit_max $testfile)
+    file_max_segments=$(_get_atomic_write_segments_max $testfile)
+
+    # Check that atomic min/max = FS block size
+    test $file_min_write -eq $bsize || \
+        echo "atomic write min $file_min_write, should be fs block size $bsize"
+    test $file_min_write -eq $bsize || \
+        echo "atomic write max $file_max_write, should be fs block size $bsize"
+    test $file_max_segments -eq 1 || \
+        echo "atomic write max segments $file_max_segments, should be 1"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+
+    _scratch_unmount
+}
+
+test_atomic_write_bounds()
+{
+    local bsize=$1
+
+    if ! check_supported_bsize $bsize; then
+        return
+    fi
+
+    _scratch_mkfs $mkfs_opts >> $seqres.full
+    _scratch_mount
+
+    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write should fail when bsize is out of bounds"
+
+    _scratch_unmount
+}
+
+sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
+sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
+
+bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
+    echo "bdev min write != sys min write"
+fi
+if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
+    echo "bdev max write != sys max write"
+fi
+
+# Test all supported block sizes between bdev min and max
+for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
+        test_atomic_writes $bsize
+done;
+
+# Check that atomic write fails if bsize < bdev min or bsize > bdev max
+test_atomic_write_bounds $((bdev_min_write / 2))
+test_atomic_write_bounds $((bdev_max_write * 2))
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/765.out b/tests/generic/765.out
new file mode 100644
index 00000000..39c254ae
--- /dev/null
+++ b/tests/generic/765.out
@@ -0,0 +1,2 @@
+QA output created by 765
+Silence is golden
-- 
2.34.1

