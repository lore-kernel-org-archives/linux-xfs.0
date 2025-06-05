Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B06B1F4179
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125240; cv=fail; b=KOx2CkRo5ywKnyVA9rJcALMapEJogbUOzAzzY7boBxBdMDVZIG7DWsJOgDhLGkq/wYNXeMVq2r/bI08LexGsNOY6Gv+rOliLVGfkpk4JjPQqdBsPiO+VdaOWSPpjKZUJd0UzI44jG569rJvSCOOZszzrnRE2ROQ7hrJYa62djXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125240; c=relaxed/simple;
	bh=Eg4+udFFIVDXACtIYU8Mgno3+7C6nc4wIdeOQ8OK2ZA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GJ7ctQmSSajjV0mWvy0iVSDAqSrTgowOK7dCl2PFZF42uMlfoqJ/jqwHFWxTfvXbR43qzKj/pXrKoiZho86lGxtK4y1rTWFC0eFoTuIPgrSYTDKSePuE/HV+JP5lalCCP0cUaXbiNJuPXizgFKQLdYYhSsvWBUt46M3j92KJJS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MkM86R50; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mjHzJ3hC; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MkM86R50";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mjHzJ3hC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749125239; x=1780661239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Eg4+udFFIVDXACtIYU8Mgno3+7C6nc4wIdeOQ8OK2ZA=;
  b=MkM86R50Tm0DQBtZDQ/kOhu2UAhI6Mer/ESZkamiPEeENA2fxY5gtSlf
   jkmVKZaNEtBwhw6utGOY0D19tUtHGLkoryZCwotGCnSQGX8TslhUQq2Ub
   ofZzKR/7XjNCKsi4WXD09bN8XxlgkukKrXYhqAY4+ch9UuDrgCSoY0vHR
   z5Wd0h7HqiVqDFes/5Brn8j7/AfdhgP3tXwV9slEecEneQT+8AhKGH2Hj
   zFq7bxnS3pVusOiK88BaB4N0uYk1MzFdAR1GP/JmU+6zMadq+lE88N6VS
   7AANa6vbv6j6CTm+qqbF2pOVeSwEmdVtaehVljlpDj/b3Bq55vJUUxHF0
   w==;
X-CSE-ConnectionGUID: UVxcAwGlSBi8HPx2nGugAg==
X-CSE-MsgGUID: 9lVtUJcGQFSYIY7vmpiwIA==
X-Ironport-Invalid-End-Of-Message: True
X-IronPort-AV: E=Sophos;i="6.16,212,1744041600"; 
   d="scan'208";a="84799551"
Received: from mail-northcentralusazon11013039.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.39])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2025 20:07:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXxI7tR360S2WNfVHv52pm3ZhZ9HH4NiSFlDknBGrA9D3QIZBIhjkxQLFWJdBvRFXRMyLXmR/xpPDke4XsW9/yFcP0qqmLLqLYicjWlNecMqD3YXInKhO+FqWYFTLRSPFf5hV/4mpK/GS0+8qRLK+VSQTepZ0XWl1/tMPn6LpJ34HmMTfgZ4fTvgxGxpH++KXs7cNKhOheAq34VhjdkPh0trRf4RLMYKfS1qp8JlbgX6fu+Jjz1YsrRJHXGL/WkA5oI9z+0AWa8YXhURGFADerNU/eyFnlnAySw0bRduqBbnV4svvUiHSyMm4KXrayWm3JZeSkJeplMBDk91G+emWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eg4+udFFIVDXACtIYU8Mgno3+7C6nc4wIdeOQ8OK2ZA=;
 b=SsPFNv4QMc+6gZD8Q/9ueYczxCMCPpN6z1rq2r3Dp+cxUENgyn2urPg/a+3YTel3Vr6hZ1O9XOvFYbeHfPHnjS/TXkahqAQ9ba7JgsubYNxL/gy055OxxyF1abWkIRG2jcG1rwkYM5TJyy6O/b5BHPH+5zp1/LWf6aYJSWahpdlfIGfIYh5OfXJT05OKDSivEKAViJz9gZFAI0fGo4DmtXYtnTT0da5Wtkw9A/bS6hagz45bhA1e6Jtm2tCGyKmrkNiBqwIF7luiLna+AsUN2X/kS4MZx0REhkqkz5iSh4CiESV4skHbnHZR75YTVZ2cpP5bx9AVSd16Pak9PZagJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eg4+udFFIVDXACtIYU8Mgno3+7C6nc4wIdeOQ8OK2ZA=;
 b=mjHzJ3hCSQ1zG+rumnX1fJzghEbTOlK+vMhSMYUR62FIKqYrsyBpqWWCi6bIL+adbqq5+A4mxMc4pRk8wM9mm2VwsUmpINTFLTTUgJzj5odRaM98UkFw/NlfnE63feJEIa071Gw9SJQXmJpXAiG3mO6uZFqCnMDxCgU9buSEQ/s=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MW4PR04MB7249.namprd04.prod.outlook.com (2603:10b6:303:78::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 12:07:09 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 12:07:09 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] xfs: move xfs_submit_zoned_bio a bit
Thread-Topic: [PATCH 4/4] xfs: move xfs_submit_zoned_bio a bit
Thread-Index: AQHb1eF01Or4czRYBkKmukV8GLeVvLP0ePaA
Date: Thu, 5 Jun 2025 12:07:09 +0000
Message-ID: <d0e00f52-8786-4529-867b-d0d7be9706d2@wdc.com>
References: <20250605061638.993152-1-hch@lst.de>
 <20250605061638.993152-5-hch@lst.de>
In-Reply-To: <20250605061638.993152-5-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MW4PR04MB7249:EE_
x-ms-office365-filtering-correlation-id: e935b616-ca82-44a9-a94a-08dda4297f6a
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MWFPNFp1TWE1bDNVVDY3NFp6d1Nvd2lzOEc1STdmTUxwbG44WXRlNncxNFo4?=
 =?utf-8?B?VmNtSi96VXcwQjlqcVltdG9UKyt4WEx5aUhtRVdGUHN5b044UVpUM3B3cWlj?=
 =?utf-8?B?WlNwUnl2WVB2elMvN1NlaDFEWmFHY3BmVnNrenladFFrWE13TFhDc0NnUEwz?=
 =?utf-8?B?a1EvalJtVHBHMnF4WkltTEF0SmlGR0dUSSt0SC9rdkRmUndsbWhaaEN1NlVH?=
 =?utf-8?B?UVBVamlReFBEM3B4SG1EUTh6NzhOUSs5UzRNa1p5UmJtWEFJOVBMaWxzYWhZ?=
 =?utf-8?B?bXZLWEY2NE9FQ1VwaUwxbW5ZKzFzNHlKTzFGbUFqZEoyWFFMY01RMDBPQVZ1?=
 =?utf-8?B?ejMxeXF3QmtCcFFKdGhhMlRyc2N1SWQvNGFKZFVNczdCT3FJNFI4bzNwaFR6?=
 =?utf-8?B?dGY4L0lFYlpjMjBTVmd4cXdTa2tqd1NFcUhXTVRRWHMzbzd0QTZ1TUNISXE3?=
 =?utf-8?B?NHBMSzZmcEp4R1hEYzJDcHBiY2R6ajR4a2N4QzlIaDFGTnR6NU9lZ09ZR09Y?=
 =?utf-8?B?NkZiY3gvWExkOHZwZzRDMUJjbWF0cksreGw3WmZ1a0hQV1VrS1d4QXNDK0ZM?=
 =?utf-8?B?NHRGN3M1d1QrdUlpQ1p3OEFQbkNRZTJGYkkyTWRkZEZ0VDE0MnYwK25sL2ps?=
 =?utf-8?B?dkFwWU52MG5uSG9iS1hSOFpjZ3lpd2w1ZnB5RHYzajhDbTVVbUJuTk05Rmxr?=
 =?utf-8?B?VGNJVVFvdkVRdHdXbHFWT1JOM1JnbCs2N3ZwR1lMOXVZMHVtVGxPRDdjam5x?=
 =?utf-8?B?ZXE0WkRkdm9jT2kxVldwSzlEL05icFhiZEtqMVc5eUV5U3BuZGJyLzV3clBJ?=
 =?utf-8?B?ZzlnOEhabnlGOXBHUG5kb2FWWjZadjhPdkN2V2xOSVNzaGJPU3lQZlBpMWhH?=
 =?utf-8?B?TjZvMCs0VXA1MERyN2lNNHNYcWVUUTdlUmhWOGRMbkpXSHFQWXlhODVqUE9V?=
 =?utf-8?B?dTZhYVM3eUtvWFh2eUtlSUk0Nm5xUmVUMm9jWEJocE8xdkhFSm9veUlBMlY2?=
 =?utf-8?B?UnRJQmZmSE9uenpiM3lMemV2VWpjbUN6Z0EzZ29yTlhQN2JOMkpUVmpaamJp?=
 =?utf-8?B?K2o2dkNZemt2VTB4N3RoTytmL1NZSHB4dWRjcTJLek5GWkFuNzkrdFNPMUtk?=
 =?utf-8?B?OEtXM25wNDZwUmRYb3k5MSt4N3Zpb2szQW1rTlF4eWhFSmwxMXdITHllYTBI?=
 =?utf-8?B?VFliQ09MeXR6R1V4QUp1NkV5V1ErVG9jdnpQYVM3Z3poaFNzbU5aVktLYXVp?=
 =?utf-8?B?RS9zMy9EWFZEOWVDdlpHUGJtcnUrY1F1Z1VUR0YwWFlwdXp3QmFLRXFPYmNn?=
 =?utf-8?B?QWY5dFMwRUlSSCtDbjdXT1dHa0ZoZTJ6TlhCaDJsY1dRSXhIY1ZhM1d0Mndx?=
 =?utf-8?B?L3R1TXhUUENvYmYyMGVqMk85b0s5TFYyTlBXRXUyaXpVSmsxc3lVNVJJQ0hX?=
 =?utf-8?B?UUdwTVhidkxud0ZsL3hvMGZrZW1SdU80ek1VcTFFQmRNL2dvSWFoQk1QM1B6?=
 =?utf-8?B?eXpxRStZMnlLWUVWUnFKcnVvdmoydVd4WS9oZ0FuRVBIdG5SR1lJQ3B0UzlF?=
 =?utf-8?B?YkpDa096TGorK2V5RWlWUmlOc1Y5Ty9CeGRSbm4yQVgrbDJjWW1hRVkwbEpo?=
 =?utf-8?B?RUtuUVhEa0JjZHByRUxqeUk5aUVsYm5YSGNzVkNpVmkwKzMxbU1yUzgwUEZN?=
 =?utf-8?B?YndqZThTanhvemwrd0pIYVhrVzRCU2EySDZEY1lkYitIaXFSREtvTUtLa2Js?=
 =?utf-8?B?czJBR0xrNEloZ2R2TnpRTW4yUEFjdUJxL0gzbjBGKzBCNEtjcjF2THRvcmE5?=
 =?utf-8?B?SzVCQ1lsSzd1VzVqV0ZqNmNQRGhKTGtuckJkN25HNFZRM3J0V2d4TFRVeXp0?=
 =?utf-8?B?SGdKQUNUU2dSN2hYTjB4aFRidXY2SFYvNHQ2QWZncEpmSnVyQjZPeDNZQXNs?=
 =?utf-8?B?NnlNSUZkL0F4c2tQcjB1K1dKTVZRTlkrUHYyemN6VHhxSkQ4eTgyTjM1VUE4?=
 =?utf-8?B?Nm1Ya3Z5cXpRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aGNua1Z2cml1QjBPODQ1eHMxUStsejFQaU1na0hmanZ1NHRRazB2bnZxNjVi?=
 =?utf-8?B?TjhYQkhCQkl5WFFFbCswTEpIN3F0RG93NkVwNU5Ma1BTZGwxNHB0akg2V1p0?=
 =?utf-8?B?VTZOdHo3NEd4YmZTL3BDK1ZDa1I3bjQ2bW9mUFVsV2dJWmRkMW5vQWpZNXIz?=
 =?utf-8?B?UnIvSXFxcjVIWDNodm51dmQ0Y3ZrUk81WWNZcHA2eDllQUxxUzhZbDBFaFVQ?=
 =?utf-8?B?WjFXcEpQcHJnSWJZOGE0TGsvenFuNjM4ZWxSbWNtMnJjbGk5MzNYcUdabUxQ?=
 =?utf-8?B?T3MyaW04TE9PbXc5MjdiMmh1bVlhTS8vK0pFNFhqb0NFM2dtUmI2Vm1zNCtZ?=
 =?utf-8?B?em9XWnFlcXE4YzljcE0wNnplaTFaUlpvLzk5VHNDTGJkeXhDVEdtNzIwRmFU?=
 =?utf-8?B?cVNaZ1dXLytHd3NKc1F4YTdYUklhQjY3M3dOeWhGY0tnQzd1NTYxQnVDbnpD?=
 =?utf-8?B?aFNVb042Y1UyWTY2UmR2VWdPRWFSS09EbVUwRUdya1hYdVpMTmx6T3VPcUVh?=
 =?utf-8?B?TTZhYkZjd2x5WHdERmZjV3pXSDEzOXIwNTNpOFJmSjA2OTZGRnJ0RmdXTk1p?=
 =?utf-8?B?YzBDaTRWalJnNVpiQ0MvSGhRN1VDSWxwMDc5T2JTVElkTHFwelpXVFp5c1lK?=
 =?utf-8?B?NUszLytvMGtwaXVFc3hwK2ZaNWFGMnpuVGNobmxCMXJoUVEwVGVXNGNOSnBY?=
 =?utf-8?B?T0Y0Y3lBZE8zQkRQSWwwenZmbGVyaVBYek1aaGpPZ3h2MFEyTlNycllGeFFP?=
 =?utf-8?B?dnVCaFlWbDVWbk5hOEVjRjdLdWRITUxzTUw0TjZsYzd0Uk82cnliRy8vRjhl?=
 =?utf-8?B?dzRReVE3ZWd6amVlN0M2dk8yNkF0UGlnQ2Z3NXBvd0FUVkVkaHBteWxGYU42?=
 =?utf-8?B?aWdQTmFtcDltUDdONFBnbmZvSWFYbGZoZG5kWEZxZ3V1ajVrOFJlZVFtc1By?=
 =?utf-8?B?Z1c3RFphUXdvL3Z6a3hCL1dsakNmTFFHZERSSWRFcU1BWk5vbHJpdENoYlk3?=
 =?utf-8?B?MGY4VkUzRE9mbDYxNWlQc0ZVL0cxVE1IQjU3SUhyYzk2MXVDcjI1N1k0S3Rl?=
 =?utf-8?B?YWxKTThnSU1LZm1nM2hHaXJkL1JERkxWbkpUQ3dCK2hCVXFoVjd6YzN5cWsy?=
 =?utf-8?B?TDVYdnNKWWE2N0hXUGF4SGdNbndiQ1gzd3JuanRNNEpmR2ttQTdQMi9adWdu?=
 =?utf-8?B?R0xEVjNLMjAxbFR1ZEU2bUljWmJrRjhzMmFyQXQ2M1hkSnhrS2RISkxmaXRE?=
 =?utf-8?B?am9DME9JUWtjUDRzL1krWEdhejVnbDlYb2ZuWG1hNTE4Mm5IaTFDcGlIUUlY?=
 =?utf-8?B?WnZwQUdaMHBFZ3ZZdjNNSmJReW5qSHJRMWxDQzVmTE9LK2ZCVElJTzJ0TUdJ?=
 =?utf-8?B?Yk45M0dxdU9YRlN6ZDA5V1JxVnBIZVNpTGQyQTVTWWIvU2ptOEtxcXZyYlNr?=
 =?utf-8?B?TkN5NnQyWHgzdGNRZjVhdTRvTTJoRjZ6aCtzMlByNElYdVlHUEhqMGR2Mkx3?=
 =?utf-8?B?RHloeE9RcCtINlhnUmN1VUd4QnQwWlMzcFk3UUhYeC9LUmVwYXpRSkRrYy9Y?=
 =?utf-8?B?SXA5bndhdnRoVmVLMm91aUwwaDBiL3BQRGUrbEpweHlqcmhLT2hlNTZEOGtH?=
 =?utf-8?B?bVhCRXJUU1kvRnQ0NGpyekdoU2tXQ2dETlhqdG40ZjkxQk1oM2lySXRFeWRv?=
 =?utf-8?B?ZjZwWmtGbVF6VitTdUJSL2FPOHd1ekt5bG50MU4vdjRBKzhtWUFqaGJsbnYw?=
 =?utf-8?B?SjduM1JKNDhJNDJPZHN0eU0yWTV3OGZ0bXpTMWZYRVp3VDZ5dW5uZmozYzJ5?=
 =?utf-8?B?OWI0RFV2VzVrbERKQzZYOGRYOVhMYmJhdDFEQjhJTVRYd2hQZTVZY1g5K2xQ?=
 =?utf-8?B?Q0NwVm9wZDhDQ0g5K2l4SWIzWlJMUjkxeVRxTng0Wm8zUUxqNkxTUFpuMjg5?=
 =?utf-8?B?WkxDV0RYYVJoUHQwZUxPNHRWZ0NyWkNGYnQrVlJWMDlRS0d4TWdKaXBzVFl0?=
 =?utf-8?B?Y3pRK0JoYmZEdk9MRi9iMGdsaWFWbmhtTTl2SHJqNFg2cTAyRFBJK0ZQMDE3?=
 =?utf-8?B?Wkw4WTJyQkJlMDlxbEV3anlZY3NXOE1UK3RkTVVVN1hFUi94cm1rYm9xSXor?=
 =?utf-8?B?Tk9BejlIcUxFOGlDVmEwWm02ZkJXRktyMVlYOGJINEpKQmx6bWY0eWg2dnVO?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C10AC9612163F54780C0F7EFA9D30193@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BB0fFTSolNuMotKiQSuq+8yeU2ELEBRcbcwSaoxYq9fnl2wueINxORNmEL5A5ncthZmLGgfEXXVuGXTBMA6bVBsM/45idNA2nXZiX7e3bmmYmOURUnIo1D+XJKvo5XzEh/f78R5iOoYwDiWnX2TQcZWtVnC8nCoUMR3PxK6sW2taiFZmxtZ2CbfwdTavI1WgsFVx1kq/VHaO+0a/DDUPZ5sPW4XJoRswklZGTXbJ/UcyPXhrFPndPFc5j2SW2mARSa5twZlgSTtQb/5YjMLgl3HPOIIGZWvXX39ysjkayA/m9F373xDJ6SJlgo9BkkfTmefXacrqZCMfiNulPkJ2dg6SByaoNCct41pXG5xFYcAiRAryPGhJM1r6F8iKreFQLBOPRcrq7e03S6YXETOpVxTO3mPpI4SvBERuJri3yT9dVjQUByiKBdxgDh5CE/cc9prUQ+24Cv8Zso2ALCqdab9NHPTXVdKdYOLt1UtEvQwONSrA6TPfwNpGHmO1R0j7kHK2eidU+SMNjoaptQxcGTOxzddPwBG5B6U+KnJ2iemVU3faHrT+IDncwD4ZFBZSnjyo7OP6vHTTCfUR6lb32izmH5zTJ8hI9M9VscEJT4Vbk+p8z/IFXAsbaxsdvLeY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e935b616-ca82-44a9-a94a-08dda4297f6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 12:07:09.4727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 04ajt5kmTW3t/2q560Fmq03L9xviqqcowa2BdzTHLr2MKB7r6bMZNBUAjSliFdEXms4Zn0l1R1/p5up78nOlwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7249

T24gMDUvMDYvMjAyNSAwODoxNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IENvbW1pdCBm
M2UyZTUzODIzYjkgKCJ4ZnM6IGFkZCBpbm9kZSB0byB6b25lIGNhY2hpbmcgZm9yIGRhdGEgcGxh
Y2VtZW50IikNCj4gYWRkIHRoZSBuZXcgY29kZSByaWdodCBiZXR3ZWVuIHhmc19zdWJtaXRfem9u
ZWRfYmlvIGFuZA0KPiB4ZnNfem9uZV9hbGxvY19hbmRfc3VibWl0IHdoaWNoIGltcGxlbWVudCB0
aGUgbWFpbiB6b25lZCB3cml0ZSBwYXRoLg0KPiBNb3ZlIHhmc19zdWJtaXRfem9uZWRfYmlvIGRv
d24gdG8ga2VlcCBpdCB0b2dldGhlciBhZ2Fpbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlz
dG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9uZV9hbGxv
Yy5jIHwgNDAgKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jIGIvZnMveGZzL3hmc196b25lX2FsbG9j
LmMNCj4gaW5kZXggMGRlNmY2NGIzMTY5Li4wMTMxNWVkNzU1MDIgMTAwNjQ0DQo+IC0tLSBhL2Zz
L3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+
IEBAIC03NzcsMjYgKzc3Nyw2IEBAIHhmc19tYXJrX3J0Z19ib3VuZGFyeSgNCj4gIAkJaW9lbmQt
PmlvX2ZsYWdzIHw9IElPTUFQX0lPRU5EX0JPVU5EQVJZOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMg
dm9pZA0KPiAteGZzX3N1Ym1pdF96b25lZF9iaW8oDQo+IC0Jc3RydWN0IGlvbWFwX2lvZW5kCSpp
b2VuZCwNCj4gLQlzdHJ1Y3QgeGZzX29wZW5fem9uZQkqb3osDQo+IC0JYm9vbAkJCWlzX3NlcSkN
Cj4gLXsNCj4gLQlpb2VuZC0+aW9fYmlvLmJpX2l0ZXIuYmlfc2VjdG9yID0gaW9lbmQtPmlvX3Nl
Y3RvcjsNCj4gLQlpb2VuZC0+aW9fcHJpdmF0ZSA9IG96Ow0KPiAtCWF0b21pY19pbmMoJm96LT5v
el9yZWYpOyAvKiBmb3IgeGZzX3pvbmVkX2VuZF9pbyAqLw0KPiAtDQo+IC0JaWYgKGlzX3NlcSkg
ew0KPiAtCQlpb2VuZC0+aW9fYmlvLmJpX29wZiAmPSB+UkVRX09QX1dSSVRFOw0KPiAtCQlpb2Vu
ZC0+aW9fYmlvLmJpX29wZiB8PSBSRVFfT1BfWk9ORV9BUFBFTkQ7DQo+IC0JfSBlbHNlIHsNCj4g
LQkJeGZzX21hcmtfcnRnX2JvdW5kYXJ5KGlvZW5kKTsNCj4gLQl9DQo+IC0NCj4gLQlzdWJtaXRf
YmlvKCZpb2VuZC0+aW9fYmlvKTsNCj4gLX0NCj4gLQ0KPiAgLyoNCj4gICAqIENhY2hlIHRoZSBs
YXN0IHpvbmUgd3JpdHRlbiB0byBmb3IgYW4gaW5vZGUgc28gdGhhdCBpdCBpcyBjb25zaWRlcmVk
IGZpcnN0DQo+ICAgKiBmb3Igc3Vic2VxdWVudCB3cml0ZXMuDQo+IEBAIC04OTEsNiArODcxLDI2
IEBAIHhmc196b25lX2NhY2hlX2NyZWF0ZV9hc3NvY2lhdGlvbigNCj4gIAl4ZnNfbXJ1X2NhY2hl
X2luc2VydChtcC0+bV96b25lX2NhY2hlLCBpcC0+aV9pbm8sICZpdGVtLT5tcnUpOw0KPiAgfQ0K
PiAgDQo+ICtzdGF0aWMgdm9pZA0KPiAreGZzX3N1Ym1pdF96b25lZF9iaW8oDQo+ICsJc3RydWN0
IGlvbWFwX2lvZW5kCSppb2VuZCwNCj4gKwlzdHJ1Y3QgeGZzX29wZW5fem9uZQkqb3osDQo+ICsJ
Ym9vbAkJCWlzX3NlcSkNCj4gK3sNCj4gKwlpb2VuZC0+aW9fYmlvLmJpX2l0ZXIuYmlfc2VjdG9y
ID0gaW9lbmQtPmlvX3NlY3RvcjsNCj4gKwlpb2VuZC0+aW9fcHJpdmF0ZSA9IG96Ow0KPiArCWF0
b21pY19pbmMoJm96LT5vel9yZWYpOyAvKiBmb3IgeGZzX3pvbmVkX2VuZF9pbyAqLw0KPiArDQo+
ICsJaWYgKGlzX3NlcSkgew0KPiArCQlpb2VuZC0+aW9fYmlvLmJpX29wZiAmPSB+UkVRX09QX1dS
SVRFOw0KPiArCQlpb2VuZC0+aW9fYmlvLmJpX29wZiB8PSBSRVFfT1BfWk9ORV9BUFBFTkQ7DQo+
ICsJfSBlbHNlIHsNCj4gKwkJeGZzX21hcmtfcnRnX2JvdW5kYXJ5KGlvZW5kKTsNCj4gKwl9DQo+
ICsNCj4gKwlzdWJtaXRfYmlvKCZpb2VuZC0+aW9fYmlvKTsNCj4gK30NCj4gKw0KPiAgdm9pZA0K
PiAgeGZzX3pvbmVfYWxsb2NfYW5kX3N1Ym1pdCgNCj4gIAlzdHJ1Y3QgaW9tYXBfaW9lbmQJKmlv
ZW5kLA0KDQpMb29rcyBnb29kIHRvIG1lLg0KDQpSZXZpZXdlZC1ieTogSGFucyBIb2xtYmVyZyA8
aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0K
