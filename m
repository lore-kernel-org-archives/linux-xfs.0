Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9475C43F081
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609660; cv=fail; b=Qe0lNNVkVXmX40kQg4M154JeOYjis4/yRd+9f8QHOTk5elTosTxxPnncCymD8k+aqIcL/VG2Xx2yxetXpXHG5bFSri50kebKM/uRNmwWZmJ0X2uT9K0h49Wd0GMU/I54QErU84j0LYuLc6iKsl6LKO70KCecqg0FIUSsJRqTRXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609660; c=relaxed/simple;
	bh=N7r6lMNzmtTLkO1i0EqFzPRE6EBw+WIFYbjO71Q7D8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mZC2pa/976IDDa8EI9AzFWc3NS/N3BPgnkH0yL9xnNhsXmzuPTR6TGMEblk62ENxNp4FnkDvCsQSI7+SR2w7rKZWF7gynBiHLvtRvqC8fxELggAAO6/IVdvofSho57WjC5lcIMxs0I+zNsVcuWw3HQb4xhsDs9/0WzbftJvnxTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=H3NyJO/p; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=P0Ihv+KM; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="H3NyJO/p";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="P0Ihv+KM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1786609658; x=1818145658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N7r6lMNzmtTLkO1i0EqFzPRE6EBw+WIFYbjO71Q7D8c=;
  b=H3NyJO/pNb5FVyx9qjRJJXYhwgyN9NXTjew8/GPOtscz4Sh8l4wUMRwm
   ulQ2PsNyGSPmiLqYo9LAO6fZ/GzCruOsP77qZzZgPNO9DacGDDPcqjbOS
   siXqijR+GjwNglcXiwxSnbq1EI4TBy/mz74yWP9hSK6Aa3B+i3Z4UZc96
   vW/96LZM1qC0SxALE3kYrkKigyW8f/oPkTGkXotsewcKT+4nkyYv6UJS9
   hSc/9DBCjDL368KGlFdbEgIkQUYCQQaVeCCuE69iP8htYipN/XDKuFr0q
   iB44QTHJd3oKgqWeaNk9M/DJHWu20LI1Ms63LWabFnFcwb/80GeIP8f+q
   Q==;
X-CSE-ConnectionGUID: NylD6YfeQeKW2EUt/8YBVg==
X-CSE-MsgGUID: BBtXpr1SQMyLtLf6lyZvWQ==
X-IronPort-AV: E=Sophos;i="6.25,221,1779120000"; 
   d="scan'208";a="152820055"
Received: from mail-eastusazon11012027.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.27])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Aug 2026 16:27:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBQboLVa6poerIR7nX/cAeVi/Paail/v4sslIr+v78VIKDMK8Ua03HyRZuiqfr5dHBtXGWlREfT5fW1a1Ng749l1Tt0xR8DIjhsMUTrR6aRpnVNP3fJ+pfJt70g3R5mxS/NXo5VxB06nIyTVP9xwykm2frPf0Fx0RLksW+Z7oPLd4QXrgytta6w4lLGynqrquIoFoSRp9lWuAtmDg9P3gzroxSCECqmW7GKIMryrSYxn1HGE6ZUJEV+vnoT8Ju7bz8s2Wb70Y0BzwGxl/0glQW/1zXlgu3zyd02Ze5el+WRNlwbkFS45rJgID9CO0vLpWkOHWm3joZ9pLSsJA3WWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7r6lMNzmtTLkO1i0EqFzPRE6EBw+WIFYbjO71Q7D8c=;
 b=H9NtQPF4bLq8P7Rpo2fc6YWiIp2NV45wHZiyQf091a3vGBOYvMBValI9XV4nkjZWoW62zOqj5y6nKXs69o/Y/5bSwBRrOcDQ4wN6X3cQCLhj0L/64NmQshDg8rPbaAuFWApqArCnzAU2oFayOBS4c+jCn8obKCM+vH/JBVF5Ew9dw3XpVLTpC0tZerkc4NXPw2cJvc0jCOImbZq/XszD00v4y0o8Bkd1TUKGzxhDmqvh794aCCBAgl0RYX9JV1MMPQq/sUELVCUXtFjLA5XJzVc1CwrPPurmpsrrDuNQoUR++2zqviRA1ba7bK8Hlj7fg72rDdC2uJCpSKctN6p7qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7r6lMNzmtTLkO1i0EqFzPRE6EBw+WIFYbjO71Q7D8c=;
 b=P0Ihv+KMxQzexnOcFwv2nTKMATKhgWTJlMZEP0/rLtEuKmVu9cTn2Is6F5S2c9dHarjsznHKfJzpnVHNpJgF/0fLCW2tsznf0c2eMNeIUt5HRUU0N9VM25aJ78kYTtgcso13esd65qeu3VSMEiIrtXfyaVvaeL/C8rk0GH7asiQ=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by CO6PR04MB7793.namprd04.prod.outlook.com (2603:10b6:303:13c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 08:27:28 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%4]) with mapi id 15.21.0315.012; Thu, 13 Aug 2026
 08:27:28 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
CC: Wilfred Mallawa <wilfred.mallawa@wdc.com>, Damien Le Moal
	<dlemoal@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] xfs: fix racy open zone caching
Thread-Topic: [PATCH 2/5] xfs: fix racy open zone caching
Thread-Index: AQHdKbFwxccFg44LwUmh0GQmJhfCK7abp8QA
Date: Thu, 13 Aug 2026 08:27:28 +0000
Message-ID: <aa4762c3-ad0d-495f-b3c5-6d1e72f2d6b3@wdc.com>
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-3-hch@lst.de>
In-Reply-To: <20260811164912.124416-3-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|CO6PR04MB7793:EE_
x-ms-office365-filtering-correlation-id: 7adf525b-97de-4ef9-c3b8-08def914b657
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|376014|366016|1800799024|38070700021|6133799003|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 gozgq0ZOQNmBE7bovTKVE3AqQtZ5ScUuzEtIiSB/AyxZ1WSwDLPsf40GW0a2J9YxMxsv5Y3snQxVHz84sLRaUwNh4D0yHkV4MClNcty1onsWNTbPYBRmpXNXRpzilVCDXFrUJL5qSPPAov1POm9/pjXXz8aspCnDgs2AiaSlunrciG+APrJQOCo5a45ELkeQ4iQaDFV4QSn/vhjsgDOxa7FWP26WeXd4jNrOmX7SDqVuzblGe13gfMqyLJc3rZFGXsQ1SYzdtJVKDRduwV3FzjRi+a+eqo/QxGXP2NuPxgRy+K7i+9rH3bIHw+UOuAYoA+aCPIFtZcOhpkwEBsyLLflE+JTi5K5mSbVoveFT5BpCeW2BfQwaf5H8H+h7fBFNs6iFwFRCoaMFQQ0y4C1ZxCWcMNlPhkTN4+5pFWRm6miNTjxe9hVLcqOnuszAzPl1r2R4CPpcAo+Y8BOAudLbj4N5yELQ49vYykcmdI6syZ5U5poIXTM01rGVk4wf7Ds9s5XMlysurZyMvGDKj6avzVKpiWCNonPgDzAjOlM4gF/bIDix8X81jWDj9lrKidwUqTUJliyt5LnSwqRvPJYvYL3DZVaJE6BdWVAOwLw7nD1AJhr3GvvmxALgpyGvS4+m7KOmVFuRVjE7j0u7fF62MXj7TS+e6pazndeJBn8McOrl121M351x62/wABEQSCORQHmpMATroPftHrDwzvCHC3SOIM+aKG0hSJgxdq2UPJ8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(376014)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V3hjeS9DbFNEVjNraEowNnZTaW4yZWR5OS9DYUdRRW1EM2JJaHR6ak4rY2xU?=
 =?utf-8?B?ZjhvaHVHcjJPbUk5K0RRZlZ6VDNnOW5GcTNmMFlmZnJyRDh5ZlBqUDk0bVdi?=
 =?utf-8?B?VDJHZmNXMGgzajJLVmd6TnhBYVBQdzVNTEhKQzdReVU4MmxPNFJDZ1RETTNL?=
 =?utf-8?B?WGtUQVNUSEFQMWoxUU9Gemc4d0FBaVJ0bWJ2dm5acENzWUIxTVpHWVlyRG9l?=
 =?utf-8?B?ODVWSm5lblhjL1dHU1JpRHUyaFJLdTFzZkwycWVWcHowSTRYZ29KRWE5SXNs?=
 =?utf-8?B?U2liSVV2aXZCZ24zZk42a0tZbmloNkZJZGRacS81UndQQTB3ek5DZnJOeDlk?=
 =?utf-8?B?Q09idE1lL0luZXpXcFVING5SK281eEtmWjczRXU1SVNJN09EV2kvcWl6dFI1?=
 =?utf-8?B?NXhJc3Eyd0t4OTJtK0w3bXQwWWV6emV5ZWlOUDJlREthNG1iV2dFck5waWdP?=
 =?utf-8?B?WkZnZjAyalMveXZUM3FtUVg5dzZoRnU1WW9JNDk2UmNFVElGckY0SzZPMGpo?=
 =?utf-8?B?Mit2SWE1NjMyTXFOU3MxSUdjcXA3WUFuT3ByUEhmVHQ2TU5EMFY3TDZ1dUpi?=
 =?utf-8?B?UkM0YTVhN1RCaG5wekxsWmdiSWFRYVZsbW5OSklKTzRSdm9leDEwSmJWM3I0?=
 =?utf-8?B?N2RBVTc1TWlscDR6bzZwdU5lSzZ3WDlLUmJWYnUyQWE0ZkQ0MFhDdS9uT2Y2?=
 =?utf-8?B?ejk4bSt2Q29hN0pEUmljdHlBSHdkdnF6Q1NjcDRyVXJreXJqaWNLRzU3WVFB?=
 =?utf-8?B?SzFxQkdSWDBxejkvbkRwclZJRmZnL0JoN1RjNlhia2o5ejRRUTBjejI2RHBU?=
 =?utf-8?B?NmpzaUg1YkpmQ2ViSjNpSkh2emw5QUhVc0V5L3JNTEpWY3lSeWVQNHZKMUlU?=
 =?utf-8?B?QVZSSmtJSGliWWorOWxQTzBrYWtWVis2aHBKTy9xSk9CSFEyYVo5M2h3NTh0?=
 =?utf-8?B?Zld6dFdiMUs0NysxdWw3MElxWVIvLzg1RlRVWWlsVW5QclJDSXlEMEVOMHRp?=
 =?utf-8?B?UnZ0NzhHMVdTRkJiWFZkaEdNREtzODBSSGNxVVIrTXZEUU9vQ3hHRHpnOUV1?=
 =?utf-8?B?U0tWZ25pelE2QkphOEpTbDZoZ2trZWd3VHd2b0ZnaTl2VXNDK3o3VFJnS1RQ?=
 =?utf-8?B?RXNsZ09QZlRPTjhXOEtGa0htVFRhUU1uVEZrL2tFQWExWituV25iaHRmRFZn?=
 =?utf-8?B?UlNoY3Y3OHFBb04xUnFtYkdMNW4rWDRRcUw1aUlvL0JzTGdDcjAxbDlRYVdK?=
 =?utf-8?B?KzN1YVpNNWVqQ0pQdDN3dy95UUNDbkJkMllYK0ZNVUxnWFBjYkd3ZzhzTDZa?=
 =?utf-8?B?L2dYbzFmMk0vYk41YXlMMmRGUWIwRlpacElubHpEZDNuQ3VQQVFPRmJSK29Z?=
 =?utf-8?B?QTd6TVZvU0hZZnMyZmlwdTJPM0VLU3FnWlZsdmtoZlQrR0dpbFRKdXFYMk9t?=
 =?utf-8?B?V21DTmpjOElITTZBcHY4NnFoanZRUmFMM3FMQk5HejhQZXkyNjNUL3B3QnUx?=
 =?utf-8?B?V0U1ZXhMNkZzTEwyTkFpRWNNZG52WmRIK3hSNFVVNFdDaUJBMEhiQWxodjlE?=
 =?utf-8?B?emxlUVRQRkY3MWcrdmlFT0x1LzBGQmdzUVdyc0V0Tld3ZXhURDhLdnAyVWtM?=
 =?utf-8?B?RkxUcGZIcDAyeExuaEROcE5lZXl4RW5DNlJybVBhTEpVdklkUjlJVkxkWE9s?=
 =?utf-8?B?U0t4YXJ3bnNXeDdXeDhRb2xqcC8zaTBQUXV5MEhzbTVoNXNrSE9wSTB6UEZ1?=
 =?utf-8?B?R0V0L0ZJWXJ5MWRPVXVraXE3SVZMam8wcUpZYmpWaGFiNHFKRGNnUXI5RmZ0?=
 =?utf-8?B?UE5BWWl0dEhHWUV0TkVBRHFZRHhwc0htWExsUlZOUmRSMldUYTg4eEppbDY5?=
 =?utf-8?B?bTVGalhGVmFteUVObEkvZ242THFoNWFZdmNZVUZwV1Rha2ptY1RKUkVNUEkx?=
 =?utf-8?B?eTMxNTNyM0ErTk9DN2NOOFJBK0phczdwbE5lbHRDTFU0RkRLWmU2QkthcmJv?=
 =?utf-8?B?eGRjczJTL083U3VLYWl1OXZsN3ZKaU91NG1qakNFbmh1c3FrRUdNZ2d3UWpQ?=
 =?utf-8?B?Y0JIb0xkQXVFRWNVWElBeGhVeXdWZ2ROajgzRzltcWVUdWwxck50NjB4aFpI?=
 =?utf-8?B?UUk4NEJFbTZwb2crbm4yOE5TdWQzRlFiMjFHdmJwTmh3Wkg0RnJqdTJGanlS?=
 =?utf-8?B?SnNHUHpmZkxIcWhLTnlxRVJuZ0pkanEzZytleVM3THVLUnFKcXdxMXJiUkJv?=
 =?utf-8?B?TzdvSlhIUURKNmlhS1RMQTJwTyt2OXJZTmF3ZXdxeU9hdnBVajhhMWhKU0F5?=
 =?utf-8?B?V2IvYndsRVlnQ0tuNVZOQTc5b1hDekN0YURqRjFxbU1yV3JzMXBSZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38EA45F096D6A24F8301B0FE6F0545B7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TV6RZAOXVr1l5MvYWfPgc3u8uKmYzfS1YE4VkUQF3mTrsoIMTbh/nNBxSczAQNJWDovkpqtpkXSikcKA/5F7ZvpuKQ7Jwrp8ix49i95S6MjPMuz7tSXZoDBABsUvHfcXXKvp1x7q5GkQZ4+kgDVZ/5g7Cz2uunBKmNsIPC1i/1yHUblkMyt4BOx/oY92Z9BFhdvUOItXGHcLVDHOeYe6I+zI5gbD0SEQkwyDu2UbBb//kTNI+fQPWVmYYw1zgU2KlmDTrHiKR7Z9szzLF7rHPhiKpZoePiUNwEoHrxHLbOuyxmbiC8CCFhE1l076ZOqZRsTGd96/KF0dFWqKv4wuFw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R47dGz9Qtv4fHsGVA1HyiA2HWeF+SUI7vPkMMEg5q6UJv23NVZIMfAOOc2nUQ5FOFeIt+PQygG8ZvnGhGV1m/WgEn3Bk2B4YKN2mkj0NsqF66xuZDM38pjlLN0aPKQsNgF+YmC1PHSII5p/n/UIlemwDq10x7IPQLtDIWB8faCgeMuMwx+zNqN+ejpVcXQVs1RwLGeYHPYnpvFkYxBWY2Q8I/GDPE6004H+YHqaupRd6bz8o8jy4YXeMv8X5JyLoit7TCjUxpsB/Q/rywp0TdsX+kPtqk2HdOeHUNuwB1ARPJvHIXbjIC1i0ItERrJoDwEcUEcHTXqSYd8ubT2RymP9PzVK9md0aQLphHdupukKeVzGsW71ll7jCQdkGKqTUxuhUMKM66qCa7qzXsn6ZzF4F06KOl6B3xm6u/OCVufEZ52o+rD/2EnIVeuIR/iAMybflRHkap+jpo1VGJ6rMn6ISSrxiBY+Evncr8IU9P68QQU4SlGJTd7IxN0db+EtmiU5Tk8ZG3raU7pdd/OGBsz737x2mMzGuEr4KRApIja2b6PBxUr8KJFaseD2Igpe0STZ7HbjgK/Vn3/4eQFAxIClp9jl4t2SLndgoXtOOBkjUq13b5zkurYrIqMiVzM6Q
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adf525b-97de-4ef9-c3b8-08def914b657
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 08:27:28.6759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zvk/LGmg2Ibx5uPd//yG9j90dOjXPK8zb3aV7Z6tXT5J+Fn1sioRpSq1Ci8VaJXxn6r3pY/K/eyxzXs+Sdjz/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7793

T24gMTEvMDgvMjAyNiAxODo0OSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IFdoZW4gdGVz
dGluZyBvbiB2ZXJ5IGZhc3Qgc3RvcmFnZSBkZXZpY2VzLCBJJ3ZlIG9ic2VydmVkIHdyaXRlcnMg
dXNpbmcNCj4gaW9fdXJpbmcgY3JlYXRpbmcgbWFueSBvcGVuIHpvbmVzIHdpdGgganVzdCBhIGZl
dyBraUIgd3JpdHRlbiB0byBpdCwNCj4gd2hpY2ggdGhlbiBkb24ndCBnZXQgdXNlZC4gIEkgdHJh
Y2tlZCB0aGlzIGRvd24gdG8gbXVsdGlwbGUgaW9fdXJpbmcNCj4gaGVscGVyIHRocmVhZHMgZmlu
ZGluZyBhIGZ1bGwgem9uZSBpbiBpX3ByaXZhdGUsIGFuZCB0aGVuIGdvaW5nIG9uIHRvDQo+IHNl
bGVjdCBhIG9uZSwgd2l0aCB0aGUgZmluYWwgb25lIHdpbm5pbmcgdGhlIHJhY2UgYW5kIGxlYXZp
bmcgaXQgaW4NCj4gaV9wcml2YXRlLg0KPiANCj4gRml4IHRoaXMgYnkgZHJvcHBpbmcgZnVsbCB6
b25lcyBmcm9tIGlfcHJpdmF0ZSBhcyBzb29uIHdlIGZpbmQgdGhlbSwNCj4gY2hlY2tpbmcgY2Fj
aGVkIGZvciBhIGNhY2hlZCB6b25lZCB3aGVuIGEgc2luZ2xlIHdyaXRlcyBuZWVkcyBhIG5ldyB6
b25lLA0KPiBhbmQgYnkga2VlcGluZyBhbiBleGlzdGluZyBjYWNoZWQgem9uZSBpbiB4ZnNfc2V0
X2NhY2hlZF96b25lIHdoZW4gaXQNCj4gc3RpbGwgaGFzIHNwYWNlIGF2YWlsYWJsZSwgZHJvcHBp
bmcgdGhlIG5ld2x5IGZvdW5kL2FsbG9jYXRlZCBvbmUNCj4gaW5zdGVhZC4gIFRoaXMgdXNlcyBp
X2ZsYWdzX2xvY2sgYXMgYSBsb3ctbGV2ZWwgc3BpbmxvY2sgZm9yIHNob3J0DQo+IGhvbGQgdGlt
ZXMgdG8gYXZvaWQgaW50ZXJhY3Rpb25zIHdpdGggdGhlIGlsb2NrLCB3aGljaCBpcyB1c2VkIGZv
cg0KPiBjb21wbGV0aW9ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2ln
IDxoY2hAbHN0LmRlPg0KPiAtLS0NCj4gIGZzL3hmcy94ZnNfem9uZV9hbGxvYy5jIHwgNjYgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA1MyBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9m
cy94ZnMveGZzX3pvbmVfYWxsb2MuYyBiL2ZzL3hmcy94ZnNfem9uZV9hbGxvYy5jDQo+IGluZGV4
IDdkMTNmYTdhYjMwYS4uYmRiYjYwY2M1ZDViIDEwMDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX3pv
bmVfYWxsb2MuYw0KPiArKysgYi9mcy94ZnMveGZzX3pvbmVfYWxsb2MuYw0KPiBAQCAtNzkzLDE3
ICs3OTMsMzUgQEAgeGZzX2dldF9jYWNoZWRfem9uZSgNCj4gIA0KPiAgCXJjdV9yZWFkX2xvY2so
KTsNCj4gIAlveiA9IFZGU19JKGlwKS0+aV9wcml2YXRlOw0KPiAtCWlmIChveikgew0KPiAtCQkv
Kg0KPiAtCQkgKiBHQyBvbmx5IHN0ZWFscyBvcGVuIHpvbmVzIGF0IG1vdW50IHRpbWUsIHNvIG5v
IEdDIHpvbmVzDQo+IC0JCSAqIHNob3VsZCBlbmQgdXAgaW4gdGhlIGNhY2hlLg0KPiAtCQkgKi8N
Cj4gLQkJQVNTRVJUKCFvei0+b3pfaXNfZ2MpOw0KPiAtCQlpZiAoIWF0b21pY19pbmNfbm90X3pl
cm8oJm96LT5vel9yZWYpKQ0KPiArCWlmICghb3opDQo+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4g
Kw0KPiArCS8qDQo+ICsJICogR0Mgb25seSBzdGVhbHMgb3BlbiB6b25lcyBhdCBtb3VudCB0aW1l
LCBzbyBubyBHQyB6b25lcyBzaG91bGQgZW5kIHVwDQo+ICsJICogaW4gdGhlIGNhY2hlLg0KPiAr
CSAqLw0KPiArCUFTU0VSVCghb3otPm96X2lzX2djKTsNCj4gKw0KPiArCS8qDQo+ICsJICogRHJv
cCB0aGUgb2xkIGNhY2hlZCBvcGVuIHpvbmUgaWYgaXQgaXMgZnVsbC4NCj4gKwkgKi8NCj4gKwlp
ZiAob3otPm96X2FsbG9jYXRlZCA9PSBydGdfYmxvY2tzKG96LT5vel9ydGcpKSB7DQo+ICsJCXNw
aW5fbG9jaygmaXAtPmlfZmxhZ3NfbG9jayk7DQo+ICsJCW96ID0gVkZTX0koaXApLT5pX3ByaXZh
dGU7DQo+ICsJCWlmIChveiAmJiBvei0+b3pfYWxsb2NhdGVkID09IHJ0Z19ibG9ja3Mob3otPm96
X3J0ZykpIHsNCj4gKwkJCVZGU19JKGlwKS0+aV9wcml2YXRlID0gTlVMTDsNCj4gKwkJCXNwaW5f
dW5sb2NrKCZpcC0+aV9mbGFnc19sb2NrKTsNCj4gKwkJCXhmc19vcGVuX3pvbmVfcHV0KG96KTsN
Cj4gIAkJCW96ID0gTlVMTDsNCj4gKwkJCWdvdG8gb3V0X3VubG9jazsNCj4gKwkJfQ0KPiArCQlz
cGluX3VubG9jaygmaXAtPmlfZmxhZ3NfbG9jayk7DQo+ICAJfQ0KPiAtCXJjdV9yZWFkX3VubG9j
aygpOw0KPiAgDQo+ICsJaWYgKCFhdG9taWNfaW5jX25vdF96ZXJvKCZvei0+b3pfcmVmKSkNCj4g
KwkJb3ogPSBOVUxMOw0KPiArb3V0X3VubG9jazoNCj4gKwlyY3VfcmVhZF91bmxvY2soKTsNCj4g
IAlyZXR1cm4gb3o7DQo+ICB9DQo+ICANCj4gQEAgLTgxOCwxOCArODM2LDQxIEBAIHhmc19nZXRf
Y2FjaGVkX3pvbmUoDQo+ICAgKiB0aGF0IHdlcmUgZXZlcnkgd3JpdHRlbiB0bywgYnV0IHNpZ25p
ZmljYW50bHkgc2ltcGxpZmllcyB0aGUgY2FjaGVkIHpvbmUNCj4gICAqIGxvb2t1cC4gIEJlY2F1
c2UgdGhlIG9wZW5fem9uZSBpcyBjbGVhcmx5IG1hcmtlZCBhcyBmdWxsIHdoZW4gYWxsIGRhdGEN
Cj4gICAqIGluIHRoZSB1bmRlcmx5aW5nIFJURyB3YXMgd3JpdHRlbiwgdGhlIGNhY2hpbmcgaXMg
YWx3YXlzIHNhZmUuDQo+ICsgKg0KPiArICogQ2FsbGVkIHdpdGggYSByZWZlcmVuY2Ugb24gQG96
IGhlbGQuICBBbmQgcmV0dXJucyB0d28gcmVmZXJlbmNlcyBvbiB0aGUNCj4gKyAqIHJldHVybmVk
IHpvbmU6IG9uZSBmb3IgdGhlIGNhbGxlciBhbmQgb25lIGZvciBwaW5uaW5nIHRoZSB6b25lIGlu
DQo+ICsgKiBpbm9kZS0+aV9wcml2YXRlLg0KPiAgICovDQo+IC1zdGF0aWMgdm9pZA0KPiArc3Rh
dGljIHN0cnVjdCB4ZnNfb3Blbl96b25lICoNCj4gIHhmc19zZXRfY2FjaGVkX3pvbmUoDQo+ICAJ
c3RydWN0IHhmc19pbm9kZQkqaXAsDQo+ICAJc3RydWN0IHhmc19vcGVuX3pvbmUJKm96KQ0KPiAg
ew0KPiAgCXN0cnVjdCB4ZnNfb3Blbl96b25lCSpvbGRfb3o7DQo+ICANCj4gKwkvKg0KPiArCSAq
IElmIHRoZSBvcGVuIHpvbmUgY2FjaGVkIGluIHRoZSBpbm9kZSBzdGlsbCBoYXMgZnJlZSBzcGFj
ZSwgdXNlIHRoYXQNCj4gKwkgKiBpbnN0ZWFkIG9mIHRoZSBuZXcgb3BlbiB6b25lIGp1c3Qgc2Vs
ZWN0ZWQuICBUaGlzIGNhbiBoYXBwZW4gd2hlbg0KPiArCSAqIG11bHRpcGxlIHRocmVhZHMgcmFj
ZSB0byBwZXJmb3JtIHpvbmUgc2VsZWN0aW9uIGZvciBhbiBpbm9kZS4NCj4gKwkgKiBpb191cmlu
ZyB3b3JrZXIgdGhyZWFkcyBzZWVtIHRvIGJlIGdvb2Qgd2F5IHRvIHRyaWdnZXIgdGhpcy4NCj4g
KwkgKg0KPiArCSAqIFdlIG5lZWQgdG8gZ3JhYiBhbiBleHRyYSByZWZlcmVuY2UgdG8gdGhpcyBv
cGVuIHpvbmUgYXMgdGhlIGNhbGxlcg0KPiArCSAqIG93bnMgYSByZWZlcmVuY2UgaW4gYWRkaXRp
b24gdG8gdGhlIGlfcHJpdmF0ZSBwb2ludGVyLg0KPiArCSAqLw0KPiArCXNwaW5fbG9jaygmaXAt
PmlfZmxhZ3NfbG9jayk7DQo+ICsJb2xkX296ID0gVkZTX0koaXApLT5pX3ByaXZhdGU7DQo+ICsJ
aWYgKG9sZF9veiAmJiBvbGRfb3otPm96X2FsbG9jYXRlZCA8IHJ0Z19ibG9ja3Mob2xkX296LT5v
el9ydGcpICYmDQo+ICsJICAgIGF0b21pY19pbmNfbm90X3plcm8oJm9sZF9vei0+b3pfcmVmKSkg
ew0KPiArCQlzcGluX3VubG9jaygmaXAtPmlfZmxhZ3NfbG9jayk7DQo+ICsJCXhmc19vcGVuX3pv
bmVfcHV0KG96KTsNCj4gKwkJcmV0dXJuIG9sZF9vejsNCj4gKwl9DQo+ICsJVkZTX0koaXApLT5p
X3ByaXZhdGUgPSBvejsNCj4gIAlhdG9taWNfaW5jKCZvei0+b3pfcmVmKTsNCj4gLQlvbGRfb3og
PSB4Y2hnKCZWRlNfSShpcCktPmlfcHJpdmF0ZSwgb3opOw0KPiArCXNwaW5fdW5sb2NrKCZpcC0+
aV9mbGFnc19sb2NrKTsNCj4gIAlpZiAob2xkX296KQ0KPiAgCQl4ZnNfb3Blbl96b25lX3B1dChv
bGRfb3opOw0KPiArCXJldHVybiBvejsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIHZvaWQNCj4gQEAg
LTg3MywxNCArOTE0LDEzIEBAIHhmc196b25lX2FsbG9jX2FuZF9zdWJtaXQoDQo+ICAJICogdGhl
IGlub2RlIGlzIHN0aWxsIGFzc29jaWF0ZWQgd2l0aCBhIHpvbmUgYW5kIHVzZSB0aGF0IGlmIHNv
Lg0KPiAgCSAqLw0KPiAgCWlmICghKm96KQ0KPiArc2VsZWN0X3pvbmU6DQo+ICAJCSpveiA9IHhm
c19nZXRfY2FjaGVkX3pvbmUoaXApOw0KPiAtDQo+ICAJaWYgKCEqb3opIHsNCj4gLXNlbGVjdF96
b25lOg0KPiAgCQkqb3ogPSB4ZnNfc2VsZWN0X3pvbmUobXAsIHdyaXRlX2hpbnQsIHBhY2tfdGln
aHQpOw0KPiAgCQlpZiAoISpveikNCj4gIAkJCWdvdG8gb3V0X2Vycm9yOw0KPiAtCQl4ZnNfc2V0
X2NhY2hlZF96b25lKGlwLCAqb3opOw0KPiArCQkqb3ogPSB4ZnNfc2V0X2NhY2hlZF96b25lKGlw
LCAqb3opOw0KPiAgCX0NCj4gIA0KPiAgCWFsbG9jX2xlbiA9IHhmc196b25lX2FsbG9jX2Jsb2Nr
cygqb3osIFhGU19CX1RPX0ZTQihtcCwgaW9lbmQtPmlvX3NpemUpLA0KDQoNCkxvb2tzIGdvb2Qs
DQoNClJldmlld2VkLWJ5OiBIYW5zIEhvbG1iZXJnIDxoYW5zLmhvbG1iZXJnQHdkYy5jb20+DQoN
Cg==
