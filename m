Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF75B1D5CFB
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 06:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570540; cv=fail; b=qiEMO6loMktXQPt6R7J0M7R2BGaVWJn3uPVD6PFamt6TzCknFmJJGFtsbNpRCjbsohkZrBnsZ2AxP7mYfWpURSHkk9rhpMqNpltoqaq0ZbxdCikDhKR7BSxSrvHnzssIWyFPkmrZC2DeXZsLk2fqHpOh5UNFpKd/koLN0Ydv/UU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570540; c=relaxed/simple;
	bh=L88j94bkZUL5RHgR96b97ZH4tr+sX6IwaWm8nadY9ck=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rulI4l7uhunqdyfTRVrz5NOV+S0IuUZI7dt0ROpp2Yb5oI2rHlofhzGjD5W4jEd9y0+HYZRg6nuc6hu7cByDho9G8TNYPN8wqbFFuIeYDt0lon9t18Jsfy5XM99U+k6zntsEgFxKpMMsyhgF0tuwYaBMkB5j7HySPx8dP650kdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sZBiecc0; arc=fail smtp.client-ip=40.107.209.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sZBiecc0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iQ788ruQQG1uwM3ff0ynBEOx2Cey+OhY9xuc3SbKxSsS7CGIwl4rs/TgGjLIOKANWPHXMtcOJK/ercNhn74uJ6hI0PjnKpOo3+5U7Boc8Oz2zvhy2PwLDjj3Mi1lvfsK/a32XbTizYnzixjPKhzk/ksuWheGlVWQvN6ZUB10QnKXnSp6INaz8XdOyswCcRY2EccnX50FraQptCSUFSDa+h/dZVP/NL46Q3kFMWj7exCh3NBpYQX1/vPwrvZnjpi5a8n5HyF38EA+ZIk1etveoO/QsRrau1nNkYxUN4iq0X0CTOpYK6kKum9kZMvipT/zfIjOZotQKSVDtxe0xfRVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L88j94bkZUL5RHgR96b97ZH4tr+sX6IwaWm8nadY9ck=;
 b=VN54VfhB4+lnJqfRU5iMCIFpPMPh54BUpwJAA7psOKLDuguprxx7LEExgAJL25ptVSISwuTsx9UwpH7jD8y2gy+KmryJYF3fccUblfu3H9A7iH3xWJ1XGoe6oGF+YgcZfGbb3Gg8L5uRABWyia7bVN4MUGPmRjwNT3W7ffCBkOsQyNQERZgOTi8QkbRjS4e50Too5CJ2Passximv5wOQyAPhtvPswXaPywPx6am6ukCcoi2m8jo0LPAccycdWpQGNDJjjONqe2O4ILvVN7yAr+oxCPW2ZYLwdj6Cqx9Pp9cNwuecYAp/29WQ6IRN55At7WSKMk2Kpe3QYwH3JPxVmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L88j94bkZUL5RHgR96b97ZH4tr+sX6IwaWm8nadY9ck=;
 b=sZBiecc0dlu18NE9Kxp/63kww22NT3egweZIv20PzgRUH9hUH7eyQvL8RpyV0pJAPvxEfGKyXfaSCvKeCssAwRT0IfjSwBPvVXsFqfADWVTeIIwx02d83YBeMBDAOGbN+cxjirngjpoiA2yPw+ddK182oDBclf1odOi5lilXHPKEERejHyNFaZxmFDSKIneeTVsUylNoJlBHd2IZxHiH+qlTTbbMZwF+9RtEu4KhgsrlP2dL2bIeyPrixONvbpIB+K3iopz3DW9aZKGCNgzKJP4EY8ccxUL2RMq9QAMwWcAgPETirQ9uz0ybHeMhVtimd3+i+2mqALSOE79EWqC7xg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY8PR12MB7169.namprd12.prod.outlook.com (2603:10b6:930:5e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Mon, 1 Dec
 2025 06:28:56 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 06:28:56 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Chaitanya
 Kulkarni <chaitanyak@nvidia.com>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni
	<ckulkarnilinux@gmail.com>
Subject: Re: [PATCH V3 6/6] xfs: ignore discard return value
Thread-Topic: [PATCH V3 6/6] xfs: ignore discard return value
Thread-Index: AQHcXZzYTTMNsQDUtk+Pu9E/Yu2pabUMXE+A
Date: Mon, 1 Dec 2025 06:28:56 +0000
Message-ID: <d9a0eb14-c532-425d-be8b-b6de58e8db31@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-7-ckulkarnilinux@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY8PR12MB7169:EE_
x-ms-office365-filtering-correlation-id: abbcade9-0b6e-4d33-4c05-08de30a2e78a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWkvZytYeEp4Rzc5MlNrNlN0eDdBcUtaeTd5Qm9LZ3RyaE52RDJNc3pUWEsz?=
 =?utf-8?B?SERNYzFHQnJYVGdLeVZxbGhKOWdLN2hxZ2tGNFUwYW8xaU1hNnJHcUlYMEsz?=
 =?utf-8?B?MjZyY1YrdTAwVFJPUkltUWIzOW1LZWZIbkIwVVBEazJldGdVSDZOQ2VKTjBn?=
 =?utf-8?B?ajNNUGdscGFLd3JZUDJxMTRoc3kwU1d0dTJLSzlvM0hod3B0OWxuVjAyY1lG?=
 =?utf-8?B?OC91emhacGpPMjl2a0VTZnBvMDhEZ3p2eG0xMW9Bd3VKSVdCMThFZ0Evb2lz?=
 =?utf-8?B?ZmZVZHBKNTdKLzFEdjVZYzIxWTdlU2RheERyZE5lUU9yTjVNRm1CSUcvOURV?=
 =?utf-8?B?Tk13TUdVdHJHN3l3RDkxeEJvL0tSU3BNd29ZTVhoZDFvdUowaEtTbnE2cTVD?=
 =?utf-8?B?enJSc04ydGpqZW9sSDFSQjJOMW5xZFZYY1dtdlY0dG9PdENMT2dtUHVPVFNL?=
 =?utf-8?B?NFdPU2FIbEE0dFBHVndUOUJ5a21zdDJTM2JmbHMrSTFJTFk5TGhBYkpIc1hJ?=
 =?utf-8?B?ZmZad1htcnUxRVhVT0JzZ1o5R0NsMzUyakgrbnNQTVJvZmM2akI0dnRpWW5o?=
 =?utf-8?B?RkFGQldCL29vTStPNVNvVTN6MTRwdGxsUFE4akVZK25HZkhrREtsYWc0djFL?=
 =?utf-8?B?bjJmaGZGQmM0WXdoTDNDYmVpclRuUjdzS0tUMittVGN3aUEzRVdzOFdBaGVZ?=
 =?utf-8?B?QU5BRlRPVlZsckFwZnJiWnhXZnVack5Sd3RJamZUOWpBMkZ4MW40aXFqVWs4?=
 =?utf-8?B?YTdUbDBNTDdmT3MwSWFISWl5RU1NMUJnRUJsajdVTDEzV1BHWEp6WGFDRUln?=
 =?utf-8?B?TTYyVUpWajVnQmVtZ3ErMjBPbWpncFpkeTFrdkxFbkdsZmtBa0E2M1JLSzV1?=
 =?utf-8?B?aURUVWl2UVBBc2QybUhVTURCeFpjZ2tJZ3dYWlZSdDhndWR6c2w5aC84eHZu?=
 =?utf-8?B?VWZMVXJxbUpjdEVYREtiWnMyVGx6SkNUY2UyQUhqOGl4RS9xTkNraTdXa0lV?=
 =?utf-8?B?Z1hKVUlCR1RUb0k1NlJrUTRRUXI4TmloWTVyUkZMbFZIbzBFaUFuOTZ3a2JQ?=
 =?utf-8?B?a3Fxa2RGV0hmZThkOU5LUWlobzRMc3JVaDAwN0Y0WGpoUExRT3RSQUttVTBP?=
 =?utf-8?B?Zk9jWktUOEV0SmZCMjBjUGlWZkhIdzlnOXZkN1JsM0hnbWxYT2JoVkYyeFRS?=
 =?utf-8?B?eXltOWZwemtvZHp2Zll3THJQZGlaaFpjWHhoNVErT2YveEVJelJrWWtlWUFU?=
 =?utf-8?B?cDMxSzB2N1JHdVhFNlNlTG11QmFGMjFmTUdVSUVUUUNzSVpvbDdGWUMzbFIw?=
 =?utf-8?B?NVhHVms4QnhIbFd4aXZnNHpac0pqSE10eEY5a3lZcCtDN3oyOHRWWEswTGNL?=
 =?utf-8?B?LzNEY2tac1R0dXdUZDRJMmEyU3JpSTlaUEZvMy80eFlZTTdQT2ZTSGtHRVA1?=
 =?utf-8?B?SWxvcEZWRytVRXBOWEpTeTAyWG95SkRIUW1ueUx5dy8zRFdVa3hENDA4MTJk?=
 =?utf-8?B?dUxLWkRaQU1EYzBRU1dIenFTZVRidlYxU21VMVp2ZmR6T1dvTlQrTTEwZkVU?=
 =?utf-8?B?NEJIUVdaV0lFeFIvTHZTR2RtWE0zRHhWVzZ0TDlGcStNUTRsKzRhUFBXVFNT?=
 =?utf-8?B?cU0rTEN0REVZcnp2NGlCM2xJQ1pVcmMxbWZaK0p5Q3BJTTY2T2FmYlU0QzZS?=
 =?utf-8?B?RmpBU2ErUFVLalp2TXVPWjRiRk9sTUR2MEJ6WTJEb1NXeVVFRy9QRjRXU0k1?=
 =?utf-8?B?bXZZbDgwVWxrS0t3cHdqOXV4OHdpT29sOTZ3QkoybmFDcTl5amxPVWp3OWlF?=
 =?utf-8?B?Tnl1ZHBmdWViSDd2VXpsb0pGMTRmQ21iTFVOUjRHUDJKbkRnZHJHV0swTlVn?=
 =?utf-8?B?ekN5MDd1QjEyaDJ1MVh4Z0dDMFJNbVFUVVVudTJMOGl0TUJUcVdlYk5jWU43?=
 =?utf-8?B?QjMwTm1CY1NVRFdjd1dPOEJ0aEMxWGRvTmt4cVc5cXlETjBUMnBsMXFWTng0?=
 =?utf-8?B?a0VhZmt3R3JqRHQ4Snh2YS8xSG1RTUVEV1JVNWkwT2FBcGR6TUFCVWpSWjBo?=
 =?utf-8?Q?WOYLLo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MU80cDQ3OVYvOWtHL3pEYjJXVzFmTTJMWmgyTWdVY3pPcEpOdHQ2cEN1REFD?=
 =?utf-8?B?Vld3OUUydWZDY1lxaGI4Z3Q5TVlMWk1IZkFKY1ppQ2U4OFhFU0Z1dVN2eDhY?=
 =?utf-8?B?RDBZMGN0SzU4K2RFTndsaEcrQjVHTU42OE00bDc3NkVwTlVqaWg5Tk5VTzJP?=
 =?utf-8?B?WGJrQWx4bVB4NzA0Q0l4UlA0UXhVNnFTSzhSSHRCWko2K2NsTU1sS1dlVHU5?=
 =?utf-8?B?VGxJNTgzMGNnVmcySTJHRkhYSHczUEFyYTh5dlJ4RHl3S01WTjNoTWV2NUF3?=
 =?utf-8?B?dWU3ZUxwcnRGZ3RjVWFTWU4raEVUSThSSkxYcFdnMUlid1JxaVBzRFNvMTBY?=
 =?utf-8?B?Tlk1KzlzYUJqYlJYZEdlNXpTMjB1aU5xQlZqaDkxSEJuVFliU1V3NWg5dm4r?=
 =?utf-8?B?NmRVU3g0V2lJK01pVGhySTRkTVI5NEtpOTJLTUYyd2ZBTHo3QU5uYW1lb0JK?=
 =?utf-8?B?L2RqRGRvZTdOSWI4M2crYnZ2eWZVN1ZHZFUwOWFEem1DV3FjTHIvNFBQMFhX?=
 =?utf-8?B?WlVzSWhIYnhwdFN0dC9IbmZEVUJySFVuZ2RPeTRyV1Y2LzFmT3VqVUR5N1M0?=
 =?utf-8?B?b1NzbjRtMS9FTGs1dXRWN3U3ck5YVmRVcFZQSjZjSHNBK05VbzFNREUyY0Ev?=
 =?utf-8?B?MmxjazJ1aDllU0VZMS9Ocklab3BLYkxsWmROQTRSalBLeElQenJOd0sxSmpo?=
 =?utf-8?B?a2N0MmROZWFpZThaeS9SU1Y3M3Jyek04Q1J1NjFEbWFnUVd5eHd3TTZNRmtn?=
 =?utf-8?B?TUgzcmVGaDJ0T1ltZmxrT2JXVDZBZEVoV2R1UjQ1STJ2VFVBTnpXSmRxMVZW?=
 =?utf-8?B?dGh3Q0ZsMVJjSVlBOHRZUXNtVUlzR3BBOG5ERDBwb2hqenJOVWxzdmNFdUFm?=
 =?utf-8?B?dFJJMER6djhubmE5dk53SFRmRXR0QldjZUFOU0l3Z0ZRZ2ZhWDBCMDVyYzY4?=
 =?utf-8?B?QjhhZE1ueXcrb3JNbVo3SkpEYTI5TC82ZEpKSFFiMjVMblpJK3NSUUN5Z2E2?=
 =?utf-8?B?Q0VKNGJKQWE2M3pSS0ZiT1NHYTlUSGdRVDRxdXJNeG9PVVhIaEEvMVlqbXdT?=
 =?utf-8?B?QU10U2l1c0xLS2dlKzRZTnJsWjRVYnM0L0FyRFVmOXdMZEI0alMzamxlbG5D?=
 =?utf-8?B?d1lIQ2lMVXVTZnA3WDVZT3J5b3cwbTRpcHM2em1PSmgxMm9zZzZaWG8waHAy?=
 =?utf-8?B?V3E1Z09VcnkycjBFSGRESUVsWjZYOTFsYzJFNEdnb3dwWWc3dzkvTlVuR3hs?=
 =?utf-8?B?M2s1NEI2RmUzS1Q5Z3dLVGxOb1RDVWRvYzdFU0t5QUtLS01kYTdUL2NtVkZT?=
 =?utf-8?B?M1lMWmd3QzFTaHpnd3E5Wnc4OCswRE1NNUhobVU2NThsaE9FM1ZKZS93dGVE?=
 =?utf-8?B?V055MnllQUs5aExkenQ3eTdZTmY2UDNiTysxZmdNam00TGNGa2ROcGozamdL?=
 =?utf-8?B?TEI5WmdFK2lRNWVjUU1nSzhtNTcwazE1SFNhTTM5VnJYeklCZU0yK2xOZDVi?=
 =?utf-8?B?VDBxWUpRUzdlV2x2THpuNFI5R0EwY0plaC9rMW9xVXBTTXorUlhCSXBTNWpi?=
 =?utf-8?B?cERWczcrblh4NUpnUVowODg1a2NSVlhvcG5lRk1NWnQ2L2dsaW9jVU43aFNv?=
 =?utf-8?B?bjVDQTJsOStLc25XUFZXdzVhMnNxMmlDcVhzNGxjamZxemZnSER2L1QxaUpQ?=
 =?utf-8?B?eXVtWjArOXJYZGVkZ0s5cTRTb3JWRnA0SVZ2aFRieXpoM1c5KzlkY2c1aXEr?=
 =?utf-8?B?d2JCSUgrWjl4dmpjVEtGa25WMEVjUHVrdlRCQkRzT3ZqSzQva0lCYmNTSFhL?=
 =?utf-8?B?MjZMaE1ndVRLbWY3SU9pK3lxTkRBWFhBOVFaUWJVZjRVK0lVdzZZdEd2Y0pB?=
 =?utf-8?B?T2l0SnFCSG8wakZRWFZwN3FXWE1UVitQNHNQOXJabHRSbzBFdEpIeHNvSExH?=
 =?utf-8?B?WFAwY25sb3N1UHlXVTlPUW15SlVxOTloQUd6YXJxai83bk9XMlpJM0VWamNM?=
 =?utf-8?B?aFNsL1NSWUU5ZkNIT0NWaGZzempZd0N5Yy92V2c0WndKemtNT0pMUmRXNUhB?=
 =?utf-8?B?SDc4ejYvWFBDRjREQmMxTDdXZm1UWUdmVk1DMFRSMGorV21HaGFwaW82TUt5?=
 =?utf-8?B?cUhaV210RUlJZXIwQ2dyeHhpT0lMdlhJRDdsVUlGR1FDcVdxL0RON0s4SkVE?=
 =?utf-8?Q?slWi84HVEK6gwKQloqfqPajo8UyQiFPQJ56EeV+SsLn0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE0F92C50C175A479CC79683A9366E08@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: abbcade9-0b6e-4d33-4c05-08de30a2e78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 06:28:56.0501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: daG4C/3N+Eca7T+uasjnkCKHEYid/Kff7pBG6X2AR7PP3msVFx2zlHQh77FT2uF2Xnez2HHzfgEe7PIqSKstRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7169

SGkgQ2FybG9zIE1haW9saW5vLA0KDQpPbiAxMS8yNC8yNSAxNTo0OCwgQ2hhaXRhbnlhIEt1bGth
cm5pIHdyb3RlOg0KPiBfX2Jsa2Rldl9pc3N1ZV9kaXNjYXJkKCkgYWx3YXlzIHJldHVybnMgMCwg
bWFraW5nIGFsbCBlcnJvciBjaGVja2luZw0KPiBpbiBYRlMgZGlzY2FyZCBmdW5jdGlvbnMgZGVh
ZCBjb2RlLg0KPg0KPiBDaGFuZ2UgeGZzX2Rpc2NhcmRfZXh0ZW50cygpIHJldHVybiB0eXBlIHRv
IHZvaWQsIHJlbW92ZSBlcnJvciB2YXJpYWJsZSwNCj4gZXJyb3IgY2hlY2tpbmcsIGFuZCBlcnJv
ciBsb2dnaW5nIGZvciB0aGUgX19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpIGNhbGwNCj4gaW4gc2Ft
ZSBmdW5jdGlvbi4NCj4NCj4gVXBkYXRlIHhmc190cmltX3BlcmFnX2V4dGVudHMoKSBhbmQgeGZz
X3RyaW1fcnRncm91cF9leHRlbnRzKCkgdG8NCj4gaWdub3JlIHRoZSB4ZnNfZGlzY2FyZF9leHRl
bnRzKCkgcmV0dXJuIHZhbHVlIGFuZCBlcnJvciBjaGVja2luZw0KPiBjb2RlLg0KPg0KPiBVcGRh
dGUgeGZzX2Rpc2NhcmRfcnRkZXZfZXh0ZW50cygpIHRvIGlnbm9yZSBfX2Jsa2Rldl9pc3N1ZV9k
aXNjYXJkKCkNCj4gcmV0dXJuIHZhbHVlIGFuZCBlcnJvciBjaGVja2luZyBjb2RlLg0KPg0KPiBS
ZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5lcy50aHVtc2hpcm5Ad2RjLmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNrdWxrYXJuaWxpbnV4QGdtYWlsLmNvbT4N
Cj4gLS0tDQoNCkdlbnRsZSBwaW5nIG9uIHRoaXMuDQoNCi1jaw0KDQoNCg==
