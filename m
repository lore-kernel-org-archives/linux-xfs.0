Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE4234C83C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 12:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602359; cv=fail; b=Rr5pG1zHBCy/P1/4QGdxbplpc1vmYYH4TvpSr3JlxBlj7OyoIkp0saT/2r0u5LMJXfPt5LygBO3KwlH3pQkI3o5QwYORRRiGynXubZEXDp9oUhSSD9tB6u19ucjepMpqE5TFR9kkS13awl1KRrdDEGbuVJ0JW/tIyLPG5n6QTvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602359; c=relaxed/simple;
	bh=AU4cVFLYA1kbpfg89dkkpDyES2LdTmqHUpPjZvUP8Ik=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GgzcrUu9wcXCMmwdJP6eSNHyE3WFmZmN7WDzCguWGSB/dNMcOTBH0Kaw6QNfi1LszebKGXiVhLE64DeoLvLsv/GZkqXpQNOm5CxsqhgU7jJe+cI3f8a7cyO379igcmyEoKyWhQa6P6jd2GTVYoPhFSZU6ishWLMYd+Yr+6lXqCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JxtE/RDQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FZTeuH6e; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JxtE/RDQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FZTeuH6e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769602356; x=1801138356;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AU4cVFLYA1kbpfg89dkkpDyES2LdTmqHUpPjZvUP8Ik=;
  b=JxtE/RDQcG2krbXfE4ZbTLLoabTSmqpxCERwU6V6S61W1M/nDsMTd5we
   86AFgNFvzVGeHCYQFmbG/76Qq+GI/gTJx8x8bH6NWlaKnyJHpAKovOd8b
   YPDfVc9sRrMjt8xHQqN8BDLSIMtj4rSHcjB0i87N9LdtfI7SWFO23EpgX
   WdvCzvslevcccBG1jd00z5mLWMqd/2mbDY2yx6lej8qIm+1r35YSB8gw2
   EHJjgP8Urz4qR+tixF9GetcVg6BMtKVyrOxlrnTfog0Tz40ME/vyQuNhO
   fq/76q4zFDpKH6XK53PBN54bznQF+TmPswKTx8b6IO56pW3VaLYWlqcby
   w==;
X-CSE-ConnectionGUID: QCVuO/GXR82BoHIjvMXmvQ==
X-CSE-MsgGUID: GeyAAJhgRj+tJSxANndakQ==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="138847620"
Received: from mail-westusazon11012031.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([52.101.43.31])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 20:12:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyMSUiolexYcWN89UKY2oqxRg0NcVfhIBSQvP8llsb/GZ9XrFy6vmfc1DqtLPofvXt0/j0R61A+hL0dByHg63RCG6aAX1VYR5Uq50nT8lPdZl/uLkZmpasduD96S2ESmnKILQeZejxbgc+mz/3NrPv5xiccfqe4EJrPjNXQPPq0lZzRWPzEl8qywgoYxq3Y/b4gvA+xtLXUQDM6Fkk3nLPEMGd8WcCb4l0/Vl4mXGSf351POzWw1YzmCaiiazAlY1TubEugHLKQEGs81jAGv26PF9vu4y+vWWDbfKz/fyKSLNVjOzLRLjAv5HF7MwtkSh5z4yGd/ksV7EYjSWDMRCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU4cVFLYA1kbpfg89dkkpDyES2LdTmqHUpPjZvUP8Ik=;
 b=H7JkIcgnDAfaO9vPB7uWCbjxoAdkC2jGhtDHcbcu6jdevjptn0+n8Jont4ysHen9W/Jpc19B5NbiesqTtmplYjMmnecAjGC4QhwnCIaEVIuitaXOTaNl6emd9l4RvhBibdnoF3g/bkTr65SHbt6antGZYAoWzC82/YEWx+67qG4TzOOuEXQ48Oo9ZzXvLvkCzBxzv6qLzXS4fBpVIEZ5DqiI901fpSdGUu1xM3VVmscpfJi78aGc6wo3mKnXrNZp1HVtILmEf2S/FoMwrHIbTVrxuz8gyLFMDwLqk3C/DPi0RxMHFD1KsLrzvkPfctgLcr5R0RPAoh5fFKqGoI/xvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU4cVFLYA1kbpfg89dkkpDyES2LdTmqHUpPjZvUP8Ik=;
 b=FZTeuH6eX4yic4JqI+gGjh05zPf78CUk/AAWxo2Zu1sWdtu7vrJns9sIgta6YK6jBBEtQdJiExj8mUolxPru+prmJz8WVy8xB4Kq4JbAujYGG2CZ4xjvBmPzZpcGd0SI3zYwKSgCj/4Zr7Wv+kIffb4LCVy8hQAk4V1KdfsC+q0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN6PR04MB9381.namprd04.prod.outlook.com (2603:10b6:208:4f7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 12:12:34 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 12:12:34 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 01/10] xfs: fix the errno sign for the
 xfs_errortag_{add,clearall} stubs
Thread-Topic: [PATCH 01/10] xfs: fix the errno sign for the
 xfs_errortag_{add,clearall} stubs
Thread-Index: AQHcj6boQkApQeDkeEiGmbbkMHBBHrVnf3YA
Date: Wed, 28 Jan 2026 12:12:34 +0000
Message-ID: <5d2b0896-8ccd-4925-9118-8575af25a082@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-2-hch@lst.de>
In-Reply-To: <20260127160619.330250-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN6PR04MB9381:EE_
x-ms-office365-filtering-correlation-id: c3624c5c-4e15-4509-41ce-08de5e668542
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eUVyZ1RGUzJURkNDWWNWTndGTkVQTHF0K1lRUjNiT2QvQ3J3enh6WEI4eHBI?=
 =?utf-8?B?YlVvSWZEbTdkWm1xREZvQXUyMmFOekgwSXRkbytVZkh3eU0xYUlwTFhSSVox?=
 =?utf-8?B?WHlRS3VGQ2oyaG9tMDNiSEZCYVArY0tmZFRtNG4wSVlDVmZOMnlDUE5rTXJU?=
 =?utf-8?B?THM0VVFKVmRMV200cmw1eS93L3ZVbXVhU3BvM3ZIU3YwcmVlUFN0TTlWR1Jz?=
 =?utf-8?B?cUpRT2FuR21OeVd1RWNaUGtrVnd1S2ZxNXJaWTM3WmFIY0ZKN2lpc1lvWGlH?=
 =?utf-8?B?ZGlQT2JVbkxXYXl6d2J3N1IzVTIzL0JyNWJQZ1N0bWI1OUwxcmh6eWViejgx?=
 =?utf-8?B?UHl3RVd6YjFoYUwybUFDTXc5SFFJU0dJbEF6eE1CZ2NwdXUyUjVBMTVVc0hw?=
 =?utf-8?B?MkdqTmlNQlNxb1o2eHM5amZOTjYzNk44RS9TY3dLWU93eFhNT2RlNGY2UGh3?=
 =?utf-8?B?dTFPcWh2eEEvUWlPOFJwa0RUbEdocVVIVUhNQWVuU1NMVTBJdVgvb1Y3bHRr?=
 =?utf-8?B?WEVQYzV2MDNJOTBFUlZMQTg3cFBpRm1DdHN2UFU2Z0J6RkdUZmxFZ0NMYnZo?=
 =?utf-8?B?MzF4VExJYmFEM3BKY0JZUnlkcnpON1FUZGZ5aVorc1Y2YnAyQTZWNGxBQ0My?=
 =?utf-8?B?MTdpWWgvZVRnTUZEclNqNFQ1WGhtNWExbHRUUXUzNkN6RjZXaVBwK2toVVFw?=
 =?utf-8?B?MHJIcllDRWFhK2xkcmVRZU9lUWdsOEl5NXhXcFdneEVlc3hHYXplZGNTbHBp?=
 =?utf-8?B?MW13eVhOa1RiRnErMTV5YTV3ai9zL2wwMzRNeUhhelpJUDQwVE9hU0xmSS8v?=
 =?utf-8?B?eitORGwwOEZRR21saW1MY3J0Z2lPRmhqMkt2YnZoU1FSRUZjN2N2bUdKQzQ4?=
 =?utf-8?B?Q0lBckNzOTlLQ00xdWlxREVrQklGWG50Z2JpcHJiQThnUXRTd1lISmdwT2xp?=
 =?utf-8?B?RTgwdmpOSlF1VDYycnVmNWg4bktQTXJQMy9CVkw3VnRpRDAwdUJ3clg1bzdu?=
 =?utf-8?B?UVlLSHFOVVoxcytQVEhxSlBEWWZVaE42VmllSnhreEFXYTM0cEFKR3YxOXFk?=
 =?utf-8?B?Rk1lREZpaHZZQjJuT2dZemVydE84Wk92N2JQcElYa3d5T2h0OWZHNDlsekxV?=
 =?utf-8?B?bG5ETjFFbk9pRUQ0VTRCM3Z4Y1p0Vlg3TUFjTWo2akJkMTkzSFcrMS9ZKzBy?=
 =?utf-8?B?ZDcvQStiSHZYdzJuNTF0bVpKRUZwclp4a2ExcUlPeVhQVEJ2MUdtK2xMYk4x?=
 =?utf-8?B?QjlNMWxZazl2MVhyOHFMQ1R6cWdTRzhNV1VHM28xR0RjdGRneDVLbnZKRVY3?=
 =?utf-8?B?RUQvdDVVZVlxTS9vaEZaaG0za1lLMzhtbUJoNDV0U3pxSjNEVk5VWWdMNzlv?=
 =?utf-8?B?c0ZOOEw1Sk1mT1dEZXZzQ2dzWTZXSWJUOHZuK1pxOTU1V1hGcWMyb0xqdmdu?=
 =?utf-8?B?MUU5YXZ1bnp0V3pEZWRVYWhIbTlVV284SDBsZUpNaXgxaHJaQllLaXNpc2hm?=
 =?utf-8?B?dDBPcDdycHlEbVJSQkNtRlRiQ0JaZnovSDVYVTVKMU43VTNpM0NhT0Nwb2p5?=
 =?utf-8?B?L1R1WDNmQVV5OGRzY081eVhJNzVpM3pDcnpTSXRHVGFaeDFvS1VPdXpXS1lG?=
 =?utf-8?B?Y2R1SlE0UUZaSWMvak54QTVwK3d0L3NjV29MUk5QUnNFc2JtaUxxRDAraGZY?=
 =?utf-8?B?ZzB2Snl3bG1lMEZ6UXRyTjI4aFRxQnVKSFBtNlMyc29aTDlxTUZBdzNySVpQ?=
 =?utf-8?B?NHZHbDcyV1h6bmJEZllZczZoOTRCcHFPRGt3YTRLbXE1SHdTTWpjbjlud1Va?=
 =?utf-8?B?MlRyM2Faa1FsRzNOU29PUmdzWEtUVElVMU5oYzU5aXlqWEllVkpPUU50RlhD?=
 =?utf-8?B?WXRmNkZ4V3JxbXpXVTF5dFZmNlR4VkVVNEFkUGhSdWJ1MXYzNENRbHVCcHV2?=
 =?utf-8?B?Mk5wYVdOOTdVRTVTMVVKeDM0aFRicTArZlZ5bmhIV2JJazByZHo2bXY4Vk9S?=
 =?utf-8?B?a2tFQ0NiaGQ5S3lwSzhWc1BQZlUzcExQYXhLQ3NyaWkwTC9iK0MxNlZ2YnVs?=
 =?utf-8?B?aUsvVFBmbkpaTE9lOHAxK0NjekVsRUpBdGNSdEdtY0MzOUdXUUl1b1VLMnU5?=
 =?utf-8?B?UEd6QXJMTjhWMmRXc0pJVDRsWG1OYTM0aFNOV0x4Tzg4NU9UblZlRHhwd2V4?=
 =?utf-8?Q?l8Xj8FdC7lTpg1HqTVIF0zs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bmdVMGVKbVRURG5MRDBYbFlBanRxNE4ycE9sMFVYZ3BMRTRNZkFXMXBFSmp6?=
 =?utf-8?B?aFdpNmFFREhoRkY3U0xVWjVDVGgxZ3B1WEdzTWZPVllYN0Q1dzUwNGdndWZw?=
 =?utf-8?B?R2FMR2xZSXU3ek1DeW5pL0grZmEvL2dzTjBLTTNCWllKZS9XajdCU2dpT0h0?=
 =?utf-8?B?ZjIrb0lyVVhKdXV0TFBSMXQ5aHBrR0JiWlNLdE12dytmcHB5UWVma2NEVkkr?=
 =?utf-8?B?QjZhSnI0ZjRFckU0RHNlK2o0MjRrazRsTEFQTnZpaGVESFNicmsyN3BjNDFv?=
 =?utf-8?B?U2huOEJFc2ZEdWZLamczU2ViNUgvbFAzVlRRQnhkYlJLNXVkZW9laXM3ODVz?=
 =?utf-8?B?SGg1UCt0cFloUnMwWUZxOCtlSjN3MzZNOHhGQmV3OC91amxiT0pVNGJUeVpV?=
 =?utf-8?B?N214K2tIaC9UWjhqVVRMNzBoSVJrTitRN3JOV0VEVlhlNlptWStYcERQY1Vn?=
 =?utf-8?B?aXNYY09qTGNJNFJXTUZjVWJ3aEw3RHlQSHZsV09LSUllWVlad1FTcXdVUGpu?=
 =?utf-8?B?TkVHZDQ2VDYvSXVJa2gwbzFVdytXbDR4VDJYV3REMXFlb3UrNmJPQ25XVXpM?=
 =?utf-8?B?ckZnWW4xc0VjZUpTTElySGlPTjZoakpJK0xHUzlObW52cWF1aWtxbW5tOHlu?=
 =?utf-8?B?dngvRU14SUozOGZ1eHorZEhlTWVxRjcvNGQ1WXlHL1F3Q2crTWo4ZkxaUXgz?=
 =?utf-8?B?QWIzNlNsYzduRHZFYlRFWkNsWXZiRzhvL1FkdE83U0Q0YXZvRzdJQXVUMGZJ?=
 =?utf-8?B?U3E1YWpucVM1WGJZeWxoeXJTV3pSaGYvYndrcFV0eDNibjBpamZFanJvU3hQ?=
 =?utf-8?B?SkFrN25wSmpvMXdVMXowcVJLMno1aW1qUUtHdUlEdCtreVdNa0VxMUFKYnVG?=
 =?utf-8?B?dE8wcFBSYkpKTU12SUFHSGNPSXZ6Uk9jcXNHNGluWWkzVFQwZzRIR0JKbkw2?=
 =?utf-8?B?NENqTEVoeTBWWTkzdTU3a0JOSnE5c0tWS1pWc3g0aFlDWWtrTE5UZDNDMERl?=
 =?utf-8?B?WGJFQzR4NkluNmsvQmhUaU1yMllCbURjdlEzT2d2MXhzQ1J1TUFjWnovTmpN?=
 =?utf-8?B?Q1FHTUVIeGlXMVA5YjVXVWZQelVpcFloTkI2a09pckpUSVUxMHBrY0lEQWEx?=
 =?utf-8?B?K3lpS0tEd1o0ZzN1MFBnb2dzSUhvbmF6TDBLZ3VRaFB4YVNVeE5DdEtlYmdy?=
 =?utf-8?B?UlpxZEtQRjhsd2IzRUMwbGlvT3ZlclBXWWFwcmZjMFVtVExpQnV6ZFl0T0Vq?=
 =?utf-8?B?SDkyZzNvQ2Z6aS9LL2JHRWVyQWJIbjJSS2dGN3N3R1Y2UTUxbkxmb0tYUzdR?=
 =?utf-8?B?cVpmTS9NVVM0TmtYU0RlVTBtUUwyTkFpc0E5bXdOckNqclhuMnB5Zm5SZ1E2?=
 =?utf-8?B?cGt0bFhFQ0xwQjhKb1hPRXlpMTB5ekYxZGdPVW0zenYzM2JGcFNEbjRJakYy?=
 =?utf-8?B?VTVIQUVOVFhQOHdjYU5ZSFV4S1pnY1M3NDVsYmVDMThaOFRTYzF3ZzJHSDFq?=
 =?utf-8?B?MkhzMWVuRUFpUWZ6Ykdkb2dZNEloOFl2QW1IK1B3dGhIZEpaUHp6OXY1bmRw?=
 =?utf-8?B?L1F4b0dKajFhNjlSRXRLODJtWFExOUQ2Z0hweXJLT2UzR0F1akcrenlMNWVW?=
 =?utf-8?B?WDZDcFI3Z3g1STlHV0dveHhBRUFObjRXYjRCdDBTZlM0TkpFcmtQRFN0dlph?=
 =?utf-8?B?cnRZMUNkWGZtVllBZ3pSMU9UVFpoYTZ1K24vOHBKaVh6OG03bUFVeGRsNDhi?=
 =?utf-8?B?Y3dMSlk1ZWtjRkFRZUFRM0NRZC92NGlZQmJsT0JVY2VteVhDamQwWWtDMmFi?=
 =?utf-8?B?YUx1TFIycFNtVnZTMVZzYTBCbGNZSGl6cG8wVmkyajJmV3lMS3JNM3ZnMzMv?=
 =?utf-8?B?cGhSVzFMVm93cFQ4UW14K21OR1Mxbm9vWVZMdEpvWktaL2pQUkJJdnpZbEdn?=
 =?utf-8?B?YlZ1ZkRtQjFYS0cvS0JBZUJoZy8ybWtxVytzb1MyZy9ZWVZ3MUtiZEdZRXBW?=
 =?utf-8?B?TGN2SU1tNWhPTVVybHBJY3pRYXNaNnlBTElmMFZlWVRzUTY3OFNhMGtsUjU2?=
 =?utf-8?B?MnFEVUNtV3lMWXBWbUlQaWN4N1RyRTkrSW9aRU5YWVYySUU5UWRPSWJreHdW?=
 =?utf-8?B?MGRBeHA1c2pydDhnd21yc3diTXdkUGcwaVV4NnpMMEtpSVdNaGVDMnFIS0lQ?=
 =?utf-8?B?S2k3bGtkOEZ1a2lrSEpHRUE2OG9iNTVUTmQvMEF0WERBTkxmNXk0dzZLOTVo?=
 =?utf-8?B?OHdlU0VwckhadmtwWDZpdmVVa1drZmM4N0lSb3VJV3dqcExUSUJNQm9ySXRL?=
 =?utf-8?B?T29zZUdFTkszMU1Ja0pJemRvbzVGaE54dWlKZ0hyUllNQmxZdkZPd3E4VGVt?=
 =?utf-8?Q?EOKHZZiqNkxQApjA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EA056FA5E43FB4DB9339782E347F7DE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LlbmocAkfmSeq1LSxaRWcRwzCSwXf8yilPBkZkv/K7KPnazpSVNDg48w99MwF0fiKxXx9WCcAv6t2Uk55TI15eN8cVXugvkY+DxdfjDPfz+cqlw802IUs0M2ss17FS8XGpymJrbMiGTwFhGwWhaCOuV8jhQ1NG/teq9ZCk2vOpFHdq0rJfB6CqfLqphitg7T1ZINpqDv2+wEE5LN/VDnE5hmapORJ+BA+jrrQWFO7uFuXfqqyLTd+Ik2UEJi09NaDqNnm1xgM4PHeF0gH1n1MxH7pSYbJk5+nEtRxFvB0LrUGNyjeu+QM1s7aWOYKlWZSVT8SoJklBjPRM4uMTTWBMf+/Q9znrQ9A1GPMW5KN8c6762A9Z6sVq3IWCf2v0Sy6klAtSvKpoZUiPajJeu9tUBNrjoH5pYfowl9gSfO2+troHqDQFk3E9RzQVBBbd78Bb+6jSH/yfLfbU/k/qnnvaVXIL4Qgd9j6/04ho8wvMCeOXcFVFOP5SbbM4eDe5NiqaZeONJ3x4N2NT4DvjiWECpoGxpsEmZKix8/pVd0OBqVq+Dg5nNlhTwhTrDA5DWVOczC9SGfl5Q9UgrTrsFbQb28jlGqLfx1ak8ftH+HNVIDIobKArYCiSExpPlNOxs4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3624c5c-4e15-4509-41ce-08de5e668542
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 12:12:34.7586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StElJ9GZe6oAMWJXcPNWw6xqaYkMfuVMGIw+ZK1NKL4SarYvcitU8MrNkVzsxiyHeokzlRtQtpiEgh4z1AfMEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9381

T24gMjcvMDEvMjAyNiAxNzowNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFsbCBlcnJu
byB2YWx1ZXMgc2hvdWxkIGJlIG5lZ2F0aXZlIGluIHRoZSBrZXJuZWwuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMv
eGZzX2Vycm9yLmggfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19lcnJvci5oIGIv
ZnMveGZzL3hmc19lcnJvci5oDQo+IGluZGV4IGZlNmE3MWJiZTljZC4uM2E3OGM4ZGZhZWM4IDEw
MDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX2Vycm9yLmgNCj4gKysrIGIvZnMveGZzL3hmc19lcnJv
ci5oDQo+IEBAIC02MCw4ICs2MCw4IEBAIGludCB4ZnNfZXJyb3J0YWdfY2xlYXJhbGwoc3RydWN0
IHhmc19tb3VudCAqbXApOw0KPiAgI2RlZmluZSB4ZnNfZXJyb3J0YWdfZGVsKG1wKQ0KPiAgI2Rl
ZmluZSBYRlNfVEVTVF9FUlJPUihtcCwgdGFnKQkJCShmYWxzZSkNCj4gICNkZWZpbmUgWEZTX0VS
Uk9SVEFHX0RFTEFZKG1wLCB0YWcpCQkoKHZvaWQpMCkNCj4gLSNkZWZpbmUgeGZzX2Vycm9ydGFn
X2FkZChtcCwgdGFnKQkJKEVOT1NZUykNCj4gLSNkZWZpbmUgeGZzX2Vycm9ydGFnX2NsZWFyYWxs
KG1wKQkJKEVOT1NZUykNCj4gKyNkZWZpbmUgeGZzX2Vycm9ydGFnX2FkZChtcCwgdGFnKQkJKC1F
Tk9TWVMpDQo+ICsjZGVmaW5lIHhmc19lcnJvcnRhZ19jbGVhcmFsbChtcCkJCSgtRU5PU1lTKQ0K
PiAgI2VuZGlmIC8qIERFQlVHICovDQo+ICANCj4gIC8qDQoNCkxvb2tzIGdvb2QsDQoNClJldmll
d2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQo=
