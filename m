Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041C0175A77
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921376; cv=fail; b=R8mdZ10LBvH5dSiQdvfO11s1RC1zjq0AaKayhazjSbbrd3pYw1Z5YQCVQktcEKzAcEx8FLKDM3Ap2/DOU3BvjLjIxPg/yt0AxksC+mPtj33JZP29U88FPwF3DacBbALa5w0D50GlBFb+oT1SqXrSMGxJqTr8kVcl1xDAxLHtorU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921376; c=relaxed/simple;
	bh=GiMvqG6Tqv5XRanP56oOZF33cLTxoCFAJIpuyUKhaso=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJCJjabuBm4eVamGAudHBLv8mB6hoPOCvI37T+5YBtw2TGGgn/5vBIA24yz9iaz6WnBbiVVw5+5YCyWFBDaercWD7MCQ6+kWwrIiOGx1e2D0Ab9geVROMy/hmLA+LnEcP9CAIUxTELfQbdTfpTEG+nhH0UvAtAizH+KyWSUbrhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YtMhPDDV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GdU8xYxJ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YtMhPDDV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GdU8xYxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779921375; x=1811457375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GiMvqG6Tqv5XRanP56oOZF33cLTxoCFAJIpuyUKhaso=;
  b=YtMhPDDV09rB3VRONUjo/pSBnrWH6Wx1PCZxX4VstNeMRn/rqByrN2zC
   VM2aH/TNXTtyLpQFP74fZrIi1zRjfu9dK+CZETQoKfbTGhB3JsbhYDFnO
   2oeV+/QVT4kECJzEbtygV7oD2ah73q4Hs1lhIqzn9ELsfegRITlFj0yNk
   bSPVQlMHuCyN+MbmhdxuI08X9jiq62PGpJuE6PpbCxI3sJr4bC6eQIz7s
   t32ZxstYdmQnq54Q5lJ0sQngT/4KuJY3sgkk91uTiOxWmU8sf0RrTvGVN
   M3JVlzuVnEXUKqXzboObK6IGIYp4EO4JPyACJfLrqvCTu2g6Hanf/nyxY
   g==;
X-CSE-ConnectionGUID: GcrXeshyRg6XR+MjdzP1jw==
X-CSE-MsgGUID: LzI56H6JS5CMw09Nu+Ip4w==
X-IronPort-AV: E=Sophos;i="6.24,172,1774281600"; 
   d="scan'208";a="147913510"
Received: from mail-westusazon11010032.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.32])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 May 2026 06:36:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GF+RCRvf96D+24tY+vfE7yMCwmxTxH+s51ccLcPO+6ozbfTaNDqdMl/twCaQdpeCcSKosPZJgVvw5jc76DbVuYeV+blGdxTVwjAPxSIdS8ZMJgFzjQiG28vDgf2boiHlktxbd8u9tSLPYNSAMkKx5yQanEu5NO+/h0allJM8GRKtqIuQCXI4ohkk4sxuOqunrqVMGeeFbzDRR/gOURlmqJzgDJC7LltGh4RY8nNymFpetKqqk6VPjWjEB1H2IW+gstkPs/ECIf5dYQCI54ewx2EbN08kHBCVTTplSULurCsbA8FXPr8Xlw3d24NNazsaXrilHgdDjSX4/FRlRASR5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiMvqG6Tqv5XRanP56oOZF33cLTxoCFAJIpuyUKhaso=;
 b=pTINezSvb78e65IG0myCWonLZMVo/e5I/IzA/tbEM4207ZZfsspZaTEAOvqJ/1dVDadq6/wvX3xliAVfQtBKAYKpnh2xWOm8txkTelzTrpNcFXsSSQ5EUnohGsvS8A1LMNu8oXbCNx73C0rutDJflbAqEOXLRNwOAo3OXKPf34M5cFahv7MJ3GTyPRKdnlYZocG/DVAVCK8iebspcm7JSyqMEMk9zaB9aBXVjMwdXOj8aM/yjdn0osoSE/OQlFZh1PuqEsx8991oW4TXDTjyZC+W4oRQSiOOpE+wNaNpiQEk3+5J5DeWWxnLQodgFpPIz2aQKQHss0PrDsVxqYyVwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiMvqG6Tqv5XRanP56oOZF33cLTxoCFAJIpuyUKhaso=;
 b=GdU8xYxJs5GqIg4Wr5Tkkb53kcdkpJ+Gx7YXWVSefznrvtm3HMOCjV8aQ5z5tE1GWfFFH4LP+0h254WWv4yIT6AWD/XQZcx0f6v16rieycJFXaRT7lN59MBDEe/pUhsg7XMuyU99hvjiY7JPsZmFlA1G0FrZT3wTgyu3irBCujY=
Received: from IA3PR04MB9680.namprd04.prod.outlook.com (2603:10b6:208:510::12)
 by MN2PR04MB7117.namprd04.prod.outlook.com (2603:10b6:208:1ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 22:36:05 +0000
Received: from IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f]) by IA3PR04MB9680.namprd04.prod.outlook.com
 ([fe80::380:1453:ea86:e64f%7]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 22:36:05 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: "hch@lst.de" <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "dlemoal@kernel.org" <dlemoal@kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: factor rtgroup geom write pointer reporting into
 a helper
Thread-Topic: [PATCH 2/3] xfs: factor rtgroup geom write pointer reporting
 into a helper
Thread-Index: AQHc7dXtEddPd2eD10yOu5MW8qFcXLYidrsA
Date: Wed, 27 May 2026 22:36:05 +0000
Message-ID: <cfb0b7b7d56b770579166744cfeecdb8f2500176.camel@wdc.com>
References: <20260527123941.2319377-1-hch@lst.de>
	 <20260527123941.2319377-3-hch@lst.de>
In-Reply-To: <20260527123941.2319377-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR04MB9680:EE_|MN2PR04MB7117:EE_
x-ms-office365-filtering-correlation-id: 56b639c0-acb2-4b43-203d-08debc405709
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700021|11063799006|4143699003|56012099006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 nBzGlIVRh6BI4OxNU6kaT8kkBPJgSoUIcDDPjcV5NkqwYtXTv08a6cf4gYDEUOdkI1geaKXDSw2vuUEw0jPVrDUpe422U0uQdCtQPGMsS7DJHI6gfNTx+DALfVATKToAMTtjWdH2xveUWNCK4WUBQ4sts3Gy/0VcimkZN5yPnr2RKkOoZqu+ecdhYm17kOuyISn3JMaXtMbrPobxlXBuAnlHxsMUuvfE2zg1jgUgjI3SkgowC4484eBxtuAjB8W/xDHTAivO8G0NytXt+AXudRYXoL2yhRBSB62njvSWwehh2h/mHnYtjPcwG1k8SLUL8sxBWQUqwRWuTX6hYNYs4pXT4p+Dlr3vey/vCmQfXNmg3fyIqhx7MndSqSVoUZ7oa/+3sDdSnWkNAcqnlkFxPZSSb9ktCUbC9J1kwV7/a0gLLcnr5m8cjIV1iGeIyLO5YJA6EpMR+5GkouIDKCJJ6geRN7giUTtbyCM6JTME0nPcP9JurRmtTcy5UZqPBDSYL8z7fdoo9+vbg1gmRTs6LkySbX9BxuZlYp7F88I86xHEDBYsmHgK9qo+OjMVLeK5k5cBzIK2xfJLUEPkcsPkg+XK4yrfZfjEx7K15g7mIEjn9LJHRt6egRXo8Q81DmvX4Aky+x2PVCvw0yv3hp1gEtQ+2J92tq3Xyj6IP3skeG9BPaq1+/Cx4TTHe7RYHft0pf5VOOgU1gR0eAf/POSwVnatP0vfIs4jX4nhywrD4AZCqU4owfQ+ps506S7upFNF
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR04MB9680.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700021)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?L2swOUpuemZGZlg1RFcyM1I1UDUrUStzRU9mU3lXR002ODlONHNJcjR1aDI0?=
 =?utf-8?B?b096Ymoyd0RWWUN1NnlQdlZHZmZudFpOUWFlYSsrcWxOZlVIbyttazBnN3pm?=
 =?utf-8?B?eVFMVFpmS3BXcmpEWlN6NGQ2VTRpeVV1WFRTSnBlZ3Y3WHIyNk1MQmwyYjFJ?=
 =?utf-8?B?aXJGRVRZbnBLb2FKclFYWGdITzFQZ2VEdmpqUmdzNTdpNE5tTGZFV1F3Yi91?=
 =?utf-8?B?NDRybDJQUFl3dUEvOEQvRWI5dDJvdTdxZ1VDa3gvMjk3b3VqU04vOE9rN1Bm?=
 =?utf-8?B?eTJlQTJsTUhQanBEd2ZtanNFc3JnYjY0anRlNjU0ZWJISDNIR25RbE1KeW9Y?=
 =?utf-8?B?Q3hHeXRoTXhHK0ZzM3U0WDZ4cWVhenBKVjgwckd5eGlXdUdRelZ0aVBZc2cw?=
 =?utf-8?B?RFlJa0xmRWwyQk9qamtuYU9la3pCS0dFRFViYitCamZMeUxxVVZzTmpkVnN0?=
 =?utf-8?B?aEJrRVNiK2x5NThhUnVJV25hL1JBdTVRVXB2R0g3bnV4THl4OEhiUnNKMlA2?=
 =?utf-8?B?L3Y3UVVFNmFqUlR5dUxXU3YyeUhTejBOajZUYW9sem43dkFIVmZtQXpOMlRJ?=
 =?utf-8?B?elU2SUZVR3VkWFRZSkpxeTlybGRBZ0R0Q2drRTdTeGdRTHl4R2tXL2ZaVG5l?=
 =?utf-8?B?NVgyeVpzdG9wa2ZWTkhPS3llL2JOQTZrL0M4L1k1SnNOL1kxQVFuTEtOVkJv?=
 =?utf-8?B?Zzgwd1AvQU5DNi9EVzNMODVoaVVYMERvcFVuU2RhclpQbkw3S1c5ckZyaHcv?=
 =?utf-8?B?d3hiTWREc1B4R295R1VhOEJsL2hCSFBZRGx0OTNpYVZUYTY1WjRaYkZDcTFN?=
 =?utf-8?B?U3NQbjNubHhndnBxcjdLTjR3ZVRvRm10eFpVUVlvMkVwNDdvSVNlKzkwRUFh?=
 =?utf-8?B?OXlwMEkvcXpSTTVQWm1rdGdibnRhL21wbmZGSnA1NGFjYk56UEduRk1uTUxl?=
 =?utf-8?B?V1E1cng4L0FZV2dUZDhuYUIycFZtK3VCeUw0WURmSXdMTTRIWHFHdUlHZDRs?=
 =?utf-8?B?OUhmbGk5VGVGbndjQmZ0UlNNUlBmWjFTQWpZNHVlZmRBNmhNTHdpUFRXcWpL?=
 =?utf-8?B?YUN4TEgyanQ2S0pkTHY2cytlUTQzblcrUFpkUGlIdkZ3NUI4U0htc2pzc2JH?=
 =?utf-8?B?bVB3RUp6a3Rrdjl5d3gzbk54OUJuMlBJY0RkUG05eDlJdnBBemtxeCtSN2dM?=
 =?utf-8?B?c1AzTStLVHVsc2tZQXNGNHo2ZzNsRXlQbG9vZEJnd2VSbWo4RkdYNDJkd2ZN?=
 =?utf-8?B?ejVGd0JOUXJJTElWRHlRTHAvV2NWM2dDWkJWanA5SDVJV0Z3cW5LOUNlZWNU?=
 =?utf-8?B?QmVocGkreUUvdXB5SFhLOUgvOWxkd3lvU0pxaTgzYlllSlBIQ1BhaUwxWkVs?=
 =?utf-8?B?Z2g0ejZvd0N6K3d5YVBBblZUemVTcktnT2dLZFlHeDdnaXBuQVpjZEQzMWVS?=
 =?utf-8?B?c09YbGM4eEE1ekpoNVpWV1hpRlQ1RWZ5cDRxc3hGWFdhUlFhTGNIditiZ3V2?=
 =?utf-8?B?ajlpZ0FpQ0t1NjVjYUpzeG9QOFJUcXREUkhsc0pYK0NqWURyTnkrVmp0TGRm?=
 =?utf-8?B?VVpvd0FMZWJwNmd0Q0ZVWEd1K1NIMkYweFR4aGxUSjFqZU04YlJQR0hPVnla?=
 =?utf-8?B?Zkx3WlRPaC83ditobW5JU0Zrckh5TXFKZUZUYWJTZS9MOVRnSlRSV3ZRZG83?=
 =?utf-8?B?SnVnMmJpYytybWs2Q0NUaEFld3RIMGQ5eHZaaGRNWU9xQ2MxaFRlNnFzWFJB?=
 =?utf-8?B?ZzcxMGJuTlNCUGVFK3ArSnU5WTNWNXBsZTY4U0FSYXlTdGdYM3BwbjJVQVhF?=
 =?utf-8?B?dHRtZHZ5S0l0TDVtMkxtQjU1akRzbGducjZKY2htNW5KUmcxZHZ1Ty85ZEo2?=
 =?utf-8?B?dnEva0kydWE5VDdhNmNPV3RrbGtoZFpaLzNIckFPTlA3Ym9XTnRUckV1R2Zu?=
 =?utf-8?B?aVVlMEJEWSt4OGduWURkY1pNalROS3lrOHFqZHl6VU0vZ2NyNDBpTzdKQzRO?=
 =?utf-8?B?TjlaN01xNjJybzR2c0tnM0RpUy9xSXJiaEUza0xyeElMMDNOcmlNNjdKUll5?=
 =?utf-8?B?Q2x5OVZReXlXZmpLdWNzdkhlekYyMWg0V1h1Sk5KVkI0aXZHbnJhT0tUQlNo?=
 =?utf-8?B?R3ZwT01Fb29pNFR0N3lzRWtkVkJwVS9PdExNbHIweUVBUFlWTmgxRU5INGhn?=
 =?utf-8?B?VEJURXZEaEpaRWxmZERDVDBJUzUzWUR3dTFoUmxqUGJwQzdqK0xWeGRKM2Uw?=
 =?utf-8?B?ZnRFU2wxVUdQOC9PMzVGWnZ4VjFVRzZkVklxWTRBWGNPa0NPeUFNK2ZoK1hU?=
 =?utf-8?B?VjUwbTkxcUFHdkdoZys5VFRDc3RMalVKbm9WL3BzTCtqWGNrUUF3N0dCUXUy?=
 =?utf-8?Q?ad+n5xIitCcXsMec=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB804DB71324F747865CD6FC5835E3E6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ALfq7rZZnm7fAsGxSx0+o9DzXWKyv4zL7m69rcUAUyLl4sWJYx2F+Da0XZ8PsW06sdu/dHt30+ZlOE0mCoAz9XqLD6X3mOrD16uJ6vnPWL4dCMlbputuhfrE+ZkpKHlmxjXfpIYGBQzzHcLNXa3NjY1hY5k4CQ3BrSJLeAZjZ6Na+PcZWp+sA0AY4vOwln5gzGjQzcUDYc7VhE3yZPUIMBrdtSU2CRZERTAm6qLUdzyRvThRhm71TcZX1RHc7/53C8HCp1fCgJde4/P1unbRWym0hwEPqGfRfReLCEmdzoQH8/ZOhH8y3/jgkiohgy9CenURKHPPWWjGcOu6jEjPCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sM+/2CYQ35F5yg+icL21PtJSeb/nkfDLzsMyfVPFYBhC/VQcMBy+o62JsHbs3vH4PIemfovC4Qxh0hLyyArUgA9muRzxWEKAHvb1eGbHspswfEkqU2aDsMmKQ21W1tQMiyUKUr0QlMOWRfRl4WtszRKIm939rUW6Vsr7LqIIM9Edh++NlAPC+qEDBd+6yJ/an/rD2Jlv4o3PEKMcRxh0q4KFzYhSRTR8re37y/tPqYPfz45AFsyud0tOExkoWhVOA7HgGFa65X4d6QOmd5t4ltqlMHj4rEu7RPb+Ar2Tk/XLAHad5+q9SMTbXv7CKtyy5+4vWBK2xZ/iydwLkwrILrCiDa3JsQHG6rJifLhCB+eWcFMgJxZ6i99LrnnkQdkEnBX3oOtwMFcDXhYnin/z/1eYjsqGTBPJWw1x3UHcegOaxrEXej2/gukDI97vSpSJb5g/1iK0AorDVBfEckOZ24Qp1p4weOetczD5RFlXGAzTCIbOYJmK0gGzDfbcaREe+Ac+QlCg20qkmGCkdH79zN5NVTy6SMPq+7cCJoy0CsHYj6dhN2vjvm+RAuss33ZD5X+9MlO5frswOqCjr3p3DyxU9Cn0Jz1vr3uxrfAvaQ9Tdeoowri49rDuE9+dPO9g
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR04MB9680.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b639c0-acb2-4b43-203d-08debc405709
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 22:36:05.7051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aX2conwXAegyjc9egcn0JMnhZxy6iFTASRysv7KTBNM+IZ+ztPZ+gWJ0KBn3SZwqQClAj+jDrQPJfqj/28gYrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7117

T24gV2VkLCAyMDI2LTA1LTI3IGF0IDE0OjM5ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gU3RpY2tzIG91dCBhIGJpdCBiZXR0ZXIgaWYgd2UgYWRkIGEgc2VwYXJhdGUgaGVscGVy
IGZvciBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFdpbGZyZWQgTWFsbGF3YSA8d2lsZnJlZC5tYWxs
YXdhQHdkYy5jb20+DQoNCkNoZWVycywNCldpbGZyZWQNCg==
