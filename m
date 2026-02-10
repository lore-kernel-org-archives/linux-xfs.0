Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A428F2D193F;
	Tue, 10 Feb 2026 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770703181; cv=fail; b=O6wrLK79K3kaPrZW6h/y6KO4qmy3oOWrHDEKxWfVlw/E4d+fNoZ9D+4uwwmklQpaKS9WBlgIpubRm4JbsXIGOnvq/kOHkcWXwf+eTZb+65eE5Pdy9cLyeOsXuplhTQ7ubFfCFDk9WwoBaIHfa76rdoYm9a0l+IJeg/93Aw1U5PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770703181; c=relaxed/simple;
	bh=DaG3rm2eL33VT8AwfVnVJUmLJO3I35xMhBmLJX+IZAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T7PXwZfl1oNyzRJ5mi45lS8+mZR7cMR9YN4JQeK6QwbRCZGutRK0SdZZ6fuu4LqmN0skZqCazOcLavkko0HInBUO+t2CQLvvK5YyUm6KtLM372//a2BIHjZZxWrRq9B7ssQfPrL1L6R6N/FB8B7eQgv8iKoCpRXE3YZ/A6oE2ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F/mbS6Sc; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=znaXIG/1; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F/mbS6Sc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="znaXIG/1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770703177; x=1802239177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DaG3rm2eL33VT8AwfVnVJUmLJO3I35xMhBmLJX+IZAA=;
  b=F/mbS6ScQAyJSGMCFrQ0y9sNOagheLGH/H5Gfl2Ym8a+zV1BojwhF8fI
   yMyRZ4cQPnpLB6sKXZDTGYqmWNcvwb958//zSs3gfxNfr+3Dgy86UTFpr
   piLe6/sDaPe8SIGNVT0cOB8a/rokVp7L8zkqAJjWSwzCyBgLZMMBYm7dq
   1zj9ntenj6ku0iPKRqdjmH+hUlLlnLaCOvCZNfbnLPyPvPlCmPsFC+Uvx
   eVnq9grXMGvk8mQcca+LxoBqfcfy/ORjk4wMkmwhRb3Tq1+ou33/mkbNP
   pUDUHWvLBLb3lZV9wZMoZBIYQmEmE0oCoHe59z+IxPiz1SjgYVV0+vOvv
   g==;
X-CSE-ConnectionGUID: LH1K8h5fSBC6acL5bg4UfQ==
X-CSE-MsgGUID: 3OGy/RITTsiyFIai6LwAYA==
X-IronPort-AV: E=Sophos;i="6.21,283,1763395200"; 
   d="scan'208";a="140435437"
Received: from mail-westus3azon11012041.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.41])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2026 13:59:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwe3y8kAPAnM9DiOB5yqNiTxSbSxHBT1gVB2WNU31ogt7VetMB+mNR2SsXKVUQZRfUNWhdMUEojcewWt7Smeec0GUQyHtV9XLtcx1q1U5tqGUKqElX3E5WqiA6rucOau9yyABVhUAXUfT5TxpuKD8HXEFBVah04TMkhvvFpXHWphonE6dVEbKBth4Od3zpgyUibtARf3sCZPvCdzwtO1X9FxDpA/NKeFvhlspngfMOvdYy2nV9/jfS/+8zJEArgJrk69jc9V9agHjiJcFovh1/RmWMD41doj5B3l8XL67vUa2mbXkQWwhrnFZ9wluEQxQiEb3BB26RlUI4KZkAqv+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaG3rm2eL33VT8AwfVnVJUmLJO3I35xMhBmLJX+IZAA=;
 b=rOtpdxliS6Z3Q6YrLET7u2qAZXHBh8VxWbN7kpsI0QAp5VfikABHqRkNXgSl4EggTW+KaD6RiNSeQyijm/sarptdf9HJ9NYP5b+SfP+9iRU6gY382uQv+hHt55Rn16OBGL1ZcgzYEflU7B+g1RCk7df4xf1WpiTXLXUWn095TNJBVebtt7p1Ia5UpyAozNMXT0jdShikowefj7lMzNjQU4Wyha8WzJX8ELHwaQuR2eCzSHgcM9LbJVlAR67ExDrjOJIMdC32/K2m1iuA/ZjHb6jp7X4ALiAfHnM3YhZIJs19w6bWbygZmCEPQeJt/bOjOWmtUUKVY29mPyGCK3CUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaG3rm2eL33VT8AwfVnVJUmLJO3I35xMhBmLJX+IZAA=;
 b=znaXIG/1g8AzWzjuHhBreQuS7k/gjR0TbcV1/2A4BmDL4jwa7zN6lEGoi1x+YPHT8dJxcT1w9ANDkhM5H+vSUg1buSOJgL6c4mfOnGT7w6i5ZGYcY49guEWcPGYYvuPemqSX5wUZI9+pg/uch7OlQvCZfDe8le4nI/JK7sZof1o=
Received: from SA1PR04MB8303.namprd04.prod.outlook.com (2603:10b6:806:1e4::17)
 by PH7PR04MB8974.namprd04.prod.outlook.com (2603:10b6:510:2f7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 05:59:36 +0000
Received: from SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1]) by SA1PR04MB8303.namprd04.prod.outlook.com
 ([fe80::8719:e407:70e:f9e1%5]) with mapi id 15.20.9611.006; Tue, 10 Feb 2026
 05:59:36 +0000
From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
To: hch <hch@lst.de>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Topic: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Thread-Index: AQHclxW65B7KzMvbt0CIJI16Abrfu7V1L7yAgATGuYCAAIF+gIAA/r+A
Date: Tue, 10 Feb 2026 05:59:36 +0000
Message-ID: <ab478aaa3504c366f6a36cb06293fb1a2f1320bc.camel@wdc.com>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
		 <20260206060803.GA25214@lst.de>
		 <41ea75676ea983281368c449647599aad9551d1b.camel@wdc.com>
	 <20260209144749.GB16995@lst.de>
In-Reply-To: <20260209144749.GB16995@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR04MB8303:EE_|PH7PR04MB8974:EE_
x-ms-office365-filtering-correlation-id: 915a0c2a-aa89-4fc7-009e-08de68699257
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bkJQcDFuZzlFcnFhdUZ6VjRlQklKcWk3bit1R245MU9ESDVaaC94UExBd2RH?=
 =?utf-8?B?dGQ5UWQ2S2phNmp6U1QwMVAzRWFLYW1yOU9SN243SE9vUjRQNVljZ2dON3U2?=
 =?utf-8?B?aFRNMkRlL3V0RC93T1ZWTDRlc1ArRlFsNVVhZlNjWEtBMitRMExkbjEzSm92?=
 =?utf-8?B?cXNIUzFhZWwrMkI4S0F3MUJ3dXVTTFVTS0VxeFNSYW9BMlVvZnhLRkZHdmFs?=
 =?utf-8?B?NzUwZkZnUWNEeHk3TzVJMVBic0FHVXhiK1JYOVJrZ0lkWHVkQlZnTWtLK3B4?=
 =?utf-8?B?THg1WkM3Vk1IRk5ZelQ5aDNYdjlrRUMrbkJwNTVYdTdEMk02VHAyMVQvcDQx?=
 =?utf-8?B?R1pmNndyZkl4aTdmZ29xak9yVi84L2VwWndWV3ptQ2lIeVJiS1RWUng3NVVE?=
 =?utf-8?B?Vmc5OUJBRUVPSGNINUhvbklFQ0J6ajFrTXZXSk1rcjZnM0ttOEN6WTlPVG9C?=
 =?utf-8?B?WGVRQkIzaVBTRDJmLzJpNnZQN29uSzdEQm5tYVloRFFGREU1eEppNnROdTlR?=
 =?utf-8?B?YXdXQUE1Y3NSWkQyY3hlK0l2TForRFZRbFlCMUhFZGZURUhsRko1REh1Vjk2?=
 =?utf-8?B?TCtLY1kvZndNOS8yRlVEWjFSRnU4TkZHS3lTaVYvVkFIeUlDa3lZN24rQXMv?=
 =?utf-8?B?NEhqWjBOQU9nSzlGY0ZCZTBNbDB1Mld4dXBKcWhCaUZPeFh5VnpMRlN6VlJZ?=
 =?utf-8?B?M3ZJZ3ZnUUhNMStybkV5ZnFuM1ErYlV2ZGd3bEhYUHpPb1V6QmdlN09LUE9w?=
 =?utf-8?B?STlGanFTU2EvdHBaWHMxSGQyZHk4QTFvaEVpY1lOWDlYMmxJZlNPaDJuS0do?=
 =?utf-8?B?ZTIzc2xiN2xHdTdvS1VFMVVTeE92WjYyV3h3V0F4OWgxaWtvT0hrWFZmQ2Z0?=
 =?utf-8?B?eTQ0VlFaNGF2S21rOGdRcEdad3ZxeERISGlZUVlTYTNKK1J0SFVBQ2toTTZS?=
 =?utf-8?B?TVYzaWtzeEVaeXlKdUtEOVQ2amNqQytWeFl4bGFlaFZIOXlRSlcwTVBqYm5X?=
 =?utf-8?B?OE5Fa3diOGROVjU2bXNtV3ZiZDhLMVlXbEpFYkY1R2RyTTZtMTNRVVJEaXRV?=
 =?utf-8?B?ekdhWWVMc1BoSWV1Y3VuMXl0d0kyTWNmVWVjWVhNMi9sREUwOHNkY1liUkhn?=
 =?utf-8?B?UUdnZTVRMEUrZkswVzBlc05DdDFYTlpLRnMxUEc3UWRxKzRCcnBGYzF3R0tQ?=
 =?utf-8?B?Y2VHcWFjRXA5TDZJdktZMzhCYndIeWZWcFR6QkZOOU1nRFo0bHJUWTV4U0I0?=
 =?utf-8?B?QjN5bloxVXBsSWQrRkZEMkNqdEFVU1pMYnFvM1BCa1hWTzNyOU1lVzBxWTE4?=
 =?utf-8?B?YnNJL3JpRURzbldpd2FBZVBXWFd4ZGM2ajROclFkYllDMDlMcWN5b0w2a2NJ?=
 =?utf-8?B?Rk5RRjZQRnNJdXVzSXJRMmdObEc2a0hDQnBKdEVBWVpnSUpZNm5hazJjSUhS?=
 =?utf-8?B?ZU1qbGxRa0l5R0Q2T1pDeDRJWlFMQjVDMnlza0pnbTNaMjFCd3g0WWdURElO?=
 =?utf-8?B?bjJnc0F6b0JJeWg0NmRaRDBsdHEzUjJrci9UVWJ3dERrcTN6aHhwajhPVGtQ?=
 =?utf-8?B?dlRyTkN0TGlKQVBTQ3RDR3pjTGFBa0ZQUXczdVEvS1Fad0s0bTNxUmNNMVM0?=
 =?utf-8?B?ZDhucmh0NUtBSngyWEcyaWlBcExJSmtybVErL0J4QzRNWFU5M0wwZWZoSGlj?=
 =?utf-8?B?RC9CMjhsTjhWWG0xMkxIME9FWmRTRk1jTWJ0QkxTRWEvMjJrb3JXeEpMV1NM?=
 =?utf-8?B?Q3QrTHpNQUdYcTg5NGZQaHdrZndkNnRtRW1qOVRnWWhpWGlLeGZCVTZ3NUho?=
 =?utf-8?B?SFpoQktsVWd6V1FWVEtNTk95UlNUa1pEblRGMlRtbTdsbGxzSTFFUEpLWHp2?=
 =?utf-8?B?MGpzNzhDZnV0V0ZCRFFjVE5GTTF2VVRYbDRFYmN4WC9PZDhGejJMQjFVdFJ1?=
 =?utf-8?B?RURYTm9xZ3dWdGFSRjI1OXFNZVdtOFJxakZHVlBrUGlheUxPMkIvbUN6MHhU?=
 =?utf-8?B?Vk1VYk9oY0M1WWZGQmYzcTRpcmtFVDhnMnZMcHFSVnhJa0U2SjAvbFBDLzNK?=
 =?utf-8?B?ZnF5bU1WOHBKSFpaRHlJeldDSGlGTG83ZjhkSzV1ODRWQ2g0bzFleGM1MmlL?=
 =?utf-8?B?TURORERaM0JIUm5OL3hqdmxLazhYZWpKRjE3bkRneXdyTURTRC9iRUdvZEJp?=
 =?utf-8?Q?LTul9SuCg9+4IZJuJSbrpac=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB8303.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bzRjckcrdndVdHNZd1VCT0ZhWU5kNldYdkxGU1BoWWRiK3hTaGRLc0x1QW1U?=
 =?utf-8?B?d1BOc013R1hMc1dhTkpPT0JUTmZTS21sNzdjc3NtREpuMHgvbW9rSTB6MXM1?=
 =?utf-8?B?c0ZycTl2NGJOYnRKT1orVEE0dm0xbENwbXJuam5UV01LdmxsanlFZFJBU1Bu?=
 =?utf-8?B?VmVORnZ3ZGVYYWc2Q3pKMlpkcnp1OXVmVDlCWUNsaXVQVmhzMzhLcFhVQkxa?=
 =?utf-8?B?KzE0eHN4UmtULzJ6dWxDQ1R3ekFxa21IWEdWNnBzbVRldjdiU2pxVWhSNVk5?=
 =?utf-8?B?YmhYeEhKNmIzY25sMDFQM05BUktXeDVGeW1pRWlkbjFXNnBoVXNiMjRscXZa?=
 =?utf-8?B?WDFSQ3gyNFlFUWw5VmpUbk9SME5VKzFSb01nOUpMK1F1RThOVnV3TEEvZi85?=
 =?utf-8?B?cElRK1FHMVRoamgvMENhY2pQbURXQUoweUh2TUovVWhOUkliL0w4Y0pzSGdT?=
 =?utf-8?B?eDZZdGRTZWRsTldYWDZ6UUZjM09qNjlYanhLdDVHTHROYUo3ekJIMHlacnY0?=
 =?utf-8?B?Tk5MdE9XclpTK3JYblRLNldCWnUwOSszRGt3S2tNcDRiL2FGV1JVeHhOTmh4?=
 =?utf-8?B?TCtBZENBelR1ZWhzWE1rV0JINDdZRHlkTjFrWlI0NWpNLzJzNUlxNG1Ha21k?=
 =?utf-8?B?MFlYa00wb0FaeUFEVzloM3QzcmxQMGxEZE1CRnA3R1hiYkZCWVRBTit6WDJJ?=
 =?utf-8?B?d1k5b0VGN3NiYTRETlZ2MjBRS0pVMWxNRlptVGs2Q09rRWIxTlJra3hSYkNS?=
 =?utf-8?B?Y2JSZXFvSXQ2bTlkNUk2YkV4bDNYTlFnVjhkOEJlK3pIRUFLMlNudXFnTUJM?=
 =?utf-8?B?MytsMUltcDZVTGlRT0tnS0NmVit0TU80dnZ6UzFIUEQ1MzlHU3ZEbFRxZUNn?=
 =?utf-8?B?cFBxNFZNWmlzaUZYYzdhV0ZZbEdLd0U5a0dHQnlyUnhYdk1DV1RERWJqSE04?=
 =?utf-8?B?eFAyTmRFUk5IQVp6WHVvV3JvN0ZPM1ZzWGwrWjZvSmZoYzBpZ2hkcGl0ekRu?=
 =?utf-8?B?L0phUG9hSW5WdW9jVForNDFTcDByckZlaGdUSXY2aEdNbDNhNXFwVk8xWXp2?=
 =?utf-8?B?N3lvQlVJOGxYZjNYSUJxR0RkMEVzc2JSeFo4VDlnRG1hSnhvQUtxb05hMm1M?=
 =?utf-8?B?UzVhME5VdXBYSkZMc3RjOHczTEFKbU82aDI0cXNmeWlqVktrdXMwVEJhandI?=
 =?utf-8?B?WXRqSzZaQzJXSldvVE04OGxweVBEUzFvMThITDBaKzRGeXd5cm1tWlRVblcz?=
 =?utf-8?B?L0E2NkhSeHhLcVpHTTNBUno2djFmT0xKQUlKVzVKQk1GUEhqUjFXUnYzcmx2?=
 =?utf-8?B?YjJhK0xHbkJCRHFyTEU2ZDhQcTVvZGdKUVoxU2d1bXFuOW1XR3RLcXlYUGJn?=
 =?utf-8?B?VnpXbzVhdm9iNzNnQURvbjJCT3RyNjZxbHBVMGdnTklES3ZDWFp3aGx0SXZu?=
 =?utf-8?B?K0JwMU5rUDQ3ZUE2ZGJ6cll6ajlEb0ZxZnBMMERxbEczR3BTYmtKZEM5TmU1?=
 =?utf-8?B?TVdXZG9NVkZBam1JeHNxVkM5S0JQSGFkSjFac2J1WDZ2LzZ3clIrKzZMWGlq?=
 =?utf-8?B?OUpIRnE4K21LZ3NoS2FVNWtFaC9oeGJjUXRZbGVWWlJBbzhYazFEUW5CU0x2?=
 =?utf-8?B?ZkY1THgvamtuTDdIR2p4VlhsMHNTMmd1MUY0TWF5NDg5eE1Vb2E1WVNKc1p0?=
 =?utf-8?B?d3pycStDYXEyL2JVaUVuRE5vL1E1eTVxTHBBa2g5eFlDUDg2K3h2OFd2NDVH?=
 =?utf-8?B?VHRoZ0ZhSGVqTUhYelNFM2lmK1hCNVgrckJYZE5iWThlYUFiMEh0T1B5aDdZ?=
 =?utf-8?B?SEN4M01BTG53R3RET1N6QnNTUnRhM1dJQy9EOTU2YzVkZEY5WFpWSVhSb3F5?=
 =?utf-8?B?b042eVFZVTBNMTl0NCszb2kvVmNTMDVwUTVyRUlJMlBlOXBRZHVLVnR3dHla?=
 =?utf-8?B?TVJucUNZeks4d3dCN1ZleWVmREMxbTFWOGw1YkRjY1lkVG53N2k5by94MUUz?=
 =?utf-8?B?OVZkdlcvRnlsVHZBd2Z5bHdNd3R6QVdlKzJjeENzM2VueTgyODY5WEZscHJr?=
 =?utf-8?B?OFFOdHU0RFhmbWQ4K09ZWmRHampiU1pWQzlNQmx3c21rbTRIVk9QOUpEY1dE?=
 =?utf-8?B?dUJpMEoyRXdCdDM5RzhzYUkzdmNsVHlkVXlVOWlGVStreGw5d3NBODlMSG4x?=
 =?utf-8?B?L2xmOHBEbVY3dSsvTWF5TDZOL1hwdFV5Q1g0SFpkaWxGRGtCUjFRcW1oWmE1?=
 =?utf-8?B?bHpucXdzQ250ZkUyMmdiTGZOZzArUXl6d2ZLdFRLYlpSMWd0OGhPNVF4MGs1?=
 =?utf-8?B?alA4VEhhSDdaRGZQbW1kOHJPVG5hQjExcDFHZVFwZ0lDVlBleExyWlo3alNq?=
 =?utf-8?Q?6o0OShpaVDMtKphQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6290CCF49D221E43805798111E9F870C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rTcmq2oM7oW1HYOHGXn3F1arTYj1MtxDsmVUy1CU9vdScRy7gtgc3Kr3tRqWajk3/I1GdDm2zDh3+90sdkJArFEubx6FHrfnxs4Or8t2SJxi5W/7CUVcxfeo9MP9NcmayfeS7358SOgui8evkWukn0Kkavj6MBGt7Bl8b8FsSOfMwpkT9Y+qKWn3IMhQ6fdNJ+TrR9LwjRNnnhRogpHKpjYFOYDCfZ2YYdzF16QWzjIknrqdiwLkqvg4cUn68UqPeavlCSweUkSPcLISqxwnpPko7nCCzUnJjjm2xg+52gCadJSOSH1qq2ImCJl3shCrMfXA74HrNZLEioLY4sO+tX4IvOT3N+n2ZyAAXIKJv380yHJEw/O89Cy5dqKp2vbodtIM1f0pJylK9yRHWMK1B8Uy46PgEJNlvgZdi6sjt2siHIOIbh68b34jeFsbE3iynVVElMsNhbdL7GRtWfyOpygc8q67HwiAeJbsxmiNaAzyWVleYU6Xw+QXcp3xr23TOGbMtFRHPAR8JwzEvdARuxCK/RWrhK76gR+2+WmnEcCPC1cDe/xPJWnEV6iRJ+8xyroquJpDsWeOyimPKz5IU8d6NucRcWA2KAoCf9l9D9sLvh47Y3t50geWwK9MB53J
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB8303.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915a0c2a-aa89-4fc7-009e-08de68699257
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 05:59:36.9071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I6VUikPgLkeNUmb/AvFszNQNHtSLKL50HOZPxCUVBvszmUxRwhEx7AN2OZETVIbplObB2Mj3nE20BwYrAXx1Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8974

W3NuaXBdLi4uDQo+IA0KPiBPdXQgb2YgdGhlIExpbnV4IHN1cHBvcnRlZCBhcmNoaXRlY3R1cmVz
IHRoZXJlIGFyZSBiYXNpY2FsbHkgZml2ZQ0KPiBraW5kcyBvZiBkaWZmZXJlbmNlcyBhIHN0cnVj
dCBBQkkgY2FuIGhhdmU6DQo+IA0KPiDCoDEpIGRpZmZlcmVudCBwb2ludGVyIHNpemVzDQo+IMKg
MikgZGlmZmVyZW50IHNpemUgb2YgbG9uZyBmb3IgbG9uZyBkZXJpdmVkIHR5cGVzDQo+IMKgMykg
ZGlmZmVyZW50IGFsaWdubWVudCBvZiB1NjQgb24gaTM4NiB2cyBldmVyeW9uZSBlbHNlDQo+IMKg
NCkgZGlmZmVyZW50IGFsaWdubWVudCBvZiB1MTYgb24gYXJtMzItb2xkYWJpIHZzIGV2ZXJ5b25l
IGVsc2UNCj4gwqA1KSBjb25maWd1cmF0aW9uIGRlcGVuZGVuY2llcw0KPiANCj4gNSkgaXMgYSBu
by1nbyBmb3IgZXhwb3J0ZWQgdHlwZXMNCj4gDQo+IDQpIGRvZXNuJ3QgaGFwcGVuIGluIHRoZSBj
dXJyZW50IHhmcyB1YXBpIGhlYWRlcnMgKGl0IGhhcHBlbnMgaW4gb24tDQo+IGRpc2sNCj4gZm9y
bWF0cyBzdHJ1Y3RzIHRob3VnaC4uKS4NCj4gDQo+IDMpIGlzIGNsZWFybHkgaW5kaWNhdGVkIGJ5
IHRoZSB4ODYtc3BlY2lmaWMgaGFuZGxlcnMgaW4geGZzX2lvY3RsMzIuYw0KPiANCj4gMikgYW5k
IDEpIGFyZSBpbmRpY2F0ZWQgYnkgdGhlIG90aGVyIGhhbmRsZXJzIGluIHhmc19pb2N0bDMyLmMu
DQo+IA0KPiBCYXNlZCBvbiB0aGF0IHlvdXIgYWJvdmUgbGlzdCBpcyBhIGdvb2Qgc3RhcnQsIGJ1
dCBpbmNvbXBsZXRlLg0KPiBUaGUgbGlzdCBvZiBjb21wYXRfIHN0cnVjdHVyZXMgaW4gZnMveGZz
L3hmc19pb2N0bDMyLmggc2hvdWxkIGhhdmUNCj4gYSBjb21wbGV0ZSBsaXN0LCBhbmQgaWYgZG9l
c24ndCB0aGF0IGlzIGEgYnVnIGFzIHdlJ3JlIG1pc3NpbmcNCj4gY29tcGF0IGhhbmRsZXJzLg0K
DQpUaGFua3MhIEkndmUgcmVtb3ZlZCBhbGwgb2YgdGhlIGNvbXBhdF9fIHN0cnVjdHMgbGlzdGVk
IGluDQp4ZnNfaW9jdGwzMi5oIGZvciBWMiB0aGF0IHdhcyBpbiBWMS4gQ29tcGlsaW5nIGZvciBp
Mzg2IHRlc3RlZCBva2F5Lg0KDQpXaWxmcmVkDQo=
