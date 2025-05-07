Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD43205ABA;
	Wed,  7 May 2025 10:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746613447; cv=fail; b=BsoNtnssNd/o1n8mDOz8v6CH7+KIgUCks4m6J143EoU/dnDTYavOfJM5wNocIJleq8DAVkQPslD4LKa60j6z/FFtxQKpwwkmAmEDzD6ZjgIPS52q4+YruzMwn5dBY9ICDCLJM6dALUCUPCXstAPbnCAny1sqRPRPqotbBh7VSyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746613447; c=relaxed/simple;
	bh=EJuH31XNauGaDs/jYyw4lpnqRtXCBDDFoHZ6+iS5fE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AfV3lbf0UbpQU0faxYfRkjtMzP+JeOl4mLmkpfvJwQfLP+BQBASqYocxbZ4YF0XhYoSR13D1UhfCzivQAOwMmXfzX6Tj0Rp7/ma99d0xfguqR5L5FMAYs+B6Hwk4VkDrOv0Biis50yd30ilTz8+ZOMCDF9SYd6nWE31N/WSd3cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=J4s2bprS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=h7oN45MD; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="J4s2bprS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h7oN45MD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746613446; x=1778149446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EJuH31XNauGaDs/jYyw4lpnqRtXCBDDFoHZ6+iS5fE0=;
  b=J4s2bprSVuYIurlu8gIchqWt/2GWP5+p9ygG027xugn00azZwJuCWCfU
   wPbwHzAe0b9n13LkePiGqk+//Q5cjd1Ce8MrqsJTIyxAI521VmH9BsClf
   NAVTOnBevIv+hs3qYuxcrxEpvjwMVTe+MHzxEZC7tu1yHj5HHOeLMG6/u
   9DL16h18rMAL/Ki/b+3/5dp+1UoraS3hgFZyUUYEu7kYErIKyen4Sj116
   y0Y54xQTQRPPpcazJ1F6ySj8mggtPr0AYHZdbmmt4vOu5hgkKot/0Solx
   /17WTir8wcBTGHoLxt6LLkU9inzduatv8CtdvTUGg2erC1rSqTU+NJ8c7
   A==;
X-CSE-ConnectionGUID: izh777SATUye0WmvQkVFYA==
X-CSE-MsgGUID: yeChbqUJRFu+4zhWsHcWOg==
X-IronPort-AV: E=Sophos;i="6.15,269,1739808000"; 
   d="scan'208";a="81429669"
Received: from mail-westcentralusazlp17013074.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.6.74])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2025 18:24:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V+uQ8LPbB2cZ10JkeOAc7pgN2aD4iK2Ev12KZNhKBDP5f9UeJAUOKH0gY8CsTNXOXF4JO1QH1DMGkqqtCdDcnLuZkgxOZPbJNJ7WAFyRBF1FFAj3wygDTCHKmp5SYopKeP4D42S2PTC75ZXMchEaZyswS81AkeRYED0hhNolUGF2WEt3jAdygZDGf7b5z+MEHfo/MYZvMhGqXnRtgiCoNOfezVjR+5zxOXF3aZRim5cZKE3tdb5F7rDBqin4Xs4M8OEW7XYtMsCiexnRTOwofMqVqji7SRwKL9JkKtoLyWN5GGhy1myrq4+amhkb0ioPiFVNdBe7OZyKfTDBroeOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJuH31XNauGaDs/jYyw4lpnqRtXCBDDFoHZ6+iS5fE0=;
 b=r7hNS61+njcgq71outwQXe2avE5SLz1Nig7O1O7qwDU5olXcAElZeSWu8s/QTg69ydLdIjw02sLvJLC1yq8vMoJ8pMn/AtQfcE9bBBETQic/MQcQlE4rR/uA8BKXR7cWqOtlppejlQVrcp4YV29Lt+1BrdCcuijisJu7rNAk5kD0wPDCsDczCIXNKes3WfCjBm/cOYiiRWGOYcEGgroEAsi+vOMamlDs8zAdHBEHobB3yVPKknNLSq6dkPvKNvoNh6q4ScfvL/J7UtDTtVCsNebeTLrK2z4UofBskly5FXj+z5llqyeHB2fw8L9s6WNy0+Ap/BgEXSpnmb2W2Oc3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJuH31XNauGaDs/jYyw4lpnqRtXCBDDFoHZ6+iS5fE0=;
 b=h7oN45MDhqM8MsJjgGWTvaPnpO4teC7/f3+5mVqWYLsmy4keX9s2+qpg2NjdcJN9vP4+Gx5p8Ejx/dkX5Xe+qEr8pUNc8iwK0nVoEuoz/ZiB/rxhiL5Sx5ksRsPunvdwj4ughzsvBx/K4waB3OnKdPJfdP7AZYUsvLv47V8RIY8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6550.namprd04.prod.outlook.com (2603:10b6:a03:1db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.20; Wed, 7 May
 2025 10:23:58 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8699.033; Wed, 7 May 2025
 10:23:58 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, hch <hch@lst.de>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Topic: [PATCH 1/2] xfs: add mount test for read only rt devices
Thread-Index:
 AQHbtcDlQOxnpwBoYku+VcbjviMnX7O0euiAgAYW+wCAAC86gIABcegAgAAfroCACp3+AIAAGBYA
Date: Wed, 7 May 2025 10:23:58 +0000
Message-ID: <f7834928-82cb-47b8-a3b5-28cab36cc7c5@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
 <20250425150331.GG25667@frogsfrogsfrogs>
 <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>
 <20250429145220.GU25675@frogsfrogsfrogs> <20250430125618.GA834@lst.de>
 <20250430144941.GK25667@frogsfrogsfrogs>
 <cd061e60-bb7e-46be-8b8c-31956e3ad255@wdc.com>
In-Reply-To: <cd061e60-bb7e-46be-8b8c-31956e3ad255@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6550:EE_
x-ms-office365-filtering-correlation-id: 64f7ca46-d65b-438b-8384-08dd8d51475c
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZXlvSzdkY3RJL2EyOGdRaVk5Y2VRUFRLbzZLaDdDOSttbFJVSWxKUlE5L2ZR?=
 =?utf-8?B?a1pYeUdrVGV6aU1LVy9oc1h2bW1JWlVZNUoxVDVyNkFzSDZMc0prYm1ldE1a?=
 =?utf-8?B?eDNVOHg5Q05xSXF3a216RngxTHBwRXI4VjBKYnVDT1R4Z0gyc0xCWG9rNnJC?=
 =?utf-8?B?Rno5OE9IQU96aUFjMm5Lb0JDWTNUU2FKODI4VkVycWlHa0xxbGRIbWljRUVC?=
 =?utf-8?B?YndBbkRRRk5vSHo2bXoyNm9oRXp4dXNqdk5USHNiQU5YRE50TDh2THU5bjR1?=
 =?utf-8?B?dGFXenJtRkZUckxsR203cFRIZ2x5b25tSmFHT3dXRnJrSlZuOE9OaVdwc3hZ?=
 =?utf-8?B?MVFKeGtIMnRkZm5qMGhXRDhzT2FSUENrTFhVcHRGZ1VXOWpSamxGVE03U1Fw?=
 =?utf-8?B?MExlVHBjMXBUVjl1Z2VCQjBWS25mdSt4MUROam5aQTFHekpndXVqT2YrSnNs?=
 =?utf-8?B?ZVEyVHFZNzM0RE5VN2NwWllINjBEWTFsOXROR2EwSm5ZcHFNTlh0YUhYeDh0?=
 =?utf-8?B?RXpXd012ZzFWMFhtaXFCTkhqTjZVcFZQREYrU3FKMnppSnNGKzZWb0hubVNz?=
 =?utf-8?B?SEdReXhUUERDZ3BON3FzZTNOazdBWFk0d0VGbnJiZXBYYzhlN2V6OHhXOU5x?=
 =?utf-8?B?TWN0RGxhNmJnczFkNnQ4SGV0UDJpQUo5dEdLamRpTjJteVk3TlZDeGpQYUo1?=
 =?utf-8?B?akFUdjREekd4YVNRNjFQb1RLQTgzaTRkeitmeFR3Um5YTkpmQ0dhTVBVRzVW?=
 =?utf-8?B?enhRZzBHRFVFQ1VSdWlZeENvYkh6WGIzTEp2UGl5QWJUSzBRMDhxYktHelUw?=
 =?utf-8?B?MWd0Sm9ubGVUaHEvTXZib1gzeWNNdEU0ZnNsR0FVL05JV0NqcUhndUJwVDRG?=
 =?utf-8?B?MG9XbE9kdDAzWG9kVjE3Uytad1VtQ2I0amV0YkVqdmJ1Z1cvL1d3b0swT2cr?=
 =?utf-8?B?cFg1TmVYUWgzUjViUnRvMWVoWkZGS2FZR3ZXVjlmVFdMY1dzSzREdzdzbXV2?=
 =?utf-8?B?N0lmZUp3anE1Ui8zamNlTktOdXJYQ3VpRjhBVktlVUhQWFJVSFcvZ1M2VVNz?=
 =?utf-8?B?UTlnY3N5YWRMQ2MxcThpWTBHaGNVYVd4eHpJNjY2UDQ1b055dXc4QzF1SkhI?=
 =?utf-8?B?d1VUTWNYeDc3cVNETW5UYjVHS0Jjc1RsZmhrY1IxWlo3NWZxbjdCUklNOCtw?=
 =?utf-8?B?bmU3Wm1LNmcrWThDQnNabkNnWWZobm90UzNlNlBXbmg1QmFRa3BLUGowTTQ5?=
 =?utf-8?B?TjFzbWJNYXRIcWxKaFVab2FuUTNmTVFvd2t4SHlPWGFPd2tBSmFjVFJjbUJD?=
 =?utf-8?B?c1RZS05KcUFpZ0xlR0RQQkRZTC91N2JtTUl0dXZUVmJBZEhUTkJUVG5YOE9x?=
 =?utf-8?B?MUtlUHFPNFh3QklZc3hraGdxbGMzV085NDJpTVhVQlptMG5wTEpGNi8rNmVW?=
 =?utf-8?B?QUVaZ3ROWUZOT1AxNjc3TEZYN1pIeFpuZ28yS1dMZWk0bXNRZXM1Q0gvYldC?=
 =?utf-8?B?c21Qa1FMWFBGNG1JcFRaVHBsSGJSZmsxQWlleHVDTmw3c1hUcXJBQk05VTJK?=
 =?utf-8?B?bUwzZ0xUV0pob1JSeXBNMzhoOFgrRHJYUUVnOGFoRThpVytHbklGd29QRExU?=
 =?utf-8?B?MC9EVDlJbXp0MjhEZGo1R1ZzVWtTQlRCOEcyQWVJS0RrbDBTOWp6cjdwc3Fx?=
 =?utf-8?B?TnpKOUVFcXRaUDlxTjBCY2ZXNWErOVpYRW5ua2J0V2RXOXhlODNSZ2tXTjFP?=
 =?utf-8?B?cld5MlJVZE5iRCtuQ3ZwbkxWZFY4UllrenU3ZTZ2aEF4K1BCc3M2VWVxcGN1?=
 =?utf-8?B?TUY3OVBncVlZVlhVNThCZHFpNStjSDdNNGJTRTJ4RFJMZm50VzFhNnphNmF4?=
 =?utf-8?B?eG94UVFLR1ErUVVBWUdyLzFuRmtueGNQWGs5ejF6V2dOY1JUN1Vra1NCc1B4?=
 =?utf-8?B?L3BsTE96ZHNDQXd1VStoR1p0bmQvYVVpdW1UN0hEek10MFpmU1NnNXJsYWwx?=
 =?utf-8?Q?iqZRxTEldGwt2zz45mp64330S5UALM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmlTK2VoK1V6UzNtR1Jld0ZQTjZnNXVGdGZhRWl1SU9YaHZRYXQ5ZlRZOFJL?=
 =?utf-8?B?eHJtd2h4U3VFR3JXRnZaaVZSQjk2S25vOUlMMkIyaUhRbDJTemlLZys2dnI3?=
 =?utf-8?B?NHJwamsxbVFFSUd3d2YwYkFkbFJXYUVITHFWUjFsS2ZUOW9Jc3dYaTJHTFNV?=
 =?utf-8?B?UHBDNXhjRzQ0UFNVTWpCclJLVGVpaHVJelZsMmFOWWFNL1UxNFNtWTJoOEk1?=
 =?utf-8?B?YVRCU2YycXFtS3hJbzFFZDJEL0dWYmtDd01La1Z1L1ZsMkR3Sjc3YnhraytX?=
 =?utf-8?B?cTNkYTZ1dUxvTGJ0RTBobktFTHMrSUVQaEFEaEtvZkx0Mi9VdnpzUnMrZFVC?=
 =?utf-8?B?N2c0Wm9uajlQZGZZeFQrSHVuQm54Y3VlM2hJZkZVTUpxSVp5Y1ZWOXFpMDZN?=
 =?utf-8?B?R254bTdqYmY1VUd2WnBJYndZUlk5Y3V5NVFCZmxrczRvQ2FxMkxmeWVqeFp6?=
 =?utf-8?B?cHRrSk5WL0JrQXFxcU83aTBzd0YwWjlia3B5L3NsWUxlYW11RlcwcVNqQmsy?=
 =?utf-8?B?clNlVFoyNm1pRWVJOFBKaGRoKzNUdjF6UTRGR2FpVVdlblFqRXN4NnUrZU1j?=
 =?utf-8?B?WDJqZVZVMkVyMzZEWGJnRzRsSll6bGhBRG5sUUUxWXd2VERiNXRMVEovcmF6?=
 =?utf-8?B?TGNMQkRLYXdmYU53bjdqTzduZFFmbDFxcFk0MTB5ZS9rVUMzSWFZV04vMWpr?=
 =?utf-8?B?S3lHK3I2WVRMWTRZcmw4RUZWSE50UEd1eGtWWXR5bDBiNXpUM0pMbGx1MDhn?=
 =?utf-8?B?bEFUbERqVHpNVWlvNDllcE8xbHYwK0NHT3JDZzcyYkhvcVlvdUdUMGJ3T0I1?=
 =?utf-8?B?bUp1VE1oT0YyNnArL1IyY2E2MGoyVFh6dlpLN1pGSlN5UHhRc0E3U09HOTlu?=
 =?utf-8?B?U3NxLzcwZVNobktRdGY2RnRybFJqOGJQbFZZUm1oWkh5NHJsRlpKaXlBSW1o?=
 =?utf-8?B?VGNodkJtVEN0YkdOdFl2VDZuOG5jaERua3hnTm1MbWVhZ3lDT2RISHFNenl0?=
 =?utf-8?B?UEo3RmJ5aEpFTy96ZXJWNXBZazhhUWdLRDh0QmYrRFltc0hPVll4UmRoRjFL?=
 =?utf-8?B?bk45Y2tIbS9nV2kvNTNyVW05NHdKd1NYbnJPTEs0eWZYaDB2ODRySGU3eW1m?=
 =?utf-8?B?QVcrYWlUb2ZNWTNRRWQ4MUE4OFFtNXU4T0RZcEs2ek1mcWlndnhjdVJRUDRh?=
 =?utf-8?B?Z25xdTZGVDU3cmJxaWp2ajNVQlVqZFNCTDdoamxqZlBSWVYyMStLUGV3YzZB?=
 =?utf-8?B?VStzS1B1SzhOZ3ovWW1mbWNIWjlPZGt1aWRZcUZBanFQOE51VXNTd05TSlcz?=
 =?utf-8?B?UHVIQzAvUUthRjJHUDlVNUFBbGJwdklpVjcweFJzdzZiSURCQzA2WWlCUWMz?=
 =?utf-8?B?dG9aKy95TUcvalloSVFvYnBIanpVd3BLSVFpV056WnA1aHBQa3JtbEhENmxW?=
 =?utf-8?B?RjArYnBJQUN6VXlkdW9MTWlWdGVmclkwVU1tQ2tqL1g3UTRnNzVVcndvckNK?=
 =?utf-8?B?V0lWK2FTa1NYbXhORjJFMFNFMXBIVFh4OFlOV0poQUNrUm5vQU1oenVsd3N0?=
 =?utf-8?B?cjFYOTNmeGpBZktwT1R1RmhtbzdydTcrZi84TitoVTlNT3M5V1U2OVZnYnJv?=
 =?utf-8?B?MUJGaCtkQnA1RWRZcDJkSW4yNjY2eVdDQzZqdUorODRjWVh1MzNIeFlYMG9n?=
 =?utf-8?B?Vk9HK1U3cElJSTl1ZWdiMXlBeWJSSlhRVThibjlvMkRzUzJWUE1DdnV5Q1hs?=
 =?utf-8?B?T2t6bHJrakRFcWxkZG16eU1OWVpxWnZSTU56UGpZNjFMS2h3OVlOb3FPUk05?=
 =?utf-8?B?eE9aSUVyWnkyUVRzOW14dlp5U3phN1JZWGNSOWcydmRDSWV3RmNCVHZhWnhp?=
 =?utf-8?B?dVd2Tzd5aEYvcVJSWXd4LzRNbnhjcXZabzNzbEdvTEt1QXBEL0YwVTFyVk14?=
 =?utf-8?B?YmdPckNTOTYxK29BaU0vL0ZxbTBuNUVYaGlwcis4QUZ6SnhuY2NLSU1jczIv?=
 =?utf-8?B?UUQ1M3NKa2pUeTNtV1ZtS3RhV001dGhTYXZGa1FHRVAxMG1BYm1KZEFVNEZL?=
 =?utf-8?B?WW1mWW5IZ0hqOW5oTTFFbzNZZDAzaStRNFVrcDdXMVBTNWdDVW9LWGRHSkRv?=
 =?utf-8?B?ZDFob0k4KzZiaDZxODVhSFdiT3FmNVpBbHRBcHlLRkNSSm1VZXNYV0tsS3dG?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27913659C838674E932D657DEE2272C7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E3f9ro/IC5SQzjubnAlgCy5scFkvlcov8JaHOYv5lYkoZfZutmKSWTvdgdkXsOGn4p7kv69btrlcjhrm32H8IBlhUFXSl6qoiVUJTSEB77EvtR7W3W34eyAFKtL+BdTYUgMUGUMhrarSAifsXg7c5kIXgRr8AcWFh2Ff3T7Ah6z+ro+8JhtvEKBElfV/m66/cJ52LNVxCJODD4TO3JhzPJ5nEDsuGS4fZKr0Uo91VhyE1aN4VldWgGOeGJpCfxIYnEXd18hlLmQHsEoBN/AS8pxlqkZK2/WjcZfYXBAonZ/zia4eBoE0DQMsVswxrDneurufv84I4ojpNUtd7M+vh7RP2B3+/7Htod2SSTxzhAI6rKxj5+a4lnaljfdKJwF//nn8WiLg+CnffbliGhi3zkpHT8GpMuJtLkucCqGxn5gjB9tBSigtelNwoh/JD3UAu4MrOq6oF060otq8G2PboOB7oZCldCt7zaSbIXVnywfCDa5Cg/ZsgknvuBg7kv9S9pJwsULGQO4Mits+bJeXfrYcViU1/dYVGNZ/JU7Rw2G6EnuLzn0g+OhtaABJuf2eddcUi3kGz6or5z034wAMBNTzl3ywKJDvLl78ajtwXCuTpn67+FTrlCljzpxQerfK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f7ca46-d65b-438b-8384-08dd8d51475c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 10:23:58.5331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0ODFN/fjHo0Sa9ELB4UCdUlQSQ3bfsddKtFvcLjh1kbTw0SoxbPSbZ85I2nT50+iXxoXeUQXXtWB23VX6NeLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6550

T24gMDcvMDUvMjAyNSAxMDo1NywgSGFucyBIb2xtYmVyZyB3cm90ZToNCj4gT24gMzAvMDQvMjAy
NSAxNjo0OSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4gT24gV2VkLCBBcHIgMzAsIDIwMjUg
YXQgMDI6NTY6MThQTSArMDIwMCwgaGNoIHdyb3RlOg0KPj4+IE9uIFR1ZSwgQXByIDI5LCAyMDI1
IGF0IDA3OjUyOjIxQU0gLTA3MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4+Pj4gQW5kIGNv
bWUgdG8gdGhpbmsgb2YgaXQsIHdlcmVuJ3QgdGhlcmUgc3VwcG9zZWQgdG8gYmUgcG1lbSBmaWxl
c3lzdGVtcw0KPj4+PiB3aGljaCB3b3VsZCBydW4gZW50aXJlbHkgb2ZmIGEgcG1lbSBjaGFyYWN0
ZXIgZGV2aWNlIGFuZCBub3QgaGF2ZSBhDQo+Pj4+IGJsb2NrIGludGVyZmFjZSBhdmFpbGFibGUg
YXQgYWxsPw0KPj4+DQo+Pj4gVGhhdCBzdXBwb3J0IG5ldmVyIG1hdGVyaWFsaXplZCwgYW5kIGlm
IGl0IGF0IHNvbWUgZG9lcyBpdCB3aWxsIG5lZWQgYQ0KPj4+IGZldyBjaGFuZ2VzIGFsbCBvdmVy
IHhmc3RldHMsIHNvIG5vIG5lZWQgdG8gd29ycnkgbm93Lg0KPj4NCj4+IEhlaCwgb2suICBJIHRo
aW5rIEknbSBvayB3aXRoIHRoaXMgdGVzdCAod2hpY2ggc3BlY2lmaWNhbGx5IHBva2VzIGF0IHJ0
DQo+PiBkZXZpY2VzKSBub3csIHNvDQo+Pg0KPj4gUmV2aWV3ZWQtYnk6ICJEYXJyaWNrIEouIFdv
bmciIDxkandvbmdAa2VybmVsLm9yZz4NCj4+DQo+PiAtLUQNCj4+DQo+Pg0KPiANCj4gSSBqdXN0
IHJlYWxpemVkIHRoYXQgd2UgbmVlZCB0byBfbm90cnVuIHRoaXMgdGVzdCB3aGVuIHdlIGhhdmUg
aW50ZXJuYWwNCj4gcnQgZGV2aWNlcywgc28gaSdsbCBzZW5kIGEgdjIgc2VwYXJhdGVseS4NCj4g
DQoNClBsZWFzZSBpZ25vcmUgbXkgY29uZnVzaW9uIGhlcmUuIFdlIGhhdmUgX3JlcXVpcmVfbG9j
YWxfZGV2aWNlIGZvciB0aGUNCnNjcmF0Y2ggcnQgZGV2IGFscmVhZHkgaW4gdGhlIHRlc3Qgc28g
d2UncmUgZ29vZC4NCg0K
