Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1DF1C84A2
	for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2026 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791682389; cv=fail; b=ScuhVuEN/ahh+uHKnBvqzDYxPJOKxAb0qdU8hehdicFvs6fXmfxGuQi02HzhIfhL30mKPHd69E13ZBH91GQWQ0kHYznOVtLROF2Nucy5x5FnkWwICqemBmoRn8gQkHl+/oGjcpPt4A/Grx/2KUJPED96F0GwWDjWu5jRyMTJxmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791682389; c=relaxed/simple;
	bh=Y5y0yW9WniY7DQrZFfcukYs9ZMeCuLXbdO4BO5lIhy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PG6cBVvHi456oLn7QDF6gWna8a9pHAFI+nORM/d4T9m5bR0ccHAwKk0hd00KQGquRV++hTi2Vi+NfrJ9NtjS3cEBITetem58nqP9IOaRfgFuNBof8UTkOeZnW8Io6o96BbJusImLwAUyBAopP7Q0IsrOusQLYyYR8Cbsvi9/USA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KvT7BdXp; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZE25mBEm; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KvT7BdXp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZE25mBEm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1791682388; x=1823218388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y5y0yW9WniY7DQrZFfcukYs9ZMeCuLXbdO4BO5lIhy8=;
  b=KvT7BdXpV+4GXxoARb6UY4mI11zIXB7TAUxCg/QNge7novi26Rn/hlt5
   x3L1LNejsMA+aKZV3casIi4EqB9xBrdfxhdEoK4scPXtSWKdsObJexz20
   C5+zOF8THVYkMNiCS52JE2Vudm1DxUV/1akgPyF86q5dzcBOx/DfzeIYz
   Dg7LOkYr1rEfafOEdmNjyti4e7RLnqen60f0gSGLp4A+HFNymdJXxAa8C
   1ErhS2dJbxiio77JpmPrnyr1csNVLcK3W21a4vV0VulymsFqMCQVXrLTD
   wz8LPMzIX98Z8ZPisyIMoRoxjffDA5q0sY843OCArTVehJPqxIlwEM66O
   g==;
X-CSE-ConnectionGUID: 3FgxMOcCSNKGktxhAX4Frw==
X-CSE-MsgGUID: j8U/SJ5SQpaFr2M5EXawrQ==
X-IronPort-AV: E=Sophos;i="6.27,150,1786982400"; 
   d="scan'208";a="157690155"
Received: from mail-westus3azon11010043.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.43])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Oct 2026 09:33:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/2DcuV/AEDr5ts0O6fbqO/Viu7o1tEBz+6XOD1qMs6gwGGa/Nawj1ZNnDlCzz/uuhC+wOGU8cXe55wj2CwK5/FKK2Ax6DHNN1tJV8S30oJkXJuiRnZO7+sA4eksb7Q2uc5EzZ9CPZeJljmBuRpYsKevtvxsszZP8NZIpF/DAgEzNM1fvjGGehHawq1Jf27BgET3dMR0RxnTvbO2ftUA9oDfXxYDaPxOh+axiPgMP7EWt5bdXBXEKnwQ8a5kHqpB2zzSmZnB8uCBWS2OVWcy90+uLAbaU6ms3tkJjiRKC0xXOfYVSA1mcsaVRpvPm1i0UWtfQgDoitam011mANrB2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5y0yW9WniY7DQrZFfcukYs9ZMeCuLXbdO4BO5lIhy8=;
 b=plPi5CRwhdju+qIZh3lkdBk57oFdRzUc+/LMwGZVwjTTRdU8MQEl+Ga5lztlCjKdxLf8sh5gfPkVfcMDgkPEaBWhFwim8EIi60kCljF2ntir7zLU78WDXCoIsZobK0eHpT6eJ0BgeyU5R52HYzDbxlM3az2s3e48YC5MwDxUMm24icewuUZfrNX+Yaf2yNJV4c4d45virsgHbhzyVct+NdfxA7vv5kxZviI8fa/6R4s8KG18zRVKZWSCf29QKD4iT1ojxM04ZXbJd7Bx+2T6Fj0w9fmjTsA9F5aqOYIha48SkKX9Ua6ikz8vNsyWuGPPFiDzbUwzqJ89sNwh9QJmHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5y0yW9WniY7DQrZFfcukYs9ZMeCuLXbdO4BO5lIhy8=;
 b=ZE25mBEmY4AdnqTOIQczx6atxaWE5VVaD6t9F8jFXSADNtK86g2WsVZCxBB9JbEtR12D5OvGwLpMex628uKKbAxZ7laCyu7/J+JB5OcQB9FxVfbvE0vaxGnQtC/z+PDeZbIgj0Qw5JW4c2lnEaX0K52ozlC/ovMIwWpsFU8lvWs=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by MN2PR04MB6960.namprd04.prod.outlook.com (2603:10b6:208:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Sun, 11 Oct
 2026 01:32:58 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%6]) with mapi id 15.21.0496.017; Sun, 11 Oct 2026
 01:32:58 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "djwong@kernel.org" <djwong@kernel.org>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Topic: [xfsprogs] mkfs: fixup memory leak on exit
Thread-Index: AQHdVXtCquID+nF6ek64bdvaE5VYBbbwVlcAgAAyfoCAAA/OgIAC6lwAgAQS7YA=
Date: Sun, 11 Oct 2026 01:32:58 +0000
Message-ID: <e042c937a34eb92afdc0208a2f6571076f096ba6.camel@wdc.com>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
	 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
	 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
	 <20261006144851.GX2705364@frogsfrogsfrogs>
	 <asd7554UisFwlOsc@cronus.toxiclabs.cc>
In-Reply-To: <asd7554UisFwlOsc@cronus.toxiclabs.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|MN2PR04MB6960:EE_
x-ms-office365-filtering-correlation-id: 8e63e8d5-c75d-4601-1139-08df2737950a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|19092799006|1800799024|376014|366016|10067099003|18002099003|22082099003|38070700021|11063799006|4143699003|56012099006;
x-microsoft-antispam-message-info:
 uaBQSBWB2qC48Z93FadXLugqX+VQVC0BAJE2jMt13bi1shvC6jxcI+wdS4CN/ePAQWvsfi48xg+s1O4RprYpdgVk3qZqjDj29PTQ5RaxPQ4qN6bTeciHbMcaW25reKdwSeCjIoQpFYtI/przWpn5aSUgmHTJg/50W6SpIqe19nDlFPUsadUrm12qNelInnciC5pRr9Xe/MScualX5BoR2d0TUk2YWZmER/eeN3ImhnzDWu8/rrvicaceMDPCgc0fshLwXPfv66YoXmXUZrkbIk5b2zllvcPyuB8t+bqKH7qykYDbTNhHzVSAT/5qnmmfjrdbIQTeVamDTMcbund3mmvX47KO7S86VqUouhL09UrYSJv5jKioel2xKfUl3IhTRV/VP+eHDrJoCf2VOnl4lHQSgXNW4DvpMN/4wMtqctpFi9kTQOrXqY2j0LQrgNf2bPB3ySJTJl27JFhH7Uss8Hl51RhacXgvGkWR8ZFOkV6S4pDEQT2yBOMIiE+m7JzwPS81SMkZz5IjYbDJ0E7zckLVj049IUd3f+GELVJN4h7K/7XMd8/iUIOkhIQEkooqlWVsJnbN3qz8Y3QxNt0+CeyisItUGRMlZfcBKXHvePSyadKJvHVCn4v4HI+bprZ/mAIumnb6Gl0/+iHo7citGXhQzUIdaLnnRckcyl3XZswhvRgym+v2/l+vL24sIEmzUdnXQzZGw8zXvxVsHmMsChZw2rDiY9p25GvAaiUDlso=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(1800799024)(376014)(366016)(10067099003)(18002099003)(22082099003)(38070700021)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M0RwdlMyazZxUWtLWnJoQUFSazRZUUFxTFUvN3B3YzJqMXZSa2hDbVViVmhz?=
 =?utf-8?B?MWpZcnNHaFlDUWNvN1JUYkpEZ2VKMVBPVVE1c2syYjRRbGs2V0JUOThBWWs5?=
 =?utf-8?B?QXUrSzIzd3lFdkh6UzJXWkxxS1EvaFdhVXpXSzVjVGFCZ3RFUzdMV0hBdk11?=
 =?utf-8?B?VHRJY3R1M3JJbnRWM0pqMlVlZzhGeTFGdENKcWNXZzgxTmpEbjZ1Z3duaHZM?=
 =?utf-8?B?Ri8razV3Uyt3c3grU2tHV3JUWDhPMVpBb3M4M2Y2djBrWWg2SXZEVUpIZkh6?=
 =?utf-8?B?SndGUERacVpZQVh5UnAyZFFHSTRnejJycFJOM3YxdUFiN04vMkp0dVIzQXNC?=
 =?utf-8?B?RXdJK1E2dUFSL2RPellFWXh1d2p2R09VZWpCMXFDanhMK1JrQTNnNGRXMjJO?=
 =?utf-8?B?RWJkWWlOM2ZIdW9PS01BRWxKekwwVlFsVSttbklxVnVzQlZSOFJuYkx5Tnho?=
 =?utf-8?B?ZUI1MGhZUEZSV01wdGNzdlh2dmxHTm1CdWpiYWQ0QjN3bFhvVkhXUSt6TlAv?=
 =?utf-8?B?c1o4UFlFVDN5L0t0eVhUSjdldUJ2UVloQUVFaFZtZEdCR3J1M3VnR0JuQlgz?=
 =?utf-8?B?WmlQVHBPZUVodzZBeVltQm5MdXNHVVAxN1VVZnhEQmpTYnhpa2JUV1FEQ2F3?=
 =?utf-8?B?Z1d1d2JpTGdoWEpQWlBrcHVPT0s2NXJnaExlOVZPLzUxSWZMMm1tRWk0VmNS?=
 =?utf-8?B?WkdvdXZNci9ZNmxOZkE1ZjJha3laUW5nQ3Rnb3d3TTRKcXpWOG5UTkZGTFdK?=
 =?utf-8?B?WGtDYUd1M0d3M2h6VlJLY0FvczZxMGlJL29UaGxtZTFjWDlqUDlyUEIvbzdu?=
 =?utf-8?B?ZGVlQVRZYm9tMWoxRTRsWENvdzlOVG94eHZiaWkxaml3S0FhNjlmVU1aMzlr?=
 =?utf-8?B?dkpWUXFCelQvZU5ZeVJraDFRTWQ3dVg2YlRFY0IyaFVYbHdiNDEzUmlYZHFY?=
 =?utf-8?B?UWxmWDRMRnNnS2pNZTdHejdxL0VLd2QxTUsydThCTFR5Q0JtQWcydW9ENjlt?=
 =?utf-8?B?QVNpTTMvV2duSU1haUtYZEJEWEdKbmV0WjBQeGxPeFhSODVxMVdIdUwvb3dV?=
 =?utf-8?B?WHFGd3ltaDF2Nk43QkJKWjlsZlBFdDNSdVVhSDdKVlF2TW5KYTFxc0E4dEdv?=
 =?utf-8?B?THVMaEx4OFRjQ0dib3B5cWpubDhQTW0yalRzZDZsNmc4VWt4NUhaSFExOEpK?=
 =?utf-8?B?VFpLclk2K2VSUkJWbVRqUE5NQjZwUFNtOXlwV0FLczdFbC9WUGt0QjEwd1A3?=
 =?utf-8?B?OXBTVE9qNCtUM0JOdFhtV3BlQ1NTVFlLU0hOSUtZM0syN2ppTUo4MlFWR2pQ?=
 =?utf-8?B?THhMT2lvR2gwYXBXVTB1WjFVL2NtQUIvcC83TmNOOURzRlR0VXpBY0orQ0Zn?=
 =?utf-8?B?WlFnWEEwKzI2bUFTWU54R1I1OENkQWZPMGljbjdSU1JhTGhyQXpnNHExMGxR?=
 =?utf-8?B?YVRHK2tmbTh3MHoySmwzaW1UVkg4UldqMFJJd2E1bkN3K3lqSXM5R202aUVU?=
 =?utf-8?B?b1dOVXkvcktGcGU1VUdIZWY0NFhMSjFNb2luMlNBbkZCbFYvZVRoLzhRNnpv?=
 =?utf-8?B?OEFudFY5MERPYzNDTU5MVWh5UHEvTGFRTlpVZmtaOFU0QmI3bTdkaEVvMzAx?=
 =?utf-8?B?Vy9mdlpyUkh4VHhKNWlsYXdnWUVmMW5FM29KV2pGSUExemJSUzQ5K0lkdTF0?=
 =?utf-8?B?cjkrMklqMndTakVMK3IzeUJsMm1sUllVK20yMzdyUnNDRVJqMXZxZ1g2cUxy?=
 =?utf-8?B?M1RmQlYxbG94MmpCeFBBZXIrVmNlYVljNHhUdnM5K2RxZkJoMHh5N0FBd1N6?=
 =?utf-8?B?MWJKSlNQWEJqa1c1bVlSK3NKRzU3N3R3Y2RhV1pSck8vZUxzTE8zODV3Mi8r?=
 =?utf-8?B?dU1GRjlhR0MxZlBVcDFqQ210Z2lHaDVQcDFPWmt1QlNDTWswUUpzV1BYUTBB?=
 =?utf-8?B?N3dMYTc2bzRaUXkwaUpOMFFwMk5SUzJuVGRRV0d4UnpYcFhHcjl6WDdHWUor?=
 =?utf-8?B?VjVheDFCOWp6SGVocy85dFFGTXErYlVkc0J0SmhiaTZBUEtqbm4wVi9JUWIw?=
 =?utf-8?B?T3FEcEFVbXE4SXVYY3A2TGdPcGJhdHc2aEZOMHp2bTBvTDhCdFMrY1lPY1Ni?=
 =?utf-8?B?bFR3WlNHWDFsME1RcDNMZXhCYWtHVTJ5MUxGQWNhVWZKT09WeTY2UllOQ3Ar?=
 =?utf-8?B?UW9wZnZyVUJ0ZGhpYTFkRitaUmJpdE9VS3dzdVNoNkhUbmlhR2l5RVJKdER0?=
 =?utf-8?B?dE5QcERCeEVRSVc2OG4xSFFJZkkzS2h0K0ZVdlJ3ZWxvbE5md0FUWG12RHIv?=
 =?utf-8?B?dytFSzUwaEUwTUwzTWZLRVFPdkVXTVlsWWFJdVh5N3Q5R2FUS21tdjBIK0Nh?=
 =?utf-8?Q?E2u0qndN4s5m6A5c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0699EDF9069D5F4C9664D172B81DC477@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	bipw+JhmKLr0J15FDOBs3myY4iPemj7KsOEPrK9Mekz4hpu2dZ/Dg6CUg0fq8cYMoa6PjUPxqj9gBOYcGbSMFRPTxNFGEAJI7HAYYvMneWHbyVVZiat4Pae8krq8LvwT5X0tLuB1EOv3+CmUclpl4SglxdpAkF7QX0giwwm+iexWfT4CDqeQTXd5B4f3g3VDYQ5HqGKwbP8HJNMiXj3NPsyS2tHXYkceYG8PndKRKNeTU2HFvtjPEM58AUjnMHUQGOkStxWAizrUeneF1ie6Lh37NTwEnCxlibR3lFUtvWavmrsk4/J3jOuDPPoN3cwWAlQzg0g6JPnJ34XHHM4B8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Powfjez0ZAgqt3ZGpt3RMKnY2whdBGKmX32h2ErTiPzwYRMRcV5xCy2a1lBuIs9I2WwznuT+v435o9ZQa3Oi/0vDu5PBLzdAILsBvIoatHL9MTjvfCeFRhBjoNFL4Q2mdRLN+22jjd7xrFfe2T9IH8QwmfFo6xzW9JHOxZjLheObtMPkeKQ2OSlEeQHxQrQaLcwGvMoQAB8Rgeh1x8B8EvMbn1D07ixt1IrT3gKnWruOjoH9y0FIX4/0T4u7FnI6Y5Q3+dVF6Ax4JwZYSNG0Gw0g5GD9sAnrTvQmixBjn8Vdkf+OkpukEWY2d3LAM492KcGjC+vK66gIxyZyRhbqbD3gxJQqgBBHjptXc2E4c21+TEiXOOGv95zrz3gz7+12cnJamylxKLfVGHBZsC5d5i0NmQ2MLgmvZVODABijojAPYOq++PeSIayNW+eFc+w+odk8Uln0YQkLpVjV+y+TV8KIne9D4/ZQK/AJmg7zpIP9TGlMJy+6u+KcyO6Gg87FwtDAAFduiFwMnF4tsDkworo478j+bGkPTpNWSu/qI7ofepyb17MI7yZ9rI/s0sIq8kdWunjPRKd8ttN3/rj33iDwilSqg/Y9tLcCQf4yl9mhF2qD9NgXIELbYwyTBtll
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e63e8d5-c75d-4601-1139-08df2737950a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2026 01:32:58.6556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZnMWQgtV+wlAFC3iSkeSkU2i+bjdhZ2koMQKBEkTRgCpSIEZZXeA9UxrgdIeYHl2MEo2eNW+bSgX7/6Y/Si3Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6960

W3NuaXBdDQoNCj4gPiANCj4gPiBUaGUgb3JpZ2luYWwgcGF0Y2ggaXMgbW9yZSBhcHByb3ByaWF0
ZSBJTU8gYnV0IHNlZWluZyBhcyB3ZSdyZQ0KPiA+IGFib3V0IHRvDQo+ID4gcmV0dXJuIGZyb20g
bWFpbiBhbmQgdGVybWluYXRlIHRoZSBwcm9jZXNzLCB3aHkgZG8gd2UgY2FyZT/CoCBBbmQgaWYN
Cj4gPiB3ZQ0KPiA+IGRvLCBzaG91bGRuJ3QgbWtmcyBhbHNvIGZyZWUgdGhlIG90aGVyIGdldHN0
cigpIHN0cmluZ3MgYXR0YWNoZWQgdG8NCj4gPiB0aGUNCj4gPiBjbGkgc3RydWN0P8KgIEFuZCBz
aG91bGRuJ3QgdGhlIGV4aXQoMSkgcGF0aHMgZG8gbGlrZXdpc2U/DQo+ID4gDQo+ID4gKFRvIGJl
IGNsZWFyLCBteSBhbnN3ZXJzIGFyZSAiSSBkb24ndCIsICJubyIsIGFuZCAibm8iIGJ1dCBJIGNv
dWxkDQo+ID4gYmUNCj4gPiBjb252aW5jZWQuKQ0KPiANCj4gTGVhdmluZyB0aGVtIGFzLWlzIGlz
IGZpbmUgZm9yIG5vdywgbWlnaHQgbm90IGJlIGZpbmUgaW4gdGhlIGZ1dHVyZSwNCj4gSSdkDQo+
IHNheSBpZiB3ZSBhcmUgbGVha2luZyB0aGVtLCB3ZSBzaG91bGQgZml4IGl0LCBldmVuIGlmIGl0
J3MgZmFsbGluZyB0bw0KPiB0aGUgZW5kIG9mIHRoZSBwcm9ncmFtLg0KPiANCg0KSnVzdCB0byBj
bGFyaWZ5LCBzaG91bGQgSSBjYW4gc3BpbiB1cCBhIFYyIHRoYXQgZnJlZXMgYWxsIG9mIHRoZQ0K
Z2V0c3RyKCkgYWxsb2NhdGlvbnMgaW4geGZzX21rZnM/IG9yIHNoYWxsIHdlIGRyb3AgdGhpcyBm
b3Igbm93Pw0KDQo+IA0K
