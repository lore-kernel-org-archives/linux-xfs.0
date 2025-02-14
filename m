Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8866B204F6E
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 12:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739535664; cv=fail; b=oQu0+ZqD9ttMGza4tJDaAyoeeYP5tKwM/jO/MysGz1kByzmaVQDhrECjJi0cmukrsx704JJQcmNmxS15eW6nAXORtrk1YXPrNehzCeTojoecLuqSXS1sIUs88x8+Ldm5pXuk6ojsSfY3iOlvJOkmGxjQKvw9H+sq9i1/Wb/ZuV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739535664; c=relaxed/simple;
	bh=VeCXt0LZL5QVizhJjYLLIH5KJBq1848UhcOAdC5BefE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BPaYC7NUXLqQVcMJNI5J+X9UbCRgY3otMtoYXFOJuSk317LbwCv8MKgVnYZigBupWZp4lUHMYfQ0z0x3NS9dyjc9CXMKcXp66bQYdWgc0Wmer21JrXedP7k6greVn1Hyq/dDW/JqX53NfU91xEFfVgWlE95AClOG7GcnV/YErx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VgmWQeMT; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U88t/WzL; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VgmWQeMT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U88t/WzL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739535661; x=1771071661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VeCXt0LZL5QVizhJjYLLIH5KJBq1848UhcOAdC5BefE=;
  b=VgmWQeMT3y9RUay+rOB5oUanJMZcoi/84SVAebybTc27ujEpDAwe0NIN
   wRD6J+Xf9I2UR3tTBGfco7vED3XoPw1IJ5XODFu9tUF6exiFzFt4O0kVB
   VeyZIv5uRsi38vjUAO94KtzF0bNYa/agjjA+S1nCTBI5n92dQsVPuniHG
   lb7AbavAhBMyzGElgcxDS3syOq3FEiemz7kjIdOu9OmYU9M63DqdFf9zA
   GsTYIa6ivARJBN9UTQpplQ9oQW1y5s2z2ZBHMKq+N1YKvRdYo3dOVpCul
   +XWOSaz02xZ7pZu8skcqSubzSzzKAX2Ierv/22v28J5yROMXXtkve4k63
   A==;
X-CSE-ConnectionGUID: 2+aRYHreSdyXsAA6MlAaow==
X-CSE-MsgGUID: UK/NXqxyTd+/9oEXgsWw3g==
X-IronPort-AV: E=Sophos;i="6.13,285,1732550400"; 
   d="scan'208";a="39732261"
Received: from mail-bn8nam04lp2042.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.42])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2025 20:21:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFxs+xMnxeCxyDydKYLRSdQObEP2iEdva3dmFqTCqtyYcJkNZz1ItOWhPhhNCAqQ472Lretw6cRHBO2QZcscqDrX/cJDiKdkN8mELqEMwNLmWOSt7OFb7/BjDt2Huw6kuo0Qos+O3PrIXZlymOdMP9R5B+HYUdRtBe7hX9jVJSjWrEDyuauBShefxSBJkwJtdVgc5HnDaa3s1GZVo5F1evJMav0NNHPA/ETqLqBzkyJUJLrK77hm64oqpyCQtxEwHqx/DXvOQTKP8C0UJGl20FSZKvAnP9vBWrUwG43C6pRfgpUtcvBzuf0Vm8k5k0JFGiH3f1A1owo+qA8rnHl4WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VeCXt0LZL5QVizhJjYLLIH5KJBq1848UhcOAdC5BefE=;
 b=UlC4qnD/3RxaZpIyiE16BharIhwLTpjg8UwLzCcE7KAg8qHHnxoo5eR5kPYlU4TpveHoDCAOQ/8cSoatFCYbIs2op9/Y5Ka/RlVXuIUDB/AhLQ/8QZ/Ne3byqZYan4lgoI3EDgcrOT8MnLYAyS/mU3WtGOT7VjvVAPeHJAf7ektbVtSE+5piiUpy7KUhHWmOCiqexF2bk+4W8qC1o9ekHN8NsLhxbOda9OReceqMRC5veYDqHaFRVWNBBuo33zvBRb4YPGGgzfs6jHfk52Q2L4ywcddv0/YdSrH4gtet+Q8wxaijKLHf5mplbxCzCvj89eb8zMbOteFV4jzr00+3Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeCXt0LZL5QVizhJjYLLIH5KJBq1848UhcOAdC5BefE=;
 b=U88t/WzL33Niecg69IJK7nd5UR6QFlV4Neqb26zXTVjntzEHydI7af0dd4gJHcriPqY1Ks99mum4LLlntJJxGf6GmWOrQmhBoNO0o2r2jB91Te7kU9LVr098iVEIMWaYCEBRJccfTRSLfbAUpuR0W00mdzknt17vS2wrduofLFQ=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY1PR04MB9588.namprd04.prod.outlook.com (2603:10b6:a03:5b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Fri, 14 Feb
 2025 12:20:58 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 12:20:57 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>
CC: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Thread-Topic: [PATCH 39/43] xfs: support write life time based data placement
Thread-Index:
 AQHbeGMNUHBiCs4vP0Oy/NKo2p6w/rNC2QIAgADad4CAAP82gIAAi+YAgAEnrICAAF7FgA==
Date: Fri, 14 Feb 2025 12:20:57 +0000
Message-ID: <a9fe06da-bbfd-47c9-8d47-f526877f0e63@wdc.com>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
 <20250212002726.GG21808@frogsfrogsfrogs>
 <c909769d-866d-46fe-98fd-951df055772f@wdc.com>
 <20250213044247.GH3028674@frogsfrogsfrogs>
 <25ded64f-281d-4bc6-9984-1b5c14c2a052@wdc.com>
 <20250214064145.GA26187@lst.de>
In-Reply-To: <20250214064145.GA26187@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY1PR04MB9588:EE_
x-ms-office365-filtering-correlation-id: 12487583-5aeb-4407-6b73-08dd4cf2095b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WksxM3d4QVE0ZHI0elRYS1lTSVo2OVl0NGR3dlc0c3l1cEtsZ2F6Vzdoc3J3?=
 =?utf-8?B?TzZNbEgxakloZ0lIQmlIbHAyamV4Yys1MklqTW5vVEFZcW13TVd4N2ZHRGJ0?=
 =?utf-8?B?cEQxcDVTYmFBV2JUYTBVZi9KalFnYVFwdS9IdUtUZEs3K21lS1VNd3hjYXd6?=
 =?utf-8?B?OWdmUktYWVRKMFlvcmlGSnZJUkpyNkVnSWFTdEl2MWhWcjJwbGlzbnROeGgz?=
 =?utf-8?B?MUJqNmRpb3VIYnFzZGxGMERPdnJJNDBVMHRVeEVyVDM2bTZKeW9pYWVBTHdF?=
 =?utf-8?B?SmVxU0k5bldzc1ZWNW1jd1haQ0ZUcjFKci9LSXowRW56dS9yNkUrQkxZR0py?=
 =?utf-8?B?N2gvRlprY2FBbUNFTkhrT3JSL3g4aEt2blZLRnRDM2pENEs0cXV2MElrUzdM?=
 =?utf-8?B?dXFYNGl3Y1k1OXlmYUlzVFZqSUdDUFhhWnJRdzlwWXZjUEM3NXk0cGxpWExz?=
 =?utf-8?B?SlMzU3BmU3VOWk5vMXllakZveSt4QUNmZC83SG9sck1QMi9TYVpneHJ4K0ha?=
 =?utf-8?B?WG93cVI2cnJEdTB4S0xMMFdyMHoyakIrSlB4eE5rVWVTRzc3bHI1SHp3aVNw?=
 =?utf-8?B?bVhVdkdEMXkrNWw4UnQrWUNIbTJxOFZ3Z0tmSk5aQ3FDNTk0Z0VKVEhXKytV?=
 =?utf-8?B?Qkt4dHpUZVVwL1FIK25UakJqMXZUbko1SDRsaFVBTkxnbE9ZRDVvNDgydGJV?=
 =?utf-8?B?dFlrREtuRlJjMmxTb2wyZzdjY09vbDQvVXhmQnZpMm5CUjc1dnlZaCtUZ3hp?=
 =?utf-8?B?YTh1a1lSTXdlWnFwcTJPZnRsazRINVJ2MDBhRGw4dCtwOTNsOXJIYmsxZGJ1?=
 =?utf-8?B?T2VGUjk4Y3JtMDlqN1EwSEEvV1FORjI0MHVsWVE3a1MwdldRTTJTMm9SblZJ?=
 =?utf-8?B?NGg1cU1NenhEbEZWV3BtOTU0S1hJK3FDTXg5SjZBQVBpTWIyaEJzR29Lb2lP?=
 =?utf-8?B?ajVaSkNvNmVrNkJHSk5GYVd6ZHhGdUJ4NnJvZnV0Q2pRSitqaFpxV1lXTml5?=
 =?utf-8?B?OE01QmtCVmRJNk5KaHgxZTdFY1lHeWpCUXlEcWhRQ1FlbEpJZFJrN280M3B0?=
 =?utf-8?B?QlUzSG8xTndsTUE3bEo1ZEdOSit4d0k3c2N2aTMyOTBONHlKRXFweVdPRm4v?=
 =?utf-8?B?dWl4dzlPRS9ua0RhK2Q2VWdyOERUZTl4T1RNTjNDa0d4SWpoYUdXb2xRU3Zn?=
 =?utf-8?B?cTMzeUNRWVRVOXlkMnkwQnVBZUR4WlM5RjluTTdwN252YVNLZGVyUS8wcGFz?=
 =?utf-8?B?OEJwSEpDbjdsZlNhU243d0xYa1FPUDBLTlVCSE5ZaktxSUpyZk5RQno3Y21w?=
 =?utf-8?B?ajBQVzVWd2ZoSXZxanRrbDd0d3NzYkx5OGFRUEdpMVJJTWs1ZHRCSmtrUDFr?=
 =?utf-8?B?RCswWHJ4VXY3KzdXaVI5NTk4ZW5oY2xQQ09Da1cva0tSRi9CeUg4Qk5URXQv?=
 =?utf-8?B?NjZNLzIyVXVXR05OUXF4K1BVYlRWeitneTZveHVXWkNvV0prVGI3ZjRTQlNX?=
 =?utf-8?B?amNqVVlnYjQyQ010cHJ6TjB5Ykd1R0NsWTZOeVFFeTNkWnR0VEhzRmtINjFG?=
 =?utf-8?B?TEJPVWU4T0lMYlN1ODg1dE1zU3NHNy8wY1l0U1Zjd3VvVkhKcEN6QkY1ajUy?=
 =?utf-8?B?enZnMUlLVFBXUzRzMlRVVkFqalVtUlhFQ2ZLL0RzbzFha3RRdVBLbnV2dnRB?=
 =?utf-8?B?cnVYUGtJQ0lNQkFmNGVJc25LWFBwVEhNSFhTQ0hNanhpRXVSU2ZrV2d0RDk1?=
 =?utf-8?B?alJ1aEoyOStVZmRHZE9BMFhWRitidUVlamFPbi9WeWdudlVWNnphbXEwSnRt?=
 =?utf-8?B?Y2l6dWRGSEVBWDg4K0lFcFhyaWtjeFBSdk8zT2xjMkZOL01qMkFHKzZMQUN0?=
 =?utf-8?B?czdVYWJnZ3VCaCt2Z0RZSWcrSEFmbzZUY1UwNXRjUklISjgrYnVxKzdONExC?=
 =?utf-8?Q?2977Y16W8gujzCbMjR4bmYVAWKHyzi+5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?am92elAxeHQzZTBYa0FzeWNYVGp6b3pWbDN0eTFnTHZBUUV3MDZJb3loT2dU?=
 =?utf-8?B?QzJKOW1pTTExOHZrQnFYT2wyeSsxN2VZK0xENDdNNnZZNzZQZVhsdVJwejhQ?=
 =?utf-8?B?V0llNE5BNEcwQmJLY3ZRell5R2JBTERtTDk4aGVTcFlYQXNlZWV3M2RmTGFU?=
 =?utf-8?B?RTlnTUx5VWtiVE05dHdvckFSeXRRanM4dFlQckVtYnpwNjFLRHhoRUVZdmJa?=
 =?utf-8?B?U0RwSS91bm5DVWVlMmxUWWI5VkR2K3hOY2lJQzBMQUtKRC9ORzdvNFhnQ0dt?=
 =?utf-8?B?Si9mYTMvQms1NS82dDhTYWJ4YmlXZkdLbG9zYXdPbExwMGNOcGZCTlNQNGJt?=
 =?utf-8?B?K21QTVJhNExFcUJvRWlldWFWa2pNdVVXUDNYcmQ2RlI5UDF2eGFFREZzZmUy?=
 =?utf-8?B?a2EwWFpWZVpkd0pUU3NqeWgwbTVtVmlWRTNYc0VHNzBjU2lqcmVDdFptWlEz?=
 =?utf-8?B?ZEpkcURlMzJiSEZJekhiTkFETVlwSlE4WWVYR25yWXM4Q2ROTWg3NWxVOUVr?=
 =?utf-8?B?a1M3YUJJZm9lL3RoWmFUOGhlMEpZamtaSTFGb2ttcU1yQ2x4bnNBeURzNFk0?=
 =?utf-8?B?RHh0Yi9TYjNBOEwvdmlWTnJseDRuWkwrWVA0eWt0MFN6ZUc1bCtuTVZUcXhr?=
 =?utf-8?B?b0hqc1lvMzhJOFJyaTdBT0NKckd4QU1TWTRJc3VMaHE5S0FEbjFjaU04cVF3?=
 =?utf-8?B?bFVPM2F6WDNqNFFWRkJEdWZTM1U0WlpxQ3NHTXNNU3R4VlF1MlpGU3dUT05E?=
 =?utf-8?B?YTFoMDROR0MreitYRlJ2VEkvVVQ5TXVMNlpEZW1jdi9IbHExOTZaOTJtUmZk?=
 =?utf-8?B?Z3VqSWhWejloUUZpNThzcGpYSHkrYjNXbGRHcWR4dTZoSTZYQXBlRDJQbFFq?=
 =?utf-8?B?aHBtMHJ6bFNlUFdiNkZsaGxha0hPeDNqVU1oanE4M2JKVEMxZC9DTGxVOExT?=
 =?utf-8?B?bGEvMWdYS0FPODlIUUlmUmkxZEQrRFhQYXVvNC8yekFqZTJGaGpJa2hETHBu?=
 =?utf-8?B?cldiWXVSOTJCSWs1R0RvdU5YK1dFNS9CK2tjYXg3UkNQbGo3Y3owbEUyUTIr?=
 =?utf-8?B?WHBvcFYrdmNUNmRwbkZKcmJsN1lvSWhMZjZUR0t3RzJuczFBRnBCazBqVStq?=
 =?utf-8?B?bzhoSUFWZjdqdnZPUlRCQ011ckUzRy94bzhyR3Jwa2lvZFl4NGpaYm5qNlp6?=
 =?utf-8?B?RkxGMG9XMmo2RlBNT1VmeHBPZUFEZ1NZV3NFbC9ROHJRYjNENHhKMXZ1QzBQ?=
 =?utf-8?B?Yi9VczFUQktnUHR0VFc3MlR2V094bzNjbzVaOGp2Q0NNK3VScDU0SXBVS3Fl?=
 =?utf-8?B?SEMrQ3pycHY2dWU3MHFXRkhMNnhqVGUrUDVjZXlUZCt5WStBY29hV1I0R0F3?=
 =?utf-8?B?ZU9jdEt2aE1GbDJSNDBKQWFRdlVBNnI1YlA5UlliNUx3YmRlNldsM2xzZmZk?=
 =?utf-8?B?KzJ2dDBCTWlVaEFHcUM5WmhNa3p4ZkEyQ3lqcTFNbVJDZjZLdlVIeFQrSi9N?=
 =?utf-8?B?SGlJK2RwMzFFalk3OThFZ0FnZWdxcTdJRTFOcWVwWFFuQjJ5UXJPQVByRFEy?=
 =?utf-8?B?d1ZaK2oxY1lZNGRvUGYrMXUyQjFYbEFNcmxLMHJUYjRIcFBGclQ4ZGhQWVZN?=
 =?utf-8?B?MXl4MlJKRDk3RnAyR21sZVlJdWFwSlpFNTNTcVJiNkNIMk9RR0xML3VZSTBW?=
 =?utf-8?B?RTlISmdEV2UxQzZxYW9xbmcyalFTMFNhQmliNG9XbGpya0ZWNlFIT2FUZ2FH?=
 =?utf-8?B?YnRMcDNRRHhMRWdBdDlqUFVENjFrcVhPT2ovOEFHYjR2Z1lOWGxQK2plYTZG?=
 =?utf-8?B?ZDlDRDdlblozUmc0Y3BlaFNsaDh5Zy90Vll2RStxUHRGakFvZDFjNTlCVWxa?=
 =?utf-8?B?c1E3YXMybXZmQUh5YnQrcDk5ZHM1S2R2ZEh0OVRsZkpRdmRSbXNTcU1pQmY0?=
 =?utf-8?B?UlpZSTExbjBLeVhGcjdPTHBoS0FNNzhFa2diLzJja25DdW1RNUd0cEtSUU8v?=
 =?utf-8?B?OC9SNmIvTDlaanh3dCtvVVFVVXdYRVpPbUdTbVVtdTRYcmRoNjNqMjBpSjVL?=
 =?utf-8?B?UmpkcDI1ZlVmVzlLaVViZFVEemw5djVoNUJuclBaWUFYTXdCQUZxdGJKRC9P?=
 =?utf-8?B?NTRpRG0zb1lsN0RpNUR0YnlvaHJqVkFCY0E2UnBkcjd1Ui8zbmNrRlcxYi82?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0311D0593904D4A9F8A67AA701CFA9A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5GaMwklhrX0uPbtg5EmR+qU6DR0wJ/grTsi+UiOQJrqf6u6OyInuNLTNAHXzxbZEGlKktRAnQPcjzS3bb3puMSKzMOsYfWC5mW4maB2xhL0ZHAujHeOBeNnkagPmUf5vg1qp23oc5U13bKT1T4iQrhtEGX+Ub4BFQJ86mWvBfdD2bVOOsstKOGEq/WBlLxUjtYtNnjauiMnuehC+9Y0T3XS3N6RxShndMkc6QJLOitmT2OieVRQ0n8bO+bkToLh4d0e04eyMApyZPdtB7BUs+lGf3xp2bl2jMuHfbKJ1GkVPPXSqb7AibcTAQno+n+IwSp3Bo0Kz/jvfANZtcGI6TOSNPjvtGtOgGroAOX2bd5NOawClKu/EHnSNJGPRNVpztMegReZTDE2NS2IQpupODWgKPUsfuw68TWYtJ0Uvx0jN6VmR9uB/YNul2oBTUQdvy4hxncszP5K1xflLgblcZpzBOlL4CkqyYa6febjSauapbp70Vk9pNyvUFtDGmZH5AJ4nCWqfC2qFmbGp6DzsWwNELQr+WVFKLng9IhAQ2oym2uHOepjaaSaEJ9jUca/kAdGBlIH1HYLNXVfwRGRHjMMBw+ysqGDx8IQ+kPz2qCsJeEYzZymMYJHxyani30RA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12487583-5aeb-4407-6b73-08dd4cf2095b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 12:20:57.9223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5ld7oL0qZAeoCccNYeHcPXnUx1WZndB10b41Ed9XzsJRn7fBvEJW9He07Q2Qbl4TpxLARqM1GLjR0bT7fLZ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9588

T24gMTQvMDIvMjAyNSAwNzo0MSwgaGNoIHdyb3RlOg0KPiBPbiBUaHUsIEZlYiAxMywgMjAyNSBh
dCAwMTowMzozMVBNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gVGhhdCBzb3VuZHMg
bGlrZSBnb29kIGlkZWEuIENocmlzdG9waDogY291bGQgeW91IGZvbGQgaW4gdGhlIGFib3ZlIGxp
bmVzDQo+PiBpbnRvIHRoZSBjb21taXQgbWVzc2FnZSBmb3IgdGhlIG5leHQgaXRlcmF0aW9uIG9m
IHRoZSBzZXJpZXM/DQo+IA0KPiBJdCBuZWVkZWQgYSBiaXQgb2YgZWRpdGluZyB0byBmaXQgaW50
byB0aGUgY29tbWl0IG1lc3NhZ2VzLiAgVGhpcyBpcyB3aGF0DQo+IEkgaGF2ZSBub3csIGxldCBt
ZSBrbm93IGlmIHRoaXMgaXMgb2s6DQo+IA0KPiBmczogc3VwcG9ydCB3cml0ZSBsaWZlIHRpbWUg
YmFzZWQgZGF0YSBwbGFjZW1lbnQNCj4gDQo+IEFkZCBhIGZpbGUgd3JpdGUgbGlmZSB0aW1lIGRh
dGEgcGxhY2VtZW50IGFsbG9jYXRpb24gc2NoZW1lIHRoYXQgYWltcyB0bw0KPiBtaW5pbWl6ZSBm
cmFnbWVudGF0aW9uIGFuZCB0aGVyZWJ5IHRvIGRvIHR3byB0aGluZ3M6DQo+IA0KPiAgYSkgc2Vw
YXJhdGUgZmlsZSBkYXRhIHRvIGRpZmZlcmVudCB6b25lcyB3aGVuIHBvc3NpYmxlLg0KPiAgYikg
Y29sb2NhdGUgZmlsZSBkYXRhIG9mIHNpbWlsYXIgbGlmZSB0aW1lcyB3aGVuIGZlYXNpYmxlLg0K
PiANCj4gVG8gZ2V0IGJlc3QgcmVzdWx0cywgYXZlcmFnZSBmaWxlIHNpemVzIHNob3VsZCBhbGln
biB3aXRoIHRoZSB6b25lDQo+IGNhcGFjaXR5IHRoYXQgaXMgcmVwb3J0ZWQgdGhyb3VnaCB0aGUg
WEZTX0lPQ19GU0dFT01FVFJZIGlvY3RsLg0KPiANCj4gVGhpcyBpbXByb3ZlbWVudCBpbiBkYXRh
IHBsYWNlbWVudCBlZmZpY2llbmN5IHJlZHVjZXMgdGhlIG51bWJlciBvZiANCj4gYmxvY2tzIHJl
cXVpcmluZyByZWxvY2F0aW9uIGJ5IEdDLCBhbmQgdGh1cyBkZWNyZWFzZXMgb3ZlcmFsbCB3cml0
ZSANCj4gYW1wbGlmaWNhdGlvbi4gIFRoZSBpbXBhY3Qgb24gcGVyZm9ybWFuY2UgdmFyaWVzIGRl
cGVuZGluZyBvbiBob3cgZnVsbCANCj4gdGhlIGZpbGUgc3lzdGVtIGlzLg0KPiANCj4gRm9yIFJv
Y2tzREIgdXNpbmcgbGV2ZWxlZCBjb21wYWN0aW9uLCB0aGUgbGlmZXRpbWUgaGludHMgY2FuIGlt
cHJvdmUNCj4gdGhyb3VnaHB1dCBmb3Igb3ZlcndyaXRlIHdvcmtsb2FkcyBhdCA4MCUgZmlsZSBz
eXN0ZW0gdXRpbGl6YXRpb24gYnkNCj4gfjEwJSwgYnV0IGZvciBsb3dlciBmaWxlIHN5c3RlbSB1
dGlsaXphdGlvbiB0aGVyZSB3b24ndCBiZSBhcyBtdWNoDQo+IGJlbmVmaXQgaW4gYXBwbGljYXRp
b24gcGVyZm9ybWFuY2UgYXMgdGhlcmUgaXMgbGVzcyBuZWVkIGZvciBnYXJiYWdlDQo+IGNvbGxl
Y3Rpb24gdG8gc3RhcnQgd2l0aC4NCj4gDQo+IExpZmV0aW1lIGhpbnRzIGNhbiBiZSBkaXNhYmxl
ZCB1c2luZyB0aGUgbm9saWZldGltZSBtb3VudCBvcHRpb24uDQo+IA0KDQpUaGlzIGxvb2tzIGdy
ZWF0IHRvIG1lLCB0aGFua3MhDQoNCg0K
