Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946B134F48D
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 08:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760888; cv=fail; b=MlG6VtjHKwpLZPo5xb8XDVOaTpYsMgh8dmXsFefal8F8ImG47g3XAZOIO3V5tImFrwt0SWG9gNGbU1IrcsRJ87Fhpt70cbiOc+j/8Xl2ll9tEElTX5BoUDVavOAuqHCyCFERPCJxunHZZNxIdNtLjqQ9gUIF6wWrV295jtrBAPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760888; c=relaxed/simple;
	bh=Grlyld2P9FjFA0SFz3wiRh0ZZGBna6okSy/kA/N4/uE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c6nqtsfPNKun4rPLKNOg71h7+fLvYdcpZeKgnRLHo28vRqevtxW+rd0dLA813GeCDAodUazNRCYoq0EH0qY7J5vsvZQPD9WUHeLJ/2FBRY+Oo3zDVfMqcB4Fza2k+xNFn6mRQ+zK4kNsH2cjnec3SLTpLoVMQflwSZ4WgH1zbUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NUXF2H3H; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xqGkjfi4; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NUXF2H3H";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xqGkjfi4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769760883; x=1801296883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Grlyld2P9FjFA0SFz3wiRh0ZZGBna6okSy/kA/N4/uE=;
  b=NUXF2H3HRuMlle384mMwhJlv7L3dPlNHfScK6x3iJXXFFQBHErQxPyHS
   V1SA/tM8QraNKojPAppyv3J3oUc5jZQEFQmBomivFVryZE3Bpzm8ZE0+6
   jISfmL0JW8kGC+35x/UMfPNYCA4R1f/Vt4sq2LGXOiVq4KFB6A6B6zKzm
   q1oqRJmYUSelqh24qzR0MCxnVA/pz4LWoPdT0HFsZPHAC5n0+P+H8ttTl
   XHx+OTIOVOEW4fXIl0NmmHvytU7m75sUtT1+a77AAzzpJuZSur1LygB/l
   DZXQ1648zT2n+4Iqvma33sxGkhllaGE5LJSiImpl+iPXwjaD9jzJFOs9O
   g==;
X-CSE-ConnectionGUID: mcn2u3jnRmGqfwVn8Zl9Qg==
X-CSE-MsgGUID: ZFjDsXQYR+m0W3+TP/kCKA==
X-IronPort-AV: E=Sophos;i="6.21,262,1763395200"; 
   d="scan'208";a="139477806"
Received: from mail-southcentralusazon11013034.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2026 16:14:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YiF4DzHk4IVvQS7ucbuSc4ICEom+XOpG/mIw0DieHJvGlfHmwaCcZ2BnRNV2ZsCbkzwcYeaUbjIbnwQcgrF5traXJj18W/lPGa9pREkATlPTExCPFN6DqCzc2wMWRRuz0jTtD1+majZXNQVP91uW9uyzLe+BmEFTafQdBBoizBwy9fG3zhu9aQ15CbyTgnW2EpskSd/IKsiGtS0fO3hhG7FzVSTdilBYjDI7e1S6qCpNsNKZLe6Y1Q+uAwf8rvqGokTlAT20QYM008m8RLGoRMd3bcZ+LJHGJPK3t40dkBobQfy3Dw8TNmedSk/o6+yzFbsIEEDTI+vxOVwJ81Qn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Grlyld2P9FjFA0SFz3wiRh0ZZGBna6okSy/kA/N4/uE=;
 b=DHjJVWTM0xg6advcNJIDeCvZYZ8tEBNphIa/NYnyEsoqTL0Xd6bOVdR6cMYl/b+GlDrruDQOv9qzhPpgTzt6IAHZlxtpw6ZFfC6QlTPtKItN6tePAftGgzx9mzb8yMMqu4VyJuUzOMy1YJXZEjZRKjzm3LNFl8bVfNItjNRAb+GSuci7U+oZVY2eofIsxFFwEhV0ohikq9A9cRDYa6G/ceU2qXwq54hmlexgAUlz3tXzB6Hs8uAnaES+1HcKwJUrwPxLivhUPiQhD2aqBE5hfL0wXVynifl7+SXA0GjyRQngPGqWD2Uqsoo+bCZm6VC9XGEnOFw3f+azuA0bD2wDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Grlyld2P9FjFA0SFz3wiRh0ZZGBna6okSy/kA/N4/uE=;
 b=xqGkjfi4M257i9JZkU8fEK2p1GB9zMEZOj4+wutTt6ML6odsJvBbD/2yLCnUaEt438+070A5fCQD8QMk8CkofDAsuu9+Molr6Q3RFNbuGvd5E9lcydNUM4eoIYkycNsv7ffCfBdGlwsmumPOErU9IBEGXQRsGmt4mfQGfDQ+N0M=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB7073.namprd04.prod.outlook.com (2603:10b6:a03:227::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 08:14:21 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9564.008; Fri, 30 Jan 2026
 08:14:21 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 11/11] xfs: add sysfs stats for zoned GC
Thread-Topic: [PATCH 11/11] xfs: add sysfs stats for zoned GC
Thread-Index: AQHckag54II/HX73i0O54i5p4kXJT7VqXY0A
Date: Fri, 30 Jan 2026 08:14:20 +0000
Message-ID: <e547a819-b7aa-40f5-bf8f-b5e2d593cd3d@wdc.com>
References: <20260130052012.171568-1-hch@lst.de>
 <20260130052012.171568-12-hch@lst.de>
In-Reply-To: <20260130052012.171568-12-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB7073:EE_
x-ms-office365-filtering-correlation-id: e5c1c9d9-b47d-4539-60a5-08de5fd79245
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?M3NvRHhQWG0vRGhBcEdBM2h0b3F0cnN3Z2Y3WXN0YnhGSlpQUTM0YS9qL0FV?=
 =?utf-8?B?TWIzcGVUNnBhUlZVQWdOb3hZdEZ4a01GM1g3c09UTVc4cXZwZGt3c25PNFp6?=
 =?utf-8?B?bW5EQVBITFRxcmNPSCtMU0FDei9Rdzg4aHVPVVR4dG84MmhIYVp6YWY5TzlE?=
 =?utf-8?B?empDNDN5Z0lnOW9ZZ1NuZXdhQStaQ1preUtXTHoxd1pSMU9GYVBSbDkwL3dW?=
 =?utf-8?B?cVJhaVVGY0txWGFPUVRRRThNejlmUHdncHVoS2xud2J5cUVBT0xHZHdwK1N5?=
 =?utf-8?B?Vkk5bTVjbUp1MG0rY09pTi9QY0h6RGlNR2cvQzlacm5ZYVl0WXBlbHU0d3ZR?=
 =?utf-8?B?RDZJRno5dm90MkdiTjltNXhDUkxRczN0SFQ4RCtGcTBsc3ZkaUtsWUxjNnlt?=
 =?utf-8?B?NmxmWXcyK3RmUEtEL1JxZG90ZzZXNDJzajBtRjk1WXpnUVREWlNoYkVEd285?=
 =?utf-8?B?T3F1dDJpR1BjVkdYVkwxNW9pZXp4a0ZkQVNRdDBRSUVKWXMxdUtyVWxqYUtJ?=
 =?utf-8?B?T2EzU1dqWGhQWDBTSy9YTmY1bURRUDdWMTR3VDQ5bk56enhWaGNCQlFNbUVu?=
 =?utf-8?B?cjFDQitUb1FkeXBSYmlHUXcwclRWWE00bUluS3gwb2pZVXltdDAvREx3THFv?=
 =?utf-8?B?K3NFZnZZbHpReHpZbmFHQlEwODJCaGgyUzFlRTJVYVdqaGE5WHdXZ1hyU1pC?=
 =?utf-8?B?MGwzLzl2Z3l0SW1hS2R0dmtlM3E3VkNNMGdqcythaXBUNWVwckVGS0tzT3dO?=
 =?utf-8?B?M1ZiUy93eUplbHRwQTlMNnRuMFFiakJZUnFaL09XVlBRTEI2SjlRTmdyTkpm?=
 =?utf-8?B?N3ZyZWU5eVY0NENxRVlDY25Rd284ODJaTmZwY1puOVd2VWtUM2tpVjNIQTlx?=
 =?utf-8?B?TThMR0xud1hoa09sQ0lWRTRFNVVGYU83WXNQaU5FN09jdEJZM3JjSW1XbHJY?=
 =?utf-8?B?ZmpyYVMranRkOHF2OXRvSVZYeUtyWC9zc0ozMHQ4MHhvc3VSY3U0S0FOZjRv?=
 =?utf-8?B?NlZVeEpROTZCb3FBREVOQ0tPQkc3UzkyT2VncU5SRW1TdTZJcksyNk44enFW?=
 =?utf-8?B?ZzBrZEIzbS9vbmpiMFAyTUNRL09ESFhySGlIWGxFT0JzMTVwdGFoUEFCSTdt?=
 =?utf-8?B?ak0rMklqTG9zUGRSTDFIZUx2OStUMktYOGlOdHE5S3F3RUpsZEVqZ2o2UXdB?=
 =?utf-8?B?QnZyM2lPaGlDU1RoQUdXQytkWjBlUGo1czNncnhmd1lCZHE4bzI0YXliMHFv?=
 =?utf-8?B?dXRGY2grazRJTzdWaVBPSVRjYW1yWnhxUEtONjQzYmZOeFZhOWxkM3piOEFk?=
 =?utf-8?B?UFRkNmJGa2N2NmszSnl0U0J3dDJDWlhSYm1abUx3OW9QWnNobFMzZCtqaC9u?=
 =?utf-8?B?YmFSbjVYU3BLd2NzaTIzSmw5SzdmQUlpWFhDKytJZCtZenVHV2pkZWNHV1FJ?=
 =?utf-8?B?STBFYWYrdEdEZTVzby9BMXhkUHJyMERGNzFySjF4VWFyeGFZdTlnRE1pV2N1?=
 =?utf-8?B?b2JoYnlidzM5endLSDZkNzkvZmtrNkJ0Q1BNeWZMQTNJVytYSTI5RlQ5a3FK?=
 =?utf-8?B?RHN2blJtRW9OZ1kxVWZiUDNOSGRJekdJWDFQNHFNUi8wblNDUVJzNnduS2or?=
 =?utf-8?B?TVdSR2NsTFQ2WUNhdDczYldIN1llcU5LeUMzSFlYMEE3NDVsTmVPaEIxcDRy?=
 =?utf-8?B?TlB2K2JZc2txQjlFR3J4OFJGS1R4NkFOTjVUcHFrZE81SnVzNVBweTJNR0JY?=
 =?utf-8?B?ejFlQU9CTDZOeXBKdFRReWVYdTVkQWdzeC9WOHV3bjUyQXJWSTB6Z3U2R3Jk?=
 =?utf-8?B?YklCdHhiUEMzbkpJS3VoSU9XODU2VlBvSEZDL0N5VG5KZkJEVjYvSkpucUI3?=
 =?utf-8?B?Qkg1U0tScFpCUWN0MFlwZTg4eFEzT1kxK1k0NEFSb09WT0FPdlZXM0xpZitO?=
 =?utf-8?B?MnpiMC9aQmwwbzhHZVQwVTQrc293R3p1QnpZeUNkMjA5Z3luME91NUh4WWFL?=
 =?utf-8?B?RzhnZlc3VDVVV3BIalBaUmdzSXhXclFveUQ3MXdjVWFVdnVkcEhHNlRHUDZt?=
 =?utf-8?B?RXI4Um41QWhtYTFmb3ZmeFpQaUhGdWEyOWFnUW11Vi9xaXZMUllDUnpWZHYy?=
 =?utf-8?B?bFlXOTNjMkxBNk1XMVRISGNxOWg4cHJqTEtEVktEZWNwUjlwUlNrTm9yZFNS?=
 =?utf-8?Q?YqwZTsDDFkp2a+fqran2pMg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFNWS1BsSE5kNDRqcUdJVGhJWEs0TWdtVXpWOGZKM216K3NORWxHRnRQTEJq?=
 =?utf-8?B?TTUydk1kU09UTnhyNktiMFo1cGk1cTdhNHRFTWRCdGlDbVN4U2V5QjJxbDNN?=
 =?utf-8?B?cEdMaWxlV3hjT29uNkFWNmM2OE1mNUJLTDFwQ3lLVFgvcTBSM1N6K2FKOHNE?=
 =?utf-8?B?K3pvYXBENkVQWnAzQmEvelI0ZWIrWEwrS2cvTk16WjlkcEJwa0RsSDhMcTEx?=
 =?utf-8?B?UGVqTnNVdFpFTU5qdDBLK3hlaWpNcmNsZENicU9URUhieG5aT1VUVXhwdzhj?=
 =?utf-8?B?ZWU1Mi9hSmFXNWFLZGtjVWl2MDRKL24yYklFVGE5ZmZuakZ5ZXdSdmRaUWJ0?=
 =?utf-8?B?MEhZUGpKcXJUd3cxYXNPU1BKV3Y5V2hTalNTMlExUmthWCtrYnRmZEt2d0hs?=
 =?utf-8?B?c0p4Q1FiYW9SQVNsUzdRU29OTWhndjdacTBaUy9GbEttdVdsZDJMVjNpdDNt?=
 =?utf-8?B?NVUxblE1dElSaDRHL3ozYWVsWS8zbkJEM20xakpRVlJlU3NaaW0xZUk4c3dF?=
 =?utf-8?B?Y0RacUxwNU1nUlU2NFl6UkVEYmtscXI2YXpXWjJveHZDM3cvcGgxM3ZQakZG?=
 =?utf-8?B?MmJkZmtjbUluc1p6K0Q1cnBmVE5mMVMyQmRVYTAvSi85UlFacFNLMy82YTVH?=
 =?utf-8?B?bkZhc1Rrb1dpcmtiUks3WEdjN2tETHJqeGExVDRiSDhNTlI4dGdYSTdsQktL?=
 =?utf-8?B?L0ttcEdjM0dPZUgyZ2lVYW5WTDZDMUZRdjFnVnNmMlV2bHR6cVF5N0NTN2p0?=
 =?utf-8?B?OC9RSEVzbEh5ZkdpZEczdDlOZmhYSytWL2crUGNIZXY1bGUzZzJ0UlQvaUor?=
 =?utf-8?B?UGpTbEt6L1A5NU9HTm9VU09mV2tZRXU1R1NvMGN6K1BuZ0VRbUN1Mmc0RFNE?=
 =?utf-8?B?NExxWnZjRVNWcEdWRTlHMEJPSVg1R0pTd2p1c2NHZGwyZW83bWhWN3dMeXBu?=
 =?utf-8?B?ajFKbmJDSWQwQUU4MkFSNXFoa242YnNMUFFpSk9xSHMyVmd6THdueU1kMGdu?=
 =?utf-8?B?aGdEcFl3U0txRFVNVlZONGI1T1BwcTlOMjEzWUR3dVczQ3pLZlNUSzBiOXQ5?=
 =?utf-8?B?a0dlTk1wSmRQM3MrZm41dVBhZzVNek03OEs0WUVjSVpadjliU3RBTXR4MnF5?=
 =?utf-8?B?WU0wQTRTNHo3bjNKVlJucGpKMk1sM05jM2F3cGJ5Uy9lNURTbGM3ZFNpcWhV?=
 =?utf-8?B?eHRwa2xxdWF2ZXFzK1UzSmVQQmJMYlJQUWMyQVk1ZlBGZW1EaERJUG9rTHdW?=
 =?utf-8?B?WVprbVQzZ3QzaVd1TVd5Z1hFOWt1Vi9Fam5qWm9wc05lbFJHdmtKM1V6c25i?=
 =?utf-8?B?TUV0aGR3cjZsTysrWWFTNU5pUS9Zc2JBWlBlN1FGWXpHeHFFL2VuQkp3RUdO?=
 =?utf-8?B?YnZhNXdtM2V6WFVjR3pZZ25vZElJQlQ3cU1XNjIzbENWSWxGNCtKMVRnU1pG?=
 =?utf-8?B?dVFTS1UraDJYa3NoTHY5SEFRSzEveEdIVXFicE9kYVowN0ZERElnZlhoLyt1?=
 =?utf-8?B?TDNXeTZ6R1M3MFh1QWtvV1NrQ0Z4SDRCQjZKS2FwcmZFbDc5Q0tQQmMzWlp4?=
 =?utf-8?B?V0ZFeHZnZklrTHZwT1dWZDJjTVowYmNtR0FvLzd1V1RlZzNydFEwbzNMR0Qv?=
 =?utf-8?B?aDJxMEJSUG85d0VRNnN6MlV1aHJYQkU2UVkvZldXWjFxcm5QL0ZJU0lJTXNO?=
 =?utf-8?B?Mk1YWHFITWtyRTFSelN6S2c5N09kdjloS2RLNUFXUStERU4wVmRqQStYOUhz?=
 =?utf-8?B?ZUl5a2ZwbHczWHlZNWZUaGdaOEJyc0t0TDd5SjRXcVNUR3hCTlJ1a0w2R05K?=
 =?utf-8?B?NUQ4aEhJK0lJa2pmWGlwR1lwbi9mS2xkTTlTTWw5ZGRwVzNSTzBaQ3Iycndz?=
 =?utf-8?B?OE5ETkUyaDFzSVR3L3hxN0lsVERaQ2RjRmhSZDVGMnhCTGVwcHlWc1R3TnUz?=
 =?utf-8?B?T2Q4UmxuUUIxbkozMUF0QXc4VCt0STFXcVdDMVhOWHR5bTEyOVNYNHEwNE96?=
 =?utf-8?B?R3hsNDA4SnVXckNjSDlPS21MRFFGaGUwZ0Qvd2dTUEEvK0R2bldPU21taGFz?=
 =?utf-8?B?bUNKemdTZnd4d2tpN2Y5OG9DUFdVZnNhNEZXSjZSVEd1RmVtSzVCeGNkRCtY?=
 =?utf-8?B?QkRYWVhjbHJETDd4bHI1VUxqOXYyOWd4SG5XRnowSE5ReHJubXQ5cEJYYURt?=
 =?utf-8?B?WWVCWkZvVEFRdzdFY2ZuenJFV0Y3MGRQOGJEYlBWb1gvRVYvOFZ3Q2MxZFNX?=
 =?utf-8?B?MW9SYnhBbkE1dStpQWR1cHJiYk9GZ3p6TERjSmg3RlVFV2pqb1NZRlVLamVj?=
 =?utf-8?B?UWVGWE1tTkpEbFNyRzJaYzBrblpUdDhkWmJjU3ZybWRJT3lqQ2R1QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F42AF645BD5D944B3730BFA6EB05E18@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/yTDyg2TgfFNvLtbT4y8uqfZkwlZMUw2cB3Lr1oJnyS+/kLU9lZNCb5prFzUG/r7j8rwqjh2jWiSek7WNFvx1vYB4o5KDT5MwUW775DgJ4rrCjoGeJaQcGCMXvgkFnJZASrXxzj5uUKkOWCiCJUy4guzbgiMoG4DJqlwC4mKx/7IklrUOIF/ECjpF2/lLXbHhg4OhgFuUbMqPLQuACgqXkacyPH7ZnoicaRc2RMjh9qV2l6XK94lHx6DkO6KauxYWTs9gJtUAZ5FtvF1wA4iU/XsOFU2VSfU6gwzydPOkpEmslHJf6aFMMR9uRxuIsCkuoJTSitdqlFkLXVGt3wo31lZBenPdqb6lqCokyiKbW6p540GPMJLVFrDMbkSCSmNdlzvQeaGgG5nZ2RkMV9zqxiJAwpTtuqiW27axDyibs/lgoucYs0e+emF8YcGS1ZlhxL1liBkfPiKjzbWS1aCBArJh1BGEUeCQVLJN/zKny/LLqUy02IRR1sfRThiUVepOsTJkEjqYe32tpRlw2n7IPOyxqEu9J4CcGDC8/mGCRFGOckI9u+s7vEMbiePAho97EiYAS1zyWwv9PsPNAoFa6HM5V5smcKRBSS+v+BHTp2EqdU8lVQx9iRKY5fne52Y
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c1c9d9-b47d-4539-60a5-08de5fd79245
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 08:14:20.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RnyYCkL0qbRYIQJGz6m49H2gYsg3BIH/+fTgVLYb13RJTw4t6Ec0kgUUEgd9SW8G5zwQl2u/KwBzDpSlp+GVQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7073

T24gMzAvMDEvMjAyNiAwNjoyMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEFkZCBjb3Vu
dGVycyBvZiByZWFkLCB3cml0ZSBhbmQgem9uZV9yZXNldCBvcGVyYXRpb25zIGFzIHdlbGwgYXMN
Cj4gR0Mgd3JpdHRlbiBieXRlcyB0byBzeXNmcy4gIFRoaXMgd2F5IHRoZXkgY2FuIGJlIGVhc2ls
eSB1c2VkIGZvcg0KPiBtb25pdG9yaW5nIHRvb2xzIGFuZCB0ZXN0IGNhc2VzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5
OiBDYXJsb3MgTWFpb2xpbm8gPGNtYWlvbGlub0ByZWRoYXQuY29tPg0KPiBSZXZpZXdlZC1ieTog
IkRhcnJpY2sgSi4gV29uZyIgPGRqd29uZ0BrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGZzL3hmcy94
ZnNfc3RhdHMuYyAgIHwgNiArKysrKy0NCj4gIGZzL3hmcy94ZnNfc3RhdHMuaCAgIHwgNiArKysr
KysNCj4gIGZzL3hmcy94ZnNfem9uZV9nYy5jIHwgNyArKysrKysrDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDE4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX3N0YXRzLmMgYi9mcy94ZnMveGZzX3N0YXRzLmMNCj4gaW5kZXggM2ZlMWY1NDEy
NTM3Li4wMTdkYjAzNjFjZDggMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfc3RhdHMuYw0KPiAr
KysgYi9mcy94ZnMveGZzX3N0YXRzLmMNCj4gQEAgLTI0LDYgKzI0LDcgQEAgaW50IHhmc19zdGF0
c19mb3JtYXQoc3RydWN0IHhmc3N0YXRzIF9fcGVyY3B1ICpzdGF0cywgY2hhciAqYnVmKQ0KPiAg
CXVpbnQ2NF90CXhzX3dyaXRlX2J5dGVzID0gMDsNCj4gIAl1aW50NjRfdAl4c19yZWFkX2J5dGVz
ID0gMDsNCj4gIAl1aW50NjRfdAl4c19kZWZlcl9yZWxvZyA9IDA7DQo+ICsJdWludDY0X3QJeHNf
Z2NfYnl0ZXMgPSAwOw0KPiAgDQo+ICAJc3RhdGljIGNvbnN0IHN0cnVjdCB4c3RhdHNfZW50cnkg
ew0KPiAgCQljaGFyCSpkZXNjOw0KPiBAQCAtNTcsNyArNTgsOCBAQCBpbnQgeGZzX3N0YXRzX2Zv
cm1hdChzdHJ1Y3QgeGZzc3RhdHMgX19wZXJjcHUgKnN0YXRzLCBjaGFyICpidWYpDQo+ICAJCXsg
InJ0cm1hcGJ0X21lbSIsCXhmc3N0YXRzX29mZnNldCh4c19ydHJlZmNidF8yKQl9LA0KPiAgCQl7
ICJydHJlZmNudGJ0IiwJCXhmc3N0YXRzX29mZnNldCh4c19xbV9kcXJlY2xhaW1zKX0sDQo+ICAJ
CS8qIHdlIHByaW50IGJvdGggc2VyaWVzIG9mIHF1b3RhIGluZm9ybWF0aW9uIHRvZ2V0aGVyICov
DQo+IC0JCXsgInFtIiwJCQl4ZnNzdGF0c19vZmZzZXQoeHNfeHN0cmF0X2J5dGVzKX0sDQo+ICsJ
CXsgInFtIiwJCQl4ZnNzdGF0c19vZmZzZXQoeHNfZ2NfcmVhZF9jYWxscyl9LA0KPiArCQl7ICJ6
b25lZCIsCQl4ZnNzdGF0c19vZmZzZXQoX19wYWQxKX0sDQo+ICAJfTsNCj4gIA0KPiAgCS8qIExv
b3Agb3ZlciBhbGwgc3RhdHMgZ3JvdXBzICovDQo+IEBAIC03Nyw2ICs3OSw3IEBAIGludCB4ZnNf
c3RhdHNfZm9ybWF0KHN0cnVjdCB4ZnNzdGF0cyBfX3BlcmNwdSAqc3RhdHMsIGNoYXIgKmJ1ZikN
Cj4gIAkJeHNfd3JpdGVfYnl0ZXMgKz0gcGVyX2NwdV9wdHIoc3RhdHMsIGkpLT5zLnhzX3dyaXRl
X2J5dGVzOw0KPiAgCQl4c19yZWFkX2J5dGVzICs9IHBlcl9jcHVfcHRyKHN0YXRzLCBpKS0+cy54
c19yZWFkX2J5dGVzOw0KPiAgCQl4c19kZWZlcl9yZWxvZyArPSBwZXJfY3B1X3B0cihzdGF0cywg
aSktPnMueHNfZGVmZXJfcmVsb2c7DQo+ICsJCXhzX2djX2J5dGVzICs9IHBlcl9jcHVfcHRyKHN0
YXRzLCBpKS0+cy54c19nY19ieXRlczsNCj4gIAl9DQo+ICANCj4gIAlsZW4gKz0gc2NucHJpbnRm
KGJ1ZiArIGxlbiwgUEFUSF9NQVgtbGVuLCAieHBjICVsbHUgJWxsdSAlbGx1XG4iLA0KPiBAQCAt
ODksNiArOTIsNyBAQCBpbnQgeGZzX3N0YXRzX2Zvcm1hdChzdHJ1Y3QgeGZzc3RhdHMgX19wZXJj
cHUgKnN0YXRzLCBjaGFyICpidWYpDQo+ICAjZWxzZQ0KPiAgCQkwKTsNCj4gICNlbmRpZg0KPiAr
CWxlbiArPSBzY25wcmludGYoYnVmICsgbGVuLCBQQVRIX01BWC1sZW4sICJnYyB4cGMgJWxsdVxu
IiwgeHNfZ2NfYnl0ZXMpOw0KPiAgDQo+ICAJcmV0dXJuIGxlbjsNCj4gIH0NCj4gZGlmZiAtLWdp
dCBhL2ZzL3hmcy94ZnNfc3RhdHMuaCBiL2ZzL3hmcy94ZnNfc3RhdHMuaA0KPiBpbmRleCBkODZj
NmNlMzUwMTAuLjE1M2QyMzgxZDBhOCAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc19zdGF0cy5o
DQo+ICsrKyBiL2ZzL3hmcy94ZnNfc3RhdHMuaA0KPiBAQCAtMTM4LDExICsxMzgsMTcgQEAgc3Ry
dWN0IF9feGZzc3RhdHMgew0KPiAgCXVpbnQzMl90CQl4c19xbV9kcXdhbnRzOw0KPiAgCXVpbnQz
Ml90CQl4c19xbV9kcXVvdDsNCj4gIAl1aW50MzJfdAkJeHNfcW1fZHF1b3RfdW51c2VkOw0KPiAr
LyogWm9uZSBHQyBjb3VudGVycyAqLw0KPiArCXVpbnQzMl90CQl4c19nY19yZWFkX2NhbGxzOw0K
PiArCXVpbnQzMl90CQl4c19nY193cml0ZV9jYWxsczsNCj4gKwl1aW50MzJfdAkJeHNfZ2Nfem9u
ZV9yZXNldF9jYWxsczsNCj4gKwl1aW50MzJfdAkJX19wYWQxOw0KPiAgLyogRXh0cmEgcHJlY2lz
aW9uIGNvdW50ZXJzICovDQo+ICAJdWludDY0X3QJCXhzX3hzdHJhdF9ieXRlczsNCj4gIAl1aW50
NjRfdAkJeHNfd3JpdGVfYnl0ZXM7DQo+ICAJdWludDY0X3QJCXhzX3JlYWRfYnl0ZXM7DQo+ICAJ
dWludDY0X3QJCXhzX2RlZmVyX3JlbG9nOw0KPiArCXVpbnQ2NF90CQl4c19nY19ieXRlczsNCj4g
IH07DQo+ICANCj4gICNkZWZpbmUJeGZzc3RhdHNfb2Zmc2V0KGYpCShvZmZzZXRvZihzdHJ1Y3Qg
X194ZnNzdGF0cywgZikvc2l6ZW9mKHVpbnQzMl90KSkNCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94
ZnNfem9uZV9nYy5jIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gaW5kZXggNTcwMTAyMTg0OTA0
Li4xZjFmOWZjOTczYWYgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+ICsr
KyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IEBAIC03MTIsNiArNzEyLDggQEAgeGZzX3pvbmVf
Z2Nfc3RhcnRfY2h1bmsoDQo+ICAJZGF0YS0+c2NyYXRjaF9oZWFkID0gKGRhdGEtPnNjcmF0Y2hf
aGVhZCArIGxlbikgJSBkYXRhLT5zY3JhdGNoX3NpemU7DQo+ICAJZGF0YS0+c2NyYXRjaF9hdmFp
bGFibGUgLT0gbGVuOw0KPiAgDQo+ICsJWEZTX1NUQVRTX0lOQyhtcCwgeHNfZ2NfcmVhZF9jYWxs
cyk7DQo+ICsNCj4gIAlXUklURV9PTkNFKGNodW5rLT5zdGF0ZSwgWEZTX0dDX0JJT19ORVcpOw0K
PiAgCWxpc3RfYWRkX3RhaWwoJmNodW5rLT5lbnRyeSwgJmRhdGEtPnJlYWRpbmcpOw0KPiAgCXhm
c196b25lX2djX2l0ZXJfYWR2YW5jZShpdGVyLCBpcmVjLnJtX2Jsb2NrY291bnQpOw0KPiBAQCAt
ODE1LDYgKzgxNyw5IEBAIHhmc196b25lX2djX3dyaXRlX2NodW5rKA0KPiAgCQlyZXR1cm47DQo+
ICAJfQ0KPiAgDQo+ICsJWEZTX1NUQVRTX0lOQyhtcCwgeHNfZ2Nfd3JpdGVfY2FsbHMpOw0KPiAr
CVhGU19TVEFUU19BREQobXAsIHhzX2djX2J5dGVzLCBjaHVuay0+bGVuKTsNCj4gKw0KPiAgCVdS
SVRFX09OQ0UoY2h1bmstPnN0YXRlLCBYRlNfR0NfQklPX05FVyk7DQo+ICAJbGlzdF9tb3ZlX3Rh
aWwoJmNodW5rLT5lbnRyeSwgJmRhdGEtPndyaXRpbmcpOw0KPiAgDQo+IEBAIC05MTEsNiArOTE2
LDggQEAgeGZzX3N1Ym1pdF96b25lX3Jlc2V0X2JpbygNCj4gIAkJcmV0dXJuOw0KPiAgCX0NCj4g
IA0KPiArCVhGU19TVEFUU19JTkMobXAsIHhzX2djX3pvbmVfcmVzZXRfY2FsbHMpOw0KPiArDQo+
ICAJYmlvLT5iaV9pdGVyLmJpX3NlY3RvciA9IHhmc19nYm5vX3RvX2RhZGRyKCZydGctPnJ0Z19n
cm91cCwgMCk7DQo+ICAJaWYgKCFiZGV2X3pvbmVfaXNfc2VxKGJpby0+YmlfYmRldiwgYmlvLT5i
aV9pdGVyLmJpX3NlY3RvcikpIHsNCj4gIAkJLyoNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQt
Ynk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
