Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793792441;
	b=BHbvSPfJmXhvjOzKZjze3xOctemN5eTBAIzfjE7de/+bf+wh5DKCvBsdwcCMveK856pZ
	 ZMEahXLJaeEBNmm04hdbz9ryAzGabfEjE5ckmvi+9Sax3dM0Ft4MEiah3UH6Dk6Lqfo9j
	 t52a4GIk1nub3Bb52b0BW3L4DvhCG5MWR5KC24MgP855I4UlwqQHvi1p2fN6XMsVSIVax
	 TVtGpOMAZxaexXpsZekVBwgLcOu5b0QLcyfh2p+ibFSt606By8WRsJymDEqX1wfJCCv01
	 DnFCGcLVoeOiH0b7nsfOXXPtCxfhwQNm5RfDR/a3tGFpFM0dagaYB5bl1GaB6qvOwFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792441;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BnvOFkBCkDW03T+zD8oylM4RkLEu3urRPTsDjGZ7wbw=;
	b=ZpFsHjgcXqdYXG1u6XbZKnoPzzm7AiAImuDIy+NpFTydzKM7LW2HQMfiD0WVA6FyyVu6
	 H1H0H0Rje+8IbkS42JV8Dip6peVyNdGJ8arb4ljh5Nnq/PRmYi0MjFThzhi4P1tXyaxGs
	 mvu60SrtMGjK7+Xj3hw6s5267NBkg2sYL6eBwVnJInD7mke7QmwKD1AtvRoA9rXrfwevq
	 wXNdxBqOzGP0q24GH5h9LBTIQnl7DrlXPJgFdxWMnBB9J41RIt7GS0OtSQ8Jf6Bw13aJ9
	 cauq0LvSuVt7bshrcEy3ojTMyJi+kYu6SRdYU84lqG1Rz5YdQal2UIHbvvTa6ws+WFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bVHPsG8e;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ht63ZRZV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71066606A330;
	Wed,  4 Nov 2026 11:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71066606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=bVHPsG8e;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=ht63ZRZV
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1793792440; x=1825328440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DaHuEQ/ZVJWMXT2KtthoHVof9zCx3/7uwR44FGja+ts=;
  b=bVHPsG8erpsz1pA4SY3wq2cIzHJsAMpZC6Vy8maeFzkMJhfo/T9jrycJ
   dQGbWnn9GljFHDtoPXJ5Nhj2zZTCKbPW885AXX7fj9Go3Pv4jxKvcWtGz
   9+RK9GnWKQzGDxh5O2Kqv+JruxWdX4d+O+JTFk00rswCgJxvu7A9ZHk8b
   CLRUuVcLdZMsDuxlyB781KeJugZzRhVBiVyciuig/0uU8V5zF/56jM4u5
   RlKOdYCiwnOc8iqlQ7p8kxTzh/6hWyIx0awZ+CeAEASBS0zDYhw9xeUp/
   yRT44LKh4tiedFL+uiFNa+OdQocdnR+yIIzAg/8ZkqU/X5DKifDLB3vz+
   A==;
X-CSE-ConnectionGUID: QWFkaSizQHGz/o8tSse1Ug==
X-CSE-MsgGUID: ScR8YteGRf++eEYfbrO2Zg==
X-IronPort-AV: E=Sophos;i="6.27,195,1786982400"; 
   d="scan'208";a="158830304"
Received: from mail-centralusazon11010052.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Nov 2026 19:40:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRjxQWvexyu5qixQv8X8s/cWiM+rAUPkrhHI78Kb5Y99iok++ItU5O8oxLyyhOERCTlKDiuWzjMhBH4BBVKGx5N333viLE3vjvZJta4vKju+dUhWM7tqEJkaoh3nBH2BgMkvOcH6+ErjX10prERNrhLkVhRiQTlPcxB6AJfIkL21S0lHjbouM1OeB7VKjL2mgjSqYbH/Kg/e5oR10JfRdOmiU2FHqVyN7dqckGuf2uGb+1FzKtTjJatvGN9T9LnjRtsjKPwWmf6/el8x01spo6hx6nGcDZaoHFe+KWjH2QrLLJ/+9vH++SmIuHEFxO1P8IxPsM+D3VpBhsp4pex0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnvOFkBCkDW03T+zD8oylM4RkLEu3urRPTsDjGZ7wbw=;
 b=eQZoWCmRbA07IYHrXrHn6Nbd/w1/G2FVZyEy8F94+bskPCZ5vn13TnyPBHQCUG1sHbdqOAV8JikPsaKNndYWZZuxWF5Jc/OpZrDL9qi6u2wmAmzImDolQNmnZ683lDzumsYJmNGwegk8R0NobmZ1pMIK+/Vx8bgJqW2sI7gKi5elC9apeOgQ/TrW+bDuddRRjpGJ2VdBHYpmgU3vsOwcr7ZfUj+QdJsIVOBR487YsKLvMTCTjlVgXlP+P0Zyn0e+Ul9QJR1CFhMBfGnNMKT9RGI9HGl+TIuccnPauurFtSQvRXLfyPJOwXpFi1eyDPr65QkJY9JKbgaKyYHEF+YhvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnvOFkBCkDW03T+zD8oylM4RkLEu3urRPTsDjGZ7wbw=;
 b=ht63ZRZVRE6SgoeR+o08Hf5Bsf3AiCbIDEayv94BlsYhlmS1+iC9D2pQXK2FS59z14xLveJFcQh+wfvr5Ff+zCib1L4FB2SfZU/K0LlrS3oK2jPFW8m9IhNaYwKmLFIpyvuUbnB+5iH7xZ9uWKE8Dmcc1dr/guggYtgjGUQYcNY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by LV4PPF16345CD97.namprd04.prod.outlook.com (2603:10b6:40f:fc02::904) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 11:40:12 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 11:40:12 +0000
Message-ID: <2003152d-5d33-424a-8191-badbe137e37c@wdc.com>
Date: Wed, 4 Nov 2026 12:40:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/8] xfs write streams
To: Anuj Gupta <anuj20.g@samsung.com>, brauner@kernel.org, hch@lst.de,
 djwong@kernel.org, dgc@kernel.org, cem@kernel.org, jack@suse.cz,
 axboe@kernel.dk, kbusch@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 gost.dev@samsung.com
References: <CGME20261103111022epcas5p4df6a10b70dd9a92992c117669c7227fc@epcas5p4.samsung.com>
 <20261103110640.1000095-1-anuj20.g@samsung.com>
Content-Language: en-US
From: Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20261103110640.1000095-1-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR05CA0233.eurprd05.prod.outlook.com
 (2603:10a6:20b:494::27) To SA6PR04MB9269.namprd04.prod.outlook.com
 (2603:10b6:806:417::19)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9269:EE_|LV4PPF16345CD97:EE_
X-MS-Office365-Filtering-Correlation-Id: 271fe06e-336a-4f93-19c3-08df3a68634d
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|7416014|23010399003|1800799024|10067099003|22082099003|18002099003|17002099007|4143699003|56012099006|5023799004|11063799006|261026140227099003|261022105027099003|261022113327099003|261028144727099003|261022075727099003|261026121527099003|261021121427099003|261009221227099003|261009223027099003|261021123027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	X+P/oIF2Nk5DQIWiiiRSEpw236jmJFLfiljXpfK4MFNtrW4VU0MPgug0hWfC0rxNwo8OHoL9Jf6D+cAKIUxEBWz0SEaSstjsEba/9KYCrRbYxrSoWGUPiKSh0qtxLoclMbSA4UT73g6LbudlmmlP5Sa4zP6rEdLWUg5gA4u/9R0sCbX0ABuDSVHT72XKiVruicavu/BRgB/XJw3aQrVATjbtn3qa3lKFxprqjvRqIMIME9reM+S7hLSO3+0bxGYKu+xRWQuB5StpyyAjZ0ZYkpFyAXXMqQYFrrSwkQg8wYenWPmpBgAYQWxTmlB6HmzwRb6sAEz3/GnoK5SLnbXhSFRq2PNZOHdfEXmUyyuWgPEwX1IYd3I7QLbRotaNTN0LfvFBw05940jKkV62gcik2r4C/E/N7AZfTwIEoT3rszdbTBq8N0WN31wVI2I+hSmOdVGL8uO6xvAuh8jNawANrgbMwQgVtk+NUj8SG5KZgFk6qQaxP6EglgfnB0+2CwChD4Q5WyzFd76xENcrUvvyKLX/dgDxhNS1wFgbktQz9bR6oRVdCgk8DsS/zM4IwHAOXQ+2qk9bG43Uvka+h7NCyDSrINSq1Dicnu796Hrnx3cPh4W9UAjWfqh4tcgCANKZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(17002099007)(4143699003)(56012099006)(5023799004)(11063799006)(261026140227099003)(261022105027099003)(261022113327099003)(261028144727099003)(261022075727099003)(261026121527099003)(261021121427099003)(261009221227099003)(261009223027099003)(261021123027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?REdPWGVBWDF5N3hYQ2prcUJ3QXhPcVN2SWpRNzE1SVJ5bkVJOGpMZ2NaNDdZ?=
 =?utf-8?B?ZEVkVXRrcVJjVFdOY0Z1cFpzbVNSYVpJekxkSlE3MWFUUXhZejVLQmFXM3JP?=
 =?utf-8?B?V09LMVR2YmtxWjNtazBCbEE0Vjkzb0ZndS85L0tmMHNOY05MQmM0azM1c2Nl?=
 =?utf-8?B?eDNKajhyNVN3Q09tamN0RDE1RWRtc2pBOTJ6U244SThjaDROM1lZRlNOL0Y2?=
 =?utf-8?B?cVdra0FjOFlCNlZEcGdBWTFpMXQ2UEo0QklXZk05QVA5cHhEWEwxZE1tb3dS?=
 =?utf-8?B?WDVPaXgvUkNLclUvOHhmS1A4UUFpc3luVVd6MVFNQlE0Zm8rWVcxVnNud1N3?=
 =?utf-8?B?SWdLekNTUVNNalRVV0tVZHE2WWNmN2svNi9PTUEwS2pFTEZpbkR1Vkkxb0pX?=
 =?utf-8?B?L1FoeDI4T1lHcFNSY0EyWXZCZVhraVdiT3lqaW42ZDlBdXpFcy9BUUo0UGpp?=
 =?utf-8?B?SzVSaGxTR1h2dFJGVWorK05STWl3QVRPV3Z6SXlqcG9NOGJ5ekFBYXJ3T0kz?=
 =?utf-8?B?SGNTTmN1MjRtWVNxYnNmeTBXc2ZXV1I4NjhOQXFBQnIrYVcrQU1EWlg1ZHZT?=
 =?utf-8?B?a3A4S0lsYkpwU1lJSXJyMUZMTmJXWWRqYkgzT3oxckVySEJOMkozM3crb3A0?=
 =?utf-8?B?TlhRLzA3dzVhT3NsUTZJQTBWelMybXZKMFJIcUd0ZlZWUkFjSXo2U1crTEhK?=
 =?utf-8?B?QXhZaEdpV3pjM3dFK3hRTVVzZGxFeW1zSWRaWnFIaEI5L2RhNkxzSTZvNlJF?=
 =?utf-8?B?ZE1FVUhWYTV5TGc2SC9ZWHMxMndjUGhtei9Ec1dYWkJyb1QxMFJEN0xPM1RG?=
 =?utf-8?B?SVAzWEp0U3VoSTcyVzJxTk5mdk5qd3BmU09EcHVHaXJWODhOK2RLallYUjFl?=
 =?utf-8?B?YVY3TlNEQmtZUDFHWWNsMi9reVlPU1hXOFdvZWFtSEdyZ0RuOHVCQVJxMXc4?=
 =?utf-8?B?SmVOVWY4YXl3RXQ2RWtmTy82eWxZSGJKK0YrMktiQUtLRld2UkxDQjc1TEg2?=
 =?utf-8?B?NWFac0tCajRTQ2lUeHJSQ1g2UWVPQTk1RmQ0U2liODYvaDRGZjVERC9XdXdu?=
 =?utf-8?B?ZmpiT1NXS1BVOVJmLzN3ZEZ4MktHWmtXL1dmeXkrcXlFVUhPamd1MG1WSzkw?=
 =?utf-8?B?V0xjMTdVd1p3d2dRVmVEQlBMM0czY2lXQnVJMmpRVzZhbTN6R0xHY2hHaVZa?=
 =?utf-8?B?YWYranptSDZsY3pBOWVrNnhWUXlKbER5YmUzMUthbjRhM2g0MWJMQjVBbDVZ?=
 =?utf-8?B?UEJvK014ajJkN0U0V3VZM2JYTFplYjB6UXZDQXFKTndVeC9PeUhTSTRPZ01O?=
 =?utf-8?B?OVgrSTNFSFNlc2ZWNUJTWmt0UENxc2hBRkc2NS9pZjAxWXFKTEhVOGtnVGkv?=
 =?utf-8?B?SGdMVkZ6WWR5dHZDY0tyN2lHNEE3WkJiaUUyK2x3RVBITmQxRG4yT1l5LzMv?=
 =?utf-8?B?R0dseWl5cms2WEFxc2hxbVBRQmZMUU9TVGR2R3NxZFhEaUhiMWw5Q296d1h6?=
 =?utf-8?B?YjBlZzRhM2RMSWhzSk1GTlpLUzdPZWZwTlJUdk4wM2tyWWowbkJFZTN6R1Zp?=
 =?utf-8?B?TVg2RjR2cGU2S3dqek1rSTI1all1NGMyaDN5UXl6YzlHU3BOZ0M5VkEvbVMx?=
 =?utf-8?B?MkVKMGJ6dVhEUU9yQUlxWlozZldjL3NxVkQ2SHk1eVMwODJ1THJHd3VyOGhD?=
 =?utf-8?B?UVhqTW54QnI0SGRpQ1J6SmltMklYa2dQY1ZqSzdPck8rZ0YydDB2SjdXb3M5?=
 =?utf-8?B?L1N1a2dEcFR1ZkVycmJlVk1VRVVOY3VzTGRsVkZockgyMXoyRkVKSFRMS084?=
 =?utf-8?B?bERGbXp6YmJ1YWdqMXNhQ1NWMlJheFh6d3VLa2w2UzBnMThoT1oxYVY1Q0ZS?=
 =?utf-8?B?WWhFdFlybFB0eXpiTmxFWTlWbTNDZjcyMHlIcXE3T0RxLzBBT2puaXlmb0RX?=
 =?utf-8?B?dzBXa1RybXAvWWp2bGFzTHhSYU95Yy8rMjdDY045ZXZ5cStkdFYxNW1UUVFB?=
 =?utf-8?B?eXJuMjNOTDJoSGg2OG9uZXBFbHhyRk96ZDJTZkljanZnUXJqNUVOSjZySEc3?=
 =?utf-8?B?MXZaYUt1dnNmd2pES1pHNktiaHNLRmswSFIrWVdqNjVFODlEbkxHeEwxc2lt?=
 =?utf-8?B?VXg3dCtZbGJ6WWZnNGhJUkNDNXlOcUJEY0RLVFMrMHF6QTZ3V2JFWnFhTWJy?=
 =?utf-8?B?Vkptaldob01ZM2hVc3lGS0luK0JPUkVUZnRnZUtydlRZLzZqdEQ3bHU0d2Q5?=
 =?utf-8?B?aXZ2RHdDSzBYQnJhWU0zREFrNTZoS0F6aWlENjlvYTZnVUl6VWNNTmorMGM1?=
 =?utf-8?B?U0d4QTF0dUNjTFNwREJXRkk5K0hZNTNlalc0L0tJUFlsNWdnNWJldz09?=
X-Exchange-RoutingPolicyChecked:
	3Q+uXCgB9hJ2CwIuICVBW4tI9Xz6PJ2B3c/J3mzDrpIOVm3beuNeRlQnDSNAdzZv1hZ+bF8RVXjaR88WubxqBZ5lApQD6SMY/h6ocMOtZC1PzrT7QAAgKx1uRvUHuOUWR/fW+7/4TYCbdVzSWwTn5X1HsiJZwbZolRgxCHfWrt9LOVU5tXUkyonccvW9Ir/Y/QfQuC5oDGDKOxGgZbyCuR4hJte1Dj7kn2LxUaoo+gvAKa/aiTt9HJyv1+gr++VpAB/XYFjt8zHNE+ia6G4O3foI2GKPgc50cCuk764C0J+NjAnxc+ZonSHScHYm/UaH7hl8AofYwKMFGZbeGLl8cQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xZQ7SQHm+/DW28EXm3Bm0vEG93ctJJNakGVrDKDhzhMeMIA/D7m5dH1h3nwKAr9swdn87Yxyfm57fQjHGtyMzwHHiqIHPnWnAtDoY+7pyrFDcCgOuQWpCu2BXqQbr74citDmA+ebA3w6GP0CCdKC+HOXfw+JHrupFWmKAVfLyUkW85hsvd4TCCPAJih8n+b8cYlnyDbX3F/nz+aGgfE1WFqPoU6IAbexDPKVINWdUjIiks55zfdGlXO9wvXVRA7fjilPFh6C8nf55zsgmhryTzOqVsQk6Z69BQ2qPrw3x6CzVGipEk0Q2QgiRH6Fm9IFr5zcEuddnVsGHv2CSRe5nVVyjvX53g9Ss9o4fE6yCIXu9QYrEg2kReLICH1jdyzuPw6mG6H2dYUUhZQ0idqtF2TI/6xbl73CuXOaVwARdbEUAxEXcp2tKLNi+coo4f3/7ODXH8YqSxbTm8xaehyxu7b6IP9zit480bc6Wg15JN6zI4fZ4saM2+ZzepWVxark/hOmxePx6Q+r3F25Zj5eQF7+PuZoqK3LgkS9uOgtCPJw9i16Ko0qcK2PnOahTy/0mTKQCrI04a6NbQDdhH1+saeoOik/2w7H/+qFb+HItY1kKfC/zuqVg0JKvxh7M57L
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271fe06e-336a-4f93-19c3-08df3a68634d
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 11:40:12.7881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsHRb0nznIBEn2UDs2e8S4ED47Z6RU2Vgl+/97JDv8bHtg4QK6cigTjGZDpJrNQWUpJKODO+jYqtv88h6wbryg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PPF16345CD97

On 03/11/2026 12:06, Anuj Gupta wrote:
> This series introduces a generic interface [2,3] for write stream management on
> files.
> It enables spatial isolation (at sw and hw level) and concurrency improvments [1]
> in xfs by
> (a) steering each write stream to its own set of allocation groups (patch #5)
>     and realtime groups (patch #6).
> (b) connecting xfs write streams to block write streams (FDP capable NVMe).
> 
> Write streams allow the abstraction provider (fs, block, raid etc.) to
> leverage application's intent (file relationships/lifecycle).
> - application: reserves a stream and sets it on the files it wants
>   placed together.
> - xfs: maps streams to AGs/RGs; allocates without interleaving; gains
>   higher concurrency due to reduced lock contention.
> - hardware: maps streams to underlying allocation unit; reduces device
>   internal write amplification, improved life, predictable QoS.
> 
> Also
> - A stream is handed out using an fd. The filesystem is free to map streams
>   onto its own geometry, and the reservation/fd machinery is generic
>  (fs/write_streams.c) so other filesystems can reuse it.
> 
> - Since high-level write stream (in xfs) and logical placement can work
>   without the low-level write streams (in block device), series has a general
>   value beyond the hardware that provides spatial isolation. Patches 1-7 are
>   software only and work on any block device; patch 8 aligns the stream
>   count to the hardware streams when the device has them.
> 
> - write-stream is different from existing 'filestream' allocator which
>   maintains directory-to-AG associations in a global MRU cache. That
>   requires state managment and memory (and its reclaim). Proposed AG-set
>   based steering relies on simple, statless/lockless airthmatic that aligns
>   more with the default allocator heuristics.
> 
> [1]
> ### Performance
> 
> 1. On regular NVMe
> 
> a. Inter-stream concurrency
> ---------------------------
> fio: 4k write, direct IO, 16 jobs, 1 directory, 16 files * 8GiB, iodepth 32
> xfs: 16 AGs, 4 write-streams
> 
> base: 41 KIOPS
> write-stream AG-set: 227 KIOPS (+453%)
> here, 16 files are assigned 4 distinct write-streams (4 files/stream)
> 
> b. Intra-stream concurrency
> ----------------------------
> fio: 4k write, direct IO, 4 jobs, 1 directory, 4 files * 8GiB, iodepth 32
> xfs: 16 AGs, 4 write-streams, write-stream AG-set size = 4
> 
> base: 59 KIOPS
> write-stream AG-set: 112 KIOPS (+89%)
> here, 4 files are assigned single write-stream
> 
> 2. On FDP-capable NVMe:
> RocksDB YCSB
> WAF (base vs write-stream): 35% Reduction
> 
> [2]
> ### Application interface
> 
> Three new ioctls:
>       FS_IOC_WRITE_STREAM_GET_MAX  number of streams the filesystem offers
>       FS_IOC_WRITE_STREAM_ALLOC    reserve a stream, returns fd for that
>       FS_IOC_WRITE_STREAM_SET      set stream, given its fd, on a file
> 
> ### Comparison with Write Hints (RWH_WRITE_LIFE_*)
> 
> - Semantics: Write Hints describe 'data temperature' (e.g.,short/long/extreme),
>   implying a lifetime. Write Streams describe 'data placement'
>   (e.g., Bin 1/Bin 2), implying only separation.
> 
> - Scalability: Write Hints are limited to a small, fixed enum (6 values).
>   Write streams are dynamic, provider-dependent values that can scale much
>   higher.
> 
> - Discovery: The existing write-hint interface is advisory and decoupled
>   from underlying capabilties; application has no way to probe support
>   and cannot deterministically know which hints are valid. OTOH, write-streams
>   provide explicit discovery.
> 
> - Usage model: application needs to get a handle (fd) for a write stream
>   before being able to use it. This avoids two unrelated applications
>   ending up on the same stream.
> 
> Note: within the kernel, the separation between two constructs
> (write-hint and write-stream) had started from 6.16 itself.


This looks pretty reasonable but I'd like to do some prototyping to see how this
would integrate with the zoned xfs allocator and run some benchmarks.

Are the RocksDB patches publicly available somewhere?

Cheers,
Hans

> 
> ### Changelog
> 
> since v6:
> https://lore.kernel.org/linux-xfs/20261015063246.103433-1-joshi.k@samsung.com/
> 
> - add a VFS helper for write-stream/write-hint exclusion (Darrick)
> - use WRITE_STREAM_NOT_SET for an unset stream (Darrick)
> - do not pass software stream ids to devices without hardware streams
>   (Sashiko)
> - rebase on 7.4-rc1
> 
> since v5:
> https://lore.kernel.org/linux-xfs/20260921093147.59935-1-joshi.k@samsung.com/
> 
> Fixes for issues found by Sashiko review; no changes in UAPI
> - fix 32-bit build: use do_div() for the inode-number hash in AG and
>   rtgroup selection
> - bound the stream pool to U16_MAX, the range of the stream id
> - cap the hardware stream count at U8_MAX, the most streams the block
>   layer can tag
> - tag the iomap_dio_zero() bio with the write stream, so sub-block
>   direct writes are not split across streams
> - document that the stream pool must outlive the mount a stream pins;
>   kernel-doc fixes
> - rebase on 7.3-rc7
> 
> since v4:
> https://lore.kernel.org/linux-xfs/20260717125538.508925-1-joshi.k@samsung.com/
> 
> - stream reservation and fd handling moved to generic code, and the
>   stream id moved to struct inode from xfs inode (Darrick, Christoph)
> - stream id no longer shows in uapi: OPEN becomes ALLOC and returns
>   fd for any (unreserved) stream; OPEN_EXACT and GET are gone (Christoph)
> - ALLOC requires CAP_SYS_ADMIN (Christoph)
> - write stream and write life time hint are mutually exclusive at both
>   setters
> - stream pool lives on the buftarg (Christoph), which gives the realtime
>   device streams of its own: new patch to enable RT support (Christoph, Darrick)
> - software streams come first and work on any device; hardware streams
>   are enabled in the last (Christoph)
> 
> since v3:
> https://lore.kernel.org/linux-block/20260616180555.33338-1-joshi.k@samsung.com/
> - add fd-based interface to open/set the write stream (Christoph)
> - move from single multiplexed ioctl to 4 distinct ioctls (Christoph)
> - add mutual exclusion checks against existing write-hint, filestream (Christoph)
> - uint16_t for write-stream within iomap and other streamlining (Darrick)
> 
> since v2:
> https://lore.kernel.org/linux-fsdevel/20260309052944.156054-1-joshi.k@samsung.com/
> - xfs default allocator optimization using fixed-size generic AG set (Dave)
> - reuse the above to simplify the write-stream AG set handling
> - streamline the uapi; Use union for GET_MAX and GET/SET (Darrick)
> - uint16_t for write-stream within xfs inode and other cleanups (Darrick)
> 
> since v1:
> https://lore.kernel.org/linux-fsdevel/20260216052540.217920-1-joshi.k@samsung.com/
> - swich from fcntl based to ioctl-based interface (Christian)
> - new patch (#4) that makes xfs allocator use the write streams for AG
>   selection
> - new patch (#5) that introduces software write streams in xfs.
> 
> [3]
> ### Interface example
> /*
>  * Minimal write-stream example.
>  *
>  *      cc -Wall -o ws-example ws-example.c
>  *      sudo ./ws-example /mnt/xfs        # data device
>  *      sudo ./ws-example /mnt/xfs rt     # realtime volume
>  *
>  * Reserves two streams.  a.dat gets the first; b.dat and c.dat share the
>  * second.  Each file then takes one 4K write, so a.dat is placed apart from
>  * b.dat and c.dat, which are placed together.
>  *
>  * With "rt" the files are made realtime first.
>  */
> 
> #include <sys/ioctl.h>
> #include <err.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <linux/fs.h>
> 
> struct fs_write_stream_set {
>         __s32   stream_fd;      /* IN: stream to set, -1 to clear */
>         __u32   flags;          /* IN: FS_WRITE_STREAM_SET_* */
> };
> 
> #define FS_WRITE_STREAM_SET_CLEAR       (1U << 0)
> 
> #define FS_IOC_WRITE_STREAM_GET_MAX     _IOR(0x15, 3, __u32)
> #define FS_IOC_WRITE_STREAM_ALLOC       _IO(0x15, 4)    /* returns an fd */
> #define FS_IOC_WRITE_STREAM_SET         _IOW(0x15, 5, struct fs_write_stream_set)
> 
> static char buf[4096];
> 
> /* create @name; with @rt, put it on the realtime volume */
> static int create_file(const char *dir, const char *name, int rt)
> {
>         struct fsxattr fa;
>         char path[512];
>         int fd;
> 
>         snprintf(path, sizeof(path), "%s/%s", dir, name);
> 
>         fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0644);
>         if (fd < 0)
>                 err(1, "%s", path);
>         if (!rt)
>                 return fd;
> 
>         if (ioctl(fd, FS_IOC_FSGETXATTR, &fa))
>                 err(1, "FSGETXATTR %s", name);
>         fa.fsx_xflags |= FS_XFLAG_REALTIME;
>         if (ioctl(fd, FS_IOC_FSSETXATTR, &fa))
>                 err(1, "FSSETXATTR %s (no realtime volume?)", name);
>         return fd;
> }
> 
> /* set @stream_fd on @fd, write 4K */
> static void write_on_stream(int fd, const char *name, int stream_fd)
> {
>         struct fs_write_stream_set set = { .stream_fd = stream_fd, .flags = 0 };
> 
>         if (ioctl(fd, FS_IOC_WRITE_STREAM_SET, &set))
>                 err(1, "SET %s", name);
>         if (write(fd, buf, sizeof(buf)) != sizeof(buf))
>                 err(1, "write %s", name);
>         fsync(fd);
>         close(fd);
> }
> 
> int main(int argc, char **argv)
> {
>         __u32 max = 0;
>         int rt, fa, fb, fc, s1, s2;
> 
>         if (argc < 2 || argc > 3 || (argc == 3 && strcmp(argv[2], "rt")))
>                 errx(2, "usage: %s <dir-on-xfs> [rt]", argv[0]);
>         rt = argc == 3;
> 
>         fa = create_file(argv[1], "a.dat", rt);
>         fb = create_file(argv[1], "b.dat", rt);
>         fc = create_file(argv[1], "c.dat", rt);
> 
>         /* query and reserve through a file on the device being placed on */
>         if (ioctl(fa, FS_IOC_WRITE_STREAM_GET_MAX, &max))
>                 err(1, "GET_MAX");
>         printf("max streams: %u\n", max);
>         if (max < 2)
>                 errx(1, "need at least 2 streams");
> 
>         /* ALLOC returns the stream fd as the ioctl return value */
>         s1 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
>         if (s1 < 0)
>                 err(1, "ALLOC");
>         s2 = ioctl(fa, FS_IOC_WRITE_STREAM_ALLOC);
>         if (s2 < 0)
>                 err(1, "ALLOC");
> 
>         write_on_stream(fa, "a.dat", s1);
>         write_on_stream(fb, "b.dat", s2);
>         write_on_stream(fc, "c.dat", s2);
> 
>         /* closing a stream fd releases the stream */
>         close(s1);
>         close(s2);
> 
>         puts("a.dat on stream 1; b.dat and c.dat on stream 2");
>         puts("confirm AG/RG steering using xfs_bmap");
>         return 0;
> }
> 
> Anuj Gupta (4):
>   fs: add write-stream management ioctls
>   fs: add generic write-stream management
>   xfs: implement software write-stream management
>   xfs: support write streams on realtime volumes
> 
> Kanchan Joshi (4):
>   fs: add i_write_stream, exclusive with the write life time hint
>   xfs: write stream based AG placement
>   iomap: introduce and propagate write_stream
>   xfs: support hardware write streams
> 
>  fs/Makefile                   |   2 +-
>  fs/fcntl.c                    |   7 ++
>  fs/inode.c                    |   2 +
>  fs/iomap/direct-io.c          |   2 +
>  fs/iomap/ioend.c              |   3 +
>  fs/write_streams.c            | 165 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_bmap.c      |  59 +++++++++++-
>  fs/xfs/xfs_buf.c              |  37 ++++++++
>  fs/xfs/xfs_buf.h              |   6 ++
>  fs/xfs/xfs_inode.c            |  61 +++++++++++++
>  fs/xfs/xfs_inode.h            |   4 +
>  fs/xfs/xfs_ioctl.c            |  80 +++++++++++++++++
>  fs/xfs/xfs_iomap.c            |   5 ++
>  fs/xfs/xfs_rtalloc.c          |  28 ++++++
>  fs/xfs/xfs_super.c            |  12 +++
>  include/linux/fs.h            |   2 +-
>  include/linux/iomap.h         |   1 +
>  include/linux/write_streams.h |  39 ++++++++
>  include/uapi/linux/fs.h       |  15 ++++
>  19 files changed, 526 insertions(+), 4 deletions(-)
>  create mode 100644 fs/write_streams.c
>  create mode 100644 include/linux/write_streams.h
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

