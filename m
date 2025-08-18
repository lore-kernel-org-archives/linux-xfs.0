Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E43218C2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522402; cv=fail; b=oQx59qra2lgvZM09xcgylMaWbNZxTh/bzZBq2Z0ObOI1sRsDFLX8s3jqOCgjo9Stuk++Y8PoYCQfP5THvEtzcdWtz1UgXwtMCi93dBaI5h+naA/uIHeF1zVa+dtDbHL+5/7yRNUYY1tzuU0WRNnp1NWEaWg55Lz6+LrPMqHNXe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522402; c=relaxed/simple;
	bh=46qDEl4FCKK0JQV4YGsvx4jpJa1gj9r/5d0LRLKNrRk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H3v9t3DaNZtPjgaJas4/wFoth0uGfDGj17HYiJyUvNWNqrC1DiwABPMvwaQRUQTmI8AudF5du8+uj/dUMCjTgeHxHCgMxB+M+6deiTudUkR2jeuIsKbxnRMnQcYQR1zALBf2ianbcS/Bs2kxmjHzkIV00Uea1EMMCyJWee8hZuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=r6o2lEmz; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dokPFi30; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r6o2lEmz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dokPFi30"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1755522400; x=1787058400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=46qDEl4FCKK0JQV4YGsvx4jpJa1gj9r/5d0LRLKNrRk=;
  b=r6o2lEmz+eIOAM3TX6XiFWJbSrDwkEI/dkIhh15auDWBDCOhGiQG6yQw
   zB5RyMMX/ikYjXHitV8OFfyDYVns+FyegAuY3TP6XNCmdCJXtn69ytU5D
   rBzq5HSWVGhWYtzXhmCCVC5a7pLGoYe0BKtzyfuPMTxjfjCcP6aTon571
   cBEtXdRBPuXaq4M2SR3U1k3Nxvq1E+m8igNShVIXMDWxEna4ME4qFUCaw
   iPZs7d4tauDCTy7YPh+hmaudPMNGTewScwzwvH83FdANy1X7lEtAcJWvm
   PxcWD29NLtJAy2o1Uo4l0oQnGe12Uva4TRMH9UOYvDk4yVBp8D18GKMyT
   A==;
X-CSE-ConnectionGUID: BrbhXnqJRJO1heLnYD8uwg==
X-CSE-MsgGUID: 580Dl2QIS06P9EWHYQbv/w==
X-IronPort-AV: E=Sophos;i="6.17,293,1747670400"; 
   d="scan'208";a="105345960"
Received: from mail-sn1nam02on2046.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([40.107.96.46])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2025 21:05:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+g7dGGZlMkY3KjtjThk0WWzOaF3WShaGl6E8Ux65CS7I5Rit2ukxZvwu8p60W7HXQ3MjshO36Q941ptCMVnw7q01tO9LKqCrvcDu+ixmwgXYaAic7nYWFq+YGWfnrKHNJz6NrDi/Xib5Yy1hpROvU9EMPaugcRCXOiM5d66CSfnIIzCJ0Yv0PhEdNzRTuwIz25UTZDuZwI/SoIr8os5sT9j62qIzqvy+ZQIsFSqRCqW/xB/0BFP5guga2y3N0eCAk9U6FjOIe+xTUFkwMGKkJaSXGpjzLKV+ZEaxBJq+4JFgujhXeVYQay/tRHoCan+iY2UG9eRBM/G0MG/benFLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46qDEl4FCKK0JQV4YGsvx4jpJa1gj9r/5d0LRLKNrRk=;
 b=qzMJQNnRrrRIXNmkFy9ZaB41rRPOpo1qqCoM8D3Q5DUIspiAEdLQu5xArJoNoJCRxwAm2+6gc6IKYm80FWGHqVEvqNW+16TsNTs/EILQalzmxEtA2oVJCONdZ+GDwjpRLefww9kEfadNxVGQekPcGQv7/n4zvqFen1UgvAHSMBJTMBrN9Sje8JH9fAaSFntevLytN/erWuh4o61VMGJldu52KO78NX8kn42aE+iwIrnrUi+P1T2t1TlB6YGWCou9LlV7SdUEmkTshpqo93W9sC5sdPxqbbIKEgHmVXqaqsu8FFYkXyxi2KDLb9mOJ6umX4gxO79tna8LOa3ESrLTsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46qDEl4FCKK0JQV4YGsvx4jpJa1gj9r/5d0LRLKNrRk=;
 b=dokPFi30GXceDnBVdCYsuhxPWdOiOuogl5fatRiHCTImPshh42KtZQmKdiEY7+EZpEctWP4zvBvtg3qycTZzQg/0fqJdBfMYssWZlfZtzLuGlgeaeOuOxIC9hLDnl8fcYiC7ISrKGUYZwX2WK7zZyGv76xGzi/1UO1nF56aoYrY=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BN0PR04MB7984.namprd04.prod.outlook.com (2603:10b6:408:157::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:05:29 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:05:28 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] xfs: remove xfs_last_used_zone
Thread-Topic: [PATCH 1/3] xfs: remove xfs_last_used_zone
Thread-Index: AQHcD/4DLuOjB49ouUaTDqB3eaODc7RoYY0A
Date: Mon, 18 Aug 2025 13:05:28 +0000
Message-ID: <3bb21337-9b45-45c3-8d50-6a4fda8602b3@wdc.com>
References: <20250818050716.1485521-1-hch@lst.de>
 <20250818050716.1485521-2-hch@lst.de>
In-Reply-To: <20250818050716.1485521-2-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BN0PR04MB7984:EE_
x-ms-office365-filtering-correlation-id: 56aa23af-e6ed-4220-da20-08ddde57e7b9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|19092799006|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bVQrM01oTFlZMmJrRTNvUUwwdXlIMVFPYjU4eHh4NTI5SHlaSUVwNmpkNGxt?=
 =?utf-8?B?aDVQQks5djg5OG0yTEhHaGZDWS91bGtrdkV0SjhLL25OTWtndEVVODc5QUJ5?=
 =?utf-8?B?RGtnUzExYlpWaWsxMytSMDBHd0ZYb1lXek0ycGVWSGFjeWFzeEtvMHlXMDNL?=
 =?utf-8?B?SUxVTFNNQXZlNUw1U2NZa3ltMjdTR2ptbnVDK0k2YW1ncEpibEUxaGJERStQ?=
 =?utf-8?B?WnN2N3Q0cGxxV1hyQXJFRlUvWlh2cUhSOUw5ZlBqckd0cUgwU0M2L0d6VzVp?=
 =?utf-8?B?dHY3WC9wRkw5Wm9OOE4yTE45Mks1M2NKcHVlNjllelE0cFRhcTIyZDlSd001?=
 =?utf-8?B?L1NDUU9aTCtHdm9adFd2ZFRENkR4a2g2d3BHVGZrS0RZNVZGR09hcGpneHl4?=
 =?utf-8?B?NFBLQStEM3pDUHRpTGt6MldleDdSOVVpSEFGa1VYM2RhMlpvd1YrRTNQNE45?=
 =?utf-8?B?VWNQUmlIS2o4MHF4TG8wVDNLY3JSeDEvSXROdndlZWpCYkNJSGJ6R3VaaUkw?=
 =?utf-8?B?c2ZNd3pNdXdjRVZvQjJ5YkZ5dlprd0J4SUFRTkdtUHoydjJJNzM3d3VQZ3Vl?=
 =?utf-8?B?WDJJWTA5elNMUUZYOGp6TGhhSVgrS1JTcVRSTUMvMGdkUDlkdXU1djNRY3I5?=
 =?utf-8?B?VTk0alhtbGZGMzk4M2Z1ZzFLVVVoenkzNE9XMWY2ZUQvaXlVZUw0d2hjb09T?=
 =?utf-8?B?d29ZUkRIczVaYjhYNDJXUUQ4VktWeTRiUGd3TWxFMW9pT3VVVFpPa3BoMFNt?=
 =?utf-8?B?VVRkbWtPcDFEQ01qejNqRHUyZWNadWk4NC9tQjN4UytKbXVUS01JaXVxZkY2?=
 =?utf-8?B?eWhaNDFld0R5QS92NFBmYno2ZGVFNk5iVlIwelRlNGtaUG9MdlRkZG85RFIr?=
 =?utf-8?B?MGNrbXMxZDlTZ012TWk3ejA2aUlsMVhtNDg0dWVhRGp2N1l1UXJGU1cySnc3?=
 =?utf-8?B?ZG5kUnlraEkreFNBL0VPRi81bXBFNWtnM01qYjV0Ym01SnVCRzdZKzVtTDIz?=
 =?utf-8?B?Y3pzOTd1VEoraUhSbEV3TXBPd1RleHhUdSt6eFNxZzkzVElNUkdwS0NuV2do?=
 =?utf-8?B?MFNQUVBpSUZOZm9yUTBFOStXQWFYdHEzUTFHL3pBblplZUdjQTFvVGVHclI2?=
 =?utf-8?B?QXVCKzU4M2loL2FRU1UvWUtqQklsc1MrR3ZwcWw4NThYdUlHU05Gb21rZS83?=
 =?utf-8?B?RzNRNmU3ZGZLZTNRSkdoNjMzYm9USUFDWXVOYm1YU2ZudVlLWUR5QTR1TGNU?=
 =?utf-8?B?dC9hUUNPN0FxZ2pJMjhpM2tkNjVXN0phbzFwd2FNVVZMdWlGd2N1V3F2T3Ft?=
 =?utf-8?B?V21najVqeW9JRmxtSXNoN09YMk1CZGlSaWJ3L0UrWGNQd2c1a01IN2RBVGpu?=
 =?utf-8?B?dXYwRU5aWmVNb0JRR2E3bDdwQWhsbDdqZkpCUE0vMjBmVHRodTZkS0cwRUs5?=
 =?utf-8?B?ZmJOVk5reW5FQ0pNT1h3U1dJaGhPbU5ULzlOUzRQcCtLSDhDQW1mSVQ4WTBJ?=
 =?utf-8?B?TVYxSVdFSlRvcng4bGdaOTBhTC9CUitrcHd2ems5cnRHYk9lOWJYbjlOSEkr?=
 =?utf-8?B?Nnhka0k4L1hDTFlPTUhWVjlvT0syeUdpUDMzNWU3RExKMis2b0N2QWcwdng0?=
 =?utf-8?B?M3J6SlJ0Ynd0UzZqYWsxeWwyR21zT0R0bVVLMDgvZlIxWDhCV1dRWm5Vc2lI?=
 =?utf-8?B?cTJpaXZYUU1id1ZiZnBKZ1Jsa1RxbE14cUJpbUZZTVZiUCtLN0xIdksrd3FO?=
 =?utf-8?B?MXhJZkJYanBnTzExa2hCUjZYZUlhL2NLSEYxVHRNd0NqenhabHlaQy9pcHBo?=
 =?utf-8?B?enNKMDc2bnIxSVU3NXNQQmo5ZGNWS2VKOTBWZlpjU3BDQWZ6eTNRQ2tYVjlX?=
 =?utf-8?B?R1cyaTd4cU1paUNPMHZDNXJhVG9jWVRVTk45Q2FDR1l6QXRrMVdwMFNmWG1R?=
 =?utf-8?B?a1UzYnlPZnJuN2gwamNxdjNzcnNGUUZOdjZ6RGZxRlRzbkwwK05URU1oYk1l?=
 =?utf-8?Q?5pTNzP7zregPdbWOTUP9YCQahRw2UM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(19092799006)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUxVR1prUU1BN0E3QTQzM0thNTNaMlcrNDRKMVNqRFdTbjlvR2VpRFgyN1BF?=
 =?utf-8?B?dlJBa3JmU0owZnBqTXFMa3FSNU51Mk5GT0tBYkgzMXJldlF2U3RFcXNEeWJI?=
 =?utf-8?B?WFdFNUtaNXlSbzUwY1B2RVlDMWFjLzZoTzVTN293UUFOL2VjMi9ZRWNFdnBv?=
 =?utf-8?B?ZzJyRW91aldlNzl6dmhmUnprcFhiempna3MwNGJFbDVSZWtFMzVmWUVvbjR5?=
 =?utf-8?B?Mlh0NXF5WjducDNjS3dPWnN4ajZBTXBzSUUvT1pxQzVONHhtQndKc2NMc3Bn?=
 =?utf-8?B?aGorUGY4bUFBS1Z3TzIwNTFJSXVJc3ZrUTliQlBXNXFIdEQrbmhUOFFoRnZV?=
 =?utf-8?B?NFNSRnU0Y1E0QXcvbElDU1ZiVGc0ZUVVcXZSOHpING4yYUZLYWw4ZHUwYzQ2?=
 =?utf-8?B?cXVmc0VLY0hEZitDOTBVdFY1M3haZ1FaUGs4bEpqZHc0RFlmNHkrakNyL25o?=
 =?utf-8?B?d21qdjRxa1JDOTJCSkg4RlNHY1g0SjRiYkd0clkwWkQvK3lqS3A2dlRzY2Jp?=
 =?utf-8?B?emplRnZHTE1EVTBCZDAvMVlFZUdQQnN6Y1VWeGF4UDAvTkN4aFJVYnBoL0ZH?=
 =?utf-8?B?aVhQMGVXb3Z4YjBwZEVlMUtDa2NadnI3Zk5xNnJTY1BiVVYyaGhJcFg5YW4v?=
 =?utf-8?B?WlVaaHJaZnRrbGpTTCt1V2tWOHVYYmJKbEVtNmxzUzZKbGVPd2hLZTNhTUR4?=
 =?utf-8?B?MWl6OEhKeHZHL0gzT0hzOHRsaUxUT2Exd21zUFJFS1ZyN1UweFZUSG1FOEo5?=
 =?utf-8?B?NHpvWnBRbFlqS0l2RXdRSElEa2s4Y1JiRmdmM2pFVGplRTFKY0hwd291dVhs?=
 =?utf-8?B?REl5M1UwRzZGMmVQR3BNQWhsZS9ha2pzcXpMTi9VbHgvN2F6bUxDazFLYmRy?=
 =?utf-8?B?cm5nVllQTmFqT29zYmplUVJUV3IvY2tvR3E4c0l0VnNTSjhSVldoS2xKdkkr?=
 =?utf-8?B?ZkdCT2xsem81SVNrZHowVjFPUW44NFpVb2RjZmNnMXNFOSt0b3BQV1AzL0F4?=
 =?utf-8?B?b2VaV3lXcHduVkpOTDdGRGV1ajI0SFdrSmF0KzVRWnR2WjRvT2VSd1R2UHhn?=
 =?utf-8?B?Szl3T2dteE5rRmloMk1sclpudVJyLzZ1OEttVzEwUm1jSkNlTWgwMy9MSDRP?=
 =?utf-8?B?bWdtU1NJVXZSa2NNcDdlSVpuRGdKNDlvMDU4SGI0TVFBNllPajY0Y0JEVkRk?=
 =?utf-8?B?dFU5MStLVlViaFo1WVBhTFVtZC9kODRUbzJOWXA4ZS81TjJRNE9OaXlrVnMx?=
 =?utf-8?B?RFBwL2t0VXJWc3dQY3VvekNPcnZTM09ka1BXcjJRUjJjVW90My9xd3V1N3hZ?=
 =?utf-8?B?K0dJRWd2cUdwQTRpakVYNXFyKyt3N1kzdTQ1T0tQbU80N1JBUENXeGN6SUkv?=
 =?utf-8?B?d3RrcWQ3MGR3c3JGQWoxMncrTkF6T2xsVlE4Z1JYdWhWZzNLeEtpaS9qZUVS?=
 =?utf-8?B?QmxJZUJTZys0MHduWmNsYUg3c3RzdkN1ZkNiQlp6OGdZdHlYWERvdjNkdFFi?=
 =?utf-8?B?UlpXNkVRMlp0TmpubDR4YXo1U0Z0dTArNG5MM0ZJNnhpSi9jV050WTRoaDJy?=
 =?utf-8?B?UEs0VWVTOXVhT1BJUm8xY0owSDk5M1puRDFZdWY0a3NhaGZRQ0dubVFsdzlH?=
 =?utf-8?B?eEc1UVo5bUcrWEJCRU9rQmtlcHpEZ2U0SDJENUM5ODJ6Y01XaFN1VnNDSHJD?=
 =?utf-8?B?WXZLZjhZZkRoditXc05uVUdRaXNwM3J2Z25lamdmZS9SaFNPdUdJL0VvRVIv?=
 =?utf-8?B?UmRpQlVvbVlpTVo0Q0dWOExQL3gwcUxNemFmRjRad2grUUlsYmM1ZFZIbjVT?=
 =?utf-8?B?TVZoK2lzRDhBWXo3Q3U2U3RlRElRN2M3MStaRGtLTFVFdXZUS2hONlR1L0NI?=
 =?utf-8?B?cXY3bk1maWZGQmMwdkdkVmN6eGdPOEJ2N1Z6SzhWQzBCNDJtZzJHVUtVUUNq?=
 =?utf-8?B?WmZYbG5WTm9aV2habWd2d2tiK3JTOUZma2hWK09tRWJyU05DV3Y4a1BjS1Zq?=
 =?utf-8?B?Q1YrZHBINVJFcnBOc0ZNSjJUdzVnYTdmcTVjKy9idnlKdk1GMlc1aTFHZ2ln?=
 =?utf-8?B?WU9yZTRlYktPWVZvcFZzUnFIQ1FTeUN5OEhyMGZ5TTBaSjJZOHd3dzRBK3dx?=
 =?utf-8?B?bnJJZnJUcnhaTm9oUXJRZDNlT3BnUXJCcElTVE5ack9IdWVQbGYwL0NEbVhT?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8000D72B555ED840806419E020B4B301@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N+F/j4hy6CqobiGGp+3kfgFOft7HiECXW8CBZnQ/FbLvnV97q5oYy1kIpia8Ax/80UqSedE+sYdfj2H0dSj5unYvfEsjvMGAb+B8l5VQvTuvC0QljMe9CsTgrnFc53C86ahBuLLombXF66+0rypgDXfyQ97MvskZRGhEr1O7o+lo/PVMpm3rVUFXe0KhARs21txUY9aE3ijTomHiuEk6DU6x7hkUx83NgnLisYrBmcTvLBLgvT97VnWErobZhlsT787RpNLuA0esnmlOHk/UAT7RkDe6h08R2Cxr5i7T481ip4DPamyP3t8Avh+y7ypOVx/aZZR/uzybUiBYPz1SoHjGpgqQzFZvJ4eqs2vIZ08kXCnzTaOEIMgQPZSrwKq6nJj9I5KeIiokBvRqyKeT1yMMZuAGyVq/ljXOfT39kNXv4b6ZdQ2DQ4k8RRFIP7nK8zu6fwtxx0kU0vBziiD7ZJRqR+8sRmaemwrKgi9fTZPdK5E1ouKQ8GWT+PcnGJVCdjgBQIrIFNt9NfZPJOo+guCB6OyPJW3fRRVYyyOBIu9bibdotaMnB4MZEYdnrGsIFZwKIxeQ0tdHp/tiYupCi5nopOP7taFvhPovDNRhWQ0dLKt7tbQRCRXDpYarh8lm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56aa23af-e6ed-4220-da20-08ddde57e7b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 13:05:28.7656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xI1/a1JqHx4f0ht+Gf+UonVu+re5trFXkQts/AK9XkeV3wUlO+gj168k0+/GbXpB9oDaU645RQ4JPmD3oZvTYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7984

T24gMTgvMDgvMjAyNSAwNzowNywgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFRoaXMgd2Fz
IG15IGZpcnN0IGF0dGVtcHQgYXQgY2FjaGluZyB0aGUgbGFzdCB1c2VkIHpvbmUuICBCdXQgaXQg
dHVybnMgb3V0DQo+IGZvciBPX0RJUkVDVCBvciBSV0ZfRE9OVENBQ0hFIHRoYXQgb3BlcmF0ZSBj
b25jdXJyZW50bHkgb3IgaW4gdmVyeSBzaG9ydA0KPiBzZXF1ZW5jZSwgdGhlIGJtYXAgYnRyZWUg
ZG9lcyBub3QgcmVjb3JkIGEgd3JpdHRlbiBleHRlbnQgeWV0LCBzbyBpdCBmYWlscy4NCj4gQmVj
YXVzZSBpdCB0aGVuIHN0aWxsIGZpbmRzIHRoZSBsYXN0IHdyaXR0ZW4gem9uZSBpdCBjYW4gbGVh
ZCB0byBhIHdlaXJkDQo+IHBpbmctcG9uZyBhcm91bmQgYSBmZXcgem9uZXMgd2l0aCB3cml0ZXJz
IHNlZWluZyBkaWZmZXJlbnQgdmFsdWVzLg0KPiANCj4gUmVtb3ZlIGl0IGVudGlyZWx5IGFzIHRo
ZSBsYXRlciBhZGRlZCB4ZnNfY2FjaGVkX3pvbmUgYWN0dWFsbHkgZG9lcyBhDQo+IG11Y2ggYmV0
dGVyIGpvYiBlbmZvcmNpbmcgdGhlIGxvY2FsaXR5IGFzIHRoZSB6b25lIGlzIGFzc29jaWF0ZWQg
d2l0aCB0aGUNCj4gaW5vZGUgaW4gdGhlIE1SVSBjYWNoZSBhcyBzb29uIGFzIHRoZSB6b25lIGlz
IHNlbGVjdGVkLg0KPiANCj4gRml4ZXM6IDRlNGQ1MjA3NTU3NyAoInhmczogYWRkIHRoZSB6b25l
ZCBzcGFjZSBhbGxvY2F0b3IiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8
aGNoQGxzdC5kZT4NCj4gLS0tDQo+ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDQ1ICsrLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCA0MyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy94
ZnMveGZzX3pvbmVfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IGluZGV4IGY4
YmQ2ZDc0MTc1NS4uZGZkYjE0MTIwNjE0IDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pvbmVf
YWxsb2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBAQCAtMzc0LDQ0ICsz
NzQsNiBAQCB4ZnNfem9uZV9mcmVlX2Jsb2NrcygNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0K
PiAtLyoNCj4gLSAqIENoZWNrIGlmIHRoZSB6b25lIGNvbnRhaW5pbmcgdGhlIGRhdGEganVzdCBi
ZWZvcmUgdGhlIG9mZnNldCB3ZSBhcmUNCj4gLSAqIHdyaXRpbmcgdG8gaXMgc3RpbGwgb3BlbiBh
bmQgaGFzIHNwYWNlLg0KPiAtICovDQo+IC1zdGF0aWMgc3RydWN0IHhmc19vcGVuX3pvbmUgKg0K
PiAteGZzX2xhc3RfdXNlZF96b25lKA0KPiAtCXN0cnVjdCBpb21hcF9pb2VuZAkqaW9lbmQpDQo+
IC17DQo+IC0Jc3RydWN0IHhmc19pbm9kZQkqaXAgPSBYRlNfSShpb2VuZC0+aW9faW5vZGUpOw0K
PiAtCXN0cnVjdCB4ZnNfbW91bnQJKm1wID0gaXAtPmlfbW91bnQ7DQo+IC0JeGZzX2ZpbGVvZmZf
dAkJb2Zmc2V0X2ZzYiA9IFhGU19CX1RPX0ZTQihtcCwgaW9lbmQtPmlvX29mZnNldCk7DQo+IC0J
c3RydWN0IHhmc19ydGdyb3VwCSpydGcgPSBOVUxMOw0KPiAtCXN0cnVjdCB4ZnNfb3Blbl96b25l
CSpveiA9IE5VTEw7DQo+IC0Jc3RydWN0IHhmc19pZXh0X2N1cnNvcglpY3VyOw0KPiAtCXN0cnVj
dCB4ZnNfYm1idF9pcmVjCWdvdDsNCj4gLQ0KPiAtCXhmc19pbG9jayhpcCwgWEZTX0lMT0NLX1NI
QVJFRCk7DQo+IC0JaWYgKCF4ZnNfaWV4dF9sb29rdXBfZXh0ZW50X2JlZm9yZShpcCwgJmlwLT5p
X2RmLCAmb2Zmc2V0X2ZzYiwNCj4gLQkJCQkmaWN1ciwgJmdvdCkpIHsNCj4gLQkJeGZzX2l1bmxv
Y2soaXAsIFhGU19JTE9DS19TSEFSRUQpOw0KPiAtCQlyZXR1cm4gTlVMTDsNCj4gLQl9DQo+IC0J
eGZzX2l1bmxvY2soaXAsIFhGU19JTE9DS19TSEFSRUQpOw0KPiAtDQo+IC0JcnRnID0geGZzX3J0
Z3JvdXBfZ3JhYihtcCwgeGZzX3J0Yl90b19yZ25vKG1wLCBnb3QuYnJfc3RhcnRibG9jaykpOw0K
PiAtCWlmICghcnRnKQ0KPiAtCQlyZXR1cm4gTlVMTDsNCj4gLQ0KPiAtCXhmc19pbG9jayhydGdf
cm1hcChydGcpLCBYRlNfSUxPQ0tfU0hBUkVEKTsNCj4gLQlveiA9IFJFQURfT05DRShydGctPnJ0
Z19vcGVuX3pvbmUpOw0KPiAtCWlmIChveiAmJiAob3otPm96X2lzX2djIHx8ICFhdG9taWNfaW5j
X25vdF96ZXJvKCZvei0+b3pfcmVmKSkpDQo+IC0JCW96ID0gTlVMTDsNCj4gLQl4ZnNfaXVubG9j
ayhydGdfcm1hcChydGcpLCBYRlNfSUxPQ0tfU0hBUkVEKTsNCj4gLQ0KPiAtCXhmc19ydGdyb3Vw
X3JlbGUocnRnKTsNCj4gLQlyZXR1cm4gb3o7DQo+IC19DQo+IC0NCj4gIHN0YXRpYyBzdHJ1Y3Qg
eGZzX2dyb3VwICoNCj4gIHhmc19maW5kX2ZyZWVfem9uZSgNCj4gIAlzdHJ1Y3QgeGZzX21vdW50
CSptcCwNCj4gQEAgLTkxOCwxMiArODgwLDkgQEAgeGZzX3pvbmVfYWxsb2NfYW5kX3N1Ym1pdCgN
Cj4gIAkJZ290byBvdXRfZXJyb3I7DQo+ICANCj4gIAkvKg0KPiAtCSAqIElmIHdlIGRvbid0IGhh
dmUgYSBjYWNoZWQgem9uZSBpbiB0aGlzIHdyaXRlIGNvbnRleHQsIHNlZSBpZiB0aGUNCj4gLQkg
KiBsYXN0IGV4dGVudCBiZWZvcmUgdGhlIG9uZSB3ZSBhcmUgd3JpdGluZyB0byBwb2ludHMgdG8g
YW4gYWN0aXZlDQo+IC0JICogem9uZS4gIElmIHNvLCBqdXN0IGNvbnRpbnVlIHdyaXRpbmcgdG8g
aXQuDQo+ICsJICogSWYgd2UgZG9uJ3QgaGF2ZSBhIGxvY2FsbHkgY2FjaGVkIHpvbmUgaW4gdGhp
cyB3cml0ZSBjb250ZXh0LCBzZWUgaWYNCj4gKwkgKiB0aGUgaW5vZGUgaXMgc3RpbGwgYXNzb2Np
YXRlZCB3aXRoIGEgem9uZSBhbmQgdXNlIHRoYXQgaWYgc28uDQo+ICAJICovDQo+IC0JaWYgKCEq
b3ogJiYgaW9lbmQtPmlvX29mZnNldCkNCj4gLQkJKm96ID0geGZzX2xhc3RfdXNlZF96b25lKGlv
ZW5kKTsNCj4gIAlpZiAoISpveikNCj4gIAkJKm96ID0geGZzX2NhY2hlZF96b25lKG1wLCBpcCk7
DQo+ICANCg0KTG9va3MgZ29vZCB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcg
PGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
