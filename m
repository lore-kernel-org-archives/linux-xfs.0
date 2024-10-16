Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C4DDC7;
	Wed, 16 Oct 2024 00:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037519; cv=fail; b=V5nv4c+gCI2Vb9+2N6g6YtfxwyGWQg7vrW6qhAMkyzYLP+8M6c9KloYXGqCvDQ4YypuJglzMK0Ft33wmj60jGlSpdXy0MW02M8RW9Wkubo3QVx5UeqUD5wLgIUqclW9imlrrDV2SnAEl+IfxfSl0Lbly2hBne4BS+YCEWJBs9+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037519; c=relaxed/simple;
	bh=pMzfDEb4dWfTWt1Ua+gWRB4Gn4CV4MOeMOuLB45XCXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QBw8SmmcK+0q4FShQyjwNp9A2Ni6VlxdXCMs2h6nsVA7s6gYZ3xznxWPNf292BLhGR2U1MCa4rhiNAhN1YDC+2d6bVTF6mrZip/ndwo1fr1CTIsGpd/X8HIaUvqGa7s/nrJ+T29V1RHMctgoLtcxYanRnAsLENWGV512TP4Vlvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jxsw82Bf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Anz8r1Ou; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jxsw82Bf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Anz8r1Ou"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtf90008307;
	Wed, 16 Oct 2024 00:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=uOQ7FfHr53ANkr9MDtnIP+jDmPhdB0XKZY1GKBaycHw=; b=
	Jxsw82BfOISj8x++eV6gjw87dKdnSg2OFl+cK+SIRTJgmZjC8DJ7JfAeIkBAQ6V/
	SfBfY13PprBIpwivoeZhj6AqYTsySJnII/QO/1Ngbw52RLHrlM70h8+tZ/Gph+bq
	oMNj00S43f0HHMqY6FRwv0xKLEwdFU6TVDcD6nYKY1yxJ/9Z7T42WxWrIlHWomB4
	hNioLZsetnDnQ5dCfDGqTBn/uLn6LjBuHaU2yFdxpP8fkjK3IbsZHOijiqYR4s1E
	hyDdgD2Vbg+ORmBLDy26qjVEVmIqlRMoJBaMo2tzfQqGa5wTAUF0J3gTpkhjPq/R
	DSu7e6kkrm13NexAg/ZJBQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntaj1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMbLDI026319;
	Wed, 16 Oct 2024 00:11:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85am5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ioLN6NiCv/YkQdROUvFf8tj0qnDyEXIGOKPOJOcy3SKo0zN7FFTEAcltNKtIljkqi83fSzRYuhqizeBO601rphNVyYd960z/smYZOsP75DxDQAPJ3c8VyZBsS7GmJtcAsdneQ9MQBbsg9+0GSsXrJiX8h43PIAx1ArO3bJuU9sSmYZLGzyRP2USfcLLV2xVV9bnrTBL1/zdIjO9z9wkc0cdJfWBF2x+sjxWp6JCRj46GfuWdazGZEzujGHTiYIY7SfcctusCPZy3dR++qUCgIisaZt57vJnsmcrgW7CUyrr21aBpQr6UWRVewyz5yL9Bw8npWG9156Xt7v0cr7GOyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOQ7FfHr53ANkr9MDtnIP+jDmPhdB0XKZY1GKBaycHw=;
 b=Spz78Zb8SMfmcXL+EVTlDd22sDAQKhi/L1L447C4DMDj16VxcY8eKpXNPoXF0rcclxWG/IQA5JEEdCA9aHpRddDYLtGV63QzEA/JsofJr7XAQocFsOLgtks5JVap/T4uY65SaWv2DLVfRgBFmDdVVw4PfDSYawL/1m7SHNMFF5gyrAZVoeP4E1bPg6i0Ywmud8qwxL9MCVTK+1k+Tkzzz2BCbQ5rmZPLZB45B4GNem167tQm3kUPqoKP1WPJyLo0me1GaVdrqFLlTNiR4Wr6YJ2vygkLHMDAqWfnEjptfGIahz3HAfNw9hDowpj9+tnoaJRxpax2Q6K67Uf7yuMYTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOQ7FfHr53ANkr9MDtnIP+jDmPhdB0XKZY1GKBaycHw=;
 b=Anz8r1OusmiMcsA02LP8BLy2icJ8Tm40IeWpjKXRNtCnNfliVRuB+IP1DRDSGDrIsw7S6JqyQGos1+NSSimw7SKb/3uqAlqEFD37F/GBmTjatIMmZH11Z4O6Kx4SslC1LiPX0Tfea8L6i9PMrp0IZOA0CHEo7Fj/PSm9oC4efmI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:53 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:53 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 12/21] xfs: match lock mode in xfs_buffered_write_iomap_begin()
Date: Tue, 15 Oct 2024 17:11:17 -0700
Message-Id: <20241016001126.3256-13-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0204.namprd05.prod.outlook.com
 (2603:10b6:a03:330::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ef4024-6084-4c16-bf4b-08dced772348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z7Iz7Qa8sbWGFF4ykL6qVOjJAvvN7lNBVDpE2hiLMQVTUIKct0EattGWYh/r?=
 =?us-ascii?Q?lqHTc9tREYYmlHFFs6PxRbB+8+KtstklQEVb20gAQiGG0Bkl8LQ4SRd74mpg?=
 =?us-ascii?Q?Lam99cJJq50Ww+UtSH/Gihd3h9uTRJTbsZNpHMTDG77HXRUTgwtoy0KiOQgI?=
 =?us-ascii?Q?K/2imgRBzNiOs97hNPaHUShwMZm3WJhz/kPoY6e++wD+JvLcqSmWLpkyUHs8?=
 =?us-ascii?Q?5Sk6YLI4jjlgk3oQdkTO2YmUcO038FQdjmyNfuVi/Lex7B7lPWsj6xyfgrnq?=
 =?us-ascii?Q?86IPs3BrbQvveVj1VjWyW17e5Ua+tQrKUuzUdvz3hKzCBHJBBUnALw337dJl?=
 =?us-ascii?Q?1fP1bVFogDB1rbetdCX3TZ79fmXy5KW+BmQZNg9eP8IlLzCaIPNltmBzg4Wc?=
 =?us-ascii?Q?ud2k6UpvqP6v22PTSx3bTTEqR7JOXldwDU3Fhc0aQ/uHrlD8Rs3ia+3SVx1h?=
 =?us-ascii?Q?9GZojhX8ZOBVlTuzjIvx7eybrwFe4iQqHmIE8YnLT0EeurXcFkMwTSAvrq1e?=
 =?us-ascii?Q?6z8C5C7+9CT5kEIFV9hbm3oaMFm8cNz1X3eL3ioKdLzCXTx3GESN1Jxhzu/w?=
 =?us-ascii?Q?PLPgVwOZwwpi1MRrp73fzHkHZwV1Qn6ogJe+F5RDkxtwcZ33QAdKGpksi1l1?=
 =?us-ascii?Q?X9EVuc1rk26/+sJUXV5sxE4W39FPLPfuEitMum7WBwYw7rxblZurShd2pKfj?=
 =?us-ascii?Q?MPpTpt6tnCz0n2oIQQnIop8NT5RhSuVdQqnWpMrxD+XXZflX98sMhuI4qjtE?=
 =?us-ascii?Q?T/BoQOqJjD527gK+YQDStBjwXkHLWenAM1UXOTti5hQ7OO0KWRsf1OE4e7Mt?=
 =?us-ascii?Q?Fk4qZQXrHDcHidfpNZMWQGT31QEHRT07sAj6Xd/jhftGMmrJCi2AlrUqDN6A?=
 =?us-ascii?Q?Vv04jiT0LWGJMO6hJx3LD/IwopPKTXuNybkj/aRly+GCPc8kX3g+XfMeR/G9?=
 =?us-ascii?Q?oz1R/dqiRZHbE4FmY4HZtSi8Yu9hIGtEU0jhiogsIJktlud8dRzNt6VPeR1P?=
 =?us-ascii?Q?rL5noAOD0tPteH6+svfcnBRNsDNP+cjHO6iXtVlsBdCGAFD+GFHaN+n/nHsX?=
 =?us-ascii?Q?ZQL4PFbYtmfT28T4b4SHnzrDWSK9gcBJTM82SVwf8kJSFDSgOjK57BLegYJS?=
 =?us-ascii?Q?KHoDr74eY6MZGJgYdY0sqqPpsSI+TZ+yzQwD85OaN86kvlJpU7XjPQhvZ7qm?=
 =?us-ascii?Q?EUKdMftslX934mssPO7kGFd/v23pnsa1PY9+wUickt2nWFCO7cl/I2R0r/zV?=
 =?us-ascii?Q?G9HgWRqSTrngMNwjpbLN9vgOrRfOtZIc0HILeYv6Tg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/2moTtTpnfGzFHkEZPPTrEUKXyiZ27Ndi6gXMg7y6hEdV65r/GESIH5RxfFq?=
 =?us-ascii?Q?QTIbJ0lBn5kzsL5Jte1pC/OQ0UuYZSLj3SPvhtiEIwr+dMqkNMun+F4xcW0i?=
 =?us-ascii?Q?7k+Wcn2mIykNd7PUE9chw69wjn80PaRqEu4M0C70LcqGrKbIaiKLydBQJxCo?=
 =?us-ascii?Q?OfrnbMqm/G+b03N9cqh/kA1acRkSKKAQaHOFpvEpFE9MWK6L8EM6inE2CqXG?=
 =?us-ascii?Q?PXkvxJ8lIX3SwbQ/4b1eMbIVYHDm0pXr6N2wD9Uw1UbsYMWSBScqGDkuDcVF?=
 =?us-ascii?Q?GsXV00K0nQ1wpDwv6ZvNlvW5AAirtoZk8TULJbK9s2AHfJDcLrevi3hbZ2Vo?=
 =?us-ascii?Q?ujXT6DpVkmQGN5SdnwykJ8rVe65jTHp6eFKiHTZOY2iG7OCOzithcT+isIxi?=
 =?us-ascii?Q?JiS/GuhrSU+9UJUjbLYm1M6yGytJ1wqwFDAcMPY0FDV0cMFHIKitf0OCCWRR?=
 =?us-ascii?Q?TyVJiu9uQ58RawUcK13krb0ULJF1q1jIkv+wM8DdoLm48tD1LPIWaaX3iUnc?=
 =?us-ascii?Q?ofBLb+AN8T4qljBQkJxnOzt+m+i14aJBwhZI/RisMLG0kDQemtPAe6MZ/sGA?=
 =?us-ascii?Q?oFfarBUkQb15y8I31GlI/rPxEDQLYYI0sYhJVmAAlyKhNGQUGKZZ1Hi6JhrP?=
 =?us-ascii?Q?H5pWCdlUMArPRFlWEcv1dnNH1BOkLXtCvujK21RCH/s1Q/wILwQRp1v+txl/?=
 =?us-ascii?Q?QZVKQlLSWy3iab/Re2Q6Eufsof3/XG126tUsbjUWKljDj5ccFiuqO693bevz?=
 =?us-ascii?Q?P/DlwV31ONNIHVyjLL33XlCOE2pJW5YCTY17HyOPd2uspFCVWimYXY5YL8Ub?=
 =?us-ascii?Q?9xdPCihnAv9NQNuih7lq2Y43CgsJOAQhJroYZHvcomHUD+L+6uFFyj0a+Ix/?=
 =?us-ascii?Q?aMPrPpzWwqetX9UE7orDrAdXlcHepYETezMRTnagzKYuMSp0n/rSJiD0wAUt?=
 =?us-ascii?Q?xyvJBMCd9cldvn0Yu7foyjWW26rvxAD3taJ3e+ZqCkkVIFQ4yrKgoQi7cxrM?=
 =?us-ascii?Q?lbLbTSnKfqI7WDrpBV9dSCfSiM94+kkuq8WEb48q3/L3bRm/cPx0SkxUhhQJ?=
 =?us-ascii?Q?/s+XFifqO+nxo0tWRvLwpv78VVOtoN+ntMTEcQFLTTwsJRI1U5fKCqbHMJUS?=
 =?us-ascii?Q?frZ/5ig6tbmvBo3DzI92Ps8New2A8tBdZ5Y+3CkzxOlQFsmD8bvPYCCPCgvk?=
 =?us-ascii?Q?te/ObPRhr5SFU3DRmQIGMubZ4Oz3fE0OW7VVvOboDS1ijUj/E+pF/rnTLLmn?=
 =?us-ascii?Q?iff+kEelHfoCnkE4agw/5TxmxDxE5teNBnXgYqKvq/0DK0UHJpMe95tCMcDK?=
 =?us-ascii?Q?D9L9SD4jTNNCzbRGjNuHYINf45UXxeH6XWkVvt8KeIvfPkrKWa2On+dXynZO?=
 =?us-ascii?Q?dKgw8fM7W5CcbZ+ZfqxgdF2Uv/zX15k72EKSoyWZtqrz44V0+vG59n6INvxf?=
 =?us-ascii?Q?5mjXFBxSIXz4V9bWS0N+FqAFIimDuGKLwJm9hRWfPkzJaqn6hDFtYCM9TeX8?=
 =?us-ascii?Q?id/R3wa4DbFWvy1m5ektprYGpsm/TAIHxTGDwFClLRyO0CukyaGfFCdTmNPI?=
 =?us-ascii?Q?S3hVaeKu5QcQMQuQO4gUU1Uiw/geYfvBZ7FVKxwFaK3Cr7yN8zkqwBqOEHdp?=
 =?us-ascii?Q?aca8kIthXQhykvkSXEXPxIhKaF+Mu3fpvOsecQ/wbBRfuWw2QiZTeeoQjwQn?=
 =?us-ascii?Q?AukdcA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2IvUaGudRK+8Hsgx7LE9PB7we/nt+UjnvEBYIKv5K7AcVbJh9gIrRNBzz9Mf3TFcltz1YnPuNEtnfWWYjpJGftEVA2tG5YJm+fkDSbG/vViuvWfEDlSYEleimymeH7tfDd184BCvDvwKiOwz/BOoSukLvu1M/x4juXUF8iAwwzc9UzFvrhlWSxjTB4n+h8xNU45JZDQdFs5ibMenShgeBjAkT20dcYx5Hj0JatOTkTKjExkvdFUcvE7fFLuJ8z9smEDAxdAYcdk6lZ2ktwyMiiPoteD4pOJHru4FDEzIZfG4sKn0a6HyEVexXAojLt7mS0Y+0Xm5u4voJ3kCoin2y/6+JwbnRr6hg1kyqQ6LSGpTB/ELpFzoUzyzJu7KFsYIVnSZIPIWUg4+bqf2Ucbc0vJhft+qxsWdfkiGufv+ad/VaR4gCUPBnDZmJch8BYaZH7At5PUwpMQsGv7ADnMuBHDuxn4wQh3k6O4eNZgfHPNOiUfYpDGhhE5TnhnyWe4ZsUVe9E9qR/MCkNPnubkzJhOdJE6rTnl7wTrepzdesPDBRVT6pTJRWPf/zZMAv4EzHjX8dj/WRMSvvOf03h866ZHDeSpNe0oFnSyIIMztEYo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ef4024-6084-4c16-bf4b-08dced772348
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:52.9898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VhptvPHInHNSA6owHV8kfhgMdXcO4rU8CAKgkf3DfSoA4He0JlSj5bYj94TgxR7QjCBFEz5FwCTeyez5Usv2R6b/B4fBmcPFlju0FtMrguY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: ae1QCKhtPPpxgIAfXNTCra_Cwb4QSvsl
X-Proofpoint-GUID: ae1QCKhtPPpxgIAfXNTCra_Cwb4QSvsl

From: Zhang Yi <yi.zhang@huawei.com>

commit bb712842a85d595525e72f0e378c143e620b3ea2 upstream.

Commit 1aa91d9c9933 ("xfs: Add async buffered write support") replace
xfs_ilock(XFS_ILOCK_EXCL) with xfs_ilock_for_iomap() when locking the
writing inode, and a new variable lockmode is used to indicate the lock
mode. Although the lockmode should always be XFS_ILOCK_EXCL, it's still
better to use this variable instead of useing XFS_ILOCK_EXCL directly
when unlocking the inode.

Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6e5ace7c9bc9..359aa4fc09b6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1141,13 +1141,13 @@ xfs_buffered_write_iomap_begin(
 	 * them out if the write happens to fail.
 	 */
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_NEW);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW, seq);
 
 found_imap:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
 found_cow:
@@ -1157,17 +1157,17 @@ xfs_buffered_write_iomap_begin(
 		if (error)
 			goto out_unlock;
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 					 IOMAP_F_SHARED, seq);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0, seq);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
 }
 
-- 
2.39.3

