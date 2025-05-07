Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEB83209;
	Wed,  7 May 2025 06:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746597938; cv=fail; b=tp1UBkwh8AtF3Mzc57W+WnIfngPOJhZDFfQlszm+KiVamxcrQYrQa2zR61LEyJbSFwjX4FGYkFfR2sx4cK7VqnTY0cxvBydVli/jy4SsDraZJpeGZjrT8Nx/HbJcbVPSWsuZv9FovB9fE85rEuHWDcvaOdBhmHHRMdI8hn9ipjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746597938; c=relaxed/simple;
	bh=B019FZRkZyDOJZRAl40Mh46cRqh/Qex8uJnzC1wKqx4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dL/vo72MZnOZgqZMCdetruDBk3fqesgvOQibEO7Coqv4omy90RPxf2hlf49qmRCnqQHyBFob8I+kYcx018YERWhI2TCKZ128GJP+1fl3tdILIzN/ipimjgB5R9Y475YgpJgUYN4eXIcQt9L9Uj5djv1x5recsnzCfAHbeDU8f9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FIwY25u5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=e/hX3OYo; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FIwY25u5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="e/hX3OYo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746597937; x=1778133937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B019FZRkZyDOJZRAl40Mh46cRqh/Qex8uJnzC1wKqx4=;
  b=FIwY25u5/50UAxCbp0DFtKbT4oAzaomOCrWd0aXtGwUtvStZzNrDsuVi
   yEz7Dr+FVa8vfQX4/x8PEYuLpULDLqQEnAp9FQfs/MGlQzdqHqRBP4x/7
   IJD/I+cov1x14TgMpLEfzwffov1ncfVWo3Bvfi4KVQTnDCxJ+ErXI1gGL
   OUm5yvAGunTu8TxbuwCQzqPY2gLqcHAeT9sia3Bmjb8m3cusoQZEHj738
   Z6TOWAJDCbRLTp841KTwyF0qMNVhfXwUqII7WSEn5/eJAACJ15Ca/r4MA
   W91Tf6pdA1F8WS/md1YwG+/BUlOMWqTe91QAA+vuuhjdXy6pEcvhTwZcg
   g==;
X-CSE-ConnectionGUID: vVdlz9TERz+MaC5TXJhpXg==
X-CSE-MsgGUID: c7SrOTjjR3KEAQfDnt91NA==
X-IronPort-AV: E=Sophos;i="6.15,268,1739808000"; 
   d="scan'208";a="80373109"
Received: from mail-bn7nam10lp2049.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2025 14:05:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPBpORmOUPduWV51uJqwXuqd4ByOaric065mtSBuSQy8GCLAYF5EZU6cDKiCbFmk+sRDphejklYB+PxmK0ySFpe70MxiYuVj8UNC0B4bUUziQXJppor7r8zsi7/8oN+HoobzrXtAm8p/MpBLU6PTrABU5J4lnPR4LGwkRs5sPbqeE1oj/AmshruK7cxysI9EaX0oazVfldMdc0DAHxuguiqPDz/rmZRviG0CTx0IrlmySV6H9yUWzABCy62J4xVIqFUxZ+nLIX94IJH1tJDZCwBGqSzb4JJzvldpdoOKpboX4naxkwCofINMssH1y50zQYI/sJNPP0q63V5JEajkdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B019FZRkZyDOJZRAl40Mh46cRqh/Qex8uJnzC1wKqx4=;
 b=DCXrCv5vD6sCdZziX/L2UmwrTOW7qF8bmpls3PyWlJvpLUf4kcIsmC+n/hIB/qz8eHTc92HkqHI5wmY3DgAa/QIaej6OEaIYLkRjNNKIPJ9h9xM0G44kH+bcgEfhCY1sq8VKh9Y8vVF+yd3Z4BozmI5sOBYLV8DGkubvxa/EzazXCYZKokoWKTRuOsj257SW2ZMi0wMwZkYq71yCt70rzlHGcSAmEQtZFmfPwOiLcQ1x694Pe2wzzozXN3AONNi6MSHalQ1JJyHiuRtlFA9sH1h36KITIeAF3prcRJBFMyuCuy7ynXD3ZqeXueZELUlrcAyjXJcNH2fTDw1YmTS8Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B019FZRkZyDOJZRAl40Mh46cRqh/Qex8uJnzC1wKqx4=;
 b=e/hX3OYorMqfyMh9nJrNL2XtrWbAOitG9sogPfRoCZ3AvzQPLqcoD2aBqrcagStNrbiE+Qej8ox4gHAxL8hUZuywcva5l55X33JIfhsGHiuaa0o1iN1x39yw/GdvhKyAhXhlJYl1liuSZ30PcIMow/Xej0HgPeRg/yyKQulJSrk=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by SA0PR04MB7241.namprd04.prod.outlook.com (2603:10b6:806:d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Wed, 7 May
 2025 06:05:27 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%6]) with mapi id 15.20.8699.033; Wed, 7 May 2025
 06:05:27 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>
CC: Zorro Lang <zlang@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Thread-Topic: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Thread-Index: AQHbvaNRJpxLJ5FgFkmrq6GcallV27PGoeAAgAAO5gA=
Date: Wed, 7 May 2025 06:05:27 +0000
Message-ID: <022fea4b-3af8-4aa6-a345-474093bf8a6e@wdc.com>
References: <20250501134302.2881773-16-hch@lst.de>
 <20250505095054.16030-1-hans.holmberg@wdc.com>
 <20250507051206.GA28948@lst.de>
In-Reply-To: <20250507051206.GA28948@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|SA0PR04MB7241:EE_
x-ms-office365-filtering-correlation-id: c1dc5591-c69b-4709-7f38-08dd8d2d29d4
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SzN5ZElMVlpIdlZ1aS9RUTMreDNKbHo1UHYzUUdvclBIS3hhdm4wVUhvTnRZ?=
 =?utf-8?B?aEcvRS9MeTdkWmt1b0UybVZXaEEzaFFYVmUwTlRWRDZQQWZaMnlKeFFpSHpV?=
 =?utf-8?B?dkZCcVhtN1Y5czE4c2tQbHpoN3VQMEVXbmZRQjk2KzNTOGpUSUIxYysvTzJC?=
 =?utf-8?B?Q3hHYzFRSmN1MEo3TmlTZDllMVZmUWROWWIzWFZISFBkT2NtMHppdjljN0Jm?=
 =?utf-8?B?Rmc5dW5hWUttcnd5NnBSUUNaVFpvRFYwUEsra3o1QlBmY2ZZeWtIUzVNZHlw?=
 =?utf-8?B?citFR050SjJ0elQ1WlpORE1kaTBVSk4vWm1TMmxqT0RjeUpkLzRoOEdKWW5I?=
 =?utf-8?B?YnV6STZoZTlON3RBWHp0bUdjOGFZbkh1YkJRN1labTBGK2F2SWJPcFFZZStF?=
 =?utf-8?B?dzJvQW1ySzAveUhlVzFYSUl2aElZRHBkUTk0Rm8wN21ySDRiUXpDWncwQ0I3?=
 =?utf-8?B?NzM4N2x1YzV2UjlycVdRTkVSNDdhdFZZSy9rRjhFRlpOdjU2NnJhLzJ5Z2ZC?=
 =?utf-8?B?dGQ3ZXlZZmVJVlBWMzNtcy9zeTVhUVpxWUd6OFVMdXloUWpUTHpCTlpTVG1p?=
 =?utf-8?B?aTNwNDFWMS8ycHYwWFpPdHV0a3RGYnhvQmJNWTFWNElwc3FBKzkrZHFXWGQy?=
 =?utf-8?B?YmQxS0dvTWErMjk4ZWQvdEN4QUhHV3kzbnhQZHJkVGluMzhLcHIrZk1WRmdG?=
 =?utf-8?B?MFAwQmxPVmh2d3BOYkdFZHFGMGhaVklUQVhOSEszMTNtWkNCdFR5d0JCS01R?=
 =?utf-8?B?N3FDSkZ4eFFCWTFROGZEeDRwWFd4ZmRRa2hjYXB2d0lwMXEycVc1S0MrOVpa?=
 =?utf-8?B?M0NIZGdXM1ZBdS85d0xVT29jbFB3OWFpSWZhZjlLN1ZmLzZzTGdCNHd4TGht?=
 =?utf-8?B?T2hOMXF5NWNjU3lvZHNtWkF2SFFwdXNIM01vdm1zRURnVWE1M0thT2UyVkFC?=
 =?utf-8?B?RHh6dm1ueStHN29QMHI4ZWVaRDBsUFdrL1hSR0NiUURnWnltSktIaUxFU2Vq?=
 =?utf-8?B?UksrQW9ZZjVkN0JIYVB4dHk5MC9MYmJoUStwenNqZDBsQjdManl0TjlpUXl0?=
 =?utf-8?B?dHRqcmd0R0pCdjRqQXpQOFpIc3JLNDVRVkIyaWZlODhFZVNVZjExRzZYdzYv?=
 =?utf-8?B?K05rQ0NvakhIdUUrR2JLTjlpSjM1eXk3TzR6YlBzMkRzN09yV0Nzd1lTT1Zi?=
 =?utf-8?B?V0tXYmNWbmpoaGhTL2UwUm1qVHhZU3dEWGFJUWh3NDZYeEtYRko1emcveHA2?=
 =?utf-8?B?T2V3S1FRRi9jVkh3Q1dTN1dRQ1R5eVZmSUQzWmVKZlc4eWpBTVI5UHlKR1hw?=
 =?utf-8?B?cVZXL21VdXkyY2NQSS9nRDBTRTNOM1FDd2xmY0pXVUJkekh1WFZtK0ZUcFpD?=
 =?utf-8?B?UHIzT2FKWVNBT2lycUxwbU9WNGh0TVBoNHpYUk90L3RDQStGL1NGSWlkM1BV?=
 =?utf-8?B?a3cvL2Z4SmVKcmF6S2hUNmY2RHNoKy9NWjZFS1V1MU1xNC9BVEN2NDJVTmY5?=
 =?utf-8?B?MU9VNFI4anRZdU4zVXpqNXNtWEJTTnY0SXl1MlRCY1BTVEh4Mnk3YjNlbjhV?=
 =?utf-8?B?VnB3NU1MNmo4Vml5RkE5KzhHSW5LcUloWHhMMmY0eE44SUM4S3M3cS9BdjVI?=
 =?utf-8?B?ZUpoSVlTNElTdHdRSERvNzRpcTkwcGprRVhoZk1KQ1R6akFFQWs0SDBlM2Rt?=
 =?utf-8?B?bllDSlJ1ZFBuSytBd1Z6S3E5TU1lZnNheE1CNlBydDVZRmJ0TDN0Tjl2R252?=
 =?utf-8?B?NkRueG9uNzEyWS8vNlNSOUROSWVSQURyYjZ3a1NBeUF3RjRoU01SbVo5Yklr?=
 =?utf-8?B?VTJxbjJJQ3c4ZW9yclI1MytSNU5OeEQ5ZUZjRXRNUjFVZS92d0FtbnJEeUV3?=
 =?utf-8?B?NS9Qd1pJMGJYeTlhd3poenVtQTBLUEJUQllqcENqcUNZRWduNUNVUHBLb2tP?=
 =?utf-8?B?OFZ3TGpaMnNLR01lK0o2eUl4MDI3WUEvWTlRdHVXaXZldjBnQjdIT2szN3Nt?=
 =?utf-8?Q?G3F7C4/DTS1/hd5TRUnA6+yT0otZF0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eXl4d3pDUkZjU0tHc0FZNGk5VGlKUnA0dU5iV2VLYUtIT2pOUUZlc0JXTjZU?=
 =?utf-8?B?aXMwSkNRMVR6b1I3UFFQUzM1ZTdNRUZXYW9wTzNvR0xYTmN0TDhicmJISkZE?=
 =?utf-8?B?SWhCdUhVQ3VuY0h5Y0pEcGdpcDY1Q1BjR0Mxa08rOHJvMk5ZZkJsM1Nwbllu?=
 =?utf-8?B?U0VrbEJNeGNkRldhZldSZXRRdGM2dlAzbm1zUXFjT001dTIxY2ErczBBd2lH?=
 =?utf-8?B?YmYwaEI5T0pjNW1mYnRyWDhvSVJiWEdoWUJQeUo1ZmJtRWR1K2twT1MrZncr?=
 =?utf-8?B?UFVVaFFtTFAzZGg1OUtQTDlHYlhCU2VQcVY5SUdPNlRtd3dXTDNhSUtmNWJz?=
 =?utf-8?B?aGxVL21uV3cybDVaMG15RnMrZEkxSHh6S2hhbnJIUzRrQTAzcWE4djVvN2p2?=
 =?utf-8?B?bUlBYzZ3azc3YVhiUXpBdlNtd0dieTVOUnZKeHZNNWYxd3JONGlIbENIYlZM?=
 =?utf-8?B?UGhXdGJHZU51VVBOak9zenNqZFg4M3ZwLzZaano1V1pZU0hOeThTVXlRWGhz?=
 =?utf-8?B?Wmo4c2xpOGRRRG1ObEU3cW1sYWd0ZDQ2VUNSTGh1Q3RKZ1Z2UmJVbFR4T2hD?=
 =?utf-8?B?S00ya0ZOV2p5WTlNTms0N050MDN0dkRWQUliSVFJUmhoOEdvbE9hTFNUeWRZ?=
 =?utf-8?B?L3BjaXNONkpwV0ovZGNCM2FzVzZNbEhORTk5VEZ2Kyswb00reTVvK1FlNm5U?=
 =?utf-8?B?eFErWWJoMmlLemxIMGVGUHF2eCtGRjF1UWtYTGNmankxQVpDbTFSYmdXbE9q?=
 =?utf-8?B?b3pKWEZEMk1FeTYzOFpYQ0lPaVdxY2dCOWJVNnJXMFBmWmg4eGNzWk1ibEFs?=
 =?utf-8?B?WENXaGV5ZTRORjJzbUt1akpYNEZDZ0hLL1NjbVpvMHJ3OGsrem1MUk9HRzEx?=
 =?utf-8?B?QnY0TWxQYkdOR2FjeG5vUzlZU3NPTjJGVmd5RENCdHdNemJ4dE54N3JDellQ?=
 =?utf-8?B?YjN0WEthWmVhMWEva0VqdGRlOUE2dFR0dWpxU05UV0pnbFRUb0k0bFFWWkxE?=
 =?utf-8?B?aTVFQlN4c01VQnpkaUR4cXA3YWxYNWFqOURlaTlqVjU5NEorUEZUQ0c1ZE9W?=
 =?utf-8?B?Vm9sY0tzUFNVdW93Q2lKODhicDB1SkM2aXlMbDhxWjVTbGtPazBZampNVkpF?=
 =?utf-8?B?MndHTUM4Y01jMTJDTjZvUUk5K2VYSytwY0gxQmc5YWY4RUJudklFWEVxcEhz?=
 =?utf-8?B?RHhBVFZxWHd3emo5RzB4cnEra0VYb294U2t6OVdyUlo2RzNqMjFOS3BOc2d1?=
 =?utf-8?B?VktBbEpKMDJQSGd3bVAwQ0xSQWdqZVo1TkZSREVRTFkxQzVKSFZTT1BNbjBM?=
 =?utf-8?B?bzM2T3FaeEVteE5WaGlkaitWRy80WVFaRTZpMm9sTW5hRmtwUmszL0s1bHBu?=
 =?utf-8?B?dWU0U1IrT0dSdHVCZVBkSW83S1htclh4bjk1Unp5eGh4V3VXVFlWZVYxS0NM?=
 =?utf-8?B?QlcxdTBWdEplY3hiM29vb2M1cFJoUE9BRDkyVmo4SE5KL1AxbVVNT1B6bHI3?=
 =?utf-8?B?WEpJRnBmZmQwazZiaEhOYXJ4dkVXUGNBRGFLRmVyNTUzZkZMc3JJZHN5dEJ2?=
 =?utf-8?B?RlRFcGdWcWJGUnZTZTVLRjIxV1d3a2VnNGY3RE1aSGluMDNmcnlHcE8wQk9G?=
 =?utf-8?B?c01KTWpUbE01b1RTNGQvS1dkdmwzaUZxeG0wMGlvZDIwOWZ0bjU0S3BQV2JF?=
 =?utf-8?B?YWsxTU9kSEhrVXR2SHl2VGhPWWt6NUdyR2Vtb0JwcnBxRTdabThEVlREdmVL?=
 =?utf-8?B?UkNZSEtub01pZENvNHoxZVhhcUljbFRkQ1Q4OEFxbTF0RWV0SzNreVhBSHlP?=
 =?utf-8?B?Y3l2dlgzRmdMMXZOL2JVWlp3TWRhYUhaSEcwenlwUDlGcnhnVDNINlRZczRO?=
 =?utf-8?B?SlFkZnc2MTRtUUdJTE1GbDhaVm56Nk80NXhESmZEc2g5WVA5TTl6VWY2cHR0?=
 =?utf-8?B?NE43RWFydkZjT0hQSWxIb3FON0h3QWRDZlJHNzZkcDJ0R2tUN0gwUkVYU08r?=
 =?utf-8?B?YjhVeVBFWnJKdm00MDg0MkJWWnp4MCtkRmozaTBmaE1GTDh5MGVjRk1Yck5k?=
 =?utf-8?B?ODZqNVBTeXZwaDF0MzFtRWhmdVpSUk8zditJZG0raVdGbmEzMjJvMGUzanFR?=
 =?utf-8?B?dHJJcWpVdzg5MFVUcmh5emVubDVqMHVySUZlb3RSek8wKzVtSysyaEczN3dl?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A96548E114FFE1448BB163CE28ABD68C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bLXOSXLrUgtnlYF4dMPd/yxBn0eUGShrdrvCSQXCFzFlGOiPirIMHrm+gkNxfIDQFZvVhMJKBRGY+Viva05YB44TPKlL7Ky7tYM8rZm/JBn3tPdYgLXHQyGGl5Ub+LhrOWwexLHGMb3FVTPqHu80e3tq+hvRIuV5FxMg2kPRzGfqWWpEDYVV1z4BCigqCuBATnsquifyKTUku4qI2WDlOZGDHH3qAtOUGWp6PhjBgjKmWZ8DSuzkC9aLO3Vbe0ydEk5VP1Yy+ZdU4ce+LuuRG3EsGLaL6DQDu1IyljzbVuxwopq0fEp8s5xV/HVrbMQrag3R3mhqbdPEyupMwfVUaL8+e0RoNsTHd1VhFccpngB/yZZkdiIYle4KvIBc8zw9VOjtn/k6ZpXPq4ZifR/MeKy7QD7duFF9Jj4TMhqul23CIPjT6GW1NM874SQj/juNML9MKHDLf0qPX1aOh/WfHYKmZLaBmXD3Lly+FxWlKoDjSCtouylZRrukM0ZVF2ck8bHDZMglS0PTQ5ydE6UEUh/tfXTYt/Tq7EuF4gYYpYESPTV0O16SFVD3T79R5kpOyIbFTrdasP8qTFFz06XOQ+SLIJk5658joec3u6Demm2UvXxWvbJcQizySDBB8qP5
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dc5591-c69b-4709-7f38-08dd8d2d29d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 06:05:27.0765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yUIgDkaYejgfs7Keog3iyW1fO/yrDnxpZdhR3pJ5LKeSP7g//lhfDS2MN/epx4GRdPQaGHgVIl5nRYbzlKhJ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7241

T24gMDcvMDUvMjAyNSAwNzoxMiwgaGNoIHdyb3RlOg0KPiBXaGlsZSB0ZXN0aW5nIHRoZSB1cGRh
dGVzIGZvciB0aGUgY29tbWVudHMgZnJvbSBab3JybywgaXQgdHVybnMgb3V0DQo+IHRoYXQgdGhp
cyBkb2Vzbid0IGhhbmRsZSBpbnRlcm5hbCBSVCBkZXZpY2VzIGNvcnJlY3RseS4gIENhbiB5b3UN
Cj4gZml4IGl0IHVwIHRvIGhhbmRsZSB0aGF0IGFzIHdlbGw/DQo+IA0KPiANCg0KQXJnaC4gWWVw
LCBJJ2xsIGZpeCBpdCB1cCBhbmQgc2VuZCBpdCBvdXQgc2VwYXJhdGVseS4NCg==
