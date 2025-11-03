Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC826C3BE
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762184153; cv=fail; b=uSqwCHJ5YCVnqiYzDNU+Xi7fapZCN3TBzAYKP47TaOPYe5Dy/sFD+SswBzxg4CtZTsXPQt1bBo5L0WMvg0wWPCf7w06a0+Wwbyx/Nwk5dtE5KV4VVhIB8k/hi2vwsTkBluPgkqnghfIRwl/qu7sINFUyDcfV00C/0x7+22TZyTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762184153; c=relaxed/simple;
	bh=9VBB3LkPcODxNBDPShlJln0AJbHEzL96bvyck1EepGw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kqRG7LFevgg+zDFXqNu/5y8uT3n3LSw19ij2wmyMxWujG/NNEXUSVt6mAOY5mNdbkRMBTZuaE3c5ibiqwVH2itQT7SZhXnssnWpB9t7ITS5kzzwXPTNwcHPfSZrgKdwKlTKkvW/DvHgLu1LtgKUUOM+0DFzsR2PvD3z6786nCiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=P8V90UU/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=eBoD7o5i; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P8V90UU/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eBoD7o5i"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762184149; x=1793720149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9VBB3LkPcODxNBDPShlJln0AJbHEzL96bvyck1EepGw=;
  b=P8V90UU/x+ET/zxxfhQt8ZQ+wLtjFLnQ0gLg+pzuCiRYcZgzOLg6hLSI
   rUppk1VtGFkjlMbGJoHwEKQ4GVLAv/8x8nKMzLoWc/+ZFnwK1TIEihcJo
   26tcOzPrJVu1IrYIaexB2IjXVVzCjjfYLALAGf8hSZr4eQkFJ/mmxh0MY
   k52JmD29Sn5Az5hZjtBFV6y8AfdSPVGf9lSi3vybZ3l56oX0PudxOzgk0
   hkhtMyyNsnUJWmGkk6ygGuhVwOIJBuT6hMV3ISTkrjpt/8OIipYbS7Dpn
   tR1BoMNBzbgLLVi0YkQzVqa2coRktIgRT7eyuvJ99drgEfNVRlzwpwYZc
   g==;
X-CSE-ConnectionGUID: 0WnSfbzlRCiJ3DBr4lDKSA==
X-CSE-MsgGUID: Bt6JqER1RNGOQQL06YgRHw==
X-IronPort-AV: E=Sophos;i="6.19,276,1754928000"; 
   d="scan'208";a="134049391"
Received: from mail-westusazon11012066.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.66])
  by ob1.hgst.iphmx.com with ESMTP; 03 Nov 2025 23:35:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jf1WOpxClis+VPglS/lizBbf27fLIe9fupbpyrPD8DNIpGAkpq7zSHGmv/sd5kTDGyYMg7zC01s65HcUf23BBR5gPN15k2Ao/mq/VCydpxUJyB6Mb1nFnGn4ipqGX7DaxSs+2XIsUWaYOrgzESi6AVqVbwIK5euD0+YQe13vBF7gThYpbe9khifZFxuDrTPN0Q5krYwX9DoGfdVKueyJzlpUaJtUFre1ILA2sBipcZ1QxuUgjsdGoSB2FhRhDq99gYtSV1jBGCLfAUJFL4kDW+mdcmjtCHRKnKCCbGIeKwTgSTa1DgwRwaMJARPd4m5gbpRQSMbO1Nf3Ub8UpKAmbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VBB3LkPcODxNBDPShlJln0AJbHEzL96bvyck1EepGw=;
 b=OrX/RuOyaXkj+w4gPjX3rLFTPvnLSQE4VR5EPhcw2UgQcidRkMAL5AegZ5hkxd/WCxhlIzkQ+jRKasLoNeByG72+ascXCyJR1HCvq1fQT/ERT6+VdL2x7d6XkvqTjX15EC3HjWovHF8SvGLVbo2cfVzKLqZKQm+P3GM/9iQ/6ilKkUOUeJN68TjXBBCYMQJnMDdixwkHwrLzOBkB43lUNZf+2EXS/vMoj7Aa8WnzDgEhZ1LxLnmeRl1lRrH5p/aUmKY/BrqLyo1ZRdVMziEMFREUI4FTxrRAcHRrZ56jRwSmM9fDS3J0ga+01qtaAMAEM6os9NXoY8GlTVI4dKJNjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VBB3LkPcODxNBDPShlJln0AJbHEzL96bvyck1EepGw=;
 b=eBoD7o5ihKdh0wZgrIjksxKs/EeTSbsyPmmwZ1eG07svYqRUxZihb37dBteto3eDbTdoEMY1QjXhXjXfSxqbf8csMN1fuf4OCtgjejmK8YpcHs8rupUuLZRKWfxxS8IyjzLslw9O5mPhMf1eNLUkacjnQCoKwU0HVXL6UtQsfK8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB8527.namprd04.prod.outlook.com (2603:10b6:510:290::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 15:35:46 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 15:35:46 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix zone selection in xfs_select_open_zone_mru
Thread-Topic: [PATCH] xfs: fix zone selection in xfs_select_open_zone_mru
Thread-Index: AQHcTKrDAgU3yhkFKEKs+S2x679hmLThFbUA
Date: Mon, 3 Nov 2025 15:35:46 +0000
Message-ID: <ade35930-4f94-496d-8883-bd984c68c45a@wdc.com>
References: <20251103101513.2083084-1-hch@lst.de>
In-Reply-To: <20251103101513.2083084-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB8527:EE_
x-ms-office365-filtering-correlation-id: c5f4ee76-1213-4e92-e72f-08de1aeea89d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y0dteWM3V0NQVUVoUDU5VDhGTk0wQ3lsc1RIbXVlNDRXVmU1UndsZm95a3Ba?=
 =?utf-8?B?YVZPOXZKZEF2VFpFSlliRmpNTzZKWG5BUm1LYWtpdWl4Q3huL1pLNWg2TFBj?=
 =?utf-8?B?UTQzb1ZRdUJReDc4c2NmRHhlYmtQN2IxYTQrY1RUZ1BtZFppbjg3TGU2YnBM?=
 =?utf-8?B?Ynl2ZGxyaVQ1ME8wTkszRVJ3YWpuc2RpdDJnOS9zRmdTM0dGTEpQWFdhak9X?=
 =?utf-8?B?aW52cGN4bnNKL09kMGw4WGhGQXJranlTQ2tFNTdEWTEzUzdBTWFoWnpqcVo2?=
 =?utf-8?B?MEZaVzFTbnErSkhuUFdYKzBreUVVeTlJV25BZ3ZUSkJma1hMRjdDZWNncmtT?=
 =?utf-8?B?RE1iVnlxeUhtZnBhTjdTVkdUbWluK21vN3R1enJGa3JVZnVDa0FueW5oZC93?=
 =?utf-8?B?ZEk5NzQyQXJMYW5uTVorVUlLWUJ4VjNWRHRpbzFmSUlBdTdFdThabFdzdFR5?=
 =?utf-8?B?Sm1EZzdwYkdGZ29zM0t5QmxXNEQ4Rnc2dVJsNCtXNXhHamtReExwQTR6Y1Jp?=
 =?utf-8?B?elVQNlVyR3NyZjNrVHphTkVKTDVGWEh6Sm1GMXpEVUIwb3p6U0NBT21hdDNM?=
 =?utf-8?B?K0FkU01YRnZLUWY3eStsLzZaNjRHR1dTaldvVnFMdVMzWDdWY1E0WHV5bCs1?=
 =?utf-8?B?cDRia0NlcXpGYXMzSVpvVXV2ZERJRjdOT3F2ZFhvOWpsTllleWs5N0JETHFy?=
 =?utf-8?B?TXFQOEhiTVhnQUFWRzBWcUxxYUZLR25Fa0hRQWplUXRPb0E4RDgyWlNLc3Rj?=
 =?utf-8?B?anBNdFpmVElYVDJuaTc3bTZhUElrUlRzdGx6KzkxeVdXdzZIUkVpUzUrb00x?=
 =?utf-8?B?bGJIeHFsd2VVSkdVUCsxOHo1TmxENWZjZXlRTVMrY1kyOTd2VURCQmlmTElZ?=
 =?utf-8?B?TFRITGc0Qkc4WFI2bTdobTVsZ2Niby9iODRyRENRU2dKTEtKZHdSOWlrUVpU?=
 =?utf-8?B?cjZUSUIrM2tPOGVxelJQamlVUjhIZE9YWEpsM2tZdEVmbTFxV1Q2bFE1M2JU?=
 =?utf-8?B?Q0NtWlBSREl3RnluYmsyekJXa204b1dXRlRLOHhCc2twMkNpVVIrZnRjeWtB?=
 =?utf-8?B?Y1Z1YTZQWjI3T0hZd3NJM0RUbTVFZVVJdEowMSs5bjdOQzRHVFpDVWtvcldL?=
 =?utf-8?B?YkkxdUF6QkNTQnpHR0xkZy95MC9ZL1dXNlo0cGZncGVWOUVLRnprV2NGSUlC?=
 =?utf-8?B?LzkrNHBSK3Z1UUZWb1gvQzltMU5DYURENVY2UTRBOXlPVHBkcUNhS1Y2akpx?=
 =?utf-8?B?WjFYZkdXVE4zRlZlc0o5RHN6ZkUxZTdTcHUwcnpXdzlQMHlwRlF0UGIwbHk4?=
 =?utf-8?B?YzBZclVNMzRnTllyU3dzdEFxWHBVekx3SHhCV25NQ0JmbXJoVS9qa3lzTFY0?=
 =?utf-8?B?ejJKWktwcEJlN0htQk9WQU1FY2RJcE9LNkU5bUZzaVVnUzFEOVRlZ1JsUk9j?=
 =?utf-8?B?emdmWjdmdkN3VDduZFlTNmZtQ0FvcUIvTVZja0srZEZBdXk4U1RWaEZsVDhF?=
 =?utf-8?B?Z1dadFJ3UWRmaS9QNERiWGcrd2g0Qnl6UjVnclJXSkczUnhqU0lEVDJCaE55?=
 =?utf-8?B?c29JdXc4VVJCWXlFZ0F2amNSaW9wV0pia3UyUHJMYkZDSEx0d0ZoRjFDUEd4?=
 =?utf-8?B?and4cjYyY3Z3ZnE0dmJYQTJvekoyaHhLYThqUmhJUmx1YzRWbzg3WlRnaldj?=
 =?utf-8?B?b0lPNTJ6R1FxaDhxRENLZnB2U0c5dWM5L2FSK0k5NkErNHl6TjhnazF0RHJI?=
 =?utf-8?B?TUFYQUsxL29CSXI5T2ZhVVpzKzFjM1YrR0dacnE0TEpSZzlTdURQbDdJUDJK?=
 =?utf-8?B?Q3grZDA4bFRscm0vZElmTWVoc0tDZ0Q3b2dSRy85SDNOU0xIZ0VwcERRb0s0?=
 =?utf-8?B?VlhrY3NkcXAweUV3VmVHZjlZY2xXTEg3WEc2WGorNlZvbTg3R2JzN2RKKzVR?=
 =?utf-8?B?M1VlZWllS3hoMlVJalhEUjROT3k0VDd5SFJWYXNIdTdneU9MWWsyYW5JM2R3?=
 =?utf-8?B?SGI4YnVXdXZCUnBTTkxtSXFicnZuSFZ3K0ZxL1NBdGU3Z1BMb1k5dWF5UTNn?=
 =?utf-8?Q?hDB9ih?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QlgydmhBY01XRVE4ZHQ3ZVliKzdVZ0kxRnhaR2VlTE1yVThlaGVGaDdLdTVD?=
 =?utf-8?B?YnhRRXgxY29ZaXNTSStwaHdSNUlsSjNwZkpyd1VsS04veWxXNVdQVE1aaVk5?=
 =?utf-8?B?YmEweVEvajZyazdqZlNxblQreW1STGNmWTVaaVdkSUNId3pHRjlKK0JEQzNB?=
 =?utf-8?B?N3ljSnhuYytndHo0bW1JZWxGTlBWdTV6UnF2MWxNcFhiblFOTUpGaVNLbUlS?=
 =?utf-8?B?TmhQUHlObTloWW5ueFlKcW1PQVg5TVp3Vnc0ekt1UERtaGtaSzIzM2tMU2dJ?=
 =?utf-8?B?d0U3TSs1MDEyRjNwR0FLNVhIWHVldC9zOHVYYUx3TWsvZW5LTDJaM1l3Zk92?=
 =?utf-8?B?ZTB0U3Z4RlpIL0NyTTR4d3JmUC9IK3ZROWRWcFE5SWJEc3g2VjNsYVZ0SFd3?=
 =?utf-8?B?YkhsbjY5TGNBbGhSeE5MaC9odkJFY3JxL0lXVFN6R1IzclkvbHIvY3R6T1o5?=
 =?utf-8?B?eElPK0xjbXZ0dXdFMmZ5dURwKzlneUF0QWFhdnp4a0NHR2pkS25GTnljWmta?=
 =?utf-8?B?cng3ODFJU3h2R1U2MUVXbkpSSy9ra1l5RHdLTnVjMFBpVnA0a1RiS0kyZTVx?=
 =?utf-8?B?RVVHQzlzYk9mZ0drNkptNElQbWExaVk0RWZOR2wzVkVMV3NzSG5CbldHa3hP?=
 =?utf-8?B?dkRoRG9HVmRZQnM4clBqQjJNQmF2UzJYM3RHSmRNSVJiWTBjZlJMOWhoZHBT?=
 =?utf-8?B?cnFJV04yVTB1MUJPd05MVU5mdDlld3NsZGp6bklIZ3NhcWJtbTA0QldYL1Fs?=
 =?utf-8?B?NFVlSllGTXUrQlN5Nk5YVkxwMFRjcVE2Vlc3RGRNc3JYSzZ3ZktaVC9nOEkw?=
 =?utf-8?B?VVdXWjZKdklTVDQ1a0pWbHVFMklJbkpVMUdYbW1KNVM3MVVhdjZPeEJ3Q05V?=
 =?utf-8?B?SGQ0eG8yL3pzRWZKRGd5NVNZUzZ5M2xhR2NzUVBYNlZoempIZHpoRHFoMmx0?=
 =?utf-8?B?REo5Nm1ldXVxRHpySllJNlNJNVc5eWhnNlRvOFZJb2tzYkZqdEIzWE4yYmpX?=
 =?utf-8?B?bUs5bXpRWUI1MUtWUUF0RHBiakEvZUNJUEFDOG1yU1RPNEVMcjBhOUdVNnEr?=
 =?utf-8?B?blpGVldmNVNTTFJobVV6UHdDeDNXWk5lMnJlUHBnYlN3TWJnN1EyRVp4YitR?=
 =?utf-8?B?MkthMEVDaDE0Q3ZzOU03azRJVHpZVTM4YlBqY0dua0pGVDlJOFJBMDUxNU12?=
 =?utf-8?B?d2dVaXJzYlBtQkg3M3RZV0ZMclArdVFGWDFZb1RXaktPSGRUeGVvb1dOQm9h?=
 =?utf-8?B?TXlwWkRkdzBXRjVqL0hhSGtBdWcwb1g1VmpZMzNmeWt6NndtSDJ6TGR5K2NQ?=
 =?utf-8?B?YWJJNVdSQWtxWGJGTVA1a3dhS2RQV1BBUDVnUnpvdXNsVzlhWjNWUVh5ZGlp?=
 =?utf-8?B?UWpTMGV5MVBTYlRNRE5xdzNUV3R6Y2tyVi9aNE5VV3lLZU1kajd3YlcyUkFh?=
 =?utf-8?B?WUNia2Rzd3k3Q2hCYkw2OVBuS3F1UjNpOU9ZQnlPc3hBcWJ5aVhCSzd5cEwr?=
 =?utf-8?B?a2RsbkY3Q1pvcTRiamJsVkc4cjBYN0l0MndpUzVoRXVQZ1FJMVdzQzBiSGZR?=
 =?utf-8?B?QVVycHgzaS8vbE5MQjVWQUxsa2RHeVZSdlBmbENsSVVGL2c2SSs4YTVla01C?=
 =?utf-8?B?VzhSRjhEMytVQS9Ya2JRRnRxcW1ieDJXZm1sT1JOVzkvdUUvejZ0eEFLcWhq?=
 =?utf-8?B?VzVWZWVRU0FIRlJUWGFuVHUrOGlwS2lVRXhtQkdqSmM3OURrUXNVYVpWZlJE?=
 =?utf-8?B?OHNKZW9tOEpxZy92WVVuQmVwT1d1R0ZnTWJXMVpySFB0K05sWG5oRC9lbnE1?=
 =?utf-8?B?TUJkbGI4MTFNcC83Q04xbkxaVjBWVWNqb21US3hUZllrTXQzMkdteElnMjE0?=
 =?utf-8?B?VXZjazNjMUc0RU5xRXRRUS96NW9NaVdkdWFkbkoxZWExQ3BuNjRNZ2I2elZC?=
 =?utf-8?B?VEg0R05FaXdCNzBqWTYzV09BZmFlNTJ2NUZaclliZTZCR1ZraEpYQXI5L3Rm?=
 =?utf-8?B?QTcwQ0ZpZGdDYVB3RHAvYTI2bXoybzJHQmJGbWhjZWtFNWYrL0NXTXd5Szg2?=
 =?utf-8?B?dE5YWjJ0bmtNenl5VGhYKzBZSWlDRnM5VHdlR2FsZCtvT0hGQ0plQU1SRllL?=
 =?utf-8?B?MEFRZmZURnJ5SDVXdk9EYWRvSkRHK1FIWUlyUERkdTNzMllxSmxqUEZzV2dy?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6550E2536C83E441812B5491AEF07D69@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ekCbtMCZUEJQca9kGh/ZmU4oAC85vT2Zef8/Yn5rusKQfKWznG4h/9igmiQ0/h3Bzpkg3hgMnD4ARL2f7x+5qyCPeYcOfHNZL2hRWHqarx7jRhLcUqczcJ0C2nXmEY1HT4Z9K3AunVCrROUIunypfgnLhUMzyQPfPvah8CJRUcygMJIAKNKL7H1BrD9VJyN72FgYsWWL/oO/82XD5geHoA+2lyPZQgFItHmnm/Fff8l0jxRKbuD18R5tUa2RlRdk55pHg2mbCYCsCxFydS7FcBcXCuESpKlFxlgrQOeFo/Cv7F0dtyuJu92jUEoW9bC1oLxH3LBi3y0AMBvmu/dWHofKL5h5UhQ2stFjaegXU6qMqsTjpMCnxqz3JjbcMunMlOMGbARy64XucUPT98WQEKi0rRzb2iTi0SA1Po/6cbm8yY6raNkrFubzK5Tfm/ikuuoKmEBGQC5Gfc/rXHl5FcW0g0PQalKg8oVQfy0yuHGQFl8OKfulzBosDwHW7sVpRm7MrGeCS9u7z4wzvedKJY0oy+HBoongq2fhJyHjhrwF0kZLuDdOo6wcyPIBNJkSMlpChPQV7hhTaUvRce4tLmDYTb0Wj0zB+O/OmUa4lReQlpyzVmXrXxZoqF0G/ZF+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f4ee76-1213-4e92-e72f-08de1aeea89d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 15:35:46.6327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SbMzo44P6jKFBbPeS9/GnY+MsplajG2ODBYw1lbnVROsSRPBASTT0dMtUwbVtkrHaA+TX4xUDWBVdOj5UD9BTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8527

T24gMDMvMTEvMjAyNSAxMToxNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IHhmc19zZWxl
Y3Rfb3Blbl96b25lX21ydSBuZWVkcyB0byBwYXNzIFhGU19aT05FX0FMTE9DX09LIHRvDQo+IHhm
c190cnlfdXNlX3pvbmUgYmVjYXVzZSB3ZSBvbmx5IHdhbnQgdG8gdGlnaHRseSBwYWNrIGludG8g
em9uZXMgb2YgdGhlDQo+IHNhbWUgb3IgYSBjb21wYXRpYmxlIHRlbXBlcmF0dXJlIGluc3RlYWQg
b2YgYW55IGF2YWlsYWJsZSB6b25lLg0KPiANCj4gVGhpcyBnb3QgYnJva2VuIGluIGNvbW1pdCAw
MzAxZGFlNzMyYTUgKCJ4ZnM6IHJlZmFjdG9yIGhpbnQgYmFzZWQgem9uZQ0KPiBhbGxvY2F0aW9u
IiksIHdoaWNoIGZhaWxlZCB0byB1cGRhdGUgdGhpcyBwYXJ0aWN1bGFyIGNhbGxlciB3aGVuDQo+
IHN3aXRjaGluZyB0byBhbiBlbnVtLiAgeGZzLzYzOCBzb21ldGltZXMsIGJ1dCBub3QgcmVsaWFi
bHkgZmFpbHMgZHVlIHRvDQo+IHRoaXMgY2hhbmdlLg0KPiANCj4gRml4ZXM6IDAzMDFkYWU3MzJh
NSAoInhmczogcmVmYWN0b3IgaGludCBiYXNlZCB6b25lIGFsbG9jYXRpb24iKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMv
eGZzX3pvbmVfYWxsb2MuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9hbGxv
Yy5jIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gaW5kZXggMzM2YzlmMTg0YTc1Li5mNWZm
YWM5ODE5YTYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+ICsrKyBi
L2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IEBAIC02MTUsNyArNjE1LDcgQEAgeGZzX3NlbGVj
dF9vcGVuX3pvbmVfbXJ1KA0KPiAgCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnppLT56aV9vcGVuX3pv
bmVzX2xvY2spOw0KPiAgDQo+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeV9yZXZlcnNlKG96LCAmemkt
PnppX29wZW5fem9uZXMsIG96X2VudHJ5KQ0KPiAtCQlpZiAoeGZzX3RyeV91c2Vfem9uZSh6aSwg
ZmlsZV9oaW50LCBveiwgZmFsc2UpKQ0KPiArCQlpZiAoeGZzX3RyeV91c2Vfem9uZSh6aSwgZmls
ZV9oaW50LCBveiwgWEZTX1pPTkVfQUxMT0NfT0spKQ0KPiAgCQkJcmV0dXJuIG96Ow0KPiAgDQo+
ICAJY29uZF9yZXNjaGVkX2xvY2soJnppLT56aV9vcGVuX3pvbmVzX2xvY2spOw0KDQoNCkxvb2tz
IGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5j
b20+DQoNCg==
