Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D61519B4;
	Fri, 21 Nov 2025 06:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763707626; cv=fail; b=KSIgZB9XNGLtytnnXw8fv56BHQtVZqteNZ61Wdx4HP3LZFHw4Tw/WdgJ/3tsUJqMpJLjyl8sykyRQds4+JP1S7/IcXrmDVWeLGNdW3o0C2dsRM31Pcx3hh/4dHxrivRhqdxv4c0dm38b0E2cU3Z+dzR6IyHbXHCP8xfnZRSZRdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763707626; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=km065RB/VYMDXJaBEe56W6OGKMAO3pjwpyCF0vd6Mlc8BLn45r6SEDnaqUd4PbOssMJb4c7d15Z9vg34S0YC6BCk6x4YDbVojEkq/cpKPrU+nxy1Tu/MxQzeoRqQnTNW6T2ugeCFOswJkkYfZ1gk5EdrkpbkBRQkeRp8ZxuU/sA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=G+t0AiZE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BBuLrZ78; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G+t0AiZE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BBuLrZ78"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763707624; x=1795243624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=G+t0AiZE/gs5vaUoOLfazHJXO+GGezMh29dNTLgbZ5YzDshSpSAd0tSI
   Iz5eDNBCKqFbBGqyV9QyWKn5YKjZarKCElkUIatwex+VmMrXYRTAB1W0A
   4ndeNaqZIJ1Fkv3wYUjosZcDLJdjAd5xc0hL3UVp5uAxSSxpM3TTYGtHV
   CTgcT5vEJIpUKEG4V5s+Jh89T1QirUMRPRpQSgDLAwui2rVcQM55IZ54E
   y6HhGTuXSfEbelzcYfNHO53EESxQNlykib+erDoMIjBJq3KXSWNjsEiAK
   bWWmQAaSRQqC/HyU7ZEA5sDe+tNA0WDnl36MAIV1tN91JfaQ0yc2zpZc6
   Q==;
X-CSE-ConnectionGUID: a8dPp2J7RzS0i3+rbdMr8w==
X-CSE-MsgGUID: +GCag0clRhmUtWGnPibx8Q==
X-IronPort-AV: E=Sophos;i="6.20,215,1758556800"; 
   d="scan'208";a="135135227"
Received: from mail-westcentralusazon11013068.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.68])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2025 14:46:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fOSJwjHG4zShMdXPsICPigdTfuEtztqfNISYpfcHurR3GKvrzjTL5hKryIwLzIIhTYKJzTJlxT00p36PY4f9iJNMBpp5fsiTCBUECINHfqefjmlq+kWyA5yY3whxGYu1b/zQGqrMg9o62g600uWFQk7kYL+iaEcMGHnyICZHKSjWimY7oWAEQX7cD5weukBUvSt07ERuwih2X0PKQg9bnlYqWPLRBTP+pJZETg/dWwlL2zIi15MrZJH4iBLxN6nmjT/Sm6uTbuA677e3GF6N7ZR/xGYnNUa/1SRqSeslVNmmmmoBjU0YLwjg/f6qHxx9qN8NrKdoY+mlYysQsUpo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=mNgg609i00i0qpC+ePcNRkdej0mR+l5EL/Dzh/bW39C4cK83X9BaI+1XnkaDsJ6EfPTJeW/DQwTMvo6FzO8DbTn4YbBPePmHOu8ihYpdVF2nMBHivioMZ+b45l5OqKVDtj2PvKPeCWJ6eeIRlGLaY5eLo3B3PtxuKemovku/FUzxjjPFRwCW1oyipIWkARTWxy/aLS2X8wFXyw6UeB3M/A9cdLGyUTPR4FHfhT0eAZRirxAwTDE0opKw/2e1uT33kzW/nDrwAjwco55nOjh0w8qvCKKc1F/MH/O7+JuQT//Hzr6XxvHphi5riZeF2/4Yj2liYq+XWVISgEhFm4WeXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=BBuLrZ78nCSchOWs5W6DZE1SN6m3RBy/PY3SbJ90e/0W2ce7DybzLKTP+Y2pCCvGtmzU3OqRLYviOgB7Uyiy2D55agAGhVmKzPyrNjgCnB+Opl7FYdrJU7YFvUS9oA50dw/6mZX50Mf8bDfG6irx+TjlLwDl1uxYZKbnu+N6uNY=
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com (2603:10b6:610:d8::5)
 by DS1PR04MB9276.namprd04.prod.outlook.com (2603:10b6:8:1ed::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 06:46:54 +0000
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71]) by CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 06:46:54 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>, "zlang@kernel.org" <zlang@kernel.org>
CC: hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] common/zoned: enable passing a custom capacity
Thread-Topic: [PATCH 1/2] common/zoned: enable passing a custom capacity
Thread-Index: AQHcWjgOhPQrKasulEWu7LU9Zuqy1LT8sM4A
Date: Fri, 21 Nov 2025 06:46:54 +0000
Message-ID: <0a92b636-8be3-4392-8a68-7b0503d151ed@wdc.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-2-cem@kernel.org>
In-Reply-To: <20251120160901.63810-2-cem@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0SPR01MB0001:EE_|DS1PR04MB9276:EE_
x-ms-office365-filtering-correlation-id: 0161a88f-df2c-4ae4-41ce-08de28c9c214
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QkVmVkZsUmdyK2p5TEVzTnJONkMzalhTQ3RhNkZtVDkwcUU5NnVVQkhvb0w1?=
 =?utf-8?B?QzBici82TVhGT1BIOWJPWkR4eXMvR3haa3lzZXRVTmk3K3VFTzNucTdMOHBu?=
 =?utf-8?B?NVFBWWVsdlIwdE4vYld4bzZSalZhMEU4ZGpHTWNLQ0o3SFlDUWpuVjBRTXpB?=
 =?utf-8?B?MGplb0JTdnE5SGsrNVlKQWFKK200UzBIcUtsTDlDV2lWRkFwR3ozbEk0Tjl4?=
 =?utf-8?B?Qk9BVHdWcVd4RFJmbG1WK1ZFNVVMSjVkbzg4cVN3bGFJRjRQTjYrbm82eDF0?=
 =?utf-8?B?Wmx3Rk9CSnBINUdsNGpOWUJ1Z3lYMlBXRjNTaU5BWm93RkFrNW9rVGhqRkRT?=
 =?utf-8?B?dy85NTFjQWxLdTR0UjhiQkNYakFYR1lEZ0d0REtZU3d6aisrdjd2UFVMQnRI?=
 =?utf-8?B?RUUrYm9CeXVZYkpmTmNOVFB2VE43UG5wQkxBbFdhUUlnWVFKdm9DaXpkVG4v?=
 =?utf-8?B?T0VXb3VrTnpsYnQzYk0xb3RmL1JKMjJCb2xMTlI3bWxmYnNSR0k2ZURvVXBT?=
 =?utf-8?B?UXVMQmdoeGZYaytGRVd5TUN4SUV6U3lFUWFnYWRpVnY1SVZJd2RkOHhLV2hB?=
 =?utf-8?B?L0x2SHhaZ25rRk02U3FTTkV3NWlrZDZVMC9uTFF5ZFpKdnJGQVE2elUzZ0o1?=
 =?utf-8?B?b0kxMjR6eG0xMXlwYjJDU0pNVHRlSUlHOGlxeE1NeE0zMHdBbmdGd0RwWGdq?=
 =?utf-8?B?VWtoTXA0cUdvVjRpaGhCeGlqVGNiV1Q0Yi9ZSmJva0VTVnhHYkt1cnBBb2d6?=
 =?utf-8?B?REJRVWZxZzlOMGFmcmtFL2t6M1BiT0J4dlVjaHNCNktWT3NzRW9CalU0d2tM?=
 =?utf-8?B?NjMybFdLT3BpdHRuY1UwQWZsUXk3Sk1pTVdqalRlUTIrNHVRL0xxNW1DbHNz?=
 =?utf-8?B?N2hYK0d4RnpKUVdzZWtGM1JLajhKMkFjWjhLMXViajNrakFqcjBVOEU2TXR3?=
 =?utf-8?B?R3l6TGJUejlJcUN5cCtyZG92bnFmMTB0cGdCUE1MNjNTd28xSFRwZTNISi9F?=
 =?utf-8?B?L2hPVjVNbnRTelB6UmdxT1RKQmNPTmV5UkRkcEFTLzVCOC82V1ZmUnMwWVYy?=
 =?utf-8?B?U2VxVUcwSGZjcTBDV1cveG93S0o4RS9NUUphS2h4QXpXdXUxSmdHWUpJWXA1?=
 =?utf-8?B?UjV2Mk1TNSs3dHFQN0dhcTNIUUFVaXdRNXBIZlVtaWttdWxCMWUrWFVLWmov?=
 =?utf-8?B?R0pxWUxVUmcxNXByVThsR0hmRHhBTnBZSERuRkhMVlkvN1cwTnptdm9IS3Bm?=
 =?utf-8?B?TDlvMnFXbURHTTNVYUNYNFdiZjdTczMwWU5xaTdKL1VrdnE3N01pYVBXdjhT?=
 =?utf-8?B?RHpXNjMzN0g2K1U1eXNPeUhtWGx1Y2NiZVhUMmdpalVKQ3BnclpxYU5WSlcr?=
 =?utf-8?B?a0haMDB2eDlJcDNaYUUrZ2dlU2RaT0xHcEM2d1RsLzJTWTV2UzkrV0hpMlhB?=
 =?utf-8?B?cnFIZGxaOFpaYjVLc0Z2bFBJcmxVVk1IRERkMEREWkE3R0NGWVh4RStsTU00?=
 =?utf-8?B?aXlDMFc2OUV2S1lmclVWeFYwQjlHSmlncDdLeFZQUWEwTjBmaklQSGFDSnMw?=
 =?utf-8?B?bjFKMjR2UENnMTZhMkNVUjY2RG9nU1Z1NHRrYVBWbGJRWnliUE4rSWFjaWRv?=
 =?utf-8?B?SkNLODlxTVZKOTgyVVNoWnRTaVVtS2d1MmxzKzlOQU1HMS8vdVJvckhmelFP?=
 =?utf-8?B?QmV6c0EyWlJOVGhYK0Q4VHhSbW8zT2Z1TVJBTm5ITjVjWng2UGlIZGpXUDFK?=
 =?utf-8?B?UW9INXZ1UjJqM2Ixd3hWYjdaQnB2Y3QxMVhDZFhUSk1QQjNaTmlUT200TnBO?=
 =?utf-8?B?R3JKbVdnRUZBbGhWVTlISTB0eFI4UXR6blJER0ZtaXhUZDFIQS9nd3NVYlBI?=
 =?utf-8?B?b2dncGJoaXM1TGVGdmpjS1VNaVc0MnJLZU5YcVpXWjBxSUhacUNidStvUktY?=
 =?utf-8?B?aUV2VGl0UGRlb3VoeFVWNlJuRzlmYTEzR0tBT3dxSERnL0xyek5zRXNmcnkz?=
 =?utf-8?B?U3dBVUlDZWtjeDdvU1F6bDU1Smh1UXdCNkFDL0ZtQVR4aThGSWh0d2VmQXhn?=
 =?utf-8?Q?bVcWgf?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0SPR01MB0001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXFOWXppK2RFRXJyUXVHbkIwYlByak13Sk9wdzQ1N1JlczI5NTVxTVQxbkQw?=
 =?utf-8?B?a1ZnUkYya2svd0VRaVg0V2VsNUZUL2hhVlR6a0o3YUE1U3lmMHE4a2FJTFgx?=
 =?utf-8?B?Rm5aSVlMQlFGa1ZYNzREcGdWUSs1bktXK0ExWnQxYk1QbkI5bDB5YUxSYW5C?=
 =?utf-8?B?TVdnSTNNek5xMVZaWmF3aE4rc1h1Zmk2R3dFTmhpRHI2eFJobEJISGxrMTVU?=
 =?utf-8?B?VjMyR0N5NVRYNmhPWTcyVU04QlNiQnJCN1JlYjRaN3VzbERYQmdNVVlTcEth?=
 =?utf-8?B?aHVkdVF0d2t3SnlOMFcxcDRjMGl5UTBFTWNTVExoNlNDTnlZUi8wN0RVeVU0?=
 =?utf-8?B?aHBPeEZ6V0pZcWs0ZmI3SS9ZUlAvNzBNeUJrMDBQWHBUVnJodVBpUzNGK2Vj?=
 =?utf-8?B?SW5wSmYyaG93NGZWdEptTTNJNklHWGFDOTlxeHhDZ2NQRk1hWGNuOFF1ZnFx?=
 =?utf-8?B?ZGtDOUc2MVN4Y3ZpSTVjMHVwWWN4RElCVnlqUEpDeVdtYmZBS3BRTjI2bUVs?=
 =?utf-8?B?azB5LzY2Yy9TVy9DRXVwUWVoR0pZc0lYUnFCZ2hhMmRGVFdXQnlBQ3JKVDFR?=
 =?utf-8?B?ZGN6MWxjSnlGa0Fwb0prUndmQVprb2RJV0svR1NRNUpqeFJLTTB1M2NNcjF4?=
 =?utf-8?B?M09BTDA3VHU4N08yRW02V2l3U1Brcmc0UnZ5R0lYa0dNQlBxVlo0Q0twTnNt?=
 =?utf-8?B?N2FkQ09OeVVaVmY1WkdNT3JEVjhQQlNOUE1rYzB1VkJidDdIRkNtQ0orcC8y?=
 =?utf-8?B?dENFa09OY01CS3hXT2J4TGtRRW1QNFNBVDZyZHJrbk9TVHlUbFUxYkZtWnM4?=
 =?utf-8?B?Tk5lOWgvOEM4NFJOSk5JYkJidUpjLzBuS0x5aW9NTGlJbXlKTk9UcXByZVBJ?=
 =?utf-8?B?U0dUMDNibnB0ZE9QUjBRR1k3Sml3ay8zU2tGVXU1ZzFocmRMUnRaNTlXVjR5?=
 =?utf-8?B?MHVMdDhJR1NCQktXQjQ4K0o0M3EzbitKMXVZU0FESXlUdmdWMjlwZmg4dm9W?=
 =?utf-8?B?YmhDR1BPZmY1ZldKOHVRczRwSjd4OE1Nc2ppTzhjSWlaMTdxajVnRDNzK0gr?=
 =?utf-8?B?NmNSb1FadjMydk1PN0NxUDFnV1JOaS9ISUpySkZpOHhraG1pSVIzc1ZrTU5v?=
 =?utf-8?B?TGczcUxvYjczQklTWWpZQStUdDgzMVRubzJYNGVqdzA2TnZEV292VCsvN1I3?=
 =?utf-8?B?Mjc3TnVOWS9HRDR5cjZvQ2lOSDYyYjJkckpqYWxSbGMrVklVYVNmcmt1VWla?=
 =?utf-8?B?TmJaQVl1UU5FNDBtVzNwZlBMbVlwUi9nUEI2SEg4VzVIZE92N0dnN2Z4MENY?=
 =?utf-8?B?M09jUlRlNkdDLy9XMjduLzdXQmNHK1EzY1Vpa0M4TWc1dllLUEs1eU1IR3h1?=
 =?utf-8?B?SXJ0eDB3OEF4UUZzMWc2dTl5R2dJZGhPZ0l4NWw0SklsWWt3ZXZLWHkrYjFE?=
 =?utf-8?B?YmFtaFNZbDJLYUZ6d25RK2w1bDB3R2lybk42N1RXYk5GeHI1MHlSdVRlSnZS?=
 =?utf-8?B?SUV3R3JjTVFnRXZWRVhxVHNKTGIzd0ZzUE01SW11TWtKQ2ZiSXpaWWJwUmNN?=
 =?utf-8?B?QXZ5Y291cVNxMXRnQlh6aHRsYmVuWDIvTDRZSUNnY1dqQWN5U3V0bTFtd2pa?=
 =?utf-8?B?UnRVaUhrdUVwZ0tLUTdOQTBFczVyTU0zZVJROGFiOXVFaHJXVzRrdUdCV0hQ?=
 =?utf-8?B?MDMzUTc2ZDRpTXI2Z3dlMndleTdRYytuMDVjMHc0RmJ6dnNkNjBQdTVzcVgr?=
 =?utf-8?B?VnNINmxKL0g5cXBIbTlaYmFQU2NZb3ZvNWFBSzBRSzBjMHRYdkNtUUVQODBV?=
 =?utf-8?B?UWtMSWcvWjFOQjlvaEJWbGRydUUyV1FuazJKbWoyRDkrSUkxUHQyR3dZaFRL?=
 =?utf-8?B?ZWkrQjlBQlFCTGxVSnYxZlBKSHVVMVIzZ2xBOXlISWVEU3NWOXZJdDJHajkx?=
 =?utf-8?B?M25KeERtTkFKWEVRWERLcXA3WERnTkdMRHJpMFdWdUhybGdnRlJPSDZLOGNl?=
 =?utf-8?B?VE9DSDNiL0JvRTkrQjRzVzQybjdDUnIzSGdHRElCTzBsd0tacmZ1OUpKaDhR?=
 =?utf-8?B?a2YwNlIxeGtyRDlvVmRFdlpqZVFLSnEyZnlZby9mb2hCMFlCdjdKeGY5Z0I0?=
 =?utf-8?B?VUx5NnhEVnh5bzY4WkhYanI0TTBRZmF2eU5DL0h2SjdYQjJvOFlpT1dtcDV1?=
 =?utf-8?B?SS9ibHN2eTBSV1lPZ0IzbDJYUkxMTk1wK1g0azloaEY3YzJnckhzL0plZDBw?=
 =?utf-8?B?VFhSS0VOSWVoRkVwZ0ZrV1BJWHRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB978A148929EB4D9735D45E049E8E37@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+N9IBi/r4faCCD2XeIc1fBF00qr8VA1pAkq5vf7VSoiBW88ZKP3yCcA+r3fgd4p4Fdbd5mRLaNua3r55NhVqOqn1fy4Q+A127lLtZG68hWipRTRxcpgQoS/P34WvIidBRtEVpF7OzsqoxZXvsRHHga+BmxqMfCarV9fNETi6mDYr4JjtjwjMosJ2IWrRXSmSFI35xUjNWNfE5E9WNka5/wkHaiPO8gBxj+RW+Ogx1B6mvcUdvwum/LfsUu+lR84yPndbCX8YXh1HH7XElsboFDqTSkn4ZMga5Ht7NZ8dMyoMQqZjGRHkVeckM4TIHdmiiBlWWY8V83/pgTYtvPZxGaPb8gbwzN33nJM7iV2VP/aHUvDGvc3hEHRNwIUEiU+O/uJ4r0mflsVxJidCLiIoUqzgYO9ROsCnm4wCvmdxf28lejfIrQpLMDQEBG78Dwesp9OcKA03XSiN1st18AAI0j93Ow5hlZBtPyzsUw84VJMm4KbeiyVUfFT/j5PxeLA5FMlgh+c95nyK8Vqba41A3J7oX++agqnAsfYQ7C6vQ9JbKJ/22k/gn0MGPWTEsyL/HlT2iuhKiiHu3qVBOjzuH51/Plu7HW9QeeHAxCmB4u+eX7JJI/3I4ZM778M3uv3U
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0SPR01MB0001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0161a88f-df2c-4ae4-41ce-08de28c9c214
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 06:46:54.2418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wGoRdF/ASD8+e19BRRQpuCe+zH4nKoF0m88BVPC5i+utxRrESrWSvuZ0H/ybmOq7kyjamyQ1qBvqem+MmptIq9X6gQTlXHkJ7VotgZatRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9276

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
