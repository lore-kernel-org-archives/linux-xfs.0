Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4419E97F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602601; cv=fail; b=S+sNUulhnx8VyKeBumqentCo7ZCAyatekLWI2TxD3ukaLm/DIYtUn49JAmiQ9ACsWW/8cfzcYulCkOtoyC1OHcYc1Dn+tdFYjpLj4LuXLkeir2AkjssJjdtWOxbTRoXpZr+2gudBkt8vafsACAiN7wZMvmp9+vHRYmUdbIfcRl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602601; c=relaxed/simple;
	bh=jKYoc2kS2yeSoyPRfm8VdQs8jltVmeeCyK1qizuZhL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZW91MafSLKEQ/jt+xmAZsnLHf75Mp7Z6Z33zCTwdQTV41LygmZejuJ+HXlaoV8FFvjzM8s7WQIgr7WBHfAv3+69NroKTZn4OG0M6lsgGETTTbmiJt4rQp88M6l/ySxOYW2mo0C9E8+a3Wz23HJQWzAVVVhaAGeHabL2E+uhfE9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rXpfYlx8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=a47SN26C; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rXpfYlx8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="a47SN26C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602599; x=1801138599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jKYoc2kS2yeSoyPRfm8VdQs8jltVmeeCyK1qizuZhL4=;
  b=rXpfYlx8YcLc/OBZ1TbnJcH3V0UdgYycjpiljwg4YvwkrTnVdD5XizRh
   f2o3vjfYL5y+TClwBVI+W+IoOkNYueTFzam6AWUr5+dbojxMouuo1xDw+
   yLe2VwPPXQ53+nj1iE1+uSt8rRVN6DqmyXJd9j9RnfuS0Tx96a0dV4lnC
   rKdfNxUqnIqY+FxRHxuWGdgku+KwGOJEJhefzg0FmdcvP2HEzG8v2n4xz
   MUUp8krP3vuCclV/L67yHzFuUsZ9HRblVefZ+CDet8BlzaAYmQEZpWYxM
   he+8Y0h7UFTlRjeP242EkoZrfnuUxz8Dx4U8pLsUeUeV/3YzxKQf7sV+f
   Q==;
X-CSE-ConnectionGUID: 6rYYFM5VTr+JyZ+K+pmYZQ==
X-CSE-MsgGUID: CfUvCos6QJCb6oz2kLAkBQ==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140286835"
Received: from mail-centralusazon11011030.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.30])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:16:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYBlGgKlUDSgc76EoEZI9UuvK0SqbYc/KCsE8wHmHtb+NSAL2puhyFFv9NYVamWMUn/koE3fgrYjJEKvvggzAysG9VIHseHG08siWeJetQBjx6PQmEYVMp14cQ4OVNhrsGeHADwuyF7oszxDRwQWhkGZbwmobGP/rhnF6Yvkl+GSX6vURPUdBIpTrP2NXB9rSNU095/NDzUNI7N0sSE/ipI++Fi91cV6XckNiqbFnt+6yQ0kTV6sgsu8kNfzATjpYONxPRFj6c4lIpkgVnc4lJoML67oEJYhb/9/ICxJZADcqZRxZDcx5yopT+hWCjFK5/XkJWq1Rz6HkN+fYukhfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKYoc2kS2yeSoyPRfm8VdQs8jltVmeeCyK1qizuZhL4=;
 b=IyG4xELA4OhmkSuMu6/ZX5sQ7e7hlawBJIrkry85Zcsyr5IkcLV6iEBBpbWY6Mlzro/a3crWuwzDzRVFB+k6caJIhHk6m63H5yC5EYTJsOkTUIvH+a4lhlrqps6yl63H/RcUxgzxUo+o3CSR6QEmwQQHnqDwfptNPlbLLxpaTxIQ8STQS4zI/sPvNWTcVbLV1KTvZgMB5QpiysXLmSAoBv8vnxUlhaoo6n/jCDgigaA7MvGkajciiyZLtrC0tW7hdl86hOB22d2dd+c4Jen0nflDjyACu97ofGIw2+MFqe0WiJEJxsWgSsgeJPKB5e5m1XcWRLziQ8AAoPPekns1tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKYoc2kS2yeSoyPRfm8VdQs8jltVmeeCyK1qizuZhL4=;
 b=a47SN26CAiR20m4CcufxeLzDCjkz/qesixPqe5DvcAFzGC3uzHYzBGoOkm5X4hgPwPdcPOmuhVrq7egLqMvkjDvr+5iWqYPVZQfl/+M/oCNQkZU7bqxHmclOWYBqDf6q6bBak4fJAlpIirXuY7/ZkHyzxpQcHouWVIosbaR9uEk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH4PR04MB9386.namprd04.prod.outlook.com (2603:10b6:610:23e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.6; Wed, 28 Jan
 2026 12:16:36 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:16:36 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 08/10] xfs: refactor zone reset handling
Thread-Topic: [PATCH 08/10] xfs: refactor zone reset handling
Thread-Index: AQHcj6b/BM019DgdaEKHkCCoLschXLVngJcA
Date: Wed, 28 Jan 2026 12:16:36 +0000
Message-ID: <49cb172f-c068-44ee-89a2-4b26a066b83f@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-9-hch@lst.de>
In-Reply-To: <20260127160619.330250-9-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH4PR04MB9386:EE_
x-ms-office365-filtering-correlation-id: 909efea5-9c43-4e75-e41e-08de5e671557
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|19092799006|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QWR6Tyt0bTZHM3hJbHRDWng4WmRnM3BkQllBaGp1anFrK0VzS0QwemNnMXpn?=
 =?utf-8?B?WXhBNWhvV3hRYXkzb0RZTVdSSDNWRHhmN0VxWE5ibElGdTNVRU5YNGdEQjVo?=
 =?utf-8?B?QXhaTFduazVSL1htYkRZYi81eDVmeEd6eUloaWtKWXBuTnF2V09pWGRieUZk?=
 =?utf-8?B?ZUFBM1kvdWJKQlpYVzh2WmExWERWOVVnY3dqTFkvMnpOZUI5R3lNRWJiK0Ji?=
 =?utf-8?B?T3hLWHovNVAzWnM1ZDdyK2ZDM3ZmcTdwMHlxUnBmd3dFVGxxWVlQVkJ3akJh?=
 =?utf-8?B?b1FZT2FURjhxc2M4R0JkRXk4cnNOVkQ4aE02d1EwVVpkOUJGSmJBblpmeE1P?=
 =?utf-8?B?RWtJMzhrSzFLYWpvRy9aZXd3V041WGFNU1ROVXBhNzc0VlNMQVZFQjEyRGdW?=
 =?utf-8?B?NWwwYzZvMk1SelpFcmZTRlRYZWNNeWhrb3UyQ0UxNWRhTjJVSnNTUG4rK0d3?=
 =?utf-8?B?aUZ5Y1NlQ0lTOUlrNUZ1cWdBNmNudGtsTnR3LzVDeXY0SlhmVlI2RXBwY3Iy?=
 =?utf-8?B?YmN3d2QxSWV0d2U0TTZSR3ZKa09uVm1SZzJZazhZT2JlVFJwcmVjeUM4N3Ex?=
 =?utf-8?B?YlFPZ1Zici9oaDJIMWRZT0ZiMS96YXk4ckNieUtRanBBNnNwTjNLek1sWHY1?=
 =?utf-8?B?NmpmT3dvbUlpWW1qbjdZMVJibE91Y1RlL1h6VWc3LzRpTkx6SGwzV1BqcXZn?=
 =?utf-8?B?REk1UG5qaFE3STRnZUdacHBhd3FSL3p0UU1DYnJJQTFDSlNTQjNXcUJBMCtp?=
 =?utf-8?B?NWJudDFrMWdSWDYwakZkNCt4LzRDTWF5a2VZcE9wNllNMWRubDdxMEtxWlBG?=
 =?utf-8?B?OUUwb3JDeU9oQUkrWDRTSm9zd3NuYS9vLzRXcWVyckU2UTZOZWU2YWl4dGl0?=
 =?utf-8?B?Sk9ubnM1L0hXL0VrK0p3NTdCSmZ1Z1liSEJGQnkzOEFGYlZkVWZvNEZBSlNx?=
 =?utf-8?B?UEV3MzJGUE1FT0QwNnhQcHErSFQ0a1pVUHFIMDVIM2VUK1lZWEh4TmV1THdx?=
 =?utf-8?B?dFA3WlBYZHgyMW9XSW8xU2JvTTZieEpkMGkyOE4zUjBCZDZsSzVRVjIxTjdq?=
 =?utf-8?B?dEliOHdEbS9aaExDemUwblk5V3BOUnM2UEg0U3YyNmQ0cm5FQ3k3dFZWeVVD?=
 =?utf-8?B?OC9VeEQ0MXpPa3VuMklmbzRyNExBNmp5QllCMG1QQitrU3RJYXpHUjkxMTFC?=
 =?utf-8?B?TTNWRDVTWC9UaHhCWTlSOTFhWGlTV09GYVBmS2RLS0RQdGlvc052V3B5MU0v?=
 =?utf-8?B?N1cyOTdiK0ZtUENSQ0dwZDJ0SzI5MXVhdGNXSWxDcmhGWDJkc2xtSmZ1d3pE?=
 =?utf-8?B?bkxQNFJzcVhURW9OTVZrMEU0cWRjNHZkUXVMYUo3SGpoanRXZGgwTXZuY04w?=
 =?utf-8?B?a21sUXdLWDMySDdNRnJrZTlZNmhKYjM3a3NieFRPZSt2dEVJUEozRzNiMlhn?=
 =?utf-8?B?TVlPcTY0eDJTWDNZalM1bGgvbTJQQ0JBZ09NUUhnVHdBcHBvdjNnQ2g3cFl6?=
 =?utf-8?B?aXE0aGVVekVrY1ZOL0duWFQ5Q1BPZUR1WjhtN3k4dis4MVg4RzYzdmpHZnhi?=
 =?utf-8?B?SnB5L2JrZENXNkRWVWVIR08wNGtFRXMyWnhPd0JqcS9JQXJ0ODYyTzBpcEZH?=
 =?utf-8?B?WFNkemdGU2NBejI1VEJJTjBkNTYxYURGTWNOTExoSEN5eEhLQWpFVVpJNXRs?=
 =?utf-8?B?LysybU9WQmhIWi9xTk0wU0VHT1JhM0UyYzFHcEc1b2M3NTdGTHlHc1NiY1lP?=
 =?utf-8?B?WlZoNkFOUFhpRkxxUG52bHRlakRYWFVEbHV1clhqM0Q5QjdySndKVUhPR005?=
 =?utf-8?B?bkhSVW43T1FtSXpQRW92bUszV3ZMVDBCYXpTS0x0RHVhUGZBWE5xQTdxUk1O?=
 =?utf-8?B?MDJvYWQwdmZiVjB4bzFNTE9ZaTZ5dkdvSU44MXlNdm5nbU9NMDFxejhLRHpj?=
 =?utf-8?B?T05yZ3FMc0cvWTlYdVEvOUd2eTl4TzRrZFBRS2hVcWh1bHBCVVFYcTA0cldP?=
 =?utf-8?B?bU5qMnR4aE9sSXM1YnYrTlY5Si9kam1WckhzMm92VGc3ZXhzdmhuQ21uNjl6?=
 =?utf-8?B?OVB3WmJsbmF6cDU4VFNockYzdHNwTDV5R0dieWlFZThGcGIvZ28vcHJNVXp6?=
 =?utf-8?B?a2NNanQwWnF0emw2Q2ZHcU4vTWF5L3cvNkFKZ2NMbElnY0o1a2UvSW1KWEg4?=
 =?utf-8?Q?FiQYatDaluCjB9Mg26zYc9s=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(19092799006)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b2h6K01jNDBIVzV6eUFOQWdTRjFDY3AzZGlPdnNKTGF6MW9tWG1zZVJ3U2d6?=
 =?utf-8?B?VnBKVEZmN1l0VzFNQUdiUUQ3NmZuWm8xSlJHWnV1ZXZxYVpPSGdKRHpVd1dC?=
 =?utf-8?B?OWdsWTJpSW94TVphV0YvQlpXU21sQldnMHNHYzlTS1dyajZkdjRGQUY0dytB?=
 =?utf-8?B?M1FwbUVHNnlLM05KalJ5b2RVNjRDTThWTDA2NzcxaytyNlVzdjhzd2xyWWty?=
 =?utf-8?B?RGUxMUh0SGZWM2FuOWF4YnQ5THZpb1AzRFlidDNHcHRTZGlxeTJXR2ZrWmo3?=
 =?utf-8?B?a1JuNXVNS3QyczF6SUxmQUI3TkRWQk1JUWU0aG1QRDA4TGJ5RkV1TjMzUHlh?=
 =?utf-8?B?N2RqSnQ5d2xHRUVIVVcwdzJ1dHFvRjRRTEdoR0x3Z0kwTFZhZ2FETTVseDl5?=
 =?utf-8?B?bU91L2NqVU1CNlZRSHdZcmpobEVBTjZQNEhMZjVsZ1A0NnFVYXNwcUFoWVVD?=
 =?utf-8?B?d0FYWHpJOU4zeFc4RmNJQmhKL1lhTmpaTHVMUXgwU3FyaE5kNDBjRFdPMi9V?=
 =?utf-8?B?ZnBYak5LbEhuWlVOOE5YNkh5M1JsdGdmTWVIeDAwczBtZ0hyY3o1NWFWd2ZE?=
 =?utf-8?B?U3VXTDRZdENTWk8yNmJVWThFUVVLQ2ppNFZLL0RxZHFnekhQWUZQY3V6dkhR?=
 =?utf-8?B?TVAwUTFNTUVRckVhTTNBRTcwOGhEdEpHZ3BNRlBzUWRXaFNFa1RzUmRHcDZz?=
 =?utf-8?B?UExFcFVMSEVvcnpOWFV4NFhlZTU1cEgzaWRlOVF5eThlWVBlSEtYeG51WWFF?=
 =?utf-8?B?ZlUwNXVIUEpodHpOWThtTWdWM0hCeGIzZ0xiZ2pXSUozbW4vdytndDRBdFV2?=
 =?utf-8?B?ZVlYWmJiM0x2N0hSYVpIcHR2ZlFNZzhOL3hhbFNFT3VpKytEaU5BK01KeFRT?=
 =?utf-8?B?bXdHL3c3Z3Bqa29yVysrZXd3alY2ZmdCNWREN0xkaFFZR1E5blN5VERaRjdL?=
 =?utf-8?B?aHUwc0FudnlaM1I4cXFyUjcxcHVjV2pDS3B5RU1oamJ5V0w2MGlXd09vems1?=
 =?utf-8?B?RStaWmx1YjRMMElQRGhKenU2M3lBY2thNmJGR29zdXA0VkFMVVRmTG1XVkVn?=
 =?utf-8?B?L0NnVm5tTWEyRHpXSzF5MTNLZW4xTVA4WGVuK1JsZUgwOGZYTjdEaWVKeVR4?=
 =?utf-8?B?OVdrZUMrNE5xN3A0VS9wU3I4ODRRU3k1emgrMFlOd0l4bEIzdTQvNmYzYWta?=
 =?utf-8?B?aUdDc28xek5DYkNwWWdQZnNEVFBCNzNxSzJtMFFvTEJIaGQ5a0J1RElkbzVx?=
 =?utf-8?B?VlE2cFRqWEp1Q3l2RlJTajEwbUs5Z2M3TUFQN1pTMTBkLy8zVGpySXkrbU5E?=
 =?utf-8?B?YVZoWXl3R0gwUTM1TEEvQ05aKzg0a2xoR2hWanhyZWpFNHZqTXBUd1ZXblBX?=
 =?utf-8?B?NUkxNkJCWm1qN29zQ2tKWm9WRlJTTWFKWGk5SFo2aVJnbHhWQjNYNVVZZk1p?=
 =?utf-8?B?azErT0VydEdUeDlFRS95S0tlZnFxZWxTaWQzbStzR1ZDUHV5UmNUYSs0YVZ6?=
 =?utf-8?B?YXVtOHU0SHl4UjhtNzdrZ2p1Z1RtL3F3ZEg4bnlZWUVRK0hMR1F1SUJTTmxQ?=
 =?utf-8?B?cko1dTlHMjhJT29nV05pRndITjFlWEVWRzU4enJEczdpRzRQdkx6WGRCcWxY?=
 =?utf-8?B?UkhyTklGZmpYVWNPanZtcEljd2UydmNEVlFqV0hLT2hKUWdwaWh6WjRFREJN?=
 =?utf-8?B?ei9TYk1xRzFLem4yQXM5RWtXUEZsSjAwTkhQM1JOVFVHeFltQnFwZzNaOGgx?=
 =?utf-8?B?TExNdktxNGZQdVNzTWluM0lWVmxJRHNQVk81U3pUclRPQkJhYVpQYlhDWWdO?=
 =?utf-8?B?NmJKMDh3VlZCME9GSEZJbk9tYmM4c3JWNlJyYTlxMXRaRFNMOEtXTUdZazVq?=
 =?utf-8?B?SG16L2NIRGNTN25kcHEwM1lKR2QxaFBGSy9uOEhsdEloVDRzR2FjbkNjdyto?=
 =?utf-8?B?UkJqdm9JS0orazZTOWtHNm5VMkRGUnUwZ3paV1ZmMldwQVFESjg3b3hpbEEr?=
 =?utf-8?B?dlVLNjBpN1ZiZG1qQy9RMU9RcFZZTTVwaWtuVXhVYTVLVjUwTGZjZmpuUnJ5?=
 =?utf-8?B?aldadUNkcU1aci9JYmhZN3N3MzFRRWwrZXJTdVVydkpYM3AxdnQyTE1YK2My?=
 =?utf-8?B?QXBaL2xNSmxUYkFTbmwxcXZQZzhvZXF2bUhTNHJhOGRjakEzdDkzUkZ1Uk9K?=
 =?utf-8?B?S3d3NjRORlFTVzR3WXEreGN4SllIZUdMMHFNai9Nb3pRVXRkMGE3SWE1Y0ZR?=
 =?utf-8?B?THNBcE1EUzhMWVlrNCszRlRqeC93Y3FhYW1TVU5vQWs4Uy94d1hIRVdvdEJh?=
 =?utf-8?B?V2FCdmg0R1dseE9EbDEvMExJRFdpV3J4WFUrbW5qM3FtY0NEdGx2bG9CQ3FW?=
 =?utf-8?Q?vpmMj/8mn900S1z4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EB9A6489776344198886704E6C48CE7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	llZmFN9LKnEaNDzjMdClk8GSKnwYies8ZdQHnuagxLACJp/+YJr50EMGSyI6obp4BsQHxNwcQ3mNuWJUI3qWGniXMXG/YYGVZ1N9Hwo4+i2DlZ0yhEHtRHhGB3FyxHYPywu/RUtnSXaUXeBnGnLT26yOeNvjRPh1t4bymzlzMQzyi2m1qg424bsXlIa4ZHlP1bXVCb/PEPEsK4f8T60y+SKNXI2O6LmO94/YLHnr/k/cLLn56p3XBYcSDubqtkop2RzgLy40ZY54wLbiyQNKz60txSJvv+tlFNUT3in8cvC0bYIU/ODcyOOdBFdP1d3mNOerO/RZ8Il4myjAP92r50mN3u36wfr6YToLT7ivJGKUvKp9JVTWbDOyYiuuT0mOxpOoF+BzvUW+NsLdLycCungi7J8msy7mvlsZ+5Va6Yo1vOPEZjZZUBzez8+W8+1zxotvMuAsJ/2q5LnvexI1UzwUIXUYppnoZrPKyBUdIVFzS8CzLD6rKxR3WW9Uoz6S7a1pH1oH1kfjBGac2F3qQk1q14KGiA/frfhihFsTF/ODBMoMtVPvEVNWSTe9wPXIWV5LMjVaWLZZz2uyzCOONp4x3pMoEQ2735rSIF+mYqbnRJP9461BVsVrluGKQi85
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909efea5-9c43-4e75-e41e-08de5e671557
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:16:36.5535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uutt+p6aSKxXXIddMXLsPNgT6lxxCT0yyBeZUoRKVlqVM6vIEd7l/n3Ot/vRjNP/DL/mQjTNrq9PTa6H2TERsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9386

T24gMjcvMDEvMjAyNiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEluY2x1ZGUg
dGhlIGFjdHVhbCBiaW8gc3VibWlzc2lvbiBpbiB0aGUgY29tbW9uIHpvbmUgcmVzZXQgaGFuZGxl
ciB0bw0KPiBzaGFyZSBtb3JlIGNvZGUgYW5kIHByZXBhcmUgZm9yIGFkZGluZyBlcnJvciBpbmpl
Y3Rpb24gZm9yIHpvbmUgcmVzZXQuDQo+IA0KPiBOb3RlIHRoZSBJIHBsYW4gdG8gcmVmYWN0b3Ig
dGhlIGJsb2NrIGxheWVyIHN1Ym1pdF9iaW9fd2FpdCBhbmQNCj4gYmlvX2F3YWl0X2NoYWluIGNv
ZGUgaW4gdGhlIG5leHQgbWVyZ2Ugd2luZG93IHRvIHJlbW92ZSBzb21lIG9mIHRoZQ0KPiBjb2Rl
IGR1cGxpY2F0aW9uIGFkZGVkIGhlcmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfZ2MuYyB8IDQ5
ICsrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBpbmRl
eCA2MDk2NGM5MjZmOWYuLjQwMjM0NDhlODVkMSAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc196
b25lX2djLmMNCj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gQEAgLTg5Myw0MCArODkz
LDU1IEBAIHhmc196b25lX2djX2ZpbmlzaF9yZXNldCgNCj4gIAliaW9fcHV0KCZjaHVuay0+Ymlv
KTsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGJvb2wNCj4gLXhmc196b25lX2djX3ByZXBhcmVfcmVz
ZXQoDQo+IC0Jc3RydWN0IGJpbwkJKmJpbywNCj4gLQlzdHJ1Y3QgeGZzX3J0Z3JvdXAJKnJ0ZykN
Cj4gK3N0YXRpYyB2b2lkDQo+ICt4ZnNfc3VibWl0X3pvbmVfcmVzZXRfYmlvKA0KPiArCXN0cnVj
dCB4ZnNfcnRncm91cAkqcnRnLA0KPiArCXN0cnVjdCBiaW8JCSpiaW8pDQo+ICB7DQo+ICAJdHJh
Y2VfeGZzX3pvbmVfcmVzZXQocnRnKTsNCj4gIA0KPiAgCUFTU0VSVChydGdfcm1hcChydGcpLT5p
X3VzZWRfYmxvY2tzID09IDApOw0KPiAgCWJpby0+YmlfaXRlci5iaV9zZWN0b3IgPSB4ZnNfZ2Ju
b190b19kYWRkcigmcnRnLT5ydGdfZ3JvdXAsIDApOw0KPiAgCWlmICghYmRldl96b25lX2lzX3Nl
cShiaW8tPmJpX2JkZXYsIGJpby0+YmlfaXRlci5iaV9zZWN0b3IpKSB7DQo+IC0JCWlmICghYmRl
dl9tYXhfZGlzY2FyZF9zZWN0b3JzKGJpby0+YmlfYmRldikpDQo+IC0JCQlyZXR1cm4gZmFsc2U7
DQo+ICsJCS8qDQo+ICsJCSAqIEFsc28gdXNlIHRoZSBiaW8gdG8gZHJpdmUgdGhlIHN0YXRlIG1h
Y2hpbmUgd2hlbiBuZWl0aGVyDQo+ICsJCSAqIHpvbmUgcmVzZXQgbm9yIGRpc2NhcmQgaXMgc3Vw
cG9ydGVkIHRvIGtlZXAgdGhpbmdzIHNpbXBsZS4NCj4gKwkJICovDQo+ICsJCWlmICghYmRldl9t
YXhfZGlzY2FyZF9zZWN0b3JzKGJpby0+YmlfYmRldikpIHsNCj4gKwkJCWJpb19lbmRpbyhiaW8p
Ow0KPiArCQkJcmV0dXJuOw0KPiArCQl9DQo+ICAJCWJpby0+Ymlfb3BmICY9IH5SRVFfT1BfWk9O
RV9SRVNFVDsNCj4gIAkJYmlvLT5iaV9vcGYgfD0gUkVRX09QX0RJU0NBUkQ7DQo+ICAJCWJpby0+
YmlfaXRlci5iaV9zaXplID0NCj4gIAkJCVhGU19GU0JfVE9fQihydGdfbW91bnQocnRnKSwgcnRn
X2Jsb2NrcyhydGcpKTsNCj4gIAl9DQo+ICANCj4gLQlyZXR1cm4gdHJ1ZTsNCj4gKwlzdWJtaXRf
YmlvKGJpbyk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lkIHhmc19iaW9fd2FpdF9lbmRpbyhz
dHJ1Y3QgYmlvICpiaW8pDQo+ICt7DQo+ICsJY29tcGxldGUoYmlvLT5iaV9wcml2YXRlKTsNCj4g
IH0NCj4gIA0KPiAgaW50DQo+ICB4ZnNfem9uZV9nY19yZXNldF9zeW5jKA0KPiAgCXN0cnVjdCB4
ZnNfcnRncm91cAkqcnRnKQ0KPiAgew0KPiAtCWludAkJCWVycm9yID0gMDsNCj4gKwlERUNMQVJF
X0NPTVBMRVRJT05fT05TVEFDSyhkb25lKTsNCj4gIAlzdHJ1Y3QgYmlvCQliaW87DQo+ICsJaW50
CQkJZXJyb3I7DQo+ICANCj4gIAliaW9faW5pdCgmYmlvLCBydGdfbW91bnQocnRnKS0+bV9ydGRl
dl90YXJncC0+YnRfYmRldiwgTlVMTCwgMCwNCj4gLQkJCVJFUV9PUF9aT05FX1JFU0VUKTsNCj4g
LQlpZiAoeGZzX3pvbmVfZ2NfcHJlcGFyZV9yZXNldCgmYmlvLCBydGcpKQ0KPiAtCQllcnJvciA9
IHN1Ym1pdF9iaW9fd2FpdCgmYmlvKTsNCj4gLQliaW9fdW5pbml0KCZiaW8pOw0KPiArCQkJUkVR
X09QX1pPTkVfUkVTRVQgfCBSRVFfU1lOQyk7DQo+ICsJYmlvLmJpX3ByaXZhdGUgPSAmZG9uZTsN
Cj4gKwliaW8uYmlfZW5kX2lvID0geGZzX2Jpb193YWl0X2VuZGlvOw0KPiArCXhmc19zdWJtaXRf
em9uZV9yZXNldF9iaW8ocnRnLCAmYmlvKTsNCj4gKwl3YWl0X2Zvcl9jb21wbGV0aW9uX2lvKCZk
b25lKTsNCj4gIA0KPiArCWVycm9yID0gYmxrX3N0YXR1c190b19lcnJubyhiaW8uYmlfc3RhdHVz
KTsNCj4gKwliaW9fdW5pbml0KCZiaW8pOw0KPiAgCXJldHVybiBlcnJvcjsNCj4gIH0NCj4gIA0K
PiBAQCAtOTYxLDE1ICs5NzYsNyBAQCB4ZnNfem9uZV9nY19yZXNldF96b25lcygNCj4gIAkJY2h1
bmstPmRhdGEgPSBkYXRhOw0KPiAgCQlXUklURV9PTkNFKGNodW5rLT5zdGF0ZSwgWEZTX0dDX0JJ
T19ORVcpOw0KPiAgCQlsaXN0X2FkZF90YWlsKCZjaHVuay0+ZW50cnksICZkYXRhLT5yZXNldHRp
bmcpOw0KPiAtDQo+IC0JCS8qDQo+IC0JCSAqIEFsc28gdXNlIHRoZSBiaW8gdG8gZHJpdmUgdGhl
IHN0YXRlIG1hY2hpbmUgd2hlbiBuZWl0aGVyDQo+IC0JCSAqIHpvbmUgcmVzZXQgbm9yIGRpc2Nh
cmQgaXMgc3VwcG9ydGVkIHRvIGtlZXAgdGhpbmdzIHNpbXBsZS4NCj4gLQkJICovDQo+IC0JCWlm
ICh4ZnNfem9uZV9nY19wcmVwYXJlX3Jlc2V0KGJpbywgcnRnKSkNCj4gLQkJCXN1Ym1pdF9iaW8o
YmlvKTsNCj4gLQkJZWxzZQ0KPiAtCQkJYmlvX2VuZGlvKGJpbyk7DQo+ICsJCXhmc19zdWJtaXRf
em9uZV9yZXNldF9iaW8ocnRnLCBiaW8pOw0KPiAgCX0gd2hpbGUgKG5leHQpOw0KPiAgfQ0KPiAg
DQoNCkxvb2tzIGdvb2QsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1i
ZXJnQHdkYy5jb20+DQo=
