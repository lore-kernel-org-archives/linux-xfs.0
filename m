Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5D537C93E;
	Fri, 24 Jul 2026 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900939; cv=fail; b=mvMogXbRVpU79l4oNSuZ7wp4jmAze655eGyP8XqkIP1cyZowxnHHvAhz7kCcyHnqh6OsiACZJPHaAMKrDZtfCjEdmwSv5Ezvvxw5CpV/KyJGJ32H8cJH2HE41yJ69bwA8OgXCSwbjo9MKh5yCg2uDLdcnBiPU3EXMyUOX3xkevI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900939; c=relaxed/simple;
	bh=njTJglz6sAl8ui/ufdVZszjWMc7PDvaN0mDPN5/sJwk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=c79/PQ2ZfIGLJbqbjIsAYmK1OKYLMPmGmXwQUds6rqdou/toGliHzcYWwR6xGAIeBCGV49hJF1FCv4tA0FP7uVXL8rZ17O6u2maALTFxuCw5XkqMCJ2jD3zs9xCdr1p4037V+uK1Hitl8RgTqKgpxKEzkHIODtDMYuWtMAqHY2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=otNjMEf/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zrDgi1nw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="otNjMEf/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zrDgi1nw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCto7P3393111;
	Fri, 24 Jul 2026 13:48:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9OW5h+9YKXU+vOMziV
	+aSRaNR7/R2p8BuOy6sEOv1/Q=; b=otNjMEf/Md3P369rUawvV1vPix6RFtP34v
	OZuZnMdnsSoXYspYY0mtxP+ui501DhQcqeODvkKMZS1S+yus3thQ+ti0C2jBkuIA
	XMR6gDGqmI9UpQQf6CtrwOYBS9CZFFn3X0Etx2xw7666eXeQoURS6O7+/JEKgpfs
	5apLJkEp+xEU+9cLIGuUlPn5oTfWBTgzutNGYx+8Qtqb2eRMKlhnXAKySiIvQj2U
	JGHq5hDw292AraUMrfXVJBHNpnXf+nexeiw6Ay/AUjQOW/rehUXMv8C0t3FyLQ46
	kFE1zLDxC5BMz+y2Dbk6C7nuN6Cxl2d8xGJX5lFEpuq3CEWKE73g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3rhua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 13:48:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66ODmcWp003321;
	Fri, 24 Jul 2026 13:48:47 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxt8mc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:48:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YgPgN6iMG0wbctEvtf5zKQM5xmGDcoWQY40ysLJqbe6YuvP5UvKdUebvyLRHAvWRBTh4G+BtdS5fuTZZCsctZpsEq8XI99MzuNGkTGozJrYvUbWk+vo4kt6pK84Z+eY3ZH3ZxyxIJycioySBHYc5iYrymVR4CtPC2EsqHdP88VIE+uTwTvYvTlmaaSTN33E6ktjwd7NYY9Oz4XS2NjKYa77+tk0OdQwsk2cn03gpKZgjFRA/7tdycvW0nyfpjboWr3i/bPNaFJ0jTE71SU3w14c9GOi9Jn7vY+8hdtWCePw+g3Hf9wUe3uKbXEg5EpWPKPC78QIAd+nPBDxe7txkJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OW5h+9YKXU+vOMziV+aSRaNR7/R2p8BuOy6sEOv1/Q=;
 b=EvqlblE54KrYn4PUFnV4SaSPlKftR/OMMbS/x17NeOJaqtAnxVhUemGU8Qlcxt5L52f2WJkrufinHXOFSAA0cuYOT1HvGAUYvu789YFVVFEl4mg0vhZjPJnDEbdKgPVu9y+f9Io7A8XwrJdFykBL5Ykc1ikt1JbuMynisBaoGY2Vkc0c6zpmMsXgNXPmh4EK1kdI1hjkD806CTnm85tZMWHnRJx1HS4LU/UVhve7wKaZVGIA4Qs2hPPuhZxdBvw+XFSf5oQNrMe4GtPOJ1F5dBhJKwGXyElj6RvtUaihLKzJb9fgkGdjcPgVlWN0Nvrr5KBaYXhOs7bWms6uC5l8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OW5h+9YKXU+vOMziV+aSRaNR7/R2p8BuOy6sEOv1/Q=;
 b=zrDgi1nwsgrWwO5LcZUMk3EjLTfGklWC1RYq17BjPzrewKnBHdxPJxuoXuPek8heJW2D1JfT7DMG405z+G28N1cDPYNor/Gr3EN90Ln8PlkDCNxv+RAwHHXQJkbKspXahCJkCUp3HCF8hJ84oxTStXi766tjOtZB/7NAsFgZAH8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7421.namprd10.prod.outlook.com (2603:10b6:208:46e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 13:47:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 13:47:34 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj
 Gupta <anuj20.g@samsung.com>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: fix fs-integrity for non-PI metadata v2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260724051001.202741-1-hch@lst.de> (Christoph Hellwig's message
	of "Fri, 24 Jul 2026 07:09:40 +0200")
Organization: Oracle Corporation
Message-ID: <yq1fr1833fq.fsf@ca-mkp.ca.oracle.com>
References: <20260724051001.202741-1-hch@lst.de>
Date: Fri, 24 Jul 2026 09:47:32 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0114.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: 7712fd20-20c9-4c59-cff1-08dee98a1dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NvVcmCNLYQYZ7I1eueq2A62IEASO9ye+SssfUyqGUb0qUhXARS93C7FQpuwVHfDfWZhet3dFxb+czYFvvhPQJJX1SDReTApaDO6qdIio/rc37bnrRdzVL+bOptIQ/b/j8iSbLxjXIFLZKm65K/fh6IJFcFEWcTflP9kJIvjK0zibpdMDY6OwR8B3SVtf/cKbLUB5fWWraINdLL51Cds1qjVBqe3rOL4vXj4ATMNz2bU0WpeQi5J4SKKKOXLfPa0tASKC7G7V5OaVAZlTbVUQkEeQNEkDS0lsb9n+CPepnGgdSyTJstsJD3bYHpOJeVvpYdrV9Hsdsap5oCmhMfbiCWfuZKHDdykokjX84tGWBKCHBVtNsCxAPPEnYz2f3VlY8nWt6qMPlWym1MnQck9936z/bdigtTU/1lM9udCFXHY/BEMP9j9nJkSQgitfLcrlBJJ8ySeUV8H5Pp2I6+y3+Myse+jICyi4feAFb9mYBoigiZqH0zXyWJImSJRSROGjs8d5D3GkixogNRYuWHKdT6o2g7cCaPCxV/SBe9S81EfkztHHXnaikhIDvdnCCkVdvvjZALk1mKeIcOyuFVporzxkGiloYNX3y7pX4JSO2wLoCPUirkFS9hI1dGvy8Lt1icZrXMvb9Xnk5MsAhS0OGlpDMO/65f6mODlS7Z/E1+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F1J/nryTlWxGPR3uHh6GIxr07EpGm7Pl/RjKBtRvevww/S5gbd2N3pcwC/3t?=
 =?us-ascii?Q?kBgEkWePzc3ycw41wMtSudn+TyivNJAeIDeY70aMTrhFxgJ/CvtlhdxOduPU?=
 =?us-ascii?Q?qXXKxay/JFXWcNIVCxMGpVy7wK/GHYlXtEs8sN0xQw/v41IAddnKAY69DXg3?=
 =?us-ascii?Q?Xw5hpd0c4N7LlRMKX2Xqqs2uOrQGKc3UEdIDjLrzivsYYfTDkEbqBrIdAFoc?=
 =?us-ascii?Q?wm/f8VngOB2OsZ/W4yElu9ae+KJ2IktaDnoTMMPcDpTRz+rEtnkNOa9SblPA?=
 =?us-ascii?Q?F7Of22zG++6ZNUEEAL5X/6DloPtoKPM3OHaNL9opXa+ZwXSJTSZK1Spl91OF?=
 =?us-ascii?Q?Zym8Znk/Fj3ngH/Ug0ibl9Zh3qVHVaLua/dNTJrAY4nr4WqjVSDP2Fi0BykU?=
 =?us-ascii?Q?YKIuGKZ9aXUH9jGznWX1kG6CbhGM5hUqX/ihhzUO83aK20e8PGL69M0wmE1K?=
 =?us-ascii?Q?SQMafj+naUSeLkx8qN4mnckLsrwzqTXh4eGpy5D/zEpR4n5h8kvaRF2WUEFz?=
 =?us-ascii?Q?0Hwe+8w7hiO21w/5vFZVMb+Q6TadZlQzFHlRdAQ2DgavuV7+wzivYnoEaQ/c?=
 =?us-ascii?Q?AB6mkXmixcjSM62Ti9+U3492mSNtwXsGx4ViC+m7sBH96Ib2nob5HTTIYn6u?=
 =?us-ascii?Q?RHTa9eLy8iZK5PoYDw7Pt3YkufH6T2Fzf3aNnXorQKqOxSyTzKSFmFe0AH+V?=
 =?us-ascii?Q?OPMOeZi2Jv/pPz+XVpGepE4ZjZjlIX+wPR5t/kABJ1Bh5WuDfe77XNf/Q12d?=
 =?us-ascii?Q?O3SyyqmRZPHmhDhFTpg3xlzebtLK2vZ2F7FEn/DG9Do1/JRHQzr/ZrNA9eS/?=
 =?us-ascii?Q?FvImTxw8LbWw5J0wItAwGPE19hk246hoBBNsRxgyyTmV6ACtWNJte/XHr6Gb?=
 =?us-ascii?Q?1BC1qNdnqT31eoe1ld859U3Gj/Ry3tWoLOSersaZ7Rj0CTIX1Fm5JU5Xx+6G?=
 =?us-ascii?Q?DHM3zSfPbK1xELdnCzRLjQCgUYfB2WvGhzhinvOipUrMLxZX9XOS+7Je9Ebm?=
 =?us-ascii?Q?wBvCI5/jLp2i0UgD+mwYa1zycL5oJ5HVRNQkmKW4upfdxGnsHauF4YXmkfLl?=
 =?us-ascii?Q?lpTHOScaQnUqikieNtXkpayC7hYsNBzPPvu5l2K5wjMnU8ZbliJm7QUNHETl?=
 =?us-ascii?Q?4tyKWAkpk4IlBrnBIohlb3zTGPe35inLIM+pCxMT2xsFaKc9nvN5mHv8UyWt?=
 =?us-ascii?Q?0aVN6Ts7W5JOKnI7a1BlnAnB0WWcWCUeC1IwB1d/VAXMZ9ILRbnVemTZRHNR?=
 =?us-ascii?Q?HvMAiZdPaLx6rkNJHv5GmoekGi6KesHi6dW4qM/mZ4pjdymPAtkIjFgwY9HN?=
 =?us-ascii?Q?wWreER8kzHDp9E6iqnJi2UVr5b5Hjl0aTHU15FhuC7RhHxeo9CoflJQUJF5w?=
 =?us-ascii?Q?dgJsEmZwKdIaeuNVvG0WriMd3JDrvSKjqD56S1zpJCaeEh+rcUDxkUDCuivr?=
 =?us-ascii?Q?9fC1Km4Vfx79g+Ndw68onnsMFRUWdJ6MiQz4sDUpNfIyVS/ScTnfpjhhsjDH?=
 =?us-ascii?Q?kUuu1tIgGd3gPq/AtK167ARovxSH8AcKWXxb6DetFduLFGro3k1MdvRXshHu?=
 =?us-ascii?Q?caY7ijUA06/S7hydHmA7nRsCnAO0Q+3m3rKZl1ksbEbSg3P8mMj35PCTcr2d?=
 =?us-ascii?Q?JBpabI1B6azWaDuK47WBH551XsJjm1rF4a5n8tu0y142MQjsMIN3mwOy/MG/?=
 =?us-ascii?Q?ATCuYwjAqilFJg4jV6eLqyGXXVmpacc39H4jzvJZVvGmW/f1VjUA7PaQ4lbf?=
 =?us-ascii?Q?DfbST1/6Ie1PaMQFyxX80W77nCmnrEw=3D?=
X-Exchange-RoutingPolicyChecked:
	p51yU9VHUn55p+IEMZZwGu+eSughL8yXTIAGxP+L5e5pue7m61Lup8AcqwUAni9A3TmDyHZ8ZjRarQVhjK7jEzmGkVzYIuz6uBlzIMVp2nMG/N05bD2iwpBKcItc1YJZ0UXxK8R90lEu6EdPCEe3HTs8WtcKhaPvJ6K05Q37RALQAFv3iVyD3Os/sWMf/XS+g6x65v2oO+l8bYYdZ3UalMjZMdQ32mtkFUI/5iqPYBARpzUm05t/Sg9e8Ecylx9kSlj32f2swa1jFkhSOHZ85Gs56M/QnI//v/tzomZBA/y1saaQvt/f0zTOepT850EWik3V0nZSzG78gfc2X/tPvg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dn7+uBJaMUMNqclGrPZAorA/m/fGZokisTxhpNPaZIhOG0LHyZ3CFkFoiFf6WbL3Bj8x9Ht3zD/ulbu7zsfX4JFDwfjvB1+oQCEFTZK0YCYeggmww6ojwDAdBqoFKabSGCrwtRTMFVWSHny4R9o/Vw+rWGiESfoIwM2VQEIgIlLtY2x/CNsi8rs8lEkkg8g3VPsufD61I9RnbN6fglUKUhDhK8wi4U29T6uLZMff6eEDBsGay3JJ2ma+9rD0/YF4jvYroZ8qHhDXnb5TbOprJ6+itci5UZokp3YR5oJuysJ3wfjphgvvnnO0ouBVr/5EHUjsmIRrKVztO8jIiDNIIGxj6MiTCLV+m1JXoqqYoG0MrwQJI69J6xpmHAh3qtN6PJovBL3ZyVIzqEiF5hcPvBeajVv0mwZOlkKx31CueJfbCCp5w4cCJ/MPBqU5RR/wufTBImAxnVnO6FbmRP6djMCVYnZqwcY133yWxANqpOU0H1hmpCsLO61Z1o3wwddNijZX3sfMs66b+W4q8wNEtsnzbisRnA3yweG7JMFmd0kS81Udk/28hqNpBo1kSHfT2BuSwfRhHovnB6Zspy4YWUFfiRH+Yd8VpADBsHKmnaY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7712fd20-20c9-4c59-cff1-08dee98a1dc0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 13:47:34.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOPptV0+iGmg4BhHdQBNvaQ28asQ+hb43ERUOc5ue5twZw0vOR348lfD1D+dYd6JOV2cuMIC1URZ5O0lY3e0oyK4udXfGitxnI9zHb3LS3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=984 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607240125
X-Proofpoint-GUID: w_SQaGdH3GPkvcCmj82XT0HgT_JUt7oc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEyNSBTYWx0ZWRfX3tuVl3op1R1W
 Y39CteEFGZcmThCCSm6bmJWH3NBh0EIWGQFf40s/Ti1dOpSXfKDF6fNodkB0IOjOMaeUkgmQIAj
 GbLDrsE95c6+bzGLQqnVOdUonKRPX2IIqvsVGHj28QW480dracLf
X-Proofpoint-ORIG-GUID: w_SQaGdH3GPkvcCmj82XT0HgT_JUt7oc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEyNSBTYWx0ZWRfX72WtJaCSFRHS
 yVAiL+utkgcrMjbIZI+eioJawWcCa3KirOKy1SzufiVr4ACRveOwlxj8TbrNyDSZ1GoLu9Pogwj
 E+eDO/L+n6gCKR2k0JvJAyMzpddA/8IxnGTwP82OB2ZpcH0NY1FtlSHgcPPmZdBZhg4fSlc6GR6
 CHBcRPgCLj6S9tUoqXLymNHiW/7nFisomfcdGzCwKKhlVjZVLVFWiPlLoUuVpAcdDlYBqX61LO/
 HW2BzEqRvLbLP9Q7TrkZMRCFPpvQC+g1bL49b9rIMaKV2gFPnbZwRB0sMr4NavXTkZr2UrHvm1r
 MMcaN3DwjTW1KYWydfu7yt+Xr6aSNfBNPjnrG5kJ/D/UJGwCiO2XrQFksZK9VmEurKHrlEA5vYw
 TVCXdcBM4NyomNO0YPOtrHmYce3NZuB6u6FdziSzP+qULmb7m+tK3YWK/sru5RKtNkCXOGRAcau
 8zWY/Yapdc1GXfeVIghk7o41LlohrHC2NRgS0OUM=
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a636d40 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=kCvNaUrntToXfF9bFgkA:9
 a=MTAcVbZMd_8A:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12114


Christoph,

> this series fixes incorrect calls into the PI generation helpers when
> using fs-integrity on devics with non-PI metadata.

Looks OK.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
