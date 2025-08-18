Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE52B31E0F8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 13:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522448; cv=fail; b=uROA2B5HjNQA+c9t73M5L3dcvns9alvcW1Ymm6gVqbSpwpY0PZAoaqJIoF4b1yJRJu9XzRQgPOZMoe2grsWS2uo4G+aS/qgnLnOAiauGp+Af8nCmLqnPPhtPtoS6GN//fCIREfSGD4zh8kMmdsGzM5vra3zl/SQmL26txXZVK4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522448; c=relaxed/simple;
	bh=M3ny7V8rrg3hyoDoyBqm8e+vZC+4PeKJmYnutDh6/x4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jO3jwfB2hN8aHI9PfYCPKEhpL9siDp5IxekWs3gI8Z7B7L0iANyj/WYCAHuIGiQqi4yH6cm9/OozZVfSRz/cGCvmVuPSbxcxj2kjMjEGJ36dvw7cg5ID8gb1gL4/XT8gZScWwbIen1MNK69oz7vD7Ajoy1BEjlqOsiR/TA2Cneg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TYbVdc+o; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=A1HBA0Va; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TYbVdc+o";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="A1HBA0Va"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1755522446; x=1787058446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M3ny7V8rrg3hyoDoyBqm8e+vZC+4PeKJmYnutDh6/x4=;
  b=TYbVdc+otzFIzzGxTOTQJaO28yRHN1wQ2gueS5PJSPj5H9d4s0jHndC6
   ApTua/pVmy1XgvJGnMw77Xz4f/cnwoBh4T66Y31+DNffjJVaQNUllmsVx
   qa3JD/BdXhgCgRzfEyi8qYFsTXO6ReLRMghLob70Ua6gdcacauqPEj1Ha
   XtyjwVRRIFOrBNgRO9diKNuAh53yquL03o20I+uPP2DaZe7ep7sVQvyT3
   JOp5lId8wFxnLt242kzds62FqIjUNOGkHxbchvVbpHDWZrybPX33UIW7V
   VKrT43UoMTZam93Z73Aq0QXzM973Il07FmRQIQBGysdi/Q8wzEobsSq6r
   g==;
X-CSE-ConnectionGUID: +BDf9yccQHWGYtxrHPUJhg==
X-CSE-MsgGUID: BXwDUcApTIywl3+KRMRkJQ==
X-IronPort-AV: E=Sophos;i="6.17,293,1747670400"; 
   d="scan'208";a="105137847"
Received: from mail-bn1nam02on2057.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([40.107.212.57])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2025 21:06:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYx87zvfrPASqUsGAeRI12xfhEXopMDj2AXXkyh3pKuJ6j5xR5kTALJhVSSFj6N0ehrYsnl5M/4bo7ZWljrvSzBwLM1T04YBZKgGq7/CjKeQ174C/c4aUxptR+b8H5mNWjqOh7NGnVHeX2NZ/v4hL4r8HXrGthlp4ymHCdI9LFf7h4eUJdgnOzks49Qjr1V3y38exutrTrJq/pe92+Vxj2ZRUL6/EKTyTskuc3fka/h93ZjCqN34i0Rxe9HyHJZfjKn6P7c1wPH1MF5NCwgLAuVPAnztdTK6by+oSsGGABIJq26q7KGbQdxy8tCVChmHe9qvNr8h53EShat9jajlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3ny7V8rrg3hyoDoyBqm8e+vZC+4PeKJmYnutDh6/x4=;
 b=gfDj9EXGVFp2aJc4RMK5V02QVSt5EHHt7JWvcu6hXRNLMmlvuGbGS8cm+s+bDCQt7ULf/74WiJjoknGefeD2lP6RB5Yzmw8zXZ3iKdOQyVqCKq8vhlM8D4Ga+V/6CjwmpQHlNVkxfLj0JwFKfHcRjUm/lcxYPiGyg0/b7jTgfUDkWtMsTr5naONFDBA/uSiItXvxfLf4mzrRoVj75zyVpl7rxsER+2tTHNCSfX1ABTpB+Fh0VjzHe8ZMflE1ttKvYW63hZJzkLUnfgk/6SqPAKUuhUrZxRfUP99tLWBptQ3sfHdRxGVZq8Tvjvqo/4ohyWmnFdQA2XN7Pj0NL37upQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3ny7V8rrg3hyoDoyBqm8e+vZC+4PeKJmYnutDh6/x4=;
 b=A1HBA0Va5WcYv5dx6J6k32uF0UfYF8whwa0LQneZjgUs0xd99HckPK5qBtxz2pTzARzrLwJdnb0FLZm8f6Ugem19xioK+0pxEF8nbh6/yF8oY9ZwCAiz8EpMUFrse1WdV5a/xvrJL225wKU/uHE2SzXOVX8BoDuofyTqH4bRKP0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BN0PR04MB7984.namprd04.prod.outlook.com (2603:10b6:408:157::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:06:16 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:06:16 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: reject swapon for inodes on a zoned file system
 earlier
Thread-Topic: [PATCH 3/3] xfs: reject swapon for inodes on a zoned file system
 earlier
Thread-Index: AQHcD/4E/MgXUvCM4E2ghCFoBYxfOrRoYcYA
Date: Mon, 18 Aug 2025 13:06:16 +0000
Message-ID: <f3edf33b-b2b5-4b8f-aa48-3b2b868a9e77@wdc.com>
References: <20250818050716.1485521-1-hch@lst.de>
 <20250818050716.1485521-4-hch@lst.de>
In-Reply-To: <20250818050716.1485521-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BN0PR04MB7984:EE_
x-ms-office365-filtering-correlation-id: babd639a-663e-4cbc-0e80-08ddde58044d
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MmFIMVQwcUdDZVNhdkl2eEo0TzhXdHhQMm9IYnpyazVBZGltUXNCckdpd1NW?=
 =?utf-8?B?Ris4OVZlcmdYRkdkczIxaEIyelIwRkQrVFh4MWNKbURDbUczUCtld1pkYXM0?=
 =?utf-8?B?OW9rNEt4dEN6ME5RdHBoTGc5dFJpL0RMQ090cWNPNmUvOVpQY2hNbVM1YUwx?=
 =?utf-8?B?djJBYVJXdjU4ckFTZ1lMZU5zMlg4SVBiT1d1N0J1d1JlcmFjRDBkODBma3Iy?=
 =?utf-8?B?YzIxUVVGL3FJYkJScmJHL2E1RFAxV2Z1Z3NvM1YraDQvcEJjWUlEU2MzeHJ1?=
 =?utf-8?B?bTNGY0NBeWs3SzJ5QnhSdVpmTVczSUZoc0hpYTlSa1QzSGlLcXdTRHZzMHpu?=
 =?utf-8?B?THpLaThvNEZhamZRRnI4bzdtMDh5R2VXK3VMR3FxZ2JxM2tBa0g3Ti9xZ0Zh?=
 =?utf-8?B?dW1pVnJERSt4RVQ2SkVsNGx3a1JMQ2dUK2M1ajRkdEcwZWExeVVDWXVFWW5M?=
 =?utf-8?B?c2NFNFE5TDFTZGFCeFBzdkdYYmtMRFlvU0VSNEVPa0V4K1o2cHVIR0FiQ1Ir?=
 =?utf-8?B?U2lVSjRBTFcyS1hxeTkzR3ZBWERvTkY3YlNybm52UE5kWUZLRnNnMjhEcGY4?=
 =?utf-8?B?Z1VBc2hQK1pDS1lxV1ZVcmFCM2hFdVdRQWZnRmlPOE42bjl3MFM4OFE3WE51?=
 =?utf-8?B?N2xXUHVqcTI0R2pYMDBiTlVvQTh2emNoTU5oL0d0MTJoWDA5blNORUhYTHdW?=
 =?utf-8?B?YWpvMmRtL3ZnZm4xbkRrWERVVUVPN1kybjRES0lVdy9ZejVXNnVHdU1YaExD?=
 =?utf-8?B?VWZlUjdUdmZiQ3R5TDVyK2g0K3BPU05EMHN5Q0MrOTRvLzJGWWpyTlZFbUll?=
 =?utf-8?B?UUx6UE90RDA1UE5nYitJMDI5UlNyZG9mRklrb3QwU3hOYzdrUGtKTzJ4R1pa?=
 =?utf-8?B?STU4NFBTT1M3TG15UmF0aysyK2VudmpYTllEMVZyd3NxY3dFdTVVcEZaVWQw?=
 =?utf-8?B?a1cxZEh1QWI1OTVyL0NNUXkwMlVrS0hsbU1TNjVLbjJRek1sUzNyRGQvTmtE?=
 =?utf-8?B?OWlUbzJMOW1HN0hZZlB0enVMTWI5clBWdXZFTmtJdUdoN0pnbGtYUFlveENB?=
 =?utf-8?B?RTZLazlsZ25ob1ZQd042NVl1dUJJSUtSN3hkYmVrRHkvWTY0RE5GOWxPanVN?=
 =?utf-8?B?aWN2V0tUZVl6aXFWamdyeURCaHFjdXE3MElRbGxaeFdubVRBWkJDN1JnNTE2?=
 =?utf-8?B?a2tBMmhvM1Awd2JBQXhXTDBZMTRBWHNsUERPNThvT1lsTDkvNzRiZ0NLNjk1?=
 =?utf-8?B?OFU0K2tuQ2t1YVU3RFdXb0Q4dUNqQ3JFNlptYzh2ckU1MDFFUmxJb1RPbHRS?=
 =?utf-8?B?c0lCNUQwMlJUc3ord0hrWmZCV1NoNzN0eGkxeEhqS3lKVzhOQ2FYSmtnUEFh?=
 =?utf-8?B?WmorMm1pWkVDdmVYUkFJZmQ2WlJQeWVUUEJqV2MrdkF0SlRvZ2IrMTN3Uko3?=
 =?utf-8?B?UjcxZEo0SStUOWd6bEhubHpMMUtJaEtzYU5HMWxmSHZwVUsxc2FuQ1BDU05N?=
 =?utf-8?B?b1l3djBpQUlxZmNMYndkK0lBcVJTWXNkcUhReTdPZ3hpMGtRYUJOL09DeWJH?=
 =?utf-8?B?SUNZQU44bzc3b0FtKzQreThmQk5WaGFqRFdQZXZONjZWSk1BTFdORFdaeUZw?=
 =?utf-8?B?bjA1eEpOM1l0MHF4V002V3g2TUNrWTYzM1hDUElWU2t4UzQ3YnpiZTRQSWV6?=
 =?utf-8?B?R0NQT3VZOW10MlJQODRMbU1Fb2wyUThXR3JMQXVwbGdxVUNRTFBPUEhJNG1m?=
 =?utf-8?B?NjFKbUhYUkdsRzdEbHlOOWxIMk8rRTdIVEJVUlM0RUUwcTRNMHB2TDFoWnJS?=
 =?utf-8?B?U1lYUElRWGVOUWI3OEV0a2pLVFpEOFhqa3d4QUJ5NjU5bWVKU2xuZkhWRnNM?=
 =?utf-8?B?aG95TkkxY1BDNWZ3c25mL1JRd3Z1WGhwRTZKL1ZQTGRKQ0lwL0ZDcC83cW9E?=
 =?utf-8?B?LzAzWHJOZ1p4dkFsK2NsN0R6VERZY01Ca0V4aElZcCtKTGdxeWJMM1prNnJQ?=
 =?utf-8?B?RXUyOTA2T1hnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ek0vWERXeDB2Q0V6aVV6OXBYMDhOOC8wMVNsczBXWjV4VU1jMXB1WTRXV2cz?=
 =?utf-8?B?Uk9PcllFMm9teGVTS1c2eW1iSW1aN1hsZ2dESC9zcFQ3V2lUdjcyY2E1dW5o?=
 =?utf-8?B?SWppM1l2Z1NabDV1bDYrNjl2MXdnNllUcTVlaHhac2dWbzU1T2M0YXN3MGFt?=
 =?utf-8?B?OVJZZEhoM3ZaeWdFcTFTWmZBODhEZVZxMFl5WXpCd2JCbEhtMWNhcGRwVFcx?=
 =?utf-8?B?YXA3dXZCN2tlOGQvZk9LSUlQSzZEbkZHWEFBWmpteTFPSzRUbXlvOFB3eUVF?=
 =?utf-8?B?aWRtZUJxRUIwRXJVSndUa3NxYkhCbTRPdGdRakI2SkdEZ2FibVBvaVlrSy81?=
 =?utf-8?B?TVFDcWo5NGV1YlVuS2VhUmNjcDRJRGVxVHRJU0ZUNllMdVFzZ0NkYk96V2o5?=
 =?utf-8?B?aHp2a0sxZE1pUzhPWGl5OXZJNE5lUWYvM2t4Qk9ySHNlM3ExNW01bTlvS3pH?=
 =?utf-8?B?ZG8rVWs2b0EvWWRLb1FKS2lhNTc4S21FU0kvWTc4T0c3NDhPTE5aN045NDY0?=
 =?utf-8?B?U3ZYZFhpOUxycDJVZ1dPR0dpNEFjZ01BMkM1anlvUmRod2o4WVIwcHBFanRZ?=
 =?utf-8?B?K2t2MmdrVkNIaGxKRmQrVTZDeDczUzJtdGFtbXpnK1FBSW14OUdSVE56MFBp?=
 =?utf-8?B?NEVXTnJHOFd2eWtIeFE0U29obzFFWG8xQmJkR2lUSjZaNkF2Ullock9TK3J0?=
 =?utf-8?B?TWRTT1JpVmpLSW45QWhaNHd3dTZGa2pOTmhkYUYrUHVPN1pJNExxUTV2OEt1?=
 =?utf-8?B?MHR4bVNkbTZieUh3K1plNU9yT1RHemp4UG55dFp3MVZkblJUQ2N2UlNkMlRK?=
 =?utf-8?B?eG51RGhLUkxJYzRsSUdVL3FNRUFrM25uSUYyenIvK0RMaWlCN3FPMGhuT0d4?=
 =?utf-8?B?bXZVUDJndkszdWx0bThJY2xZUFZZdGo3alRIZWw0dWRxWlZsNEFsaVdSbFpJ?=
 =?utf-8?B?dW1nMVR6R2luY2dZV2RsV0ZnOHd0SlZEaUFsR29PaXNvbjlOWFIzNHNZWW5o?=
 =?utf-8?B?dzNLcGxHaE9hOVNUbXdEdFA1ME5KZEpVdEplN1BPZkwxa3AyS1NvaHpySnUw?=
 =?utf-8?B?VEJVRGtGS2U3SmhUTEVJQkgrWVNCbm95T1hxdU1zK2x2enFTRmdHUFhHOXY4?=
 =?utf-8?B?cG1nTTNQb3lnWWJjRlY1K20vT2pkWitsS0I1RDdkdzljYlUvbWJNZnh1MEZj?=
 =?utf-8?B?bVAwT2s2d2lEa3YrZy9ZRzd6dEFiOWFzdFVJbS9BUWF5Tmp4ejdLMGdkQ3Jk?=
 =?utf-8?B?Z213Z0dqSFVPN1dpREZoWlpDTVkrQ2RDWjRHS05BQ1o0Q21RaFQrMVBkaVJT?=
 =?utf-8?B?bHBtREpFM1J5Q1BlQjdZRHBSOXl0UlhmL3BSTW1GKzV2U0M3cUdWOHN5dnJT?=
 =?utf-8?B?THk0SFNyZ3R6YUd5a3I2MDdjNWxSRUZOQkJLS3FmVC9JWmxZOTE2NTlwcnN0?=
 =?utf-8?B?SjFDYW5LcG1wZysydlZlakxMdzJnbGVtRzlmQU05MVFFUXZ5K0wyYk9PaE9a?=
 =?utf-8?B?OEtCQU9OTmFzdFlaTnBIUlFFWFNmMzIrbkVvTExESVA2eVFWZVVnS2YzRFBs?=
 =?utf-8?B?WHB6UTJhVTY3bjNRY0pQd3VKc0toOXN6NFh3ZUhVUURCRjhZRmdGMWlyelht?=
 =?utf-8?B?OGpaZXUyZFQ4VjQxN25WWkdPQmZoZVNvOXNqaDdxelZwbHNsQW5Hc0pzRW1O?=
 =?utf-8?B?OFdvVmF0c205aWdXUlphdFV2Y3NVVGkzK2VZUnJNalBvMlpFdXJPMXd4dGQ1?=
 =?utf-8?B?cURGTlVMVVhXVWxQUHpRQmlPNFlxZ24vUVFvWlpzaGkxMDZDUFRBdnlJN0Q3?=
 =?utf-8?B?d0lxZy9rUUcwU1ZnZno2Vy9RL1ozN2hDUXluMWVZRVZnRUluSUViVnhTQ28y?=
 =?utf-8?B?ZVRxQVlwTXZQa1N4Z2prNnY3YWdoNHlFTUtQM0lZU2JQRjFvWjlIVndESTEy?=
 =?utf-8?B?QWdiWVFNRXg3NC9NalBlZlQ4QzB0OHVZRUIwQ052d3hvcU1GS3RHWGI0OFZl?=
 =?utf-8?B?bDMwb3ZkTWFubEZYOWpKcjcrQ081Ym5WNjAxUnFsMEwzNVVmUjY1ZmM0Q0Iw?=
 =?utf-8?B?NENuaHJUeUhXblFDMENjNHZ6V3FTOFc3dDA1Y0NITkRDV1VsdDJIK1B5RFpX?=
 =?utf-8?B?dkdVNDVLdGl0L1o2T0lSaDQ5VFhyWklnTWhSTHNUZU8rbmlSTXZkSi9iUkNy?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7BCAAAFE05FAB4DB4A1E2138D167934@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CHyq9lXCrNut2PhajeU6twY6vuWAkLdG+OSDjOjwoXALFRFTwKufQnuADStykth9Ey8Q++ublz5XiMeL1gxbOJwtire4BiOKIR940u9WILwSmMdb6Q0cMh78Q+mEBWY8HNhH3xGjRDFcRoMQsef2FiQaRuL4Fn8u0xTwDlyHBWQ33ymoEPPxktJQMmfOmE8+QaXu9KwXkZqvvR/YwkftUvRGLN7wK5lQQoNUIyf8LtsCOQcBIdf04JB+dzBG65Mnc7D7ojTAua9TljCkiTjZvmtDGwLgzpof47KCXSFIAaLilt0wH4ysA0gU1qQebgFtHpjQmF9dFyrYe0F1LzaNoQL1qfRM9/BX3NEyem3TQfN5zEycoPOayp/OQPihhRimUOWKXmJne+LRv7V2Qw+cyicAPQ7R1q5DgRjm6OY5McEKdYR5Tv0DR0Vs+iLEBrL9ymDLY4Ny+iGgv3NnV6EAhJutj6TpZ0dyfExiphoBzDCGuYWZrviSjo0m25BIgINSN5OSMTiwxzhkrYKwlSWmIZjo8Lm3bAx06UbWhd0UrO/0CDBAWhZqHcXHgg593xT/hwnbLHHP5voPKGd6zgOzCWiK7ADsrd12viMhcz9sQrCmEHqFUMtVlnYMVPK4Lw/z
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: babd639a-663e-4cbc-0e80-08ddde58044d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 13:06:16.6920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fipMYNMT9Q5RaWjxE4FzJikLLua/gdAZS7qb/NBm6HWGqvZxtXmyH5eSEadGo43ms4/QYyJgZ2YafIeXieTvuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7984

T24gMTgvMDgvMjAyNSAwNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE5vIHBvaW50
IGluIGdvaW5nIGRvd24gaW50byB0aGUgaW9tYXAgbWFwcGluZyBsb29wIHdoZW4gd2Uga25vd24g
aXQNCj4gd2lsbCBiZSByZWplY3RlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfYW9wcy5jIHwgMyArKysN
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX2FvcHMuYyBiL2ZzL3hmcy94ZnNfYW9wcy5jDQo+IGluZGV4IDFlZTRmODM1YWMz
Yy4uYTI2Zjc5ODE1NTMzIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX2FvcHMuYw0KPiArKysg
Yi9mcy94ZnMveGZzX2FvcHMuYw0KPiBAQCAtNzYwLDYgKzc2MCw5IEBAIHhmc192bV9zd2FwX2Fj
dGl2YXRlKA0KPiAgew0KPiAgCXN0cnVjdCB4ZnNfaW5vZGUJCSppcCA9IFhGU19JKGZpbGVfaW5v
ZGUoc3dhcF9maWxlKSk7DQo+ICANCj4gKwlpZiAoeGZzX2lzX3pvbmVkX2lub2RlKGlwKSkNCj4g
KwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4gIAkvKg0KPiAgCSAqIFN3YXAgZmlsZSBhY3RpdmF0
aW9uIGNhbiByYWNlIGFnYWluc3QgY29uY3VycmVudCBzaGFyZWQgZXh0ZW50DQo+ICAJICogcmVt
b3ZhbCBpbiBmaWxlcyB0aGF0IGhhdmUgYmVlbiBjbG9uZWQuICBJZiB0aGlzIGhhcHBlbnMsDQoN
Ckxvb2tzIGdvb2QgdG8gbWUuDQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhv
bG1iZXJnQHdkYy5jb20+DQo=
