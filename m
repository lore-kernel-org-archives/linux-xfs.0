Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7357F387347
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 10:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774261988; cv=fail; b=uG1+DT0nXEQhR0iEeVtoX4uYFcf4TjEox7TXAk8s9Rjh3x3oi4TC24tyd1Mq2ZxgwXbP5cWzrq+M5biWq47iFg+zcvVrc4AuOPqIBZTWZs/p+n1nwH0Y8W2wX6G2/7eLp4dqB5urT7Vd9B/EhpuHqGcahIKJbFDc8Aa7Z86VM5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774261988; c=relaxed/simple;
	bh=QVuYmTA4gzy5vMZsIhT/JvIlC9qC45LMiMWzxAHusMw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L1Hln52TBcf5ziKz9H83hdxn93tnIUFPAGlb+Xi2gUTxEh5pmQ6sITr+cPkV1vxQSzeSHxE3HErYMK71yM+tkzMbWIGe8+jZUjeguJ5uYXR5ICUQsnwbYZnPaWZGlXl/9NMpVpQoajOZ9P6wHh4v03wcPMo/TYKCDSngGLx13e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BRtgdMnU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aXf8tDt/; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BRtgdMnU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aXf8tDt/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774261987; x=1805797987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QVuYmTA4gzy5vMZsIhT/JvIlC9qC45LMiMWzxAHusMw=;
  b=BRtgdMnUMWmR0VvbM0xs73HmA7bPY2Ce7h/VEodLB4zLogGNYkupGpo3
   STHypekuxXx9adNFAqFZo6EJKvOsJ2aDixcXBhhSonyTjM5W9n9vrIN7h
   JsnMphPKBVyyYcVMuc6w6ov6J4xFNPzkem7uNGyQHz9t2nks5nO812lzT
   TRW3Uj8gUXwy4MJbUzrQ3rOOQ1KrOBdCVpPxqV0lhiwCdV3Gwh9GJAW68
   EIHkLRHARgb9BV2JCI0hdd260VutvqKhqccQE+ok+BKTDzQ1K8BGFfWYk
   hA8ljkqgsC9t2Ikg8Zd3XR05b4dUaBJCsO4RdZy0pDQlMNRnLdzjFJZCH
   w==;
X-CSE-ConnectionGUID: JmmPlWFUQ/66zUWJh+QvAA==
X-CSE-MsgGUID: R2+iqAYbRw2sr5F99Iehig==
X-IronPort-AV: E=Sophos;i="6.23,137,1770566400"; 
   d="scan'208";a="144176680"
Received: from mail-northcentralusazon11013056.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Mar 2026 18:33:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ot0a7GfmHbA559CsvZDvLswK58qDfEfm5RS3p9bEFyIhIFEuPi+JbkqKvzIZSmk8wcpB7pDLEQ5esQ9LGoW+/ziHijsZCRlbwPAtE9ZCos1c6vZyg8w9e+wxka+sO5j/rrsNYHJLD1qYEdIuuW0fj8wHmF2Pc07em3xHFaW6zxbFKMrQ2w/u+X4atZUH6YSr9numgy9j4eohSdq+5Rjmd4uHpxKmi1g7Knggz5UH9zvTS/O2hiIhfBOGxJ/vy5n0PhrGc/dRWkXBXjwEiC85034P7pV+WIe3E8weHpqXzBTkceVy32Ay9L7+c+0giEkABFsTTe9CC7FewxnO/hF85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVuYmTA4gzy5vMZsIhT/JvIlC9qC45LMiMWzxAHusMw=;
 b=CImu1BydpX3gUj5P9KQypIZBtxbPFv8vKCpoOeLAjLXHeAmvQ4SGW3Wfm2adcjYXXbu/+sW0XktGs7qNXUU667M/qYdQns7tTzAiJLgJDTcQvj8u8PGyuSd0NdEVBdzHuETLQUgNbAkzGxPaDW/4Ys0h43xh1PaIq52jIP+/PYC1tNOvrFY1VEKNNawd1C7QX2NenMJgS0Ck7HCCGsHzFfs+ktz1h+qba2Mrczkj6egNpdjD98n5LBqaDLbUiXYAgDfTPp6Jmis9PDVprN7kQDxaPOk7wfqD70eAo97Jj+fuImPcnPGBvxs/UUEi0tXv4B1Zwlij3QZ9pfjJkXbLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVuYmTA4gzy5vMZsIhT/JvIlC9qC45LMiMWzxAHusMw=;
 b=aXf8tDt/FzyU8kjPd+tQvQx+CX0i/iGfnou6jCUoB8frWdBqH14LRMnwcq7tQM5YZ0IGKhdBaKC8MygffiPcYP4k29DBMhMvEfQ1Y9tdgVqbvBqgDINJQfvGZ0DQbWtkA6g3WZWF5YFd737S1e/Ub0IJxDoUF4C1uNfeqI/brNk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH7PR04MB9548.namprd04.prod.outlook.com (2603:10b6:610:252::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 10:32:30 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 10:32:43 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Thread-Topic: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Thread-Index: AQHcuGneZFB7TPbR1kKesCchYVi6DLW7rf2AgABCA4A=
Date: Mon, 23 Mar 2026 10:32:43 +0000
Message-ID: <97982591-5909-470f-b453-a1d1397d4cbb@wdc.com>
References: <20260320130256.35225-1-hans.holmberg@wdc.com>
 <20260323063641.GA24722@lst.de>
In-Reply-To: <20260323063641.GA24722@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH7PR04MB9548:EE_
x-ms-office365-filtering-correlation-id: ff34a835-84e1-471e-7dab-08de88c7847a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 IeSU3qj2yiisFv/9Yc156VhHqQJiGPMWIwaZTO57ob4v1UZhZMvfinnX+ubC7q8l7XMPZC0Uixc88CTYLYfFeAN+DUgvznghbG142NQ37cFcURMvmGQhR9aGnv0M4H6Fli6xZXCOZFfuBZolOsYAOCz7sCAEQm0Pu0qfbQBspMmax6Mw79L7ZxhAnhhyIWtdE1qPnLY6sdSl0bu4Sp+qLQKIz/AygDrMY2sHc0duopxBST4Oko/NFTJQnSB2x4obpMEkSUwOfT8nLW5IUHy7Z83kWeBgKbRtph6wTUxJdfm6IXpz0AO1hgSNPKy05CDXUqJuOiUAgtRQBgmFGvaI5BVwXW+aHqwdmJJSb+OJ8pRLfC2V2RliTrjH3OKVBOFRKUSkGGe30YhHioJKuvANSnoVjSlQtEzw1VX9TCO8RftjMKbtvJneVNnrZv5+2QlERkVtkU02iIJlHUFa+fvvwlltDbntftzrEmmw5VN42gOzUpKFEk4Sk9MdgDdD81Csa74ctSfpVkd7lc57fYyZisi6cd+XbAXWILlhL3oDa3eoiKhCtjqpoLyrJumiccgTvaozAfp/H3CwWXKowt9r016kVsAhkCbMnUGL6chc+Ck1Y0nKa+AYC8i4b7NlDv+Qvim1qGPKx2zjRE8fG1Q4eA6C9vg1NAMshwwhu1iPg5zij1YC7ef6JoKI6GdkEjwXRSdYV0RYRvmUfYGPhrKeotBH/K6UI0i20BelyJ05ulTwq3nmmtRHns+apaDCxVQIXsreVTZ3Ja/fv8Q0d8ckc0ydxJYBqQh9cuVyNVBlujA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ellJRG05Sk10eEl3bmlvZHBhWExGR0NMTXZNdXJwS3FoL3dDdE9TclROSy91?=
 =?utf-8?B?NHRTbm9OQ2NtQnU4NHl1ZFBkYXQ3Z1RRaUoxVzFxK0xmSkNxdG9RY1FlQWd0?=
 =?utf-8?B?cFZxZmtnNVRVRVAyY2JwVXFQYWxZQ1c0VW1QWVFORUFKZFhlVEdmWVJwaytD?=
 =?utf-8?B?cXpYNThIM3RoMCt0djZuT0tMVG9maEhXT1Z3WXYxMEsxWEwrczc1emw4cVRJ?=
 =?utf-8?B?OHk4cDRYSWpOT1A0KzErT1FuQ0xnYk5uS3F0c1hUeE0rM1huSHVCUURTR1p0?=
 =?utf-8?B?ZitlK0N3dW9keE9WTzZHSWtGZ1l3UFhPaHFDbEhDWEFGdmtabUp5UUJ2eFo3?=
 =?utf-8?B?ZkhYR2cvTEd0U3dtV0tma2Vqek5zaTQwSDR1RlhLOTZwSUIxb29iaHFwZk1B?=
 =?utf-8?B?alRrUksxOHFDYUdQREcyRmtRL2VKOE1iQ0NkOTdEdjBXeUxIbDFaL1ZvUWFP?=
 =?utf-8?B?UEF2YWR4T2FCVVdURU4vYmZpZ3VLMm9aT1ljbW1RY3htaU9id2JLR2ZPejRH?=
 =?utf-8?B?QUtKU2ZQcnhJL3hpeWRWalQxNUlZZHlJeVkzT0dEdEprYjdrRHJUVElOdlAy?=
 =?utf-8?B?NElvN0h3L3d3VGx0Qmt5L1Q4cllUVENYZENDQmozbmF4SnFmc0lqdDZhTDVS?=
 =?utf-8?B?ZTJWNWh2RC9XTDdWZDU2RDY0RXdaUFFHN21lYjVnemNpZ0NhQkNjS2I1SitB?=
 =?utf-8?B?Z0VHRlhTU3d4UER0bk1xTEQ4MUJWd0NEcGNGaEFJZXBqOXFUbEM5dzFuQ2gv?=
 =?utf-8?B?RWtPMlNoZW15aTNHRkp4KzBRK09zZWs0cHhnUXNvaFhoakFSRklzL3FYb0Fj?=
 =?utf-8?B?YmttM2I5UUk3aURuUnBnQnJZMm5rbkZsdGpsMEw0bThIUmV0TGMzclBMd2s3?=
 =?utf-8?B?UitzM3pCbG8yUW40a2lrVTFBeGpnZWwvbnRJZFMyZ1ZHaWxBM1lkZXRRK2dP?=
 =?utf-8?B?aVhEM3l3czZrRElKclJ6SUp2c1h0M1kxWER0Z2NmWUk3Q0Z5YTdZVHJ1UDB0?=
 =?utf-8?B?UmJEem9rNFYvOFZyYm1Mbmk3Zk0xTEp1ODBsajdaM3E3RGlXM00zUnlOZWhK?=
 =?utf-8?B?ZDFSTFFJMFdKQkMzdTgyTE5SbzBVbk5lN0I3b0ZRN0pkdDJyYlpHZXBQb2F4?=
 =?utf-8?B?aVlsa3IyZEs4RVNTb1Y2Z0UvM00yeFJtTDd1Wmd2WW1GeHE1ZzY5SXJ3dTli?=
 =?utf-8?B?QTQzSGp3RFJocmo0SU5XVmpZTnJBbkEyV1JZTGtrTmpKcGdhZEUvY3FBblAr?=
 =?utf-8?B?aml0bks1R2EwRGlJUVFaNGpncTQzN0VFUHpUa0lEQ3lvbVNwUytvYkIwcnBF?=
 =?utf-8?B?ak40bmU1RVJRZmhsbWtXTXpia3lMbHhXalRRcEI2dit5S280KzdBd09oOGo0?=
 =?utf-8?B?ZFc0SFVtVXFkQVFXNEh0d1l4bWQ0OGdsakppaDlKejYvdll5SjE4NU5sRFVN?=
 =?utf-8?B?Z1BhcHhpRTFVMTNpV3hJclpqVEluZkpHVzBsUllDMTdoVldSYjM5S0lJdFUy?=
 =?utf-8?B?RnN1ajNTSzR4TDlmVFBtU0lCUGlIODdWU1ZUd05kZHdmWE4wZE90QWlMalR3?=
 =?utf-8?B?M1ArdTB1dSs2Q2hIcTJBZ2diOXdaNDlKT0ZxT0I2ckxVQ1FYTm9QVVMyMkMv?=
 =?utf-8?B?VVR6dkEzajhhVVdENURrRjB5N0R6WDJRdkl3VmVkMWNoRGR4T21qbUJidE8z?=
 =?utf-8?B?eXdOL0tEbmtKaGxFUEN2YzczRmVVNVpyeG1IWGtPUjg1dWFtOFcxa2N6Y3l3?=
 =?utf-8?B?cXNBY2JvNGFxbDEzRUh2YTBMa0VKeEVHN1A5Ny9INmMwUnp0NUVXTXVucVF3?=
 =?utf-8?B?SWpzdGRVWFlwanpaN2VEdlE2cmE3bVNrWERYM1NRMFcvdHlVanByS1dNaFhy?=
 =?utf-8?B?eGVmQ21mWGFPK2xVNjhCakdHVXQzZWVWazNaeUNVY29ZOXBaYXVhOFNDbUQ0?=
 =?utf-8?B?VzNaUEY2b05JNWhFWmt2SWtSbDcrS24zQ3c1ZGt5UVRlbmw3Q1BieEk0UmNv?=
 =?utf-8?B?bWJKZ0VJN2RZOWFVemlMMVhzV2MvKzBZTXFDL0dRL0JPL3pqYjBuMjhrMUR5?=
 =?utf-8?B?MFRFN1dZTEVRVFBGdEl0OHV1WFV5eDFMeFdyamczUU4vSFV1aXNqaitFRlg0?=
 =?utf-8?B?U1ZpTDQ1L1pqS1d1ZmlqM2lwMSszaGFpK3BPWGRMN29jYVYzQ3BXSzl3WkxO?=
 =?utf-8?B?anBEaURNcDRvb1FrTmVIbWJEZEVNWjJRcVRnT29LTjNUS0hObUMra1Fvd1VQ?=
 =?utf-8?B?ZWoraUZRWXc0azZEUDVlNnNHZ2E1emIxYzl4T3hFaFpZZWdoRGVZRW9yY1pM?=
 =?utf-8?B?STFwcnZVQXl4YzRNdCtCTXpqcDJIWFlvMllYeFNWYmY0RHJxME5rUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A277B68811B2344A7A7121EC2A6443B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	F/PWqZvCx7yV1vL4bMukMjHEXsqgEPPRwi2A6sdWiqxj0ihsfeqSATbK3xOTnTHCUHmngRICet4whvDaHiZWHBYh63PFWYhw/wb43sgyyEdiTpaTEUJdAhDn0eVWmNi9Ov3oYM9rl+2JxGnonJc/7hLc7p5BjtV1q1+p7/lYsWH7Jjb94lDva2DNhjRD8NkN4Q2mOwVYRHHzyA8Ijzlmoci57RsWpgfbBAn1OIi5OM7Z5TfaguoFeS45HSKEYht8mxxifyMmDxvRtcf6DGg5ieYX7nbroC2qfMTeIKaQ3uK+KvcwNXYesbk1xjkqSjQokcFqA4DtG7ampCVUVp5TrA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dZQ4J97g0mt3qVwT6SFN9Ta2tzrZW78IFOR33AzJr+gDPCF14+u1wDNvI4klkjvsCwNb0O94E0z1s6T2uH4n/dSu5FyeIdt+AUDMYcIEsrroQ2YgBxvShYHfbHCyHQwgWXDRhxJ8ZSr7U6WI5x/WDFhSYMi2eXaFJK2F8MUEvJYQDx6RcC8lDBu8LRLfJOAL6k5V45m/6lmN3S9CfwZryQ5imo3NhJhKypXPmvTy1RCv4L03Sm/MHaZeiK3dobFXtiS+x5509g/1Qe+Jvaa49iAYwva5qLxablIOCIor9Nofbr8ffLlglMyBEETqM+MXkSh6F11RjJ6flPzGmjHFNDgFyfLFMGfFt0UbisUO5gTzJYkJ2m/x6FU80h5jzfM821W2O35CqdTrTMEehoj40lnRlFcDSnXzygr+6OjCxUC+U8Uu1XNuU2B3hSsJgSbFDbrcdyU8mr5V8WzfOtvr9uyAQ6+8ILdoYorxaOypFmXISU7VLOtIjLgvRFvOxAZ1qATjY9u8Y3cRnkE4WSivOXrKWtEVgCjsKN8MgDSaG79jbtelP1DEpVQs0W6RJCFDufucgiAuY0oF+a3BaDsDEcGG/djfLkwSREWflV8+ZU+m64BKzDP5d97+2sDZsMBW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff34a835-84e1-471e-7dab-08de88c7847a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2026 10:32:43.5285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MLDPPbHralzJf6JvcqY8MWzV6vUzZF9r5aDURI7t1a1GHQDrCEdhNvzfj5NkXGMswHj2tsi7qM0wWuSKWo6rWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR04MB9548

T24gMjMvMDMvMjAyNiAwNzozNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+PiArCQltcC0+
bV96b25lZ2NfbG93X3NwYWNlID0gdmFsOw0KPj4gKwkJaWYgKCF4ZnNfaXNfcmVhZG9ubHkobXAp
KQ0KPj4gKwkJCXhmc196b25lX2djX3N0YXJ0KG1wKTsNCj4gDQo+IERvIHdlIG5lZWQgdG8gdGFr
ZSBzX3Vtb3VudCBoZXJlIHRvIHByZXZlbnQgcmFjZXMgd2l0aCByZW1vdW50Pw0KPiAoTm90IHRo
YXQgaXQgaGFzIGFueSBtYWpvciBlZmZlY3QsIGJ1dCB3ZSBtaWdodCBhcyB3ZWxsIGdldCBpdA0K
PiB0aWdodCkuDQoNClllYWgsIEkgdGhpbmsgd2UgbWlnaHQgYXMgd2VsbC4NCg0KPiANCj4gT3Ro
ZXJ3aXNlIGxvb2tzIGdvb2QuICBEbyB3ZSB3YW50IGEgdGVzdCB0byBlbnN1cmUgdGhpcyB0YWtl
cw0KPiBlZmZlY3Q/ICBBbmQgb25lIHRoYXQgaXQgZG9lc24ndCBkbyBhbnl0aGluZyBzdHVwaWQg
b24gYSBoYXJkDQo+IHJlYWQtb25seSBmaWxlIHN5c3RlbT8NCj4gDQoNClllcCwgSSBjYW4gYWRk
IGFkZCBhIHRlc3QgdGhhdCBjaGVja3MgdGhhdDoNCg0KMSkgTm8gZ2MgaXMgcGVyZm9ybWVkIGlm
IHRoZSB2YWx1ZSBpcyBzZXQgMTAwIG9uIGEgaGFsZi1mdWxsDQogICBSTyBzY3JhdGNoIGZzIHdp
dGggcGFydGlhbGx5IHVzZWQgem9uZXMNCjIpIFdoZW4gdGhlIGZpbGUgc3lzdGVtIGlzIHJlbW91
bnRlZCBSVywgZ2MgZG9lcyBpdHMgdGhpbmcuDQoNCkRvIGRvIHRoaXMsIEknbGwgbmVlZCB0byBh
ZGQgYSBkZXBlbmRlbmN5IHRvIG1vdW50c3RhdHMgaW4gDQp4ZnN0ZXN0cyB0aG91Z2ggKGNoZWNr
aW5nIGdjIHN0YXR1cyBhbmQgcnQgYXZhaWxhYmxlIGJsb2NrcyksDQpidXQgdGhhdCBzaG91bGQg
YmUgZmluZT8gDQoNCg==
