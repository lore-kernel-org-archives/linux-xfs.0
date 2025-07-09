Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DD128853C;
	Wed,  9 Jul 2025 10:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055429; cv=fail; b=rAhWc2PNrLog9j7tuwYztGf8kVdjeW94pSjmYEzWtp/HqbnKxgEfBzjNtZZPinANbt3eLoDR5b+h3SHUCyS4Orbuy7h5r9HIz7NlzBZd/tzEDHPEmT1njx6/SDL2icJrfQk5w2fu+pkQhd/7HNgAmgENBsHz4k8ThT6emv8j0Fg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055429; c=relaxed/simple;
	bh=Cxss/bJ1qdk4HrWolD2cKO4R7bDmrG75nzgeQgO6hcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k5gfEF97eenQC3F9EatmPeTzS6bM+wVe3fzxlqGF38H67ZEMfMsNezUY8YR/i/wcm+nsTvRSVk7S490Ecj2K/SvbnApdldrc00292UcrXRQ8SYFthMaFN4AEbmD9KRkfzXOukVUgL4iStAEgB2BU1UQkjA5RyC95BbamoMlLS/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y4U72wLN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ezFCI3tg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y4U72wLN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ezFCI3tg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699jRws027110;
	Wed, 9 Jul 2025 10:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=X+E3Kug5e/bDfvhnRP/80xgMT0UUdyoMoTfXZ+jqRM4=; b=
	Y4U72wLNJVycOR+NvmUEVUnw8mvOpd5zELxDrmphhT5lqDVMG34FYeh+LXOUqT3C
	mlsaSCgXkCRd0vGxxbvNvRmRil2lBbCc/zQUqXr9NjCtX7NzwxTfiKon4NCsxN43
	T6XhDTRsk9/7mFXu753ZpbK6AaHgCUylXc6fmMcPvqe+ifNW6lbnL8m4OzcStyWj
	FYq2D0idZro/JeUlYdhk1gWMi7seE8Y+wSFG5lKG6R53o6sjosM7uBHyi4xpirgX
	h4nL5Q4kVzPI25rmSLikqjle0dqu2xXRnRoW2QN5jo2sgVvgJUn9+FLLGBPyB2FC
	SLW7P06qjAA/znzRoLr0Og==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sp2rg103-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5699d9Dj014001;
	Wed, 9 Jul 2025 10:03:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgashdy-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSS9QsCJWF7akveiYuRqMESGClb7tpRMoo6qfCQXyJI6HSZ8QmRpWlCLtIbyRSbxIRN4D1T4aXJxWpR7h1jUNITRXkmRmtJWN9OVOxNqugbu5wotYFvW8uyJkEz2VhBriccoAjnk5TtVo0dtdFPpV9eJtgFN0Z6JGdmh9YkpBTB8v7AeL137J/rPSTNFCBrutgdwLgHu6MEBHJfCepA/GBQnrmZTpURATH93ruL3y0sdTZipgxhE/GXjxSTk8P0aO7Ru/FqxLjnyCFQ5OkWxwqNOQ7B1oL7dlw4N1sG3tNZMYSwgQVuTFlwWB6rVeSMX6ACCuCCy2BiG1XcmqgtRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+E3Kug5e/bDfvhnRP/80xgMT0UUdyoMoTfXZ+jqRM4=;
 b=NdcvhAjRN5EhLwnoUFGYhsBL76jpm4ZluJtR2m5NfudppelBrYhCIM4LJky0Z0uHblYonoErIXARonr39CtCmEQE6r/JU3Fe3uJkGC/noFxOM8wxwMdjpKrajQjnEwO4dtpVZ9ShgQBJZNJr4mTYEFrjErj6Ovi2sMN2k1eEUIU2I2zrldhzYp7t+GPawMJu8uzxmgFOudyRU8rYgDEpdxkREDQIsX1apyWjENClrtUiO9J6lBJSQVlZGYm/fjvuJ06R3Y1U3CqWEiB97vz9P79a6r4Cdch1Uy36WLtY89Cn9FeC/GEGrMF8WNwXBZF3QCGx4NDtgcJeoQOjZ8v/LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+E3Kug5e/bDfvhnRP/80xgMT0UUdyoMoTfXZ+jqRM4=;
 b=ezFCI3tgwxCyM6+NKeIaJ1lTHiXe7g/DIFgxgrOPh3bD/gCtgwDpP1pof/dOm7xlwpkkP4p49bYOUuo8KvezBlYgEVb3yO83lD9AyB037Ps2ga72ddvL4utmlxPbAxf1d3jmfRWOVcGsyeiR7j+EyTqEa9eny8o+o29Ag53wK40=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:03:06 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:03:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 6/6] block: use chunk_sectors when evaluating stacked atomic write limits
Date: Wed,  9 Jul 2025 10:02:38 +0000
Message-ID: <20250709100238.2295112-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:510:f::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 1882d940-806b-47d4-d722-08ddbecfccf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XzkSAnA2U4mQNm7EBIXBkI54gcA0yQLQ3jQDE2bMNxm/YVuTelorkg3zcqVf?=
 =?us-ascii?Q?PNb00Ny7TbYtFGnMUHqUpRwsFgIc+rhxn704+JTS37SrPn+BgwYKVfRBtXwo?=
 =?us-ascii?Q?MYO/98xlIouu6IRXpRy0M5f58wsi6rbVf3d2bFCw+Pp07U4P3jW4d5cr5ykQ?=
 =?us-ascii?Q?Pqbxb2aLRiG5zwzCx0Us9IMoI+55p719E5PHUe4ZxOBTY35N/m7nYTyPy3MA?=
 =?us-ascii?Q?glPo5o8Xu+09Tv2fjA4MA7zES+LbnFuOY2J+GyHcPJq8nUXIzTywa6NW/l2I?=
 =?us-ascii?Q?LyNnA2uru7WDLxpXPhLKEN7nnVa9PaHwNXx0JyLLnypX9FymENX5I/4dObk2?=
 =?us-ascii?Q?FVz6ptKkSOthgIAiaYxwhokfVuhMiY784xpM74XZapRTiKLj7LRdrdLAXQ6t?=
 =?us-ascii?Q?AxKitZ1Fdwy5ySeOmXH2GkBdHh5CXrCIe7ONummSrkS9h6P52+V7ksj2LQol?=
 =?us-ascii?Q?YUbX7bsTMBC6HkEAuzqTov6Muk6pdvyNWVPGe/JYDAfctjfjrhx7TErg+1sf?=
 =?us-ascii?Q?wv5CeVfrFppBfhjSEgwq4wLK8qZD+0EU4X43Q7oF1WwicEeWg5qU8hQTSf/I?=
 =?us-ascii?Q?HUHju2yS8Ed2A0DWUx9xu+xd3DEERR9X0/meICci83Ppu6l2PuDBhZFZObhk?=
 =?us-ascii?Q?Pu9c9eyjmQMQ2pj/3qGHsqwW9Dkvy3IJPqPnUtY74vpExKLi0zftpjAZ6llq?=
 =?us-ascii?Q?EN+f350+0FLg4BsKg/0Zr1L5GXilGJlbZRDbBR7IuZ4/HIRO/IJV5oZuQJj7?=
 =?us-ascii?Q?b0ddTB5JQrjdIMpKmai6/jw2+hci3YrS142rM9MrMOKynD27bQ5qzs8P77JE?=
 =?us-ascii?Q?oswvDQcrrRcMLDdsPdsbDZHIpbKTlLaiHKPP7uBYPtt0knP5BpaKtm7/BbJi?=
 =?us-ascii?Q?aVhmbKo/YSPTOHtGKO6gXtv3oJ2fdbH6UyoSnc8EMM0YKx7XE2/QIccuPrRE?=
 =?us-ascii?Q?3lb1ZaTpJFZKex4cDQKR0FdEylGrzu/gse12KC4YaYmVdmH6t8+nIVBpj872?=
 =?us-ascii?Q?dfpEaVHpShXs+xcNB2Y5WeTmTj1TmuJVGJ/tk2vX62xZgaBVe5Plks6PhrLK?=
 =?us-ascii?Q?J09q47QChXF5KD4562QzE3JMrQy3fyCfsrAlbaGfjt7gv3vRwtIoxDB7pdcy?=
 =?us-ascii?Q?+PWBwM5EFpWOlsYKVUN+wrgutVsYN1Onc/GCTKJc8Ow1X00o/D+SlzeyJbGF?=
 =?us-ascii?Q?0W9OmU+Ewtko4uSazgnxJC0BCPONScN9LkUHbZFxjtcpkfV7vGAEHqokqkGX?=
 =?us-ascii?Q?R5OB5xiimcjoYqsHa388IhqVpyZYVtS5rIAl8uuCXG+N/bE9QUoL0QTF2A92?=
 =?us-ascii?Q?k9tIT73WfHJ0uKaS67jFOV67yWWN0O8tOUJfPgrQA/Hlb9aLkFFY9SE4tMuz?=
 =?us-ascii?Q?db97qqZC67MPDKWDkuJ438EuzbiD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZqfyvBSC42eBz54b6t6khQwUoDgSMIDxX0MfpRkvy6QjWt3O1BRE5Uz9QfpY?=
 =?us-ascii?Q?xkIEflvL1eTGByg1bGtL9T/3UQsnCG39dkCvkBLeXMUXE6uCn1lKxzFBFSfD?=
 =?us-ascii?Q?+JHa02nfVPTlIr/OcpqykQcPzwR76JbePLYjF0lcjaOUBsFgn2Q2XxAA3yaQ?=
 =?us-ascii?Q?cyOJaBcD6LAYNEDoB4nys79zOl2SCsaJuNA92OLA4zWHsJBR4/5X/VJ6t3z3?=
 =?us-ascii?Q?T9a0YyJ9adUTrOG5BdFaTmQEjeQpKMKAD/Wd+reUVClgU9eF9naCaxwVJ06J?=
 =?us-ascii?Q?/eiH1NiZCx+K4LTfSywbURgacQP7kac+AOZ6NiGdkkCZ8rUf0zP7MZ79qMn9?=
 =?us-ascii?Q?Ose1LNmXjNIi+NSsLhvkZ7P6k29EAA2bGznex2YR2l+fRNCq2+gFMQt3HRna?=
 =?us-ascii?Q?erB54qi5pIA0SCQh1Jtu59obgZ0AoUZTASkXw6Zk0kFM9INaOPCK/FlukUFg?=
 =?us-ascii?Q?Uj6dOCBOM+4cALRfcjv+y2RV1B/9nhDDrTtPdH6Vd5b2dhlkamYCiTt5LsFW?=
 =?us-ascii?Q?KC9TyvsvLkbZJN5mR9YlfdBYBiZj6UEQZYT2+Ineby0ajvNBxPCrCrGeuXMJ?=
 =?us-ascii?Q?AIruxc6+Dvf6qRycS9QMKgEPXDIoWBdmfn2F8qQOOAXaW2vp2tE4ggJOnS1l?=
 =?us-ascii?Q?fL/62t+YGBDrJWGCLpG0kuKL8ubkq/Ki2goAA0/eYuohoDNrADFdlnMUH5r+?=
 =?us-ascii?Q?o1wj9E/ruXBcWxm68SH+fshoVDQOZRT0jjIEI98onvn7ZwRvvb7u0rGeS2fa?=
 =?us-ascii?Q?h1gMQ1x3VhbxGhdareCmAae9JgX5gukZMYTv8pO8dq/Ddnozt+Wjmt8e99Rq?=
 =?us-ascii?Q?0wVQ9SKmcyVnzIrcn9AakIydZMnqz5ucj/j+R0/J8vMnptFBxlFyvEjhM9Uq?=
 =?us-ascii?Q?xWmDDV8WNIurk8C/qCDIoyehNxe/SMbaQpXVyI4Y7T10P30Il43A9tYhtIEb?=
 =?us-ascii?Q?8KeI/LlXdneO/9IPodYWsJ/D973bgzRNhej/RBdWrtBEJ5AD1VQr6h7b7RAc?=
 =?us-ascii?Q?kcyDL0lherq2lTXhHxnukfQP5c1x+NpPeaPZLWZ2Kf+lh0+yCGBj78Qe177k?=
 =?us-ascii?Q?TFOoGIYBvxJ5DGW/pAx1Nc2v2JdZ5CaMpq+mHX5SFTslUIvL4mJmyGp8r5sV?=
 =?us-ascii?Q?ERBCR50V08nL31DXObYk1OST2d6WPYQOUqqtD1//NiTdhFcw6tTDLu2cccvd?=
 =?us-ascii?Q?NBuUtq2iQYEStqU1IPfI5WqYRqHIWvcCmTPNzqs+LaNqH7HhmLHQR9Fb+sBy?=
 =?us-ascii?Q?2hPAzC0oTEIRChkXFShArlQZJ68W3OnSCsIPundAor6MUknoprA2bToKqRc8?=
 =?us-ascii?Q?+Hd9Hdj2OhaxmVSpVCBQxXJ9x/xRcdEC4+Yk/WPSDGO2op/i8ZKWFKd5Q/Aq?=
 =?us-ascii?Q?tDSGjZfmW6YfNJQGL+J1COAhJoJas3qeMOXYoS58yWlZgz1yW2uFook2utgn?=
 =?us-ascii?Q?7NEC6ppXLU2614K+prXVUbWlHS+m2fRZARo/cqull3EUUVXwIhRA4MxPsndw?=
 =?us-ascii?Q?fZsIGFXh/3yIpmyqSQaoU1fBu97taH2EqCbXbgEs8XL5r6AFjIdxpiNK9id7?=
 =?us-ascii?Q?/6MWC9S6fiw4QPhRMjydEOwYFLIqH8Rndgh7cW0DLbNVm6FqS15zfsvvvj+1?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZhY/6GcK7l5KtZ7xiTMAqeRkqtJ6TOfuxn3nSbXgVvax2TSQw/Z7AJJiqBrgSpy09Qmt5dDfHFYV5hKBo1zODuL5g+LRMEBi/mskwKUdYeCsmGvmbEZC+UlE1exRjG/3ZTWvqXMzA86DZfiKCI7OSxoTjmVs/yMO7iSht0DqOPRwA52KpJPAnZDB5LYuQF8/CqYlVWUWD70fAADk3WToXDC1QhSm0GgcjfTJHqNW0okR5DdxiHszmLLnisDybOswb7Si/RVZykRtG21BOnh6C8KiDEx2n5m94TX7+offr//Xzj8poSazoUvphOvGwBdx2mBINq3y1uKaVyyk/6V7MEskpNyqiVZhPb6Gvctdmu89otkVm/967Z8AeZSAxhGYhfglT9s9RXt8cOHjiuwY6gKulVItwLla02S1d6SyJ+hC7gis40RCRo4g8f78dHopRWKCwNVR5zQ12lvVXS6tpeEv0r3VsmjiUPaO4PM0b66H23qQCNpi1XtHQ33yw2hC19++CyWGrLg9II3IgQCMYfZYTICtx0nFBQjp2aQZLDHtzM5sZRwwkQCidGgwYUZqbKc9yQyUZSRDr7W4t4Wl211Rvz0Am9dcC8BElvSCV1c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1882d940-806b-47d4-d722-08ddbecfccf5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:03:06.6082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWtGh9iy7DwZfTBXB2iipC+49aX7+L4XVWBVImzinvQISYQslZCeFnW6Gp+Erp9Xv1HjpXX3bIdqmahtaPOfPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507090090
X-Authority-Analysis: v=2.4 cv=e4EGSbp/ c=1 sm=1 tr=0 ts=686e3e70 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=Vx6Y8ZnjGDVhUwe7cXkA:9 cc=ntf awl=host:12058
X-Proofpoint-GUID: Sro89cnt_PwNbB5v7Cq8JTTy6_azqRy4
X-Proofpoint-ORIG-GUID: Sro89cnt_PwNbB5v7Cq8JTTy6_azqRy4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfX4eknPQHxJt81 1tbj1Ii0Zm/rQluMH8yLrPOp29ZRo/wLNUDxvqpOn23VOoGVS8Mf8DTxsC1eb9VV4Tc+F5BGezi 4Bhs/XbS8ip+4NqOiqBpXf8EgTo4/cC+Lt/lDXP9bMfpYRj+HKN26w63xj19nkfvkROeOzUOOda
 S4bwseatPMCH5JvXuKgWxtjeC6mMcjefl4nU5yqvce1X7d4ByNr6CubEk2pForY4LlUAchk1JQs 389B2X+hHu6Slc1AgaESpdB5kWhLRJ3G3ogJHbvHPKYBQIXl3EJgpGQ/3CZtrOZdqDbaApukldw FBAHla9I5QSGzZxkAAZ6yvJiDO+zhwT70s6zjWJyNkPt+R4/3hG6JEkY9ZcWApBIqvx4+R6mLr4
 GNsSM9VNosxlPMS+KfeSdSuLeBYViamRIKxMQGRqO/fBy7gUMGbyI8qA/xWQswZ5HMTWdXpp

The atomic write unit max value is limited by any stacked device stripe
size.

It is required that the atomic write unit is a power-of-2 factor of the
stripe size.

Currently we use io_min limit to hold the stripe size, and check for a
io_min <= SECTOR_SIZE when deciding if we have a striped stacked device.

Nilay reports that this causes a problem when the physical block size is
greater than SECTOR_SIZE [0].

Furthermore, io_min may be mutated when stacking devices, and this makes
it a poor candidate to hold the stripe size. Such an example (of when
io_min may change) would be when the io_min is less than the physical
block size.

Use chunk_sectors to hold the stripe size, which is more appropriate.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 56 ++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 725035376f51..2dffd8bd72f0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -597,41 +597,50 @@ static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 	return true;
 }
 
-
-/* Check stacking of first bottom device */
-static bool blk_stack_atomic_writes_head(struct queue_limits *t,
-				struct queue_limits *b)
+static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
-		return false;
+	unsigned int chunk_bytes;
 
-	if (t->io_min <= SECTOR_SIZE) {
-		/* No chunk sectors, so use bottom device values directly */
-		t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-		t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
-		t->atomic_write_hw_max = b->atomic_write_hw_max;
-		return true;
-	}
+	if (!t->chunk_sectors)
+		return;
+
+	/*
+	 * If chunk sectors is so large that its value in bytes overflows
+	 * UINT_MAX, then just shift it down so it definitely will fit.
+	 * We don't support atomic writes of such a large size anyway.
+	 */
+	if (check_shl_overflow(t->chunk_sectors, SECTOR_SHIFT, &chunk_bytes))
+		chunk_bytes = t->chunk_sectors;
 
 	/*
 	 * Find values for limits which work for chunk size.
 	 * b->atomic_write_hw_unit_{min, max} may not be aligned with chunk
-	 * size (t->io_min), as chunk size is not restricted to a power-of-2.
+	 * size, as the chunk size is not restricted to a power-of-2.
 	 * So we need to find highest power-of-2 which works for the chunk
 	 * size.
-	 * As an example scenario, we could have b->unit_max = 16K and
-	 * t->io_min = 24K. For this case, reduce t->unit_max to a value
-	 * aligned with both limits, i.e. 8K in this example.
+	 * As an example scenario, we could have t->unit_max = 16K and
+	 * t->chunk_sectors = 24KB. For this case, reduce t->unit_max to a
+	 * value aligned with both limits, i.e. 8K in this example.
 	 */
-	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
-	while (t->io_min % t->atomic_write_hw_unit_max)
-		t->atomic_write_hw_unit_max /= 2;
+	t->atomic_write_hw_unit_max = min(t->atomic_write_hw_unit_max,
+					max_pow_of_two_factor(chunk_bytes));
 
-	t->atomic_write_hw_unit_min = min(b->atomic_write_hw_unit_min,
+	t->atomic_write_hw_unit_min = min(t->atomic_write_hw_unit_min,
 					  t->atomic_write_hw_unit_max);
-	t->atomic_write_hw_max = min(b->atomic_write_hw_max, t->io_min);
+	t->atomic_write_hw_max = min(t->atomic_write_hw_max, chunk_bytes);
+}
+
+/* Check stacking of first bottom device */
+static bool blk_stack_atomic_writes_head(struct queue_limits *t,
+				struct queue_limits *b)
+{
+	if (b->atomic_write_hw_boundary &&
+	    !blk_stack_atomic_writes_boundary_head(t, b))
+		return false;
 
+	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
+	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
+	t->atomic_write_hw_max = b->atomic_write_hw_max;
 	return true;
 }
 
@@ -659,6 +668,7 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 
 	if (!blk_stack_atomic_writes_head(t, b))
 		goto unsupported;
+	blk_stack_atomic_writes_chunk_sectors(t);
 	return;
 
 unsupported:
-- 
2.43.5

