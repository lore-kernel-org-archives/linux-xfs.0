Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C462218580
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 12:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125164; cv=fail; b=qxGqEamP7hxYk+jXRQXkuKe1vchYtdtPuYiCFF0V4NXVJqy2DItw7qFreWYwGPZLSDLnnLi9ZvlS3R+ZdfZdwQnABSWFR7SN9VDujCQJElj9MuwRMpXBdy8ADidxgn+nxfD/5pQwHB2fb9ZBeECPIV0Ug5hzsiR1D0ILVxDz37M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125164; c=relaxed/simple;
	bh=upZpYHqv/V7D9V/LGR/9X2o5VcP3xGN8JKnE5012948=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qRVX+fgFl7VyuJsM/69qAm8GLNYoogcQLmD053S1Mk4opagiR51mxi2HM7p8nvMbm+8Q1Ff1jOd3i5Y5N3gflyzv1qrQt5pM4jwsrgLkWIRpmIMo4mOoarv9g5y4vWVDVwKC0GsJPbwDYCcAf1SapqJjIGL+ZzBxBjeInm11a9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gw567nu3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=zt5MiGmf; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gw567nu3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zt5MiGmf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749125162; x=1780661162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=upZpYHqv/V7D9V/LGR/9X2o5VcP3xGN8JKnE5012948=;
  b=gw567nu3rVuxPXBDCYp/xXurX481Oj1GlvrpTe1wRz1ejAVD/0dFjK8w
   CsK2uXBGvdjOwGMYYi3lWAdOQuSjDylFa37RTlfR9cRKmJnmyZuXiaoes
   vQqRiHRmR0vNfP9V/ae2g5MP8kWj3Q4uWHTL+t1CMPzwJnn0/gD3QY8dt
   GNSy3FJ66j195AxPmXdfcKKJ3AwF8OhxC/mJLpVbG0yaJMZlexsApIAQO
   Twp5RyTUBnDq/38FztWWqdcnXJk8hbpiqaDTPyosZdIYlCaXuZ18N1HCQ
   EYFMOSGMbwWQ/eUkyiqyUI7EmYwbP5om3G6gAHhfzXLj7iF/I6K4hFdSd
   A==;
X-CSE-ConnectionGUID: O27jk8gISsKkCb/j2HhWyg==
X-CSE-MsgGUID: OZWPGqO/Sd2+BVBLnaY/hw==
X-IronPort-AV: E=Sophos;i="6.16,212,1744041600"; 
   d="scan'208";a="83495518"
Received: from mail-westusazon11010011.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.11])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2025 20:06:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojzOdp5EB3If0obDRVOlf4kNYC4KB4047BbH6ixzlsmL2x3bdd5+tyOiOGX3kTQqdFhqi9zWiP7RVTwzeXsa/EM6hZHwZp64VwUiBNSHhf7H0WqI4BAHjxxQu2zLWVewQcNFFchUnIdevwAalT0s70niqWHb18YzgqNIle2KcquDbYJJiJvZugjtWn87ucbz5GvojpkqdSttk0WggfxL2TcfHqGoGnhSNINnQmUbcdNy0Mx21jtl20e3DwdDf2KK4MMkf3VEF6jzeUhbsT2gFMfQTpHRfqcdQXwzt6TZcB6K2Y0kydMhjinIw0Wgc856YerGmoKv3f+6hP/cuMcoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upZpYHqv/V7D9V/LGR/9X2o5VcP3xGN8JKnE5012948=;
 b=jCreZi0gT8ir4HT4XcBkm4goMeN/mPZr0TI+quGKildHqX7pk/xBQg4Mcpi+KWjtVIa/BWwCSf9DblCX+kpRf1xhvuaucgmMcgMInmagtRyJuhtsurR1UCBJw1FiGlG7G5egY0AjWgFHrzn4QGcyGyufEEjD5gdHx50RZhCz9FF6D7iIZu2ObAN1OqDY+SxpEu0YE2nN6SUjvIPl92mA1ZzMBlZcT7zEOFCUBCNuI5LTX901U/HHHn+IW7/hrsmzGn//eIbYcWE3hrLKDQAQ6Jk3j+AyDpqHixXmvKFKev7y2JxOLWmmnnIw8zCSXqcS7QLY0CTTPZYU3T10/wd99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upZpYHqv/V7D9V/LGR/9X2o5VcP3xGN8JKnE5012948=;
 b=zt5MiGmfe/GRRUfq5WNen3iUq/n+8ilrGDV14aGTYJoTgPECaFMJ2W0SOuRZ3vAdFZUbMRVPZpLG2lEiBj5CZQ7Sq368XWfCjSXCMRQkyZCsFLcdgwQ+kqdxkV53vcjlOK3gTNadoR9ScbF8OcgF4tchgYR6SXThao+DGIeK9+E=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MW4PR04MB7249.namprd04.prod.outlook.com (2603:10b6:303:78::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 12:05:59 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 12:05:59 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] xfs: use xfs_readonly_buftarg in xfs_remount_rw
Thread-Topic: [PATCH 3/4] xfs: use xfs_readonly_buftarg in xfs_remount_rw
Thread-Index: AQHb1eFz9S1MEI9+V0CRaG/l74tkQ7P0eKEA
Date: Thu, 5 Jun 2025 12:05:59 +0000
Message-ID: <9de0f448-f915-47a1-bcb9-359ae44dfc52@wdc.com>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-4-hch@lst.de>
In-Reply-To: <20250605061638.993152-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MW4PR04MB7249:EE_
x-ms-office365-filtering-correlation-id: 7a374a6d-738d-429a-e9b8-08dda429557e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U1VTQ1VWRitoRGhDbWlyeEpmRmNDVWpmYXR3ZldlMWNqMXZ0RnFBaGxIOUdJ?=
 =?utf-8?B?TjhYd0F1V3VYZHIxdnFSMkpqZVpRVE5qNXJVWnk4ekR2dkdJRndFUVhUM25j?=
 =?utf-8?B?NnhMRDFubEh5aTlXcmpiZ1JHNlRGMnVwM3hPTkMvQUtTSWp6QXFiQVM2SGtQ?=
 =?utf-8?B?ZkdkcVJ6RlRBUSsxd3hiMG9sTWdBS2YySnA0NW1WT2JCQ1paZjZNTERBaWI2?=
 =?utf-8?B?aWpFQU5heHBhbXJ0dlVtdkoxV1hEUXBBdjJubGlWbkNta3lnazRQWk8xMGcy?=
 =?utf-8?B?MzQ0aEVMcEExbDJ1VmtzaVhzMjZScVN6WDlQcGllMlJjemlzRWhhWWppVm9r?=
 =?utf-8?B?REdnMElCaWwwMmpNS1dJVVNMbWJUTi9PVlliNWZYV1lFS25BTG5UMTNpZ0Jo?=
 =?utf-8?B?a1RTM3h0WXZ1VVZoTUU4Vis5RDZ1eTZHS2t3aTFZUlA2SEJtS3Q5U1IvTXlK?=
 =?utf-8?B?b0JlOThMVHVlUmgxelhCSUNZTi9DYk1qdjRQZ05POENRc1UrS2svOG5zcHhi?=
 =?utf-8?B?ek9lNXJJMlI0N0toeGpTQTlsN1FnWWlVUm9JVzQvcFFQMytYVWRZUVRJejM3?=
 =?utf-8?B?ZWFSTmc5SlNTSFB3SzJHZWxIQm9hZlNrU1hJWlVXYjg2TU1BM2dTc3hmZjJh?=
 =?utf-8?B?eGdSaFNpTGk3VHFJQ054TURiMXhMdUE1WVhGdHpQOGVoNHFXRDJsUThpSHpl?=
 =?utf-8?B?RmVLeTdueW9hTklXclI4b3ZNMWY4R2hQNkwwUUc2cDh3YmZIVjlZaVFXVUxG?=
 =?utf-8?B?TFZGOUNjK1pub2ZiUll4N2hHS3V3Z1RMOXBteWpRZ3hDb2V5V1E4Sjl2VW5u?=
 =?utf-8?B?N1M5VTJtZmIxZWtmcEZJaFN4SGM0aWgwa050QlBJTDZYSkVKRHdrRyt4N001?=
 =?utf-8?B?THgzMFhTM2pKN1lPSGRKdWdNaG9kS01sN2RZbTRpdFpNVlQ4VXNoTkpDWnBH?=
 =?utf-8?B?WXNCbEpJN3l4VU5HSmNZNVlHWUw3RGVIb0RhOFZDS1pldVRZbnRYbVhUZEJ0?=
 =?utf-8?B?eEkwQ2x5c3JnOXo2aHJxdXAvYzV0YmJoYkVwbjRwLzUvODRPV1RqVVgyWXg0?=
 =?utf-8?B?a0dYZDdDNWhUeUozcHlGRTBuRDFqVlRUSE43WE5pSnRuSlEzc3BuLzVUSVl6?=
 =?utf-8?B?bEQzaCsvVk4xTnhFeE9aS2t6OVF1SW5yWUdRbEszd2JPZXJzR2NYYkdxUjNT?=
 =?utf-8?B?amY5M3hxSzk5Q2x0Z1o4ZUs4Y0hZZDRzZDMzUXFsNUYxMFJ4UzIrVGlTVC9U?=
 =?utf-8?B?RFNwZExyL0VudC9Hc2c4bVlLY3RnbVYwdkU2d1JiMGNpZGhqbWorKzlkekRC?=
 =?utf-8?B?MVpFdzhZU1dNeW13NERnNTdFOURCbkhLTXQ4cmdFRjQvSFZBelRNZnpCSi9B?=
 =?utf-8?B?alozWlRMUW8rWGEwM0l6a3BvcEs4cXU3SkwwczU0WXpsY251MUpsV2xkWENv?=
 =?utf-8?B?TitCVDNUTFBwS05VTmNVbjU0c3JLejQ4L0VwRDZmS1VTUUY3SG85SU9oNE9C?=
 =?utf-8?B?V2U0STBYUnZwTzdIaDBRYk01NGVXRE9TY05NMFZESTVCWEdraCtHeHFWaDRq?=
 =?utf-8?B?UkFaQlg2MVFkZ0UzRFNoRjlwNTRmQjlDU1JyTERYL05FWU41elBOOU9lazZk?=
 =?utf-8?B?N29JNjNSVzJvYTZHdnlvZnR5bFo2a3IybzQzQVpZR2R5TUNmUmo3dUhrVlpJ?=
 =?utf-8?B?NU14ZXVMeXFMTjFwOXJuRHVBYTB5UGNaMEpDanI5Y2VWUklQQVNCbTkzeFBK?=
 =?utf-8?B?Sk14S3QzTTdrNWZqTytyNENXY2p1dEE4am1ISlg4OFpJOGw5Qi9BTS8xSXFY?=
 =?utf-8?B?dXdHMXh6RFZ6aE5Pcjk5UXRhcW9ZNWpDM2pUd09UT1pjSFkxVnlJNmxFMlBN?=
 =?utf-8?B?UHZ4NWZreExwaXo3MHJGVkFyUUpmYWwxVGU5bVJhY0o5S0R6V3p5bXB3U25z?=
 =?utf-8?B?U2UrUHgybFZUaURDUTJyNytyM01RU25BL1JpUWExTFNGWUV0Z296YW9tOG1C?=
 =?utf-8?B?R1hkVnRZRDZBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a0phL2phczZwVVVtUk1ETkNYeGpYaXRwWWlFSHVnMjRoOVlWSkNVTTh1QUZU?=
 =?utf-8?B?RkIvaUJhRHpXcXNIMGNtRFh4dElMS0ZjRDhEcFBqVW4xdUJERy9SZmgyWlRG?=
 =?utf-8?B?Y3l2NHBuNVhaUksxczU3czlhZWxLZE8rY01KWWRJUXNIYldrakc3SUJVaitO?=
 =?utf-8?B?c1ZWVERrUlo3YUpzMnUyandNa21ZRldQRTd1SVNoSlpUdmZmVXBiR1BwRzVo?=
 =?utf-8?B?Q2Q3UUlKVXpNQ29LMGJOTDh5ZkJWenpMWlBrZkM3ZWF3enpuWExERUMwdWx6?=
 =?utf-8?B?aGJ3ZkxwNjRyWExOaE5ObzVXamtHbERNdlptcE04eGtGMUszalYrUUp2cjVK?=
 =?utf-8?B?VCtBVjVMb3phT0hrUEgzbHlIM3F2dFI4VndiVmo5Qmc3VVJrbkFIZ1JCM2Yv?=
 =?utf-8?B?dURVUExRYUIyOXBBNmtHS2UraFJMbDl0bWtrbnhUbGF2VnAyK2lYci9ZdnpX?=
 =?utf-8?B?M3VpcDNwdlRweUQrL2pKcWRaQXI5cXdUYUx2UlFnTHRhL21kSUw0Q08yaFdH?=
 =?utf-8?B?NjcvUEdHQXJ1bmsvbzYrc3o5OEs2NkpYdHVTb0dOUW9ZK3RJdUpRMzFEdVAr?=
 =?utf-8?B?cDRsVmFOTkEyVnpDZVZpby94QVVGNm0yL2JFTVV2aUgyelE5OTlBOUdOeHhR?=
 =?utf-8?B?UDV1QVRKY1F3aWdlMk9KSTgvMUcvMkZsQzBOaTBtejhnem0wUmwycnZHdzRz?=
 =?utf-8?B?VzZDMmEzUEFDTGF6VzM4aU9FSjhYaHZzRDJER0RVSXdlbFR4aXNlaVdUTHVL?=
 =?utf-8?B?aTZLMzFCdWNuZ1Joc1Jmdk9aT1c2T2hWQjB6R3dnTXlxM3NOMXZTUjBEU3Ba?=
 =?utf-8?B?Qk1KNVdETGRNVXl6SDBJeXBVK05reUJJTjB6MVRuU2dkV2NaL253eUlTSGZ2?=
 =?utf-8?B?SWhLcjF5UTFjQytxM1AxNGdkcHpRODJjOWhzdEt5emV0LzdMOEZWSVlJYy9t?=
 =?utf-8?B?RUVoZERXWHZ0MjVEZHhHTlR6clhwemo5TDh3eTU1VGdVUDBNSVpxSENONXRv?=
 =?utf-8?B?R2pSQncrOXVKRGcvNDh0VE1WVkZqNXRKNGo3Yk40Z2ljT05NelJVb084V0h3?=
 =?utf-8?B?MUJEZ1FpV3lkaGMya3BOZ3JCY1Z1OTU1OXl0ZnlHRGRiWVI3YXZkRW1mOS9V?=
 =?utf-8?B?dSt6eVQ2ZG9Fa1FoKzRsZUlNZzdNQUZWOTQrR1pPMVZKbzlwTkNNMmQ0aGNE?=
 =?utf-8?B?dzZiZld2MzJUUlJPeEpSQkt3RTNTMDU3WVd2Qk1icU5zQVJKZS9qajRYay9h?=
 =?utf-8?B?d0FPTURwMTJCOGR6cTRjOGg0TVVqTFMzVWNndWFUQTFGNjU4MklsL3RzdnhQ?=
 =?utf-8?B?ajVmOWhycDNyZGloL2ZVU29wTkxEM25yLzJ6TElKd0Q5Zm0zcklWb2RwU29k?=
 =?utf-8?B?SGhwc3E5UXZtRUZQcm5ZN0s3WEpJVUx4bFh1Y3ZKcmZ4eVAvRnBaS2RjeGoz?=
 =?utf-8?B?NE9PWE56NVZEZDV2R2VkYk02eXdZQ25Ycm5JYU9pN1RobmN2ZVlxa0NmMDFw?=
 =?utf-8?B?TWxIZzZzMUhGU0Nyd00za0huQXdJR2dPQ1NFS0Z4cUdsOThqenBxdlpwMFFq?=
 =?utf-8?B?R2tXV2c4RzBwQWU0R21HVXcyb1N3NWxvYStoNGM5L21TSXhRbm13SElpN3Ux?=
 =?utf-8?B?NmhSVGdCTkt6SDFMVHJBM1UwU2FqMjNsOGdoRS94QUhMdHhNK1NkZ2d6cElm?=
 =?utf-8?B?OHo0dnY3bXdPMjk0cjkydm50QzJubEQvL1ZLTExkYVZKTytCMzdBSFBCUnNU?=
 =?utf-8?B?dXlyQ0VnUHltTGpMZ0FHbDQ2N1JSOTdjNmViUS9Mc3FCTEpPcGp6cENpL2pj?=
 =?utf-8?B?T1NLc0ZqQUt2c05LZ1pMWlZvTXhTdVR3MGJzVlk4aGhNeW1OM1JjeGtINjFP?=
 =?utf-8?B?ZlRuRzE0Uyt0WUtWNWtnWHprcXQ3T3I5c2ZUWVF5eUQwQVo3RmNmTmdHV1FK?=
 =?utf-8?B?UDhDMWxhSzJ4Mm0zQkhTTEkyeVJMUy82dHVqai9VcHBDUGowU3dwSnhFY0VX?=
 =?utf-8?B?anlFZEJLb0dQZm1xcXllYktRWTNRZXB5UmRsSVBCRGgrb2ZmTDZQaDF4Smlq?=
 =?utf-8?B?RU1BdUVyS0pzWkM0SXNBYlRQZVpzcWgwQ3dGbk1za2pHWE5yRGZqUWJxc2lt?=
 =?utf-8?B?SVpVTGFZaDJWSnZ5bEZ4MCtBR1RVTmV5SGc1ZE9UdzJKMldDOXpjTjVSZm9C?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D734455E24E46429422C6E345BC27F2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/bhvQ49+khYFQjnELCl2QBi0v2MPagftoL3pqW2ps3R2loTAIgAu+X1PrBZ/scCfXyzKvL3c1tFpMX3dewwdzHg+Xd38d856ld4do+hR/KRHISCt+RoZ0gngCN/X5mb7asRXSdG8ZvfCOeXTOOzhQyJWRn0fJ88QcIRSMHHDD/miw/G0Hz2Nv3T3gEWT2W2qX/RGlNdVaXdO3xOg4Dzt7ks2PSueSex9mhIkk8fh5jlHlBJ/c1WRZ3mnuvESDIQDPXO+5MoSdQ+B6IzaYd3Llj805RRmqg4fG1aQXq/lg2/VFOCfkQJn80T0Gh3WNx293zalylb+8PKtlOQKzvGABHI1HaS6SbPc5PpQbUPjCyRleMpOyFnowuBN3Z3GiH/+n7hBEQ3lBtYZHCRY4e5Lyi8pOlji9XSYOY4rHPzwzaXtiLM7u7WiuviV7dw+kiMzBfkYpJrk/Kn2fj+Ao/4dtfJHIUoJBkHqDJnlZvj61heij81J9AjJpT83JGlDW/BommpyvknZiJvIvK+V/NQRHagBsZE8T4d8AOcVU+iE0EGpchaqF76mcTJ0RJ2U4kCa/W6RYaaqA5P0YzQrt3LWGWr5NBHHDphLqDAg4J1f62XJ1PsPBQIWl4Quc0UBaKXk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a374a6d-738d-429a-e9b8-08dda429557e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 12:05:59.1226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BiAnOuqy/Our6NMHS9gDIDWWxjaMZbSwYMGZhsBBLW/5zkE+GxiAT+CC4YFfB74+F0DQhNKRXKZ1icTLMekowA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7249

T24gMDUvMDYvMjAyNSAwODoxNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFVzZSB4ZnNf
cmVhZG9ubHlfYnVmdGFyZyBpbnN0ZWFkIG9mIG9wZW4gY29kaW5nIGl0Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IC0tLQ0KPiAgZnMveGZz
L3hmc19zdXBlci5jIHwgNSArKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3N1cGVyLmMg
Yi9mcy94ZnMveGZzX3N1cGVyLmMNCj4gaW5kZXggMGJjNGI1NDg5MDc4Li5iYjBhODI2MzVhNzcg
MTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfc3VwZXIuYw0KPiArKysgYi9mcy94ZnMveGZzX3N1
cGVyLmMNCj4gQEAgLTIwMjAsMTQgKzIwMjAsMTMgQEAgeGZzX3JlbW91bnRfcncoDQo+ICAJaW50
IGVycm9yOw0KPiAgDQo+ICAJaWYgKG1wLT5tX2xvZ2Rldl90YXJncCAmJiBtcC0+bV9sb2dkZXZf
dGFyZ3AgIT0gbXAtPm1fZGRldl90YXJncCAmJg0KPiAtCSAgICBiZGV2X3JlYWRfb25seShtcC0+
bV9sb2dkZXZfdGFyZ3AtPmJ0X2JkZXYpKSB7DQo+ICsJICAgIHhmc19yZWFkb25seV9idWZ0YXJn
KG1wLT5tX2xvZ2Rldl90YXJncCkpIHsNCj4gIAkJeGZzX3dhcm4obXAsDQo+ICAJCQkicm8tPnJ3
IHRyYW5zaXRpb24gcHJvaGliaXRlZCBieSByZWFkLW9ubHkgbG9nZGV2Iik7DQo+ICAJCXJldHVy
biAtRUFDQ0VTOw0KPiAgCX0NCj4gIA0KPiAtCWlmIChtcC0+bV9ydGRldl90YXJncCAmJg0KPiAt
CSAgICBiZGV2X3JlYWRfb25seShtcC0+bV9ydGRldl90YXJncC0+YnRfYmRldikpIHsNCj4gKwlp
ZiAobXAtPm1fcnRkZXZfdGFyZ3AgJiYgeGZzX3JlYWRvbmx5X2J1ZnRhcmcobXAtPm1fcnRkZXZf
dGFyZ3ApKSB7DQo+ICAJCXhmc193YXJuKG1wLA0KPiAgCQkJInJvLT5ydyB0cmFuc2l0aW9uIHBy
b2hpYml0ZWQgYnkgcmVhZC1vbmx5IHJ0ZGV2Iik7DQo+ICAJCXJldHVybiAtRUFDQ0VTOw0KDQpM
b29rcyBnb29kIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xt
YmVyZ0B3ZGMuY29tPg0K
