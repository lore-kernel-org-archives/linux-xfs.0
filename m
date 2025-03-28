Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2B91DEFE5;
	Fri, 28 Mar 2025 12:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743164193; cv=fail; b=QbfkVQ/N7XoB5we6CGcCCuR3AeSKM+bBUom7zd3WsfCPVqVVR56Gzbunt2DFxoLIb6cF5+sjI4LNjczFsF8rHgMkROlfAEDJ2R0hUGuox1KrAx/EiWB8KhVetnBL+Q7EiYuBBOFXnCQ2gWXxNU2E+Z/elblgwDfY0byJiIXTJKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743164193; c=relaxed/simple;
	bh=kttnYb2olDWzmnfCijc4NhV3J2gWXa+sFAV7eg76qFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0pzEiv1zUSn7MlmutDI/Mkg04f59YUPrY5cIs5aIobdtT5Rcfy81LYkEHLW4BIQjWkWOrf/UkJTv3hFD49auPxSSRRBHN5GYjju5qpeApjQRl3WSP21gzklbETaVe/SG30CXPsgsaLngYxkhjYbmM1PIkfYBnE6YXCu8naMvZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OGIiRu3V; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=lKAYzrUj; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OGIiRu3V";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lKAYzrUj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1743164192; x=1774700192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kttnYb2olDWzmnfCijc4NhV3J2gWXa+sFAV7eg76qFg=;
  b=OGIiRu3VNk3Cqk+VkpKqdRZmZ21hdFElL/5QOJtIi71P9Snjy4nUmVK9
   jT5zgzZIhiSYKT3qJAyYbcbRk4jWZRIr2b4AhJ6GsbiOJ3zl5bJP8kavv
   BUybdsBcOUbYwdR9XXi1J8KfXcRMCjMVcvHgC6FXdIvfs1DhFiFw6wwC1
   zPrPo5I/E/1AvdZ3792VV7RdBiI11WNciYF0jhju07bVUF6FM0nlSK9DA
   GTwLqk3vNJX/XP00wophLwObg6S1EE5kvxCRmxOJoXiK4uQbbdUT8WCsn
   b8u/qPOBFdIx2WM0vGYU25d245OO2pU6endiyxAPNh9VBd2fxwtr/KpeQ
   Q==;
X-CSE-ConnectionGUID: JutJ/skOSOiJ8jHXdc94Lw==
X-CSE-MsgGUID: WM08u5+2SEiE8sMIEJmYew==
X-IronPort-AV: E=Sophos;i="6.14,283,1736784000"; 
   d="scan'208";a="62957259"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2025 20:16:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqVo4RzsglXqceViJhrDOHb+pSh2gIRX4e+I3scamVS7p605nAOmEljiYZuZjUSAAU+eZqdfwoUdomqShqzY0Qd9Wdo6EnSppZnE/tr5MMf/wQ+psXQhmlOpjeviFEULRApvRALqZxhDR0SNjSPm6YW/PvunZPC5YLPmlpQlLxWFb6Kn7isTFXeBpnarPVA9sPJhWNHLZFKqsQ7+Xn0AwDanhSJB935NQ9vtlGeU0Dl2raDKGuIgnI6cwRqnUi1Pj4mHj/FEoxR5jDz7GF+ywM6gj8smQ5RU4AnLevcEyse6cuIYqxA58LyuKnbSC2M5uF/e1JFelKvIEPtxL0v0tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kttnYb2olDWzmnfCijc4NhV3J2gWXa+sFAV7eg76qFg=;
 b=yjUe3H49SztrpK4Zg8/NVfigWiqgoYyJgaewuLrgAfp1YVbxye2gTUT1T6GED+rqBlwdeSlsmzF9+HgcdjK/vyo+OduTS45qvADlpBiDGLztwDB7uhI24axEA4KdZ0ZKF7q0Dy9vgB12t9BpccRVKJ/AoSYHEi0fdT520nR4xfYy9Q9YhfbtU1HvRIYcHZBTI0ZHaNzPE2jkDcmzUzHKdADBcdHXUELKUBMsdzQ535MmuyKm/462I/xhpQrdEXh9Ojrt7xMgcLpOKj/xJGcyeYj8L2YyBG05j678Ja1L5DJ/Go+s+1C+RCdqgF1u2V1DZLCuiAYG4x2iY3Xkk5KbjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kttnYb2olDWzmnfCijc4NhV3J2gWXa+sFAV7eg76qFg=;
 b=lKAYzrUjiyvonL1CLM792k0KqLOdB0qOKhLjQPh1wgA3RrA1QW0TqXvYkUCJmrKbIRzlhNCqJVK+5mcA+FSnfORmAgWA3+NHIYCCQWjdNSvFi0h40Ii5ApqHZvIy+quC0N7CMG/BzgwBWCqELInEdGcbeLTFjC89XRAB3JOazTI=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DS1PR04MB9539.namprd04.prod.outlook.com (2603:10b6:8:220::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 12:16:22 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 12:16:22 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Thread-Topic: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Thread-Index: AQHbnWXN7wqBus3oD0yp1n74cUSC0bOIZrWAgAAU7YA=
Date: Fri, 28 Mar 2025 12:16:22 +0000
Message-ID: <9f48501e-2901-41bb-bc8c-71c480f912f1@wdc.com>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
 <20250328110127.GA20388@lst.de>
In-Reply-To: <20250328110127.GA20388@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DS1PR04MB9539:EE_
x-ms-office365-filtering-correlation-id: 7d2fe045-d5cd-4633-5725-08dd6df25a5b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OW1OQkZUQlNnOENGMjcwdHBuNFA5YmlaNUc1WTJpOGhKQjl4cCswY3g3VkZj?=
 =?utf-8?B?SzhXRk9jU0t4OGpZUkFDcHZvS29KOWp2WDIzZkFUcHU0ajg1SndSZTV2Rk1u?=
 =?utf-8?B?U0lteGxaNlZZbWF2Mndicm5PZXBaUjRrMXNiTGs4SDZ0enBFOVpMNER0UWg5?=
 =?utf-8?B?dXUyVFdwSEFSV0pHaVd4ODVYSGNOZUt2Qmx1REFLOTFwLzFzWjVwT3RTaU5F?=
 =?utf-8?B?c1FrL0FUNFZFTkJTS1EvaDNGZm9SRkVNbTFkT3dxbDFiUFhwMk13dXc2TlpQ?=
 =?utf-8?B?b29GK1VrS0VTRC9iMDFNZ3pCUTh4aEJIRGpXR0VVcktXSXQwaU5OUUsyQkh2?=
 =?utf-8?B?cjR2QjQrQkZIWVRtM0habVVSQUpSOUNuZmw0cDlvQUpNK01pVmdKVVU2YVFF?=
 =?utf-8?B?Y1RIQkhCaG0rZC9xS1F5V243RmhhMTF6Ti9nY2orUU9MOHlHVlNDYWZRK2t2?=
 =?utf-8?B?Wmd6TEhLbkRCMEQrVmJ0SmZsdFlnWVFDKzgvOWEwM0ZhTTZsOHpGT0Z6c1Bn?=
 =?utf-8?B?VWVncTN6ZzUzYmFheVZQSVpMUVVHYmMyeTVpZHN5Mnd1K09PWkVpVE52Ylcz?=
 =?utf-8?B?ODBkMGlLSWNZblZ4WFYvbHRzeFFNb2dLaE9ibGVmN0JQaWJxV0ZXOEZyYUxO?=
 =?utf-8?B?YmhKZGQzaFlQVGhnTFIza2V6UElnc04xT2hSZUFXUU55OFA1dzB5UzhGSlpo?=
 =?utf-8?B?Q3V5b3BGUFF2aUZYcWJtb3FMRittcmtUeHVSR2VjWSszaytYVUozeGtCbHdl?=
 =?utf-8?B?S25ZamJNa1E2cG45V01LQ0xEdzJKQmZCTXNPbmFlU2xaUi8vK3NYYmhqZWpF?=
 =?utf-8?B?MFhFQmtHL0NKR2ttaEtHcElZQWFVdVJhcWYvYmk5V0FRWEJ2SmRQcXQ5SHNN?=
 =?utf-8?B?TTl1RjRRTHpnYU9kWTd2QWxrbTlGemxZWDErMEZYdWVNOFdJNjRKZEEwMW93?=
 =?utf-8?B?a1A3ejhqQzF5LzE0OVl0QkFCSEZjOXVoSVYrN0RQSEh2Wmp0MmhyM1REVnNN?=
 =?utf-8?B?SmpuZ1pGai95blNNT1JodDJJSUd4V2Q3ZTA2eldCYkI1ZEQwbC80TlVUcjJ4?=
 =?utf-8?B?Qm5kZ0JFZ2RqSGZsYWFkdUVZcys1ZHpmRUxoRExZYlRVSzl0SERjdUNiOFM1?=
 =?utf-8?B?OGdBVDVOOUVhZUQzMkdzeExTVVhteW5lZ3RxbDg0Wmh4RklRYmN5UXBLZVc3?=
 =?utf-8?B?ZHZlQlV1NDV2RnV0c1dMNmdNZ0NqWEREN1ZsN2dNQjJKVndHS2lDcTRncm85?=
 =?utf-8?B?T0dPcWNnenRmRCtHNFgya3A1NHNyYVhVL1prWG1DUGRXY3JwVUhtcnFhdEhX?=
 =?utf-8?B?SzBySWJXVFdqZG9xdXNFMmdXSEU4NEIwOFI5YnRsY0dCQkkvR2NwYWR6UFlG?=
 =?utf-8?B?dE80Q0EzbDZVdTIwOS90YkZvYnpmeWFJZzZzZVUycGV1MjA2cFk1blkvRTNS?=
 =?utf-8?B?RjhLRGx4andmL2tiS0J4b1BzUUdRV3l4cVpONFlWVUFuejBDdVFkVjYrbkRr?=
 =?utf-8?B?d2tsR2I4WEZrblZkdXFIa0cxV09PZUNMZVdLZXF6c1lmVDhOZ3FjYVloRWJj?=
 =?utf-8?B?VVpyLzIwTFFzRkl3aCtubG1mUmw4OVpxOVkxdFNTR2VkQjVvRnkwbHZ0RGlh?=
 =?utf-8?B?SS92UnFPbWljWnF3ODlYcC9ZaEptTEhVQU1heTJ2R3poWWphdEtKMXlIVnkz?=
 =?utf-8?B?S3M3VDZybHVObklYOUEzSkR1djV6SzhTN3pqOTVqZW5EeXRhSFlhVEx3TWw4?=
 =?utf-8?B?WFM0SGdXZE5oNDk5U0dDQWk3WDRFMGN0RTQrUVhjZzNpa0hKOUovKzRDS0w2?=
 =?utf-8?B?bUNCc0RCQVMxbHRyeCtWa3RsNFBKMVpqZHJvQmNSOTVjdExtYmszOHZQbTBI?=
 =?utf-8?B?bXVkT2YvS25JSUllVmlsbHZQSVIzOVQ4VTZYK3MvWlNGU0dyc3YyNmorL0pP?=
 =?utf-8?Q?y8YVDevk1DD0v1krlPmpEhgk1IwGRJ4M?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MW5lcG1ZcVI3VzhYTGZ5WW45ZUk3cmNhMEJZTFRxRTY2d05qb1FGY0xLR2V5?=
 =?utf-8?B?VmhpdGl4NWVPQWhJSEpsUCtqcFVZbDdtODUyZlJocTFvQVVYQktoOVRIYkYw?=
 =?utf-8?B?WmszZTczYjZmNFBiVWpvRE44c1dVdjFTQnVYK2haeUJUdFNndmgrMEpXRlBr?=
 =?utf-8?B?dUtaRU55NlIrOXJEM0thMHlRV08venRDVnkzRVJ4cmhjdithVlQxeXdySUtG?=
 =?utf-8?B?ajE5NVk3R00wK2ZtYU5kUTYxTWQ3WGRaSUExTmN4LzFBaE1UaDF2Rzd2T3BX?=
 =?utf-8?B?VUVZdTNPOFY2SVpFTGt2Sk1Mak1YQzVyTVJJVnJUOHlMaU05UkpGVjdYRFZz?=
 =?utf-8?B?WGF2R3NFclJKR0VXejNNWnpYREJKVkxlYzFlM2hNSlFpazBNYkRuWkNrQ1Ba?=
 =?utf-8?B?blVLdVJWdzFrVVR1YW1odmRzdjMrVHZhSTdNc0lzMkcrMEQ1Zlo1UEQ1eUZQ?=
 =?utf-8?B?ZGd4c3Z0aFB2cUliRVh6TWh5RVVJWlVxNW8zVmhZeFI1T1pybXRQbFdlVUQ1?=
 =?utf-8?B?QUMzbHZBTGdMblZQcXdRYlZnNHgzSnk0c0t1bitLL2RhZmRhdm1lYWVES05O?=
 =?utf-8?B?dmhBdVZWOXpJSlJOOVZ2cE1uT09pajQxOXBuQy9zRm5xUHdtQXVLUEdkaDV1?=
 =?utf-8?B?NnplRDAvRUdvQ2tjazlNWTBLdEdJVS9ZMlVRZFpoRnpYdWNJanZYeWxnNzU0?=
 =?utf-8?B?bWpuSGN3aldNWkZKU2xKQ3A3TjU1T20rMlJaa3g0Unp1a0V5eXVERG9RdE5r?=
 =?utf-8?B?TmxDb0RGWFhPOFMzdjFGejZ6bUxUTk55alVpMHBEVGt2SEMxa2lKVDlOU3Vq?=
 =?utf-8?B?enBiME1vemd5M3VMQ1lEd2ZCaUlLNUk5eGt3eFVhbm4zVTVBaVBkbUQ5WHBI?=
 =?utf-8?B?ancrUDZlTUs4aGloQjR5SGV2TVNWQlE0M3lINmpZMnZSYlJzbDRQb29GTUpp?=
 =?utf-8?B?L1l3alRzWGp4SEh1TG9NUVMzWklzbmdibXVDUlhtRWh5Ykhrd0dmcWE2TXJx?=
 =?utf-8?B?V2V4T1Z4cnM3WkNNdWdGQVl2WFc0T3Nvajh3OE1kNkJ5UWFZZ0pHbklqRTR0?=
 =?utf-8?B?VXZOcFd0Q0lnM3pkZmVoVitpTU9kemhiZWkycEtVdGl1S1Fub1BIbjRpeDdv?=
 =?utf-8?B?OHh2QjZrR0lISi9kZUdGNEFuc2NsU3UyVFdlVkFQdzQvbEg5ZVQvR3A1TzFl?=
 =?utf-8?B?d3BIL1ltMFpSSDY1QzR4RjFTZWxjNW1rRm9mMHRnMWNVeFhDVkU0NjUxN0Yr?=
 =?utf-8?B?eGFyQWhRR1JrUllScTRKc2szY0dIbDlYYi81cFJIK3R4RXRZcmRWQjRONlBx?=
 =?utf-8?B?RWQwcHpBbVVEcldlb1VzMGFtSjNwakFHdTVQMGduMEc4ZUp5VVJNMTNrNkQx?=
 =?utf-8?B?T1ZQQWRkTzhWcGM3NXdQRi9RWXFIVlNXN0xsb1dJWGZzZnp3cHEzQW5rYjZi?=
 =?utf-8?B?QmYrRXE1RGNZelJLMnZXV2xjQVplNGN4Zm91ZUF1ajl3Rk54ZFo4aG1ZNWVB?=
 =?utf-8?B?S3R3aUlGdzNsRjdJMzk3ZHdjMVlDZThhdGpoZVp1R2pUdVo4dTRvUTY3bnVx?=
 =?utf-8?B?ZGNQTHhmdDV3a3ZpeTFMS2V4dTJoSk9aSi9mcTQ4amhRNVI1L1FjVVU0ajVV?=
 =?utf-8?B?ZEx0eEI0SFlCTnR4a0g0V2wyZFVjZDJQOUJDZnJvdE5FRlpMY2hVa0ZEaGwz?=
 =?utf-8?B?dWtEdzJPNkdOVkE2TUlDWTh2WGppcW1ZWjBtZk9YejdTR2Y1aStYeEQxVWZs?=
 =?utf-8?B?YzFpWVZ5TWpWMzc5eXQzeE9uOW53SzVLTkVsc1BqTFF4YUM5Nmt5QnNnR1Fj?=
 =?utf-8?B?NExsMEcreGxwTlA5RHQ5bEF6c1hneXZGUDdqWlozdlF6QUpUOFUrcFRHcHdS?=
 =?utf-8?B?MlZibHZRRkNNYldVV2xqWHlVVnEwOUdPUzdUTmtBME9yU2JZdmlxVHJxcnQy?=
 =?utf-8?B?aVVzeUJSRGR3L05SZnlzVzg4WnRzS25IUkVFbEZuWmF0c1VMQ283TTBhQnd5?=
 =?utf-8?B?cC9lemIzakJTT2svUkhJaFYwckMxWnBNR1FHcE1lUGRjNi8wNHB4bDF6K3lW?=
 =?utf-8?B?ejBIemhFbnErbnZ1R0JPTWo4V3RmaCs1M3A0MTJTVGhhWksrQzlPNk1VeENJ?=
 =?utf-8?B?dE50WTQwSE0rRldKNkM3b3hHOThiTVlzOGpCQStYU0pjVUhVOUh4VFNzM080?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1D754F585DBE54E8DEB4BB9FD234EF9@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	su9K8WlzqVQIRrbTKUG5cHKa7b1aFar1sL8pI7OIFWE6vuwzBlOyqH2ESXOKdJ8WYBrnAYDXZ2urDwYZvmHdll2bFUlrRwu0Vfzizq+gRRyOGVkWb1W+C7e7wBEAvmvebqziy6J+IK0cCGIUJRd6L6dGG4Tr1h/qMDxSg2ou1+iQilFldosjO+ySyMfi6GFuwy+Lh9iyjyo+7uk3DWoPV7Asa/1F0nTmP4qE+vfN8N9ps8z8cznMUhhYfAbSV3gMOV0Zp4CYFWUlctstx1GCwQ1BTIeSDXFDx/FfgzAZjo3q4AlEcqgzu3iHZNr1tT6DyQTdhxkWVI8ETe4tNtC+FtTxJXzffT7Fw+iQUVro20RxSZQ6rRpCNuXaWbKwV9k+vLEn7hRJgRWZ33pJ9yFEICeXtLbjyiIro59IBrW/UaV6Pmu3mhG5UonGDy5rkNgj9+ByUF2Av6FwmsF60bCf6FPsrWVyor9d1CrncXC/WLZbk6twlGWK1ZVJmEFP0hEyBMqnIBlt1UYbWSx2+uM8HWSOt+VvTxZai2F1DR9w9Rv/OwahFbOJiz61C4CgHPvDXaaQoDpo9sfdKqx8W0WGzCIaQHhPw0FzAOqNtrKc6DNvNWarFPj80Bux04LOOqTT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2fe045-d5cd-4633-5725-08dd6df25a5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 12:16:22.1843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WKbl2sT2uHYgDKnIsIzDL5apzQgqwOzHyak7OjcOjvCrCHlPXE0pOQCSONLMb64m7CxsZLiaKkFxd7AaYFLPag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9539

T24gMjgvMDMvMjAyNSAxMjowMSwgaGNoIHdyb3RlOg0KPiBPbiBUdWUsIE1hciAyNSwgMjAyNSBh
dCAwOToxMDo0OUFNICswMDAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gK1pvbmVkIEZpbGVz
eXN0ZW1zDQo+PiArPT09PT09PT09PT09PT09PT0NCj4+ICsNCj4+ICtGb3Igem9uZWQgZmlsZSBz
eXN0ZW1zLCB0aGUgZm9sbG93aW5nIGF0dHJpYnV0ZXMgYXJlIGV4cG9zZWQgaW46DQo+PiArDQo+
PiArIC9zeXMvZnMveGZzLzxkZXY+L3pvbmVkLw0KPj4gKw0KPj4gKyBtYXhfb3Blbl96b25lcyAg
ICAgICAgICAgICAgICAgKE1pbjogIDEgIERlZmF1bHQ6ICBWYXJpZXMgIE1heDogIFVJTlRNQVgp
DQo+PiArICAgICAgICBUaGlzIHJlYWQtb25seSBhdHRyaWJ1dGUgZXhwb3NlcyB0aGUgbWF4aW11
bSBudW1iZXIgb2Ygb3BlbiB6b25lcw0KPj4gKyAgICAgICAgYXZhaWxhYmxlIGZvciBkYXRhIHBs
YWNlbWVudC4gVGhlIHZhbHVlIGlzIGRldGVybWluZWQgYXQgbW91bnQgdGltZSBhbmQNCj4+ICsg
ICAgICAgIGlzIGxpbWl0ZWQgYnkgdGhlIGNhcGFiaWxpdGllcyBvZiB0aGUgYmFja2luZyB6b25l
ZCBkZXZpY2UsIGZpbGUgc3lzdGVtDQo+PiArICAgICAgICBzaXplIGFuZCB0aGUgbWF4X29wZW5f
em9uZXMgbW91bnQgb3B0aW9uLg0KPiANCj4gVGhpcyBzaG91bGQgZ28gaW50byA2LjE1LXJjIGFz
IGEgc2VwYXJhdGUgcGF0Y2ggdG8gZml4IG15IG1pc3Rha2Ugb2Ygbm90DQo+IGFkZGluZyBkb2N1
bWVudGF0aW9uIGZvciB0aGlzIGZpbGUuICAoVGhhbmtzIGZvciBmaXhpbmcgdGhhdCEpDQoNClJp
Z2h0LCBJIG1pZ2h0IGFzIHdlbGwgZG9jdW1lbnQgdGhlIHpvbmVkIG1vdW50IG9wdGlvbnMgKGxp
ZmV0aW1lLCBub2xpZmV0aW1lLA0KbWF4X29wZW5fem9uZXMpIGFzIHBhcnQgb2YgdGhhdCBwYXRj
aCB0byBtYWtlIHRoZSBkb2MgY29tcGxldGVseSB1cCB0byBkYXRlLg0K
