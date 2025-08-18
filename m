Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8571931E105
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 13:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522365; cv=fail; b=EbQnbCkgU9z2QclGHftAEyNTOCuyRtDbh1mLiP2rU6Po8lP9t0vgH2c0zx/9xv9AoOEQtXJckHzeCrmAA7HdeeE9DfeC+a5pdm6faYkWKIQx1weODcRCHZwH7/WbqVTWipAe7vJaeR7ftf9RSJxXfRkbx94HL58PZpkoHd7tRUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522365; c=relaxed/simple;
	bh=HBIQ+lIfmgxccGnymdDE9SFksuVejiDZ1YwLw5PGx2w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GBEmnDlZCvX1juDFgQdhZkJzzs1JrWgT2NJx+Nk0h8hM391LilqINpGTgJxS/xL3m/iFyyDLZiJ5gnh1D9/QUK3akEYF5nZdHPpCCjhC01w2uWKdTjDvc5He2eNg+ThC5V6yFoyxh47z/gNZzjG0f4n+wKKlFy5kYeZpH9LZ8RY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QN8X2xW+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=wX7irvzt; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QN8X2xW+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wX7irvzt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1755522361; x=1787058361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HBIQ+lIfmgxccGnymdDE9SFksuVejiDZ1YwLw5PGx2w=;
  b=QN8X2xW+30LwIperByz3JGTIQR/kvQg+hdU9PZ/OlM1BA5SV+FqiKA0D
   I1NLfO+51JFp6mpkPVbVHWQuw68T+CQPXljUrLA9URkWgZjEqV+Vrbc/t
   LpoZYalyjoU4dQHlKiL7imY+ogOlXMWuTGNK5ysBgUWDRYwtB2DduQPQm
   sa8fofC70PzfuJVXz1Ryus6AATsLyRO02e25XF5+cPGF2hO4LoN5lAUZm
   uWJNYxzwLS+QCZbA9abJivdEyxbtK2/ZDlM6i0jI/Yly2BTUWAfP81he0
   BhOEGR/z1EsEl8OCGdL78WCiLWf690zKdhO/qAcWRDnR+0CV00ZZ1VdN0
   A==;
X-CSE-ConnectionGUID: rX04qP8vTmuKO/CvV75h2A==
X-CSE-MsgGUID: q7lne9S8T7K7u2AW0gHX6w==
X-IronPort-AV: E=Sophos;i="6.17,293,1747670400"; 
   d="scan'208";a="106043420"
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([40.107.92.43])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2025 21:05:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gmyPAYW/BgAE1S27PfzBfRSibN24mUEVaxbeNJB7x87QSYrOWmsZEsZTSjp8PjQtjR8h68X6gHkcpSrmJ9Pmeilqdm7AJUB22wtNQWj2pgaDFnXlJMwVhqq/hFGq2TV3zfen+O+TE/A99Ol/0I1cRrBJOcj4Y3Tgv4K7rbKm60+fyhPhKE0Bq7gmPvPFhfWRWgM64r2/sEQQTTNIIkfvMQRte4GDzYuTOEbXzBFtHsUNTH6q10xvyDWVJZSNHZFrj17moZGr5StTCtHcqEq/KxiBjMyHXU1/LmfH2Dsg2M21D14HgJ0W8c8LPZpIUyLheeyWAM+QN9Z7DS8YDa34Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBIQ+lIfmgxccGnymdDE9SFksuVejiDZ1YwLw5PGx2w=;
 b=aoLHaC+V4uZa2RTO7uJ/+dG2u26rmN0VhMxnMRe4Gcg/9x9vf1CksgxTZiVE/rYQbgQNize4vOmipinHHa4qhMgosWtFRP+mbPwsLdDTFxOdxvyJ7y7OIch3ZdgKNGnoxdVLT/6m67jSRlyPLiJrQw8lQqDdLvgSsgR+mwoXCRTXccm/ONhLLfmhfRUIqOHG1sF0wDHGVyp6ohqjsZKYHuBDDOV2vxuJuFfhrJGYALCHirmeCvI1IbllSgBmj3e/5O0jnWb0LgSHTcpLebObA1MJnLXtFU9C+1+fuSftlA7SP1fasJSdZHFZfkqApqd2ZkfSrXfSVJ/U0dRv1I8q1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBIQ+lIfmgxccGnymdDE9SFksuVejiDZ1YwLw5PGx2w=;
 b=wX7irvztWvsrEyg1kqiEDGlwxlWL0ViZpiLqjMdtIC/dVF2hRjjFmcOVZWsmvsjIslwYpYMzeGmIYvd+HaDttQOqxKp9Az+YsOyeS22EZCGmLoXc1J8OU3yuuPjjuCc88W6GQy27N0AWLgdXcRuc9WrR6pBXOztjX0QuRqneHew=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BN0PR04MB7984.namprd04.prod.outlook.com (2603:10b6:408:157::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:05:53 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:05:53 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: kick off inodegc when failing to reserve zoned
 blocks
Thread-Topic: [PATCH 2/3] xfs: kick off inodegc when failing to reserve zoned
 blocks
Thread-Index: AQHcD/4FQwDk690JaE+TVG8Zcqu6vLRoYaoA
Date: Mon, 18 Aug 2025 13:05:53 +0000
Message-ID: <38e03051-f89a-4f4c-a145-d0893d4e7cbc@wdc.com>
References: <20250818050716.1485521-1-hch@lst.de>
 <20250818050716.1485521-3-hch@lst.de>
In-Reply-To: <20250818050716.1485521-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BN0PR04MB7984:EE_
x-ms-office365-filtering-correlation-id: 0acddf74-4714-430b-3819-08ddde57f63a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QStWUkM2U0R1RHJELzdJbTBkbTBKSUxVUGtvRHhPWi9HWE5sSWt1MDBtd3BP?=
 =?utf-8?B?S0hBZmdlb04zY1RkMGYyalpDWlZnN1lMRVU2TEc2NWs3blEwMkxZV295dEho?=
 =?utf-8?B?d2dUZ1JhYkhhbmNyTEtsT0hQY0FxaFd6cUlpUVNRZzhkOGgrcGMrWjRxQWNP?=
 =?utf-8?B?V3dxNEtxaHVTN1FYeHQzSi9mRGNVUjNQa1Fud1R6dGw0dTY4RnVuZ1U3NnJO?=
 =?utf-8?B?MVJkdVN1RWo0Nm56UDcwdEExbyt1VHRQT2MydFNSbllFWTNqVnF2VDAzNEpj?=
 =?utf-8?B?a2N3MmZwQUc1UVR6YldFTWxwblFRRWVJMnFJR01GazdyMms4Um1qV3RnTmlL?=
 =?utf-8?B?bXdLSWJKb2REUW1oQ2xmT3VOVnNkUWNMdTdpTzRXMnpXOGs1YTROalhoOTdo?=
 =?utf-8?B?YVI0QzhoblFLbVpaTk1VQmdTenNaNGc0OHV2WTNvbkpZdGtZb1llNmFKZTBG?=
 =?utf-8?B?WndlOWNlMXFPbWc3RndEckpSUVRqN1A4MGx2UWJHZjB5TUlVWXNlenVTdkl1?=
 =?utf-8?B?SkR2RmFJa2FjRFhlWDVzaEI2R2UxR0RnQ3BYWVV5QWxzdFBDbkNQQVJVQ2NB?=
 =?utf-8?B?S1ZjaGUrK0xYVWFSeXk3QWM0Wnl1MENOUVlCL2I5Mm52QUkzb0FSTml6Ymtu?=
 =?utf-8?B?Yi9wdXBiSndSNDUyMk9Ec0JaV0oxYXk1S3hMamF1VHV6QnBIUzFTMmpTalB5?=
 =?utf-8?B?andxbVJQaHZMblQxcVFYaWhnNjlJSDd3VXBXQVZUWGVpazVZRG5pcWF3Qkpp?=
 =?utf-8?B?UFgwY0gxWjdyOHBzaXpqbWhXVUhVdWxSSTRsRktIbXdyNVJYUHFXcVljY29S?=
 =?utf-8?B?VEZVb1k0UVJxeHU2eUtLRzJ2RUx0dGhvRXh4bzRPY2huTUhsblZmbmg3UG02?=
 =?utf-8?B?eEdUVktDVGx6SWN2M3c2Z3RRcytZdEVzV2owODMxMlM0NG43NVdOKzdSNU9x?=
 =?utf-8?B?UEExSEczWmlCWko2TWZlK09hSUUyNjlkRFI2aThjUDVYL2l3elRQODBHaVJv?=
 =?utf-8?B?UDRhVGF1c1JSMTN1STluY3A3Qy9MOFVIeXF0Skd4VGZJZ2VsSmEraWhYbnQv?=
 =?utf-8?B?T0cwTUVRRWs3UGNmbUNlTmlkZXBmM2phSUFUd2x2WWZDcHVKRXZXRW9qdXFa?=
 =?utf-8?B?UVB2QzNlWHVyTy9qODB4eXRveVF5Z05lQW1kczFGWnMreXNicVhsa3l2czA3?=
 =?utf-8?B?enNHSHI5UmVIV1NHaVBQWjlnMTBQR2plZDJ1WVdNb0xUS1E0WmErbVU4UlQ2?=
 =?utf-8?B?bnhjOXQ4Mk5ZTTZOY2JJNDE0UXNNbzdWd0N2RC9DbVoxV2k3c2RMYjhBNGFE?=
 =?utf-8?B?Wk9ZZncvSUJTUnZONGtaUUlMWjVLOERTc1psV3MwZDI2SVRXUWhGR2gyZDNj?=
 =?utf-8?B?Q3lZeUN4ZEp2WVh1bGVEQVVvM0d2cUE4V3ExdmN2ZHU5eGpTTys4Q0JaWFg2?=
 =?utf-8?B?eEQ5TDUzV2Y3NFJKV3FzcGRsUTRhV3ExYUlzTDh5U3dHWWw5cnZVQUFaemVD?=
 =?utf-8?B?WjZPWllsYWFOT28vNC9JelI4S3o0eWxicXFvMHJvQllEWjFyaU1rTEluUWdR?=
 =?utf-8?B?R3JDZkcramZHQytRLzBIZDVLRHIrZWZOSFJQa1RNTmhGbC8zaG1XczZQclp3?=
 =?utf-8?B?NUNmZlpHZm0yaENMSFRqTTVTUjNDdFBRRGVndkRaQTk3b0JIWUhlNWc3Q3JE?=
 =?utf-8?B?SXVwZWlqV3BvSFI4bExoeEROVmJrbmhYbzVEckRMTTZOdDF0UWNqbVlIc0dx?=
 =?utf-8?B?TTV3emJMcXdCN3VPSFk4d0o2bk5kdnZmWndpUmh3NlB1QzFGN1hZa04zd0Zu?=
 =?utf-8?B?aVBoMVE4aHJMSGtaa1pJZDZMVG91RHhNOW85bEZ6bFRrQ3h1OHlRSVVRbVJV?=
 =?utf-8?B?MVFsUElQUHBKdHV4RFI4UUZPbkJteHRCVVhXT0JsaFM5Z3VReVZ4OFByaFlL?=
 =?utf-8?B?QjkvV0dSWktzZTZSelo5SkdrRit1T2lJOFVvV2hVT1FaV2Y0SXY4SDZiODNY?=
 =?utf-8?B?ZkRxck1zK2RnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OERMWmNrTzh6ZkcxM043L0pNNVVvK0pPejhmSVBzTjQzeFNwMEdhUmtvY0VC?=
 =?utf-8?B?TTMvVkdTSTMwQ093dGdMdFhuOEtjVDR2azNQY2hmOCttQ3FJbm1BUTUxVmdI?=
 =?utf-8?B?T0RWU0FlbXlQTUtoQkNqa0dLLzN3NWZrUm00ZHprUDVTcG1TNFVOYlpva0Jl?=
 =?utf-8?B?d0tTMGhYaTRNUDVzZU5JaXk3VzRuQVJ0d2NSSXNEM1ErSHdJdk91Qk5NNlNp?=
 =?utf-8?B?MGt6UHgwK1lZNnR3eXUvd0ZmU1BKU2R0eUNOVlRRNmsvUG5SMU9yN2RDNHJr?=
 =?utf-8?B?K2RvaWt3S1hTdmg2WHFac2lFdVZBZ0RxNWJoQ0VaUm9pZGxBOE9uekRDa3R0?=
 =?utf-8?B?d1ZoMExieGt3S0RrSHIwbFlmU2MvS1hDTklwYjAwNURWOVVhbWNwQXpWQ3dl?=
 =?utf-8?B?Q1pVWUduckp1NThXSnFpWDBEU0RiN3p2VFhhQzE5QmRDWDUzT2k4MkpoWVVE?=
 =?utf-8?B?aHcvTlljM3JuejhuOVFoRU82TFI1bi9JT3h3UjRic3RRRmQ4cDhKKzFGdklk?=
 =?utf-8?B?bXBFczVkajhmNGF0bDBlQVhsVEdOSGxFbXh3eWVXalFGb1kybmQrdnRCejY1?=
 =?utf-8?B?R2cxekFVbGlScU1QakNiRyt0MUw5MTByVlBsOEM3UFU0SUlOOVpXREdpQ3pm?=
 =?utf-8?B?Yko3S1c1MEdQZ2JPL2NMdWcvVXhJeWlXUVFrbm1iOUpyNjdUcUVVaUUwQTdZ?=
 =?utf-8?B?OVhsa0VRRkVoZVpYVE5tcG9nTEI0bFJXNUJzZ3JkamFPMTMvNFJWNjNaSmpI?=
 =?utf-8?B?TmI5cS93SjlrREpFZ3FqcGtocmgvTVZTN3hsbkNkd3RHdlMrclNGdHUzU0d0?=
 =?utf-8?B?VnprQWppWHl5MHA4Rjg2eHRScEJhSlNkTVpkSUZ6TGtDTzBKSG9CdzJMQTAr?=
 =?utf-8?B?cG9sWXJYRHM2T3lIdDRkYWFFai9oUTMybFhacnNGdXZCdTlyVC9yRVZDdU82?=
 =?utf-8?B?U3dEV3RVZnZYMGpZUDJwalpXSWpWa0JhVUwzRE5nUFRNK3NMZVZTd21RSjlT?=
 =?utf-8?B?OXVCOHY0b2xGeW5FazRHeFBlSzRLNW1KZC9lWngzNW1oNGdtQnB4cndvSlll?=
 =?utf-8?B?N3B5VWYrNnU1RS9DSGxJZFFiS1ZnZ3JRbW5mdUFaTDN5YWUxZERLVmRxRllT?=
 =?utf-8?B?US9lREw5czVQbENPaUllNXJOYVMrekdlbXZGakx6bnVUZU5yZ0NxN3dkTGpv?=
 =?utf-8?B?dGhqYTdldStWQWNYNmU1Ny9TRmlOeTJmbWpXQXpEZ3lrc1FCNTRiU0NVeUtJ?=
 =?utf-8?B?cllQSlNxQmZBR2U2R1E5blpZeU55UXZGRE5vTExVYVFPd21NZ2dOcG1GQ0Q5?=
 =?utf-8?B?WjV6RzRmd05XSS9LMFgwbmM1NG4vWW9GWlZ0aGhPNWkvcUhEdkZTdVdHWCtH?=
 =?utf-8?B?czkvN1ZYUnJIN1FndytlcnRrc21TSEYvdHZwT0NnM2FZSSszY2RPRDduR28x?=
 =?utf-8?B?NmozRnc3UHlraVI0RjJqUEcxQ1dMUFZmREZGYTF3NTJkWHByVk82RXBZUDlG?=
 =?utf-8?B?YVg0czRabGowRkR1OVVrUUlQZnUvQWFyQzBGNm1EenBDOCtBRWhYa0FUSU4w?=
 =?utf-8?B?VFdwMWlFcVVtZ00xdFV0QlA1aVFDbE55anFPOEVpblVUeTUxUjZuR0pGRlM4?=
 =?utf-8?B?YUl6a2FudElRZ2ZybEZXT1pxSWF1aGFnU3VEVU81RU5HYmdSTXJ6eFpyMVdM?=
 =?utf-8?B?dDM1NitrQ3gxdjMxdEtFRm04WHh3V3ZMRyttMi96WTgrSEo0NjArLzlBNm03?=
 =?utf-8?B?T29LZmxHWGYxMldMUGpkR0FxSVlCckw1MUpxSjRobHBzWjVvc1ljZHNVM0Zn?=
 =?utf-8?B?Z1pBUjFoczBXaTQ5dTVhVGRCQml3akttM0hSTGxOcjZsdmVVdjR3WjczZGFG?=
 =?utf-8?B?RC9SWWprdkhYMVlRTkdyaGdqa3QrUU82RmptUVdMOHVNUldqYmdkazBiU3lG?=
 =?utf-8?B?UVY1YWVVZERNSzFFMFlhbERzcDFrVVc3ZnZsM3MwdVo0OTVobDhGVkN3Nm1O?=
 =?utf-8?B?MElvOGxoRWtISWdYdTkwN0Z0b1oveGdSdW1Gb082c3ZoT3owNUw2VFpuT3V1?=
 =?utf-8?B?bXhRUk1xek1ZYXhPS00xVE9xU3Z3cE92QVFmeEJmNmJ0d0VPNitxMVBiQm03?=
 =?utf-8?B?S0ptN1ZhankyeEVXaGRzT0VIMmhPZkJUdnFZZ1F4UWpOUDc3MncrS1poZnhi?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7176C75796CEE74E9A982FB1C41A9D00@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hrWtFimlk9MGBRvolsijZkcWcjg02bYdsQKrjCdEMlYlmGSAaXgN5EnRSXzRUwBz2OmXIlM1JxE09XfXi1APJ0YhAkVlBKWHGQrLSaqWYy2nBsux+Hzpy/QzpQrK8Zm5xwkolxrKZoUIsP16gKRVgvLi00dwX0bX+Yt4QeUWYNGIS6RJ2S6wZr/LYCVHKT4y0NNLrkGlRXiDPa8JVQ4ScDDJuYEl1hAnthO5Y/vVDSY4/fmqtq87+n2ThbMMjkdH1JFMVUmkSwFOLNAHXGTtE/AnQWvEFb3vtqr73ZPxSeiypNZg0P2hExF/CCSGE0SuHNr5XOdR8sQN/T5s4uR8NG9reV5vtroNKcrlXEAHMIxBqZ3TQx6cQgZ2kXgf75ZIwgsz2wCqmGOhZSrThI+uAg6XgtJW8QBxLJ9YmS2SUrnDLJ/TgozQ8wBOzuXFWC1UKYpMI4dAkp4FqgJcITahZtdObqFDyVgX7gNjgAaLAHrvbxkXIg2MBybNE8aZsEE0cSsszgIqEy0OyF+92ZGayScZaGJe8SDUxt4Xc6kz19GVSWshjQFtHnZG4CX5QrBu//YZWX6cadZlaii+SXEfGjBIRr75wv6WUZ6/iDabp/dqqO9rQAOaVLCTD2h1t6gK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acddf74-4714-430b-3819-08ddde57f63a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 13:05:53.0683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QfHNh02h1Enn1Avb/etpwOBDfvMSGfFNdDQ+1NFU4GQNtZR9omt4GdJNkhI3vvQI2GzoNakYEVQw1jLpqSRpSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7984

T24gMTgvMDgvMjAyNSAwNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFhGUyBwcm9j
ZXNzZXMgdHJ1bmNhdGluZyB1bmxpbmtlZCBpbm9kZXMgYXN5bmNocm9ub3VzbHkgYW5kIHRodXMg
dGhlIGZyZWUNCj4gc3BhY2UgcG9vbCBvbmx5IHNlZXMgdGhlbSB3aXRoIGEgZGVsYXkuICBUaGUg
bm9uLXpvbmVkIHdyaXRlIHBhdGggdGh1cw0KPiBjYWxscyBpbnRvIGlub2RlZ2MgdG8gYWNjZWxl
cmF0ZSB0aGlzIHByb2Nlc3NpbmcgYmVmb3JlIGZhaWxpbmcgYW4NCj4gYWxsb2NhdGlvbiBkdWUg
dGhlIGxhY2sgb2YgZnJlZSBibG9ja3MuICBEbyB0aGUgc2FtZSBmb3IgdGhlIHpvbmVkIHNwYWNl
DQo+IHJlc2VydmF0aW9uLg0KPiANCj4gRml4ZXM6IDBiYjIxOTMwNTZiNSAoInhmczogYWRkIHN1
cHBvcnQgZm9yIHpvbmVkIHNwYWNlIHJlc2VydmF0aW9ucyIpDQo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9uZV9z
cGFjZV9yZXN2LmMgfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9zcGFjZV9yZXN2LmMgYi9mcy94
ZnMveGZzX3pvbmVfc3BhY2VfcmVzdi5jDQo+IGluZGV4IDEzMTNjNTViOGNiZS4uOWNkMzg3MTZm
ZDI1IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfc3BhY2VfcmVzdi5jDQo+ICsrKyBi
L2ZzL3hmcy94ZnNfem9uZV9zcGFjZV9yZXN2LmMNCj4gQEAgLTEwLDYgKzEwLDcgQEANCj4gICNp
bmNsdWRlICJ4ZnNfbW91bnQuaCINCj4gICNpbmNsdWRlICJ4ZnNfaW5vZGUuaCINCj4gICNpbmNs
dWRlICJ4ZnNfcnRiaXRtYXAuaCINCj4gKyNpbmNsdWRlICJ4ZnNfaWNhY2hlLmgiDQo+ICAjaW5j
bHVkZSAieGZzX3pvbmVfYWxsb2MuaCINCj4gICNpbmNsdWRlICJ4ZnNfem9uZV9wcml2LmgiDQo+
ICAjaW5jbHVkZSAieGZzX3pvbmVzLmgiDQo+IEBAIC0yMzAsNiArMjMxLDExIEBAIHhmc196b25l
ZF9zcGFjZV9yZXNlcnZlKA0KPiAgDQo+ICAJZXJyb3IgPSB4ZnNfZGVjX2ZyZWVjb3VudGVyKG1w
LCBYQ19GUkVFX1JURVhURU5UUywgY291bnRfZnNiLA0KPiAgCQkJZmxhZ3MgJiBYRlNfWlJfUkVT
RVJWRUQpOw0KPiArCWlmIChlcnJvciA9PSAtRU5PU1BDICYmICEoZmxhZ3MgJiBYRlNfWlJfTk9X
QUlUKSkgew0KPiArCQl4ZnNfaW5vZGVnY19mbHVzaChtcCk7DQo+ICsJCWVycm9yID0geGZzX2Rl
Y19mcmVlY291bnRlcihtcCwgWENfRlJFRV9SVEVYVEVOVFMsIGNvdW50X2ZzYiwNCj4gKwkJCQlm
bGFncyAmIFhGU19aUl9SRVNFUlZFRCk7DQo+ICsJfQ0KPiAgCWlmIChlcnJvciA9PSAtRU5PU1BD
ICYmIChmbGFncyAmIFhGU19aUl9HUkVFRFkpICYmIGNvdW50X2ZzYiA+IDEpDQo+ICAJCWVycm9y
ID0geGZzX3pvbmVkX3Jlc2VydmVfZXh0ZW50c19ncmVlZHkobXAsICZjb3VudF9mc2IsIGZsYWdz
KTsNCj4gIAlpZiAoZXJyb3IpDQoNCkxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBI
YW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQo=
