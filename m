Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4313C198E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750369; cv=fail; b=epwR5qfMHH/8d3WzMLVPKd0ydZ6SFqtl+j6/hKLLsl143HM4Y1fuptRhX/Tdr4rCzorfdislvcyllth2B4OZ9EXvkIdg0gW9WnMRAvBemWWvm6HSyM3jGkERvPYtUKT+gSFsDvKk1TyUUkfdkra03hH//QdGofxazOXPbwtuRDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750369; c=relaxed/simple;
	bh=zuqtgp6U7Ni+wPSJ0PdPd5nMzWlTW0hX+ADIipRo1a4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jXaRTfYHH5xBda2SfrRzsw3XbTSCdN5Chvk2XFTf77YsC6qsFC4j/qOVAeEhaey3lYEc8ZiLgGuJH5cO/k4X8v/buu0ZF+N37ZA6VKO7WR9J5A/cifGqNkTYWFF324OPaZ9nRfx1T88eN1UwCVBa7AVPqQzGxtvOThH+tkuCjio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TBfKRU4w; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=H30xKOIE; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TBfKRU4w";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H30xKOIE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773750365; x=1805286365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zuqtgp6U7Ni+wPSJ0PdPd5nMzWlTW0hX+ADIipRo1a4=;
  b=TBfKRU4w2iexwsytJ2jGSZhsZrEIuGDJKV0iMdJU29Vl5nxt0+UGx8/G
   qU0Y2cs8OriIgLX6sBIn/5pryDtapVwP7rybcbVkwi1vwZXZpz2PR6laU
   O+5Hhj3Sw85Jah71kl+KysFXyBvFwH8gItZ4AloqTY6plnEFZDhUUrtoW
   dmGo1sjN7kJ65cAohRxLtH5tDxCdKZCxGuhx3sS8VWfybrCNPK8VDq9wJ
   IlUWzdtaK7bKmQ2CdFwMTyopN13avVWYQhZ8EFm/V2p1RQOEo+kofW0O8
   7pR3WGzbpxRLkBOK/ETIqCVWkCjqC4Lw+8YfQCkSFzQnKjCa5az7/Yqld
   w==;
X-CSE-ConnectionGUID: Am33iPgsTL+1xjKr5tv/Pw==
X-CSE-MsgGUID: D4RobVAZQZqjacJTbAHVJg==
X-IronPort-AV: E=Sophos;i="6.23,124,1770566400"; 
   d="scan'208";a="141680566"
Received: from mail-northcentralusazon11013061.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.61])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2026 20:26:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvBL92gsHtSynaK7gOGvDw5Y+z2/y9tTKdJWXl1sqQLQ/jTv08GhaicfLzMAiQ6jHoVnsM69+hilyQMAHz9EZO0OIO5IKmzfSpwz3hQ3ax1IDjp96g39Jiomod5tnA7P+Zafil99NFkYOUdWcGXFJ695bEIY+wOhylh+RyUQotkUybnmUQxZoXe0+ZuCNhPq52o/gihmnUV41cszB2v9nfzRuJSBCQ1w2jsr2fUivjtNNeuujlElWgpffTjLyIRY3OtCmln2wg/pniaIKdgtNwSXOHtgMlSYWbYYulMKEy5E4kieTlD8xwujIylQ6znQ8hiH2Jz8oxYso8FbZY/yOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuqtgp6U7Ni+wPSJ0PdPd5nMzWlTW0hX+ADIipRo1a4=;
 b=sfQmf4MSVL81Ljdp6Eay1gIHMnCKLqTUWBFziEup0tAtcQvwIYfzp7ncFttZ/AyqWXhY1mqzSL4kETsjLPZ7uA32mCjPOLf9VTx2NS2mroj/zrN583hLfaUvm67z+Bja5tC82/gFQmJei69oIQb1ddbV0ejeq9sg23/Huw/Kc+YTHAbU9kAhWDVP76eqiWksZTdnMDyHCl+I8tmdLh9OwojcBiOiKF/wdPqiN1uYdroEZUO+PrqMB1I7X8Oi+VNUHd9bRqvXEJtvcWz1W8fjBLzFmagM9Z0okw+noFD2gAmgWQPxLWZZ0AUKf2HaZTrDMVIGOhYSg8I7Pq9gHxPBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuqtgp6U7Ni+wPSJ0PdPd5nMzWlTW0hX+ADIipRo1a4=;
 b=H30xKOIEUhyE473IRE0EKYZB4JO/v8xwXm1a9XCyNAffj9cK7KH2t4zPGrxoPpgO7znEe7yUSTlncM3wNtE9ZA7UtHLMJtJlkDwPf5w+kkUNglatHIHdStglEbmgBXBuLUJ51tS4BROjBkzbVJPxY1vVuIyDTiPYpFy/ew/KA3U=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by SA2PR04MB7674.namprd04.prod.outlook.com (2603:10b6:806:14b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:26:01 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062%6]) with mapi id 15.20.9700.015; Tue, 17 Mar 2026
 12:25:32 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/4] xfs: avoid unnecessary calculations in
 xfs_zoned_need_gc()
Thread-Topic: [PATCH v2 4/4] xfs: avoid unnecessary calculations in
 xfs_zoned_need_gc()
Thread-Index: AQHctTp2FCaUbTiS/kSFEv1j09gQErWyp/gA
Date: Tue, 17 Mar 2026 12:25:32 +0000
Message-ID: <deb2200e-1410-4c56-8a48-654f24f14bab@wdc.com>
References: <20260316114020.753228-1-dlemoal@kernel.org>
 <20260316114020.753228-5-dlemoal@kernel.org>
In-Reply-To: <20260316114020.753228-5-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|SA2PR04MB7674:EE_
x-ms-office365-filtering-correlation-id: cbf12dcc-b2f1-4c1b-47e0-08de842048bf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|22082099003|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 5fh2S1HA4SdXY4qOzdMMKNOH9qN9sPxEev1QJiwGm5NDuetUFjbHKbANQLLG5nlWLBR5zBxC+BBmsgQ0u3SjsblaWYIkTzClrl49izVE1j3QZfqEkqedjmno4FBnej0eISNECnr5DOXtq60LOr9jLm+vQ/vLRPtufHWaVvzasQ0iIENlSBMFqO4uaOi253UFaE7Kc2XT/kFsaXrnsySqiRosmpzLoqx8OUo6DcBsXp9i8GKjVt4TxJ5DABZg2NKUdtqit3RqTh7zGiVVZuLXNL6JbqCxs5lbOjbG3FmtF3Bu35o5BCq4KUwaS/4urPfrBg93brz80zyquAN43dVIR81Z+xLs/toiTKQ200W2GBzybJGn9oP1C9AKec6LumfitIiz/FvQE9iacj75U1vgoj2wd0fkXfZaMS+v0f9V3f8N66UeXu7f+dRA1qY6wP9UL7enuEtEyY+WQky6EzhwsldvaZN22l2kaGqjxKr/nVMEeezHjWwDpzv6oieQE8QWjxfF5NM0ypfyvewKrVv9sOiM/3PEZ4B2mL2KF4rNCo/Bhe6asHpv4PR/wTTNESJZ6TIOieR3sE2ChEWbiF+/30igsSQH9Xm4P2+/68qyzQWr8c3WOBSCFrwSpBtxE8PsWiBS14+fIBprIfzeUH2lny5TGEMpMZjdRR4SmnbgkJh1uryZrMjqfZOETqawj0aR1kZZntulokBRrYUUuUXg3UNNgZv1DNmOnJifohtUW9vwTPJst+IPc1fIgaQWnL+8IZtY81jW20HWi+tBy9xqBYynLCXUhu4UXOZ81BuiBik=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFJKdllQV3hiZUp4d2hvcjJLd3FwU0lKVWFjRllXbDVHYWM0WExhUk9MNGpT?=
 =?utf-8?B?OHJNNVpWNTBWR1grS052aGFVUW1NVnJReHVma29QRUtFc1grWSs5U2d3QVpa?=
 =?utf-8?B?WlIvTzcySW1aWkEzTWRKUENScnJXb0VZZCtXcXltbS8wY3B1dGZyTmo0U01r?=
 =?utf-8?B?TVhMVkI0N3NYNnRpdFhHZm03ZDlzVUdrdVVmZWhEbDlHcll4QnVIMXhiL3dI?=
 =?utf-8?B?OXUxbEM5Rk9ITXBkQWNqbGg1QkI4bGFmUlZLR2l1cStITWxsTDM3QXFieDda?=
 =?utf-8?B?RXB3T2lOc0diZFNGbC9pZDlTUlkvdjliWE1hS1hLeEtvMzdTcHluVW52NkV0?=
 =?utf-8?B?V1c2TEsvdEgzb1ZtSDFyWmN4cE5wQ3hYMEpTNi9mZ25ZanVqNkhlaWhlcGp4?=
 =?utf-8?B?UldURWd0TTFWWUlFeUlyTE9DVmVnOXJFVmJIc3lnRUNBY3Bud3RHR2RFNUxY?=
 =?utf-8?B?ci81cmVzT2VYQVhVdTVHQnhkZUgydVIvdDVPeGFCNitnSHFFcDVUZVFKS3la?=
 =?utf-8?B?Z213djl1WFhFM041UWdoWGYyR1RvRTFuaVZ6RmpzOGFKa3VIUCtiaFc0Wndo?=
 =?utf-8?B?eCtJRCs2R0ZjTkZHdzFlMFFYZ0pyalQ5UVBEUUE1OXIxVk1yeEJXcjRQanBX?=
 =?utf-8?B?emxiajR6NWFkM3FpZC9SalhZYi9KdU44YnpKWjF2Ym5Ra2R3ZjNOV2xUNE5R?=
 =?utf-8?B?R294eDdwRG04UnB2SGlpSXBUTG12S05oYit3NlRjRVFXK2VZbGkvdE1tMDZX?=
 =?utf-8?B?U0dPZkhJWit0Qm1ma29QTmlGMlNTNWNhS1FxOXhNemtGVjJiUnJLZlNKdmp6?=
 =?utf-8?B?c1ZrREtGUkkvV3NSb0NHSDdvQ0ZxY1BUVUcwMFFSeFJKZFQyQW41Nm5Sc1pv?=
 =?utf-8?B?WjFHMnpoeHhDdmxxLzM2NGlXVWExTVZpUmViQjMwUUpwYUJyNlBIbFRMUG9m?=
 =?utf-8?B?TDhMQmRTUkxpUXh5Z1RMbis5aGJyZE1hY2lFcjVIZ24zQVh2MGFsVDFRRGZs?=
 =?utf-8?B?TEJjVDlnMnJQSmJjTDQraVBkeE9GdWhiQWNZSFRwVXdOeVFLUTFOaTZsQ01p?=
 =?utf-8?B?MkxKenlkcWlVTDU1NFZ2bVZIM3RPYWRVSVoyTStGQXZCZFd4TnpKVCs1aWw2?=
 =?utf-8?B?VVlXNjFaT21yMm5jL0Z4Zm9KRzZXdEE3dkQrZFNCY05UN21SdzdoU0FzVTFV?=
 =?utf-8?B?eGdQVnhseE1SWkhJd1VVTHc0amxJMm81R0ZWdWhkRG5mWlJnQmR4RkRCdGkx?=
 =?utf-8?B?WGpEaWlyQXE3SlhxaUIwSmxmVDFUVDVPOUVLUmdDb0ZnaEgwUmQxNGY2Mk9X?=
 =?utf-8?B?VlVGNEV1a0dQeVltQTdDb3lwTWlFeFljK3oySVpoaDdydkpnSFU4QVE5OEJH?=
 =?utf-8?B?UlR1bURENHN0R1duRXJxaFpyaFdzL0VmTGdMV3lrdmVScDZQNUVTVzdKNHV6?=
 =?utf-8?B?SzBDVFh2ZFJGYUx4R2tCNk54RnZLQnlvMXRsVjRlRXJUcUQ5Z2kzS1krTENX?=
 =?utf-8?B?UlBRRE5YM01kM0c1WUhHZVJicDNscW5NMVBqbXUwZ0p4dk9wbnVSWVdreDZF?=
 =?utf-8?B?ajZEdGxJZE1OLzVVamVNR05FUXB3bEoyWDhvRmpzb1FWYmxlK1g4SVZnd0pY?=
 =?utf-8?B?UWJzWFJpVVNBcFFRTlFOTDRyUHRNMXRHRytiaHJQMUFTQ05DakppMStEd0pi?=
 =?utf-8?B?dXI5YzZ1TlBrMmRXM3kwVmhwZkRXK2VENmF0ai9Zd1YzUnR5QktEcGtLKzZO?=
 =?utf-8?B?QmV1cjBJMHdNbWh3WGlrN0N5eUtQRXNJQXFHQlE3b1gvYVowSnlWL3J4VzFM?=
 =?utf-8?B?b2R5cm5hODl2ZkZRVTNIMTU5ZFZ0aDFyK2xVQS91WUJPNU52NGMxMzRZUkRK?=
 =?utf-8?B?c3VjdVd2eURDQjQ0cWJtdytMaXhrMXY5VklmTzk3dWNGdWJNbStSZ3VKNWRI?=
 =?utf-8?B?M29VZ295b1U3eXRIS0VXRDZrUGtOcHJ5THFXZTFqdjk5alFBNzhZaE02MldS?=
 =?utf-8?B?OTYwbmQ2UllKbmZJb0wvOGhSS2hxTkZ3QjFIeVNCcUNCSE53YXpJTFMzMktH?=
 =?utf-8?B?emxNWnFOVFF3WEVDaHNKUGIzc0tGUWtDYkdBbWJUZEhQRVZHWG90VVhrWHR6?=
 =?utf-8?B?bnpta0NVaGduaGZYTktKZkg3UlZvRWRWc1pwMFhJcXB0NktxUndEYUJMakU4?=
 =?utf-8?B?ZUFQSGx5VDNCWEkxWXRnZG1ybjRmcTlYMWRKNkJuUDVKQzVsNm5nUXJYN3ln?=
 =?utf-8?B?ZGFscWJaWm5JUXlOTjBrdnV0OUZJUnpLd3d0bFI5V0d6SHR3T3p3SkVaS0sz?=
 =?utf-8?B?L3hNUS9RUHNVYVpWQm9ubjBzS2tzcnBkdXpNU1ZxdSszcllubjNDQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87F46AC25FBD8742908F6604468060AA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	XWKoPHM2BeMjfCheSpYy56LWwuVQiGhbM3HQ+2O1XvxFTL1XHHPXOFSrm0BeA5Ua0NuJ9+CXufR+wrU/oWepZyTEqj13iALxt13VvbDxLDAjuRB55kD1FoowiTbRY1Rt2GMhNygUyXt7Y4NfKJWYFIkc91pJSpA2UVStx+l8QtPJonMzdGmwyPR6VraGWeXwGOfr3jL2OaCmglIZkvI7FnMWx8Pvu6RqddDy3eSwGHqeqJYP3JsN9yQ167ckvAvkCt1Tyhqj9Ag5uBDDiKcqg81ZyTqaCiBxdQ/QF+YWJPqKio4yjnve9L8URHYgvAmtng/PBk3kX5hDRA1URnEydg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Si2TQ9MzRlTQYTE8fD4MGaSJ07JTVNC7jk3qTudTyWfxolGgLZCoaezdFFHUJxpRplc6tmn7pSCuuno9po8DabrJTCJdF0JA5l0oV6zjcDNLJYezTOKfKlEvY6R8Vzc7wLd5/ZUgnHGNZQDf5PzD/0nuL1Kpn0V0Ck1yEoQa4IjhuayuC/eyjei3+0uHuOgI3+whdN+yKurrb9yVza20VgQznR2xhQf8//zVkJrZ6tezJhI68VHgvJVT/tKfVOAiViXSL9Nk4mXLAKvSO11sNU5znXOY4+2YVgnrypDcINLWicjy9mnbZJeokFuKtEmdpPv0EntQomygPU5BG39fbZu1+kdj2OUSH1PC84582++4JdsdOmRpzSFyQv18dtE5yZWQIsOOc64lyd0rYFxBnMSkvzrlIsIzyznTNGcUEng4Xsd/vxHarryi6m5VsaH89KF76T4/qkLv9qoHJx95zhNIEWx2rylEq+i7MCats+Aev/JK7USa5G9/W0524fyaaRNKN4gjzvN57W3yis6bN0vIu8IccwQs3wRYTMUGB8tW/q013IMemq44yqetaN/XOv9iM+EkVdSlVi4wscFIqY22IiDV2erAPHaLcAuTfiM8x9ioGL1UbzbXWdIx6OXl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf12dcc-b2f1-4c1b-47e0-08de842048bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 12:25:32.7324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qtWFEXIbroiyIouuqgT6qqnrNhvkRrxGPg9taZyetQwZ61T7rfFrEt7DX4SbJ5xE0RxjvZlVIrASTRXvuZ87XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7674

T24gMTYvMDMvMjAyNiAxMjo0NiwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+IElmIHpvbmVnY19s
b3dfc3BhY2UgaXMgc2V0IHRvIHplcm8gKHdoaWNoIGlzIHRoZSBkZWZhdWx0KSwgdGhlIHNlY29u
ZA0KPiBjb25kaXRpb24gaW4geGZzX3pvbmVkX25lZWRfZ2MoKSB0aGF0IHRyaWdnZXJzIEdDIG5l
dmVyIGV2YWx1YXRlcyB0bw0KPiB0cnVlIGJlY2F1c2UgdGhlIGNhbGN1bGF0ZWQgdGhyZXNob2xk
IHdpbGwgYWx3YXlzIGJlIDAuIFNvIHRoZXJlIGlzIG5vDQo+IG5lZWQgdG8gY2FsY3VsYXRlIHRo
ZSB0aHJlc2hvbGQgYW5kIHRvIGV2YWx1YXRlIHRoYXQgY29uZGl0aW9uLiBSZXR1cm4NCj4gZWFy
bHkgd2hlbiB6b25lZ2NfbG93X3NwYWNlIGlzIHplcm8uDQo+IA0KPiBXaGlsZSBhdCBpdCwgYWRk
IGNvbW1lbnRzIHRvIGRvY3VtZW50IHRoZSBpbnRlbnQgb2YgZWFjaCBvZiB0aGUgMyB0ZXN0cw0K
PiB1c2VkIHRvIGRldGVybWluZSB0aGUgcmV0dXJuIHZhbHVlIHRvIGNvbnRyb2wgdGhlIGV4ZWN1
dGlvbiBvZiBnYXJiYWdlDQo+IGNvbGxlY3Rpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW1p
ZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9u
ZV9nYy5jIHwgMjQgKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3pvbmVfZ2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGluZGV4IDMwOWY3MDA5
ODUyNC4uMGZmNzEwZmEwZWU3IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0K
PiArKysgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBAQCAtMTcwLDI1ICsxNzAsMzcgQEAgeGZz
X3pvbmVkX25lZWRfZ2MoDQo+ICAJczY0CQkJYXZhaWxhYmxlLCBmcmVlLCB0aHJlc2hvbGQ7DQo+
ICAJczMyCQkJcmVtYWluZGVyOw0KPiAgDQo+ICsJLyogSWYgd2UgaGF2ZSBubyByZWNsYWltYWJs
ZSBibG9ja3MsIHJ1bm5pbmcgR0MgaXMgdXNlbGVzcy4gKi8NCj4gIAlpZiAoIXhmc196b25lZF9o
YXZlX3JlY2xhaW1hYmxlKG1wLT5tX3pvbmVfaW5mbykpDQo+ICAJCXJldHVybiBmYWxzZTsNCj4g
IA0KPiArCS8qDQo+ICsJICogSW4gb3JkZXIgdG8gYXZvaWQgZmlsZSBmcmFnbWVudGF0aW9uIGFz
IG11Y2ggYXMgcG9zc2libGUsIHdlIHNob3VsZA0KPiArCSAqIG1ha2Ugc3VyZSB0aGF0IHdlIGNh
biBvcGVuIGVub3VnaCB6b25lcy4gU28gdHJpZ2dlciBHQyBpZiB0aGUgbnVtYmVyDQo+ICsJICog
b2YgYmxvY2tzIGltbWVkaWF0ZWx5IGF2YWlsYWJsZSBmb3Igd3JpdGVzIGlzIGxvd2VyIHRoYW4g
dGhlIHRvdGFsDQo+ICsJICogbnVtYmVyIG9mIGJsb2NrcyBmcm9tIGFsbCBwb3NzaWJsZSBvcGVu
IHpvbmVzLg0KPiArCSAqLw0KPiAgCWF2YWlsYWJsZSA9IHhmc19lc3RpbWF0ZV9mcmVlY291bnRl
cihtcCwgWENfRlJFRV9SVEFWQUlMQUJMRSk7DQo+IC0NCj4gIAlpZiAoYXZhaWxhYmxlIDwNCj4g
IAkgICAgeGZzX3J0Z3NfdG9fcmZzYnMobXAsIG1wLT5tX21heF9vcGVuX3pvbmVzIC0gWEZTX09Q
RU5fR0NfWk9ORVMpKQ0KPiAgCQlyZXR1cm4gdHJ1ZTsNCj4gIA0KPiAtCWZyZWUgPSB4ZnNfZXN0
aW1hdGVfZnJlZWNvdW50ZXIobXAsIFhDX0ZSRUVfUlRFWFRFTlRTKTsNCj4gKwkvKg0KPiArCSAq
IEZvciBjYXNlcyB3aGVyZSB0aGUgdXNlciB3YW50cyB0byBiZSBtb3JlIGFnZ3Jlc3NpdmUgd2l0
aCBHQywNCj4gKwkgKiB0aGUgc3lzZnMgYXR0cmlidXRlIHpvbmVnY19sb3dfc3BhY2UgbWF5IGJl
IHNldCB0byBhIG5vbiB6ZXJvIHZhbHVlLA0KPiArCSAqIHRvIGluZGljYXRlIHRoYXQgR0Mgc2hv
dWxkIHRyeSB0byBtYWludGFpbiBhdCBsZWFzdCB6b25lZ2NfbG93X3NwYWNlDQo+ICsJICogcGVy
Y2VudCBvZiB0aGUgZnJlZSBzcGFjZSB0byBiZSBkaXJlY3RseSBhdmFpbGFibGUgZm9yIHdyaXRp
bmcuIENoZWNrDQo+ICsJICogdGhpcyBoZXJlLg0KPiArCSAqLw0KPiArCWlmICghbXAtPm1fem9u
ZWdjX2xvd19zcGFjZSkNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiAgDQo+ICsJZnJlZSA9IHhmc19l
c3RpbWF0ZV9mcmVlY291bnRlcihtcCwgWENfRlJFRV9SVEVYVEVOVFMpOw0KPiAgCXRocmVzaG9s
ZCA9IGRpdl9zNjRfcmVtKGZyZWUsIDEwMCwgJnJlbWFpbmRlcik7DQo+ICAJdGhyZXNob2xkID0g
dGhyZXNob2xkICogbXAtPm1fem9uZWdjX2xvd19zcGFjZSArDQo+ICAJCSAgICByZW1haW5kZXIg
KiBkaXZfczY0KG1wLT5tX3pvbmVnY19sb3dfc3BhY2UsIDEwMCk7DQo+ICANCj4gLQlpZiAoYXZh
aWxhYmxlIDwgdGhyZXNob2xkKQ0KPiAtCQlyZXR1cm4gdHJ1ZTsNCj4gLQ0KPiAtCXJldHVybiBm
YWxzZTsNCj4gKwlyZXR1cm4gYXZhaWxhYmxlIDwgdGhyZXNob2xkOw0KPiAgfQ0KPiAgDQo+ICBz
dGF0aWMgc3RydWN0IHhmc196b25lX2djX2RhdGEgKg0KDQpUaGUgb3B0aW1pemF0aW9uIG1ha2Vz
IHNlbnNlICYgdGhhbmtzIGZvciBwcm92aWRpbmcgdGhlIGRvY3VtZW50YXRpb24hDQoNClJldmll
d2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
