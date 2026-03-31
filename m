Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44A3D75A0
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 08:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774944315; cv=fail; b=LFHM36WhNaReY3XWmHA2ADL3gAStM7qb++R/LXybp/zwhL1Kj/7x+56DPxVkjab/bq8Dy4w2bJn/agnVYOfFBEQ4kr5lNmHuD/0WS8AlpA6icXp+W7zrAWQHpgCXE+afGp+qtTV/zoU1jt6HDHbCdfkpPuY+mmISUUhS4gxyTls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774944315; c=relaxed/simple;
	bh=X8Wgn5djWZxuxvvgQ+cOhC6jrkE2fZllSAdA7lla6rw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IaTKm8wKl4psDOQ1Udfz05heun0j2M9t11WRMzp2a5ZFj5upBv49KEtFaSFZbfrhrWaUUPYBI7lnJd4w2yRW2SXbrrJepJVgqx2ddBY6qldI7Bci6XU7sBCpU3LlzPjEeyMhB8amBkEANi4OadrhJospyH52Z9+6Ad/i8FBs/GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F2y3Eh8O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=a7C8mI/v; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F2y3Eh8O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="a7C8mI/v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774944311; x=1806480311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X8Wgn5djWZxuxvvgQ+cOhC6jrkE2fZllSAdA7lla6rw=;
  b=F2y3Eh8OYBoDJbdmpXR5Jr5fkzJlby8oUhlFPgd6JvOaMnFtuAsPCSO4
   dhAS+uXvbV97AS5p9k9ZGOFfxC2wPecx7be6BvPNUKoxbAwwCfQlPt6Yz
   U1yu+4ZQSwma6ksc403h61P22fyPuCnw03YqIFSq1Xkw2QgTIkMiuPlzV
   CFuUnbv5OMUjNcbllKPGCTzrg4Qd7BjDqf0uOlQbFEsbakhM8WFS+rJ/K
   ZjJA2RlAL7DAvxtgT66Wq1Ywl/jWx4Fnexvv8IMUzfL741MS8CTyTpvrQ
   DNVs/wXsLQJI+S+ANVnA0F8Hxvla0CQ+xUTKP9LzNq4jolpx8Zgra72IC
   w==;
X-CSE-ConnectionGUID: ZQeBEbJJQTaxqpmf/VwQeg==
X-CSE-MsgGUID: JFGyt3U/T4CFoAWBtUj0SQ==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="144724280"
Received: from mail-westus3azon11012056.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.56])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 16:05:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGwbq32UDZrsAu0xpSbbrKe2KjNyN/CkWys7EUd3MgcKfdKsIIqkPWN+aC6EmSNqnGrbcieSbFiAKQRhJsBrawDY0q4TR/dSJ8K5Q2GZunWNxS3Z+g9sL6l8I/zvc9nxpN6ByTKYDNHw1JC5lRTcd3/ss9GGmkfH73LX+NX8o/GtQot0tS9ulF7RK4rNbupTOCjjdlOhtBP0r0ytvj9Eq52QOAh0By1tFd/vl+O+CjYty5GTZwItNSEPPsq9qTgewaFn1w53RsKWIMiMvk/Zz/QaZo42J+mAA4OHSp2Z6ytoXW2ftNnM65cOZHWkYSJ2Ff/h4w4Vcv/bX9E/hzB/cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8Wgn5djWZxuxvvgQ+cOhC6jrkE2fZllSAdA7lla6rw=;
 b=vH1W80aEZu5PcAkHPlktwq1G+5gGNYHSGJmRVsqk4pUVSIIygze1Y4laBN/ELtAQDeyU2wwvzkRG1tNpRjOb0Y7FplG3DOIw4KBKBurVc5BWdx9G4JWMMJOKdghi58FAZkkvMymnrw6lhidlPjBduDwn8i2oSfamaOtpBf4tE1KurhmnOB2jcg8xER0Je/m0CUqwTw5K/6OU3rPHUb+3pzy8xRd9mcxpvOVRfq/k+xBmAQ5cH/1dltYSdnZv6/RnxTT5KbPZ1w5+xNq+/EFWE3XiDwXXsmTVhhkzp9s8waVKQ0xKXUSv+bplBSkI4wmYBLQ0rnNPs/PgN2++MC7JeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8Wgn5djWZxuxvvgQ+cOhC6jrkE2fZllSAdA7lla6rw=;
 b=a7C8mI/vgFPK23rrGi8yseEq4Sn6E0ypBGCbpFfy6RJGQYYfXyCLp8h25VguXGQEMfTz3ZhyZmzDkS2GI5TvM+1QxKK0sYO7WB1lbcit/ZB22+DmlpgCtPyQw8SigeKnjpY2Y6TMslEW7crWlkNC7GmZojbvCmLk4E0CTetweRc=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB7129.namprd04.prod.outlook.com (2603:10b6:5:24b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 08:05:08 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:05:08 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/7] xfs: rename xfs_zone_gc_iter_next to
 xfs_zone_gc_iter_irec
Thread-Topic: [PATCH 4/7] xfs: rename xfs_zone_gc_iter_next to
 xfs_zone_gc_iter_irec
Thread-Index: AQHcwAiLX2wN8gSwFUecRTxSzWDkHbXIShwA
Date: Tue, 31 Mar 2026 08:05:08 +0000
Message-ID: <0716c17c-d678-45c4-9f75-bbd9cdbb2868@wdc.com>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-5-hch@lst.de>
In-Reply-To: <20260330054533.3856339-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB7129:EE_
x-ms-office365-filtering-correlation-id: 341d5631-2a43-4da7-3d6a-08de8efc39e7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 w3b9aBEl3LV0U8HlvfZDNnqoaAeHWV7xpKrvPQcYLz6WFhvtXl0mZNKGn7zV4ZLYCAmQCbTQkl29NK3hBLZfJXWY+qVjJ4V0pviCN8hwGPUAA3he9G3xit+if+cVbZm9O7/+cyjDBcJyaOwi1U91HpbIl6468fSf7CkxbgxHuftrQ1b76R9iUL+BaFsTrECm3Tp2M2/quMPLBADNK7HDx5LGux/LLVgDKmPqKi/M5glMJknMAfHOPvUa7LJJTZzDCMg+QganWgeEFVIwpAPLzmd5G2zJYw2QdNBo3LynCZhSIjA/IrGzmAqsb58BpJSYvRAITlKRp37mbCeXq2Es6EvmUoDt14IljoE/kvxsC2vBDOUjuAgEJsHQ9UjQBx+InAT9+AO76aGneQ+hQox1xS9hVLujbtnKnOApPoWONhXld0u7+p02QPW6uxL7qiza/lmFKqBbJrufgy2rTOoJHmMBKqy1HxnoWq4B/yLZNRw31lhMplLhzUN7E6fif7bdIYlSJ9IFd/zZVNOB6mdIkaCtlcYmR6TjOBFnYDb234L4O7sN+k7psnfWJj2vXU1gavQHiYUbCkUSEwKMdR9dCmAV0mR6l7eYBmC6bj85IQ0CsvBBSe7yP3aAZYwqoRSzIUxoKVHFEcBumdTgkUjLPBDH9EWGSlIBv9DkUmmxZEANj6CH4l6GsBZegaOCjIr4Qhbw3l68av+1/QLIjHr462uf1JCI/V1Y9VEw4xDaokbQBd0WMIeuypKy8snDJFN+VrzDf8+NBFrf7n7E7omVyQD7ARSDzHv6iezLZS3QA7Q=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MUNFbUxQUjFsV08yQW90aHA3NzNIdEQzeUtQY29XTVp2ZUY5N0VCd2N6UE5y?=
 =?utf-8?B?SXZYL0pUQmxBOXpoMk4xYllkWXZXL3lpMnNuV0diZUhwcVFxYXV5d3pkWFEv?=
 =?utf-8?B?dWc5eS95TEJFVHJmSW9BcE4zZS9zV0pPUmNRTWZJRVA3OWlidTFkL2Rwejg1?=
 =?utf-8?B?bnJZWDNZdXkwRVRSaTREUHFVc0g4VUtvOXNjblpUQTFIelVZZ1lWK0gvZll6?=
 =?utf-8?B?OWtrV2xBNGVNZzlxa0tGdDQvS0ZkQjRTckdjckV1UXNhemhCV3d4bDR1U3dl?=
 =?utf-8?B?TE9qZUJqTnhBYzd2dHZzOE9tUDNBU09FSEpkdUhDcGNxQVNCczk1ZUlmaXNN?=
 =?utf-8?B?SkowZjdSUkJoN29SMWsvcmorRTNkYXVNaWp6OWVwZHZwdnhBSTJkb0U3ajBU?=
 =?utf-8?B?Tzk1N09zRHc2eWs3K2w2NFZ6ZUp0cnNHQ3RndEIxbW1PYmFCQkxrd0RBK0lS?=
 =?utf-8?B?T3hjME9Ub0VrbTlsQ3YxOU02c29Cd2Y5Q1VIUW9NbEVFY1FCSkVLVnp0cDJ1?=
 =?utf-8?B?N1BqU0R3TUthRFkwK3Flc1dOZHN0bXR6SHpXTXVQbjNNOWtqbTNoNks0djk0?=
 =?utf-8?B?a3cxRWFLVWVRQ1lvYlYzTjhLUVlNM3NlUUhtQnZqTDF3K3pDclZyRUJ2TStT?=
 =?utf-8?B?UUhpNGo5NkNWakc4SDcwTUo5QXBPZnhscjJxb1RPQllhMHhhdGNZakVxbmFW?=
 =?utf-8?B?UERIdmh4OWxBQWdtZWlkVERUUVBTTUxlRkwvWDU5cjc1Y1V2VzU1M2lLdFZD?=
 =?utf-8?B?b1BqZHBIOUM0a0FKcXh2Yy9zbStYZ0laU2tta0JOc2FmSzhNQXdmRDlCYTR0?=
 =?utf-8?B?ZkVvZFI5eVJFZFlVY3NRbUhSYmFSVlp6bkVQRlVMd1lVdG9RNVY3cUtwZ1NK?=
 =?utf-8?B?THFJdUdBUEovdzZWOU1qMk5Ud2Y4Mkt3TmpFTkE2aXpWTmpwU2NzU3Y1N0tZ?=
 =?utf-8?B?K1BwNGNaZ1dZb1Ayd1NvYnhzMGN4R2VNb0dVY3FHTGdJa3hUR2V5emdSR1kr?=
 =?utf-8?B?VGkycDlnd3pDUVdCNTFsNTRHa1M3MDNZODNkZkJQVS8yZGJYWE1CZWhMVzY4?=
 =?utf-8?B?ZzZiZXBCZS83RFZEYk1FOTBkRlJtUnA2a05nNHhzU01NZGhWUUsxa2tWcFlO?=
 =?utf-8?B?WWpvdWVBa2ZHNDlFbUVGT0JqSEh4a0FHVkJwRkRlUWYxL01Wc0pldGJHQWJq?=
 =?utf-8?B?dnBNVTlBUlFXNzYvUlR3dzBWZXlQRFI0eWlZekZLejAwTzlLRG5uMGJEL0cx?=
 =?utf-8?B?ZjNXMG1sUXFUNmM0TFBocDJkMm5ITE92YWNSZzRjNndGRVlJc0VJemF4bUti?=
 =?utf-8?B?cExlaGJUdk82Q2ZIZ3IrRFowY3o2WDFHNmIzVVFiS3BVUHlpdUpJWXZya0lj?=
 =?utf-8?B?ajNpTWZKdmQyRENmcHFoQnh4TVpzUDJZRk1MVnFPblVoUmhnTGdwa2F2Ni8r?=
 =?utf-8?B?T0hscHZWd1dCMjNhTUZvQlBwWkxvbXZUOUxwY2ZLYXRIRXdORjZjN0Q3cHA0?=
 =?utf-8?B?U1R3NDkwRXBNNkl3SVVIVEVwc3hKcElGRmZWTEk4c2JHeWxkemFIL3lnRVZr?=
 =?utf-8?B?ZW0vVWNvSTJDbUtZbTlZME9EUHU0R0kxRlRZdEV1aEk0Y3U2clB4bXM3clFw?=
 =?utf-8?B?Rmx1Ly9icmdiR0ZITlFmcklSd0hma0Y5ZVQ1dHJ1a29YdDZ4UE5aYUI2RG5O?=
 =?utf-8?B?UWlwT25ZTW5QU1M4TFErUEhSTEM4UTNwK0dCL1I4Z0poNmdQZW13c2EwU1pR?=
 =?utf-8?B?K2RxY0lFcTV6K2FQL3h3ZGhTTkxvRTIxNjIyRHVDNU9mamE2cVUzWUgvUm45?=
 =?utf-8?B?Qk1oRWYvRGhWNmk2K3ljU1VzV0RhSld3Y1lBOHVlRXMwQjFmMVY0QkFuSVhp?=
 =?utf-8?B?QWdCbjgxUVozR2lrd0lTOUE4eVVncEJRTkU4enArS0lpRVNKaEI4RFBqTExo?=
 =?utf-8?B?NU1xQ0VVdU5MNGwxOGlOcVhvdEpHejlCWGxOVmZwa1N5Ui9TSVJEVG85Z2lQ?=
 =?utf-8?B?Qk43SXdsdTRTaWk0QURBTlFJVDFOZ2k1Qy9DVXNwV21hczVva1U4ZExXZ21Y?=
 =?utf-8?B?aWRXK01MVmlwTEY4QXVwbkRZQk1MeWFpUjJlY0VjajltNjdaakxYVEhrckZh?=
 =?utf-8?B?WUhrUTNQcnYrclQvNnJRNDZxODhwbzhYd3NGalEycERpZFdRVnVBQzA0NG81?=
 =?utf-8?B?dXc2Q2pSUGVsUWhiREVMRncvTEEwY0lCZTUxY3lKQVZxUzBHNHdNNHFKMWcw?=
 =?utf-8?B?U2J0TUhtY3VkTTJxNWhUNVNYT3V4a21nODJreXlHMUNlQW1NZ1IzVUlIZ09w?=
 =?utf-8?B?TmVYMUo1M05UVnZubndHZVlZRnEyaVpCbUlyT01VKzVOL0hHbGZUZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93FB93CCA878CF428B56576815D0008A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	V/kZUl5P2/6K1Bk3Jms14m6bpoed2br7/UkWMsjkqqeNTnQ08ka1jqv6ckXPZfsHFaf9cOmXSkoVhWKYoIoGY3PHr9IuTzNWqRbkkQnKxvFJ12iicFPgAW1MZLWI/Rv/mgpnRIljV7g3a9n+5GuynEXJDtfXoJ0rKC65hDo30rDxEyrw/ihMOQfGMieyGqXXhNZp5mMoFpbm3F57jBbzK/mKTreIpiOOwYeYnSR8PYTUcmFBx2gw2ld8yQKwrC6UfdNRGIiu3xxO4228W91rHkEPeWUGZ4bssSKxPdyN983fuKSy4jtf8bFE52Cjknye7c527hmtZR/qmyEje2U1SQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zhF1yqQyLQM/pzIlKmi3hLzLGnve/gGpd2/vipw3Tpnh7qkaOZY3hYPYrMiMY4dVy4+qwIpsE7abqxgN+249NEt5HgG6YRDw/xJ5gRCkMlTSonfZ9JwMbD/SiTGhoW3tgSKzib2hTXuyduXDoOWA151kxSjAri9cq8KItiFo3tcOYqbjvR2qGZMXPD1zwlJ8LpsaSHaFMvrGwtHzidQJoqCqcVIeiNawmWl+tQB5zH84iNQLebiaS8YFfmk5HlPZ336cNiz1YNZo9BLegjplVSasd9vv75P9Q45DYH9hTfVTigFxZkZ1RJBeFnz2fZ3KqH8kuuxa+6ch1QFhaLf1dicNbNQlZ07CaqvAmsFAqSW2Tk+uGq/2qEgP5bvocYHCdHU5qStEbfDJuh5bvJ3Vv5yz2+JX0FcPidgq2JxMTousP+Pr/e6H6VCPzsywlOMr62IO+T20Cle2FgQG9jeOR7/6vYCn/FOJrhpCR/Nh2DQDVKiN4rBi+Q9P5tgO9t+Viwy7dNlADJ747tywFnqSa6vqDO4R74OLg2FC5DWiSPO4A+V0mCJd+sLuRlOlzgQKGmcR4mLCyW+2/Dnw6hZ0BMaumn07PmlWRFKB0wp7adXvagUMdP+kGlKxYjB2RG/f
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 341d5631-2a43-4da7-3d6a-08de8efc39e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 08:05:08.7025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S1gvy85QYSfiGigBYCQ9UhuNJKzfXzfnEDkl84P0+juyD0GWi3/WnO6PZ0oCOAP1szsWnsfFe6BDWzJNqMHoKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7129

T24gMzAvMDMvMjAyNiAwNzo0NiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoaXMgZnVu
Y3Rpb24gcmV0dXJucyB0aGUgY3VycmVudCBpdGVyYXRvciBwb3NpdGlvbiwgd2hpY2ggbWFrZXMg
dGhlDQo+IF9uZXh0IHBvc3RmaXggYSBiaXQgbWlzbGVhZGluZy4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNf
em9uZV9nYy5jIHwgNCArKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jIGIv
ZnMveGZzL3hmc196b25lX2djLmMNCj4gaW5kZXggMjczYzQ5NmMyZjFjLi4zNzIzZjUyOTNhNjQg
MTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNf
em9uZV9nYy5jDQo+IEBAIC0zNzQsNyArMzc0LDcgQEAgeGZzX3pvbmVfZ2NfcXVlcnkoDQo+ICB9
DQo+ICANCj4gIHN0YXRpYyBib29sDQo+IC14ZnNfem9uZV9nY19pdGVyX25leHQoDQo+ICt4ZnNf
em9uZV9nY19pdGVyX2lyZWMoDQo+ICAJc3RydWN0IHhmc19tb3VudAkqbXAsDQo+ICAJc3RydWN0
IHhmc196b25lX2djX2l0ZXIJKml0ZXIsDQo+ICAJc3RydWN0IHhmc19ybWFwX2lyZWMJKmNodW5r
X3JlYywNCj4gQEAgLTY5MSw3ICs2OTEsNyBAQCB4ZnNfem9uZV9nY19zdGFydF9jaHVuaygNCj4g
IAlpZiAoeGZzX2lzX3NodXRkb3duKG1wKSkNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAgDQo+IC0J
aWYgKCF4ZnNfem9uZV9nY19pdGVyX25leHQobXAsIGl0ZXIsICZpcmVjLCAmaXApKQ0KPiArCWlm
ICgheGZzX3pvbmVfZ2NfaXRlcl9pcmVjKG1wLCBpdGVyLCAmaXJlYywgJmlwKSkNCj4gIAkJcmV0
dXJuIGZhbHNlOw0KPiAgCW96ID0geGZzX3pvbmVfZ2NfYWxsb2NfYmxvY2tzKGRhdGEsICZpcmVj
LnJtX2Jsb2NrY291bnQsICZkYWRkciwNCj4gIAkJCSZpc19zZXEpOw0KDQpMb29rcyBnb29kLA0K
DQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0K
