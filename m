Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921A7846F;
	Fri, 19 Jun 2026 01:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781834204; cv=fail; b=sv0FdeL6uIJywBM8R1XSvR41U7NBNq7c+Hk+yN/OfAzWVrA4RBRDCafbvu/EsUlo4UvlbGdPU03+fsXKUATrI3rdA1UjcqbO8GJ5BbpcWL5Occ3K0kfgeHqcaTgcW7YeXrsST7yiLewWrO0t9ZPNXfNp6QJ1vI9hvR2z6EqsLec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781834204; c=relaxed/simple;
	bh=8ycy6Z0BgDwDF7Q7dx1ieK0Pf2yNuP5ZHzyfMGkBe9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qaOp6u/1MMKHIbC9FaSW1MF0p4NnUHqzRNVicu2bMmvXnJAAoHIoz7Eyti9Byg1oVlFqiupuCjWhYFZJ/vnG9QAwWtCHNoxfiI4pQtHpACZ325aYgigapmag0KKuxf/VXglbB3JHmH933lAeVeL/triyJraaC0W8qd1O+45HDlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OYedtu9O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=JfaAntyS; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OYedtu9O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JfaAntyS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1781834202; x=1813370202;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8ycy6Z0BgDwDF7Q7dx1ieK0Pf2yNuP5ZHzyfMGkBe9M=;
  b=OYedtu9O6ql53dUB/OgZHp/WwsGf3slLI2DQqsypcQ61aSsLFgPlV9TH
   10WjRilnx2cvdX8yVoiHH3gr4PwfM4plWChPIzACXRi5QsWvUhu8HfGOz
   dzDRMrber1fiASuXUsMkWv911T/DAghEvTtXrudAa8X/tyRdHNMZrQUUr
   Bz4z6+JTJNKFlGLN3jQ0AofRdNiRxFoW2rDbFlNAOZYahY6cWFjD5IpdP
   pVeeHkq8nmuoQEsHlk0E4QMdeRzAZ0SpyPwGjgTdN318NH6Ffq0gqCIyx
   6m8gp7QkHv5Eb4a04Bu4y0KIwbQYW49N+H73hRdTGwB1Z+CZ5Gxf9Rmz6
   w==;
X-CSE-ConnectionGUID: BUelgHRRTJaY+4kbo0av9A==
X-CSE-MsgGUID: Vsv7JoQXSdGvWGGxxO6b0A==
X-IronPort-AV: E=Sophos;i="6.24,212,1774281600"; 
   d="scan'208";a="145305503"
Received: from mail-westcentralusazon11013026.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.26])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2026 09:56:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7cDBKIKc9ZVU4VTvql+KY+3+DhmIS1nME7HbuqmUAi93/i5ekTWAyNokdUXLZB1ZDm/ODw0TC+BIFMb9f96EtnqguwGLbC4jbS0ftDkz/zTdGSVRpubv1rRUSvZTrN1jAF9oJAUAcXorzYujJiB8GwyWwd6Ptc8IpgVnUqH0tW0PrDGCZ3uwgdywaqyZ9b24aGO0ixh0WrBbnRsgn1PTB3uQ31k5sbhzlrAqnYhoeP4Yg+/2Av5FbcI1F+bqAEg0JtHGD9p3mjVTWlYdMrbjr5eEw9+34XzjuI2kiJEzgjezYZo+7jGSsjjIPNPFCYHnn+5MBjnDX+05AgX05NT/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukzXoFjZ20/BgjgMdQ0ovZf2Ifod7MCZ/qRAtiEFA4M=;
 b=qBmsmHohxD7fwLkX5iob/FBKL77hlZfCwObw1SSlHYc7Xo+tTWT+LR4T3n01qz+Z3+/wXhrs6iw8d1TGEwTo3ZBAaIymldOT1lNtf0EtA3giDFXi+o5lsLXcoY13Zk9QN+NwIBGo2LJZjOmWeTZV9Y+vBsis45bEzKqw9orRCJqj+A+auYsYD6v5MKTLC6a9rxHGY/owkackJhdtoIeW/kcdRBZcvHTECrNkPIZ0FrxYw1lVoiXcdcK2UJm7cerVyXrky/4hc4iUEdPknZ5J+rOpNk8HEZwX9n0DGGS/qmpNKSselatkHBx+Nye1px2fkygWJUUfDYUxNeBOPzHGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukzXoFjZ20/BgjgMdQ0ovZf2Ifod7MCZ/qRAtiEFA4M=;
 b=JfaAntySjX/D7hFBtoRGvV4no2i3356T4zdS4M+Z4o5Jjbv7hDCbq1klWZoJwREONtbqEIG5Wl9zz5qu9ylK5yTCmxJ2aSYI4lYV/2YMIervfSiEHU/rK6mGvVbDi+Ya893ajRv4pd11NukPkr98WvbWPAEHVNFDsNmTdvA18Jg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by SA0PR04MB7465.namprd04.prod.outlook.com
 (2603:10b6:806:da::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 01:56:40 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 01:56:39 +0000
Date: Fri, 19 Jun 2026 10:55:21 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/078: disable all concurrency scaling
Message-ID: <ajSgfekizOMFT0SB@shinmob>
References: <20260618134834.237647-1-hch@lst.de>
 <20260618134834.237647-2-hch@lst.de>
 <997e50d2-83d8-4b41-9c2a-749e5c85bf4b@sandeen.net>
 <325bdef5-487e-49d7-90d4-3418e2ae7799@sandeen.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325bdef5-487e-49d7-90d4-3418e2ae7799@sandeen.net>
X-ClientProxiedBy: TY6P301CA0026.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3bf::13) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|SA0PR04MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1ba92e-cbbc-4cc4-d8c0-08decda60109
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|19092799006|1800799024|376014|23010399003|11063799006|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	kHQmKdfmvsCcdxbja1pwmy+DjsXXuQpPP3a2Dma8H5cUVgwYEU1EDd/C0jfa6KBr1vs3yYNl/OLm/qSImtHAyth35UHteFZAW8qKeJ/IkUzgrwE7q+5kwqdDhP85YXOsO2R5d54LxpynWJb2DTEeasp8Oz5WIoJvIe92n3w50FqYqQUj4FeqBBfba8iFmmGPTAm9q3IhPVMPH9zYMq4IrNGdm4nqhrmhoFWgK8fxAUNwyyydlWV3HEomQvikSa3LQNmSdArLu3sSFk4z+rf8Qba9KPce2qi0yIekn3UTEKuvZa6gob4YlBI3f+pkEm8AjkGrVbu2u/fno0nQ3qlN2S0/4ZSqCrDOVbW6c9ZKSxodJONkdNYYkcZZZqwR5L5g4sW1zCYPnRYE3vLpwY639K/13ugm7VE9eMn5C5umYqlQqQ3ecqpAMrrRW8N2Vjemv9VIOyuCxyqrktQ9WqG6Kj6tRA/+cX5EaHINGMJI24yRJwD+SqpjHkbWmHUSRgh9JuILbBqChl8JiHqwV7YOw/n8pSEVYrOAj2uFPQZL8jb51Srb9QERoi2W2pV1Rs89sLjXrpAQC/4EuPofWX1NqanrFKV9TVo4EPRmQTaWKCrQx2SOgGi2p8QtMPaSuEgWRVTWIK7Tq00tYmcO9FGL9gNMuHvqX25jHuaupsWG6Po=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(376014)(23010399003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aHUq+i9EZvWU3iF3W34NYuYaPJN0T4oiEhwN8GjXLiZxNKZarjWD1kBy2uqs?=
 =?us-ascii?Q?JzFyExMc47WFJ/CiVr/XNd3qgzFSHvfaWO+1Pj3RplHN9B8vih/5I7iAhPmG?=
 =?us-ascii?Q?o7s4Qi2zL5YnsQlEMG+4keDW08X5o297r21VnYUIxgYsHtfMcohnRDAhKNJe?=
 =?us-ascii?Q?GFUSU9i1ccQ0vd8v5IGMZluMTJARx+qtHX035YtGnup7rr0QamG1QF9jBSrx?=
 =?us-ascii?Q?Ud+5oLRd6Hkvs/BdZAXNA7ig7lfx+netOIfN2yCuwm7SsegeL09iMYP9mWvb?=
 =?us-ascii?Q?thny5jneef9PP4cXqZ+6Jxc2RPS7s3eEbQrGC0N4shK1o4oRQSCQYYqqIif/?=
 =?us-ascii?Q?44rOWcpB6jkjaRuULPDuZHwWGwEAfPQ2JfqRRq9XbwWUlLW7mWwxQKhi53sq?=
 =?us-ascii?Q?Gf2gSh2M5gGZj54jRTZb7EX7nGAe+baAwVm9DCCMrdkwROYaX85F6SxshYHL?=
 =?us-ascii?Q?jMzfc+SOiR97iQwZxXps8UgxFBvCmoPI/iKCbMjE52OVMnnfWdDLOxyBJehw?=
 =?us-ascii?Q?QxLLGXzuvPJ1GUKsGGHMNyB/j4AuEvBUYHzTL3FDtECXp/Xvc+CtuyNKeUCI?=
 =?us-ascii?Q?7/7ZaCAd5c8S3OEmk6dwHACbff4YyGDcLyBzHOMDUgIB8Ud/MAHpqrTjh1rv?=
 =?us-ascii?Q?BiaTkduWCTZCDuKKAFrD3RVGKzRZJXlOhjMyiPTCoMqzMibJGc8BDPYFkIA4?=
 =?us-ascii?Q?w45LAH0CRFZjmhxzU5l21B+CAVB3fEv9OnEuQD/nD5gg2iS8Illh83DbYbcw?=
 =?us-ascii?Q?Rkokx2I+gyspN3/RKFc1zfSSsPxWla7lK2Kr/9diFzavsWiA4/N6+HPZdVAJ?=
 =?us-ascii?Q?sHFgJQAeZAKl+roMotRrgkZbD0HezS/w/ScteV3BRrcZJox643hSEtvzQtr0?=
 =?us-ascii?Q?AaLxjarenIptJ13+q79DBtg9q8BqWT8p/a5E0hYehTWfvwHZ+ab0N39gmXIY?=
 =?us-ascii?Q?1wT9sn2t3dI/N/ElVnb+YOmoNfZu+6XsyzntGtP5KzduD+9Q4aHklQwNfG0R?=
 =?us-ascii?Q?Vu6Yh9uVDZbjN+Q4xtfEhrrEOGumKnhzxVtFaUc61Cw7QI3gAPkXSvPNQd4Y?=
 =?us-ascii?Q?9CL0g8v4JWNgcppUWLxSDl9WiYI1aYNlqMKBMj6K6Ue7oXfPuyM8ZAcsjUx5?=
 =?us-ascii?Q?fd7sa6YEa+gUS9ogSXq42Ce31b2syNE4HQEDSVqheFgBPr9wdDDlPpprhm/z?=
 =?us-ascii?Q?7A4eWPs11UGHIiEmxvsjlz/p/BdGdAV44xgkvj8Kewaea5XEi9pVh+mySL7L?=
 =?us-ascii?Q?2cU+D00Sd/2LhPRsQ0OQAxduT9ZS2tr5c0/RcesOmdPdaKAY0TvkIbZspC8h?=
 =?us-ascii?Q?z8eEzCplcpLrVJKJHnR3diz3umMw4e2IOwES78xWwq1+BbZDaH4P41N0DmqU?=
 =?us-ascii?Q?4IXZzmZ0t8mhbqtPVAXQRQEv+g92y0n8SQxCxL9Q5j0DmG26mPn6R+qrufm+?=
 =?us-ascii?Q?3xqZv2zWpYvvcxk8dyUsf40BQ6VsMO3/HkbNX8Bq1hvIyAtiFSC1B60mrGND?=
 =?us-ascii?Q?H/jU2IwKRsN00TtlWbBiwUftRpr7MZhb9eD+bMPMgK5+aRweekYzfV9cwIOs?=
 =?us-ascii?Q?C/uqmaPk2AHDv9BkiNSRlRSDJMEpaYd7l9H1a52X9CxwPJu9RRr9aW7ystN6?=
 =?us-ascii?Q?/2z6ohB+NN7dF+Qm7Q/V3km22/FaC74q8X8k5/hoRGbsV0m5HFWEnynzX153?=
 =?us-ascii?Q?WuMuQK4usthne5oKQ85nKyxAn7zB13wUHyg/a1q/D6jknHM8erxY3lvslBBc?=
 =?us-ascii?Q?NdFSd3Of1zFXm8PK6Yv51xIFw4NxlUE=3D?=
X-Exchange-RoutingPolicyChecked:
	k5SucERNa7cplKprmxkqQFqPWh9s7+9IZF37sWbpFEyYBgA2sy2Dxpt61EecBL2glbH0HGy6byFyGrum+xyj6bk1kE8CIGcUGB4aBgqbvWA4Uvacq0NWHJfac1SHHkxvmsdj8HWj+HUMz2dSXJmczqFNbSnc+2nmFN0Yl1Xu1/TiRhin9399oXOIq1S5xVi5T532+KeeTm+HZQE7DNtwd2kkDhooKIV8HWkoUzNIMtsUaW0KTc9dpl1J39jE2gzEiOvE3tryAaaTXivFmEMV4zdVJfwcz0liW2zdIyRBN90zVN1Ewb5WtFWelQ0bPfKXTW7W+GQ968+EuPi1Gi8CHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6JXT4WntFujahUaDljwb3xh7WocqZWF92FBl/w8A+ZUXBpNB99DeQFmvRClgpI3cu22Ro9TXmKFcgjq2dDLlsNR0hdAXuzxm0MhipYtQ56CTCXSdmsXJ7JWZaBGwrx3jOMULltQfVaQsLPvDIxYkQcElYyTnhb85mpJn2QDpWy9zmzVQ0n+nYznZvf6NcceiNDsGbAgegiKk5+lCX13wNqMl+DxSGMe48di2IkUT+az888masI3sD0FntZe4pVI/6HMjOTsvbcAOLZ78vPzn3hrgxiLDerO0gRfpKZpQhydrceBaxRIXBfLIAJKMjh+U5HGsQqHPY2LUH4iKMdQOsO1naYliKm2xqgFQOEfwWzLoe92hsuX+xumcC2/W2ZHu6iip/tP/8YbSe9yIrt6ucOhgsugeLd5r6pl4/lzBTDUH+oTLAzo3SEEn8Tfi6POuDM6DClN0sPccrYqsG6KeEuKTMWQqYdPUh838/zhZuvGSgq7ZitkRGRlAHmHr/8y+IkHUP0205mBCmnT6FHzAdk9jhwqcU6TUa+1Hr7VjqhrbL3Fg8C9oSZ35UWJpx4P9wYwXSW65DleBy3ppyp3i37UEW092qGS03iBuAJB7imQOtPynohs2URZalv394IFV
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1ba92e-cbbc-4cc4-d8c0-08decda60109
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 01:56:39.9486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2abc1uI1yThl6Tz+X+qvttAu1oW5haJexRKxeAn0Ocz+nGU4YGZaNcxlgDjCv8cJkImjwp1ESFqCzMHbLX7iX2Vy+OeWpSEqYaWaXVsK4Sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7465

On Jun 18, 2026 / 09:23, Eric Sandeen wrote:
> On 6/18/26 8:54 AM, Eric Sandeen wrote:
> > On 6/18/26 8:48 AM, Christoph Hellwig wrote:
> >> Disable concurrency scaling to avoid mismatching output on systems with
> >> a large CPU count.
> >>
> >> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I think this papers over what I still feel is a problem in mkfs.xfs
> > behavior, but that's a different issue and making tests pass is good, so:
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Er, hang on - let me retract that. Lukas sent a series to address
> this problem too, right, and one of the things he added in his series
> is a helper to determine whether the concurrency options even exist,
> so that this can continue to run on older xfsprogs, which seems like
> a good idea, no?
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?h=for-next&id=7f162f5bcf50fc32c7e3b432e7ff189571a3151f
> 
> which added _scratch_mkfs_xfs_supports_concurrency()

I agree, I think we can add the change below on top of this patch.
Regardless of the change, I confirmed that this patch avoids the failure
that I reported. Thanks!

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

diff --git a/tests/xfs/078 b/tests/xfs/078
index 8ef5261..dc0668e 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -59,7 +59,11 @@ _grow_loop()
 
 	# Disable concurrency scaling to avoid output differences due to large
 	# CPU counts.
-	mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
+	if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
+		mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
+	else
+		mkfs_opts=""
+	fi
 	if [ -n "$agsize" ]; then
 		mkfs_opts="$mkfs_opts -d agsize=$agsize"
 	fi

