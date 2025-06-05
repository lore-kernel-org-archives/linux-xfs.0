Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2944A927
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 12:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749124970; cv=fail; b=pZeNLUlewrYOs4gJ2Of9TbN/AYW9anrSfILX5c/W29OxQ7AP6O3F5dQc3IiDGtgsLNTEuKJXUZglZYSGRMDVhSEopNzuZW310OxtmIsOtot20sPh62R2KyyFwxkF1kCY6bmrOxnHHqxmOuhX4QAeNajLiqbYVRCKrJnQ7ibyj0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749124970; c=relaxed/simple;
	bh=J+NPH+S0Yr85BpMtYQUNxCjzAEQguvR8klq3qfMyWHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mq/tYiK+ZTGKQgIL3Jh9F76Lsm1AfLXz1PepH22ICs80dQo0vCRNBivbXW+FFyHp9gnHBvhrioTORu2D9LkfQx9dt7qwjvoRVG7/5eimy46sO/sTiVtu64OBU+jEqAl2E38LCTS4B32A9UNUkUifD1IK1P34Jcb7fb53gxNQkP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ABmZ5UDr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=M+7x81t+; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ABmZ5UDr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="M+7x81t+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749124968; x=1780660968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J+NPH+S0Yr85BpMtYQUNxCjzAEQguvR8klq3qfMyWHY=;
  b=ABmZ5UDrq+FCCXZuLNb6/ENOsTclR90DDNSf/XIotktanZxkjoBHk6aw
   5vhLBPbF/ehOCLBenPVUTuG8yepKIYW6OMIupB7S2OA+RICVqfJ2CriAT
   DjKXNUlPJ6yCsLi+c0I+3+EKGU5grnABZ7czlR7yG6WzVliJ5ii53zOls
   MD7FvCzzoBhwrT3N3JvDjzZ/Qnh1dc0l8ZiVJRrLm7wiyrav2k3gGNTjQ
   unhrII+nrF3u9s3fBWeNRGaiUeHohmjARSjeVFAZmLOJzwn/kutDTgODo
   4Ya2jKJKlBI3fS59nyO3HK4KnLb0QIGVHuj0wLMgOFBLuKmAF2YC7cVQs
   g==;
X-CSE-ConnectionGUID: KerY9/NwQti9q/3Y+E2Gzg==
X-CSE-MsgGUID: DRz93T77SwK8fBPmQsB8Gg==
X-IronPort-AV: E=Sophos;i="6.16,212,1744041600"; 
   d="scan'208";a="90045673"
Received: from mail-northcentralusazon11012044.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.44])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2025 20:02:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwV7tOuj0eoRjEIGO555wXQtOQ9KLGp3XyMAAdPacy5LBC1koSZUoo6/CswnlLhVNJU8RRNp06NYrgceyaw4mkbsf/ZweGOsmrElcXHInTnrVxd6/pw8PHaEGbHNFxuNCluKFpYNNABWcr6/C5UZUQpPbFXmKz1KTOTJUud7YTqDm2m/KXjHpHE1A8s49QuyMtRsIwG6HjRFTD1hxY97QkYj+wF5lvH6Vf8UV1cjkeQsvhHrHY1a1tuESdyKmehRaiSODumVjWWZvvKU8PPi+zVkJnOC2+2Ch/gCjkD0MYTPUYtvolxPUugtbgm1IS+IGKEBSshE9z+Q+OAPJi2ePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+NPH+S0Yr85BpMtYQUNxCjzAEQguvR8klq3qfMyWHY=;
 b=fPENW0VI91WJeavlva3j7G/Vs4FVrBR74fDYWlwm2uwpPIfv1lvE8nmBjizWVbeIpEBfkx29n4o02Fz/fWHOe71Ht1MNTPP5DfacHqJDhV1MhT8hwIpV+/CSrt3/yur8yjfw7iCCD6bHoMwh45ysVI8t355jNwko5GoBh3eK05k/okjTWb6tMNYnwfoLlcjoaqCw7MxDkpkjASjoE2E9Gy0wmjrlQKMrRM9hMtPRE06C8uUnNRgnVdz7Te8zso07bdrNF4oE5Owv9tfwcdY7bOVYixvK+LrewLOK/UB6WzI5lQUJ/UDyOQrUAysXsHBeMG7FUssvScbC2sjzVvMybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+NPH+S0Yr85BpMtYQUNxCjzAEQguvR8klq3qfMyWHY=;
 b=M+7x81t++2HixXUVMV+Fxk4B1jrMZgBARTSPfJdrFYf6Ht+uQIxhbIsxh7qBym+uuIKBMYC6XwLcHRpo+NofYqRrw6klteAXJ/P4fJzKWvXx9Um1Zg1AiBK3Dd3FLXidmU4j6PzmftRSclEnOD52SzEvCkxPuNgp3rp2jROfBzA=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH0PR04MB7787.namprd04.prod.outlook.com (2603:10b6:510:ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 12:02:38 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 12:02:38 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Shinichiro
 Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/4] xfs: check for shutdown before going to sleep in
 xfs_select_zone
Thread-Topic: [PATCH 1/4] xfs: check for shutdown before going to sleep in
 xfs_select_zone
Thread-Index: AQHb1eFtvurllbhNvUOPf8FZBW8aTLP0d7MA
Date: Thu, 5 Jun 2025 12:02:38 +0000
Message-ID: <8dbea18c-547b-4497-91ec-a8dd58c71095@wdc.com>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-2-hch@lst.de>
In-Reply-To: <20250605061638.993152-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH0PR04MB7787:EE_
x-ms-office365-filtering-correlation-id: 15983462-535b-46f3-f332-08dda428ddd9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eVNNNEljY1lTVE9NN20yQWJPdGtaTklNUExQdHFaQ1FBL1kyQWNvcHJodUxT?=
 =?utf-8?B?cEdSMjBSQ3RBR0x5aDF4c1BmY2YxaVhjaTF3N0JzNnpkTEh2cVF4K213ZUdS?=
 =?utf-8?B?ZTU4OGhmSForM0tzT1VkUThwRDdVc1hheE1LRlgrLzBWVURuV3JVZlB4S3RW?=
 =?utf-8?B?MjNZMUFEeEZmNXhZaTVCN3djZEozbWRvd3pTLzh4RG5BWjJndjZTTTZTcWZD?=
 =?utf-8?B?UkRYMW9GRjhYcGNQRXVxVmVzaFFPRkN2cVU3R3BVYmhWbWNlVi9VYSsrQWE0?=
 =?utf-8?B?NmZpV09yQTR5dXB3dkZiOElVRTA4dXVwYXVJVWFYMW5CTE5wTFpDNHR1QXd5?=
 =?utf-8?B?ZWo3WTNzZVZ0bFFQeVJTYmhEOVd6Vjkrazkyc1pXY3VHbDR2N2wwaUUyc0lD?=
 =?utf-8?B?OWhpbGJSTW9IeXUrMXBzZnJIbkJuazIvMU9YTTVBY0ZYRkJuc3hPWDdPZjZW?=
 =?utf-8?B?eFJDK1VzN1krb2hpRCsyV0Fma0xYYStGRDVMMk5oQXlQY0RIamxvZXY4bUFm?=
 =?utf-8?B?c3MvM1dYd2hZcVJsL3VSQm9jYzdVSGVwQkl1QlV6RjR2OFNuSE9qWW9SVFN5?=
 =?utf-8?B?UWFrYnZEREpJN3JnZ0RBNVZ3MU9uekc2UVVJZjBUTHJiNGpQMnA5b1FiOXpp?=
 =?utf-8?B?N2lWbUFvOFlhMlo2TlNzdUQzcEcrZVpuRm5odDg0aG1EMmNwaUV1OStmOG9j?=
 =?utf-8?B?d2Zwb2s1UndMMDNSK1REWWlNWW1yeE1Tb1lsUWNjbmRGRFBmL0Y3WFFPWHBX?=
 =?utf-8?B?R2IveUF6eXp2TUIzTGw3dGJ5R1VYaHhnaHlKK2FTVERNOENCUlpHMk1ndm9C?=
 =?utf-8?B?QVVxUGRHTFpyVnVBQ0pnSVdjWFlVUlN1ZHhMa0k3RDZIYytHcDBaQklNWm5Z?=
 =?utf-8?B?QmZNdU1FNWM2ZlQrcDdTWjFJc2x2MURKYk1Sc2s4NTd2Q3FEaHJ3TjBCNHhY?=
 =?utf-8?B?alpXRmF4dEVhd255bzVTSFd3UmpTTVVZVVZ1c0lrc1ljbFpsbFZZMWMvMW9r?=
 =?utf-8?B?ZmxKWXp4VkdJWE5aaUFQK29JVFBEV2F2dVlraVU2VGlMVjdadE15eUJiS1Na?=
 =?utf-8?B?VjlDbDZRdW9PeG02SjQ3ZHBqNVRHTjF1QndndVkybjNWMUZaclAycEFOMVBM?=
 =?utf-8?B?Ui9RWDBlZGltYnVxVEtyQkp3Qmo2NmRVd1UvM0RvaVd1akw4MFpuQmwrc2Ny?=
 =?utf-8?B?dU8xYmRYS2p5b0NEWDJMNlVPeUJnc0kvV09aRTJKZCtQNDF4K29vclBrZHdI?=
 =?utf-8?B?SE1mRE1vV3YzREU5Qy9Jbm9ITHBNdzdad0x3dEtvV0c5RUo5K2JDTk85WlQx?=
 =?utf-8?B?SFdsam0vcmd6RklrSlQxNUZya2ZIODJsemovQ3QvaEtwQzVIQUQvaTNxRWtY?=
 =?utf-8?B?Y3p3dlIralNSOVhwcVpxTHFBNWVTU25HM1VVS0R5UTRHbUZxNzlxNlAwVE4r?=
 =?utf-8?B?UVVQV3ZKV21tcTRyRXdDWmlWeDd4czRmekhTN3NpSkNCNXdEOVJvZ1VWYWIx?=
 =?utf-8?B?RTVVTXlsTHExb2xNL2t5cm5ZZWM5RDhYRUxhbEJJU0lNZkl5Wnl0N2k3NTdG?=
 =?utf-8?B?ZFdIOVp2dkdrNzhQZmE4djRYT0daN2JvTXFBNlRmUFJqYlB0MnBkSG5CZ04w?=
 =?utf-8?B?TXFSNHZ3cGJyRXhicjZVSXdCSC9vaUtlUXcwTTJ1Tkh1WDFHK3BhdEo2Tm45?=
 =?utf-8?B?R3hLWHRkL0VWY1dlenBCTUZSWU16TWQ3UHVGRGg2bmc5K0dpMDhRUmNFWHFq?=
 =?utf-8?B?akhyNUMyMHBweDFzQ3NqdlNLL096QlJUME5WYlhla1BjdTBOVjRwTzgzKzJm?=
 =?utf-8?B?ZkN5UWx5cGNPL2RPQjhNMjNKdTFlajdOenlhM21zaFcvSmpyK3VnWkRiMzcz?=
 =?utf-8?B?QUgxalAyUW9TUU1Qc1NPTkcyd1ZvUXFBSkVVcXQzNk9JK0JMN1NvVk0xWmVa?=
 =?utf-8?B?Q1AxU0tXMDJyVG9OWHlSYVd5dTd1aWszZTdyWnprdHJZOFkvWm82bklQamtK?=
 =?utf-8?B?UUo2R3JnTGFRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzRCMmlvWkUvaFQxNk5RWDR1eDZlSDZ6OFdWZzNCRklBTE43Tlh4c013cDhu?=
 =?utf-8?B?eWlDR1JtSDZrbWNKeUdlUERrQThObWVUMHkrQkllMTROREtpL2xUMGJDMkV5?=
 =?utf-8?B?NGdnV1RlR1ljSnU2RnhhZEtocUNqQ3FxTm9pNUxIZWVqVDNhNTZvdkJieGV0?=
 =?utf-8?B?L2xqTWV5MXVaNjdId21jMWFzcU9oUWxUQUJzZlAvbjQwVVZvVng5MTFlZDUx?=
 =?utf-8?B?c2M0N0l4S0c0SEZIcDdKRXZ1ZWQrbi9rc1VsRjNjK0N4U1lhcVJGSGlRZ1E5?=
 =?utf-8?B?UTB4aVdYcW10NlhLU2ZvS0ZBWHhkakoyN2U1aWt1cXdzODRJakphdWhsaXhj?=
 =?utf-8?B?WGtHdGQ2YVNTN0ZqeDI1WEJpc3Z6MXJOdFZGb1R3OURNRjhjVFAwNHJDUTMw?=
 =?utf-8?B?QmVCM1FuZjlia0k2UC8xZkYvUDFLMmpOWk1SQ0UvTmxSV2dma1JHRXkvRGhu?=
 =?utf-8?B?UTE3UGQ0dE84VHA1VXdhWlVsSzJMZGhON2d6OHU3aXBETlFoSmF1a0ZWS29Y?=
 =?utf-8?B?UUJaOWZxRS9yM1U4elV5aHpWaEl5dURHSTBmY1NyaThXb25adVJHRFVEV3Uy?=
 =?utf-8?B?Tmp5TXZmekFvZ2xmcUZZUlZ2Qm01Y0hLZ3R4ZFNCbVJ3YmFvclZKM3g0ckor?=
 =?utf-8?B?U1UvNXJPM0EzbmRyL0ZDdWpRVzZaSTMyTnkvYW4zN2FzK2tvUk5IQStJeDAw?=
 =?utf-8?B?R05IZkcyTUNUcDJzQ3hCTDNHNnJ3NXU3eTUzTTl5OWpTajliSjVFdXhxTW5p?=
 =?utf-8?B?c0lzYWRGaGFxMnNDY3BhYXN3Zkw0Vzc4aDVna2F3Tmd2MG9EVlRjUTZnNE1s?=
 =?utf-8?B?THlyeFVzOWJYQ0JEUzVnOHgzamF4OTFnZTJMTkhISHBJRGFBbUI5eElRZ2ZZ?=
 =?utf-8?B?WmloMXdzN3dad1d4Q3JreVQ4ei9OWUswSlczSmhMMHJmcDc5NENqbmtRRDd0?=
 =?utf-8?B?TG1rcnl0MmhESmI5c25oTHZvK0htc2JwUlBKWTRlbHdEZDkxWHpsREQ1ckwy?=
 =?utf-8?B?b3NaZlBZWmxLZHAxNEgzZm1ZUXZvNHFxS2E3QnpOd0NBd3U3a3d6eG04LzMw?=
 =?utf-8?B?MXdkTW5EcWhLemMrL2ZuK2w5S1hHUGxjdGZjUlRMSXc4d01QVDlJYlpEYVpq?=
 =?utf-8?B?dkQ1MVlNMG5FVG5UcTVXSG9EK3dJS2RoRHdyWVhOM2hTWFZvbnRtM2RUeGpm?=
 =?utf-8?B?N2IzMmllNTRPQ1VrcktkTzFwbzlnRWNRWHdVN3k4MEJrQitWSzl1NkJETGVJ?=
 =?utf-8?B?cUNBRjdlbHg2Njk4Yi9MZVJSRWpiN09GdEZMbThoU2JDVnlHbWk3UzFUYlVv?=
 =?utf-8?B?cGdLQlRVem00V1pRbGlicytINUpidEZmSVJUaThPdjdqTXovYXMyV2xNUWZZ?=
 =?utf-8?B?eGlFOXlrL2tFc1RtSUhWNHl4MXJ0S0hDbWFQR2l1NzVGYUJEUnEwMHYwVUZt?=
 =?utf-8?B?NXdnM28rWXNKUkZvcVNlN1VvS1Mxc2IzbGQzdHVWLzVpUGgrYlhGM05sNHdl?=
 =?utf-8?B?bVNEZFNLNnhlbVZlbFlHbjlnbG9vU2ZJNjh2ODQxN1dRMDlETDd2UmpCL0Zq?=
 =?utf-8?B?dkxzWG56UFVkOFpubXFtY1lNS3ZjMkVrQmh4RE45VUlwSTUzbTcwdU5LYUlh?=
 =?utf-8?B?U0dwRElTSUNFY3pFRXFLOTlSK2FOSGROMGlyL0dHZFR4M3RldGRVdGhwU1Vz?=
 =?utf-8?B?WlZwT1NFeUlUSjJmeXJKbDZoQW5La2l4aTlWSzh1dnE5Mk5MeXFVMmE5cnNj?=
 =?utf-8?B?VnZ4cUZZNjRhalFmWEJSYmw2QXprL1ZSc1N4QkFDTXgxMFZralY4c3BiQ0J1?=
 =?utf-8?B?ZmtYM3d3QWZoZzZxM1cycThJTzJFTy9scWJHcDd6WEZab0NrbjB2SG51S1BW?=
 =?utf-8?B?WWtXUTQ4cUJibXlxbVQwTy9CY3BYNkdKVVNiYUlXd3FIMFJ4MFpnc3J6Q1I0?=
 =?utf-8?B?NXRqSnlPaC8rZXRxWWNxSEhGRU8weTNxdWxnejNjNkNobm5aWEdrMTZHTU5j?=
 =?utf-8?B?UFZzMXJIbGdsYVlVYXk3dE56SVdZdm5RUWQ3eStTdDFlSk5CU2NHR1hFbkdK?=
 =?utf-8?B?RWhkYUdFUGxuTlhSdlVjZXlBc2NmR3c3bjIvZG9LSFgvaVBteGErZVpLMkpH?=
 =?utf-8?B?Vm1WSXhRa2UyTGcyTFBJRHhhYUZUVU1KUC9mMUpoS1pybXcwcytsWDlvbk0v?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACE0EFC1C589A740BE09B1ED438A4021@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	flE1jHf+/R/xp3AyNqXjS10ANL5RetNpTxVJoqKyJ4ntlVb0VZp/BAzzVdo/Sn0cXNcWdh4ktm3qZfTUvCeRWlKe/k3z+zuDotLJzNzRXoWHHVIbKa6n1jLE70m0UMvPjqR0pFCBnxe/lYylBvpzTPHk8klW97IpM5jUxWgu2yapMJtuCXMUBZBjgCujJqRh6G1QdXCHsL1hQ8Mf9FcTByVwPH0E5lk15ajb8nfRBpDAcckd33zsI5/B+e9mXW5sat/AjSO7AoY66ghBPGs35+vlXo+sLvxMmZDouLxfW+zIJBlWRlDjIo5sgSuuU333HN8wd9qLoLh+1ywrn1oNVBt4JkPiPuZ/VMLPRQC8DYqrV66krXBRaE4/dPS36H6mta89GcYnRxxJFhWtcIgofp819IMy0I7nyVFJ7zY7VeWfzsZUywxg54XOQROmZOUS4UDTAaJqmjPt2MnrzCcILBjoLGZNJwQTa6T2/P22RCP1Jac/QD/9az01UxGEXiVRD6EFkWo9E6WmVQseYskIe7ClXOHHmTPU2UukuKhwUEcJkxJo2yaQt6HIbCkxYb37CbT7RuLXsjCL4a4IEH6pqf3vuvlTXpacVPe5KgMCfQDXshcN5g9N4YqyOubrReO2
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15983462-535b-46f3-f332-08dda428ddd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 12:02:38.3534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cOf8TMlfkFXRTdnDzFhGhsSv8v5pv4MsSlmSCAd9z0a3S+7rGjLZKXryBHTMAFWYm6gyOxCDtrADbWWrSp72UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7787

T24gMDUvMDYvMjAyNSAwODoxNiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEVuc3VyZSB0
aGUgZmlsZSBzeXN0ZW0gaGFzbid0IGJlZW4gc2h1dCBkb3duIGJlZm9yZSB3YWl0aW5nIGZvciBh
IGZyZWUNCj4gem9uZSB0byBiZWNvbWUgYXZhaWxhYmxlLCBiZWNhdXNlIHRoYXQgd29uJ3QgaGFw
cGVuIG9uIGEgc2h1dCBkb3duDQo+IGZpbGUgc3lzdGVtLiAgV2l0aG91dCB0aGlzIHByb2Nlc3Nl
cyBjYW4gb2NjYXNpb25hbGx5IGdldCBzdHVjayBpbg0KPiB0aGUgYWxsb2NhdG9yIHdhaXQgbG9v
cCB3aGVuIHJhY2luZyB3aXRoIGEgZmlsZSBzeXN0ZW0gc2h1dGRvd24uDQo+IFRoaXMgc3BvcmFk
aWNhbGx5IGhhcHBlbnMgd2hlbiBydW5uaW5nIGdlbmVyaWMvMzg4IG9yIGdlbmVyaWMvNDc1Lg0K
PiANCj4gRml4ZXM6IDRlNGQ1MjA3NTU3NyAoInhmczogYWRkIHRoZSB6b25lZCBzcGFjZSBhbGxv
Y2F0b3IiKQ0KPiBSZXBvcnRlZC1ieTogU2hpbmljaGlybyBLYXdhc2FraSA8c2hpbmljaGlyby5r
YXdhc2FraUB3ZGMuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNo
QGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDIgKy0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMN
Cj4gaW5kZXggODBhZGQyNmMwMTExLi4wZGU2ZjY0YjMxNjkgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hm
cy94ZnNfem9uZV9hbGxvYy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IEBA
IC03MjcsNyArNzI3LDcgQEAgeGZzX3NlbGVjdF96b25lKA0KPiAgCWZvciAoOzspIHsNCj4gIAkJ
cHJlcGFyZV90b193YWl0KCZ6aS0+emlfem9uZV93YWl0LCAmd2FpdCwgVEFTS19VTklOVEVSUlVQ
VElCTEUpOw0KPiAgCQlveiA9IHhmc19zZWxlY3Rfem9uZV9ub3dhaXQobXAsIHdyaXRlX2hpbnQs
IHBhY2tfdGlnaHQpOw0KPiAtCQlpZiAob3opDQo+ICsJCWlmIChveiB8fCB4ZnNfaXNfc2h1dGRv
d24obXApKQ0KPiAgCQkJYnJlYWs7DQo+ICAJCXNjaGVkdWxlKCk7DQo+ICAJfQ0KDQpMb29rcyBn
b29kIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3
ZGMuY29tPg0K
