Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3119620E309
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739366966; cv=fail; b=jspOoYPUr4CNBk/kA+oLUZ4jjL6sa6lBMSVZaDKcb9A3Lm3Behb4aAwXM2fjgibDycdzTQkDhRKKGlPKjBUmV0DrOIO80/wYLK4ERCFfdKYbDAfyvWSA5AQ/ZwbMEcwrtU7VdW+8K+94Phh8qUR8+Fz+NxcAmQiPfLcDftgtuRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739366966; c=relaxed/simple;
	bh=8pvVu9zjL97uRH0aMIMlnq3ots4NM1y7lfs32NSKsRc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GsI/PZRYINqNk872y6QaXNpUo+nrmFsSFKnRTUhQBwdEoM1qV7/9aFyRcknGdNWJTwLGUWG2eO70MNvQuNwJuob88U82fNOIB/lzbTlToudLHI+/STNz5L41BwkZ9AKKZuVUa9XFpbx9TbFUjsKkymbgZYB9CwDgNrw7YMl4MUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LyO75w9D; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zTxb4oRD; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LyO75w9D";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zTxb4oRD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739366965; x=1770902965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8pvVu9zjL97uRH0aMIMlnq3ots4NM1y7lfs32NSKsRc=;
  b=LyO75w9D7QnE/qQMkJ1HYLygGBtJL4UIx7nC1xUCYtpQWlwSvgCZBM5f
   XyejHNEXSFHzOJr4fbxaPb+jn4QtpacNruAFxZFiXSr93Bk1a+Hz6EL3I
   4d3R0Qykc9pcwEYOzTPr2aYffMSbKRBl4+TMFzZ3WsQDFobQuJBdqNMP/
   rsVXKVOnbFUptPOwFL5UQUUxpd/7ykQYT0NtM86Tv12V1u+vWrldnleMb
   XsQ21jCLJQwUFKlVT44GQZ5DaBrD1FKx/h+DutR7dCww+6Jzqon60VJcM
   K8xZABnVc72WO4uZtPCVIVns/s616bBCzN8DWXNHVbNIjjznlyR6vbh2s
   w==;
X-CSE-ConnectionGUID: H8MqANbQSHSBr6GTxsAmYw==
X-CSE-MsgGUID: f2ZiCdvzTdGzYlWiXOrQ/A==
X-IronPort-AV: E=Sophos;i="6.13,280,1732550400"; 
   d="scan'208";a="38870839"
Received: from mail-mw2nam10lp2049.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.49])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2025 21:29:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPTNlpztmsiz5P+LkwCwHdTWtQRQoCnjDCHXyw41FlxnP+ke5KVobvVZq/YV5PanopS7ntwS0Bb2JxUO9UvGIVSBd3FKcTTFplNfY6w0rqMzzcFPMe5MTWNQdg1VFhDvTSPHanA4sPYxrX0Nacaud+40cDEt9K0SRDMiyA4W1V9QWFctT0TXcuXHg+VOnsI/o2XOv9vOgPJ07IQ/kwAxsqRbuOai/NMgkDVkqIQnXcJ0b7L9TtZN48qkkodv6nU3EHwy3r73bfRvI6v9SN2mSehTiLTwvriS0l7HTniXkjxbL/KDmFhJkbpc3O2QhnEQpAdUu7Vjis4FKWPV/Z0ctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pvVu9zjL97uRH0aMIMlnq3ots4NM1y7lfs32NSKsRc=;
 b=ieqm5rjmfi+HmbPTDIfmdO4JeqrRVV6Fn7/rHnyIGYl/W/15XTh1gQdsUWrTQhQqa/uiAEseH76n0xExe1st1kq56akBauIaxW8XntXhJU/ug+EvU7IB2d63u9IsAISf7h8dk0DdppvFKaRt42jPxSEDXOcKi3LWEaY8qLjZCt+w6r5xOknnOzTRi9ljf3XmMBIEisCcteVfY/J4gFDBfvRuuRhS/g41EcI+w+vLYiKK1k2A1MKwUq3etBJjqow3mQRIQZokvcDNJWTQ+meVj1u4e9lPkspa94GZcgrhjcfvq3RJnmnKoesVxQxUly6kH0CQY2yJe7pFCDMty2XWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pvVu9zjL97uRH0aMIMlnq3ots4NM1y7lfs32NSKsRc=;
 b=zTxb4oRDktjxbVSZDulbcxey7Iw6J/44W8cd29n974RkqBdS7WCwhJ+uRi90uPqBPFTUuVOK6eTdkLc7AG6LuH69qsommRWjQ/JDIpkCNITnNpGKzqTkkTZE+ZZjToFdf+Ia6UVvy4eml66vGXT7rRe08cqWMNdUnU0kXh7Orfo=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB7525.namprd04.prod.outlook.com (2603:10b6:510:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Wed, 12 Feb
 2025 13:29:22 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 13:29:22 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>, hch <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Thread-Topic: [PATCH 39/43] xfs: support write life time based data placement
Thread-Index: AQHbeGMNUHBiCs4vP0Oy/NKo2p6w/rNC2QIAgADad4A=
Date: Wed, 12 Feb 2025 13:29:21 +0000
Message-ID: <c909769d-866d-46fe-98fd-951df055772f@wdc.com>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
 <20250212002726.GG21808@frogsfrogsfrogs>
In-Reply-To: <20250212002726.GG21808@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB7525:EE_
x-ms-office365-filtering-correlation-id: 202fa769-9711-4185-8474-08dd4b6942c0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SVhEb28vRlhWb1RQa0xmR0lkbDFhQXBYd1FoMVhmN09EbURNaWIvRlpiWCsr?=
 =?utf-8?B?SndzdXduMGdFTG50NExtWWhWWWxYLzdnSFl2U2R2NjcrelM4ajZoWjhvMkt6?=
 =?utf-8?B?bjA4bHNhNU5lcE9qTTNzL0MrQ3phWlFpTS9RV09mT1F5bThyUERGSHoxb0c0?=
 =?utf-8?B?S2JmTDduRDFlL0hoLzllQm9UQWVkZERMclZIYURWcHBZc1JFQWRuU2V2a1F6?=
 =?utf-8?B?eG0vS2phUHhLUjRwYndFVUJYMjFTNGxybkh0dmJOdnI3Ni9rOHI3TGxPY21C?=
 =?utf-8?B?Ym5oZzg2WDVsM0ZzTk1Wb2hvRG95L0hCTFNBaDJZU3MzME5WditOa053K0xZ?=
 =?utf-8?B?eTZsSzZ1VlB4R2dzK0dQYzJMK2FpTncvQ0N3akVobE9Vem1oWS9SRU03dGlo?=
 =?utf-8?B?RVVhTWFGS1pQL1pocHpFeWJ0ZU1PVG5URytSZ2JLNjNsRGJpclJqVlpKY1BW?=
 =?utf-8?B?OThDdk5MVUMwcDVpZVMwa3FpRys2L091dFUrYjI3RjFyOTZvd3pmTmxSaEJO?=
 =?utf-8?B?K2Z6OVNhSWRKT3RLeUJpVmYyM2ZNbk0zem1nYm8yNjV3NWtwQVJDT1EvMmc3?=
 =?utf-8?B?TE1JT0kwMThXK3BVbnA1K3JUbDlpcU1uWmpwUGM0WHJ1WEhRNldWeUZkVHQ4?=
 =?utf-8?B?Z1FsSExVS1dlclhRckpnNHN3aVVHeWdEejJRSFI0TmxPbGFPVlFBM3F4SU50?=
 =?utf-8?B?bjdWRU02NzZnVEhXRjlUS3I0aVc2TEtNZVZSRG5QTHM2S3lZbnZtSCtqWEcy?=
 =?utf-8?B?MG9pUXcxbE1qOU1OL1RNUWlMSWF2OXd4TEpWMzhaYUZ0anFIL2dtb29CbHhF?=
 =?utf-8?B?UGlGcVVGc21uTkQ4WitZT1lkemhyd2ZVb0NJUVR3K3ZxeVZpaUMzS3RkTUF2?=
 =?utf-8?B?RkEwdlpteHN6d2FhTXZudnhCQzh0emN3RnY1VU9SQXdVL3JkbEN1YzJyVGRr?=
 =?utf-8?B?UkxQS1RKOWhBUWg3TnF4S2hrbitNMlVnTTE0UGdJekcwVWtic2RWR1k3cE82?=
 =?utf-8?B?ZHVXTVNZdVg0dmEycjFrU3JoeFVFYnMwS2dCMTFqN0NodE1aUTlhWFFVV1Rq?=
 =?utf-8?B?Uld0amllVmtIbE1OMTdxVyt1MEZVMEVqQWVEN3pSYUdrM3BzTDJ3TEgvcFlV?=
 =?utf-8?B?WG5kdVU2ZUxvNXdCNTNWY29zdnIvVzNVWmpRdzdtenVQeDhyZUt1V3Uxb1Ux?=
 =?utf-8?B?dFZ1cVRXRG8yMGRCa1dXM1V5Q1hEb0MzVUwwQjhpS1V3MjVDUWhwMGNGck5S?=
 =?utf-8?B?K1hSQkdzLzlLZHBOSVMvdWNZeWJWQkc0dUozRXBlcHd6SEJRUExHUFFCTkRk?=
 =?utf-8?B?bE9yZVY1emVoWGtwWTZoTGR1UmxjL3JpQUZmRzVDdzBwVWtiZHZ3dmFnRk5o?=
 =?utf-8?B?Ry9oWm9GZnJ6bVNMQSsvREQvZ0hEbDVxY0RsZlhWdTNGT1BSanNjQTJVbFJF?=
 =?utf-8?B?VXFVR3UydGluc3hkeGZXYVB1YzkyMDZDcE4veFVsK29JQVRPYmptanNXVWZx?=
 =?utf-8?B?SHNYMjlmMVZWcTFGd29nSG9nR2M3NFlxWHpzWGFRbFA1bVJYMzIvTXl0aXkx?=
 =?utf-8?B?WGY3VHlNLzZhVjRlSmF1K0V2YkF4T2VMZGcyWnkwVnFyY3g1TU1xTEtsby9i?=
 =?utf-8?B?UEtXN2g0VGdoT2l4c25SRkF2S1ZCUklBdFdvUGtkdzJ0dVdiU3VVUTZKaW1z?=
 =?utf-8?B?N0RlU2w1eW55RU9CdXFvZWJyTHE2Si9QcUtEd0x0QUgzR0xEYmRHU0RaQXFr?=
 =?utf-8?B?bVBMbHU5WmRiL3pvcXBYNVc1akZRQVVTVEQvSzZYK1Z1a2ZrOXlXNmltNEhR?=
 =?utf-8?B?Q2ZnVjl0R1Z1QTUrQ2RWWmZEM3oraGpGcm02R3dXTjBJeFZHZGFncFJHVDhi?=
 =?utf-8?B?VHZaMkhLa2RhVEVCdFBjTFo3K1JQM1E1TnFSMERZNFBKQzJWbjJUWlN2Ly9K?=
 =?utf-8?Q?JoIGJLoEDlWNj1i2nV1PQpIse/BHNmRR?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGVxMGRUS21qaVRtOGFlcVlVWnJoQWN4QXBhSlFFQlY5S01PV2tjaWgySVhO?=
 =?utf-8?B?SFhWZTlIQ0pzNHBabENpMUVPdlRsS1R0b2xyODNtVU9yamFqTVB4QlAwY0gv?=
 =?utf-8?B?bFppOEtpNURJa0xUM2EwaTA4Y3FzbitmbnFHSmRxa3JkeG9JWXVWQVBuUCta?=
 =?utf-8?B?MGg3ajZOV2pVdTdwK2puRFVZMHByZ240R2k4cDJTOWxIdEp1aDJkUG93KzVx?=
 =?utf-8?B?dThObVRlejZUZlkzSWtmMzlLcXdOMW9ldTIremVLd2M1SDBoR1NycTUvdWJx?=
 =?utf-8?B?VTQydlRPekd5UWpKYU51TVRkODc3Y2RPQmd4R2xXcUR2amsveTFMY1VmVjEy?=
 =?utf-8?B?V3VGSXpKQ1lTTjlVZHlTUUFldVRyNWNDSmlBcjVDZWN2MG9LWGNhM01sUVF4?=
 =?utf-8?B?N3FoQkcwc0p4Z252QXdBRzJ4UkxzUndWYzZERXRxN3hwL2FTWjJwK2xzanhZ?=
 =?utf-8?B?UHB1eUxjVkM5UnE4VSt6VXpZdW9sNlRSTERyNW5OWUVrOEJHQmh5c2NUdTF4?=
 =?utf-8?B?MytEalA5RExHQUp1Y09NWElVeXdUR3ViM1BWa2d6WGpyTWtNL1NpU3l4M1oy?=
 =?utf-8?B?MHl5TWZSeWVlYjNnaVNvWTBMbDFpZlg5SUQ0eTBwYVV2c1VkTURLZWRNV1o2?=
 =?utf-8?B?R3hJU3JTaHgwalM3NnZPRzB5ckhXQVJ1WVhNMHJzRmZ3QTVHZjhXbmxhRm5N?=
 =?utf-8?B?UmtXM3pUZ1VwSXF1TDZ2Wm03YW55TXRZZUE4ZE96cUJQVkMyMlpaSkZZdGlr?=
 =?utf-8?B?aHpJMzl5M05zM0l6YmlPUDV3ZkRvWFNDc1BxWkpaeXhXSEo2SklXTzV3OXg1?=
 =?utf-8?B?M3hCaDFXSXozMmErNDlNMFM0TlY4VHlBbkRxTUdncUFSZnAraVJLdnBzazZy?=
 =?utf-8?B?aUpaYW1rZEJsS24wTXMvbFAxYkdWNVl1ZG5pWGxzMytxR29EMjdCS0tXWU1m?=
 =?utf-8?B?dGpjaUlDbU1DN0FDcE5xaGt3cEN3SHBQTFMyN2VhTEwvSUdzd1ROYzJLTXU0?=
 =?utf-8?B?TGd3aHVKNWR6KytySlgwb2lKNko1S1BiK3JtamFuM0xDUGptVys4Vk0wdnJY?=
 =?utf-8?B?c2V1RkpQbmtUcmpFb2ZNWTd3d2N5UWJ0T0Nsa25CSzA3bkxSaDhna01kYWh4?=
 =?utf-8?B?dk9PVGhyY1BUMXlxMFY0WTBRcm9YSkZnWGVhdVRrY3ZNQWRNU3piRHdzU3FN?=
 =?utf-8?B?aEZUQnZTQkU2VGVrc0NVK0NqbmlSaUE2bWl5NldkRzBFRldIZ0NvRnBaSUpp?=
 =?utf-8?B?S0RxV0ZtWkgxc2cyeHAzTkh2d1R5d3lnZFdBeWJzcmtYSnZwMTJhTWtIWUtN?=
 =?utf-8?B?MTRUeTFpaS9xTkNiWGloekREcWxYUzkwTDVrM0xMNytwV1JPS0dpWWpQVEcy?=
 =?utf-8?B?VUFjRW4xRU5PSXJZZW4xbG9LaWpJdTZDMEtWb0pJTEhoNFZIdm5vWW16VUpu?=
 =?utf-8?B?ZjdXanVzQm1iWWFFZUY5RjZwQlBHMlhmRWV0Uk9RTFM4blhGWE5ROGJ3cXhy?=
 =?utf-8?B?dXE5ZjBzb2FJeTZaQk9PajJFQVNBT2ZUMHdVT3FXODlmY1FzakpvdkpsZEx3?=
 =?utf-8?B?NzZOVmJXYVlEUnYva3U1ajE1Wnp5VFFzSmRKQ09PalBWRHRlUzJMSUN4Z3B4?=
 =?utf-8?B?TVdQYlFocTI4MlhwUE5kK1dlWFpSd2pCRGFsRzZMR3p2OUU5Qnd5czRGeUxL?=
 =?utf-8?B?ZmtkSGI2Qk5ieVdkbzc0enZWMW45NXFGanh6V25hQXdsdFZ6cC9NakI0cmhO?=
 =?utf-8?B?MUZFMy9JMHlJdEVHRktmbEhLTldETU5oRWZuNTNyQ09BSDNMUERiRVZPV1kx?=
 =?utf-8?B?SmVOakg1OEY0azVCSkRlN1Uzb3NxcmdnWmhOMDFvQjhKL3cveUZ0L1JEZU5C?=
 =?utf-8?B?U29tb0xBY3lBVk1qSkhHMFZnaHpTQTNlaStidGlQaWpScE1ETERwTWlxWFZ2?=
 =?utf-8?B?MzNPKzFWL20vemZ2OUtocGRhcVlRT3hJWkp6cmJqTzcrbzBac0RHWTVpZXBY?=
 =?utf-8?B?WmxocjZoT01wZ0NQREcxT29yWWFIczl2ay80aFdDRXMwNzBjU2RRcEM5eFF3?=
 =?utf-8?B?bXBzTEo4S1lYWEYwU3JkeHFFbU5oTURqWnY4Rk8wV0pFT1cySXJTSDdNNFRU?=
 =?utf-8?B?U0xlMnE3ek15T3VkZFNOdlhuckdOWGxuc3dja0V6M0dMblY2QzZXTldXZGZS?=
 =?utf-8?B?dXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <535E4D817C2154419F729FD4B4C06339@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O4Qu56yX/QEcvt+YB4Dbpdm1Ts+QojgJphWFfs+lAaihyKc8G8GRqe5LsGLfry03AY2dIYEyjft8hxGzv1tLd9uyEuhMJ04S9NccqSurSQJm62cIcAPb+UM11nLmIFamLtQAKn0HdpaVhcz/6PSsD62x1xNiTCx471B9zeQhekUq7Jee7teIxrAkNJ9XRNGrCS/hAOSoOlTAv3ymWG/ujc8aag9nZVRDxlSqEYUc9yKBB5q4jn2SuInTmNRmiGY6LjCKA2W83wQA1vqwAGwYxSdrnsJ626gfaPtVxKwu38j3tcujpBajEHzTW+9BXkTqn65lXLqQRNE44d/Ykmvr3Sm23rAJm6ImtGMQPqcoocFvCEvisQqya3KCxFC/xj4WcGGikBy/8LGc1hhFFimY+mpLygWVbYLT0TndDmzHwBjoUo0QJWoBb3GG0CmJLFZ4gYzTmGQIsn3X6DW4ItPJr0mjBxk1LltSGQr2wbT/7GXYWKP+8vUnlslnH5Bhkd4wE1PYb4UvhGEy3pgiOEI8Z9t9sV6GDiJcgneVDTeuI2eidVzjf5cGrsPpmel5sEef2OaVp9pnmixYfxQmo7Pi91I/oycmnMc4eCuZo+4VPwsAvrGOdCCLZ1f3jci7Z5aO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202fa769-9711-4185-8474-08dd4b6942c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2025 13:29:21.9530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oLZaJxIh1PfgQnd/H9w8f/Uh3eAb918difVs4XXmKS2G2fOLxdh9a3fy38Grcc7HHzaT4VKznpQFVAoo+3Ny4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7525

T24gMTIvMDIvMjAyNSAwMToyNywgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBUaHUsIEZl
YiAwNiwgMjAyNSBhdCAwNzo0NDo1NUFNICswMTAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToN
Cj4+IEZyb206IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCj4+DQo+PiBB
ZGQgYSBmaWxlIHdyaXRlIGxpZmUgdGltZSBkYXRhIHBsYWNlbWVudCBhbGxvY2F0aW9uIHNjaGVt
ZSB0aGF0IGFpbXMgdG8NCj4+IG1pbmltaXplIGZyYWdtZW50YXRpb24gYW5kIHRoZXJlYnkgdG8g
ZG8gdHdvIHRoaW5nczoNCj4+DQo+PiAgYSkgc2VwYXJhdGUgZmlsZSBkYXRhIHRvIGRpZmZlcmVu
dCB6b25lcyB3aGVuIHBvc3NpYmxlLg0KPj4gIGIpIGNvbG9jYXRlIGZpbGUgZGF0YSBvZiBzaW1p
bGFyIGxpZmUgdGltZXMgd2hlbiBmZWFzaWJsZS4NCj4+DQo+PiBUbyBnZXQgYmVzdCByZXN1bHRz
LCBhdmVyYWdlIGZpbGUgc2l6ZXMgc2hvdWxkIGFsaWduIHdpdGggdGhlIHpvbmUNCj4+IGNhcGFj
aXR5IHRoYXQgaXMgcmVwb3J0ZWQgdGhyb3VnaCB0aGUgWEZTX0lPQ19GU0dFT01FVFJZIGlvY3Rs
Lg0KPj4NCj4+IEZvciBSb2Nrc0RCIHVzaW5nIGxldmVsZWQgY29tcGFjdGlvbiwgdGhlIGxpZmV0
aW1lIGhpbnRzIGNhbiBpbXByb3ZlDQo+PiB0aHJvdWdocHV0IGZvciBvdmVyd3JpdGUgd29ya2xv
YWRzIGF0IDgwJSBmaWxlIHN5c3RlbSB1dGlsaXphdGlvbiBieQ0KPj4gfjEwJS4NCj4gDQo+IFRo
ZSBjb2RlIGNoYW5nZXMgbG9vayBtb3N0bHkgb2ssIGJ1dCBob3cgZG9lcyBpdCBkbyBhdCA0MCUg
dXRpbGl6YXRpb24/DQo+IDk5JT8gIERvZXMgaXQgcmVkdWNlIHRoZSBhbW91bnQgb2YgcmVsb2Nh
dGlvbiB3b3JrIHRoYXQgdGhlIGdjIG11c3QgZG8/DQoNClRoZSBpbXByb3ZlbWVudCBpbiBkYXRh
IHBsYWNlbWVudCBlZmZpY2llbmN5IHdpbGwgYWx3YXlzIGJlIHRoZXJlLA0KcmVkdWNpbmcgdGhl
IG51bWJlciBvZiBibG9ja3MgcmVxdWlyaW5nIHJlbG9jYXRpb24gYnkgR0MsIGJ1dCB0aGUgaW1w
YWN0DQpvbiBwZXJmb3JtYW5jZSB2YXJpZXMgZGVwZW5kaW5nIG9uIGhvdyBmdWxsIHRoZSBmaWxl
IHN5c3RlbSBpcy4NCg0KQXQgNDAlIHV0aWxpemF0aW9uIHRoZXJlIGlzIGFsbW9zdCBubyBnYXJi
YWdlIGNvbGxlY3Rpb24gZ29pbmcgb24sIHNvIHRoZQ0KaW1wYWN0IG9uIHRocm91Z2hwdXQgaXMg
bm90IHNpZ25pZmljYW50LiBBdCA5OSUgdGhlIGVmZmVjdHMgb2YgYmV0dGVyDQpkYXRhIHBsYWNl
bWVudCBzaG91bGQgYmUgaGlnaGVyLg0KDQpDaGVlcnMsDQpIYW5zDQoNCg==
