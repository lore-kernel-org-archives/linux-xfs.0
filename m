Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC30C4C91;
	Mon, 28 Apr 2025 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745842600; cv=fail; b=t9Cfgxn6fE0/LERFyfPgHeKNIS11j/08wcTMYj8zQxMENK093GoALs3Kfyoz1/ahZYyoFvmOnTYkFCG+E3b2fKHbP7/G1ZBzg3jjY5KVeBs3EVxoqYVJ1FXMcdtJojrpZKhFNa7kDu4XCCeAar89Vvah2it3rvi7g3gYJLtGeVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745842600; c=relaxed/simple;
	bh=hQTgG9uSP4TWZrARZP/xKkuJ1Jj3befgTInp917WuBk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BhMo27xXs4etbva5KSAnylmzYoD6cCCAmuvZ4RpO3HD2gdu4nAh+xNH7Ec2ZrMPtAWFdcGPqptRcMlehhB2m2XuGVBa2A10a5a4NCETy03E81fVTUga444Um5AAgXlSvEXJw20iG9iRkpe0RURt5P6PZQbxmRs/+Qgm7S2OPW88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EBu3vMuu; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ckimtGwb; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EBu3vMuu";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ckimtGwb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745842598; x=1777378598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hQTgG9uSP4TWZrARZP/xKkuJ1Jj3befgTInp917WuBk=;
  b=EBu3vMuupNwk+oBtqj6TmWW9CBaP08hb/k+spOKUTl/SmhAtCj4gaXG7
   9vDRuc96ZX4JoC4uIP382Vvn0ENKlTYwV4GrXKVB6c4Lb5SIg6BOMXn19
   dAbbqkBD3p/7zIU0binAyjPqCYHmpu/zshjRGAWhoQkXboA4Xqf1F5wtH
   KGi0QHD4BgfWzNpDdeqdEF7ynUzwgskiP8YwYpZZixbk1eO1jhubGCVCs
   avI9+VVnNy1rXXXLV8eKumwJVl3SsmKgEWuUjeKscVE+FVpBcxN4q/nPV
   cpLDaDwLpDcmrj7QRWD7MGu5HaPLFatyL0qgb8m5OXq0L5t4Ej2VNobrN
   Q==;
X-CSE-ConnectionGUID: OuEMk84aTga4PadR0EOp5A==
X-CSE-MsgGUID: 8Utjvhs8Quq7TEgu0r2POQ==
X-IronPort-AV: E=Sophos;i="6.15,246,1739808000"; 
   d="scan'208";a="82648696"
Received: from mail-westusazlp17010003.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.3])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2025 20:16:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NE9AI1WJXs0llqXskIRyQcb7GhXVY96HRyinIKUw68VgqZqX/od6s7w0Q7uev0Hbqdbb1Ze5vIqX/K0DeCK97Ub1KEDC3YozdadO2WcASvAj7v8cd6mnPxlQre/i2P60HwSwujMcFues5Ur3H82/DEtdDZrlqgezq+zCX87D9VbdrqPnTTlQ2jXDA3loJrjueJG4R0nwPU2Ta6mFPwJ8CEmqhwqk9s9fUurCtv4dt2tEx6SeEqP+bI8+mNqz+k09pEpayhIaFxnfWHiEdNC+mCHjjflpoDaECu7AceYncFnWF6naGC0Gxc1KyeEtR7HXduqDBosRxXVyNeuJaywRdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQTgG9uSP4TWZrARZP/xKkuJ1Jj3befgTInp917WuBk=;
 b=kRBgdV4KjO2z3KnXjBe/1on1cv7A2rKBniYnFtD6g5jGqSjj918F80vorA9As8g010VFeDRm50KKc1PWtQxE+B8uuEFYKfkifoGAY1MTjJDVksHjSGu7sKt/m/B760/Mj08GlGfMuTz5UK9fcEiZ3szIUbw42YWZOFXg2FEOhcQPoPRvCdi7TEdbF22rj/5g9s5HMXNfP4BibOQs75Wn1kwIx/JQjyjlcntBlAD8m+a8H6gGRDW3NKUPtPRkvEcwBGheUHEYENq0El1M3QBxpPVdelXl+HHjDRYBvkP363CWt8NbQEKg6SvUYUdOzlduT0bpmoellXxbGa88ag7APQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQTgG9uSP4TWZrARZP/xKkuJ1Jj3befgTInp917WuBk=;
 b=ckimtGwbCXpTt4JZjLpiiCD1fLzRKRZwxbtWIPP0/MXtX7vNbV2o1z5ZgUbhqpQTT/REKJkgGcdAIFFe2W/zQKXyUgQxD/eNwWF2HDinnnuyAPowrP+APnx2u8uyVMdT4urotTEHMBhbElVDs+x2A0qT/raDeZ+DGNXEMWC3oqc=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SA1PR04MB8465.namprd04.prod.outlook.com (2603:10b6:806:33e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 12:16:34 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 12:16:34 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "zlang@kernel.org"
	<zlang@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>, "david@fromorbit.com"
	<david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Topic: [PATCH 2/2] xfs: add mount test for read only log devices
Thread-Index: AQHbtcDlALwMj9CgvEO6QaqlIzHfhrO0e1cAgASH6gA=
Date: Mon, 28 Apr 2025 12:16:34 +0000
Message-ID: <1c313919-f6ca-4f53-be69-21fe93e97b0e@wdc.com>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-3-hans.holmberg@wdc.com>
 <20250425150504.GH25667@frogsfrogsfrogs>
In-Reply-To: <20250425150504.GH25667@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SA1PR04MB8465:EE_
x-ms-office365-filtering-correlation-id: ac489927-da13-467a-9210-08dd864e84b4
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RXJ0MFZiSnFWZFZJMDhJdXIzV29VcVVDRENmVVJOb205SHBxclp4RWUrSEdP?=
 =?utf-8?B?ZnY0cUdLOFVpZC9oZlFqZkZlYllhRU8xbExQZzZNTDNvektkRHNXcC9wMDNv?=
 =?utf-8?B?clhjQUM1YnYvb2NrR3ladElzK0NCRCtxcDBtYm4vd0hVNjM2bFZKVlNQR3B5?=
 =?utf-8?B?c2trWTM1SWI5ZWRwU3pndllGdnM1V0cxdWZ6aGJEdTVhZ044K01SSlN5Ykdk?=
 =?utf-8?B?RE9RUU05RGRNRVpET2IwNVlGeHlwQUlVSTVBUGFNVjNHWjlOdmtCbzV3UEZp?=
 =?utf-8?B?RmlJL2xpL0NLY2xUMXVWVk1zTjB1ZlZsbllRZUhBOUJXWjYxQ1hxN3c4UGto?=
 =?utf-8?B?YUtXeUY5UDVCY1NqVml4cW5MQTdvYXpGTkkvVXhrT1ZCd2ZMRm9PaEhDeE1Q?=
 =?utf-8?B?UGUyZTZWeDVRbklhcVVXOU1RN0VrNkUwd1IxSU1RZzQzbDgzSWVXaUNkOWhn?=
 =?utf-8?B?U0U0bXM1V3FEV1ZUeVRkUzFzK2Vta3ErOFM3RVZpZkFpOEhta01BV1lhMnNj?=
 =?utf-8?B?Q09lNEhlamZkVkYycnBjVUgxZW1rNnpWSzZpdXNhQnBiaGQ4Tit5QWdrZzdN?=
 =?utf-8?B?ZlhaY2w4Z05LUitmNWJqZnRENkVBQWMxQytFVkNFalQ4RFpuaWJJcHpyK1kr?=
 =?utf-8?B?ZHJoM05EaEY5cHRTOTUyYm41bjlFVWxpRGIwNzRIK3BDQ0tNWWcvb09LZ1hp?=
 =?utf-8?B?ZUp2dUpEcFVaRUsvb25zU3pzVHlPT0ZsSWlubjkzYW9DV3FjWnNZMzFBanVF?=
 =?utf-8?B?aWZ2T29tZVMxWWd5a0MyZ1N0RnQ2V3luZDlZUnpDY2N1U2xXMmNFRjREQXhO?=
 =?utf-8?B?VUFBUnNZTi9pemFKcU9pL3ludGNJUmtCaVFJUVpiRjFTVWNzYWFNUUpNYkhN?=
 =?utf-8?B?L2RqeE5RcXJrMHlNd3haVmZhN09jSU5Zak1VSkErM0F6aEJoZ3JEL0pLQ2ps?=
 =?utf-8?B?UERXWVNWb3gyczkwb2I1Y1cxRG9hc2ZlQXNRRGNKeXJYTnk1ek1LRVZoMklt?=
 =?utf-8?B?U0hhTWpnRkVuYVIyL0JHT1FFT1YwdmhRQlVaV0pKZ1lNSUhCNDlCUE1BZmx3?=
 =?utf-8?B?LzRMVUxUckxNaWhQY3ZZWVd0S0c0NDVNY3BlTWRWN0h3WXJjNTNZTDN5bk4z?=
 =?utf-8?B?MTQwbUMrL1N6VVFTL21GbHhYaHdHSXB0R1dSUktoQkdqT3M1QTlUMDRTcWRl?=
 =?utf-8?B?YmFEeVVZQTRqVEY4VDFZZnU3QjNoanF4Q1d3NHdNYlpjcXBUZ2Q1Z3lndUdw?=
 =?utf-8?B?TEhmNFVORVZzTWZQSW5zU09oSS9tRlNydGhtZkJhdGJsKzcwRFFGZW9SK0xs?=
 =?utf-8?B?Wi9SSXV5Wjk1OTRuZHpyVjdDOTRWZ0haQzlSS0NIZTFIenBOTnZsZEh1OUY4?=
 =?utf-8?B?cUd2M09xUitUMzZsY2RhSGFUOFZ3Q2prcE02bnI2UW15S2txdVNzWG94dEJQ?=
 =?utf-8?B?T2FOK3ZvbGJZZ2hyQWQrcXdJdGgzZXBOQkVIaHhwTzRaeS9XTTF6ejlnZGda?=
 =?utf-8?B?b1liZTBOK1NoVlNZcldpcVVPVTN1SzRuWkFlTWNZek1ZT3hGTnYyVHpyb29P?=
 =?utf-8?B?N3h3bUs5MkVyZ2JRWTVlRVZkaTlBdUhsbXpTYjU0dmRNanJXcVRmVlBZYThP?=
 =?utf-8?B?eFl3cFBjblNBcFM1cE9WZVBlN0s2UXY0d2xhejJGcjBZd0ozTkVvS2loSWda?=
 =?utf-8?B?NGNRY1pWNnk1cjhxSkR6R3JWbmFmWFloWVNNd0RNd20wT0NLcmVOeGxwVTdr?=
 =?utf-8?B?MWJZT2NjR0tJa1J0Z0ZCTUpPR0ZJQ2ZSL0VackdEcHFsUUNyS3EzTUlFWmZO?=
 =?utf-8?B?TXBIYldXalJJcGdIMWZTV2d0RFdUeTBnUTlLNHA4NjFqWGY1MlZid3hnYTRE?=
 =?utf-8?B?WmtqOHVxdFRvazZTUjVoUCtXTjRWK0xpQXZSSHVTK1ppUDZRVkNyWENuV1A1?=
 =?utf-8?B?MXdmNTdyc0psYVljaUU4Zkk4R01BUVJEdnplNmtVZTlacVFjSTdob3hSTndt?=
 =?utf-8?Q?0hHE2qgia96iCfriEtFDf6t4V6wQOw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?clh3dTJ1QXFOMHBsUFV3VjkwR2tjNTlsYkFmRzFVNVF0N3pmWGRDaVFEV05U?=
 =?utf-8?B?WlJiUWFsTTlJeG54WHlPdWU2ai9yeGgyMTVhS05rNWVUYlo0QzE3NnBXaTBM?=
 =?utf-8?B?bU9BK3dDeUp3ektIdGRRZ3JKNnNQU2czR25YYVljOEVBbXF0U2NoazFBRERY?=
 =?utf-8?B?aUxKUnZLT1pPb2RqUWdVTXZKZlZDQWk2ME8yanZubDI5QnYxdGk0SjRuenVL?=
 =?utf-8?B?V3dqMzRUeExFQnU4U3h0MXI0alJjS1pWNG1xbTExUjRzbGhSc1JFV0NQK1V3?=
 =?utf-8?B?Ny90cmZpSFdjMXpFS2hJR25yZlRXZ0VnM2pobVBxejlVRmg5MUNDQUV5bUlU?=
 =?utf-8?B?VFJCZ2ViRzdSU25OVVdXZXpOa01CVDZnOWcwZUI4K3dTTXhUUUFQWndGNGRa?=
 =?utf-8?B?UlFQZzdZVCtpK25RWmFoRHhwbkNLT2c3QTJpMTVHdUtMdjN4NFJmZ0R1L3Jw?=
 =?utf-8?B?SVJoMU1xWE16T1pSV0FseGdlV2hWZEszTWVabWlZUFIyb0xtMVNpS042dDZa?=
 =?utf-8?B?cGhjV0QwYk1za0JPRjJCa0NYUmVOTjB2bkR1dHlyRXlQTnpKUGNzRTVhNjJH?=
 =?utf-8?B?QjhFcGR3K1pqN1B1M2dZeFBpNXc5N0UzQVhubEVmQjF5aXdsMUsvQmF0R2ly?=
 =?utf-8?B?SEp1NC96UkJ6MGk1cHp4RTQvQndPSHJhVXNwc0NxVlpFeDlRZFV5UmF2aHFx?=
 =?utf-8?B?Znp4QnprSEtIZkUySU1tMUMzVmE2OE5NVjYySVBJMWRGZ1JjZXcvRVF3d2xI?=
 =?utf-8?B?aXpERHFuWElRSFdEbFJrTUZrTS81OENnK1JZMFNWbjloNXlaT3ZYYWU1ZHdm?=
 =?utf-8?B?VXNtVGRhUSttWDV4MEZEZlE1UUpuZkNXOGF4ZGdLL2NwSmttWG5DeXNmMmlF?=
 =?utf-8?B?SDJVMTJxYUgxbnZDR3lKUE9tbGU1Ym9nT1kweTdnWFpMUnlqQnMxS1BVVjJh?=
 =?utf-8?B?dnV1VTZDWUhXWUhDMTFlMUh0TVY0cEJYc3BveHJhMGJHTzFZa1pSbUJCK0d2?=
 =?utf-8?B?d1ViWmtJaTFlcHRKOW1CazRxRjhoTjRueHYyMnRnVTlUbThBOTY0QnRwblNr?=
 =?utf-8?B?RjRTQ3FEVFh6ay94YWVVOXVwVGpiNTJIckh5UVlZQ1poODM4b0RLTXFHSGZp?=
 =?utf-8?B?Q0xJWFRvT2hLb3BYS01QN3UxVmpESVZhUFhwckRZVUV4THVocW5HRjdSQVFs?=
 =?utf-8?B?WW1FT25WajVrVkJMSmorWXZYWVNWR2dRbTJVVzBFNGtBNXAzaW5jdlpvZGJD?=
 =?utf-8?B?T2swcy9GR0ZBazl0UTFJdFk0UEREZnh6MVcvUUVSc1d6ak5taC9Fd1J1T0l1?=
 =?utf-8?B?VlZlY1hOZ09LSE1wR1EwbkNnaDRUQ2pOTlN6MHhmTlErYlQxUWZ4THNoNWVp?=
 =?utf-8?B?alorNGRwdVNvbXcxdnFDSkVZV2ZkZ2gzSUIvN1d0M3pzUXJSUWd3MjVEeXlX?=
 =?utf-8?B?RzdKNjh3d0dJRmFpZUhqVWxnZGpnaEtUekp3MUd1R0ZNaUpnZ2RrcExJNzVV?=
 =?utf-8?B?WktyM0FvbW10SmhiRklHdFBXdTdmY2phQTdjd2hZVFZoNGZYSGhrcmZndlQ3?=
 =?utf-8?B?THNTVHpDSHJPQ0RtLzRzZ1ltcmJkZ1A3NDBDdm1GeWdxRmVtYnhRV1ZscnJN?=
 =?utf-8?B?Z2xuMlBLNi9EbVhvMkt6QTFmeGgwZlhMU2huUlBaK01iQmpKMGMzakdoU2dY?=
 =?utf-8?B?eUdkaDg4RFRvTWF3K2xjVHRic2hPMTBxNFBVckRXNGp3dXlQNXhZU2Q4ZGRC?=
 =?utf-8?B?aDdKZjhlSFh3Zk92M0xYcDYySU1GMGhNSHRIQlIrbkRBVXh0ajd0U0tYYnB0?=
 =?utf-8?B?a2JWWklQWUhKQUtRRzlJNHpCWjcvWDZWSnFDMUdHVTNEcC9FeTFEaGgwZEls?=
 =?utf-8?B?c29oU0tjZWx5aDRuYjdjdDVFU1pWR1czTDRydFhibitjZ2lZUS9YU3V6QUMz?=
 =?utf-8?B?RmRIeEx0dHNPV29WYTE4UjlUMytTY0ZMZFBXdHVYMHdaMTR3WlZiNDZvYm5Z?=
 =?utf-8?B?alNCa1VsMnZoRlVVOWt5NXRKMlk5TmllOHFYTWo2K0lXY0ZoQmM5dDdlUGJm?=
 =?utf-8?B?VE1oVlpLR0Q5SmkzSk1MajNDdjRrcDJ0cjBsSmUzWVkxYTJBaDk4M3hUR1p2?=
 =?utf-8?B?NlNHSjdJUDhPdVJSU2RJNnAwWE0zV2t5VGJFZndaM2FIM0xISUIzdThkcDR2?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3027FC2B98F6984E9C696E91E43EBFD9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jMY4TN2m0cwHnpMj2us0IBVFEZK77pxHFtz1WrLcht0JQHzvZcR0MX+AYkTkBZ5cZ4VFkORLq2u/xkqWCiM6APqEkTS7l3rjCzftTj27tuaH0nxGQ8MIDP/ak55OK21/V3XVmu7B95ZF9mTcYq6C8M9YH3gRR0v+eWQ2A80uOjQ1BN2YSUXRksO55ZiV4AkmDZ2wuT2Y0KjnOb1MjvQukT372x2yPFzC9JRp65vbEHQwQWJZTCvoB8dMFFS/rpr7lc3aBnoaGJvhjCe8ONfW/KQcKZC9d4QDJAccbKQoaqggpK/TPPmvhJW9xrJyikZ3yE3hQOkIO5yJAp8VGb1rp+Pvq7lhYE4zKNiy4lEYCnaRuYrWSlkFpenH3UryROWiTv2Ay1sB+OwVMHN+ueprA9X+efNvbzWt/cKZHiWHXdmQZBBm2Dg8CLUKZ05l68/CezgmX4P1s7KFiIRJzz8Cl2w2aPHYKToYhg3cEtv2tIeW58ZIfoO+6Y7P8wekfLKFjcpbCWu3LgBfMfxeATnejTLNiw8SE1jxGyr34u5vlYMB0b5GEcJsZI2Q4CuwN84n5LjGISo1jz6cBNIsF79mcaJc2eTVP0GC0/Wud9M9hVjvF3qsCRRVWhbUAS6bQ7X0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac489927-da13-467a-9210-08dd864e84b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 12:16:34.8163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWeW1y9Faigg6Tux2YjuIBNjTE0vGV3YEJdRV4S9fzrHQa+tKto4GhM/WBEFa9tkY5G0NVWQX/ig2Xl6OYrIiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8465

T24gMjUvMDQvMjAyNSAxNzowNSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBwcyB0aGlzIHRl
c3Qgc2hvdWxkIGNoZWNrDQo+IHRoYXQgYSByZWFkb25seSBsb2cgZGV2aWNlIHJlc3VsdHMgaW4g
YSBub3JlY292ZXJ5IG1vdW50IGFuZCB0aGF0DQo+IHBlbmRpbmcgY2hhbmdlcyBkb24ndCBzaG93
IHVwIGlmIHRoZSBtb3VudCBzdWNjZWVkcz8NCj4gDQo+IEFsc28sIGV4dDQgc3VwcG9ydHMgZXh0
ZXJuYWwgbG9nIGRldmljZXMsIHNob3VsZCB0aGlzIGJlIGluDQo+IHRlc3RzL2dlbmVyaWM/DQoN
CkRvaCEsIGFjdHVhbGx5IGV4dDQgaGFzIGEgdGVzdCBmb3IgdGhpcyBhbHJlYWR5LCBleHQ0LzAw
Mg0KKGFsc28gYmFzZWQgb24gZ2VuZXJpYy8wNTApDQoNCldpdGggbXkgZml4LCBleHQ0LzAwMiBw
YXNzZXMgZm9yIHhmcyBTaG91bGQvY2FuIHdlIHR1cm4gdGhhdCBpbnRvIGENCmdlbmVyaWMgdGVz
dD8NCg0KVGhlIHRlc3QgbWFrZXMgc3VyZSB0aGF0IGEgZmlsZXN5c3RlbSB3aWxsIG1vdW50IHJv
LG5vcmVjb3ZlcnkgaWYNCnRoZSBsb2cgZGV2aWNlIGlzIHJvIGJ1dCBkb2VzIG5vdCBkbyBhbnkg
cmVhbCBjaGVja3MgaWYgcmVjb3ZlcnkgaXMNCnByZXZlbnRlZCAob3IgZG9uZSBvbmNlIHRoZSBs
b2cgZGV2aWNlIGlzIHJ3IGFnYWluKS4NClRoYXQgY291bGQgYmUgYWRkZWQgdGhvdWdoLg0KDQo=
