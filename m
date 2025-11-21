Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC182BE7C0;
	Fri, 21 Nov 2025 07:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763708409; cv=fail; b=MzaUxyJyblmS2fiN5BfvzckLmbR32JxgBodQAu+0YwPAVNYiMCHkchATFP2slXaRic8xPT2cY7EPyU3hQpXdFhVYRXxU3qu3saw7s1MHLfXkn6TyUKSgFvkXbS42TYYxnkFuwe4oFrvliV64BhREv31DeV/AJHxU7AGVZEISTb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763708409; c=relaxed/simple;
	bh=QWg89TdlBY56C8gVknA2/YRsS4oUns6gZhLZ8f99nAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V8Ygk/+XS0SxspAo+tXfdl2jG2jdK3qYYwsEWa09zWRxfhaB4TlJfU4rafTAPbm+KAGcEp3vwEjO5exKMAjDvUsFSBDzInathFohPhrrxjcHjaYmv+3D6W0NkFSCkwoQzqJdwYV+XqPcUcmIkYceZ4VRJqe5UGd/Td3iSjlMHVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PwsVRmq6; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=FrI4viBU; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PwsVRmq6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="FrI4viBU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1763708408; x=1795244408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QWg89TdlBY56C8gVknA2/YRsS4oUns6gZhLZ8f99nAA=;
  b=PwsVRmq6lIjX6NTOfY0zIWw/UXNGOwd36bLL2H8CMRuKYEYziDuoR40M
   D9mtRrn09t30M4WRdIo15nBbq4foZf5urNMU3nUe7RmR4t9CKD27GoD/M
   aqNxlV6GFw/fb6Usf+akXC69nhhnr6zRvjdzX8dYvvwHzg00mNXlfWCl4
   JPbRkZW1wD+jDkGi/vA5HPDx9+HNOen0Uwq0aRMc+K0ZzEmxU5Ci5vqtK
   P8sK/HdfmK27olzi3URpGwLTG3zYtuklNYiDPPe3Aj974d52hzAHx9noh
   m+/2nIYdAzTImG4ZgAlHon2rwoZUbQ8kuYbEW0jnpD5kgRGsbHq25IN6h
   w==;
X-CSE-ConnectionGUID: +qxiEOqfR56GhijsKoxDzA==
X-CSE-MsgGUID: uSJnzKToS9SjtVs7j2DqPQ==
X-IronPort-AV: E=Sophos;i="6.20,215,1758556800"; 
   d="scan'208";a="135135908"
Received: from mail-southcentralusazon11013011.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.11])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2025 15:00:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jpDaSHXdzk9Uad6aHUe2NLWCiQY3qj9gfL0k6xnRHURapVeuTujYNb48hvffXLMpGGyDZnwHmkpXMfenxp8Ws7Cg2ul0/j+bjX6nauC5TsBagGGmyVjspPcgqRk16D9N2FIPVFMD1o5rK1fRAeJEiosfIz6BQ7OS3sBgfICahD+H56V3k+UxJ5nZaKVuioABLY4/7RNPTbIMj3VhEpdFb6UW5XgGoW4n1wA3ddl7qRTcjsd7t5GajSLpps1OV8z7hl/qUetdVAsBWQBPE1VR78D8wE6inO3xZb4lkju+Bdy3B9NUP/NryqKotElLirS/ZcrjtyJk05271AyU3O4OUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWg89TdlBY56C8gVknA2/YRsS4oUns6gZhLZ8f99nAA=;
 b=YTyAwvsW3jP8vC4lbf6YsEnL7zNc4Fm9uyRvO7e9xK+oezGaiHeE60mPYkJ3VD56ghmg8smKkHUOug7sDGPRfhk3sQitrUQi8Bn+il9DfKg3GfzwkI3OKEaMg9ITKQyRo8QRdiSwAp4JQh2uJk12ChpB729lMkCDlCuPKxjNZJZYOQuxW9vY7M4hqpwzeF6Hi+8g+YLNkH6+8PNDInNl9wkZrPO8m1nujJg2IgMZPnhhBR1BwG+5fk8i+mQJp2+XyXoCouUoJDe1RqoPjutt+c0q7P7ejsx0+hechWDA1CB0BbWPb8Yw7I2bTY2Lavtat9OMJLITNfIquaJ2eYkXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWg89TdlBY56C8gVknA2/YRsS4oUns6gZhLZ8f99nAA=;
 b=FrI4viBUBFtXG5ZVxLndZf+2U/cnWg1BeVoWktD+hC3DOZIOKWhqZ3CLsW+WxETatCy5Aq4Calwk8vRRXe2582NAQlthBJQHVXUn/w7o/o63yaqElxGM+oPNkemQpQRM8MlPJ/HcMIOO7yvFxDzwWPRMQkSG5KPvr3bKAAF5m64=
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com (2603:10b6:610:d8::5)
 by BN0PR04MB8192.namprd04.prod.outlook.com (2603:10b6:408:144::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 07:00:01 +0000
Received: from CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71]) by CH0SPR01MB0001.namprd04.prod.outlook.com
 ([fe80::1425:795e:ebac:cf71%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 07:00:01 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>
CC: "cem@kernel.org" <cem@kernel.org>, "zlang@kernel.org" <zlang@kernel.org>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Topic: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Thread-Index: AQHcWjgQoqh4EHp59kCIrlcKzfAjxrT8shiAgAABoQCAAAC/gA==
Date: Fri, 21 Nov 2025 07:00:01 +0000
Message-ID: <01e8e0a0-9d4f-4df2-8da0-08b69662564c@wdc.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
 <20251121065720.GC29613@lst.de>
In-Reply-To: <20251121065720.GC29613@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0SPR01MB0001:EE_|BN0PR04MB8192:EE_
x-ms-office365-filtering-correlation-id: 55464268-aa6a-4c05-6b83-08de28cb9751
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ajVNcGxJOEJvNUtCaVJYZ3BzSHNKNXQwcUROSXpUc0FXczNtUTc2UWFvZkN6?=
 =?utf-8?B?N0VWTEVzeTJKMXd3NWxNcnBuNldpRGNnTkFUUUhXbmhDZzg2TjYrTjNPM0N4?=
 =?utf-8?B?dlF6cjA0SEl2cWdRZ2RjSjJpN1VrQjdZOHh4eFREZVcxcS9Lb3dVeVNhY3lz?=
 =?utf-8?B?T3VOMGh5OUVmbzdta1hnalYzZzVKRTdJYlcrbi85THVTd05VV0hYcmw4RXF4?=
 =?utf-8?B?eGQ3eEhvb1BYRDdQenY5QmFjd0VtTXBSamNidjRsYWd5aGNsTGt1V1pLb2xk?=
 =?utf-8?B?RE5IVi9OY2krYW96OGZ2NExWcFNBNmJSMitZM09EMjQ2ZlJoRTBsMXcrVS9i?=
 =?utf-8?B?L2hlaVRWS2tmTFpyazFZTEFJcGwrZ0dUUEptMUZ5TllNM3I1OC9MOHdNNnZ3?=
 =?utf-8?B?NkV4OGl3d3dhNnNKZWV0NFpmNW92OU05dnhXWk1PWTFRUi9mendYOEZBekhq?=
 =?utf-8?B?MHpHQkFzWUZPRm5yWkVDc09jQjAweG1KdXhxMG50SE5ab3kzdThIZkx0Q1VO?=
 =?utf-8?B?UTJ1bitIZXB4N2VycHpvRDdRVjM3T1ZjSkJPM0lINXZFNlRRY1VjUHpGOHcz?=
 =?utf-8?B?Z0lPa0xjS1NmL1VvUWZSRnEwOVZOS3d3K1VkRzdDZzFDeEo1MmlEL0Yva2pM?=
 =?utf-8?B?c3ZuUGo4U0hWQ2l0QU9ESm54TmkyWlRha1NqZTZvZnRPbTgyQ2dvZ0lxUExQ?=
 =?utf-8?B?aVoyVWpMUHB1SEM3MFhzakU1UTZCaFlIbG96bHBScStDR3JXSkl6cDd2T082?=
 =?utf-8?B?bzliRENNR3AyQW10Wk56UmNHc0Z2QkNXV0pwS0JPL3cxVFZXT1lINkFsNjA2?=
 =?utf-8?B?cXdUT1pYT0ozL0FFeHRGNVFaVVNLN3N1dFk4WVllb1orVzE5c1QwejNsc1h1?=
 =?utf-8?B?M1FjSDlZT3Q0dWJUN1J0TlBxWEM4VzlpQXdud2VTTXo0UFp0WTI2VkRSK1JD?=
 =?utf-8?B?MUxMeVhScEZHQ2pDNDZDcE5YVzY0c1lmMmRSSktVdVdWbS9LUDJCRzUzVWRE?=
 =?utf-8?B?c2VQK2pNNFBpdFFxcDVMZy9jK2ZRMUkwcStHL0xDNDZaVEtnay9wQ0VqamUy?=
 =?utf-8?B?UWcwQUN1TngwY1BqOGRtRGQzbUhVeHA1anF1MmhRZmpFQVJ5UDdxdFh1VHJL?=
 =?utf-8?B?NDJQK0NNNkV3VmgxRUE5Q2RIWDlqY290TUcrUll0ZldBQlh4UTcwU3pnQ1VF?=
 =?utf-8?B?T2U3b2pCN1RYeWdIRE9xRlU1c2lvaXVEMFVmU2VCWDhjZFMxR2hRTHhiZVFh?=
 =?utf-8?B?eTFMbzl4WmdDU0hiMU9nWldkamIxS0l0K0ozVjVLNU1tTjlsdWhaanlYaUlk?=
 =?utf-8?B?MVlaR2o1TmE0TFR1bm5CRWM2TksrOUdJajVHUGR6c3hmcFIrTEh6MWZaVnpi?=
 =?utf-8?B?aDBTVVE4amdvZDZtYWNDNUNhNVA4enZQWWhLOWtwL2tNaHFZUERNaHVDRmtX?=
 =?utf-8?B?QUM2RDdVUGhPdkd1RUlBNGZXek0yVEdydVZyaFhtVnUxZy9WcTh6OUpJVW1y?=
 =?utf-8?B?OGdjOWZGM3dpelAxUzFNeHdTNW45SndSTjlSNHBKR1JUaGVNQldUQzNnN1Z5?=
 =?utf-8?B?WGI4QlA4c1pPakhlYmp2OFdwSmFDajlQVjZ1SGtVWUluamJxb1JWM3BlcFNC?=
 =?utf-8?B?ZDZKYm1NSzU5Y0MzejNQbHRCUi91K0dMZnZtSUFhdEFnYnBnMXAxQlpSc3JR?=
 =?utf-8?B?Qmt1Tm9VcGlOOGR1UjBZeVF5eVJLVW5qVnpiSU5ablYrTENaM2U3V1AzV05p?=
 =?utf-8?B?ZGZpS2d2S3JXTGcwOFdGQmNMZ3p2a2dhcWtXN1hzZ0FFaHkvRGpITVo3WFZz?=
 =?utf-8?B?NkNDSG1aYXA0SmdzaVlXVUhiMGNLR0pwOWJySzRGUE9Xb0ZIQ2hyY1NjNVVz?=
 =?utf-8?B?MVJpVzRwZTVFaWdRYnAyUitFSmlnQ2x2Sm51UnFqV3FBaUJyZmhKZjVQdkQr?=
 =?utf-8?B?dGlBQnZtTk1CcGdORHhuTFJEMUVnYkhocEVXbjdzNmFCcTR1VS9acy9obVNm?=
 =?utf-8?B?MFVwbzh1QnZOUHVHRWpJTDJ4ZFFvb243Vit4VGR5Q1J3cDFXZFNpTnJNWDYv?=
 =?utf-8?Q?BdCt1J?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0SPR01MB0001.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?amNkcjErOWw3emtyMzdCaWFIU0NqTFBUYXJHbmhPOGxmNVljUlI0aFBlRG5R?=
 =?utf-8?B?M09DdWZjb3Jna01yazZwK01BY2c2alg4RE1rakV0dCtnWVVJeFZNWGRHY3Zw?=
 =?utf-8?B?Tk9NR2ppNWQ0TXV5bTlleUprWmNkUmJXWFRMWkx5UHJGOG9hTzBLNXhWVHFp?=
 =?utf-8?B?WGZlV0RtMHdYdGMyWXhZYXBZMjh1aWZUaGpKVUNseGVDUDRaMlppU29Qd2JU?=
 =?utf-8?B?NXNadWkvQ2VEWFp0aGt2ZkYzYkFUcTN0LzUwUjRSK1J3WWp2L1RYRDE5WHBP?=
 =?utf-8?B?RVV6ZnNPUndLSnhiYzhmb1JKU3pGNy85L3BObkRWekVucGE5QWdIbUtBT3c0?=
 =?utf-8?B?UGNDcnhYcW1aT2ovWDFQM2ltb2c2cVdnMjFCN015a01WYklBZEpKWDQ1eWo1?=
 =?utf-8?B?NkY1Ynhlc21xTmRMUDY4YytZY3VPVUd5bnB5NFBFRkxMclpkbjVKb0h1aHJD?=
 =?utf-8?B?TjNKeXJpV3hwMGVtMUhWeldFRm5xV3ZVQVEvN05wNmZOcUdUWHppZDR6cTBn?=
 =?utf-8?B?SWpSSHlpcUhSR0FzTTZvVmxMT2pzZ1N0Qkcwb05CRUVwOWhaTnYvTlN5bEVJ?=
 =?utf-8?B?bFRydk5nSzhzOFA3cnlJVWFGNDNqb1NpaEMyaFlwYkN5bWIvN2N2S0ticlA5?=
 =?utf-8?B?eTFEd2cwa0IwSDczemovVWh2K01IbE9YVnl1N24zZkpWNjJmRlQydHJscmZh?=
 =?utf-8?B?NTVzL3Y5dlRpQ2tvR1loeWV3QnRQWGdTNlRQcHI0dVVUOW9BMUZiU0FGRTA2?=
 =?utf-8?B?WDVPQjNmN0VQSmVTNS91NE9lTzFHdjI2YzdEdDQyd2Z6WlZFNHREbWVYK1BQ?=
 =?utf-8?B?UVA0QTNoZ2s2enk1ZVJ0ck5ybUsyaHdDbjBQbi9nR1V6cDlCeVVnQ1hNbUxD?=
 =?utf-8?B?TTFBdnBRNGNWVWdiakQ2WGExS01xenNJMDFwSWpRelNBN0h1UTh6a2RSVm16?=
 =?utf-8?B?blVIeGFTTU4zWkMvRUhhSHBVUVpTaThqZVlGNmJPUTE4Z0FRNkI4S1hRc29I?=
 =?utf-8?B?dzNMckJyeDByNkZra0hyUHhtL291Z1F2ZmFvYk1acmE3dFdLbmhEOXVZblE5?=
 =?utf-8?B?ZzEyS1VlNHlqTzQraEY1NEQwU1A0VHhuL1BGanFIblJFb3FEYldzeExMVjZ1?=
 =?utf-8?B?eHBWVzJuZ2JyK3huVnRtM0Y5VkVmRTluUkF1Z3R3QVJRY2lMR2x2VE9wUS9v?=
 =?utf-8?B?b3Nhejh5Mk9NL1hzcG4zQkx3OUJhVXRpbVZrOGttdXNJdWtXb2ZqU3dORTdx?=
 =?utf-8?B?enNVUzhicGUwVFJRRk9aSi9ZbzVJb2J1cnphYmQ3OW5VUEQzTkxQck8xS3Bw?=
 =?utf-8?B?MmhJc2hHYUhwTVVscG12Sk5ybHJSWnBlcVJaeUY3Y1JuY2VyZ1BKRGNpMEVh?=
 =?utf-8?B?TUVLL1U5QXRSbG9NQVhOVW9ndXZmRHN2djliWFJqQXh4ZXNwUzNtdHN0WUlB?=
 =?utf-8?B?QzBaYUVReW9QTlpRMFlqNFh3a3Vkd2JYVzI0NUkyYjdDYVgxN0d4NGpTVVlP?=
 =?utf-8?B?ajlsckt4c3N1QWtGYXQ5VDk2MjlkTmpFZ3F3c3E5eW82aFlTeEY2Y1NYcDNT?=
 =?utf-8?B?R0FlQzllWlJBOFV2U0NjZHpPK1EzWkM3RlhhS090WlpQbWpoUVNsUURRWFNQ?=
 =?utf-8?B?QkJHNFJzODBTYWhiZWZIS0lxbjRQcytzL0FsRUpKL2ltbSswQUpzN01RekdG?=
 =?utf-8?B?ZDZrQlNMcnUxb2x4eWhadmtKVzRxOEdUcldSajUxc21jRUtlYU9QajBBbjVh?=
 =?utf-8?B?UlBtK0JTSnlzaHRMNTFTUkdEY3pSaGx2Z0IxVmJzOTg1UW0wMTdiZnphN2RC?=
 =?utf-8?B?UjY2ZW4yMmdsQm14NTBYUHRCVjgzbzI3blVwL0xwN1dJUVVtWFFEK29vc0Ez?=
 =?utf-8?B?VU5hYkRUYThnOTVKeTJyT0VlckZUbDdvTDdEVEZ3UW81akgrdldhL1doNFp0?=
 =?utf-8?B?TW0wL1NpV2wzSDJjb1VQdk84THBGSHlzUWxtUnpXZ1IwWEVLczBjVnFCUGZC?=
 =?utf-8?B?M1FMYTRmYzBXRExEelg5aHNDaG40QWV1ZHdTZVFpMFVCbWk3YTJEVzdJb3lq?=
 =?utf-8?B?NzB0NGUyUzcvQ04yOU1LRUJQeEtwVzVDcmxzUXdiYU45aVRPZnpIbU5TNmVP?=
 =?utf-8?B?d3ZnSkdhcXhDL25LMjBiTkFkTVlvcUphK0dxUDNwY2VuVCtKOUlqR1BtSGIr?=
 =?utf-8?B?b3hoTDZHK2MyUHJxQjQ4SlpESFZrWFNlaHdGV3lVM3NOV1c4b2dhcGxMNkJv?=
 =?utf-8?B?N0xyOFRieHJuNE9HSDhpTTFhMVdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AE16D177A6A904DB89B00A3E10F06A9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A1mkQEtbaKPf7CJY9J6910J+b6YHPlH8laLzLfm5fq71i9jnVtalpqvhACwz+GmHMy3mBSKGhFzbUqB3qzlbzZCcXMHU1bZrwKLM5bSS8LDUjOs8zyBWYalo6MhLQaqi7N9xcJWmLoD6xfVbpuiuSkSNXcdtvzpcIYwbL7U1sKveDOGV9FB/Q5hvbaRvdlUeJL010yadVGif/IDudhWNZvrK/OFOWWHC2Y3wZ2PQPFEcPl/7248aJk8XroJIoF+eGUFVBGguN1qG8fGso/TObYmZLG1gGs1P+p9hEd0raBvct8DaTUXqmeU0RyMdRXsIUyysHdP2U8s6fcF05ytyVmkQh/g8Yyb0XN5J0YfWM17hbO0QoMAUvWrdRkkYFsZEVqD/eiIvI3/PRICNkIF3xmMKhOuXsTart735pEmI+wgULpIWPcyIDEIHxUwoDV3Xh4UZ06DoZoOuX74Ydf7tp7c+cdNAxJgXYQkoV5HEHIWguYiuY9LsRJSK0iv6ZEQ0kDw0wZMgQgXbUZcM7rlViYWJmFJTDGK1855iku/5Zz6xGkcWdq0+fJld1aR+pZDJ6tfORS5H34QdoZIpAN5rzbzHH3LkJaFAvpKtn9CxGf482o9mgvOkMq+IuHpk+sgp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0SPR01MB0001.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55464268-aa6a-4c05-6b83-08de28cb9751
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 07:00:01.4859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vyLue8w2bORF4C0S+APiv/l6gJ/8iajXThd7B5PxPm5oSbLG6huLIbrSgoS4z8SuTSPmAOUvN5QQBj7fTHLvmo3cHAae90p2+k1uypVyUl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8192

T24gMTEvMjEvMjUgNzo1NyBBTSwgaGNoIHdyb3RlOg0KPiBPbiBGcmksIE5vdiAyMSwgMjAyNSBh
dCAwNjo1MTozMUFNICswMDAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+PiBPbiAxMS8y
MC8yNSA1OjA5IFBNLCBjZW1Aa2VybmVsLm9yZyB3cm90ZToNCj4+PiBGcm9tOiBDYXJsb3MgTWFp
b2xpbm8gPGNlbUBrZXJuZWwub3JnPg0KPj4+DQo+Pj4gQWRkIGEgcmVncmVzc2lvbiB0ZXN0IGZv
ciBpbml0aWFsaXppbmcgem9uZWQgYmxvY2sgZGV2aWNlcyB3aXRoDQo+Pj4gc2VxdWVudGlhbCB6
b25lcyB3aXRoIGEgY2FwYWNpdHkgc21hbGxlciB0aGFuIHRoZSBjb252ZW50aW9uYWwNCj4+PiB6
b25lcyBjYXBhY2l0eS4NCj4+DQo+PiBIaSBDYXJsb3MsDQo+Pg0KPj4gVHdvIHF1aWNrIHF1ZXN0
aW9uczoNCj4+DQo+PiAxKSBJcyB0aGVyZSBhIHNwZWNpZmljIHJlYXNvbiB0aGlzIGlzIGEgeGZz
IG9ubHkgdGVzdD8gSSB0aGluayBjaGVja2luZw0KPj4gdGhpcyBvbiBidHJmcyBhbmQgZjJmcyB3
b3VsZCBtYWtlIHNlbnNlIGFzIHdlbGwsIGxpa2Ugd2l0aCBnZW5lcmljLzc4MS4NCj4gRGlkbid0
IGYyZnMgZHJvcCB6b25lX2NhcGFjaXR5IDwgem9uZV9zaXplIHN1cHBvcnQgYmVjYXVzZSB0aGV5
IG9ubHkNCj4gY2FyZSBhYm91dCB0aGVpciBhbmRyb2lkIG91dCBvZiB0cmVlIHVzZSBjYXNlPw0K
Pg0KPiBCdXQgb3RoZXJ3aXNlIEknZCBhZ3JlZS4NCj4NClRoYXQgb25lIEkgYWN0dWFsbHkgZG9u
J3Qga25vdw0KDQo=
