Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6114F25A640;
	Tue, 13 Oct 2026 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879187; cv=fail; b=kmTu0+BY7w0bGZJR3xCb+0rW9i5z7UZnZeYhCaNT1NfoywCrJX30pO6XbNN7MAa0FeBapnnXht3iCW5pmfhUQDAotQeCbNI6b+fWUmWaPS8f9HvgEGwWMOS6KQjtwVlEQmT7Knd0UettXAZEVrx83smFewxT1xL82tqkPVwN2Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879187; c=relaxed/simple;
	bh=hTtpfE2QnYmScK7ZYfaGMNdjT4Un8xqLYA12Q8A9jwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XiD4n8hdQN8pue6qMQiMKO6Wzy/KVxGUzmc+wRgG6UkrSl1Res8QGctLyFGSYMj1w4M9oeGEQojnlsEFxzPvrrfXZXwZcMTorPixAxmeSM8cEzBDzqJQCjleiikPVkujT09fccS6b2LxhnENpDF/Y2koeoVE7o5nj0imnP7aN24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PxT8l5Qj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pEvQg5Vw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PxT8l5Qj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pEvQg5Vw"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BsqF4060585;
	Tue, 13 Oct 2026 08:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=; b=
	PxT8l5QjvhwVdMu4NGcrG5vg4zdJUFmyvwKu1Ho8A61nIQZgfaHJUb+lkkOhVMiV
	DHd2oImDpf5H7DCrGX3Ni76G8eL4T6qVWzD+p+zHwsd6b5QUFDQe6OapT40adno3
	JVtKTuHiSlJjVsJUo3pb8tsF+iA8tM5r0yOYmcRsQFk1NEtV++Z3l5xibiog26WH
	AFiEy/GhjYE5YjLsjDOzPXwKrR5iinz1qGQBdcu49dqXxrP9JYBg2LC0gT9Bt53W
	46HuaHmBf6eQ2+X8r3m0acVYV55Cx/czPpCZLuf3s3mele75zyHY4ZVHcn8mfgX/
	S0KHjXBUCXWa3rbZIcp/vA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkkq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86W9L024080;
	Tue, 13 Oct 2026 08:13:01 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9yvxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QP4eHpqGYg6Oy5tg4MwQqxGC3+7su2r4m77v3DMZyRHuEwzKsUTOs4/hV/T0Qkg7txRDTqL1KFNqRWX+nC0AMlqlzggVPZZO4iFQB/bNFIx6n9kcn91J70hBn9zwWujTvF3GtibqyCnuEKcGhADe9S4Vpe0RQbIUxCG3NkrAv47Man5/jIaFdy0uCkfee+l4dDc2VwnORy/ruOsSwliZagUxLuJrfHnMuHJYHXdIz8IMmSXUIkxm3baE2PsW9472MEiq1wcc5JXzOmzBgD9tAzJRw7U2l541gOIf8o/VtU5fv9htLIL25+HjgcafpFoLGicN4PhBnouiX3pToS3YPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=;
 b=kct+zEGauDj3EefDuEiPX7VO/brVHXMkQJ9W5iYTFJ/XxVc417RFxwolPmdTzgM32OlGHlnoX5aYeAWpkDTdeY4zp/jg8pyc3SPT7fz4j+lftuzA28v/MrmjSKlESifPoZcvBiNeQxXRG8GMwZmO9RZTQ82NIX0cJXxWhhMVOVY11Yx8dONPYqqhTi4hvBRdDHHpqUocYZTqaCMsn8UDDlMuBHJKSqJHQ9TcVqAaeruttzQ7/86WEBzegAog75I2Aff0ID1IWzhgMFJjxCLg7jpn8DOOleR8hqCHvdXGC8c6cokpwlFkxr/ORluE8sndpbMzEsyOfAkIXwa/6HrOcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a+bvJelLIOkxFLMe48NbI/pslV6ThdcbAIPLpwi8kY=;
 b=pEvQg5Vw8tlVRY0+EO0XrmVCSkWP93Z1J72V5OSF2zR1fzpd4GlZuArXwKFariwR5LZnOzDS/7WhXU1Ce3ObFIt4h/HOTJliuR8Ay9F2SiIiNoYKXnB79nzmaQ7/Oh9/5Lz6WhMLugcee6mJh4YzdG+f359Iv60F6//aI+y/p58=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 08:12:56 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:12:56 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 v2 1/6] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 13:42:41 +0530
Message-ID: <b374793f0f441fdf96bccd294c32c3d7351a9c16.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|SA2PR10MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: 04e7549e-e21f-4c3e-05af-08df2901c977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|10070799003|366016|1800799024|56012099006|4143699003|261009223027099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	lfF3oi9azVvlRjhwPsO6zEFMVPOerFjZgg2mdTms+SmGm+B6Rmn3sjDX1hV6W07TP8s4fhBXGzb/dJZd2N6uIQIz7BlhSZ7bSV768YxznIXAd14nG1+ky0lbpLw9Mfg2INwyGLyEJAMDuuYMXctbbLOKHrj6PdVKImDfpYPQ9qmyvoAvk7tbGupDB4hRnU9y/Nq1DYtr1RrIEC9I7Etq0EKKwE5kkKyiZJ8QutWpAZThEkH9xu/vciMgOblXq4cep3X5JrPVIHkhybpMYwDGq9MrseBfoNlS8MkOlDYPddBxrK/Udg/yn0mwWdaCXomk/BYsYy8vvPYtfXpKkQUmeO4ZIEbe0XaLprERdho6OwHUx8ak92wBJfrRX9UvvxwsraTQ09GPNRdUFkfVlGc5XJxxDcRYw4nUkXOtrYQEbBYPylQjy/G2aih/NNF9qqNg8TbepTx8sEPSPxwzjQnSXz2YYIJpbp2rNQgxhmwsxcPbhkecm/DDD/opfRUAu4xcASmb40yj7tTnKVhfilf4nPTL+XsWIH6bkpMUv+a1NshWR8H8svkDbsYDAoy5eteuQbyC7fX24fJKl1FqpOCoEhT7xL1uRHwt6XkaVrspR0D1TrUb3lZYSU69YRqaE58Tf04nWtnRoZjNjqGjsyGfYjlddJ+adCu2km60dOfLXb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(10070799003)(366016)(1800799024)(56012099006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WUH20PpNdAYNhauUXM+3Sqt/ytzIfbVuMt6FIwp71Ti53zIs2AfUitrfiE6Z?=
 =?us-ascii?Q?LDOY72/a3U6zi+Q01PfBbkvJT0PZGlXs6fZ+r4SU1gfXOBMfNGEPY+NkH6XM?=
 =?us-ascii?Q?h2Ip9KuTg7El5hy8aBsTzWfkR2utPYn8FnZAO0x2gc78R7kjaDOuxT1T/CD3?=
 =?us-ascii?Q?WrFYDQIG257b33Knt+qn4PFetgjmoT28F2t/unssjWlAuufsfr/bxNtRONP5?=
 =?us-ascii?Q?k/7k8hpTxq1u4njz6Z4QvUpLerD3eKMImU28LQH/bDH+CA2JDYPnBg/oNWSP?=
 =?us-ascii?Q?ZqeHglwjCQOXF4KLXZAsXByuEE0G0JAjlYWEowhC3GpExa8/LKl2d54w+Zwl?=
 =?us-ascii?Q?wZlcJPEXqjGHE7ewSrHwrPXRb7mVq/ibpWB0bMM8y4ppkCxsZeVcrPfIjK0e?=
 =?us-ascii?Q?X9k8ri9nUSF7RkBKZmVpUWf/SOgdcs03Evujwqedmjxxg97GQFIC7EneJthK?=
 =?us-ascii?Q?5dcPCJ+ChmkDlxs5etOnJGo2HQIlSp2Bycx99JfwNZBqMSWmstQf/apwowUh?=
 =?us-ascii?Q?sAnK/iB1u0u+6EaDv9X1SfNaIoEXiO/e9p7OCkguiEuQPo2LPa5HlXCF4Mks?=
 =?us-ascii?Q?w5y3Qn7Fd4USpyqT1yNou3SV3DswzEmHYNv60pRUQ5A5WRk8DtJeVSQ6jEM6?=
 =?us-ascii?Q?YX1AqdusXk4w7xCEJvL5vmTfp9FHORtB07nBJrSqvvIgg8afhJvPaXuyi4wb?=
 =?us-ascii?Q?UDmLMmgv0yTO8b4w7vxRWSyk9tWqXrJkOPYNRFTfj9XHUSoYltWpUr9TmiZF?=
 =?us-ascii?Q?PB60T0xCg37eLCSSTZGP13RzFyTk3pPG+DrBylAMHAVWRgesHR0FWlsSp+H9?=
 =?us-ascii?Q?1gqvK/M7GhhRYCwENTqPdXEOMRcK0gY2u0W1HFqfgI82WIFrc8KQZVLLfMxu?=
 =?us-ascii?Q?KJPQ6iQZT3pt8lUOyVtjAn0KrgOVQcvZa3wT6RdG0VR60piwaImChUdpal49?=
 =?us-ascii?Q?hpQ3uUfqxwNrj6uy5wjI07FvQfmJ2FAXwKOx9QVekPOvQIkWn0XO5/M0TZrs?=
 =?us-ascii?Q?2dvqv0FnY7UZlaR+4KWry441SzbtedT4aLxAzD0MrqAiAIPowxdi0xB//HPF?=
 =?us-ascii?Q?5cnxGLTFz3no/NX/dmKMXYhQSIQEL+TxjQj443Kp6UVSMpYaxUTr88Z4hDbz?=
 =?us-ascii?Q?tcZ0fLXYxDiVQEz/J4ImaAdPd60IwlkcEun45ikZyp5YJsmf9lNWVkbrckkZ?=
 =?us-ascii?Q?wYvWGgEJvANzH+FGT9SSmc8/u0pT2tDMlUKqDIVr4CjA9nXYnd8I8PJ6weyU?=
 =?us-ascii?Q?VXvqMXgfWNUjON8f9rqWl7AD71JouUDFJFDnJVYufI+kuTi0t3w7Web9pLOn?=
 =?us-ascii?Q?Da5OTIaaBNicBtMSCHBzfv37m20x1vTRlKUfMrL28y3jk1RBrn2pUZtEkOKR?=
 =?us-ascii?Q?915Jqjd0xn+iK3/cv0yiB0lWp5mKLBCmeA+9wOZJeKiT7zjXlCh1H5os3iCx?=
 =?us-ascii?Q?O51Bc9LBcL+kwgLMFZP5jyGS3O5M4W7ToHYCKQGl6Ye0Sb7Ms7u8dauCb+No?=
 =?us-ascii?Q?HppQPO/Y05v/nBZDJIrum0WCYuC6vQsnuRf4Ddu9iBuRCc6/EdGiD5BeHPxv?=
 =?us-ascii?Q?Epg35GL9tqEiDLByTC56iWdNmkKsLXcpPfGdifkgGpnkRLHLqJSHuQE8mm25?=
 =?us-ascii?Q?2/k/GeuIbV8bmCotsZWTvQJdTWxrjC1ysJkHz80Rs0IB3+UiHM9ovCO9AKt0?=
 =?us-ascii?Q?K4J3aSX+Z0l9+vL2MEA8i7PF9M84GxC7abWcIC+jaQyKhUXGMk5i8Co89HT2?=
 =?us-ascii?Q?TjbAn4t2CgOQ7bdN9gu3wBOM64zD1fNPyMeNOTNyBvp6V8d7nwAOrPiZZyRf?=
X-MS-Exchange-AntiSpam-MessageData-1: aAjYyRiihMiCAXsithPDxEoDCzSMkwV2RIE=
X-Exchange-RoutingPolicyChecked:
	lSCc9fdnH6u9zWWUOrSdXanThHXncerOCLLL0/eQsGnHuLdJoPX96MwxoLcZ/7Ux6i7P/655LVMdubBr+WFD6SUd9KdyeRP3XZdtgqATTYWXxViqUVP/UphFRK04UWCj9h9ZABwWEPUdcOruxvDgs0jf+qV4fS8FM7VKSipeUr4EVqBwIWGxsmECxllv3qoDtFJC8OTT0nYGid0qcOa+DRDqR4cKCKO3X5jF5PasR3JlOQ8xlGKdUB5KSrGta9K2XKwCV16ZZfYnouWziw0hMl9XruhsDNRSQ77zvgf7/+LZCABH4DZlSs5Hz6IS2XFY2DhFd1YnlA0uAvb2aDfAzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7I67fiz44r46CFyndH78tgkeNQTSKaZ95RILyfmGGRLJu7M3Yh6/hVmVRfvKsGvKsEXTjynvwi2zIeHkA6826bhLXPSar8out58VIZaqRXjaVXTRGluaUnhedIrSGL9Uw7Y653HUqInqV0avBtSObfk6mU8gsr4kYxhEncRSzQEfhYcWdQHxlUIwOAiyxBe2pLfiZGoDbPXFZemOLcgfZNfrp3vaGR4mOn9I1Tgo6siap+Xsth3g7CQqoh1J9QP7IRH7BbUmHhxAkfZ8gLrzkOb9B8Jxr/O8yut28uxicuPx7bshd8uUcgDZZ50ZOXraZd+NWa8AZtjW6Q+ewSckqMTxWITfUkb4fT/MOueQnz4DsGyHahf8je8lI7MoYWL+laTl/Afem5s0ZdxiO9p3XTkcq7XMXBya+qWfIiyxi3GG9cDtRfwV+0g3P9iHNcSIMWMZxku2icFaZXSxOHjpPfBmoBVO7jhw8R0OgFEJhTu0U8zK6mqhXB7vKTzkur9Rgxxsf/tfz0PSUm/TmgacBo/cFTsFZrQjO+KHuXETjUPK7ZYH3ywnvSF+nzwbC+jWhnYb7LGB01kxOsm4UHQJD1YXRdAvFspSriGTffHy3cI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e7549e-e21f-4c3e-05af-08df2901c977
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:12:56.3274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7DYizVd9c/y5uuePpFNpetYtbKksBddwriCKqBLh8TZWWaCMPZRR/4WYZAnvTM9wc8DVa0lQaQUwlWsDOTEzMk3e3T9uriiV8lG0Ya/a4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acde80d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-GUID: jiMAX5rqXVIgfxUg0QKDyjFNsfPUnxf_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXylT+XILfFULC
 zV8myEqTQClRn6G1t8ZhFE8AyQ+KvJXEiszKJU2oZ2PMKkKiKchct0zqf8DSmz9rv/HSeWXRWy8
 OeOb1SyHJRs5WQnIY7ZdXSR2ZM39I0qYsT0e2DpMHhHj8HzzbMzG5Jy2jaPKEu/6FS+zhRw9glR
 tJynQDpBJu9CCiAIw82/huP1f1XHRftY38b0JoYJCH2BrCZvsGuazAyNLXWwWBo6m+qXVvJqsPI
 tmZChUkIVmE65P4FTNy65qo8a+xd+Il8u+epQsJY8vo+Z93THx7QIUqUmddOTUMzVv8bDLUDM/3
 klf9baptIiD/N43s07BbLYsrc7/8ROmn6XxRzbHiqa+1pF7sGOkEWyR2IUt6imWt0/Vv1VxZu20
 Bm85vWxvH+L8HvDUv+seE6hxPUpgARzJrvlLpvd64gulTzlAF+sKtpQy64IP3RP7hGyAyVHi1pe
 d97qazHZbuVX2gAUNXQ==
X-Proofpoint-ORIG-GUID: jiMAX5rqXVIgfxUg0QKDyjFNsfPUnxf_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXyCJindtF4kDa
 055UtGl4RTZ9UfJK+92z8k8ZNFJsvnhEM3q3ntiEdevRHFKd7gnelYfQlQfYwxGJp6qRtraRCDN
 8TAx7kEE/arP2aR2fBmjZ9afrK9gj6+1kwPXZuxk4sONfAsSNi5K

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 08689839dd77..e22d103f5f82 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -923,7 +923,15 @@ xfs_reclaim_inode(
 	 */
 	if (xlog_is_shutdown(ip->i_mount->m_log)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 266fcc789098..3b487341348a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1624,7 +1624,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

