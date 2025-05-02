Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1323C51E;
	Fri,  2 May 2025 11:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746186020; cv=fail; b=raN8tm/N/JcbX1x04zXsM7MjLz1EYmfnu+Q0Klb5HoqmRZEJoGmQbGrWiwct1cfdPjSS6PmNe/I2aqeON1soTasBAdkR/kp9fnndH8tcWqVJEQ2Tu1UQlXKIAOtlQalUgv0s2ucNs9N/KbIMw27OpnhTVgsmfZ+Bcz/7msZvQUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746186020; c=relaxed/simple;
	bh=jidUD3LUdI4yVxI6EyWE98+okfnKPlHFkkVJ+KG0bfs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UHYnPuidJ3o3EqFA+Mbd+xltUSn/SbrkYOnOhjVGHjmmYeUoiDLaxh2OXstAWtytpXYQR/UmM64h643qBaYTakx+xUE/Vs1uv5oZamU1M3+L+K0p4vlDWbPfr5m9GQDTvEw0eY6uEc6RY9IXskIGLKCJphmvJ/AyQSfJCHNJeWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=T052zGZM; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Imbsm7Gr; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T052zGZM";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Imbsm7Gr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746186018; x=1777722018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jidUD3LUdI4yVxI6EyWE98+okfnKPlHFkkVJ+KG0bfs=;
  b=T052zGZM4zZLYtsbUdp4ywvqPz9DPlbL0F0M4x0ySBnXW4VLy3fUScrT
   vEqLbUj45SZQscwTRlHZ6mozMyF/t8XmtPnPBubyHFbrKX6/RrFtWRPTb
   EsRHbXFYhjgWBUIaAZJUynuuJjoH9Is7X8ItBTDTIIMriNvmC+nU2DjiX
   5viHNpP2zJ8iL+ioxoNv8Tn1GvbiTcZfaiXI9FzCSbl62p/5dy5y/i752
   p3AIuYjVUJmPotouiFDj7KbqoKzC7NZcVWG8ZzGnwc9kFjGYSMUsSQR9p
   b9KGm2NxkbpIrfmb28sSx9NLjA3vwd1w1JxcV+UV5uQ+YYCuCedOW6T4H
   w==;
X-CSE-ConnectionGUID: UoU8ttbQS4yWVulWSnCAfA==
X-CSE-MsgGUID: cwIHXFGuRSiPKGoQrXeE3A==
X-IronPort-AV: E=Sophos;i="6.15,256,1739808000"; 
   d="scan'208";a="83166625"
Received: from mail-dm6nam10lp2043.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.43])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2025 19:40:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkRYU/d6hQrlpdJ0b3H5f9+7hPi05SzINNhkm7fQpxshHV4T5OeCitfOOL1OGcGnHlRQ4vQ1y3oK5iKbYKwv6gHvlu095xMg5/Ccy7B2Wny2RDdLab4XCN752AiW/yJ5eh0v5bB1fTFKDRHAxePGZL6FAm3zIScULPfmbJjYDgNr/kBLNbYZSfwb8pIfMNJVNRnGJitOiqdQ7ucfVJeQFr08w5Q9ScAZ7EhTO645wzQC/3vGkeCdg3pSsN5NRt6bfEfYB/19F+HKk6SiEDSI01dCYuKkRcTZ81pyD2qgvrhMBS0MnmZVlN7v0Fwa92MrxzJiSY4UMI6Ns4Y+91k51A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jidUD3LUdI4yVxI6EyWE98+okfnKPlHFkkVJ+KG0bfs=;
 b=ud18IVucy66JaroHAWmiU+DjxxjiyagTcaLgIJ/66W89tUojJYm3elLbp0+TVkIv/StMvKkCgnsa0Ehgc+bOsCCHRb6UeJo60DhYX+4h7m+l/ccNy9NkxJLs3csrTbfFGuGCaJguwZwCHxQyCPa+rQGlW0rbaClPhEVE16coeodvvXVrNjsYrJ65uYK19OyOZh3olGeInYhu4F7t2Z0E7I1Eg6qya0Uauquv4Pge/DW5/UaqZDpx1bCqJXqYQ9XDlwPmc5L6o8/rilyek67BJpu6r5Fs0EkRZsVASklzB5VnyMDx9EW8Sy+0dbVT67LhUM/8XRukh4ZQeSyTnZoxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jidUD3LUdI4yVxI6EyWE98+okfnKPlHFkkVJ+KG0bfs=;
 b=Imbsm7GrN+5zGHIDTVdOIEApuHmZGGfuA9+zYkVqi5/j1mwS5AnGFUYT/GRQDRopvelioWa69Ju3K6Di6q5YwtE43/TKu4vf3o8mkUtDgRrNrW/MnasUpntqMi1SPCeRx081HogvmuGCX5tb4iM3czzEuFtMQVa8X6XfdeotJbw=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CYYPR04MB8877.namprd04.prod.outlook.com (2603:10b6:930:c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.37; Fri, 2 May
 2025 11:40:14 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8699.021; Fri, 2 May 2025
 11:40:14 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Topic: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Index:
 AQHbtcDlALwMj9CgvEO6QaqlIzHfhrO0e1cAgASH6gCAAD4QAIACpi2AgABr54CAAu8IgA==
Date: Fri, 2 May 2025 11:40:14 +0000
Message-ID: <3ea7dba6-f552-45a9-ae61-a28ba7f3eda6@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
 <20250425150504.GH25667@frogsfrogsfrogs>
 <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>
 <20250428155842.GR25675@frogsfrogsfrogs>
 <99b99047-a24d-4a75-aa5c-066b92b3a940@wdc.com>
 <20250430145211.GL25667@frogsfrogsfrogs>
In-Reply-To: <20250430145211.GL25667@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CYYPR04MB8877:EE_
x-ms-office365-filtering-correlation-id: e4a7a124-5610-4b47-8e0f-08dd896e1a9a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OFFBNExlU1RuZVBOekJ0cHVtcmtQZ08wUFQxVEdtVzBSdTB3bmg5WFNVejJJ?=
 =?utf-8?B?ZXphZW5TazVEQWtZZDdYR09lM1JmSndKWVNGZjF1OHB4dyt2ZnNpaGJSSVhi?=
 =?utf-8?B?anhUWWFsMDBWSGlvcXhkL01iWE82NTlDcnhCZHF1NEJjNDljZnNaVVR6czdM?=
 =?utf-8?B?OGdTdGRwc2VDNUR0aTArMndoQ2tOL2pyVEZ1K0dGaTk3azh1VTRYWVMrblRj?=
 =?utf-8?B?aWx2UFBtVTRXMUg4aGNPcVdPUzNibHpHOHhmWW1OdVN0TmNjRWFHL2Q1OCtZ?=
 =?utf-8?B?U1Zic0J6amdidlR4T21yM0x0M2JDTjBCNVV3YUpXejQ1L0R5bndkNFM4UjdY?=
 =?utf-8?B?cUtaODlqY2QvbnM5dElhVk5FWHAxa0FDOVZ4NmUyMHlKSWwvZXorUnNEdnlC?=
 =?utf-8?B?N21mQmVEVHBXOTN2ZlJ5VURsMU5NbnRHcFhqcG05Y2tIUWNJalBuL1B6cGJw?=
 =?utf-8?B?dWVIQjVVcFdKc0M0MDJyMWdlSXlVdkhnTC9SOU9yS0Q0TlUzcnE5bGI5dTF6?=
 =?utf-8?B?dlVTSktCVytZc05zSm42TURqVDZLYzRBQlBqblZ1WHFtZCtyNHhDeEIyb1FR?=
 =?utf-8?B?Ti9ESEMybVJIMUVQbDEyb0FmOUJNWWg4NDdSYmh1eExKZzMwMTNPc21Qdmpu?=
 =?utf-8?B?WXBHMllTTnRkcTgwdzVtTlRITEpnUXowZFgzZXg5Z2U0RVdoWDBVL2F2TC9U?=
 =?utf-8?B?c3VzVTRBbm5MbFBmczE0eW9vb1hQcUpFTXNwNVQ3OEVLaFVPcmt2bU91ZGhP?=
 =?utf-8?B?TVNYWmxpU0VvaUZlZjRpWnRDY2VhbTd3S1YzTE9Dc2NTMEZLcENxZlBaOXlV?=
 =?utf-8?B?cWxEMjFTaVczNWdBUkdpdVpUcVVMR2pYR25DNUlUSGRaM0UvY0pZWDZCczdH?=
 =?utf-8?B?YjludWUzL2FFbG1BWUdlUTRnbFk1eFZVRGRjTXVZdng5dlhITUQrdm5GWnVC?=
 =?utf-8?B?T3ljYU1UTzBiN3J5ekdrZ2dPZXVNcWVjVGxaU29jSW9HRDJ2VDQ0NTdEdzVJ?=
 =?utf-8?B?anJJWmZVaFJXZE9TbW13eXhmczVnOXg4Tk1SZGFOMFNML01hVkhQZHM5QU1u?=
 =?utf-8?B?SDQzYUY5RWRCRDNIeU10eTBIcjRySVBpcllVTDUyb2ZtOEQ0S3hJNXZrenY3?=
 =?utf-8?B?K3BhZmkyLzJqSU5TU0dGS3BvSVlYcitTSGxTZEx5dHVJRFFEWGFub3VZTTBE?=
 =?utf-8?B?VlpIOEd1OWNxWlF3Y0N1dHhyR0p5bkt1UjloWGNjRGNyZEwvdzc2NHFiNDZw?=
 =?utf-8?B?c3prMWhDT1lGSUJUMnpic1ozYWdYTmFqNjRDczNvZkNhVnVKNGRIQmlla3Ro?=
 =?utf-8?B?T1Jsa2dMMFErMmpuZGlnWWJJMXF1VnlOWVpKL3RJWDZmN3VMWU14MkU2T1Nl?=
 =?utf-8?B?NEIydzB4eHQ0cEVkUVFxMmpWRjB0dGcxc1EvRmdLY2wwcEIxdTVlSEh5OTFz?=
 =?utf-8?B?MEl1d1BwR1dyOVRuNWtKVklmSEdIeHNrMS82cmhVTFl4RzZuLzh4SGlma3h6?=
 =?utf-8?B?OEg4WGhFZ0NhbEdCQVIza1FDMHhRSWxFUjZYdGg0Z1I3K3oyVzUrdE9lVlBX?=
 =?utf-8?B?a3VyWTMwcFVrUUk5ZzI3UlZnYWxVV1ZZQ210OTdEZHhVV3llazZxd2wxWXBk?=
 =?utf-8?B?eDI1aFJQZW9EblJMMHJxc1k2V1dXYUZ4QlZ4RCt6Rm1XRUJNL1V2by83dSs1?=
 =?utf-8?B?azV3WWdGZVZ5bnRURlpjNm9lY2s4NnE3bnJ5czQ4elplejE5VnIxN0lXSHRX?=
 =?utf-8?B?RTJwVVpyakt4ZFlCY2w4S295Vm01dTFUVlJZSEg0QS83V2UrbnpxYU83NWg3?=
 =?utf-8?B?T013dUlsbDE4bXFSenVJbWtnWmNveG0yR1Nwc3dYSWViZzJiZk56dHpVSzZY?=
 =?utf-8?B?alZUbHZWQXJVeEFQT05pQVUrOXloQ3RIR053b2oxdzVHYXBPanA2S3plRnRQ?=
 =?utf-8?B?SEtrVnp4bGpCK29tL3F1dWlZWEpJajFjRWVCcVNVN3VpVUdidytEV2F3SzVN?=
 =?utf-8?Q?myjphkBMeFRs1B3AUzDkE6xDmC3jBs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NXZjcERRUGNsMzh5QytTQWZIblZ2bkJ5elRocTBPMytFZWxhLzU4YityWWdp?=
 =?utf-8?B?dGtLdm4rNEFTYVZGMlJBNWRVcGhlNHA5ZkdLNGVPaVFCRmFrU2hPM08vYUM0?=
 =?utf-8?B?SzhQeEF2aUM3MkIvRkhaS1lXNWYwbXYzQ1NwSko0Z1pjWkpvWWk0Y1Rvc0hn?=
 =?utf-8?B?OWxNR01GNzNHbzRCUStsSC81RnBlb21OaTVJYloxbVRlSS9MRmFCdkRIbWVN?=
 =?utf-8?B?MGYwc1lNREdxN0ZobkU1dmFFZWZZcnVoNEFlM2o5aGRuVTlSaU5mZGlLWDZG?=
 =?utf-8?B?RUI0ZEkyTTRMSlNPRkx4b2NyNFIvQm4vc1hCWTRNZkNaWEsyNmxlZm44c0hp?=
 =?utf-8?B?a3hpckdRNERRZHI0clozZlJLTWlYT0RZSHBaT3lpMW1CNU1CbVlaeWgzdmQy?=
 =?utf-8?B?cHFWVnpOeE9adExkR245dFl6ajdFTVF4NHZqb2dmdC8vWER1Z3o1S0I3NU1H?=
 =?utf-8?B?TlpuM1Q1KzZnWnlXZnhxTTh1MnF1bTloM29uWmdYRDdxNzg1NGhlZEtrK3I5?=
 =?utf-8?B?UzNwcHQ1djg3RzZLN1hRTTdiU2NFeDMzU1JZSVBWQ2RhRlk4dEFJK0lJcm5K?=
 =?utf-8?B?QVBwYnd6TVl5TWkwSlczdHRFZUN4ekptRUlXRmZJeHYvUC8yREp4QkRPOTdu?=
 =?utf-8?B?K2hoMmEvY1cyMnhlRlg3b2p0SEV6dlZoRkFxK2xLZU1RTjMxL0JhL0x2RUg5?=
 =?utf-8?B?UUZkK0h2THRVOVJuSGlYLzhQWDVqMktKUWtjR2hJcDdvL01Rd25oNWVLZnht?=
 =?utf-8?B?RkUvNmk5OU95ZFZJZ0tFL1RneGh6ZW1VN09YZHRrU0paTjA5VWVtMXZXTVZU?=
 =?utf-8?B?eXAyVWhhZDhyNDd0VXk4dEdqenUyVHh6bjQ1MDdwemg3emNNOTlya0VuUmtE?=
 =?utf-8?B?em9RbnZpMlBlOEdjOCtjbVZMZVRuY2RDUVc5ZTU2VnlXTzRGakJHR2xVVFlV?=
 =?utf-8?B?L25uV0I4Y3BLbVVYTkVZVmpFR2Y4cG85Skx6N2J1ZmJFODR3T24wZzJYUFR5?=
 =?utf-8?B?aXdpbVFJS05jMCtRTElnbkRvbFRtZCtyM1lDRGtCTWZualRzdWxGUzQzWXQ0?=
 =?utf-8?B?UjZLVW12cmJ1Snc3enF6c2QzTGNGRnVCMmw3OUdWd0c3VFNHRTcxM0srbzBi?=
 =?utf-8?B?alp6ai9xSG1mYTFoWDMwcGVzeEFMS21SUzZkUWJZRWxYOCsxckV0VnVvR29H?=
 =?utf-8?B?VDhVcUdTZ0psMXFWUUV5eFZNNVRRYlhBOWVJTWwxS2JaZUZxb1BBT3dNM3hF?=
 =?utf-8?B?Y05Fb3BoUUhOeUJnazVpRFo4UlB3WXBMUlFYVEJoNWErM045L09nUDFxODBr?=
 =?utf-8?B?YjJZNjFqU25tUjVwSDhuUGhHMGt4Ri9DbmptSHJwWSt3ZXhzellsa1poMUJ2?=
 =?utf-8?B?WlVLRkFjZGFjVFFwengySmFsdndyRHB6RWROYUFmTllRZ2dVRHZHb3M5MnJ1?=
 =?utf-8?B?RmJBVDNpeVdiVlF1RnVQWFJKazgybzBlMnZwSUNuVDVKSndNaUxxYWhzclhs?=
 =?utf-8?B?UkZocXd3dTNIU1VROW4wNDM5dTVYalJXOUZNcEl5ZTg1YXRabWR4Y3lYenZu?=
 =?utf-8?B?Vk83clA0WDVuUHM1TkY4elNxcU0vQWwzcXBNUjgzVnVpZHZuMDlCc0hLMVJT?=
 =?utf-8?B?eGZCTlBvc2IzNERlbHJ4RnRGQkpBWlVxYytnbm9GRllId25MOVdxNk9uM3Fo?=
 =?utf-8?B?UVVWVW55U2ZlU2ljSE04OFg5Q3RWRmE2S09sWWZxQlh1d0o5b01qdWdlWkt3?=
 =?utf-8?B?VWg5TEVSc0lYbTdtdFJqa25hbmllSklaYUlUVDI3bGJaOUVJcHg1L0JFWTFG?=
 =?utf-8?B?UHp3cy9LT1ByS3Zja2FmY2p5MlhLMk05cXlLbzlwVXBramZhbUlTdGRXOTE3?=
 =?utf-8?B?K3ZWUmUyMGEyNmZoV1NERDFLaExiYjVJRVFvL0dpbHBOaUR2R2RTRHdQaWlB?=
 =?utf-8?B?YzJuT0M5Qkg3RXFVTWN4U2w0eXBFcTE4QzZuS0ZpM0E3Mms4SWFueXNUdzBU?=
 =?utf-8?B?OTdseUNURkpTUUlyRnRoRW51b2ZrWmN1am5rRS92emc5V0NBaHR3dEpFWFlP?=
 =?utf-8?B?S1JaUVdIdWpUdG1CRytDbDJ6NndLVXhybmEzQXVVZmNURFJzZGp2dTlzdTJo?=
 =?utf-8?B?NFNjWlJSQUFiWXEwUmVqcXAzYm9LNlJveGdqcnZQMU5vVU5uWWNTWUNTVi9i?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93D20D32C58B094FB842DB19974C776D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g4xwyqFvSLdEHmcxisiat0nOvjjHbWQeImLCrUIKam71TIt6L6H8dTUNtJakzt6GqJLP/LNNoL+wxkY/EL5BeTfcjsYX0QPJZ+TxALkBz1ptnqd2FKsRfOE3Gwb2yUttCn/Hx1iIb0OfH3NyM0l0WvEF/G3sMgsrlNMfDmbMomt1OCQf0bzZOmCWawfBvt35hOSs4WhXvdzyOq5F6g5XhJ74r2zODI+7V66t+jaVnXK8KWBxAQ/SFmvD1VtJ8ZajPsvEjG5l7HZhZ3unTuEXibaXN8b0sILDx5b4uwWW4wH9KfWWPjrbKltZvbys4disd1stNO/IMKILJv0Nh9En2RwSzzTwGCGmRzo1y4M8jeGOjuy34db7zDFrfeCJITOPnZAVdN7B+tS6+FkvjAylcz0olvjbzGQc3nD/crWJ912CATJ7/70Y+Czq9KAzQXfHJdmIo5RIyzUiI67BhDDxnCcAa091jDU5hHWnNtEnO0bel8HPeRjfFoDA1tMarFyN/L6aEIccJ2aLUc4O1Fi1lbyH9Y5OcZmnrw8H4cPiLGebr7AvQm2WFhkc1WNd1yyQ6mdXd58HsffNavOEgaGoqRvXi8WIMmoi0oelhb7RCa4EYttxs0WVrc+pqymayiH5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a7a124-5610-4b47-8e0f-08dd896e1a9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2025 11:40:14.1751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tV5FMp4/U2pxcv8IntB8sjbIpV6KDNZq7lLfObjMmaAelD3t2xZqoG/NutUEHpRgI6iLVJ2d+49eyjJUcgFsfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8877

T24gMzAvMDQvMjAyNSAxNjo1MiwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBXZWQsIEFw
ciAzMCwgMjAyNSBhdCAwODoyNjowMEFNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
T24gMjgvMDQvMjAyNSAxNzo1OCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPj4+IE9uIE1vbiwg
QXByIDI4LCAyMDI1IGF0IDEyOjE2OjM0UE0gKzAwMDAsIEhhbnMgSG9sbWJlcmcgd3JvdGU6DQo+
Pj4+IE9uIDI1LzA0LzIwMjUgMTc6MDUsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4+Pj4+IHBz
IHRoaXMgdGVzdCBzaG91bGQgY2hlY2sNCj4+Pj4+IHRoYXQgYSByZWFkb25seSBsb2cgZGV2aWNl
IHJlc3VsdHMgaW4gYSBub3JlY292ZXJ5IG1vdW50IGFuZCB0aGF0DQo+Pj4+PiBwZW5kaW5nIGNo
YW5nZXMgZG9uJ3Qgc2hvdyB1cCBpZiB0aGUgbW91bnQgc3VjY2VlZHM/DQo+Pj4+Pg0KPj4+Pj4g
QWxzbywgZXh0NCBzdXBwb3J0cyBleHRlcm5hbCBsb2cgZGV2aWNlcywgc2hvdWxkIHRoaXMgYmUg
aW4NCj4+Pj4+IHRlc3RzL2dlbmVyaWM/DQo+Pj4+DQo+Pj4+IERvaCEsIGFjdHVhbGx5IGV4dDQg
aGFzIGEgdGVzdCBmb3IgdGhpcyBhbHJlYWR5LCBleHQ0LzAwMg0KPj4+PiAoYWxzbyBiYXNlZCBv
biBnZW5lcmljLzA1MCkNCj4+Pj4NCj4+Pj4gV2l0aCBteSBmaXgsIGV4dDQvMDAyIHBhc3NlcyBm
b3IgeGZzIFNob3VsZC9jYW4gd2UgdHVybiB0aGF0IGludG8gYQ0KPj4+PiBnZW5lcmljIHRlc3Q/
DQo+Pj4NCj4+PiBZZWFoLCBpdCBsb29rcyBsaWtlIGV4dDQvMDAyIGFscmVhZHkgZG9lcyBtb3N0
IG9mIHdoYXQgeW91IHdhbnQuICBUaG91Z2gNCj4+PiBJJ2QgYW1lbmQgaXQgdG8gY2hlY2sgdGhh
dCBTQ1JBVENIX01OVC8wMC05OSBhcmVuJ3QgdmlzaWJsZSBpbiB0aGUNCj4+PiBub3JlY292ZXJ5
IG1vdW50cyBhbmQgb25seSBhcHBlYXIgYWZ0ZXIgcmVjb3ZlcnkgYWN0dWFsbHkgcnVucy4NCj4+
Pg0KPj4NCj4+IFNvIEkgYWRkZWQgdGhpcyBjaGVjayB0byBleHQ0LzAwMiBhbmQgd2hpbGUgdGhp
cyB3b3JrcyBmb3IgeGZzIC0gdGhlDQo+PiB0b3VjaGVkIGZpbGVzIGFyZSBub3QgdmlzaWJsZSB1
bnRpbCBsb2cgcmVjb3ZlcnkgaGFzIGNvbXBsZXRlZCwgaXQgZG9lcw0KPj4gbm90IGZvciBleHQz
LzQuDQo+Pg0KPj4gRm9yIGV4dDMvNCB0aGUgZmlsZXMgYXJlIHZpc2libGUgYWZ0ZXIgdGhlIGZp
cnN0IHN1Y2Nlc3NmdWwgKG5vcmVjb3ZlcnkpDQo+PiBtb3VudCwgc28gZXZlbiB0aG91Z2ggd2Ug
ZGlkIGEgc2h1dGRvd24sIGEgbG9nIHJlY292ZXJ5IGRvZXMgbm90IHNlZW0NCj4+IHJlcXVpcmVk
IChkbWVzZyB0ZWxscyBtZSB0aGF0IHRoZSBsb2cgcmVjb3ZlcnkgaXMgZG9uZSBpbiB0aGUgZW5k
IGFmdGVyDQo+PiB0aGUgbG9nIGRldmljZSBpcyBzZXQgYmFjayB0byBydykNCj4+DQo+PiAuLmFu
ZCBJIHByZXN1bWUgdGhpcyBpcyBmaW5lIC0gZm9yIGEgZ2VuZXJpYyB0ZXN0IGNhbiB3ZSByZWFs
bHkgYXNzdW1lDQo+PiB0aGF0IGEgbG9nIHJlY292ZXJ5IGlzIHJlcXVpcmVkIHRvIHNlZSB0aGUg
ZmlsZXM/DQo+IA0KPiBOb3BlLiAgSSBndWVzcyB0aGF0J3MgYW4gaW1wbGVtZW50YXRpb24gZGVw
ZW5kZW50IGJlaGF2aW9yLiAgVEJIIEknbSBub3QNCj4gZXZlbiBzdXJlIHdlIGNhbiAxMDAlIHJl
bHkgb24gaXQgZm9yIHhmcywgc2luY2UgaXQncyB0aGVvcmV0aWNhbGx5DQo+IHBvc3NpYmxlIGZv
ciB0aGUgbG9nIHRvIGZsdXNoIGFuZCBjaGVja3BvaW50IGluIHRoZSB2ZXJ5IHNtYWxsIHdpbmRv
dw0KPiBiZXR3ZWVuIHRoZSBjcmVhdCBhbmQgdGhlIHNodXRkb3duIGNhbGwuDQo+IA0KPiBJZiBo
b2lzdGluZyBleHQ0LzAwMiB0byBnZW5lcmljIHdvcmtzIGZvciB0aGUgdGhyZWUgbWFpbiBmaWxl
c3lzdGVtcw0KPiB0aGVuIEknbSBmaW5lIHdpdGgganVzdCBkb2luZyB0aGF0IHdpdGhvdXQgdGhl
IGV4dHJhIHRlc3RzLg0KDQpDb29sLCBJJ3ZlIHN1Ym1pdHRlZCBhIHBhdGNoIHRvIHR1cm4gZXh0
NCBnZW5lcmljLg0KDQo=
