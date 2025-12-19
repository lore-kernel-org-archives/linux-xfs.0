Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B462FDC26;
	Fri, 19 Dec 2025 07:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130318; cv=fail; b=XN+X2N3sy5J4SWiDih8rYZkwRWDOLM9fxYgAlv6WSIXHnhb6YzIYtialflwJUJfeWz3dnGhdeyhIMNrF2AIbXEIw3wMN0s0yRkMQpnsgrw6h+4jj9f8ebFUyGg/imlM2RnVUa12umIIYpxQ8Z9FQgXbyAuYIOYtig2UQWLtK6lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130318; c=relaxed/simple;
	bh=5WvS6tWDVX/Bv86KAek4NzB06H3VdFqyYKhfQPveYX4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hO3hARmeln+A9kvTpyAbZUiybjPa3S1tt/uSu4jQymnOGLUefR0Q8RWt3I/ss6qjOnmkfvFhpy4XvN5kH1mItEFr7aUvCtN4eoeph+48ws5KPLnX9eVYhw+lObdR1ZTYdNGDJQQ/4g2+6t/r2hjWAuNRNj1a/QceDNBtPoijsEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eONLlOAP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=hm+heNKZ; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eONLlOAP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hm+heNKZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766130316; x=1797666316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5WvS6tWDVX/Bv86KAek4NzB06H3VdFqyYKhfQPveYX4=;
  b=eONLlOAPkeYytzrHIqFi7R6zxQ1OY+E1euRED+M25MhIcERr7G0nsdck
   KL5ueSJzUm/EGupdNGfhNOLQlTTHGhWtvRNnCpKIPM8CdajMGph2w3lIO
   nWUYyjokLV9792M2xFuUMJ6deVvl2hjpeAR5k1Ur25pT1RfhoQUkNkBHg
   JEaWQChvEfWmP6IRPA/q1IF9VRsyXUm+BPUf9aku/AKLKs3p4NWrxdXlo
   8lmzNRANf5xhLlw4wgOdLgwmq11rD3/robeiF0j/C1Xf5L9dQb/MIENic
   3e2QbBQbrHw1lRQF5VZwh3U5nbStn8kWIn+jtrKoDLnlxDv8R+BHu6ZMg
   Q==;
X-CSE-ConnectionGUID: iy0lT8SZS4WgM/d32CGyBA==
X-CSE-MsgGUID: dHTULkfWToqhNAJMGZbEoQ==
X-IronPort-AV: E=Sophos;i="6.21,159,1763395200"; 
   d="scan'208";a="138642701"
Received: from mail-westus2azon11010053.outbound.protection.outlook.com (HELO CO1PR03CU002.outbound.protection.outlook.com) ([52.101.46.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2025 15:45:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spNeCB7MIs6TanS+8vF/4HSfVz+KFlkEGHXAzkJHILPt3XsU4HQFH2URZj6g2x1uofdhUi+MG2UXH/mZEdtqnxWq1n7VYRQGrEBrps5wNK8wsbkyetkT99rAFZO3bYPtmfDvTl3tucvI9wiZGnKKV6DLQqFua7+tGXEwg+Se8S2N1qtkFl8bVhcDIcZW/lSzlliAYTH7BvFbAzR4+nrcDnOLJK97xQ4uKS1gGJen1PJR4ChU0KStQBVjr1W9QbMRnbQhyOcJyy7aNs5CoSjtU5nQS+mwjre4U50wMQ4dZ0zgHoMjCLiLZcPrk4a1SJskh2nO8BacV+d4Q7ENavkdZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WvS6tWDVX/Bv86KAek4NzB06H3VdFqyYKhfQPveYX4=;
 b=sUZChE+1mXnuYFkfygEgZwjFL1nZuTCHiqvJfzuOA5F0uJ0sWQBPKsJMN9nJKa5KEw9yT9+K6Lvg8oIjj/1jL26xOB8c54Z0f140NbSdzDF2HJ8efKE/9sN9mVsIpau5CMMEG3wc/7z5ZbFPCJJszsGVxPiHGkY6s6y2eFNyknsqD1+10gcc/H1dSwsNdLMOf4ZwwthJJ7Jgoei4fm+EVGxXrNHD5xuvbvsXrQeVplxS6mlVYf+wbCLkdWu19lfEvAkVVtvWN3m6A4Q0p4j/ZvTUqYsKMqHhfApKebJ96xh/ifop1fLUTL3rqljDxhd+/2PJfbhYhLhnjf7XeTZ6wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WvS6tWDVX/Bv86KAek4NzB06H3VdFqyYKhfQPveYX4=;
 b=hm+heNKZNETRjGNUZQ1mR5dVGEweToo4v3xBC4v4S2YjN/EoudgYl41nt+VTXK9z28eB7tvO0MmAdYPofa2BUpdHM6OuJJvBzrnXIbyGEqyI+tZVv23of+rZjEM3S8gzB1z6P8dqNIj3GtmqvDWlJCqvJ1CNchbbgdUUoa94x60=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6931.namprd04.prod.outlook.com (2603:10b6:a03:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 07:45:11 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 07:45:11 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Carlos Maiolino
	<cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Thread-Topic: [PATCH 1/3] block: add a bio_reuse helper
Thread-Index: AQHcb+ggz4lUBOHrQkKMuR45is75irUolvyA
Date: Fri, 19 Dec 2025 07:45:11 +0000
Message-ID: <74a800b0-3c19-48ea-8cbd-d8999ce3b50f@wdc.com>
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-2-hch@lst.de>
In-Reply-To: <20251218063234.1539374-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6931:EE_
x-ms-office365-filtering-correlation-id: 57601a00-1a04-473b-0be8-08de3ed28a1d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?S1dtWDM2NEdVaDdxTVBVWnEwN0EyR01sOXM1VFA4Y3llamNhdHE1dXcwZmRu?=
 =?utf-8?B?UlZPVjA0NFM5aDN0dFZKbVgvandUYUJZR2pNemlaTEZ4ZGhibGNCMHh0Wi9R?=
 =?utf-8?B?amd4RUJmbG9qMjVOSXc1WDdLd29rUlBnVnlueWgvT0dmVXc0cXE0QTJoUjQ4?=
 =?utf-8?B?UVZBMmpZeGo2SklzeWhicXM5WmJmUlVNck5ETnRhNW9DWEJGdmJPZWdZMUx5?=
 =?utf-8?B?UkxBQXNCa202R1huRmNMaGVHeXBUODhoWS9PUEhnTDI4RndjaHBwVFFKWG1p?=
 =?utf-8?B?Y05MN2pWcmlGT0JjeDVXOFZ3TjcraE9pSU1JS0NrNTByUDZKSmM5TFhHMHR3?=
 =?utf-8?B?aUh6bVVBZndCek5zand4S2VReXoyeGJPTFZIU1RaV0FCR0NTaS9LYnNWbUQ1?=
 =?utf-8?B?Vnh5eGZQZExJdHV3VG45Z3EyWS9rWkwrWlBaM3VReXZsNEk0UjBBcEZxWnZz?=
 =?utf-8?B?Q280Ni9qdi9tNXlldTBrY3JGNjFSaTV2NnY1VFBLMUpIOEZxZlFObVBRQ1d0?=
 =?utf-8?B?b2l3SHE3V0F6ZTlxck5jbEJuWXR5T2llNFplTWphL2loRUI2WXJMYTEzdXVY?=
 =?utf-8?B?UDcxeWRuOWFHMGFKMWtnZUp5cXI1UlhvRjV4QTgrVXpZUkYrYlVSTlhiUE52?=
 =?utf-8?B?ZGszMFJocXowV0YvMXluNWlTZ2o1eGpDZG1UcC94dEdEa3VaakxNd2JmcTZY?=
 =?utf-8?B?RVBhS29pYXEvWXM1dFFPc1NnWUU5NVhOaCtFMnIxL2NsUHZQSktJcjBRZGl0?=
 =?utf-8?B?MWVmYU0wWUk0THQ0MjAybzk2YnNucktaTWZSRVRRVG5vU0trSHRXOFdhMTQy?=
 =?utf-8?B?Zyt5T2dLOWFlSkhscm1VTlBrUGdCa3JqVDd5TW1UVmZpY0Zla2dQYVRPaGVv?=
 =?utf-8?B?WXZuRlRWQnN3eS9tYjg4bEMxVGtQS3pkcGRTSWdhVUcyWVZEYzZnWTZUNUtE?=
 =?utf-8?B?amlmMEhIcFhLeld5NUlnWnE2SEJudVZaQ0JkYWdNZ3laTStDdktmTFBJMDRY?=
 =?utf-8?B?QkVmRm5kVExpek5xWitLKzRIYzltcE50c1ArU0RLdjBqaitNZVo2TVdmellT?=
 =?utf-8?B?Q3JxK3BwNE4xVkhQV2hEeTlGbmcyK0dXeWt1ZWcrUWFZWGVMempoUGtYWXJi?=
 =?utf-8?B?a0hGT3F3TENNaE5iWFQ2cnJNWmwyOThUd0FJM0grUEFaVDR0Yko2VnAvQ2lO?=
 =?utf-8?B?VG5yZ1B6cVJFMGp5QlV5UmtwS0daYkFPbmxkalk4Z2ZsNjNFUS8zUmtGbEFZ?=
 =?utf-8?B?VlhWdytVR3BnNEJVdjZiMzNiZTVyK2N4V25KdUlZUGhsSkpUYStFem5hc2Rw?=
 =?utf-8?B?RE8yY0E2RHhXRUEzN201TWxUUlJjQm03UjYzUVhVenZpd1ViTUZSMHYrOVpZ?=
 =?utf-8?B?ZTlGNWZpd2JiWW5zaWVzMktzR2EydTdrY3drdnlqWDA1T2tkTHJSbVpzaWNP?=
 =?utf-8?B?WUxIRm5nN1MzWU56Q1BLU0NQUHBVdHgxVWJMVHJDRkVOZWtsTm1aUjMrWjZt?=
 =?utf-8?B?bDFEM0R1WHVFSUl5MVZOSCsvYnZkVFFwWGlnV1NpTW9vUVc2NnAzeHJOUHRW?=
 =?utf-8?B?R09NeXdsaFQyNEtVY0dlS0FhekxCczAvVS9Kb3pCdEhKUFladE50YkhiTUN0?=
 =?utf-8?B?NHdqSHNmR21KZThIdVhEaVY2akQ2Q1NNbDNHSm9yL0Viczh2RWpwekJONlor?=
 =?utf-8?B?UW1Eb3lHcHJkZ3o5cytNc2FWRk5VT0lIS1NMOWZzR1N0ZmxKcGtZVEZibkg2?=
 =?utf-8?B?N0V6OVpiRjUrMDUvVm5zZ3pST3BPN2h2WXIyQWhhYlhmT3hkSXYrVUtxKzdP?=
 =?utf-8?B?eWZhdWpWU1ByeVFRL3VvR0owNDY3blVqc0xScThtbkIrL0pkY1BKZWl0UUZW?=
 =?utf-8?B?dlZ4ZkdYZmsrUHptQmtBZ3hHMUxqQy92c0wxQWphd2dBOW9jSGthdTR1VWNS?=
 =?utf-8?B?TFFtKzRNL2ZPWEpITUo3cW9FRG9XajhUTlJjY2ZDMEtNb3VKZ09Qb2pqbFcz?=
 =?utf-8?B?T3VxMHQybUVZb1FONUFaeTd4WnZUbXY3MkM4bVlFT2F0K3BGUm5Uei9JM0Z3?=
 =?utf-8?Q?JWlWig?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnlhMGZ0cEZVamFKcXhUbDRSajE2WWRXYWZHSFh4SFRJVmpVRjhYMlgwaUpl?=
 =?utf-8?B?QzVLanNQcFdINTdtRWp0K3Y0aFZXTE1tYU9hRGFyYytlWisyZktvTDF6cW4z?=
 =?utf-8?B?cTZjbWp2VEh1QVduelNLZ255cFFuYTRqZm9LMUdZOTZxWGZNTWFoT3ZLU0sv?=
 =?utf-8?B?azZYeDZ2emxKUnJrdVhHL2dKQk5OOCttUWJYejdjeTJ3TEl1dHVlOWtGQW93?=
 =?utf-8?B?TkkvM2FSVStxZDh6aFcxVzcyZzErVmx2ZEpQaGhFdFJ4TFZtTnAxYWw0dXRU?=
 =?utf-8?B?ajl1NlE1ZitrbW1QR1J1ZXJ2ejZlbEs5NklZUWp6Q0xuME1HbXM0R1lYTU9o?=
 =?utf-8?B?VlAxb0pYY0JOTHlLRTJhY1dvakI0OTdSZ1JMNFRUM21sWmhhb3UrMUhLamRu?=
 =?utf-8?B?WStPRW5FRWQ4S2ZRYVBIZVYzT241Mm5YeUYybW00WFZVL0RnTmpJZkJTVWJN?=
 =?utf-8?B?ZHMxRS9CcUtNanRjTTdyRjB2TllQUWo3ckVBYm9SUUdkTm0wdWRGdWQwWkRZ?=
 =?utf-8?B?dVczajdDcFlQbnFTSlNReVdkZkxVQ1REWVg5UFdBTlhtOC9kUVBjdTJtQXFZ?=
 =?utf-8?B?UFNHQmNIZkxvNFFiblBIeVFHZFNWV3JFdU5seUpMZ2hXODZvclVQV3diUGgw?=
 =?utf-8?B?T0NNSTJJOTBuOG96dXRJV0hmU1BWTFo0eTNwa01LZFVuemZQM2lrTDRUbXc3?=
 =?utf-8?B?TkdHRVVHQUtPVFdNdzhLMHFpRFhSWUhlYzVqekVtN3VnNDB1bjZsY1NvRDN3?=
 =?utf-8?B?STVYbE81djBjbWlpVkMrTklscW9vTEQvTzNxaW55MjdjZEd4bjdZVkJLczlE?=
 =?utf-8?B?NW5YWlczTHhHa3RyVlFZRllaMUZaKy9Ic1ZTbzdJcDN6SDVra0o4SHFRQmhK?=
 =?utf-8?B?NFE3NW9UZGw4dXVHK3FjbE9SQVF4TjU5bFFvbjVGNjhMV3E4MlV2eXdnZ0Z1?=
 =?utf-8?B?NU1rRkN4M0hHUW9rcWsyaWhEOUM0VmNYeng4MWhrRU9oRUlUZUVic2VONlRX?=
 =?utf-8?B?Q2JiblBNdEYyaE53cFcrbzhMbkczK2dYSFg2dWFsbEc2em9DWHFtckRmdGpE?=
 =?utf-8?B?TndFY1RDUGp0elF0dGFNcWtUdXVLbkhpUUpIRldjQ2hiRmdHWGl3L0lqK0l5?=
 =?utf-8?B?UUVZcWYvYmVMeTJkeWxBL1JsNlNlQWdSMSt0NDNNOTBNYW5Wc0dlQ2FLWTJH?=
 =?utf-8?B?U29jS200TkNFVENuSjFKN0JNNE4xcTRxakFkSURQTmN2cVdTaXAxVUV5emFY?=
 =?utf-8?B?cmQyQlk3TDFIcnBmRmZlS3dHaG50dGFncUdHZnZGMCtrU3huQXpTRmw4YmtO?=
 =?utf-8?B?S2FmZGtKNGROLzVOc3V6TmpXQXJKMDh0RTBpUnlQeVpSVVNlZy9pZXJHYXRG?=
 =?utf-8?B?alEyT2FheG5qdi9vb0FML3VNQzlqOEpaU3VGV09NMGllcTFqdGtMRjUxdUgw?=
 =?utf-8?B?cjYyQ1luY21QQXhEcjBtYnJENTA4bHFrUEliaTNMWEx6eFowbHBFQUZXZTZG?=
 =?utf-8?B?TndmMlU4NERjaGhLRnphZk12U285SHJVR1VOUmRPTDhMMDcvQW1WamNBN1oy?=
 =?utf-8?B?Z0VENXIwdXYrWWFsczh0V1R0MGxQRkUwbUtGMGt5WmZwcGNuREM5ZlIvM3dx?=
 =?utf-8?B?U0NlVUZtU1ZYTFVwL21aZ0NLclpSTGJ3eTRJbmNYWWZoZEtHMjM2QnNnWXNo?=
 =?utf-8?B?eURSQ094QkZmVC9FY0FnMVFFeXJ0OFFQRnB5eFJsK2dEMHgyK1IxeHZkT2Iy?=
 =?utf-8?B?L3Q4UGQra29nNEk4aUFyOFNGcnVwNjhIQXQ2eHhSNkxlc1dIZnZSYTVuT0FL?=
 =?utf-8?B?clc2eldKZmNZWGNoR2JZQjZuRkw5T0R5SFRLMzdaNkhTOUp5T1RzUm9ZYUNJ?=
 =?utf-8?B?dmtER0VseHdlNjJuQm5JZHpBWE1XZDdQOUk1L3liNXNzbmQvSEZUdzgwdEhK?=
 =?utf-8?B?SnhGanFtYXBtS0RVamM1eThuMHYyZEFmZjVwQ01mZ2xKQ0NzeThXczJZOXpO?=
 =?utf-8?B?RVZ0Z1R6SStWdTdlMXRsOWorUjJtaFU4UC8xcmJ0bUtHV0x0T2ZtZW92MXVT?=
 =?utf-8?B?cnZaRGo3cUFCVDRUTzRVaE1uSFZYbnQ3K3JCbDhoWnZXZUFGdVh6S2wySGZV?=
 =?utf-8?B?dEpyaXA0THZBWVA4N0FmUmxGSlRTVGtyNW01VnBpdjRVU21YKzNKV2hrODA0?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AABE75B5066C534185ECB524955392C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fyE7k96LmS/QG1D0rZTGgLYJm5nxA8SUprcoCA3GTuPF/nvj9qkGaayfxFdoVcFz+bAvOraWWFzA0e4A0W8CsE9YFNL9bnXQLia6P+nmWR+HeNy5ew3xWPLaQBCc6sb0GHzavJ3kKnsQZcj3+7AYvrr4Kf4pm7iXUHSasqJThhqEIY9I1iY05U6SCTwrzZd3INgWtU59T4FXlZVAaKrupuFri3zupQ5n7sFraEV/vrcyqKq/ficOeIrYR9sYyxJpE6hLitfevn9FukEE4pXMvyhXZEs8d6oHfEI9oCrEWLGpDVlpllZg7Q5UP+fPykxkwxPALx8kja7XoOR1/MwQpD9BymMlVkrBz+Cm1lUp5PdFj+USdpp3RvmT6rwZ7thecy/ypa4cbmFyCO3ClYWZOcWxcqWnTKcykRYlIGTGV5XNXrrVUmiLEBacjX3p8jUEXjWobrrqR7lO/i5SgiIABn2zzMWPngfef8lH1r3fd9P6vc0P5zc3Sqak7IGFJIEKJW+i2epUDSoaAtiBy5Ew1NbXo8MTath4x7f2d/ipSLN53P6HBbhkasfJq6C7o++VwqHqV8TlvpV1CuSPOrnz5r8Edn4VYQVQuwbXRkG3xlmanz2k9082Hb6NYruHClMy
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57601a00-1a04-473b-0be8-08de3ed28a1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 07:45:11.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9GIXZEKKH8oKSjsO7uhsCiekWM1egmfjq+4ZTcGCbw0h1JqJJWJP39xwFWwRPbOujKCvKDsi61reeqVnhxGkJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6931

T24gMTgvMTIvMjAyNSAwNzozMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBhIGhl
bHBlciB0byBhbGxvdyBhbiBleGlzdGluZyBiaW8gdG8gYmUgcmVzdWJtaXR0ZWQgd2l0aHRvdXQN
Cj4gaGF2aW5nIHRvIHJlLWFkZCB0aGUgcGF5bG9hZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGJsb2NrL2Jpby5jICAgICAg
ICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L2Jpby5o
IHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvYmxvY2svYmlvLmMgYi9ibG9jay9iaW8uYw0KPiBpbmRleCBlNzI2YzBlMjgwYTgu
LjFiNjhhZTg3NzQ2OCAxMDA2NDQNCj4gLS0tIGEvYmxvY2svYmlvLmMNCj4gKysrIGIvYmxvY2sv
YmlvLmMNCj4gQEAgLTMxMSw2ICszMTEsMzEgQEAgdm9pZCBiaW9fcmVzZXQoc3RydWN0IGJpbyAq
YmlvLCBzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBibGtfb3BmX3Qgb3BmKQ0KPiAgfQ0KPiAg
RVhQT1JUX1NZTUJPTChiaW9fcmVzZXQpOw0KPiAgDQo+ICsvKioNCj4gKyAqIGJpb19yZXVzZSAt
IHJldXNlIGEgYmlvIHdpdGggdGhlIHBheWxvYWQgbGVmdCBpbnRhY3QNCj4gKyAqIEBiaW8gYmlv
IHRvIHJldXNlDQo+ICsgKg0KPiArICogQWxsb3cgcmV1c2luZyBhbiBleGlzdGluZyBiaW8gZm9y
IGFub3RoZXIgb3BlcmF0aW9uIHdpdGggYWxsIHNldCB1cA0KPiArICogZmllbGRzIGluY2x1ZGlu
ZyB0aGUgcGF5bG9hZCwgZGV2aWNlIGFuZCBlbmRfaW8gaGFuZGxlciBsZWZ0IGludGFjdC4NCj4g
KyAqDQo+ICsgKiBUeXBpY2FsbHkgdXNlZCBmb3IgYmlvcyBmaXJzdCB1c2VkIHRvIHJlYWQgZGF0
YSB3aGljaCBpcyB0aGVuIHdyaXR0ZW4NCj4gKyAqIHRvIGFub3RoZXIgbG9jYXRpb24gd2l0aG91
dCBtb2RpZmljYXRpb24uDQo+ICsgKi8NCj4gK3ZvaWQgYmlvX3JldXNlKHN0cnVjdCBiaW8gKmJp
bykNCj4gK3sNCj4gKwl1bnNpZ25lZCBzaG9ydCB2Y250ID0gYmlvLT5iaV92Y250LCBpOw0KPiAr
CWJpb19lbmRfaW9fdCAqZW5kX2lvID0gYmlvLT5iaV9lbmRfaW87DQo+ICsJdm9pZCAqcHJpdmF0
ZSA9IGJpby0+YmlfcHJpdmF0ZTsNCj4gKw0KPiArCWJpb19yZXNldChiaW8sIGJpby0+YmlfYmRl
diwgYmlvLT5iaV9vcGYpOw0KPiArCWZvciAoaSA9IDA7IGkgPCB2Y250OyBpKyspDQo+ICsJCWJp
by0+YmlfaXRlci5iaV9zaXplICs9IGJpby0+YmlfaW9fdmVjW2ldLmJ2X2xlbjsNCj4gKwliaW8t
PmJpX3ZjbnQgPSB2Y250Ow0KPiArCWJpby0+YmlfcHJpdmF0ZSA9IHByaXZhdGU7DQo+ICsJYmlv
LT5iaV9lbmRfaW8gPSBlbmRfaW87DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTChiaW9fcmV1
c2UpOw0KPiArDQo+ICBzdGF0aWMgc3RydWN0IGJpbyAqX19iaW9fY2hhaW5fZW5kaW8oc3RydWN0
IGJpbyAqYmlvKQ0KPiAgew0KPiAgCXN0cnVjdCBiaW8gKnBhcmVudCA9IGJpby0+YmlfcHJpdmF0
ZTsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvYmlvLmggYi9pbmNsdWRlL2xpbnV4L2Jp
by5oDQo+IGluZGV4IGFkMmQ1NzkwOGMxYy4uYzAxOTBmOGJhZGRlIDEwMDY0NA0KPiAtLS0gYS9p
bmNsdWRlL2xpbnV4L2Jpby5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvYmlvLmgNCj4gQEAgLTQx
NCw2ICs0MTQsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYmlvX2luaXRfaW5saW5lKHN0cnVjdCBi
aW8gKmJpbywgc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwNCj4gIH0NCj4gIGV4dGVybiB2b2lk
IGJpb191bmluaXQoc3RydWN0IGJpbyAqKTsNCj4gIHZvaWQgYmlvX3Jlc2V0KHN0cnVjdCBiaW8g
KmJpbywgc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgYmxrX29wZl90IG9wZik7DQo+ICt2b2lk
IGJpb19yZXVzZShzdHJ1Y3QgYmlvICpiaW8pOw0KPiAgdm9pZCBiaW9fY2hhaW4oc3RydWN0IGJp
byAqLCBzdHJ1Y3QgYmlvICopOw0KPiAgDQo+ICBpbnQgX19tdXN0X2NoZWNrIGJpb19hZGRfcGFn
ZShzdHJ1Y3QgYmlvICpiaW8sIHN0cnVjdCBwYWdlICpwYWdlLCB1bnNpZ25lZCBsZW4sDQoNCkxv
b2tzIGdvb2QgdG8gbWUsDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1i
ZXJnQHdkYy5jb20+DQoNCg==
