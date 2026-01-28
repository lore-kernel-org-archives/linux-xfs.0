Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F773288C22
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613068; cv=fail; b=Nm1x801ruHqF66UjTSfA+IRHX8wXoijMwCIh4jQ4tL4qAkwHMCb+UcTB6j7X3JwJ+7zddW+G6CeuLfYxURSuMQG2kyFM6RXUSI+sA776eWHF6oQ8RMK/lKD4Hjyksz+615HrOENxbiHOgHME0YG+PR8qs/oTeZ6a13iHydapTxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613068; c=relaxed/simple;
	bh=yn67pwF6ipR254dsuRHsfmtgP6qGOGwRTwuNhif/r3U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PvASKUYrjKYpZ3uwo4UkmzVOZmlIrg3H7wJkBNrmLXShVSHwdFKJcpEuu1rcI+na9qJCE3oVEjT4EPVBBsbyljr2C/2UzPHNGKKGM86ztXw+uQAKcucsrTZ1JZW5Z13lZtyvBYtPA4h1VU5NbHI4tDm61ZHgWNsJTlrjfP97Jvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JGzizwsK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Nsf5bSth; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JGzizwsK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Nsf5bSth"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769613065; x=1801149065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yn67pwF6ipR254dsuRHsfmtgP6qGOGwRTwuNhif/r3U=;
  b=JGzizwsKVpCuqrDIt33vTNMUKPXQoK4ZaqwnnYq8wCnfCuqdoGtmke2X
   sTe8ntQ2BRXlo5ykPInu5hEAcnlJH+o9N+GPSZyvRGt61/Eocp8s9WwJB
   hzE23Cm3iqebm0Okqo8g/Up9t0B2lhgyrKrHFDNczsFQQsvhoV96e+vhl
   gJs04NJd8/RgkwF7fH14Jv8ujc18LfWkKmTOPGQjzsaQ8oAbntRfHPoBo
   nqlhnoESFna2i7Q5KeXrg2xLtgxYrhQZn6F2+EqODKaxHJJ6iI0WLYj+3
   iBNFzIRceFdSYECJ4WTaXma09sQuISyEkCBB1ND68EM5RmlMPSGmmiOWE
   A==;
X-CSE-ConnectionGUID: ken1NEOJSNOTn6Gk9f4Wng==
X-CSE-MsgGUID: ab0XvXMmRAOmEwlskhJ6/w==
X-IronPort-AV: E=Sophos;i="6.21,258,1763395200"; 
   d="scan'208";a="139640950"
Received: from mail-centralusazon11011066.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.66])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2026 23:11:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4hen6gB/doSGNMkxQ+xQ9y70VWjwY8miDsvQlzMQGEsyVYIsokc7RHpRktewHPJw0heyYxPdOmxS3VugU+CEvPwt5EpquNdRb1Z+IVAzPl923lF/5n1idoNxJmXd3diSdqIxcKan0U+BmCvXn2IJZQK2rVIKPhu2WFmzbtbtcREvU/EPQTaohztFQu2/Kz9tZfPhHEmM06IZojf60iykmdnn35d5DbkH55byFUH1EUts1KBrBCLSwNBMkDKeQ3bzKke9O1mcYodF1G/A6IYvLmKl4HReatyMQIjHDjFJphUrwj5VoFAnYTb9B3A8QHAxJTuKzdN2DRMGxrdISI89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yn67pwF6ipR254dsuRHsfmtgP6qGOGwRTwuNhif/r3U=;
 b=bRMHaMr4aJqpy9GOwmusq7ROdc9qBfg9A8EXQEKrIFjJ4hc4l4Eq4TBHD//t1gTH6Fkm/XByl31WsMna3MBGuyuSU6TIUVFQrrB1J1UAAQMT3TBrvXA2p3Ezs+9SjXhBkpYWIR9BSkDnuhykazZYt7YDe3C4Xst4meJzAN9ExQvTd+VvVNKQP+moot9J942s+ZUhe8AHK7TZLhmudg1haHu9SEiUC6+gBO+I2cCfLZpTnxRicxqK68XRKN7hAmMUJCtS+N6fR2zerlQE329VCZa8FjmexHoHRgtSGCbTXDssPsPx6yTRFKN4kRzrIVBHsN9TAY5FdnP3lrxZj2RTwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yn67pwF6ipR254dsuRHsfmtgP6qGOGwRTwuNhif/r3U=;
 b=Nsf5bSthl6E+lpo0xrrIR+nhHwLURBxEBsDbmHkoUr1HFC945kZDtIFqJmMX79erRvSMpp8VskX42GeJy0E49Mo4RlVnacpInFTAd1F0pOsUpVi9kla3a9sTFm4Yb07ryiGxTG8qeCnLFOLmZsiTjhXgvCYL81ztXRvZ9HG8O9M=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by LV8PR04MB9005.namprd04.prod.outlook.com (2603:10b6:408:191::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 15:11:01 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 15:11:01 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Thread-Topic: [PATCH 10/10] xfs: add sysfs stats for zoned GC
Thread-Index: AQHcj6cE1kXUGEYG50iEjqwY9phDHbVnit8AgAAWHYCAABBVAA==
Date: Wed, 28 Jan 2026 15:11:01 +0000
Message-ID: <a589bf70-883b-43da-a6fa-438b0c0d3467@wdc.com>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-11-hch@lst.de>
 <8df94cf5-20d0-40ea-8658-d24769faf7fd@wdc.com> <20260128141233.GC2054@lst.de>
In-Reply-To: <20260128141233.GC2054@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|LV8PR04MB9005:EE_
x-ms-office365-filtering-correlation-id: 2bd82c6c-0c2a-46d3-f0a0-08de5e7f72ca
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bjZVTmtjY3Y2b2JTeWQ5MHByMk54c05hUXRGNEVQcjJoYVd5NDdqNWtRSzR3?=
 =?utf-8?B?SEVZQTdDN0NCYm1pSEtDTnhNanpmenFiZC9iSklYNFFabHhoQ0RZM3VOR3Zt?=
 =?utf-8?B?OHU4LzNlUlpPUTNCT2ExMStqNHNiNWlLbzZFR21EOGdBZXdhTUZkSkpRcllT?=
 =?utf-8?B?bC91NS9tRGgyZEdlODFOOEsrRGMyMkx0MTIxUjR5VkNRb1h2QUpVaGp0TGE3?=
 =?utf-8?B?T1RWL0tDL3JjWEtaS0MxUE5xVGtrSmZ2WWVxb0NOOEY4WlNrOFd3ZnZDaStH?=
 =?utf-8?B?WHdEVExJaHZJZ2o0b3E0cU4vQmk0eGMxTU84elBpemN4V2hrbFpNMjFIMDhw?=
 =?utf-8?B?YW9XSDU1c3NaVnNidkhwMFlZZm1mMEJQNUdmQWhPQmMxQVpqaDh1ZjBCcFRO?=
 =?utf-8?B?UFdubXc4OW9Ea3l6NkNRb256a3QxRkh6bi8xTHlENnBvendYelU0YjhJTlhl?=
 =?utf-8?B?Z2J1elhJUXVZRktKMVJBWEVDOTFLTkNTNnpqdlJ4RG1yRjdxMitNOEdINEk5?=
 =?utf-8?B?UzM3bGNGbTNaYld5RVRPTG5HNFNBYlNSL3FMU1VmZlFpbW5BbHZGUklUVGdM?=
 =?utf-8?B?TFg4MXE3RERJcGR3UmFVajBMZ3p2VERFVVNuQk82VktDUXpsU3ZRWkhoQzh1?=
 =?utf-8?B?bVMwdWNEVThmOWxvRmp1K2ZHdExacUFhRjFnVmx0ZzZzYU1jZXFKcTluZXpx?=
 =?utf-8?B?YWhCV0FnVFc0eW03VEtBcUFDMjdUbmFOaGhqSHU1WEtESDFxeVk5b3JDR1I0?=
 =?utf-8?B?ZUJJV1dCZE4rMHFkc3dqaFI5NVJhb3pMY292cHQwU3BVd2xiNXpCaFEyWTJy?=
 =?utf-8?B?VnNOZDN0UzNGRitJdll4K1Q4WDIrK2JXREZwbXg3Y2VzWm1aOGdqMEtNRHBk?=
 =?utf-8?B?TDhrK2grZnpIT0pScTg2NC9MTlpUYlhpTjBOR0x4Z3BCeXJPUStuRjZXdlQ4?=
 =?utf-8?B?eDJieFROcWZobkh2ZnkrWFI5d1VvUTVieE9VaVJTcktDOExxdTFWK0dwSXFq?=
 =?utf-8?B?Q1ZjOWtQZDZtWkZpN3Q4Y3RhVlRqSEV4SGVJekhIOEp4cjBsbEFibFlLVVhy?=
 =?utf-8?B?amx5SHFZWWJZVHhURW5BR2ZtMEhZQ1FjSjJieEd1bDg1cjM1VGdGVmM4QmpX?=
 =?utf-8?B?amZpNGdTaURmdFdqZlB5b2FKMmtzWkFwUEhDZGZtVENoR2VkZ0hTNDAvbXFJ?=
 =?utf-8?B?UEdxM042NWxXTHgyVWhDMGhESXVVclRPL0hoYU9Kak0veTcvbTRkdjhVeXZk?=
 =?utf-8?B?NjF1UXVRdlhGRUNVK2pVNDZKZU5HVGVXQkNab0tiQVM1WHRsb0drdVZXbFJ6?=
 =?utf-8?B?R09nNjJlSm14VGlybkFZTnV0anRFQ1hoM0FtUzljWGMxWWU0dVJyTVoxbHEz?=
 =?utf-8?B?dDRyU2FSTE9VNVRGZGFaMnpxclpyajF1VHVyTldTcTE3TEhBRkFyak1wRE96?=
 =?utf-8?B?Mk9YSDlxbXU2NHNrYVlYWVZDclF6UWticElWRVRlMmw3MklqV05HS1V6RFNh?=
 =?utf-8?B?NzRPN1ZHY1F0WWNVWjVMQ3JRaGpFRFJDODY3cG0rYStCcldtMHdFVURDZ3JN?=
 =?utf-8?B?blM5R0tERDNCUFVENUthcGV0UE9IWG9nMmdGeEExTUZmM2ZqZVE0MzhxNDYv?=
 =?utf-8?B?eGVLMGFUSytsc3lmT3krd1c3Z25CdlA0Rk9tSnBybFY5MDRETURXV29WUU9z?=
 =?utf-8?B?Y3NheGM0RVpRTnFvVzZ0UVlaZmRSVnZseThEU1RmeFp3aW5xNnJobDlOdXlO?=
 =?utf-8?B?a1dacDdocHI0RlhxaTk2dkVyaDZuOTdkYzJSWGwzUzFHRnBib0cwbFdNTENm?=
 =?utf-8?B?ZVZrMmNaaTBIb3VydDFpOVJYU0l2Y3pjbEpxV3hnZzluUG1RblRxVXlMVlNL?=
 =?utf-8?B?NmdNOWVDY2lPN1JrTDIyM1FaWjFMSTJiNU9ucy9KN1ZZZGgxVFZ0TllEUGZ3?=
 =?utf-8?B?aStrNmFySWxCR1o2QkJSU3NXVlAyVExlaGpKSXRjWnFIZVNtMWFRR0tJa1hE?=
 =?utf-8?B?aWltNXJsT3QrUXNCYytMS2VqTGE2dmx3Y2J3Y3dtODUybS9WWTZKU3lHdmFp?=
 =?utf-8?B?eGlXQTJ1aHJjVXdWSmx4ZzM3b1RpY09ua0JWYU51S1JjdytZZGE2R3VDeXdm?=
 =?utf-8?B?YUl5QWl0WHc5OFhvTVMrL1BlRi9oK3VqVGZtZFAvOGxFYWp6aFVKR0NZeVJu?=
 =?utf-8?Q?RIo0JZs4joePzNq24PFI+K4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnNEMVJBMmNsKzMvVlh2RnBlZTRLQzNQdndyK25uNEZjYW8zN2tRYldxSWNB?=
 =?utf-8?B?UXdJdGZkQjNhcU1XbmRRdVhwUXk0RzdOYW5VTHdZOWcwMlJIU3lYblNuRGIy?=
 =?utf-8?B?WDJjcGtQZDMyUEJkTTJTUDlKcHNuWnVra0pITWQzYXlWRDVVblZ2TmxGK1I2?=
 =?utf-8?B?S3NlbGVOakZoN0l4Lzdvd0hyU2I0d29LUzVMeXZQREtHRGMrdDNaUit2OTE5?=
 =?utf-8?B?TUU2aWh6REdzd25pTytIQ1QzSkNFYTlIZnc0K2ZjV0RodzQvZTFuelpKK1I0?=
 =?utf-8?B?SXp3TDRaWDBGemhXSWhBbjBXOWpFRUc3NnpIWjIrZmlpaTVrTi9aTmRibzdk?=
 =?utf-8?B?QmdVYmJLbTAzUGMrUktUM2tQOFplRXVWcUZlblFvVW1hQVVCSEJZc1JudHMy?=
 =?utf-8?B?RGhzd2FSeHRzTjdhQ09rN3AwVjdpSDAvQlhnR2R6cUh3K2JmQnFlbFBUV1Vn?=
 =?utf-8?B?Zi9WYURNZ2RlSnZHek5pdnFobUphLzU0aFdWT1k5RnFGaFZaT0o0ckZ0OXQw?=
 =?utf-8?B?NmFlZVBJczlvQVU3Qm8rVFRIaWhYbElZT3N4a3lRMFdwRkROcXpaR1lLY3JB?=
 =?utf-8?B?NDVtOSt2ZGJoYkJtTHovamo1WHNKSUE3RnRRK2k5Q2o4ZWpmREJsTUV6V0F6?=
 =?utf-8?B?VE9RTHN2dXJya0xmeWx6dy9SZkw5aDNCQ0hhOUhtVktZcHpTRS9lUmREeDBK?=
 =?utf-8?B?MEFSalo5SGdacjNMb1RlT1YxRGFYc25EamxCa09Jbm9jQzNhUU0yWW45R2pL?=
 =?utf-8?B?SjZWcWJIWnFienNEMElFUEtMTlpJRG9PbWZMb01uNWpETHhvbGU2L2VxNUx3?=
 =?utf-8?B?aTUrSlhETlZseU5WcXAzZGhwU1ZRZjAweEdiV1VmcGFHRThKdDBpNDVuQUhF?=
 =?utf-8?B?cXMyRzNSNXpEeWtSUWU4RXQzUGpxZUNPQjduTW9ZV0MzcXBISjJlNHo2ZE50?=
 =?utf-8?B?MnFHMDM1QzBDcEozaGlOeURwVEtSNENaUUQ3REVGN0FtTDFqN1BNUzJKdEww?=
 =?utf-8?B?NUdjZmtEM3JMWi85STE4UW9wV2lzVFRMWjMzMWE4ZWxrR3VqQnJJZ3ppM1RU?=
 =?utf-8?B?RS9NZ0gwR0Vuakd2elk2ZlJib0tjL3Nuem1qQTNVNDdnYitBT1Vmc2lCZGoz?=
 =?utf-8?B?b2tFbXJtL2FLYTlkTmxXeFYzcGV3VlpmdE1FN05EL05nR1phYzdDQ1dyZmpT?=
 =?utf-8?B?eTJORVlNd2pJNno1d1hEWVhiaitQTFNIVmY5ZDJBd1Z4ck5IeWV3Z2c5QnRG?=
 =?utf-8?B?NGk5QU54ZDJGVWxFME5ZamtvYkFIQkFCUVI0RmJKQ0RBSjJQdGdCR2VGcmRT?=
 =?utf-8?B?dXJXMzhKb1Vnckl3cWdXM00yYXRHUVQyREJHeUJHK0VkMVRvY1M2STZRN0RM?=
 =?utf-8?B?RjhheHBaU1l3K2YzOC82Q3B0UEpqa09Nd1RjZkNHRlp2RHRDWHpvMStydmdR?=
 =?utf-8?B?NmxzclpzaTcrbzd2aHRReWppTmhkMmFlRVZNYXZ3UlFvK1FMaTVwKy95eDZw?=
 =?utf-8?B?MldXa05Fem42cGtJVjlBWWxHY2V5bm41V21hOEIxVjZOTTJ2TkRacjV0QUNm?=
 =?utf-8?B?ZDNTWjZqS2dJM3VMNkh2YnZBM2ZLVGVZbWVaZzFQSk1qUXc1QTA5UUZMZ2tF?=
 =?utf-8?B?TnhQcWhzZ0djdHJVM1AyOUFOcEtBQmVuaVFqL2U5TGZZOGlRSUU4ZXhKUTVR?=
 =?utf-8?B?TTBjcTArUEJkc0RsVy82Y1l0ZXJoTTZGRmlhbUxYOUxGZmUxNVl4d3NmUTZQ?=
 =?utf-8?B?eWxTNGp0V2FvOEpnM3p3TTMxQWFOUXA1eXVlQjBjTGJ5OVNXQllhUWpCR3l0?=
 =?utf-8?B?OU45STJNMldNbHcrMEdPVWpJNHIwTmVFcGpIdTJkVFZIWUgwVHUxK1dBZm9l?=
 =?utf-8?B?czhKT1dObEtFQm0vckVkUVhMVHU2QUdIQ2VqK3dZbWYyNTQ2WnA3MUdPL05y?=
 =?utf-8?B?Rmh6YWxiWERYbmZrenRCY0pUeDkvMmJoM3J3aHhYNjJORkRKeGV2OWM3Mjg4?=
 =?utf-8?B?M2FXbXRMczdzYklwU0J1ZFljRS9hakZxZU1ZMDRlOVMxV2YwZ2RkZjI5ak4r?=
 =?utf-8?B?V3kxb3Bia2plWlA1TmFRcGFCWFVER0wxZjNjUG15cTRhWmxxS0VUeVVTQXRq?=
 =?utf-8?B?cGZNQWdFY2gxNU1aTTBuRWVPbjBLbW5EUVJpQnJSSU0xeDhjMUY1eWJBaGpE?=
 =?utf-8?B?S01pN0lVUzk5MG9FQWpKaWVqQ3ZoZ0VoaE5UczE2anNKcWRSVTd6U0JMdzdN?=
 =?utf-8?B?OGZqaVJubGlHeXE3OFhrUnYxZTN2MDFUVGZhMVJmUWkzakNBbERZbVVHRGFJ?=
 =?utf-8?B?aytIUW10MW5kUUtzR0VOWmxYMnJiOVV6SHJDOWdKOWJkeWExL1pFaVhwYyta?=
 =?utf-8?Q?zInek2QTS/JYrsUw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <668A3EDB311F144DA1282AF04894039C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p5pPba8xvU4guWq+cb2ilgFnl8TbkahY+SRUj1+NSYdcHm362p4aTgtvb/m2upWjpy34u8PaKTvSMH9r4xZuqxf8peHFDB93OecoqhYjjie0cyLdq4FCP313saIXPjT+XMgA861uk8Zwdr0/IXvPEAGKWkD52uvn+i8hZAJ1yd+tU7JFzK3WuYBYxfIalrF4W45YwAsquvxM0aqcFj8U8TSfb2XdM5pRCTAEEZ8lCawxr9q669ASfXdOixsj4R7gxAWijjsveFrReYyLeNNy0iMF/FCjuHOn1woe/Y8RFQiGnxm3rWSJwIE2OEnHz04AZpxdbP6GoYrlC9EfTfrqd31fPiwq104ueEgnWnjGW37j0Pi2ygdgN6LUiPj7g/H2VkpTgP81/lqElGsJME+SZ9kBc+3fCbFbqCI9b2OxWC4K0CXQ13i54BY785Eawi2VEw4MiQ1JmSInkE6eBS9EvW/TjEU0EGcojU5Wn4dZ9GMqgY4xZ8Lxdd1BERVMYIkl05b2KgLt1IC3PSD22EP3njdiMAIUvChjTe5Av8KQC2cJdeQOE0SJsM/PhbU84iYMx++YnLFcb2Rb7gcH5eShgpyQKuWb+1RysX4dKFzeirZrJAXwdOuvYQuu8CIYN67X
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd82c6c-0c2a-46d3-f0a0-08de5e7f72ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 15:11:01.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Ht2bdPaRF8VWTz78iRyLpo7+y5M+67OF8hZqlA9xx02fDE9r3L9upTrFZEZ+Ox55xGKX3Fb/W1Gqq9VEN4pLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9005

T24gMjgvMDEvMjAyNiAxNToxMiwgaGNoIHdyb3RlOg0KPiBPbiBXZWQsIEphbiAyOCwgMjAyNiBh
dCAxMjo1MzoyNFBNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gT24gMjcvMDEvMjAy
NiAxNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+Pj4gQWRkIGNvdW50ZXJzIG9mIHJl
YWQsIHdyaXRlIGFuZCB6b25lX3Jlc2V0IG9wZXJhdGlvbnMgYXMgd2VsbCBhcw0KPj4+IEdDIHdy
aXR0ZW4gYnl0ZXMgdG8gc3lzZnMuICBUaGlzIHdheSB0aGV5IGNhbiBiZSBlYXNpbHkgdXNlZCBm
b3INCj4+PiBtb25pdG9yaW5nIHRvb2xzIGFuZCB0ZXN0IGNhc2VzLg0KPj4NCj4+IFRoaXMgaXMg
Z3JlYXQsIGJ1dCBJIHJlYWQgdGhpcyBhcyAiYWRkIGFsbCBvZiB0aGVzZSBjb3VudGVycyB0byBz
eXNmcyIsIHNvIGNsYXJpZnlpbmcNCj4+IHRoYXQgaXQgaXMgb25seSBnYyBieXRlcyB3cml0dGVu
IHRoYXQgaXMgYWRkZWQgdG8gc3lzZnMgd291bGQgYmUgZ29vZC4NCj4gDQo+IEFsbCBvZiB0aGVt
IGFyZSBhZGRlZC4gIEJ1dCB0aGUgb3RoZXJzIGFyZSAzMi1iaXQgY291bnRlcnMgYW5kDQo+IGhh
bmRsZWQgYnkgdGhlIGV4aXN0aW5nIGNvZGUganVzdCBieSBhZGRpbmcgdGhlIG5ldyBncm91cCB0
byB0aGUNCj4gYXJyYXkuDQoNCkFBaCwgbm93IEkgc2VlLg0KDQo+IA0KPj4gWW91IGRpZCBub3Qg
YWRkIGEgY291bnRlciBmb3IgZ2MgYnl0ZXMgcmVhZCwgYmVjYXVzZSB0aGF0IGlzIGVxdWFsIHRv
IGdjIGJ5dGVzIHdyaXR0ZW4/DQo+IA0KPiBZZXMuDQo+IA0KDQpuaXQ6DQoNCnhzX2djX3dyaXRl
X2J5dGVzIGlzIGZpbmUgYnkgbWUgYXMgKGl0IGlzIG5vdCB3cm9uZykgYnV0IG1heWJlIHhzX2dj
X2J5dGVzIHdvdWxkIGJlIGEgYmV0dGVyIG5hbWU/DQooYXMgaXQgaXMgdGhlIGFtb3VudCBvZiBk
YXRhIG1vdmVkKQ0KDQphbmQgeW91IHNhdyBteSBjb21tZW50IG9uIHRoZSB4c19nY193cml0ZV9i
eXRlcyB0eXBvPw0KDQoNCg0KDQoNCg0KDQoNCg==
