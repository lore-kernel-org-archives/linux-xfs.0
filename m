Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA63D5C23;
	Mon,  6 Jul 2026 06:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783319408; cv=fail; b=qK4/ZL7Wdao669ZoZreSCd3lVNzEW23I9/5Hrn4QfNMhA/2jifLoODEuSAGXKjTyHGPdhCX9rbT0p/IFYP3CA5EtYwhnM1vxbaX47uS92ZUVJ/8T8ATWutsR+5FxzVeZ2zn9W4u+/1bs5x9e6aG4VyMo1AQk1D4soTF8naG7kjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783319408; c=relaxed/simple;
	bh=vz0oHVhrPccbsqdRtm8A+143zZ+gEZVxLGetXk9U6eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZyWehrFpKcETswsJEZqdd0EWRFjy+/0baEpCd9Es8WA0ySEL8k+EnkMSluMfuQRIwNyKBjZC8ywCBjrBCsdLm/qwUHeI+eYcdpPyr7k2uMmJir1dWWYQnqeDWaE0FD79gIUBuefif7VXicwaFRFePrdcN0BBmZOVzRu7hC3hmbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=owdh9T2I; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ObBuLps3; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="owdh9T2I";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ObBuLps3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1783319401; x=1814855401;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vz0oHVhrPccbsqdRtm8A+143zZ+gEZVxLGetXk9U6eg=;
  b=owdh9T2Igwz6sW6pbwIat93j8FOGYnSn3NAyv82/oo2evVBgtmA6ihk9
   EZd5u5zme/cCspZWz/WMupUJdnJgMgbvK+zx2Y1GyQUni/zF4Vz9qbDud
   7U57SIxv0M0lD6a9tJuz8M6vZypeHHTvh/CuGslI9dGAg5Fd/wmfUUVi2
   EW8Ztn8ehiJoDwu9Uq2O7GJk8li669iTBKAXYZ5kP9jLdwf5LAvV1ha3a
   aT+PieLGeNWMigYQYEBlkKBgVnqwLJDffiCD04Y+HR+y47/aXRmp+88X/
   vSCc2DOMfodby+b0JMIHZ9wWlUdrNIJ8I/oxyGsEMR+t9ZE0+DvKS/0i/
   g==;
X-CSE-ConnectionGUID: bYWWxOloQtyjpXJPVgB9sw==
X-CSE-MsgGUID: QUL15jWKQVu7rvy+t8fKIA==
X-IronPort-AV: E=Sophos;i="6.25,149,1779120000"; 
   d="scan'208";a="150138767"
Received: from mail-eastusazon11012013.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.13])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Jul 2026 14:29:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQQ+xqePzw0y0GzGKKBGkL2w73j+FRtcttUp1Y9rwOE56AMtpqaomYydw5zcN7s98sebQ2Cd+/Yr5AlVJNCVriMVIbu7IqjdxjPqgXGbSRQU0zPYL8PXjZFJaP7mamHot/SQO0ZrPo1itJEfaGzBu2enOG3GX2X8i4CqjDXBrMA4VMK5rqSoQIAhPdhNiAt/Ls4/amcqSgpSAff+GPNxwRCznKHgEpzHPTgwkV/2Kff+wi7uartZnm8gzSK7Esz9mfwYbvIISkzrNP0b9TwDzlDiU1mma2sXd1Hh3Fx/xxyi/Ln0vXnR6era9PDZX/odj8YPzWXiwUDMWYCo+NUY/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bHW7ZuSWCE1rUh5CXe1113OZldCAC5J4eHnZzb9Hes=;
 b=htVWkPwQb6vH7F/cY4B+tvDfTlaipYjNVI1OE9URJ0IcNOev9DnWQYDxGMU6OCG5OrJcw9t46e2Dy81eur6YZOVaE4PDGMiibDKtN7ICSzm6AaZ3OTVqZ+Gg+a/TVoNNrN4E4j+Qs79aVy4c792RR6S3eFxtmx67sZWoZGoody+CNsm6gkLPB1dFDWWQ/eSGLlow3I/pskkCAh6tV12vRa2lEdmpiB1wFc9fSWHNZbFOF+/5FOa7wkX/XKdjmPKmMOARAu0QsX5IvYMpG/uGyaFDm0Rz9n27MpfsYuxTSxydnkxUVk0Nv8Ck72LQisnffezgwr60VyF/u71kRD1F7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bHW7ZuSWCE1rUh5CXe1113OZldCAC5J4eHnZzb9Hes=;
 b=ObBuLps373psav1oRH4L6R8eLCNdjvdCen/3Wv+Q0l8JI20rycguID1QZ9RUAjmt+CQSWbjo+aiZ5I2jmKIGW3X2kOeScHPZHNN0XXt8J7uFdXZI/PsxAVY5vSifY9K5PXkNUi5P3XTpWLxlC9tuYzBjEeZ5jCfup59OgNvmG5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH2PR04MB6808.namprd04.prod.outlook.com
 (2603:10b6:610:98::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Mon, 6 Jul
 2026 06:29:46 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%6]) with mapi id 15.21.0181.009; Mon, 6 Jul 2026
 06:29:46 +0000
Date: Mon, 6 Jul 2026 15:29:39 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	ntfs3@lists.linux.dev
Subject: Re: [PATCH] iomap: Remove FGP_NOFS from iomap_get_folio()
Message-ID: <aktK-gWJcef1W0So@shinmob>
References: <20260624174228.2015893-1-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624174228.2015893-1-willy@infradead.org>
X-ClientProxiedBy: TY4P286CA0022.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:2b0::18) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH2PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 7563a91e-fafa-4e70-8a31-08dedb27f941
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|19092799006|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mBw4PWWpx8eVaeUs2NPWTyfpc/nQ+GrVfPzjqmCAnHNJkC44tekrNwDRF/VWN6vJn4ea3lWVA6oOW2+L4oX7GFKH/iAQMPSNVoxj3g4lzrskjBUrlgvEh7pBFRazylSuAgk/H4esk7QSmP7d5Giqpg4GSt5sYM33in2vju17Y98jJk9qWKB7aKNqzxvvm71y7RejaUyfBNPjH5QGVMUsVEtsCjCSj/kZJAH3Vz3gInicf0VzqJhuJN3nc+h/Dti2ORv9GiHgxwclOeR+8xC1rPdii6r9sf/d3qD5VbP0rsUyT32G7dWsKZ2K46hSvNFxVeHywKOKzaEzKxeKoLOxs0+XP8Lhwdm9XUSBOMEiYk8EJlt4jDzFeei6Qb6nJ/hj2I4N1Om4glpCqSSiiwk0/KPy6jwtNscdheE8c99sb3PJSMZuuNWq2Nl7Z7hBmPqkfbZnMRi1cNnOXRUhyNMxKRKCm3skte61zXsCjnfg/Mfz7KwxiAWf7vlmr2+4qq6P5rRNTKnQ9VMPnNYyX3nf0NyqRti4ujlQuKSRjrTehbAcPb9SMONShwjf82mj8JPbqLucnDhR8YY0/wsylyZZ6wuiWmUcWerkjlZRvmoWWmZdQDuknlmVSCWdV2iF+sdEDss3Bwfv5lSKnMD0Ylc6DKQbmK5koj1EZWdeT60JHss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(19092799006)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oFlyTCv6k1z3IL5DuWBqDbdtPMK9HXuD0Q3FYaRV/mzgZYHzUw83u5hoXxa+?=
 =?us-ascii?Q?KXPB0e+noMA+pZjPS+wpZa9U9TUwOf/fa2WNDsGGq3H34KYaBvLRsEM6fzuM?=
 =?us-ascii?Q?MBUj7TeI2o99WD1B6ggolrZ4qFSupRGxpMI651x7K63/xk2o6FMWjR+15nGe?=
 =?us-ascii?Q?Cj/RHZl65UkyzN94r9tGtBDtEVpeCck1tm3PQDXvjN7ePjbeK+PhXpXbZfNq?=
 =?us-ascii?Q?/ZhtqtPdV1NlEMImcGK5EjzVBdFFMzAM8WmItUKbRw46SHmM3V0h58lL+bhK?=
 =?us-ascii?Q?RZJziuSq9E0I11HDOXQdX+ht7YwDyjhb/kMeweFEqHsKD475IVejOQJaa9XR?=
 =?us-ascii?Q?rUWxOEPNX3TQPvpZSj7GxBZWZkyNFHS5wCglTYnnnStDSqF5dBo8po6aq/uT?=
 =?us-ascii?Q?A4DdxbKXy/7bu9T+EHGV+9rFfbZEQ2BWJb341Ka0z6zFPlG8uzxcx2tIG8Gn?=
 =?us-ascii?Q?1Ag1rN/6zqQKJ9i0nTgFk0LiA2YUeLbvW4OsQVDgVthkhbDh9deIXXdW7Fjt?=
 =?us-ascii?Q?AU+U7M3MjOiPb8oLoT4yrmIzfNnGqYnouiZ08WEM57YCYhhVd1spqxAgrxFH?=
 =?us-ascii?Q?8nNvdTuH3R8+j9b1t4el2bKyq0jwC18iRui9dxnzeaoxPL1S1MJjk8sb1EZ+?=
 =?us-ascii?Q?r85bWd9OttMgmRLvBazmgc8KfnBLrDQHvxpyA1T8XYpskDiEZ27q9SIWaA3v?=
 =?us-ascii?Q?mrCHamxbOg9z5RluJDWcwGSec1TL3L6Sx6YWsxo8SIVi3Pe0p3qgu/7o2K/q?=
 =?us-ascii?Q?069BjmcJPfKvR7AddNvUHt220FQia+B8HiBk6ux7ZgZ5VIBfOdypHGMSQ+9P?=
 =?us-ascii?Q?ihiLA1TaTW7JA3K5cEKAEg3RiwiyiTHzpA7VobqeBV+5GjhpJJ7MP1IMtYKu?=
 =?us-ascii?Q?vSwTQHMKByk3f9jxVk5RXNzIH40OUBphnxqyoBoJOwLu8ME2p8psktYAv5Ck?=
 =?us-ascii?Q?sYFc3tT0lG8RSFFTcuv/Akdjp0Xvz2E7YClsNDc+autf4MSESnTt990Eyok4?=
 =?us-ascii?Q?CWAYYzl3WO4ce4Cp/YBM4QqdG9U6T1MdjAiVr8ZdglK2X07ZlgX2DhpWyQvk?=
 =?us-ascii?Q?y8u01zoAUI8KD6Nr4KNg3CUWD588kXJY3MhpKUhzSpv+jKpK/KBoGIUOI2md?=
 =?us-ascii?Q?Am39Qi6aNUZFdfHLBpeE5oSbNzsoSlPKXd0dtbOsBUATFUuqVyVFUUEJPRoD?=
 =?us-ascii?Q?pvwmbs3MF4BQlAVDjEF5m0GZB/36AHMCNS8vpWORQdKk3u5sUpodXqBWr9cN?=
 =?us-ascii?Q?U8dUwo+2Ns7MsbedXjCgzRkUgKj619xMmiLW+pWL/xFtnEwjIKXk8I0uEIR/?=
 =?us-ascii?Q?HlMcwf1spWyq69ZifQMQEbkrI/dURgmiasX/DcKm1rC4Cqi3sieLaHq5h+tZ?=
 =?us-ascii?Q?4N5CxYN+CIv9cipPFYOsg0y8kssr2VwaedULu5JYrOK9JsQQszHbykpksIFr?=
 =?us-ascii?Q?mhiOYPh2tRgfCJMe5f22k57S+AAki8Ay9igecFatkFKE1EIcGStW4im4AksR?=
 =?us-ascii?Q?ZVrcsXYajuk/a4XefK7bnxCcFuFspYvzuWPGhlGEzukcG2wewZro4aOFl4UT?=
 =?us-ascii?Q?iLprOKPgoodC7fF7iGYH38XJNXkilv3NZyd7c9cXZBfuuaZHQXtbvqC6ZUwL?=
 =?us-ascii?Q?5qXQHcsSeeZc2dXrzrkQU+fy5iNxyjKmg7zPPD0aG8V6oTqpJs08Z9wKiMIz?=
 =?us-ascii?Q?CwrCDMybbkXOZP20k1AkRBqFx9+LE7B1aJ39Mr/wO8btKdy+sw3erL4JkYB5?=
 =?us-ascii?Q?eE09TYPgPSsU33wxBFlsr66iJPj40OQ=3D?=
X-Exchange-RoutingPolicyChecked:
	XZkudOC0Rjuy1oiowRSROWVbXLal9S2sGPPZEaNaDD61/3POFeki1rLJPgPEY3PudmqXnKmcS1k/tWlieIZxFzcIuUOrrcDrbJot+xMD5R/D4Q7L4oHvYkLBHclExKy3PYVuO4Tb9vG7QgM5aa8DmXojiRJ+90s8Uo/kI9E3ybtkgIlO09QzklkH5tujpvg/XYSgddsQdyj2en+n1qSsMzPN6MvMMXJgOW2W9A+H1JBhY4BPhf2Ft7wPDp2/7FSvusnD4DJ7nWNLQR+ehF77YCrzRagpHs2jzeGRxndV9U6b7bi3GJvH4IL9bIlTuzk1WVXWnMTrlCmCAWj17Iuv4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v6nJRSEeLCEa1V7UpIGhi+k1pt9PcEl1ujsNPmS3qdI9dmKmM07w8k1mXXPeTDu4vYHbnSnAWC0Zb9Gc2EJRf/p+RGD5RyJuq5/iQCObFDnMdgiXFLDnEzFcP4UPYAs7wsVbyulMQCpzkldPJIpo6vZLiSIHoaKcN4tc0J5zMd/QCFqqzf21oL4uQ8Bopq+SBb4UDVXAi19+2k/9vO3T/Kr0n7+4sfzcFs78pfU86NFiCn9lWKfLTh0ZrFiURSI25h2N7mHkYxj0FUfQZr3CNYxd331AeHpChJc/WnlszknHmBRznL1ViEKMV3w7Ef3WZHsxkX7MnYsZDropy8lz92U4NR/RoKjUnw96OmQW9aarcZ43IGiawU5DSNNOdVMN5SrD9ZLIPnHFCr4uMYWJ8goYOaQzhzAQSZI1SkCs21l/NRuoLjZCqxV/RM0CaPwp15TBuC+HuxeitQHrQ22FMIM9jRT7+Ov9aD65c4D3URrfBTP22tgGoarm5h1ZRdSWuKzw4Latu1EJKxZ/+22wkceS1SA1Ao+KYwgtD8LGqmSgHCMn8R7an/ZZYz75VjZfFelVyzaP1yEcFU1W3Wb74HXnW4iCyPna93qgsX0rCkKunP64f9gylyUFyWxVrmA+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7563a91e-fafa-4e70-8a31-08dedb27f941
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 06:29:46.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXt1fIS/up+PELokBaFAz/W+wTzjrauHW7z+Uup0zV5VYTTw357pZxXFLFzqQwF8NQy9uDajrVattcm7fZz6WTBstnCe5YFHhLf0U6Lxzqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6808

On Jun 24, 2026 / 18:42, Matthew Wilcox (Oracle) wrote:
> FGP_NOFS is legacy; filesystems should be using memalloc_nofs_save/restore
> instead.  We have it here in iomap because it was buried in
> grab_cache_page_write_begin() and we didn't want to change this behaviour
> as part of the folio transition.
> 
> I have tested this with XFS and see no issues.  Other filesystems (cc'd)
> may need to make adjustments.  Please test with lockdep enabled.

I applied this patch on top of v7.2-rc1 kernel, and ran my zonefs test set.
I observed no failure. Good from zonefs point of view:

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
