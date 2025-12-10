Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC43A2EBB9E;
	Wed, 10 Dec 2025 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765401163; cv=fail; b=CsdetdCgd1ucgdJphFz57m1cQRwrfdrNfhj/VUbkDjP1+DkPy99Q3aWMQrUxDhCMNEgeFbvM+LoOd45dAx9NvwGCR/HOnqnQIjAErbrE9B5KEc3J7EgbFoFpM1tm4OwFm/pjrmD/O6BW0vkO8yVFpuvBWyHV+wcy0Ctz1cEcROI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765401163; c=relaxed/simple;
	bh=YWIEcaiDIFh0DcmgcmhhILLbI2G0rH0+WN4NELw/UjE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tp7uJVNg0cWipU12l+n27cU4oB8RPzy5YP6IuUogag77xUH3NxnQ5YmIo1RcWiVDyfdYWTTN7TuV6E/hrh84ZnzyzfUADZx7HKNN2L77yYa3wK6RboZIC4q6VR3MrUUq7J/ab2tPGDGViPVqdIsVXg0MPNtR66gDsdGkgq1SFmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H9xEFIum; arc=fail smtp.client-ip=40.107.208.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9xEFIum"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzYpdOgKESCDvyTtbmcWv9IryayviJp/pxWeXIeHWfdMKc9aFLP2uF2o/C3LJf/V2vGqgJPQJjAmHI1Ka2ryDChGdasgs6j1l2yG+YWiy+yc9oeRaI30jG2jTLjpYJhRvCgTLbIOZ4qBtrT8Fv9NFuJvXi/PbcxghXdyFfnDAm/TWNXnqVoWBZB9JyuKiYtSGE0lY3eMADaTjEjruJpEYVSQn7OT0JTmVo3XK/+08Kv0tNwJwf1MexPeK62bys1vaH0cnK5Ii0k2SKsxOvtNNthHU21tc9EgdqlDywpwwUynpBoP7TAhJMweE/7FDAAPABD1cjVVXGNSjj9tX+4Jwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWIEcaiDIFh0DcmgcmhhILLbI2G0rH0+WN4NELw/UjE=;
 b=GWORerfPaHK465llpHcvNJrYEr9xwPDRAuk+ag6bKuy+eCS7cvUfaTAyn8bxinQCsaiBd/L5MRC/32076emt68Kgbd1WU/vxl2nUmos5vaOSM03jGX9XehoOBSlyU9YnxRtOsyNz4gPOcpiyDtcTrb4zg+tIVsxOlDNN4qlPXsmt9ErotJPoRFtcmFLbnqBOSqcYo92fa04dFIfC6mtiH8rlFcQMNedVxRHR0ByAjWI2ZIcKSEwi0qBJNY2iD0cS1VlHY9+6fbEnJHd9MyPntTygxJo41ybXg270Xs4OXMIjwGmUfaLQvPRTyAtvKdhSLCgkK7yKyqSdUlTSDXlF4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWIEcaiDIFh0DcmgcmhhILLbI2G0rH0+WN4NELw/UjE=;
 b=H9xEFIumgdDaU4Shn2hMucoSYoNCYIY5ywKreQePLOsAEEZe6o4vwxlBy5H2J4xyy1bRaSB1TZ2Je0r82l54Jy8Gs6yyyp/tpbmWCyEWyjzQgfeZUuFD5JTgD9iQENs14Fs3iwd1n6cJUosjTDxmjLx+y0W8rxgbWOoTdtWY8vC+hnmFKWZUPvlkAZKbu6LQdyGXrLPsjuHI5baR9OYt78c6mPW7SZmtLDSz25VP4x6PwLX6u5/88iTIuLpcNbYN1Gaaha8wXgUdp6eWHQcu6fy9LEJFrzN+vm2tTz0w+ZWOgn/508xB7UFkUsm0G2yARDtBCASKp24WLxUzKBjIZg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by PH0PR12MB8149.namprd12.prod.outlook.com (2603:10b6:510:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 21:12:38 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 21:12:38 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Sebastian Ott <sebott@redhat.com>
CC: Keith Busch <kbusch@kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Robin Murphy <robin.murphy@arm.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Jens Axboe
	<axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Will Deacon
	<will@kernel.org>, Carlos Maiolino <cem@kernel.org>, Leon Romanovsky
	<leon@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Topic: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Index:
 AQHcaQFVH3CUuaIhmEu/T0GQ8kjfQrUZMfcAgACbGYCAAFrrgIAAGoGAgAAPIQCAAMyTAIAAQzkA
Date: Wed, 10 Dec 2025 21:12:38 +0000
Message-ID: <e0bb4d89-e3e3-45b8-8818-edca8df57d0f@nvidia.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
 <99e12a04-d23f-f9e7-b02e-770e0012a794@redhat.com>
 <30ae8fc4-94ff-4467-835e-28b4a4dfcd8f@nvidia.com>
 <aTjxleV96jE3PIBh@kbusch-mbp>
 <2fcc9d30-42e8-4382-bbbc-a3f66016f368@nvidia.com>
 <0eec3806-c002-54d5-95a9-7fa201c6b921@redhat.com>
In-Reply-To: <0eec3806-c002-54d5-95a9-7fa201c6b921@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|PH0PR12MB8149:EE_
x-ms-office365-filtering-correlation-id: 5e01632f-d3b9-4b10-69f5-08de3830d947
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SGcwOEpmVGVmZjNMM2F6L3pRL0NlYlEyYjY1R09KQXlMUGxXMzR6bFdjN2c3?=
 =?utf-8?B?STBtNGZwY3hoUStxTTNvWXVFZks1L0VXTlQ3WUI1d0RDWGhTOWxZaWVKdEY0?=
 =?utf-8?B?VHl4NGlHRTJrR0xSRWpBc0MrK09GV0p1ZE4ycktpWWxROTdKTzg1Snl0VGxj?=
 =?utf-8?B?Z0NFWkRlY2g1QW80TEVNc3p4NUZJbUlJdlZxMGh5ZDd6ZFpxUU4zSWRUdUEy?=
 =?utf-8?B?bzBVRmE3N3B4VUpBaGVzTkVHeWxGUWF5czZSVXhoSHh4M3ZPTlpDOHplNytN?=
 =?utf-8?B?OVhFRG9BUnk5bTJBeDBHQlVEVVRPSC9oUzlpVnQvWkFBSU15MTV2UDVadUF0?=
 =?utf-8?B?WnJ3aEVRcEVRSU1kRjd0VzZjaEI3QUhUeWdpMmxYbWNOSU5Fbm5QaXBOMVlQ?=
 =?utf-8?B?Kys4c3RJazY2KzRMOEg1d2NlZmZqTFVSM0JpT1RJNW9YSHUrVGcweHRtbVhU?=
 =?utf-8?B?MTAvanp1VHc2c3ZEN3QzTmRrdHorTHRMMU5TaTNUU3FrYkFnN09vUWQyQ0c0?=
 =?utf-8?B?eE5EMGQwWC8zaDRqbTF3MHJwb1d6cGk0bHhCS2UxZEIxaXV0dTVPbkZnQ1hC?=
 =?utf-8?B?NHErTkNqV0hlMURkYVdvOHo1dE5vNVQ1Yy9YbGJ4allFbVpQQXI0eVNVbitD?=
 =?utf-8?B?UjVwSmZzdE5ZSURGeXhDYU1QUUxBTVhnNDZWVVlQcEJsTk51VHl6K3lyWWd4?=
 =?utf-8?B?NHhaQzdpV2E4SXBoaExNbEdJK0dlU29pS1lOMnB4UVBsQlFIZ3Jya241bkE2?=
 =?utf-8?B?WTZJWlhzT1VublM3Vm9FL3g4WUI2M0JJRjAwTG9QM1d5bURLSVVwY3U4NEI1?=
 =?utf-8?B?QVB2Um96RzJZK2lIYmFJS1ZyZVNQdWd5V2FCWW9EeTJ6bWtUWmxPVnZwejh6?=
 =?utf-8?B?RzBLRXdocWN1YmVyZlZ4emNtUlpTWDRsWklJRUN0RlJIUU9RTTcyZkY2QWNu?=
 =?utf-8?B?OU9FcDJCTDBCRGFEdlJ2SW5hVVROYkpZYUE4UXRhMnhrZWMrY2hNeW5Ka0to?=
 =?utf-8?B?alRVN25PS0FLRXJpT0FKVXM3ZmQxZHZjRlp3clBaL2loSUpKNFh2bGpIdHdl?=
 =?utf-8?B?MXlUeFZ0L0pic0ZLZmxkMEdRVnR6Mm91RStZdVNmUERzeHdNZVNUeGpiZytI?=
 =?utf-8?B?aVcxeFhsOGFGbm5aRDBGYVlEZlY5ZHM1Y2xrbUxLVzA5emVQb1VZVWk1L2d2?=
 =?utf-8?B?NERrRnVwUEpOdURRalduNFdnWVFLbDBCQ3NNY1E0cEQvZEptazVZUFhMWUpU?=
 =?utf-8?B?Szl6d2pXZzNmOUxDVnhPcEpqTDNsL1pCSWNLbmtGUkdMRlRDT0VTUTdBd0dl?=
 =?utf-8?B?NUtGaWJLd1RWNXpETkF2OGhFYkZIYUtIMXIrclQvbFdQeEphOGdqenFBejVu?=
 =?utf-8?B?R3c1dTJpL3RiaXpnR1I2aGpHMjQwZkxSa1l1VFpqdVAxTlhrYlhhM0NLd0lV?=
 =?utf-8?B?RmpQTGpiaGt1bExDaHc5STRZK0tDQWNCQUJLOC9DWkZsT0dYWE9DdkxGNGxr?=
 =?utf-8?B?eCs3K240SWlMb1E5NXAxTDdVaEJDazM3NWI1VHQ0bTFLRUpJeW9rRXVibUNT?=
 =?utf-8?B?d2FBNzRSUmh5U3hNUEJDZGcvVjAvZ2ltQUJCenh3VHQ1My80VndBdWdudEhj?=
 =?utf-8?B?NzFPMHJOUXliV3FaT1VGb0JyclNsMHkrNldJQm5oN2V2ZzRJeHpjL3loNTA4?=
 =?utf-8?B?U0JHcGZlb1BobkdVaG1IOVBENHd6T2dtUWFIRkp2Rm1zVVhPa3hoOHBRbjdG?=
 =?utf-8?B?WFU3RkRHaC9hK3cvNHZzS2dITDhWSW1odTVzTjJ0OGtzQUlFTlF5MlZjZHJw?=
 =?utf-8?B?ckNYOFhjSVgrR1kwanNXUm1GM2xycUxwbFM3b2ZyZ3B3WDRVbHBiS1Ryekxp?=
 =?utf-8?B?aDB6NG5VZitETjltdE1yQzhaem5sZmR5Qks4WEh3eGJvOXdaTit1MlhUa1hK?=
 =?utf-8?B?VlNQR2R0WnB4RVBVcEJxaERSdTRVMXJhcmU5S2NKVlcxU3JSYTM1YzVxV0Qw?=
 =?utf-8?B?Q3BDQWdxOFF2LzJjaURaaGVXUVIvMGtaUXFWdEFPdGpPbFk4Q3dGSFM0dG54?=
 =?utf-8?Q?tI1V5m?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QkNMZFpDYlNJK0QrL0J1bUpaOG84WEN6RXU4TElKb3VDaVVGMnB5aks5a0RF?=
 =?utf-8?B?cDZMbGp5QUFCaC9NTUpFVk1kdytlR2xlaG9nMVBHQWh2Rit2SnMxOHM3ckZS?=
 =?utf-8?B?bzdkVllTZ29WbzhqWVl6TWFOQ3QwTGhxVUI1RklkMFVpSFJ5SDdiNGRCTWE4?=
 =?utf-8?B?QTZBQ2xvcEo0eW1qemU0U2I0UFVjQW9PellBbHkrdGRBT3dtU0kxdG9weDBq?=
 =?utf-8?B?Slh4UDRVWndscWljUGZPZmFGbU0vNjIvbzEzSnM4UlFueUJHUHVCcjNRYU9T?=
 =?utf-8?B?c1VKcFZpVEFGTjMyRytsaHhTTmJiNGdVdlhBYXkzcE9CMEFJZUFMTmZDaGVS?=
 =?utf-8?B?aFdRRVNGU011SGgzY2YxTEJjbllBSTV1cjBwN2pmNXYrNCtSTTlsa2JuZjJt?=
 =?utf-8?B?UHF5M1lEKzAvRmtXM0VSYW1MU0Fkbkt2R2pEK0JTekFxZSs2L0NNeXlpU3J1?=
 =?utf-8?B?WlFKQUdNU2VicmhrME54WVNkWVMxdjRjS0FKdW56WUxkbnRHWWNjQWRKWlps?=
 =?utf-8?B?bk9WaVhvWTNoNGxEV3lzbzNkM21HcStONVlmQ2pWbXNyYWQyNHBReksxQjlF?=
 =?utf-8?B?c2pEUnd3dE5kQmlOOC9JSVRlMjhtUUx2UHJ3TVZ6SGhUZ1ljQThMVXBrZG9a?=
 =?utf-8?B?U0xtMnN4b3grYXJ1VjdLNDd5NHJBQ1lIbCtRYXgrc3YzeFB0WE44YUZFSzVZ?=
 =?utf-8?B?V1RXTWJjcXBTWVIvR1pRR3hLMXplYTVpNnVZb1g2OHRONVN6MXk5bzNZaGxz?=
 =?utf-8?B?T3MxeDVDYk5KTEQvL2FIYVRXYTkxa0NkUHRPZ0d4cVdRUENpeEFuV0l6VVhD?=
 =?utf-8?B?WFNWekRWanVrUUc1ZmpGb0RqVEF0V0NKWmNteldiU201N0dadGhSQkE0Szc2?=
 =?utf-8?B?aHgzQ0FUNjBlK0ljeDZhdTVTeEFlZUxrcUhFWjNKellsaHpaRDJwcE9mc3F3?=
 =?utf-8?B?aVFINXozRXhJamhSWEQwQWg4S09TRkR5SHVTMi95MGxqM25Ld0xTM3kzdUpz?=
 =?utf-8?B?QmFiOGdwdW42djVrVFEwY0ZnNTE1bGxaVkgxeDdrNGFtaG1iU0QxSmRiVXlF?=
 =?utf-8?B?d1F5ZG5ham5aTFBESjJNVzc4RzBQaHpuQnZoNjFqdEVhVjhTYnJHQld4WUFz?=
 =?utf-8?B?Q0xvVVB3MkpwU0ZNWUVDcldqTkcyaHlQekI3VHl6OGJKYmdkZVNoLzVVRGFl?=
 =?utf-8?B?WDMyMW9aaWVKSjBBSHF0cVQ4eDc1cS9ENDN4bG5Sd0pMVUNiZlRaV3dDK1ky?=
 =?utf-8?B?SVlaYjUxVkp6ekVxY0x6M2lUVnAvSjU4cFlIbFQybHVOa1AvQ2srUjdNZUNP?=
 =?utf-8?B?MGl0WFFVQ3habUFTVWFZc0lQeG5BT1dFMjZ2V0JMR1NPVy8rWnRkSFdqb2or?=
 =?utf-8?B?VjVrMnVkNlVXWG84TEVrN083UFFHU1gzcDVvYmdLTFFsWGkyOFE3VUZiTlAw?=
 =?utf-8?B?b0dCZXJ1Q29aVjNXTjE3MVc3WU1saGxvOG53TmFVakVtemFnL1VvNkRnSnB4?=
 =?utf-8?B?MG9QZWZYK2I0aXJ6RGUxVC9wTU9iOFpFcmNVb1dOb25idE1BQ2JieGhhWnFp?=
 =?utf-8?B?MSsveGUzak13V3N6dlRseEFlZG9uMlpOZDhhS1JYUU8vbmgwT1cvN1BVMTZB?=
 =?utf-8?B?djZzTFAzbkdMWU9qdGJCRVRxeXlHaHlIKzYvREpXUS9BNFl6dUhyeUt0bHhC?=
 =?utf-8?B?ekZnaXdvbjhzSXRSZk9IbE1BSmNRVFZuV01IcjgycFk5Ni9nS00vYitJMWVk?=
 =?utf-8?B?K0w5WGVoTlplVkpoNGV1VUZnRHNmVmZZNmRtbk0zQzhjTTYxUnFQbEh0TURm?=
 =?utf-8?B?eEpZN2ROMVR0Ny8wR3ZZVDg1Q3dsQkxrazVXMVRuYmRGdlRmRS93cnY1OEUx?=
 =?utf-8?B?SEw0TUVsVWVkYzc5SjNrb1JUeEpsbmJRemx3Z0Y0SFNJL0N3aFp6K1hZWVBU?=
 =?utf-8?B?ZnBFdFkyVTNUbkpWcXI3RzY4bmxUc2RrZ2FTU1N5dVdQME5FY1BybzlQZGpw?=
 =?utf-8?B?OXFLMUs3OGZWN0g0TFkzRE13YUdUYithOGU2djNwNEdFbTJ5R1pYRFp5MFJn?=
 =?utf-8?B?Y09rdklCTnFBK0pLS0luK3lIczhWNmZGWjBxQWpSdHlJaXM2NFhSMkFrV3pJ?=
 =?utf-8?B?K2NLaFJJZXdDeHlXTzZMMVBNRTg3YldMOWJ5S3NiRU5JQXViNWRBbThiSU5O?=
 =?utf-8?Q?nw6dtIl1eOBHotmh3JIsGMxqYstMNmMmpiHeW0gHo9vo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F3D25673DE5D2409D3C972633CFB41E@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e01632f-d3b9-4b10-69f5-08de3830d947
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 21:12:38.7783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NLVUghOm6S/o0/7iTyuEg14WwpweWzbYczZS9vNW1o8kMQGOoqbHSGce1q3BiLRXfR3hwFkvkGZZ/WsURWIUpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8149

T24gMTIvMTAvMjUgMDk6MTIsIFNlYmFzdGlhbiBPdHQgd3JvdGU6DQo+IE9uIFdlZCwgMTAgRGVj
IDIwMjUsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToNCj4+ICgrIExlb24gUm9tYW5vdnNreSkN
Cj4+DQo+PiBPbiAxMi85LzI1IDIwOjA1LCBLZWl0aCBCdXNjaCB3cm90ZToNCj4+PiBPbiBXZWQs
IERlYyAxMCwgMjAyNSBhdCAwMjozMDo1MEFNICswMDAwLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3Jv
dGU6DQo+Pj4+IEBAIC0xMjYsMTcgKzEyNiwyNiBAQCBzdGF0aWMgYm9vbCBibGtfcnFfZG1hX21h
cF9pb3ZhKHN0cnVjdCANCj4+Pj4gcmVxdWVzdCAqcmVxLCBzdHJ1Y3QgZGV2aWNlICpkbWFfZGV2
LA0KPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlcnJvciA9IGRtYV9pb3ZhX2xpbmsoZG1hX2Rl
diwgc3RhdGUsIHZlYy0+cGFkZHIsIG1hcHBlZCwNCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHZlYy0+bGVuLCBkaXIsIGF0dHJzKTsNCj4+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKGVycm9yKQ0KPj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsN
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfdW5saW5rOw0KPj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBtYXBwZWQgKz0gdmVjLT5sZW47DQo+Pj4+IMKgwqDCoMKgwqDCoCB9
IHdoaWxlIChibGtfbWFwX2l0ZXJfbmV4dChyZXEsICZpdGVyLT5pdGVyLCB2ZWMpKTsNCj4+Pj4N
Cj4+Pj4gwqDCoMKgwqDCoMKgIGVycm9yID0gZG1hX2lvdmFfc3luYyhkbWFfZGV2LCBzdGF0ZSwg
MCwgbWFwcGVkKTsNCj4+Pj4gLcKgwqDCoCBpZiAoZXJyb3IpIHsNCj4+Pj4gLcKgwqDCoMKgwqDC
oMKgIGl0ZXItPnN0YXR1cyA9IGVycm5vX3RvX2Jsa19zdGF0dXMoZXJyb3IpOw0KPj4+PiAtwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOw0KPj4+PiAtwqDCoMKgIH0NCj4+Pj4gK8KgwqDCoCBp
ZiAoZXJyb3IpDQo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dF91bmxpbms7DQo+Pj4+DQo+
Pj4+IMKgwqDCoMKgwqDCoCByZXR1cm4gdHJ1ZTsNCj4+Pj4gKw0KPj4+PiArb3V0X3VubGluazoN
Cj4+Pj4gK8KgwqDCoCAvKg0KPj4+PiArwqDCoMKgwqAgKiBVbmxpbmsgYW55IHBhcnRpYWwgbWFw
cGluZyB0byBhdm9pZCB1bm1hcCBtaXNtYXRjaCBsYXRlci4NCj4+Pj4gK8KgwqDCoMKgICogSWYg
d2UgbWFwcGVkIHNvbWUgYnl0ZXMgYnV0IG5vdCBhbGwsIHdlIG11c3QgY2xlYW4gdXAgbm93DQo+
Pj4+ICvCoMKgwqDCoCAqIHRvIHByZXZlbnQgYXR0ZW1wdGluZyB0byB1bm1hcCBtb3JlIHRoYW4g
d2FzIGFjdHVhbGx5IG1hcHBlZC4NCj4+Pj4gK8KgwqDCoMKgICovDQo+Pj4+ICvCoMKgwqAgaWYg
KG1hcHBlZCkNCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGRtYV9pb3ZhX3VubGluayhkbWFfZGV2LCBz
dGF0ZSwgMCwgbWFwcGVkLCBkaXIsIGF0dHJzKTsNCj4+Pj4gK8KgwqDCoCBpdGVyLT5zdGF0dXMg
PSBlcnJub190b19ibGtfc3RhdHVzKGVycm9yKTsNCj4+Pj4gK8KgwqDCoCByZXR1cm4gZmFsc2U7
DQo+Pj4+IMKgwqAgfQ0KPj4+IEl0IGRvZXMgbG9vayBsaWtlIGEgYnVnIHRvIGNvbnRpbnVlIG9u
IHdoZW4gZG1hX2lvdmFfbGluaygpIGZhaWxzIGFzIA0KPj4+IHRoZQ0KPj4+IGNhbGxlciB0aGlu
a3MgdGhlIGVudGlyZSBtYXBwaW5nIHdhcyBzdWNjZXNzZnVsLCBidXQgSSB0aGluayB5b3UgYWxz
bw0KPj4+IG5lZWQgdG8gY2FsbCBkbWFfaW92YV9mcmVlKCkgdG8gdW5kbyB0aGUgZWFybGllciBk
bWFfaW92YV90cnlfYWxsb2MoKSwNCj4+PiBvdGhlcndpc2UgaW92YSBzcGFjZSBpcyBsZWFrZWQu
DQo+Pg0KPj4gVGhhbmtzIGZvciBjYXRjaGluZyB0aGF0LCBzZWUgdXBkYXRlZCB2ZXJzaW9uIG9m
IHRoaXMgcGF0Y2ggWzFdLg0KPj4NCj4+PiBJJ20gYSBiaXQgZG91YnRmdWwgdGhpcyBlcnJvciBj
b25kaXRpb24gd2FzIGhpdCB0aG91Z2g6IHRoaXMgc2VxdWVuY2UNCj4+PiBpcyBsYXJnZWx5IHRo
ZSBzYW1lIGFzIGl0IHdhcyBpbiB2Ni4xOCBiZWZvcmUgdGhlIHJlZ3Jlc3Npb24uIFRoZSBvbmx5
DQo+Pj4gZGlmZmVyZW5jZSBzaW5jZSB0aGVuIHNob3VsZCBqdXN0IGJlIGZvciBoYW5kbGluZyBQ
MlAgRE1BIGFjcm9zcyBhIGhvc3QNCj4+PiBicmlkZ2UsIHdoaWNoIEkgZG9uJ3QgdGhpbmsgYXBw
bGllcyB0byB0aGUgcmVwb3J0ZWQgYnVnIHNpbmNlIHRoYXQncyBhDQo+Pj4gcHJldHR5IHVudXN1
YWwgdGhpbmcgdG8gZG8uDQo+Pg0KPj4gVGhhdCdzIHdoeSBJJ3ZlIGFza2VkIHJlcG9ydGVyIHRv
IHRlc3QgaXQuDQo+Pg0KPj4gRWl0aGVyIHdheSwgSU1PIGJvdGggb2YgdGhlIHBhdGNoZXMgYXJl
IHN0aWxsIG5lZWRlZC4NCj4+DQo+DQo+IFRoZSBwYXRjaCBLZWl0aCBwb3N0ZWQgZml4ZXMgdGhl
IGlzc3VlIGZvciBtZS4gU2hvdWxkIEkgZG8gYW5vdGhlciBydW4NCj4gd2l0aCBvbmx5IHRoZXNl
IDIgYXBwbGllZD8NCj4NCm5vIG5lZWQgZm9yIGFub3RoZXIgcnVuLCB0aGVzZSBmaXhlcyBhcmUg
bmVlZGVkIGFueXdheXMuDQoNCkknbGwgc2VuZCBmb3JtYWwgcGF0Y2hlcyBmb3IgdGhlc2UuDQoN
ClRoYW5rcyBmb3IgcmVwb3J0aW5nIHRoaXMuDQoNCi1jaw0KDQoNCg==
