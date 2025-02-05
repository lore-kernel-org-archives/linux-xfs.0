Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9735921323F;
	Wed,  5 Feb 2025 03:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724913; cv=fail; b=q/9W/lVvzR7S7TwE1YdjRi0fvPVJ4OuNLBRJUYZHGDxss1WcaeVw+wkJI2SZRMmkv6OQ16JmOtT6URdxR7H+Q/IchshmqEvIWZhp1Y/JP0KYKmAsrA0YZ88a9nApCHNcw5CJ/9UIN2Ea8pePqAkMo2CJlp+Gfbaxw9dOoFcMu8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724913; c=relaxed/simple;
	bh=9iO7rQuujORPq+qfdYyvyh9nWCZDKsjeRhULP+1Pq44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Io93H3Wy5bAqk7oJHRNHNVvS2hQt6DK2X4IRwtFdCmNEI62Qyo3YdGCIipptxkIvlTdNklI9vh1xgpVOS/HUdL7sFkUxfoSghpyK/jQJYOs6tHfWNpVeUvyqLfswDTltX5k3FHrg9NBX8CPyxm/nkWilI9XZytNwh67kkRIvea4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DbPKNr79; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wHn2SmvE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DbPKNr79";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wHn2SmvE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBvMv003148;
	Wed, 5 Feb 2025 03:08:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=B9EI/tu/5SawdRJDVzJmhbXNi9Szjq7S4ttnnUltVao=; b=
	DbPKNr791N9Dlp9cZbR6nUqyK2Z0Y1GW4/t0D6hsYrvsgYc8CEb+1kbS6FC1pu4h
	poNSMi+FKMiKAw9iYUJo/f0gOIlsoYNWTm505wUZ5HQhqJ6G+ZZ3Fkjb7dL77+wI
	XoOAiepOgHC1JazqOj+Fh1F43BfNsF35luy9ILHIcJ41dqU7oqD7LeJjbkt6si7L
	3TxZykHmlrP2srQMAuHHCgrhOSnSwFraF0AKxI2JUeXH5RNmxy187i44NuY9bxFA
	Vnr0itSkIxNgKCNst6foQR4mIROndQt0JmXXHpd7IBO4LiEggJrYyuvrueJxxsig
	Xbk1mcCQk5mhClvdC71DUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy863jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5150gUhB036451;
	Wed, 5 Feb 2025 03:08:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn1phg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OxBgChvR3sOYUVt0wuj7xwC8dK/b8NOVm2vZWqSHwcNnvOVr3U9o6OEWFAqPS2vZMh9xDwqLgp6EO5PHGNo/aKrx/95AMmZgyw88LrD3poYz8fqIIyuf2Qzv+CVa7HfS8ECMErmWV/bdTJOu2cwBDMzEpFhiGNeEIxXkqeceu0L92xdLeY/zV9nFRcjStOL3UBJT0JUAgJbX6xCGUAKGT1B18qh1vXd7uAIMVt8g9Bh9hzaMIm0wxlivVF/p4Wj7b1R6SPQIwnr39bK0raZduT54YUuANS08pKajFRwHRzWY8DiKZuVmAg2Oxq/damd60DYds6j6QIn1ghUo2uw3WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9EI/tu/5SawdRJDVzJmhbXNi9Szjq7S4ttnnUltVao=;
 b=r2gShrzRV9jyFm50G5C/vuSAhuHBTMzhT74d5FriqQM71qdBFaYJRuNqHbI9WVBAlVlcbfcOlVaiVVTg74NdF418cjqhFOQudjkc9Yvg5RHYqqeR3IxgICyUTdKN35qFXNgp1uv22bGQ9H9htxTDlnuuzRYks4cIQ8PsAgnSfUXKkCkTmLNC78bULXyY790EdFsVqKcFSnnB/TCjUa/v1+vJuV6GO3tCVL6yLCGXqF4RigqGOgGoaoKTqT5pxtDGHYZ8p3pMO3z7s8bg0+sTpAEQxkhkpvw2M0m8tVFmVckhZB38peFxrXaNFt7+g2FXlkZjHZ0KmVJieX+/37gR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9EI/tu/5SawdRJDVzJmhbXNi9Szjq7S4ttnnUltVao=;
 b=wHn2SmvE/YZjqMqCnxK7aipr+usmoTXbuwpK/xnazoJpauF+IoWhVgsuiXvmPR9HuHj3XzBoXP5Z/yRU6l/HhfGt1wdyZUlCVAWdSZ128CxsDDvFUL4qUcQGdCpJVvoKf0nn3EY5VwJ0cSWpaOWZwwigBzJmUd8Z2ybDS32ZXxs=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:27 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:27 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 17/24] xfs: pass the exact range to initialize to xfs_initialize_perag
Date: Tue,  4 Feb 2025 19:07:25 -0800
Message-Id: <20250205030732.29546-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:a03:333::25) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 8337c1f5-d991-4950-a963-08dd459250d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jRESrgzBIGgTw87xt6UPpU2v0RRBZgW5KnVmWn4lzD5h6HiQkpqGlRUwX3BH?=
 =?us-ascii?Q?5n8wKs+vKg2giPYDcM7ax2oHrECw9Ufu+KjVeUeRkHyYztZ4AF83tBBJv3gr?=
 =?us-ascii?Q?xq4JQu8bMrNKnhoEG4Owc3v4xtWpiPXl1bDdjCwT3z6Z2AyIeDGRInnM0IJP?=
 =?us-ascii?Q?BYakj29i/fUzwoNCdrJ+vtUpqkcltdA1Ae1aZrMsUodSdf4zKclNyBmDKzbs?=
 =?us-ascii?Q?vIFzvvtxfyigb61NoIOpQfpcxlBQ8qs5VL2AkB8fVjbR90tChqpnOr9WNsIK?=
 =?us-ascii?Q?a7L/lpSvxGERPuMuHoHpehYO1R5bnitGP9ysuDe+teumv0SAPs4hCrRmOEVv?=
 =?us-ascii?Q?6mhosPTQ2d3QVlA0RR2GPgKxIGlr1+Xqy5xCqRbSL8fQl+ofWezHZr3oLKFE?=
 =?us-ascii?Q?h/sP7qxeUiRL32PZkb3+YZZSyXC19KV33PDqjahEitJBXVrXlnmS7Q5KiKZv?=
 =?us-ascii?Q?HzjB3gJn2sj8wkOsJQSNTHyU1lEAPrJW7m8y0LQqMMaF9D4pH2wFFyNc6OuT?=
 =?us-ascii?Q?0hn9dB3y3kFCOhjfCTiUucpASTA2+GQ4Byn6yRCGJ5iCSlXyqcncrtQr/Hnr?=
 =?us-ascii?Q?1IUIfmXL71UJPjg2XAFCRsXRDcQesFXx89PWdnsxwltbx7s/8DlGYIUBCzDE?=
 =?us-ascii?Q?NXfC4UnZEEV8iVOBBmhKYs+NG0RxAkaCkhdEz7Zi2yPS+TQlQfex8kHm3fwV?=
 =?us-ascii?Q?5DdeGLvHLRiNxw8+6psFt9Uzw0qOpckgdRGtJOKm8xLbDE0Mp7JOk9iXQ8QV?=
 =?us-ascii?Q?l3wQ/sl5TxZTLxre6uSxJPCO7LGaVheLPtzzrZx+ZknweU2Jbu96gEfLzUPn?=
 =?us-ascii?Q?jEze06JId1ixQ7mImkHos3P5NupDVq6Oyul9lVFrIkskoA7Oqueue5UfSAOp?=
 =?us-ascii?Q?iM7BP3/GCDpVYRyd0VGmwBnYw8rnbuQ2CnX0ed7ohMdGDiFvBLs7nVNMciIm?=
 =?us-ascii?Q?z7L/9SxicA4q3YLjSCKirQgcwT9p8FwwXsK87a6/YMHhP5zNr1rYmiAjGJlu?=
 =?us-ascii?Q?UPUxbF/k7bVnJWPnbgSTS1aghxjUylLK0xyfyXsxl1V866BxyQ0Pb8I/pik1?=
 =?us-ascii?Q?AoaGXZ/mLB2dGebogwfu2POpAcR5AvlAXPKw4QRGhwWK+1rF7DepfDZGayxi?=
 =?us-ascii?Q?kQi2crWVzSVLrAw4FEeO83ot9i7V+F+tw4Qk269fUL538K642O6KOUWyUs2N?=
 =?us-ascii?Q?EiDTQ9A7/nVPAFXBFW1meti4OP0JouNZQRJPDwCb9eUdEu5odEtSWvM5FKWO?=
 =?us-ascii?Q?Dvxmb4IQrPza/0wmArL+MaQ532SuQg4bsKSGwqODuYCUDRr1oZZKh10TLYnF?=
 =?us-ascii?Q?wYVvQJy726pfDedLDzLwrUT+ZN6PD2n90vfoL3og+llTGIhiZS6Rf7yx/4nz?=
 =?us-ascii?Q?zRDBP1jOUkpWUab2d7+/Nww7N1aN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4nCiT5jbvHFxQz5jIQ2pDj9NnXPGRckU4hReY02Hh2ispt8idey0oToJOXUN?=
 =?us-ascii?Q?9ZrZqs3CN98Vto5E5ZKLMJ45bj6KAOSJ6z71xmN643ZqBw74ig+uPBquw50K?=
 =?us-ascii?Q?UwKdmty2pRal1Uc+7ncyLr7L3m95IG7nynj/rhkJnpfbQ0IQ5HhiMfQ594HP?=
 =?us-ascii?Q?GVC8DWOXHA3B/5a2Jbbhdonslaxn3XSy62JtIIxk/ADPJE6XHAL9Pz6/86nC?=
 =?us-ascii?Q?yM3QRDmedaRRFiAalmNQzKY4OkztDjtb+ptWu0AD0VJBEoIrOs1hHhc2t0jV?=
 =?us-ascii?Q?3jdm14N6rgw9/wExb5p185IIBcChucts1yJcseEfkkwihmsotR0VDIG6me5x?=
 =?us-ascii?Q?4ZAHoByxw+dEUbyyH6MinmysmJvXn+w73NDKwu/YCvKJJ+Nvtu1Gj3sMx8DV?=
 =?us-ascii?Q?0I/xdrjN69WbuDPTXv+xnvMMYRGTZuCpyNXanEfTSdVZjBqfsoYsoxdzC3Lh?=
 =?us-ascii?Q?Bu8TbYke9RiJ4qm0ojbFB4EvC74XO8JR2tcVbAiua+FpeAiSSbC2MBLaN4Ly?=
 =?us-ascii?Q?Qsp60UigCQzwMHs6qVh/rIQHb+6yAq/nCIdqdSLFsqSMO26+6ZEpBXaMNYf0?=
 =?us-ascii?Q?R4Y7hBwAY4fQpkK6TacTEznU+cijR1LWHUm+ysuMq5ew4p4Hj7zqQrKpb/JX?=
 =?us-ascii?Q?6CqdzlyWlvfD5JhYr1zjhAIxgmvI5jxk2/kG4UFU4XzHrOI/14fB9cT5sDOY?=
 =?us-ascii?Q?1H7TS8xl498c0IAEsY5/iIdaPo3DryNUpKCnGQRMV8pHTYEC7FCE1CUPfUs2?=
 =?us-ascii?Q?teEp4p3ib1K+2j7Xmtw7MNp+u5zZ0Br22um+MOb8RNzfofS8KeN4t3y5HuLx?=
 =?us-ascii?Q?S0qPdHNTYhDRL6Pfz2wPhZKWv/eKm9sAhC48IbkBzS24JQzCA55beuMYA4kp?=
 =?us-ascii?Q?bhR7kYXw/OeYOcTHxFqlljXz5oYiZDnmbCEV2Cw2KIt4z0D/K87PQjFMDLaL?=
 =?us-ascii?Q?tuDSEm0wWIDf+ClN3gN9IXvmHHphH6rQsAQqqUC7XMzcZcadQ30j4HJHA0B7?=
 =?us-ascii?Q?S2irBu2coHzWyECZbblhFqjfJpuqVJTNFGGqKSu8qCKQru8KGSyGjrZRXNi6?=
 =?us-ascii?Q?tUhm97M9hWxX7QNFPAyBFo6/Jl823bQBTIifMpnjgmBH6WOCx9EebM6aE83B?=
 =?us-ascii?Q?AhaAcmOGSQ+hYoud/6XU9j76ovLV2aun75AfG6LwM+ylUA/DuIw33MSsxRko?=
 =?us-ascii?Q?TRLMA6rq2ytLrnPtJ8eJLo9Qg+mmSd69h0glxlXPGRO6KF0EhuZvYKSmZI7E?=
 =?us-ascii?Q?s8mjWYzdngnN2sGK+moTX7u0kqqvUw2AjR0ILXgKrcdBDRb0qekqVhe+nx3L?=
 =?us-ascii?Q?tU64S0EnStAJD0zN68Gdak0fa8GSRh0LjqCbl7iGc9dnQDAUfSLWjTyh2L73?=
 =?us-ascii?Q?4MQAzJb+ODp4kyDDjcgOXZFBKkdGVFffc7mL6FO35RfPy62dqthW4F3ASh5R?=
 =?us-ascii?Q?H4RwyNrLiqpEvzuvwfRibC37apE97nlqamhIhDO37GOHCCO5suThacAIOdOT?=
 =?us-ascii?Q?8caWPXh1A5C3Vcu4NJhIIUB42/5aIDq90loKFkDFmzviycgJlIFaVkJd+USy?=
 =?us-ascii?Q?vo8OouILSA7RGrqbSgwqBQlb9mZ7//54kMpVPi+/eXWQP43pDQUKMq/FcHr7?=
 =?us-ascii?Q?oGYF+vh2cMzw17eqPbTsicPHE7Azc/twDtaObSPF8UZrUIJhOVTUuWbq7Inh?=
 =?us-ascii?Q?l3lE9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ctmO90Ba6znXXuiLQRStH8J9SCoVquVydQSuv5bRok6f4Nq0ffGFLwNpGjDeNTlI7nuDl3ZBakKTIzgi/+wXAgXpn9dC3R6vhigMAMfLF25WIQj/KS8o9OzbFHVJdj4AQXPrtFTzQcTag4IJfooXzPMmHr9DTXAYYzJU/AtaFG9lDXBPOsPrWYoL1vNNCYm0ykJLYYXOsr6wb1StEGAfpUmuFAqwUFJF3aR12JkiavJlp2lLEbdFuM+b1jN6aOlXH8iKZSNjn+ZHeDQMMTFg21B9DWxBbhXuO5OpUwmUuXjBl/dS/5XG8H0YvJxja64gZ4CCXF7lxY6vm8CzsogcvJI7F7SmUHiMs3NGmOaTr3QaE2Zl9ofm4W0bE2Id+DBhLsPo+9gMYYUnXHXxBKFykEuYiqHGbS4qP+mKovFfG8/jyEnMOpIFycyALlpNReRHPI1hw2PLwj5tr9fMU1qmJrF04F58k4agWfFZWRpcq3n2rOxl+RCw0uBwf42XGuWh48hZdGPVrzOg7DbCVVaxHO49jLbpZHosK5ztRlg1+4ZzT53fDm4OFPLyNqy/k8HyVDfLIYmNyeqf6sp8kI9IVH8b516ocCs+eAfgwLmnwDs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8337c1f5-d991-4950-a963-08dd459250d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:27.3159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYbE7GVACr2B+48b91Lw5X8kua2u817rB14Wo1a/dyP/nWmBZUoh5iOj5LbxnX/2YhPPWSA221KwJ7E3WHWpszB3z8JPZgxATApL7QJzIXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: twsKqiYj3WWl_VlLfyCAUOjJ-2O5hAO3
X-Proofpoint-ORIG-GUID: twsKqiYj3WWl_VlLfyCAUOjJ-2O5hAO3

From: Christoph Hellwig <hch@lst.de>

commit 82742f8c3f1a93787a05a00aca50c2a565231f84 upstream.

[backport: dependency of 6a18765b]

Currently only the new agcount is passed to xfs_initialize_perag, which
requires lookups of existing AGs to skip them and complicates error
handling.  Also pass the previous agcount so that the range that
xfs_initialize_perag operates on is exactly defined.  That way the
extra lookups can be avoided, and error handling can clean up the
exact range from the old count to the last added perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c   | 28 ++++++----------------------
 fs/xfs/libxfs/xfs_ag.h   |  5 +++--
 fs/xfs/xfs_fsops.c       | 18 ++++++++----------
 fs/xfs/xfs_log_recover.c |  5 +++--
 fs/xfs/xfs_mount.c       |  4 ++--
 5 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1531bd0ee359..b75928dc1866 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -360,27 +360,16 @@ xfs_free_unused_perag_range(
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agcount,
+	xfs_agnumber_t		old_agcount,
+	xfs_agnumber_t		new_agcount,
 	xfs_rfsblock_t		dblocks,
 	xfs_agnumber_t		*maxagi)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		index;
-	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
 	int			error;
 
-	/*
-	 * Walk the current per-ag tree so we don't try to initialise AGs
-	 * that already exist (growfs case). Allocate and insert all the
-	 * AGs we don't find ready for initialisation.
-	 */
-	for (index = 0; index < agcount; index++) {
-		pag = xfs_perag_get(mp, index);
-		if (pag) {
-			xfs_perag_put(pag);
-			continue;
-		}
-
+	for (index = old_agcount; index < new_agcount; index++) {
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
 		if (!pag) {
 			error = -ENOMEM;
@@ -425,21 +414,17 @@ xfs_initialize_perag(
 		/* Active ref owned by mount indicates AG is online. */
 		atomic_set(&pag->pag_active_ref, 1);
 
-		/* first new pag is fully initialized */
-		if (first_initialised == NULLAGNUMBER)
-			first_initialised = index;
-
 		/*
 		 * Pre-calculated geometry
 		 */
-		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
+		pag->block_count = __xfs_ag_block_count(mp, index, new_agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
 		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 				&pag->agino_max);
 	}
 
-	index = xfs_set_inode_alloc(mp, agcount);
+	index = xfs_set_inode_alloc(mp, new_agcount);
 
 	if (maxagi)
 		*maxagi = index;
@@ -455,8 +440,7 @@ xfs_initialize_perag(
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
-	/* unwind any prior newly initialized pags */
-	xfs_free_unused_perag_range(mp, first_initialised, agcount);
+	xfs_free_unused_perag_range(mp, old_agcount, index);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 40d7b6427afb..ebebb1242c2a 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -135,8 +135,9 @@ __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
 
 void xfs_free_unused_perag_range(struct xfs_mount *mp, xfs_agnumber_t agstart,
 			xfs_agnumber_t agend);
-int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
-			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
+int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
+		xfs_agnumber_t agcount, xfs_rfsblock_t dcount,
+		xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c3f0e3cae87e..a2c1eab5fa4a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -87,6 +87,7 @@ xfs_growfs_data_private(
 	struct xfs_mount	*mp,		/* mount point for filesystem */
 	struct xfs_growfs_data	*in)		/* growfs data input struct */
 {
+	xfs_agnumber_t		oagcount = mp->m_sb.sb_agcount;
 	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
@@ -94,7 +95,6 @@ xfs_growfs_data_private(
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
 	bool			lastag_extended = false;
-	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};
 	struct xfs_perag	*last_pag;
@@ -138,16 +138,14 @@ xfs_growfs_data_private(
 	if (delta == 0)
 		return 0;
 
-	oagcount = mp->m_sb.sb_agcount;
-	/* allocate the new per-ag structures */
-	if (nagcount > oagcount) {
-		error = xfs_initialize_perag(mp, nagcount, nb, &nagimax);
-		if (error)
-			return error;
-	} else if (nagcount < oagcount) {
-		/* TODO: shrinking the entire AGs hasn't yet completed */
+	/* TODO: shrinking the entire AGs hasn't yet completed */
+	if (nagcount < oagcount)
 		return -EINVAL;
-	}
+
+	/* allocate the new per-ag structures */
+	error = xfs_initialize_perag(mp, oagcount, nagcount, nb, &nagimax);
+	if (error)
+		return error;
 
 	if (delta > 0)
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9ef5d0b1cfdb..79fdd4c91c44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3317,6 +3317,7 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3365,8 +3366,8 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
+			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0a0fd19573d8..747db90731e8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -797,8 +797,8 @@ xfs_mountfs(
 	/*
 	 * Allocate and initialize the per-ag data.
 	 */
-	error = xfs_initialize_perag(mp, sbp->sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, 0, sbp->sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed per-ag init: %d", error);
 		goto out_free_dir;
-- 
2.39.3

