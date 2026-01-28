Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287720125F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601707; cv=fail; b=cAj6S9xsJUszkYBEIsQwNhf8NnxCjzYVzCRPgYF7j2IyrE8ZwxDQbxHsk+zjcoRoQIjWKwKxVpgOE7eAXt9YR0aQ43BraKAIvXDRUG46WqeD1gmj/vIP0CWG5lLr2xBFaLtD/83bl1JW5ytMFRj3wy7kK2C0Jpc9Kx25MOGEBmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601707; c=relaxed/simple;
	bh=4wdgNaHQAf74tQK2sn7hs7Mz1fTrHMgP7mz8x/NmYac=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NCd4b9GNSdHg4pQK9WPdrdqJEt7mys6TGA4z0aL3dM/ETHlphD9LXjwN33mR3sm7PrjMyIfezRzMiPRUCfrYq4VI7nT9Q1un7GGtUfcMYdTPFCAIfnL1s485++ik3nHA/euFZoPZsL1tZC6txdD4FeZmqE4Xiz/3TQa5EoDWsng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DYiN0TM6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fe+YvfFS; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DYiN0TM6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fe+YvfFS"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769601706; x=1801137706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4wdgNaHQAf74tQK2sn7hs7Mz1fTrHMgP7mz8x/NmYac=;
  b=DYiN0TM6zNpYVUf6fV9bHku5gAobnTPxMulOVtPDOPLX2XLf1RX7YKzJ
   2SYn5PRbCODnywM5mfpBAOwTCWui7IWUSjxulIbYzi5uVyjAldMy024eQ
   d3tE1dRxYDboA2NhGqbplSAE2yZmD4IHi8c49Eniwm7wRlsAAENI2Eeb2
   CCXru5Y0HHWro/CQhqNjvQgiNcolzASBDP20K5MkBIJQYonQJhpS+GXmz
   AaeVAUVTNJdSnBK2IBXo6hSc0eLqhhx9blE3ZivBHwLaJb3ceZ8f+18aq
   vJs96E+r/L2zsdoYqEGTnHdRt+S++XahTgNYMvTrJ3s7xFZkKE+xkG2KZ
   A==;
X-CSE-ConnectionGUID: P2z2q1y1Q9GC5U9i2mtNNw==
X-CSE-MsgGUID: FiFs9A5MQFinpCzj8myw/g==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140286168"
Received: from mail-westcentralusazon11010012.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.12])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:01:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ocP4sJmf73Xx5N3u8Zk40zbN3ZvhnmHUCQgxCdX/jMuwX2M8/0D/k1HGW7dR5TRlPfPOLfBgys98EaSlaHsYm/LXwH7Dc1i4YMN3rsSKGM10y2ZjfnbzWD5xD9FbcKk9pgjQ57pY5P1oSWfQM+deMnEg2dFWJ89VnBw1PJAU9bSydwGveLWWoFSN4nT5Pnn8p6z2j79yf21jmAFBUuu8go11Bn/gxfaBOE5wIqXWqzu4IIMqo+cgy+02m4xdNGHo/6/x6rXOAG693vhNLAnm0L8PKsk03+2jeGe9zKmohiHLnv123tGRsfxyKKmYgy+7Njii6KFrbVgtGwgWTT+I7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wdgNaHQAf74tQK2sn7hs7Mz1fTrHMgP7mz8x/NmYac=;
 b=RRQBWgmu/Hz6DqM1laQsvpmiW1j/W3OuFkUpAj7cz90GH0MmXJbu9dDV4gOypCVB4RCRvwkb0pFkvm+TfIuYQ9QRRnHoI94QDMMx40CAUejHk/ZhvDrbLpK18ElDCHpj6M1amom+kSY5pHkkezzGIYK/CYCzvis0x4wunfEscFBSS+aLDR8aYDwmVap9nOG36z+OAopAaCkYyhYUKwgZMt1Q+Sejmyl+39PJ+RUDKR/86/J/q73ZSil2M6sJov+hqLzHN/gX9M2iJlHghaRmSbudxXxrgQZ1XTirhz9xWjI5XGDnfAaNyRjZqClQfwKtiGkGXLeADJMR7rdrmz2mRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wdgNaHQAf74tQK2sn7hs7Mz1fTrHMgP7mz8x/NmYac=;
 b=fe+YvfFSnwNI4De4xYxNXeynfX/KBY6E/twHif69Z6sv5MK9g+jPubxbkU97a/YoIBujDwmwA7pWmFemr6BM3VtBKYG+MNE3p8/huaqjzrbmudXpMbVrD+Mgexm6/BzkCZhj6FMrJKLuMDRs41qrZ2unSXSrI24Ln/vHpc9Z1OM=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6985.namprd04.prod.outlook.com (2603:10b6:5:244::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 12:00:28 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:00:28 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Chris Mason <clm@meta.com>, Keith
 Busch <kbusch@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe in
 the GC scatch buffer
Thread-Topic: [PATCH 1/2] xfs: use a seprate member to track space availabe in
 the GC scatch buffer
Thread-Index: AQHcj58dkazwFss5/km9vc9U0/ti4LVnfCQA
Date: Wed, 28 Jan 2026 12:00:28 +0000
Message-ID: <5a3e9d6c-b4f6-481a-bdab-8f9d32f2d0cd@wdc.com>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-2-hch@lst.de>
In-Reply-To: <20260127151026.299341-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6985:EE_
x-ms-office365-filtering-correlation-id: cbf76513-ef28-4fcc-394d-08de5e64d452
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?b1dQQ2VCQndBVVdxUEJldnVsKytwdGVLOHZQOG9LVmJVUFhQYVM5Sjl4eTZD?=
 =?utf-8?B?bUUzbXZLWU5TaGdJODFVVzdHRjduQmJBSk1VWVlZYjQyK3kvQXZxMk5oWFhO?=
 =?utf-8?B?dEgvSzEwNWY1TVJ4Z09NMjdRa2lzaWhaU2dLS2x6U3kyU0tVNGZGWWJ5RHpO?=
 =?utf-8?B?aEI2RUVoS0tpTFlXaXBhMWllRURGbXlzR1hzLy9OemY2N2VsQU1MazI0TWxt?=
 =?utf-8?B?Zmsvekc1T1lORU9KK3AzZkxLSVBBU05CS1lWZWhXby9VUllxYlRoWlRPQmcr?=
 =?utf-8?B?bFVWTXdJcXVkZFBROVB0UzBlQXBXNitac1hXTEt4R21hQXA2MnNPRG02TmRQ?=
 =?utf-8?B?endYT0pqTGtocFovM1djUGVWMWxOT05Rc1ljVkczQWtDcDEzaEFpaTBLTUg0?=
 =?utf-8?B?U1lyNnpOSDMxendpUWVRZ3dGdUtLMnZYSTNpOHpiSlFJbk1vS3BEbXZxT0cz?=
 =?utf-8?B?aElHMWUrUmw5aS9oMHBiblErK01pUHpOM3l5Q1FRUWFNQk9vSUgwTGs0T2Ir?=
 =?utf-8?B?MXRoS1JHNlorQ2hESWFydUhUdDNEbmFkd080RGMxV0VRSXlnWHBYWFQ1Z0c0?=
 =?utf-8?B?NnI5Mm02TDRoOEVsR2pDWVNxY0J3aTBTaTcyZWZvQnpLaEZFUTRjb3Jjclhn?=
 =?utf-8?B?bDVuSHpPMXZhelhFOEVSR0JzN3NyRXRZQ3Y2bTIwQkJhRUp4dHl0b0xBRzlK?=
 =?utf-8?B?SzJHMlJGdlVKdGROemhPcTV1U2hMRSs1VTg3dithSnRzci81eDc4cDhVTlFQ?=
 =?utf-8?B?Tks4b2ZkMlVWMFlGZUNEWUtRRWZBcC9LMHJpY2d3c2plY2Y4TlVCYmFQNGE0?=
 =?utf-8?B?SGs1YW5McTd0ZDd3TDNyUDgwd01QVkQ5WU1Lb3FDajVyNDFqTnBTaEgvWkI3?=
 =?utf-8?B?Zm8yOW1RejI4dXh2Tks0RmNDcjZhWTRidzYxdlVKdXRoVlptcTdOUlVaVTJ4?=
 =?utf-8?B?S3k5cHdwdy96MXVCTjZPSDR4WEhvcnJwOXp3MGZWakRLc3NYQTc0ZDlpQUpw?=
 =?utf-8?B?SXV6UmZuQzlxZVd2c0EzWjVMRCsxQ2NQbldzYVErNmNHUEg3VC9yKzZBTncr?=
 =?utf-8?B?QlJjanl3WW51L0crcStVQnQ4QzNVQWFmczNpaUg4M3oxUjhqVVVWZTZJV1NL?=
 =?utf-8?B?MjdTV2NVZmtTUmREVHhnRSt0SlZxODVtWkYvQUc4V0VFRTVyc0lza0oxYTd1?=
 =?utf-8?B?bkdDYTlPTWd3SXp5REpJbVpqMlR3eUNPRGlkeVh0NXk3TDc0M1BkdWRVSzFm?=
 =?utf-8?B?TWhWaTJ4WitQc0h4aWExZzhnN1FxbDlnQ2oxd25ETnU2OU9DL3NUbCtCaFNM?=
 =?utf-8?B?L3RlVmpCekxuRmo0bEJLVkVMd21SWTQxaFNpc1dIQkV6dWoyWXVmWlhac0FB?=
 =?utf-8?B?Q2lJQjNmQ2JBMGdGUkRiOTNVRC9WRmYzeVpLYzBtdkRzdm5STzFCN1dBaDhQ?=
 =?utf-8?B?cFpTR3ZuTWZHNGgzbVQ2RkRkSkE4NDFtL1Z4b3NBTkRxUHNYaExyZGxXOXpi?=
 =?utf-8?B?Z0lMdkh3SDAyR0Ntb2JIM2hHUFVuRFdmMDgxUGNHS1pVT0gvU0tRRDh0QUJT?=
 =?utf-8?B?T0xVTEZPWGJiaVhQQUNuTkdiN3JaamdpKytEc2psbEdURGpQODcvNFkxSDZV?=
 =?utf-8?B?Z2hzOHJid2tZWHhva1BoMjE0SENIYjdOTHVKL1JjYTBjd014T0RmZlBPSUVE?=
 =?utf-8?B?T2ozM2FnUkFIdk5TdFJSaG5IODFmeTA3UlVtN0Mxa0xMNytoZFJnUHE2WGhT?=
 =?utf-8?B?SktXazFGWXpjV0pNYlAzNDNJeTArYjdNb284NDZxY1BkcVM1dnMxTWFKb2FM?=
 =?utf-8?B?ZE5xRWpqN0szM0tWMVJ1d0dhTjRSbk5wMERLM0owTTNWNGVjN2IyYUtReFd0?=
 =?utf-8?B?cmVvVEJRTUNtbC8rNTFZNEtJYzc0VmxtVmlsYmU0TGYrMUNJWEtQdVVXTGNn?=
 =?utf-8?B?WG01T1ZSWVVOa2t3WlVVNDBNQjl0elpxeXJQNXE2Z2ViN1E3L3NGTkRLSzZP?=
 =?utf-8?B?ckhDUUpZRTE3bXdGamI2QkVDUzlOdnlGUXp1dk15aDlSRWxsMWZqWnhuNm1r?=
 =?utf-8?B?Ulo5NTRPeXVNL1I4UUVITnZRNEhEK3YyZktyVjJZUGlZdkx5N0hMMHpZeDVS?=
 =?utf-8?B?clRPUElaWDkxYjNLdENZUFY5VTVwNGltYUM0WWNxRHoxODB2azZNT3lYM0wz?=
 =?utf-8?Q?pAxtb/FzxjHAE/Bxo3qF/HE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cGtBMTgwc0hSWVVUK3ZGdCtsamZha3Yva3NCeDViTVh6MmdwQVYvdzA3ckgx?=
 =?utf-8?B?N0h0QjJGOFdGUzlnT2FveUhDZ0ZHNmpuUTRyZmNnUC8xY0czdHZzR0RDQTF0?=
 =?utf-8?B?K29MVTVzZi9NYXNuZUZjQWNzdWJCVkNVSHNRQ2VsbTBubDllbENuZjRvd1J2?=
 =?utf-8?B?eHlQRk9UZEhON2tzRnpVVXgvK2lmd3VYVXFvOEp1djF1TVJVckd2Wmdxcklo?=
 =?utf-8?B?MlB0N3dYWUZVaUpjRVAvZ1hWb0txMUhCem5oQUVhMjRGeHZQV0l4M2E4Z3Zr?=
 =?utf-8?B?UHBCMThhdU42WDFGKytPSm82NHpHbldRRmJmTlVhSzdsazJJaGQwQkFCdUFi?=
 =?utf-8?B?UGxjNUVwNU55MWhZVzNVYUFXRTJLSFVocVJsOE1seERsalROK0ZUdTJVSXdE?=
 =?utf-8?B?MUgwNGNJc0NpWlJpZkJNWlFieUdVbUdtaWZVZDBRYk8wOVVrWnZBa1R6NkM0?=
 =?utf-8?B?cWxtVXFmTHc3Q3VaOFhqamNwQXZKd25rSW0xR3BOTklXd3dRcWtsbGVCRmZh?=
 =?utf-8?B?NG1sdkxnbVZoY0FTRUhGdm9wanJUeGhmZUVaRDZYcTJiK3kyYjc0eEltb0Rw?=
 =?utf-8?B?SGlXbjhJSlFKd3NVd0g1SjZaMGdHbjVabHJObndXVk9ZZ3lXSk1zczFUaVAw?=
 =?utf-8?B?b2ExSER6WHVKZExuV0orY2F1SHJGb0ZNdnNoVnZoSlZwdTM0ZE16RFdaMExN?=
 =?utf-8?B?bE90VHlLY05mOU5SQmRyVFo1MCtCZTVEcTkzb2ZFV1A2M2todTMxQzJoT0Jk?=
 =?utf-8?B?UVZNeHB5bmtnRUd1RFBzTzNtYTVHNUVHaXpEOWUxVWErMEc3OTJKTVI2MXNY?=
 =?utf-8?B?NEdIQzRrVmFXQ3dPYWpNRENkUUFOV1lNRzFnVTNndzJZQ1E0eWo4dFZaS3Vp?=
 =?utf-8?B?cWJtM2dRaFY5eExjMVVXMGZKeGc0b3JQam9uRU9HeEc3MnRKNlpnZ2M5ZlhJ?=
 =?utf-8?B?Z3hXZHpGQ3lDNk10TkQ4ME9USDhvbFpkanBoRS9jaDJ5VkQ3MGtmYmd1eER4?=
 =?utf-8?B?TXFaZmkzbjlkUW1waERHN1h4ZGlpZXF5UC9McEV4b3c4TUlPT2ZjdzhzRG01?=
 =?utf-8?B?N1BKZkFTNkxBNFRPOEp4UUFPRGY3SXlSSDRiNHJ3VURTQk9MZGJRN1VmZ3Jh?=
 =?utf-8?B?bDE2Z2dQZUxNWTg0dHJydW5KK3U3RXprSytUWWd3eS9jZ3BMTmVta2crMVlL?=
 =?utf-8?B?ZnBLK1BWWGRLZnNhVGdsaGtFUWxudFJlb0hGMkRoVG1nQWJySnBlMVJIZUQ3?=
 =?utf-8?B?b3NFTFVGM2o5VGtrZ2VrSnZ2UWZVamlVYVVJOFUrbjVNRllKalgrMkgrY2Zs?=
 =?utf-8?B?VzMrVUhMWFNJZytGSU5ZSk91WTJnaEZLaTgxOTZRRTNuSW9BQ21iVGh4YnpF?=
 =?utf-8?B?eitzbDI5UDBFZnFzelAxcjA5bUNkTHBsWVNELzQzME5ObW1RQTlzMlNZb0xV?=
 =?utf-8?B?ZjRkaUlQbmJ2YVZaZ0ZqZVF3UTdvWnZ2eWcySExLSUFXc2gwK1dJdlZEeEEr?=
 =?utf-8?B?Nk9DNG9LRElxZEJTRyt5S2s1dkUwQVQ3cGtFMjdIS01KNlhJZ3lDQjNYZ1Bm?=
 =?utf-8?B?UnM0RG80bTN6MUdXQ2NxRFJNSitUS3JXNjlQdEt5VENpb2d3WkpuQ0RSSzVk?=
 =?utf-8?B?bS8xUEYyR2ZEOWQyc0N2OTNSanpWcGNtTGFBU3lObXZpbHJCTlF5T3oxbDU1?=
 =?utf-8?B?ZlJUeDdFL2ZTbitRVUVGT2pkYzhKRHA3U1VHNEpIOFVUeWcwbkY4NTMwZW5D?=
 =?utf-8?B?djUrZEhIdjlNU2wzbS9DRFc1RXVMQzFOOVlZZFJ4akNpdFZ1cUJ5UnlJdE9x?=
 =?utf-8?B?NDJBL0NBMFJXMHNwK0NwQmRCOWlTTEVZNVA2N0s0SXpCQXR4K2owb1EwRkg3?=
 =?utf-8?B?UjI2L2VBekV5S0hCTm1xd1FZS0tDZFNqbDQ2NW9URnFxblZ4ZjRqa0Q5ODJS?=
 =?utf-8?B?UVl3anpIK1YvNFZZV2tHeXFWL05Ya0UzZVVTL1RSZTlUQ2srY1NhcXEyRWVI?=
 =?utf-8?B?cnorN3ptMnZ6QW05QU11RnYwQzNReEhXRFlIUGNUbGFlckRnVFJubGc3UGNr?=
 =?utf-8?B?RDhoNmVWSGpjTWx0WFJTTGFuYXdTR2VVRllWeWlxMTBrWEVUV3d4dzRJcnk4?=
 =?utf-8?B?enVkNVpueVVBR0x5Y1NZM0x6NnFRWkZ2dXZBSVNvVGpSMGtuODBhZUVtSzRa?=
 =?utf-8?B?QytlWnBQU3B0anBuRGxzc0V1Nm1JVDFncnYvbGJ1Q3Zha2lVL3k2NStINnNs?=
 =?utf-8?B?UFkrQm1uRkZtckF4RmkxZnJaMUlyQ1o2UWZnK1g1RURtdkJiSmdiaCs0Y3JQ?=
 =?utf-8?B?LzFXWUMrcG1lbmFSMTZobEh0MytLcjNNNjJWdHMvR3l0Smd4QjRFZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E303DEC61D6EC34B976F03B16205AD95@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ftT6HCywwNGGFo/Hmo8lNDMdSeKQvHNX7bIPmhOpUu0D4eYawjT4iiDMkg3NXruC7VKIkcdTADxRwhqbbmMzE96XQuXkLAPahxbpa/1QcZE8IE2W7hRk108QDZgKC3U6HHmKfJ+5SHa2PmA5at55qltLkZBBF1spq1vsCUsDx2VRXofKDUBQ4R2vaN+eILPzgKGfp+BPj/7vyCNslkDlh96b9We9/XRFOY5/2VnyOgGTKhVs5zH0CLSXQE32BZFtUyEQLOJeGgeQYv9+vrnSL6HHDBNDkG6Pu8E4QL4Z1hI7J+4EE1t5DDdMXBjO1xpa0dOnk6HRwXbmEKsiCPzWHaw1XDOqvAAMBHfZlnLlhKNKgtABchwq5pv/4hYRaJ8nH5WvvuTa2H0J9qcUte3i1eeAJFKsJzcAq1pPQLge9cBGCDGwADHpTMckha/2tC0WWq5R6ShPY3q0r1h4+v+XXOEsfO2rkiZmP5j8rKwZR19aQsPX3TkCKAwOEaN299tmjrmbgxW/NQa2wYNansX5/+qIxG3Nncto7yAGUCCu55gIBpu8jrIXjQ4CU9QExj1ZRGDp0VNsRQEunFpmY3haLCF1fK6rcd0Cw9Lb1xInKnXiMxVMENOVA2zPZSQx3K1w
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf76513-ef28-4fcc-394d-08de5e64d452
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:00:28.4191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ln2ctxdJwlocCycUHYsPibVCT4uEFvhB6w9U4yWBflWX1hyJAQLag2Qn10OSyhYr8W4pRJgcT+ppzAweHNrV9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6985

T24gMjcvMDEvMjAyNiAxNjoxMCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdoZW4gc2Ny
YXRjaF9oZWFkIHdyYXBzIGJhY2sgdG8gMCBhbmQgc2NyYXRjaF90YWlsIGlzIGFsc28gMCBiZWNh
dXNlIG5vDQo+IEkvTyBoYXMgY29tcGxldGVkIHlldCwgdGhlIHJpbmcgYnVmZmVyIGNvdWxkIGJl
IG1pc3Rha2VuIGZvciBlbXB0eS4NCj4gDQo+IEZpeCB0aGlzIGJ5IGludHJvZHVjaW5nIGEgc2Vw
YXJhdGUgc2NyYXRjaF9hdmFpbGFibGUgbWVtYmVyIGluDQo+IHN0cnVjdCB4ZnNfem9uZV9nY19k
YXRhLiAgVGhpcyBhY3R1YWxseSBlbmRzIHVwIHNpbXBsaWZ5aW5nIHRoZSBjb2RlIGFzDQo+IHdl
bGwuDQo+IA0KPiBSZXBvcnRlZC1ieTogQ2hyaXMgTWFzb24gPGNsbUBtZXRhLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMv
eGZzL3hmc196b25lX2djLmMgfCAyNSArKysrKysrKystLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9mcy94ZnMveGZzX3pvbmVfZ2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGlu
ZGV4IGRmYTY2NTMyMTBjNy4uOGMwOGU1NTE5YmZmIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X3pvbmVfZ2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBAQCAtMTMxLDEwICsx
MzEsMTMgQEAgc3RydWN0IHhmc196b25lX2djX2RhdGEgew0KPiAgCS8qDQo+ICAJICogU2NyYXRj
aHBhZCB0byBidWZmZXIgR0MgZGF0YSwgb3JnYW5pemVkIGFzIGEgcmluZyBidWZmZXIgb3Zlcg0K
PiAgCSAqIGRpc2NvbnRpZ3VvdXMgZm9saW9zLiAgc2NyYXRjaF9oZWFkIGlzIHdoZXJlIHRoZSBi
dWZmZXIgaXMgZmlsbGVkLA0KPiAtCSAqIGFuZCBzY3JhdGNoX3RhaWwgdHJhY2tzIHRoZSBidWZm
ZXIgc3BhY2UgZnJlZWQuDQo+ICsJICogc2NyYXRjaF90YWlsIHRyYWNrcyB0aGUgYnVmZmVyIHNw
YWNlIGZyZWVkLCBhbmQgc2NyYXRjaF9hdmFpbGFibGUNCj4gKwkgKiBjb3VudHMgdGhlIHNwYWNl
IGF2YWlsYWJsZSBpbiB0aGUgcmluZyBidWZmZXIgYmV0d2VlbiB0aGUgaGVhZCBhbmQNCj4gKwkg
KiB0aGUgdGFpbC4NCj4gIAkgKi8NCj4gIAlzdHJ1Y3QgZm9saW8JCQkqc2NyYXRjaF9mb2xpb3Nb
WEZTX0dDX05SX0JVRlNdOw0KPiAgCXVuc2lnbmVkIGludAkJCXNjcmF0Y2hfc2l6ZTsNCj4gKwl1
bnNpZ25lZCBpbnQJCQlzY3JhdGNoX2F2YWlsYWJsZTsNCj4gIAl1bnNpZ25lZCBpbnQJCQlzY3Jh
dGNoX2hlYWQ7DQo+ICAJdW5zaWduZWQgaW50CQkJc2NyYXRjaF90YWlsOw0KPiAgDQo+IEBAIC0y
MTIsNiArMjE1LDcgQEAgeGZzX3pvbmVfZ2NfZGF0YV9hbGxvYygNCj4gIAkJCWdvdG8gb3V0X2Zy
ZWVfc2NyYXRjaDsNCj4gIAl9DQo+ICAJZGF0YS0+c2NyYXRjaF9zaXplID0gWEZTX0dDX0JVRl9T
SVpFICogWEZTX0dDX05SX0JVRlM7DQo+ICsJZGF0YS0+c2NyYXRjaF9hdmFpbGFibGUgPSBkYXRh
LT5zY3JhdGNoX3NpemU7DQo+ICAJSU5JVF9MSVNUX0hFQUQoJmRhdGEtPnJlYWRpbmcpOw0KPiAg
CUlOSVRfTElTVF9IRUFEKCZkYXRhLT53cml0aW5nKTsNCj4gIAlJTklUX0xJU1RfSEVBRCgmZGF0
YS0+cmVzZXR0aW5nKTsNCj4gQEAgLTU3NCwxOCArNTc4LDYgQEAgeGZzX3pvbmVfZ2NfZW5zdXJl
X3RhcmdldCgNCj4gIAlyZXR1cm4gb3o7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyB1bnNpZ25lZCBp
bnQNCj4gLXhmc196b25lX2djX3NjcmF0Y2hfYXZhaWxhYmxlKA0KPiAtCXN0cnVjdCB4ZnNfem9u
ZV9nY19kYXRhCSpkYXRhKQ0KPiAtew0KPiAtCWlmICghZGF0YS0+c2NyYXRjaF90YWlsKQ0KPiAt
CQlyZXR1cm4gZGF0YS0+c2NyYXRjaF9zaXplIC0gZGF0YS0+c2NyYXRjaF9oZWFkOw0KPiAtDQo+
IC0JaWYgKCFkYXRhLT5zY3JhdGNoX2hlYWQpDQo+IC0JCXJldHVybiBkYXRhLT5zY3JhdGNoX3Rh
aWw7DQo+IC0JcmV0dXJuIChkYXRhLT5zY3JhdGNoX3NpemUgLSBkYXRhLT5zY3JhdGNoX2hlYWQp
ICsgZGF0YS0+c2NyYXRjaF90YWlsOw0KPiAtfQ0KPiAtDQo+ICBzdGF0aWMgYm9vbA0KPiAgeGZz
X3pvbmVfZ2Nfc3BhY2VfYXZhaWxhYmxlKA0KPiAgCXN0cnVjdCB4ZnNfem9uZV9nY19kYXRhCSpk
YXRhKQ0KPiBAQCAtNTk2LDcgKzU4OCw3IEBAIHhmc196b25lX2djX3NwYWNlX2F2YWlsYWJsZSgN
Cj4gIAlpZiAoIW96KQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICAJcmV0dXJuIG96LT5vel9hbGxv
Y2F0ZWQgPCBydGdfYmxvY2tzKG96LT5vel9ydGcpICYmDQo+IC0JCXhmc196b25lX2djX3NjcmF0
Y2hfYXZhaWxhYmxlKGRhdGEpOw0KPiArCQlkYXRhLT5zY3JhdGNoX2F2YWlsYWJsZTsNCj4gIH0N
Cj4gIA0KPiAgc3RhdGljIHZvaWQNCj4gQEAgLTYyNSw4ICs2MTcsNyBAQCB4ZnNfem9uZV9nY19h
bGxvY19ibG9ja3MoDQo+ICAJaWYgKCFveikNCj4gIAkJcmV0dXJuIE5VTEw7DQo+ICANCj4gLQkq
Y291bnRfZnNiID0gbWluKCpjb3VudF9mc2IsDQo+IC0JCVhGU19CX1RPX0ZTQihtcCwgeGZzX3pv
bmVfZ2Nfc2NyYXRjaF9hdmFpbGFibGUoZGF0YSkpKTsNCj4gKwkqY291bnRfZnNiID0gbWluKCpj
b3VudF9mc2IsIFhGU19CX1RPX0ZTQihtcCwgZGF0YS0+c2NyYXRjaF9hdmFpbGFibGUpKTsNCj4g
IA0KPiAgCS8qDQo+ICAJICogRGlyZWN0bHkgYWxsb2NhdGUgR0MgYmxvY2tzIGZyb20gdGhlIHJl
c2VydmVkIHBvb2wuDQo+IEBAIC03MzAsNiArNzIxLDcgQEAgeGZzX3pvbmVfZ2Nfc3RhcnRfY2h1
bmsoDQo+ICAJYmlvLT5iaV9lbmRfaW8gPSB4ZnNfem9uZV9nY19lbmRfaW87DQo+ICAJeGZzX3pv
bmVfZ2NfYWRkX2RhdGEoY2h1bmspOw0KPiAgCWRhdGEtPnNjcmF0Y2hfaGVhZCA9IChkYXRhLT5z
Y3JhdGNoX2hlYWQgKyBsZW4pICUgZGF0YS0+c2NyYXRjaF9zaXplOw0KPiArCWRhdGEtPnNjcmF0
Y2hfYXZhaWxhYmxlIC09IGxlbjsNCj4gIA0KPiAgCVdSSVRFX09OQ0UoY2h1bmstPnN0YXRlLCBY
RlNfR0NfQklPX05FVyk7DQo+ICAJbGlzdF9hZGRfdGFpbCgmY2h1bmstPmVudHJ5LCAmZGF0YS0+
cmVhZGluZyk7DQo+IEBAIC04NjIsNiArODU0LDcgQEAgeGZzX3pvbmVfZ2NfZmluaXNoX2NodW5r
KA0KPiAgDQo+ICAJZGF0YS0+c2NyYXRjaF90YWlsID0NCj4gIAkJKGRhdGEtPnNjcmF0Y2hfdGFp
bCArIGNodW5rLT5sZW4pICUgZGF0YS0+c2NyYXRjaF9zaXplOw0KPiArCWRhdGEtPnNjcmF0Y2hf
YXZhaWxhYmxlICs9IGNodW5rLT5sZW47DQo+ICANCj4gIAkvKg0KPiAgCSAqIEN5Y2xlIHRocm91
Z2ggdGhlIGlvbG9jayBhbmQgd2FpdCBmb3IgZGlyZWN0IEkvTyBhbmQgbGF5b3V0cyB0bw0KDQpO
aWNlIQ0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29t
Pg0K
