Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ECD27F754
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 08:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944212; cv=fail; b=WD7Q3g4GyIHh2atouATVP1VaXaOHgyxp7UWy9NUPGp6l0hbfvHzkoQjVZggSt1DcD0kb08l/47Svm/NEYTMkKb7amTjRTI2VhSIWFUOBHmV2xnB8DqCse5aPnerFpWDJdxKQSbW7rL39m/Qj+Mfv+Vl3g/F7JTPhE1TALEgJaBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944212; c=relaxed/simple;
	bh=wuu+2b5dOR7+QbHHMOK73fqWrRenXvjsKASjKWpIdnk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z7AO4Ag5XTQZDKAHuT7yZqUw/ZV4PoO3YZYDEX16Nq9GX5PXyzb8pDdq4nyw7AIYzEu0ijvHRAb/MyMHqGUqa58P7Rd6oTTFr3l/OdQ/Sa+3v+GFgJtculHwZEoXPXefnrgDLQRxfErP3aeWJ/boGwuK95ARPWSIbkwOlNEF9WU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BxUp0ASQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qxztMVh4; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BxUp0ASQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qxztMVh4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944209; x=1806480209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wuu+2b5dOR7+QbHHMOK73fqWrRenXvjsKASjKWpIdnk=;
  b=BxUp0ASQ+0F2gZrqTzkTZAlvnOGAAOtfZTUujo1/qXF89GsuXKoTWwPk
   ENawDeMZMhwVznm5qd/+BSWTraftaoa1ZfJajMmSbbHaWDSrowAsVNniU
   u3sLvWAV1clHhUr4ie3RUVEvQwdFKn/1PagJrUelqwpkIA4CZUqylUqOv
   cKzzFzPqv7LXPT3vbkx9gSHNdC/JRvCaPkPAA7LoBSnQctDNalbmQpogY
   t+U+hr7BBIiHImTsFpuS+B2DVicf8dOxRC0P3vxpPQGicwtLxsGHtPH0z
   CT0ouvF0oQDse5S3fndfT8zpAADSg1675LGLeDqdnaVyARexd7fLckaQ6
   A==;
X-CSE-ConnectionGUID: bTEgwpn4QraAFooDUeE58g==
X-CSE-MsgGUID: NPvj07suRRea6FmpGuUbaA==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="143585997"
Received: from mail-northcentralusazon11012067.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.67])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:03:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YddhIM5Y4NwBZZIuPNhkm4aojzRI1eXyR5SubVLaE0nnwawLcf53vUdMz3T1YySab3tpzc0Y8kQJS5gEo3ubji9s9ePiVB5Qq0Emhc7V/4xGxbQhfl+eY5CZOHJOA223mpJFkVJsRUKG6J67JKV+l5cZx9R3YfT73XD1XLj2dfVm/tE0C9PI/3asabWwFcR0ePGDYFkrVoV8LbzljBuEPqVuSJjhd6n3JTR0doC9uhvf6CSrI6d+fPUPMxe/zlPL6IIrJYn2dnStJINwl40U4G4r9zC1ADA432jbNCRUihu2GLKn5WKgHK8uwazIoFr03lgfoiWdry0ofb7x54RTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuu+2b5dOR7+QbHHMOK73fqWrRenXvjsKASjKWpIdnk=;
 b=WDWlBMsgs0/ZoRjRIVI99RM0kQ680EdfDEDh1p+bM5B6T3+hhOAatJkKkPZofNPl206GzbbIlkfd/H7/X2r6q9Fr3SHOi2S60Peph+WM5bFgs01+od6RztwoNwjuSu60h8H4F6TwooPr4ZL7t3nj9i4s1ff+/+haVd7umVGJKpJlNTEEGL/2Y5Wwd1rDPUv7paCVzK+weRxbnII7RSGheDXnnxA4nTz2jlWMMJe2S3Y1CMScmlaHMWeebqztbh/KD8wpSUIZK03pvx59PmoEv1wI0T1wWMWi0t3Id0AdK3HUR23eR8evl9XCqshtiiDQGNxHvSU9bmfJKZjVb47g6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuu+2b5dOR7+QbHHMOK73fqWrRenXvjsKASjKWpIdnk=;
 b=qxztMVh46GhU8jzvIELBfYCQWAH8EYo7grLKBKqQqHviNjW8eTpycB36rlw73w/MW5f0RKVuBhtFJXhp5o9vIlxvmz3UCpnhn5PRKVY6h4YPzQkRpT7j85seapJMHPW8dI64osgckEDUrDB3OmWQBJNLRigf7AS31WiwkLJdci8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DS0PR04MB8599.namprd04.prod.outlook.com (2603:10b6:8:128::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.23; Tue, 31 Mar
 2026 08:03:27 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:03:26 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] xfs: delay opening the GC zone
Thread-Topic: [PATCH 1/7] xfs: delay opening the GC zone
Thread-Index: AQHcwAh446sLpxcvbkiPZbeAYgpCB7XISaKA
Date: Tue, 31 Mar 2026 08:03:26 +0000
Message-ID: <37a95bca-e146-40bb-ae77-e6522a295fe3@wdc.com>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-2-hch@lst.de>
In-Reply-To: <20260330054533.3856339-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DS0PR04MB8599:EE_
x-ms-office365-filtering-correlation-id: 9d8e159c-c5a3-4dd1-2d5b-08de8efbfcd1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 kmJFuMPtRtGS41vEx44VHD094a2/9YBry0OcJAuxJ9ad83CO7fMX4GrPGZP7vBeWmOc24ZzvA8BMgpElO/iJNko+EwceP/sVd6/qAlCLT+LZCnzD3jvgAybCCU6bvoq16AprdGcP3e5MQIKR8F+9Jg23qW81Cls4S4i828Ip5zvM6HUyka2jHCQ+MW0WcAWMJY17xFokZ/JytpLDGtkKA191tuekxT6dDGNiwUjKu5ig1YysNCYEB2QPsH5zkxPikPOZ3lt/94iedUSP20w5Rlh2lzDvezpczDYaIZc6+YGoaXy9KfVdkbiHYH1zzxPuZd5scGuXfoiiMnBf7TuiZt40hLFxJ7GcBho4cevjtPNhc2xdhIWtv/xztAJ52neUIoAU1x5W6MnJOWqA+av6mbxgm2JcsAbAioIeOb6Faf8hAlCKWWuNbUGFkuGRTLRICTjOkkO3EQ7ubKVDMd4wn01M3NaPNKfsuiiMCiL8Eubx5nCpV/timm0OVhgRayfu16ooh5+5NMIpZJcTid0RyqZvQ/xtgQS5F3x/Ug0jt3AZn3U3nYpV+unDc9be+lqE2zjeT44aR68hAKg8wy67hxdcw20u+PM4L1tBBDWpYaduHieVdrXXj3cJ6y0dAhLn9Ucf4/cf46tR107n4TZAWhTOrxkkGbA5mB/qE+qz3nmTukC5KW8QnHONHZNXELm427LFXRprzvQ4W5G/ThR3E+8LtqApaWFVac/X4RnCCnljKLgpHOe9TIYSe7N46hNULPtZ/tatVil2VAO7bQVoknC7Ej7nvlL6c5LS4uqK5dA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NkJqbXZ6UmIrcEdEUks5Z1g4QjBteUpqckZVdGFuV09qVDdYYUZPZWQ1KzVx?=
 =?utf-8?B?bmRIaGZZRGtUSFRGYWczQkdQb2hmYlpISUJPdzd0SG42QXZMTlpDR2hUSmMx?=
 =?utf-8?B?M0Y5VjRad2VnZmUzS3p0bTluSUUwWTBqWkwwM3BJN2Y3Q0dkQitobUk4ODhK?=
 =?utf-8?B?RHcwOTVNM0pSZ3NDM2JuL3ZzZExOQ2M5bEM3cEhZQ0hMcnF4c1FDRnNERVJ5?=
 =?utf-8?B?eW0wMGpnTFplZklDZEo0R3p1ZnQ3clAxb2Y0Y3owSTFWZ2tUUXE2VWFJNzU1?=
 =?utf-8?B?R29vc3UyellBSGxHVGFaY2ZLOExITDdGUiszSzBWMzJ3MmZHY1FOTHhtSVBP?=
 =?utf-8?B?MnBDYjR2YVpXQVJudkYydEdadTUyempmaTZhZDZVY3JRTTFES2hxbi9WZGZ4?=
 =?utf-8?B?QlY0NDFnUFVQenRUMXAxalppVFFyQktoUnR0SXBXVW50MzZPZGd5V3YxOHg5?=
 =?utf-8?B?SC9qUkVBOVROei9pK2RRcU5SWWo2RU02VEwwMEZ2MFM4czUrTUZTdzNyS2Ro?=
 =?utf-8?B?Ykpvb0RWcWJJRytxa2kyNzNBdFk4alFSa1RFY3JlRmlRNWRBTVp6cFNqWG5u?=
 =?utf-8?B?cHpHTEp5YTlrY1ZFbm9BdGNlZXo4bWR4eFJKZTlzeXcwcEZYaVpVTjIzREQ0?=
 =?utf-8?B?R0kzK1Y1c2pMcHJ3bXZUSlY0Q2tSNU5PRHBkejFOWWZBNHVNUXRQK0VZRHh0?=
 =?utf-8?B?TnhjWVE0RUI1MFZSemE4Yzc2VWhkTkpJdVJTQ05YTllaWmwxVVNsVXVQalJO?=
 =?utf-8?B?V2IzSVR5UCt0K2l5d0ZEdGhWRWhNdGlXRkJMSzZJUnQwVXlPYy9Wc0R2NHk5?=
 =?utf-8?B?MjA5NkRVbkVkcGF4aEhTcDhPaGY2K09wOG4xcWJyTWFnUWl0OGE1Ly8xK28r?=
 =?utf-8?B?aVBhSUg1VFFVQTh5UHBKL2VCQWdiRmJmaUYzT0pIaUJIajdkWURoU2dnWkEr?=
 =?utf-8?B?UFdwckVjSFcrLzlpWXR3VUpVZ3BEa3B6QTJxcGp0TlFwTVlsZ0VsdjFhcit0?=
 =?utf-8?B?ZzRKTWhiRDlqL0FJNkZIa21TaG4vRWw3ZGc5QUNKTmJ4bTFHdVQ5MFI3RWFl?=
 =?utf-8?B?Sk9oeGpvNWRTRG1JUXNPZlVZWCs4VER2K0xFOXJhVWlWSU1BMHlLaWlCYnZ4?=
 =?utf-8?B?cU54Ty9FZDRoVjVXRGE5ckROMkZLNUh4WkJaQ3puQkxBQU1EUGJ5U3R3QW16?=
 =?utf-8?B?YTRJWlZnZ1JReEhEMTYxdVhxZHZwUmlQWUVLNnRMdHdXK0VJTkVZMU0wakVS?=
 =?utf-8?B?YjA4YStBUVhXbzZUMUJjT1VLamtVTy8wL3Ftd1FYL3Fic3ZYVGpsT2ppbWJB?=
 =?utf-8?B?eVgzcUxNQkVudUZGMWhoTnRhQmlNZldxSnhFMG42Z0V3UnRwZTNWV0l5d2hH?=
 =?utf-8?B?S3hqbGZtbExnSXFLZFB2cUtydzE0Yk9EY245M05yUjBqTktUMURjZHJYRjRU?=
 =?utf-8?B?UTl1OTZTVHlkRjlSRU82UlNQTFhGQU9GTU9yZHRSeTBFbzh6Y0EyUlVneFBa?=
 =?utf-8?B?NExkUlJlZ2pyd2pwcXY1TW9pcW5ySlhEMVl6MHAxQVdhdG01aDdQT1RVMThQ?=
 =?utf-8?B?Qmp3VFcyeWRUdnNBSEdlcmV1YTd1eDV6U1U1OUFNVlBsYW54V2hXL0doU3R0?=
 =?utf-8?B?bnFFcDNaOUw0OUxUVlVEeWh0MklwRzViZzNBRnorekFCRU42V3RCYmlXdVhs?=
 =?utf-8?B?M2plcm1YeWRITUEvVlVpT2lGUXhQS2NkYUdlY1kvR04zRHo3UXJJUVNKT0cr?=
 =?utf-8?B?aHJZY3ZSMlJ3NFNRMzV0R3A3eWNUd0tNSlh4bXRVSmtqSXBoMWFHQWtnQXVE?=
 =?utf-8?B?N0hxODJqTDU5aGN5R1RJNk9xeUFjdUZwZGdhcmhBamRXUnFidTF2dXJvbGlp?=
 =?utf-8?B?eklwTDVoYTBqdUc3ZUlOL05KTnk1T051RzU1bk5ReXNTRHRTTFZnZkc3Skhl?=
 =?utf-8?B?TzV4UDJZN1BaYUNWWCt1WWRhUmN6dWVLZ05abW1iKzYyU0NMZzYwaVI0czJY?=
 =?utf-8?B?bStQVWNTSXY4RnQyN25WbW9tQnN5eks0NHhWdlpLVkROa3JTZm1EWmdXS3pP?=
 =?utf-8?B?dG9lRG1xRUF1bTVDWGVSdVQzb090M2RCTWI3RnJmQnAyZVVpNi9qbWM2ZkFk?=
 =?utf-8?B?T0tGdlBHeW14bkhqbVo2bU01b04vSHUvWHE0cndQSmFyQ1g3RnNzSEszaUJr?=
 =?utf-8?B?ejhZY2NOZ294UzhnMndTWjlZS1ZSc1VsS2RFM1htQnd2WkNZNTB4WnNQdVR3?=
 =?utf-8?B?OEh3S0tkV0VQSGNRSUNObHZaekNQKytQWnNoZWxOUENuTHZWRjQzdXpHYk00?=
 =?utf-8?B?MXJ2ek1MZndHRVRzenBMNG53d3pJUFVOTW1Za01INStxT3VSdCtydz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97F1F92972EB304AAB6398035245AEF1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	qOGbxhQAk/xBMNOWBWtbQ/fO0pDEINUTwYuiqHQlePkWe9NTJXDa27NJPfTLXUVo3Jzis+oSspkjtAp+NGVhfD2RwKXzQflQJkPlUzIpGwLSnSphHSZ2askicvX3QhPcTVfKV8WpgdrJ9Zzf/aQwoFvgkBR/KUnMo/yBuvanhVja9kfDq/AHKtFU62Ef9gfKdfygzIXp2Gw4rS29tiTgj3VDFL1nX7yss4ev105m+WGAMa8g4Wgb51Nb9ZIwFgP+LR8T2oRGz/qEKKt9Nb5I1FGda+wWDv1lpFxV4NPS2KPpzjJidqYDJnkfexgZVTUhWOkAiCwktPCC9AnfUI3l6A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AsYTBrTbdbffOjf78NKEYpTSXUZsX1LLKrtOOxYws47CQI+FjVjr0ssmZQAdSRSIs3CLvt9vLlloAqod49D3fJcg260oPvTgzWvtx2XcCaH4765VqJS5p3SPSOJfKPz6pWKKmzjg47gxcG4Js35ZGt8S262ycNg74lhhDePj+ylLhT/DoKL+B9lU1PralFH4guaFONtMFnqJtmvxq4fSOuEFjop907wmrE4Gv5wrzX24TuSSzCxW8euncwTAgBKUBOqTRpndkzzav4wju3CqgfVtCR8AJEDM2l4/MJX7qYJu2R1wRYSRcObEMCaAcfKAcTAb9T5g3+71wVTgYOAeeXFrxQsby3qeSrsuV9BA6RCNdxBLIPVgz7iGbYOrZqV7fonkYt7uvWFiQa5DxvA0EhDzVBWnMdU2JYxEkocK/VlQznSHdwKY2WJcwtADwOAv0eqhhT0IvwxFqnEKE9B4A7qX3WvuUj7mmhH5BN5+29sjvKaRbYQowkXJbpkFd4FSnWS6xPzj9BVjiDrUXXR0uCNbFvwBVcnOfoRjjtq0N76CpfqjK8ltqSCW3vHIhABLL8U58lAYirdyInjAHpdNDSQXLRKdRk71s5N0ZKSY+3a81Ka5Dz4k01SMB7Jo6b1E
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8e159c-c5a3-4dd1-2d5b-08de8efbfcd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 08:03:26.2187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QFaqNUfKXAW2UKSHIPgM/Ot9f6i+aESPntmUK+Mn99c5GVZ+hDHjE8Tg/EOh5YleU2JGymSIJQYtS9HthKujEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8599

T24gMzAvMDMvMjAyNiAwNzo0NSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoZSBjb2Rl
IHRoYXQgc2VsZWN0cyBhIG5ldyBHQyB6b25lIHdoZW4gdGhlIHByZXZpb3VzIG9uZSBpcyBmdWxs
IGFsc28NCj4gaGFuZGxlcyBhIHpvbmUgbm90IGJlaW5nIHNldCBhdCBhbGwuICBNYWtlIHVzZSBv
ZiB0aGF0IHRvIHNpbXBsaWZ5IHRoZQ0KPiBsb2dpYyBpbiB4ZnNfem9uZV9nY19tb3VudC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0N
Cj4gIGZzL3hmcy94ZnNfem9uZV9nYy5jIHwgNDUgKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCAy
NSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3pvbmVfZ2MuYyBi
L2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGluZGV4IDBmZjcxMGZhMGVlNy4uZjA3NmY2NmM1ZDU3
IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiArKysgYi9mcy94ZnMveGZz
X3pvbmVfZ2MuYw0KPiBAQCAtNTI3LDcgKzUyNyw3IEBAIHhmc196b25lX2djX3NlbGVjdF92aWN0
aW0oDQo+ICAJcmV0dXJuIHRydWU7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBzdHJ1Y3QgeGZzX29w
ZW5fem9uZSAqDQo+ICtzdGF0aWMgaW50DQo+ICB4ZnNfem9uZV9nY19zdGVhbF9vcGVuKA0KPiAg
CXN0cnVjdCB4ZnNfem9uZV9pbmZvCSp6aSkNCj4gIHsNCj4gQEAgLTUzOCwxNSArNTM4LDE4IEBA
IHhmc196b25lX2djX3N0ZWFsX29wZW4oDQo+ICAJCWlmICghZm91bmQgfHwgb3otPm96X2FsbG9j
YXRlZCA8IGZvdW5kLT5vel9hbGxvY2F0ZWQpDQo+ICAJCQlmb3VuZCA9IG96Ow0KPiAgCX0NCj4g
LQ0KPiAtCWlmIChmb3VuZCkgew0KPiAtCQlmb3VuZC0+b3pfaXNfZ2MgPSB0cnVlOw0KPiAtCQls
aXN0X2RlbF9pbml0KCZmb3VuZC0+b3pfZW50cnkpOw0KPiAtCQl6aS0+emlfbnJfb3Blbl96b25l
cy0tOw0KPiArCWlmICghZm91bmQpIHsNCj4gKwkJc3Bpbl91bmxvY2soJnppLT56aV9vcGVuX3pv
bmVzX2xvY2spOw0KPiArCQlyZXR1cm4gLUVJTzsNCj4gIAl9DQo+ICANCj4gKwl0cmFjZV94ZnNf
em9uZV9nY190YXJnZXRfb3BlbmVkKGZvdW5kLT5vel9ydGcpOw0KPiArCWZvdW5kLT5vel9pc19n
YyA9IHRydWU7DQo+ICsJbGlzdF9kZWxfaW5pdCgmZm91bmQtPm96X2VudHJ5KTsNCj4gKwl6aS0+
emlfbnJfb3Blbl96b25lcy0tOw0KPiArCXppLT56aV9vcGVuX2djX3pvbmUgPSBmb3VuZDsNCj4g
IAlzcGluX3VubG9jaygmemktPnppX29wZW5fem9uZXNfbG9jayk7DQo+IC0JcmV0dXJuIGZvdW5k
Ow0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgc3RydWN0IHhmc19vcGVuX3pv
bmUgKg0KPiBAQCAtMTE3NywzMSArMTE4MCwyNCBAQCB4ZnNfem9uZV9nY19tb3VudCgNCj4gIHsN
Cj4gIAlzdHJ1Y3QgeGZzX3pvbmVfaW5mbwkqemkgPSBtcC0+bV96b25lX2luZm87DQo+ICAJc3Ry
dWN0IHhmc196b25lX2djX2RhdGEJKmRhdGE7DQo+IC0Jc3RydWN0IHhmc19vcGVuX3pvbmUJKm96
Ow0KPiAgCWludAkJCWVycm9yOw0KPiAgDQo+ICAJLyoNCj4gLQkgKiBJZiB0aGVyZSBhcmUgbm8g
ZnJlZSB6b25lcyBhdmFpbGFibGUgZm9yIEdDLCBwaWNrIHRoZSBvcGVuIHpvbmUgd2l0aA0KPiAr
CSAqIElmIHRoZXJlIGFyZSBubyBmcmVlIHpvbmVzIGF2YWlsYWJsZSBmb3IgR0MsIG9yIHRoZSBu
dW1iZXIgb2Ygb3Blbg0KPiArCSAqIHpvbmVzIGhhcyByZWFjaGVkIHRoZSBvcGVuIHpvbmUgbGlt
aXQsIHBpY2sgdGhlIG9wZW4gem9uZSB3aXRoDQo+ICAJICogdGhlIGxlYXN0IHVzZWQgc3BhY2Ug
dG8gR0MgaW50by4gIFRoaXMgc2hvdWxkIG9ubHkgaGFwcGVuIGFmdGVyIGFuDQo+IC0JICogdW5j
bGVhbiBzaHV0ZG93biBuZWFyIEVOT1NQQyB3aGlsZSBHQyB3YXMgb25nb2luZy4NCj4gLQkgKg0K
PiAtCSAqIFdlIGFsc28gbmVlZCB0byBkbyB0aGlzIGZvciB0aGUgZmlyc3QgZ2Mgem9uZSBhbGxv
Y2F0aW9uIGlmIHdlDQo+IC0JICogdW5tb3VudGVkIHdoaWxlIGF0IHRoZSBvcGVuIGxpbWl0Lg0K
PiArCSAqIHVuY2xlYW4gc2h1dGRvd24gd2hpbGUgR0Mgd2FzIG9uZ29pbmcuICBPdGhlcndpc2Ug
YSBHQyB6b25lIHdpbGwNCj4gKwkgKiBiZSBzZWxlY3RlZCBmcm9tIHRoZSBmcmVlIHpvbmUgcG9v
bCBvbiBkZW1hbmQuDQo+ICAJICovDQo+ICAJaWYgKCF4ZnNfZ3JvdXBfbWFya2VkKG1wLCBYR19U
WVBFX1JURywgWEZTX1JUR19GUkVFKSB8fA0KPiAtCSAgICB6aS0+emlfbnJfb3Blbl96b25lcyA9
PSBtcC0+bV9tYXhfb3Blbl96b25lcykNCj4gLQkJb3ogPSB4ZnNfem9uZV9nY19zdGVhbF9vcGVu
KHppKTsNCj4gLQllbHNlDQo+IC0JCW96ID0geGZzX29wZW5fem9uZShtcCwgV1JJVEVfTElGRV9O
T1RfU0VULCB0cnVlKTsNCj4gLQlpZiAoIW96KSB7DQo+IC0JCXhmc193YXJuKG1wLCAidW5hYmxl
IHRvIGFsbG9jYXRlIGEgem9uZSBmb3IgZ2MiKTsNCj4gLQkJZXJyb3IgPSAtRUlPOw0KPiAtCQln
b3RvIG91dDsNCj4gKwkgICAgemktPnppX25yX29wZW5fem9uZXMgPj0gbXAtPm1fbWF4X29wZW5f
em9uZXMpIHsNCj4gKwkJZXJyb3IgPSB4ZnNfem9uZV9nY19zdGVhbF9vcGVuKHppKTsNCj4gKwkJ
aWYgKGVycm9yKSB7DQo+ICsJCQl4ZnNfd2FybihtcCwgInVuYWJsZSB0byBzdGVhbCBhbiBvcGVu
IHpvbmUgZm9yIGdjIik7DQo+ICsJCQlyZXR1cm4gZXJyb3I7DQo+ICsJCX0NCj4gIAl9DQo+ICAN
Cj4gLQl0cmFjZV94ZnNfem9uZV9nY190YXJnZXRfb3BlbmVkKG96LT5vel9ydGcpOw0KPiAtCXpp
LT56aV9vcGVuX2djX3pvbmUgPSBvejsNCj4gLQ0KPiAgCWRhdGEgPSB4ZnNfem9uZV9nY19kYXRh
X2FsbG9jKG1wKTsNCj4gIAlpZiAoIWRhdGEpIHsNCj4gIAkJZXJyb3IgPSAtRU5PTUVNOw0KPiBA
QCAtMTIyNCw3ICsxMjIwLDYgQEAgeGZzX3pvbmVfZ2NfbW91bnQoDQo+ICAJa2ZyZWUoZGF0YSk7
DQo+ICBvdXRfcHV0X2djX3pvbmU6DQo+ICAJeGZzX29wZW5fem9uZV9wdXQoemktPnppX29wZW5f
Z2Nfem9uZSk7DQo+IC1vdXQ6DQo+ICAJcmV0dXJuIGVycm9yOw0KPiAgfQ0KPiAgDQoNCkxvb2tz
IGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5j
b20+DQo=
