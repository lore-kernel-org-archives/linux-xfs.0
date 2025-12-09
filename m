Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A1B1A58D;
	Tue,  9 Dec 2025 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765301356; cv=fail; b=WGeWosiNZMM0gXcz2jrTaEV4y2m6+LYdNrknG795Vav12CjnWVd6G8e1TnkeJWzYbCFfKFCzSim0uQZMdwLEy3h1yKPpU6cICuqfewY7XSD/MvN4Odj6lcKVaVwCVKUvrTbOcbkhr3TN+rgpanNY3GxhLfUJ0Stu4ewMrtVQ6Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765301356; c=relaxed/simple;
	bh=kGWDmFIVQrQZRnAPQfCHl8XKHnQ2K2kCukkPRHMkP9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Uq8m5XQ6orC7YMTT9FMFSxZ53VJeR74gEo7eieKf3mQ86xmVqvRrGroKm5yRscufpC1VxFCk7IcjWU/x1ENTFV26Vcl7D7CzERfWFexLo8yi/3MIUurAHigiT8KX+Rix9fA7/30C2j+Z0fw6Q4FAOq9PfRHyiVwQl7vIrYkZFL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MqzawZCJ; arc=fail smtp.client-ip=40.93.195.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MqzawZCJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EYSVAYDNktSZAZagnO9FW95VOYsUAgY+1lTNHjtACHwScUFtu4jlaDTEtj6qxctCAVqXhDcJqaeg8x3MfrN0RdS1vSNtUoPOal/ydHiC5A8YYDaxRXyuiEO4BEVt0NkvNWmAQGbUCndWn6dEE5V8eM9vdTPVpU52oiEo1/agL7srnIR5jn06t+/XW31Q//aAjsmoaFtQVF8yi724FwZ8CZo7KYoziCL0U0ERzIveq4YmS2XpIP37ZNpft6XpdbvT5R2hmmWj8xTgMjM608Eot04i/Q3Gh+DbwajWned5eW1dfVOQGwp/I880dFsTFEZNwkq5QdR3TDecUh991D3G+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGWDmFIVQrQZRnAPQfCHl8XKHnQ2K2kCukkPRHMkP9E=;
 b=Vm36sz3zt7EG/YHedB8VI6vH0AC2B0139bTbaWz31vcmI0Z+sGK2fuGEbfSK45/kNsIki0n9DPZMB9JNZ4+5pSI4Fl3JnynAr7XO2heDvpD5FpDpkjSakUjOoVo9ZBse6F6w/qJQPFk3HepiW0PyvftpALTmYc6/MQu8zpc+zGHfdWlWYiVz7NMMrNaEVW/X1mpzUiTQcGRG6tUBfTX6ugoRDEfsxhGfVDQiA6bS2bQIOf/+p6XB6iCQcbXUipa+uzeu8lh4ELlZIC398UrSNgr9KRKAb/QQg0qknRovW+r8t+DZ6CcP9VwjxNuwlNPDLinsphV8WDVK7MHe/cUQ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGWDmFIVQrQZRnAPQfCHl8XKHnQ2K2kCukkPRHMkP9E=;
 b=MqzawZCJlZSA03fH8ZBr4rA3nbTFJ4reZm3nYAAdU5Qj1T7nU15ZQa3VjQ3TdqV88tYYNSjcxNdERC8+H0E7V46j43T4hZTOXM2p4xOWcBAWgrgtUNy0rBpRdf1/yUEX/LSMe85EV0PqQp6RBWbqz6dXDVfD3pT7+phYv/oKz4CGYPk7BiIWUKhW3pGfKhXw83WxyTGz5QUB1gnwxObtSFQQqmNU5JMDx2+JBDZkIKI9my/5ok9S7uCj9vphLKbDA2Zi1AUuXoQx1bwz+FfADG2wWEW3Hh++MFKWbl8HxKQFz6rdFmDKPxos29NDsoC99y1g/cNMwcjkWnxK8UKlng==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8904.namprd12.prod.outlook.com (2603:10b6:610:167::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 17:29:09 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 17:29:09 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
CC: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Will Deacon
	<will@kernel.org>, Carlos Maiolino <cem@kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Sebastian Ott <sebott@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Topic: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Index: AQHcaQFVH3CUuaIhmEu/T0GQ8kjfQrUZMfcAgABerYA=
Date: Tue, 9 Dec 2025 17:29:09 +0000
Message-ID: <d1d76dcb-5241-4290-ae69-7d20e4461b9b@nvidia.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
In-Reply-To: <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8904:EE_
x-ms-office365-filtering-correlation-id: 2aca2f9b-79a6-4154-f233-08de37487660
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MmE5ejRHZTI4UVBQQmQ1Uyt0ZGhKUW1vdW5JUFlURUI1a3Z1ZGNxYUs4cUtx?=
 =?utf-8?B?anZzVUNGTVpPWGZKTU5tUGJnMHFXa21kMDAveklWYzROQm5SZkE3WDNyb3Vu?=
 =?utf-8?B?YklMQ2FkakY2aWp1YStseTZrUEpMc2Q4dTlOT0FCbDZvRDhIcDJUa3dES3do?=
 =?utf-8?B?SlVLL2pDbWJMNGZ0dExUaGZGTFVCMkhHS0ozalAwMEVTenZPT0VkNlZyalUy?=
 =?utf-8?B?b2NUUzgvQUhXUmhUcUUvWS9QQ1pTeGtVTHlRV2IyZWhDL1pWV3lVUmR3Rmc1?=
 =?utf-8?B?RHVhd2JReXQwWVBXb29mU1hqQ3lZQTNyeHY4VU1CdkxCUzdPRmR0KzZGUUd6?=
 =?utf-8?B?M1oyZUgvMmd1SFIyVzNHZ0Y2RVJGcXNWbUl6OEd2a3NOTEpnL0NSK0JSL1Fs?=
 =?utf-8?B?aE9ZR0dXV1ZaQm1MRVJBQm5pa29ZRzZySWQ1eFhGVXVNbDlIUWgzd0x3ZjVi?=
 =?utf-8?B?UjFkMzNnVUl3UlRqaFhXbnVFajNsQlREUStuV1p5T2xORmVwZCsvL3RlRlFr?=
 =?utf-8?B?S0VlTkhnalR3SXhURHNFejVleWNXZEJDL1ZwY0VjODBKak13dWpKTUkwZnFX?=
 =?utf-8?B?cExYYk01akNCSit1ajJqbDQ0ZTJMbFFhTjdZaWRWbzhBeERLak9RUlRqdEFh?=
 =?utf-8?B?TTROWWgxc2Jrck1WeGs1WnNFaTNDYkxTaks2U2toYzhlV2M3dUt5alBCNEov?=
 =?utf-8?B?cjJrWE5vbmt3Yi9SRGR0dzhGbGMvWFRzdnlWR1hNTUR3RWpXb2R5azRHeWY2?=
 =?utf-8?B?cDZTSURlbC91bTEwazlaSXFRbXNkNXpLOHhTYjZ1bWhMdzY4NWZuZmZQR0ZO?=
 =?utf-8?B?YUN4MzJNTnhONTlHelFFa0NMNlhiNkxBRW5XN0NlaHliOEx2SkRpclkvUmxw?=
 =?utf-8?B?SVdBc3RvdzB6RGpnUUlVU085cWdyWUsxRmFCMUUwWHgwVk5aWlp1c1FzcXV1?=
 =?utf-8?B?TEhaU3M3ZU44aWQ2RnMzSzJ2eWRURVlSakdlZnJuTG9tRkJSaDdlOUhQUEcy?=
 =?utf-8?B?WDJPaURWWEEyWDBxVTRyY0Q2S0NSL3UrMkJNSHBON2FFencrQzNXdHNqRHNY?=
 =?utf-8?B?bGkrb09LWXBpNFd1d0RPcnUwQ2RFeTZtdTlHakR3cFREUVRZYXZxNlBXdnI0?=
 =?utf-8?B?UEdzN0t3SG1BSWUyd0Q3TDNmWGx0dk5pVW14T0JuSHdCVHJHc1czUU1VMW1V?=
 =?utf-8?B?UjFvbW1yK05nM0prYU83dEJrdVI0U1RyTFF4UzFwVkFnNkJ2Z2J2ZWV4b3RV?=
 =?utf-8?B?cHpMb1NmcElHZ3dZaGcyR0tyTXdkVjlNUVlhaDNGZ2hCSUVSNUw3ay9nRU5x?=
 =?utf-8?B?Ym0xeFpNOXBvK21lS2xldXYxMDRwcXBCZkxSUWdDNTFWWHNPeS9ZYjdYeWtS?=
 =?utf-8?B?bTdlQ0xucHlnTWZUVkdEcFE5dDNzMmlvellGTE1OVXJvbW5tMDFPOXVGcE9p?=
 =?utf-8?B?S1lHYVVLU29PUnBBZS91SUd4dTh6cTdLdGEwZnBValEzaG1IeVREWXNudFgw?=
 =?utf-8?B?RTlrTnltM3JGT01mdERGTWU0dnlFcDROMHB0Q0x4eURLc0p3ZXFpdURhNjNW?=
 =?utf-8?B?dEgwMytRS3ZqVkN1eHZyZjRiaWRJQTRaSmZYUVpHZFpYbU9ZYjIvS21EYTFC?=
 =?utf-8?B?cFRLMzJhYjJpR1N6bVI4amd4RVB5cHJyMlcrSWU4dk1mek5PbWxObkI3ZXlU?=
 =?utf-8?B?d051b1JEUWZ3MVBHelU1NkUvTk5lQk56WGgxcS9Ta0w2WDFIUVVpZml4aEFH?=
 =?utf-8?B?RTJxS1ZGT2pBdFVBbG5qY00yL0NDeHlaQzJwWEZlUWlld0xJNnlYeDdGMHlQ?=
 =?utf-8?B?YWFtbTdlVzVFRTZSZk0wVEdXYUZQTSt0blIzRXQ1d2xTcTJ0Zml4eHFnamVH?=
 =?utf-8?B?N1h0NG91b3JKQWJjQkFPZGs5KytyY2t1VDhJM2Yyb05ueDJHalp2b0JwZjZi?=
 =?utf-8?B?OUkvck5VSys0b1dFYmtnKzZpSnFOVEx6WVdvejNMbjBFWWs2R3BqYXZiSVNz?=
 =?utf-8?B?V2lVZERFSEZ1MExkand3amxvYjBQY091V3ZqckU5UlpKSFRML1dneDdQM2dp?=
 =?utf-8?Q?0YnAHS?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cjdoMmYyK0pFU3QvcDlrQW1HMEdXYjg5djFHVU40WHJ3REZGMWZMRUFtWm04?=
 =?utf-8?B?M1llVmxUKzBPU1ZQNnhIM0h0WDhleE0vZUc4MHljQSttVGV5R2cxS21nUlVv?=
 =?utf-8?B?N2NCUUpJQ3pNUzFDWlQzMm1PbU1mcHlXb0VIQklRZnEyZ3N5NTdIcG41Q0hj?=
 =?utf-8?B?bHFMZ2ltR2lFWkdKRncvUDd6ZFNZajM2d2FCclI3UG9EalptbWVOampWZCtu?=
 =?utf-8?B?U0M1SDJ1RnpmZEZpa2N5VGtNWTYzSEt2WG9QUHJ5YU9pcmd3UHRSZTBtUXlm?=
 =?utf-8?B?L0lDVE5qZ3NlR1JFVU9oaFVQWmczclAvUnlwYXM5LzNVaWxsS2JMa0lzRTNW?=
 =?utf-8?B?cWhmZ2g1aW5pc1NxNTYxRHRMblI1My9tZmF5WGVuQlA5akpoc2s5aWpodmdt?=
 =?utf-8?B?NENUZWd2VDR0UnN0K2p4OExLaDdGVmFXTktCUTU4cXBrb2JYQ0VCbWpCbGFT?=
 =?utf-8?B?czY4akFpSjFWOGVnTW5nT1Z5ajErVFpGNEJUc0thMEt3dWFUMjI3dUVaUjVx?=
 =?utf-8?B?M1Y4T2NWajhoaVZmYWhsdUxIbTZDdE44T2hZVHVpZUQ0Mk5mdUdhclU4c3pZ?=
 =?utf-8?B?bkgyaTlrRnJyWWFySkxjOEZ2STdoZmxOcGtJWk9OTVZKUG5ubzZlVXBmd0Rt?=
 =?utf-8?B?RXNDNnBTWWdTRmQ1cmJRYmFJWmZqMEZyR09vMHk1Z05EVDExZldiNFgxTFE1?=
 =?utf-8?B?YVVIVEtGdTVZaHlTYTNJSjdHV2NZYWJrbFZoNUdzM1VZZ3lIRFluNXRzYWNS?=
 =?utf-8?B?RjNkT0lYOGtuZnRoaU45eVkyMXJkd0h5eXc1UHBtWEtzd204U1B3aHMrR1Rh?=
 =?utf-8?B?WjlGODltR24wNEdVdmYzMDE3d0YwMEx1V3BUZFcycGM1bmhkVzNsbXRrd1FY?=
 =?utf-8?B?bE9XVm9yek9pNTN3cDJPVm5YWUNqTXVrRFptT2Yxd05NeHd1NUhSYVNzclBx?=
 =?utf-8?B?eTJzdnlYSEYwL2o2NkRwcDk0bHRqOGtONnoycE1JVXJvZE8xajVaSHlFS3Vw?=
 =?utf-8?B?dUU3bHVYT2NEd3ZFbkRrTmIxMjk1MzRpTm9wWldpQlVmR2JiTWhSelR4eTRI?=
 =?utf-8?B?aDNNZkpoSFJXQVdLY2ZwUkp6RE04d2xibVBneEdOVVBGRGZHSXdBTWdvNTZm?=
 =?utf-8?B?QUxDamM5aCtoS25uckpvOTJ3VGNFckdqUjhpc0hEQWNTVzdxY29jKzF6OWtB?=
 =?utf-8?B?bGhiakpmRnF4enprRnAwTW9vYnh1OGZWd0NLeW9XNHZYWTFQZmNseWErRjB4?=
 =?utf-8?B?Yncxb3ZETWU2SjVWSStSUW94SmtmelBRUzFpa08rK0xpWExoZ2dGMHRkMXZt?=
 =?utf-8?B?bFprNFlSUkRhMWRMWVlLUjRCbDdvRXhzTENtUWZ3NDhubWVDQXlESE53ZWhy?=
 =?utf-8?B?NGpVem5WZ0d1L3FuTm5mU0NnYzZuaTZFSWRWcXMxTmdwWjVZRnR6R2V2NGFC?=
 =?utf-8?B?VzNIWmJTWWt3NGlEcy93cG96TCtnbDl4TkJ3OG9CUDM3MituMEtxV0xldzZm?=
 =?utf-8?B?ZXloYmtabGJDV3llb3FJZUFyUXBxMkhseGFRd0pmZGxtdnRIMFQxRmJWNDR2?=
 =?utf-8?B?eVhxcXhCUzlaNlhYdGZtVXdwUkJBY2dPVjVuL29LZk1VdzcvWE4wMStGakpS?=
 =?utf-8?B?UlJNMmtsK3pyczBqY1dRS0J1OWlORnJrODBGNFNQRFAzTUFKSzcyR0pHOWJ2?=
 =?utf-8?B?bitLZ0E3UHMrZkZ3WWlxWUVVRlpndWwwckRUNnBpSmY3WnFoenlVZkxZdmdS?=
 =?utf-8?B?ak1YWmU4YTV3R203c2J1Tkx2YkdtMFEzaXNaUFJqVGo3Y2pWQmx5Z2NSa3dB?=
 =?utf-8?B?bHlEcUE3N3NieSszWUtLcVVudnhMT3oySlFzYzk1ZkVCUTI2L3hibGJ0VXRB?=
 =?utf-8?B?aHp4eENuSGpzSXkwYVZZaXpYaGNkeFFSWm9ac08wQVBHMkxCYVNjdXFFLy9m?=
 =?utf-8?B?bUl0Q0FwUnlyTGpDQ2ZSSktPRzdDS080YTR4bFFNQVpPNUpBNUhMWmZnOXRh?=
 =?utf-8?B?cWM3NitVS0FlU01rTUx5Ym5FYS90eCszRnh1UmJRbnYyZXZkcWhJSktvY2lR?=
 =?utf-8?B?QjNwMVFUZFlPTGhBb0RZVFM5NERWaUx4WnIwbEZjWDZMNDBPVjNsQlNVV2Ex?=
 =?utf-8?B?ZXMyT2FvRVR1SDJqQlVaSlp6amNqTktiR2Q1ckJDVk0vMDZMU1lQTFFFYjlm?=
 =?utf-8?Q?+Bj5dq2urxGGKdk06ONQwdhjR+7GLpCEWHojwpD5TiL4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB5EEAC140EC924CB19D9818FBF25E04@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aca2f9b-79a6-4154-f233-08de37487660
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 17:29:09.6296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xlMfNf90gROP0t5beGgNVI0e0buJPwWuvzYynIhyP1j+c8YI1e1uL2kHGojjMYUPq0sQccrFKWu1qeIld5CBZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8904

T24gMTIvOS8yNSAwMzo1MCwgUm9iaW4gTXVycGh5IHdyb3RlOg0KPiBPbiAyMDI1LTEyLTA5IDEx
OjQzIGFtLCBTZWJhc3RpYW4gT3R0IHdyb3RlOg0KPj4gSGksDQo+Pg0KPj4gZ290IHRoZSBmb2xs
b3dpbmcgd2FybmluZyBhZnRlciBhIGtlcm5lbCB1cGRhdGUgb24gVGh1cnN0ZGF5LCBsZWFkaW5n
IA0KPj4gdG8gYQ0KPj4gcGFuaWMgYW5kIGZzIGNvcnJ1cHRpb24uIEkgZGlkbid0IGNhcHR1cmUg
dGhlIGZpcnN0IHdhcm5pbmcgYnV0IEknbSANCj4+IHByZXR0eQ0KPj4gc3VyZSBpdCB3YXMgdGhl
IHNhbWUuIEl0J3MgcmVwcm9kdWNpYmxlIGJ1dCBJIGRpZG4ndCBiaXNlY3Qgc2luY2UgaXQNCj4+
IGJvcmtlZCBteSBmcy4gVGhlIG9ubHkgaGludCBJIGNhbiBnaXZlIGlzIHRoYXQgdjYuMTggd29y
a2VkLiBJcyB0aGlzIGENCj4+IGtub3duIGlzc3VlPyBBbnl0aGluZyBJIHNob3VsZCB0cnk/DQo+
DQo+IG52bWVfdW5tYXBfZGF0YSgpIGlzIGF0dGVtcHRpbmcgdG8gdW5tYXAgYW4gSU9WQSB0aGF0
IHdhcyBuZXZlciANCj4gbWFwcGVkLCBvciBoYXMgYWxyZWFkeSBiZWVuIHVubWFwcGVkIGJ5IHNv
bWVvbmUgZWxzZS4gVGhhdCdzIGEgdXNhZ2UgYnVnLg0KPg0KPiBUaGFua3MsDQo+IFJvYmluLg0K
DQpBbmtpdCBBLiBhbHNvIHJlcG9ydGVkIHRoaXMuDQoNCkFwYXJ0IGZyb20gdW5tYXBwaW5nLCBi
eSBhbnkgY2hhbmNlIGRvIHdlIG5lZWQgdGhpcyA/DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lv
bW11L2lvLXBndGFibGUtYXJtLmMgYi9kcml2ZXJzL2lvbW11L2lvLXBndGFibGUtYXJtLmMNCmlu
ZGV4IGU2NjI2MDA0YjMyMy4uMDVkNjNmZTkyZTQzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pb21t
dS9pby1wZ3RhYmxlLWFybS5jDQorKysgYi9kcml2ZXJzL2lvbW11L2lvLXBndGFibGUtYXJtLmMN
CkBAIC02MzcsNyArNjM3LDcgQEAgc3RhdGljIHNpemVfdCBfX2FybV9scGFlX3VubWFwKHN0cnVj
dCBhcm1fbHBhZV9pb19wZ3RhYmxlICpkYXRhLA0KICAJcHRlID0gUkVBRF9PTkNFKCpwdGVwKTsN
CiAgCWlmICghcHRlKSB7DQogIAkJV0FSTl9PTighKGRhdGEtPmlvcC5jZmcucXVpcmtzICYgSU9f
UEdUQUJMRV9RVUlSS19OT19XQVJOKSk7DQotCQlyZXR1cm4gLUVOT0VOVDsNCisJCXJldHVybiAw
Ow0KICAJfQ0KICANCiAgCS8qIElmIHRoZSBzaXplIG1hdGNoZXMgdGhpcyBsZXZlbCwgd2UncmUg
aW4gdGhlIHJpZ2h0IHBsYWNlICovDQotLSANCjIuNDAuMA0KDQpkaXNjbGFpbWVyIDotDQoNClRI
SVMgUEFUQ0ggSVMgQ09NUExFVEVMWSBVTlRFU1RFRCBBTkQgTUFZIEJFIElOQ09SUkVDVC4NClBM
RUFTRSBSRVZJRVcgQ0FSRUZVTExZLg0KDQotY2sNCg0KDQo=
