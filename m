Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB833CE494
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 07:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942877; cv=fail; b=aaOVnV1+Zyr1CY65E1dF6mSw2l26bf4vzqx3prylNShkAxA/RzIVG60F/DBX7TX+Exdvv4KGrRCt5HdMC0FEY2KqanPfS0txEO6YMy2JjCfISKzW4bxbNBdIxxu8raV/YE6pO6YaS4DVtjcAz/yRGK2ACBpmh/Vy7rMv/qe/mo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942877; c=relaxed/simple;
	bh=voIgcW/T7gUHulaVD5w4hbk0wAeTJbQqKlmv3lajupw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VmXuxo7X5OJ/0W3AOKXTzUp7sLi2SWbyVjRHu6vtM+VkcS8cMxVtdWdvpUlkVP6q6tbLCL9Y4h1dvXRpSPo8kzecGhJJwooZCUxtQ3+vmYidPLPS/4vVApcqbo+meZfGopBcw2kJ5K3aoHMt9P9tK9J8CcxfBDNoOcDuXxvzcDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=baqC5apR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YYU1MPmK; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="baqC5apR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YYU1MPmK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774942873; x=1806478873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=voIgcW/T7gUHulaVD5w4hbk0wAeTJbQqKlmv3lajupw=;
  b=baqC5apRk9MRukbmH9qZGSwRwRv4T55lGRLyE+j7k2G9OJTZxZ1e2obH
   EMWp1Fk1uaSyDM2lr8E0272Fc1edSL+eVEnLrFHpZVk4+QyUkHCwjWadg
   Y4tMX1pycd4w6SkDQ+2nXIKVWpVQooF9sMvVV1ATAf000OXMloNhUhxNE
   kcm2w+wD4BDSHnFDI7cX4+tRmrEgotdoChQUwO16r/lKjodDGro9bbj/z
   +IChcfnSj/XizYfBYLChyyBe/p3cKO7PU99HRZ/OQiYjn+RrPR6AAl0qa
   67uyMRgmtv0yW80fficNwFDZVP8JjB8OuQ2PlDvt8LGCtTo+uTLSMWXPQ
   w==;
X-CSE-ConnectionGUID: RgF0OnqjTLK80TtlbPsh7w==
X-CSE-MsgGUID: tFiyJp0FRQeZ/bt3xz0/kg==
X-IronPort-AV: E=Sophos;i="6.23,151,1770566400"; 
   d="scan'208";a="143584429"
Received: from mail-centralusazon11011009.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.9])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Mar 2026 15:41:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ij7dcQDKBtqO4MbgE1DPqSt2in5SQNMEuTU7Q2Jijzz7LIMyEMzBBg+xv14o3Np1+/zg5/l/xbD3TtX0quQiHK7rv0TkThf9/M98Ou9I5JNwDpe7uX91parb9lAufZwsEaFdiuVKmnt61WXh3IKxYFU9bf9cCY2sEQv1W4nxBYfUYzIoE9Ai4JuauHL4+hiI2oUxs1NnKBPZhPznFPaNYL2bKoFWi2tDc/jd2RCxiqWVktoEa1nOcR2Mq7JNwmWcd8m6SUPiv2t367rP/ubx4aZl76gcPQ3vebS8AYbGB2w8HJioJVORJce7sOPIghNdPHKknBeXtb9W4lDWftFJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voIgcW/T7gUHulaVD5w4hbk0wAeTJbQqKlmv3lajupw=;
 b=KDfDFWsv3BK2o4g1OUC0joWrMFIeLDo5SrektAgiJFWZrJajz0GHS7d8VkG4ciFE5GYr3LdgJf7zqsXg0Rr5AhwbQtJZJXwneLX2jRrJqdMvKXwIzUuwMNcMtfQWB9vKVjqr9kGBNUADxGOxsgwzD2LPv1uthEWOOlMck/sgG8sbk7t7OYLo3Cerp/nztL3EpBuKVOOdXXkqbKdLkaMwY6lnS+AZT0qjWDfjcc7WRentWdDJPztwx75tWZH2yCRrEeZB1q+nbhKC1CoUjrc5WarRayu3axV+6BDq8YxgaIGAbtpq7Oy1p41jCHAqfH2YHlxMgNPlsU9wggl4qIOPIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voIgcW/T7gUHulaVD5w4hbk0wAeTJbQqKlmv3lajupw=;
 b=YYU1MPmKy2GHmwPdchdCcZ7frEPX7Il1q1Na33dTumGE7cyYDthA2VmFN2lge00Z/duhHeDeiyxG4fIjwKHCZ6KMOiSAxnDjuP2GVwD6jz8ImPbtD+d8btlqzQ1hBQGi3yBYb7i1Uo39AGIJVg1PqVdcJm/T0yubr2xneepcjXA=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CH4PR04MB9481.namprd04.prod.outlook.com (2603:10b6:610:242::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 07:41:12 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 07:41:12 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Thread-Topic: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Thread-Index: AQHcwAfgEus2AFEwpkCKgC1EaeKAXLXIQ24A
Date: Tue, 31 Mar 2026 07:41:12 +0000
Message-ID: <649c5ca2-64df-4d79-b756-397ce602771a@wdc.com>
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-5-hch@lst.de>
In-Reply-To: <20260330054111.3855818-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CH4PR04MB9481:EE_
x-ms-office365-filtering-correlation-id: 54277d45-266b-499d-4caa-08de8ef8e1f1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|19092799006|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info:
 GtX3FYh7A4rMCrxVzkcSz5qVgEuSTz96RRzZtZXNIuqsVfZkcsq4oOMo/16mTqxEeJ16tsDuQP9j8E8xhQ/nm3RDcVVJYSp7WhGCCPFaLjOxZ02q77nbQqzVrh33Uk8vUTkHRIgBiVTWe2RGwM4Qi50DRtBLrMKA2lb0YoWKpPq8ZDs5+x+wL9We5Pu1Hg7v970ajy9Qq1TE6jSqx9RmJutMwTmsgM7BvFDdBJwNr7i/TWZCtWr82hFqYsM4BwwoZlHm6HStE3BOZSqZV1S9zhHgSUTc6kvpMs8kSs3BicialxksLVlDThaQAZzTgNnl+Ap7DrQRHWj+CTwZwgaurt9OuWkzxmqBCZL0SdVg1wtOIfYxEUnM+UnIQ7cFAQTL4emMHCLRn5yf6W/zD2Gw2qI6uPDCdQ82J8XFt/fK/sm3McMnJk0wVIgGP1QrFyykWMfpa2BMlWJZE5OabXwPJ/d7PEwh7jVpBhDVuPUSQAilR6GrgqfgoME+/or7RYDSrWV8tZdh85zyJrC476ons2LSVZkw1tSLcZwjs0bjmdYqRuR4cv44szL8jC4AVPcybh1UXTDlrcdlqTPHdXnlQqFrAbJJuY0CZtQo5ndikPHNvX8udL7jzBpTTpU4sViFqe3TzOQFd1GHbki6kZu/OEMUTXCjvw17w9i72rM9LFk21OgL2Cd7NoP/MEsSc8Ov0jZA2h2FeTS56t+Pdy4zJfSIso5lzkmhhLJkiU3phbZRgIkWOA2x1cxDrwMiyJ/LpWISp2RO1ZmgeyGs/UyHPv/2MEApe2j4sdnAN/l5C2o=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(19092799006)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a2ZOcFFIbVlIcFdBekxpbVFNL0FCUW5OTDJ0OFdZSXhrUTJiK0Z3ZGFGNDA5?=
 =?utf-8?B?a3dnbjVmVFl0RkhFMjNXelNvNDdVRjBrQkladlJ2T01sbFhuMGlyYUMwcG52?=
 =?utf-8?B?a2wvb2xlcDgydFVUVGRnV2dmMlpLTHBST0k1NFBhZENJaTVqblBiZ1dEb2Zv?=
 =?utf-8?B?bi95UFdXaHFpMVJMclFrdGN1bUUvbU5IcWQ5anF1MmNXTjIyUExCdy9DdThJ?=
 =?utf-8?B?OFkwZ3plSHFSVVhHU2VTZ3NCL0dWSkJxaTJMd2YreHZPbW5XVUNnQllwNENz?=
 =?utf-8?B?Yk5OMzQvUFliZU8wNUtRT2tDMVBWRWh6K1VNRjZFMW0rbE5DbENySmpnbmdx?=
 =?utf-8?B?eHRleDN2SzBPbXB6NnJ6d2ZVbTdWUjdWakYySHZYUXhtZEIxYTNsdDhWTDBU?=
 =?utf-8?B?T3pmL2FsQUdhZ2hNMXd5V3Z1NWs2TVFvSHY4RWFidEFCWGNOWmF5Wnd6bkpK?=
 =?utf-8?B?YzNscHd6dmw2cHp2ZXlIb01xVUhXWUFuajVUcVQ0L1pqK29LT05ESFRua1RG?=
 =?utf-8?B?U2hmNE5EYkdoUzJzdm1vYnFyYTZXOTJmQ2ZtR3RsZ0RXUmhhczhPVUxRM1Nk?=
 =?utf-8?B?VTBFQk1zRGJvNDA1TUZtQlFhRGVMdFNrODk4cWJIZjZVOWVwMStYVWpHVC9T?=
 =?utf-8?B?SjZxdFdTeWlNOFQyMVNQamUyNVZIWUh4RHFtS3ZXZlVJeWJOajFWeTVjS0dr?=
 =?utf-8?B?eGVNekNKMDQxUG1IemczdUkyZ25SUllNWWVSazgycy84UnNvM0c0Mkd0RWt6?=
 =?utf-8?B?UzNYVlZLOFlkaTdGaGVDTmxuZU53NDBjSE1KczVIMnQ5VnYyeVVpcXpIQzR5?=
 =?utf-8?B?RkFOMU9pMVdwMEliNzRoMVJVbjRhT0p2RVNNM1RZY3FKSDJkWVJYMWpaRFpj?=
 =?utf-8?B?NlZTbG94MUdyamJvTGhrSDZZMFl5ek1rNVVHNXYyc1JoYmFzSUZUODJNQS9r?=
 =?utf-8?B?dWRlZ255L29iRGhUK255a0REQWp2eHEzZVJXZ3d2c1c4b3hQWmdUVkRlb0k0?=
 =?utf-8?B?NHhBTGlHcUIwYXZrdUZYWCtVdUJodjRUazRzdWV6WDlpenA3NW5vQzZvODVP?=
 =?utf-8?B?RzZaczNkdjRXSFJyblR1YloyUVhuMlV6a0xIeTNiaFVsY1IvUHNGYkQ1NVJE?=
 =?utf-8?B?cWFiWUlmbkRnS3h3TERKWUpzU29jMDVYN3pLd3hRZXFkT2E0N0dBcGJVVERF?=
 =?utf-8?B?UHVsRkhVelBGcGVvODNvc01Ga0pFVW5Uc05RQ1hCY1lsRFhhRCsyMlA1aVNq?=
 =?utf-8?B?blFRclRzNjZvT3VZa1UyY3hkRHA3aDVNbDdGc2s0emQ3N01QN0VHbWFUUzc3?=
 =?utf-8?B?WCtRcHM1NVBJaDZoVkVNRUNSSE5rM1Vodi9qdjJMbkFRcGsxck9iVncwM3Rk?=
 =?utf-8?B?cXFYSldHWjZFS1NkOXhJMFNJT3JUL1NPUm8yczFyL0V4TEYvM0gvdng5bXJP?=
 =?utf-8?B?VkdNbVUydDVOMDFDSmc2T29scDhmT3p6V25tL0N1czRheEIxK2FBMTRiS2V2?=
 =?utf-8?B?eHBVbFVoeWRqb1R0K1dsZTYyMFpOZDFlY0psMzMyTTRsNTRRbUdqbjRJbEd2?=
 =?utf-8?B?eUFzUGc0RmxhSWJkRnBnWW1zWS9ZRXVHTTdoRS9zOGVNbWhMQnY0ZlU3TWZQ?=
 =?utf-8?B?bDNGcmlMTlg1Y3F5cWNsaWZOYUxiRGJPZHh6UTJBZFdSQ0ZFZVhTaHplVHlT?=
 =?utf-8?B?UWQzUEo4WmpBODZCTWxGLzdTUWpDKzdnam9NdmgzQnNjMElERG9MUFUrTEZY?=
 =?utf-8?B?VXdYRHRDYTdtR3QrUjlJMzJqNVJ1VzdoSkxaellzWUp5aisxdU1qSWZVZ2gx?=
 =?utf-8?B?bmJnWXhTcTdiR0cwa3B4b2Fnd2R6TlNYTTF1VHIvSmtZZUdBSXYxczJOdGtl?=
 =?utf-8?B?V21oVWpiVGJhSzNER01zdzFwWVNSSng4dG80U3JoZEpzdGk0S3MvaVBKQmFG?=
 =?utf-8?B?eUhWVTNYNFV0WUlsQko2T21XdGV0VU5EN3RCUmIvTWdDT3A2dnNocytGNHdM?=
 =?utf-8?B?UWtpU3J5amdmZ2RIZWJpYjlScXJiYnVZSWQ3N0FEM3lBRDZrWE1PTGNSR0Iz?=
 =?utf-8?B?OVRpUE42bE05QnpFdEtCWTRwY3JTU3BDRG9jQjJNeXh2MGhFOHBZa1JDUnZZ?=
 =?utf-8?B?RXkvemNDTHVRbmFqNHhJS1lydjV3VlBJMHArL3hLa0Mwa0pSVWZBOFVGS3U5?=
 =?utf-8?B?SGpRbHRGT2RINGFNd1ZDekhLRmQzQ1piWnBWOEVIenloYmJXZkRjTFN5cTdj?=
 =?utf-8?B?ejR6RGNsSE5aSmE0anlNZWRnTFJ6TjFSOFlqaTlBSnllRml3QXdwbyt2ZjhZ?=
 =?utf-8?B?VnZGNHVXR2xCcEo5blo0S1dxVFIxNndmN0o2a3JhWFN2N21GUS80dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6CC98D2ED37E44080E59C12B83C78C3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	if3/5o9vwy+0rS2osB/5Mpw39K8AG/7X4J7S50iW4veUjZ8nDUAdlQF21Yrj45FPGMldP3KlF/qmZsGmKrn7eVSrt/4BzBZ7rADCY/zB/YqnfEGwKJBz7bZDhrbz43iPKFX1Ow05t/EzUgyoTPlQ7y9kykDz1SoRWE2kBy9kk1i+jJHFujFEgym8C1tsWSvWI54vyCAeT/JCtUvSirpVr0hJPpDlFuSVFefC0ph9jD/gnW5kxdUMNI+jN8kvKvSeIP2ESVUnXC4Dy/T2BtIWo3o//K8cRRbc1PsYlq4ynpBfKih9fx1cyLhubc1qeDfm26U8C47mUIxMORTIchTF5A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TRzajKmGF9jZ1H0XdXuofFelgHzwku/c7T/uzVFXuuB9QbTWnuvBmLJHnYKwGDRI0BcTLGPHl6eKf1m8I19O3sMA9U6SSsZKyfgA0irNcZvhvHJ2hteFMZhC4NQsiqAwsK8Y8bw8eyt9VXAU3FJrk3RcI/1RVB2ASGrWtzOe7iRaw9AZHXVQ/zj2ac/f7UX8sB1kgvTaiZ0kiyQ/MTZhEpQ3ryJf1OnmMPLoggGDhTq1QHWAAftHD89nze3+pvAHWU4oh3JV5ZmXuCnBgcCUYqfhdhaDJ30gLeGCc97drCrVPECF/iCijZafWHNnImtSUWTEZT8NEPSqP93R1liMJoK7vmHjXjOA0zoVym+M9KT3vTRPPqNXK4L0JykI7MzluIydGVIYN33Z4I6azByEmFA3wT9Ydsz3xwNf+3ZqYtqPjDDAMuvCG5Rvd6oGO6Bee4VCCW91CpAHrI2e15uLumlTs97Is+KdXO+xFAZgstFDUFs93OhGQEGuIDnFXn6oWgDsGAIe5gARxsLi1YMpa0rvThKLZhSrx/jBElwBGdAv29TbrnPRlcYbEgKbNjj1WCyL+MEJTzzDuykIdfP0DhpVRT7rAkSNZjg4fIeYgY3aqTLQgCBWW2opQGXS6KhZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54277d45-266b-499d-4caa-08de8ef8e1f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 07:41:12.6753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vOrZseiiG+3xdfSbMQGjkCFYyHwC2N9zTdwnsTwRpXV2HiDBz2s1fY7CEp1z17+WRZYdBiH/MEE+kTSOEAEplg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9481

T24gMzAvMDMvMjAyNiAwNzo0MSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEtlZXBpbmcg
YSB2YWx1ZSBwZXIgbGluZSBtYWtlcyBwYXJzaW5nIG11Y2ggZWFzaWVyLCBzbyBtb3ZlIHRoZSBt
YXhpbXVtDQo+IG51bWJlciBvZiBvcGVuIHpvbmVzIGludG8gYSBzZXBhcmF0ZSBsaW5lLCBhbmQg
YWxzbyBhZGQgYSBuZXcgbGluZSBmb3INCj4gdGhlIGN1cnJlbnRseSBvcGVuIG51bWJlciBvZiBv
cGVuIEdDIHpvbmVzLiAgV2hpbGUgdGhhdCBoYXMgdG8gYmUgZWl0aGVyDQo+IDAgb3IgMSBjdXJy
ZW50bHkgaGF2aW5nIGEgdmFsdWUgZnV0dXJlLXByb29mcyB0aGUgaW50ZXJmYWNlIGZvciBhZGRp
bmcNCj4gbW9yZSBvcGVuIEdDIHpvbmVzIGlmIG5lZWRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9u
ZV9pbmZvLmMgfCA4ICsrKysrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9pbmZv
LmMgYi9mcy94ZnMveGZzX3pvbmVfaW5mby5jDQo+IGluZGV4IGEyYWY0NDAxMTY1NC4uOGU1NjE4
MTAyMWIzIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVfaW5mby5jDQo+ICsrKyBiL2Zz
L3hmcy94ZnNfem9uZV9pbmZvLmMNCj4gQEAgLTk1LDggKzk1LDEyIEBAIHhmc196b25lZF9zaG93
X3N0YXRzKA0KPiAgCXNlcV9wcmludGYobSwgIlx0ZnJlZSB6b25lczogJWRcbiIsIGF0b21pY19y
ZWFkKCZ6aS0+emlfbnJfZnJlZV96b25lcykpOw0KPiAgDQo+ICAJc3Bpbl9sb2NrKCZ6aS0+emlf
b3Blbl96b25lc19sb2NrKTsNCj4gLQlzZXFfcHJpbnRmKG0sICJcdG51bWJlciBvZiBvcGVuIHpv
bmVzOiAldSAvICV1XG4iLA0KPiAtCQl6aS0+emlfbnJfb3Blbl96b25lcywgbXAtPm1fbWF4X29w
ZW5fem9uZXMpOw0KPiArCXNlcV9wcmludGYobSwgIlx0bWF4IG9wZW4gem9uZXM6ICV1XG4iLA0K
PiArCQltcC0+bV9tYXhfb3Blbl96b25lcyk7DQo+ICsJc2VxX3ByaW50ZihtLCAiXHRuciBvcGVu
IHpvbmVzOiAldVxuIiwNCj4gKwkJemktPnppX25yX29wZW5fem9uZXMpOw0KPiArCXNlcV9wcmlu
dGYobSwgIlx0bnIgb3BlbiBHQyB6b25lczogJXVcbiIsDQo+ICsJCXppLT56aV9ucl9vcGVuX2dj
X3pvbmVzKTsNCj4gIAlzZXFfcHV0cyhtLCAiXHRvcGVuIHpvbmVzOlxuIik7DQo+ICAJbGlzdF9m
b3JfZWFjaF9lbnRyeShveiwgJnppLT56aV9vcGVuX3pvbmVzLCBvel9lbnRyeSkNCj4gIAkJeGZz
X3Nob3dfb3Blbl96b25lKG0sIG96KTsNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEhh
bnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
