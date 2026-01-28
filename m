Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B4D34DB56
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602376; cv=fail; b=g/20f/Bn5E0z1MvxHT2pUwnR0y2OQfHYyknb0/i6o2v7ZXD+z0m3KYnLMnO/v30dablhEiTpu5TQqQZvb0rzuQ+sGp+CmzY1uhCdk1J6LoZy0R/JwRj2Qk/NZZAzUUrqS2LL19PWZbxCiBFid+4IanJBmCa6mqtqyWdUePz8/uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602376; c=relaxed/simple;
	bh=MR25UF3g99RVgQXsCZw+UAz4gIar917uX6/iK4a84lk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EXmRSfDtMfqksvqS12hVIhwa0dwEhG0IrFjVde8mFdJMFxeE7UnzIlrDKQ70fj0IL1auLoXdKrE60RqUuDkXef3raPUvZsd/7dbGkmJy/DYxnUkX99WfOSn9ZBnkVKT2A9jheD3cQrbtcSSFYmYsxBer/+/oIfOgK76iiioRaKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jeVENQdY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zuId2IPC; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jeVENQdY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zuId2IPC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602374; x=1801138374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MR25UF3g99RVgQXsCZw+UAz4gIar917uX6/iK4a84lk=;
  b=jeVENQdYIcxwMvdw4hwKpuuEkQOGFTo7yE+ADSsbLofdXc3uNvwMjJdE
   njp1R/+F55b+hPwsbQnjV2Ve5w6awNvM2YQ0JqvijnLFCyzo3nmoVl0nH
   QPCrOwxXRoYI94CM9KcuCS3EyOAbi+7GppJTo5mj3GjwQVx1KzdnGKl8F
   7RqZwPAzEch7zQaZSa67tzQWaC+h/5XBtU825fD5OD7frBAVViIuzIgTs
   1A24zq8EwIHrxhR7iCKmzOcpRHlLuZBOEYjabYphSasdSLqFkVlEOoo22
   Sn4/1wo2gjq9mSHUprT3jNWwQf5DUR6RL4gR54ANrSuPBTfzMpCSyDaXd
   Q==;
X-CSE-ConnectionGUID: zp6mmFtERGuTx0U8zF9jAA==
X-CSE-MsgGUID: i1Q3rxL8TlSBoIctw+SwXQ==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="140286678"
Received: from mail-southcentralusazon11013007.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.7])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:12:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f4mGk1mlxIRxGpGlT82qJMdCn/axYucWGHYmxyKFKELXPVAqKe88onDxNqJwiWWCcES0ASSeL78A7Hw/k+atBVPJjIT0pH4gmlGq5ymF7lqBFm3kVZmzxr8lY6RqL78x4R+4k9mvCS3PqWf3QEIpMrWBMY7IoCNxKHPMMl3RTGXrWY05EQmWooGjG1lLEysgNO4xx4gd1mc+spo4GYoqzyJ8l7QEtsZI9pB8zIQuOvXjz3E95iqTxXDWN0iYR2JrcipIVkF5w9/BeNqvMgrMEP39T4yV9esWPWSM3xvBFCFIPPpYNTNldRihexk/qirVb5GJdbdUbxCbIUa3cdkivQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR25UF3g99RVgQXsCZw+UAz4gIar917uX6/iK4a84lk=;
 b=mmDtLapRRnyjtQAyotob9JkN1lg8liGxm/FhAs8UHyHJGuvOdKHwJMqoEU4HT7/etpGoGGFAyjbITbztMgKevt1bErY50Lith/K/2rgAqQc6S4WiBkq6TbiQb7PnzkfqJ4I+KWgmCBkWqVudZk1mRL7ug0P3zls4K64rzhxNjceeACEJQpMqUBBzQvAJdEJ1dXg9aWDE6UGP6hwm/l2J0irRNTRktn0zLlmhKrzVQuYnK+ytEZ2azp2nku+1qqloyYtb4W0VsZE/WeECrqjwi3BZs08y5gh64kBnCvXcy+NF8ABV83mLBKnTL4vbX/WTvI7RBvwwrWDadTbdnF/zXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR25UF3g99RVgQXsCZw+UAz4gIar917uX6/iK4a84lk=;
 b=zuId2IPCzhsGulB2mfQvf+uaUC+HMP8lvC6MoiUnHqU5uIiimgXyulZpIm2jAAZi9Al+ujjjwE0o0vb93y88Uzzod+s4ZOFbrA7AmDRRXi7OYeouzvGMKF1TOXulKYQFGPHVm/6IpjfsOfA9F+FhnFmD7WslqhIkk2EDcAr4REM=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9381.namprd04.prod.outlook.com (2603:10b6:208:4f7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:12:52 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:12:52 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 02/10] xfs: allocate m_errortag early
Thread-Topic: [PATCH 02/10] xfs: allocate m_errortag early
Thread-Index: AQHcj6bsbtIGOh/r9kSKYgQAQHTxZrVnf4qA
Date: Wed, 28 Jan 2026 12:12:51 +0000
Message-ID: <84b96f84-b56f-4108-9581-a2baf12ce69c@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-3-hch@lst.de>
In-Reply-To: <20260127160619.330250-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9381:EE_
x-ms-office365-filtering-correlation-id: e9b7c032-adb3-4d83-bee3-08de5e668f78
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YW1EcTZvTGNkVm9tbnRqd2o3NXVWZFV1TGRLblJtb2VVZ01hUGM3a24rcUZh?=
 =?utf-8?B?NzVrTFd0R0piSEYyVXUxWFlPaTJ2UU5QNCtaS3NESVBxMWNwT0t4Y1lCd3FB?=
 =?utf-8?B?SzVYR041eUlzQlB5dXdvR2pYaVNEU2crbmovbThaMGhQTmcyVUFva0RDQjBK?=
 =?utf-8?B?VUpUaFErNTk1RCtOclZCbXZUR0ZxeW0zdktsSEdndk9XR2x2Rmx5aU8xZ2dR?=
 =?utf-8?B?c3dpMWl5MEdNdUJSajhkQm5nTFV0OTZCeVFuLzJTMU1TaUwyMHBxbzl2Uzdz?=
 =?utf-8?B?c0l5Y1JEWGFBUmo2MUxSYzR6aHMxRmR5YU1rMENyN1dqc092Q0dSOS9QVUJa?=
 =?utf-8?B?VHN1ZDM5RlZyWHNHZzN1SlRYOFd4VU5XWlR5V0l2TE5mT05VVTU2K2lRU1BI?=
 =?utf-8?B?SDhlQjVtVWtvOTdyZFpnWmJLcFlRZW5LRk93c3FERGNPazZaa09KbFNmeVhs?=
 =?utf-8?B?aXlTV05KaHhWbE90WVA0eVhkdzkvMlJJZTVtWnlTSy81Ymdib3B2eC9BSDI2?=
 =?utf-8?B?Tml6QVBlcUFDVGZlaFdQSEUwK1ZqYm00RGVpNWZmbVNaV2Z3SXYwcnZ5cFJi?=
 =?utf-8?B?V294bWt4emZwdXpPUm93cHlQdjBWaExaRndWa3Y0ZGtWeDNnQ2JaVGh3dkNQ?=
 =?utf-8?B?eElvT2x1MDRaWXhvS1diTjdFb1paUUltaHJON2dNdzJZdzdDcGQwOFpBTUxs?=
 =?utf-8?B?RkpyaWNSU043bnJyeFJBd2pHY0tLTWJYRExUbXFEYSs4VkRyWE5HZFdhQTBm?=
 =?utf-8?B?Znk4OUlmbzNsdVJNb2JpclZWSXh2TXRmKzJMdldYYzNxd1p3TnFWNDJPVzZX?=
 =?utf-8?B?ZlJTeXlkRGpvYS9FM29hRklKR1Zqc3NHdlM1Wlk1cUVqUlNhRThwNE1RbHJr?=
 =?utf-8?B?VjUvcW9kajZnSHVUWWJrbDY4dDdzWWNmT25BaGFCem1uMnNTSUx6TXFzN1lM?=
 =?utf-8?B?cHhhWnYyaU5BWjNzU0dkNHZ5MlI3Qjd2Y21tRmh1YnE1NVd3OXJ0eStJUGZP?=
 =?utf-8?B?bGszOStxdllKUmNpRmpLUlpLVVcvSUhVRGxVM01WM040b05tdy8yRkN4T0J5?=
 =?utf-8?B?S2xFUkEvSm9rVnNOZTVCamdEWkxwdFFwR25Fa3dsa1hKeDNmTW1wZ3NrS1dT?=
 =?utf-8?B?OGVZK05LdHJEYmNKNnBGQkxuSDB4Tm81QVFuZlRLRzc3QklMc09RQ2pyd2JG?=
 =?utf-8?B?eE9HK2VPTGZEbDJLWEVvdHVUZndoR2JMc1dWSGNLVjg5c0d4ekxXZEZIM1dM?=
 =?utf-8?B?SVRreng4bjJaZ25OZ25vTDM4WmFTLzR6Slhua0Y2VjdFa3FWN1gxZjNMZGxP?=
 =?utf-8?B?R01ZUHRnaWM1QitZRjV5Z2pLMk9Kc0pHbWVNWXRZaFVDQjY3S204UjVLV1FC?=
 =?utf-8?B?TWVXazhjQW1wOXdvUkdSY01tYmQvS1dWSldWK0NwMUlLQ1BBOFdaNExNb2Jz?=
 =?utf-8?B?Z2U0N2xudmlxc0lsRGM4dmIvcFRyYUpycVoxRUQva0tWSkt0TG1LcWVOd3Rq?=
 =?utf-8?B?Unk2TXlvSVk4SXhJaDBHMVVNUitVUEx3eEcwazJzN1Q4VjZtVGVYNnpjRS9Z?=
 =?utf-8?B?Um1rd1hlMjNWa0Yrb3FXWkRna0dwTlVuMyt3U3pjWm41aWRSYWdqdHpJUWtz?=
 =?utf-8?B?enV6WGo0RWJqb0xsR3pxczZLN2JuSEU1NElMMHoyRUZ1OFNnZ3ZUeC8wSkpl?=
 =?utf-8?B?c2JyMzhwRFVCc1NQS0JYVzE1UnZ1dDhJMW8yODRwVG5ScGVOb0lPbkpSdUV6?=
 =?utf-8?B?V244aDEwdFFZcTVpR3Nkek5XR0hLQXRpS29HeEFhUDg5RGZNSExOTXI0SlZI?=
 =?utf-8?B?MEdjTXlHb2F6MHRUcnVaOFpjaG01RGhvWkp5ckNQVWRVQkJKTE83OU8yTE1T?=
 =?utf-8?B?SE9mMHI2Q3creXY3REp1SmM0eWFxYW1wZFkwbEJLTTFwZ3l1Rjk2NFZzbndo?=
 =?utf-8?B?MEhzVkxWc29XWjQ3UnNwcEE2WkNrZ3ZSUWh4OVRvWVdKRCtIb1MyTkJnV2p6?=
 =?utf-8?B?ejNsMldsT2FkOW9xbWNlZFhGNVViNmQrK2hBY2JQSDA4ZmxOUytHWUJlRk9j?=
 =?utf-8?B?dUYySWRQY3pISUtiaW8wdG51ZzkwT29nTnZ2eE1lZ1BCZWIvM2JnalRMM3lq?=
 =?utf-8?B?bGlKVUE2SjVDTWNpRHh4NTErRGxzamk4THZMQzBMWkxkR2tkS2tmQUIza0hN?=
 =?utf-8?Q?L8DHqrJeegfQ+7idJ1HhtkI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Qmw2V1p0OVdrTmlpa1VXQ0F4VXBjMzZtWTlmWWJvV1BXellxY0NWcklERXZq?=
 =?utf-8?B?SFAyQkdraEFYcGhEWFdPVkRhU0piMWFkTGRNdUF0d3V1QXRyMVVZR1Q4NzJI?=
 =?utf-8?B?dEZYeXhpLzFHaWs3NkxTeDdPaVNjTVl4dktHZkZrZGNWUHI4Nmd2cnVSdEJB?=
 =?utf-8?B?YTh0QVpiY3BLaWJvSXRmQTJkc1NNdXZMNXZXd3BWS0J1dGpBRmZHc0RWWEN1?=
 =?utf-8?B?YTh2M0hLZjFNZmltZ2lWaFdOemhITkJRaU1NbTdkMktyNnowRWc0aUszRnY1?=
 =?utf-8?B?MGRzNVNYUlJKUGtKUEJRUkNaQXhaNFY1RkFZcmVFbUczMzFOZENEeENCMlFj?=
 =?utf-8?B?ZHhvUEhCYUFvYnJhOXkzQnRjYU5BV2NiSTgrMTdXOU40Qlh5SjdNTldFbFBw?=
 =?utf-8?B?WXUxeDdQTmdkclJINFJJbkgxeFZRUnlDRFdQdGNJamdkZWRZT0pQT0x0aGZk?=
 =?utf-8?B?UmRiNU56TThpVnJHM0NiQ1VvOFNvdndGRXpWb2FBT3crVDFFVm1yQm8rR0I1?=
 =?utf-8?B?elc3WnZIcmlXTmJuM2pNNFltNjIvT2ZLUktpNVpwVUowd2lTZmF5ZTVHeS9J?=
 =?utf-8?B?WGVEQzdGOE1LVE93dkVtb3ozMDhoNXhuQ1FYOGhrUFV6MXB5b0ZPT0N4K2Qz?=
 =?utf-8?B?elJER0xqWjlSWk1lSnhFN0g1N1B4U2ltNGhKcUs1cXdUVHpuL0tlajlRckxH?=
 =?utf-8?B?TlFTRVRFcDRQWG5LQlNZNnRwcDJ2WHlDbmduV3pZWXc2REdjcTAzSHEwcFdF?=
 =?utf-8?B?TWhqQ20vaUhZSVJWWHlScEtlMUNnTW9uZzhmM0x6b29kMFgrL1gwYkg1THps?=
 =?utf-8?B?bkk3M0lFb1g4V2w2R0VZd0xlSFJ2amxUbGZvaWZUZGMyRnBmN25EdzdkMnQw?=
 =?utf-8?B?UVpNNUtla3hwYVJhQ2FBeEwyc28zTFlvMEViV2JLamZsYmsrVzZrWExzWnpx?=
 =?utf-8?B?VUtqNVAyeW1CWVV0U1QxNG9iNlUrWTl2UjJrdSs1WElUbnRmTXRXVjdDOW5Y?=
 =?utf-8?B?SFJuaTRoMk40YkFZemFOZW05dWQ2UE5BSmQydHhuZVVSeUVjNWl6cm4yVU5N?=
 =?utf-8?B?WWIrUmlhUEY2S05xMURXZzdYeDBaUFdLMEVNeU5ESHA1alNMZmdrMHlCV1lj?=
 =?utf-8?B?Nm9kK2dCOXdtbUZhb1dhbngza3dqakRCU2MyUkhIbkxkSmJIWUtGNlA5MGI5?=
 =?utf-8?B?bkpKVmYrZ0MvcVJrOTN5UklEdWRUeDRMbCtNNEZoVExsMDZveklML0d5ckpK?=
 =?utf-8?B?RWVsTWZEZEhIL0M4aEFITWs4b1REQlNKWVZDSzRMNXRYYlV0akxJa0tTMWlN?=
 =?utf-8?B?ckE3NWEzMFlyNkUwWWNKd0ZFUWtyME1ndnI5V1VsTUR5YVQ1bmY2bUNCUTNu?=
 =?utf-8?B?QjhCYmM2ODRTYWkycWtJb2V4MXFOS2R4bWxUWUliMHFaN2liekN6aU5xR2JV?=
 =?utf-8?B?Zi9UckRYNzYvaVdwUDQraUNNY2tvckNSc2lMQjJPcVVodndZcWsxdnk1RWdm?=
 =?utf-8?B?ODVRbHJweXhxQXE3YytCQnF5eWpTWXBDanZkRzZMRVJ1VXhtS1lBNkhhLzh6?=
 =?utf-8?B?SlBJWUVQaXZLSzEwNGE4dmhXMm5Pd3VJeEgwUzZJNXI1SjFXYTdCWHFPL0lT?=
 =?utf-8?B?SnFJWG9TTURFVC8wK2FDN0Vzb1dLNEpwbXVpZUplQnlNWmhqbUxqZ1N3a0s1?=
 =?utf-8?B?b0tELzVaM09WcDNkbWY1YkMrM1BhanFhbS9GZWZ4UlhocTZJNHFzeWxZVTVI?=
 =?utf-8?B?MU5BWEVPNEJxZlBwZFlvNmh4ZGNNZ0taNHpIbndWVWtFTVhYQlNwQlN3OEE5?=
 =?utf-8?B?VDhqTGdlSXJnZUErWWxycytXeEw0d1dUNnM0QUhac2dpbnJPOWpNbG83Zllm?=
 =?utf-8?B?Ulc3cWJoaytrb3BmeVVWWExwNmEzSDBBRlcrcFZwWDhmWXg4SjZnR0dnai9M?=
 =?utf-8?B?SWZvQzZSdUJMVTFobEVYZDZ3RVNGYW5udU1yL2FsL1ZVa0ExejYyY2M4NnJS?=
 =?utf-8?B?cUxDeGpLaXF0WXpPV0NOakRpOWpTaS91eElZK0t1akZJUWI0ZnFGaXY5UFZC?=
 =?utf-8?B?WVN0NklscmkwYmdsaDhiVmt4ZC9EaVdXSlJDYkxuZ1dUU1h0eWo1ejlJTkpp?=
 =?utf-8?B?TlpiUjhpbXArNUJ5RzI4WXZCTDQyeTBhZUFoSHZLdGN4L00zczJVelhiekM5?=
 =?utf-8?B?V2pzMGVaWFlmRHlFcHljbFRZTndoNGtFelBmTEMzS25CVlBjNko4VnphREZr?=
 =?utf-8?B?UEttSU9RT0NwSmxlZEJLQmtlOHllTWU1aVY0bFh5dU9IUm5YS3NwZWVod1Rw?=
 =?utf-8?B?VVZxajJ6bENsbUI5eGFSdXp4VllTMFpPaVVuSU1jTG9DejVQd2dOL0lYblNL?=
 =?utf-8?Q?BLIKT03XC6FsAkt8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FC340405C639C4E96D47D8DA73C2CAB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1548KYIYhB+JQaZbrPGaSS9xSwhfhB4w1Jb2pEkS9gRux681eZSLLnpkQRmdJlbHU/jkGbXVjaSZB6dJXPOJHHvpPxUkGvPgDyd/1EsilzdMJuY8cqDVLAiT8qbp5/hbNDcc2Pt46PpLrRM6inSy3PjEbsbH0FANUVBsTIVv+VO2ENfEVSxpeko5sfc49/i8ufi9CwXdIRH7ekoo2vgEt27szICZ9tgcP3undv3rQPjpWCQrfzyoAIFRKCdkrvEdK20D92ZBUuCbW7LfKO1MNYTSOBQW0H/+7zWH04dK04Ff906jhxGLfPhat3aMw5dPiMUeaJv0PKRh2iuGJLx3jqQKHpHGZajBGCQ9yIURM0inRMKw5mcblJN8FnnpHdgUFNTKVSSONymjEIw+pxjfiRohqLdakI8FarZLH0x8KOZ+/b51Ocrfa21C/mhrQH47eazAZfapLBaz3CmIS3hgtSKSnsdvClIzVCQYKeOWStKKZBD4eZW9V7eyq7rc0aCkotTN2LTPeJk40I/A7aLkHDL7bAHUMRREmyiQj/tLJN7AnHyU9uHNrjtgR/NrtDqQEswA9Kar8INiaW57rOfqjHazTDVtmkcg0vnTXz2pfal9ULfE1vZFalIJp2y4ddi2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b7c032-adb3-4d83-bee3-08de5e668f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:12:51.9729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fRKn2Ov8yB07jwPPozBrX9FQbJlULbIlHwEgaseHFKvWv7lt4XfLGnnX1DfIBIuhukg5WwGohrSoVsMUnPMJ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9381

T24gMjcvMDEvMjAyNiAxNzowNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEVuc3VyZSB0
aGUgbW91bnQgc3RydWN0dXJlIGFsd2F5cyBoYXMgYSB2YWxpZCBtX2Vycm9ydGFnIGZvciBkZWJ1
Zw0KPiBidWlsZHMuICBUaGlzIHJlbW92ZXMgdGhlIE5VTEwgY2hlY2tpbmcgZnJvbSB0aGUgcnVu
dGltZSBjb2RlLCBhbmQNCj4gcHJlcGFyZXMgZm9yIGFsbG93aW5nIHRvIHNldCBlcnJvcnRhZ3Mg
ZnJvbSBtb3VudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfZXJyb3IuYyB8IDI2ICstLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+ICBmcy94ZnMveGZzX3N1cGVyLmMgfCAxMiArKysrKysrKysrKysNCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5jIGIvZnMveGZzL3hmc19lcnJvci5jDQo+
IGluZGV4IDg3M2YyZDFhMTM0Yy4uZGZhNGFiZjlmZDFhIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMv
eGZzX2Vycm9yLmMNCj4gKysrIGIvZnMveGZzL3hmc19lcnJvci5jDQo+IEBAIC0xMTQsMTggKzEx
NCw4IEBAIGludA0KPiAgeGZzX2Vycm9ydGFnX2luaXQoDQo+ICAJc3RydWN0IHhmc19tb3VudAkq
bXApDQo+ICB7DQo+IC0JaW50IHJldDsNCj4gLQ0KPiAtCW1wLT5tX2Vycm9ydGFnID0ga3phbGxv
YyhzaXplb2YodW5zaWduZWQgaW50KSAqIFhGU19FUlJUQUdfTUFYLA0KPiAtCQkJCUdGUF9LRVJO
RUwgfCBfX0dGUF9SRVRSWV9NQVlGQUlMKTsNCj4gLQlpZiAoIW1wLT5tX2Vycm9ydGFnKQ0KPiAt
CQlyZXR1cm4gLUVOT01FTTsNCj4gLQ0KPiAtCXJldCA9IHhmc19zeXNmc19pbml0KCZtcC0+bV9l
cnJvcnRhZ19rb2JqLCAmeGZzX2Vycm9ydGFnX2t0eXBlLA0KPiArCXJldHVybiB4ZnNfc3lzZnNf
aW5pdCgmbXAtPm1fZXJyb3J0YWdfa29iaiwgJnhmc19lcnJvcnRhZ19rdHlwZSwNCj4gIAkJCQkm
bXAtPm1fa29iaiwgImVycm9ydGFnIik7DQo+IC0JaWYgKHJldCkNCj4gLQkJa2ZyZWUobXAtPm1f
ZXJyb3J0YWcpOw0KPiAtCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCj4gIHZvaWQNCj4gQEAgLTEz
Myw3ICsxMjMsNiBAQCB4ZnNfZXJyb3J0YWdfZGVsKA0KPiAgCXN0cnVjdCB4ZnNfbW91bnQJKm1w
KQ0KPiAgew0KPiAgCXhmc19zeXNmc19kZWwoJm1wLT5tX2Vycm9ydGFnX2tvYmopOw0KPiAtCWtm
cmVlKG1wLT5tX2Vycm9ydGFnKTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGJvb2wNCj4gQEAgLTE1
NCw4ICsxNDMsNiBAQCB4ZnNfZXJyb3J0YWdfZW5hYmxlZCgNCj4gIAlzdHJ1Y3QgeGZzX21vdW50
CSptcCwNCj4gIAl1bnNpZ25lZCBpbnQJCXRhZykNCj4gIHsNCj4gLQlpZiAoIW1wLT5tX2Vycm9y
dGFnKQ0KPiAtCQlyZXR1cm4gZmFsc2U7DQo+ICAJaWYgKCF4ZnNfZXJyb3J0YWdfdmFsaWQodGFn
KSkNCj4gIAkJcmV0dXJuIGZhbHNlOw0KPiAgDQo+IEBAIC0xNzEsMTcgKzE1OCw2IEBAIHhmc19l
cnJvcnRhZ190ZXN0KA0KPiAgew0KPiAgCXVuc2lnbmVkIGludAkJcmFuZGZhY3RvcjsNCj4gIA0K
PiAtCS8qDQo+IC0JICogVG8gYmUgYWJsZSB0byB1c2UgZXJyb3IgaW5qZWN0aW9uIGFueXdoZXJl
LCB3ZSBuZWVkIHRvIGVuc3VyZSBlcnJvcg0KPiAtCSAqIGluamVjdGlvbiBtZWNoYW5pc20gaXMg
YWxyZWFkeSBpbml0aWFsaXplZC4NCj4gLQkgKg0KPiAtCSAqIENvZGUgcGF0aHMgbGlrZSBJL08g
Y29tcGxldGlvbiBjYW4gYmUgY2FsbGVkIGJlZm9yZSB0aGUNCj4gLQkgKiBpbml0aWFsaXphdGlv
biBpcyBjb21wbGV0ZSwgYnV0IGJlIGFibGUgdG8gaW5qZWN0IGVycm9ycyBpbiBzdWNoDQo+IC0J
ICogcGxhY2VzIGlzIHN0aWxsIHVzZWZ1bC4NCj4gLQkgKi8NCj4gLQlpZiAoIW1wLT5tX2Vycm9y
dGFnKQ0KPiAtCQlyZXR1cm4gZmFsc2U7DQo+IC0NCj4gIAlpZiAoIXhmc19lcnJvcnRhZ192YWxp
ZChlcnJvcl90YWcpKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2Zz
L3hmcy94ZnNfc3VwZXIuYyBiL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPiBpbmRleCBlMDViZjYyYTU0
MTMuLmVlMzM1ZGJlNTgxMSAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc19zdXBlci5jDQo+ICsr
KyBiL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPiBAQCAtNDAsNiArNDAsNyBAQA0KPiAgI2luY2x1ZGUg
Inhmc19kZWZlci5oIg0KPiAgI2luY2x1ZGUgInhmc19hdHRyX2l0ZW0uaCINCj4gICNpbmNsdWRl
ICJ4ZnNfeGF0dHIuaCINCj4gKyNpbmNsdWRlICJ4ZnNfZXJyb3J0YWcuaCINCj4gICNpbmNsdWRl
ICJ4ZnNfaXVubGlua19pdGVtLmgiDQo+ICAjaW5jbHVkZSAieGZzX2RhaGFzaF90ZXN0LmgiDQo+
ICAjaW5jbHVkZSAieGZzX3J0Yml0bWFwLmgiDQo+IEBAIC04MjIsNiArODIzLDkgQEAgeGZzX21v
dW50X2ZyZWUoDQo+ICAJZGVidWdmc19yZW1vdmUobXAtPm1fZGVidWdmcyk7DQo+ICAJa2ZyZWUo
bXAtPm1fcnRuYW1lKTsNCj4gIAlrZnJlZShtcC0+bV9sb2duYW1lKTsNCj4gKyNpZmRlZiBERUJV
Rw0KPiArCWtmcmVlKG1wLT5tX2Vycm9ydGFnKTsNCj4gKyNlbmRpZg0KPiAgCWtmcmVlKG1wKTsN
Cj4gIH0NCj4gIA0KPiBAQCAtMjI1NCw2ICsyMjU4LDE0IEBAIHhmc19pbml0X2ZzX2NvbnRleHQo
DQo+ICAJbXAgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgeGZzX21vdW50KSwgR0ZQX0tFUk5FTCk7
DQo+ICAJaWYgKCFtcCkNCj4gIAkJcmV0dXJuIC1FTk9NRU07DQo+ICsjaWZkZWYgREVCVUcNCj4g
KwltcC0+bV9lcnJvcnRhZyA9IGtjYWxsb2MoWEZTX0VSUlRBR19NQVgsIHNpemVvZigqbXAtPm1f
ZXJyb3J0YWcpLA0KPiArCQkJR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCFtcC0+bV9lcnJvcnRhZykg
ew0KPiArCQlrZnJlZShtcCk7DQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArCX0NCj4gKyNlbmRp
Zg0KPiAgDQo+ICAJc3Bpbl9sb2NrX2luaXQoJm1wLT5tX3NiX2xvY2spOw0KPiAgCWZvciAoaSA9
IDA7IGkgPCBYR19UWVBFX01BWDsgaSsrKQ0KDQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTog
SGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
