Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF42877E8;
	Fri, 11 Jul 2025 10:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752231236; cv=fail; b=LEHGFrxWGO9tDPSEgw6pMskhdwtOuvAgbQJazfoe0K819WHdGLBhYGvZU0O5aXPTZOZeA+D7+i52Hks9ET9Jc+7XiKTOtilyrlvhwhT1z94+PTKCl+ZZrY/pb6SSQYH7pWBh9Tte8flFaGSSmZaSSk5C30xCgAmL6FPFscyEJn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752231236; c=relaxed/simple;
	bh=VDu+d6nf6kU3/Ab3GicpeoTeUXROud4ZQ9pImqQt7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=afn04btmcNHSXOkbM/eDz4+d9W3PwzKSp9CHHec2wB4NqyOFKW9tp6kuINEo9faSfTh1wsfhFpnU37WtmcV8bSdzCd7cnjkw8N2TOyI5lZiLHmKG939BtBIF7OeBMjFfuS11jXWJa1GtAEAlD3U6YXjSKa3HwUcba0u0O2606sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X2+C1eFO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rWEmxSMW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X2+C1eFO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rWEmxSMW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAMM8E009861;
	Fri, 11 Jul 2025 10:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=T1sj3KtSTL2fhMnz
	PQrF2dgW/rH7nTiu7hVE+zqK1Cc=; b=X2+C1eFOeHCC92+mm/e0v9O24PKFjxcd
	0uUMduVYIBHEfdQoTLPIwQCb1q3nZzki3f3B2+ArFfNHFG8Y31CxMax1OflmL/T5
	2neWWcfPSWCEZuNv32ZR2UWJdceOUOerVsLBy1H9jp2HrEI8+/PfAEfAcq4QQjhY
	kY31XrVnsaV4LExcZLMLRvB3KwaGEjdqKjom+N7Ys4D5fF7yY0SeT3vvQ3aexQVC
	CXXIjJ6sli7EyrMehJJSsef3keQ2Kfvbs0rLYVBg0P6e4oFrWpEmsU3mMTvNld1U
	S+/3/VkVkmY6qHD2PL98sA9a//OAKGzSqBHMwQ2O9byVRisEKAPp3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47u0svr1n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56BAok6a021358;
	Fri, 11 Jul 2025 10:53:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgdd1bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Jul 2025 10:53:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMeNz94suO3EhgoRIsopOF3Zi8MZssWguAdkbEwDESQ/1om0PVoGLJAJzzDFIAy7Z6eLipNMAAHVM5OgUjRo++ALG13AdWmwmphOkuUl2XTZqHx5lRHb9c3Ol7v5P1rwzUhmjIuNsj8vEAVcdsVs2t77Y7ILFeR7nv19YqtVrmoGXbyb+Mx/FLIhPNt0XJN+ZMIb6PCGnLBJQzMiLM8YoZcYZ4Wnxcwsi3rY9ArZgah7Frj3KvLHOgpRbB9SaHY3138Lmx+X9qjQK+0GxuOYYzKa7I2Jh7pUWzZ3IR+/4+O5TrRv24syg3vuwGQtwVbPRPvEC0yZItu/TrakUsIMfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1sj3KtSTL2fhMnzPQrF2dgW/rH7nTiu7hVE+zqK1Cc=;
 b=esR+HJJzm5vS+hHSpVV+iGOGLsFJh5eXlxl4GTvmXmpFInUkitpGq3l77arxFzh5+Y0tHYYnAC52tev26AFOhqeYTNNNC+sBxokNVsNnCksd6Rmpbkjr4CyRdjb9ILeFd1tQrMmqgULc6uHAn12PxQWTA3qQ5XPapAzPXfZDe3YFtOOQQPGY1klNfyhxGgDHSpSC+K04XQrqyGxLecoO+VJ+KUsDLINXaJyQuTWwO37kX0SpWzymBryZEHReImF0x9iB3JPBsLy7HmXLJ3BsDkjGisc9tbBk2At4ZPVK2IpfCrya/9GW59evj6p5mSjecuOszyk1dLQ1NZx0eZg4fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1sj3KtSTL2fhMnzPQrF2dgW/rH7nTiu7hVE+zqK1Cc=;
 b=rWEmxSMW1HpSwXBLfJGQryHW/gAVGoorv7UMx3vASa65zUXMmwEuJn6nLIgwO0IBmLuMRTw0dmxjmwGI0nEsJ84gVyrztHI3tFkMhSfZfiWCcZlE0czEOYmvlkwLx4w5FNvgW+TSCRXabBNwsa0Of4aDQOgY2BTTMrrbXMHgm34=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF079E800A3.namprd10.prod.outlook.com (2603:10b6:518:1::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Fri, 11 Jul
 2025 10:53:03 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.023; Fri, 11 Jul 2025
 10:53:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, dlemoal@kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 0/6] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Fri, 11 Jul 2025 10:52:52 +0000
Message-ID: <20250711105258.3135198-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF079E800A3:EE_
X-MS-Office365-Filtering-Correlation-Id: d8b6145c-32e9-4857-b012-08ddc0691c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3gHF/bPvNdyAkz8c4gRv87+tiJkz/wjk0L/O06Is9zdeILv0mdEVzO3+HAKb?=
 =?us-ascii?Q?Uxa/l8rZthJVwaDUzOd8uaVfTAIMey+zZLTyFr0MxuLRV54rqYsB+1qvSXm5?=
 =?us-ascii?Q?pmRuO2RJRkxBt8KR3TtHGQlSaxbWpuFeAERnargp9YTP73VQg0n2bGmlm9bi?=
 =?us-ascii?Q?p92DIZaXi25dX06d/MjydzZsqK+yYvuGDL9BVMHix9w+Recz+tNhIymemMUj?=
 =?us-ascii?Q?JH45hoXUacZahHJxbyD5FY0RKsOaRSpXI9c6lEaCrUkV6XC1BtLslG1/cKCk?=
 =?us-ascii?Q?33fWyRMZMgkwcFIEPDYpdvFa9z30nVGi5D4lBM00unB6EKVDWfcLPqeNF87c?=
 =?us-ascii?Q?0qvhWvIK6N1JtwE5NzhV+pxYmq/vFV0iUqLtzbqJ2wErvxwlwfQNaEcNezAl?=
 =?us-ascii?Q?dAub65HIH1I/j0kJOQJCNIgaVLq0CHOd8oM80KjYsG8kk6Kygo0TlGyZE69e?=
 =?us-ascii?Q?tZ0tz9AaHEozXh9j7NITezCr1clGXg7T0MsSCHBQStvTGCSX61sNue/vv37S?=
 =?us-ascii?Q?iwVHmKJHnj1oJ2E8RQBg0s+kkyS7VHexrq4j6+CI0fOh/KzzB1VG0FFZxSrW?=
 =?us-ascii?Q?7KjsUsGKJob9weP1pv16WZIVPGwpPZCewU6ay7LBtio5GYQPgVJC7wKPQ4/E?=
 =?us-ascii?Q?OnCmCAIiTefVE8KMNrpQoxgU9SFzapjxEwxtu1nv+ZtA5hf43HtxndJvFPCe?=
 =?us-ascii?Q?LTGsd+4iYuiVS/K4py2KqnN56ySj0XA0ij6tu2ihTGFh/hRX6DePTSj2RDjV?=
 =?us-ascii?Q?16S5CKPlyQ5NV1XSR0mJIe1LoLwmwN2/WYQ9077kvNCRvMogywsHqclRAawi?=
 =?us-ascii?Q?HXAF5JPOvI2iWHVdAUIwQuMBScZ5COzcH+kJs5UceceRU5/2HlMC07Ebvatl?=
 =?us-ascii?Q?2R2J3AQ2nZLGBEJ1VTnTm44zfDfDV0d2nKtE5GD8v78A4PMo53Er3qwn6G71?=
 =?us-ascii?Q?0XZVjU28NMo21OZbML0XDQjKZW4gE9QD+S3EJZA9AhDMorEXenbLAq+8VLeY?=
 =?us-ascii?Q?1qFyHsKsNP1B+DIvkIRRRl7kHSSlksOJ8WpxOhsnJbwvPT8cvw7eHWhWo5UP?=
 =?us-ascii?Q?bioBo9bb+UKME0fS6k40ccEZi/XV2ocz0dfPcFNQJnjysslNvuzX/rs2SM6m?=
 =?us-ascii?Q?zXcpdGKqs4exjsZWzpqv2OOOL4kmrwb+G0KDE0qfOwPOWTPRBIh2aMv6Xy5y?=
 =?us-ascii?Q?5A6IlhwKz3BAF2Rd8nnsTl61M7RQVU3TbSb3PC5iL3IeXSEHlr3uaMJs7rHk?=
 =?us-ascii?Q?MnBJMyHVtsado/JvoNa6Y1+K6Di98O3+7ohf1dHsh9k/MophOe5nAEa5a8IV?=
 =?us-ascii?Q?TLngeakm5PLkcdxQbJUu96W8/MkHg4i8FVtGCREG62KKVb8SYdTpiGwo5ueA?=
 =?us-ascii?Q?oL7EpFRt24BA+Cs3JB9CTtzddvBS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R2JuMm7hdvRiA1UyLGZltaxcKUrG3QGFY80j1oL1UwHI5vGJ9nuX2o6oArG9?=
 =?us-ascii?Q?Eqt55q1h9QxdIUY4f37xJUJhDn8hhcLS47/D3PDOdYiBIgahQ0U5vAqiPc4N?=
 =?us-ascii?Q?cX/518anbwlIesh7Zv8nM8O+yFLmV/t/9tRBoe2LoqD09C2vdpqQYjhSJF13?=
 =?us-ascii?Q?8AjO8ayoBkXMaLQVNztU652jThulzojj8oc1lQmKRAWxj/Mmu/6EDw2cfNoG?=
 =?us-ascii?Q?fdbOcax5kSJod6E/ce3WG4yaeqlLpLFFXjkijwo1+UBnB58nGe/fZhAlm59J?=
 =?us-ascii?Q?sOnZtkLfCvNrT3uKBsv+4tiBN1Jq/rLvO5JZrS1KoxitdrIRlCXOdFIU15Yn?=
 =?us-ascii?Q?emp/u99wVIUWZ2ugynjhijWEt9AzZYNrLKhfmFJ7otHL8HmrAgWL4st+mGH0?=
 =?us-ascii?Q?Z5x79vlUY1t/GVLFtiwzTh+aFWn7F93z3ojymE9TsX8QYU/mG3F4XfiBDf/p?=
 =?us-ascii?Q?RURdhyoF+4/9bFxGLKWjx1Po+Srftvvep5JIjl+MOvorzMqZ7sOlgj0NhcNh?=
 =?us-ascii?Q?Jh14nbCYRnMeLtPNYT2lD1nZt3vttMKc1tcsut61zLDkubh/NaS4AhgacDAT?=
 =?us-ascii?Q?i8APZ6bohRN0PuQPdDiv+w6FYF1HzIcdf0NvtriF6JW1j9QUGTU9dgP5KSKk?=
 =?us-ascii?Q?h3FQ0oebMNJV4mhoqnRTrK2MUZUQe7n7eEEJdFLD2rtrnilY/1S0GhXZKmiB?=
 =?us-ascii?Q?yaNJ78zEO8hKPxTPzrqZoXQiKb/cXBEJg69UOI3bqaSjt2dJmdqc3vlnVDni?=
 =?us-ascii?Q?rt3eUTU2vkyztJAlDxx3geqN4UEDGauuunyRQ1DyC2CXBytZA4xIByQMEaZ1?=
 =?us-ascii?Q?iHAIkqBvPb/Besugv96KssltZMZZFei86jc8cmCgbruwTAOMhqwe2h7phhBd?=
 =?us-ascii?Q?L8kJ9JyUx6yeSHRMMg7ErZjR9ungVKtJUu20DMEmg1Yqr9WrmLxaJw3NnRi3?=
 =?us-ascii?Q?fNoKYVNq8LDSykb0PkpXYVqS3hMZWT/wUXexPTlF0jstDgcasp3MZmKjW8GE?=
 =?us-ascii?Q?ZtGf3wOuUZtCLmddEwne1WhL4MXToDU4bcjWGUUHiCktmwjS3abZCi5ra+Ml?=
 =?us-ascii?Q?HF/ZLcT251AIqeb/+MfQ2O0ymtKUSgicwp9K6D9g+G5E5NJqt+h4+wo/uvA5?=
 =?us-ascii?Q?QToRFe6QNEjEok8BNPD8bT/tp84BWVnDVDXJsN/6UrO07FUZ2O2IbfRXn+gH?=
 =?us-ascii?Q?wJkHlWCXGYty70Uk2TKhMMx8zLdxoG0I3XN/WRkrngWEIjaXzWVNpVypy3dR?=
 =?us-ascii?Q?Kw16+ViUjBMXNc2YDOKnmc0KZZuPnqAnPfcNVNyycQLdg4KP2jIJrdJuZuyq?=
 =?us-ascii?Q?dfV2pqZjNWZpEbFH6RbRoAnFKwJRcdNU8joARuL3vF/GXHeeC1CQSmhL2Tgp?=
 =?us-ascii?Q?53JRbYvQx8rjwMJrhVga2UkTY5lH2SZDBKQaJC+0pWY2pgzq5JHz8+rryMcA?=
 =?us-ascii?Q?b6+9hUFCZxZaGCBCRJxI89s7JZnzQY6yOd9kA2XthKOFi7xyV6u21J9nUAWw?=
 =?us-ascii?Q?ExGnvoeRJ4huXJTyQQpUudZldh/u7XKZBk0HD0Oie0Kg+XBiV7TceN6GPRBg?=
 =?us-ascii?Q?BwEmpx1f+AiTQt8g0Y5KbFrmyv7vWCqdNvTEst+7+XvtN4YpZf7idmOombTy?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8xZ4iC1pWgMs0p/oOtr7pCwc79E/JfNtLaG/ammjllbEjm9ikuk9wNWPy9fpZjvZF6Bw1wUhtafz1G/izh26Kh+j6Y5j6SNRZeQsfjxwc0vlHfYwZwSbCSPtU6rAyjoYvCra7eDyd+hFdAHm39/+Eu18Scpt57fH3Mu+Z7NGpV4G7gN/ZnhN6Z/9vgOICVz+NBCb9w3ojOwgZFVug9Yh2Ro1PY82ymyS5czrzfvnKnw6mhlBCMFyOOA5bMRWnJQ2QCWo4qzfxLexETGRr9yIwfjgxe7ftczEc/8u4m2nOiG4J6YWxD44HN9bZA6ehnMd91f1e+YoUg4PfXqI+g68SceYGiKzpvalGSsQc1d33NR8XAPmvVKAh+3DHhEYgGhYpg8Q4XL8i2sgfnKkM5P3VjuWCH+laxXF0Rp4VLZq8W+5NFprgLhBPJEZ9DBzEH2pC7uGunPHQpyY8cbMHC126K2EU0pjhnATyM14EdaI5qfisHi3Zyg1QK7jiJmUiWk0rzIwXOyVvX/4a9Qa7kg/T6w1guTP0c5rQJ7FXoGFEpi1uGWY5eoKpuLAG9KI9OoHDrrX4B/uldhcumj9XNvrSJwIv9pfGRrdLkavSUpqNuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b6145c-32e9-4857-b012-08ddc0691c3c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 10:53:03.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBpcNuIdsgoEOmH9J/In0GC3pDo1t/daF65uZskfLK1dNGlk8GluAv6P142/m5BFy7UjuW9kialVwFpZ8PsQLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF079E800A3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507110077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA3NiBTYWx0ZWRfX2f0M6FNbPe4/ SYg32nG1B5PSmmS8lMZAZ9V8u96LyMzI1Sp08oHfcffYThVXKf9Jod+lEKLqeqs1SGQDO6xDFQr TpQ8vU9k1XiG3d0MdS5qpt6KpkIfUnDYjUGCSA7ROvm4rmcFg9GfWSEKKvN6qEddcofXqLXvui5
 8vbjufX0HlX+k2vRklWULXIt/tOHZ26fsjbJUpyHOq0P3tEdK58/hFSK3JGF/2Er4IU4fT+ELxw P7H7G1VQ+DQKubckC+/LXyzEBm49UG0H4RnibRujvxQd0F2Hs5WWl79gV7huxJogYPP7H1gJHzh 6u6Dg8I8niHl8eGHALe4shNxMKKs86SOQ7K7f8qOwExy/pA92IY1Lehn9M9ErLKVZW6YbcsYSCR
 RC+rDKODJYeVPPeRhYl3yEhU0+RQOxYbWnigrNcH7CCQJP2TYzvYliX6LbXE5hlYvmdW3r14
X-Proofpoint-GUID: 7YO9oG8vsGEYlUo0McTDVOh-SMS3yH-O
X-Proofpoint-ORIG-GUID: 7YO9oG8vsGEYlUo0McTDVOh-SMS3yH-O
X-Authority-Analysis: v=2.4 cv=PpyTbxM3 c=1 sm=1 tr=0 ts=6870ed30 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=loq-tJhv0IFIE_0Y8b4A:9

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on 8b428f42f3edf nbd: fix lockdep deadlock warning

This series fixes issues for v6.16, but it's prob better to have this in
v6.17 .

Difference to v6:
- do comparison in sectors in 2/6

Differences to v5:
- Neaten code in blk_validate_atomic_write_limits() (Jens)

Differences to v4:
- Use check_shl_overflow() (Nilay)
- Use long long in for chunk bytes in 2/6
- Add tags from Nilay (thanks!)

John Garry (6):
  ilog2: add max_pow_of_two_factor()
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 62 ++++++++++++++++++++++++++----------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 fs/xfs/xfs_mount.c     |  5 ----
 include/linux/log2.h   | 14 ++++++++++
 6 files changed, 56 insertions(+), 28 deletions(-)

-- 
2.43.5

