Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C0259C;
	Wed, 16 Oct 2024 00:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037512; cv=fail; b=i80Ph9LCyJEVAFeCzProY92sGJB7fFUjvK5RljiXqykf/JSRpxqEDmSMb08qxzJnYgpUsn2RHBuGlACyJhtIuojCPJjOBu3Y6XEZNg00ihaRwj/WY3svS+HZm5l6XtZP1Y/m8zdV6SbQfH9w2qdCGgm1ILBcQpZfPSVSjp1D1nI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037512; c=relaxed/simple;
	bh=MdUmciKtoz/QqrY+nukznfsBi6zDTkQCc5e2jbSGwlc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WMxyZyWcjOxb2IVrlA6lS/V+xj7RKC5ExiNhSvHeqNHsdpJBvXt6O7eLLSLovUA9uyi8b3oHZHxYD9g6afLlRTQexmEwP1xYUZNWTZQi3C8FVPodqZE2jPWf0fX3Prs7Q32GWFihrWBIWEQE6UrekP+yp/O9Fk4NFrZjS5+RRYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QZUJ0hXn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ngB92oiR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QZUJ0hXn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ngB92oiR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtiin001646;
	Wed, 16 Oct 2024 00:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vToyfmovG9qXzauVdmCZzg3AazJ2tFf/23JNbWxg9v8=; b=
	QZUJ0hXnDWWgV0VQyyIjUSbrFGRB4GIQD1lBytVrOJw944PjGfi4NcGXxGmJdcpf
	Ra5/KZSIl3WcBOA3kZeXoztFv4i9hCSlRMdJKNW5LVQUrUDaElaPGaNpe2Jt3x6I
	sXm5lDMkgHLhOq96Dze0IeMU7ke774k0QvWfll75HzPgcjwT2+luBsdZo+tQ5ThJ
	yYU4E6yCKXoe6JPVRPdfa/qPKk+pOC3cQKebpcCw3rCBkT7Fm3uG5wN4xyE0WqP9
	WByB4DzFi/DIqG1MWNB2O8mcMv54zkU0J7ORQydfhWKBK5m6Fjg+gcMS2AHlroho
	tYWfWvcTpKoUzDpsiKyCLg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1ajb0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FM6a1D036660;
	Wed, 16 Oct 2024 00:11:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegwrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/NpjRWB+0bKBIg/jwbTFtvDbD5xBqIHpTpo93Wt2g6wrI2nr1C0TIaL6l1w7ZQUMkrfgQuUbPhWcaiUxWTo8htoBx1Pfbte9ti7xIBcyIPzpJZm9H2EprT5s8uMQKWl8xnNypBXa2O+ih7PXYUAUUIn8+lyEt3ypB+C4UV9t3LOF+Tyb92M6w1Ua1HRH+eebuh+hf/Zh5bH5Ty++XCji9qlplXFXZgbK3nEl2NpuuV6UNZYm+n+TQd4fHoPILY85tTaUIWDxmeKqpofRFCDVnsnL+M76r7nQemY945ukRnEwVTr0G5BbmdyBgxZ0G0uo4c9qju2h3Hfrut9rQ6tOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vToyfmovG9qXzauVdmCZzg3AazJ2tFf/23JNbWxg9v8=;
 b=Np5N1v9t86Gxro0DPBUMhlQ+kXCuZSFktdJSY114YG9WpodfYSZpLEUDEOVFOypbLm1zfyRQecj7ICkfJ0oCQrf5Xyq6uQd4R7VLk4PShFvKS/IWkQKNPI9vazALvGa9fApfkMvUGX8Jp9kZ8JjreBPxP8IQKJkZnXHtlQuAXArMX8B73IGOXupQGy3q9t6ciIg6gLDmpoWtSk/top+xiXjPrApKS366Pkx7cZFL/3MdffiB8oFsOBN9SgSua0fVt10pdpRxcy2coVTulStk5UUWNYKe+8cvZ+Ry2ln3PJDt76Pd4JjpArTz9BDtelsaWmiX9hbkZwLx36iuVW0w5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vToyfmovG9qXzauVdmCZzg3AazJ2tFf/23JNbWxg9v8=;
 b=ngB92oiRBz6xGFa0mWrGlHPTXF5KmTrjklLHIv0D8SxeMnyTRxD+TUNW0Rvb/6d2YBIPcanq15AhmU1TAbzChBToLmOLiO1Y5JAxfU3mlS5oVtK9/8ooQzoW7l2TBhzWaOqMpr69T1BgnJY2Ffr94u3KtwfowWMOWqpdVv5LD7s=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:42 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 06/21] xfs: fix missing check for invalid attr flags
Date: Tue, 15 Oct 2024 17:11:11 -0700
Message-Id: <20241016001126.3256-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 45767afb-7201-4412-7cdb-08dced771cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pG3bquysINDHUFA6z36hHcgXvL798nWPp+iok9oU5TgWlxUxgvGkop4f8MQb?=
 =?us-ascii?Q?FbLSABQwmY6JtrrG0kZHCm5Ses+Ee2JII4GocDTOGqyirsGzRoqzVVCtrh8a?=
 =?us-ascii?Q?ZX6FxApKI5NVRDW+PnZx9dpz8+q7TqiHwa7NPy9jeci0smPwKWw4BWi0HR9o?=
 =?us-ascii?Q?1THvRtlpkfGD/Q+RtVgNn+MDet3vMD8G4003nqz6RqcpyWc0aAKJHzGa29Mp?=
 =?us-ascii?Q?RQuKuwcotSx3ZDuXlxfXXKPzHRMRhD1/0SBr8vcypogXM77QJaqVBRkCHw/J?=
 =?us-ascii?Q?YpMEQc0xqe47hFsxBRcjQB3FCdTYqdWa6iXkzr43PImlNxGTltOWkN2pGtHv?=
 =?us-ascii?Q?I7Cstv1mf358OS8vYPDnBoULXpXxHCGCGqxGVL/+zO41rbjX8WN0jrmL4rBv?=
 =?us-ascii?Q?NsbdhWVgAvIx6vX8YuwqhYiEHHBEVHynZNxtO4sywJxqu1HatnXUYF6PQQF3?=
 =?us-ascii?Q?fSAKn4OHFVxVIXGDQIH/y8gVEZX/EdFj94EbVnza6HYXjP1zB4DIBUqMev66?=
 =?us-ascii?Q?IdOOO73NeYSXJLHXzVrMK3eQcIxfM6cPnJAaq3V8UxP8IncbMqS+W9sb3Sm9?=
 =?us-ascii?Q?iA3AfWhhzUU4vuiUn1jc1JqsTWY0DpdyMIQC0mM0gzf9lMEqReVPeZEmHE6I?=
 =?us-ascii?Q?kXDHYKvQM4sXPKP45COj5YxUZvltPf/ZC9fNMGnh2K6VFkKT40kR+4evjWmI?=
 =?us-ascii?Q?gWDRYXftRaJN/Kb4+2rt1itJAzAO/sCyPKOLFOAT4ntGaumOFIq5luIQgmSf?=
 =?us-ascii?Q?kW++lAVOXu+lSGRiowyJ+Le1oZSyqIGK+PcdNBZgUVqXLACKK3ieYCHEJgh2?=
 =?us-ascii?Q?6Et+tbOEkwmD/AUyOEKwXpu8xuJM1aE1ryMYu0d2BcqdE+CA23aCO88DpkAn?=
 =?us-ascii?Q?zUsuv2TeMiHB1jblPHbsyFKDr5khShde4jVbI4tOG75r8rjc9ihwC+BZ/o3Q?=
 =?us-ascii?Q?pqhKZ1tseFjm5V5EMSNxNasdphQOhHpk9K5aMsnXOQrgivS/JzZnDALMeB7T?=
 =?us-ascii?Q?KNOI81jNeg2WwF5V5U5AMBsDbr4pafe3BQxBEVxdsuZrB+3TSv7kRXLqEAWq?=
 =?us-ascii?Q?g5BhfSiBGQb2iTOUDuWHcJVu9NcbDIVJlfuxmujcEmS5hlFq6VrKgnh0gtcV?=
 =?us-ascii?Q?yfFFJY0oqVgoZzW3Y4f1/qbuot3TfBDITOfYQmmNL7VVQLRxgO8M5LXBLtmZ?=
 =?us-ascii?Q?EVsy4sBBq8uGA/nB5ADvgXs2DWehy07LcJei1a2otw+od6XwCJjdz9rx+flB?=
 =?us-ascii?Q?B0cRlWQs6ams/uRNNyyTVessRDlKoAVgXNCbrIwj8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i5DKoUmXSAd/bY7RMbw38KSJIcvolmiF7lE64deZMNnlBjxHfrK446ypwuZu?=
 =?us-ascii?Q?oNkaxI99Mamc7XIwL6EYSYA25GjjVHMnxLJCT0ASINLdWdJ4wksX/wGcoIcO?=
 =?us-ascii?Q?A4bev/4P77tCtjkNRfdZ/4zkDPFr5NSr5KlEVl11T+Ly1NP26DpKiu69W00J?=
 =?us-ascii?Q?RYNIbUTYo7IKzbWk39co14xrxeK9BP8EVzjJTBD2TM3ddSxcxJiFq92/qhdE?=
 =?us-ascii?Q?RJrwkRINE/TBHUJjQJgh5u/B7wQQftLpO7J5sUXm0B/pHcwgHknJHD9zC7L0?=
 =?us-ascii?Q?IoeiILQ93zKEanzMPB7ov/4kgGYzPIPzEqFn1wp5WWSjX/F4XawXyIalKvif?=
 =?us-ascii?Q?bFJFDjujWTYKXgtxVWD+21hi4f6jSvY+z92FYRXo3fjACb7q8KBcpXF4g+c5?=
 =?us-ascii?Q?Q1ORBunAuPXSklM9f+6NdrViGnhq24JHbiZpeKcjTOpxce4vCC4wSSP/vGBw?=
 =?us-ascii?Q?Dsh1PeuxIl2D9RTAAoGNQ04S74S8SL00n5oO6a2F12ztwLZcTxCtt8Nl8MoS?=
 =?us-ascii?Q?2yoTgQpt5Yj4iE5Mp5fM3ItqdT9ZRGqhwaZTHGBqMFmnDeE+xaDo38SJs+0a?=
 =?us-ascii?Q?qoKgjQC2HvDZbg1y0ycXlGvvBTJSp0ioRRoso31CPc8c3p8bdqHCmPuBoYLi?=
 =?us-ascii?Q?KwUROPFpgdXNusuG68pc8H+yO4yMEuyasOFD04U8G4aDeX8iHaLWRpTBfDak?=
 =?us-ascii?Q?qR0mLf6rWmVknu02cycH2LK+ZBwA/Qdm3Jfr75JjPDD7Lw0hGHkdIHnD8aza?=
 =?us-ascii?Q?1KltOTaikF5enFwix/y6AUOhvWWh82Myd/AUoOB76S3SnXzbB6TKuzeWovGH?=
 =?us-ascii?Q?IQdP/D7KRMRd6vpxQF39YjvkT9zvVnsa863nDAhpLvt2UAfFfS70lt4LXLry?=
 =?us-ascii?Q?gRPGHEv0NfoczKHcQXixLLSIUdNckUzsJi5g9BnA5l4nj0yLEOT31XM2hNiq?=
 =?us-ascii?Q?rf6FJ/dxhFTx01a+8CWIXPXDR6FH/TMmyDypuCsD13KbKN0KGqgHa2HpTa2W?=
 =?us-ascii?Q?AnSSXaFE8RnNs45eTfUJzhL5XA7m/61x8OmrouD5g/byC4NjR8cFrKJu/4y2?=
 =?us-ascii?Q?jnZnLYtRcmfIn5W/wXfPgOu+zCrgAHH3Kj4TeFjWhepUTfrNEJuxYwJnCEd/?=
 =?us-ascii?Q?empgYFE9ewq5DjrJYJ1NmYcnLBH8VI+Nm64mGMfswzBi/mu/QP6vZ6ShMym0?=
 =?us-ascii?Q?9iAYQ1JqmfVFCRLV3G2IX2OT8kQMlur2lkZYW0JDN9dpAEmLQaNE5wvjIqUX?=
 =?us-ascii?Q?BWHKrluYl+6QjBuNDD3HD4kFZ91PiKqI7++EAbpgv41YYmDpPj9G1i6OABB2?=
 =?us-ascii?Q?2FVkQlj33It6i1kOUvcl3pk+7FzeByQv0X5jveS4wwhBzls8R17jRixdCHGT?=
 =?us-ascii?Q?pdp7RbrVTvZWMlABsx74qw39iLFKieBpnkrhRLm/m/Z6edf680t49WgmphCl?=
 =?us-ascii?Q?QZqJdlK2iQzrXJA1dauuNGXFFAr6thv6rdvQPQ5VXiiGTGnBFdLGDbHCw691?=
 =?us-ascii?Q?VlN19PmpzMQDBDuxNhGwgSOg4QqBjDDm9vqsJlZgCQ64V4sBfkGa5DJXw/xz?=
 =?us-ascii?Q?KliuWqGucCDUUfZwQ+95H8a3d7AvayOeaOF4kQDAqzCCmKjSlVhLcxOuMtl3?=
 =?us-ascii?Q?OYy1ZkjEmOAnChuH5P3i1J6EsPxO0FwzyOXVNpGFMkCFe17nfVbhmgabBPrD?=
 =?us-ascii?Q?pIqPdg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z2p9FrpDA59GiosGAcIGJqatBE5b7K2REFl2BKCXF0NixUQP8f+X1os4p/a56OJBFCVRTdDD+O0AMRabNtNRgBYUEq7XxXnpfxV+wkId4Kv2r8OTO1LbOtiSqU8Jcrf0TzDIRX1JP12RRHZKmUkq3brYcoN08JaeBZ+fESqvc1aEb2/5UG4FJsTIGFXYcrBKpA91jWqyYVHJB10NHaqfgijB7y+RoUHmYTw87qixn7rDu7Fc3AXdgsjUUfn1F0xnTbIGET1MP2QlO1g/rSw6L/ZQf/bzoUglVYSR10kRDmw9+ml1ZHZVdd8cJLTTzUfDbLIka5r3w71S2LwIjwxK/jB6uzhttfA78z6qEgcr1vHtHl9CbpNrw6k49PyO3+je50nNVdN6RLIhozvXgHG2a5PVXiKj7z8JJqAzaJ6u73Po6JnJgQHE6yGvL1/L+Yc1+IwGuVsdUipau5Q5E2UdWOsCWNIgWz54kaHxeDMxQ94cpodGWd3lLgonLNgaT32c9hGbuZvv5UA1Q4JTc2Z+8DMmPemB8C6WiRY4/Q7EThqAdwypQkjery42sfcwTj1rDIf16nNuiqNuBhncxE5gOCDzvmFidU4P/wrhtBPKLWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45767afb-7201-4412-7cdb-08dced771cf6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:42.3500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvKlQue7muQ8Ljy4b3cClWSn//AOGtqYeqyrBKYcFW/A83gq99/rEQdwso2Knze0AX59TaK/vVSRolmdPhw2KXg20oGsfLqT06zhCiCvNgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: tGMPqmQ3B-ouWNzfKbwWRE3kuiIlTK-q
X-Proofpoint-ORIG-GUID: tGMPqmQ3B-ouWNzfKbwWRE3kuiIlTK-q

From: "Darrick J. Wong" <djwong@kernel.org>

commit f660ec8eaeb50d0317c29601aacabdb15e5f2203 upstream.

[backport: fix build errors in xchk_xattr_listent]

The xattr scrubber doesn't check for undefined flags in shortform attr
entries.  Therefore, define a mask XFS_ATTR_ONDISK_MASK that has all
possible XFS_ATTR_* flags in it, and use that to check for unknown bits
in xchk_xattr_actor.

Refactor the check in the dabtree scanner function to use the new mask
as well.  The redundant checks need to be in place because the dabtree
check examines the hash mappings and therefore needs to decode the attr
leaf entries to compute the namehash.  This happens before the walk of
the xattr entries themselves.

Fixes: ae0506eba78fd ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |  5 +++++
 fs/xfs/scrub/attr.c           | 13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index f9015f88eca7..ebcb9066398f 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -703,8 +703,13 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
+				 XFS_ATTR_LOCAL | \
+				 XFS_ATTR_INCOMPLETE)
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530cca..990f4bf1c197 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -182,6 +182,11 @@ xchk_xattr_listent(
 		return;
 	}
 
+	if (flags & ~XFS_ATTR_ONDISK_MASK) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	if (flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
@@ -463,7 +468,6 @@ xchk_xattr_rec(
 	xfs_dahash_t			hash;
 	int				nameidx;
 	int				hdrsize;
-	unsigned int			badflags;
 	int				error;
 
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -493,10 +497,11 @@ xchk_xattr_rec(
 
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
-	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
-	if ((ent->flags & badflags) != 0)
+	if (ent->flags & ~XFS_ATTR_ONDISK_MASK) {
 		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
 				(((char *)bp->b_addr) + nameidx);
-- 
2.39.3

