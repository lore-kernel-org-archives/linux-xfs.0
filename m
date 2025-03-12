Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73621E32B7
	for <linux-xfs@vger.kernel.org>; Wed, 12 Mar 2025 20:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741812060; cv=fail; b=SUNmIpvtddFriGsmpOIH6OBvsXARxVzw7Ko0HstdpAdnyfV9LylwSSFLvSm4XouRyvSIh27WDyoDsha/nvwVm+JmbB84REsF+lbU2LJ46np/aasuY17NoXAMn4VO3WgrcMvgs8RUd86wHaVq2h/JgADmMv3ojPDTV3k6VSD4Tas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741812060; c=relaxed/simple;
	bh=VfMHbgzIn/SaCD3EEG7esuVBhYluXBvb5U8ktPY42LE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cG4RcCoFqAEMeaSI7ZWvvNJseVB/PiI7v8Q3DeTycNhkAf5V08yyLAk6b4Aa+5V9G9wKkS5tpt6bCmD8T/o+iKNuNhhmoU3++9QMbsA/pzfBnQ/9CZVbi59IlAbdZox8YiTlBRbAAiPbufwcRUauHHndV237L7N/t3F/BKqCN/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P6Ga8JeA; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P6Ga8JeA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpnBb3tzBt6NQ1r5ZRWZtRLNTY8/cuFsvDDBYuMVXJm173ztPzN8ze7XhtxwCIzK0QX231SC9rcEfD5SfbGDopCeGVl7TXPVSKQImRCaCXMeU3bHHlVigUDdUcLyog0IqsBAjQ+GbNB0qzGoJZK9HoUsCWs14h0Vq1JR8kruX0yiP5rQUCTCyWhqtVd1MVZ8+w1pVpHEz8gnqm2CNssJwCmRRQdvhollEZHdSnnnn/BX2CR7D0XCoKiOfZMqWNp1tE2aR71PWe7kc5d92CouJ9JLBEUVg/RO3wfe7tdU0MAbYZOaR967IE2ktINcxQxbE32JRL+Z2K9t3g6qVDUDUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VfMHbgzIn/SaCD3EEG7esuVBhYluXBvb5U8ktPY42LE=;
 b=ob3ZfgCvC3eRiLg1h9qu4Z6n3xvHl8Ax+lVbX+VyBainlcatYZpu3MDVKNGKjXGRRGzcWN3gLhUPuJgVFHG8yfPn2MTmnDjFxd9Rg2OmeFv/0iyTa1BJIq4gMYi5itLkSka74PQnqsmhAga7pIXDHY/K5biaoznXoB6H3A3ctu5On8ROifVHpPZEzMs2ioIDmlmZ5+1HajGOidDBUJ6TWXCOXvPDyZ1AbjbPzJSNYpgKcP2HqH1EpGl3WQQb0JsM8jZsu1OXVjQK1UloLOzoLT2xqIEm6/KZKZ34Gc4bfCU15wl+2qwnW43L53wPg0ySqECfA97lAPQZMsa/0QvdfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfMHbgzIn/SaCD3EEG7esuVBhYluXBvb5U8ktPY42LE=;
 b=P6Ga8JeAXqKd/EyjPfWOsLv9XLurlvMsNTcZsTh+5Dpzg3uWwVw+pCW/KtJxhpnjZywHleH4cxyyOP0GH6YpU1yCnD7KRo0HvTpPc6fHRXX0Qb7uwZr+3wESd5NL9yhLpKlcq/LkCsImy/+dIeYDMythLtEUT5NVcO1ETHwI8+lB5k/1ZiV8IlwIwPlVhSz+EJHYWOa/9T7LkimTgyqahe/VT9u7eKCFRtsquyUeBU/jwtSk0IBJwFFTG98X9dx1kv/A+KQ4ZNd7AgUFCWkE7YVl/cWRGN2FJ0PudOWG75VQTceZd9LgYjmyEgGF1nri4lxkQh87X3DXCPWFtjm9nA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by MW4PR12MB6875.namprd12.prod.outlook.com (2603:10b6:303:209::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.27; Wed, 12 Mar
 2025 20:40:54 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 20:40:54 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, "cem@kernel.org" <cem@kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Thread-Topic: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Thread-Index: AQHbdzRe9iyT32aSU0WnV6HRAMjFfrNwL6+A
Date: Wed, 12 Mar 2025 20:40:54 +0000
Message-ID: <13dae7f3-2b7f-4317-ac4e-72dc3f9d51db@nvidia.com>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <20250204184047.356762-2-axboe@kernel.dk>
In-Reply-To: <20250204184047.356762-2-axboe@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|MW4PR12MB6875:EE_
x-ms-office365-filtering-correlation-id: 2bf4d7dd-5693-4ac6-f7c2-08dd61a62f48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bWx1ZEJSL0FvZGFrR3B2SzNsTkcvbkkvN3NoM2Q0KzdlaWhJQ2ROSU9BdTA0?=
 =?utf-8?B?akZGa2pibnk2NXJadmFRMEg3R0JyMHlxYnoxWUJJMCtMWXdCdWlqdTFKdzlr?=
 =?utf-8?B?WmJpNTRMZzNQWS9JY3RjTER0SFpZcm44WkFBWUVkRHdnLzlrTjdXaG1tK1Fr?=
 =?utf-8?B?aDVFMGVDV1lZbDBFbzlwZUgvVCtIdzU4bVRTWGJIWWtGL0FtN3lDQW15c1ZL?=
 =?utf-8?B?cEcyZ1RiaWJBMHV4REJqdUtmb2hJYVVGRjEya2tjZ1FMdUU4VUxNQVdQcENQ?=
 =?utf-8?B?andlczRJdWJSeWpEdEg2aC9XbDh6eFF0MjZmdy9ka3BkNHZjRERsMkVDOGIy?=
 =?utf-8?B?YnFMcmhEd2Y0NmRYK3drTkZsL21RQWxRaFVVTE83SWxOZmRGNzhleHpPWUV5?=
 =?utf-8?B?M2hrNmNZWlM2b2o3Wno4MW4xa1R6YTdlK2lCV3JNQUxIZ2FHYm1zSVVsZ1d4?=
 =?utf-8?B?WHJLSnJaT2FNK0hsL0JGbDh2K1dZYlVTM2lDcSs2WVhEOUNsUnhBenRBdEUz?=
 =?utf-8?B?UkFrZjgxOTRDckQrYUJDUWJXa3Y0WnkzSGFlZmI1WnM4bkN2RVFoY0V1ekh1?=
 =?utf-8?B?YWNHZFVzVHZMK2VlNm90MnhkaDdkQU55cnZYK0Q0cTJ0SDAzVCs0THo5T2Jk?=
 =?utf-8?B?azV5Mk5VbDY5R1lHU0hmcElwWG03ZUpBRVRFOS84aG5DUitWSmZLbXJTeWJD?=
 =?utf-8?B?M2tTRlF4WFRnRU9MWUFQVHlYdllMQ3F6cFdaTkpWWUtvWHpKVnQyRHk4cnZi?=
 =?utf-8?B?NXlyb0dmaUVRSHZGV0pRMjJtRU5lSHE0Nnk3SUpWdzA0a1V2empFZ0xCOXZV?=
 =?utf-8?B?NEdkZnduT0ZzRW82aC82bm5SL3ZBRzdoeVZ3eTJzV1Z2dkI3R2tTcFlrRXh0?=
 =?utf-8?B?dzJ1Y2JVTzRtYTcxVGszYzJsZWk0VlRKcTRHd1N3dFpISndMdVk2YVAwQVg0?=
 =?utf-8?B?dS9SS3NETTZDRjI0WXZiSkN5bkxsN3dLbm5pem41N1FNUjdUa1I1aUg2WDQz?=
 =?utf-8?B?VkJVQWNXd3VPQ1FhNjVIeUlqRU85NjVWUjl5RVVHalNHZGdLby9yZ3RYQmg4?=
 =?utf-8?B?SnZzbUhhUzM3ZDkwK0R5YWJadUZ4WlhHL3dwb2VyeWh6eE5SQlQ0WDRvYk1J?=
 =?utf-8?B?RGQ4UUwrdjQ0SWxaUW1sMTY3Vjh4TFVtdFJyRGZGTDBUcTRuWHE3YzlxN1dp?=
 =?utf-8?B?QlVGRWtYNUMrcG4vM0MyeGViOVEzV3hqTXhIaENuTXZISEpwdWlhSnBTVzlr?=
 =?utf-8?B?bDVJTlFsaUk2SHV5cHRHenFpS1BzNXQramtLKzY1NDlLMVhPS2Nwa0krMG02?=
 =?utf-8?B?QlMraUszWW8weGJrMHpRNFNLRkwxMTRGUnFpU3lMVGVyam9Yall1MWdEbmN2?=
 =?utf-8?B?RXowSk5qVlE2d0pyQng2RzdwaUNEYkk2ekVNUmVKeGJscVRDejBvMi83ZVBH?=
 =?utf-8?B?MUJ3TWM5QmlpZHg2a2RSbzJTR2pldW92TFlNQU5iZ2U3RE5NQSs3RkMwM09K?=
 =?utf-8?B?MThhRkhWTDgvZUZmTmlCUmhaUTlHcGd1eC9EVE1keVJGSE5FellKRXRpSi9w?=
 =?utf-8?B?UXNiWnltOW8vaHZWa3hMb1MxOGZQVzdPSnBvNElJOUJ4REVuSnBhd1paTjJU?=
 =?utf-8?B?NHZ1bC9UejJSazNoeGtxUEhKazJDQ2FtWjFvVEh1WDFvUzNIeHd4WVdQRGpP?=
 =?utf-8?B?K1g4eDRieGFqYTVlYzdXazNaZExPdWFXSmlVcDFSUVVOWURta290QXgwZ25X?=
 =?utf-8?B?YjRsVDE5OEhtVUVPQ2kza1dqRVRkY0syMEJScHNCMzVkTTlST0F5d3dXeXFE?=
 =?utf-8?B?ME1wZ1FlTnhzMVdSdVc0aWxYSVRJWFJnWklaZ3h3MTlTZ3VEMG5GREtQZHJX?=
 =?utf-8?B?NTU0V3VYUDJkMnY1dFVTK0todUdhbDFQWDNhYkg1cmtDcHM4bWNDUStoVms1?=
 =?utf-8?Q?06C4Hk5XeSSZFcIwQAAsattr1/nimB5Q?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUhDaUh2MGpaUm1nWUdmQStiR0t4TUQxRTdtOUxnUGRJYm13b0RuZE5TZWxX?=
 =?utf-8?B?UzhDaFpHam1pM3JEN3VYK1VRQUVkTURLckI4RWlkYWZvbHpFb25HbVhFNVZ3?=
 =?utf-8?B?akpSNFlsb2dhTzg0YU5uZUJsMWE5ekdQZThORW9QVlZkTXNRYWdnY3dQQ0tK?=
 =?utf-8?B?bjBjQUlOR3RWRjdWek1PdnpBMDB2UnZmOC91SDh2MEJ5TzNKOUZXaDhUMERn?=
 =?utf-8?B?eEMyTzI2OU1YajIvWWF5VWc3amd0dDRoNjhkWXF4WXNxZ0g4SjI2ZDhVcVdx?=
 =?utf-8?B?VmFaaDFYdFNUS1ZVMWVNWFNCUEl1ZmpVSE50YkpiM3h6Z0ZyRUFLaFhMZm1Y?=
 =?utf-8?B?azkzS2crZjFwL1A5ZzdhVjkyaFI2WUNiYnkzbDE0ZlFWVS9sZjArZXN1TjZ0?=
 =?utf-8?B?aThMZ0FCMmlTLzNhdFgrMWlSOHhHUTM2NHNFWDM4bWlPQXI0eDhMQ1B6Y3Bv?=
 =?utf-8?B?clpLay9rNTljY0RVcnkvWlRWcnBUSEovL3BKOFhEa0hSUDBSdXZIdkd2MTVH?=
 =?utf-8?B?Z1ZEVGpnU28wMm1iMlBRQVV3REgyMWpDVlB1MWZmL3RoOXdCVHN3bU1UbEp6?=
 =?utf-8?B?UWNqOGxhRFlxenYrY0NzTlpqUTlWMEFqdXlTMTVJSkJWMXhDdE1uTW1UUkEz?=
 =?utf-8?B?NFY2UTFwZ2R2VjkwK2I4R3BHR1BENkNEQmExZ0xSS3QvQkIzemtUV3B6bDNF?=
 =?utf-8?B?ZFFYZVcwajVBYjBSSzY1YkJnWk8xVEtjYU0zMFY1NDNMR2x5R1hzNEcrbkZZ?=
 =?utf-8?B?dDRsWkR5bTRQUFdpWDc5WVF1K3RSZ3dnSk5DUFhhcGc0UDNUaVZFYTNtOEJX?=
 =?utf-8?B?UGJuV0FTT2xNT0l6ZmdzZTNHd2ZrUkpDWDNhZ2tBUldtL1pVVzZOU1dtdHVS?=
 =?utf-8?B?d3FadGQvNS90YWRwTW5zRTQrRFF5bzNXaGdCS0VwT3BsaDc4eGoyRHlWTWwz?=
 =?utf-8?B?YnNGbmlxMThZbGU4d2Q1TFZibXVzRmUwRTREcjRGMVlaQ0JPZFlxeGtPbVJ0?=
 =?utf-8?B?NmlBMmtKYkFHTzZKWDlrWG5NbTVTS1RJS3BXZWIrdzl4T3I5cy9Wa0lPVjFi?=
 =?utf-8?B?cnpRYWY2K1ZqTWwyTzlORDRJN2RJcmN2RGdtZlZwN2N6S0RyNWx0WG1zYlZN?=
 =?utf-8?B?dU9yRnJ1c2N1Tk9pQWN5NEUxNVVkckV2b3VVM2d4eDgweGp5dGw5K1NwNGVy?=
 =?utf-8?B?TjRqQTRZUXVjcHJ3YjlVL0x4Yy9wV3dpR2wwNTBPcTZ6enZTdktqcEtTaFJ4?=
 =?utf-8?B?MWhrcmI1a3NjSThnWXcwNGNoQXB2T1hsRFhCTVVYVFgvVjhEL2cxVEtUZDBq?=
 =?utf-8?B?czVTSUFRZ24vNm1hVnRWZ3ZOMFlDeEgyc2lseW5yV3NLbHpleUk4OWdtQVhP?=
 =?utf-8?B?UThMVXRDUXh0blZGYkFkM1dtZml2eWlNT1R3ZGJWeWZ0WU5Ia2FqQUdEQnVE?=
 =?utf-8?B?S1lXTmlod093azFBM3NaUmY1a3VKN3VOajd1U0lmRzdOZ0EwYWQ1SWFadDdD?=
 =?utf-8?B?dGwyS0htcEhrVDRqQnpzZVBJTEZuTTlqUVR4Q3FjRnJ0SlZBZGx6YXVHYjdv?=
 =?utf-8?B?Z0JlN2puaHZyQWZna1hJWFp6c3NNaVhxLzdaRFBsNzhEMWFrckxzck52Zmdq?=
 =?utf-8?B?c2p6dWJoMkRFUUpHSEp0L3ZvZGU5YTNyRG54RGNKSit2czJxNzFXSE1vajhs?=
 =?utf-8?B?UlF6OVRlQUhLT3A2bWpiT0p0WFpadHV0TkEwN1VrNGlvcWI3QWhjZHRtRWFY?=
 =?utf-8?B?bE5BRGZaSTVkUTJFNER2enJ5ZEpKR2k2aDduNG9LRTZTL0lmSEVyTjFSN1VG?=
 =?utf-8?B?VWRpTWE2SzVCd3JSSEl3U0FzcnNhTCtJbUpTTVl0cXZTRkFsNUk5ODlPRnlR?=
 =?utf-8?B?LzlwVVJ3TUl6eXNCSTlJbUsyWXhzbHR0ZWVZNXlqSCtXNndRTlgrOFRRYzQx?=
 =?utf-8?B?N2dkOTFzYzEvZ1Erc3ZDTUk2djZaVUdRRmF1ZUhHYVNSbWh4VVdHVlNhOWpV?=
 =?utf-8?B?OW1yRTdQVVRKdmJ2MWpxVzhFc1F3Uk1JZG5vK2lqakhCM0VDZlR2VGVLanB1?=
 =?utf-8?B?OE9XZHE4VGhoNVI0ak0vbXorZ3V6djNRSmdpc05Pd3RKRjdXU2ZtTzJlaXE1?=
 =?utf-8?B?VWtsVVBXSm1zYmJEd0htL0RENzF4NDdEb21pZnhjM0lYempOMVFwcER3WVpt?=
 =?utf-8?Q?UmTf3zUoVPybgexBO3P6OXXW+BmV/zwJKNhI9wIMo0uw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A57B9B4819070B4DA336C1BB7AD3BFC6@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf4d7dd-5693-4ac6-f7c2-08dd61a62f48
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 20:40:54.2113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +mi6mWwqgkeZlfra7oGaI2i8aXDvCZ43H1xgnNZPUAa2GaQFTTM0jnUNbVyShjZaYzBrjYSvSKUznuqRXGPO/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6875

T24gMi80LzI1IDEwOjM5LCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBBZGQgaW9tYXAgYnVmZmVyZWQg
d3JpdGUgc3VwcG9ydCBmb3IgUldGX0RPTlRDQUNIRS4gSWYgUldGX0RPTlRDQUNIRSBpcw0KPiBz
ZXQgZm9yIGEgd3JpdGUsIG1hcmsgdGhlIGZvbGlvcyBiZWluZyB3cml0dGVuIGFzIHVuY2FjaGVk
LiBUaGVuDQo+IHdyaXRlYmFjayBjb21wbGV0aW9uIHdpbGwgZHJvcCB0aGUgcGFnZXMuIFRoZSB3
cml0ZV9pdGVyIGhhbmRsZXIgc2ltcGx5DQo+IGtpY2tzIG9mZiB3cml0ZWJhY2sgZm9yIHRoZSBw
YWdlcywgYW5kIHdyaXRlYmFjayBjb21wbGV0aW9uIHdpbGwgdGFrZQ0KPiBjYXJlIG9mIHRoZSBy
ZXN0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiAiRGFycmljayBKLiBXb25nIjxkandvbmdAa2VybmVs
Lm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZTxheGJvZUBrZXJuZWwuZGs+DQo+IC0t
LQ0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtj
aEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
