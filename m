Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102181547F0;
	Wed,  9 Oct 2024 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456369; cv=fail; b=gf3TCg/2mLch9a5Jvjj32hNbbXJ6GBgeZ9om/9jkPweDnS9DNmYEQbHksEH+lKYhyaW0X5H4QaB4vmwAUXv0aKIb4rG6qoArqGfu00Lj4Aq8O+jLN5SWDlG5M3Cxfuw9b/rtX4uJ2WjjeDZuWi96mkaGVA7zqCERp412/jP1JVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456369; c=relaxed/simple;
	bh=Hv0gDh0U+xu/Nxii4SOYg/d2Awt62QKuC0jVTQ7nons=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i18YgdcN6piMC73eUbhhDe+HAgTjeB4IzyJh+cNHkuX0VNI7kXmuVmhtKDm+rB8VevY75X7fTKUAA9CFqNM9kZa8RS1hDlER81Wq1k75iMY+9iabAONLLKh5JzUJQzGU8h8KwE9yimyrO8k05ivs0V+l7IX/N4ozOLdVIxh/+QY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hWP6EVuv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dir/EwCY; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hWP6EVuv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dir/EwCY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728456366; x=1759992366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hv0gDh0U+xu/Nxii4SOYg/d2Awt62QKuC0jVTQ7nons=;
  b=hWP6EVuvj6CkE+tKCevDxxYpCtgK06s17m27ZXCke57vH17oKZ7PpcN8
   EkrIU6M+23sasRJIBBy7kI+hBSUoNFr0N3QHGmtjp71HloJ4zXz0YIh6P
   fYTnMC8a19lN5ViMQZD/l3UREhuHggJULRcL8YWjZTEo/XDRQW28kBeT3
   Yf1DemXSw2JZOs9klb+fTgOOAKIyzZ3Qn//6R0AWTbprI1c6o1oBX21Ma
   VDwFyl/OHNeczIo/WDOb6ERs/R6b+SzBR6PmZUZAjgTVanZCn+4PxIfh+
   TkRYHHdY6J+wQYdl9uONfb8l+fm3PwO2+n7cdOQsbgLMdQGZHArmo2Zo9
   w==;
X-CSE-ConnectionGUID: qW2+Q4Z5RpyfzxFU1nQ7/g==
X-CSE-MsgGUID: cx0YrrFGQhCHjdajB12hlw==
X-IronPort-AV: E=Sophos;i="6.11,189,1725292800"; 
   d="scan'208";a="28994332"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 09 Oct 2024 14:45:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXcxFvACNqE+szv5iuoroI5uOuovuAULrRKuCQe0ChLztta9wYPKj/uxqJg8lDtAjVwGjWCAji+McnIp4EH2Rf7E79kA7z7rVFdXmuh+sbxcr/oQeaphZA/fdpIc4Wa+85prBjNnb5lWtYIVTb1kfNBNomeT2A49+qQ5Url4YhCZljkTCm6bl+zl+D1FtNuaEkN8yAJLqmm+2EOLga2Y7TWjySztqZLpi51KxlPxIWkygFcvKW4qjc4ZTN8JcNbOqoGbbstyYRQSru+U73wzyk+mqmqtim7ybl22vUNzPGuZukH4FoTBpRj55iZmD5zyPE1WQOSEaD/IRcnj14zLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hv0gDh0U+xu/Nxii4SOYg/d2Awt62QKuC0jVTQ7nons=;
 b=XM/cnkkPYDhy5ba0eYczlXVSJ6IOEKDlYdsHyATPqmNTB11kOQwc6SEhGCTvbVRy/a+kFbIppo6zpCgen++ii7uVVYRrUSmMgBcGMd8o69CWq3lLoST+RpI42MJ6y6OG/MeZfBurLVesBVixfTGKj28PGhsQitBvJ9YwB/sCpoEwnHrfOnweW+yFs8k+X9zEaB6ng25cr4NivIFwtQ+O5TSsWBrO9fzsmRp8mj064RGVqm8g0THtUtembymtsCfgY/PXgkTnJ8/81M/L6DJ0NcYBBf0a56Ht2cshEqouOuQ+nDI2qklaBP/kd8RFbvq8azmFADQjb/BS06AYb1LQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hv0gDh0U+xu/Nxii4SOYg/d2Awt62QKuC0jVTQ7nons=;
 b=dir/EwCY0KE1A34VwedIVY2vF0UjNdJOO77Jm86FKa9Ba55mU86jkwDMsagHfaRoSEL4/uNft8DAPqC/Q+OIwz4Ip+Z4RB3wH31s9VKwLCEaXdWR7Q7k5o4ylaQkNvffHw1D7FAhOfH8RAJgooBI8VCLYY2zirMMr1dCK610kxk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SA1PR04MB8221.namprd04.prod.outlook.com (2603:10b6:806:1e4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 06:45:57 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 06:45:57 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "zlang@redhat.com" <zlang@redhat.com>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Thread-Topic: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Thread-Index: AQHbGXAcO8L/aUmkt06VOR0qHTTj/7J9F2UAgADjgwA=
Date: Wed, 9 Oct 2024 06:45:57 +0000
Message-ID: <e81d2e10-5b13-4d3a-937e-d7cd48c21ba3@wdc.com>
References: <20241008105055.11928-1-hans.holmberg@wdc.com>
 <20241008105055.11928-3-hans.holmberg@wdc.com>
 <20241008171138.GJ21840@frogsfrogsfrogs>
In-Reply-To: <20241008171138.GJ21840@frogsfrogsfrogs>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SA1PR04MB8221:EE_
x-ms-office365-filtering-correlation-id: 6afa198c-c9b1-44fd-9219-08dce82e07b0
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aEVEdUh2dUx3bFhUdUZLNlZzYmNuN3FuY3krL3NRRXltZnh5Kzdib2o4RUZz?=
 =?utf-8?B?OGY1ZTRJSnRTVndHT3ZpZ2JGUk1hL0JOQ2ZkZnJjK2hIbGI5RENKdGVvSlNx?=
 =?utf-8?B?eFpabnBtZklHVHRVK1hmOXRjN2hRczNwK3BPT215UklONTNiOS85TGgyT2JC?=
 =?utf-8?B?d1Q2eFJlVEE0Q3c0d0pMNTlEVHFTdVFNV2MvdFljQWttdUwvRll5dlFLY3Z2?=
 =?utf-8?B?b1RZUW5ldUNnZGhqUVZrV1Q0QXBJVFFxY3ZxTVBvVGx4SEtuSEdBZ3hqZFkv?=
 =?utf-8?B?WU9ENXlFb0dGUVBkMEhHTEcxbCs0enQvZXRnTElOeENrU3htdndKNTROYUtI?=
 =?utf-8?B?R2czNWtxWEtkWkREU0oxc0ltTWR0RDBqeFdzeHFER2UvVG5Ed3kyMHVoNits?=
 =?utf-8?B?b25oU3JpdUE2ZmVlTDhsaGJHVTMwNUVVaStCamhlblN4YTNmOXRnSHBCNnN3?=
 =?utf-8?B?SjVUN2xrL3hIeVkyS3VScFpDZ1o1cVkrazkrTW5xSkdSTHF6aWJMdkY1cUJP?=
 =?utf-8?B?YU4wbjg3WXZxcCtsaUlGcTY2QVJjUG4rNVg1SXZsV0FleW9SajRyL1ZGV1Nj?=
 =?utf-8?B?ZEJDVEljbTRSSjVLbXNYajROazJFSEVTclBnK1YvRmhEbzNpUEhQb0VTWmtt?=
 =?utf-8?B?WmVodEVqTHpDblA0TzZuR25YL1hJdndUQ1VzM1RDaldvN3I4WStMeExZWHdE?=
 =?utf-8?B?VWE2UWROREF2WFJmWnBVTDhsV3pka0psOElaOTRHV2pzQTBrVE1WVnFONUQ0?=
 =?utf-8?B?aTZiTkg4ODFKYTM0STVlN1R3N0FNUkRsdVBtUTVNNDZVdWdiUzJ1dklRYnNN?=
 =?utf-8?B?bjdRMzc3eHl5OEVIZSs3U01lWExRQjdXTkJ3NkY0ZzM1UlZmWnVqdTg0NUpS?=
 =?utf-8?B?OUYxQ0lPVXByczdrMS84TC9UZzBDWTk0SzdHWnlGZUdvR090dHdIUlJWS09X?=
 =?utf-8?B?U1hLRDNNN04wL3BTNXV4UGJYeHhiVkRTd2d2QmtSenhjWmRpWGo0QWFVbFFE?=
 =?utf-8?B?QTJiRUN4cFU4OGhBNHJVSnhtUEFSRGZYSXlER2FVcXNxTjFKaDh6bDNtenlW?=
 =?utf-8?B?MnhBUzdXcjVNRlgwdlg1YnU5R05TdDhIZTRIMnpaczZSZE5aWEFYZ1lwUU9D?=
 =?utf-8?B?cE9HMm5XU0daaFIycmR1eitVREVBUEVyb2N1bFRTbVh6SkszOUpIRG82SHow?=
 =?utf-8?B?ZDJYYmw4cW5pdW9kV2pNbHZEOVNBTUV0ODZWNkppUm14dncwNnVSOGNUd1da?=
 =?utf-8?B?Ym5ucDNrM3RBbnYrSjBXbDRTaDV1Z1VxQjNwYnRPcEJaT1R5MHdzcm9NRzVD?=
 =?utf-8?B?RkRhR3VOVUhXRTk0U2lyVjVvUEswU2tPNW9NOXZ0ejY4VFQrSVVoRFVxZjZD?=
 =?utf-8?B?bXlxajRPZXNLRVpJUnUrd3BxZUpwck9DZDlCL1NUT3VERGhWRXJ5VS8xNlo1?=
 =?utf-8?B?a2tGWGNFOFFkbnFYSE80UDFIWjJZeFZzYXUvNm1pdnhIQ1BzMVkwSTNEN3VZ?=
 =?utf-8?B?cEg1WU5TenlObWJtV1k4OE9vOWpxcHpaaGxzY2t1d0paeVBKYVYxRUhhekZq?=
 =?utf-8?B?WnR1WGNiNm5BbFdlcnU4M2JQM21FalE3KzU1bnVIeURIUDBhTlpVdFM5cHlt?=
 =?utf-8?B?dlgzZ0M1MkNwOUlOeld2T3h6QzBydkxDQmhtdi82VUN1OTNuMTlBaW1zNStK?=
 =?utf-8?B?M3ErUWNEaWQydmJuUEZPUUswSDhQeDVWZW5uL1BCc2NJTHZnd0kycEJ6bFhV?=
 =?utf-8?B?ajZpL1dmdlFxaGtXbHJrbTU2V29qS0ZpTzRha0hoRE1aMG9uejZJT1NiZEJt?=
 =?utf-8?B?ekJWMGFkM1lKWDRYZEtnQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3VuWlltZDk1TmpaWEhTYmZ0NmowcHM2cFhrMEdXV2VPd1hqVGxxOCtidFp6?=
 =?utf-8?B?WnpoTG4reGthdjhRb1liWDEzb3J2cmVTOWZjNmY2RFN1c0RtcU0wWG4wc291?=
 =?utf-8?B?aUw0UjBJN1I5U3RXOXdFTWxhMHNXbUZRQUFoYzdIUTNUTEJwWkt1ZTc0OUxS?=
 =?utf-8?B?MTV6MzN3SzBCNDBSR0xSMERpSDJzK1hrbjZSTWlZeFZwRkVMa1NwaytHQUV0?=
 =?utf-8?B?MXRoaTR0OXZVYXpEWTBRckg3OUJuNUROZkQzUmQ1YTFjeTVWalB4QjhLVFkx?=
 =?utf-8?B?TldrSnJiMHBmdUJPaVZXTDZDNnY5WUJ2SC9mWmFxVmJTWldCMjU3eW5Tb3Rx?=
 =?utf-8?B?bmtrVittM0NiU3pqejVsamtMcDQ4dDhsSVpvZVVoRUp2RTJqZ3g5ek9tdm80?=
 =?utf-8?B?Qm9BaWFkViswUUNkeFNiZkNLcHFpVkhYVGdrK0x4cGxJNE55azUvRnd1ZlZR?=
 =?utf-8?B?Rm9pRHU0bElMNS9wb3dlTDZwNFdyWkxXZDVJU3FFV3hxUm5CVUIwWVFxd05F?=
 =?utf-8?B?NHFFYW5DVERwUzFJU3pCVnNXemx5NDRpMUFGOUZtQmlhVHFYMGZYa2lqeloy?=
 =?utf-8?B?Z0w5ZG42Y0ZoRGdabmFkdFd5N0FaYlg5VzZHaVhCYkdOMXoyL1cxcEl3OHJv?=
 =?utf-8?B?YS94ZGJmRVRQZlBncjVxZWlDZDlWRGxPejJsaFlmQWpwN205RklLdmRsd1RE?=
 =?utf-8?B?czB2Z0pERjkrUE1xckRkNHZvajRUZEdxRE8xbUxTU2dETFdtVkZ2MWdlM3Qy?=
 =?utf-8?B?YXlndGRDZWdWWXgrY2IyK1NsdXQxVzc0UFkvMVprQVZ3NE9PU0RNV1VuQThy?=
 =?utf-8?B?ZXRkWnhieXgzUTYza09MOTJiR3luUkg2OUNiN1cxeFg0MG9UbmJ4SEtkZzFZ?=
 =?utf-8?B?LzlvVlUwZWg1TXZUSG5RbnZIVnRoMEVOUWRYZWtPeGFRcE1mbUFZMUZRMTlk?=
 =?utf-8?B?cEx2UmJ6UEp4SktLUjF3UHpJZlpUV3lnbXFLdXB0TjF2NGFqMGtIWDczRUt3?=
 =?utf-8?B?cWNkbmV1L1RyNTR5bjZNK1V6QmJFbDB3SEhRdG5YN3lwR1IyNWdXZlhsUTFQ?=
 =?utf-8?B?eTFZcXM4N3hOczhlN2U0UDVXeWxKN0RKRjI5WXdPWWRqTmlkcWtTTWtIdmNS?=
 =?utf-8?B?U3lVRjVsbFBURXRTSUFKcWNVTTJTK2xWSWl4ZEMvUExQVjlINHBxd0hZSWtZ?=
 =?utf-8?B?ckdsREZzRVZGRUZMeVQyTEIyR2RFME93cXpRNzdaOFBNVUs2MFY4Mkc1dTFl?=
 =?utf-8?B?UGNCcjNjdEorTk91VnhjeFkzWWhOc1dOUVYvNjJEM3dBWFJNZ3E2ZXpRa1gw?=
 =?utf-8?B?VVdKdXVybm1lUmtpbTJJSnYvS05Wb3RPYnhZdmF6cWZTUW5tT2VHaHExT0hS?=
 =?utf-8?B?SmJQb2RVSDN0N25xV1I3UEQyWlZVS3NsKzcrMmlrdTRST2dkWTJZVzBseWxr?=
 =?utf-8?B?azBvMTN6cWtPNXlqZ1NDVVVrbVY0ekJES3BSczdCVm1hbFJKRHhSWFZacUxh?=
 =?utf-8?B?SGVFRytWWCtPbDIwa1BWdGNZZjRkL2VCdWIrdDFLeUtNWCtQZjUveENLRDhQ?=
 =?utf-8?B?RFdHbFU3TnhNc3R1VDlGcnQvY3ZGSTB2MHZsU2ROZDNiNkpVSUl6TmpnU1N5?=
 =?utf-8?B?ajJEL3pNc3NjYXg4Nk9maC9rWEV0N0h1SHZTcEh3a0hlcjlMeSswbWY2MFY5?=
 =?utf-8?B?VFU4Z3J0MTM3dHFUUlRDQkdZMWpzeGdqUWlmTlFwSEZ1MEFadzNsTVNsaHMz?=
 =?utf-8?B?OXJyUTh2VzZmUzVHaU1ib0Znc2UzRmJqRElNU0dwcEJuL0o4a1BiQkdIS1lC?=
 =?utf-8?B?eXQwWWY3SWtNQWxmMysrRDk5bHlPMW5tamloSVpYYkRkaG9mcmlYUUtXNkhZ?=
 =?utf-8?B?S0tvelNHazhzaHk5ZXU5MFVUdlFzclp3T2NzUGZxZGFDRGJqUm1JVDZqbm5B?=
 =?utf-8?B?VW5SS0h2N09IRG9jNjRWYjdhM1NNNTkxeXFtejRIeUlrdnVmV01FbnRtTFZK?=
 =?utf-8?B?UVpXYWpkKzlPbmZ5NGZrYnk5Z2FHNERFUUV0V2pVRVhQUG5vWW5UTTE2NE1U?=
 =?utf-8?B?eERVOW1RdzJpdi9JMU96MHE0Q3JHbG1nS3pQS3ZObm9DQVZtc1IvdWZKcnh6?=
 =?utf-8?B?UkhlOU50d3FRdUVMOHRiRzRJU1ZsaTQvS1RBTkNab21kQmNUYmQzMlAxSlVX?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E6F1AEB1EBF60429353A1A9B449E71B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jw0VcJmwvMpnRddMh8Z6sQKlOS6IXD3CH2EultgIRfla4Kz5fd+Tb/PtgSLFXoAX4JtHGnEo9+KAeS7oOQbB/c2/xhG2YzDYebPeFzuJVly6MG7KIbQUFvIWlCi3IB6WPQDrCkU7tEEJHVXNkrXGn9OQzQRFz+ymImCAIPiNpdY13vHLU7KiO5HpE4CIvRpjJVA2zuCo0uCh187oDVcoXAutBlBzaTe3YNZLPtp1yWB6WJq0GZoMPv32nL2aetTdYRWAuQhEQtc4wjsjI/1ZYwB37omOlN1iElqk31eg6k8SloC/ILmXR8aa+c9a9W3VHIvw+2T2wjNIXU9nA4xND7xUyMgMFj03CsCJr3yqWanqorX0SRhfbrI9Uz7CuTqCF3AIPId2wo8YkA6iQ9Z88nagCcXjz82wY/AD6TYY56CuB4Cua9b9C37Vw5WCSCC9448DEVoP2H/bxEudPxad7KymFPI2iljfMJHeFD/8T/D19J7Vv4sl/n15HbtEn+O6Bakref04ASipyhITDzsfmsozFz3MYAHFpTCMYtrvJWTnU2dNOsLPLlWkQ5DJEcSsal+ozfHeHYaf492zfEihGRep8lY8NOS1JPzKghC0jO19Mv01eKWtQ+prnZwqCo5c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afa198c-c9b1-44fd-9219-08dce82e07b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2024 06:45:57.4410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8vhsXw9Z1mP3lMuHLVQqjZgh957kKguuLT+ADjmHurfolO6nGI42FSxzz3Q1uMoU+0lc/b1zAEkoxWjZtQeZkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8221

T24gMDgvMTAvMjAyNCAxOToxMSwgRGFycmljayBKLiBXb25nIHdyb3RlOg0KPiBPbiBUdWUsIE9j
dCAwOCwgMjAyNCBhdCAxMDo1MjowNEFNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4g
RnJvbTogSGFucyBIb2xtYmVyZyA8SGFucy5Ib2xtYmVyZ0B3ZGMuY29tPg0KPj4NCj4+IFRoZXNl
IHRlc3QgY2FzZXMgc3BlY2lmeSBzbWFsbCAtZCBzaXplcyB3aGljaCBjb21iaW5lZCB3aXRoIGEg
cnQgZGV2IG9mDQo+PiB1bnJlc3RyaWN0ZWQgc2l6ZSBhbmQgdGhlIHJ0cm1hcCBmZWF0dXJlIGNh
biBjYXVzZSBta2ZzIHRvIGZhaWwgd2l0aA0KPj4gZXJyb3I6DQo+Pg0KPj4gbWtmcy54ZnM6IGNh
bm5vdCBoYW5kbGUgZXhwYW5zaW9uIG9mIHJlYWx0aW1lIHJtYXAgYnRyZWU7IG5lZWQgPHg+IGZy
ZWUNCj4+IGJsb2NrcywgaGF2ZSA8eT4NCj4+DQo+PiBUaGlzIGlzIGR1ZSB0byB0aGF0IHRoZSAt
ZCBzaXplIGlzIG5vdCBiaWcgZW5vdWdoIHRvIHN1cHBvcnQgdGhlDQo+PiBtZXRhZGF0YSBzcGFj
ZSBhbGxvY2F0aW9uIHJlcXVpcmVkIGZvciB0aGUgcnQgZ3JvdXBzLg0KPj4NCj4+IFN3aXRjaCB0
byB1c2UgX3NjcmF0Y2hfbWtmc19zaXplZCB0aGF0IHNldHMgdXAgdGhlIC1yIHNpemUgcGFyYW1l
dGVyDQo+PiB0byBhdm9pZCB0aGlzLiBJZiAtciBzaXplPXggYW5kIC1kIHNpemU9eCB3ZSB3aWxs
IG5vdCByaXNrIHJ1bm5pbmcNCj4+IG91dCBvZiBzcGFjZSBvbiB0aGUgZGRldiBhcyB0aGUgbWV0
YWRhdGEgc2l6ZSBpcyBqdXN0IGEgZnJhY3Rpb24gb2YNCj4+IHRoZSBydCBkYXRhIHNpemUuDQo+
Pg0KPj4gU2lnbmVkLW9mZi1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29t
Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+PiAt
LS0NCj4+ICB0ZXN0cy94ZnMvMTU3IHwgMTIgKysrKysrKystLS0tDQo+PiAgdGVzdHMveGZzLzU0
NyB8ICA0ICsrKy0NCj4+ICB0ZXN0cy94ZnMvNTQ4IHwgIDIgKy0NCj4+ICAzIGZpbGVzIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBh
L3Rlc3RzL3hmcy8xNTcgYi90ZXN0cy94ZnMvMTU3DQo+PiBpbmRleCA3OWQ0NWFjMmJiMzQuLjli
NWJhZGJhZWIzYyAxMDA3NTUNCj4+IC0tLSBhL3Rlc3RzL3hmcy8xNTcNCj4+ICsrKyBiL3Rlc3Rz
L3hmcy8xNTcNCj4+IEBAIC0zNCwxOCArMzQsMjEgQEAgX3JlcXVpcmVfdGVzdA0KPj4gIF9yZXF1
aXJlX3NjcmF0Y2hfbm9jaGVjaw0KPj4gIF9yZXF1aXJlX2NvbW1hbmQgIiRYRlNfQURNSU5fUFJP
RyIgInhmc19hZG1pbiINCj4+ICANCj4+ICsNCj4+ICAjIENyZWF0ZSBzb21lIGZha2Ugc3BhcnNl
IGZpbGVzIGZvciB0ZXN0aW5nIGV4dGVybmFsIGRldmljZXMgYW5kIHdoYXRub3QNCj4+ICtmc19z
aXplPSQoKDUwMCAqIDEwMjQgKiAxMDI0KSkNCj4+ICsNCj4+ICBmYWtlX2RhdGFmaWxlPSRURVNU
X0RJUi8kc2VxLnNjcmF0Y2guZGF0YQ0KPj4gIHJtIC1mICRmYWtlX2RhdGFmaWxlDQo+PiAtdHJ1
bmNhdGUgLXMgNTAwbSAkZmFrZV9kYXRhZmlsZQ0KPj4gK3RydW5jYXRlIC1zICRmc19zaXplICRm
YWtlX2RhdGFmaWxlDQo+PiAgDQo+PiAgZmFrZV9sb2dmaWxlPSRURVNUX0RJUi8kc2VxLnNjcmF0
Y2gubG9nDQo+PiAgcm0gLWYgJGZha2VfbG9nZmlsZQ0KPj4gLXRydW5jYXRlIC1zIDUwMG0gJGZh
a2VfbG9nZmlsZQ0KPj4gK3RydW5jYXRlIC1zICRmc19zaXplICRmYWtlX2xvZ2ZpbGUNCj4+ICAN
Cj4+ICBmYWtlX3J0ZmlsZT0kVEVTVF9ESVIvJHNlcS5zY3JhdGNoLnJ0DQo+PiAgcm0gLWYgJGZh
a2VfcnRmaWxlDQo+PiAtdHJ1bmNhdGUgLXMgNTAwbSAkZmFrZV9ydGZpbGUNCj4+ICt0cnVuY2F0
ZSAtcyAkZnNfc2l6ZSAkZmFrZV9ydGZpbGUNCj4+ICANCj4+ICAjIFNhdmUgdGhlIG9yaWdpbmFs
IHZhcmlhYmxlcw0KPj4gIG9yaWdfZGRldj0kU0NSQVRDSF9ERVYNCj4+IEBAIC02Myw3ICs2Niw4
IEBAIHNjZW5hcmlvKCkgew0KPj4gIH0NCj4+ICANCj4+ICBjaGVja19sYWJlbCgpIHsNCj4+IC0J
X3NjcmF0Y2hfbWtmcyAtTCBvbGRsYWJlbCA+PiAkc2VxcmVzLmZ1bGwNCj4+ICsJTUtGU19PUFRJ
T05TPSItTCBvbGRsYWJlbCAkTUtGU19PUFRJT05TIiBfc2NyYXRjaF9ta2ZzX3NpemVkICRmc19z
aXplIFwNCj4+ICsJCT4+ICRzZXFyZXMuZnVsbA0KPiANCj4gSSB3YXMgc3VycHJpc2VkIHRoYXQg
dGhpcyB3YXMgbmVjZXNzYXJ5IHVudGlsIEkgcmVtZW1iZXJlZCB0aGF0IHRoaXMNCj4gdGVzdCBj
aGVja3MgdmFyaW91cyAqY29tYmluYXRpb25zKiBvZiBibG9jayBkZXZpY2VzIGFuZCA1MDBNIGZp
bGVzLg0KPiBUaGUgYmxvY2sgZGV2aWNlIGNhbiBiZSBxdWl0ZSBsYXJnZSwgc28gdGhhdCdzIHdo
eSB5b3Ugd2FudA0KPiBfc2NyYXRjaF9ta2ZzX3NpemVkIHRvIGZvcmNlIHRoZSBzaXplIG9mIGJv
dGggc2VjdGlvbnMgdG8gNTAwTS4NCg0KWWVhaCwgZXhhY3RseS4NCg0KPiBIZWgsIG9vcHMuICBN
eSBiYWQsIEkgc2hvdWxkIGhhdmUgY2F1Z2h0IHRoYXQuIDooDQoNClRoaXMgd2FzIGEgdHJpY2t5
IG9uZSwgYnV0IHRoZSBmaXggc3RyYWlnaHQtZm9yd2FyZCA6KQ0KDQpUaGFua3MsDQpIYW5zDQoN
Cg0KPiANCj4+ICAJX3NjcmF0Y2hfeGZzX2RiIC1jIGxhYmVsDQo+PiAgCV9zY3JhdGNoX3hmc19h
ZG1pbiAtTCBuZXdsYWJlbCAiJEAiID4+ICRzZXFyZXMuZnVsbA0KPj4gIAlfc2NyYXRjaF94ZnNf
ZGIgLWMgbGFiZWwNCj4+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMvNTQ3IGIvdGVzdHMveGZzLzU0
Nw0KPj4gaW5kZXggZWFkYTRhYWRjMjdmLi5mZmFjNTQ2YmU0Y2QgMTAwNzU1DQo+PiAtLS0gYS90
ZXN0cy94ZnMvNTQ3DQo+PiArKysgYi90ZXN0cy94ZnMvNTQ3DQo+PiBAQCAtMjQsMTAgKzI0LDEy
IEBAIF9yZXF1aXJlX3hmc19kYl9jb21tYW5kIHBhdGgNCj4+ICBfcmVxdWlyZV90ZXN0X3Byb2dy
YW0gInB1bmNoLWFsdGVybmF0aW5nIg0KPj4gIF9yZXF1aXJlX3hmc19pb19lcnJvcl9pbmplY3Rp
b24gImJtYXBfYWxsb2NfbWlubGVuX2V4dGVudCINCj4+ICANCj4+ICtmc19zaXplPSQoKDUxMiAq
IDEwMjQgKiAxMDI0KSkNCj4+ICsNCj4+ICBmb3IgbnJleHQ2NCBpbiAwIDE7IGRvDQo+PiAgCWVj
aG8gIiogVmVyaWZ5IGV4dGVudCBjb3VudGVyIGZpZWxkcyB3aXRoIG5yZXh0NjQ9JHtucmV4dDY0
fSBvcHRpb24iDQo+PiAgDQo+PiAtCV9zY3JhdGNoX21rZnMgLWkgbnJleHQ2ND0ke25yZXh0NjR9
IC1kIHNpemU9JCgoNTEyICogMTAyNCAqIDEwMjQpKSBcDQo+PiArCU1LRlNfT1BUSU9OUz0iLWkg
bnJleHQ2ND0ke25yZXh0NjR9ICRNS0ZTX09QVElPTlMiIF9zY3JhdGNoX21rZnNfc2l6ZWQgJGZz
X3NpemUgXA0KPj4gIAkJICAgICAgPj4gJHNlcXJlcy5mdWxsDQo+PiAgCV9zY3JhdGNoX21vdW50
ID4+ICRzZXFyZXMuZnVsbA0KPj4gIA0KPj4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy81NDggYi90
ZXN0cy94ZnMvNTQ4DQo+PiBpbmRleCBmMGI1ODU2M2U2NGQuLmFmNzI4ODVhOWM2ZSAxMDA3NTUN
Cj4+IC0tLSBhL3Rlc3RzL3hmcy81NDgNCj4+ICsrKyBiL3Rlc3RzL3hmcy81NDgNCj4+IEBAIC0y
NCw3ICsyNCw3IEBAIF9yZXF1aXJlX3hmc19kYl9jb21tYW5kIHBhdGgNCj4+ICBfcmVxdWlyZV90
ZXN0X3Byb2dyYW0gInB1bmNoLWFsdGVybmF0aW5nIg0KPj4gIF9yZXF1aXJlX3hmc19pb19lcnJv
cl9pbmplY3Rpb24gImJtYXBfYWxsb2NfbWlubGVuX2V4dGVudCINCj4+ICANCj4+IC1fc2NyYXRj
aF9ta2ZzIC1kIHNpemU9JCgoNTEyICogMTAyNCAqIDEwMjQpKSA+PiAkc2VxcmVzLmZ1bGwNCj4+
ICtfc2NyYXRjaF9ta2ZzX3NpemVkICQoKDUxMiAqIDEwMjQgKiAxMDI0KSkgPj4gJHNlcXJlcy5m
dWxsDQo+IA0KPiBUaGVzZSBvdGhlciB0d28gYXJlIHByZXR0eSBzZWxmIGV2aWRlbnQgc28NCj4g
UmV2aWV3ZWQtYnk6IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+IA0KPiAt
LUQNCj4gDQo+PiAgX3NjcmF0Y2hfbW91bnQgPj4gJHNlcXJlcy5mdWxsDQo+PiAgDQo+PiAgYnNp
emU9JChfZ2V0X2ZpbGVfYmxvY2tfc2l6ZSAkU0NSQVRDSF9NTlQpDQo+PiAtLSANCj4+IDIuMzQu
MQ0KPj4NCj4gDQoNCg==
