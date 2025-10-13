Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803372F99AD
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760344508; cv=fail; b=kB2bUBWSUE6xR5iitutUSr3uvEhGkEQmbROlUfIPmBUxRGuOZA2cKbNnL7rXWEkfeX+B1b/cbTzaNEU0KoCgDHGevOLVdxR1W9gfL7dZP2zjp5tLQBi/OKizDvVaAOOK//z5F7IUbVzodAeOBxzc7dHIl01YxaFByjcdLjTL+bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760344508; c=relaxed/simple;
	bh=vFHf2oAWHv4WOrDe1kOOOak5lPkayB4ZVaqPdUKs4ls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ar98jahFE/dwf84AJV5v7B+I36Fi1rUNWOWQ1ia4APpqeldfUQNm8G5gQ5ef2BoVnM3WUM9Uw1g8AZ+ghHpzk3HGCsHC45LxpP3ZSo6cux9HoBPwlwY1BmhKnsjNCZH5cRZD9vDECdg1Z+wHO/68vWDADSt8sXJsKJ9jdLWQjCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XqAl4lwj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=AcyL/V/U; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XqAl4lwj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AcyL/V/U"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1760344507; x=1791880507;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vFHf2oAWHv4WOrDe1kOOOak5lPkayB4ZVaqPdUKs4ls=;
  b=XqAl4lwjJajTPjK9ZYWZOTrQvV0s5eupN7lUweN/c0c3r+dprUw+XrKy
   oAJdXElR+sjYDKCyZn3ccCFPeQNYC4iAt0vDtfxS7elCQfT+pOtFVZBrf
   to+pPihjXew2PyZk5YzhT/lFy24RpFzGrEo0FnJuXmFu6v3asmhHusCCW
   yqNUut8GCG6bNKg4NC8oxN/47ZBLPPGeP/HbvrHuY65uPn/9ENcKAVVp6
   C/jhBU5cI/Jvgcjq27iCurVXym1xHATsMlnpPHng1qEi2489/qX5WgQLY
   gWL+aAzb73qrNkO0KfD2VdqiZclD/WkuWgB1u0WmChZG5bKdxumFKyGKf
   Q==;
X-CSE-ConnectionGUID: DbBQTg2tSZaW3IeW8oRSYA==
X-CSE-MsgGUID: 75lYoULTTTS9pqutogqznA==
X-IronPort-AV: E=Sophos;i="6.19,225,1754928000"; 
   d="scan'208";a="134035608"
Received: from mail-westusazon11010032.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.32])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2025 16:34:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hI0J03p08NNQteSmhMNn23dfGgqsVfQX2hoN3uJO4IUzPH3oe63VUzc6e8DVDfW41MvsojVNR2MYF1ICGNVQ/aczRO+msnwk4mWwbaJLi5OCHKjyuOQZQ2R1aAPD8YVC2KJ7UYXTPCPGFnOeSjy/yszYsjq0TNO4vq/6jhe+SCJub7qI85vyLIxmYzX7kDPf9sG+Vruai5YYrync1e5IZ4C24sP4yIHZY4ObCcULyGyKcvjxNjPdm2SMgz0UOrKv/eTOR12Ejf4/bWZcTdUQa3hzhbwgNrExLiuoXPkJrlLk+pmGXSCh7lRR8VdOwwZHDrIJDAMRFTi41fakHQZn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFHf2oAWHv4WOrDe1kOOOak5lPkayB4ZVaqPdUKs4ls=;
 b=HhIK7VhWrEvKBalU4YTCArEi6b6ofkudr5jh2MPfl5C7A8QW7NVTcE8QfcRZPNrMrCt+qeZhRbMhJ6LMkHaCHdYY1uVA2FgqaBDT0T4QvA3OiUUj+B8oEaa78qffnMKxJY0kwAABoxjwnaT0f4v9qE0k9XUeeT6kaiaXvqXn9gNEOpLWJ3mIXTce98XpULR6tp6St8xmbpEizJP5qkS9OpOBJUZjB1f5T93OHWOnoHzqQkn8QBhzsqTFG6vRlXx0BfxwC96TltsIr4SVY4214TfGb1ZK+imz1MMwit3kryf21BZZ4KI/I02WErJPpLsFAsfG+uMnNjzDs7yOgs6GCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFHf2oAWHv4WOrDe1kOOOak5lPkayB4ZVaqPdUKs4ls=;
 b=AcyL/V/UTUHExdjmayL91HOTtO2ymHFvSxAhWkxTX3NwOqloWBfzBdVHxVj0/d39IzmkvqXsvNtWjb+8r3uDY7sYvIxM7V4tWL24QiG82wJaflXVM8TAa1ZXzkPqLAG3hwCrlCVK5a1A1B/Scgv2eY24hed9DJWQaZaTwfBeQe4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY3PR04MB9765.namprd04.prod.outlook.com (2603:10b6:930:103::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 08:34:54 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 08:34:54 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: hch <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [PATCH v2] xfs: do not tightly pack-write large files
Thread-Topic: [PATCH v2] xfs: do not tightly pack-write large files
Thread-Index: AQHcPBMJ7wgb/o/xPEq1IRhBSjloA7S/wFkA
Date: Mon, 13 Oct 2025 08:34:54 +0000
Message-ID: <3c0e447a-0a46-43d9-9103-ceac4f4efcb7@wdc.com>
References: <20251013072517.752662-1-dlemoal@kernel.org>
In-Reply-To: <20251013072517.752662-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CY3PR04MB9765:EE_
x-ms-office365-filtering-correlation-id: 07702e6a-b7e4-4ee6-1f8e-08de0a336278
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmZuVkQ0WnBaZXpyZHRYQU1lWVI0b0hnMWVPUElMR1JJdHo2UzNwQUY4ZzVM?=
 =?utf-8?B?NjlWOW5WSG5GZUlDdzN1WTIxY0dBRzVsR1NHa3UzSDhzWS9rc045U3lHTWFQ?=
 =?utf-8?B?SlVuVzU4SDZwNFRJOXkwNnptK1FjemhxUWNnTEJjRnp3b0NJWnQ5MmJYSGxM?=
 =?utf-8?B?UUMxUWtlbXhzMWJUZkNWQWM1Z2Q4cmthWlB2OC9BdnJ5aWpVNzNpRk9KdW9o?=
 =?utf-8?B?dW9ud1FlLzdEUG4rbm1lUU94M3pvemZFZ1lvcGVjWjhRSG8rL0VobldaSzFY?=
 =?utf-8?B?RjJPSXM0aXRWRTB6WkZwd1FIT3lTeGo0SXRBRC9ub1dLNUY4ekFmY0ZObTBG?=
 =?utf-8?B?K3prTmxoRkNmanJaV051NGxKTU0rL2x6ZXM3REZLSEVEK2w1Q0RtVkdud3Q1?=
 =?utf-8?B?VXRNdXJ5eGk4Sm9DUjMyekVLNHRLeSsrWUh4M2lLcjByanIxc0dWV3ZqMGk5?=
 =?utf-8?B?OWl4aGhjaW1TNytLZ1NvNVJYbDJEbVJNUDRkNUY2QXdKQmdYaVg5UmRwcHRx?=
 =?utf-8?B?UUs3VktrSTl1UHZYSzlyOVJwYzJXN3pMclBXTDNLUFRYbmxXRUt1aXN4RWhR?=
 =?utf-8?B?TnAvYmVjSi9IV2hEK1NOemNjSUZTNnBWTm9Da2VmTjdBUEJkRnluZlhpYmlC?=
 =?utf-8?B?UDhjVXNQdG9YUFQ2ckNWVHhZR3kvUWcxNFR4L2orTlNzOHZHaUVOQ2hJUlh4?=
 =?utf-8?B?SHJIbnYrSzUwNkhJYzJpWk85d0dUUThHVWE5N2FhbE9nUWlpSTN3UUhiUmdo?=
 =?utf-8?B?ck5PanhxREY5amc3L0lVZ01KVFlURFYvekVQWll5OFdTSkNua3VSNFVIa1JZ?=
 =?utf-8?B?NVMzU1pkOTdVNVYzTHhuNW9ZNDBUZkhQZEwvZUZHamxYelNZdlhORFNyVHZZ?=
 =?utf-8?B?TkltSC9JVHpVa0lka0dTOHRUM1pwWHQ3bFgzK2I0UmRUUk1MOFdXSDdkV0tx?=
 =?utf-8?B?V3lkbGhvRHM2TkMvdExqVjZWU21PSzVqQStFUTlQL0k3bVF2ZmR6ZUk4NlI1?=
 =?utf-8?B?SmMwaXVrMmFYSkJsRng5ZkcwR0dLbzEyTG9YK21EKzViNnpCWGFaQkk3TEdh?=
 =?utf-8?B?dWhXN29YdXdzdjJQWEZIMUU1amFaZ2wvVkZKb09lajdBanFkZ2wzRkJNWFM3?=
 =?utf-8?B?bGVCWlgwRllrZ0liZkxseXh1OVFvRXVNOTMydFZuYkppMEpxTUgwYVJOQ1Zs?=
 =?utf-8?B?VU11bnllWXp5c2tIUDZZWlk3YnIrRnNnMUlYZk9YYmNkQnQ5TkpydGJXekYr?=
 =?utf-8?B?c1l2azhYdlB0NXAyNHkvOE9yeDFjdGdBTWhLM0kwYStjYnNRdnQ1ejMxUDNO?=
 =?utf-8?B?cUFvK0FOalByNjgyUWlnUzF3SGVFUUJ2aTF0WjlDdU9WV2tJNDdNeGtPMkkv?=
 =?utf-8?B?QXcrb2g1aWFmR1NoZy9vRmkvYXJXMjdyMHpWaGFiM2wxSmJCQTdHbkdKcWxW?=
 =?utf-8?B?VXZUYUdvWGdPVlE1R0NIUk1WVTU0TU12YnhUM0hNNHJwb0ovVTFtSHF3Rk5D?=
 =?utf-8?B?RHo5ZXMxWWtGZVVPR0xoVUgzYXlFVm5vMG1vaFpuWTh1SHlFbU9RZGMvM2JW?=
 =?utf-8?B?V0Zma05pdlErNHZnaUNkYk80c1MrbUxhVE9JNWZ5RXEyY2lkaEVNd0hod1dU?=
 =?utf-8?B?cG03ZTdFaWVLY1kzNWgrbFJjc3E5eXBsQ2FycnZza0ZHSzBZSzhOVzN4eGc4?=
 =?utf-8?B?Y2dnWmFRSm95RFlDcEtKbnA5STk4OUNhbk45dWMyS0wxcEQxaUJNMVB5NTlS?=
 =?utf-8?B?aFo4TkxNTkp1WG04OU5CaGsrejRIYmZSMllOWEFpaGpWMld6cFhRVThMUyt4?=
 =?utf-8?B?a3dQQ0REUXpCdHhPaHFxS3EzWnVMdXZUMUYwL2l5L1RkWTJUMDY1My95a2hh?=
 =?utf-8?B?T2t6Q2QrNWxteDRPd2ZIS0t0Zko4WXM4UkJEYnRSQk1vWklHRm1ackZDMUZZ?=
 =?utf-8?B?WkttMHpSUzhJcWdPVXpON2tsNFBvbVBFUUlKRDFLNVF6Um85L1NlOUFQSllq?=
 =?utf-8?B?MitQeVdMYWFUZnpPVE0yMm1CODkvREJNUjlGUXh0T2diZk5sVndiQUhUWTJ3?=
 =?utf-8?Q?J9/Z0C?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3U4N0ZCeXpNM1J4Yjc1cGxHeFJRM1pPWnI0QVVyV0RqVEExNVJUdjhESjNQ?=
 =?utf-8?B?cWw3NzhkelhXQzgydlYwNmo4N1dORVJwc3ZWbkljbmdqVmdnTnVsVUF4RERE?=
 =?utf-8?B?N0p5NWp2Y3JaUk9XMlVrYk1CYVlKWDlBT3p4WUNtNE9KN050aEVXdVJmZ3JG?=
 =?utf-8?B?Q1ZjUmVET2RUWHRTMFczeFJhemRaQ2MvSU10ZVBEbGlFZDlLWmkxZkpjZ0NM?=
 =?utf-8?B?WHM0MkJ4T3RhVjgveTJ5YkRJa29xR095ZGZxcnp4c3FvdS9Rano2amJ3dnht?=
 =?utf-8?B?ZjZ5RWdBK0RqaFBpOUlJM1Y3RVVHNGNSQ3dSTVFvVzY2WDErYXcvQXk2VGdP?=
 =?utf-8?B?ZFloSCtiVU1VWFM3dnNnVWhzbVZRYVRpN3ZpMnF5V3M3SEx1ZFFxQ2V4d2kr?=
 =?utf-8?B?TVRURXFMOHNpay9zcFMvWkRteXJIanFUUy9SWU1BSnJSZXJXYmF6dUVPWUgx?=
 =?utf-8?B?VVpSQzN4WW9xU0I3UGdKdWYzVDd6VnVaQjdoVWNQWC9Vc2Nwd3BoUjJ0YUFZ?=
 =?utf-8?B?OUFucUZlNE43WW9XOExXb0h6eWI3enhSVjlvZUFPQWlFMVFadklGUDVLeHYz?=
 =?utf-8?B?TkJYZTE5VXpGdFFza29ESi93QXJGUjh4VGU4WEtxaWkyWEs1ZHVCdGdnYlkw?=
 =?utf-8?B?V1RjSzB5ZWFMWkJaL2VuOGNrd0oxVlpVSVFIa29CS1UvRkRza253TEk4WVBy?=
 =?utf-8?B?L1g0QzRNak1UNlJCRTNGNlhqY1pabWR2UExub096U0xXLy9rMnE0WW5LNVo1?=
 =?utf-8?B?ZVVIbXpXNnc4OUJlbTQwaG9nQjhGT3F0SkJBaGhlOC9CV01LNk1lQ1g0NW5z?=
 =?utf-8?B?NDQva1ZUZGJlUnk1TXZGaW9rNnFrL0hNZTNBdUJ1VHFId2JLKzF0VVU4Q3Q2?=
 =?utf-8?B?MFZJUXBQY2VqdC9oT2lmOENGSTB2ak5KbkFEU2tpWXlIOWtBS2N5TFJUdmVZ?=
 =?utf-8?B?RW9FU3ptZFRqR2JENmN0YnIvWEhBY3RieHZETTJ3WkRnN2ZXYWxETm9uUDNE?=
 =?utf-8?B?OGlFcTJHSzFSTnZkbkdsTXpCS2tsZ3VzRzZVWmZ3QWw2TnVoOEo3MGwxbWcv?=
 =?utf-8?B?RVl5MkNIN25UU2NtRXFuUGpTYmU1U3Zvd2FiTW40Q3JWL1J3UzRtem5wSlFu?=
 =?utf-8?B?MmRIMVdtenhIUG90bFY5a3lVaXFlcnFoM004UUMyNmdCOEpmMUhWbEF4YTYx?=
 =?utf-8?B?d2d6TWtvLzlCTkVTWXYvSTJyQ0VYanNiZDJiMm0rL2VJVjByLzdMOEVmM1NI?=
 =?utf-8?B?SVFhdjc1bzc0Ni9tSTVBNzAvN2crbUVoZUZnU0owTE1HQTdvemEyK3pTdXM2?=
 =?utf-8?B?OWJSTWRrZGtjL09ybmpReG5KZ1QwUUkxUS9YaGZHWjRIRDdpWFRPMm8wdDk0?=
 =?utf-8?B?S01xVHNQUGpTem1lTnltc3BOdGdkeVBlMWl3eXkrVno1RzlwYTBLRkxUV0x0?=
 =?utf-8?B?TWxGcVo3VFRabStPTVZxMmtSa1Z1YkpOSzVkWHpwbUpMN1Rod0VEd2NwNEgx?=
 =?utf-8?B?L3phMXViQ3FMcjNSYlNYd0tKWGJycEhCeWFjVlVRZCsxUklMUW05ZHhBVkNn?=
 =?utf-8?B?emllZzZudnRqT1k1b1JPSjh5SUJGN3VjNkxTZ1lQVm15SzR6UDdob014aGpp?=
 =?utf-8?B?MFU4bnBOWWpxOFlOSFF0MHBzeHZ0aXZxUzlmTksrZitFY3BQcnRJQTBxbm43?=
 =?utf-8?B?bjlkMUNOem5tVEJUY3NBYUlsUVZkWndWVkRnSDdGbnhibHM3TTd2K0VSQ0Jj?=
 =?utf-8?B?ZDhVL0xmUVY1WUp6ZUthV05BUERRZzNKTjRlZlFoKzltK0RlSGM5RHViZXg3?=
 =?utf-8?B?S1ZLVEdiWXRVTHFWQlVFbXdMNjkzU3UzNkFCYlNwQk1uUU12THV4dUNmZVJ3?=
 =?utf-8?B?Ui9pVHNLc2NBUkcvbG1ZMkpIckk0c1F5TFMwUkFzekdXdTNnOHlHVGdTaFdW?=
 =?utf-8?B?ekRHUThNNzV3QkN6ZXA2ZHluUjJkYkt1bnZtVU9qWWtNUzdtVG5ha2sxZE9V?=
 =?utf-8?B?UXlsMG5nbXo1THpta0QwZTBjRkpzTElEbnk5OGRSRkp3cG5EajI3TmljZERW?=
 =?utf-8?B?RTFyc0tvRGVJeTZoT3VRamxwblQ2L21mOVFlajBnNkJZWTR5VzR6V0tlcnhF?=
 =?utf-8?B?STQ0cXZaMXgxcklQblJjMU5qemFiVjFROFlBb3U5UVZLZmxrSEhrZjdlSDZ6?=
 =?utf-8?B?Qnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19E48EF055358A4894784A4223955151@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GnNcM0OLyYREiE/e+k8eZ+zrC5wEckFlpxkNRncQa8407SNcqxWzgjwJU/duz8sKhQk0x9Qy1G1/MPpIvGJBn4o1wmWzJIYlfIZe+MQRcfKdJHUcI4aWaZES5ljsCQN9wcJEh7gPjHYSdn7xwUod78B/QL1pEhUwaFzohDmYKCkf4l01lvRLLL+Y11tYF4vAGl64dellrHtEBDPNZe1ytJlcz3m1FJQKU6ZYwU0c14T91iRX83rdZNy9+T3oEahX2SCeuEe9y4S+2bW705FyrRs6THFoPC/0M0QAIFp7+SSKvELzcvpo4b/tmuVxk3FZ+18kqY4EqosJfYt/vxlTw/k1vZbIjBtErS5wPnY5UugMAXD6G9FytAYNR8QZG7X8ut4mrZycKGRM071YYohjWkdz4IaAIeBlEVofO+JngRGQLZWGH4KsrB+SVa8aS18y4J13WhefbiKOqouEkhjE8cDNyBqpKr/XBlDWJCQD5zKf0NGWCB8dhtRMMlC6E2pK+7Xa7IpNxO8dmMfzxELiZH7KHvnmznqKDPJBB9iOylddNDIrPG0WVSsj3Cd0Ti/zMrLc5sxe769ybuU0qmSTMk8+bvQRVfH7qWI9TbXT9FTLi11d/tSWuhN+EKT1DEwL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07702e6a-b7e4-4ee6-1f8e-08de0a336278
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 08:34:54.4251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R7lfDpMY+LNF8SyPBvtOG24CTZvyxs9+194qmlMHJFk4XsDuv8P1u+T8tC4c8UjZScSULN0WELmhDMOA1JLXhdi7geLgoo5ZLms3OAaMj+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR04MB9765

T24gMTAvMTMvMjUgOToyOCBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+IFdoZW4gdXNpbmcg
YSB6b25lZCByZWFsdGltZSBkZXZpY2UsIHRoZSBjYXNlIG9mIGFUaGUgdGlnaHQgcGFja2luZyBv
Zg0KDQpzL2FUaGUvLyA/DQoNCg==
