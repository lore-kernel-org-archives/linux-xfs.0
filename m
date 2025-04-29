Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882672C1098
	for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 11:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745927906; cv=fail; b=mgH2Eo1gp5HrQafeQI7/KOtjKsYF/sbh6pNJbjh7x9hJTfZnwcpEOULy5A/MWywtAVejNIeUQ9tJqnBjcxPdRWMjVkI4nj1jE5e6fms6qWilo6647Ranrgp0d/VLCU1IwcS/JjPKWqoYpc5ugeTv896neaAAJxq1kBWKTeGqy9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745927906; c=relaxed/simple;
	bh=RdGM4G4/He74pUJAOxTHPaAFLaZm0mOulMu9glTXjX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=niJQpZ/pc3yqt8BL6mlt/mTjvdNk8uvhCLzVQl2Ry+WdP1DHmJe4xRiJuGvXKPUDjodXRm0Ut16grkeJ0phPONGClemNXLFZzb0I/WRmsEjQnslDQyGX2lMm4SK1ZQrNuJ2sB3exomZb1uEdT6DhTZcBROSQEZmO0JCYoKUUQoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kD6NZul7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Dl0d2nwr; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kD6NZul7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Dl0d2nwr"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745927904; x=1777463904;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RdGM4G4/He74pUJAOxTHPaAFLaZm0mOulMu9glTXjX8=;
  b=kD6NZul7PwnUAcj7GvG59qSOlS3RMgKI/K38dnFGZwEDRVXJDNKpb7cN
   nqcJPuxwDv0yEIH1Qiw7CtGMAN15DnUbZv3/d6kbq6h+rMuhHyMRzUDjH
   fZziVEdC0OT2KgXzX0DfUyMWeytts++WrOjk4VEW14Y7lZ3gfokPI8y2z
   rpBt8lieejCfURrF8l105iiwh/UMxxVLqr9LS+aQi3Dxp+WP4IXnNQI8e
   E5Yg/JCLtwY/CwAX3zMgMAm6qhWQHpcoPjiSweG43a11m61ojVsZZ2yfv
   vGI7b5MNufaiQu8oOG6DEKM8q+cSCuQIrzK8vW7Q+PFyuV7oDV+aXSQcT
   g==;
X-CSE-ConnectionGUID: pTUnWs1cQ3ixNTg8zR9ODQ==
X-CSE-MsgGUID: QXH+mB6zSkuyeu4RxaCOug==
X-IronPort-AV: E=Sophos;i="6.15,249,1739808000"; 
   d="scan'208";a="82773867"
Received: from mail-westusazlp17012039.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.39])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2025 19:58:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ib/b3L62T8lXr8wXW8swnQvmm2j7anBx+qOn8jZX7QUheOeZTE2NXN4s+QEcpwjBEfsDeQl7xkQTTiJGS+GE9ypfbOXd0h3E2wny3fJQDy7hkrVnhPaRZ3EQOfUwQZowRdm11wp7Ime4ckHSAfGfDXfi1xqiS++X4T1qB3qxUmBMk4NDeE+Mgfhnaimq3Grwf7sXjECO7Nrkg9FwVDTQu2TtliG/jOcmD7aUc5+i4tnXiTEoibcSC5C/RWtLcgj6LTf1kvR9nLaGc5lootCEg7Lo5juc+oMpLP3vIvF1v+sH07fujMG0eRMLUlKsM9TNHCoIoDl4eNeBmqPbIr5llA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdGM4G4/He74pUJAOxTHPaAFLaZm0mOulMu9glTXjX8=;
 b=i8ZPl+E6uzyky8YQa90sAJI2leGT4iBKBhez6yHjtzv1gAlQuYvyBwdtFwPGevMew7wqId7PhmbXVX/XXorzBtdjznvDrAnq7ZIdJAAi54U9nwRAXRYs16aAHqQKVUAMu1GuYLQc2fKB4tJD1WpUn6hZUnFWvQteyrJY1+Zbaoo2sXw/dbMelieAdy3GRqf2fvh5uBjbf6vyJHtS1T/mD/TL4Cu0D/ijtmsxnjrbkrJfe42c2a7bwqgWg4m+WB0nCZZd4dDB+ypMal3P1mx4VqS3nH89zI3jsezyy1aSjmXqIquMICPqCdLpx9JFhBuLlgh4WU0oug3O3LJ0b0gycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdGM4G4/He74pUJAOxTHPaAFLaZm0mOulMu9glTXjX8=;
 b=Dl0d2nwr7fhlTIHtkGyb2vB+q53IPRXxNITWOkX5k+O3wMqE9ppT3Ph57MUwd1gh5dIBTFXkIsm0NyIQtmzUI9tDcL3nEZ4BnR8X7idMCcZrmlbDPcuqU14z4WxpYrXDfN2ycgXL7VAuNHjxSnj6rJWxLeA7g5dTOPcmeBvR/QY=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CYYPR04MB8812.namprd04.prod.outlook.com (2603:10b6:930:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 11:58:21 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 11:58:21 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
	<djwong@kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Topic: [PATCH] xfs: allow ro mounts if rtdev or logdev are read-only
Thread-Index: AQHbtb9ugJyGk1wFU0SBquvCoobacLO42u4AgAAhTgCAABHEgIAAAsAAgAF/woA=
Date: Tue, 29 Apr 2025 11:58:21 +0000
Message-ID: <833d77f7-87c9-4e58-8d26-864dd86c2ada@wdc.com>
References:
 <M6FcYEJbADh29bAOdxfu6Qm-ktiyMPYZw39bsvsx-RJNJsTgTMpoahi2HA9UAqfEH9ueyBk3Kry5vydrxmxWrA==@protonmail.internalid>
 <20250425085217.9189-1-hans.holmberg@wdc.com>
 <iboil7qz4s76y53wlwvpnu2diypdv5bdryoqwhlh4duat5dtj2@lkptlw2z3pdq>
 <C4tcpc9KgtT1pkGmrFcEWdwZcHpOiA2vViIipXnQqeVEHXsRPRXdmhAyyFhgljCydyMMbHO_qeL3wgFD3FVEng==@protonmail.internalid>
 <8d4aa088-e59e-46bc-bc75-60eff2d49f4a@wdc.com>
 <rld7gaksnhm5r2dn65v2cxct3wtqvokbhxnw2zh6betey4jblc@6dvgavf47zle>
 <20250428130450.GB29270@lst.de>
In-Reply-To: <20250428130450.GB29270@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CYYPR04MB8812:EE_
x-ms-office365-filtering-correlation-id: bc3ebd06-bd00-4670-609d-08dd8715235f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?b2V6VENpTG15cW1IYkUzVDRDZFFJeDNNYi9kdWo1VjVtRUhVYjhGYmEwSFU4?=
 =?utf-8?B?ZkMxZTVwK0lRN2FFdlh3R2FFbHMxV3pyWWhQanZmTTJ4NlNHa3dRYlBWb3BQ?=
 =?utf-8?B?d0xMTzZvZnZnOWowQWxYenh3QjVzazNhUWRqOUNpd2FtcWFIV1Y3dzZCd3FB?=
 =?utf-8?B?VVU0VncvSmRqczR1REhwSktJM1h3MzFKUE51MVRJZFpUUjJDeERCaVJVZTFE?=
 =?utf-8?B?M0FzbHBLMWpCUFVEeGhSVHpwRlIxNjRETjNGWk44aUlLRVhNQ3JFN29DS2Z3?=
 =?utf-8?B?U0dlMHpORmZINy9FTlJuamZkNjZadWhDMjlvUlcxeFdOZmZ2b0ZzQmw3Tmh3?=
 =?utf-8?B?Ykg0bFlGa1A5T2JOTDlNTWw1ZVR4d2VCRmszT3FPd2Q3bDBVWUVyRk9yTkxt?=
 =?utf-8?B?L1N5a3hkdFpKQWZ1eHBSWGIybmMxZk5adTlSaE94WWxuOTR6OWxVd2pFVFY2?=
 =?utf-8?B?OXFFeU5sbjNMbmwycFFPUVNhOVFvUWcwTWc0bkJ0bHhDMnZBaEtmTWJlcGk5?=
 =?utf-8?B?djNGdE5hSzdIM2plVjJ1UUo5Z3AxR3J0eW1EVGM2QnNPWENOcXU4Y1RtY2E0?=
 =?utf-8?B?N1Q1UWdrYnhtdFRTdHFtZzNDdGhjRUxVUGNDSU1VNmU3VE9YQ3QyQTBzekZ4?=
 =?utf-8?B?N1JCemQxUjIwaHRhQkI3WHhhR3pnTmo0QjA4UFNXbFBZMnZLa0Y0NDFyd0Jn?=
 =?utf-8?B?V1hyS3BVQ25tcjIvelJQam9uOHdnL2wyZ1hjL0VqTitUeTF5czVJdThoTzBC?=
 =?utf-8?B?K1piS2ZXUWRxY1RnNDNHN3BWQ1RHRVZzczJIVmUvUHFwT0d0WUVXZ21lRnor?=
 =?utf-8?B?aFd3Uk1tR1NFNGwrNUEvVHJjSlBMRHVUVFFZQVVyR1YwYlRreU4xTHYvaFJa?=
 =?utf-8?B?em5JejduTGhNRUhqQnFaMlNGSzV0VVduSXdUaVJBSCtqT3ZDZ0JZYXZkSUNL?=
 =?utf-8?B?TFZJM2tBeFozaFpNd2RPZUZxYXJOMFRnaFVMdkpPWlJidEQxdVFra1lxcG1o?=
 =?utf-8?B?aHNCSDE0bWUvWnpnNDF1OU9aUzFuL0FPMHpLWllUTU0vWkcxR0s2M1doTEhn?=
 =?utf-8?B?YzFIWG8weitQUjBKQktKTmIveXF5aDRYSUlRRkFwalg2dmVhVC8wT2VJaUtj?=
 =?utf-8?B?elN4RDBSOVV4akcyUmkreHQxWnY1dElGREc0bEtGUjN5YkVhZWt3bXVSVEV1?=
 =?utf-8?B?M3k1QVRHanJrTFR5c2xGZlNSS3hrZFU5UlRlZERYYzdFRUNaSnBmK1hJRG90?=
 =?utf-8?B?bGFlUWNRdkVhMjlPZnVXZ3BsYzJxcEVwRmlhbGVreXZRLzhncHNrWmZZdnVZ?=
 =?utf-8?B?Rk9ORmIxVzI0bUtCSGVSM2JMVUdxY0lHRm4vNTliL21zaGdneTV0cnJ1cTZU?=
 =?utf-8?B?WXFJNFBkZEhmR2wwUGlobFBXc3BmUW1GMkxMOWgxMmtENVFDOVJZa2hQOXc1?=
 =?utf-8?B?b1Q4Y0NQMWZyYXlIeWtzU3pzWHZZV0JESFVVV2R1ZWtrWHlPdTJFY21LT3pu?=
 =?utf-8?B?Z1lZeXZBS0NtZ0k4c0JSb2dtRjJkZlJhbnowRlV6MHVQV0IxbTdXTHlRYWVM?=
 =?utf-8?B?djk2SVpzb3V5NXRLekRDbGlJME9PRlpzaXFFdFFOSm16bWo1d0ZCQkRnNnJN?=
 =?utf-8?B?aHpvZHRMbUhjdXdudEEwSlhKVWpGWnI2TXk4RkpjakZVUTZUd2pTRXNNZHJm?=
 =?utf-8?B?MWtsWkxrYWdvelFmNXVEUUhkMlhLUzdRQmlULyt0aThGUVVXMjEyTGJaVTBP?=
 =?utf-8?B?WU82c0RTVWl3WHd4QzVNUm4yZUFBc3RkMytqOUtXTUhkbHBYL1BSNDZjUjZo?=
 =?utf-8?B?cTlVRjlpd01USU5YYmxialpneWswZkJnMDd4ejZ0dWtDOFJETE8yMVlkWnkw?=
 =?utf-8?B?TDJhWjhWSURUUVlNdHRnS2NZaFgvQjJSYzlpMXNiQ3J2MitscTAyQnNoa3dK?=
 =?utf-8?B?bWd4b0hBbUJsR1UxM0RpaCtBR3hEb1BWN2V6aGZiNUhxTmQ4TytZYk5lRHFG?=
 =?utf-8?Q?SaUKoCSyQ5nxGmfESN/MBxuaG7zIRU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bDViSGZocFlaRFR5bHhaNWdwc3hURE9EQ3lvelRsWnpjamRhekpxU3VKN0Jh?=
 =?utf-8?B?UGRNbndPaE1adi82aC9QY3J2dW8vckVzMEw1aTVBT2loRzFWaGtGWmkyQ1RZ?=
 =?utf-8?B?QkNNR3gzelU5SEI5Tkx1UHlncDl6bXRSWVZnVmdVY1BsL3lIcHlDMm5NWTFJ?=
 =?utf-8?B?cHpFenV6S2FFN0F0M2U3WGxWNmFyY2NRZmdseXlIUTV4VGJ5bFBEOU9pMVhQ?=
 =?utf-8?B?ZGEyU0VNZjlSNzNlZkRMUzRFMVJiei9QUFFIMDdiUjl0Nm1VL3dyYXBmRGlV?=
 =?utf-8?B?Q1ljMnJBSGp4RGtickM0eFVZWkNGZEcyby84WExZVWl1OG1FNzRFOXhxUUtK?=
 =?utf-8?B?ZWtXWUd6eW4xdGQ1TXlxTTd4Z2JXVGFUQXlnL2ZiT3kzeThUTnduY3JNc3Az?=
 =?utf-8?B?ODI1bnZOM3NNQ2JpUXhwNDhKMlVwVk1zdU1qaHNVTkZ3b0lpcjNCK0lKRkFr?=
 =?utf-8?B?cHVwVGpzQm82dzRmVzNRMmdSbkRyb2VBd0hENGVMSVEreml3UHNvbHFzN3RQ?=
 =?utf-8?B?V25hV0ZSL0V3ZERQTG9qeEpwN3gzRlpBekl5a3B1S09DMGdnUGMzSDNXSCt1?=
 =?utf-8?B?aHgwL0d3bnJUVDU4OTRnOUc4d3YveldJMDU3LzdFMi9sUko3OVA3Ui9laEJx?=
 =?utf-8?B?Z2p6dEpSSXVJaEFSSmd1dEVjcUR4d3NBcWpVb2FWLzA5STM2MU9pOUJOMktz?=
 =?utf-8?B?L2xDRzh5cnVVelg1akY0eE9GV2ZweGU3RFBwd3JubGMxekNwU2hTUXdMTVVT?=
 =?utf-8?B?NWpoQzExcktQNWtKazNmZUJJWEhUcEh5cS9hU0pkOS9LY0EreXUzL1ZOcDNv?=
 =?utf-8?B?KzN4K2hucVVGTVdUU2VsUThXRWY1ZUpwbWVsNlhEN013QXE1QXJjbmcwYVh4?=
 =?utf-8?B?b3hHZi9HZDgrTm1hYnZOMzIxa3J4dVI1UC9nMElmZUN4T1pnNWF6SlpWaWJ0?=
 =?utf-8?B?ZkZ6M2RBd09TWGs3dkhKS3U3Q25Sc3lidTQ3V1J1ZGNmVi85TmI4eEs4b2Jl?=
 =?utf-8?B?Vzg3Zk44czVYeHZ4RjFNOUUrRkZsaUlDVm01TnhmUWxURko0MUFZZXZ0dlNq?=
 =?utf-8?B?blNDOGY1T2xmS2hkdFhvNkhlK1pCNU1ncnZsWHNzNUZ1eSt4ZW82WnI2ajhZ?=
 =?utf-8?B?ZG5CQ3hoSVUyQXhQVGw4Mi8xSXhtRFBMVkptOGJURTVoa0txMFppTmtxUGxp?=
 =?utf-8?B?N3hPZmpOcWpXa3VEVzl1QXVxUW85UHY3Z050MFFTTGx6VER3TEV2eitianBw?=
 =?utf-8?B?MXduRU9qUmpIa2pzeHV2K1hKaEJiYlBSaUN2S3RtTGsxTnJDTFRlYitNMUtW?=
 =?utf-8?B?Wm1wb09NUUJTK2s4OXR5dnVWcFJCV0E0V3FaYWkvTjVsM1VwdHhraWIwNFNS?=
 =?utf-8?B?c3JQcjA4d3YvSThtWWZRR0g2Z3owejNITkVQUU9EQ2JGRlQvMWdtbHlPbllH?=
 =?utf-8?B?ZDk2aGxZLzVqWkszTWc2RWNqZEd6OWl1UzI4U29sRmFLY1FlUUhRVGJoeGNU?=
 =?utf-8?B?bGx1NkgwNXNjcU1uRlFKbGNFU2J1VXNjTXFYbHcrUnY4R0FMbktra0wwVmhD?=
 =?utf-8?B?b2hWZGVsNUZlMHJFVkhacTh3OFpjOVdyQzB0azZQN29TSFdXUlp3cVByRVd2?=
 =?utf-8?B?b2Q5em8raW9KU0kvd2NmSG5wdzZrSlFRZ1NzTHVjdWNKQ2JNaXJuNkkzU2Qx?=
 =?utf-8?B?cUtmbysvUnhJZ1NreWd3dFZML2YwdWk3cnQvRCtYS0p2cVZhUWZqSk1Wa2FI?=
 =?utf-8?B?OUpyNzFLSXF2eUtETXoyZ1BrMWhQWmg1NjRMeElvRU9VdDRkRnVPbm16ejJJ?=
 =?utf-8?B?OTJQQmxIZnVqZWY4MXNCTmlHTnBJRTV3TlNTQUZFM3VxT2FsUHF5QVlIZjdF?=
 =?utf-8?B?QmppNWNmZjVMNzJHbTVCQUR6Zm02NmxJc1p0WDNhWHhOUDdWOUwyMmsrbmNm?=
 =?utf-8?B?VzVJMDB5VnZnL0cyUVM1WGx4Y1hnbFJpSDBBTXJoR2c4NE5UTGhEVmNQUVk2?=
 =?utf-8?B?eWdTVnFqZjk1VUhvMCtOcUdWZmRUNTB6ZXgvQmIwbHZtcTRQYXRHWVF5SE5H?=
 =?utf-8?B?bHVJMGdBTER3cWJvN21VcVMyUFp6dGRpdloyb0ZRc2liaFpaWE5xT0VqVEsv?=
 =?utf-8?B?Rzk2NG1MM3lIUDdIZzAreXpiMzhnRlN3aXFqV2xhOGFkcGEvdW1naWMvQVQx?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A102912A58471D4AA49329248A5474AE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YXrPHSV0eJxbCmKlcrk/5nWG2/5L3nJsQagN555XvZ2jiRD97WU7yPpEj25e0aTnDUH21C72kuYfbH/nZpDWhGg75Zlf2Qna1rCjtDQgw3abEMg9qPg0wkxLeYDZcDxJx6z+zRV+KGbI/9xgkH8bdt/9L+2jos+kMbmOkdMY6WaAhLB27h3Y/0xNeljpiCxEnKeCE3zQH7+jJ3gRvFHEwGCxs/4UpuRfIlKAJLP+FTXdv6L23nnUD9Em/x3nt9lVzkvhLV6qdyKtZJjPtKvbNFOb06F9tpVM/lOEuljAsUCcWVkFkCksPZ14HHVSzddcOOOa0uyCsa31Z/yC3uyF1t/BILEd3IznlteFXi/+uq5/pJAuUvOIpBlrkc/wEkhGtwW0hIGNSywH+S1cdOlmUYF1jJbOZJ3u3qH3BrHm7LuUmcBAgV7ObtqHxYzJoHHmd75zDmuiESEOakz2mSVU8LubZhJ06zU5FsdLk3QjSvcjLynH4BQ81LwcBu8DMlpjrQwZE2LAWRkN9X7n5xYFkEXdKm1YpHX0vuiqF7mhC3lYpVvZsddUHRAUwg2gS3S8flO9EFGsXotdMgFxx+skQtqKAYAqYnTY09ETCbDwsX2M60bDLjZIPfBbbISZQ72e
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3ebd06-bd00-4670-609d-08dd8715235f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2025 11:58:21.3945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xFV/PecxQkTpBw8NaEdDN5cAyggnrZoyO46LXmHmZuWHZ4i+dZkLAxcjUZUMODt1NjosES5ri5ZkHZwmt4LeUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8812

T24gMjgvMDQvMjAyNSAxNTowNSwgaGNoIHdyb3RlOg0KPiBPbiBNb24sIEFwciAyOCwgMjAyNSBh
dCAwMjo1NDo1OVBNICswMjAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6DQo+Pj4gQkxLX09QRU5f
UkVTVFJJQ1RfV1JJVEVTIGRpc2FsbG93cyBvdGhlciB3cml0ZXJzIHRvIG1vdW50ZWQgZGV2cywg
YW5kIEkNCj4+PiBwcmVzdW1lIHdlIHdhbnQgdGhpcyBmb3IgcmVhZC1vbmx5IG1vdW50cyBhcyB3
ZWxsPw0KPj4NCj4+IFRoYW5rcywgaXQgd2Fzbid0IHJlYWxseSBjbGVhciB0byBtZSB3aGF0IHRo
ZSBwdXJwb3NlIG9mIFJFU1RSSUNUX1dSSVRFUyB3YXMsDQo+PiB0aGFua3MgZm9yIHRoZSBjbGFy
aWZpY2F0aW9uLCB0aGlzIGxvb2tzIGdvb2QgdG8gbWU6DQo+IA0KPiBJdCBhbHNvIG1hc3RjaGVz
IHdoYXQgbW9zdCBvdGhlciBmaWxlIHN5c3RlbXMgYXJlIGRvaW5nIGJ5IHVzaW5nIHRoZQ0KPiBz
Yl9vcGVuX21vZGUgaGVscGVyLiAgVGhpbmtpbmcgYWJvdXQgdGh0IHdlIHNob3VsZCBwcm9iYWJs
eSB1c2UgaXQgYXMNCj4gd2VsbCBhcyB0aGUgc3VwZXJibG9jayBpcyBhdmFpbGFibGUgaW4gbXAt
Pm1fc3VwZXIgaGVyZS4NCj4gDQo+IA0KDQpZZWFoLCBzYl9vcGVuX21vZGUgZG9lcyB3aGF0IHdl
IHdhbnQgc28gaSdsbCB1c2UgdGhhdCBpbiBhIFYyLA0K
