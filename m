Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1BF3890F9
	for <linux-xfs@vger.kernel.org>; Thu,  2 Apr 2026 07:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114756; cv=fail; b=uuv6yELCu8jJR6sNzOZL6j1XyikUzO2ISDsO/oggP4aKImZMeSNgUECC7mKuuLqpATa6Z0fqCDFA1f/qJhMzCquaa2oYBnftn2y2B/1NMxdUGJrWCrmMO3g2JmBZ2oFCg2KjmXRB5JyCwsIJfs+EIP9yRpC5F9lQ7M6wnc0487k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114756; c=relaxed/simple;
	bh=4mRiYS1I9D7TO3m6BHwNPqutqNxkmhyGDJgIZvD8Hlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jKqLvCU+21vTqwOjmIbEESAOfaSOQXE26lgonhjMv7MxDC1h5fN6e+t8hUg9Ajqw7M7V0yV5F2FLpQ/7KQmednl67YMbY/G7eefuTdCWXarTtVMGoJYw7sj2lj4+lDKE7oHFgBRkmvoKH7PZE+ToTte3GrvV3A8fGEmm4NB1nI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=i2cacEW8; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RX+8wuHX; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="i2cacEW8";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RX+8wuHX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1775114754; x=1806650754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4mRiYS1I9D7TO3m6BHwNPqutqNxkmhyGDJgIZvD8Hlg=;
  b=i2cacEW86ggbEkQ72sReCVfbRZVwTQtJqKWAs0y8jvbniloZ0tVm+xUw
   JHiLPuP6KuVVQ12lRSnD0QpYAzQGbFUfEN1KOwhVIgCMQ5wWGZniJ8Zxp
   o9w01N39BLAoXmHnk/XzSc70/sqP4YJ0ptrQuN+Hb3KVVS/yHhqbD8uNT
   e9OgThzXSocmirHJNEz0MNsNq0jT/RBWPvZXfnefzi4qy0dswx855Q15R
   n03iyQhNnzKGCz10opdql+dtmUedbk6SJ/S4IuKa+qS9fHuDPcv/5DMq1
   PJIDkLTlbB4Y0NbrDFipUTC4GjD/ij3lVSP78uAP1m2DVMLonFo/hm28Y
   w==;
X-CSE-ConnectionGUID: OQSHzi4RSbmSHF86QT+zlQ==
X-CSE-MsgGUID: 5ARGuXVmS2uXRx7e9W43mg==
X-IronPort-AV: E=Sophos;i="6.23,155,1770566400"; 
   d="scan'208";a="143737484"
Received: from mail-westus3azon11010058.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.58])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Apr 2026 15:25:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yztqoQeYqqqSdx2waIY/GfoBiM2yB0HTzAJqd0JKV6eulR3n47/GNld5cJObrheylf8sMhvSWDY/FcC2ixeAPBnjnnfooEvGC3YpfdQH4HDcGzuAqwLYw7mlD+mBgukhf03oB2TOtz+CluR0us1Kyy+8hgloUeEIvtt/fN88e9oDV0l+wE376IYYt7sagMbR6bmm+wB2TH8yhPz9PH5bJKE/cW9Lh7hd37Pj3axTjtDv+UE2JBUs20uC3dN6foCqeTumxPA8cp31cV1ucaVDUdO/j3wKhQPdpNAlB/ANdslAFigK+b0XfAobnv8B2+DR2M7W9tElmgIkQvLvtaxkEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mRiYS1I9D7TO3m6BHwNPqutqNxkmhyGDJgIZvD8Hlg=;
 b=khtWAX6FOxjvEHELhKips7OByJLf1Wq+zmxSOOzGPddtzsIgjSc6qAdWZiXNvGcpUXAKa10xQyloIPGK88gBs6wV1yv7b4BBBKP8fSH+GVGkYRLnd+LD85Ia3b8Q9NV8tcsYDRW7TGxkJ12G/ADPJ/TlNAo7EDyJ7MoPqNqR9yGr1gSJPFZkPca6d9Ccdfwo61IpzLJJrEJMF7/1KoCddWxeWMXDg5PD2655PrK3yxheE9VXHeoJxsAH3b0RKQ2TN0qRLxGJrSGuoJcw4q9rvvfXt6mf4KQnYQU/0+1T3dQqs0hkHDHcS+qrg7IPrcjikFAYZyHuNa8PZEYGMJNMvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mRiYS1I9D7TO3m6BHwNPqutqNxkmhyGDJgIZvD8Hlg=;
 b=RX+8wuHXb1ZCCY4i4NQXH65NGFcnRlr1Gb3Ra+/T1Ntv2k32J5xedFOa/NVimJjiIrTfv6ip3n8kL5kGulch5ROWnHImFGLGvpBU/xZsB/XqaGVUlp3MOBWjCT4AJlcPBrjckMNOEL+nYvdamEqzQ+c/yS0vtuoa/aaZPfigxAg=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by BY5PR04MB6627.namprd04.prod.outlook.com (2603:10b6:a03:22d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 2 Apr
 2026 07:25:45 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::5df3:d910:6da7:49ba%4]) with mapi id 15.20.9769.017; Thu, 2 Apr 2026
 07:25:44 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "dlemoal@kernel.org" <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix number of GC bvecs
Thread-Topic: [PATCH] xfs: fix number of GC bvecs
Thread-Index: AQHcwd+VRj26xQGjc0SYtCRUdQU3H7XLYBYA
Date: Thu, 2 Apr 2026 07:25:44 +0000
Message-ID: <c052461d-31d4-4296-8268-8fe3c7863bc3@wdc.com>
References: <20260401135801.124987-1-hch@lst.de>
In-Reply-To: <20260401135801.124987-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|BY5PR04MB6627:EE_
x-ms-office365-filtering-correlation-id: 2d3e7ff7-f011-4891-3bb4-08de90890dc9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|19092799006|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 uUex+AS7w2jurR/pXrWJA5Fnw+a8cmusfZrT1FKHKb82aMZTVQ3tiRQddnbeucQiNsf1I1R5FAYkq8ojgXCIttMkn99CjZnAjjoPTLjiPWwoyY3x+F4WVOCBi28w6cO0I7pCtbt4EcciPYWLHEWYxjEQj25Tu3aEtIIR/G8opXztKqyT0Q1W12ySHoi4O41rlhJ7vz16NO8nfaziPfkNlsD5diMRi/SgZpDu3jF+TfjTp32+qGj6R+1I+cN6ZCPascqGEDeZJBth3Yq5r9pwh9W6pL/k4G3X/iG2TN4pOhLsNVXum3xwoKAfOuuC00VJ1dnHYKM4enC/wHmF/67Ue2BxMIevWFwFnoLMvIr7rVEPDQavirovPGA0jLaCBJR1cuhebIEZRRE0sMmDsz6DlTujrleiG/4I0FolMoTJfwGrdkO07kICC/SQFPJrB7FEze5QOkn5/vWDRc1p/SsrC7wnCjERaftLCnbCweqrsfhYM+0fxrK/DeMMSRHprjEaUM8UVjyJ688iiMxUiMysypZ1bBo+FXJNv5eFrLdJ3iyseuSIPQqUgL4ozuxo737YZf29UKk06OxTV/hpzlhuf5MVEqvCzY+QdFnGbG+gi4ZzGFEaNFr8ELgAWdSxpPmCkHPC99ABaZlIzIPstxRbXNLrsgxQm4wDoG9KFSs7NQq2ai6HTItj0EWc4pu30qA5bp+umZrSV9cuMo23gT4RUPp7QW/Pz6x5IDNZ/5V/zwk8UFqsVZ7dueYYq5D7ctw8hkUvDZW3x1WmwT7uUOqDxY8A7qzoFJKWmd1hWerEJYE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OTF1Mmx4aGgvZmNZNWZUcmhOT2RwV3o2MG9GK2YyZlBKR0pEVDltV3piMC9u?=
 =?utf-8?B?MEhQQ3l1NVpDdGx6KzZwWnNveVhOV2p0emc2R0JaL0kxUWxVbmE2eUI5YXVm?=
 =?utf-8?B?RExqOElrUER0dFR6SWlkZUdPNXYwUjBRNWkyKy8rb25JV2piU2lab0RnazNH?=
 =?utf-8?B?akJMY3pEa3FxdG1iU2ZzUThLQmpuNE5haWJCMmFldkJJMzBsa0cvYlFnbldO?=
 =?utf-8?B?eTdoRFo5ekhIelZVMlJDTWVUNXVnUTUveDhRcitkaEFOV0VWWlEwMlFTRTNI?=
 =?utf-8?B?OXNESGlRanN2S045Q1VxRzdRbFlveEdlMnVSZWYxTXVjbEFKSGdOa29TaGZ6?=
 =?utf-8?B?NlRXNjVBTGVyQXNUbjQ1K1BHbjhOTkJMNUpBRlZRWHdUdHZ6SlBveURlKzEz?=
 =?utf-8?B?UWMzaW1lcnZoNU1kSjRLYUdwTE9OVXRwZS9aZGdtUU56bkpQNmZtVGF2S0sz?=
 =?utf-8?B?QlM2bE4xV2lyS2FmeVJJTWVtNGZzNU1ibDBId3duOHU2SjRCY3J5L3dJSzJO?=
 =?utf-8?B?cDdoM25RZENPOEhNbXozclg1MUV2eFBDQXlCZWQ1U2hQb2xkVndMeDdwaGFp?=
 =?utf-8?B?TEFXbGFjNTUwZmVvMStaZnZxSGVmeWxjb09KN3NSN091Zkw4eklZNTgxc21Y?=
 =?utf-8?B?Wjk5UXJHOVBQMEphT2NGV3UySk1DakpkQzE0d3lIZVMwWlZnSjZ1dTNJekRO?=
 =?utf-8?B?MVBVUjZsbkxyZERmRUFFTlFmaGZ6cDZseDhXUkM3SnpzQ2NWaDhHRER0T1pa?=
 =?utf-8?B?bkJNSHFzYWRHU2JKdHhHNE5JTFZKRiswekN5cWhUNG5IS1ZsSGRuY1JKYUJ4?=
 =?utf-8?B?RFlzK0xEcUNsanZKTFZyWUZrVkxKbDQ1aFhDemRzZmpoUUNFTWEwQ01seVI1?=
 =?utf-8?B?VGV6ZS9YclpKTi8zdUp4UGk4Yk9TSmd3ZGZMRUtEUkhMQzZKQzMvSmZMTjZM?=
 =?utf-8?B?bWZEUWozY3RzRzBsTnF5bFY0WFdCRlptOGQ5M0treERBRzQrMmJXK1FrdXc3?=
 =?utf-8?B?RnQzSTdWZEcxbnY4VEtZZUhkbW9TRTVKMXRhTmVNeldaUjFGMUxnL3Rmc1Vn?=
 =?utf-8?B?WDREbkltbTZac2ZsdWFPQUpPOFZLZ0RPRnNzUVAvZDBrK1RZNzRRZTVTM3Av?=
 =?utf-8?B?V0VQOWFVcTRiZUFLc0MxZXhaaGE4VnZlcmVjTWorZ0pWZHkvclBtR0cydWNY?=
 =?utf-8?B?dm83Zk1YY2VtWXd1NUlUSUF3MTk4aUo4dTUzOFJ0TmpFUEk5aTRSV050dEhB?=
 =?utf-8?B?MTU2dTkrSVJvclFhQnFaaDYzaXVPQkVwSG5lNjZEQXp2MmdRYWZGWm9DMURX?=
 =?utf-8?B?WWN3OS9oUE0rVStJTFhLYzRPSjFOTWhRK0d0WWZ3RXFPdXhxSWNMOThWanhm?=
 =?utf-8?B?OFcyWXlEWW9KU0RPTHJkRSt1Z0NpaDhTbHE3U2hxaTVNREVBVXdkYzNTNGRv?=
 =?utf-8?B?YTlGaWFpc3BkQXFFT1RHNUtnR0hQUG4wSStnaDhUUU1TZ2dwRyt1QllGU1RD?=
 =?utf-8?B?b1ROMzlYbE80UTR2djFwTVZ6N09mNTFwNk5HZTIwbThCZnpXQVFsZUtKZ1JM?=
 =?utf-8?B?cVJ4T2t1U2tacEJRQlRUVmdLZkt6bFFJd2VKeVpiNG02dkF4bTJFZEhlVHJD?=
 =?utf-8?B?M2x1bUU5K1NETys4c050LzJwR21DUjFONllZVzV2eVExWjJqaVR3RVF5Vldu?=
 =?utf-8?B?SkFISVlTYmd5RXFud0xTdnlWYytHcktEYzFSdjJRTGxDR3ZnWDh2R2VSSDM3?=
 =?utf-8?B?Y01XU0o3MzRpNFZrSytMRHJZNkhDZlNvMEp3SVBlL2xJT3JERHh4SlZYK2lT?=
 =?utf-8?B?UDN0UlgzOGt6VjBNcmI1N0RUWTZoQkVrNitPQUd4ZmhkaytRVnJKb0hENGFn?=
 =?utf-8?B?WlA4VVd5VkdXT0xuVUo3UGtoditPSmdzSTNIYUc2dy9WdnpKMmNxdE9CdkFF?=
 =?utf-8?B?aVBEQlJJeEM0Vk9nN1J6OUpaRVhFU3hrRjBmQmRDbEM1UitlZ1FlODQzUzNx?=
 =?utf-8?B?L1B2aWVQME5XSFJFVXRyQXdOa3EvSFNoSjhCamhVN2MvS3NRek43VzdMaEVU?=
 =?utf-8?B?aFFkNHc4WHlzT09VUTBmVnkvbGoxbzdDZUV3VVp5eXZzRXZPQXp6eit2cjNv?=
 =?utf-8?B?T0pBL3EvUkdFNURBREo2TWJFVHVYTnE4cHBzQldIZmJValkzbUJaM1hSMFlR?=
 =?utf-8?B?WWpTM0NyUHZVM1l2Y2JxZGY0WEgremhVelBFMDUyOFMrVTlrWGR0bmsweWNH?=
 =?utf-8?B?Q0dabGsySGJLSGM5bjROc3Ztd0ViVFFwc2dPM2xZSlFtd2hqMXVzMmlhTjRH?=
 =?utf-8?B?ODVVOGFtWnJNb1JrUnAxdHFHMXV1RkZTL3Y4S2ZZRUo5ekRMd0swdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29B964DC38C8984282BECF355DD74C57@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	QcfAfAoIBx5G+FspYasIPyDjWA4wwmHG7XbHIbjqqUj27KqdRrQADMRsj7SYrH6rnqQh9s6eqjOOJwvVnqTICNd24+IGOi2gmctqbWyxkmUZ5y8hJvV1adxIoG57g8Zj9PDrECMWMo/Pr33/VQUjCpXDIXVcm0mJD9mmqIekG7TMKwf8lePb8vFyQeDZo1nXHyEb1gwe0IjdReVdL06A9744XFm8bXQ7wFsQSFGu101g0ponfVViyK+mAaGtAU2nx0dQsuEEOhXR76gIdsaOZsfgtCqUoyw5sXnhUhA45NqvgmKiL4wvuxT9k6cY06qjxoN6h5RomCPmodIBzwCeLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WTAGUrRgPxNxQgVhktlu6JrlJ+8+IGjCXhrdgrfnsH1GKtZYfRcD10Fm6YZTgCrAMdN6s+2+ubEdJldu8w8A5yCbTbjs/sLlX9IqYRLi8boKTY5ZhMBCMq/g/BTUoaJ7euc1Q+zrpGjkxeh0GEz6h/eQ5kulZD0l1FKBzHphc5vvNJ8Z22+Wy9MraEk8dDzI6NTgfAHdVwO5qV47t7SfyVeQ6UKFjemkfPz/pX0SxpQjuylbTQE0jYlgIArJsk/wqaGnGGBV4xMB7AIZIvPhEK25zCEZ5I/s4RGfxs0xjRPM5EkkGe+m8/9jQYbbX+Ln7YaqTdHTBDM8jn3yLxDdW4QObHWqstQKAUKnTiZXKJ39XXsJtcMA3Lvqmqe3UyRSmBhsFs+UVsrq5MC6II8kFwK90qzVmykFayoANfqh4GmbnEwv4IEpq/M/uN+CiO9vJLKJs2KC4STeRi/r6Mu2ge8402fHklmTCsSZn6pfY4Hh9g7k+rZMnv++B3vqz2aFvtzo2pOuMNizvCJWOygz0s9EV3n4rScQK4M64Ygq3YW49/7ci0aZvgeu8PtHZ6/a5QIGhs4PXhu8/qQShtZMLkDUzb7d8V0LTuKjqAsLr4qgpPnQJXj/1SekiLg4rT07
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3e7ff7-f011-4891-3bb4-08de90890dc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 07:25:44.8769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgeE0HKpafqmmMVfeG5la5BsZMC87TDPVH4iMvMj6gODu4s/twatnOKAaHCOOaJEDfNcYSlnmFXgkVior80cqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6627

T24gMDEvMDQvMjAyNiAxNTo1OCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEdDIHNjcmF0
Y2ggYWxsb2NhdGlvbnMgY2FuIHdyYXAgYXJvdW5kIGFuZCB1c2UgdGhlIHNhbWUgYnVmZmVyIHR3
aWNlLCBhbmQNCj4gdGhlIGN1cnJlbnQgY29kZSBmYWlscyB0byBhY2NvdW50IGZvciB0aGF0LiAg
U28gZmFyIHRoaXMgd29ya2VkIGR1ZSB0bw0KPiByb3VuZGluZyBpbiB0aGUgYmxvY2sgbGF5ZXIs
IGJ1dCBjaGFuZ2VzIHRvIHRoZSBiaW8gYWxsb2NhdG9yIGRyb3AgdGhlDQo+IG92ZXItcHJvdmlz
aW9uaW5nIGFuZCBnZW5lcmljLzI1NiBvciBnZW5lcmljLzM2MSB3aWxsIG5vdCB1c3VhbGx5IGZh
aWwNCj4gd2hlbiBydW5uaW5nIGFnYWluc3QgdGhlIGN1cnJlbnQgYmxvY2sgdHJlZS4NCg0KSSBo
YXZlIGEgaGFyZCB0aW1lIHVuZGVyc3RhbmRpbmcgdGhlICJ3aWxsIG5vdCB1c3VhbGx5IGZhaWwi
IHBhcnQsDQpidXQgYXBhcnQgZnJvbSB0aGF0LCB0aGUgcGF0Y2ggbG9va3MgZ29vZDoNCg0KUmV2
aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhhbnMuaG9sbWJlcmdAd2RjLmNvbT4NCg0KDQo+IA0K
PiBTaW1wbHkgdGhlIGFsbG9jYXRpb24gdG8gYWx3YXlzIHBhc3MgdGhlIG1heGltdW0gdmFsdWUg
dGhhdCBpcyBlYXNpZXIgdG8NCj4gdmVyaWZ5LCBhcyBhIHNhdmluZyBvZiB1cCB0byBvbmUgYnZl
YyBwZXIgYWxsb2NhdGlvbiBpc24ndCB3b3J0aCB0aGUNCj4gZWZmb3J0IHRvIHZlcmlmeSBhIGNv
bXBsaWNhdGVkIGNhbGN1bGF0ZWQgdmFsdWUuDQo+IA0KPiBGaXhlczogMTAyZjQ0NGI1N2IzICgi
eGZzOiByZXdvcmsgem9uZSBHQyBidWZmZXIgbWFuYWdlbWVudCIpDQo+IFNpZ25lZC1vZmYtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9u
ZV9nYy5jIHwgMTkgKysrKysrKysrKy0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hm
c196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPiBpbmRleCA1ZmU4NGU4MmZmMWUu
LmIyNjI2YTQ4MjU2MyAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc196b25lX2djLmMNCj4gKysr
IGIvZnMveGZzL3hmc196b25lX2djLmMNCj4gQEAgLTY3MCw3ICs2NzAsNiBAQCB4ZnNfem9uZV9n
Y19zdGFydF9jaHVuaygNCj4gIAlzdHJ1Y3QgeGZzX2lub2RlCSppcDsNCj4gIAlzdHJ1Y3QgYmlv
CQkqYmlvOw0KPiAgCXhmc19kYWRkcl90CQlkYWRkcjsNCj4gLQl1bnNpZ25lZCBpbnQJCWxlbjsN
Cj4gIAlib29sCQkJaXNfc2VxOw0KPiAgDQo+ICAJaWYgKHhmc19pc19zaHV0ZG93bihtcCkpDQo+
IEBAIC02ODUsMTUgKzY4NCwxNiBAQCB4ZnNfem9uZV9nY19zdGFydF9jaHVuaygNCj4gIAkJcmV0
dXJuIGZhbHNlOw0KPiAgCX0NCj4gIA0KPiAtCWxlbiA9IFhGU19GU0JfVE9fQihtcCwgaXJlYy5y
bV9ibG9ja2NvdW50KTsNCj4gLQliaW8gPSBiaW9fYWxsb2NfYmlvc2V0KGJkZXYsDQo+IC0JCQlt
aW4oaG93bWFueShsZW4sIFhGU19HQ19CVUZfU0laRSkgKyAxLCBYRlNfR0NfTlJfQlVGUyksDQo+
IC0JCQlSRVFfT1BfUkVBRCwgR0ZQX05PRlMsICZkYXRhLT5iaW9fc2V0KTsNCj4gLQ0KPiArCS8q
DQo+ICsJICogU2NyYXRjaCBhbGxvY2F0aW9uIGNhbiB3cmFwIGFyb3VuZCB0byB0aGUgc2FtZSBi
dWZmZXIgYWdhaW4sDQo+ICsJICogcHJvdmlzaW9uIGFuIGV4dHJhIGJ2ZWMgZm9yIHRoYXQgY2Fz
ZS4NCj4gKwkgKi8NCj4gKwliaW8gPSBiaW9fYWxsb2NfYmlvc2V0KGJkZXYsIFhGU19HQ19OUl9C
VUZTICsgMSwgUkVRX09QX1JFQUQsIEdGUF9OT0ZTLA0KPiArCQkJJmRhdGEtPmJpb19zZXQpOw0K
PiAgCWNodW5rID0gY29udGFpbmVyX29mKGJpbywgc3RydWN0IHhmc19nY19iaW8sIGJpbyk7DQo+
ICAJY2h1bmstPmlwID0gaXA7DQo+ICAJY2h1bmstPm9mZnNldCA9IFhGU19GU0JfVE9fQihtcCwg
aXJlYy5ybV9vZmZzZXQpOw0KPiAtCWNodW5rLT5sZW4gPSBsZW47DQo+ICsJY2h1bmstPmxlbiA9
IFhGU19GU0JfVE9fQihtcCwgaXJlYy5ybV9ibG9ja2NvdW50KTsNCj4gIAljaHVuay0+b2xkX3N0
YXJ0YmxvY2sgPQ0KPiAgCQl4ZnNfcmdibm9fdG9fcnRiKGl0ZXItPnZpY3RpbV9ydGcsIGlyZWMu
cm1fc3RhcnRibG9jayk7DQo+ICAJY2h1bmstPm5ld19kYWRkciA9IGRhZGRyOw0KPiBAQCAtNzA3
LDggKzcwNyw5IEBAIHhmc196b25lX2djX3N0YXJ0X2NodW5rKA0KPiAgCWJpby0+YmlfaXRlci5i
aV9zZWN0b3IgPSB4ZnNfcnRiX3RvX2RhZGRyKG1wLCBjaHVuay0+b2xkX3N0YXJ0YmxvY2spOw0K
PiAgCWJpby0+YmlfZW5kX2lvID0geGZzX3pvbmVfZ2NfZW5kX2lvOw0KPiAgCXhmc196b25lX2dj
X2FkZF9kYXRhKGNodW5rKTsNCj4gLQlkYXRhLT5zY3JhdGNoX2hlYWQgPSAoZGF0YS0+c2NyYXRj
aF9oZWFkICsgbGVuKSAlIGRhdGEtPnNjcmF0Y2hfc2l6ZTsNCj4gLQlkYXRhLT5zY3JhdGNoX2F2
YWlsYWJsZSAtPSBsZW47DQo+ICsJZGF0YS0+c2NyYXRjaF9oZWFkID0NCj4gKwkJKGRhdGEtPnNj
cmF0Y2hfaGVhZCArIGNodW5rLT5sZW4pICUgZGF0YS0+c2NyYXRjaF9zaXplOw0KPiArCWRhdGEt
PnNjcmF0Y2hfYXZhaWxhYmxlIC09IGNodW5rLT5sZW47DQo+ICANCj4gIAlYRlNfU1RBVFNfSU5D
KG1wLCB4c19nY19yZWFkX2NhbGxzKTsNCj4gIA0KDQoNCg==
