Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743403C062A
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750136; cv=fail; b=HGQyyxCxNjylS4khmSU5PJ3vpfLuWBSRYkB5bIsJ5m613Sek7kFgUNhLxwLl4OwLgOGGpU6KQ5Zpnl6a7QzKXxk2X4opNngLpzpz2gsUCcEKC9j1y9R5+bQPY48P4Y4NOaVJ1J8mkFSK/ZZNx77eFjhBK+ZzLCfFYYX/aauTOPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750136; c=relaxed/simple;
	bh=vsmDcEyUZ3Y/H4YThodlqEoZWgFzlyyC9GnJ8Kn7034=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KIml8/ByVP17/vtnjRnGu7NueNHGE/dMxby+6NR0j7GiHNurzfVotrzT60p5GT66+Lq+lzbIih4x9GH2wZXGIYaWulJ2UwkDxuLhUnBwgyXednl9bxIBsLe/48o5+Qb1oladnTrs7jJ3hSgzmZcar5uqpr5t9lmzzisuvpwt658=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Ja2/jQ04; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=H+vDFKeY; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ja2/jQ04";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H+vDFKeY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773750134; x=1805286134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vsmDcEyUZ3Y/H4YThodlqEoZWgFzlyyC9GnJ8Kn7034=;
  b=Ja2/jQ04GjIqE3BoA5O3PRaC+OcKXaC/YQhaS1/yl9RK3xKx3eXyAMXX
   EXgpoXS6OIxWwxzpip71Equ1l5zxbDK+idaLOvb10PZcwrW6rK5wSQG//
   QHbLj5H5z0yXpSree2cdmudki1OWUzeI5v0Mlm5xSJOf0+4gTmoN6DSjF
   m7Wqv/FltZ6gF68x1B1rf3GzWX4PskaeZE1tpaSG7Etg21D6nmPS0TPVR
   gYjnhoYA6cLekODbKnD/9Z9hhMsu7jgYR9bjYQTa3wXKI3lAxtOTf+EZM
   h5nEs8/wCP7QbSwoMkP27iAr7fGmcOxyRGy6ppeW+larUcmVopZMDfIQy
   g==;
X-CSE-ConnectionGUID: OzCALiq7TPiYL+orf6F7rw==
X-CSE-MsgGUID: A5CkwCRhSt+XI4HlzEQrgA==
X-IronPort-AV: E=Sophos;i="6.23,124,1770566400"; 
   d="scan'208";a="142686397"
Received: from mail-eastusazon11011000.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.0])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2026 20:22:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzzhseMrDYG7sX20C3HaP1GLPggIo3VkmM5MWM4k8ft+EsT0SbJq4rpVB6EJwLwyZ6jn97NfJbUvwN5hORp58ZsFWS9J5pZ792Drj6Eb2zlz36wzbbfQbWTbm/a8NhC6dHE0nUxcHl3xJylbOcVD4mdMmg37y7HgetWO1+zq8YgfsG4FEjBUnuhmwNCxd85/4ycn16f+KV9FJMrInsz9oaOcP3sHyWCkn1jdNHqy4J5ihuCmLAjE6mmHprbv+tahMwI8MKzMuaq/SuYmhCUcimyY03ATrE+0FcFFQxE2sDSu6vX6RW7w2Q1PKbKh7Hv/iyXwQRpogicYL4PLvbaxNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsmDcEyUZ3Y/H4YThodlqEoZWgFzlyyC9GnJ8Kn7034=;
 b=vNwWBieNMpBaPYA2HX6MokndsshDo/7wKUFtvhW1OLECuHxo0tSlI4QzjHLzMcbyTJaJDiR2eKeKdncnjHkaLvmxC4DNRUW93jZ5gcC2Cx6sz2nNcVDeKeOwk9I/egXQZtlgxdRuf08+ihfQwGQgpo3CrcdvF8VlUDxov0yoNKygWhSvfIGoW9U1X97+rxwocgxcEafm8PDq4ijubGVM+d6WlBkI1CukAAtCLApaGYy/sNvMb/8lETy//NWQUIxPQ48Wxt2qrgTh9Es9X1RHLAaVDyLRJXyNuWAo+DecKmgm8uyk2CK/mkWtezp7vRfY7pLwfGVx8dzl05lo5TF9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsmDcEyUZ3Y/H4YThodlqEoZWgFzlyyC9GnJ8Kn7034=;
 b=H+vDFKeYz1EVq6VQlwAdqNJM2JzAm6MP6aTftCUToH5nv9p2byZZjhJMNSRTsb0b6J+gLmn6ZNko1tn/PW4lF9wkKuDBUj/A1AGc0JzgPakxGP0ZZnSVqQPFJCHGzRT5QbwGxmllV1VdDuDF30iroSgG+aa4Rag93fDUbUc2TqE=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by CO6PR04MB7649.namprd04.prod.outlook.com (2603:10b6:303:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 12:22:00 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062%6]) with mapi id 15.20.9700.015; Tue, 17 Mar 2026
 12:21:42 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/4] xfs: display more zone related information in
 mountstats
Thread-Topic: [PATCH v2 3/4] xfs: display more zone related information in
 mountstats
Thread-Index: AQHctTp2/ae934bwE0CRFCRDiLW28rWypuSA
Date: Tue, 17 Mar 2026 12:21:41 +0000
Message-ID: <cd5d850d-7826-4555-bec8-48d44f2c1499@wdc.com>
References: <20260316114020.753228-1-dlemoal@kernel.org>
 <20260316114020.753228-4-dlemoal@kernel.org>
In-Reply-To: <20260316114020.753228-4-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|CO6PR04MB7649:EE_
x-ms-office365-filtering-correlation-id: a4324669-d96b-41e7-c711-08de841fbf86
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 fYVL237IkGMMnVcYlAAV6jCiXo+39WbrQG1X2UIHyTdyfRwowZQEqCl4kaadyQxJCnqfGf3qpaGpjCbbRW/15REe0Pd23qRo0MjINzHxH8hulz5UdT6j8z3IoPupQ2LCEAxueBvy3SC0z8EOGoNSnqXw3dg0/+wWLekn/Mt75W7vp0Q0Vv9Ske2PnZUR8YWKROpTk2sFZk6RKQiGRFpZLyHX9HEp7IiOdKsJ3rrl58WVDTdcxD0eVVs61Casc1QVkWomRbJO6m7jvhV+wKS8Tpc+9Vd6IYt7HfOt7Ooir2F+a+/VHN17cvo2hzRpp5/vNfIiwFlNzp2Of4uEO/7uaP3kcXljYFTL+LoNdVPAoVWXwn+2rp7ZTtGrYHvJO0Weo85K7/tZa07DkBPWq+jrWA0scRnLKMZ1Vgopn+Voy237z6PuMhOommQSIbWjbpDLyKpqoctAXBcVmJopMxbh22VKHUNy750l8BLaXtL2NP4BSrbFbeJ8z59qywYKQdFfeQML356fV/BcVaOtzczAKvlZBw8jgAU7SROE816U4w3+YYMZwQ2BmRRYi+5IlT10bJw0BdungeHaEpaOq7O3RrkAVkPomBCHqZkw7XuhdRmYmMZAhndlABYWH98iiuMTDOhAmJ74d7HXXxBiYRMqeaC/mn/MvKtSH92hzyR24k7/luP3swg7StHT8aEihqjEle0FLjwk9aIZUBmNetVHQWp8Ln9+YrclJmS98Z62bQUXTMUuX+z6C06BibYeFvJSK1Unt03Wrg1GN3JbApc5HBnos0DIc2aDx1HNVgh8yMw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SExkcVpRa25SVWVsdDBLVkNYbnBZUTVuZ1J3RTlHMTFKNU1ZZ3RzL1ZqQ2VJ?=
 =?utf-8?B?M2hQaFFsUlhhdXdqRnVOQ0srM3NhdDd4WEZzdkp2R1p2dkZUbE5iQ2xkeFRz?=
 =?utf-8?B?aXYrSC9wYUsvWVZ6K1p6dVZVRG9XK2dob2lrVDV6dnBDaENRYXNna3RMSWdn?=
 =?utf-8?B?cUZ4TTdvOWIyZ1hKTnRzblErK3hEZ0ZpQi9YYjRiWklDODh0YWxGU1l6RWJt?=
 =?utf-8?B?RVN0cjBmM0Vwd29kU3BwL293MFVoSmlaNzBrUmNvdFl6b1ppd1Fkc0lQcUFo?=
 =?utf-8?B?aXRhS1BrUFJJR2V0QTh6eW1UTnc3dnh5QXBjYTNnN3h2a3BzVDZwVGErdkh3?=
 =?utf-8?B?Ri83dE1mdWphL2FGeThPb3RHK1Job1cxQ05HcCsyNGVndTF1T09tZnZ2ZFVx?=
 =?utf-8?B?cWg2ZlZWR1duOG9zVit5QWNGSmdWV200QTd0YWdJQVJQSWY5Z0JteUN4WFhw?=
 =?utf-8?B?UWYxTkJ4MTc0QStFNy9lQXcvbnVjRjJZTThiT3RxNGdQRkdmc3RyMEx5NmNL?=
 =?utf-8?B?WldlaXNBeVNMU3hjeDR1OENpYVhwRGJkd3hJT1lHa0t3a1F5VURRYThFRDV6?=
 =?utf-8?B?Q21XWHFha0M3UWJIUzZsTlRNT2hNSDgvWXRUazNuVWwwMHhiNE9JZXBqVDkv?=
 =?utf-8?B?Zk9mSWhzOXV1b0gxQ2UzVVFYTnlvTGpwY1BSWDNOWWZscnBoS1FPVXRRK1pi?=
 =?utf-8?B?REp2NWJ4VVBuTG1ncXVWbEZpL3NtdzFrWlBCdTNGMk9Ba3NnRGtTZXJRVGJQ?=
 =?utf-8?B?SGxiT1BSRVZmTG8zZU1xVVdWcVJ3cEwvYXVWUTNwdzlQV2h0eVVicG9KaW5o?=
 =?utf-8?B?WTl6SmRiRFNTSHRpeWYzOVhnOU1pck5QSGo2VVBYZHlWc2o0Sy8weUd0Z2pN?=
 =?utf-8?B?cnhUTXpaTjBMQyt2dEorUWlvTGRRejBiZU8yRGlnMzNZSmVETE1HdGtKdjc4?=
 =?utf-8?B?d1d3VlRxcWsydUUvc1BmSGNUblpUR2RuQ2tPd0l0d2RmNGMvWEU5em1TRWhh?=
 =?utf-8?B?QTY4ei93bGo1MzhNSDRXbURaT0hzNldDOTREWTRsOVZwVHhUaFU0ZTNoNjJT?=
 =?utf-8?B?c2J2S0ZjWSthNUg5UmoxSVlkQ3ZXNk5IT0FvRGpkOVpCTGI4SGZsbFJES0h5?=
 =?utf-8?B?Z2tZYXQ3a014d3VvNm1kV1cvdlFMSlR0ZUJTRmx3T0piVmM2aFVaaEtaTm5r?=
 =?utf-8?B?NGRBRyt3L0txNnZDR2daWTZRSE44MXNlZldwNkVURm96UFc1enh4NjRuKzhn?=
 =?utf-8?B?RzZuRGEyN2lYK05td1FmV3F5ajZZeTUzRWRFTzdVclEwMDBERkszTGFpeThZ?=
 =?utf-8?B?d0RzQXJFVmIyczBxL3RIZjZ6czUvMW4rcVFDTGhFK3FkbzFxcGJVa0FhbHBs?=
 =?utf-8?B?Q1BKcU1kRE1IYWRWRTl0Rk11Y1RabDJWQVJraFR1L1J4aXBaakhiWTFpL0NE?=
 =?utf-8?B?OVo1d1ZQL2JicVlnTHZHN3lxTU96U0lLZGlaRi83OTRDbWE4UEcrRUVKb2JL?=
 =?utf-8?B?VWgxV2NlOC9CckExTGpUYTcyNUVtdmNIazh1UXc3eHJJWDlqYk1yQ3AwQXY3?=
 =?utf-8?B?VTU0N29WeFJNMEpaTVMzYnpKQ3piVXJ5MFZzc2JlKzBla1l3LzJ3cjU2T3I3?=
 =?utf-8?B?Z05jRlVhS1p6eHZHMkxqdVVOM2tleGlzZUhtNFM0Q2EwUDRJcjJmVkRHQTNu?=
 =?utf-8?B?Wjh5MlpwR3RqcTZUN1o3RldaUDZJaWlJSkl0K2cwRkxHQnJlckR3U3YxbjQ1?=
 =?utf-8?B?dzhwVHRCWERLaHZXdEhUUlR1VkFuYzFweFh6bVFhVDBnQW4vV0xMc1J6YVFR?=
 =?utf-8?B?TitQVVJaeWU3UWh3bWdkamd2bTcyRzh6czFmY2VLMnVRa3BaTVhiSGFIcHFL?=
 =?utf-8?B?Q0VGVlBzOThYM3BsS1N1US9qVzVTL3BnRFFuSXVSTTdGMWludm10OUtvblRT?=
 =?utf-8?B?RlJBN3BkaFZJakxCdXN0aTBoQy9kQk5BUTNidU54aS9GUUNiQ2JrR3NmSk55?=
 =?utf-8?B?U29oSnc1c1N0TTRrMDhJVjdqNGh0YktjYWdldXZOYVpFM3l4U3pTN1lwZXA4?=
 =?utf-8?B?M3R5azMzaHhrQ2VveHBJTi9xeEwyVGhsVjZ2Qkl1MWhmYzgvUXg2bVVDbUh0?=
 =?utf-8?B?ZWkvZGFHZGJJYzBnNTUwWDRMeVhCbWpUZGdJRUplQitOSU00QTYrOS9aaDVC?=
 =?utf-8?B?L0NES0xZSEtHdFZqTTRHN1ZsUE1zYzE2STM3cXpZZTVzMlhKUWVpUGZlTXFh?=
 =?utf-8?B?NEswWlR5NUpyV0syby9sWExualA0LzR1ZHhrUWtXT21uSHdCeit6MkRPZXVF?=
 =?utf-8?B?SG40NW5qQno2RjhlaUFqVzlLaDg5RlNaVlVxUU92MnF6MUVIWXowQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C94D00435A305F4995428419DDB68377@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	hdUW9cBB74D5LJHhpj8pXct+5G2QX4za4vo4Jgies2jbvNwK5AxhyJmAK4eG9fM7VbNAx7S/gLrAdBfnGpvd/RLU9LvD8d0Y4Xc0R8+CR5pmp9qKkuJWEZ9AalxIl3nMM8eXKUXSSB5UPCzcGiPIn92LptmCaTG8HaYPrBjKmy3971uiNVY1vKU+h6lTRevi88A8eHuSoaRhg0tVFT+rMJOOyxUKGJskRibrDeJpdFol5fFR13t/hRuWNySx0FSg2Wy2VypzUVX0HeFVRfWO2hxLKVPw+68+a9BIZilJ00WZn+7EZXmN/7efM1iQgrfbK3YEy0I8z4jg3mPRMcNsiw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FxUXQv9EZgvJq0Yy17WherfJQtVO8udp7tNyde82IYOgS8fIIOy+eigeNQb/x/Wl1tTtZ752U/vMlKReW7PFBi8qZpUoSXBvp4NFpd3s0+dvMBCK2noLxGZP4TMZLVppifMqjqI1JPwEv9pEHk+U0wteM0piEHDonjQ6RjVrlcsIIqKtBreT5f56eSLZwcPNcDWhQZdqCWzngzlsHit3yTJHefYUML+RBx5kvr2tXeoZTgSNZAM0GLs/S/srtSnCtaqmBmBYblhqqSVJw3tfuoh5surGWSEjEyDMbjvACVLChYdTYBUuYKIiLSt0R/UGYlrT/sBa0F1UYv0psbXB0hcDqfCPVUMXYycv4ha9gYVgoIgCD3Vi1uY6T48JVZATb0l4F1LdkzNUaRuPiPV1gF4PtqNH+7Cl2VF8hflC7g27ik5QOceQyEvw/pvMgSZAXoNqsoE6/FiW6d/IdYhAyivVXGlrs1Slk+44ryHLBuA9kzJfZ5SzQ5J/6wSomero3nWvFbnE23X3e9sbKbc+y1sjMdBUFOoLMlyto4V7PxezoD7X7Uh3Bi1/u6Mn2q8LV5lh+1/yhe+IH9WOXNFvB/jtmNejU7JQx0O5V5+1wOZj64sD+1klptVQKP2rWxBJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4324669-d96b-41e7-c711-08de841fbf86
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 12:21:41.8775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z93dYowLjhBkQfGTaXrGVT0o9F4txcSfy5cuDr0IA9/audz8dCV/m2dSHUggj2Zeea7cKK7mX+EYsmhJZbEXew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7649

T24gMTYvMDMvMjAyNiAxMjo0NiwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+IE1vZGlmeSB4ZnNf
em9uZWRfc2hvd19zdGF0cygpIHRvIGFkZCB0byB0aGUgaW5mb3JtYXRpb24gZGlzcGxheWVkIHdp
dGgNCj4gL3Byb2Mvc2VsZi9tb3VudHN0YXRzIHRoZSB0b3RhbCBudW1iZXIgb2Ygem9uZXMgKFJU
IGdyb3VwcykgYW5kIHRoZQ0KPiBudW1iZXIgb2Ygb3BlbiB6b25lcyB0b2dldGhlciB3aXRoIHRo
ZSBtYXhpbXVtIG51bWJlciBvZiBvcGVuIHpvbmVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGFt
aWVuIExlIE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pv
bmVfaW5mby5jIHwgNyArKysrKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2luZm8u
YyBiL2ZzL3hmcy94ZnNfem9uZV9pbmZvLmMNCj4gaW5kZXggNTNlYWJiYzMzMzRjLi5hMmFmNDQw
MTE2NTQgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9pbmZvLmMNCj4gKysrIGIvZnMv
eGZzL3hmc196b25lX2luZm8uYw0KPiBAQCAtOTAsOSArOTAsMTQgQEAgeGZzX3pvbmVkX3Nob3df
c3RhdHMoDQo+ICAJc2VxX3ByaW50ZihtLCAiXHRSVCBHQyByZXF1aXJlZDogJWRcbiIsDQo+ICAJ
CXhmc196b25lZF9uZWVkX2djKG1wKSk7DQo+ICANCj4gKwlzZXFfcHJpbnRmKG0sICJcdHRvdGFs
IG51bWJlciBvZiB6b25lczogJXVcbiIsDQo+ICsJCW1wLT5tX3NiLnNiX3JnY291bnQpOw0KPiAg
CXNlcV9wcmludGYobSwgIlx0ZnJlZSB6b25lczogJWRcbiIsIGF0b21pY19yZWFkKCZ6aS0+emlf
bnJfZnJlZV96b25lcykpOw0KPiAtCXNlcV9wdXRzKG0sICJcdG9wZW4gem9uZXM6XG4iKTsNCj4g
Kw0KPiAgCXNwaW5fbG9jaygmemktPnppX29wZW5fem9uZXNfbG9jayk7DQo+ICsJc2VxX3ByaW50
ZihtLCAiXHRudW1iZXIgb2Ygb3BlbiB6b25lczogJXUgLyAldVxuIiwNCj4gKwkJemktPnppX25y
X29wZW5fem9uZXMsIG1wLT5tX21heF9vcGVuX3pvbmVzKTsNCj4gKwlzZXFfcHV0cyhtLCAiXHRv
cGVuIHpvbmVzOlxuIik7DQo+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeShveiwgJnppLT56aV9vcGVu
X3pvbmVzLCBvel9lbnRyeSkNCj4gIAkJeGZzX3Nob3dfb3Blbl96b25lKG0sIG96KTsNCj4gIAlp
ZiAoemktPnppX29wZW5fZ2Nfem9uZSkgew0KDQpBd2Vzb21lLCBpJ3ZlIGJlZW4gd2FudGluZyB0
byBoYXZlIHRoZSBjdXJyZW50IG51bWJlciBvZiBvcGVuIHpvbmVzDQphcyBwYXJ0IG9mIHRoZXNl
IHN0YXRzIGZvciBhIHdoaWxlIDopDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5z
LmhvbG1iZXJnQHdkYy5jb20+DQo=
