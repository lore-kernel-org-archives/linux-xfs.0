Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE8E3E0C57;
	Tue, 13 Oct 2026 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879269; cv=fail; b=rjOn8cmx7v28f3f7pzQlIEz1OyvompIb7fhDXeXU82UKydBxtisNItfiIuRK9nqRMNfVubVgT9+f5OPeygvBONMNS/OUKeKlJgBDYeewsYXenksX/ivwsyczoHmW9Gx9ez5M/zv7BDBI9WQ6u/hmPoDKjxDGQMTdnx3P7DHckvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879269; c=relaxed/simple;
	bh=riSTttPDYV16AWsBwMcvcWyJOBR18MvspbyK7gPuyQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g0HQv9nQbSwzTUzG+FeR0MYQOgV6Y77NmrzKBsNFXf9Xndj2uC74SWir3o8FNMK17s8qpnL9/+VjPsyIRJv2r91s9ZzezaQ2YQ6lykvRhFSf6HM6NKHcJZOFAN5yxmoeG5UmXztiMApRdEnVAAOKwy7bFyOAV2LSTfnaar/IOx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XagLizg8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vLQjCdy/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XagLizg8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vLQjCdy/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D3Cx3436329;
	Tue, 13 Oct 2026 08:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gqac8ha0T4aogKn6/9nPqbbNJSfMQGxdrmHHrV9M7jk=; b=
	XagLizg8HEPqs4Oicqq3/MuJkttXNsMDC7IRYkzJXmiLrVc2mznLh2XEG7//LlZg
	aZSrsq+UbWumkUX0klv1JcQccsI7YaGWdfqDDNCI/YswO+QAXniTbbNPsr5wUgiH
	YeF4POytmDzBGS5WihWGKuaxOwSxzFON6zD9luntqMJFTZdnjWhkanbakFXqd6Ra
	tSanmxEZRTln+PVeP6fUQsNcIDwdfD3YTKiXUi7V1kXsycu3l8cJZFDHwpV1EhdM
	DRRBFLgqqwargwVNtKBPK71BH2oUJYW0VLHTXYq3SX9JWVw7Noxr2SJdYr8jL7FZ
	n4wawmWGKSMpkhagrL7nYg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86RTu002111;
	Tue, 13 Oct 2026 08:14:24 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8yq61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlXlGVemLKrR3ccokbGIkiCmBMAs7jaIwR6t1QT4iVeQyAI8TAp3jN0urbPsYPVkf4QsSyH/gS1oF/3i6ghj7ISVfkudtquJ99PpVd6G/5/DlkbjImK68N3sGY9cqNhwecrcv+KxYl/4ll+34B0+IzyU6kx9RsbXVpk42tvu5ncy0DgEBx5dqsJmviZI8i1IAH2KxEJ7nSFfYcUALV6wowgBd9fpACGsq7hFiP61AWLPX4dwZb0tY3QJAE2yWfe0/I3CFmJGh3jC8fOX0m9DNbADaq/Iewm5bhGBL4u5eBaz9vep34lJxx7UUHUyuh4zCAZQolMdtAjIZyhLv5jP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqac8ha0T4aogKn6/9nPqbbNJSfMQGxdrmHHrV9M7jk=;
 b=mQWi53q2KzTU4Pct9bN5f0+AWUMdbjwtocHrKhwB8SZ0X+WUBRmvxnil/SRW3cCSrfvrJ4wDqWBIWwdBzM/DuTWU4h+EVKYMBDUa/SF5trhrhYOhsNKrcMw44dgn8oAK4ur1mP6Wje5vYuD8b+B0Vnrn4fTik6aG4oWvDNTC3aqGKQj8DuCCG5+L9KhQh4JCCbVjY1HvxvaCVONf15VTc4aPvvSLQuJBJUsXwZ/naayS3oAer7GTiNMDZ9bBpN/WLgrRBEhjNdwh8fMC0j0Ck2gMG0FYRy4Yrjo4RauhkYWKmUs3bGxw9su5lVb9t1w1WUzsE3FEXm0lJETnmQy8EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqac8ha0T4aogKn6/9nPqbbNJSfMQGxdrmHHrV9M7jk=;
 b=vLQjCdy/plNdoMS3j5A9IiyINPGW6xDYqUg+1FnfDXumNsSH19gFXuoTShsdWBu4FGbcRrgM6cXhmBB7TirOsWE0wKeGd/dMZ3CQ+uwBRNErQE2ZrsVeApFccinv5VCm85W8EFXu0oFjV5RJ+1xScLN/ot+ztubPCGNFixXhvT8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:14:22 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:21 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 0/9] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 13:44:08 +0530
Message-ID: <cover.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 717b184f-64fc-4173-40f9-08df2901fc73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	A4g8E8Xjwn9KdhTe0KZ9hsC/nGC8jiPOSveq32DhnIrq86rti4TGZ4r0oIRa3iwpqV8qwczwbG/e20/9OJRD+VHyJeaeSCMfIhQ3p4/sRTQ6Funfin1vGiJqcjlfCnYV7N3kjj/TaxcSYYwNyc5u2mrR0WiniSrezOTdICZVLZRFgGsOBk0FGVcUYFrnVrRwaWEp7x6Cf1Q40npcBV1Qwg92sb8JAKRXTWKBxiOKJLeTj0LID38D9VarCjdfTR6HxvJZwZXdxTaafE9B4T85BywSkToIcy1M430dAYDvKnSMkNHsu0g2a9WNBwxIv2IkqPQNaAI9LzUT+QjFPnOOKX/+zcJeML7hEYlEasKT8dXwdmBHJKxBP9cjnGWKOGYhA3ew6ukCLwgceJB6V2Jz2i1278mdu7wPBE0JRpniHu1J9ySG+hVNTK6DGX8PdtEVfI47Mg3K2aPCGeKLFjQTGySl2+BrQhN8npE1tKdlZXrCx/gvUXhsToy9cKHmiA99eMMbo063lz0XBQeKexyjbPRKkaI57jxLJYkhvoSiRebrekyGguzuTEcS4TL2IiUkFYjmOj6XXNNbeW2iUTb4P/dCCDQ37YG0GAHRKdV1KG8m5IBi9ieWDKq47/J4ZMh3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DfRmPxNh6IO9+bliFQky5fnKWj6TAoVlBnJI5v4ub+KoY8/aRUK9XPmzC8P2?=
 =?us-ascii?Q?/0WRw8f24vcK6oyYGm21wyzQrZa2QuRzVJcO1QpQsR30MiEuI6xWpCLUbDmR?=
 =?us-ascii?Q?vjv43Vj5Cq2ClUaSbQ4bGUQFnOmGuPGUecF9WU4nmRw24MjHubleVl051u2p?=
 =?us-ascii?Q?b9nkcfkQypBLrWAUlD0EPOHBZ8J1iEds0TNvcHUt+FxBbKg1gIVhbS3fogDH?=
 =?us-ascii?Q?jWQ2Hi961mqBA5Uu3QcJHpixE5vlJ2hVUONBLz9tiV7hddNNNWqNNb2rXJ84?=
 =?us-ascii?Q?P/epNosrVHPUb73ZY9/h53qFbA4D9WMbsn6u0jg00Ys8FPaDea5QSW0OAVhN?=
 =?us-ascii?Q?7s1XQIPA6M2RD5Qv04hFt8+zGwZPfFcDbil3H/swUi36clVad6ghAeNlaz1n?=
 =?us-ascii?Q?VKm2ABA4wyJu/+M/GpvPoXBADUPDwi26LAaJ75CbIW90BNV4yYGAFBwrlcQ/?=
 =?us-ascii?Q?4mQY5u3X9G7x2Le06NzTvbKtTLQZCuEW4aUtKiBFz7YdLPJ88GE6vkZDf6XX?=
 =?us-ascii?Q?+qO2t2dXipjKV3OrJ/GwHqztEuR40B9z+3YetZwCekSjCFP49tpY3AggL6a3?=
 =?us-ascii?Q?h0rYs16eHbfmZvHLKvPs35lMkFz1og1ZShElQjhhLEUd7wos89T0pCGsh6PB?=
 =?us-ascii?Q?s02y0axBqij+Mkb3KyoWeUM1T+rvC8Zbrf8ID/sNHhzNn8RpGiIW72YhfSyb?=
 =?us-ascii?Q?BWRIG/qimpFtsXwCIqJwsUym02jh59grG58aCIH/nIJCOeV5LFGVDmo7wXop?=
 =?us-ascii?Q?opRDraCGAe8nF/uyHR/u9o6P2Ck25oufSRqqjlsnwJ8rmGUg6eOiKQhae72y?=
 =?us-ascii?Q?K4GTsS0sHefgzzBxXP/WpCDsMuc7YVqAXoRChSP3bxGfpSGleG6Va+AExJ2A?=
 =?us-ascii?Q?rQ3MgQGxPaEnI+6NlVKCVo2ee1WCAo9vSUH8hGA4jq5ZDfxnu8edn+1uCfeH?=
 =?us-ascii?Q?aJxpr4qp9KP5bRQ49ng6IlIBbZv9ccx8lUJT6ZUYcWflR+d1mmW+joQFq4xI?=
 =?us-ascii?Q?WTvhBj6KBX/f/57A7rG4sFlY2J6I4cnsnM5a68LzH7iFT+bdrA3g5b/rNi1Z?=
 =?us-ascii?Q?xDDW5a293W9kgqm8ubg68g6tX2JZ15jx/ra98/z3TZ1xGMj6xmfKalwa7BPw?=
 =?us-ascii?Q?QgzH8jaZCxTJG+ocrVJi/JZI//OtSeVdkxQqbqwQEjhhHrF39vTcKflhhELJ?=
 =?us-ascii?Q?sB6cfA44YYy+ZBPJSCwHb0fgl55sr7RSYptya3wJztUZK07AtR4777rEOBzd?=
 =?us-ascii?Q?A3ORPQx0ASFfKTOWEZx2RKidBarl2ys5YC1yvYUBNS14m5zfIK0MBm7B/Qr0?=
 =?us-ascii?Q?1D6hmld1+a0hVXPcEFGppkRzKCYN35Dpl4O7rPuuO7M/Fe1UJf4PewjMQyqX?=
 =?us-ascii?Q?zYIhSa77Kcq+dm+Iibjkzqn+L8g4xTPrwB7vNc9jzlP52BkrJUdUvTFS9L7c?=
 =?us-ascii?Q?XnYwrbEP0enYWZGJQBU9pFUP4Fh2i5WjWKnH1Rlim7AvZ4KzLUHQvKdfLwqf?=
 =?us-ascii?Q?ZlOQQ2Nc4m/cTatX1USf5gGD+ECSmDJkH6/c8emgPfMfQB2/rrwDx7QyNdfN?=
 =?us-ascii?Q?mLTz9jdLkue0uCwxoHLeaGCb/YV2gPT2o0l9AZ3eqAp1ucBpKtDvUhstJhJu?=
 =?us-ascii?Q?anvLUIcxRNxDvxkeNK0I215/YQQjGCDempIt0oPKtHcntXbBNIc7WSDMWrPG?=
 =?us-ascii?Q?s9HesGE8kmaDseoz/oVfXO6QU15b/KDafGdXgwNVkPFH/QBMvqvb2P+vV61F?=
 =?us-ascii?Q?EBC1nmNb1KwBzubAn4DxFPmqcFaoQ37DNSxVLq9OdLCRVVxaPtsBuyxDj8rl?=
X-MS-Exchange-AntiSpam-MessageData-1: g+Yy7fMfTm4nGz8ZAGNVKBVF+DaZNh4IWj8=
X-Exchange-RoutingPolicyChecked:
	ssR1fbQrjmJkvPFnBq73r1Ak+jGYadssKeUOu8j9gMV4BP7Dg/g3amIiwpd0RvUrnSBSlkE/8a5nnzBGyzXp1km0rgMS5yax2w9gwi6++ejk+TG3oGpSVQwkjbpb1HCdyl03W+RKegIBMjtdri3K1HTE3a8VITEezRsf7MqBu363uNjVsbSoCUBcGAgbTl3ANmYaPsraiue/mh814F2GdfsbTX7LuZ1FFKLD3rzJL71b2/l8WKlLKDBxXWDVfIdAwjad3JqZ+lPBuk7UP11ufsMR+IOQ9D6DD3+iCcmfc239C9kZv//QUFbFK82Y+zBi2V+dzisV+YI0/i48ZTujyQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j5p094Of7wtOpkYVqOHUITdUlIZrfSr28hewFyhrwxsKQHgTKJJVqjmklMg7/rBmij6maaNhbjKLvEbTqijpWiYHnb1ZjHkB4w18/mSsrQ5RvULGTh5avINobnFPGmz85hTdgOSPoZ4CgJpKXIcTBb/O8a6kzStayeWgcKAOr9+zMThfo0gk27Fr+UtScV1NO7Ina49QypmlbUQh/lIHCxbKjmSIWgkjQsnePVB2cqvQRyWZidDqM6+WIgH/XQ/ESVt/3bUKOsymIoWWQRN6qBOPnYkavYwmTeO3nm4uwEOLkpr3Cnt9MbEUEk2R4QqJI7QJkvAglIzyuBYANKxuZOovXo+TwDi3CKqa1mmQ/NfXAV7ps/11j6uZE2nJp4Rl04IsTF+xqzZCWeAPdOEcCRO2As561fg/WobYQ3rs54DZg1ygnjQqtORUPns1RIDyZJF8Wt+MlBYZicIbabe0OrT81/TA4BJYCYmPBQODW1saUUz0Zu7cFHNjsROuE1Rpm/hYzgTARPpfQ9ci6FBjOrz1QSX3jlhchyw/FPMGFcoa6/17xT+wguQhTHqvf2f2jreAnqU3H0xIbjx/YE/YJsQpGlmVXHqYy9RYicRkfeA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717b184f-64fc-4173-40f9-08df2901fc73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:21.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gz8KYhfPBQP+86g8Tn/OiS8BWGCbVS51J3dzUfr3fmdXd/eZRmuyf9zgUBbix53VKQP+27watRKMHU+jMo5MftujBX9PBzFZ3y92Nar+SqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde861 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=kk7J8XDwd_-Zc7KFLIkA:9 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXwTThqfFuuS43
 HPqsNizFVvkYHbUkYOztpDT1CGiBJObJBTYzyEh6rFGRedew/yk3mkBNSlyHldrV1g17gehbApc
 Rk9QtpZ4tUzW0GxWdXJ8FM+UR+Pbxr2SFHocKsRvCnOkkdWFCSjd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX9sC1CgwMra/s
 3ZmzAYpLcxHMNOuDR412lKOCvU/ax6oHfFSL+VtwCB43IiBEptlDv0NQalRFhtQfsCVJsI83/54
 rNR9NIefVz44xASn1jfOEEt96zBghPEFl6wYA1cgYznsChS9tlnkKL0Fv+Q37qt4NgVMDCV1/Mn
 asoO19VTfnKvigQirlB36PYd+czJ0hGlQ++x23c6gYwIWzx3x/rA758lsukYGbBe38YLks3eZUo
 nP2mJ2qiaT2Kjliw1yy+HhOvm+Fiq9kCVZq3id2CrmBdCIDdGweDDui0nS+02DWKjTG3QtP2Rh5
 W3rIFgXt8MrPSmTiD8+ewXbzDDjzAbsqC17YyArxPz78Gh6lBznIKw8e+GIujdL8SxkW1VmcEzt
 lMKeD0n0ffpTLWxUSsRCZtH4z218NCOn2XPZe5aGQip+uGOFTP7Tm9h/FzIjixAVBHwlQ79bq/w
 c4Q9P9UgBnrMdAvJB2g==
X-Proofpoint-GUID: vu5KHqjNIybFNXhEMO7lxIEbFa3vEFGH
X-Proofpoint-ORIG-GUID: vu5KHqjNIybFNXhEMO7lxIEbFa3vEFGH
Message-ID: <20261013081408.t8AXIAvU9lrDc7nUxdWQajymLQ1DqoZHEdwxnXcy_eM@z>

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (671 tests; gaps)

		Failures before changes:
			Count: 19
			IDs: 075, 083, 091, 112, 127, 263, 269,
			     270, 363, 365, 373, 374, 645, 700,
			     733, 753, 754, 759, 760

		Failures after changes:
			Count: 19
			IDs: 075, 083, 091, 112, 127, 263, 269,
			     270, 363, 365, 373, 374, 645, 700,
			     733, 753, 754, 759, 760

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (312 tests; gaps)

		Failures before changes:
			Count: 10
			IDs: 104, 168, 179, 300, 348, 442, 557,
			     597, 598, 609

		Failures after changes:
			Count: 10
			IDs: 104, 168, 179, 300, 348, 442, 557,
			     597, 598, 609

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (8):
  xfs: log items should have a xlog pointer, not a mount
  xfs: aborting inodes on shutdown may need buffer lock
  xfs: buffer pins need to hold a buffer reference
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

Guo Xuenan (1):
  xfs: fix super block buf log item UAF during force shutdown

 fs/xfs/libxfs/xfs_alloc.c  |  45 ++++-
 fs/xfs/libxfs/xfs_ialloc.c |  32 +++-
 fs/xfs/xfs_bmap_item.c     |   2 +-
 fs/xfs/xfs_buf_item.c      | 382 ++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_extfree_item.c  |   2 +-
 fs/xfs/xfs_icache.c        |  10 +-
 fs/xfs/xfs_inode.c         |   4 +-
 fs/xfs/xfs_inode_item.c    | 164 +++++++++++++---
 fs/xfs/xfs_inode_item.h    |   1 +
 fs/xfs/xfs_log.c           |   2 +-
 fs/xfs/xfs_log_cil.c       |   2 +-
 fs/xfs/xfs_refcount_item.c |   2 +-
 fs/xfs/xfs_rmap_item.c     |   2 +-
 fs/xfs/xfs_trace.h         |   4 +-
 fs/xfs/xfs_trans.c         |   2 +-
 fs/xfs/xfs_trans.h         |   3 +-
 17 files changed, 467 insertions(+), 195 deletions(-)

-- 
2.53.0

