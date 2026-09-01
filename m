Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E933264D9
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252403; cv=fail; b=RIGSuPUfH5FbLMEUFYe9impdgKSGMiAoTMCPvn9B/4SznmKtElKyN0u2WWiW0OFf4iL4Vpzdh5OQhPWzFwLX/wOn+T8wUOjxy2ve9WDqJ8MG9Ujc34EQITXRF31jElX2NY7GmopJXfGO+Xcp6HcXKOXQz8zVNncIhPvEx62yADM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252403; c=relaxed/simple;
	bh=ll3NL3uFZUzG0YdJ4TaHI02Ah9ifR3+FuPZdcumE/iE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DkNw8UXwPaKMlP8okdU9CqxVOPtsjp2jx0d5bcY7RE4VhpvxCGr8+Vmh+eWnIQt96Pf+ciD/CT5NV3bc/qm+jiweVTfjHzb2Ajaw6/KGBNwAAazBO1Th0PPFcF0k2d3cL6OlyUx4q3Y1Od3flFu3A9H4ksIXEoMRQGe1ccREsaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ccp9gbY1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=henzSbw5; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ccp9gbY1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="henzSbw5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788252401; x=1819788401;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ll3NL3uFZUzG0YdJ4TaHI02Ah9ifR3+FuPZdcumE/iE=;
  b=ccp9gbY1i7Lpha+sc3bZSu3tiyLIO4faKFZUWEWKqMH+uE21tO590aTU
   g5pevJACbPOjCP8JwULqK4uWdsjBhXbye9X+wf4HW8ev1S97BaKrxJoUS
   rHup2vAPETXoSu0EaHZ/qBQsY6Rdfm5cVWv7uILD7vGPxzyAeDEOTgU+/
   W1SNSMvCv+XOSOn/ptU/ccaA+LGU6v4hO7MKq+IT9wUdo0aAusmuFNsij
   TJxUqdB8kV26pb8QYo19EQQTrAOtLim3BP9sAQGoA5nRzT0h1gzjkJunJ
   4pqGaWpjjdEq1jRHdxNpj2HPKGBFbek8yWlGtno4gpaKjR6trUNjSFyt1
   A==;
X-CSE-ConnectionGUID: RJwg6Pd/QomgQFHRv1oKSg==
X-CSE-MsgGUID: R0d9Yj3mQzOVt16uvNSpmQ==
X-IronPort-AV: E=Sophos;i="6.25,255,1779120000"; 
   d="scan'208";a="150483413"
Received: from mail-westus2azon11010025.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.25])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Sep 2026 16:46:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdiE4VVqTKkdBgyO+U6W7wQ8LfFVVVCHhRFxmItT4GpKar2q0KjqY7ZrfZx7gqvxYukCz/k8IlLwNU1k65bL32kbjTNj2NJeyHPzov9KB8VWuz7rMyIdDNn2+MywHy1gcF/YT0sjnRx1UYJ1r6wG7zKWZy54C7nRcMk+e8SCNHGdfhYHQWxCD+1bXPHKpGp6Eavejh9gQOWz4axfSWbWqBAJ3ihIzi3GOPF5Pb0gSP0oggZZ6POTLwAUEkjLewEYCu9ScvY+nYPaSdKqvAWEUPlznjWa54Q6WqLfXNgsYvBTm/LdBIlIrv2WCVkAQM6aaWE16dDNyXq2LCKHZdEr4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xYJ7VInNW5Vcq24kFO2hDES/P/SvQ5spByalUW2cPs=;
 b=vwdk6QHllKORGsY0rUCyRz5XNt6WSs0Jon9dMuaBUxibo/kvZeyzdWMjJMQWYf3++A7wVKEDzl+vBls5nLozeLhh7Lmut9jtBPQNJpReLfrGGwLjOw+Co1midOHXuo6pa1R9YJs7WStUoPfRyIlBHi1KasmSjIyP47RADyn2tax5iOb8xRWvVk/6vzC3MdEtzh3tSmNdulj7DLlNIGUvUo5c3szSEXEPlTO3SJ9TDKDOC5hYjqs2LUU6s9D28T2hctgACZ3NGCsv4SLudBaio9jrxqEb0U6x1PuYer8mN/M/zhGKl9zg8kfi4wgD0RcLOhkp9UZZ7j0dhQsU1nAKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xYJ7VInNW5Vcq24kFO2hDES/P/SvQ5spByalUW2cPs=;
 b=henzSbw5cZQ+VxRYn1n3AQdW24HXUi+8IdDPyo8ojcyzd/nFd9uf2rnMYm1a3Ro2JtFSmU0h5AjEK+XNUXkyfvcl1A7m/ekKqQ64k5PvMx78owNV75l+LMgIfFAVRwTzq6j6Eo7nIy9DOA3NllB7Xt8hqD0j0a8QtjdfwR2mrvs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by DSVPR04MB993550.namprd04.prod.outlook.com (2603:10b6:8:421::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 08:46:31 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 08:46:31 +0000
Message-ID: <32e910c2-28b1-4df5-99aa-8bf13801ca1e@wdc.com>
Date: Tue, 1 Sep 2026 10:46:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libxfs: report device open errors during topology probing
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
 djwong@kernel.org
References: <20260827112855.70037-1-hans.holmberg@wdc.com>
 <20260831071039.GA25070@lst.de>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20260831071039.GA25070@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CPCP307CA0003.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380::12)
 To SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|DSVPR04MB993550:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c2ad678-326e-420c-69f1-08df0805854c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|19092799006|376014|10067099003|22082099003|18002099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	mebaCVzP6H04U4bnOkLMkCtOogcjLjdj/3IFrK0HHvRjlm/Xqe37rbPnhV0Mo04UeUj2w9fdtIDVYaaVZoklMJlPhkrW4+KkQ/Z/cTrSu/7vvIv/7C1w6pWvwD/IvatLptYxz807WFJ1lNO3zkmOkInExVuVWiqCmsuiWiUOu0ovUWG5WSxWKVBhk85Cntu7q9irO//Be3wp2T9abUMtRcpKT8EqTn5K3pU6CbxEHrJ3QJgpNoYt3M233wPN8NVw1wOphBHaA38W+U4apFmDyi0bVgXF2b3/STzcRts5DjRj7VQudpYexzPx2e7uHeRmjmJmEMDGxQVL4Uc9pI9V8SLPb2B9/YuZoXXKFjgyMG3GqtRP6bN2Iz9XO8vFL/KuZWpYT1fR9eT7QbWdTclFgc0GrPugpDxe+nm4FIc72GgY6C/hMgCZt4pGj9BGsyFjYIgRDmHOTiM4NIWVyLELOASwZ9pY0h8Pytjdk7DTkdws7RKjL+Tm5NghdgogwRVs2x8ZyZ2UVwlbeoZcv0VeC5of5/0WtMKaOOQDlvE9M+vcpQLmDf8W3VeGNkMSKgryEE8rhx/pu8rcDc5P+OWyNQ9q4jgFbkZaTc7hu9J9fEW+mxoXBeMT7CrvxERCFvOgRGBrp5gjCh0HIjiBqVw7zA833cNwRYfEeX2q00qWSlA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(19092799006)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDYyb3YzK2Z0TUM2NThjOWd3UDRpeTdkREFHb1BnUHZGRDBUOFc5akNKSUQw?=
 =?utf-8?B?cHBXelkwcE5zK2lpMDJuUzRDM0VQR0RGVWNJRFI1LzZGamdrYTcyZUU0YjlB?=
 =?utf-8?B?ekdyUzZVeXNZbHRBWHZMWUN2TW1EV1hHT3Vtc2s0MlRKeW8zTll1VVNDcnZE?=
 =?utf-8?B?TmNQZEpjaXBZaVQwMURIMmR0ejRoYXZZdDdxSStPaXpIb3lNa1hiRFRKQXlq?=
 =?utf-8?B?bkp5akVFUjJYK2hGUE03UjVIM3gwMEh6RC9Ya0ZSdEQ1YS9XTXdLZnRIK2lp?=
 =?utf-8?B?WVhrOWF2WTlrblNHY3dBN3gwdE5zNDJpNDJMczc2RDBVSFpqVGRDdnRWSnpG?=
 =?utf-8?B?amVRT2VyZ1ZBeTJNYW0zNS9oVVRyeUNZcEVHa2YwbERKNTlKRkxZRDNDc0pR?=
 =?utf-8?B?YmFIc0lSWUcvVTdxTnRpZTZOclBHVHpxWWJaY09od0g1dlFUMjM5OS9ESFZJ?=
 =?utf-8?B?bU1uVUVOQ1ZoeDZnZlE5OXdhRkl3NmNJdVRudjZ5NEd2REI4Wk1mOUVYdFR4?=
 =?utf-8?B?Wjh3cGxmaENHQm1RSzc0QzdpMEdBVDVqcWl3T09uK1VQWFh2TEEvSll6K1J0?=
 =?utf-8?B?aUxGbS9OaHA3ZkxyVGt5cHliMGR4VVJueHlZT0RQTmdLREJPL1RyNjZwaXo2?=
 =?utf-8?B?UTFxNGdPczhadTJEbU1kTitHS0xyTjA1MFR0RjRQZ0lGMzZvZ3FidFdkMy95?=
 =?utf-8?B?UGVLS1V1enZicVNlVk9USHltMDFsYkxtN3p3NUdyR0RDc24veEJma2JsUHpE?=
 =?utf-8?B?NHZmUFk0N2RGdzNtVSszNE1KQUdFWExKLzNWTVhKQkxFRG1KWVYrSEE1RVJP?=
 =?utf-8?B?Tm9lSGNFSC84NXpTMmNhdEc5OXdjTzIvRUY5MmJ5bnNrZm4zVUgwSU03bEti?=
 =?utf-8?B?bzJmYUpCU1dvNkFCVHU0MVlvbWhWczFlUk9LYTZyajRSelZ0R0ptenY4V2VH?=
 =?utf-8?B?UlI5M2JoYWg5YjYrNEp1Qy9JeHFoTHB0NTJycGFodzdBN2FjUUtWUzMrZ1Bh?=
 =?utf-8?B?ZEZ6ZkRYV2xlMWdkclZCUS8xYWQyQk5GeW9lcXZGT3UzMGFkMkNYWWZacWVC?=
 =?utf-8?B?NXo3VWdKOEJFSUxnVVg1Q2ZMc3IyczMyM3lnYWIxd09KanFHQnJXZzcrYjJR?=
 =?utf-8?B?eE81ZVVleVRrMmJhWFptZXp5OGcvSE9rWFhzU0RUbTNZVjVmNWZpQ0FwUmdv?=
 =?utf-8?B?Y2ZJUU1lc1V0VjdNaEJTdVU3YWtrYXBJd2l6V2lkN3gyMXVnRUI5VFRYN1pF?=
 =?utf-8?B?cytHb3VyMDlsbWV3RElKMzVPK0wreWZYaVRhckdRK2xJeDJQSzdDK2ltQXZK?=
 =?utf-8?B?ajVNcDA2Mlh4OWJHMjRGUVR6RUZYQzBULzZWMG9QWFBscnF4TkdrSTZDM3Bi?=
 =?utf-8?B?SEZUY3A1OVhEWFZqRTU3NUFSc3AzMHpOQ3NrcmZWNWI0NjZzbjRSUUU5dHVj?=
 =?utf-8?B?Q0ZHQWZETHA0UHlIMlptYndac2lUTjVKU0twdUM4U2NrSXdQclVMdExFVk5r?=
 =?utf-8?B?OVlkN0E3ZFhQb1ZpcVFRaVN2RnpmSTRPY0tTcjNxeXBwOGJnMVBQK1B2emJz?=
 =?utf-8?B?SE9KV09NWlFMSG00TnUxblFaR2JtVHlZRmV1MjJxKzN6V0d0UlBUL20xd3o0?=
 =?utf-8?B?NmZGRERhcU4xa00xYXl1UGNmOFU0c3NMZlFuOHZ1emtlL1dYcUxwMjM2NHZN?=
 =?utf-8?B?L2c4cVZCUWV2NUtML1RlQ0tYU0I2V3JNaXB5MjFDT1NOKzBrRDhZRnJCaHB0?=
 =?utf-8?B?aGx3dG1vZmJ6OXI1cnhZcTQ1V0NWbng3RVFzaE9JSmRiV0xxSG9JOGV1N1NI?=
 =?utf-8?B?ZnhTQ2hYN1NyN2Y1cXRmRHBGRnZwcmFhTStOQVpoenFlb1N6bnpHcWI2alFl?=
 =?utf-8?B?d1h1SmluclhObER5YU5LMGlnK2I3ZzVJZHFId3UyZDhoUkp3TWo1SFlqU3lm?=
 =?utf-8?B?Z3BHbVdUQXZUWC9tWUdpb09wN0RvYngyZTJYeEtESVZYV3dHd3VlM3lIYXRD?=
 =?utf-8?B?aEEySWtPejU0aVR4ckVZOE9BZEpOZ1dTMEUrOEgxNnFhUFVvNEtzeG0xYVRX?=
 =?utf-8?B?WVRSd2pGOVdqSERINGRwNjZIZTVHcnBEOFJxM2FjdXg0MEt5WTkyVUdrYTcy?=
 =?utf-8?B?WjFxWW1KUWFBYXVtcnBsWlY0d21oQjlxZ242MjJpOUZwWUQvSmUwNHFnM3lw?=
 =?utf-8?B?cnBqdHpLOE5na0I4QUZLWEIwN3psTWVQUnhTN1BZSThRc2MydzVEV0NjMk1D?=
 =?utf-8?B?TnRNSWhmZjNTZVpvbFVtTEI1OUw3SjFsNWI0Sm10QTQ2ZGN1QmNGcld3R1ZB?=
 =?utf-8?B?aWdRM05oNEExMHcwME5vV2o1M1BNRVR3L0ZUZnNQSmZSUHN5cTREUT09?=
X-Exchange-RoutingPolicyChecked:
	BOrg+hFn6wOpQ9lHQsGjxFZb8IQ+pavwD/s9MGKX97Kj1iqY8d/x5kTxeB+fOhdBB8AKoKy4CEs4qWY2T8JB1GvNzdKTFToa64X4fiLlnWwiaxgIdzQSwDCHn1lak5ogdYFWfmHOiUyUi0whNGUrMxCP5EytT5hK5F0EShJ2oJWZbM5kLiz7AhgKVB48VxzRrW9JY9XDDGaOTYuS6bH14xw80URI8dy9mQbbuiMzKvcCt3GQXcvFxGArVotWdl5HPcC3m+rLRikL1UddH1ptHkqJxWjUfVU9mMyY55FQlvVrro2zphbnUY7HP8oj7MPDZawU54LION/4VLN8USB8rQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i/xKRN9jL1oMMCS2zfAmifscm3EJqZxgMswIvX59JK9KklFMyPmnTtHjM0JazLEEa63sFpurDdjzmIJOhFCmFM6iii0jGeoEEiIn2bWPFex4sXESaH9WtBAX974Cq8FbrGm52a8SRWcO3HQ5eEfA3VPlgKDzJWyHf/85zGGhR16cwWo6frzx11YpDkbcJ+vAVd2vDgp5rpchiBmrijhG0hh15b+kk+WCbWd/q6aCo9v0vAbyOtTKzKNvTxDj+y6hBt/gcs9sxs8PSDVQEZNzxSiJsgDr0dXKhgF16++MHAO12wkxEuQ4a7PalphCoEA8IV/jLvNc7Oe/f0FXjGBqk9E3UBPxQ132qUfRRnuE/XWLYDN24ESCfTlbT0FqIjtu1m5oTp3jaVHWT+QBg0Yj02rDVxs6r2ewFZmgJTaYyP1c9WH/YqHD22ebcJJLIzU+G+9pKAVzPYUn+wOtMALFNN2X/3ygwHp2UTurHBaA4tasLLVjH5pBdvCWTL34VCLWbqmq1IBOrqCtVx7QpPO0jZoTDedhUSbB2Qa5c19ZiNaW9htzadx2YWycBCyVHeckVCkpoauDruIdvhl9Lg9FixXhhVJOxjVwqMJodg7n71ih5DZyxhACNOliRzkD7wqd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2ad678-326e-420c-69f1-08df0805854c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 08:46:31.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48xU7lClMSQecmH8SYqMmtU/3zkyBDZrBmCV9e65ucbV+h2ZMgQJjkTucw8G2yqN2h78l2UU+SqsENhKBDdTLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR04MB993550

On 31/08/2026 09:10, Christoph Hellwig wrote:
> On Thu, Aug 27, 2026 at 01:28:55PM +0200, Hans Holmberg wrote:
>> mkfs probes the device topology before libxfs_init opens the target.
>> If blkid cannot open the device, blkid_new_probe_from_filename returns
>> NULL and leaves the topology sector sizes initialized to zero.  This
>> causes mkfs to report the misleading error "illegal sector size 0".
>>
>> Report the underlying open error immediately so that permission
>> failures are diagnosed correctly. For example:
>>
>> cannot probe device topology for device /dev/nvme1n1: Permission denied
> 
> Did you also accidentally run mkfs as a regular users? :)  That's how
> I ran into this, but didn't get around fixing it.

Yeah, I do this all the time and became so annoyed with the wierd error
message i had to fix it :)

> 
>>
>> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
>> ---
>>  libxfs/topology.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/libxfs/topology.c b/libxfs/topology.c
>> index dc2aaa17..5571c9d8 100644
>> --- a/libxfs/topology.c
>> +++ b/libxfs/topology.c
>> @@ -230,8 +230,12 @@ blkid_get_topology(
>>  	blkid_probe pr;
>>  
>>  	pr = blkid_new_probe_from_filename(device);
>> -	if (!pr)
>> -		return;
>> +	if (!pr) {
>> +		fprintf(stderr,
>> +			_("cannot probe device topology for device %s: %s\n"),
>> +			device, strerror(errno));
>> +		exit(EXIT_FAILURE);
>> +	}
> 
> I wonder if there are any valid failures from blkid_new_probe_from_filename
> where we'd want to continue?  Probably not as it doesn't really have an
> obvious failure path, but so far we continue here.  So the print is useful
> for sure, but I wonder if failing here might cause regressions in some
> really odd use case (containers without sysfs?  Although we'd run into
> trouble with that quickly in other places).


Yeah, it might be safer to just print the warning, and that would solve
my problem (no instructive error message),

On the other hand it's nice to fail early - but not if it causes regressions
of course.



