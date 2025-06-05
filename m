Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5017B50F
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125045; cv=fail; b=ggvtNckX64o7a7pDTjGckXJmE4izK8gjsTThVs2VkWnAiirwagBi7rXVXt1oX34k7wlQZNPxJLzVhOM4yjTnQCqQc8BQFBAFXsOH3HNsaXzZoOJ4rxDVUAlJD80yUc3DdJ93AAtMjsCBcbtDNBTspZaZQagr3OYIa6Wfr4Kr1PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125045; c=relaxed/simple;
	bh=Dd4YGr2ptkJTVai4BzmQaiGkhG1op5e+FCPSVeiCq9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XPKVieKgBDCzJQG/VZxS9bJjh1ZDcGPjFr/E1WsyCpNVl6eKCgkKOQnHH2xlpQcz5lhTHqleUgtHsXBtKLiRz1jMGQ7khkLJ+ZDCVHs7f7pXGKEkVpeMYFvxK69niwBcEJY9TG9+WYCvMeiJfLsnx7t0RbpVTYwjq0XqG8c5PB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=do7+bm5I; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=z5sFa67y; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="do7+bm5I";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="z5sFa67y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749125043; x=1780661043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Dd4YGr2ptkJTVai4BzmQaiGkhG1op5e+FCPSVeiCq9E=;
  b=do7+bm5I7IICLRz1BhKW0XporLBfheaW6HdKi1wjTbiMp7tRURQh3bEE
   KagXD7RZsx2+lFMhQB+gjYtdWx7wiSoUX2Mu5iBAzQPX/EVXxGDlYla+J
   tFKExGucUx2pmlkxYuNPNsQ7i9mr/hyCsYha92grNXnXcpBVZ9CM1/dRz
   sfSCYZyHiBTI4gi1aD7nYBXDuMozpsXuTi+YNc6Vz0miqDhb+IYP1U1b0
   4Ctzan6xLAvqFDs8MUZFQss5rey4xdTitYEL8yaB7v6sATI9M9ApSN+Pz
   aGSl8gBEECFBqkqL929KI6eTFYyxr2fshemMN55lVkdR78jQpj3lKUCCi
   A==;
X-CSE-ConnectionGUID: D+FKAM9sTXe6OB9J4Nsa4g==
X-CSE-MsgGUID: T9pKSPjfTh2Gj+b9I20bZA==
X-IronPort-AV: E=Sophos;i="6.16,212,1744041600"; 
   d="scan'208";a="90045815"
Received: from mail-northcentralusazon11012007.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.7])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2025 20:04:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qq/TXAVvrv2p8POe9aMo7W8qXVU9sAQ5U3uE872zPUuPFRpiJJAvchnM5yYZ4grG8DAZMvISvmNklI72JejOzHdMvpXG8aMSAgjJIiDtOlw3wb9/Pr7xmqJg3Dk3yEgLPiC74rppeLic+kCiCneUpjS7uwuiVeksGpZW6Sc9uxQYKh57pshidTxoNNvFnt7WHMgPrtbnby2HAm1lxaB1Tst4cv7Y0sD9nFs6QLdD0n/cXHkl3TGdqOcurocqI5yVt71QpRDvSQjNYRkrFOc+QkHmCp+afxQACLZ60CoH6N/V/hi0A5WiMjifvaJSpNNOdIIswX3co5zwX3ZZJVtHQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dd4YGr2ptkJTVai4BzmQaiGkhG1op5e+FCPSVeiCq9E=;
 b=RbrxOS3lTUWkzcCIzHV2U7OTK46WXpwer4mx/l2bjVAh6dT1b8EEqv5ZMsUpTYDl5804ZsK6IDvg4gcQPwMXo3glf+Nc9GtTNkvOJ8IfqFcrexjELb+DsqLxJPRHHil09qMlpI7Uf3cOKE/4pgfmWT8ay0juv3CBe//Y+wbwPY4S35PBp3HRm0mjcesJCVadSVqXtjmgEawagGQWADQ9KQsAOmguweukoBEiCjGFoV6KBRQEJkwwWhfHuk80bgeGGcaAS2465kADB5WhR8+uXcRqa8MCJmN6J3JQ7vUlkm9hkq+/IIgABwhnZy93hcSoA4rjwzojP+VK2mDe6/ghoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd4YGr2ptkJTVai4BzmQaiGkhG1op5e+FCPSVeiCq9E=;
 b=z5sFa67yMvBz/NDfKufRleEOo77WvmFTUKcGfDYfxk4iSIL5lAWfxrBXNaCgkIWCGS4nVuG/cjzowWqiUDHoQO+gfJ3jlJbchDVY30mHz4IXdbYSl7iqjSI9CNrGMVGxeXa/KTT+m/67y4z6hipihSI/rnCLVdMRrcov1eyY+o4=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB7787.namprd04.prod.outlook.com (2603:10b6:510:ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 12:04:00 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 12:04:00 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dan Carpenter
	<dan.carpenter@linaro.org>
Subject: Re: [PATCH 2/4] xfs: remove NULL pointer checks in
 xfs_mru_cache_insert
Thread-Topic: [PATCH 2/4] xfs: remove NULL pointer checks in
 xfs_mru_cache_insert
Thread-Index: AQHb1eFyy9NtcLXzRU+vGNGK17gqWbP0eBUA
Date: Thu, 5 Jun 2025 12:04:00 +0000
Message-ID: <26b8d7fb-a090-4da0-ad54-8b3b3915c21f@wdc.com>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-3-hch@lst.de>
In-Reply-To: <20250605061638.993152-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB7787:EE_
x-ms-office365-filtering-correlation-id: 1690c43d-9422-435f-9139-08dda4290ea0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NHRZR1d4Yi9Ha2ZtV0o1YXgzNFlqUW4zb3ZoK0tKaG12Y3BkNGZPdE1LSDhh?=
 =?utf-8?B?K3p0VzZoZDlxeVExMnJLR1dnOGJOTUZLS0FWNlRWSkUzUFRiZEZGN1pKWE13?=
 =?utf-8?B?UUk5VFlxQ09qY0habHgvR0ptQ0xjaTVrQTM2VVBNRExNZ05wUENwZmorQ05o?=
 =?utf-8?B?Um9RY0prUjFaRXZBaFlIZzNaM3ZiNFBFMTBrZ1JpcUl0K2hLbElHbUYyYUF1?=
 =?utf-8?B?T0krbDZoaURNSHYrdEFJeStScHJYOFZvMllKbDdXZkcraHRxUlQ4L3NIOG12?=
 =?utf-8?B?S01PTHQ4S3RJdksvVHhIQUZ2M2gzemN2UFcvbFQ5TUZFeGRLZ2hoU0VUNGVE?=
 =?utf-8?B?Z2tTWWo4b2hSWjBkTTluMklhcXJ6eEQ0WlpxQ0VmZ003WjVvYlZ3aUpyUjU3?=
 =?utf-8?B?SkZQZmRiODhSYmFLZ2dZMVQ1c3drVkllRzBlNDVRZ2pDbmdwcThqUTk4clJu?=
 =?utf-8?B?SVdxMWErbWFyRFRmcTlPQjFZMG1YSVQ0TnVWMjMyM2dUeExmSGJXWUdqMUdG?=
 =?utf-8?B?NzZjRDlkV0lXSEJtNzRDTGJGMUFMRHcrVFBTbkRhNnRyM2toMnVRRWhOTXhX?=
 =?utf-8?B?b0Y0S1oxeFY1NlJrT25XanlHZzVYR2VNWHVaWVZlMlJET2RKdmE5S3lycm5W?=
 =?utf-8?B?RlRpeXF6bUNkcmpST1FaR3VJTExNWTJqQnlxMWhpZGpsWFd3MkxaaEZkYzNI?=
 =?utf-8?B?aE5nY3FIRzdoaE5VZ1U5WkE0SW94WEp3QnJqTUZYRlM5cGUyd1kzeXVaZjJR?=
 =?utf-8?B?NnJkREFEcHBzcWFyZlRQTnB2dEdHT0hPZnRKcFdxWGpjbDVqbTdtdTNvUlBh?=
 =?utf-8?B?ckUvSWl3Vjc5UTN5V3QvQ24ySlZvNjRWNFVWUEREbks5Z1l1YitOdzJZcUo0?=
 =?utf-8?B?U2tIMEZaYURzNUR1SXlvQ1Y1Ym0raWpZZ3ZZNHJkdWlXLzV0VmZLTjR5blUx?=
 =?utf-8?B?bjY1T2NIK0thMVd6Rmsyd0t0ZHRMNzgrWk9wWWpDKzFNWjdrT0txc1dSQ2Zl?=
 =?utf-8?B?U2RaUk9Bc3FRdkJ0WFZqY2lKb2t6WU1FTFRVSE9zM2dVRVhUVTJENXpwRXdz?=
 =?utf-8?B?MzhXald2RmVoKzlWcElicjZ1TTlUazh2b1EyNFBEamhTdEtYNkRFU2NDU2tD?=
 =?utf-8?B?TzgrYXZwNjYyZi9UTmxnRU5TYjdsUll3ZGppSkN4b3k1aDh4dXBrME02RVdV?=
 =?utf-8?B?d3NPbGdxSE41Y3JYNzFydlBzMEtINDVyWC9KTWNPaVc0UFBkd3RFdTk2OWdx?=
 =?utf-8?B?L0piNkY0UmhUNWY5bUxaQThtdWl3Q09SazdyNFkrUkN5RXZRbGtDOTZ5bHBn?=
 =?utf-8?B?Ujl0ekRRZkRubGVLdFltRmZYc1dXVDFRbDF0SkpKWVRrbkxyalUyMVpBUXRK?=
 =?utf-8?B?L0RTaUJHektGZERhUnNBMUdSWUtGKy9yRTNWWWFWeitPNC9MMVNGc0hTUUs0?=
 =?utf-8?B?NTh0ZWxySWQrSDBacDgrS2d6Vllpa01SWFhJbDlnclU2eExjNUNYaDZvMi9G?=
 =?utf-8?B?bEw4cDl5NmY1K2RhWXVFTWwwZDRZNnhRZmowNEsvbmRJcldIZHAvL3h3RkNH?=
 =?utf-8?B?ejRZZS94c0g4SmwrajBhQk1uaXJQY0szQjF1MDJ4Yy9qUi91UmpIbk91U202?=
 =?utf-8?B?N3htanhlc01KNkFxSFV5b29PaFVmbnRFM2RnNzlJc2UrNlpxY1JBMEVjZkZK?=
 =?utf-8?B?aW9IUDI4MFQzOWVEY3l2OHd4NXZyUDBSNXh1ZVBrMG8zbnNyZDdNUW4yUFow?=
 =?utf-8?B?aHVJeC9xUjJrWm1qZS96SENPbkkzVWUrNmJNSTNUS3Jrd2lEK3VaaEt5MTFn?=
 =?utf-8?B?SnpYKzhpT1JDNEVNL05wblVuZFFtWG9vZTFrTVgzSWxPeFFaY2RVMUZoUTQ5?=
 =?utf-8?B?OFAwOXdhd0F0c245T1hGZmRpaEZBR2pnUXZQRy9QWlEwNERlVnBiUXRMcjZT?=
 =?utf-8?B?U3hrRTdDV0VzT0ZrN0tXNnZ4MU5XRGpHNW5DTlUxUnVSdTd0WE1SRmN3TlV4?=
 =?utf-8?B?WElpZUo1TnB3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnZhZTBoVmcxQjF5aCtxWWE0emNzemZkcGJzVHF0SllDTUY3NEpVZEpiUmFn?=
 =?utf-8?B?K251ajNDQkJSWUN4Uk01clJnY2VxU25MZWtFeVlFODI5bEgrTzJuazBwYnND?=
 =?utf-8?B?R2Rwc1hOaEFCc251Y1NCd3I5MTlIcVd3WTlnaUZFQXpLMVJVQWRwWnRQdWQv?=
 =?utf-8?B?QW03QjlrY1RocDdxOWIwckVmNlJBb0ZLb3o1VzNKbzNudnQ3UnZlYm1JTyt4?=
 =?utf-8?B?S2ZNU0h2dWlDSFFUWTRhYXdVSVpnY0d4Mlc3NFpMTjdIQWI4QWRFTXlSRXgw?=
 =?utf-8?B?RjZ4a3E2OXErVjRMMkFLRHRwWnV5cVFRam43NVJaNWhHcThNbHpGTFBJVmU3?=
 =?utf-8?B?Z2hUTGhReWREWUplOWRkbjRPaUJaK2xwYjZ1RnhmSEFQOEFlQ2xOY3RWYnVF?=
 =?utf-8?B?R29wQ3R5WjNNajY0V1pTc0N4eDlqcmpXbjdEeTI5cXhWMFViWlFRckJBWHpT?=
 =?utf-8?B?dGp0MTMwN05sL2RDbWUySHZkZTBWT0w0RFBLN3F5OHBHOExhaFVlcTBmUFpj?=
 =?utf-8?B?NDRsYUM3WTRvckFhV25JVllFNTdiRE4vSnVsSU84UE1DbFN4VWdrWXd6QkNh?=
 =?utf-8?B?YnJHMTd2NEl0UHp6RmtQazFOQUozYmpTK3VwbmZHZlZNN3BFNmsvNGIxWjBZ?=
 =?utf-8?B?UENCaDZnTkdmVUVXRkd1LzhKb0w5OTFPVTBzbE5hZ3ZBV3RhVHo5WVJZcXN0?=
 =?utf-8?B?WmEyWGVpTjJDYk5QRTJQWlFEVGdzcGo2TllwMm9IRnl2ZVNOYTNpWTl1SnBO?=
 =?utf-8?B?K3J6V0trbjYvQ2hONWx0NWk2WnJOMGFlai9QSG9odUhsc2d4NEdWeFYra0sr?=
 =?utf-8?B?aEQzdkRLSWZNT01jUFQ1WVIvMk5MbldYL0QrNmNiVVFCa3ZabGgyQVhseGlQ?=
 =?utf-8?B?NFhwem0yakVmMCtUdytCQUlLaVdsa252QnhGcWozUnpKRVZCbDkyelRqTnZR?=
 =?utf-8?B?Ynh6TjRUVTAxNHlucFV6Ymd2V1JzWU50Q3FCSVdDL2t2d0xoVGk2UkFpOFYy?=
 =?utf-8?B?MW96YkpiWUIrN1pHNkN3ZVlNeTF3NVdYT1V5eXVJS2s5NHZKOUF6RHBwS2Rq?=
 =?utf-8?B?RHF2WWxSeVIwcnVmRm9jTHFpMEdWWStCR0xTWHFTS0ltbGdpemJsTFMvM1pP?=
 =?utf-8?B?Z0hNN3B1Y3RLUExkQnBmM3FqU2dYTVpNWlRvcU5aU2tTVDFvcTY3eVoyTnYz?=
 =?utf-8?B?Q3FrN0RNRU85K0FZN2NFOEc3S3QxdHRuaGE2aE82dzNiWWcwNk9ZRnZEZTVk?=
 =?utf-8?B?eXRpRVcwUVhQZHFPN3NteVJ4bEdmMVhJUTNTQ0VWTmJlaHlhOHpyMm0zZ1R2?=
 =?utf-8?B?bGlxdnBiU2lDODY5eUpsRWlyQ0JiWjZtajVUMFpKQ3ZHWHBockhJQXJZWG00?=
 =?utf-8?B?UHo5TUR4S0dzN3huZFlsekxaR0o3cFZ3Mjhmc1ZiTkpEcG0rUUxBY3N4MnYw?=
 =?utf-8?B?V0hoaDdCWGo0TDJLcjNyUERuSEJCNCtDbXhxVXRxS0pRMUpnV0pyOFRneFEx?=
 =?utf-8?B?S3F2N0Z4a3RIM0w0dUM0OTF6QWlEbnQ5TmhJUlRmWm4vSjM5Rkw1aDYyNG9o?=
 =?utf-8?B?anl2dEVkUG1RVHc4RVR3T3lJUURmOThJUlVXNHMrZ1gvdUpFOVYxdFJ5WnEv?=
 =?utf-8?B?T3hzY21Od0tGZFNyTkRNdzAzY2c2SVJleFNhSWlOanM5TmJxYktoZTg1cE0x?=
 =?utf-8?B?T3JNSlVZUUx3bmlzUG0wWjRPSENwU2xoL3d0MFNWVW9pS0xmNStEUHplaDg5?=
 =?utf-8?B?bHpMWFdaVGFJUDdFajRodCtvUFNOeDZ5NXN3NkxYa3N0cG5UZmxCTmFpcGw1?=
 =?utf-8?B?MW8vMXJNdWFJeFN6eW0wRlNmcUkza2VHM3ZYYmpscWthL2Q0NTdNMEpkeGw3?=
 =?utf-8?B?NElWR09pTHBqODNTaS8wZTdHY215aW1Ka1NrWDQyVEpjYjJZU2s1L0JxUjBi?=
 =?utf-8?B?VmRSVzYxOVFlZjFNOTVIaFJoVzFUdXZSZGdRZGN6WXJLMjhnVlRIbWNsM2hK?=
 =?utf-8?B?ZWc1emdIR3A0RW0yNnhndE85UFpiK3ZwQ0VuNEZyc2xyaXhnZ3FEa0VIV09v?=
 =?utf-8?B?MXl3SlBPZk8wRWJ2Q1BsYjZ1NFZjL3pUYkRnaUxhZzVtN3FpL0pLYWMrNDUr?=
 =?utf-8?B?bUNzckhCTW1ianZXSzhNV2ZheGl0WGd6MGU4NjVYa2hHaVZ6VHh5Vm1QMmwv?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F220CCE62A6F454D8B4A703C237D0CD4@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P0GfXyb3znSTtccdAocC7BG7R5xVyCJJGE7FOJQiKuGPnS8FAkA5GGQEINJwXfQLe55m9JvvUiNZpWumVvAPDdCF5obo4hoJ3E3xkK8aDGJ6+g4WC14WbP6XWC4azOnaMwQ6d9pXMPzEpakZoZXJKXLg2KxGfECzy135KfZVJCZKIqbX9+UzRFmdwaEbzi3TCKXBnY/A5mpTheE4mLqWRQ28bDwh6gf3F19RY1ZT9KoBwkedHmjGECBo3ctx0VjXdf2eQAL7MbcU5sJU7T9xwsDD9JYck5J3zIWCDzR5u5Ycqbojh747N6PeW26PCvmXDZJ70q6BrPI8UQ1G2vv6M8M6yUTfYjOpyPmb5hBsMxfqXb6OoF70l/YNOpu0Ux5r4VL88BuPX7iBqWXsf4dPiCzg/gbcIiRXAd0z8BCJuOXgwMgiQo6YVTeJLRFxFUCnZ4ERZLbrPWd0+0yx0du8nn2gq79zegF8V+PmApfqRmtWkEzrPJJsZ4cJ4Ms9ONTVO12wcJRoGRMKm0z1CVrjc50nmWep0DmqIkPu4Hl2Pk7ngD6fXWMhoCvWzQHe+da6w4Jd8EvzLKyjZ8k7rSbPNMgr8RLGCYivAvD5BkGz2Oml3d9PiFIdur0trajQ9B2n
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1690c43d-9422-435f-9139-08dda4290ea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 12:04:00.2281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xiCE1DIU3DXZZEK97ei7fQ65dFvBzclQ0kINOfh5CFNacA6e7D/oPo04lE7Y6XCAaMiB40/7nDd6sbNnYqsWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7787

T24gMDUvMDYvMjAyNSAwODoxNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFJlbW92ZSB0
aGUgY2hlY2sgZm9yIGEgTlVMTCBtcnUgb3IgbXJ1LT5saXN0IGluIHhmc19tcnVfY2FjaGVfaW5z
ZXJ0DQo+IGFzIHRoaXMgQVBJIG1pc3VzZWQgbGVhZCB0byBhIGRpcmVjdCBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2Ugb24gZmlyc3QNCj4gdXNlIGFuZCBpcyBub3QgdXNlciB0cmlnZ2VyYWJsZS4g
IEFzIGEgc21hdGNoIHJ1biBieSBEYW4gcG9pbnRzIG91dA0KPiB3aXRoIHRoZSByZWNlbnQgY2xl
YW51cCBpdCB3b3VsZCBvdGhlcndpc2UgdHJ5IHRvIGZyZWUgdGhlIG9iamVjdCB3ZQ0KPiBqdXN0
IGRldGVybWluZWQgdG8gYmUgTlVMTCBmb3IgdGhpcyBpbXBvc3NpYmxlIHRvIHJlYWNoIGNhc2Uu
DQo+IA0KPiBGaXhlczogNzBiOTVjYjg2NTEzICgieGZzOiBmcmVlIHRoZSBpdGVtIGluIHhmc19t
cnVfY2FjaGVfaW5zZXJ0IG9uIGZhaWx1cmUiKQ0KPiBSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRl
ciA8ZGFuLmNhcnBlbnRlckBsaW5hcm8ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX21ydV9jYWNoZS5jIHwg
NCAtLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9mcy94ZnMveGZzX21ydV9jYWNoZS5jIGIvZnMveGZzL3hmc19tcnVfY2FjaGUuYw0KPiBp
bmRleCAwODQ0M2NlZWMzMjkuLmM5NTQwMWRlODM5NyAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hm
c19tcnVfY2FjaGUuYw0KPiArKysgYi9mcy94ZnMveGZzX21ydV9jYWNoZS5jDQo+IEBAIC00MjUs
MTAgKzQyNSw2IEBAIHhmc19tcnVfY2FjaGVfaW5zZXJ0KA0KPiAgew0KPiAgCWludAkJCWVycm9y
ID0gLUVJTlZBTDsNCj4gIA0KPiAtCUFTU0VSVChtcnUgJiYgbXJ1LT5saXN0cyk7DQo+IC0JaWYg
KCFtcnUgfHwgIW1ydS0+bGlzdHMpDQo+IC0JCWdvdG8gb3V0X2ZyZWU7DQo+IC0NCj4gIAllcnJv
ciA9IC1FTk9NRU07DQo+ICAJaWYgKHJhZGl4X3RyZWVfcHJlbG9hZChHRlBfS0VSTkVMKSkNCj4g
IAkJZ290byBvdXRfZnJlZTsNCg0KTG9va3MgZ29vZCB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IEhh
bnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
