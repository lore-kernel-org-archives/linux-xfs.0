Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3911263F2F
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 11:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841099; cv=fail; b=AoiT1JAz9/RTx9PX47Z8g8l/KtxY09xlYxkK145Fr2FiNtvBibe8fLnDGoV9cfmdyKWEQ9DHUpnAUyCW7HEIV1zSdrxZZ41G5x8KD7PpG1sV7OvXUE0FTjWZeDh/K6aX3FoEzDh1Pk4PLoZ04CGd4G8NCFogRUkmGzseh6kBrOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841099; c=relaxed/simple;
	bh=4yUh7kymD9AWMmRkAGCvPsUVr1KR6A2wLLzaZLOFTp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sbGpqLml2Bu5qebz4ErkHeC30yzddV8cP/XgW91sCq1bGqoCTHOVGRkck9H+VFBPzSLpJKj16cCaLi5m/HMn5orW7Zsf8Nu6L6PyzcbIfuSvOzYjaxBhhfz3EA7xoyirIPpudAHP3Yvs6o60iELtSyNZ04eHeKCC2BrSCLxlu+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HrlV5eTX; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=siWNlxee; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HrlV5eTX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="siWNlxee"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745841098; x=1777377098;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4yUh7kymD9AWMmRkAGCvPsUVr1KR6A2wLLzaZLOFTp0=;
  b=HrlV5eTX++oru09rAG6Fo4v2S+pbxYl4t5U7Hf/oUHOUqHax8aUVb3EY
   qww810ggrPxZfaO+pe5HYnQHRWWkpwETa+MlZ2sDDXel+WHXtmd01nFO4
   1l81Tk8W5thG6F6h+Wi765N/GGwNtNvfJoqURb5hXDiUvn13lcc/2mxPM
   yqslzowBCTD1BD55o6ncsYVdM9vby8SdmSVlxyFxVZzyhdWkd/HebALCr
   hv37hjbJQHxaDy0hCpNdOxYbr/I9wGsdvDEOlT8Tpd/5H6DCgjj5Vaq6h
   8Uns908jCqgjukf756uF25HPDz1PNb/DAjMlqkrsxU4GK8cz/Yne7WGyZ
   g==;
X-CSE-ConnectionGUID: ij6fm5F0QOmjBP27X2NvvA==
X-CSE-MsgGUID: pIWU1kFYRhKgF6Ls0uepYw==
X-IronPort-AV: E=Sophos;i="6.15,246,1739808000"; 
   d="scan'208";a="77996617"
Received: from mail-eastusazlp17010006.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.6])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2025 19:51:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iquJbaFcJcDF5kQMLhqtHT8wlAeq/Eu7UEM/OKiJ/Lq8b7EwDb9eNih8skDonLnu9vG+BXo+4wGyHrwjwf73bxqVd8+wONLwo/OKny4pi6q4/BrRDWjuMOW6pyt0ej7dRv6QFL+fOKldH6q/QxL4FadNO9f3JvxYmqIrvy74Ie1MqCNKbX4zrm2grKQ+TmcGoeIKiropy0OhrPd8L92Hlk72qp73Mh9N6kb+J06t/IxlRkoqAZfPK1FyJ68++K++0vkg7Jdl+WTFecHY9ohClX8vk+iQkRjy4umpzn7Rc4DuTuQ/0DyvCr+fpgxjifve2cC4hawZUqze9F6kMGbXhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yUh7kymD9AWMmRkAGCvPsUVr1KR6A2wLLzaZLOFTp0=;
 b=dTo8nYL/u2Kd8y4ZsRb0u0PV3MfaFqg6Q0zCxa+ns4eM7MFNLgtN77skrQ8FqobvOpqvhbv8eAxHz9eu49qXBXJdjRAuiSczwXrJtM/Pw914VpcK/Why+qHsBDfqKtbUk9qhegwvaRA/PVFYzsELusHD7eKvJ3fJgVXl7MRct39ui8VBCR8eRVd0M3qsnv3A5rt6cerBCORYdr9L+2H/68YLol//0gzVoVsepLSYuu5sQRedH0xEyion5lhN3bP9GRy1rtlZAozgrD60UMF4FF70lT42AWvkMrDAIjM0X89K+WlX4J5dRbMpRYiCj9jfSmefyncw/kliq0nAg27LCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yUh7kymD9AWMmRkAGCvPsUVr1KR6A2wLLzaZLOFTp0=;
 b=siWNlxeeku/1OysHCuoT2C9Tm2TnoZtfxmD9B5hSaW6Rdi9QvfyT2G+94wg0h/Kg8XfGoRQqZ6dvMKcnxFCdB8K9cMM5WQF1N0ky1rC8RoKU0W8rFf0NQYGAAuSeYyWN1aJ1gHa0DGu4dReCOkK1AGBp3sfMx6l3xXcvHbtQjb8=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6582.namprd04.prod.outlook.com (2603:10b6:a03:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 11:51:25 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 11:51:24 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Topic: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Index: AQHbtb9ugJyGk1wFU0SBquvCoobacLO42u4AgAAhTgA=
Date: Mon, 28 Apr 2025 11:51:24 +0000
Message-ID: <8d4aa088-e59e-46bc-bc75-60eff2d49f4a@wdc.com>
References:
 <M6FcYEJbADh29bAOdxfu6Qm-ktiyMPYZw39bsvsx-RJNJsTgTMpoahi2HA9UAqfEH9ueyBk3Kry5vydrxmxWrA==@protonmail.internalid>
 <20250425085217.9189-1-hans.holmberg@wdc.com>
 <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq>
In-Reply-To: <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6582:EE_
x-ms-office365-filtering-correlation-id: 62ab1567-a50d-46c8-cc3d-08dd864b00ac
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cXRXSjNtQWIxUk5CSWFUMTlLaE1QTlNrOUZmTHU0R09ZRUIvRFllVkpSSTFu?=
 =?utf-8?B?MWR6OWpWekgrZ1dqUWVCL0dOMEgwSnNGREJ6YXVWUWlINGFVa1VtRUYzSjEx?=
 =?utf-8?B?d252Y042ZFFucGRCOEZPdjJrRjJGN1NaS202TEpDMHdGd0NIRVV4UlVoU1Zr?=
 =?utf-8?B?NGZRenhnN3BtS3JSRXVDMFI0bTlheFFVblZ2VGN0ZGhIWUJqazZ6bmpkYm15?=
 =?utf-8?B?QWx6LzNpWTlsRjN6M09JcHViMGVkV25kQjZqNXRXWWJLbllHMjI5dkVDcmdQ?=
 =?utf-8?B?UnZPYldUK2g1aWR2KzQwOXpiUHdnYVZjajdpcTRPZFlxY0FrZHNpcFRwR3VD?=
 =?utf-8?B?NDZlTzByVXZsYnNJVnA4T0t0RUhmd3JySTV5TFQvSXkvM0tiQ1NWZnBacEkx?=
 =?utf-8?B?SDh2YlZlS3NaSXg2QjRuQkNaaENlM29pRXRqQXBXZVcrRkFkcnVBRER6UjJZ?=
 =?utf-8?B?ajRRVnAwTXFLNnZOTlB2cGFaSkQ4UFJ6dU1CUDNJZTdJK2dndUFXWXQyMmRn?=
 =?utf-8?B?UkVrT0dUZC9VNTl6aHVHL2pBUjNUZmg5MGs1ay8xbjBqSUtxa3czSTRncFRm?=
 =?utf-8?B?cFF5TC95c09keS8yS25JWTFzSG9CZmpZK0VDRU5vRG9sdmlYUUg1TEVKTVFY?=
 =?utf-8?B?L0hMSU1Rc3lJcm9jMUZjMDdHZExPNFpCL1JOVTcybnhUbmhtUTNuOGwycnZS?=
 =?utf-8?B?ZDdsQnprc0oyYkc2c1VacjkvQWZhUU0xQzVFZEk2NlRJaVhvVzhrZjhMb2lF?=
 =?utf-8?B?UWM3OUVzWlZaM00vOXZGQll0eUJob1QxeCtrK25LVmZpSGgwSFZkNU83OGdv?=
 =?utf-8?B?SFpUcXlJVEtVb1lxempBZVg3TUV5M3Q1WFNwTmlKZUQyaGdKRnd5Ri81Q0NR?=
 =?utf-8?B?RW03eWR0SzNXcndrNG5IUXdEVEZrU2k2NHJFVmRiWjdBcTVpZURhVUlLUGYw?=
 =?utf-8?B?eXlTSHY5a2daSVVpUWQzS2NKaGlNeVBoNEJGZlUwMFdka3FnZEdPZGVkK0xz?=
 =?utf-8?B?YldRM2dWbkdNQUFqeEU0OEJzWHYyRXhPOTlhdEFVd2xzUVk1WlQ4dG1xMjVa?=
 =?utf-8?B?b29IVDRrRDdiQSs5YU1oeEtBbXFuRGloQW83TmxlZEZsZkRWZjVPMGJ5MDdj?=
 =?utf-8?B?Ui9BSktFTU9KVUJXVFlWTHg4VHlUL2NjNGdZYzR0VXA1eWtkVzF1RFh5a0ly?=
 =?utf-8?B?Q216SnRZYnZnRDZEcVlUR1crTkpqT0dPbExFSUhxYytNT2JybVJWYlRLNzB3?=
 =?utf-8?B?bHdiajY3OThOWG9xS1V0MVNvbitQd1UyV3RNbEJ5U2hvS095VWRyV285ZndG?=
 =?utf-8?B?aHl5OHI5em1Dck5YVTNHcHU3RTRaWmkxN3BmNXZnT1hhNXFweG5ncHdaSjNt?=
 =?utf-8?B?YnVsMFVnYmZXbGtOWUQ0RE5pRWtIbi8zazNBQjJOYmZTazJhczhrcktROWFr?=
 =?utf-8?B?dVJSRzlKQ0k1SldkRzlnZXo2SVVZaFMxbC91NGZ0dlNlTzBoZnhUdzRpZTRo?=
 =?utf-8?B?MFZRcHdYc3Q3c0o5Y3JOLzZFb2k2MndqY1pFZ2JRRUR6RWU1ZW4rSkd1ZGpI?=
 =?utf-8?B?V1ZRUUtyRnNQYUtFQ1hSR3kwc1o0Y0tvWkptTnBBcW5qWUowOWRBeEowWGRQ?=
 =?utf-8?B?SU9yeDJBcDNPMWpLMXVHM0tzR3JMRzlaNVhSV0Z1T216V2E3U3ZxWlpJUkxj?=
 =?utf-8?B?WWxIbG9EblFCRDZ0VDNRc200d1JkcEFrZFJXVWxVUWVlMzBJQ3B6K2VCVWRP?=
 =?utf-8?B?VTgwMnQrUWxwNytJTEttckpJRWtZWmhpamhQRjZrTk1vMHg2MGFVZHpzb2ZE?=
 =?utf-8?B?SVJWc2VuV2lJNEprem9oWlRvZXlmWG9zQWh3TTF3UkFPd2lkWXVhUWN1NjlM?=
 =?utf-8?B?T3lWWEs4Smh5Sm9MV2ZBbFQvL3E4RHhMdFprbXdvdkl4SjdIRVJoekZJUkJu?=
 =?utf-8?B?RnRGTmc5UUxnV1FNVXNSeXhNeXduK1hFR0VoV2xNVGc3MnZJclJMU0RIWEx0?=
 =?utf-8?Q?ma/w6j5/KI32QX9ttQCx9hSG7odrBs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NXlJQmJyaE5SeUcrZ1VSVWluS3RJUnZETHl4UzY5L25EVlgwSng2aFhyS1dR?=
 =?utf-8?B?OHdXbXRPSnhCblB3TlpCbGZ3ZUFSUEF5VGJEUStPZkIwelJ3d09tMitxemVh?=
 =?utf-8?B?NktTcDcxMTdFcnhJamJqM1lrOVAwTWg2bmtZdHFRMGUzLzBDVDFWaVA5WjRY?=
 =?utf-8?B?UkozNnBVWlp4ZW55Q29hVXZoZTh3Mi9IVjRFVldLOWZxSncxNmxmQVBEdTZr?=
 =?utf-8?B?Q0RCZkpZVkludTFKNmJtcGEydWlCR1VCeElwdEVlbTl6VDYydGx0QVZ6TzRX?=
 =?utf-8?B?ZEdKZUUzNjVWaGtPS3N1U2hwSEI5cDdzNmtRTzdhZ2JLNmE0QlNKdUpWd25j?=
 =?utf-8?B?NjhPYnVOei9ORU1HMHpoYlpsdE0zZGhDZEs1WURHbG8wMXovRVZPK3J1dk9D?=
 =?utf-8?B?NVByMW9Zdng2WTVQOGZGVHR5RFpwZGpiQ0JPMHZmR2QzV0FTSEhIWHB4T0d0?=
 =?utf-8?B?Kzh6VXZsOEI4YmRiR2Z6cDdpTnQwUnJHem5Ec3hxaUFPVW9kTTRTa0szemxR?=
 =?utf-8?B?ZWlES1hJNFFLVWFjd3JDWWg3N1lYUGExVzBHeDZjTzQ0YlFERWNEbHZUYklY?=
 =?utf-8?B?NFNmeDMxeE53VGx3M1ErKzIxdFZWQ0poWFl0V2NHbnMxMTdoalJwVkVRSGJ4?=
 =?utf-8?B?UmpmMDhpa2FEWW0wUXQrcGhQV0RWRURYWHZCUzUyZUhoeVUxMnNtSlM2dFhS?=
 =?utf-8?B?OWZ2ekc4MnVheDczS05sQk9jVnc5eVg5amhMTnhxMW1aNXdEZGVRZ1hidy9x?=
 =?utf-8?B?U1lndnFJTVNOUlNGSDdLR3V2OG02Y3dIQzA3NlZNSlk1dkpXWHM5VkdhZ2p0?=
 =?utf-8?B?WU1hMDZGZHFBZ1ZZS09ZY1pFQktwM05EbGc2L25hWktUZzYxZUcvWU9tbVFz?=
 =?utf-8?B?d3YzdzlxSDkzdks3NU5CMTZQOFBrTTIrK2ZMK3I1d2JrV2JvRGJmVmVoTXlZ?=
 =?utf-8?B?L3M2MWdmMG9rL2FqRjArOVB1NURGVDAyWjE2c3VkNGc1Q1VMczFVb0drSnpC?=
 =?utf-8?B?eUZFUDVVZDBqYnFKNUJCSE1WSzNqenVLOTJGT0tOOFFMTjdFNEp6dnhZdnNj?=
 =?utf-8?B?d3V6Y1FVV2FKSWRYYWQzWU5lcGFPb2tBblFHaThiNm50dDRCNzB1M3BkQUs5?=
 =?utf-8?B?YUdqTkYyRGs5UHpBbDAxYUtrMWUyZmlzVkhiSnJtcTBYTUlXMXpZSXJueDJ0?=
 =?utf-8?B?ZkNzVGNzZXVOV1h0dVpKaVlMNzgreVByMFhnczJrQ3NrT0szcGJZYmpYQ3hz?=
 =?utf-8?B?dFNCdTlTUmdsc2FpdC8ycDJJQjR5eTZudWUrSjJXZ3lsYjlLU004YzJXMkxy?=
 =?utf-8?B?cmVCTjBMUHBCK0Z4dHhkcGFXMDI0aUttY0lGQjN4eWZxdGVlaXllVG8vRTZM?=
 =?utf-8?B?ckxVU096QUNUcGxtZTNXQkdhZXpzSmd5eDFqZFdwOWV6NFVzM1pYVkxGVGta?=
 =?utf-8?B?SWs2Y2lOZ3RpbkNuTkFZUWcwbHRVLy9RZkpPZnIvZmZ5cnhJTGx3UFRqRXY1?=
 =?utf-8?B?ZW1zQnQyNDV5YkxPUzF5bVRtWUlUU2RXSXVKaExXVk1FaDg1NU1rVm5FU0RL?=
 =?utf-8?B?MTYzbzRPMytKejZsc1FKbmlkMjVOY2tvVmVzT290dVdNZE4wdktrdXVHaTYy?=
 =?utf-8?B?UkY5THNlNE0ybUJ1bW92TzhrQkI3V1A5K0xpK3pHTU4rY0d6bk8yRktpUjFD?=
 =?utf-8?B?bnJpdDh4a1VYSWgzQnJPa2cwSXB1Y3dPVDJaZm5CVE9uSzRrdGlFdFhGc0lz?=
 =?utf-8?B?NWN4R2hOa0JDOEUybVdIclBvNGpoNHVTYXo5SEI2dWk0SFlqbVIrZEdUWVc2?=
 =?utf-8?B?YjJkUkt1enJiU2NvRTVpSHFTbUQvajh1elh1WlhLdHZxdXgvNFV1ZUI1ak56?=
 =?utf-8?B?b242cjdsZU1qM25EZjd3Snh2SnFJN1dmMWJhd0dBYmRpRUIxUlF6MzZWUU9N?=
 =?utf-8?B?a1RNTlg1WmwxWDgvSE15c2F0ZisxUWNoV0dkMktobDlLMjRVU0MzQVRMYk5Q?=
 =?utf-8?B?R04vRUdKNWd1Y3Q5TXczN0VEQ1M2QTFwaUUyNTNpVHFkVm45U3NPdFNxWXg4?=
 =?utf-8?B?MXcxSnFGMXJ1NmhjNGwzYVFUcDR6blVuK2VaeXo0dXhzYjFZNktMWmx2UTMx?=
 =?utf-8?B?eURuaVl2QTlQTktmWUVtaEJKdnNYWWsrMFFwVkNqNlFUZFp1c3FWbHFvWEhp?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10387F287D438147AD66D73AF165B428@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eGoEyrBBg+wLMcelgOlN2uzuDmjEwZUOkwa+67ooOytaNIvHXVOvuY1Hd7KE7cstM7NkOSKuIt8XIZBdBMOeIgqF14Lb1Bxw7pXOaQmlLIBp4V4CRf5biEILhoLyjvrbss4whNpWEvyjG9Xo/wXapobo+GaS0hdy9fkypVTAP4e8uQNC7uAKWXYXCh9V2EsVev0uuy/oQGhHdyKCwUcNw4NM+omrhXmWbwlhxS346RqzAl+WoGtBgVfWL8EzisEQ6UHC5T8mofopPcmJoxrUw+w0HeY7RuozHR2oUInOA4U+RI6n8h5r4/01IE5vjdm6spQAAxgnrve44ImyJeTQQIZFcLTLnRoWoceZHe1v7mDFHt5Zims7dSwDg6okUj6J7bJdw3Bgfm8ZpnO9CWEGWZ8njRCHwjBYN4qzbfzmTlcfoxE+vwOwh3hzktLENiTJ07MlG8e0Yfrc5r1d09tt8rUB2m98KjB6FoAINzbduPOFL1F+mtDbncVSSAW/uqX7JKzVPLnNUwq8lwPtsSWredxSU9L234de5/ST4xB6TRpYbk1KdPsTI/Fu67Aj4Eu/yXwYIGXCXSZvOTJc55zH4T7HMPshpgLXygoeSPmoYpFLQLhtwZmrBjqtd9MV5dBP
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ab1567-a50d-46c8-cc3d-08dd864b00ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 11:51:24.7872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQLiHNFTWdQ56BXmKIyhXkEi/T+dpj7+H5VPtPGKGN8akCfaEDNsmHW3WkeyKF83oLR6zZB9XBdLifqMIdctGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6582

T24gMjgvMDQvMjAyNSAxMTo1MiwgQ2FybG9zIE1haW9saW5vIHdyb3RlOg0KPiBPbiBGcmksIEFw
ciAyNSwgMjAyNSBhdCAwODo1Mjo1M0FNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
QWxsb3cgcmVhZC1vbmx5IG1vdW50cyBvbiBydGRldnMgYW5kIGxvZ2RldnMgdGhhdCBhcmUgbWFy
a2VkIGFzDQo+PiByZWFkLW9ubHkgYW5kIG1ha2Ugc3VyZSB0aG9zZSBtb3VudHMgY2FuJ3QgYmUg
cmVtb3VudGVkIHJlYWQtd3JpdGUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSGFucyBIb2xtYmVy
ZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KPj4gLS0tDQo+Pg0KPj4gSSB3aWxsIHBvc3QgYSBj
b3VwbGUgb2YgeGZzdGVzdHMgdG8gYWRkIGNvdmVyYWdlIGZvciB0aGVzZSBjYXNlcy4NCj4+DQo+
PiAgZnMveGZzL3hmc19zdXBlci5jIHwgMjQgKysrKysrKysrKysrKysrKysrKysrLS0tDQo+PiAg
MSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+Pg0KPj4g
ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfc3VwZXIuYyBiL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPj4g
aW5kZXggYjJkZDBjMGJmNTA5Li5kN2FjMTY1NGJjODAgMTAwNjQ0DQo+PiAtLS0gYS9mcy94ZnMv
eGZzX3N1cGVyLmMNCj4+ICsrKyBiL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPj4gQEAgLTM4MCwxMCAr
MzgwLDE0IEBAIHhmc19ibGtkZXZfZ2V0KA0KPj4gIAlzdHJ1Y3QgZmlsZQkJKipiZGV2X2ZpbGVw
KQ0KPj4gIHsNCj4+ICAJaW50CQkJZXJyb3IgPSAwOw0KPj4gKwlibGtfbW9kZV90CQltb2RlOw0K
Pj4NCj4+IC0JKmJkZXZfZmlsZXAgPSBiZGV2X2ZpbGVfb3Blbl9ieV9wYXRoKG5hbWUsDQo+PiAt
CQlCTEtfT1BFTl9SRUFEIHwgQkxLX09QRU5fV1JJVEUgfCBCTEtfT1BFTl9SRVNUUklDVF9XUklU
RVMsDQo+PiAtCQltcC0+bV9zdXBlciwgJmZzX2hvbGRlcl9vcHMpOw0KPj4gKwltb2RlID0gQkxL
X09QRU5fUkVBRCB8IEJMS19PUEVOX1JFU1RSSUNUX1dSSVRFUzsNCj4gDQo+IAlEb2VzIEJMS19P
UEVOX1JFU1RSSUNUX1dSSVRFUyBtYWtlcyBzZW5zZSB3aXRob3V0IEJMS19PUEVOX1dSSVRFPw0K
PiAJUGVyaGFwcyB0aGlzIHNob3VsZCBiZSBPUidlZCB0b2dldGhlciB3aXRoIE9QRU5fV1JJVEUg
YmVsb3c/DQoNCkJMS19PUEVOX1JFU1RSSUNUX1dSSVRFUyBkaXNhbGxvd3Mgb3RoZXIgd3JpdGVy
cyB0byBtb3VudGVkIGRldnMsIGFuZCBJDQpwcmVzdW1lIHdlIHdhbnQgdGhpcyBmb3IgcmVhZC1v
bmx5IG1vdW50cyBhcyB3ZWxsPw0KDQo+IA0KPiANCj4gLUNhcmxvcw0KPiANCj4+ICsJaWYgKCF4
ZnNfaXNfcmVhZG9ubHkobXApKQ0KPj4gKwkJbW9kZSB8PSBCTEtfT1BFTl9XUklURTsNCj4gDQo+
PiArDQo+PiArCSpiZGV2X2ZpbGVwID0gYmRldl9maWxlX29wZW5fYnlfcGF0aChuYW1lLCBtb2Rl
LA0KPj4gKwkJCW1wLT5tX3N1cGVyLCAmZnNfaG9sZGVyX29wcyk7DQo+PiAgCWlmIChJU19FUlIo
KmJkZXZfZmlsZXApKSB7DQo+PiAgCQllcnJvciA9IFBUUl9FUlIoKmJkZXZfZmlsZXApOw0KPj4g
IAkJKmJkZXZfZmlsZXAgPSBOVUxMOw0KPj4gQEAgLTE5NjksNiArMTk3MywyMCBAQCB4ZnNfcmVt
b3VudF9ydygNCj4+ICAJc3RydWN0IHhmc19zYgkJKnNicCA9ICZtcC0+bV9zYjsNCj4+ICAJaW50
IGVycm9yOw0KPj4NCj4+ICsJaWYgKG1wLT5tX2xvZ2Rldl90YXJncCAmJiBtcC0+bV9sb2dkZXZf
dGFyZ3AgIT0gbXAtPm1fZGRldl90YXJncCAmJg0KPj4gKwkgICAgYmRldl9yZWFkX29ubHkobXAt
Pm1fbG9nZGV2X3RhcmdwLT5idF9iZGV2KSkgew0KPj4gKwkJeGZzX3dhcm4obXAsDQo+PiArCQkJ
InJvLT5ydyB0cmFuc2l0aW9uIHByb2hpYml0ZWQgYnkgcmVhZC1vbmx5IGxvZ2RldiIpOw0KPj4g
KwkJcmV0dXJuIC1FQUNDRVM7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYgKG1wLT5tX3J0ZGV2X3Rh
cmdwICYmDQo+PiArCSAgICBiZGV2X3JlYWRfb25seShtcC0+bV9ydGRldl90YXJncC0+YnRfYmRl
dikpIHsNCj4+ICsJCXhmc193YXJuKG1wLA0KPj4gKwkJCSJyby0+cncgdHJhbnNpdGlvbiBwcm9o
aWJpdGVkIGJ5IHJlYWQtb25seSBydGRldiIpOw0KPj4gKwkJcmV0dXJuIC1FQUNDRVM7DQo+PiAr
CX0NCj4+ICsNCj4+ICAJaWYgKHhmc19oYXNfbm9yZWNvdmVyeShtcCkpIHsNCj4+ICAJCXhmc193
YXJuKG1wLA0KPj4gIAkJCSJyby0+cncgdHJhbnNpdGlvbiBwcm9oaWJpdGVkIG9uIG5vcmVjb3Zl
cnkgbW91bnQiKTsNCj4+IC0tDQo+PiAyLjM0LjENCj4+DQo+IA0KDQo=
