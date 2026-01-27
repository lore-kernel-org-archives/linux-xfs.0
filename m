Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1767A2566D3;
	Tue, 27 Jan 2026 22:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769553663; cv=fail; b=YAk6fuBepTDedSt8DPuFSJwIol8hsdfmP2Fe/deITDTNLTIQ1v6/oeoWL8sbLOaVowJnzqvYGsRS2ykW3K3MLx9X3VA9zlEEQrHTrLhXMThoe55Hblxt0GHvrN/xApJZK2zH2fSaqt3oW2A9s/rCMYWO9wIfJBxRC7+0QMWx8yI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769553663; c=relaxed/simple;
	bh=ayo3ki25oRkTCIe4bxy1YMh65n692UQotlweYc512sI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kzNJCbl3REahhv9ssZ2oQr9wppZAtpIjbHU3hyBsxDQWg0xdb5qpbRZxmgkxqksMycTTvVizsTMBoAHolJyTfG3jPD3GuBRnI0tXt58YBwwynPb1dVeUwV8OK0Xf/iBPq4l84eOE/dKa26CZpL4OsJb7HnjnxLXBbkrY164CF3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FuS1I1tc; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FuS1I1tc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrJe5y/YqmCyIZMkMowyQnfrZudNiapZOfQ2+ZBRxC6W2Ne5yag2WJbknY55Rlv399kRGgDMNUWBQ3NbzjdaYoynD2CBDJM8Xdd4Vt1Flg2PhzXo1sr5Xz1+x6RwzuZo6IZpK2PGuxHEjxHkQ8p5vH5BLeCJ9l0T5tagaefqhESFLZgLKkYYEZFr3DuOtkay6LSOT66K+QCo84/VAcv6SVAH0wABVJyUYiS5nHq2uf6+o07PPt7nsyJIKRkPzPe7sGN6BdZv3qnyjy2zZkV6ghtykTwLzyEdR6IPQ0ifd59LHEhQ/ykxM2Lb7COrq/CzAljdfWLxB3VljtFDYXZiSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayo3ki25oRkTCIe4bxy1YMh65n692UQotlweYc512sI=;
 b=CurqA+zMPThA1GqsDpzgC86+n1kRCEPNxr6Kiekt2KPSmP/OxePpUKkPUo1Zn4rSBNv2OQS4oNMphfj9XSl/rmrHLEnuHJJLOsmFB9ilWMuO56d7JPKN6bIZl/ofKZKB+ZiEdEcfg/SEXuuwGg9gWeUQqwGiC63e646p9FL3luVkn3iBx3lwTQwbZA1/JCjaUkonk4IdF+vlcRNO6Kwm0tl/oybnm0MHDa8GVIzEcunHeurJzVrjNDwRYJdoplYw0s4QtY+d1Q//gQWRos5Mpx2nYmvhCz7U3th/pkF4Ey0W/3at4QvLh9rO59IqZp/yoRtvVv5446Dw8gd7e7CfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayo3ki25oRkTCIe4bxy1YMh65n692UQotlweYc512sI=;
 b=FuS1I1tc8Ei0bnWaVBEiH7hWztzgQqR56FS5vQQ7WIR4MTqxNQePqLWQX/T4mrb4IywhTGmzfnQmPd3SNgfoTsa1BeHruZQVeFBTe+Wp/keH7MWTFXal9jztBz5q07kbskEw/8knvGeoo6SN9SyhgtbxZtQESlt/8IfuVw/QAJFBq+cHmzBo2UTDdL6VqUFf4xWWuqj+3jFGNHQ+8aPpFstYH3Eyc+QkUXnLxJO2+y1bbT23ciLzT+Th1MbSkYVNRtL1BvGIUTDER/M9iSffzA3EDP9rKj/+kj160LO1Om0d/hc8XeBwArjdnRkR+nR62KDOfGE45ydJ8Mo5R20+Eg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CH3PR12MB8879.namprd12.prod.outlook.com (2603:10b6:610:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 22:40:59 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 22:40:59 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: "hch@lst.de" <hch@lst.de>
CC: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org"
	<snitzer@kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>,
	"song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>, "jaegeuk@kernel.org"
	<jaegeuk@kernel.org>, "chao@kernel.org" <chao@kernel.org>, "cem@kernel.org"
	<cem@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn
	<johannes.thumshirn@wdc.com>
Subject: Re: [PATCH V3 4/6] nvmet: ignore discard return value
Thread-Topic: [PATCH V3 4/6] nvmet: ignore discard return value
Thread-Index: AQHcXZzXDfTSuV3W4kihFfciFgwCxLViN28AgAIN0wCAArt3gA==
Date: Tue, 27 Jan 2026 22:40:59 +0000
Message-ID: <5bbe8ca5-8689-4c1c-a601-4704770850e0@nvidia.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-5-ckulkarnilinux@gmail.com>
 <942ad29c-cff3-458f-b175-0111de821970@nvidia.com>
 <20260126045716.GA31683@lst.de>
In-Reply-To: <20260126045716.GA31683@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CH3PR12MB8879:EE_
x-ms-office365-filtering-correlation-id: 7e8ef64d-8340-40af-dbc6-08de5df52480
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?M2MwVTBkeDBUdTMvVXFHLzJES1piM0Z0RHU4Q1BCcHhhYVcwNmtpeG5randn?=
 =?utf-8?B?MGQ5MUxCR1NaVlJJU3MvcVF1VjA1MDdmaWs0b0JSeDB0dHlTODhtKy8wRU51?=
 =?utf-8?B?c1lIQXVhNE43WkFyVlMya1RIeHR6VkxWYkVPck9ETm44ZmNvRmJqZWN6WWhq?=
 =?utf-8?B?eGE2Sk5vVzQrSVlGMHh5bXZ0cEtkQStEVzZOWVFIM0pMREFFWGg3T2lHdjl4?=
 =?utf-8?B?UGRaNERZQ1hIMkdTYTRaRVk3bVlYMmRRZHl4c3RjdGV4cmgvTExxeTJqQUxL?=
 =?utf-8?B?YzZ1b2RqaFJWY3JzTUh6V2c1OUNZdkNNVGh5QmVYYnl4QmgvL1QvdlE2di9r?=
 =?utf-8?B?Wnp1NkVwZUNmMi9qckVlbFdqRlo1VnZ0WFpMdTF6ZklQVS9mREpqMHUvYmVr?=
 =?utf-8?B?dlVsNTIzWEVHR0FFU0o3YmhEaDhqM1U2R3Vkc285Q1Y4RXAwbHVpMi9LYzBy?=
 =?utf-8?B?cGRLN3FYNDFIUUtUQ2JhTDd0R3FkOWIvQm5FVU5BcGxyUlZXcGlwKzFzdjV3?=
 =?utf-8?B?SFFlODNzNXhXVHlrT29XWE10ODlVaFRad0Z6NENxVlIyMHNtVmVMckxjeTRB?=
 =?utf-8?B?NHk2T0RxcHpsVUs2Ly9Yd1A0bEhLMXVpMjY0U1ZPdHM4bXZOMTJHekZaTERi?=
 =?utf-8?B?QUpPVWszdmdFLzN6R1ZvNm9WWThHalNXRlhKeXhEMzlreGJwaHBoVVBqd3dN?=
 =?utf-8?B?czJZRkg2b0gxOUp3Vmd2dzNtbTk2SEJmWXhsQm81WnpxcXdMRnJhcnVVdzha?=
 =?utf-8?B?ZEs3VTFkMTA2THpOM0hZdVBOYUV5TW92UUVvaVhnMnBkREFJRWIwWHIrTkZv?=
 =?utf-8?B?cDNDcDJ6QUloRllyN2ZTSnc4SGtTei93TllhZVR6YW1hWlJ3TGJPaUZ3L2Np?=
 =?utf-8?B?Ymg3WklmaGljQ0xGV0VhUUhkbHJEem5LaDFpRWZ3anUxMzNhdGtIa0wwejdC?=
 =?utf-8?B?WjVCbXFZR080ZzZGaGcwOHRCenpmS3hDZFRtaVRlZ3JDdFRZVkFzM2RFcCt2?=
 =?utf-8?B?eXQwL0N1NzlMRmpSUXo1TS9ER0k5Qy91K1k0OEc5RnZCMzRKSU1jbVdqUG5u?=
 =?utf-8?B?UlNkb1FTYWIxQ0EvRExrSlJBQ1EvNENIOTFHQ2tiZ0VlTlJwWVZ4U0ZnMmVL?=
 =?utf-8?B?T3hpaWdLS0poQzduWjNTUExQbCtzb29WZWpITkZ6MDRCcjRvS0FpMUZod2Qw?=
 =?utf-8?B?RGxwMGFQWTFua3pENk9laUphdndXVVhqbDFlL2g3YXhBSUlWbHBnOGgxelAy?=
 =?utf-8?B?OUtzT3dEZ01QakN4ell6TVlyc1pUbnJ0d1AvenJPajBNdzd1TUIyd3dubUkz?=
 =?utf-8?B?ZUdCMHFMRFc5cFBhNkVqOU1PZ2FzTnZiaFJFSHE1bCsydmtoMDRlVWFtam5T?=
 =?utf-8?B?WkV0d0VNeU91SUtZN2RySTZiRzZvNDZtWVllV2VXSG1OcG1MdElkNGdzVVFp?=
 =?utf-8?B?a0ZHWUNKbDFLcG1hV2pRK1l3OWxWaVhsU3dOT1doYlUzZlJvbWprYUxUM2VT?=
 =?utf-8?B?N2hiYTJBVzd0R2lyZG9yUkFqa3NFUnQyb080bVNwL0d2TVlOY1FzVG9uN0d4?=
 =?utf-8?B?cEhkazJJamlHdjEweCtBUHVhRXhLZkFjTHZFRFdsVWoxODNXeWo3YmlndXhE?=
 =?utf-8?B?UW5MNEV6SENHTUFQdEdnNTJwdmYyR3ZvMmhkaS9ZUHdlSjJNbnBHdm85L1Bx?=
 =?utf-8?B?UWIva0FrZDdKcy9QSjZLOFFqcCsxTWhmd3JHdlZ2MW9rTHQ0SnYwUGtnMCtv?=
 =?utf-8?B?YlQremk1NWgrOGJMbi9Sb1R4UWQ2MnBWZDJoZGFFODZMZHZLTjNVYVhscEYr?=
 =?utf-8?B?emJwTG45TWdsT0NRSVFkZG1jTkdDb2ZpaDMrcmtiZHZEU051T0YwdXJWUGxr?=
 =?utf-8?B?UTdoVTd5RHN5dFVqVDUwR0lOeURQVU5McmF6QVBMb1NNRzNqbm1ZbEhzUXAr?=
 =?utf-8?B?MG96Y2NRTFBWaVVxODlyR0IxMTdsVGVHb0RwelJQTzBHM3Z0THJWamRTT0FP?=
 =?utf-8?B?Y3F1R3FKN2hMRnNSZTgrVUZJWk1mMC9XSEhHT29Wc2EwL2cyRWExdmF3MjMw?=
 =?utf-8?B?SmJ4SDdpMkl6Qm1rVjRYWkd0MU9GRWV1dTUxNFlqVGZTUy92Y0xZZVMxUWwv?=
 =?utf-8?B?R2xSUk5nenM0SW5XL2ZHa0xEUkQyM1JYSWhzTnFHTmowcmQvMmxYTUhRbE1R?=
 =?utf-8?Q?vwVfXP1muawfoxEaI4oXX9w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bERZU1JCR0R3aEFaS1ZrZTVDSStVRWFheUl2U3JxUnZ6OUhTL0x0VjMzcHFj?=
 =?utf-8?B?SXcwb1dnRWpXVXUxbzdTaTFIcDF1MzJZcnl4QzRoRDkwa3d6aHI5NlFBRlg3?=
 =?utf-8?B?L20vVXRYbEpCMzFOUmVSWUZOaktoeWw0bTF1TWtpUjVneU1WalUwR1h3ZXUz?=
 =?utf-8?B?YTAxVmJDa0FNSTJkc25EY0lGUXkvZysvU3d5VzV4V0xVWStFdkE5dmVBOHB0?=
 =?utf-8?B?LzFSNkNhUHlablg4N0NRTGxHaWxMUlg2R2JSL3FOd0E3WFNtTWlIejBzY3B6?=
 =?utf-8?B?V1NFekhvR1pWaUIrYUhvbDc0Q0ovSzg5b0d0azNXb1Q5RmxLdTU3NS9jakZH?=
 =?utf-8?B?S29HMm9ZdnVYcDVNRFFwVnE0cmlvazNQalZrOTgrWXR1SmdtR2FzbWZNdGtW?=
 =?utf-8?B?Tjk4Y2l6KzdtQkJKaG9rZ3ZQQkFKN3A3OTl3VURMdEkxS2V3SFJsMVBnUmw2?=
 =?utf-8?B?b0lmcmF1eTl2enVQU2M4UWd6b0RxSnJIVnpwenB1Q3d3WUJBaFdwaVhjUHBC?=
 =?utf-8?B?eDk0VXVBNWxoOEdXdTlPZERieW4zSURyTWxTbGo4RERNS0VjYjlhbVl0N0Nq?=
 =?utf-8?B?cGN3emJOcFJ4MzVzZ3p4MkZLNndHWWpmdnVXV0J0UDF3NUNhc1MyVjA1UjdW?=
 =?utf-8?B?OGxKWjZPMkhVaTJ6eDdwOWVzWmVJQ1JwcDZYQXQ1K2tQdi9McG5rRFR0alRI?=
 =?utf-8?B?MmZPNDJvZTNhRHErTksxUVEvbzB2dnlSZEFRTWVKZVBnR1pJckM4cno5ajVR?=
 =?utf-8?B?Qzc5b0RwMkpRR3Z4eGJjeUZZVUxXYUJob3NHWjJhQjhrNmlNbjdUSGFxRGRB?=
 =?utf-8?B?Q3JxNHBSUEpLMXRMNy9tYWg2VlV3bUdxcUJNWHZLSHM3c0RlYTBOS2xoTGZS?=
 =?utf-8?B?aUFWdXluTWVGS3doazFzWnFsUTRYQWVCU0k5aGttWnlRUmw2K0htSzZZdFg2?=
 =?utf-8?B?eXhJVXdITm1FRnVPZmFzWlExUTY1RFhGVEpqamFLQzExU0N5WWp1OG93c1Vo?=
 =?utf-8?B?Z0NJS01UQm1EWHpEWGZrdmdXU3k5SnVlWWJHck9SbzQza0FwdWc5bDdwSVlr?=
 =?utf-8?B?d2hPZVZtTkoxcTFnK3VKOVpFaWlWaUxGWEpYYURmS0RoMllMQ2ZyMGUvUlZ4?=
 =?utf-8?B?YTFLVmVGdkx5Y2RFU0d5a1NOaHhKWlZxMVpoT1ZPNWZlU0NQOUJ6bldlK05z?=
 =?utf-8?B?b2FTbVBUUFN5OXQ5dHI3U1Vjd293K3BUU2ZEM29Tck1FbVl5TGVPb3hBZHJM?=
 =?utf-8?B?bjU3clBUWGlkQXhsNUcwMlU3aU5QdU5rbCsvRHRnUUt1cWp5bmZwVHAxYkpu?=
 =?utf-8?B?K1JNMTluTXlLWE4ycXNNdVlmNkVzcWNSYmx0VHRBMGhnbUptTko4TGlnUFZJ?=
 =?utf-8?B?VjM0V0hyRzNuTGh5QkoxWk84eEMyaUNXN3JTT0tIV25pbjZIanhubEVqVG1u?=
 =?utf-8?B?VGZNcS9ja0ZxZ1ZWNGU2V3J3d0YxZVZDODNNWkRjb2xrMkw2bnhLV0tFb2Zr?=
 =?utf-8?B?NTB6MWFxcm5RaVNkSHZubmFwRWRQN29yQzhlb2VpZXFoMFg2dHc2NU84SFgr?=
 =?utf-8?B?cXB3Z01DdVdwVXQ5cWpETjhBYm1MSmRjemkzSC9ZY1hiODR0aUpGclBibFB6?=
 =?utf-8?B?cWVTWkVSYjZuQ3VWRlZjaXJrY0dvQ09rb0NaR0NrU1ZCREkybm9xQ0Q2Y3ZJ?=
 =?utf-8?B?VVBQRm1JYjNJYVZpS1ErLzFlYVZDa0lkbTJXZUxRekVIVmVMdFhheUtaMm5p?=
 =?utf-8?B?eGpLQUdnYUpTNGFSR2ZRNGIyWGRRZTBIbDQ3QVBGVk5TU2xIdWtLWGJiK25Z?=
 =?utf-8?B?bTVPeDJwcUM3dlpVRmpjRU5MTjZ4YWt2NlcxUTY5TjVTL3pnNnY5cGM5MEVl?=
 =?utf-8?B?N2poQk81YW1qN0xHWnRSNGk0SkJIdW9wQUdLdCtpK2o5ZGs5Zi9kcDNQYVdY?=
 =?utf-8?B?dXVNN0pJd1FlOS9ndkZMUjY4RUhoeTEyODYzLzFyYkRKNFM4T3lackpqaG5k?=
 =?utf-8?B?M3JMUTZhNXA2V25wK3h0eXNSY1Rtc3g5K1NXU0lsbExXaWU3dnFrUnhIUFo4?=
 =?utf-8?B?N2JRcEgyOVYzTFF4aURSQW11MUdxYXc2VnBjYVAvRFVtK0xVelBKYnowVGp0?=
 =?utf-8?B?Y21acmRod0lqT25STnNqTkN2dlFyZlRaWlhWMXdWT080UFdKUURVVW02M3Y5?=
 =?utf-8?B?M3Y0YXAzQzFBZ1BCS05JclV4V0p6MzhJa1c2dldGSHFKMW5OZWxZRm1qMjc5?=
 =?utf-8?B?aDlHUUdJVTlyL3J3c2E2bzFjelNFOWtWeS9ESnQyKzkwM2hVVHJQYW55Visz?=
 =?utf-8?B?KzF3bHI4VDFnaFIwY21vUXA3MHZpZWNJeWlaRWV3OVBZNDNqQnF3TndJTXQw?=
 =?utf-8?Q?WhtxBMF1xuIwLJFRavaYSSUzrnCfH2FyfqJsvNELyUgpS?=
x-ms-exchange-antispam-messagedata-1: ijku9bDL61L3MA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B49726DAE586740BB49DC6C53FCC042@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8ef64d-8340-40af-dbc6-08de5df52480
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 22:40:59.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 33zZZH48bAQaLgk/LSpHMtejlz12eYNomII6aD8vKFHp0NohOUhEJhOq8LsuLXU5UYPi0fMxuwGlFnBtpI15sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8879

T24gMS8yNS8yNiAyMDo1NywgaGNoQGxzdC5kZSB3cm90ZToNCj4gT24gU2F0LCBKYW4gMjQsIDIw
MjYgYXQgMDk6MzU6MTZQTSArMDAwMCwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPj4gT24g
MTEvMjQvMjUgMTU6NDgsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToNCj4+PiBfX2Jsa2Rldl9p
c3N1ZV9kaXNjYXJkKCkgYWx3YXlzIHJldHVybnMgMCwgbWFraW5nIHRoZSBlcnJvciBjaGVja2lu
Zw0KPj4+IGluIG52bWV0X2JkZXZfZGlzY2FyZF9yYW5nZSgpIGRlYWQgY29kZS4NCj4+Pg0KPj4+
IEtpbGwgdGhlIGZ1bmN0aW9uIG52bWV0X2JkZXZfZGlzY2FyZF9yYW5nZSgpIGFuZCBjYWxsDQo+
Pj4gX19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpIGRpcmVjdGx5IGZyb20gbnZtZXRfYmRldl9leGVj
dXRlX2Rpc2NhcmQoKSwNCj4+PiBzaW5jZSBubyBlcnJvciBoYW5kbGluZyBpcyBuZWVkZWQgYW55
bW9yZSBmb3IgX19ibGtkZXZfaXNzdWVfZGlzY2FyZCgpDQo+Pj4gY2FsbC4NCj4+Pg0KPj4+IFJl
dmlld2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29t
Pg0KPj4+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGly
bkB3ZGMuY29tPg0KPj4+IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNrdWxrYXJuaWxpbnV4
QGdtYWlsLmNvbT4NCj4+PiAtLS0NCj4+IEdlbnRsZSBwaW5nIG9uIHRoaXMsIGNhbiB3ZSBhcHBs
eSB0aGlzIHBhdGNoID8NCj4gQXJlIHdlIGRvd24gdG8gdGhyZWUgcGF0Y2hlcyBub3c/ICBNYXli
ZSByZXNlbmQgdGhlIHdob2xlIHNlcmllcyBhbmQNCj4gZ2V0IEFDS3MgdG8gbWVyZ2UgZXZlcnl0
aGluZyB0aHJvdWdoIHRoZSBibG9jayBsYXllcj8NCj4NCnNvdW5kcyBnb29kLCB3aWxsIHJlLXNw
aW4gdGhlIHJlbWFpbmluZyBwYXRjaGVzIG9uIGxpbnV4LWJsb2NrL2Zvci1uZXh0Lg0KDQotY2sN
Cg0KDQo=
