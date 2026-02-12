Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2382773E9;
	Thu, 12 Feb 2026 22:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770936829; cv=fail; b=sGSf0fd6aT3lEmBKMucNy+vZbM87B8CC1ECJ8P1qeq/E9PAPIBjg/m0xecAb+A+5r7qFVtEshay/yYlGOyT/zG2H37f1m9YIqa6e2YLaQA5CJDhrZ6ut5hzeb/Two1UuU+jCvUr69w96oRS9BU4rGXlo0dzPJUfNxTPr71FLOsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770936829; c=relaxed/simple;
	bh=kmPqi95jsWcE2pdyNraIhklJhxigwNvTLC9sZlVP0gM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D0Uw2/IDnlcKEzq76HRxsrwX7bH0ESY7fciA6Vx2h9OERF0S7sV5CSTByHbw94qSPKCENWJNQRwQCQaOTxj+Mq91TY+nA3AhqFdnSDoFFAHLLqmsnE8VNS4nwEsM9mAh2aRyI1J6oAovyEix+uiaDhbKjtE55sk8HeubReXASVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JpIY6Q7/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=u8DtqjKi; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JpIY6Q7/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u8DtqjKi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770936828; x=1802472828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kmPqi95jsWcE2pdyNraIhklJhxigwNvTLC9sZlVP0gM=;
  b=JpIY6Q7/jSCQmVaS9PWbG0txCEr3X7GEoo+gT7b9iWZy5i83neTYqRUG
   esV2tIYvKnpRUpWx6rplJmLwxP8YR5/rbRfH3B+5iSZrmX2qfUfZKgB/F
   ryho/7/abEGNFRGIqX/SN6lktQUq/L3RvE3qlsZdY9c+Ll2WeZbLMY3BK
   Z8lbNbUcqNF9raW5dTD3TqxXXQLIKWOc2+7KplintSfDJFIRsaL/37i+5
   Tj0K7NoEp3b2pa19HCprRG8b9asjaJKWywSPESrlcbOTVb9NupZcGy/MQ
   poXgQt2rvuJfn2Kl+lJkIEfyv3mCsPh6uUNPehsbMHIKsTQizfQrqrz5r
   w==;
X-CSE-ConnectionGUID: IjWdyVvFSKiSJxSFmh5ISg==
X-CSE-MsgGUID: Jqv3Y7twQxWxxBEDKmhCcw==
X-IronPort-AV: E=Sophos;i="6.21,287,1763395200"; 
   d="scan'208";a="139773181"
Received: from mail-eastusazon11012023.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.23])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2026 06:53:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rW1+nzcGV3i4rGqmNj/GX0nvrbul38+BzJvYwY+RTuQXi0ygKZ0NBTYiHFoeIRf3XtvCKAjbdnKbuazPF2uXUuo+Xx6AaRLjkeBWNgFPkw+Whof0zMVMp7dAS2UmAtO+Qgvi9qrTr3ZJnfzKFdgG7rkvh3r7ZRXvjNCjLMoLBTopmqq1jPprhSSoWzXHBKf78a5U4Ah7O768Dx2LCxy02QT+6mkci6HbnleXorU5lBaDf2OjMGc4Bw65TQp6EcEXD1EXECJrs0Ol7ZUoZNw6h5xXrbZVDMtPRRTB0O4IMFw+0q43Du0n7e++Nua64vdzxFQOuyaAcXAMwbKDEHReSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmPqi95jsWcE2pdyNraIhklJhxigwNvTLC9sZlVP0gM=;
 b=sAF5O8uomqyff3d2qThhJakeRoAa2pqwnFTwlAvx2L+cUSFlpxVHktBMphrPdRBPLId4JQc3mjQPqbb0X+6VvYW+3qCMO6CxFcsGgj0NvLjLfMjU4jhryIobVQOL1cA9Eqx6Qy6ogijfGcy0469p/eR0BvjMzswTrbJ+jnEF1NWFj2JO3Fq0PZl1nBzM1d/vdFJb4wr2Mx2OoqYJiEz8lAplYIvGvrebYjN672gd2HzwUYRrXyL/PA7N48nMs7otOoZmPNSvgjZ+SQmlDulQglq+yWTRmMnp1XMUPkqTe2MGliV74lAV3dgfvQ9cNw1Kw4+sO276p+AC2zXbukFGeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmPqi95jsWcE2pdyNraIhklJhxigwNvTLC9sZlVP0gM=;
 b=u8DtqjKiAM3NyPaX65nJLaALBb4q1himwTfp6/HLMVr1mlrYH1i/ph2EiCvYbDREIaTyRMT3gGAaG9AchB+BOJ8VafnqsalmJKo6FBEIS8WJCXeNJhUL9qlX31QVsbcpG6NDetf9zSbq4AL/8uMQ7unFaTLWXAZPS5zTYYklNIA=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by SN7PR04MB8693.namprd04.prod.outlook.com (2603:10b6:806:2de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 22:53:44 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 22:53:44 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: hch <hch@lst.de>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: fixup some alignment issues in xfs_ondisk.c
Thread-Topic: [PATCH] xfs: fixup some alignment issues in xfs_ondisk.c
Thread-Index: AQHcm8QHqqxnroG58EqfEyy3HZ5GY7V+2UgAgADUD4A=
Date: Thu, 12 Feb 2026 22:53:44 +0000
Message-ID: <1f4b9236fd742eab160a7d5b00b423b484ee1556.camel@wdc.com>
References: <20260212020437.259170-2-wilfred.opensource@gmail.com>
	 <20260212101444.GA8615@lst.de>
In-Reply-To: <20260212101444.GA8615@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|SN7PR04MB8693:EE_
x-ms-office365-filtering-correlation-id: 27c71362-a834-4823-331a-08de6a89931e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WmYwajlTcVZFdHJCRVhWbUdTRVlqNDV0S3dpNThUK1VlM3BxRDJscXpab0FF?=
 =?utf-8?B?bUk2b2dVNmhxTHU4ZzFSTVFsdVcxZGFVVmovOVZ2dVhMSGNLYVVHRDVHVjE1?=
 =?utf-8?B?MmZEWFVIZ05meXozK09YTlNoUndid05zbFNScjBhTDJzanlETnFYdzRzNEcy?=
 =?utf-8?B?SkpHQVlzV2NUZjFpWXV3Znk1eXZBWXF1eW5QdE9EODR5eExsbHZGSXJSQzV6?=
 =?utf-8?B?dkdIaDhDdWIrK3p3aGxiMmxoU0NMK29UV1c4MkNUK3NORnc4bkpkREJiUlFS?=
 =?utf-8?B?SEJDOFU0WUFNMHFIN0UyUUdTQSs4MjN5LytmUG5ibXFYRlJJTFkvQVR4ZUx2?=
 =?utf-8?B?MjlyWkthRXY1WVNydmdoVGNSNElvMTBUcElkQnEwWmtDa3QzZzAybnhkOG9O?=
 =?utf-8?B?aDl5ZUEwSHg0OG1EWEJmNi8yTzd6TjZUNzJQcjhEaURtMi9KWjJKNDl4cDhS?=
 =?utf-8?B?T3R1WElxWTFRb3FaOVJJdnR3VmtwcXNZcFZuOVVDU1JVWW0rRnN3d1IrZ3BC?=
 =?utf-8?B?NHA2blNwWDc5VUdPS3IxSVJlbjM4a0d3TTNuS0FNN1pEM0NzZHhOb21EZEhX?=
 =?utf-8?B?NDZJRVhJc3FIN1JpQTYxTGcrTlF2bE5kaVEwekNMd2NaS1dDR094SjB6UDcw?=
 =?utf-8?B?MStCWDE1b01VaTNmM2c5NDFzSmQ4V1JGbldORWxWeDR2eWkwOUlaRVJEWlVq?=
 =?utf-8?B?NXQyc3dkQ3NJZzVlRzhaS2ZmUnEwdkxCSTd2ZXlqeXlYV1cwVnJ1Y0lRMGlu?=
 =?utf-8?B?blhmZlQySU9EeUtlQmpjVm9YcEozNHg3VWkya3gvMWNyelVnSjYxQ2RMblNT?=
 =?utf-8?B?L1RzQlE0M3hMUmVzWkxlekhUR3MzMGozalM3ZGpHZzY0cFpLaUlheUNLVXN6?=
 =?utf-8?B?Z0hvQXhhMGFwb1ZWOEpBalNJMEEvTm92VVZ3U3loUGlYRElkNitTNm5NSmNx?=
 =?utf-8?B?YmJRMVFycThiQ25la0dLY0QvbmtHUjdiV0pGTGQ0YStVUmR1bGx0dFNjci9H?=
 =?utf-8?B?WFFrdW5xU1dsM29wZVhKVFNjeUZZY2pZUENNankwL2RjZ3BBV0RxYVFtdkhM?=
 =?utf-8?B?NnF3SmJMb3hGMlh5OEZJYldYVEl1bTJZR21OVUxJNU1DYS9MZFFNVm12REph?=
 =?utf-8?B?RUNiYXlYMUZpTmhydlJRUkhncWtZUDN0WFFaUjVORzUrZW5qaTd3SjVRZ2pk?=
 =?utf-8?B?N0p6ODMrMmlyM2JZMGlub21JQVcyZEtYblJCZkIrTkZmbS9XOXJGeHdsKzJE?=
 =?utf-8?B?SDNtNkNBWTdySFpaYW5TZ3lrTzJxc3FwemZUV1JwZnZ5ZmQ1MmxTTjVOTmUy?=
 =?utf-8?B?VzBKRkJCYkpiNksxZTcwSTRDamJTajdaK2JYMlZZUEExSkxuVlJCWWV5ajFy?=
 =?utf-8?B?R2ZWdFcvdlErRk5vaGI1YUIvNjN0RENrMGRmLzhES3ptZXNaU2Zjek1XN2wx?=
 =?utf-8?B?VnhqRUwrY2NFUnZBR2tIMnBSRkdVb2xwOUJYZ1BwWGczWnZJSXZTcWVQczRE?=
 =?utf-8?B?NGx1dThwK1JzQ2F3bG8rdGdFOUloWkNFWWdCUUl6RVhIVXkxbFNoRk1oSHlF?=
 =?utf-8?B?U3pRbzVWNHdWSE9MQ0RXMFdhcFZLZXFaUFMxTDlSRUtXM2lLZW84WUNwRG1k?=
 =?utf-8?B?aGYzM0JPTEtRTGFiOXpzalFNOXo5MHY0cm1TeXQ1cXdsRUVOeTRvdVNsdGlm?=
 =?utf-8?B?MFJNbnN5OEhsNDF3REIvTHVpT2dMNjc1QXA4c09FOFdOVU5YeXFWSm8rR3Yr?=
 =?utf-8?B?RVVOaVdKOEJuOWRIci9JR2I2RFBxWXRKb0JzZFlxb0o0c0owWFdBTjRIN2Vq?=
 =?utf-8?B?WC9MMUZ3T1BpREFnV3pjNjMwZHVrTUpSS1JLcnlReDFxQUhMcjZsN1YzVWZV?=
 =?utf-8?B?bjlkMjg5RWI0SDZXdVk0eS9CMFZCSkdNc04zRzNKbkg2am92YnNLWE5rMzBI?=
 =?utf-8?B?ZDNHUnJSVVdRZSs2N2pPMml1UDRsN21xNHBvOXcyNVJCT0t5UGwwT1YwYnp3?=
 =?utf-8?B?UFVDLytvYU5OTjNEQ0J1Y3BBWWpUM2pkWU5yaUhzNkV0NUJETWtoMHFjQjJ0?=
 =?utf-8?B?eXNVaHovU0FPNmJCNWQ5bXNXdXcrdGxUTVdYTTNHNjVWMjFoUzlzMjk1bERY?=
 =?utf-8?B?cEsxd3orZnhGRS9IbXhDSGRTMU9Yb1NiWksydElSN0VmTnA1aHBFVjFLODhq?=
 =?utf-8?Q?TVUk4zYQoPMnr4s7R0fHIbk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUExS2Y5OWhiWU5GV1JOZmszaS9UU1pJWkpEV2dQbHFEWDhpQTNZVmtjaXRI?=
 =?utf-8?B?M3RJcDN0MDlia1VqUlpSVE16UE5rUDBGL1ptRkdyWXA2cXpyNEJXRDllb1lh?=
 =?utf-8?B?eXoydXZkR3RmMVVxOG5LcitnRjBtNXRPVWRFSmcxZmxWeHhETlYwSTN1bUha?=
 =?utf-8?B?S0NTY2pRUDBla3ovMmloZU8yaVppQTR3WFpoSnFjUnRBWlpyTldjVmVpNkZK?=
 =?utf-8?B?Yld6SG9sRVRvdGRmR2lyeWVHMzE4VUJMWGcreUM0R3I4VUVlUTFwdnltRUcx?=
 =?utf-8?B?c2VBNTErVlBBVnhIczRtSHVIVzNVNzVYM1JkdEdneTYyWXM5a2pkUHZKVmJu?=
 =?utf-8?B?TkNhbmU1WllFVWdvWVdQZ014aHZwNGVUdmtVeHZ1VnF2alA4WlNtZmFXRTFL?=
 =?utf-8?B?VXo5bjQ1ZlRrSVc2N3BYVmZQSnkvUHYyV3ZYMDFVNTRLNWhSTTJVaTRYV3ZJ?=
 =?utf-8?B?U2pERnVhTFljY2xYYUJnNjhKVm93TzllRnk2Q2YzSHd3M1gwamxYNjl0bE5W?=
 =?utf-8?B?MGRsT09rdlFSMHJLcGtqeGNFT1dUUnZjOE5zUjRURnF0MzRPQ29ydFRJV0R5?=
 =?utf-8?B?Zk1Sd0dDSWIrUGs4ZFh6S0xleWRQRXZNQmN4UlR4WXBsazkrM0VxYklKbCtS?=
 =?utf-8?B?cVVmT1Foc0x2WGF2dmpiUHlQWGtYdmVWS2VHRVNSMVZtLzViSjF2RHdWajAr?=
 =?utf-8?B?aCtjNWR2alczVmV5bkRET2RXaStRRjFidCtzV2dnUURhVFhvWVFmUmdnSGJm?=
 =?utf-8?B?QXVXdEs5d1hBUWJzbWxDTWprMGdsS2RTU2hKcTNnUGxUSnp1aDh1S2VUbjBR?=
 =?utf-8?B?SUFoOHdycjJJbHR3Zyt0a2l4aFN4VjV6VTUyQmpXeW1vdVBTaGt2QjVsMEg2?=
 =?utf-8?B?OERPL0J2MGhxNmdrQit0cnZRVUNMNS9rYVBHVk4rRHZ2cnh6d1JjcGVMMVRa?=
 =?utf-8?B?b281SFF3UlZ4VWZjdmlDM1V5TFR4MTcwTzBaNWFoclpNNlpMeGliU1NrNVNF?=
 =?utf-8?B?Ukh4VjJlN3hSQ3A3TmM2Um8rcUV6aWwyL1RNdTFoT09yWkEwZkp3Qm5lMy8x?=
 =?utf-8?B?eXR2Uis5bC8vd0VSUHVtN1JHa3Rha1ZlSjdPb1pkK2RqTEJLV01yaFN1Slor?=
 =?utf-8?B?Ulc3MjE5cElOeTgrR0VPU3ZBOEtZNHhDa0w5eFNhYjNkd3pIQ3lJRkpQaXc0?=
 =?utf-8?B?NkY4VVNTMEhiWmg0VVVZcko4ZEhmL1Bsby8rdStqNHJNZlFpTFdZUDNzakQv?=
 =?utf-8?B?L2gxZG1jeFJscm5IdGRNdFdhQ3FKZlpOU3orYUhMSmxSUmFqNEhoMmRQZ2ln?=
 =?utf-8?B?Zm9DYjA4UnRER0RMa2UzeTNIeWY3VnE4UGRNdVAwTVIxdzZYSE5rbkVUa3d0?=
 =?utf-8?B?NnFJSVhWSUIzK0lDMDhCYzZDOC9VbzliYmtUZC9CZkxvSGdibTNuU1FUOVpU?=
 =?utf-8?B?Uld6aStBK0FBTlpxQVZONEMzSDFqS0dIaVU3dmVIbk5yQ25hSUpMVjVoVEJS?=
 =?utf-8?B?bkd1dGkwUTR4aVJWQzdCWHlxNHF3Q2ZyRENRRm5VelV0bEtLcVlTd3lYNkw0?=
 =?utf-8?B?ZzYyY1Fzb2ZxNUdMWnBEYWExc0tVdWp2VWE1YmMvcHpCeDA1Qlg2UjR0Vzkw?=
 =?utf-8?B?SlppQ3dsSVN0MVZaM0F5QVJVY3ZXMSsxaTV3T0gyYnlOYkt3b3hCeW4wbktO?=
 =?utf-8?B?dFNEc3lZcXVhZDMycFo2ay9CRmErWXBvWDFUQ3U3VWZ2MXRwd2Qra0hPOHFs?=
 =?utf-8?B?RCt1VDJEZXNqWEpXRTB3cG1pNGUzeHJxZXgrQkxkcE04TmxHc3VjaEd1OGY0?=
 =?utf-8?B?RTlPU1RYOTIvb3UxRG1VVFMvRmYycytLZUJYYzM0L2o4SVZZMDIrdVdremxI?=
 =?utf-8?B?NGZBYkZqMXg0aHFnTkx3S2htbjdZMyt4WmJlY0hIeEx2SytWTFhQbkxuMmxa?=
 =?utf-8?B?eGpqdzdLNWYzeUg4RFlpdFVMamo4ckNmRXJyb2hCa1cvbS9rdkJBQVd6YXps?=
 =?utf-8?B?amd1dEppUFlnZDJXY2FyTjJ0SEg3Kzc3Rm1TdUVyWnorOXgwZWZwMm5TcHVp?=
 =?utf-8?B?UG9FNER4cEIxMzU2MDlldU1hc25CeUZZbUFUendXckhoZFRhRmUzMXhacVNo?=
 =?utf-8?B?Vkk3aytIQXlqVXU3MHl1RzU0MnJpRmJrYVBITXhtRVZOSElaZXlCZ1BZMHMy?=
 =?utf-8?B?azJFK0N6V1ROSUl4YVpIOVJCSURtQ0lad3lhQ1kvWHEzMmRCdEVGNjJMZWsy?=
 =?utf-8?B?bVI5K0szLzdUSzhDNE15WS9yVml1YnRwc1V2SW1JTWhpV3o4bUhmRGF2YjVm?=
 =?utf-8?B?WjlKbWNIdkNpVFlISld4TThRT0lHb2F4STRXZGpkVit5UjZTSXJ1Q3RmcldU?=
 =?utf-8?Q?I5EbfHA/j9uDJNKs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2A3EEFE9250D74ABCCE54E39BC4E2CD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9+nbOz/DrlSeSTAK01ljRlJy/oSoqDoezEH0ZFSdyuOoeoQM7Sh4RKRaQu4HMYP6VB4pd7jzfiyaR+Oc5BB2689fFhF1vdPMlc/RmVHZNfTyPvxplMWkEvSnHKMwtuBKITKdGGJttNW3uuW5mkmIUyO7pmq5P8xUzraKZGaKNDhwSEwrxNGOE8PRc+CYudPHe/zykA1yKSpYWyhLNkOcsPxt9W2Yo0QQFY+Vebg3EdbdcfMKNAfF1g7Wu544EV7Fmgq9e+QmklE4EzuE0srd3f2Vnz/DxyXcJP7LNl4L009sNiLZamlnQqTjxQDlIKCHGYAZxzC3fUMDm9X7tSrP4jrqLa97++kIlf6SgSeVxgh8pJnWZk31PuL2Qx24mTRsKxXOjv5zBHSvGp+R8xgP+xeb7G1E6BXl9YQbCfVYx+KVnv2q4HhViEDbgMOClAY7gCbYtLeFp0ZEuZmFkUViIeFwVZfBlEUXjv+MCBfPcRstZY3eT/RlW7/J0l+CcVuTKo2HB08K1XpW6IpwjgqsY/HYtrvuAx1Cue94AJmM2ej2w5NPDJLGPYGNRtXU9D5HXx5e3Tb2nStpsZNjTtP9kOlrqbZXrDARWaR8N+QrnoSchapR6ZeWHr/X0dMzETJH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c71362-a834-4823-331a-08de6a89931e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2026 22:53:44.4260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HcXCTYO2pFTzLZz5LeOwZeUp1sw8Gb/JSKqCklDPY8lr2135Is0UdgtjAAsnTEY0OR8W+CNu0vl6HZFUhTou1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8693

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDExOjE0ICswMTAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gVGh1LCBGZWIgMTIsIDIwMjYgYXQgMTI6MDQ6MzhQTSArMTAwMCwgV2lsZnJlZCBN
YWxsYXdhIHdyb3RlOg0KPiA+IEZyb206IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdh
QHdkYy5jb20+DQo+ID4gDQo+ID4gRml4dXAgc29tZSBjb2RlIGFsaWdubWVudCBpc3N1ZXMgaW4g
eGZzX29uZGlzay5jDQo+IA0KPiBUaGF0IGNvZGUgc2hvdWxkIHByb2JhYmx5IGdvIGludG8gdGhl
IHN1YmplY3QgYXMgd2VsbCwgYXMgdGhhdA0KPiBpbml0aWFsbHkgbWFkZSBtZSB0aGluayBvZiBk
YXRhIHN0cnVjdHVyZSBvciBsb2FkL3N0b3JlIGFsaWdubWVudC4NCj4gDQoNCkFoIGdvb2QgcG9p
bnQsIEkndmUgZml4ZWQgdGhpcyBpbiBWMi4gVGhhbmtzIQ0KDQpXaWxmcmVkDQoNCg==
