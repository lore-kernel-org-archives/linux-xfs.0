Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0221C860C;
	Wed, 10 Dec 2025 04:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765342795; cv=fail; b=ZsPA2LSPP5D+BzEHFEZVjhwDwruSdb/GU1IoeQkY/WrSyWgXQxMdM9o633SwyTDysncKZY5mysHayLcbO5YbNpjk6+tcbIMKE9XCabcj5OjoN8lD/kcJqTuwRjSre3YywHVx0EbB3vgIjxLA5avzEwUu1IX3ABUzHADwaCaB078=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765342795; c=relaxed/simple;
	bh=+l0yok6sojvzAhGfn58L1Gbe6NVFuo+koItjb+8Ki30=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kkFdxQk3ttaLJWrB0fIs7dTGwO3KQpkvXDrEaufd4pbQNbdDPC6OvmLdvkA/LTPzgtt62tllnWhu3xkzDACt6Y7y5lI7FWo2l9MlFg8F3MWiUzgCIvsbd49DvJxMJ288bhbMboHbZcXX3j2j4JBbmGJdCOoYn/qYjG2MXA2ReSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H5SSNweP; arc=fail smtp.client-ip=40.93.198.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H5SSNweP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcBeEi5PprgwBwtg34sZI8IIJNMFQOfITlHmvX4EY/E97wQq6X9YqZaArdlCAlXZtjXrdZygV/vC8IuyoOU0A7tVhH0VhelSwqkTta1bDwirc4YHoe0W6vm9LhfFhYRANXUP9uEOHnK0v3zU7ka9yMb7ZF9D8hmEXf8hFQuO6t36ufPKhACKPZdw3TvbBcli/oAvU2F5CVEWcTJVRQnezwEboe51ZwOYf6LJOfYZJFnMm+mKZPFql006giE8pEwL8cAqggamHfFf/fplcirr9wcSsfikckbQQT69Osnhop65VrBce5TwxdTYhC1YS0MjP1RY1/ecVHtpZa2WTq3j/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+l0yok6sojvzAhGfn58L1Gbe6NVFuo+koItjb+8Ki30=;
 b=IHR6mnDJbkW386MEt9+VX7wx1IbUt/ZxNU2c5OrbcISsM2163Yn98yqwL56PNpbRokgTkheNKGV4NW1iFkkZ6X61Ie0niVI5jSbEZpa/Q8y1haM/OP7z84eB//J3alWBJLel92Hr+aRxKZ+xTuhV1aNL3Gm88YgMHrtx1UlT7bfDwX1GMCnFoqdKp1NHkps1ySVBHzjYdojq89TFD081TSGj0z/DhARTC2CI549cwXCZy+yvT/ZemqPYa9GCt5as2j0n75/HkM07P3kNU/AXNA87zGpXn5pUDH7Rutp40MuvuXDI4KE/G20rMTVzhh75I3p7lb9ZVWpT2BZdIHTu6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+l0yok6sojvzAhGfn58L1Gbe6NVFuo+koItjb+8Ki30=;
 b=H5SSNweP1fkU0CIl07Pxb9bHjowAxWyO/yuExe3VKiBjx/i3A4yKG+vPsBBq1u/Jku4BHXGfX4O5vbPjMgRcJH3o8eT1KqKyzzQtBCc3/tZOmcQtuHxjxgQ43BeIy5z0XiqGcz1CVpyo0aoF4zkgeX9eTEfvuhjhA/0L1Ahska4pUG+2GTd11aCEVadrLmAfhSgfBC2lyBQXkJUyOkklB7Nl+kTZ/po7dVcWdSrRb9Stlf4JHUasYkdSXXZVwJdKcIrF8nFDNskWJWQ/MMZtQkH0mKNs+QAZC5NtjGwfP9q7QEJbNVTIyic1e9/JTxcNK20cIZIUq2RsFOuqFAF2bA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SN7PR12MB7834.namprd12.prod.outlook.com (2603:10b6:806:34d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Wed, 10 Dec
 2025 04:59:50 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 04:59:50 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Keith Busch <kbusch@kernel.org>, Sebastian Ott <sebott@redhat.com>
CC: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Robin Murphy
	<robin.murphy@arm.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig
	<hch@lst.de>, Will Deacon <will@kernel.org>, Carlos Maiolino
	<cem@kernel.org>, Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Topic: WARNING: drivers/iommu/io-pgtable-arm.c:639
Thread-Index: AQHcaQFVH3CUuaIhmEu/T0GQ8kjfQrUZMfcAgACbGYCAAFrrgIAAGoGAgAAPIQA=
Date: Wed, 10 Dec 2025 04:59:50 +0000
Message-ID: <2fcc9d30-42e8-4382-bbbc-a3f66016f368@nvidia.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com>
 <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com>
 <99e12a04-d23f-f9e7-b02e-770e0012a794@redhat.com>
 <30ae8fc4-94ff-4467-835e-28b4a4dfcd8f@nvidia.com>
 <aTjxleV96jE3PIBh@kbusch-mbp>
In-Reply-To: <aTjxleV96jE3PIBh@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SN7PR12MB7834:EE_
x-ms-office365-filtering-correlation-id: 1c580e7f-ec2e-4a60-8d2c-08de37a8f314
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eWsydmtVRTdQRnhLdk94OGRkMnkvbHg2Uk5weVNTQ2VLVmFwRElmak00UTRs?=
 =?utf-8?B?SkxMRDFZYjA3Tmk0UFpwcWRNNUYxcnUwa3kzOVpZRUwyVFc2V2x3KzdHUUF2?=
 =?utf-8?B?NE4wejJTVXpLaDNaKzErN1NlOGczUlNEQ0hGUnZERlEwWXU1aGhhNXduRSty?=
 =?utf-8?B?dGhZTTgrRUdkVWtCd3lhQ0l6OXpoUmo0eHdMTnpUY0l6NzQ3eUtJcmlyZElI?=
 =?utf-8?B?TEUvTWJmeXh4Vm5YMDczTjJ6ZkkvTmtsNWUySnZZTmg0YlNaMmt0UHFvVlFV?=
 =?utf-8?B?TWx3ZEtqZHQzWDlldnp1QmtqM3FqZkxRTW1EMmFlM3V1WW1YV1lNNHdCcGxO?=
 =?utf-8?B?Q1ZwZWpwZW1PWDZ6QXF0NUFQK2ZLZ3FzbENyMUxXd3VKVXYxd0cwY0gxNTI5?=
 =?utf-8?B?YzUwQlhwbktWajk2dHlDZzhMbFpDUlE2OHBXUmZVRDVXeTVGaFJDZHhnM21K?=
 =?utf-8?B?bVdncVNuWnNLa2VETS9ETEE4QTZ0aklYdy9STEY3R2w4TC9UTUNoWFZ3cXNP?=
 =?utf-8?B?QXduSVJ6Q2RHaVFkcVJVMmxKY1VYRnJEVjZVTGs1YU8zSndodVJsYUhncEZ5?=
 =?utf-8?B?blNjTlhvYXZLeit4dEZxOERiNkxOYy9TZjZ5WkxJWUt1QnZSa2ZzdHFtSW1k?=
 =?utf-8?B?a3k5Mzd6Y1VHV3BPSkFocTZFY3V4M0YxMkJaRURlTnRlbWNFcFNDUklnQ1Qy?=
 =?utf-8?B?N2NKbzVodWtVaGhIYUNGRHY1OU8xanppbzM5MTg1SnVNK1hRNFBOZ0pKQ0xS?=
 =?utf-8?B?T04yaGRWTUJmZTQ3OHhGWDAxbEtHQ2dqbEhxQVlrYXVOaHRyWm9ES2lmVisw?=
 =?utf-8?B?QU9zZ29aWUxnMXRVNGd2VndJRXlaVG01VkMvY3h1T0g2cTJTUk9DQVdyM3Ux?=
 =?utf-8?B?OU9zc0c0NVZCQXRkY00zNkdOZW9sVWpqSmQvbHdjWlhWZDdSemRncjBLVjYv?=
 =?utf-8?B?UEpHQ1dBcmFWTHN1YzR0RHlJelVUdmIzTTBQejJFTGdiRjFNVWlpaHNBWXRD?=
 =?utf-8?B?QTNkN2MrbGpBVk5rZnBDdXZ4Q21hRHZKY2l3aUw1M1pOSmJ6dWRFNTMxc3g1?=
 =?utf-8?B?dVZOeXNLVzFtUmhXUmcwdXR6MjNqM3liQzljUXoxK2dNVkdNbFRVamNYY2tu?=
 =?utf-8?B?MlpuNHBHL29zWXFmR1hDZzZqdGowMVdMM0hudGplbGYzKzFucnJoS2R4VjBz?=
 =?utf-8?B?eXpURXhoa3pncHdzWXo2NWFXak1yR0oxYlFsQmROQ3UzclBBTzN0T3hxTEN2?=
 =?utf-8?B?eWQyRWxQWnVJaGtiUnhZZWsrN2xqU25EdFhhTHNOODR3TFpLZzdDdXJzVGVQ?=
 =?utf-8?B?Q3FlOGRIanJwNTZxdmMzdUtDalJyMll1cHVrd25ielJZTS9SelVGbElhVHlw?=
 =?utf-8?B?VSt1YWl4cU1MYXVKL0R2SjBjakZVYjh0d0RTNWhqS1hMVGFOWm10Q1ZXbnpv?=
 =?utf-8?B?S0VkV0kzZjZwU2tOblBVckxCTDNOMS9senpUTytFeGpOZGdDWlNyaDdtQ2VI?=
 =?utf-8?B?TEpYU3N5L2ZMVjV5V3FnWGxtWHVFamJTNlJmWHFlNGIyM2twcU5oK0kraVht?=
 =?utf-8?B?b29mN1lqVDJDalBPMTBxUjBxYWdZN0tXaVlsdUNiMlUwWUo4OERoakMrSnZm?=
 =?utf-8?B?MHBpUnprTE9Eb1hjVU9RaDIzOEhzd0cvcnZGTnJlQ2xCZlV5N2dRRllMV3hB?=
 =?utf-8?B?Y0pqaW9zWVd6Nm5wTDJsditzU2JPUFdHSVRxYkZqbmRET2F1bGh6RUYwODFQ?=
 =?utf-8?B?QWk2V3ZTdkUrSkdXaTZwb0l4S2hrdDV1WngzZk51YTR1Y3ZIc1VKZmtRUkRW?=
 =?utf-8?B?NmJJeU04SmpRcnd0QkM2ckk5TzZicHNiR1kxTUpGNWdjQWQwdjdPQ1RRQjBN?=
 =?utf-8?B?NUNaekl6TE8xa2s0VVFSdEdkTzN4elZTd3NJUldaSm00NzF4OWNHdGRMQm9O?=
 =?utf-8?B?TFlwTkkvVlFUVzZpd2llMW9aN1F6REpNdTBudGZSNURNSGllMnJhRlIxWjZG?=
 =?utf-8?B?aUFWVG5sN1JMQUhuR253UTBBQjlPYVhSbEhlZ05CZUU3bDhNMzZWUEdBSzJl?=
 =?utf-8?Q?UQcM+w?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aTNlaVQ1aTdadVd1YTg0blk0Mmt0ZW83VzBhNVZiTk0rOVFSSmpCU3hRTVJS?=
 =?utf-8?B?bDY1N2F3em5icmlsZjBDNG9pQVpndy91YUs3SUFCTFJBaHM5ME42YjFNWlFO?=
 =?utf-8?B?ZmNidzVZTUxYQStFN0M3ZWVwdFFmTVFtREUrQmdKS1UrMGNEa2V1RXNreEVF?=
 =?utf-8?B?ZFJmNVh6WmN5Y0hGamtlWHFLdmVnSUswV3VFdVZjaWNndml6N0dwVVk1OVV2?=
 =?utf-8?B?WElCRGRGaktkYWtIQ280ZXFCV2Vtam41RU0vYlkreTF0Z2RaU0ZMeW80YXZ1?=
 =?utf-8?B?MVhYUTVRRUNlNzZ2STRUd2RiY3FsWWhKQ0Y2VFY0WjZ0VC83RER6M241TTQw?=
 =?utf-8?B?VG5pNkQ3ZW9RSTRqSUJMVHJsTnpKNjcySEs2dXZLU2dYY0RGcjVFWC83QUhJ?=
 =?utf-8?B?RVN1QzF2MWY0Y0xGU2FiQXI1WXU5RFE2OS93QUx5NXplUldtMVJnRDlZSFlD?=
 =?utf-8?B?NXVXWW15QW0zcW10OGk1OTVrWjQ3aWZjYzVmaU5XVHlwN0sxRXZWTk5kTWdI?=
 =?utf-8?B?YUJ2VW9LY1B4bEo5QTF0Y09wSWUyMThLWTA1RzI2ZjN6S1JBRXo0SDFSL2hy?=
 =?utf-8?B?U0V2OTBaNy9GYUNyRXhKcW5IbDRKVmhwdXloNllMUlJLNmRrWDJ3d2NXNEFr?=
 =?utf-8?B?MDN1cXFvVHhlS1NNSFllWUlzVDY5NjV0eHU3ZXNwNG9vUWxER2ExRXpDakRk?=
 =?utf-8?B?OWdPcysva3BFWXZSdjZaSUY1ZUVmMkl3UVZGNjlTQ0REaWVhMUwzRGtpTWZF?=
 =?utf-8?B?anQ1S0xQaVg0NVdOU0x5TmpKODhRSmhZdGlIN2xDd2V3RWI0eThZWXB3UUU3?=
 =?utf-8?B?MzJSSXJrK1NvQ2NvbGpzWXhGWlVGK3dybm9Dd08rQzRqWS9Yam5VMFllWkxI?=
 =?utf-8?B?RFdtWUFvVzk4ZXJOYzBJNk16S2lCYlJQTm9SdEZHVlZ3VlZ4OTc1L3N5RGVS?=
 =?utf-8?B?Um9sM2RGRjZ5V1dOUWp3TGhIb2Q0MzZUNGFBVTArUCt2MlJLZHVjUTU3V2FS?=
 =?utf-8?B?RENUa1gwUXNRdEpXQnZ6cTVUV09Va3I3YitIeXJWUkVjenRKZUFrNTljUWdM?=
 =?utf-8?B?VHRVSHFoY3JMSkFkNTJ0amFGVHI0b0xjemY3Y2JUTjJYS1VWUEVHaHgwRFhR?=
 =?utf-8?B?b0VhQzQyV0ZzYUVJd3FHWWk3MWkwb1pzc25PKytYR2laUng4Mk9wRFB4RHFF?=
 =?utf-8?B?VUw3VDRxTU9BWnQrSHdiTnNBUHpibTRwY25wZmFvMkx3eVNjSUg1b1JmQ0p2?=
 =?utf-8?B?VEhRNFpkbUNYTlJ2YTVXRXJXWUlBNDZuNDNNaFhQUFhyeG5rS3A5R25EQ3li?=
 =?utf-8?B?a3BPOVkrTmdaZ0RtYUNXeTh0RzVrNHJQZlQrUm9sN2xEdXcxWU83NTJqZlVF?=
 =?utf-8?B?ci80S1dJd1BaaGhndTNta0VGMjI4RDhsZkZVVTJYaXNENVgzV250NVFzZlQz?=
 =?utf-8?B?ZDNlSmEySVpVdXEwdGJrd3Y2VXh6Q0tjL0RBd0p3dDhmQS8vRXkyOVhwdTdz?=
 =?utf-8?B?UVN5Z2FjcjEwaUdFaG5pNVBIdDQwVlYrUUZoL0NzZitnMU5IY3R1R0xrc3VI?=
 =?utf-8?B?NVpsM0M5VTNGYVYySTJoTlZwVG5iL0lNQU1QbG9JOTBCOVh1SHdMZGgwMGRP?=
 =?utf-8?B?dFBDb3ZLUVlpTXY3aHErS3F0RGtUTDF6dkZtVll3UUU2MGhsWHBSUXZVUjk5?=
 =?utf-8?B?cmpxWHZtM3pJL08zdmFWT29lUmJURlR5eXI5TlJEZitNRkZHYk1xc1Zxazk2?=
 =?utf-8?B?TzJJenRRdjYwQm1TeCswcjlnTVlUUmxMV1habzVGUzBxd0pTTllCRHk2Ym8y?=
 =?utf-8?B?enl5MHI1dG5nMC9XTm5lUkttRmUyMjVxL3lPVVJLSU12OG5vdXBBcWtPdFc2?=
 =?utf-8?B?eGVDOGUyU2JlRzNEcGJ4S2tTc2NadWxOZUllUk00SXdaVVJueTIrL0NaeEUz?=
 =?utf-8?B?VmpBcm5wSjJPdWJnS09MK041RWxKNVdFQVhOTWs0aXo4MVZCSU1rVEkwdGV5?=
 =?utf-8?B?YUV3b1BTcHpONTIxcjZNd2hkRnphRGlyakRTRXI3bU5qcnd1dWFqNkdWTVRh?=
 =?utf-8?B?WjRYRkhVRHRSZmplYTQyenhlODNOQlZ2Y3NBdkcrV2VEZnFUVW1Pa0R2MVJ1?=
 =?utf-8?B?aDErQ1NVRksxVkdlc2dvNEo4MUNVQkRqS3dRNWZMMmxWYXByMEt2ei9rK2NT?=
 =?utf-8?Q?NbnH7YxdaUpTTvGbBGuh9CoQhBQnq8hX4JYvLtRvJpsF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0A44960C2D29845BF9ED3E4C50046B1@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c580e7f-ec2e-4a60-8d2c-08de37a8f314
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 04:59:50.5317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OWHZRFYVIZqlMUckI23DyDr/M3llgNXhOEEEVrI2z9aBudk+T4LDnjJJOA6laTOsgdKLDGNTYR/zIPwkhCWqEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7834

KCsgTGVvbiBSb21hbm92c2t5KQ0KDQpPbiAxMi85LzI1IDIwOjA1LCBLZWl0aCBCdXNjaCB3cm90
ZToNCj4gT24gV2VkLCBEZWMgMTAsIDIwMjUgYXQgMDI6MzA6NTBBTSArMDAwMCwgQ2hhaXRhbnlh
IEt1bGthcm5pIHdyb3RlOg0KPj4gQEAgLTEyNiwxNyArMTI2LDI2IEBAIHN0YXRpYyBib29sIGJs
a19ycV9kbWFfbWFwX2lvdmEoc3RydWN0IHJlcXVlc3QgKnJlcSwgc3RydWN0IGRldmljZSAqZG1h
X2RldiwNCj4+ICAgIAkJZXJyb3IgPSBkbWFfaW92YV9saW5rKGRtYV9kZXYsIHN0YXRlLCB2ZWMt
PnBhZGRyLCBtYXBwZWQsDQo+PiAgICAJCQkJdmVjLT5sZW4sIGRpciwgYXR0cnMpOw0KPj4gICAg
CQlpZiAoZXJyb3IpDQo+PiAtCQkJYnJlYWs7DQo+PiArCQkJZ290byBvdXRfdW5saW5rOw0KPj4g
ICAgCQltYXBwZWQgKz0gdmVjLT5sZW47DQo+PiAgICAJfSB3aGlsZSAoYmxrX21hcF9pdGVyX25l
eHQocmVxLCAmaXRlci0+aXRlciwgdmVjKSk7DQo+PiAgICANCj4+ICAgIAllcnJvciA9IGRtYV9p
b3ZhX3N5bmMoZG1hX2Rldiwgc3RhdGUsIDAsIG1hcHBlZCk7DQo+PiAtCWlmIChlcnJvcikgew0K
Pj4gLQkJaXRlci0+c3RhdHVzID0gZXJybm9fdG9fYmxrX3N0YXR1cyhlcnJvcik7DQo+PiAtCQly
ZXR1cm4gZmFsc2U7DQo+PiAtCX0NCj4+ICsJaWYgKGVycm9yKQ0KPj4gKwkJZ290byBvdXRfdW5s
aW5rOw0KPj4gICAgDQo+PiAgICAJcmV0dXJuIHRydWU7DQo+PiArDQo+PiArb3V0X3VubGluazoN
Cj4+ICsJLyoNCj4+ICsJICogVW5saW5rIGFueSBwYXJ0aWFsIG1hcHBpbmcgdG8gYXZvaWQgdW5t
YXAgbWlzbWF0Y2ggbGF0ZXIuDQo+PiArCSAqIElmIHdlIG1hcHBlZCBzb21lIGJ5dGVzIGJ1dCBu
b3QgYWxsLCB3ZSBtdXN0IGNsZWFuIHVwIG5vdw0KPj4gKwkgKiB0byBwcmV2ZW50IGF0dGVtcHRp
bmcgdG8gdW5tYXAgbW9yZSB0aGFuIHdhcyBhY3R1YWxseSBtYXBwZWQuDQo+PiArCSAqLw0KPj4g
KwlpZiAobWFwcGVkKQ0KPj4gKwkJZG1hX2lvdmFfdW5saW5rKGRtYV9kZXYsIHN0YXRlLCAwLCBt
YXBwZWQsIGRpciwgYXR0cnMpOw0KPj4gKwlpdGVyLT5zdGF0dXMgPSBlcnJub190b19ibGtfc3Rh
dHVzKGVycm9yKTsNCj4+ICsJcmV0dXJuIGZhbHNlOw0KPj4gICAgfQ0KPiBJdCBkb2VzIGxvb2sg
bGlrZSBhIGJ1ZyB0byBjb250aW51ZSBvbiB3aGVuIGRtYV9pb3ZhX2xpbmsoKSBmYWlscyBhcyB0
aGUNCj4gY2FsbGVyIHRoaW5rcyB0aGUgZW50aXJlIG1hcHBpbmcgd2FzIHN1Y2Nlc3NmdWwsIGJ1
dCBJIHRoaW5rIHlvdSBhbHNvDQo+IG5lZWQgdG8gY2FsbCBkbWFfaW92YV9mcmVlKCkgdG8gdW5k
byB0aGUgZWFybGllciBkbWFfaW92YV90cnlfYWxsb2MoKSwNCj4gb3RoZXJ3aXNlIGlvdmEgc3Bh
Y2UgaXMgbGVha2VkLg0KDQpUaGFua3MgZm9yIGNhdGNoaW5nIHRoYXQsIHNlZSB1cGRhdGVkIHZl
cnNpb24gb2YgdGhpcyBwYXRjaCBbMV0uDQoNCj4gSSdtIGEgYml0IGRvdWJ0ZnVsIHRoaXMgZXJy
b3IgY29uZGl0aW9uIHdhcyBoaXQgdGhvdWdoOiB0aGlzIHNlcXVlbmNlDQo+IGlzIGxhcmdlbHkg
dGhlIHNhbWUgYXMgaXQgd2FzIGluIHY2LjE4IGJlZm9yZSB0aGUgcmVncmVzc2lvbi4gVGhlIG9u
bHkNCj4gZGlmZmVyZW5jZSBzaW5jZSB0aGVuIHNob3VsZCBqdXN0IGJlIGZvciBoYW5kbGluZyBQ
MlAgRE1BIGFjcm9zcyBhIGhvc3QNCj4gYnJpZGdlLCB3aGljaCBJIGRvbid0IHRoaW5rIGFwcGxp
ZXMgdG8gdGhlIHJlcG9ydGVkIGJ1ZyBzaW5jZSB0aGF0J3MgYQ0KPiBwcmV0dHkgdW51c3VhbCB0
aGluZyB0byBkby4NCg0KVGhhdCdzIHdoeSBJJ3ZlIGFza2VkIHJlcG9ydGVyIHRvIHRlc3QgaXQu
DQoNCkVpdGhlciB3YXksIElNTyBib3RoIG9mIHRoZSBwYXRjaGVzIGFyZSBzdGlsbCBuZWVkZWQu
DQoNCi1jaw0KDQpbMV0NCg0KIEZyb20gNzI2Njg3ODc2YTMzNGNiNjk5MjQ3NTg0MTAyZTQ5MWU5
OGY4ZmRjNCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCkZyb206IENoYWl0YW55YSBLdWxrYXJu
aSA8Y2t1bGthcm5pbGludXhAZ21haWwuY29tPg0KRGF0ZTogVHVlLCA5IERlYyAyMDI1IDE3OjAx
OjE1IC0wODAwDQpTdWJqZWN0OiBbUEFUQ0ggMi8yXSBibG9jazogZml4IHBhcnRpYWwgSU9WQSBt
YXBwaW5nIGNsZWFudXAgaW4NCiAgYmxrX3JxX2RtYV9tYXBfaW92YQ0KDQpXaGVuIGRtYV9pb3Zh
X2xpbmsoKSBmYWlscyBwYXJ0d2F5IHRocm91Z2ggbWFwcGluZyBhIHJlcXVlc3Qncw0Kc2NhdHRl
ci1nYXRoZXIgbGlzdCwgdGhlIGZ1bmN0aW9uIHdvdWxkIGJyZWFrIG91dCBvZiB0aGUgbG9vcCB3
aXRob3V0DQpjbGVhbmluZyB1cCB0aGUgYWxyZWFkeS1tYXBwZWQgcG9ydGlvbnMuIFRoaXMgbGVh
ZHMgdG8gYSBtYXAvdW5tYXANCnNpemUgbWlzbWF0Y2ggd2hlbiB0aGUgcmVxdWVzdCBpcyBsYXRl
ciBjb21wbGV0ZWQuDQoNClRoZSBjb21wbGV0aW9uIHBhdGggKHZpYSBkbWFfaW92YV9kZXN0cm95
IG9yIG52bWVfdW5tYXBfZGF0YSkgYXR0ZW1wdHMNCnRvIHVubWFwIHRoZSBmdWxsIGV4cGVjdGVk
IHNpemUsIGJ1dCBvbmx5IGEgcGFydGlhbCBzaXplIHdhcyBhY3R1YWxseQ0KbWFwcGVkLiBUaGlz
IHRyaWdnZXJzICJ1bm1hcHBlZCBQVEUiIHdhcm5pbmdzIGluIHRoZSBBUk0gTFBBRSBpby1wZ3Rh
YmxlDQpjb2RlIGFuZCBjYW4gY2F1c2UgSU9WQSBhZGRyZXNzIGNvcnJ1cHRpb24uDQoNCkZpeCBi
eSBhZGRpbmcgYW4gb3V0X3VubGluayBlcnJvciBwYXRoIHRoYXQgY2FsbHMgZG1hX2lvdmFfdW5s
aW5rKCkNCnRvIGNsZWFuIHVwIGFueSBwYXJ0aWFsIG1hcHBpbmcgYmVmb3JlIHJldHVybmluZyBm
YWlsdXJlLiBUaGlzIGVuc3VyZXMNCnRoYXQgd2hlbiBhbiBlcnJvciBvY2N1cnM6DQoxLiBBbGwg
cGFydGlhbGx5LW1hcHBlZCBJT1ZBIHJhbmdlcyBhcmUgcHJvcGVybHkgdW5tYXBwZWQNCjIuIFRo
ZSBjb21wbGV0aW9uIHBhdGggd29uJ3QgYXR0ZW1wdCB0byB1bm1hcCBub24tZXhpc3RlbnQgbWFw
cGluZ3MNCjMuIE5vIG1hcC91bm1hcCBzaXplIG1pc21hdGNoIG9jY3Vycw0KDQpTaWduZWQtb2Zm
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGNrdWxrYXJuaWxpbnV4QGdtYWlsLmNvbT4NCi0tLQ0K
ICBibG9jay9ibGstbXEtZG1hLmMgfCAyMSArKysrKysrKysrKysrKysrLS0tLS0NCiAgMSBmaWxl
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9ibG9jay9ibGstbXEtZG1hLmMgYi9ibG9jay9ibGstbXEtZG1hLmMNCmluZGV4IGI2ZGJjOTc2
NzU5Ni4uZWNmZDUzZWQ2OTg0IDEwMDY0NA0KLS0tIGEvYmxvY2svYmxrLW1xLWRtYS5jDQorKysg
Yi9ibG9jay9ibGstbXEtZG1hLmMNCkBAIC0xMjYsMTcgKzEyNiwyOCBAQCBzdGF0aWMgYm9vbCBi
bGtfcnFfZG1hX21hcF9pb3ZhKHN0cnVjdCByZXF1ZXN0ICpyZXEsIHN0cnVjdCBkZXZpY2UgKmRt
YV9kZXYsDQogIAkJZXJyb3IgPSBkbWFfaW92YV9saW5rKGRtYV9kZXYsIHN0YXRlLCB2ZWMtPnBh
ZGRyLCBtYXBwZWQsDQogIAkJCQl2ZWMtPmxlbiwgZGlyLCBhdHRycyk7DQogIAkJaWYgKGVycm9y
KQ0KLQkJCWJyZWFrOw0KKwkJCWdvdG8gb3V0X3VubGluazsNCiAgCQltYXBwZWQgKz0gdmVjLT5s
ZW47DQogIAl9IHdoaWxlIChibGtfbWFwX2l0ZXJfbmV4dChyZXEsICZpdGVyLT5pdGVyLCB2ZWMp
KTsNCiAgDQogIAllcnJvciA9IGRtYV9pb3ZhX3N5bmMoZG1hX2Rldiwgc3RhdGUsIDAsIG1hcHBl
ZCk7DQotCWlmIChlcnJvcikgew0KLQkJaXRlci0+c3RhdHVzID0gZXJybm9fdG9fYmxrX3N0YXR1
cyhlcnJvcik7DQotCQlyZXR1cm4gZmFsc2U7DQotCX0NCisJaWYgKGVycm9yKQ0KKwkJZ290byBv
dXRfdW5saW5rOw0KICANCiAgCXJldHVybiB0cnVlOw0KKw0KK291dF91bmxpbms6DQorCS8qDQor
CSAqIENsZWFuIHVwIHBhcnRpYWwgbWFwcGluZyBhbmQgZnJlZSB0aGUgZW50aXJlIElPVkEgcmVz
ZXJ2YXRpb24uDQorCSAqIGRtYV9pb3ZhX3VubGluaygpIGRldGFjaGVzIGFueSBsaW5rZWQgYnl0
ZXMsIGRtYV9pb3ZhX2ZyZWUoKQ0KKwkgKiByZXR1cm5zIHRoZSBmdWxsIElPVkEgd2luZG93IGFs
bG9jYXRlZCBieSBkbWFfaW92YV90cnlfYWxsb2MoKQ0KKwkgKiAoc3RhdGUtPl9fc2l6ZSB0cmFj
a3MgdGhlIG9yaWdpbmFsIGFsbG9jYXRpb24gc2l6ZSkuDQorCSAqLw0KKwlpZiAobWFwcGVkKQ0K
KwkJZG1hX2lvdmFfdW5saW5rKGRtYV9kZXYsIHN0YXRlLCAwLCBtYXBwZWQsIGRpciwgYXR0cnMp
Ow0KKwlkbWFfaW92YV9mcmVlKGRtYV9kZXYsIHN0YXRlKTsNCisJaXRlci0+c3RhdHVzID0gZXJy
bm9fdG9fYmxrX3N0YXR1cyhlcnJvcik7DQorCXJldHVybiBmYWxzZTsNCiAgfQ0KICANCiAgc3Rh
dGljIGlubGluZSB2b2lkIGJsa19ycV9tYXBfaXRlcl9pbml0KHN0cnVjdCByZXF1ZXN0ICpycSwN
Ci0tIA0KMi40MC4wDQoNCg0KDQo=
