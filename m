Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3961A9F82;
	Fri, 21 Nov 2025 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714105; cv=fail; b=elicp5nRSbqVtBtpqcXMVNHl/B2Yc13kvfUfpHU69gtDv8fcvmSYp16ypLWhXxVJAJ8yQN1ZSe0PIpyopzXa6rOwA66y9qfanLYN7IE1KMwPy6ofQ9Q7s6gXj7brn8goYadkdTt020MGicfwbOhC1MUIpVG6JXF22hJOQwKPO+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714105; c=relaxed/simple;
	bh=WnvUZ7jztwWkjIouO7BPJYkA0nUeKaS+pgZD08mFYzI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p16bVt53jpmeZYOzO9u4z+qNZUcYm4X6jjOzN22JKnUe9Z3usFwYAx+Ag78a+89Z7sECfjYcNZB7h26wyALTmmGzwMRagmLZLmmdJusc9wrjVHOTQ/E2jBwflukpWgU9KL0bWG/+b1d4mP8c4ypax6twu5vy46UuARz/GPJrVC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QNF8tujE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XhMPKjWJ; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QNF8tujE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XhMPKjWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763714102; x=1795250102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WnvUZ7jztwWkjIouO7BPJYkA0nUeKaS+pgZD08mFYzI=;
  b=QNF8tujEDCdIpxfd5UmCGptpKJjy6nSv0JKKkjFTsyvVHiTT/4brcHMb
   O58XeXAEQV1rqDAP7qGT1wnq9g2t3xIcQgOa7QW8Adadk2qlF3GIThbTM
   Ad1Gnc4gzijHfQmMPcMeaAeVrU2TiBp9yQxVKd+YvwAuOp9XFmqU2WX7M
   HdbneKea0eFfHhJXlUcoEWflhmGDtLKVPz/GlJDIsfIJRxg6tIDLCNzEm
   jDQQ8/eh4dsmeLTKzNXzIefEFkUcBVAQEHGLk66BUopji/Ha4NCe/r/pM
   B/sLAUMunuUM5hnDtu9beAZwyhaHe61j0Ukuydk5zO5T3qq8LuI7VicF6
   w==;
X-CSE-ConnectionGUID: 7gsQIxiVRvunwTq94v1uCg==
X-CSE-MsgGUID: qLXNDPa/QaK8J2i5exF+Qw==
X-IronPort-AV: E=Sophos;i="6.20,215,1758556800"; 
   d="scan'208";a="135530355"
Received: from mail-westus3azon11010039.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.39])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2025 16:35:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hB5Cno/zv3M9Iw73umXmE8TGUYZ96H7+1jlohlWJx/V57l9XvpUGkY1KhscZFBOpHiZIWfQMrrgRG1GLYDPq8cxUo/x9qxnMUUF/5w59v4YhxvDLIW0Y3u2NF+3+zFA03qN8E7Fr96gq9vD4lIafWYc/VmCdJUx43x9pfGOyI3npzyMGrnDpPZ4X4wWtPrE9xn/rphYOx10RHubTqlDsoEOu/atT8iZIgQKvv5UDCBE6Gx3jyaNOkmNczV2gZWZSurMKUhjvr1Rlda46DU7QTI2/KCO87au4C2LjWnHE3v41wQRjN8UwjrFZQDmBt7VRvHrTgzhcL7lBhwkgActG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnvUZ7jztwWkjIouO7BPJYkA0nUeKaS+pgZD08mFYzI=;
 b=QkfvRSCafDGwfzKeqy8IRfqQiQSAm1mhMh6b2gh4Yt+3TRm01OSUj+uep0Aclyr5rYnXlUVEOZ9TU1pw/BCrMmdQXVqxAkoAMT9iG9reyLoRdvk/q+DU8P5Uk8J8zUzXL+ikK5wgpN8lrebyfxAHTCQ7jY16jv5/sQKn6uu1KLS/+jpF51P4S1PLVeVO6J042lBQGGrQgrXemrkoD4CT/Wh3V0nRl+sS46wNSABLMHc9db4nrpWFjm86u8txuwq/LTqGg0ehlqFtX+xvzLr3TEyRt3VLiq78wZfT97fMelqtCri+bWAPA9FEW7i9btUXErIhTwuv3gpeApu92rZXfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnvUZ7jztwWkjIouO7BPJYkA0nUeKaS+pgZD08mFYzI=;
 b=XhMPKjWJRyxgZ9uWP8ym9s2wGZZiTBVRtOod2ZxtDiFOVUjrzRTKx7FLcuzcwrJT/XQDcBnrQcNq9/kFRsfeXn6g3QPWhMZgtJcBEQJtol/5cYnI3D84rjO/QmWgkQsvdTG6CXL6qI/an/R93V9WSMY2DPGdwLulc0w2KCkGr0s=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BN0PR04MB8094.namprd04.prod.outlook.com (2603:10b6:408:15d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 08:35:00 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 08:34:59 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, hch <hch@lst.de>, Bart
 Van Assche <bvanassche@acm.org>
CC: "cem@kernel.org" <cem@kernel.org>, "zlang@kernel.org" <zlang@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Topic: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Index: AQHcWjgQJLXRFf6HIEWT0vfrFRwAaLT8shiAgAABoQCAAAC/gIAAGomA
Date: Fri, 21 Nov 2025 08:34:59 +0000
Message-ID: <3f8e892b-5c73-462d-8860-73f7ce003491@wdc.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
 <20251121065720.GC29613@lst.de>
 <01e8e0a0-9d4f-4df2-8da0-08b69662564c@wdc.com>
In-Reply-To: <01e8e0a0-9d4f-4df2-8da0-08b69662564c@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BN0PR04MB8094:EE_
x-ms-office365-filtering-correlation-id: 80b069e9-bc1c-407a-d50c-08de28d8dbc4
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z3R1NVE0Y2IveEc2VU9ZZDNSWnh0M25LZHA3N1R1V29BSy9zVVdHaWduR0h4?=
 =?utf-8?B?NVo3Z3BtcTZGVG5oREdwdm94T2N5Mnp6Y3dvZ3JFbStBZWVWaXQ3dU55Tk0x?=
 =?utf-8?B?MktGcTAxb2pUV01uMm9jbE1NRnJSSEpCTnJ3V2hWQ2VLczYxT1loZmlxZmF0?=
 =?utf-8?B?WVBnelRQKy9tbGZ4YTZNWUFHQ1dOMGMvYW95Tmh6Y3c3clRpRUh1U3ZwWGpk?=
 =?utf-8?B?djdsRXJLcDhLc1Y4blkvOXFjRFdQK1pvcmRwSFEzTlR5Q3dJbFZSNDVNNTVq?=
 =?utf-8?B?RGJMUE10cWEyTi9qdTc1YXVUZnVLTmY2NXIxOEp6TXE3VC9ZZ2w5MUVucktK?=
 =?utf-8?B?NC9HU29yczhhdERsVGtrWjRzeittd1N2TFI2M091ZTh5NUJtSXBUckg1dTBT?=
 =?utf-8?B?M0haWkoxb2tHWWlQazhJa0hqbkN2UDVhNzE0RllmYTBMYjR3K290QzNhOCta?=
 =?utf-8?B?aEpyS09CQkc5Z3UxeFhsR0tjeXVKRlZxK3Q4bTNYcnRHNmRBTElpLyt3N1VB?=
 =?utf-8?B?QmhsMUhWaXlZT3ZIalY4cHg3ZUJld1crYUt5T0g3eXZGTG5ubnI1NlZYK29h?=
 =?utf-8?B?djB2TEpVZXRhVmN2MHJvT2tYZmFzYzFhcjI2ZHp1RFhqTjNGcFYwMm1SRGVF?=
 =?utf-8?B?NGhSWW5adEVia2ZDeUJmN0ZkbEwwb1dtNGdwMHBxRUo3NWNGQ2FmRnhIRHpo?=
 =?utf-8?B?RFN4ZmVjdUxFM20wdWJHY3FPenFnSmljckl0YTBNRENuNGZ0WDNPdGZ1UzBy?=
 =?utf-8?B?N2RYbFhjdFg0V3NOUU9tRjJyblFWU2ZQMW9YcytrdmtKNWxiMEVrY093b214?=
 =?utf-8?B?MVNZWG1ySzBVdjloLzdKSmJEWmtaSWh5R0IvSU8rUUM4d0crNzVzV2s2Rncw?=
 =?utf-8?B?VGhLYXpuT2lSRlRZN1VCalpxSXhRa29zYXdzWDFMNFNLZENpZkpqcjZmS24y?=
 =?utf-8?B?Y1JMaDBBOGwvN0Vac2cxSGxpU3p4eHFSYVhYRGkzdnNZYm9jWHNCS2szRnBU?=
 =?utf-8?B?SVAySno1NGgwck9lYk5aVnFDbTJyQlpyV2VsdUk0a28zOXpMSDAzbnNlRTJi?=
 =?utf-8?B?SllmL2hFQUZGWDVMQjBxZW8yRVZTcDRzNFVQZC9qaUE2SVhsbzdETUphV2Rx?=
 =?utf-8?B?NlozL1duRlE3UGZuekFTa1IzWmJ2ZDNQVVNFR1dzWHpwd29vZ0ZOSkRiZGdP?=
 =?utf-8?B?cjRzNDg5end5WXF5YU8zanFxcnRQRVEzeE1hdlpJRzV4QmptN0pHYkJuTWYx?=
 =?utf-8?B?RGJNUW41N3gvOHlPblVMUE9VQzRwNHQ3aTdQam1HamkwR2lWQ0xRdzEwMHlD?=
 =?utf-8?B?dzNPOVdpZkF1VStTNEdyWU1hbWExS2xqSzVFZExvaVphTjkzSjRjeXpQL3Rl?=
 =?utf-8?B?M2NBL1dhS2M2TE5aMHZ4bnBuSmp3VktLLyt5Q3FBNitPbURpM1puNXlvTFhi?=
 =?utf-8?B?UG1Zekg3RFBJM2VNSThoMHJxTHdPd0tKTllqdHFYQ1U2RzVXRGR4RUFuenA1?=
 =?utf-8?B?R1o3Ky8rd2M5WWdPNVdJak1oRUhkRk40MGFVZkpTaklncUdvSzNsYmtKNGFG?=
 =?utf-8?B?aVNCT0VTTlM4dDBHYUJBS1IvZHhEVEIvcWZvUmVtdTBlTDVuUGsrWk15aFZh?=
 =?utf-8?B?SkEyMFgwZURiN1VLYkoxWWdJRlVFMHNPV0NneE9lQ0ZKT1F6WENtS0tqN3lU?=
 =?utf-8?B?REZEUU5Jd3gzWW1xK1AvWTFjRWxDQmZuS2szbXpPWm1MZjExQ3NIcDRKRjJo?=
 =?utf-8?B?bTJlSVZDayt3THRmd1hhVzNBcldTYzdDdmt6UDZFamtnU3RCNUxRQjFwM1Y1?=
 =?utf-8?B?WDJMcVhKanVnVjdZbWZONW9CYzFrRlhOUGdGMkJLbVhWSHdBOTh2dWFLazRV?=
 =?utf-8?B?OGp0UnV4bFVDRjJLQlJJTmpxbk15NW1MUFNXd3R4WmxuUzBGQllVNFd5N1Yx?=
 =?utf-8?B?ZmVhUzVneXpsdEhNcUx4eEZTMUtCNTgxRDk1eDdTUEJwbjd2MjZPUm10Qys5?=
 =?utf-8?B?cXhlUXZEWW1ONWRBWWN6Q2ZWS0xzaHorU2RPYnRTZDJ4Z3pCdUxqN0lTNjBz?=
 =?utf-8?Q?G7B2M5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d2t0RWwxTEVlMU9HSkhpVTcwMXltbjdSb3YrRU4yTlhNUjhmWk5WdlpJRVp2?=
 =?utf-8?B?aFdES24wc2JVRFpkb2VWdG56VmEzZ1dLYVhGUjJRdzNCTWprd25BVGVGM1JI?=
 =?utf-8?B?WkxqZEY4UzhoTUIxbkpUMktjRHVqQ25EcGFUMGdsdWtrcE9RaEFaWEc1ckt5?=
 =?utf-8?B?alB4OVgvc3dhUW9xTHBObUV2VkNYeVNVRTE1RnBUOC9ybnp3UmIvNGJxN1R1?=
 =?utf-8?B?blpjQitXM3NmWEliY1pwZGtoT3QwTXdyZVRCVi9xN2h0ZUo5ZzZCUDM5S3JW?=
 =?utf-8?B?ZDJjSWxiSWdWQUIwbkFWMEJ6NzducnNqSzI0SXk0di9ESUN3aEUwYjZ4VTZ4?=
 =?utf-8?B?ekptWVp4d1Z1a3B0bWRFaEZESC9VWEV1QWRTMGlqUFlnZkFnbjdIYlpTSnhK?=
 =?utf-8?B?U1pJTEVNWGh3c0lWSGJtR2pNRmxaRzFsa01mU0lhNWpjSjV2aDhQbUFGSGRa?=
 =?utf-8?B?SnE4SjE5RjVoQjZ4T3haVXM0ZjdxM0g4VFN4dzFMQWtraTJKcnZPWUJ3cjJp?=
 =?utf-8?B?dmx2QUJNQWUxSnhpaVZEUVp2K01wYUU5bVBZVW1nSVBxM2NQbzFXN1gwcGgy?=
 =?utf-8?B?dTk1a2ZrbGh0RllRa2lzWFRHK2MyTFN5VzJ3UlhaOXNTTFF3OUhwWHkwSHkw?=
 =?utf-8?B?ZXV4dGRaMHJuVXFBRlJlQVpzbkJxb25DY3FjV3pBRjhDRzB6T0xlV25sMEJ0?=
 =?utf-8?B?ZUpRVGMzRndMQWF6aW5GVGFSb253RjFOUUNkVU5qWEpWSFQwUDZMb2VhQkYy?=
 =?utf-8?B?MThka2R5a0NYSnlqVnNRVXoxbkN0VnNuakFhcUtkTEdoL2ZHZVVSQzNpaFZR?=
 =?utf-8?B?Y0IrdjBOOUFDYVVzL2FYbmxHTndaSUU1cGEwcFU1MDA1UnR2NlUzaStTcjA5?=
 =?utf-8?B?aXJRamFsVUZHUFlrM25Pd01xUVZjT3I2YmdyVTQxMjJTQ2c4ek1LUlNpYWRW?=
 =?utf-8?B?alNFb2dYUXlUeHIvTFpwZXJZNEUwMnJCMklSN2JxUnhkSm8xSDBMTDF4cHVw?=
 =?utf-8?B?QWZWRndVMmRpdTEyTnkzR0wyeldzWVVXbmlXUExMRG1USmhJbzFTVDJTai9a?=
 =?utf-8?B?NlRKUjVpem1Cc2tZVXBTOVZQUjd4czloRUsvbEpXWXpLZUYvTjV5U09OY0VO?=
 =?utf-8?B?R0p2UDgxNU05MUxCM1ZlK2dERHFIWHZBTk0yaGZNbFo1L1JxM2I0bHd1aWx5?=
 =?utf-8?B?WjJycUh0WmZLT1d6OXBySzdiWVNCT0JuV0kyN2czV1pBcnZ4UGZGdXJzcVFl?=
 =?utf-8?B?R21CbDM4eUpReTBNbFlPM1pYWVc0U1lObWpNaE5ZSFNMaDh1dnU5eHRTd1lV?=
 =?utf-8?B?VURMeDZaS2ZLcURpK1ZpM251ZGNOL0dRMkl4aEhLUkVSTGdmdkhkZkQweW85?=
 =?utf-8?B?cjBtODJidVdPYWorbklYVThkTTNaV3VWZnhBWnBtNXJudi9WN1B2eXhBa1Rs?=
 =?utf-8?B?NG9YOWkwRGF4WVU5TmFVQUJkQzdSSkUyV0p3cC9kZ2pvZzd5MXk0WTU0VWdT?=
 =?utf-8?B?cGQyaFJ4Y2MyZUsxTjlBNjM0ajZtcHhnQ2RDdGthbDIxR05rOXVyUFo2ZGdp?=
 =?utf-8?B?TTBsZGFtT1kzSG1pSnFIaVBOM3JlRVd6TXNwSm4wN3I4dUlIVnlTemNWWDZQ?=
 =?utf-8?B?ZWdVbWNmSytTQ2FDSUdzNk1QWXVZeWdzT0tzL3JWL3dpd2t5bXFKRnNqbzlY?=
 =?utf-8?B?aGJvVmdFSnV6NDk1WlRoUnhQL3NVVXp2UkZWUmM4dExBZUZtME9OS0ppSmVY?=
 =?utf-8?B?c3NuMGJSSHlVTXBZQktweXU1NSttN1RRMnNiRVZEMVV3T3FrNVhoNng4OWFM?=
 =?utf-8?B?ZDJBdlhrSHRZUnhXRHIzU3lETS84a2JnTngxNWc1ZHhCUk1SOGVxQ3VqSE5B?=
 =?utf-8?B?UEtlZ3l5OERrbXpGZHlCTUcrVkNwV1ZsWnI2c2FFeVZQVkNoTE9qTlgxbFBh?=
 =?utf-8?B?b3A1aFRKamhiRmZqNkhYV1hJaHdzekswRzlVOTdXdlRab051RVBxY1M0OHYy?=
 =?utf-8?B?UGIvZHVkMW54dURhdGtrVEYzakt2ak9BOUprbkRkOVB2ZXVnUythZFlxRWF1?=
 =?utf-8?B?SStGcHdiUEJEcENHbUJxNTgyMS9YRjZnZGxadWRTdlNYQzVGVEdCaDVRUHoz?=
 =?utf-8?B?UVl6cmtiTm51eS90ajJTWnhVdGRQNjA3TDFIT3NWQVFuK0NPNkh4QTJmeFRD?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F34CC4CE27C44C49ABF2906E148698C1@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cd52A+CcjFJCBM0Z4BsW5tCDSnQ2iWW8Qu3g3PtEcVGn4K3oiBfGmkXuWOenyNXD/tu+zDycmComLcBbF0aHbup7vKpKeX1sTRvU8bSeRMAVnwIJ1SSgk9mC/9pAYJrhQT+9v+5JNJheNQlXEzpZif54xou52OCutjf0lBF1NJYgn/qE9JXcTYWKsWxKg714J4Wbp6pSnlDkd6EGeHU3r+fqEll4OFmhNHfDtxuGf97XqhALoPddOQ7m3KmYtr33hbh6s5e1TATr59m8aizYSN4jjG8AeWQZudku2CM2mR0BR6cN2/tH8yhVlbpFMcjp59CDZBTcS/UAkENnbJldkPek749Y2rOhW7Krdd5gPsKatY23x0NXxV4hulGtX17N5GE7sUyPbYp5WoePIS8L7lZFpNCT9gl8R3nsqEQwnsnwSFSkcJMhRnabPmzr7MGXpLnvEH/RL+UD0jRFGcpDlBWnPzvtNXh2OAOfr6lYyQ7uankWC2cZH3GCPantRRdsVl7n4iEd3Frno8FpKKrZv1aOoJ9vnVaAmCfmKBXkoK0kAzcxwJNBfm2Gjqq1ChmwX4oGqFftVJcQSECYsS6v+TD2W9b5vaC5iOWLGZP4jTI2YOym41RYqxxwj2CsDzKL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b069e9-bc1c-407a-d50c-08de28d8dbc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 08:34:59.7772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CzPpZQS30AMu8vFuUEuap57Bh6QeClkL9rwESwv590mTfr76XdK97vN5caMxWaIgWvTYEpznBwoJdswupyr5cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8094

T24gMjEvMTEvMjAyNSAwODowMCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPiBPbiAxMS8y
MS8yNSA3OjU3IEFNLCBoY2ggd3JvdGU6DQo+PiBPbiBGcmksIE5vdiAyMSwgMjAyNSBhdCAwNjo1
MTozMUFNICswMDAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+Pj4gT24gMTEvMjAvMjUg
NTowOSBQTSwgY2VtQGtlcm5lbC5vcmcgd3JvdGU6DQo+Pj4+IEZyb206IENhcmxvcyBNYWlvbGlu
byA8Y2VtQGtlcm5lbC5vcmc+DQo+Pj4+DQo+Pj4+IEFkZCBhIHJlZ3Jlc3Npb24gdGVzdCBmb3Ig
aW5pdGlhbGl6aW5nIHpvbmVkIGJsb2NrIGRldmljZXMgd2l0aA0KPj4+PiBzZXF1ZW50aWFsIHpv
bmVzIHdpdGggYSBjYXBhY2l0eSBzbWFsbGVyIHRoYW4gdGhlIGNvbnZlbnRpb25hbA0KPj4+PiB6
b25lcyBjYXBhY2l0eS4NCj4+Pg0KPj4+IEhpIENhcmxvcywNCj4+Pg0KPj4+IFR3byBxdWljayBx
dWVzdGlvbnM6DQo+Pj4NCj4+PiAxKSBJcyB0aGVyZSBhIHNwZWNpZmljIHJlYXNvbiB0aGlzIGlz
IGEgeGZzIG9ubHkgdGVzdD8gSSB0aGluayBjaGVja2luZw0KPj4+IHRoaXMgb24gYnRyZnMgYW5k
IGYyZnMgd291bGQgbWFrZSBzZW5zZSBhcyB3ZWxsLCBsaWtlIHdpdGggZ2VuZXJpYy83ODEuDQo+
PiBEaWRuJ3QgZjJmcyBkcm9wIHpvbmVfY2FwYWNpdHkgPCB6b25lX3NpemUgc3VwcG9ydCBiZWNh
dXNlIHRoZXkgb25seQ0KPj4gY2FyZSBhYm91dCB0aGVpciBhbmRyb2lkIG91dCBvZiB0cmVlIHVz
ZSBjYXNlPw0KPj4NCj4+IEJ1dCBvdGhlcndpc2UgSSdkIGFncmVlLg0KPj4NCj4gVGhhdCBvbmUg
SSBhY3R1YWxseSBkb24ndCBrbm93DQo+IA0KPiANCisgQmFydA0KDQpJJ3ZlIGJlZW4gYmVuY2ht
YXJraW5nIGYyZnMgd2l0aCB6b25lIGNhcGFjaXR5IDwgem9uZSBzaXplIGxhdGVseSBvbiBTU0QN
CmRldmljZXMsIHNvIGknZCBiZSBzdXJwcmlzZWQgaWYgdGhhdCBoYXMgc3RvcHBlZCB3b3JraW5n
IChidXQgdGhhdCByZXF1aXJlcw0KYSBzZXBhcmF0ZSBibG9ja2RldiBmb3IgbWV0YWRhdGEgKGUu
Zy4gYSBzZXBhcmF0ZSBuYW1lIHNwYWNlKQ0KDQpTaW5nbGUtem9uZWQtZGV2aWNlIGYyZnMgZmls
ZSBzeXN0ZW1zIGFsc28gd29ya3M6DQoNCm1rZnMuZjJmcyAtbSAvZGV2Lzxob3N0IG1hbmFnZWQg
c21yIGRpc2s+IA0KKGJ1dCB0aGF0IGhhcyB6b25lX3NpemU9PWNvbmVfY2FwYWNpdHkpDQoNCi4u
c28gaSB0aGluayB0aGlzIHNob3VsZCBiZSBhcHBsaWNhYmxlIGZvciBmMmZzIGFzIHdlbGwNCg0K
DQoNCg0KDQo=
