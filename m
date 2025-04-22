Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5746281378;
	Tue, 22 Apr 2025 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745325068; cv=fail; b=hdn6FnhMC69CVxwlmfgu5+d2zIk65+bDH80ryovcLh23De3e5QlNkGydiBvT8OXIIf5hkjt6Lq4vtCrspiitQYhs9f402m3Y2Opf4xA7seGlmanh8LnSn2ATMK5SbG/v18fFNImnXArJuR7yfS2JaCigXfJdbvOEQPOHNbdyqxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745325068; c=relaxed/simple;
	bh=nLCmMX5+4AmzY30cm0OpbZvlBcLjJiMMLh+fgg7cBgI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eCUQpbY3GA+Xme6pzSL+aDf0rQ8i3R3UtS1uESO7KqnLCpCYgMTMbSrZ4sKlcCv0LB/mskpzAwwfSj5eWZTyEAgIi3zIi6oqX4hPtrjuFeLZzKF6wFjfoMu+WXvFyskuN51+TiEIla6xE/9j/YzndL7+yiG1kolsTQoR0KLzF6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YFwR14P0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rAJkw3xN; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YFwR14P0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rAJkw3xN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745325066; x=1776861066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nLCmMX5+4AmzY30cm0OpbZvlBcLjJiMMLh+fgg7cBgI=;
  b=YFwR14P0eyZYD6em6Y1iKOXrPu5plEm/8QU1sa22RQNjDt6OVdwkcq7m
   XrST9HrGhmcWdsjCt3azBdWTG7PmVLLYHIxS1sHIzj39d0yHtdJRegZxr
   Kq55wiP/n87UrKWXPdaIThYYuVEl/RAnGbL6S/lj2SrcD6sFQ7a5bukZ4
   moNRS8wCXKNCKlz/kofPXGJBx3aRe+n96g6G04Wvz5RFP+pbniA3W3tjf
   y4EDiFfd58XIC942Pjy5QtdlYgTaNQT1+e24NM3pkRyB3f8FMudkaPZvh
   9cQa9OvsJvC9uYgnO4K/uP4NrhtQG8+vOOFzPqPj3X4biw0M8EzYTG+j9
   w==;
X-CSE-ConnectionGUID: HmtEW2AfTYy7n1iBWpE1pA==
X-CSE-MsgGUID: UpTD4M5yT1KY2BwZH3spfQ==
X-IronPort-AV: E=Sophos;i="6.15,231,1739808000"; 
   d="scan'208";a="77445686"
Received: from mail-dm3nam02lp2045.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.45])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 20:31:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e/Zd94/WX4+a47LjR3AR/IIkD1IltH0pUFzIz+QjvpSQcr57vULOS1Tvb5wvpJPuie0ipMZqmKP4kjxb9/OxdwLnmAwIZsPgGi/6RtFFjlLs9oz/5jbqxIuq73tquHpBOtVTQaILskug+4/zSc7BnwuZD0StpSqE5SFagn/8jFpZF3xja+x06/oewYhz0SINslMVUaEM7aZQLMuiEJjhsP9/GRhvXp3NEW/VdwnEk8KVgOK7sxerH/XI47ZdF85X1x8oonUo+LPj2wI40EP8smyb3dpZWTPWrHzOaA+OiRpSPGg0CA0/44ZadZkOckOQqltp1HH3a/LHy7QKFBpoPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLCmMX5+4AmzY30cm0OpbZvlBcLjJiMMLh+fgg7cBgI=;
 b=sIpfSD7Viw7CFAhVNrWvJy5UksixX51Q4uzHzJXBCIXXvJDWawMiz3q7ASQWxOQzgN+8LcZIBg6xmBegpntQ8KO4nUmTgDPvtC+2gP3P8svcn97Fh6RjSx9vTIeFiT/zBZ8hbL+mjfj5RKpXicf04uC0iIAHZlmv+22fJVKwwfEQrWnnqLTpKwlmHbn90DXs8daH7cGEh06bnZUcaGFs78UqJ9SB1STAGOTfXZynf1HaNG97+joIjjBe4LhGs7AtbmCxiCOAiZcN1lSfIYJoZwRmnLWjOEo9lLpV92KdZSVLyiU8zAmB/9253ghNxthT6YLhHXa4qN53wO1JXGhldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLCmMX5+4AmzY30cm0OpbZvlBcLjJiMMLh+fgg7cBgI=;
 b=rAJkw3xNU9Bj1CobnVTziHkIIczGqvA2kVuzsSKI3JQsgyPaLAEiqa/PuzzXhg64s1uLWaZta9FmcTguIHQXgyZkpJcgqZR0wAv+GxnRoYPwRzXUeuJUorAjRRaF0VHCmUjfA4JbWeVJhyEgr06DgsYusKNeStfzeewV+QodchM=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by PH0PR04MB7496.namprd04.prod.outlook.com (2603:10b6:510:56::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Tue, 22 Apr
 2025 12:31:01 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 12:31:01 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "cem@kernel.org" <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
CC: hch <hch@lst.de>, "linux@roeck-us.net" <linux@roeck-us.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH] XFS: fix zoned gc threshold math for 32-bit arches
Thread-Topic: [PATCH] XFS: fix zoned gc threshold math for 32-bit arches
Thread-Index: AQHbs3uoYonrpB7QzE+U5/OKs8niQ7OvndiA
Date: Tue, 22 Apr 2025 12:31:01 +0000
Message-ID: <fb6536ec-244f-4a90-949d-ddff7f15d18b@wdc.com>
References: <20250422114231.1012462-1-cem@kernel.org>
In-Reply-To: <20250422114231.1012462-1-cem@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|PH0PR04MB7496:EE_
x-ms-office365-filtering-correlation-id: 66a53755-1dcf-4acb-491e-08dd81998ad4
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?utf-8?B?VFJ6eGh6SktJRUlITmtBZzhFVk1XMFVIOW1TL2JVUzVrUFlTVEdicUpqT3lZ?=
 =?utf-8?B?NFNFNWlMT0JGOTFLREo5R1ZYbVFWTlZseGtGU0t5Y0xIWjRCSjZDc2xOT2U2?=
 =?utf-8?B?ZDdxNVA5b0JPQUFTMDkycFRLaDNHSkNBQ2NxekduNEIxaFBFTUxEeHkySmc3?=
 =?utf-8?B?WXVGcE5MbEhYaUpZS09rS0wxV0Y4SkdLdVhtWW5hWWRkM1p2WldTc1N2R1My?=
 =?utf-8?B?ZC9qNXRRQkZJTXdwelZSRkk4U3crekVGNnh0cVJiMUJldkhxZ3NXYVplRUVy?=
 =?utf-8?B?QTVZOEpURkpJQytDUXYvSFplMitYZ1ZQMmt3Y0krR2xsQ2VXbjRvbUp1QWc5?=
 =?utf-8?B?d0YwREhxZXpNRWxEWmRNdExVK1Q3SEV2Nmpndmg3aUpRWWxGRTRFb1BuR0U3?=
 =?utf-8?B?V0U0V1Q5SkxQMVg3aGsxeWc3aDNQeHVqQWNDb2hNZ3lOcnl0R2FxY2FseHNN?=
 =?utf-8?B?RFhFZHlpeTlEOFFTU1VvNENjbURkNmVtamQwaWpNZlIxemNCOERJZkh0bzJ0?=
 =?utf-8?B?WWk2anBGY1AvbXJJR2ZtSXIrUExVQkMzQW1ibDVlcEluSHlSbkVhYjFEV291?=
 =?utf-8?B?RzNIUWlkcTlIYkxqMmZ4UEZobDZSV1ZOaEtSRGltektmaDNvc3ZKME02SS9y?=
 =?utf-8?B?dWtpZStqZ25vaXMvZEp5ZWp6MmM1RFlsNzVUeGxwK2puVWZHMFk3WUcrclg3?=
 =?utf-8?B?bjE2bDUzbFZseEVaTTVDMnE3TDgxdWJKQkNKUXdSdUE3RFMwa2xMM0R2NnA0?=
 =?utf-8?B?Y0s3YjdBZHhQK05LTjdOeFptczhHWFNES2pnSENPSjJISHU5R0J2ek1UK1dv?=
 =?utf-8?B?cFhrdGd0T2hQTHlPdS9VSWduQklYVE9vWGx5NHA1cjZIQWdYckRJUEhQckYv?=
 =?utf-8?B?RDFXVnlYR0wwQ2pFcGVkYWxBRkt4d2FqaWkrZGhBSHBqRUZKRXFwV1BWNW1N?=
 =?utf-8?B?RGZkSGdUaUNIbGJSSG1pZWcrTGJUVGFDd2tVb01aVmRpdHBzcDNQMTN0Y3E0?=
 =?utf-8?B?bUloMnlFYWsrNCtKdklYa0d5OENSYktxR2lldGxoVVZXUmlTbk1uazNUWjMz?=
 =?utf-8?B?czMxRFRidy9LditnTGZQbFFJMEFvc3I1blI2SkZWVnllTUM3bzNzem5uMm9Y?=
 =?utf-8?B?R241WHpzZFBWK1MvVWZwODZiNGFSclVYMGM1cStLa05kTlROVk43Z1RuMGNP?=
 =?utf-8?B?N0cyL1JXOUxvOGZzR28vSVo5Tk56b0dHbHE4QUYzWXRqb0RMY0FDRHllQW43?=
 =?utf-8?B?enlUZXRuWVc5NTJ3UFRkMnl0d2RrUU5VQVgzbTgyM3UwSmU2MDhObVB5QVNj?=
 =?utf-8?B?Vi9CY0pCbU5HV3dNYXZyb3gvVUxsWjZzekVpOVlYREh3Ym52aGJrUlBhc1g2?=
 =?utf-8?B?czdUMGNVZTFFM3F3Mm5LcDdHZm11Rkc0UTNmOFJ4WkVncjZ4WFlNdUJYVmtq?=
 =?utf-8?B?U2FkUjVQeWNxQWlWbEl6Q3JvbGxOampSMlJ5bUF5WG5KM2RyMXlvWDlwM0cy?=
 =?utf-8?B?RXpCZjlweVRtME9RcGcyTWJVZnJmV05oeHJ4RHdVUVpqN0RFdnpVYS9IeTdU?=
 =?utf-8?B?Q09UV0FZMW4vZWdwU3BMSGJMd2JTNFNKdytWMnRYWVh3M2t1N09ZU05NVmh3?=
 =?utf-8?B?QnFEekdoZmRUdjhIanZzdjZjTkd3Q1NiRncrcGwwcGd1dGhlcVJTRXdlUXdt?=
 =?utf-8?B?TExTNFUzUFB4T2xTUzllT3FUdFdhTlNBZ3VDRnEyeXFwSS9KQ3pEMDBQK3dH?=
 =?utf-8?B?WEsxYjAyRUxEKzRIQmtMTDlYRnZSUFZmQkM3L3VEeWRaT1htZWdNdmJ5RXB3?=
 =?utf-8?B?MkM5c3RKMEQ3M3piSlFsLzlaNGVTdC9laEZuV1R6UktEZzNaSDc3ZVl6bWdT?=
 =?utf-8?B?eGZSUTh1cHQrZWdkL0RRREk1UFFJeHlWZmNqVHZsVkFkMElPRjlKaFdtQzIw?=
 =?utf-8?B?K1JZMHdnbUlraUJUQXJkQnJIUTNTK1ZaTDQ4RnVVZHliQXJMUWdHS0lUaHpQ?=
 =?utf-8?Q?vy1GLJLuNouWLJNlORlroPldv/Bmpc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b01Oc0U0SGlscHBKQy9PRENkSG1GQUNqRGJvancvK0tEVStkSlVYcHRpc1da?=
 =?utf-8?B?b1drc1A0aFZFQnZFb0E2ZHZSV0hsL1JRbFFTUzJRNGlMdURYbTdobG5ySHg1?=
 =?utf-8?B?cEpGb2JaeHhnalIrdExSRE5nck1yTWFwV1ZEc3VEeEZkditXaktwQnk0TXZZ?=
 =?utf-8?B?U09VeTdwcThJa3F6Y3A5UnBQeVdtN2xaSUlxQWRMQzBiazk1NkVzekRaeTI5?=
 =?utf-8?B?TDVrSjFkQytWZ05rMjh5RHFWSmxvakRmaWY1aEtDcXpIWCt2b1VtQ2FHS2RE?=
 =?utf-8?B?ZG92ZXA5WjFSZUVGTWlZUGlXekd0VVBRRjNxNkptek5ML2Q0Q3h1aEFxZGox?=
 =?utf-8?B?NlVkSVpDUTJSbWNVYlkyb3VzV2V5UGl2anV5OW5TbStyWlU0emNOSHNHNGhU?=
 =?utf-8?B?NUJCOG1udHMvUzZJb2FRdzMxWmpUdzFkUW9SZHhid1UvNk5kZXRBajI4TTVX?=
 =?utf-8?B?b2ZzS2JPeEhORlBzUnpkcEUyOHdjcEUrcklRWEJuNitnRkRjYll4R1VoTWxB?=
 =?utf-8?B?MHA0OSthS3k4a2NlcEZFOG02c2VuUnZ2amFibkc2K3J2Rkl4bW5GWHJVOGM1?=
 =?utf-8?B?Mmtoa1Z6c1R3aDVnaWpBM0RaajV1cXY4UFJjRkhKRDJodlhueFVjRk1YMHBn?=
 =?utf-8?B?TXpnTUJtUkVaSzRtZ1hTdyt3MTdYNnhJVjhkd256NXI4YzNwcFgzVWRCWHVL?=
 =?utf-8?B?NEdBYmhHTjY1Ymphdi9SS2k1eHJjSlRqTlpQVXAyNlA5VG95MjI3TTlRU1pJ?=
 =?utf-8?B?S25IbzU2eXF3R3BKSVJCT0pRTlByM3dxMjZwdkltcmJiRFh0akUxbVp1Ui9S?=
 =?utf-8?B?QUpzVGM1N0pDNDlLMmVCS3NRdDJhN2IrSXk5Qmg2YVpncDJibVJOeUpwK2Rw?=
 =?utf-8?B?cjhsQ0YvOUdCU0c0eEgyTTRHR3NVRGk4bG1XZWZiUGFNS1d3dU5QUFF3T1Yv?=
 =?utf-8?B?YXRmdm9oZXZRamhiNFIxM0dLbGEvdFRMYW4rT1dwZzg0RVZXQmFyNk95NFV2?=
 =?utf-8?B?R2VCYzBMYTZ1MGttTVp0V0FPQ2ZpVmRzWDl0bnpNdi9Cc2FTVk9UcWFFRWhw?=
 =?utf-8?B?dzN4VmVXNFNtUW9NYkQzR3lTVG9nRXplZU1xVEVnVmd5R0RRaThPN2tRcjR1?=
 =?utf-8?B?VlZVWm05WTBZbm9QT0RMOVF1d0t4Yk5tcVVHQVgyZmw5TWcyamhTNkh0UXVW?=
 =?utf-8?B?T3FiY0o3TmF1OUFka1Q0c2Fyek9SSmkybzEvb2luU245NHZIVjIxdVpZSGtn?=
 =?utf-8?B?ank1WGxrWVllY1dhVFNaZDB5VTBWQjQrUXY1OEVuYzZuYmNiK0g5YWc0cHFQ?=
 =?utf-8?B?bWhzNjJZQmNOYUZFM09zdHpmK2V1ZVlvQS9WUHlaNkh0MjhVejNMMWk5dEwv?=
 =?utf-8?B?d09VZFc2S3pwL0JqSHRZZCt2VmxrU014TEdJYkU4NVFOVG9uUWllM1B2OXBh?=
 =?utf-8?B?ODdBd1pmc2ozZGRJY3N1S0xoSjR5R0VzUlJkOGl6OGhLZDhxRDlqVmxXYmZS?=
 =?utf-8?B?M0c3STZiQVdETlJoaGdRQnlzdmNSbUJkdzVRQTV1N3dSUmZ4ZXQ5QU5tbHNx?=
 =?utf-8?B?VVJnMkVvMnA1dy9Id3RZK3Nsa3FYbUZHQXdZbDNtV3N1ZWp0eDVzemp0WTc1?=
 =?utf-8?B?aEtpb2xUVWVFb2kxUmJManlYRFVHUkl1UVVTUzJQbjlUU3FCU3RLRVB1MURa?=
 =?utf-8?B?ZFJnSVhMNzM4d1VBSFNJdXRaRjl4bkZ2WUMxei9VYlFTQ0pRWDlsYWhuRExZ?=
 =?utf-8?B?aVBYMzczSHBCZWNPN2ZQanFoZDdJOXRrTjR3VDUxN1Rycjc0T09kQUtXWFZ4?=
 =?utf-8?B?WUNOLzVsSm9MU1M1YjJBSkVvVm4vOGRUa2VRS0x0L1ZtbERUOWZsb1IxVTh4?=
 =?utf-8?B?TWlzcGFTL29sTi9uNFd1alRjOWg2K3NSejlYZVNaQ01lUEM0Y0tsaGI3VWxa?=
 =?utf-8?B?N0FRNlY1S1FpbHhKU1lLcTZ0NVNlQWtwWVpibnBOY3YxZVhFeC9YNkk1eXZn?=
 =?utf-8?B?b2Jic1U0d1dVL2hoZkNHZlcwMXkvamJTaHE5UEpFcTN3UTNwUHlXb28zbzBa?=
 =?utf-8?B?bVVzV0lZelpJallka2dSdStFTUhTbXRuSWRCMk9xUkVJMU5hdUVKRk5jZnla?=
 =?utf-8?B?OUU2dHZROHdzNXVyY0d6UkYydU5lMTZmNW10VkZ3THJBQ1BVSUMwUUtaUC9m?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5EC443301ACB4791CE050557167B2A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xD3WSyk03Ilj6j3M0p7rMt1SOeQzf0iB7exp6t+pOkP6j41OfrGWAOCiMXIxKz3q8BiTS329Hv6PeOsT3T4x7miIJ4BF5cVZlKOT4g5gsT9N1Scbs6kE4nyJyX1dfwcEnEf1qzqXemXFUrvN2rYlVxvq0kiXOlCcR3fmAaeZdYZb1V+2yxy/zRsmWBSj/ndLiJQ/CfpXxPQ6GNkCzPFmqotSSrvT4WtD8PFrkyotrRoyZANE7602wHRC/9sDvfSV4VFuQier8yCu/Rd16++x5POveVSJhpY3jtUeGSUqC1JK4BRFcI6Ld6hUXjtry150iKjfCG6xaFZ4WyeyRiZ21adCW+GOrG/8B0dwCJhYXdqpqOgEMWRwwtGkAWOQS3sdw+0Yz1OoYs300ac9zY16R5Zxvys6DgT8q7iLpmAXFz8BDoNKzWoBwN1kE21RIa6CF5n+tCL5D1ZUeYHj2JDGDWHC4BWn7VSkMczYNv5dmljyrxKDw0/Lpy1oMNjZ8+QxYx3dx17yTPXmwxx4WXh6DpUUnxsIyg4tAaunNAONz5l85TJ2ibPBDkq6m/vWAocJ3I2Tw4QzLUctxiCwU13ZGAvTHqQV4ukG41/rR2ZbI6CVuTJaDzSsr2dSYoIuCccT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a53755-1dcf-4acb-491e-08dd81998ad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 12:31:01.5297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wLcGrEPhKkpZJWndPk7brJueoSXT+WXfC0kH2hxFLUm+iiwXkj7SswahlBgI6qmjO9pSuiRTCvZbzMzI29lqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7496

T24gMjIvMDQvMjAyNSAxMzo0MiwgY2VtQGtlcm5lbC5vcmcgd3JvdGU6DQo+IEZyb206IENhcmxv
cyBNYWlvbGlubyA8Y2VtQGtlcm5lbC5vcmc+DQo+IA0KPiB4ZnNfem9uZWRfbmVlZF9nYyBtYWtl
cyB1c2Ugb2YgbXVsdF9mcmFjKCkgdG8gY2FsY3VsYXRlIHRoZSB0aHJlc2hvbGQNCj4gZm9yIHRy
aWdnZXJpbmcgdGhlIHpvbmVkIGdhcmJhZ2UgY29sbGVjdG9yLCBidXQsIHR1cm5zIG91dCBtdWx0
X2ZyYWMoKQ0KPiBkb2Vzbid0IHByb3Blcmx5IHdvcmsgd2l0aCA2NC1iaXQgZGF0YSB0eXBlcyBh
bmQgdGhpcyBjYXVzZWQgYnVpbGQNCj4gZmFpbHVyZXMgb24gc29tZSAzMi1iaXQgYXJjaGl0ZWN0
dXJlcy4NCj4gDQo+IEZpeCB0aGlzIGJ5IGVzc2VudGlhbGx5IG9wZW4gY29kaW5nIG11bHRfZnJh
YygpIGluIGEgNjQtYml0IGZyaWVuZGx5DQo+IHdheS4NCj4gDQo+IE5vdGljZSB3ZSBkb24ndCBu
ZWVkIHRvIGJvdGhlciB3aXRoIGNvdW50ZXJzIHVuZGVyZmxvdyBoZXJlIGJlY2F1c2UNCj4geGZz
X2VzdGltYXRlX2ZyZWVjb3VudGVyKCkgd2lsbCBhbHdheXMgcmV0dXJuIGEgcG9zaXRpdmUgdmFs
dWUsIGFzIGl0DQo+IGxldmVyYWdlcyBwZXJjcHVfY291bnRlcl9yZWFkX3Bvc2l0aXZlIHRvIHJl
YWQgc3VjaCBjb3VudGVycy4NCj4gDQo+IEZpeGVzOiA4NDVhYmViMWYwNmEgKCJ4ZnM6IGFkZCB0
dW5hYmxlIHRocmVzaG9sZCBwYXJhbWV0ZXIgZm9yIHRyaWdnZXJpbmcgem9uZSBHQyIpDQo+IFJl
cG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4gQ2xvc2VzOiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjUwNDE4MTIzMy5GN0Q5QXRy
YS1sa3BAaW50ZWwuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBDYXJsb3MgTWFpb2xpbm8gPGNtYWlv
bGlub0ByZWRoYXQuY29tPg0KPiAtLS0NCj4gDQo+ICBmcy94ZnMveGZzX3pvbmVfZ2MuYyB8IDgg
KysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3pvbmVfZ2MuYyBiL2ZzL3hmcy94ZnNf
em9uZV9nYy5jDQo+IGluZGV4IDhjNTQxY2E3MTg3Mi4uYjBlODkxNWVmNzMzIDEwMDY0NA0KPiAt
LS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0K
PiBAQCAtMTcxLDYgKzE3MSw3IEBAIHhmc196b25lZF9uZWVkX2djKA0KPiAgCXN0cnVjdCB4ZnNf
bW91bnQJKm1wKQ0KPiAgew0KPiAgCXM2NAkJCWF2YWlsYWJsZSwgZnJlZTsNCj4gKwlzMzIJCQl0
aHJlc2hvbGQsIHJlbWFpbmRlcjsNCj4gIA0KPiAgCWlmICgheGZzX2dyb3VwX21hcmtlZChtcCwg
WEdfVFlQRV9SVEcsIFhGU19SVEdfUkVDTEFJTUFCTEUpKQ0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+
IEBAIC0xODMsNyArMTg0LDEyIEBAIHhmc196b25lZF9uZWVkX2djKA0KPiAgCQlyZXR1cm4gdHJ1
ZTsNCj4gIA0KPiAgCWZyZWUgPSB4ZnNfZXN0aW1hdGVfZnJlZWNvdW50ZXIobXAsIFhDX0ZSRUVf
UlRFWFRFTlRTKTsNCj4gLQlpZiAoYXZhaWxhYmxlIDwgbXVsdF9mcmFjKGZyZWUsIG1wLT5tX3pv
bmVnY19sb3dfc3BhY2UsIDEwMCkpDQo+ICsNCj4gKwl0aHJlc2hvbGQgPSBkaXZfczY0X3JlbShm
cmVlLCAxMDAsICZyZW1haW5kZXIpOw0KDQpIbW0sIHNob3VsZG4ndCB0aHJlc2hvbGQgYmUgYSBz
NjQ/DQoNCj4gKwl0aHJlc2hvbGQgPSB0aHJlc2hvbGQgKiBtcC0+bV96b25lZ2NfbG93X3NwYWNl
ICsNCj4gKwkJICAgIHJlbWFpbmRlciAqIGRpdl9zNjQobXAtPm1fem9uZWdjX2xvd19zcGFjZSwg
MTAwKTsNCj4gKw0KPiArCWlmIChhdmFpbGFibGUgPCB0aHJlc2hvbGQpDQo+ICAJCXJldHVybiB0
cnVlOw0KPiAgDQo+ICAJcmV0dXJuIGZhbHNlOw0KDQoNCg==
