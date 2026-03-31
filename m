Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EB03C0630
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 07:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942453; cv=fail; b=NEboCkwSX2RdgNRGIfbJv/eCW0iR4EYFIkc1RZ6uHVCi5aEZBRrFyEsiq7P9G+IgKeK0433+IjRhEvL1EbWuwiN39nadruXYRySNI43JuRx81MxbpfwznoX+rO+a/WTvWMX4OygA0q9H5iQSOjJGNSPsrf2LBzqQuRZeYu65vRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942453; c=relaxed/simple;
	bh=ZmW0HXD+sNKryGzhXaM8zWdbn1tD5BL7wyi63vm8wuw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EP6PTo3bHUmMIORn+LLp6xez/bz5W+IRutXQQ5rrCOswKjlpwx4NUTridAD0dJzHACKUGgszeIv4zfhgLD6H5eM0Qg0+3aJs7y0uon2VKOiqRORa37x/8J3cA+aB24GEJdUdlGXHtLZNtyW7A9afryV2bTT9vAv3d/aq9Kv6zmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=f6dgOWf/; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RuPkLLZa; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="f6dgOWf/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RuPkLLZa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774942452; x=1806478452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZmW0HXD+sNKryGzhXaM8zWdbn1tD5BL7wyi63vm8wuw=;
  b=f6dgOWf/MATozVuUxlkU0lSZe08iw5DB6kGiyQEp0H/CCQrXaHFuL70W
   Q9LLmkSrZJIpcqA/cXr+CC6U51dqMXKUWn7f7CBt0fA4Ez6HZCAW6fkpZ
   T778QJRoFeu5mp9u48XCOOhgyUu3GkOPbKYSNo/n8LjAaPm6nvSd9uPSq
   PxTw2G0cLcuTS+dYrMSF/lMj30+gflFPlVlKP8bgCgfQM2A8UbT5jhONm
   WKq/T8C6mZrUPMHqMHUWclWIaBCDoTFLOLmtC3sbCpbxWlhlSdg78E4vu
   k2i2stAox0vxC3ZwuuwJhjqSxY74eztdE18T1Fh3VAuWEvXGUTyMjek2L
   g==;
X-CSE-ConnectionGUID: a8ISJDb1TH24Qj6TRGy8Ig==
X-CSE-MsgGUID: x6wP3YyGRrOtiz+ebcSG+w==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="139884188"
Received: from mail-northcentralusazon11012056.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 15:34:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cVIBKKp2/GCZKdb7MUTPHzuPD7zMGrYjVMTMJlrzn5p0DFqsPyyjTFpz7yNqc9NkitETXfN/BzEF/bKAsIIsvooJehbwOJf4IMm+xxoaTG6vh3dSQtiz26R26J84W7CqeQy2+6Pd6PBQgzq2YYYEtyb8Mt/Xoaz1Gy79l+gWyLq7asEv64TNyNpxRGOHUSwb9Gv7OR/uXrxqYxpFzVyAKPyhZN9yTE+eFFXeaS5znSVuAun4Iui3xdrTjvuvY7vPXopzZDwNim3Ufi8ZDyYG/crxMF1M/OJy0CyPd859uKkHnufQifwKgHPkarurpC5IxN6saunHGm/lS6SAXmYxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmW0HXD+sNKryGzhXaM8zWdbn1tD5BL7wyi63vm8wuw=;
 b=HcMGWvMJ8H1NMG6GrK8+Fs2TVnU87VduwySaTIjdA4446OdYy86hzsvAjBW6Y9ytWcxLJiM7dv9BwkJlmGUvMfayTA7yXZcwG+M7RdOyMOZ4s+mag9VUUejl7RhH793ibxt5ZMUBqR6i7zNt91M1ljnBUynsOjgIg3eN1Hy8ps2AFnUsC2XSC1vgtco0PJbThNv5SMfQCXHdLsNfYlZ5elIZ9ZZP7tRcX65RktvtULqsreIFxdVKzC75eGxTfKeTTC8R/VnIUut3wae7cy10u0QWNhU8qeHeo4aYSpKg4zbd3LKJQYqa4ITbnNXYxgLemUUmTI0yD9pqRueavlYMMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmW0HXD+sNKryGzhXaM8zWdbn1tD5BL7wyi63vm8wuw=;
 b=RuPkLLZaUP2QX9TimnvuVf9PSbJUd0ixok6XFRp6GsDYONbcbW3HwaZBMZZapnFqLouJ0X6EAXmOepk1wayyJZDCQp8VU0GfpkY504cPWvH/TPZyAOU6BAa2LFQIxWOrCD+HgY+LdQS44r6IoCsyMpBSSIU+bKZsTn7rmheL/OY=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by IA0PR04MB8806.namprd04.prod.outlook.com (2603:10b6:208:483::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.27; Tue, 31 Mar
 2026 07:34:08 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 07:34:08 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] xfs: handle too many open zones when mounting
Thread-Topic: [PATCH 2/4] xfs: handle too many open zones when mounting
Thread-Index: AQHcwAfgaQooT6/NoEmvTcGENBW1HLXIQXQA
Date: Tue, 31 Mar 2026 07:34:08 +0000
Message-ID: <f5b90db9-6ff2-4882-82b1-c97f1ff62d63@wdc.com>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-3-hch@lst.de>
In-Reply-To: <20260330054111.3855818-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|IA0PR04MB8806:EE_
x-ms-office365-filtering-correlation-id: 3d9785dc-a740-4a81-5114-08de8ef7e52c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 crNVdz0NEiyTRciztsdw1hGGF+UMV8/qw0dE1rDjJPorCferzJD8BJMYI2XsXC9d0jTIa2z2v7pHPCdIWid430zBx/2PUMGMgi0bf+mxHI0AjtSPXKTdgIWuS38UUOatlucyrcJh10YDqM48aZIaRji0p+NseI1SV2C1du9gz0OpIFoJmJWszgClx1BwVh4hO5l+cke7EC/TTfw/iHJ0Z4GsagUqujDg5ku8hWJGCtrcKaorNxkYZ/Pw7s/hrblLvm2oP/Ac2fUAWNjyLJwGzE41aacMVsXacG33n8XTH3D61VosELz/c6KcaprpXAS3Qqk27SnnFhoKmklDoa+QNb8RCnF2GMkJaRdK7pwLIfyKWGqqb2/jmdj3fAMro5xKY4820LCzEIfkW38nhtctfXhhQLEBcPwGIu99DyWayeyO+sYgFtQL0vzy9BAO7nXB+AuEMojSNIB3qKszqhMBz4kWH8sfR5nLR14PIUKeKg74EBcpSh/LRHx2MONBqkm+Y7W8tWIX30TJnSY4XX86o9OXA3zkZOooWlrqUyN3ocHBDeOJsETXJ8iivvv64VMLmNDYbBOaF6qj5vMJ/iWjjQ2VFuJNhLjVLqrrnMPlzbkVUecCqlR4VoY9BBB5DPv3FZGVU48H/aII8LQonvrW4fRu6jRsKi66l34TLlDUJ0qnkat35KWDo0ut+1XQZ0I7dBaFDy+Ci558TWbl0twTHwjbwefLOnpH1z49OJykXO7JvLFe+jJ0WBVg9aK4NMUPfK2BAgcBO3x/jeRxkkC8UFHaFOAM8S5CTjx87cf7q6U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aWRmTFBIY1BkQWV5cUJXN2hndnRJdUIycTJXQ2hvSXlRM3BmU0pMd0hSaGNj?=
 =?utf-8?B?cjloLzJDMlZpQlZFUWVucTcraldrbDBKNFFRVy9LL1F4Rk1YQktLRytJdDY4?=
 =?utf-8?B?em1YdHRiUnU0T2crcXpxM2hIREdVUkJFNkd0NWlLRnVTSWtpY3dyc2hEVXNY?=
 =?utf-8?B?WS9CSlZIV3piWlYzbzhGcDdLMzQvN1doSUVuaFU4NnhGTmJsbktVRVV1T25v?=
 =?utf-8?B?OVhBRWFEK3R0WEFzeFNXMUdhNnJuZ2gxK2k5dXcydTRwUUZGSDVyNmhCeFdv?=
 =?utf-8?B?aUZFOWdMMFU5VGlrbXhMN1JDakJtaW45ZXFaNUNJNml3aGdBTEJ6eUVWdVE5?=
 =?utf-8?B?N0UrS01TN2dWU3FnaTBRN0pndkZYV1NWekRrVklsdTVncWNFaEhta0JmOFlr?=
 =?utf-8?B?NkVqaStIQmZzVjVsbzFpcXFKRkp3NjRUVU5PcExmNktPbG5kd3FMSXBNNC9N?=
 =?utf-8?B?UWVmeXFEUEVtYmpxMTNyQXpzQlJqMXhIclNneVRIS0xEQUVwK2lHNjJ0emtW?=
 =?utf-8?B?YVJmS3phWHZ4clA1dm5BRlQya2x1S0grSDlzMzBDTy9sblhtaThLUFM3Nkx4?=
 =?utf-8?B?UFJVTzE0czczZ3dvSmR3NWhXRitFQkcrNmlzeU1ZanBaYURISTBRTW9SZlls?=
 =?utf-8?B?bXc0OU9wOXNlTi9lZ016d0lQQldDdDhva3UxRUtvU0FURXk3ZWwxVjd2cHd5?=
 =?utf-8?B?UjNOQ2RIaVJkNyt4ejJ1Vi83bkh1Z2VGVGVRbzREYTlQK2FhRW5hVVJyL204?=
 =?utf-8?B?bnVmRHJjSmh6dU9NakhrZjdVSXlXSWJsTEY5VGNURW1ublZCaWpLMUFsZUpu?=
 =?utf-8?B?SGIzYXdEeHdzcjFGWjk1U3ZYb2NWNFFHWktqblV4aTcyOUcwMzlJTTVrb2NH?=
 =?utf-8?B?WHBiU3g4RFpHSmRTYjlkQ3BXeWo1SXdEbGFsbjdwZjBTRzhvSlRyVkdrRVRv?=
 =?utf-8?B?bG5ON1I1Nmhac0hHTE1sSHJ6NHR4YjVCZ0NGMmV5QUVIRWNtN2xKbStaaDdR?=
 =?utf-8?B?S1BoR3JESHdEN3ZNczlTTHdXVVMwa1cvcnFOeUNocjJKT1dMeWVpMXovVnhB?=
 =?utf-8?B?YTM5dFBDWkdDbzJkeFFEUlFiWUhvdW1tcDVqYy9QUWVCMVA1NHorMFgveTBr?=
 =?utf-8?B?TURINE1zVkhxMm04UmVmK0JtY3pUVlR2UzM1dy9VdkhvdjAxc2hNYW1pMG1l?=
 =?utf-8?B?bDhiTDhld2JpeDQyeS81bHFoWjNrcDEvWlZ0SWF2Vnh5NEdJbVNPL2U4VGZU?=
 =?utf-8?B?aWdqTkhRT1FsN1RIejN0dzJieFY1RE5oMURzZFBZMFFDY1dsQTBPT3VHc2l5?=
 =?utf-8?B?SFFkZU9sV1FJTytaOFJXQWpUblZTb0w3Vlp3N3BVNHVZZXptL3lCUHpVNU85?=
 =?utf-8?B?dmp5ZHJockwreWpNK05OL3N3V3dkWWNlMmhaUm1JZ1M0aHZYVkVYZHlhenhY?=
 =?utf-8?B?czNwaDRkbStQa1pmMnhBOHJkQVprUkU1UUlCZC9QSDdXVGZodmZRTlRRRWlp?=
 =?utf-8?B?UHo1MEZsNE1ZdnJGQzVhNXhpQTBOVHRNcml6OTlONDA2cXQ0SGNSVzlXSzZy?=
 =?utf-8?B?aFhpMWc2TlJvZklCdGFleFJveXZ3eXk2My80WGRiblV1a24xUEFnTU84Smh6?=
 =?utf-8?B?MTAvRmRXZFV4c2NyTjhSQXJpWnV6K1Q1ajJ3Skl6emlwZjBNbk41YXhaOERD?=
 =?utf-8?B?aXhRTFdiUm44Y3R1RXFrSTMwb1N4OVAwSE1rT3djMjZWbnZWRk40THdEUkpB?=
 =?utf-8?B?RFRjbDRFYnQvSFRMYm5ZVzZ3aDlsNWg5V1VzMVMrUWJJbytIR1pmNnp5Wnll?=
 =?utf-8?B?dmsycFJNS0NJY0pHZGJBWFRIRFRqcjEvd1NDczBzencyemcxenBaWGlFNTNY?=
 =?utf-8?B?cDFNRzBBZDUrK0N6bU9WblZobVF1Wlg2bzNPb1o1ZkhvVWhSUmdUaExlRWNh?=
 =?utf-8?B?M1Y5a2lQVU1JWUxqVzFJYWJMUnpNYkdyeWpScHZsWDBZdzFDMUtndzBXUWIv?=
 =?utf-8?B?TXRsaEM3VjJLM0xKZDkwdFg0N3YrTVFJYldCQ3ZaWXpuZ3FDcitjVVo5alFK?=
 =?utf-8?B?ZUl2VFZjVm50ZFAxUGdiSEhZejcxQUNSTlZieVgxTEpEVk5Hd1hkazJmdlY2?=
 =?utf-8?B?TWRUemIvNEtBaDBhRDZUNE52R2lkSkNGN2paajFRcWZGbXZ0MC9Hcm5nL0lI?=
 =?utf-8?B?Q0oxa0l2alRHYzh2M04weUlVNFl6Q2JXUXdMY1NnemdCcnpESUdYVkpmU08w?=
 =?utf-8?B?RUtXT0RabkdpdlJ0SnJaWUQrMGk5MVlKNkZqajFOdVVTK2ozOHZRR255NDRw?=
 =?utf-8?B?MkNuNTRvM2RJR1VTOWdjbjdoR0ZsNDRVSnI4V2tlcTdvU0VXNHFHUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEE4EC347AB83640B242E9D613758D9F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	gikhYO+iAB1c+H4UfNTe4Xz9fzpfwYLLq/NVtMMDFCYmeTPn4TJXQ3ZIcJKqpxCgO7MT7aq+IatPjDm1Z/1xkiYAnNfLpt6yf8lOmcMcjanvBWPWceeyO5+HsQluWqBkBxy4bKfYBpxjMQ4V84lUSF0jmZRryVDI0wYMAPEqjKZusY97YJoif2GFWw/wI/MQrSMPKwDJEDWoHTTNPPhdgnSyvI0nxbNErNIVRXEy8GwiyRkatCAq2d/Nu/w6v3wuyBJui7KyweMWXXdTk5+gHElO3NwOLiZUj34WXrYcMb9aKUeoZA0SsOqxYWkenyR8La6eMljMnEyfcVzovwWMJQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b5QYjmEY4DtP/WG/PwyBrH3e0vFEBJGwcxUpD49bwdwHyqJs7alnoBEJDzgUlTmW+bwX2lLsvgIkEmWJbM0W54yu1bR1bLEMMr4BWaoMqD5UQ5as5T2rfALZDgjD5nuNSsRucfcRxwbt5sFn3VoyvUBm99Ri5y3+yVKiE8CehM3TDREs/DlbdbLt4l73jP1kEZc+yIe6ZEG/G6dTJaQDUa8fKZWatIiaeom6DzJ6wZxxfXWo3JaJVWB6pwSqWyO/vf51mkrq8hzi0NcF8/z2d+jDOfz7+VCoeroLBPYHGz9HFHwCoadDwHyuoBtGoLb6s5u6TJ5pIC4udYzzUyIKwY+ROdshdTMpRB69DSusQ6fq1axBGYarrFn7Z7sHvWMi0V/xVeDrgclLzlgDoed3CpgevI+lXf+RfipnZWPe+IMTJ8heng+dM2IcplSlv85ORVaAUXZNZKznr9JBCK9ikjDQTjWdYSPFUF4jJwMlWk05eIIX2sfNYuPmkKCAgoyviH5vvBQjyBMUDlmwSHoh9h640iqfQUA581pQp0PgJJCrjiuhNae45Jl9Q4rsvYnz2g6gp3OQ7MKyOViJt5vsr2lppmIcjgCFCVhPmLy/q1neRWRGjz1993TtP51JPdtL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9785dc-a740-4a81-5114-08de8ef7e52c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 07:34:08.6105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emMm7zsxhcQtR7d7gdKEC/MKyZaXCdcUoR+1p79IW2YDlSsXJ7BXjb3FymwKahF4KeQWnTAHRGHHqSMVvd6CXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB8806

T24gMzAvMDMvMjAyNiAwNzo0MSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdoZW4gcnVu
bmluZyBvbiBjb252ZW50aW9uYWwgem9uZXMgb3IgZGV2aWNlcywgdGhlIHpvbmVkIGFsbG9jYXRv
ciBkb2VzDQo+IG5vdCBoYXZlIGEgcmVhbCB3cml0ZSBwb2ludGVyLCBidXQgaW5zdGVhZCBmYWtl
cyBpdCB1cCBhdCBtb3VudCB0aW1lDQo+IGJhc2VkIG9uIHRoZSBsYXN0IGJsb2NrIHJlY29yZGVk
IGluIHRoZSBybWFwLiAgVGhpcyBjYW4gY3JlYXRlIHNwdXJpb3VzDQo+ICJvcGVuIiB6b25lcyB3
aGVuIHRoZSBsYXN0IHdyaXR0ZW4gYmxvY2tzIGluIGEgY29udmVudGlvbmFsIHpvbmUgYXJlDQo+
IGludmFsaWRhdGVkLiAgQWRkIGEgbG9vcCB0byB0aGUgbW91bnQgY29kZSB0byBmaW5kIHRoZSBj
b252ZW50aW9uYWwgem9uZXMNCj4gd2l0aCB0aGUgbW9zdCB1c2VkIHNwYWNlIGFuZCAiZmluaXNo
IiB0aGVtLg0KDQoNCiJVc2VkIHNwYWNlIiBpcyBhIGJpdCBtaXNsZWFkaW5nIGhlcmUsIGFzIHRo
ZSBwYXRjaCBwaWNrcyB0aGUgem9uZXMNCndpdGggbW9zdCBhbGxvY2F0ZWQgc3BhY2UsIG5vdCBy
dGdfcm1hcChydGcpLT5pX3VzZWRfYmxvY2tzLg0KTWF5YmUgc2F5ICJsZWFzdCB3cml0YWJsZSBz
cGFjZSBsZWZ0IiBpbiBzdGVhZD8NCg0KQXBhcnQgZnJvbSB0aGlzIG5pdCwgdGhlIHBhdGNoIGxv
b2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdk
Yy5jb20+DQoNCj4gDQo+IFdoaWxlIHdlJ3JlIGF0IGl0LCBhbHNvIGVycm9yIG91dCBpZiB0aGVy
ZSBhcmUgdG9vIG1hbnkgb3BlbiBzZXF1ZW50aWFsDQo+IHpvbmVzLCB3aGljaCBjYW4gb25seSBo
YXBwZW4gd2hlbiB0aGUgdXNlciBvdmVycm9kZSB0aGUgbWF4IG9wZW4gem9uZXMNCj4gbGltaXQg
KG9yIHdpdGggcmVhbGx5IGJ1Z2d5IGhhcmR3YXJlIHJlZHVjaW5nIHRoZSBsaW1pdCwgYnV0IG5v
dCBtdWNoDQo+IHdlIGNhbiBkbyBhYm91dCB0aGF0KS4NCj4gDQo+IEZpeGVzOiA0ZTRkNTIwNzU1
NzcgKCJ4ZnM6IGFkZCB0aGUgem9uZWQgc3BhY2UgYWxsb2NhdG9yIikNCj4gU2lnbmVkLW9mZi1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMveGZzL3hmc190
cmFjZS5oICAgICAgfCAgMSArDQo+ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDc0ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQs
IDc1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3RyYWNlLmgg
Yi9mcy94ZnMveGZzX3RyYWNlLmgNCj4gaW5kZXggNWU4MTkwZmUyYmU5Li40MzNmODQyNTIxMTkg
MTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfdHJhY2UuaA0KPiArKysgYi9mcy94ZnMveGZzX3Ry
YWNlLmgNCj4gQEAgLTQ2MSw2ICs0NjEsNyBAQCBERUZJTkVfRVZFTlQoeGZzX3pvbmVfYWxsb2Nf
Y2xhc3MsIG5hbWUsCQkJXA0KPiAgREVGSU5FX1pPTkVfQUxMT0NfRVZFTlQoeGZzX3pvbmVfcmVj
b3JkX2Jsb2Nrcyk7DQo+ICBERUZJTkVfWk9ORV9BTExPQ19FVkVOVCh4ZnNfem9uZV9za2lwX2Js
b2Nrcyk7DQo+ICBERUZJTkVfWk9ORV9BTExPQ19FVkVOVCh4ZnNfem9uZV9hbGxvY19ibG9ja3Mp
Ow0KPiArREVGSU5FX1pPTkVfQUxMT0NfRVZFTlQoeGZzX3pvbmVfc3B1cmlvdXNfb3Blbik7DQo+
ICANCj4gIFRSQUNFX0VWRU5UKHhmc196b25lX2djX3NlbGVjdF92aWN0aW0sDQo+ICAJVFBfUFJP
VE8oc3RydWN0IHhmc19ydGdyb3VwICpydGcsIHVuc2lnbmVkIGludCBidWNrZXQpLA0KPiBkaWZm
IC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2FsbG9jLmMgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2Mu
Yw0KPiBpbmRleCBlOWYxZDlkMDg2MjAuLmIwYTZiYzc3N2MzNiAxMDA2NDQNCj4gLS0tIGEvZnMv
eGZzL3hmc196b25lX2FsbG9jLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4g
QEAgLTEyNTMsNiArMTI1Myw3NiBAQCB4ZnNfcmVwb3J0X3pvbmVzKA0KPiAgCXJldHVybiAwOw0K
PiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wNCj4gK3hmc196b25lX2lzX2NvbnYoDQo+
ICsJc3RydWN0IHhmc19ydGdyb3VwCSpydGcpDQo+ICt7DQo+ICsJcmV0dXJuICFiZGV2X3pvbmVf
aXNfc2VxKHJ0Z19tb3VudChydGcpLT5tX3J0ZGV2X3RhcmdwLT5idF9iZGV2LA0KPiArCQkJeGZz
X2dibm9fdG9fZGFkZHIocnRnX2dyb3VwKHJ0ZyksIDApKTsNCj4gK30NCj4gKw0KPiArc3RhdGlj
IHN0cnVjdCB4ZnNfb3Blbl96b25lICoNCj4gK3hmc19maW5kX2Z1bGxlc3RfY29udmVudGlvbmFs
X29wZW5fem9uZSgNCj4gKwlzdHJ1Y3QgeGZzX21vdW50CSptcCkNCj4gK3sNCj4gKwlzdHJ1Y3Qg
eGZzX3pvbmVfaW5mbwkqemkgPSBtcC0+bV96b25lX2luZm87DQo+ICsJc3RydWN0IHhmc19vcGVu
X3pvbmUJKmZvdW5kID0gTlVMTCwgKm96Ow0KPiArDQo+ICsJc3Bpbl9sb2NrKCZ6aS0+emlfb3Bl
bl96b25lc19sb2NrKTsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KG96LCAmemktPnppX29wZW5f
em9uZXMsIG96X2VudHJ5KSB7DQo+ICsJCWlmICgheGZzX3pvbmVfaXNfY29udihvei0+b3pfcnRn
KSkNCj4gKwkJCWNvbnRpbnVlOw0KPiArCQlpZiAoIWZvdW5kIHx8IG96LT5vel9hbGxvY2F0ZWQg
PiBmb3VuZC0+b3pfYWxsb2NhdGVkKQ0KPiArCQkJZm91bmQgPSBvejsNCj4gKwl9DQo+ICsJc3Bp
bl91bmxvY2soJnppLT56aV9vcGVuX3pvbmVzX2xvY2spOw0KPiArDQo+ICsJcmV0dXJuIGZvdW5k
Ow0KPiArfQ0KPiArDQo+ICsvKg0KPiArICogRmluZCB0aGUgZnVsbGVzdCBjb252ZW50aW9uYWwg
em9uZXMgYW5kIHJlbW92ZSB0aGVtIGZyb20gdGhlIG9wZW4gem9uZSBwb29sDQo+ICsgKiB1bnRp
bCB3ZSBhcmUgYXQgdGhlIG9wZW4gem9uZSBsaW1pdC4NCj4gKyAqDQo+ICsgKiBXZSBjYW4gZW5k
IHVwIHdpdGggc3B1cmlvdXMgIm9wZW4iIHpvbmVzIHdoZW4gdGhlIGxhc3QgYmxvY2tzIGluIGEg
ZnVsbHkNCj4gKyAqIHdyaXR0ZW4gem9uZSB3ZXJlIGludmFsaWRhdGUgYXMgdGhlcmUgaXMgbm8g
d3JpdGUgcG9pbnRlciBmb3IgY29udmVudGlvbmFsDQo+ICsgKiB6b25lLg0KPiArICoNCj4gKyAq
IElmIHdlIGFyZSBzdGlsbCBvdmVyIHRoZSBsaW1pdCB3aGVuIHRoZXJlIGlzIG5vIGNvbnZlbnRp
b25hbCBvcGVuIHpvbmUgbGVmdCwNCj4gKyAqIHRoZSB1c2VyIG1hbnVhbGx5IG92ZXJyb2RlIHRo
ZSBtYXggb3BlbiB6b25lcyBsaW1pdCBhbmQgd2Ugc2hvdWxkIGZhaWwuDQo+ICsgKi8NCj4gK3N0
YXRpYyBpbnQNCj4gK3hmc19maW5pc2hfc3B1cmlvdXNfb3Blbl96b25lcygNCj4gKwlzdHJ1Y3Qg
eGZzX21vdW50CSptcCwNCj4gKwlzdHJ1Y3QgeGZzX2luaXRfem9uZXMJKml6KQ0KPiArew0KPiAr
CXN0cnVjdCB4ZnNfem9uZV9pbmZvCSp6aSA9IG1wLT5tX3pvbmVfaW5mbzsNCj4gKw0KPiArCXdo
aWxlICh6aS0+emlfbnJfb3Blbl96b25lcyA+IG1wLT5tX21heF9vcGVuX3pvbmVzKSB7DQo+ICsJ
CXN0cnVjdCB4ZnNfb3Blbl96b25lCSpvejsNCj4gKwkJeGZzX2ZpbGJsa3NfdAkJYWRqdXN0Ow0K
PiArDQo+ICsJCW96ID0geGZzX2ZpbmRfZnVsbGVzdF9jb252ZW50aW9uYWxfb3Blbl96b25lKG1w
KTsNCj4gKwkJaWYgKCFveikgew0KPiArCQkJeGZzX2VycihtcCwNCj4gKyJ0b28gbWFueSBvcGVu
IHpvbmVzIGZvciBtYXhfb3Blbl96b25lcyBsaW1pdCAoJXUvJXUpIiwNCj4gKwkJCXppLT56aV9u
cl9vcGVuX3pvbmVzLCBtcC0+bV9tYXhfb3Blbl96b25lcyk7DQo+ICsJCQlyZXR1cm4gLUVJTlZB
TDsNCj4gKwkJfQ0KPiArDQo+ICsJCXhmc19ydGdyb3VwX2xvY2sob3otPm96X3J0ZywgWEZTX1JU
R0xPQ0tfUk1BUCk7DQo+ICsJCWFkanVzdCA9IHJ0Z19ibG9ja3Mob3otPm96X3J0ZykgLSBvei0+
b3pfd3JpdHRlbjsNCj4gKwkJdHJhY2VfeGZzX3pvbmVfc3B1cmlvdXNfb3Blbihveiwgb3otPm96
X3dyaXR0ZW4sIGFkanVzdCk7DQo+ICsJCW96LT5vel93cml0dGVuID0gcnRnX2Jsb2Nrcyhvei0+
b3pfcnRnKTsNCj4gKwkJeGZzX29wZW5fem9uZV9tYXJrX2Z1bGwob3opOw0KPiArCQl4ZnNfcnRn
cm91cF91bmxvY2sob3otPm96X3J0ZywgWEZTX1JUR0xPQ0tfUk1BUCk7DQo+ICsJCWl6LT5hdmFp
bGFibGUgLT0gYWRqdXN0Ow0KPiArCQlpei0+cmVjbGFpbWFibGUgKz0gYWRqdXN0Ow0KPiArCX0N
Cj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICBpbnQNCj4gIHhmc19tb3VudF96b25l
cygNCj4gIAlzdHJ1Y3QgeGZzX21vdW50CSptcCkNCj4gQEAgLTEyOTQsNiArMTM2NCwxMCBAQCB4
ZnNfbW91bnRfem9uZXMoDQo+ICAJaWYgKGVycm9yKQ0KPiAgCQlnb3RvIG91dF9mcmVlX3pvbmVf
aW5mbzsNCj4gIA0KPiArCWVycm9yID0geGZzX2ZpbmlzaF9zcHVyaW91c19vcGVuX3pvbmVzKG1w
LCAmaXopOw0KPiArCWlmIChlcnJvcikNCj4gKwkJZ290byBvdXRfZnJlZV96b25lX2luZm87DQo+
ICsNCj4gIAl4ZnNfc2V0X2ZyZWVjb3VudGVyKG1wLCBYQ19GUkVFX1JUQVZBSUxBQkxFLCBpei5h
dmFpbGFibGUpOw0KPiAgCXhmc19zZXRfZnJlZWNvdW50ZXIobXAsIFhDX0ZSRUVfUlRFWFRFTlRT
LA0KPiAgCQkJaXouYXZhaWxhYmxlICsgaXoucmVjbGFpbWFibGUpOw0KDQo=
