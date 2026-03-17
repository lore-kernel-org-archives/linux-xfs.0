Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA46B34A3A2
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750025; cv=fail; b=gSANApqoK0A8wb1BgQFCcsdq024WaZdtWFH4HNAMNBwG46Lzm4RCxDNHt0k6ERHUzA9dpr+4uoBA28CAl5poklHXFDqGWhoE6d4qb++QG5z4nPX9ZWf9TsEsrt5sV95D9CYDu/1NXcceVtD3KuKV1XRHZqlHPqZxz9HgnDezI3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750025; c=relaxed/simple;
	bh=0hS4SGoNtosboMhsasOi3zaCFrkihubY7dYMhWYfqp4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lXyS7p1o2sqI4/tppl1LefA1c/EQFUv7L44kCgM47jI6cMxJkPbdad4q78apgTU7rei5XOTpDJ9vjOgRHnYMXuIyWA7mgAF9Ey7FW9nAbIKb7IlNRHj4vwQUvre03CrLlHKV2JyqK3eYrlRYqcZgYrxQU4HPJ6BDF22BnvxX7X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=WJ208L69; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YQM9Mc1i; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WJ208L69";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YQM9Mc1i"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1773750024; x=1805286024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0hS4SGoNtosboMhsasOi3zaCFrkihubY7dYMhWYfqp4=;
  b=WJ208L692d6OGaR6xZgdGuHm6tRmzeR/8Z9tX1XvvlL5Mz6eQl1dvxbY
   kRSvjNSHjq83wyX2otoipLwfMbor/rsseozMUDWW1Fob4CeIrZCEK3Ow5
   wA5AvKGwwW0KBt1+xptcZAHaThsEskSQfnacircgLBCuQpV49DfZVxJib
   XabU8M6xwd1x6n0bkVS8qZ5CJEq94K7wuqlCHFzZuG/+0+hNKXhUOn4Aj
   fEjSPYYi3Shsh1VfZSZEZG67XGMBTW2yEDJjm7UUyF0uYTQRZT9huH0s8
   fbNJi1AjrqUaL87in3B6EqRa8OaqoQOVlKXWSFZku91Ejjysa2e8br0t4
   g==;
X-CSE-ConnectionGUID: B3aAocxjRI2MQJ3aILPObQ==
X-CSE-MsgGUID: aUfaENdBSw60Sqx6E7P6yA==
X-IronPort-AV: E=Sophos;i="6.23,124,1770566400"; 
   d="scan'208";a="142266027"
Received: from mail-southcentralusazon11013042.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Mar 2026 20:20:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7vv0zVfxVkgiObBOKgLvLOGTNSHECSQ1YWYG5nsjZ9IRXiy8Oa1ivPYTqjnrPM34TPyt+TGiGOoqkB3XTCjhOS0w1uOssK6byu5SiM7CwCzx63cAX/kV3LKe04rYQPsCEuxHlsHg2DdGXB74lGRuI9RmMzGXOIPHeLSEFpsxduzZQJGbVO6Eyenzp+lpfZLTzZbHRixor84DCxJv4NBnCu91T6PmTMbFGbLi64LRQmIFPMR1t6iIMGvvHwemLaERUNgSOCmB+HSdYvwrbc7zHyTiWbpKwKLyZ6quL+M7RZk1dqOwBQM6S2jHmpqDsFC93ZzCvFiGdg5u3unkC8pxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hS4SGoNtosboMhsasOi3zaCFrkihubY7dYMhWYfqp4=;
 b=AWUaRgKowWBMlcbResApDRzcumVz85Wx2//6wdokEL6AsuL3b03NRBpHEOoadN+Mny95/JO45XZiccst6CK8YbO1zqEGEbqIKXSuKnchuattubVcTOBW7x+SMohvK92HaiY1FiOmo7lprK//QWmFpOAWwoHGMQ4aG+Sl4HfY2aO1soOhDj62rIy9NEp5YnDEqRvIW3uWjdKsA6P9BUvpGAGwLiLQB2fIILPPXZ7YunewT/HGG1BEE7zsVaEiCI9dRBSis5/Z/8Y93Euvc9eBLhuCxtoiGbQwFklQfJh1yIHyN04I8wp0RJsUoMuZUkSc+oJBZJQsXjXrhEw+MWyxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hS4SGoNtosboMhsasOi3zaCFrkihubY7dYMhWYfqp4=;
 b=YQM9Mc1iBp/zkFNMz557cVLgP2CKILfyUpy/u5myry+ik7/yKQFQpH+hYLM7BsKG7vfcUxGW0bt6JbZ941Wpy50qxzze7zuFgc3XE8+IqZqItJwiWnlRPAFyAY+l+tE7pJKyahhNpru5RdIbrf8ZtSboovtWqBx0CuRJD4ZMx5o=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by LV8PR04MB9295.namprd04.prod.outlook.com (2603:10b6:408:25b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 12:20:12 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::bacd:b9eb:89b5:6062%6]) with mapi id 15.20.9700.015; Tue, 17 Mar 2026
 12:19:44 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Carlos Maiolino <cem@kernel.org>
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/4] xfs: fix a comment typo in
 xfs_select_zone_nowait()
Thread-Topic: [PATCH v2 2/4] xfs: fix a comment typo in
 xfs_select_zone_nowait()
Thread-Index: AQHctTp8ojdGgpmg1kGwf1g4s/KbirWypliA
Date: Tue, 17 Mar 2026 12:19:44 +0000
Message-ID: <a8e07acc-b3ce-435c-9086-0f75cfcf4e11@wdc.com>
References: <20260316114020.753228-1-dlemoal@kernel.org>
 <20260316114020.753228-3-dlemoal@kernel.org>
In-Reply-To: <20260316114020.753228-3-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|LV8PR04MB9295:EE_
x-ms-office365-filtering-correlation-id: 61a2d21f-bafe-4df2-583a-08de841f78eb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 7rfaV9UOLtAOdak0RFGAW+C+WepLJlpiy93ZoIESzIPv3wHegnSFgowyYNLHJCNFuC/vOO3U8ZEQuzywAoFaNUp/Rx9fksCgdbg7//wQFruCdE7QxYbiXSIii4/jrJj9FtQ4PFYzCNYc+C/hs1yv7bY7n5QtXRh5VUoAF2SxAzB2SZ0qVZmn62BsSWo87Ey0Gg4brbhw0MlUklKVwaKefCsiUBSJ/SkP02LnBqYruHfdE23TuusE+nExrkWYwYjAWkLKl7uiIgFWcdt36u6AVP9csK51x/Pt77P5LwFqu5x7DW2OZmTuAdcoGxoE6buKcAYFI4OK292froIdeDfZi+wAg7Hitu+HiRzcARKTCZs3QerVe8fp12cQsncXVKM84bY6OE3/YxB1dE6GfqqGusz3VFXf0F05QhgpJnGxbZYfZkWvpHImcurk2uphquxONHT8xTGpM2KeYB7aMUQEznulO0sEXIBP/aSfnNkRm89c645QtEZY396ppIcso5KAaYlKaUokG090Itc0KaQzydRcsSR33wUhMM67Sc8HaxzU4WjRMsMjgQKaDuQUhe9uwf+sMPRJbOsNOQ/906G8whRneGYfAURCF0BA/KCNYeqlPkPo0m980hPM0IzGLx53Kn4hBw0St2TgPxGNfcgw+U9yxLdskaVgnpEHdfYZlOUiIX4r/EjMwTsXtCC7KjLHq6WGg+7x4WdphY4qFARxUT+CJ9T5HbaqOS076tI3ydaaK0nAFeqT66fkHbs5+4nvWQ3RC747tZhh0DV+GVYCJUiAH+KxbGrQSMJaGhIVQXQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q2tka1hMbjBZRXM1QVFVWTJldFlyMU9PVnAwWmFLclNmc3BpZFdBOWtvM0Mx?=
 =?utf-8?B?SUVVb00ydUpUOWxDSXEwSXduSzFWS0k4ZHl2eHowL2p0RS92SnYrOS9KSmZF?=
 =?utf-8?B?ZjlROHBmVVo4eitoNm1CUUl5VjdkYWZiQXFPekZBbW85LzI1ZmM5RGR0L1F6?=
 =?utf-8?B?RWZFTHBYdktDSEpjUkxFNVdEK2traDdXdXN6WnJFUmZaV2FEQ2JXanJFUDVY?=
 =?utf-8?B?QVVNU1E5bTVEQ1dvM21lRGxWenBJbjg2UkJiaTFGclVjV05VcFpQaGdIR2VZ?=
 =?utf-8?B?M1B1NU1DZCtpVUZLNERobVRRMFI3ZWRjOHVzYi9Ybnpsd2kweTlyc2RPRHRW?=
 =?utf-8?B?RWFIMjRDRUp1eFRXOFJOYll6MVo5eFRoaHpIb0xqU0FFMzQ5T3d4MW05d3ZI?=
 =?utf-8?B?VFNUSjlqcjNWZlpFbUlIOFRSRkMvUHJWbG1FTXR0K3Z5VzNWVTJrc0FKNHN2?=
 =?utf-8?B?OEZpcTZJZDkvN2ZtRTMwVGdFKzFtNU5nRUw2ZStsb2EvR01mWnY3bi9rV25k?=
 =?utf-8?B?blNuUS9vd2Y0N1UvNzA2U0x2Uzh3bEs0ZUU0ZnlpOGtneEIvaFhxMDE1cXo4?=
 =?utf-8?B?aStHTkovR2VnTHRWdVAvUk9KcjM0azhLbW5TanZ6M2lLWXNwZ2JFZzh1UlNv?=
 =?utf-8?B?OURrNUhOVXUxVE5xTE9aUHd5VVlWZTY2VHhnMG1ZM2lpbnNRZUcwcDlDSzBV?=
 =?utf-8?B?Vlg5T3FCTitqOW01Mkp3ZGFkcSt2SnpjdENnUHB6MlB1d1hkVlNHWXVEbzIy?=
 =?utf-8?B?TzFHOWRVektUa3RsR2hhTWR2cnNtRTQxNE5tTlF0Qk51SEdCUVlOVS91VnNt?=
 =?utf-8?B?bnBTUHRqbXpJaXpBUDJBZk95blNaUjN6bHVDd3RxM0R4NTV3RHcxamlBNjRH?=
 =?utf-8?B?SDNLRjJZU3FpT1VWYXV0S3BNNitJL1NIRXVtR3BSZzVjLzFUb29xMGdLSUZ4?=
 =?utf-8?B?akhhOVBWNnBPTkh1aFhKSlFLOEhqZkhBMzRpcWc1aWx1UWRFTlUyZG1ucXhX?=
 =?utf-8?B?MFNpS3hDVEJQVStyUlRzemF4OERoNTRRT0xCRHk0aFRFa3BUb3ZOZFlWempZ?=
 =?utf-8?B?a0VpWjkxU3VhZHFnVmVPRTYrQTROemdXaWR3clFjOVp0Q1ZsekR5NU5jQTc3?=
 =?utf-8?B?aHdqYi9WTDV3M0JoSHVCbkNpam1FendzS29obVVKSUt4L1dRc0RORnpJNUFW?=
 =?utf-8?B?bTZhNHZMbWpIYTB4ZWluWWlnZWYxeUpyVHdxRThaNWFFRWdtMkZVeGFsVDhk?=
 =?utf-8?B?VzFnTFh2NlFMRlkrUldCb3owN0FUYkg2d3E1eWt3VTRLMlUrWEhlekttZ3hV?=
 =?utf-8?B?c3NsM25SMms0S3pnRFNJY1VudjdYRWgwaHFhZ29Vb0Z2RFBYVENSTUlRUkFr?=
 =?utf-8?B?UTNYM295T0dOYytRNGx3MXBoaTZocGRjL3lsV1JrL3lsWkVyc0p4aGVXaFZY?=
 =?utf-8?B?bFUvNkhFL21mNXh2L2JFS204aFF2dmRJT0kvQ3dWWTFSNTRyelFZVXNHb0pl?=
 =?utf-8?B?UEZKYVYvMm1uNHZJcVhSV1VLcFBOVHExbjFZVE5jc3RGQ3EzSHRxMDRVU2ww?=
 =?utf-8?B?SFAyZjZrZ1hnTE5CMWVkVTl6S21qRVJUZ1dkVXpLVG8rUUpVTUVkYUVEME1h?=
 =?utf-8?B?OGM4UW5lTFhxZm5td2FnOEpQMC9WMWNadlByR1AxK3QxSWFJdFFzOEFDbG9w?=
 =?utf-8?B?TFMwTEdyUnZSTXlmbzJDL212Z05ja1BGYWs3L3oweEZURGxyS0JMeXcxckNo?=
 =?utf-8?B?WFRNZVFjWkZydjVSUEtsU1VwWm1DVEs3ZUVhZkFhaWVqZ0l2YmVCcFc1NFBl?=
 =?utf-8?B?a3c0a1JwdjRqSTRJbVJHRGYvM2hpVWsycit3bGkycGZUT3FvNXFvOVczR3h3?=
 =?utf-8?B?aGdDdnNWUFhaT2dzeUx1UWNnMTZna1lTWmV4L2dLSXBFcDhhMlg0S3Zvemd3?=
 =?utf-8?B?ZUZLeG9TWXE3WTZ5STh6MFYwU1JUUjErYURJa28rNW5oR08waStHVnJPTHpU?=
 =?utf-8?B?ejdhZW9SOU1DWFM0R2Vvc0xqdDN4NFZIcjAzTjF5ZE9GM09QMHdCeE91SzBy?=
 =?utf-8?B?VHpBMEp5dU5tZWg5eFI3UUFlNUVZTmpCMjBVQkptU1dLQ3BIV21oVEhKRFFE?=
 =?utf-8?B?SHV2ZmtLdExoM3FncXZDcHRiQzdiV05rcDZJbjlHdm94cHJTWHlSMHpIbmxS?=
 =?utf-8?B?Ym44bW9ZZWtVOXV6aWo4T1IrYkgxd3R5S0QyMVdDbThJeGR2MG0xZkpXWEdu?=
 =?utf-8?B?LzFWVW0rRGx3QjZBVEhrcHBoZ0hTN2MydE5NejZuaXpIbFdTaDJ6RXROcWts?=
 =?utf-8?B?YXFrRkRJRUhkOWxaUTUwMDdOMDRrYVpHMU91eTJVQlU2UDlqSXRuUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F710C5F875EE441A44E1945EA96FD24@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	WZfj3lWp0hoAc/TNWn7ISN3fVtEDSO+3kA9vfmYus9t5zrLtNISGSyrQX+ADtBlr7IoaTWY0ODVaF5BUEPAXWqi1t97LkbSL5+i4LuXdvS1jz8rwKnWphu4Ml7NJDkZUSbAqaWWB/+Y3z/USZs2PXJ3SiCdUE1YeGBLGzCJBHz9TY9YlSSs+PcsGKYB4pfeMIvq+CVveEVdoR9cuzEzaTXiKKpIoT1w/z3IYmHdd1U1hhfgLaKQJkFpqhoXy1L4KvmY2B0OflZY05Z+z/Gb/N1nO4k+u+aLfv5++UL8XYd4l79E86q4/tmA8FaE8pmzSbuvexvHPkYYk+qB7NZXNsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xlJebtb4P2F/S2sMVKFA7Y3BzWtbY6HNylQNJI1FcBguhtzhSw9aXnAxJ8mOesPCPRNJgeEEEJ1N2jtzT5vtl39VsqDkiPOzel9PstvVxOcebN8kxa5eP0TB4GXMedxIaVQIwB2s9wEqB3H+Bul7OD7VsoNgKQeZqfYTad3QImXHz2nkaF8bqT7T7gF8FZKjoTtU7uIC6SwZfuIEL8DgplYTYpSNSEzWTq0biKHDX2f42O2Vv9fXV6nwztmh3k7feMPKoGTZkBB7WGUCQSxiIAbp2HKAJshcdYNrMn+yblpfx69XSXdFX4MzQ++N+FbZRUNOfzkLpk74pSa2JPHGxQbYB/wR6+w1YOcA8G5TD848s/l96jpa7C23I+N3c938wLnTvSpqa0y2YkmeV03xqN6tno64ONsfUIxxLKCid3GxOFMqac9heP025qK/8Xr4+Gtwd9gSsJvv+FIpWeZtu+oelJZT5tKpniCg8kTBzTVMS8Sfp1ym24j5MQaqXtTLgSBPQ8PtcKWD1tHZpG9bEEDmocx/W/SUmVlWFzv0qICjMyOy8Kt2g1f9zZWFqypkzdV2is2t4JnRGaypxt/Gr5Wtra7rpiZYzdaIXI+g1zl3tV3UTXR/bNGSHFxJUa7h
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a2d21f-bafe-4df2-583a-08de841f78eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 12:19:44.0443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vob5ovuTcX8u9VLtml9U+GvcnHjeYL9YYyDvjY1Zj9CIsfCwHgGhuNl4DzdtceoTOdhYScOKQeJM0URrIAKwYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9295

T24gMTYvMDMvMjAyNiAxMjo0NiwgRGFtaWVuIExlIE1vYWwgd3JvdGU6DQo+IEZpeCBhIHR5cG8g
aW4gdGhlIGNvbW1lbnQgZGVzY3JpYmluZyB0aGUgc2Vjb25kIGNhbGwgdG8NCj4geGZzX3NlbGVj
dF9vcGVuX3pvbmVfbHJ1KCkgaW4geGZzX3NlbGVjdF96b25lX25vd2FpdCgpLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogRGFtaWVuIExlIE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4NCj4gLS0tDQo+
ICBmcy94ZnMveGZzX3pvbmVfYWxsb2MuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNf
em9uZV9hbGxvYy5jIGIvZnMveGZzL3hmc196b25lX2FsbG9jLmMNCj4gaW5kZXggODQzNWNjYjAx
OGRjLi5hMDU0MThhYzZhOTUgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5j
DQo+ICsrKyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IEBAIC02OTAsNyArNjkwLDcgQEAg
eGZzX3NlbGVjdF96b25lX25vd2FpdCgNCj4gIAkJZ290byBvdXRfdW5sb2NrOw0KPiAgDQo+ICAJ
LyoNCj4gLQkgKiBUcnkgdG8gZmluZCBhbiB6b25lIHRoYXQgaXMgYW4gb2sgbWF0Y2ggdG8gY29s
b2NhdGUgZGF0YSB3aXRoLg0KPiArCSAqIFRyeSB0byBmaW5kIGEgem9uZSB0aGF0IGlzIGFuIG9r
IG1hdGNoIHRvIGNvbG9jYXRlIGRhdGEgd2l0aC4NCj4gIAkgKi8NCj4gIAlveiA9IHhmc19zZWxl
Y3Rfb3Blbl96b25lX2xydSh6aSwgd3JpdGVfaGludCwgWEZTX1pPTkVfQUxMT0NfT0spOw0KPiAg
CWlmIChveikNCg0KTG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEhhbnMgSG9sbWJlcmcgPGhh
bnMuaG9sbWJlcmdAd2RjLmNvbT4NCg==
