Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C52221F12;
	Fri, 19 Dec 2025 07:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130537; cv=fail; b=LDGWNu1f0m3z4TmnwXqLyWhJnCPDWeypxm9jTyF1g7g29agewpM2OMcAGaina6dW2nES26hsA833nBf3bebFdvFdnAk89QcclAqEM2Ke7fjK8k07xzfjczfLBgs3FE5T/z1q3BkGnPOdzdsaYwI6kz9LYBRZCpPmoSB0bZKabhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130537; c=relaxed/simple;
	bh=gyYmyavCCHqNzHx+j8OflN6O1XZepXkrHGB0CNcrJnk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OH8PXVEXE6hKcyHTEZt2yyBvtOCGq47HU8eqmdSEyLFpnqf+ph/t/blSZsxtWF3odGhIWSmPV/M06X7ypJ6tigVt9A9zpcsTANcp2VpXCX5UqgHv/APQ0pL15lS6VrWj8ecbs386TlfCgZdwQIE6grb41qxJSAD4Ti98tPJtZfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MvQBM/Li; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fwJ0LCoe; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MvQBM/Li";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fwJ0LCoe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1766130536; x=1797666536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gyYmyavCCHqNzHx+j8OflN6O1XZepXkrHGB0CNcrJnk=;
  b=MvQBM/Li1EdC6ApVz/sC0aIqKJCtwkHiAaBOcplLNEDqPXiSwooUFRtO
   VEuXamWKZDFgKBjMIbzhlVbkgCP+pgjWcXONMeUf3DQa64lxluhhqyABD
   iEyi2Fwd2KqtOcn+fMCKWHz551838gK3w5t7SHqxts6KcU+qA8KEkzXaJ
   a4FmuoLAwPdDt9lTFRyEJjhXJCgLN+4SLPEK2V6y1aU+08cv2+mpq+Leg
   mYOnvasMbsMo2iqx6xp9vPK57EZ12Dfn8UXPFGa/LpAhsohotMGCP3gpr
   mYFo6texyJn3wYdAdyuoFUOac3U/2DojeoifwxGvSnbvGpJOxgWaWCrKC
   w==;
X-CSE-ConnectionGUID: 6KIxy0MaS0iipzWGypkazA==
X-CSE-MsgGUID: 3hlf+aHBQz+3m79Junvw2g==
X-IronPort-AV: E=Sophos;i="6.21,159,1763395200"; 
   d="scan'208";a="134170061"
Received: from mail-westusazon11010004.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.4])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2025 15:48:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehn06tX0MtsnZGGPeeAiigFgOzEhcKJfpR8GqhgaNQVAI84ULuoJxQMHcr8Fkx8JFUG/VdDGti+EaKLV2FNCKb/+aA6FApvBMokkjoeQqLZNmibssgoX+h5e7+bgLP9TkiD3N8+OAi7sM7O2pC+YDwlTMBxcx8m5i+fspukukGPbmSpavoet+lTrtahCuKXd0XNj+rKXBbE3cQyo56RoKiqg9sRErBQOkJFZo8C65YBRcQHXm9UUOYbxSc/x0Nka5Ur2DtmYBq92K4XM69c4C3UTsKHyFxEpaJBj2HY7RW0Hhp60h4QUEPgLKD5S4UpgaQR1FVx+lB3TTav2gg7DBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyYmyavCCHqNzHx+j8OflN6O1XZepXkrHGB0CNcrJnk=;
 b=GLSffk0XYiniK9IHcigFzQCQJHpRdKUr94l3RFsr7wTQ9nH/q2QxjU+sXMDw7NEVOuTufgEYKH7SA/mMBNbmm8gc68YGIo2AGvqJIWmo1mgB1CX1Rs6/i4GEzvutSfvUdzbzn6PgETtb6OPKSBC0qiXedOVXonxuAZp9sqMoAR/R6CQfWG3z3+dZC1y/Nwl16AthhKPTshNRMP00tyIsGKR6BMqSbESzSz2bkMivV9d9/1cPy//mPw1fQIk6Wl6qytTWUDoe/0l2ss1/J4o7fGbroMbBysNJDVIDvVa5CsgmR9ivKbOdxGofeXu+NPgifau5FhlmWgstLgwFW7D+iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyYmyavCCHqNzHx+j8OflN6O1XZepXkrHGB0CNcrJnk=;
 b=fwJ0LCoe5zh3BOrTD9onIO8pCcjnTwow1QEqINAv9A0EWdNVF0aHnGf9zA/rVo1YvwtCseVofu5mrK/IhQfltui0AE6DGIY65ja15Voc5oE4H0rzshXFUkb+oJkk2Qfls+OUTfgC+ahGhRhnFPNtNl4ZmMCjxxP0ogfDBO+t5w0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6931.namprd04.prod.outlook.com (2603:10b6:a03:22d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 07:48:53 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 07:48:53 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Carlos Maiolino
	<cem@kernel.org>
CC: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Thread-Topic: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Thread-Index: AQHcb+ghNJ2Izkvuz0mAAPDdV228V7UomAUA
Date: Fri, 19 Dec 2025 07:48:53 +0000
Message-ID: <f82d088b-7bca-48b2-b28e-3a134fe0e904@wdc.com>
References: <20251218063234.1539374-1-hch@lst.de>
 <20251218063234.1539374-3-hch@lst.de>
In-Reply-To: <20251218063234.1539374-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6931:EE_
x-ms-office365-filtering-correlation-id: 99480528-4ebd-4a71-45f1-08de3ed30e3a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?RWl1RTZQbjJrNjhPUWoxQUtOakE2aGxJRGx5Q2dkOVR1NTR3dzluOFc3REFs?=
 =?utf-8?B?RHJNeVRadEV5cVNDeGhXNm1vZktDNEdWVllVN0Fub1VYUGNoeEp5WEYxK2lO?=
 =?utf-8?B?MmFCa05La3RrUkoxMkRhM01wTDgyWkNWTjh4WUVZTE13NCsrVTdxdGttTDFS?=
 =?utf-8?B?Y3d3aU9qYmtGRVJ3NEs1Uko2RGpFeUcvM2YzL0ROcVd0WVFVRnd4emNLNm1M?=
 =?utf-8?B?MTFnblZwU1JCQVF3WVlZR2pRV3cxbmltMzh2N1hGS1p1Y3R2ck9mUHVPYy9m?=
 =?utf-8?B?TUFxTkRYU3ZzU0pBL3ZJNmdZNTlqWURTekprSmxOaVNBcjljQm1qeU5EVlhX?=
 =?utf-8?B?ZE9XengwMlN3akFWZXpmemFiTURhYys0Nkx3YTlSdm8rcStjZEhlelBqT3B6?=
 =?utf-8?B?c3lFd1pOcmNiYUFDaFAvcnFiQms5YVJaUVBxR3YwKzcyaVpMaXRrR0w0TVhC?=
 =?utf-8?B?UllRVkJxSlAvUkU1M0dDejlQSURzZjhodlFsenhVNDV2eEJETzNrRk9vem1q?=
 =?utf-8?B?MGw1ekVwbElOQ1dOaFowanR1M1JiMGVlOFkxNDNsZDlXaGJSR0UzajBndUxY?=
 =?utf-8?B?NkoxNi9sdFhGOEttQk9yL1FhN1NyZ3djcGVtVTdKUEZPV0pRcStEbXBKVkpV?=
 =?utf-8?B?SHF5eGtTVXJuU1Qra1lRMkdZSTFCdlF5d1M5VXBEQkp4RFJ0ZXp5K3dxREE1?=
 =?utf-8?B?ZVNSNWdQcXBUU080aFhlSDdnV1hxRWpUZnRhOWVnelJ3MGJWYU5FSnpVcTl2?=
 =?utf-8?B?U0ZpaURHOTUxWVZZQXBjamJ6R0JRZTdzWThhNG9CL0dVN242N21xelI3WHNR?=
 =?utf-8?B?VXNpVERhc3RuSW45MlZpYVpGTG8zQ3oyaGZJRVM1ZHE1TzJpZ2dtN05WMTAy?=
 =?utf-8?B?QzVWN0s2Z3h2SXV3M1IvcGRWYTBYR0dtL2k4ZHl0UHRXaHBmVkhiRjRySFd5?=
 =?utf-8?B?QnNFYlhaOGllZ0RGblphcE5CK1M3R3BHOGZlMGxaOVk3K3hIRlVQdm1ObU9B?=
 =?utf-8?B?TEQvQlI5VzMySHYyaVhiZVg4OUJPNVNrdkV2OHZldDV5VnA4cTF0VFhBTWFN?=
 =?utf-8?B?TGk0ZUkzTjgyWFcrVVlJR3dESVVQRXd5MjM1UnFPYXBrMzg5TXpxL0RtRzBq?=
 =?utf-8?B?Zm9DM0tGNHl4ODRVWGVLN2dCRWY1WVV1ZlplY3BycDAxZHp5WGEwYkdKZFhJ?=
 =?utf-8?B?ZWR1WlNyOTdRVEpVbFlmUi9OaWs3WVUxSE1LYkxIWGszaFdLZWkxcHp4M01F?=
 =?utf-8?B?MW9pWnUrSG1XT1JSYkhYZFlCZ0ZYTWFrank5TXRtQ0NSNWRjbE83ZkNBcjJE?=
 =?utf-8?B?RGZTWGJGd09zaUl4RnhKeFRSakRNY2M5Wmw2VUVCaWU1SVc0aEYxRGpJUThl?=
 =?utf-8?B?Qlg0OXJ1WnR3STR4Z0dHNWpsM0V0cElSSXI3UExMKzdnVzNEUUtTMmVMeDlr?=
 =?utf-8?B?WkhabGg5R2VjbUV6M0JudkVhVER1RzVvWnBZVjdlQXMrcTJCdmYxTlVSTXln?=
 =?utf-8?B?MnppUDR3YjdpcGlvZGVMTFNDbWpmMmVBTWx5ajhORWtaL2lZRzZ3ZjVnb003?=
 =?utf-8?B?alNoRkVaWjVZSTlPM3NhN1BRTTZ0N0kvMHVmaHBScnpINTNZYitIa1pnQ1A2?=
 =?utf-8?B?cEFRckt2YkxWUU15bVk1T1pjc0dCNlpPV05tY3Rwayt2TEZlSVAwQ1pXS0E4?=
 =?utf-8?B?dVZTVDZtRWZRSnBaNnZTS2RtYUtXZFp2Skgza0lFOHJRRFNZTUk2M0w2SGg2?=
 =?utf-8?B?QjRhbVJzTkgvdXVsaDhqL3pjVHZTT2FNNE1iK1NvK0Uvb0hLUHVsTDg3QUhK?=
 =?utf-8?B?Z2VEdG8xRXMzNUg4TE9vSk5CYlBqVVNtSVozYnlKRHN0cjZHbFFvUW1Cc2JS?=
 =?utf-8?B?dWVSWWtTUExRdUZIKzJNZkxDcFNsWVJsQ3pTZHJNY3BnanhMb1VVL0hSb283?=
 =?utf-8?B?UjdsQUJCSFhqdktjL3JOanBLdUhtWnpSeFdaQ2cxYi9EUStBUXNXRHJqOU1M?=
 =?utf-8?B?ZFhHc2lrYmxhVlduc0J3M1g0ZFlVY1NVSHpaT1VtaEVMWFozRjZiZCt1VjBi?=
 =?utf-8?Q?3Wi/Jd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NU5zYXRxNkZSa0hBUjM3SGZBYTJlc0VnRGhTRUJrVHRsaldQNGRSNkFBOUpk?=
 =?utf-8?B?QlhJN2tEY0pNNmNTQ3dFVXZNeFdTMXd5dHdHUkpzcWVybS9JRGsxbERLT0JH?=
 =?utf-8?B?clZ0OU93emJpS0Z0U1c4LzdneWNpWTFzZm1uYm55NXc0ZloxWVkvQy84V0dt?=
 =?utf-8?B?K1Y1RG0ydzd5Q0x0Z2orTWhLRFBjK1dtYzVBYzRjbzZsZXdXc2p4MWFFNm9C?=
 =?utf-8?B?SUNLazgxRFpianVjWTRiYmk1V1pkbmthRHRRTzZOQW83K0kyWUFibHlHWGNj?=
 =?utf-8?B?Mkg2Yzc0UHdXa3c0SmpqLzltRDhFbnNzOTRZOHo0UXVkcFdqTE9xK21EMDdG?=
 =?utf-8?B?QzVTb1o1bDdFNDB0QVMzcWZac1dHbVplMzNhRVVtSlpFYzlCMnQrWmxkeWN3?=
 =?utf-8?B?a0c2NHEzaWRUMVJNZVZFbCt1Rkx3QnZvVlBvdnE1YXpVc2s5elorVUtkRWIr?=
 =?utf-8?B?Y0xTc0ZsOVNGNElNMEZ6TENWYm9UTGRlK1hsMGhDdnNxanFway81aE1Sa0V3?=
 =?utf-8?B?SGdtUnY5ZXZ4SGtPZGN0Mjg0SENrYjJFYko2ME1SMjBnT09POWYySFVvTngv?=
 =?utf-8?B?eU4wYzA4V1IydWk0R0V1ZTlWMHNWUmxEUjJqcjVuMzdLRDJpdXpxNFZ6WS9j?=
 =?utf-8?B?MXhVeWtueE1uWTdBc0tadGdRdUJnaDBLZ3hneXg5UXNaWHZGc1NPWEZBclkx?=
 =?utf-8?B?QjJ4SVNYYWduZ29wd3JjSFMwdnF3V1dkNkNLTEpDTm5Cc0ViYklzTVNLb3Vs?=
 =?utf-8?B?eE5hRitrZkhWUDhncDRNcjIzYkh1dTU1Q08vMUdzRmRLMjRZQVg2RTBvbnZP?=
 =?utf-8?B?em5pMlN5dUdxNitJcGNCMksrWnYvVXFMQTdZUWRzZmhUSWlSZXNQSEFoMHNO?=
 =?utf-8?B?cUYzZmRQTjdVZUw2OHhMSEk4TGhnY1hCMkRmWXY3cG1QT2RNVDRRYUZwUTY2?=
 =?utf-8?B?bmNlVjBNVEgvWm5XSXVwUmxvVjNnVGlmMHc2N1ZXOE9WVk5vS3R0S2ZGVUdl?=
 =?utf-8?B?am9yMXZ5aC9Jb3ppYnl5WlZIczlvRlhSampIbDJTRFlSTkNNdzVwZGZ5eEhm?=
 =?utf-8?B?UGQzMk80MnNjeE02MGpmajI2UUJENXlzT2ROaU9lL1Z0czZ0NFpVeFk5Wmla?=
 =?utf-8?B?Z2g3Uy9CeitnM0FMaWtkd21nTlc4RU1iQkxHUnp2dWEzTmtwZTYvOE0xRkxP?=
 =?utf-8?B?T2ZVMjFWcnlvU09MdCt5dG1VY1V5SWJDeHEvRkpKOFhJdnB4RjZXMU8zVm9x?=
 =?utf-8?B?Z09zTzBRYzJ2SE03Tk13dWNWZHpBYjNoRVZ1RFdvUkVKSC9hYmhrSVRKdXJv?=
 =?utf-8?B?YTVhbXRhRVFmZldYWEpvY0tYd1RzNzBmYkgwRUpEaXUyeTQxUklDLzNkR2lh?=
 =?utf-8?B?VWpRd0VOU09FaTB6MFpPUzAxSXNEMGRMNjlKc0grSEZjcVMwU2E2czd5SVQ3?=
 =?utf-8?B?SnNHUU5ZY3Y2dnRQREVQYkJXcWR3UXdyTk4xdm5paU1GaTZKSVZyL2hJdEUw?=
 =?utf-8?B?aWV2VFI3ZkYyYXZIVENrWnlRZldqZjJLRFV6SEswaW8wM3RubUtOblp3M0NZ?=
 =?utf-8?B?RkNCTW0ranFUQ1B3b3N6djBibEVEb3FuTm5mTGM5Wi9Kc0JDMElnOHdOYm0v?=
 =?utf-8?B?cTcrTHlTWEJEVU55NXc2d2JGWEZOazVlZWZ3eC9TdjNXUitXckxRWEUyM1dM?=
 =?utf-8?B?STF3dnU1REZFZWMvNXAyWmhlb0dtSHBJTFhEUlZYclFOR3JXV3ZtN0F1QmhM?=
 =?utf-8?B?QWhHSHBtSjZScTcvMEdGSEhmR1JOd2czbEwyVzRYWENzY0tpZ1VnQ1VaMzlt?=
 =?utf-8?B?R1RqSHRDLzh4eCtqekkrdmhKTGU5QUhzZ25NVVhQVm1YVmVOaVZ2ZEtNSlp2?=
 =?utf-8?B?YThBR2kxSEsxNDlKUGIvbjJjaWZFUE9aZTF3cFhrRG4xcXI3akhCS1A4alM3?=
 =?utf-8?B?Ym9zQnZKNEladmRVMFY4WmhaZm9Hd1lpL2dtVWVSUVhWakVzV25KdlIvK2xj?=
 =?utf-8?B?Sno4czMzRFp0MlJ5UG5iUEdNaW1BY3lLT1JEeFVnbk4zL3ZLYVZJcWRyR1JL?=
 =?utf-8?B?MXNRSFBRWnBraDFYQm4vYmdtUDFZMjU5ZUcvbE1oR1FKQWUxNW5LbHp6QkFM?=
 =?utf-8?B?akZjeVF5dFNqR2ZobnRFSlhXb0s1UHVYTnJTdzJRK3h3SU8zMVMwZDVodkhJ?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDCC22856EDE974794044BE75E62717A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uxlhALm4nQDeliuLZCs/15wsis6Jtqs08cE8ILW/PyMOG+mrZfqiwf/WwsPyQ8CBHfXeWu1AGPoidR5hPmmE0OIWtVYxyLNVxlTrshiL4Pd5nhGzd4Dm67Ap4A2SjLLusCeKyqvGkYTLqZGkzX1t8zxCPvdNDxtT8Yn2E2prjxq2NcCmrE55uWv0tV/E6FRx25Fc38YjdeBvCsbQNFM9+14hxd6VWOHPQsatP+SmkXmV26CAejshcXT8+N+xb4fsgapaNpmiXK8x5oOSq2AxFbr2DM+bH82zZFrMhLKdUWZ47iPx0o+nFJ5oXoYPi0neYzeDMerP09IA+Idc9R4xtbSjVZRzcsFW9quuB8pIu9TClHdcPOKVjdmEQdKD6RIpJNMbLtxU5Xqi3rurd9oxj3tlSACvvF5CTr8uSHzB8v47Tl0ZDjxIvb6PVLFY2Vfmf/ZVq5bKsb+UkDWBa8SXHWy7z8XMhrmPH6f5kfnvHbYVPV6PxThfc6qrl7Z0gZVrih9VlkIiZduneSO5Do63BHKOkRYT++eyJFfclabI7OASXJ/Qg5lMs9jddLLJ7eGBAhEDgIfKKPq5hquWEAGFyH03vZN84sJ0Low6jiB0QPWb6pjpAAWrb+3VL1FqXJkx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99480528-4ebd-4a71-45f1-08de3ed30e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 07:48:53.0890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VCHI8wNe94ofUuyneTXVfEaXrFNQsnojtDNKudOfM++H8gluZiQ3bKSXupggoJpuI7nowYh1eKKZRD+4q8EJ8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6931

T24gMTgvMTIvMjAyNSAwNzozMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFJlcGxhY2Ug
b3VyIHNvbWV3aGF0IGZyYWdpbGUgY29kZSB0byByZXVzZSB0aGUgYmlvLCB3aGljaCBjYXVzZWQg
YQ0KPiByZWdyZXNzaW9uIGluIHRoZSBwYXN0IHdpdGggdGhlIGJsb2NrIGxheWVyIGJpb19yZXVz
ZSBoZWxwZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxz
dC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfZ2MuYyB8IDcgKy0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9nYy5jIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gaW5k
ZXggMDY1MDA1ZjEzZmUxLi5mM2RlYzEzYTYyMGMgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNf
em9uZV9nYy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfem9uZV9nYy5jDQo+IEBAIC04MTIsOCArODEy
LDYgQEAgeGZzX3pvbmVfZ2Nfd3JpdGVfY2h1bmsoDQo+ICB7DQo+ICAJc3RydWN0IHhmc196b25l
X2djX2RhdGEJKmRhdGEgPSBjaHVuay0+ZGF0YTsNCj4gIAlzdHJ1Y3QgeGZzX21vdW50CSptcCA9
IGNodW5rLT5pcC0+aV9tb3VudDsNCj4gLQlwaHlzX2FkZHJfdAkJYnZlY19wYWRkciA9DQo+IC0J
CWJ2ZWNfcGh5cyhiaW9fZmlyc3RfYnZlY19hbGwoJmNodW5rLT5iaW8pKTsNCj4gIAlzdHJ1Y3Qg
eGZzX2djX2Jpbwkqc3BsaXRfY2h1bms7DQo+ICANCj4gIAlpZiAoY2h1bmstPmJpby5iaV9zdGF0
dXMpDQo+IEBAIC04MjYsMTAgKzgyNCw3IEBAIHhmc196b25lX2djX3dyaXRlX2NodW5rKA0KPiAg
CVdSSVRFX09OQ0UoY2h1bmstPnN0YXRlLCBYRlNfR0NfQklPX05FVyk7DQo+ICAJbGlzdF9tb3Zl
X3RhaWwoJmNodW5rLT5lbnRyeSwgJmRhdGEtPndyaXRpbmcpOw0KPiAgDQo+IC0JYmlvX3Jlc2V0
KCZjaHVuay0+YmlvLCBtcC0+bV9ydGRldl90YXJncC0+YnRfYmRldiwgUkVRX09QX1dSSVRFKTsN
Cj4gLQliaW9fYWRkX2ZvbGlvX25vZmFpbCgmY2h1bmstPmJpbywgY2h1bmstPnNjcmF0Y2gtPmZv
bGlvLCBjaHVuay0+bGVuLA0KPiAtCQkJb2Zmc2V0X2luX2ZvbGlvKGNodW5rLT5zY3JhdGNoLT5m
b2xpbywgYnZlY19wYWRkcikpOw0KPiAtDQo+ICsJYmlvX3JldXNlKCZjaHVuay0+YmlvKTsNCj4g
IAl3aGlsZSAoKHNwbGl0X2NodW5rID0geGZzX3pvbmVfZ2Nfc3BsaXRfd3JpdGUoZGF0YSwgY2h1
bmspKSkNCj4gIAkJeGZzX3pvbmVfZ2Nfc3VibWl0X3dyaXRlKGRhdGEsIHNwbGl0X2NodW5rKTsN
Cj4gIAl4ZnNfem9uZV9nY19zdWJtaXRfd3JpdGUoZGF0YSwgY2h1bmspOw0KDQpOaWNlIQ0KDQpS
ZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0K
