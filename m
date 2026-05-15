Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9893DFC9B
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 07:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778828484; cv=fail; b=GgcLPRgtR8sjghE7xDxhkPU1u2vFqJ6H7F4lSAIeHg+JqNrewMWbK1YZitdAHfSThfkV6KmUqmnYSs87LBeVvCVYFp3b1M3YVP8efwVynoNc4rD3nBXQcwBbZsW124AAojIwaRrKMTrLG7aPi+cD9iKjgiaeJbYyQWYonDv+DF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778828484; c=relaxed/simple;
	bh=PVLUUvaZIcjjegOXeuppbt7puJ9A5JKDmyffEWH8a1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vof7gLYbSiw/t10f79MERfP8J+aPYH3ckNVLRDHHK/p81AftC9G1gyB+2IR5sccmgNUSpdKI2JQFp56A0JAmNPwGhLG4P/b6X9E2nfHekQpXltuv0oCSQ68P3sYdTzDV9OG/ZvuSwlaTlegedhxzF2dTAD6ygQ6hSUWX2hyGGe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FIeeljL3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RQPr85VP; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FIeeljL3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RQPr85VP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778828477; x=1810364477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PVLUUvaZIcjjegOXeuppbt7puJ9A5JKDmyffEWH8a1A=;
  b=FIeeljL33oy1S3bkNnD2fUCCn8dvvH9zBug2eJBHfoleJ6opDSaPHFd4
   GgXk0i0gmVwT6LBOlq5dU9uXOL9SY7wE13P4ZlC814FOfp/Qa8IxyolCd
   8ttBJGSnaxOWdP9KOJNRqbroVnvb2MTxaC+4ZrfQMG4pVm0nmGUTXy+aU
   OQJmAW+8mqulnFSOAdExinMgivOZ7e1Xz3D3+QusPjCCedx3559PPr+zn
   fqkDa97UAv538ls8/P0OmahR4fO8mOyopB7srtK5CKm9oYOriYYhAChGU
   oKTHoYHeV32hT6hD+jmRf3Eex7uOCe2LOrlbm8/RODyqBxkcH84Q2cHhv
   Q==;
X-CSE-ConnectionGUID: 1HxWvo5ISNyy8N0kPy1Udw==
X-CSE-MsgGUID: CCfgbq0WTsyE/XX1A7ZWcw==
X-IronPort-AV: E=Sophos;i="6.23,236,1770566400"; 
   d="scan'208";a="146056486"
Received: from mail-westus3azon11012034.outbound.protection.outlook.com (HELO PH8PR06CU001.outbound.protection.outlook.com) ([40.107.209.34])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2026 15:01:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U90PLv8HZuASbgR4F2FbkpN5pGhQkOkNBBdIaBiS2p5hpPQtgs80IBNtYMLY/olBoeYN3qDtAbBzhpll/3QkRH0bzs8pmaNW3+q3PRMjwCXlSy2nY442aVC71WtVzZ0sL+v3noAKcDTwnG32RrlUbrGT70vMP5GabjqGdX5jSWrpbOtJ2sWzbtXrhVmcm+pKTI5xHAo2dGON/T6nP5jYkCRjoWQp5SFEA3zlOBin0v80naZfJ8pJ6Mo92ZhuKgQJNHP7uDwJthH4cOLZPgwgsBSyYjv6KWHPwcIaf6joQ/4bYMpQwIrSlYWz2ERLe3RmoAJw/5c6LEjY6Ve9lQRQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVLUUvaZIcjjegOXeuppbt7puJ9A5JKDmyffEWH8a1A=;
 b=ipFcilxVgDXzv8LN2tIVQLel8j9G1FX9rMujoh1r5+A5CfZUxMM/S5MbyS6yM6BHvDw+FyGpPprZDLmVDksY1uJ6bo4/dvmBTu8+gZRNjdnGvUzxnSit3S4b9Lr8g07Sbsz49+R/g408u6jUkxRZnIQDSC/TsG3RC0VfnRYWjTAsxKROEpSDWvki2iFtTJha+VLb2uOmeKXrUhV2jGms5wikUARwKjAHIWGwsUKai/IUvjeGUz7/cgLn/oDUySVmW5WMdmMlTCRnElc4IN5tfv+Qgfq0Rk5HAAdVbOkl57n50eakJG2mWUDgBV4wrL352CKVU/kyJPOOadsMF6D62Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVLUUvaZIcjjegOXeuppbt7puJ9A5JKDmyffEWH8a1A=;
 b=RQPr85VPbd5kIu/sy2pYpxFIa5wuVgsyrJDijuLho4cq8acgK8SlzXjyF7n4e/bg9dJUKtdij/MaTNibUz0mliXRvpkiRw1C1WV4PzDL/7f8j6E7/hOOKcmXZ4z2B98hu0PCJ9BN/ARDamRhBRZOmKtXEq/SeWwP3fWkYWM72to=
Received: from LVXPR04MB9982.namprd04.prod.outlook.com (2603:10b6:408:37e::17)
 by DM6PR04MB7084.namprd04.prod.outlook.com (2603:10b6:5:242::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Fri, 15 May
 2026 07:01:10 +0000
Received: from LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e]) by LVXPR04MB9982.namprd04.prod.outlook.com
 ([fe80::a7f:ee0e:59e0:428e%7]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 07:01:09 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Damien Le
 Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: return -ENOENT for unallocated inodes in
 xfs_imap_lookup
Thread-Topic: [PATCH] xfs: return -ENOENT for unallocated inodes in
 xfs_imap_lookup
Thread-Index: AQHc4qMRBctvkQBOjEKhbSYHQqkN4rYL98qAgAK0JoA=
Date: Fri, 15 May 2026 07:01:09 +0000
Message-ID: <87055655-b908-456a-9ad4-08ffb26e25a5@wdc.com>
References: <20260513063745.8067-1-hans.holmberg@wdc.com>
 <agSAF-9YFa1ODMIG@dread>
In-Reply-To: <agSAF-9YFa1ODMIG@dread>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LVXPR04MB9982:EE_|DM6PR04MB7084:EE_
x-ms-office365-filtering-correlation-id: 9711eff9-fd9b-478f-8d20-08deb24fbe34
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|18002099003|22082099003|56012099003|38070700021|11063799003|4143699003;
x-microsoft-antispam-message-info:
 +H/ODOycakUL/Wn7s+vAykrmrhhhPEchAAvwXldq+0MLFwOJvrJKYTbPi8JVATvWe0VllJEMXP8Iu3dHXthMcTPvHp2d3Rs2doqmAc0HtGJKK/IbwFGPmYgyaNF6wuZAOeDAd7Skoza3//bm25Sz5H0h03jQhN+biTEBLmDOjPV9zFM0fdKAIlsyXv59UeM3K+N990ac54sd7mpaSqfSJdUI86lYZNmOCXYh8kINVRwmgO/3+AvRVa5HL2NZ7uqFyJG/zYUHaWN/+p+LO/GQIgCYMivoBgfuraxRz+gpx1r8c5lBZk4uhpN3WtIu7FE/dqaKVjqvELWPhzHqZBTF/Ewj+2E+kvDkQuyuX12gXLAZHrJQENaFS+jqdw4igbkC41SVwhu0+HIhM2lW0ZYAoYqFsvo7vE1UZNFWADbfcO7nUzo2U0jzhh8tc5XR2exrt70xYuu0tX3/Xf7lU4VvclmsTaryJc9pXDqdO7YDP9MxLCQShvLNZJE6tf+quUtroIjTxOTrN1zmspiR9Dy5uawAMRM/G0a7jAQMHKdqonBeM5J0qdDTb+8uhEbFKcq7aq1UY0tuuy7si4fCG/qaTngIqR9VS2OvTMA7J5q1KF49SOrdl19rVetI+DX+e4cp74mUlP1jBoZkr5OwtWx0MzTAKA2tErvfVFzL2XzCDV3v/pLaLRxok2qnz9r3wDxeiit0yxtsORQzkemanZLrsMys2VbSPVeLE23OSU7bN1DQHXNqjspG5tj4dJZYwdCu
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LVXPR04MB9982.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(18002099003)(22082099003)(56012099003)(38070700021)(11063799003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3pnako0TStLdGNLVG5Eb1B4MW94MWo5ZDlZcDh3azR3bjB5VlR5c0dWUGFi?=
 =?utf-8?B?ZXhBTG4xQ21yUWJHb3VISGp4K2tzYVNPcHFHOWllTUtEaWg3VUUxdGRldllJ?=
 =?utf-8?B?SEI5a2Rnakk1RWE0TkdtN2xmYmxJQ0lmblJYTCtrak45YU1FOUZKL01KenlQ?=
 =?utf-8?B?YVZVRXhDNVNNaU5WN3lTMm96Z0FvS3VIVEVjS0ZSeTluNHhyRjcwYmI5aFc3?=
 =?utf-8?B?MGRxczJkam4xZnZmbElFalVHcHV4R3hEQW4rWklvaXFRVlVoMkxuQ3pGQ1BF?=
 =?utf-8?B?Z3hRTmp1ZGU5MzZoL05ZaUVKR01JNjNtdGlnNzlIS0szcUVlbzBpdW94N1N4?=
 =?utf-8?B?c3g5ckZWMmJ2cUxGS2NjUkRoNkhMM1RCU1ozNE5veFNjU20xWmZkWFYrQjgy?=
 =?utf-8?B?bVZpK3hJb2NnenZta0E0aW4xZk40S25weGFVN2VabEMwa1lYeWY3eDc5TjFp?=
 =?utf-8?B?TDlXdXp1bFlFbjZNVTk3RUt2UzhjbTU0dkVuNTlFYU1ZUFo0NXJJek8reERN?=
 =?utf-8?B?SEtaQjVmYXhrdE1rTzRSeEhFNVl3czYwZEM0cm5wVDdNaTdibXhmTmFocVhU?=
 =?utf-8?B?UXJpUnNkTGNpUWJNUTJiRnB3WnhReUxRRlFMS1d4NytvNG9YcFhKNjY0MTZl?=
 =?utf-8?B?b2ZHQTFFNllJRmZLeHhzeDJ1Mk04cUxEUThvOEE5WkNIWjFsR0d3RVppRFl5?=
 =?utf-8?B?QXlBSlhyTnk2ZzlhbFV0T3dQNzNicTZsSFpkZnpsc2hYcnpIRVlIeVFEN1Q5?=
 =?utf-8?B?dTBWYnZ0b2NmWnhLMTBDTS9TeVBjTDBRazczVm5semFWTitGUWlycEViek5K?=
 =?utf-8?B?cmorTmJHelhRajlCNTY4ZFhpK0JGRzdDTXZjemw1ai9LM1FYMnl6K0xqSDhX?=
 =?utf-8?B?WVZ6UHBhekVCWTVrNU9hWlJBNzZtYm94U1FBRC9PY2NOVWVSRmlyMmQyT2lW?=
 =?utf-8?B?eUQ2SHFEbjRFcHZQalR2cVpMa25Sc2w2ZlhDaTM5VVp3M01DRG1mRElLdHdY?=
 =?utf-8?B?YVcvY2NFRncrY0V3QkFmeWhTelV5YXE3V3I0RVNCMWo2N2RRN0NoUEVtSlM5?=
 =?utf-8?B?SkhLWG5EV1VGOXJVTEZ1WUViTkRQVVdTcnlZc2ZKR2ZJME9xbjVtSlgrODBS?=
 =?utf-8?B?ZExBV0J6eEJheTFIem5ubXV3Um9iQ2VzUytXVngzek9YUTg5NkpnbGZEUFpp?=
 =?utf-8?B?c2lJZ1JZZmMwREVtWW1WUC9zSTZWNk41ak1oNVd3UzY4VWl1UEkvK1pBdUNl?=
 =?utf-8?B?TGQyWVR2MzEvRzRlK2F0NFhTR1FlcENudDI3TlNISDRZaVZKTEFVMUNqem9G?=
 =?utf-8?B?TzdvNFM5MjJ0SlE1cXFtckVCRzV6YWlXSGVkM2ZhU2d6amFTSDg5S1YvQVRo?=
 =?utf-8?B?dTdlODh6bllPZ2lIOG9HK0tHNTBlQ1o4ZWs0RStZL0FNbEsrTG9vZmVHSWhT?=
 =?utf-8?B?czBzSHhpd2JGTzMzbFNrL1UxQnRsdTlOZlNFaDlrQjlmeVRSTkhWbXViSnBp?=
 =?utf-8?B?QmxhSDJKREZOZURPSWp4RnBWZGdvTUQ2ZW5JMWJyakdFQlBVSldhRUlHbmsr?=
 =?utf-8?B?d0pRWG9PSUtobEFXVEphMzdickJRU1V3U0VZSHRRZUNQYkhzNVVLem4wTFNj?=
 =?utf-8?B?Y0xRMVRHcWtlNEw0blFJZHdkYlhwc1lTZGFyMjB6YmZzREhwVTJ6RDZTSGJJ?=
 =?utf-8?B?cUNsNGZLQXQ4R0pJVFJNcHQzVmJRKzRBb1FYcktvYStkMWQ1QnRMNVloR2x1?=
 =?utf-8?B?RWt4eTlMaUVEckp1N1M3SnR5REUzcWo5S2FZMHhrdUgwd3lTT1VHdFJwblV4?=
 =?utf-8?B?SGlIZ2ZzTURCVFFqcTFNR1ovNTBRQUZtRC9UL1JpN0UwcDlTN01KVU05WUhj?=
 =?utf-8?B?U253SFVYWVd6VCtmVldCTEg0Wnh3Y2Nvb2VjbzNnS3JHZHdISTZRNkJkWC9h?=
 =?utf-8?B?Rk1wazVLMkIxU0FrckprTDR4c3NPOXQ3OElobFJPZFVHNE1jM0lmdUREQjcw?=
 =?utf-8?B?OHJ3Q0JsM1JYT0FDdFhnOGIzUm9PQVFLeTAzV2lUcWRhb2oxL0VhL09oNzVr?=
 =?utf-8?B?cmZCZ0lpZUtRQ083MTdUS3dSbEhOL1hDTHJnRUNTc1pKOEtoRGF1b1E4b3ZE?=
 =?utf-8?B?cTRwYStRKzZ2QkRoamRISTgyQ21USW1ZMkNjWEcrNG0wa2dHQ0V3TnZiQTVJ?=
 =?utf-8?B?Y1BobWFueUxmUzRRRWFFWUpaekFCOGJ2OXVJUGlaZXRrUU9mczdRa1lOU2pU?=
 =?utf-8?B?Q2E5SmYwRm1Fa2lNYjVSMGRWRnNlbmFnc0RJZFluMVQrNWVLUVdXYUZCRlBN?=
 =?utf-8?B?TkdMdmQzNDBrdGJZTnRpRmFrZGloK3RZd1ZmdUNwcVZQRDhpdUVBQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D91B331FDB14744B0D5C9C1B0034659@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	C5JaOQelMwhfUQf/uB7NgLkZQVJ2jB2C/XK5j87M5ldES4x5EbcVw/0JyrJFuwi1yk0UquBnN73cnfJvasAv0MzeZWZVztB45Xpy6F04DsQllKkRebtRkSaSRRhEdso3FHtepA5+lh2zK+6P7MewwJxBCK4vW7oVfzsaFiGJnFCSu3dC91Gmk8oGG3urVZoNlO+YL+GGU6+6KJq/4XjJQ/T+O1WcCkdqr5SeQNOp0BrJLZ1qm7jpcKZ30fZXnPBy4MLM63hdVkAQSujS2oVTjprX6BHPwVOlbQ3t/5Yyngeo8qMM/tbvBgDmyaWfXQMPvdKPdpmEPEf78B5L+PmzYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GYCzwZRKxkPvPWBxqPyweIwg0j0XF6ubNxHyNjmiP3LyE/Z80Dh+ryulScDZR/AfByX6iNmZuaUWVKHBu6TULBh7JoC3aRNsqf1s27Kv8IV7VCHPg0w9iFM/y3ff0PQF/w98LQ/i/mnrWdp4V/6Bs0q8XxIZpSxeKH1q92TkCch+QoIvaYmmjQPN10FFeO1H9Tp8ZoniioHe3m1pAJg8FCNZtVuGJouvjPrWv+rwKwkjEKU8fqjq1HXspnhnA4SVt8Hf0rK0uAR34wBQ+eXY0F9/jQ4dg8sSdhG5kZ2l+5jejqvTTWdHQnkckJYSoXpdU3O4m0cfbvj2ezsCB/caSX0jx08XPxasYmpxlr0v2M7awO9RfD+jqQHm8iynTp4R+rfnbrD/oP32dAwvurSAJRpENG2TLvHPpiNuF45qSOzZbJCc+z7EM5+y6PTf1n2ZuZ7Emj66/p/pU03lJg7LF6SBt+n2aKyUoZ4PQUmi23xTQmefQ88rCOsepyW8uTIuwI3z7PRvZqsQlLQBtS87iy27RwZ4bJu0psBw5Qjm6mdAhYJaAMXlN0NZNT0DtLSsya/nA8LHSpVWkpwb3TlfPaqjdlYpK39R0wLO7CwSoINM+Rf8vGA/YKs1NFQVw1So
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LVXPR04MB9982.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9711eff9-fd9b-478f-8d20-08deb24fbe34
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 07:01:09.6049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDfuQAslnrJzNuHQweuFIM9H84AR/kjxfWS9hlf8M78oB+Z5c0Dw+OHM72TMxUxfRZkmX8s+4nUbO7EQIml7OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7084

T24gMTMvMDUvMjAyNiAxNTo0NCwgRGF2ZSBDaGlubmVyIHdyb3RlOg0KPiBPbiBXZWQsIE1heSAx
MywgMjAyNiBhdCAwODozNzo0NUFNICswMjAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gVW5k
ZXIgaGVhdnkgZ2FyYmFnZSBjb2xsZWN0aW9uIHByZXNzdXJlIGZyb20gUm9ja3NEQiB3b3JrbG9h
ZHMsDQo+PiBmaWxlc3lzdGVtIHNodXRkb3ducyBjYW4gb2NjdXIgaW4geGZzX3pvbmVfZ2NfaXRl
cl9pcmVjIHdoZW4NCj4+IHhmc19pZ2V0KCkgcmV0dXJucyAtRUlOVkFMLg0KPj4NCj4+IHhmc196
b25lX2djX2l0ZXJfaXJlYyBleHBlY3RzIC1FTk9FTlQgd2hlbiBnYXJiYWdlIGNvbGxlY3Rpb24g
cmFjZXMNCj4+IHdpdGggZmlsZSBkZWxldGlvbiwNCj4gDQo+IHhmc19pZ2V0KCkgcmV0dXJucyAt
RU5PRU5UIHdoZW4gYSBsb29rdXAgcmFjZXMgd2l0aCBhbiB1bmxpbmsgb24gdGhlDQo+IGNhY2hl
IGhvdCBzaWRlLiBXaGVuIHRoZSBpbm9kZSBpcyBub3QgaW4gY2FjaGUsIGl0IGNhbm5vdCByYWNl
IHdpdGgNCj4gZmlsZSBkZWxldGlvbi4NCj4gDQo+IElmIHdlIG1pc3MgdGhlIGNhY2hlLCBpdCB3
aWxsIGdvIHJlYWQgdGhlIGlub2RlIGZyb20gZGlzayBhbmQgdGhlbg0KPiBjaGVjayB0aGUgc3Rh
dGUgb2YgaXQgYmVmb3JlIGluc2VydGluZyBpdCBpbnRvIHRoZSBjYWNoZS4gSWYgdGhlDQo+IGlu
b2RlIG1vZGUgaXMgemVybyBvbiBkaXNrLCB0aGVuIHdlIHJhY2VkIHdpdGggdW5saW5rIGFuZCAt
RU5PRU5UDQo+IHdpbGwgYmUgcmV0dXJuZWQuDQo+IA0KPiBJT1dzLCBhIHBsYWluIHhmc19pZ2V0
KCkgY2FsbCB3aWxsIGhhbmRsZSByYWNlcyB3aXRoIHVubGluay4uLg0KPiANCj4+IHNvIHRoYXQg
YmxvY2tzIGJlbG9uZ2luZyB0byBkZWxldGVkIGZpbGVzIGNhbiBiZQ0KPj4gc2tpcHBlZCBncmFj
ZWZ1bGx5LiBSZXR1cm5pbmcgLUVJTlZBTCBpbnN0ZWFkIGNhdXNlcyB0aGUgR0MgY29kZSB0bw0K
Pj4gdHJlYXQgdGhpcyBhcyBhIGZhdGFsIGVycm9yIGFuZCBmb3JjZXMgYSBzaHV0ZG93bi4NCj4g
DQo+IElmIGl0IHBhc3NlcyBpbiBYRlNfSUdFVF9VTlRSVVNURUQgdG8geGZzX2lnZXQoKSwgdGhl
biBpdCBpcyBzYXlpbmcNCj4gdGhlIGlub2RlIG51bWJlciBjb21lcyBmcm9tIGFuIHVua25vd24g
c291cmNlIGFuZCB0aGF0IG1heSBiZSBpbnZhbGlkLg0KPiBIZW5jZSB3ZSBkbyBtb3JlIHJpZ29y
b3VzIGFuZCBjb3N0bHkgY2hlY2tzIG9uIHRoZSBpbm9kZSBudW1iZXINCj4gKGxpa2UgZm9yY2Ug
YSBidHJlZSBsb29rdXApIGlmIGl0IGlzIG5vdCBhbHJlYWR5IHZhbGlkYXRlZCBhbmQgaW4NCj4g
Y2FjaGUuIElmIGFueSBvZiB0aGVzZSB2YWxpZGF0aW9uIGNoZWNrcyBmYWlsIHdlIHJldHVybiBF
SU5WQUwgdG8NCj4gaW5kaWNhdGUgaXQgd2FzIGFuIGludmFsaWQgaW5vZGUgbnVtYmVyLg0KPiAN
Cj4gSU9XcywgeGZzX2lnZXQoWEZTX0lHRVRfVU5UUlVTVEVEKSBjYWxsZXJzIG5lZWQgdG8gaGFu
ZGxlIC1FSU5WQUwsDQo+IGJlY2F1c2UgdmFsaWRpdHkgY2hlY2tpbmcgdGhlIGlub2RlIG51bWJl
ciBpcyB3aGF0IHRoZSBjYWxsZXIgLWFza2VkDQo+IGl0IHRvIGRvLS4NCg0KQWgsIGlmIHRoYXQn
cyB0aGUgY29udmVudGlvbiBmb3IgWEZTX0lHRVRfVU5UUlVTVEVELCB0aGVuIEknbGwgcG9zdCBh
IA0KcGF0Y2ggZml4aW5nIHVwIHRoZSBjYWxsZXIgKHhmc196b25lX2djX2l0ZXJfaXJlYykgaW4g
c3RlYWQuDQoNClRoYW5rcywNCkhhbnMNCg0KPiANCj4gSWYgeW91IGFyZSB1c2luZyBpbm9kZSBu
dW1iZXIgZnJvbSBhIHRydXN0ZWQgc291cmNlIChpLmUuIGludGVybmFsDQo+IGZpbGVzeXN0ZW0g
bWV0YWRhdGEgbGlrZSBhIGRpcmVjdG9yeSBkYXRhIGJsb2NrIG9yIHJtYXBidCkgdGhlbiB5b3UN
Cj4gZG9uJ3QgbmVlZCBYRlNfSUdFVF9VTlRSVVNURUQuIFRoZSBpbm9kZSBudW1iZXIgaXMga25v
d24gdG8gYmUgZ29vZCwNCj4gbW9kdWxvIHJhY2VzIHdpdGggdW5saW5rIHdoaWNoIHhmc19pZ2V0
KCkgaGFuZGxlcyBhbnl3YXkuLi4NCj4gDQo+IC1EYXZlLg0KDQo=
