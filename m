Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CA41BBBDC;
	Thu, 21 Nov 2024 10:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186454; cv=fail; b=IKyUhTHGAQQoJsvtL5pEZeT7hOkE0U03BUHeYmcP1dTxfFCk8qVNrCGw4/N5o4GXBJyRiIHI3yMEOCrg7yogqqnfVznc6ZQCzR0UKF04KENcRVOh7QQ88cKU2TKwVtr+ghbxBOx/8EiESdrsrSblVaRvMKOxw7+95zVNZppEGOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186454; c=relaxed/simple;
	bh=mQKRhzMcxqDOcKHgXKiPbkzabp9lbWOvrhLuobbdo0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lZw1TlXz+CVPe+RHpk1pq1Xqq0WBc244HCtfB6S/4Tuqjwz0jS9hRPBKTTzdPg6Th8I/9mGQogK2AmYqWeeotHGiA8Wwh69Hn7561tL/CLY0f/rq1sD8IjlSZOwB5K6MQsvE0sbbJsUPP/sUWKKZ0Au2fJtBFdFqFOe3zu+La48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nd3nkaWF; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RcWjGUfw; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nd3nkaWF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RcWjGUfw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732186452; x=1763722452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mQKRhzMcxqDOcKHgXKiPbkzabp9lbWOvrhLuobbdo0o=;
  b=nd3nkaWF+cDnyQJceWF+DwpQ8LP6H7VIiAG3N8SccBHuDSA1+0LO3hRu
   W42Y9uoH0lqjy88JSgFaCAaDox8hR948KrMvn6Ed3LVNocHtGPDPRmBpu
   CZQd/cHA2lBMIG+Dn1IFr93tSVrrRnIq70Qcqj9fsGZ1u+yCy5iA/P4sX
   YOh1I54dAIYH7qB0rW99Fq1Vm5wHQgA/jtzT0MI0W0ba4fyDGmh95CE5c
   zh+TRXuVG9CuSJEqF4zmCWdhapdyiukiHcc4vDQkbQxR1xE5rONrsQ/yR
   YYeMuzdd9hsef3olNgfSorPXkWP+OXeQ3PeJYeP2UjOZQQir0eQlMm71w
   g==;
X-CSE-ConnectionGUID: smLNNYvoRFKQgHXJgdDGIw==
X-CSE-MsgGUID: vX6w6MXSTw281bTR0U3Iog==
X-IronPort-AV: E=Sophos;i="6.12,172,1728921600"; 
   d="scan'208";a="33084803"
Received: from mail-westcentralusazlp17012039.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.6.39])
  by ob1.hgst.iphmx.com with ESMTP; 21 Nov 2024 18:54:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrTGOJYXYkQhxYBETPcgD1yRNM6MyIhKeZOyR6OBtkfmyLmVdk60DB3k0ZJU72K/bT4GeMqqmOEn3O6XaRROvUOG+bJoka6ocsFW432Qspww6AkAKD0fyMt2R2CpywAi7u0boyZWvCZwaRoB3PYsRiB0oM0gwUoxWafqpYii0nTiAyR2pEzgEgwlkh7Zg62U0dAbgfHGud7sxuZ97fMnWqzC6VbG8X1LrSZ2yYLIBC1TNxXbVZ3AacUBLB8USjr3lGABR6ubAGybetU2SOkgGyM7abZj6smVUBniw6WZv7eiFjfBYefIpY1Bv6uPBOjEdMWA9GYWud3QtuIDVBdwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQKRhzMcxqDOcKHgXKiPbkzabp9lbWOvrhLuobbdo0o=;
 b=WTxZ48ed14YR3mVcfuy3EYJOSnlN0dMOXp+WpjWvsNVjjGedcEd/suL3kGvvzHACrnC81MubMx+1VZOqfCfjf1Nsies/oX7xkjOypL48BIlPdRo4DbatSU1dgQhI3i0xHpCriB+kZjZ+emVRpzGDkhvt0ySAk0N7xQ0hAm6h9kUw0O+nxBmG3vmRfOHKq97ZppKOfLbbB7H0kCUZnrVs31F5Bp1uNk5YuXB0Pk0rFL7rotTclFYJZcfXHy3mbYGDGbz6g6qwk9izKaY/tUWLv4I9weBnJ2wBmMb3OFJSPZCBc3iiR8TC29wsTgnB+2kmZhkMigfkCIBSBfrNir7ZtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQKRhzMcxqDOcKHgXKiPbkzabp9lbWOvrhLuobbdo0o=;
 b=RcWjGUfwQ5rSt7la3GQeWavRXrfIpiaKtIfYd6hATV+ShSNoReLT98MBL/PkPoOig+R+BdXIXyXdPgXqerhOniXSyVb6EM+5RvSqcbcIh7b1V7EDFuL/9sQyjzb8cTPa2WLyxeHGMT+leifxKKKW9g6gqt2U6reNtE3UlhZ8Q5o=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SJ0PR04MB7311.namprd04.prod.outlook.com (2603:10b6:a03:295::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Thu, 21 Nov
 2024 10:54:03 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 10:54:03 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "zlang@kernel.org" <zlang@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/229: call on the test directory
Thread-Topic: [PATCH] xfs/229: call on the test directory
Thread-Index: AQHbOpMQpewTTRp3kk26qojkR/TSv7LBkjSA
Date: Thu, 21 Nov 2024 10:54:03 +0000
Message-ID: <6e1679eb-4765-4ae1-9d6b-ef8e582626ca@wdc.com>
References: <20241119145507.1240249-1-hch@lst.de>
In-Reply-To: <20241119145507.1240249-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SJ0PR04MB7311:EE_
x-ms-office365-filtering-correlation-id: c87bd58b-0105-47f1-20aa-08dd0a1ad05b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZXV3VHlTZk5IaHdiRWtLTzkyUDdZajh4UkZnWU9EdkduYXFGcDB6aWpoNnNQ?=
 =?utf-8?B?QlE5ejlsQ1I5OEYyUVF0ZWlWcG9FcHpTRzg1ejJ1bUF6YW9YQ1ZCWkhsb3ll?=
 =?utf-8?B?cnRCa2JaWnlpZDJ4c1pVbHpHRVAxS24zUk54VXBMY3Y5d2FRUHlJODBScGV2?=
 =?utf-8?B?enh1bUR1Qjhkd1dVRDE1aUdEdXVBNTRFaXpwTGlvMWJLQnVPSmtDcU11SnM1?=
 =?utf-8?B?cUVpcnlBc2hlenBrZ3Y4ZDh3aFN5Rm5LZHpoTGg1b2wzQ1ExSHpLMjJmb1JT?=
 =?utf-8?B?QTN1RUF4OGhiZi9DV0p2Z2hiNEx4QXdSdGtJRFE5ekhTYkJXYjM5M2ZzQkE0?=
 =?utf-8?B?bXdXWWdmZ3VqYVBueEVzOG5lV1NqYnpsSFI2NkF4aVNvb0JpeDducFNIYXQ1?=
 =?utf-8?B?bEpCWWQ2Vjh5dE12YmZIc1F0cTdkS1NTZXZzcjhKNzlBdHNLTmpZZ0ZUQjFQ?=
 =?utf-8?B?NktvV1h1TVA2cnVLYmpRYjloRjJyS0J4MTd2VlVSRi9obERzUkhPOTRJcVlz?=
 =?utf-8?B?RXkza0x5V0FXTnBBSVJIbDZZMVNMd2xoUk1qSzFxVkQxOEowY1A3VEFxTVkw?=
 =?utf-8?B?N0gzMjJVbGh1a3B3YjFFNVBhajhudVk3eFNwV1JNeU9SYWNHZVA0OGN6ODEy?=
 =?utf-8?B?QUM4TWlzdExnR1p6dU93cTVTRmJZOW5qV1RZQ2g5WitMOFBjZ0tUTTJWK0Zz?=
 =?utf-8?B?WEhBTGwxZVhaSXprM2p5NmI0OGdvT3k4ZWl2TFpPeWNPVXJJeWxLRTlxL1hm?=
 =?utf-8?B?b2hSSWNpUlltVVByZ3RBdGxVaUFhVzZ4VHpsK2k4d2U5MnJGUXlnY1M2S0xH?=
 =?utf-8?B?Z0pNdHhnbzF2WWpUTExXL2JIUEJtZkdGcEhudEhTd25NQW90Z3lxRTFubU9u?=
 =?utf-8?B?ejdwWjdDWEM1KzQrb3NaSkl5MHRieVRLcjg0RnhyUkpNb2hZNmJCQXRmZXBV?=
 =?utf-8?B?dm9JNzYxRXNyOXB2ZlBxd0xTUFhLSzFWMTNpUitrUG84ZFEvUHZhU1NmRG14?=
 =?utf-8?B?Vi9wcFZsT0dWR045N24xb29mWWR2V01NMzJYM053bS9lSjlKallNN25zUWdi?=
 =?utf-8?B?cXJBQk4rMGg1eXpjQTFXOVkxZkNVRm0xTy8rcnA2d29yTk5QckxRVlByOGkw?=
 =?utf-8?B?MFQrTjBHQmZ6dHByREdTM2J0YkJROEtwVmQ4bnEwRWpycGpVVlpaOW9HREw0?=
 =?utf-8?B?NE5VSFRaeDhNalpQQ3IvOUJOZlk0TzVpNnhYUE03TDBlTHpFWlNsbmpsdytF?=
 =?utf-8?B?THJXS05oZUQyZzZvcHFTa05kNjNZTkFvRjh4MG4reTZFVVBYZ1pad2xOMW5H?=
 =?utf-8?B?MEUvcjFwMnFUNVBraitrVHBTMCtlQkY5alFQWC80aWhUb1RubGRYODEzZHFv?=
 =?utf-8?B?Zy9RZTNyTU9tWjhSNElIWldHVzZuVWFwUzBnOS9OVlhDN2tuL2pzaUtZZENR?=
 =?utf-8?B?Z1Z2WlgxeUtQU2pvckRTUXI1UURYY2xuWU1mRDJNN3FQYk9wTXF2eGMvQXpJ?=
 =?utf-8?B?VDhjczQra2xjaURRT0ZiakN2cmhmVFBJYzladnpuVWxVdmJWMGJ6bXQvUzAy?=
 =?utf-8?B?OGJkVWI0VitqU3VYYS9xSGliQjg3NzN1ck9aSnpkSjZHNnpRRkNLbkxBcU50?=
 =?utf-8?B?N2FubVFhS2x4a0xZRnhXRCt1QTB0Q3RsK2tvdUZyd01nQUwyTFNmT01BdnY3?=
 =?utf-8?B?RDU4dExVT0VzMGh4ZlVzWmpiSnJoazI0QlBJRVNSaUtzZGpqcFViWEZMVENL?=
 =?utf-8?B?UmRZU1U3UWlLOG50SWVXdHM1dXNQUVdBMmpoY041cDg3QUFnaFpOdENiRlZV?=
 =?utf-8?Q?GHZxaumUMgFhp+1kmxv7qHqz7CcjeKx3MjSIc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q0lsbUJ5UzVUdEM1dUNzVTdLQ0hXa1hmS1RMempndFkrMlErQm1FWXptbEtU?=
 =?utf-8?B?MElHRnZPSDFMR1NPVlE0ZnEzbDRsejFKdUtGeFAwWGtJTHdCV25KNnhaMVln?=
 =?utf-8?B?Qk9TQS80WkE2WkVjUFhMbytobWMzWVdtMmw4RllTMEs4OWhjaTF1U280S0hq?=
 =?utf-8?B?VW1ZeUhPOHBGZVpMSXVMZDlxRldaZHI4N2tvMjdHL1Z2SjlUUlJvMEtwZGE3?=
 =?utf-8?B?Znd0eVJTdWRoUnZCVmpKcSt1NGEyTWNpek9QWXBvVmpJRzhHZk94Rk1vYW8z?=
 =?utf-8?B?M1B0Qk5xdld0Y0pDQ3NZMmI3dFVjeVVWNm55Q255UXBVbGRlM2p1WkNBV2Zy?=
 =?utf-8?B?YXBqYnlyRmhVTnhNSzE5c0JuRkF1bzl1STJCYVBKZk9wTUFUSGMxVUR0WitJ?=
 =?utf-8?B?R0NnaHo0dFp3a0swaUdkbUdVM1lqUTlWai9KL2V4MHk0U0RTeElSU3JRMFpO?=
 =?utf-8?B?RzNmOXlSMGJ4QzdnUDRxV3dqTSt4N3RzWlAvQXVvd3RuQUltcjVadVZEcTR0?=
 =?utf-8?B?cTFGZ21Da2hYTEdWN0FBQlZyaVIxMjFvY3N0cDNqRUl1cFloSTNGWVIwWW9t?=
 =?utf-8?B?QTV1SVo2alRUT2FzRUZORjRVTGhhQ3JMMm9iWVc5cC9PRkhzd0NHU1JSRUJ0?=
 =?utf-8?B?QVh2VVo3dnZvdlExOTk3WmJINlh6UnVmdjRGaDFTTTNxSEQ5eVBybVdhc09t?=
 =?utf-8?B?QjZjMzYvUVY5cVRrWFU0QkJaTlM0UHZMUXlkUlVtSWMrR3FYdlJ0NDl1UzMw?=
 =?utf-8?B?MytmUnNUajF3WDVVMTdML21uQVZ4bUt0QXEyNmtUSkpqYjhJRzdkbXhTMFFy?=
 =?utf-8?B?bWZQU01JNUlZUVNMZTB4UGtrR01BVVh3WHhyMDhmd05OSGRFOE9ZZ1U4VzNJ?=
 =?utf-8?B?UGhKOWxhWm1xVkxTc2pxWlA1cnRnY0N1bU1WZi9PZTVoVy91cDNtUk5jQ3N2?=
 =?utf-8?B?dmVDMVEwYmZMaklwd05qeWRCbUJGaU4raStnazRLT1o0MW5Yd09pcTgyWGNi?=
 =?utf-8?B?K1dZYWpzTWJQU0Y5MDlGNHFjdFBWRDdUeU1CRkQ4WGt3cUpmMkY4eGIrQmN1?=
 =?utf-8?B?QVozT2lXVHBmZm94YjhjeENBZUM0Zjc0UWFlMWxHU2ZndzVkZk5Vdy9TbVo2?=
 =?utf-8?B?enVXS2QwVVEzbXRiL2JuZS9INnlqbzdBNFJOd09pOWVQWEhkWnRvRmo3dnNP?=
 =?utf-8?B?Uk5lcG9mZjBhZHh2ajRLYlNPMDloNGRwajlqRjhYa0RNZngwODFTdTNTK3I0?=
 =?utf-8?B?YWVZRVhZUGZaRlh4UTlvZ0xlQjVHUk84K01FS3I5aUJJOEFSVk8vNlIzR1ZI?=
 =?utf-8?B?UTNhVnVzdlVoREtzMXp3Q215R0txUWtteEJ1U2ZHQStlLzhyNE1mR2NiUnRq?=
 =?utf-8?B?d1p0ZlZaZVFmZURiWjlocVhBWHBHOWhtakR4ZUlvMWpGbC85VUdwTi81Zk9B?=
 =?utf-8?B?TVZzUkxjcmh4YmNqSlJ0VlA2SnVVWnZXeGxrMlRsYTZCWVJBZzJTK1VBeVpP?=
 =?utf-8?B?LzBwRzdBM0VXa3RBUVkzL2F3Mm5aVHhuRzZUTnVjSEQwUnZxUXZ2WXVhQ2FG?=
 =?utf-8?B?TkowdUx6WGVjQXB6aGoveEVORGVKdlFLMHBVUnlubkpHY2pGcGNlYnBDNVNi?=
 =?utf-8?B?c2h6TTcrY1NaZHFQTnhNVEFKM0ZidHBNMEVIbmV0OEtzQ1ZYZkZBazZ1REsx?=
 =?utf-8?B?TFNxNEJKaStqanRRbENBL29PYTZpZkQ0U0ZQa2hhQkd6RFVmcndORGl4KzZW?=
 =?utf-8?B?RVFVZWduaFdwckRqYkFlcCtDWXFpS3lmNXZJKzdxNmM2U1VqRVFHWVUvYVFo?=
 =?utf-8?B?SmNqTjZwaVo2eE0rYU9lQ3ZLOWtOSmZmUFY3NEJvVHhQdFZtTFNtaXBvUW41?=
 =?utf-8?B?b3RGM3hpb0NKTkUxVkRnR3RsVFRuR2VBQmVsaktxVFhBcjQ3SGpuTitmZWR4?=
 =?utf-8?B?NGtFaXVkQXNYb0NwczJuWEs4aVk0MW5RWnd4UURML08vWUd4SitteWFmZ3Fr?=
 =?utf-8?B?K3AydlVhL0d3RzY2Tkw2QTQzY2wvTmdKcTdsWkpNdnlNa1ZYVGI0a2NGc2l6?=
 =?utf-8?B?a0gxTTN0eFZheGhkN2JmRU9HWXExQjFjZDNLVmQ4RzZwVnBVb2xrc2ZicFpL?=
 =?utf-8?B?cHVhRVpWNmh3TGpIaThUbGJTelpycE9qY1pYMFRkd2VGZmhVY0I3ZXU0blRX?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79E98B04557A5F43A60AAF50E75F51C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pmWzyMa9/lvHOzCOCNorSx3GV6D4aGGHQ0qlz87kcOVT5inaer+wPGZ+OChE2fafv5Cis+2qZYhetypXA9nWK0H8U3/Qu5dnqh8WbmWLRkAY+dRBHzKmqrc9GhXBSgA7QWLl9NZnGRPGSneKyvMgpJO7z6jETvgV9LR56scfFcsZUn5TFkAjMgcRfELkRDK8RXu5c6CwFrX2VrnwkeHYrdQgxq9xfHfBbNzXDNuE53QG/p22gku3Dy/qcO+mT9XynF2LuVlhGisZVMnHO+5Ptj0n5mBKmC1swQc4ZMakW2MDrV2STQQ5xemOEyRgP0eajmCar0PvD7vtooi6gCDZUokrRa6lnNI+UX/aQTaeDmPKk92DQm2PDGgSCgfNowXkxID6G9HPRyp/JVspcZPfHepFB2aeYUun+kxOv/RvWUlJtqftSVB4jHl811Ji+yzqmhK9WpUJoxKv+bPg9oN0BUl1Udvte+B0xLpLsRE7Wg21KssBitqomNXj7+gaO6/aNCqb/2cPoga7qt2C8KkUlKMCYMVpcW5l7w6u8iS6hxmVO5C54oXbxg+dij6Syb5iCAZFPBj8UlXF6CkkfbjafUnau0mOTIZRZyDskYbABOX884xcVd0AtUY8gRfzxacH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87bd58b-0105-47f1-20aa-08dd0a1ad05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 10:54:03.7379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sd0T/U99DgUJaTR2NPgjGDU8sP0JQ0dwIAYQmEzbclC2RvtHhw9dSJEHFah2sESyjPFN4DJwXATF/CofJ5IYOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7311

T24gMTkvMTEvMjAyNCAxNTo1NSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IHhmcy8yMjkg
b3BlcmF0ZXMgb24gYSBkaXJlY3RvcnkgdGhhdCBpcyBmb3JjZWQgdG8gdGhlIGRhdGEgdm9sdW1l
LCBidXQNCj4gaXQgY2FsbHMgX3JlcXVpcmVfZnNfc3BhY2Ugb24gJFRFU1RfRElSIHdoaWNoIG1p
Z2h0IHBvaW50IHRvIHRoZSBSVA0KPiBkZXZpY2Ugd2hlbiAtZCBydGluaGVyaXQgaXMgc2V0Lg0K
PiANCj4gQ2FsbCBfcmVxdWlyZV9mc19zcGFjZSBvbiAkVERJUiBhZnRlciBpdCBpcyBjcmVhdGUg
dG8gY2hlY2sgZm9yIHRoZQ0KDQpDb21taXQgbWVzc2FnZSBuaXQ6IGNyZWF0ZSAtPiBjcmVhdGVk
DQpPdGhlcndpc2UgaXQgbG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6ICJIYW5zIEhvbG1iZXJn
IiA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQo=
