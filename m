Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4A52D8DC2;
	Fri, 27 Feb 2026 05:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772169410; cv=fail; b=TFXhk02xFIKgGen4JTP4u4m8g5eMcUc9+cmMummyvcNxSD/y+X2shAEcHpXOcXF84y3LlgP73+tkuz8OyvVrsz9EphbbJJGeyW+8aj3KcZR8k96lCpbVB20KWTuFGVYqVJhIf7jhLaJZz5ATs/frwU5NGDkX1uW2l7K1G48hbXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772169410; c=relaxed/simple;
	bh=3OCvS2AtBMyVfcUlOi53yzynPaWM0d8jo4LlPKZ/EXI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VHTQeGshRk9a8xRuRgCI+0+jZHB78GaoETHc6J/jFLSy5bSv/EATDHm0ZiRwth/ZNFJE7EroQ30j2duy3jg/pFJ3Bpts9K0MQX/VrzZBd7grZOSESgi3bToRdjF1HpZUy/2Lrg63MKHrqNBJytF58SWERpvbC+tm8H9k9R2Mayg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Et7hIra1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q7kcXwL+; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Et7hIra1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q7kcXwL+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1772169409; x=1803705409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3OCvS2AtBMyVfcUlOi53yzynPaWM0d8jo4LlPKZ/EXI=;
  b=Et7hIra1SoGXVtgEETZZZDrvcz9KQDJbvKX+rqGetLowtXjZSf+1l//Q
   eojXC85vtgdL11YLufllLpWZ09ACaZ5BbWh5SLcED7lpW1p7oUQTuM3yX
   QGWfzaFxLVNkApClM/WDsZNlIOua0CuowHk1XqRhiDk36a+uFOaPcWq4O
   bvgr+lfO9mtpz3I9LroNA2ESzEsRfPt/OwgAIq6uscXDi++mVNLXP8w7C
   Kf9xjvbuhIKAYD1PrinAjvDS1JMtL/MkJtYn4pHKCrHgu5zhtBz2j9Au1
   jmLd7NY/hqLIYHI5DSyvXrq14HFRu8rXOdoVKAjeVmICSaxStd6wkX7Ti
   g==;
X-CSE-ConnectionGUID: FxQqluEyTpCTH7DI3DUfhg==
X-CSE-MsgGUID: l0ej1EdXTie8CH9j8gKwtw==
X-IronPort-AV: E=Sophos;i="6.21,313,1763395200"; 
   d="scan'208";a="141570442"
Received: from mail-westus3azon11010028.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Feb 2026 13:16:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P2Mf7OnMyVcdFn9GE0Dt01ySqv4uFiDtVWz9k9kCOjVk38npxOCM4TR3OlfeXTctXrHPx8q7hvdNSMRr7p0drFjsbnDm+5Max2SZE7EUHfXrXP6ezko2jtvdu6aRoQiP91wddDHrYCLOjsfZCLfzX5hMsRyLwu2wjBbYFIZ+FR+AlUfWhnOygLjv1xRgOESuYhGJR7zVYGsV6YxqojIzZWgolOut30FI00wS2G1GGPjNuUikGDU7eqbNOutIjdTEQsT1VMgNTtO1FbTLB3oWIU7uzcdUtcNwKml2KCjYRHudH+J9AA4nzuKxMJbP5R00GnW0JUDrfSMNrYqBf/qFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OCvS2AtBMyVfcUlOi53yzynPaWM0d8jo4LlPKZ/EXI=;
 b=GVsP4ldYsfEcjjUhz1plFXg/vQx2AfA/fLi294ozaunyPoEkN2DR0girku/1d7dY3HD6AtSQYrVkx4kcDiBKRxD/4GQ6eb7lg0vHvdWBTL9E4vqZO2uU1lEcmDHBgT9vrhfex967fgGMJvV/+iDdWntmGnsJ298LsXPezG3dAmEoiOrYP5Z+nQ+t8eJ4DcLTNN7GBcLq3INxHQwiMGIrMy1GaB6+yzC6f6VtMoxNLtkqu0JOj0/gJUdToBG2RIFdwVl7r5peIiiAC237z8Cd8fouyIgMIdmkoja+kXDErV1P9+oyI4F4ZsHiSLVoacwe7PEidSrOONHUUnOpEsqObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OCvS2AtBMyVfcUlOi53yzynPaWM0d8jo4LlPKZ/EXI=;
 b=q7kcXwL+ISIt6JuaieFE9GO6PVC+qhBgBwvtiHh52YchL8VDmfR3XVh5QaF+wpLz7XOHdo4gHMieZQtZSyRCj7xncv3cDMmTfohCe8tJMGCPy977wF6FpJMyWmrD9ilhlrBeM+fv+qhwExBSmBDYmhbsPvkj1nVAjznjKSaRJbk=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by SN4PR04MB8351.namprd04.prod.outlook.com (2603:10b6:806:1ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Fri, 27 Feb
 2026 05:16:39 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9632.010; Fri, 27 Feb 2026
 05:16:39 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "djwong@kernel.org" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add write pointer to xfs_rtgroup_geometry
Thread-Topic: [PATCH] xfs: add write pointer to xfs_rtgroup_geometry
Thread-Index: AQHcp5WJ2XXUEJYJZkunEuzt1q099LWV7a6AgAATpgA=
Date: Fri, 27 Feb 2026 05:16:39 +0000
Message-ID: <dbda17987ff33a132da82b8635ac2a5c6ae01c78.camel@wdc.com>
References: <20260227030105.822728-2-wilfred.opensource@gmail.com>
	 <20260227040619.GI13853@frogsfrogsfrogs>
In-Reply-To: <20260227040619.GI13853@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|SN4PR04MB8351:EE_
x-ms-office365-filtering-correlation-id: 2a23e9a7-13ea-49c4-492c-08de75bf631e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 +fzP5mXktNnDHP3s3O32os11zZmZvVhthmgNVEKd+FRld2vBJPinG0zLuzGPkj93rmOnzGayLCSFpqZIEP3eyUytSGx9waFW1JpshjVyRIeN4EAEi02lPlKdWPo62wR5TEhbfAbacPQ8UOkyF/vrwz6XJZp/QBJa/GwBd2OTv3lduFobINtp7zXxJWrTzP/tbKDoQnknr4NuuyWROpbS5H7L12S+erIcmQu9no4AUyZCiLAUvg55/RJIVv89VTqqEdjsdFZh8kuuJqHiC+hNkFI1K86IkW9ykLPtCLDMNjRfu2wcaSDOB5kVspZJ+Tf3mFFv4YtdLIIn/qzy9Uv/UMviFIvQxr+9t1YWTn0PFaGJdjzreIsT0N9zs/MlXlNNtxeiu2GsOqiulZm3lynzNkN2HtkBCrEKEf74cY6TXXWj+DvKalBmAtNcWzlIbk4rBPkSTAmziNyVJhGvhvt/+hyfTh4kFj4nrxup3xG20fm5+gsWa5pDwhBOPtrkZAa3vCSAv6JTnDlzT2dojdIH7dVHbWpolCfr5Hi2fA1wQQ1w1tuMhmrg95a+ScJrKFqJnXukxb8eFgNsQexUeLqIwD4qnyGvK2IW53X9LB0mJVFOLrRhDm0+5sLTqv5EPZaBCsZhUgEu5/nfnKj7s9heGxmRVkPQin9qWokcylzItzEmsftbuaNP3xL5Pwnt22rpnH0iuchxFcNPJddXAt7fB5nd/RJ2+oYFT9NSMrAwz7jWMQvRj0omk7k8/I2rp1RU
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXF0a3IxWnliTHBJcmtjWnNkZ3R6ejZlU3VJSS9YcjM1Vm1nUW1mdTVGbmxJ?=
 =?utf-8?B?UDU4NC9NVHIxWWxOYlNQclFrdnM5UUk3aThacCt1VGx1UWNsaGNNUHdmcGNF?=
 =?utf-8?B?SEhQSUxQZjZ5ZklnRmZxMjNKemFvTFpkY2hLRUV3eEFHSktkdTZJcGlJUjQ4?=
 =?utf-8?B?eVIyS2V2VFJBMDBBM0h5UTVTYWw0K29JM0dEOVpWQjRMU1F3Qkh6bUxpbGs5?=
 =?utf-8?B?QVVmdUd0eVoxWmprWTNLK1diWFdzenZEQXY5Qk9wODU0OExlZmxacmdUMmdy?=
 =?utf-8?B?ektzcHJRMUczUzd0dlZoVElFRDFBSXZEb1dPOGxGNUJnTi91alZJRDVjQ3Ru?=
 =?utf-8?B?cDRuVlczRHJWeUtSb2tTcEFBb3p0eWx6VE8vK2ZISmsxTkNFNTZaVlBVVVBM?=
 =?utf-8?B?aERscFR4SGNUQzFEWkd4UFBRZC9qa2hXa05tbnFMMnJsVzBEbXU0MnpJc04y?=
 =?utf-8?B?UVlxWDhVV1dBbnd5eDNhMWRYR2QzNUN4dUFkeGpLYitTRG9yQUNaZVBVMjdQ?=
 =?utf-8?B?UVY5aTdOVlU5aHZPUWtqQjUwZWFsSFBjd1ZGNkZhQzM0S25tZks1NVNKcHRP?=
 =?utf-8?B?RXF2VnVzWVpGNGxVQVNESnMzZDcwOGZMT3UxWjQ0ODF5NzBDMHRpYUVnRE12?=
 =?utf-8?B?dkwzY1VWY2JramYwRnBFTmIxV1BRTjJYWWhOL0tOVUNRWGdtQlpFelFISytZ?=
 =?utf-8?B?dFUxNExMalJpaG9DNUVsWFBJTkU5QldpTEJjRWxmUWRWM1YvLzA2SUswREhv?=
 =?utf-8?B?d01UWXpKbHFwUmV2dG81RXJ5M0N2Yzl3RGltcUVEVW03bFI2QjFZazlicklN?=
 =?utf-8?B?QkNPZ1RHejUvMC9jVHpRa3BmZTlEMml0dFZ5aUx3dlpsMGYyc3h1NWhpWWVs?=
 =?utf-8?B?QjQrd0JpS1NJWG1FUTg1VU1jdjJMZHBhaWJPV1ZNNGVUT2o5TFZydURUZHRL?=
 =?utf-8?B?M3pTeVAzTU1oUlhoNVFWZ1RMTVBJSmRqdVVGMmZkbzVWa3JyRm5pSW4yRUFN?=
 =?utf-8?B?RzZnNVBjSEE4emNjUVE3QVdobUI3djFJdnVISWorejA1VzE3NmV5SERiUFp3?=
 =?utf-8?B?MjNBWkJSNUFGZmJKVjBjclF2QzJ1ZTlhbEx0WjNpeXRaQ25OWTlKY3AweFFU?=
 =?utf-8?B?NVAvOGhLc1hxTW5pdUYvZjhtMmhTaHAydTZmbGRkZUdoSDRSWlJlYUZ1WHlC?=
 =?utf-8?B?WkhoZHRhWEZmQmhtQUZrUzZmZGNsWjVFblliMGVZWDI2K0IwQmtNaDVvTEhv?=
 =?utf-8?B?L2EwaS9VR09od05iVkpvVko4TTA3Z2liWkhuQjlNZG5IQVhBRU9QTjgycFly?=
 =?utf-8?B?bU1zTFdYK1RUV3QyaVVlaXhDamt1aGdjanc0ZzR2RDYrWkd4a2EyRWk4ZTlX?=
 =?utf-8?B?bHNSbStPYTcxVDUvdlJuWXhYVHFEc09KMzhWVGFtUGVSVjJNUDRBdFZJNi9X?=
 =?utf-8?B?L2Z1RkVzUFRsMnVXWHFKTGJDRGpyUEJpSk5ISGRCRFJGRnNqWDVYK2gxWkY3?=
 =?utf-8?B?VzV0aVRScHVhUzd4RC9JT2cyN0xieE9VN2FSeW9DQVpKcC9oS2tMZVVmKzBN?=
 =?utf-8?B?ckNDcmdXcGQxQVA0S2ljY0JScVI4ZjVhTkllMkxlNlJSNU9xeDNGdnBVbGJi?=
 =?utf-8?B?UUxNcFdWK1R4ZGN0VWhKRW82dTFUazJKSmVXeFJveGdocHh6WElMNTJGSmpB?=
 =?utf-8?B?d3lnZUlqZFY0cGU2VnFxc0pVaUhuWE5iSXh3ZVpoSndGWGdDdklVVll0bDMw?=
 =?utf-8?B?ZVZKcTFGMDN2bHhXTzlpeXNmWHA1N3ZhZVRhbGgwMFdMSy9RanI1cnlIejRk?=
 =?utf-8?B?UFprdDB4QU5qaE8xdnQ0TXVXREUvbGlIYThpNVBLcFU1SFhvNCtScWVibVBT?=
 =?utf-8?B?aldOczdmWStJWXAyL1ROdUJKOU1XYklEdk40Qkx5eTF3M1BhR1FZTWowNDdH?=
 =?utf-8?B?VWVwTVhjZUVRTGIzc3J5Qk9iUUNJeUkzcjBrbExtTkM1TGJxREtvQUYxWEdV?=
 =?utf-8?B?YTgzeE4wU2ZkSHhoNXRPaGVlQnluSTVadk1xMzQzaEY3dXpjRitzcmduRkFP?=
 =?utf-8?B?am5JWHRYdjN6YTlIWFh6REZXUjRHSjNtSG1Camw3cDF6VmpGWU04UU9zOWds?=
 =?utf-8?B?NzV5VEk2Vmt3SHhwZkNwcTAwa2NoTWVFSi91VFZLcnYydG9Tcy9HdWN2MWp4?=
 =?utf-8?B?bUM3Qy9QZGZoVFFaN3FKcHFCRU9iUlJjVlh6TjJtN3JuZk1WU1JyUnNHL01t?=
 =?utf-8?B?NzUxc1VlL21uSGMzWU8xejR5Zy9FUlpUN081bXh6Rmd5cXJad1VnMkJtakZm?=
 =?utf-8?B?enFHQ1JqcDdieHA2eWdJZ1U5YXZKcDkvRHI2blZCcmtwWVpucDlVUTdCWFZy?=
 =?utf-8?Q?aTg/aEiC9eDrbYkY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9A0786DFBB1224588B395EFFB9D81D9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gDxpfueteuOS+DVZBXa80Qnkcpqy/sgTczD1tWWmpYD8PP0bW5FHOcoUvhc6QHZz5t2VOBD+wmhXO04pDWxws07SoveOZ/f2p1DYSE57Ls+sAryAF2jzhn+PH1H/OIJOiHyTjyg1JSJDumRFTQgdAFcyxFl/KBJNb1IufWVk3KcpluVl6GiBFvWR0OVQyq3iQMC1LpvJU/yeYRb/hkWwzTIqINqU0xOxlhzWUPkDbV/YFM/cmUKZRaZ39w6bvbvLW7qU/vJdKQ1BzanhlXqqUUuCFZR2MnyLUbkWiIVlzA/UPTm9G9Kto6CJqpZ5QCyvnfp2rmwnM3F0UAaRTsy8fGi/LldrfT6WFb/RXTVg1mAvt4e6NV75XJVBAZlHXByXdOL5OrtF+1gI2lvTQ6oR3AWQaglrVqlu15Jig2NJhJBs2BSAwuCCh/UKk76I9b3zFzEqwz5aGLMrXV06d68ChlWTEtBln9OUja9ANlP0b8OnWm1gNJ2Z5BaDausNZmHXRY21E9W4mbVCLewHqlg+JtvY9PuqznqnJkH9/TCNj1qouLAhvaZnr+aG6WDSp6M6oRkbBYerdshVgABJCUOwxwPlMEJBhJrC72uNego4x8DA04L/PG7YevpX6UHpQr5+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a23e9a7-13ea-49c4-492c-08de75bf631e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2026 05:16:39.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKxqm30U9/q8UP2huh3pQb+OS1QcXqQVoqfMnDeZAzwfuZ37pmuQg8NDwWBm9j3w9L5KO4fSd0Mq6ui0PtFfNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR04MB8351

W3NuaXBdDQo+ID4gWzFdIGh0dHBzOi8vbHduLm5ldC9BcnRpY2xlcy8xMDU5MzY0Lw0KPiA+IFNp
Z25lZC1vZmYtYnk6IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxsYXdhQHdkYy5jb20+DQo+
ID4gLS0tDQo+ID4gwqBmcy94ZnMvbGlieGZzL3hmc19mcy5oIHzCoCA2ICsrKysrLQ0KPiA+IMKg
ZnMveGZzL3hmc19pb2N0bC5jwqDCoMKgwqAgfCAyMCArKysrKysrKysrKysrKysrKysrKw0KPiA+
IMKgMiBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4g
DQo+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2ZzLmggYi9mcy94ZnMvbGlieGZz
L3hmc19mcy5oDQo+ID4gaW5kZXggZDE2NWRlNjA3ZDE3Li5jYTYzYWU2N2YxNmMgMTAwNjQ0DQo+
ID4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfZnMuaA0KPiA+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMv
eGZzX2ZzLmgNCj4gPiBAQCAtOTk1LDcgKzk5NSw5IEBAIHN0cnVjdCB4ZnNfcnRncm91cF9nZW9t
ZXRyeSB7DQo+ID4gwqAJX191MzIgcmdfc2ljazsJCS8qIG86IHNpY2sgdGhpbmdzIGluIGFnICov
DQo+ID4gwqAJX191MzIgcmdfY2hlY2tlZDsJLyogbzogY2hlY2tlZCBtZXRhZGF0YSBpbiBhZyAq
Lw0KPiA+IMKgCV9fdTMyIHJnX2ZsYWdzOwkJLyogaS9vOiBmbGFncyBmb3IgdGhpcyBhZw0KPiA+
ICovDQo+ID4gLQlfX3UzMiByZ19yZXNlcnZlZFsyN107CS8qIG86IHplcm8gKi8NCj4gPiArCV9f
dTMyIHJnX3Jlc2VydmVkMDsJLyogbzogcHJlc2VydmUgYWxpZ25tZW50ICovDQo+ID4gKwlfX3U2
NCByZ193cml0ZXBvaW50ZXI7wqAgLyogbzogd3JpdGUgcG9pbnRlciBzZWN0b3IgZm9yDQo+ID4g
em9uZWQgKi8NCj4gDQo+IEhybS7CoCBJdCdzIG5vdCBwb3NzaWJsZSB0byBhZHZhbmNlIHRoZSB3
cml0ZSBwb2ludGVyIGxlc3MgdGhhbiBhDQo+IHNpbmdsZQ0KPiB4ZnMgZnNibG9jaywgcmlnaHQ/
wqANCg0KSSBiZWxpZXZlIHNvLCBwZXJoYXBzIENocmlzdG9waCBjb3VsZCBjaGltZSBpbj8NCg0K
PiB6b25lZCBydCByZXF1aXJlcyBydCBncm91cHMsIHNvIHRoYXQgbWVhbnMgdGhlDQo+IHdyaXRl
IHBvaW50ZXIgd2l0aGluIGEgcnRncm91cCBoYXMgdG8gYmUgYSB4ZnNfcmdibG9ja190ICgzMmJp
dCkNCj4gdmFsdWUsDQo+IHNvIHNob3VsZG4ndCB0aGlzIGJlIGEgX191MzIgZmllbGQ/DQoNCkkg
ZmlndXJlZCBzaW5jZSB0aGlzIGlzIGN1cnJlbnRseSByZXR1cm5pbmcgYSBiYXNpYyBibG9jayBv
ZmZzZXQNCihzaW1pbGFyIHRvIGEgem9uZSByZXBvcnQgZnJvbSBhIHpvbmVkIGRldmljZSksIGl0
ICpjb3VsZCogZXhjZWVkIGENClUzMl9NQVggZm9yIGxhcmdlciB6b25lcyAoPykuIERvZXMgaXQg
c2VlbSBtb3JlIGFwcHJvcHJpYXRlIHRvIHJldHVybg0KdGhlIHhmcyBmc2Jsb2NrIG9mZnNldCBo
ZXJlIGluc3RlYWQ/DQoNCldpbGZyZWQNCj4gDQo=
