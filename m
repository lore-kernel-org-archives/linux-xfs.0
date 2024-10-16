Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3521F28EA;
	Wed, 16 Oct 2024 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037553; cv=fail; b=e6QcuBqFe1oOPVL+4JuUJ9Ym+Dw2bYcDzgpTh2BcvRlNm72jlrRsWYxC9mP0TiuasjEDLPOJQb5noXdRvFv4xQEM+BHHp5ofF2LANzOHVO/S9ceSiWrRR29LjvS7hAMAWdKubXCT/59W3SGeEIkTL8F+eD86GWVJnRUp6WOLZvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037553; c=relaxed/simple;
	bh=mtpjIVhfsL1l3oMw330XdUzBlkGACqvqJ4kDACMGEEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ShGQxAIPWO7NRIxnhlq4rP6pBQfmIrE2RBoJ8g3UOrw6MCDlL4yVrAIL8+wXcAxMg4zJzuq0H0BaUOYazml+1TlC7PPcLp/qV3eg3sjnstHavZvE/23UVVUgswMKk7gaeIJYtn66Q300QnhZrNrNB47nukE0MQM8BNL9/PRsCpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gv0XUgrV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0VO+5QBJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gv0XUgrV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0VO+5QBJ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtg6N023479;
	Wed, 16 Oct 2024 00:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=c5eAMquoqAeTKaod4nVoasZvNuBWSs7r1zSh9UHGUcg=; b=
	gv0XUgrVA4w4Tj7nTIDSo6aerepuphXlZOmXgxMQNxij6tpGdbFhFs4t9ZR5xtjh
	7UXSbCnACXcXjVINpQkCPABfLABoD16VkimTlDYvGqe898ZRn66JRhsuRtpkpwde
	OXqKdKSaudsuZSgVgQxWtfOKcdWjtnFJm7Hwsr4rWO+gmae3BGv2MOCfjSRNDjC8
	OkjRBLxGiCsvXLHM4pl/Qk/c8fFTrb1ad+OoADUdX9OnNhQLDEd7vQugdMZB691P
	Rgt7skMtaBG62A9Js2bgoCDK/hZQmAouCoLLzVAXS+ahO2zEPPTAbkKZ3M+KS9wB
	dLY5uUFV3cDcyOJO5wEckA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09j16m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLkLwC026369;
	Wed, 16 Oct 2024 00:12:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85aps-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snA9bkixTegAflxZTbxGbH2InkspevWP4FCNrgfU06jwYzV33OdhPHcDPnu5gTt4mT1WatY0XIRATrxZp6uB2PLqG2ryp76fcLoXfTJG5ApqFMNyNd1xBLo6ZcdRx6+t8DAZ3TD2npa39+PvUk7IyJOhGit2YmminpeD5ab+A92jC4s8Dqv/jCXm/nZd4NI/f1S5I8krw5tWlg1KJURxYhoRk+D4cIJ7VQBnY5PvJWLxjP4a0NnTkYCI2g3YVJtPuhYB7B2E1oLeMg5adKLYn/XJ7NYJI4XaaWXBtuayAQAfrV2H2IBk5BSIE5LCxtA//2LW/UJ6F3UiwyVpur6Ezw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5eAMquoqAeTKaod4nVoasZvNuBWSs7r1zSh9UHGUcg=;
 b=XVLxGcVVyC31BCUZtalobth82eFkNPJ/67722L/il2ZyfBX/p6QMOPWTUh/jzDItoaQwBziS+iX7jiwTDqHC/UdelfwKx9TlMMqqGIVpNmMuZO0KjiSOjDY3EeEN7o1M2HadfXFgZJk8Hw4al/msz7p0TuccNXVF7K//RIQ2AIcUyGtJ7hfOm7VlicdOIVE7GTyQpaVykCw1HOI0Lgssk2dlfIpQ5m/y+PZ7ZMwnpfbLtzTShW9ref5ZlyEllVEfTUdNRaxtbrhgERxMUN+soHf8yU63Fud10pnqUDXfjP4ZENQfPEg+yLNT66LbnPP/1cNis41A7QT2YWgJY02oFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5eAMquoqAeTKaod4nVoasZvNuBWSs7r1zSh9UHGUcg=;
 b=0VO+5QBJLQimqbPzDadmsc2CM+OLdEx4NqHbJPCQd4eU0NbaRCklSQw5HTwgH16swguF68Cs7DjbGAN11fTb4f2BWu6qsAcdnaTS8uRAvi3rHI22ysNXT+OTIF+DY6a3HwcqjWP2+t/dIFKQKf7hQcw1bsHi4QvNgXANyDzMoQE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:12:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:12:07 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 20/21] xfs: restrict when we try to align cow fork delalloc to cowextsz hints
Date: Tue, 15 Oct 2024 17:11:25 -0700
Message-Id: <20241016001126.3256-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 50489eb4-225f-4b05-18d7-08dced772bfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OfLd6Qqxi1lIsm1A9Zu8AggfmAHmhHJr1BS1WBpxrS2EcVYst4u8C9CrXjfE?=
 =?us-ascii?Q?EmeXqvDhFxEApFycMCbdSh+lFDXaS+PysE+38C5rMIc7MGKeerjaDlZUjjZP?=
 =?us-ascii?Q?3f6c1R11hPCrBakFxC6xr7gOiwKHV0G0IeLaqNa5Z2ZIbMQsCwgPuKxVfAwq?=
 =?us-ascii?Q?JBtQ1K/AyaNNhL+E3CRsl/wCBxV1BOPuHJWwxCf+C3/eEEOLv/ZOiLkSwLR0?=
 =?us-ascii?Q?4OVEAkkx9cM4Q6/t+oySx9hav/8zF+KeK0p/yr3l/AqfJqFUYY6AZXENmz4e?=
 =?us-ascii?Q?rHjPUr8WDZJCR80lIohLPHc/pvULzEyejtnd/1RJRs6z8zBSkAxo1P/t6iO9?=
 =?us-ascii?Q?tRA9nRqogAXTbMOdGu9rGen/+je3T45EzuL2qVRp9/xP14X60vXOySoinVKz?=
 =?us-ascii?Q?soFkoSUPAIsu7wCHMirp+zFC4KqPL1IA7Z827p9B2YNnyktZpgd85kd+9E3o?=
 =?us-ascii?Q?RG6GR+dlA0qoBt/deLONIdfjgh6wkWCKrGUDs2J9rRcYBgCE30k5P/a7cvEB?=
 =?us-ascii?Q?xHq0xZYYRwFIdnkwJfg9YLtNEjhgc58xDvi23Te2DVZ+cncZVFLfGkfdEoVh?=
 =?us-ascii?Q?25MDwJ5rQG+UVVUCLK9yqrqJ5EP4HaWF31/ogheIBvuRq3EnevTTv1BuxJv3?=
 =?us-ascii?Q?BnSP6ItZ9sQjv3o1cevcjg6WHoRMyBd70QE5e8cQBw6ko3XK0g/fOi8kkR+T?=
 =?us-ascii?Q?eBYRxtf2gHuSZkHALYBVlkhzKk3Tjr9Aq4ckNcuc2eGGQIWFGxYVWIPQ4GHh?=
 =?us-ascii?Q?Qp6FdOVb/WrPjYv1Qb0am+vEXp0YXcquQzuja6ZYh4GyjmX0owvsimhATMFn?=
 =?us-ascii?Q?fI/HB7Q8N3qrvNCyqH+NDb+Xu3ruEScX+b8Y2MtclBEoZSd7x3eJgABBH95+?=
 =?us-ascii?Q?SNiHI5hGaBxBkVV2vC+WUjmTmNr643UlyqL5QYTOcO7vdrfC8KEypoLKF3GZ?=
 =?us-ascii?Q?L0dYkRVBx8QTvsr6m3nCbHTGMb6IccOGQVScNT8mDmrPAalH9Laiik01i/O0?=
 =?us-ascii?Q?rzUSk912UwWARDa3Cyrc2fvEB6TlLTaWWPHLpV1/FbEZfLxJ7INUUeo1AoiZ?=
 =?us-ascii?Q?GXj7kyH+T74mytaqxBsZGsPu28dx7/FViFkqbsvQiQWoXYUwpCvizJuU2tB4?=
 =?us-ascii?Q?z2yj2y3xwwuDNbxKtCdORZWcDRxlYXbf1GwhMTOYQjOfN0x5t82xE5y99DYo?=
 =?us-ascii?Q?uRtLzQtr0C4mQjsvR6pU0z+OPR9CpzvGLdY9W3R8tvjoK/VLJmc66zsXBKVP?=
 =?us-ascii?Q?tcNSpdM+3jCTl5OUtWk+W4lyXx2PVaG05YU+fAOdnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xwxwIa352qOkZ9SmuGYBdsSN6RnWOWIDTjK/CtGDC+bfPshJUNfwd1iJapjd?=
 =?us-ascii?Q?ttMjLChZjTsr6zfnkzJkse1VWQXRJAv9eqVfMJAmBjcc6pH9KpXlbXYx64nW?=
 =?us-ascii?Q?xqrvaH+o4wYdVGHViD2SoQMPhLc3xK8GCwAdcx6TadmM3di+rSKP32iQ5ARJ?=
 =?us-ascii?Q?ivw61Tc2uYu6D7gbDi7J6Gy+3ZsT+PPhk96/s0LZr7x2m7dPtCUjRYS6LUbw?=
 =?us-ascii?Q?kQpVRyMilvSW0P3FKDiAj1J3tAYm2NBIhoqnktFwz4LbAOlFtnjDdMOpFgQl?=
 =?us-ascii?Q?Ws30KKZC5K56Vubl6uoH03aAaTnEEFGK1x91BzBo5s24umYI0JQHeSFpobCI?=
 =?us-ascii?Q?e7+1tcmt6wJdd0dRKNyT+NO5vn+GLfCIcgjDklLmlD33lKSSVvIm+Vc/PcSW?=
 =?us-ascii?Q?4jIlFfOqhSAdyxX/MApkaKQTVq2ZIa6KpsK80PqCgopsud5x+WsxXsTEV290?=
 =?us-ascii?Q?a67ob5+nhIxZkBmjABt0BAmr99NenOiAx+YIo5+bkMMP8MdAPZJgqm4fZwC7?=
 =?us-ascii?Q?iWNHyf9fEmdlsdLU/yl6tkV4eh8vzbPNbKnVt45aYLOcEpt9FXoCvKBWCLHu?=
 =?us-ascii?Q?gxd9A2HdJl5FC1pGUQ1Ugf/zwBsiZrQWbVJAcFtegD3uoyHLgsQRwCL9DDtB?=
 =?us-ascii?Q?Uy7iOTLpOlyztueuAFtWyCjyfXdExVlgEii8qrc3pRg8NkSF8MFlBMX9o8Uk?=
 =?us-ascii?Q?+T6oUMbvIXEpTlJUTET3M+u3GIL4tWGXWaIauMVgSSDjkrtjX8SgJndcAkIy?=
 =?us-ascii?Q?i7F0JvLS7enI2hsii7x3XRV09TjoGXZnwjepDi3P9ewniDZWMoiY60T6N7Zy?=
 =?us-ascii?Q?oECjJ+VwzLsjh3C7xRdhLWZF7Xh+ankTHPfil2w4bGmtOGM6YHBLt9a581ip?=
 =?us-ascii?Q?2PtK3w9GA0F+6Bcnzb2VtWhijJmKCTt5upHcGeE5bGTJqCL9aUt9l28+MtLi?=
 =?us-ascii?Q?Mc2kjXBto9bIat/NDCYm40SMYYr9JaZpEeIUxOW2BKBnPjMiPuYKAtIq0v+1?=
 =?us-ascii?Q?FVsty55DVX+dsTw2IoSRLbl3xOw91w+egkaw1w/whF6EsTJxovVzntR/uPAH?=
 =?us-ascii?Q?YdSVH7HH1y3NVcxp1l85AnyrQuoZtwUL1YgRY6vJsQHDxSXo4Pg/diIC65DR?=
 =?us-ascii?Q?eSO7++x9IZKI2yn5evh28YBCn3UshJBYgS28f/cKd7JXEUczFnuuCuQUBLoq?=
 =?us-ascii?Q?yn3PZr74rDu2kmjQjk0xkdXF2poMir8PUCLKeUuCsaRacKX0G3h/Y5+a3evu?=
 =?us-ascii?Q?51chcPNyjzHMDAEBMhM9mpNzCvdlFMQL2UXzmwzE4CUv6F0BOjbB1+akh7d1?=
 =?us-ascii?Q?OJF1BSlcBoamhhIvfZKm3tASAWNFb4OBVe70VFDdKgapsXgoAwqF9VJNA5gF?=
 =?us-ascii?Q?ROa957vvrL9rc0YCvjeGew2ZSorHf430BU58irOSXURIYbyMsMq1EK0+4+ON?=
 =?us-ascii?Q?RSDLc2rMSN6nup21sTtLSUc3snxo9X/72YiAC8VhoIM4Y7WbkwRuwueGJ8EB?=
 =?us-ascii?Q?QIylACmqoC4L3dsao12f8lsBYX0ApfMJu7odcjw/ZmJuRedfvCudCmZfntGE?=
 =?us-ascii?Q?VoPYyeXT30ElIV5yfhbP225kQFceEp+QNLtHx6UVt3G8BgWGOCPN3/LOD2CO?=
 =?us-ascii?Q?7BPEzCYhOBxpdMHwS7K1KeF3ncM0/MmeRejUwKqzO56LEgNa6oFHcyTnaJjR?=
 =?us-ascii?Q?PBOcdg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8dDNhsOYBfrkRspXAl95GQglt2QV4kXHYGTNiUb+IyvXRG4RX8F9tyhgyLbxLVEmEW26sINzsK1lBwqbvD7JtH691W/BohCg9T2VD6HIo8yK7uT0yewvLAJj6yp5leyLQOIoezjIJWae8skE/Tn8uH/QalBNCEmSfHtYrU4dd1eRYc2/+sZi+Guu00qQ30adXeRjsWtn6OfeTfzB9MHfGKazlSGsmNp0eETWclye2vSjqwW1ioyaWFsgI4U3OmoKoj8TTcEOSIP9J8YfBMYnOU3xT0WeqPMrNhbHrdgM/ONfzu6EVCEb08oOHhNYwBTGkcAjMaj/SgNuSyjRoAjFrBo7RE/mSyHHk+t+oP3wiBpNZTFLzqUNCcxEC2SK7IkTAINxyvA2GEZE1bIgXtCAH3LOK4mZf/Fc/RdH43B4LoRwPkthIpJRW0oyJAQa3jpSTtsNVyO6t0UqmySAOBaszEIR1XJ9PgdRZqo9Jzfhf2rG4Qf8Tq7MOJ10LU3bHUbgW7dm/Xgw8FLZTjmQDleeTyqN+XrvW39RSerH1aZD8NL7WFDVaSl+r+arZTN/eyxk1jLeMIaFy/C4CTVrrs7GeeDSU/QgRwmGZHxxTwvCgFc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50489eb4-225f-4b05-18d7-08dced772bfc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:12:07.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0V7WbL3fpJplplWUh87Poh7VRKMcu2X62cZI3zhR5TsMdwNeuFGKUlzgOHmx/Kp0+UlFMoNINarV9DEFXIqgKJcZO8eVz1IJMXcQJ+KLFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160000
X-Proofpoint-GUID: EUNxwMPiw1BJhzjgknpEkmcoLjF_4dJV
X-Proofpoint-ORIG-GUID: EUNxwMPiw1BJhzjgknpEkmcoLjF_4dJV

From: "Darrick J. Wong" <djwong@kernel.org>

commit 288e1f693f04e66be99f27e7cbe4a45936a66745 upstream.

xfs/205 produces the following failure when always_cow is enabled:

  --- a/tests/xfs/205.out	2024-02-28 16:20:24.437887970 -0800
  +++ b/tests/xfs/205.out.bad	2024-06-03 21:13:40.584000000 -0700
  @@ -1,4 +1,5 @@
   QA output created by 205
   *** one file
  +   !!! disk full (expected)
   *** one file, a few bytes at a time
   *** done

This is the result of overly aggressive attempts to align cow fork
delalloc reservations to the CoW extent size hint.  Looking at the trace
data, we're trying to append a single fsblock to the "fred" file.
Trying to create a speculative post-eof reservation fails because
there's not enough space.

We then set @prealloc_blocks to zero and try again, but the cowextsz
alignment code triggers, which expands our request for a 1-fsblock
reservation into a 39-block reservation.  There's not enough space for
that, so the whole write fails with ENOSPC even though there's
sufficient space in the filesystem to allocate the single block that we
need to land the write.

There are two things wrong here -- first, we shouldn't be attempting
speculative preallocations beyond what was requested when we're low on
space.  Second, if we've already computed a posteof preallocation, we
shouldn't bother trying to align that to the cowextsize hint.

Fix both of these problems by adding a flag that only enables the
expansion of the delalloc reservation to the cowextsize if we're doing a
non-extending write, and only if we're not doing an ENOSPC retry.  This
requires us to move the ENOSPC retry logic to xfs_bmapi_reserve_delalloc.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 31 +++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c       | 34 ++++++++++++----------------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 05e36a745920..e6ea35098e07 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3974,20 +3974,32 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
 	int			error;
-	xfs_fileoff_t		aoff = off;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
 
+retry:
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+	aoff = off;
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4006,7 +4018,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4051,6 +4063,17 @@ xfs_bmapi_reserve_delalloc(
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1a150ecbd2b7..9ce2f48b4ebc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1127,33 +1127,23 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
-retry:
-	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks,
-			allocfork == XFS_DATA_FORK ? &imap : &cmap,
-			allocfork == XFS_DATA_FORK ? &icur : &ccur,
-			allocfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		fallthrough;
-	default:
-		goto out_unlock;
-	}
-
 	if (allocfork == XFS_COW_FORK) {
+		error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+				end_fsb - offset_fsb, prealloc_blocks, &cmap,
+				&ccur, cow_eof);
+		if (error)
+			goto out_unlock;
+
 		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
 		goto found_cow;
 	}
 
+	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks, &imap, &icur,
+			eof);
+	if (error)
+		goto out_unlock;
+
 	/*
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
-- 
2.39.3

