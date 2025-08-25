Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6FF2F068E
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756123784; cv=fail; b=D03jIo6jjd9XJXDBYOwiPZBl2oH1IftCxDGhSEnHk+vnzZWUBFPYC5ozI45OjNlc2Yz8E4z5r405svf/CVzBoGRoG3GtPeVloDdClP2TYKjlwqIwTwDRIoW2QhxxW2SFmvMgZBJf50eCe2OtauKJeHaLS0lbD7Zv2AytyDHLVc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756123784; c=relaxed/simple;
	bh=YXDmLudWKHP9JFXrGJaCE4uiKzNez74/5WOI1W+sEvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZKqNWaYj+NieeQ+YqiO3BvX/JuzRacK3SFfYUu3RcThYx++ca5ouS7W6BmWvMZLw/nbvnOeQ1LOnfmsPFYkPpxYtu9x1aui3ioB7Q/mOobTCEAxpXwI6nucmcVI+KJ3/GLV2H1bdgt1aHFv8yAPHWWZz1wGfkhz3K/nLBTsQnvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CNoBY0Y+; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U1NHpFdg; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CNoBY0Y+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U1NHpFdg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1756123782; x=1787659782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YXDmLudWKHP9JFXrGJaCE4uiKzNez74/5WOI1W+sEvQ=;
  b=CNoBY0Y+4de7eMNpY/ITjCPSf/fK2+p7YaGdt4TjXrPpzRms0P+tj/0/
   R5EqPrhp5F3k6a/gIt7nF6w8mdGavH5K6KhhLFcg1QbzutLhKn10likxq
   Fx15ns5lRQM7utmY+uWP3QSPGmssk9Of58gwqRTodqdq5DKZ3oV9mesht
   v7J69bGCrMHixGDEfegtEpuk3G+k06vGldIggWUl9JMtwxnREOCHprRzT
   yYftnPEB20o9i3Qd22CR6KyBmuWxegELscfA/Q8DuL/apTFEgQRvuNlHF
   R2s09/l6MhhneHUvuj/mouwl2/Q/cra88nJvm4A6MA6T1biiV0WW39Iqq
   g==;
X-CSE-ConnectionGUID: L9wAgaDWS3CogEJSWP2qSA==
X-CSE-MsgGUID: EBKaCWWVQt61K0obVxRmJA==
X-IronPort-AV: E=Sophos;i="6.17,312,1747670400"; 
   d="scan'208";a="105292639"
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([40.107.223.74])
  by ob1.hgst.iphmx.com with ESMTP; 25 Aug 2025 20:08:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/XDc6BX6rWNGjKkyNetgtUulAkw4PKu2H9TF8YfqmRtAK0DQUddXDNE3JN+ZYxtdQEoXsn0UL5dpQR+ZHNN4t+xTPrz2CQFnRGPT69uqD5dLDCKFzaOYkLwUepRxU5el6uj04XDyOj0kN5jV06zaO+LJdFVEpDs2NfWebFb6sjWZjT4AhKQhSiYMnJlBUGeJq//3TDJZmBVR3d3fVhA0WPuHRdigH9hDrvVzHV5sOf4Mr936TJXncdJDds/voPQ1am5i7ksxNcTi7L7InFk7BnmUCswWHBudOBAhScpasvMP1HUKQO/syI+KCWlKNs/+YaXku0uqtSVLibL1gYxbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXDmLudWKHP9JFXrGJaCE4uiKzNez74/5WOI1W+sEvQ=;
 b=qfJxYu7szRVrfjIEGlytdOtsJKOLctPztwFHKNEVZ4m+pPZZ8Jg94pIFxcEszz6a0Son83RxxS+TLDEiZp3nFiSFbMtlN3GlrGMiAU4pcCvYqufZ0fvNPrDoiZL4nAToWeoSxfRnTUu41yjqxXSMs2L9/psvB+KPnZUKpWT9pO2luKlkAoeFB4gD0iMQh37Aw+hUWagCrdUDpvisHhHZvtojN+CbYJfXrevC38OTauT6xa8odFJeUZyH4Uck8tmUKRPDCerMcJpXtp/TZvuUzesg1NjEcKsySrbGdpEp/QHbe1E/UhGmQyJ4u+1TE3oycvX/sTt2RLmJTrPDOv0myA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXDmLudWKHP9JFXrGJaCE4uiKzNez74/5WOI1W+sEvQ=;
 b=U1NHpFdgVq+5NoTPLPbKWf0px4XB03gEd+XEPOkE5XPmlkoFvjXQG5SUovf+lWWmKyLbolFrz/xsbI4wgGIBFJgj7eQ84JzlkL28KYXx0eT6i9ajFrbTWFL8RX62BXVEu9byt8ozlmIGrCr12WKC43dFCuXvUGzxPw/4ypNTnww=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by PH7PR04MB8731.namprd04.prod.outlook.com (2603:10b6:510:236::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Mon, 25 Aug
 2025 12:08:31 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 12:08:31 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove the unused bv field in struct xfs_gc_bio
Thread-Topic: [PATCH] xfs: remove the unused bv field in struct xfs_gc_bio
Thread-Index: AQHcFbRWObe9e2SEcUm677WaBKa+FrRzRomA
Date: Mon, 25 Aug 2025 12:08:31 +0000
Message-ID: <ae862e2b-8a96-4f44-848a-05b8aa8532bb@wdc.com>
References: <20250825113511.474923-1-hch@lst.de>
In-Reply-To: <20250825113511.474923-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|PH7PR04MB8731:EE_
x-ms-office365-filtering-correlation-id: 3e766227-44ce-4792-b102-08dde3d01bd7
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eEJVVktlT1V2ME9UZHpwQXF1S0hIN3E5aUhCME90TSt1R0FTaVIwUVAyS2dN?=
 =?utf-8?B?ZVUwenVRZzJlWW9odnJyeDBQM0hxUEJjRVdSeEFWNEhhNE9aS3Q5WGlWdFQy?=
 =?utf-8?B?RmxqYlFyMXRJUFQyZ2VQcHNzaExxejZ4SFJYVm1MYnlCeEZoa2dSdkhRSm9B?=
 =?utf-8?B?eEFOK2tDV2tFSC9TQTNuZml0RzN0S0VDSjV0SlJNUkN6bXlNMVdwUG11aS9H?=
 =?utf-8?B?bmVvQUo5ZFJOV3JUU01KM1J5R25PZ3ZCZEhBVXdhbmV5alkxZWpieWdHNUZm?=
 =?utf-8?B?VFJVa0h2RFYwTkN2Q2lqMTJrb09PVU44V21UN3BNOVpwOHRxL1V1RmhSWjhY?=
 =?utf-8?B?Yzg3Qzl1NDBkN2VJWVpIM1g3SzVBcURZWXhRUzFrNzhHTmFlQUlIblFFZXlS?=
 =?utf-8?B?LzhCdE9BZi9jRC9kUHp3bUxaMDMwbFZNL0JGNExBS1oyUkNScGROWm1sc1o0?=
 =?utf-8?B?NzZYdThpS1BONjNhN1dvd1ZKMzdMeXZpblJtZDNDbVFOLzJzSisyL0V4M014?=
 =?utf-8?B?TFlCL0tKU2NDc1dwWStrSGcwK0p3MXUzbnU2TjJ4Z1JaN0RETzFudmlzQlBk?=
 =?utf-8?B?VEl1b2Y1U0ZoeFJYdFBycU8yTEFEdWdQM1I4cmNuMEtYT1d0U3hBTHJUbERz?=
 =?utf-8?B?S09vOFVBRndJSzJKdk0vN1plaG1UM1EwVXZqcXpOT1JvSG01b2dUeWQ1VklX?=
 =?utf-8?B?cUYyZEJxdmxKZHZTb1h2c3I1TXdOV2NIaVcyS09hOSt3aGpROXdTWDJYQTVu?=
 =?utf-8?B?d0pLWEx5YnBMQzJzdjBBeU9hcWR2R0s2cmZ3RGRwWHZZYm94NVRZaFFFMERr?=
 =?utf-8?B?eW4wSm1ZaG5QbXQ4OWZld0l0NU1QTFV4ODNmVDhKOTR1Z2FmYmFOTUJrSGQy?=
 =?utf-8?B?ZWZiZHdzQVhrZER2S0g5THNFdWd6K25ZeWx5SEhQOWpGTnAva003bnczS211?=
 =?utf-8?B?UmZ5YmZDUVpRQjJaSm04emNRcWRDbHU5ZzF6MDROM0dqcmRkT0xFNFFaRzhh?=
 =?utf-8?B?OXZwUnIxeEJYa05SS2dMMDY2dFc3eGhqY2Q1Skd5NTUzdDZteEpkL24rRWp2?=
 =?utf-8?B?cndvTkRuRXF5OStpN0NDNFhVMEdVN0txdWtKWk1HdXdidjJLNi8zOFJDL1VD?=
 =?utf-8?B?WTBIM21UZmIvZ0dqVlRHTFNNbUJNbG1pYnVBYk5Md3dvaHZza3B0dlI2M3Q4?=
 =?utf-8?B?YlZmRkdyM1hLWlRGSm1NakpRSEtkZFl3ZG9INUpsd2htY0dmbHR6ZjNDT0hX?=
 =?utf-8?B?QnNXdXNKUmZTY2ZPeVdQSUNJMDRDVWgzRUthQzZIa3dCWjRwNy9icUpWTlQr?=
 =?utf-8?B?OVZiRFVSMnRZRzVoOW5sbWViVWx6ek9vbXdlNGpoMis2bHBub3pNYTFJS2Va?=
 =?utf-8?B?WDFudXNkM2plRnVFbk0vbkYxUDMwSDN1am9TOG4xb2FUeERIZnBkb2x0NDMr?=
 =?utf-8?B?aDZVRDZZMXZ1dzdvM2RNZDlIV0RtSXd0MlJDelpydEpBV3FOZ0szSlFsS1d4?=
 =?utf-8?B?QmlwbzV1VmtrTjNwUlBibHlMVjIrSU0rek9sU1hBTXZRcThUL1BnRndreUpn?=
 =?utf-8?B?b3pEeXpYZmxSVXVsTlFGanNPSnJxVjNIMzc0b2x3OHNLQ0hkSlY4VTFvTnkw?=
 =?utf-8?B?RCs4Zk1Wd2R3YWtIRERpTmh0bmVaUHBBZWJBV214bDcyeDhvZC9xV1JsaHUw?=
 =?utf-8?B?MkRlNml6NDQyN2hUWTlmbTR1cHVHUTRuNmVZWUcvbHRuQzNwQXZ4T3dIUG5n?=
 =?utf-8?B?L2xudFhXKzkybkd5UjFGRm5JQm5TVk53YzNkdkFJWUlxODJISzNUNEs4RE9z?=
 =?utf-8?B?RGtlLzA5QWwxZDhqbHd1dWhCd3lOblJkSGZlUjJHa2l3d2hPdnRkMVptbFk1?=
 =?utf-8?B?Q3B1YkZKbzhtc3ozaUZwbkFFRVoxOFV1Tzd4OWFxNm1NQzVmL0dMTm9TbS83?=
 =?utf-8?B?OFN4OEtFQStxRGdWS3c2ai9pYjFUaFVUc1NnN1hrNVBZWjRIMldlY0R3TURO?=
 =?utf-8?B?dXlJMXpUNGt3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGZnSUFBTlFKSDRtZ0V3ckFnSFJIQ0VORjdPNU85RUg5cFczZ1BoZDR1SitD?=
 =?utf-8?B?bTFmOVZqRWtYdTZKaXdzejloVGhiL0RqUElaSzFyZmg0SW1zeXl3cmQvYnVU?=
 =?utf-8?B?MVkzeVdvNTJVUzNTcEp6akVuN1FxemozVGFXMm5UZnBjZlhHOUpuSloxQkts?=
 =?utf-8?B?a281eTRENXpEc01kdHJwMEV0VmFoWUhnVytQUzVHTWdrWXFpSUpLUTFSOTVG?=
 =?utf-8?B?YWtNeEd2TEdSL3lnRkdnVmZMRGVmaGJ4MmlzT21xY0xCWUhVb0JhK3l3NElj?=
 =?utf-8?B?M1o0WEJxQi9kKzdHKzRiZmlmdHd0MVhKUlhSc09jZVVtYnhiU2hKTHA3WGhp?=
 =?utf-8?B?MXFWZUtETUpNQ2FBL1M4cnk1ei84NGxzTGY0T3RGc0lEMGlUK29wTngrbmxr?=
 =?utf-8?B?S3N2cVZTTGlLQVk3a3h2OXpnYzc0WmxpaEJqeUJLK3Jxd2d1TTJQNGVDNmdH?=
 =?utf-8?B?Z2RIV0N3TDdZc2Q1Z2tjdThHU2NTbDliYzRSUjg2NWhXQjFQc2JIajliaG5B?=
 =?utf-8?B?cmxmR3NPNXpCMEFnVTVkL1NEcTBMN0NnenYyeFI4UDNVUWg1VzBxMUVqNDFY?=
 =?utf-8?B?Q1Mxbm5vSTdqdUF2M2QxazFYWTU0Vmh5SVRNV2JhRSszZjJqVHR3ZU5LWmlI?=
 =?utf-8?B?RkUxUWFObmFIZXhNZFhsNFl6elArMUtockVZUWhCbjRFUnh5SEtNMnRRTERM?=
 =?utf-8?B?YmNSYnR3aEhPdHl3R3V4OWFpbEtDc0I1YWwvUjV3M2pUdTVPMnNTOEsxVmJX?=
 =?utf-8?B?QlpqSWNrSC80RWQzaEhSVGFNdTFIQW1saWMyQzZvaUYvZTltSWEvbHFoUWpx?=
 =?utf-8?B?dUNpRzRhWGxFTER0N0oyaDZzaW1lck5jQzNkQTFJK0M3VWhPaEpVcjlNM092?=
 =?utf-8?B?VURiM2tWSlpSdk1JMkdxb3RCV0NsSG5DdWQ1aGNvMUNEQlkvRnpZWGwvOGRT?=
 =?utf-8?B?SzRMN1JNVzRUUWR4TlZTMXJMd2pWbUE3dUZRbVFBWU9VZ2VNaytzUHlocFYw?=
 =?utf-8?B?MkY3dDhhNUY3eXZaTzFPd0pwYjdvTVQ4SEM3SGttTmxPSk5UcW1hY3RleGk2?=
 =?utf-8?B?Uy9STHlpaitnZy81NzZxRVprQStxTEZVUm5xaHB0a3paZlVjUzEyaUM4ckJJ?=
 =?utf-8?B?NVpNNXgvYk9ZUmp0SmdTcjU3UVRxK21wcjREdUEzNE1xZVM2SE1RaFNpOFpp?=
 =?utf-8?B?R3B1bVAvY3lKQURkbkxib1JsVWsyL0JHYXRnVUN0Mzl0Y0duQlh0OGZxbFRM?=
 =?utf-8?B?STl3V2VibHJ4Y3Y1aHBoa0Q4Qm5Ed2pyK2VvOUlUaEY0WmI4VUpLblVRcHph?=
 =?utf-8?B?NExXVVl5d2lvLzlBL09hb0plb2JWTldlUVpXZ3ZqSTFxV0ZOWHJJeDdsdXFM?=
 =?utf-8?B?L2tkdllwTXFNdTZmdm55dnFLY3l1YnRhZVNQQitBY3JUa2dkamR5QkVYWW4y?=
 =?utf-8?B?UVI3RzhSeHErSFY2c1dURDRVamdXSzE0UDYwcUFla3cyR0Q4NlJBYnFxaU9G?=
 =?utf-8?B?ZGZGcUNmTDlLY0ljK1oxdDdxZWh3QXY2cEVvTU1tQkRiSzZlc0hYbkg3WFN4?=
 =?utf-8?B?enMrUlpnbWhpV2VCSks2NnpRYk9abFZiVUh1TzMxRzRYeXJNSXVFK3BXWUg4?=
 =?utf-8?B?S0oyRUg5QmhlYWFYOWtJd0lyNDhMdHhuNU01NXljZHlDclU4RXQ3bXhabERB?=
 =?utf-8?B?ZFlZZUxxYVVzUFUxSHkzeUYrRURiR1lEQUVNK2Rvb1NZajNkT0NTZGQwQ0Nr?=
 =?utf-8?B?VHdlRkNDV0U0ZzFDclJLbXIrek1XT1c2NUljVjRrVmxwNHZmWTRvMzFpOTIw?=
 =?utf-8?B?VzN0Y3ppRmZBK1JjZVhSb09Yc2ZoaS85SmVnUUp6LzBJeVFqOXcrUWtmdjQx?=
 =?utf-8?B?WTBqTGM5aHpYSGRTOURYd2ZNY05XNFhIS2lFNk9ycmFhLyt1L01wYzc4UVJP?=
 =?utf-8?B?Y0lyNzZlcDhzSi9nVTBmU1JnWUxCL3VZREU3azY3WmNFM3BlcXFXYlNHS2Rs?=
 =?utf-8?B?cFozZTBnZzhMOUJ2TW9jZGtSeHF1cndQUmhLT1Nvb2pZMUpCVm0zd2I4VkY0?=
 =?utf-8?B?ZWp5Nm93Wk56WXJvUDBhQndXOW9saEsyQXdCbldzVFdxTDFGRGdYRlVqby9r?=
 =?utf-8?B?MlcxLytaM2NqRnBhdEpCZU1rYnVIODVCVTUxZWErMzkxWWtESWVyWWdzbkFZ?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7857050AB99439459DDF371B7C26BAA7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KQg22+p1aUuayaKWgh/OO95TCg+G0eqwBtjJmYNdSkSz5DUtcH8sJ46gApFAT3vfRtI2Q7ppor/ROq6tw81bTrspGd3EJjI6O4iMI/XXDhgAGv2b1J5PSW2ysqFYJ0Ou3rTF9RwNQhYRD0NovoBNjK/HUGpCoYa67Q76+iDWW8iVshfuGYRQuyhkFH9RM2EZKNUpU7g3xv/zH8VFMvjovSvCDMy+92wLcx90def75sQuLDyw0kiJ2gGH9izvD7t/OmE71eL0XikbLtI23d0m/9aNdpnGxG6LhAbPtP9Y8O3Rnep0iAS5LfYohoT0B/3s6uyF2AbILRZOSOgF4ZzMsNGSfX3I6Nq9UMoXcNj4ldK3AjSAF1Y5wvN6KrIAMzZz83HwdmCvA6h9jV1E8zO9XPUPFFNjKJ3OUKKPkfyFklHZeCrBw5YdIo6ZlE6bZx3RChID4BXuoUei/QF70cVnjErd5OzCE3Twyno4CpZjnXpbXCo2+WJmIFaZuGQR2H9ELdD6wxQD5qDFgqm4cVPn8F1pimk92TYdEHSLZ2/98zrnqiSHiuPwuGe6IZLSl4F7f99p1MX1InP6zAhKfhzw/ybwjzkLFeA72GMJ7qXMBgSKJiAtrRbqrKzeVv9KW+2k
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e766227-44ce-4792-b102-08dde3d01bd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2025 12:08:31.5696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I90ZLSO83TiSj6xJ71EvWLsw+QdwDeYCTU2eZchJcYW99B3ymeOhUFuDMv+on20dYn0yiV+dVHNA7oFqAKpVeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8731

T24gMjUvMDgvMjAyNSAxMzozNSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94
ZnNfem9uZV9nYy5jIHwgMyArLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3pvbmVfZ2MuYyBi
L2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IGluZGV4IDA2NGNkMWE4NTdhMC4uZDJkOGZlNTQ3MDc0
IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiArKysgYi9mcy94ZnMveGZz
X3pvbmVfZ2MuYw0KPiBAQCAtMTE0LDggKzExNCw3IEBAIHN0cnVjdCB4ZnNfZ2NfYmlvIHsNCj4g
IAkvKiBPcGVuIFpvbmUgYmVpbmcgd3JpdHRlbiB0byAqLw0KPiAgCXN0cnVjdCB4ZnNfb3Blbl96
b25lCQkqb3o7DQo+ICANCj4gLQkvKiBCaW8gdXNlZCBmb3IgcmVhZHMgYW5kIHdyaXRlcywgaW5j
bHVkaW5nIHRoZSBidmVjIHVzZWQgYnkgaXQgKi8NCj4gLQlzdHJ1Y3QgYmlvX3ZlYwkJCWJ2Ow0K
PiArCS8qIEJpbyB1c2VkIGZvciByZWFkcyBhbmQgd3JpdGVzICovDQo+ICAJc3RydWN0IGJpbwkJ
CWJpbzsJLyogbXVzdCBiZSBsYXN0ICovDQo+ICB9Ow0KPiAgDQoNCkxvb2tzIGdvb2QsDQoNClJl
dmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoNCg==
