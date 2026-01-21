Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07A73C00AD
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768980215; cv=fail; b=toSIQuXpix26BHtXrnpr9HiGpA7anmr6FKgtJX+57St53Yvh1oS4aNNLjFMYrKipAea61Sdon19ZhIOr8A06TOVkDSUst8npTt8jNDU3N+B/sTLBRfz57VsYvsLT3Dm+3gvGGcN3ra7So1fnrF7htbBLjp/SpU3qqxcLLynLBOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768980215; c=relaxed/simple;
	bh=baYxz3KHxneyPgi0pgQLbJyLnlZ4S+84yV0TQR9sXOo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ISutPxWHlul49+fzM0me0vY/d0sQeg9d7pVFqYxQ1dUMpIsLtty5q6YZiNZfsAZk3Tl9GH9n/64gZZNvPiXKr3oHIFUDgXFqwktywXWqZUUa2GftvBoC/7Pf2J9lxT4b9yXjbOxAJ/GuqmM0L/Ytjz6D3nSDSYNfx0wZ1YR9ek0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jFYpbhLb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FamctDgi; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jFYpbhLb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FamctDgi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1768980212; x=1800516212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=baYxz3KHxneyPgi0pgQLbJyLnlZ4S+84yV0TQR9sXOo=;
  b=jFYpbhLbQCeqdSdsqrTq777uCbtRUdGfxYoxwsOGKBuog+6MwtPc2Pj1
   04pP1p5wCJOH7PgU6lgzYt+qUsPLkroOAypX2Blut0i4rwGVkEAvZFWES
   V/lPFUj7xzK/Tyfb1Uv4q1xHpxSYormZXGA8F9KMCW1Bo0UZkOWPbsqkw
   QP1/7mi48FG07eO4crk1nmXSuvqTseIUe7y4OdBJos6CSmGA9cb1GXpXD
   QqQfBEbN+8ZSMXFLvYOGLyF66v6FmL2E/no424z6Y9QMQ51Ohv9ELFGZQ
   5AA+tY9WS9F/E1QHi2+uzxfw7w4f42RSx63vCfLATM5nBNzpTCw7q7r78
   g==;
X-CSE-ConnectionGUID: JTPTVG7gQKK5kBD5B/gGaw==
X-CSE-MsgGUID: E+m6g3cWTEa2OOehzg5P1A==
X-IronPort-AV: E=Sophos;i="6.21,242,1763395200"; 
   d="scan'208";a="139865474"
Received: from mail-centralusazon11010058.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jan 2026 15:23:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Od7fnciJhPf9aDLnPD2vwtRE5oKvochytncmrBD4QBpDmhwvKSg2jGHV2xciYlkKL6kIn2QuynIh4FX2tUdtJZc5yoLKBFz72VkS2TO+oBSiHNM/8BvoGvfUw4oa0K0TosLQonGV6iL7PDsoMnrp2lcxz7UdWqE08i+DWRejZEhC8OceQ3NJiNJUOOKr1BQNpGNrnj9Z0BoQ5/XDN6LkuKGEJqhLTHummZ9uAebeMNA+CesP2y0vNsBK2x2tI+VdpkoeWzJucblU4p8ioHB3UnunVXMCg3ni6oAjveJzxCMDDMRbIAiC8Bn6rAqcKXDtUolMIKCcaBHQWEEZjeJloA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baYxz3KHxneyPgi0pgQLbJyLnlZ4S+84yV0TQR9sXOo=;
 b=jn9k+3dEN7IhIxA2fZymTC8BQ6lUuED/9aD1N653IeE7Iw6UBj0YLEQUTpZGGLAjmSe7GuyCp8kiG5TGZWEcWLYTbByYa2K4rGQJoI4ZDzFyoPOsP6P/aBn3+nmkyUSEWZEGhASQM9rkV8ZuP4HF5bC06oTpMw8UqnX68F1KSa/jlHvbPzVKygRQ7igSDFkdk1GyR/aS6DJNZ1diGMqS/M3iA1EdYRp194eTdyP+hjFQkC7qfWLk1SCLij7o7i6WkQhslFOulP85PkKO02LoXoKpJYkpPRbMKAqG62Hm7FTQ7RIol+HcxU5zaENQQZnf09aJppbJSlzFVy+5B4NbwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baYxz3KHxneyPgi0pgQLbJyLnlZ4S+84yV0TQR9sXOo=;
 b=FamctDgiv5f8PYqTPSjzvNh5qn+nLDDIDQaSMtCLcDAuho4fecSwmrAVTAQ7qO519/OPnzC9LrD7c7ZqCik0rKKjrjgWc9FfSFnSG8CckJNK0kJfhLmmHJX/gQ8M8DOkPM2ZV58LQjykxFuCRdW9edzwole6EfEpTANYZ0faOd0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9454.namprd04.prod.outlook.com (2603:10b6:208:4f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 07:23:30 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 07:23:30 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Carlos Maiolino
	<cem@kernel.org>, Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"dlemoal@kernel.org" <dlemoal@kernel.org>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest index
Thread-Topic: [PATCH] xfs: always allocate the free zone with the lowest index
Thread-Index: AQHciescPV05groijE23hAPY8w6w27VbNgCAgAED14A=
Date: Wed, 21 Jan 2026 07:23:29 +0000
Message-ID: <7b186f15-7593-4ce5-aee9-a3d3eb893b11@wdc.com>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
 <20260120155329.GM15551@frogsfrogsfrogs>
In-Reply-To: <20260120155329.GM15551@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9454:EE_
x-ms-office365-filtering-correlation-id: 1ef3c40f-197e-439e-9a70-08de58bdf9eb
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eWoxREkzei9CbUVvVUlIZ2hMbTNWVmllS1ZNSS8rdDFWSHl4OCtNVjNmSGxQ?=
 =?utf-8?B?ay9lTU9nTE9pblRlM2pjL1ZwTDU2cmZYRndsS2thZyttUld3aS9ZUU1kWFpZ?=
 =?utf-8?B?TnBYZTVKZnYrVnB2TU5QV1BtdU4yZVY2ZThDdmN6VE1EeUJVRGhEMEFhUEp5?=
 =?utf-8?B?RUtEbkQvSDdHL3VZV1pLSWYwa0JMSXlmK3Z6aWVRWEd4eFJZQ0xrNCtiMFEx?=
 =?utf-8?B?Mkw3WFB3NW8wYTZaeGhUVGdpNHZLdXdvN3hVbEpFa0xjam5nTFVUNVpjM2xX?=
 =?utf-8?B?RWVtbjBnbTNQcXhDZWhwTktRZVJDeFVZT29lWEwzYVVhTW1zMXhYcFdHRnBS?=
 =?utf-8?B?MUNoSHhMVElScit6L2d4ckZKMEFLR2JoN045YnpYVU5Nd0tSTSt6bkF4T3Fz?=
 =?utf-8?B?SGFDbGo4N3lQV2FHRmZhWTlUSURoenVSWmo0VHo1cVVPYnNkb0U1YjF2eGls?=
 =?utf-8?B?OWpuS1hMVmRYUTh3cE56aXkxdm9XczMxRGdMRUVqT200MWpLU2FEZC9RcS9M?=
 =?utf-8?B?SG50aWtVeGd0T2ltYm51eUs1VlRMdWVZQlhCU2ZHdmpZWFR3VU91cmd2MGdP?=
 =?utf-8?B?cGJodUFOV216VTZEa2hjdVB0cFVwWHhjZ09CWVBPY1p5MkpyTEQ5eXdjcVV0?=
 =?utf-8?B?UjBEdkJ6empRNlptNUg3TzRkKzNNUTlPK0hDd25TaDA5L3BraFVTMWd0OWpZ?=
 =?utf-8?B?TllKZmZYbUtYSmpCSkVBSmlUNzZDdTJOb2s2VCt2MU9pZjlsb1JXVG90SFN0?=
 =?utf-8?B?Vnh3WGdIL0Vyd1lFQnFlcWQrU3FBV2FmbEtMamh6ZFRTRHZBNS9RaDJ5Uklx?=
 =?utf-8?B?ZmdOOFVtTFUwMlNjQzdoTDUzSjdKNi9DUEhuOGRmU2FPSytpZ0duTmNLc3Zw?=
 =?utf-8?B?Uk9wM2FUNzlGQ3U4UENqT1ZhRXZ5Nkk1NG1JK2dzTUV3MjBqdjZEMno4N3p1?=
 =?utf-8?B?dmcwRStscXp4L2QvQXc2RVJGSUw5QThEMG00cTNadEROTW5VY29XN0J5a20w?=
 =?utf-8?B?VURRVnpQU3EyRjVPYzRxV213c05IVnZ0cDN4RXBEcnFUSXZ3T2podVBxeFVl?=
 =?utf-8?B?Nm9OVWM3WGFlZkRXUHFNYWhjZXhydXgra25QSlVrUVh4R1BhTGluNnJlclJM?=
 =?utf-8?B?aUYrREsrdXM4SFZaWDVDM242aFhNUHNGYUMrdG9mRHRQVkpKd2hUSXJQRjhT?=
 =?utf-8?B?bG84RXlIcEVUUWsydWZraDRnRG5yTk5jRkFoTDRIc28ySFNBQUNDc2hMM0Zy?=
 =?utf-8?B?Zy80ZWMxTmtOTVlBeERRcUxrV3BocWRCK281cEVOUVVTWGRlbVR1b0F3WE93?=
 =?utf-8?B?RmtMWFFWMmZLWUhpMjFwUFhic3pOOUNxTWt2MWt5M3oyRTFKeVpObHgxMytr?=
 =?utf-8?B?UjVuNDVMeVIvQ29vaFJTM0VKSHczODU1cVY5V2xOMkdmZjY3Q2ZHcnBWM1Rt?=
 =?utf-8?B?LzhiZDZJZWM0SnNadFo5WXhHOTlMTWtKak0xdm1DL0Jvd21NZm02bm9jcFlI?=
 =?utf-8?B?aTVENk5RNVJvTzAvN2h5SFU5Z0VDTEt4YVhrTTV4T3N6VE1Gc3RIdE5vK0F3?=
 =?utf-8?B?ZjVNenprekR3ak9rVlYyRXB3UFpkajhEMnNHeEZaMStHVmZJUnNVQlRLSUEz?=
 =?utf-8?B?NGI3MzAzM2QyVnhqWEpKZXlCWFl5WVdEemI3MWJ5TFY4WHQzMVpUSEpnbzRU?=
 =?utf-8?B?TVFYbExacEk2aWZPMmxQNW9udTdadkZJbnovMWtxTUdKaFZ1Z09MTlU0RWVz?=
 =?utf-8?B?aHhndzdHTDd0d1VzTUU3eE0yMUJVZVBMTm5NSFNWVjdiWTVldThEbzVyTVZU?=
 =?utf-8?B?OGpZVWRSbGx5ai85eU5YRHlyeGpQK1RpcU00c1RzOG40ejBBcHZSMFVkVlNx?=
 =?utf-8?B?ZjZDSVFSMENlazBYRk5kUzhFRGI1RzdnUjhrVi9mcWZyVmhMRXpSTTZuWExp?=
 =?utf-8?B?NW1TeWlZRk0xOTEvazNzUlI5anU5OElyR2lNTVRvQXpzWGpIa3VBU01kVUw1?=
 =?utf-8?B?WGV1YnlRanlobjJTNVI4Y0thTUhSa0VmYThuL3RlSWROZExSd3RCMTVrUkJk?=
 =?utf-8?B?aHNJOHk0cjRJSXNZVGs0TUc3TVZJRUVOcWcxUW9YK3FmVEQraCtRcVlRMUZs?=
 =?utf-8?B?OFIyeUg2T3NOT2luWHlwaGI1YTI2Zy9JV1FNZThQaVhUVytjZmxaWjFoRU50?=
 =?utf-8?Q?8OhdS3L1xE9ey8Q600bo/+I=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Yy9NRFFGcUJLUEZKSmxJaktpNU9DcVB1bG5HOHN5QUttRHNEeDJtS0lVc1R1?=
 =?utf-8?B?am1DQVp1a1B5QnE4ZVBhMXpKblByR3krZjVGYWRYVFM4alhTajNWVHVSOXVG?=
 =?utf-8?B?R3I1TVhiQlE1Z0JmOXBrL1pVMHpsYjdkY3VKZ1Vtcm1SejdwYktKOGdqbVpF?=
 =?utf-8?B?RnBPdmx3MUxWSkRRUWMwSWNVVi9VcG1zYWMxdjl1dVFGd0dxMzEyV1FIek1C?=
 =?utf-8?B?VStUaUF0QnpncFpDRE9tWUlIVlAvd2hkbFJEbmtTcU9mNWc4Vi9VcTNrSGZj?=
 =?utf-8?B?V0QwY0VuQ2RJZXdwLzgzNk1VbWRrVFROd2xITVB0clEvVDRsWmw3V0hTT1hB?=
 =?utf-8?B?ekNtS0RreU9pZUFEMzArRzZHTmVlRG5ybWtMVmg2VW53STJjQjRaRVcvaFlE?=
 =?utf-8?B?V1liUDY1Nm9uWjNTNlMweG5IbWNlZUF2Tm9LWGo2cGhIMDRja09XZ1NjRHFX?=
 =?utf-8?B?b2xNV2NZUHNsSTVZYmVuRlM5bFVFWklhd3JaN0FjS1ovYkd5bnpYSE5oamhQ?=
 =?utf-8?B?WXphVVNmVEpVblRjRng2YjloeGFuNkJWUG9kZFV5L3NzK3VTN3F5S0YrNU84?=
 =?utf-8?B?S0hlS09YQ1VqdDBJOVdBSFhYSS9TMS9NNlYyZFE0R1ROeVlIdmVCUXBiWEwr?=
 =?utf-8?B?cFMvZnNHOHZtcUVMNHN4aHowR3FBK0ZYY1htSFUvNllXZzhmNitKd3ZxYkdH?=
 =?utf-8?B?Z0FqUFZ2ZXhFQ0FKUzNtMEV5Z1hLQzFGVEljM1QyY29Zc1krRjQ1U3VsTUFX?=
 =?utf-8?B?a3M4VmwrWFhPNjdNVnJWQVpmVFZNVXkwQjRtQ3ZqeXpPU2tDaDlRclhFQ2dR?=
 =?utf-8?B?ekJXR21OUW1tTkdjZUVPRS9HVmdQakowV0NDeGRNbWJVSDdMOHdoMVZ5Nm9C?=
 =?utf-8?B?VTZjdjY5NUloRUU3bm1ES0tJNU16ZHZjcWd2bzNDbmgrZmZMbHFpMlYvMmZx?=
 =?utf-8?B?SkdDbndDSEtGZkFXV3EyUnhmcVVrbWdpdXFGajFUUEpGbGUwVFRTMkJITzJo?=
 =?utf-8?B?Z1k1WFZOU3NRcy8yQ2wzS09VakFkeDFVU2V0UlVBMU1nOWVsYXZMeTFRSjMz?=
 =?utf-8?B?TXU0KzZzb3ZHY0t0L1d1RU00Y2ZLaS91SHFvcVVQU1NtRGc1UjBGUHd6ODRS?=
 =?utf-8?B?blZCTjYzMGo2bmtkNkhZb0tYQ0h2L0NHcDZRcjd6dm5VMGRpMXBTV3FLcUlE?=
 =?utf-8?B?TmxGdjArOWpZTWlOd3Vpa2NKTEIvT2xZMldkK1lnYitoOUpIa0h2d3hKa3Fa?=
 =?utf-8?B?d0ZTSi82MXVTRHRlMzBHSEw3U0VPSHZLR0EzNDh6N2xBbkZsZndyM3h0RXlt?=
 =?utf-8?B?Zk9iZW5xdVVOQktOY0trUm5MVXZxa2t4Ylk1T21wdGxiVzNiMFlMbHNxVjFQ?=
 =?utf-8?B?d2Q5OGpTOWNGQ3g4UExEdkJRVkVVdlpZS2drcmJDYlh4NVFNLzd1K3h1OEdM?=
 =?utf-8?B?R1lRZkZTQ3lJRTdnaXFEcmNwd0prNE9ZTTB6MlR1MVArdWQvV3NiQkdOdjlE?=
 =?utf-8?B?RTZhZDJSb0h2MG1CM2hlaWk4TXFQaDdsUGdxWjBPUnhjUCtHNTB3NThLOVpk?=
 =?utf-8?B?eWxJOHV6dEY5WFVsWithNldKU1J3b1hpVE1jeGtwZkFIWC9RK2h4M1EvY1dL?=
 =?utf-8?B?SEVqb1cyYkZxTGVuT2h3ZmpES0ZteUFjVmlOeGVibzNIQWVSMXhhV2lxOTRv?=
 =?utf-8?B?ekFGRXNTYmxXdnpHSGNXUkI5ODNoazZGaEF4Zk5oNk1VbWlYNTZVdTNybTdy?=
 =?utf-8?B?U0w5ckN6cUk3eFQ2K1AxZ1lOSDRFYUR6TzlqM1dvdStYdEs4U1Jxajg4WExG?=
 =?utf-8?B?WUlsSFhBNmJ6akpqVldWQnRrNFlqclNYck1hUWcxN0lDZzlDZ2VYZFR1QjVD?=
 =?utf-8?B?NG1QQzNrTlVncDR3eHI2ZEIxQTFtRFFUQVRPYTV2d05Zb3NjVkx0d2FOWkV5?=
 =?utf-8?B?czZ4M2syd0ZIWVN2SlZWMVB0QTVKSmdGZ2Raa2JnazBFUXU1QUZPRmVzdGZN?=
 =?utf-8?B?YWdjQmg4eWNSSVdwdWZiRTcwV1lRLytONTZ2N3ZINlY5T1IzSFk2ZC9jMTFs?=
 =?utf-8?B?M2hLMzlUeVR4ZnRaSStGRVdoTVJVRC84MUtmbnJYcTcxajV0WFk3Yk5icm9S?=
 =?utf-8?B?VDBzWW9WdjVDSFhuMzRXWWhUd0hRR3JIR1lMaEZrc3FxcVNwdXdmWW1oQWw4?=
 =?utf-8?B?NWRGN0dMbWtFTEh4QkdyNjkxSUxHRkVnSVV5Qys0S0lPcmUyVjFwMGhyMkNJ?=
 =?utf-8?B?ZU0xWXVGdzNLWTNMb3p2U1dCWmtTcHNTQWJuQmJpOGRBV04vdWY2eTZqbis2?=
 =?utf-8?B?K0s3Y0dhaW1idW8rZHZTbnFrMisrZWhONkU5Q1FjSjhta1lmV0Vxdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D5B293E5F81744D8CC592392E568422@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V9Bk6tkc6+ZYjDjrmhgA/hQWWeHgGURLeSaOFHzjCePXsvKlkMddLAGBNeCWmGhBDxj1AQ/PxeshAkVf885nv/MuH5yL+L3eF2KjEuNsYYxvZvOJjZSrW5YV7TpX/RJB7umb5fznz/oWUl7rNBS5eHb2E6bxcHhUlHdCaS5fNGyQAvEsRcZHnHdpSojGunDY7zeBx2vM/9Em3qLhR3PatBkA6EII0mNIL2S/9wcBIKiQQ6CrryC6UtDa5HipIrhxybYG8DGm3V5wOTyIWBPlHfDUHlmy8hlSfzrVbJUBF76GOJ4fBIvgClc4UKQUj+Pgl07rpK/6Xx2J0cIWGpy/Y6UJoYSuBoxJhNHBiMYq1owyCFrgzIe+BOKLqEDnTCdre2JP7AcIc/5pDyy0OMDKjrzqn2i2Qcz5DXMfRixoqKL9TV6GVPG+NRR/V6D7HNAS2TsSWQ4yZuWwVShMOlYrzE+GOBA/0wCKkwuW08HLxCKJ9jhqkQ+MQYHLi4B92jou43sUEiRJt5/G/5j+4Vxplb6WFEcPEmlEGO0jZ0OFXMYGIlOAKMOizz8gQdGqA8Dd8rqMl/gNdQV44tEcqM18KLGVASz+3BfY+mcEgXoWQcgJn2UOsgHhC3cgB/wXescD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef3c40f-197e-439e-9a70-08de58bdf9eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 07:23:29.7874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZFC0xmxESVgDg9vimP1nDC9tFv64T5vBGw/EE40oUyh3Np4lvzYhCbzK1hTPcd0b6YCFZLCP16QDw1QEDVXew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9454

T24gMjAvMDEvMjAyNiAxNjo1MywgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBUdWUsIEph
biAyMCwgMjAyNiBhdCAwOTo1Nzo0NkFNICswMTAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
Wm9uZXMgaW4gdGhlIGJlZ2lubmluZyBvZiB0aGUgYWRkcmVzcyBzcGFjZSBhcmUgdHlwaWNhbGx5
IG1hcHBlZCB0bw0KPj4gaGlnZXIgYmFuZHdpZHRoIHRyYWNrcyBvbiBIRERzIHRoYW4gdGhvc2Ug
YXQgdGhlIGVuZCBvZiB0aGUgYWRkcmVzcw0KPj4gc3BhY2UuIFNvLCBpbiBzdGVhZCBvZiBhbGxv
Y2F0aW5nIHpvbmVzICJyb3VuZCByb2JpbiIgYWNyb3NzIHRoZSB3aG9sZQ0KPj4gYWRkcmVzcyBz
cGFjZSwgYWx3YXlzIGFsbG9jYXRlIHRoZSB6b25lIHdpdGggdGhlIGxvd2VzdCBpbmRleC4NCj4g
DQo+IERvZXMgaXQgbWFrZSBhbnkgZGlmZmVyZW5jZSBpZiBpdCdzIGEgem9uZWQgc3NkPyAgSSdk
IGltYWdpbmUgbm90LCBidXQgSQ0KPiB3b25kZXIgaWYgdGhlcmUgYXJlIGFueSBsb25nZXIgdGVy
bSBzaWRlIGVmZmVjdHMgbGlrZSBsb3dlci1udW1iZXJlZA0KPiB6b25lcyBmaWxsaW5nIHVwIGFu
ZCBnZXR0aW5nIGdjJ2QgbW9yZSBvZnRlbj8NCg0KSXQncyBhIHZhbGlkIHF1ZXN0aW9uLiBZb3Vy
IGFzc3VtcHRpb25zIGFyZSBjb3JyZWN0LCB0aGlzIGhhcyBubyBlZmZlY3QNCm9uIHpvbmVkIHNz
ZHMuIFRoZXJlIGlzIG5vIGRpcmVjdCBtYXBwaW5nIGJldHdlZW4gbG9naWNhbCB6b25lcyBhbmQN
CnBoeXNpY2FsIGVyYXNlIGJsb2NrcyBhbmQgdGh1cyBubyBuZWVkIHRvIGRvIGFueSB3ZWFyLWxl
dmVsaW5nIGZyb20gdGhlIGhvc3QuDQpUaG9zZSBncml0dHkgZGV0YWlscyBhcmUgdGFrZW4gY2Fy
ZSBvZiBieSB0aGUgZmlybXdhcmUuDQoNCg0KDQo+IC0tRA0KPiANCj4+IFRoaXMgaW5jcmVhc2Vz
IGF2ZXJhZ2Ugd3JpdGUgYmFuZHdpZHRoIGZvciBvdmVyd3JpdGUgd29ya2xvYWRzDQo+PiB3aGVu
IGxlc3MgdGhhbiB0aGUgZnVsbCBjYXBhY2l0eSBpcyBiZWluZyB1c2VkLiBBdCB+NTAlIHV0aWxp
emF0aW9uDQo+PiB0aGlzIGltcHJvdmVzIGJhbmR3aWR0aCBmb3IgYSByYW5kb20gZmlsZSBvdmVy
d3JpdGUgYmVuY2htYXJrDQo+PiB3aXRoIDEyOE1pQiBmaWxlcyBhbmQgMjU2TWlCIHpvbmUgY2Fw
YWNpdHkgYnkgMzAlLg0KPj4NCj4+IFJ1bm5pbmcgdGhlIHNhbWUgYmVuY2htYXJrIHdpdGggc21h
bGwgMi04IE1pQiBmaWxlcyBhdCA2NyUgY2FwYWNpdHkNCj4+IHNob3dzIG5vIHNpZ25pZmljYW50
IGRpZmZlcmVuY2UgaW4gcGVyZm9ybWFuY2UuIER1ZSB0byBoZWF2eQ0KPj4gZnJhZ21lbnRhdGlv
biB0aGUgd2hvbGUgem9uZSByYW5nZSBpcyBpbiB1c2UsIGdyZWF0bHkgbGltaXRpbmcgdGhlIA0K
Pj4gbnVtYmVyIG9mIGZyZWUgem9uZXMgd2l0aCBoaWdoIGJ3Lg0KPj4NCj4+IFNpZ25lZC1vZmYt
Ynk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCj4+IC0tLQ0KPj4NCj4+
ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDQ3ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+PiAgZnMveGZzL3hmc196b25lX3ByaXYuaCAgfCAgMSAtDQo+PiAg
MiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAzMSBkZWxldGlvbnMoLSkNCj4+DQo+
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2FsbG9jLmMgYi9mcy94ZnMveGZzX3pvbmVf
YWxsb2MuYw0KPj4gaW5kZXggYmJjZjIxNzA0ZWEwLi5kNmM5NzAyNmY3MzMgMTAwNjQ0DQo+PiAt
LS0gYS9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPj4gKysrIGIvZnMveGZzL3hmc196b25lX2Fs
bG9jLmMNCj4+IEBAIC00MDgsMzEgKzQwOCw2IEBAIHhmc196b25lX2ZyZWVfYmxvY2tzKA0KPj4g
IAlyZXR1cm4gMDsNCj4+ICB9DQo+PiAgDQo+PiAtc3RhdGljIHN0cnVjdCB4ZnNfZ3JvdXAgKg0K
Pj4gLXhmc19maW5kX2ZyZWVfem9uZSgNCj4+IC0Jc3RydWN0IHhmc19tb3VudAkqbXAsDQo+PiAt
CXVuc2lnbmVkIGxvbmcJCXN0YXJ0LA0KPj4gLQl1bnNpZ25lZCBsb25nCQllbmQpDQo+PiAtew0K
Pj4gLQlzdHJ1Y3QgeGZzX3pvbmVfaW5mbwkqemkgPSBtcC0+bV96b25lX2luZm87DQo+PiAtCVhB
X1NUQVRFCQkoeGFzLCAmbXAtPm1fZ3JvdXBzW1hHX1RZUEVfUlRHXS54YSwgc3RhcnQpOw0KPj4g
LQlzdHJ1Y3QgeGZzX2dyb3VwCSp4ZzsNCj4+IC0NCj4+IC0JeGFzX2xvY2soJnhhcyk7DQo+PiAt
CXhhc19mb3JfZWFjaF9tYXJrZWQoJnhhcywgeGcsIGVuZCwgWEZTX1JUR19GUkVFKQ0KPj4gLQkJ
aWYgKGF0b21pY19pbmNfbm90X3plcm8oJnhnLT54Z19hY3RpdmVfcmVmKSkNCj4+IC0JCQlnb3Rv
IGZvdW5kOw0KPj4gLQl4YXNfdW5sb2NrKCZ4YXMpOw0KPj4gLQlyZXR1cm4gTlVMTDsNCj4+IC0N
Cj4+IC1mb3VuZDoNCj4+IC0JeGFzX2NsZWFyX21hcmsoJnhhcywgWEZTX1JUR19GUkVFKTsNCj4+
IC0JYXRvbWljX2RlYygmemktPnppX25yX2ZyZWVfem9uZXMpOw0KPj4gLQl6aS0+emlfZnJlZV96
b25lX2N1cnNvciA9IHhnLT54Z19nbm87DQo+PiAtCXhhc191bmxvY2soJnhhcyk7DQo+PiAtCXJl
dHVybiB4ZzsNCj4+IC19DQo+PiAtDQo+PiAgc3RhdGljIHN0cnVjdCB4ZnNfb3Blbl96b25lICoN
Cj4+ICB4ZnNfaW5pdF9vcGVuX3pvbmUoDQo+PiAgCXN0cnVjdCB4ZnNfcnRncm91cAkqcnRnLA0K
Pj4gQEAgLTQ3MiwxMyArNDQ3LDI1IEBAIHhmc19vcGVuX3pvbmUoDQo+PiAgCWJvb2wJCQlpc19n
YykNCj4+ICB7DQo+PiAgCXN0cnVjdCB4ZnNfem9uZV9pbmZvCSp6aSA9IG1wLT5tX3pvbmVfaW5m
bzsNCj4+ICsJWEFfU1RBVEUJCSh4YXMsICZtcC0+bV9ncm91cHNbWEdfVFlQRV9SVEddLnhhLCAw
KTsNCj4+ICAJc3RydWN0IHhmc19ncm91cAkqeGc7DQo+PiAgDQo+PiAtCXhnID0geGZzX2ZpbmRf
ZnJlZV96b25lKG1wLCB6aS0+emlfZnJlZV96b25lX2N1cnNvciwgVUxPTkdfTUFYKTsNCj4+IC0J
aWYgKCF4ZykNCj4+IC0JCXhnID0geGZzX2ZpbmRfZnJlZV96b25lKG1wLCAwLCB6aS0+emlfZnJl
ZV96b25lX2N1cnNvcik7DQo+PiAtCWlmICgheGcpDQo+PiAtCQlyZXR1cm4gTlVMTDsNCj4+ICsJ
LyoNCj4+ICsJICogUGljayB0aGUgZnJlZSB6b25lIHdpdGggbG93ZXN0IGluZGV4LiBab25lcyBp
biB0aGUgYmVnaW5uaW5nIG9mIHRoZQ0KPj4gKwkgKiBhZGRyZXNzIHNwYWNlIHR5cGljYWxseSBw
cm92aWRlcyBoaWdoZXIgYmFuZHdpZHRoIHRoYW4gdGhvc2UgYXQgdGhlDQo+PiArCSAqIGVuZCBv
ZiB0aGUgYWRkcmVzcyBzcGFjZSBvbiBIRERzLg0KPj4gKwkgKi8NCj4+ICsJeGFzX2xvY2soJnhh
cyk7DQo+PiArCXhhc19mb3JfZWFjaF9tYXJrZWQoJnhhcywgeGcsIFVMT05HX01BWCwgWEZTX1JU
R19GUkVFKQ0KPj4gKwkJaWYgKGF0b21pY19pbmNfbm90X3plcm8oJnhnLT54Z19hY3RpdmVfcmVm
KSkNCj4+ICsJCQlnb3RvIGZvdW5kOw0KPj4gKwl4YXNfdW5sb2NrKCZ4YXMpOw0KPj4gKwlyZXR1
cm4gTlVMTDsNCj4+ICsNCj4+ICtmb3VuZDoNCj4+ICsJeGFzX2NsZWFyX21hcmsoJnhhcywgWEZT
X1JUR19GUkVFKTsNCj4+ICsJYXRvbWljX2RlYygmemktPnppX25yX2ZyZWVfem9uZXMpOw0KPj4g
Kwl4YXNfdW5sb2NrKCZ4YXMpOw0KPj4gIA0KPj4gIAlzZXRfY3VycmVudF9zdGF0ZShUQVNLX1JV
Tk5JTkcpOw0KPj4gIAlyZXR1cm4geGZzX2luaXRfb3Blbl96b25lKHRvX3J0Zyh4ZyksIDAsIHdy
aXRlX2hpbnQsIGlzX2djKTsNCj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3pvbmVfcHJpdi5o
IGIvZnMveGZzL3hmc196b25lX3ByaXYuaA0KPj4gaW5kZXggY2U3ZjBlMmY0NTk4Li44ZmJmOWE1
Mjk2NGUgMTAwNjQ0DQo+PiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfcHJpdi5oDQo+PiArKysgYi9m
cy94ZnMveGZzX3pvbmVfcHJpdi5oDQo+PiBAQCAtNzIsNyArNzIsNiBAQCBzdHJ1Y3QgeGZzX3pv
bmVfaW5mbyB7DQo+PiAgCS8qDQo+PiAgCSAqIEZyZWUgem9uZSBzZWFyY2ggY3Vyc29yIGFuZCBu
dW1iZXIgb2YgZnJlZSB6b25lczoNCj4+ICAJICovDQo+PiAtCXVuc2lnbmVkIGxvbmcJCXppX2Zy
ZWVfem9uZV9jdXJzb3I7DQo+PiAgCWF0b21pY190CQl6aV9ucl9mcmVlX3pvbmVzOw0KPj4gIA0K
Pj4gIAkvKg0KPj4gLS0gDQo+PiAyLjQwLjENCj4+DQo+Pg0KPiANCg0K
