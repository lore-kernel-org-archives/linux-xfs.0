Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDF123F40D
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742222774; cv=fail; b=t8tIfoVgoRv1QUqfpK98b2Gvr6IevqLAr3bjrfS7QiPzDM/G1pN5NzRye5M1QaCw0cCzVuoDV3vWejB4FTUZFJVCq+UOra7U6NU09vAg1CtzLx+dM16eyMlgSYRJHUQo8S+MDMnzFYx+zF0BFB4nvPScCwPfy+n0zqwaOTkS3Qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742222774; c=relaxed/simple;
	bh=F9hx/eI2CvsFFajQA2aPotPQKQ9bYM4Hf+ABMs/o86Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oL8gZcSxbwLJflYy66pFSNw/WG1VBb7pnXdZmCDHB/WIafdVlhtPeE+QPROBkaEKdP9wpzo3bwoZUMRKPtNOvEEUuCrwl14Ze2C9/IrEdz7UROcqoanbCF8PAT2e5NvKngVdPUkVcLTt/OSrN4GXLclBLdIeMrjrVMxquwadlWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iCPA08bG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Rqppv+5I; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iCPA08bG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Rqppv+5I"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1742222771; x=1773758771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F9hx/eI2CvsFFajQA2aPotPQKQ9bYM4Hf+ABMs/o86Y=;
  b=iCPA08bGdrhmnPSFNCdpbVJ7OeLWThkbNEJ1Xo8WfYxVgAUR8n9fWocO
   A5P9KAfIpqtUdjvivGt8yHJ5YvaEhx84O9e3Lt5Z8qcJ043clAOWXTwGz
   5xz4/+iIG02sSyCbSHXXQ/5oeQgdvSU54K1DW9CBICAqO8g6HtL/Hd1q7
   Ush+aurRra+LYp49AB8JgZaMvSTvCl+zTXK9DtQ5v7g/cjYSv4hC2PxIx
   WKWB6zHnotuwrHhRxttD36DpXgf+xcyRNu3uH1P0knXzwhRNq9+s5Wgai
   BQTpUHL8InZENvie+CbOgi1iQLt+DZFoiFeTP7g3/Lje2pNb7lAG+fBfg
   g==;
X-CSE-ConnectionGUID: WJY/S8HkS/SyRMSDMKVCtg==
X-CSE-MsgGUID: V3kHaQ+bSXmGjzN7P5De7A==
X-IronPort-AV: E=Sophos;i="6.14,254,1736784000"; 
   d="scan'208";a="52208955"
Received: from mail-westusazlp17012032.outbound.protection.outlook.com (HELO SJ2PR03CU001.outbound.protection.outlook.com) ([40.93.1.32])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2025 22:46:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eb7OUQLjZSLPMgX6/74BrNzgkCRKlrouorkSrkT84xVbyGmYLUO9+6+hpGvkz+RRQrpgRNt1n6oFY9v2mVLSVlDq/7O2UUpx94mdrAYIgYRKn2R8myRs0w4xqLLhTTOjuZ9AOV9a964/zLxa1g6srteujDteXngjNFCxRtpBnJkglE8bou5/rlVRCRG0T0SzYbKtvoj2y1VW+3cTy348ZMqhr4iqSFPE4tTSASXG4RgOHLSiZU/o9R1Esmv65vK3j2peR9cjhijHTA/EhQIhichqhH90yaVLFsAuhn+vzJEHjyarmS9IdxpiH51TCVH5n+b3uPa8jGrPKp9src4S0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9hx/eI2CvsFFajQA2aPotPQKQ9bYM4Hf+ABMs/o86Y=;
 b=qmI0oeHpUBA3pdGOFFOQ0alF3Hquxyqaj3h0lhAL0WAy6VM8wc7oaYeStCjof/HhhShlOiP7Txp5aUMr/NzvHOBXMsCVWEBRIElnw2pvOHVowtg52yoOafwjC5TVQydfQPzPqPsD9X2CJKB13ZHdpsvoa4Ie2aB4J3e/BrUsPB42f1L7SuMJC+lVKDpgyn1KP7NupFm0TI71SkMa21uuO77VMKHf6JaCqip20F4pU3OH1lgHJhGsj66YiaRUCn89MMYY229tEm3b9FIP0BC4uGCR9x3ZYJFmyV9UiENvRJMUVl8RJKv2WDIGeUoLllZQafcZPoggC+YcVeEfR0NKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9hx/eI2CvsFFajQA2aPotPQKQ9bYM4Hf+ABMs/o86Y=;
 b=Rqppv+5IBnkE2RbQrUzfikUwr2l0fJwDIk5V2HhPVIH1Ii8yjAJU+UC1z5wGt3Bn5fJGt/+Rgap2Llub6nVlEL2dIo94Tse3LPm3fZ813jZQDWd49vebtPvncySl9Wo843+w294YgYx2RCMbtMjQsOJIxAlpo5e+JR9yNR8jiWE=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DS0PR04MB9365.namprd04.prod.outlook.com (2603:10b6:8:1fc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 14:46:00 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 14:46:00 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: hch <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Dan Carpenter
	<dan.carpenter@linaro.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: don't wake zone space waiters without
 m_zone_info
Thread-Topic: [PATCH 3/3] xfs: don't wake zone space waiters without
 m_zone_info
Thread-Index: AQHblv/M8kxCyxhZLE6ncbIKQ76GxbN3aJkA
Date: Mon, 17 Mar 2025 14:46:00 +0000
Message-ID: <524d0aa3-2b70-438b-8188-27d5f12fce10@wdc.com>
References: <20250317054512.1131950-1-hch@lst.de>
 <20250317054512.1131950-4-hch@lst.de>
In-Reply-To: <20250317054512.1131950-4-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DS0PR04MB9365:EE_
x-ms-office365-filtering-correlation-id: 6be66631-a5d8-4a20-2af3-08dd65626f3b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bm5FK0NTSGpFWWxCSVNjM0FvUzdMamc4L3p3SkszTTBIWTIxSjlieDViM2o4?=
 =?utf-8?B?dkU3eFU2OW42OXpIRVlkc25oUWlmdTFLZ3Rnc0doUnlQbm9zcTdhU0NPeWxE?=
 =?utf-8?B?djdiVlRLQjNZTGRiUEt5Vk4vSHJuRVBnY3FUWkl2a2dtQU9lcHpIcG9JMzU4?=
 =?utf-8?B?bzFOUW91QmZnWkIzekhXZjdnSEhYN2NadzZvcXdWUllGZ2c1WEdiWlBTSmRJ?=
 =?utf-8?B?YzJhWk92R2ZTZzh3L3hoa0VINnovOWo5QkRkOGtDblRQY3hzeXBhYWE4Z2tO?=
 =?utf-8?B?bnNMeHFYWjJnd1ZYSE9QMEZ4Y1NSejNqSVVxdTQ1RFNmKzFtQnRqYjRNVG9M?=
 =?utf-8?B?bkZUMmc5c1hLR2tacFJkSjhtYUFnWVY4QTQvaVVaT3F1L3NkRGRnNnlYZXBl?=
 =?utf-8?B?bXA4V0YwZ3NHbWh3cGFxWlNmNVdpeHo4aThxZWVrRENodExMREdYalY5bUR6?=
 =?utf-8?B?cFkxSDMxWm9iK1hoK2JmTFhIaU1pMTZxd1dtREJlSmN3V2ZZb0hSTEM3THhF?=
 =?utf-8?B?L0Y2aXBJNTF4aGwxcU5iRm12bCt0RWFjZ09aMGxPZWdQeXcyNEVIMFRnS1Bo?=
 =?utf-8?B?L0RReGpSSVRITDNmTWw2U0FBUHBRSXFXQ0U3US9pUEZCNDk2ZnUzOHVvdUN6?=
 =?utf-8?B?d2xBQ1QvZVh5b0hMb1lhcGd6WnZiamlYQnh2TWFRUi8vbnhJdWRnZ0ZveHN1?=
 =?utf-8?B?L1ovTVoyNzBCVklzanBsazJlUHRBN01EcHgwNHVFWU5MSlNieWwxMjR5dHc5?=
 =?utf-8?B?ZDNseXQrVU80cGc5bGtXQkJJbEo4T1NkbnFUaDE3TWZvVHBtd05oY05NRXp6?=
 =?utf-8?B?dlg1d04xUmRUWjJ2SjAvMElGTS9DYXh4V01vOERSeGROYnZDdktqZXUrVWFG?=
 =?utf-8?B?RnQ3RVFkUWVpNE5mdzQyQ2lCdDNiWGUzZG9wMEVwTmRZRHR0Mjk3SUZUaXhY?=
 =?utf-8?B?NHpxUWN2NHZvTWpYMkxUSng4R0xkRCtZaVdqTmRqRmY1QlJMMWszWlVGQmJJ?=
 =?utf-8?B?SUtybkdRKzJqU2h0c3BPM2JuQnZzRTJZeUtDQjJnVHV3ZEV2c3BGb1h0dHNq?=
 =?utf-8?B?NEZKSy95Z1lINHM3MjNNL25FNVRkNU1LVWlCdjR4eXp4N1E3M1BlS3Bjc1lm?=
 =?utf-8?B?WWxOK0JJdWdQQXduNzFkOGJkRDRWTExlTzl2L2FzTDNoYU5JcG5kbXc4WUVn?=
 =?utf-8?B?Q1F1T3FJSmhZQWdGUitSa1QyaTVtRUduVHhjVHIzUlV0MEkzYTcyYy9pRG1W?=
 =?utf-8?B?WWNrTk5CVUttRXBpNXBIREpJVnR1Z3JyT2hXb3MrSUppc0VMQ0FZU1dWemVx?=
 =?utf-8?B?TEpUOEVVdUxzVDI5bWZoakZ0WFVWYTlzWTJ1WUFwY1JxZVdWemlCb1Fvd2N6?=
 =?utf-8?B?TUR3eFFtem9QVC9GUTVIMDB5ajBLeVgwZ0t6WjZkS3Z1VnNBVGs2K2Y4SkFn?=
 =?utf-8?B?dDF2QUdNSk4rUmpyekdXU0RzdTVCcldZcnJ4MDNrMWlIaXVpNEJWYnVpczNO?=
 =?utf-8?B?SGI4WCtYSWhlU0JIVE42TFNCY2t5UVFRUGVWY0ptL0JaalFpdXFmYUFrMGNm?=
 =?utf-8?B?QklUQjdZWmFtQ09DY0ZUUjNmbHd2T0JTRTBwMVQxQlZqVGZ5U3dYR3ZzbmQx?=
 =?utf-8?B?bXZDaktEN1dEZkdsempHNEcrd2dMMEpHdkMzN0xwaSs0Z1hkOTVMQm5GVnZl?=
 =?utf-8?B?ZEM4WlVyTGdNeDVJVXhja0JVOEpXVG4xN0IzTTQ2c3l1Z0RqN1VtZXg3L0FY?=
 =?utf-8?B?YWM4M0ZJL3oyVVZtRG9kSXlRa3p6cEZYdzBDVDdVeGgxN3VsMk03cHhncWZu?=
 =?utf-8?B?R3BLeWdCNkU0Zm8rZUJya1JjRnR2alRVaXlwTFV0MnhCK3plbzBYUThCc2Vj?=
 =?utf-8?B?Q2gyaHBBY3lDMVdEckN4MDRqdFYzcElCcGZ5YVIrN3U1N3kwZ2NnZlJLOTRu?=
 =?utf-8?Q?azdJ5uBSm2H2LLVHEXtXh2XkBCpJpRCt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a0h6TTZiZnZ4dC81ZmZUYXBnOHAramU3T1Z6NW81QzJuL2pFZXhLakJRMHM5?=
 =?utf-8?B?SGVpbGQ4SHdpWFViSXhYOGVXTWtkRWhyeHdzVDZPZzFqcUlURjN1NnVVTkE0?=
 =?utf-8?B?YmtmWHRLZGhKemkyQU1KZXJBemFzdk1MNWR2enVZcjl4RVdmK1NBNmp0OXd4?=
 =?utf-8?B?a1lvc3llY01mMG9QQThPYjY1K3JuZXFUUGg4KzZ3ZTA2SmhWTXFxMGdKTkhP?=
 =?utf-8?B?WmFJeE4rQXRHZXJqaW40cjhXclUvcDRYUDV0SGMrbFh5QkY0Z0tjcCtuTzRH?=
 =?utf-8?B?YUNPTlo0Mzk0Z3hmU21lSjlCRnh6ZGkyVHk3RTVwTVdRZ212Qzl1cklFMTlB?=
 =?utf-8?B?MVJCYmdyN2JjUzJCbVlGNVBuTGsxR0RiY2FwZFVmeWFLaEQ1V3Y5UEJBNG4z?=
 =?utf-8?B?STFEdXlVRFpnZlhSZXNEYUhYSUZVWGhlcU5lbkV6d2xFTFlkeUt4Wmp4UUlx?=
 =?utf-8?B?SXR0VVpVQkdWSElKRzRrNzJ0T2hDVS9yUG9qOURKaGpHOVVRdVNHZmNGZmE2?=
 =?utf-8?B?ZWZMS2ZHVHFPa3pQMGd3cjQ3RmIxVWJidWR2STN6eUlwcjFqMUd2UElRYVda?=
 =?utf-8?B?NGF0WjRHbHZaMkpXengzS1dQckluWVRrTk5TMnFXcjQwSE4vQlhGV0lybnEx?=
 =?utf-8?B?WDNCRnNnR3lQZ1FCRnpnNXNsRXdWSDBMY1lVdDVmbVV2NjRxOEs5V2p6MEdE?=
 =?utf-8?B?UVlRU00rRzVqbVJrQ3ZheEdad2pFR1ptY0xwbGRwVU5jcCtWVWlMSEJFQzFP?=
 =?utf-8?B?TUhwblY5RkFzYlNMcDJKODhiRCtvZno2WDVQK090Y1dWTmFFSEY2U2thUVV4?=
 =?utf-8?B?bHpKUll3SGlEUEs2emJDQ28xb0pGNXB2bjd5RVlsUXVpR2ZId2ErUVZsYmtp?=
 =?utf-8?B?d3JmdGt5WmJvK2lsYlNEL3M5dTJsS1FpZmJqaktUdmh4Zmx2cFZMZEYxcDZl?=
 =?utf-8?B?Wm84MjU4a2lEVE0xQzdDTkNsTHVNSzdBZ1VRSWZBWC9GK2xLdGJHakZmSVZB?=
 =?utf-8?B?WlpQeFJXOFVkeGJrNFZVVUNUbndXNHF2akNQQ1lrZFVoWnJjcGpibi9xQ21w?=
 =?utf-8?B?aVFZM09tcjhBVFpuT3haQ0c4SUxPK2xxVXlnUlpQYXRjU0tmcmZKMzV3aFRi?=
 =?utf-8?B?b1lqb00xcE5sTW9Rd0R0UjVoN2VXWUNUd09YV2ZlVGliZUJCK1VGTGxac2NX?=
 =?utf-8?B?cG9ZRjBVa2RyMVlPZFBMN043ZGdBRThOTHNJUXZ0UHpNSXVUSG1uRCtTQXlj?=
 =?utf-8?B?N0RxTVhTMzN0bGVPSGYvTUdwYjIwWVVLYm5Cam9mT2R0eHQvdFI2QTFFSUlN?=
 =?utf-8?B?ZVNpeFJWM3dtdmdaVW9QeDNmcWl1dkFMN2xLcmtkVTJ1bVpRRHZ5ekplK2ZU?=
 =?utf-8?B?NFg1cEZEWDJ1UG54VlBJMXNudjU5RzM3WVlNVjhQb1JJdE1PQTdrNU9zQ0tu?=
 =?utf-8?B?UW11YUw1WXd5aXZndUhJODNQYmVLMVNkeGVrR0ZMMU5LMkhlSndYU2NBTnF5?=
 =?utf-8?B?TmJuQk0wS3NKZlBhN2ZUSUYxTjY1QXIvejhhWElFR0pWN3hrNVJuMXV6b1ZO?=
 =?utf-8?B?bXlFbStNdGtjL3RBWTByZENMbTlaUGdWMm5Cd2I0Q1N6dUVOUDJKMW9wSXVD?=
 =?utf-8?B?RWJpbjNmcHpLMUJ0TjlHR0ZOR1lSVU5lRi90M1hIMFVtazFmRWtqM29kZEgx?=
 =?utf-8?B?Y2RUSDIwenB5MENZbVdQY1BjRVh1V2VRTU42Ymc4Yys3R2ErTEkyQU96MThY?=
 =?utf-8?B?VjI3eStOOENvWDJMNUJveVhSR2FYTTZtMWg2YzZDbGowNXdSYlEweWxESzVv?=
 =?utf-8?B?REdodlNSUUszN2FrY3dsS2VKQ1NreFJKdDNEQzQrU3BxeWpJTjJ0ZTRVYWUv?=
 =?utf-8?B?eW91SkhYMG5GRkVmYUErTHNLNDVSZjI5cHVjb1RqMStDNUxZbHNhVTllYWIv?=
 =?utf-8?B?Z0hVclhnUEc3UzJZUndQemFpZEdPMEtTRjNnN0xuNXhLd2Z2bjYrTkNYZEtv?=
 =?utf-8?B?Zi9GRHo0RW16U3J4bkR0SEZzZktSYWpUdm9iUFFZUGdCUlc0ejZCeUZVV0Mx?=
 =?utf-8?B?ckUwakZPQVlmNTV6c2ZkbWlQWStDTGFVaHhJMitiTlM1RW9QYlZwK3FNZUgx?=
 =?utf-8?B?VGNIZ1NpN0duWFcvVWlBVXRIbVZlWEVmS2xuTVdhUHVvQVFibThEeTV1RFBP?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E95EE67ADA0F6E44A25C642F584A24BC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7mTVZwlIXLMvt9+3e2XT88lubqy5WJObHbyFc0HCAu6A1ULyDUlHADJ+VGYBSmwucVnZYS9Wy0MQM1W97PVSPeoF2HLigxn4OogaCuIgJb+8E5ZjwxZXuGr9k3LgoKsUNyQ3vsb82eNbtrmC6JemwMyS5E6tuSeJ9LuJN2//9WUrMNq+Wdwm05aRxL+H4Q7AfRZxLR+B8epQOS1G+3oFB0G0BBD71a3P6HvAj5/DFBn46xTvRCyAnBnl8p3MUJR37bPhDRa+jZybuArJlgPBjug/nH4WR7EW1XKQ+Y/dAOXk/Sdc+FruTCXH+Xq81VBt1vleHzYL8Uo1A9wGdxQo81qp0v/VVxivqy32GcFZV0es+io9Yirqd5SI0k/SoVNQHgcdSDdxi7jsKLiYngIB5v3J6e0Y7QlAZacNSz529+ZA8mjccuwnDeypCg+UQoZkYiFiMmJMEgBE0I8pcuYr3/3otZ5RknXT9sTGyMTwV59EvyItMcmFExucsLe9R0p8gvQF3ROlyT0NfdVjqgzASYP/Td9B/N5T6Y42245C9zoiMwWIG6T/LpwtYHIN68RLZZ22UoKpV9ByDEUPJ53xgw/zB6iTi7eC/ltJxpVQvrKb88hpPeNUUNRCVreJT8+V
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be66631-a5d8-4a20-2af3-08dd65626f3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2025 14:46:00.3802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/eZRGfv69s6gphBvBDk+Co7aHQYbUIsw7MVpoVlMxLSUZUe0I4VFK/0m2XXaBiRPNm4sB4oj4AKnz3Y2AZCCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB9365

T24gMTcvMDMvMjAyNSAwNjo0NSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IEZyb206ICJE
YXJyaWNrIEouIFdvbmciIDxkandvbmdAa2VybmVsLm9yZz4NCj4gDQo+IHhmc196b25lZF93YWtl
X2FsbCBjaGVja3MgU0JfQUNUSVZFIHRvIG1ha2Ugc3VyZSBpdCBkb2VzIHRoZSByaWdodCB0aGlu
Zw0KPiB3aGVuIGEgc2h1dGRvd24gaGFwcGVucyBkdXJpbmcgdW5tb3VudCwgYnV0IGl0IGZhaWxz
IHRvIGFjY291bnQgZm9yIHRoZQ0KPiBsb2cgcmVjb3Zlcnkgc3BlY2lhbCBjYXNlIHRoYXQgc2V0
cyBTQl9BQ1RJVkUgdGVtcG9yYXJpbHkuICBBZGQgYSBOVUxMDQo+IGNoZWNrIHRvIGNvdmVyIGJv
dGggY2FzZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0Br
ZXJuZWwub3JnPg0KPiBbaGNoOiBhZGRlZCBhIGNvbW1pdCBsb2cgYW5kIGNvbW1lbnRdDQo+IFNp
Z25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZz
L3hmcy94ZnNfem9uZV9hbGxvYy5jIHwgMTUgKysrKysrKysrKysrLS0tDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IGlu
ZGV4IGZkNGM2MGEwNTBlNi4uNTJhZjIzNDkzNmEyIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZz
X3pvbmVfYWxsb2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBAQCAtODUz
LDEzICs4NTMsMjIgQEAgeGZzX3pvbmVfYWxsb2NfYW5kX3N1Ym1pdCgNCj4gIAliaW9faW9fZXJy
b3IoJmlvZW5kLT5pb19iaW8pOw0KPiAgfQ0KPiAgDQo+ICsvKg0KPiArICogV2FrZSB1cCBhbGwg
dGhyZWFkcyB3YWl0aW5nIGZvciBhIHpvbmVkIHNwYWNlIGFsbG9jYXRpb24gd2hlbiB0aGUgZmls
ZSBzeXN0ZW0NCj4gKyAqIGlzIHNodXQgZG93bi4NCj4gKyAqLw0KPiAgdm9pZA0KPiAgeGZzX3pv
bmVkX3dha2VfYWxsKA0KPiAgCXN0cnVjdCB4ZnNfbW91bnQJKm1wKQ0KPiAgew0KPiAtCWlmICgh
KG1wLT5tX3N1cGVyLT5zX2ZsYWdzICYgU0JfQUNUSVZFKSkNCj4gLQkJcmV0dXJuOyAvKiBjYW4g
aGFwcGVuIGR1cmluZyBsb2cgcmVjb3ZlcnkgKi8NCj4gLQl3YWtlX3VwX2FsbCgmbXAtPm1fem9u
ZV9pbmZvLT56aV96b25lX3dhaXQpOw0KPiArCS8qDQo+ICsJICogRG9uJ3Qgd2FrZSB1cCBpZiB0
aGVyZSBpcyBubyBtX3pvbmVfaW5mby4gIFRoaXMgaXMgY29tcGxpY2F0ZWQgYnkgdGhlDQo+ICsJ
ICogZmFjdCB0aGF0IHVubW91bnQgY2FuJ3QgYXRvbWljYWxseSBjbGVhciBtX3pvbmVfaW5mbyBh
bmQgdGh1cyB3ZSBuZWVkDQo+ICsJICogdG8gY2hlY2sgU0JfQUNUSVZFIGZvciB0aGF0LCBidXQg
bW91bnQgdGVtcG9yYXJpbHkgZW5hYmxlcyBTQl9BQ1RJVkUNCj4gKwkgKiBkdXJpbmcgbG9nIHJl
Y292ZXJ5IHNvIHdlIGNhbid0IGVudGlyZWx5IHJlbHkgb24gdGhhdCBlaXRoZXIuDQo+ICsJICov
DQo+ICsJaWYgKChtcC0+bV9zdXBlci0+c19mbGFncyAmIFNCX0FDVElWRSkgJiYgbXAtPm1fem9u
ZV9pbmZvKQ0KPiArCQl3YWtlX3VwX2FsbCgmbXAtPm1fem9uZV9pbmZvLT56aV96b25lX3dhaXQp
Ow0KPiAgfQ0KPiAgDQo+ICAvKg0KDQpMb29rcyBnb29kLA0KDQpSZXZpZXdlZC1ieTogSGFucyBI
b2xtYmVyZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KDQoNCg==
