Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13076176AA1;
	Fri, 12 Jul 2024 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805661; cv=fail; b=R5ulWlILy3XYM/2oub2JnICg0l9WlipjdG/iIOhl9YrPLHwSeoXGbpJ+OMZjwJsRNUEL9P9cigI67sRZzVNqOIFgDdSFLtNWJ1CPslUUfZs/yDoW4A48JbKm04uUX/rj7yF0ckBE3elkJOaJnXZ804aES+I3qioPvriQPDlYEls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805661; c=relaxed/simple;
	bh=1hD5QNmUjdBDYkzvnVaTeklElIfmn79ZypQhvVpwyXo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S9GOg2/uC9Gwe+BRlJV0OMsd4byKQGXJ+4V6vpeNLfO/ISWUdFgwy62E+5NPu1tFh3FiwjviGiw3LDP1qemuac52Xvwk0elpK02MGAHP1XxwkubUq7N+JD3Hx4wLVapxMtrzQ6VJz5XfPmD5tUFU4su9IyF6RjfAlXQzV3lJdwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vqfth7ba; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vqfth7ba"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c0vAqX01RiznVZ40l/JzZfpcrYQ7wpwbWvpex+wRMOxktd4g1xR1cHXiMUOfO9dfMMxVy1hVbBbg/0VXq++Qnuy6njyY6Rag8KpVCSy7VFctSnSma2eTzL7GVXdajzV1ScAAatY1WLTLSFxURWYV/ASybZF2g2R1FhbwulsZO68+CmAdXBUSUb6NI5sQSqY3/EAa+MfmVl0KngOwmAl3lv0Bf68RtAIItJ0FbFnt1QcR244H2ByX11+HXlMZAhQnt5CVh7BkjT4sqe3Vde/IlScapIIAeBIqQfCwF3lfzWlyVsB/Z/OnK2fiAKMTMnBFcs75a9n25GDEQnwQXunE4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hD5QNmUjdBDYkzvnVaTeklElIfmn79ZypQhvVpwyXo=;
 b=EVPq8vONK/PH9QHApar4+uF9jdOs2ttDsFfI4+8cSLqPd4ZWxYUBlXUf7YR6ISgg0SVp4WhDx+TDPuU6ObjcsBegGMQxCJHWA4XWcyuU0NGIpT62EYjBSvSaiwGpCKJvpR+iEIiYG3jJoKTzRCzuzzDYvz9F5/kwJsKPlJvwPOmEjvbUagGqjJdcN5MhXmvLO1QwANBZoeNNsg/QrcqiIncqUtxF/dWq4E1LBWUtY/V5e7ESrH/uZiyld74u4V5fdVaRljGXUBq8gvWaW69hOVD8xJb45dR8WPfDBo/7HZNk4soKTK9ienFPhOuNOBA9rK35EB7zT8Ksn1ujgK+gNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hD5QNmUjdBDYkzvnVaTeklElIfmn79ZypQhvVpwyXo=;
 b=Vqfth7baJCKGa1W//pZ256FTsMMFf7BXsm8NixVwK4t9cp6Fp+vnWNY3ngzZE0pxndnRRGrNCoS879MT6K0Syhy8uhUe6Ekx9MexEgTaoLE5rLf3i6yFc3I109zVFUt2UVEitpM3FXfG+36kWA63Vxw6pU9qj0eTs5U21005ohZHU9jKZgmOiHzRZr+3fmSCBmxXaJJVrXGERG/lGFpKh49hopbj0Iel+4Z0beo1ieUGGOCUOj2bWkh3FYG2chu9CVl+Ze3CjY9avvgYf4onViU8rkju5+Gh0Sk9R1oAL2eGaDfImTutbPdSskHnFWlxQ4BTB3RsPhu7KMq7C/BXsQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS7PR12MB5815.namprd12.prod.outlook.com (2603:10b6:8:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19; Fri, 12 Jul
 2024 17:34:14 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 17:34:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, Chandan Babu R
	<chandan.babu@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove unnecessary check
Thread-Topic: [PATCH] xfs: remove unnecessary check
Thread-Index: AQHa1GTnsArDhYMPT0eiDCdKP3cxDbHzWqSA
Date: Fri, 12 Jul 2024 17:34:14 +0000
Message-ID: <512241eb-2190-40f4-aeae-066d67464362@nvidia.com>
References: <a6c945f8-b07c-4474-a603-ff360b8fb0f4@stanley.mountain>
In-Reply-To: <a6c945f8-b07c-4474-a603-ff360b8fb0f4@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS7PR12MB5815:EE_
x-ms-office365-filtering-correlation-id: b3a9e91f-7861-418c-316f-08dca298d930
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dlhweCt0UUdZellXdGNHMWhPN0lQZ0IrTHhoQS90NENPQWJ5a2lBWWc5Rkhh?=
 =?utf-8?B?SklYS2ZKdGtrZm45MDFUa24ySWN2RUkrc3NjNjMyMU1UdHJwZVl0enlCaTRr?=
 =?utf-8?B?eTVtZHdjQ3IxdFY0bzh2MnRoSlNKbXRSSnhaYjBOaUd4aVZoaXhNNXhlNWhG?=
 =?utf-8?B?djlZaUpSZHZFUmR0UktYV25VdGc5T2dLd3NCWUVvUzB2cldUcXhRemQ3dW01?=
 =?utf-8?B?dnE4Z0xybUpMZHZtN0c5N05oTjJrUGc4NHJjZDF0TGZuSkt3OVBFbzREMmZo?=
 =?utf-8?B?elY4bHUxdFBXVWJ6QXFLL1E2R2tkSFVKNXFQTEhvR3NpOHNaRzAyNGQvUHBp?=
 =?utf-8?B?cDAwaHRJby8yVjJSbCt0VzRlcmRlbnFrQlNUdkVPaHFuNVZobm55N2RvQ3Jl?=
 =?utf-8?B?VG1lUHJqZDcvemJhK2toMm5qNUgxYU9KSHB5V1BlNmlRWmNSeXcva04xR0Y4?=
 =?utf-8?B?citzenlCakg1VDM1bUljT0xPcGVxVzI3d1VVcm5NSVY0MnNVN2FySDhGblps?=
 =?utf-8?B?dnBTYnlMOFc2N2NTaEFudWowQlZnVWI0UU5YYWExOWdQbWRjV2orK2taTnE5?=
 =?utf-8?B?eVJrUWh4b2hYbjhDMjd2N2IySjY1ZUM5RzNjWDVLeVo0MXhMeU5Sa0RDZ1ho?=
 =?utf-8?B?WFhqdU5hbi9qWkVXVTVMUm9wZGh2L3RwUlJYN1N5a05zOVVXVEQ0OWVIWE1n?=
 =?utf-8?B?YXovc21MblQwR0t1YXU2TU9mK2poYms5dnlTcVBNOXc0OTFxeTZhWktZSit3?=
 =?utf-8?B?L1dQRTRCand0a0Y1bkFRZ0hjL0ZSdXloVlo1TnV3T3Vyd2prR002NStuaVdj?=
 =?utf-8?B?dVhNQlF4ZVNTUURvcklBNi92bzRaSUNEdWhneWNVTnFNK0JSaHlLdVJ5WGhZ?=
 =?utf-8?B?NytScFNxYzFTVVBuTTlTQVM3UmhMT2FsVlM3dFdvSzFJYWxFUER3Slpqa254?=
 =?utf-8?B?WVIvdWpmdkpHUURib3ZyUkJraTZZcGl1U1hmN3hFWkYrSWdSTGtkSTdZMVBM?=
 =?utf-8?B?eUVYOEhXYWt1dURBSk1pTTllQnE5WWtQKy9pMVBBUE5McHAxR0RxZXJ2aDFU?=
 =?utf-8?B?NXVrS3VOaUVZd25rSHdRRzVlNWhyZzVKa05MRHVQRlE1ZndvQ05JR1NhZmpN?=
 =?utf-8?B?RGJuczRFOXc3MWpleFJIdWgyY1V3VEpOS0JQeHoxSmEzcllwZ0FFQ0JUNXVN?=
 =?utf-8?B?TVh4NW9hSVl6bEdpVlovVjB4dmVsT0pUQ1NOenNDMUxVMlhJWW5Kbjc4aGdr?=
 =?utf-8?B?aXk4WFI0YnVueEFHbFNQL1hxeTlxTlBObUZNSXFuZTVrV3ZKaVFKc0E1YVJ1?=
 =?utf-8?B?eXg2bUN5c2lMZmlpUTg3Nlg4Qi9iZWgwR01xWFdTbHJGM0hXU2Y4MkxJZVpZ?=
 =?utf-8?B?ZUxQWHdMZEZHUDQ3TW0vUjVZYjhLenN3L0ZSWG5IdU1weFBvQkFwZTl1Skkv?=
 =?utf-8?B?a2FScWVxbDBNNHBCREQ3OEpLNFlnamtXZis0dzJBcDFGeDE2WEFnU1U2TTV5?=
 =?utf-8?B?NnQvQnhqL0ZYTXRsM2h5TVNnMVpBRGQ5UGZmV0VEa2QyQVJCckZadWN5cGJK?=
 =?utf-8?B?N3VoTUNzNEt6WGxRbVk2NUVoek9jdG0xWFZrTUZvQXdJUWROOHRCaFQ0bWJP?=
 =?utf-8?B?L09adFJOWlZNZFhoc1JpMTU3ZUFCVEhSQk5yc202RzFjK0tPc1R3ckhKWERU?=
 =?utf-8?B?c2dySHRXZCtUMGZONUJGZ0szUUtvNkdhSGFENGJGVE50YW5wZEY3dHNLV3Ni?=
 =?utf-8?B?YXp4R25WZkhhajZPWGZySDFsNHAxQUlDQzJyUHJ4dkluZFU5RFRHRDh4WFVt?=
 =?utf-8?B?K0tpQWFINUNmejY4aTAvcjNaRUpuYzNxQmNnYlAyQmVSTmFOUGNLMkdoN1hh?=
 =?utf-8?B?NWZKK2xDVUw3SkQ1eXBqQ0FsUlJpSFdHeGttamRhbm9jMWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MS9mV2tOVWRlVDZDdGU2d1pkdmlrZDJScXV6RHZkR1FTdEorVDdNMEkwU0Rv?=
 =?utf-8?B?clpDbGhjN1l5NmhlbTFYY2lVT01CbjRFVS80a1AvZTk1b1BoNXJ3OWhIbXhp?=
 =?utf-8?B?a25rcWluWkxrRUlHS2w5V2JJaHVicmQzQ3lsNFllbDNyMnhuV1pGVmZpTzg4?=
 =?utf-8?B?dGhqSTREYnhMcWNtRHI1LzRsdjRFckUreXJZc0x2Yk8zSDVCT1ZLQm9tdm54?=
 =?utf-8?B?clY4MTZHT3hxWjlMSUdYN0xHaTVtK3VJSDJYVnlMQjZ3TjNhZGRjVUc2em1r?=
 =?utf-8?B?VEIyNGxBUWwzK3FhVjR3NlBlYXFpa1U0OVlYT0VWKzkvTWY2Z2c0eTQvTDJz?=
 =?utf-8?B?aVlEdzB6U1F6MUNUc1kvVTVwbDB3bkxiM1BtU3lFUEN2WXM4U2IzOXBMMDZH?=
 =?utf-8?B?ZlFaZ2ozbjg3S0NvS2dBWVZLWGFGQVcwTERBTG5JOXByYW4yaG5qTndNcVd1?=
 =?utf-8?B?YWRhTFBvNDlIUCtjZzBLSmlCWTdmWDlVRXpNNGd3SHAwaHp6ZWt3bUQraFpr?=
 =?utf-8?B?VkxWVEpNa1RQWWxSeUdLOTZUMnJVcDAzZEh1MEdPSnhnWC9ndDNCdEpoSlNZ?=
 =?utf-8?B?azdHN3BaOCt3TGNSUEFIV1JmbFV4dmpLRk5UUjRpTzE5ZDlib21adG9FT3Br?=
 =?utf-8?B?UUd6dTFCQ1Q4SCthbVhRYWh1TGZ0enZzV0hlL3F0QlY2WmdVYUxRenkxR3lD?=
 =?utf-8?B?QWRQaEJSTlRKd0ZxakljWnZORlFaWHU0TXVnWTVJQWVoY253VnVOTVhLMDcx?=
 =?utf-8?B?MC9iVWFXU2M5cGU2aGwyQmlGcnhkVXJlZU4zTFUwVXcwTWdWbFE1L3l6RkZt?=
 =?utf-8?B?STNwdHIxNFJ3bGp4em9FbVZKQjVXL21lWi9jd1NtUXpxMkJwUHlQRFpIWC81?=
 =?utf-8?B?bDV4dTBVdEFneXpNNnZPd0J6YkFZbGVUOTZtc29JdkhmVU0rd2JpQzgzMFZ6?=
 =?utf-8?B?ZW1oZkRkZFZXNGtzWmkvNTF4ZUg5TERHWGdvcVZ1OUJPSjI4NWI1aG0vSGlq?=
 =?utf-8?B?a0RTcXVDQW91WjhHVkR3Z0JpSkNsUjdRY09saEtobFJCYStZZGFsLzZLU3BV?=
 =?utf-8?B?aXkyQWZtR0JNZlJ5VDJpb2cyaGtUZE41SWFsS1ptNzdmd3NSSnVvOFdVTlhn?=
 =?utf-8?B?bEJWbWxMV3NLRFNoNWpoOG16ejhQSk52d1lQTVRQM0w0aDBab1U0YU9BWTVZ?=
 =?utf-8?B?R3A4SFJicXpsY0NRMTRkeHFBdG5QTzlucDNIdWZvUGJZdFloVFUzcXVxSElx?=
 =?utf-8?B?MWNUYVNMRXdtMkp2SWNScWt1RGR5YnNZTU90c3F1aytneEc0R1NJZjlpRXdG?=
 =?utf-8?B?MU1PSzYzc0tKZElsUFBaYkl2SmdWU0EvVVEvK1diNGtRWkJkNUthUkg1YlQv?=
 =?utf-8?B?YzBFcDVTajByUXBmMW83cFpXeDIvK2dUWjhheFpVTlprMytKTUhhN1h3Wi9h?=
 =?utf-8?B?VFpMTEpzZFlFaE5yYjkzQnl6bFg3RFJ2YmRkalRJcFI1QjlvbzFJejBYWEZZ?=
 =?utf-8?B?REpNZUppMnpMcC9BYVFLZHgwak0yeU5iYXIyZVVFb3hNM25LaWtQb0diVHBt?=
 =?utf-8?B?QXd1aWxIWHZ0WGZ4eExwbnRXOUxsOFNDWEJubW85Zm14cktRVEJqSWxXVGhF?=
 =?utf-8?B?QWE3TWRyelVoL2tHSGI5dDJveTB4Z2xDMGF1aHBMOUpzRWN0dzNqMVNuV2Yz?=
 =?utf-8?B?R3JJbURlOEF1Qy90TDkyb0lzRVlKNVkwN1pZTTFRenBRSXc0K1VqY2QvWVNO?=
 =?utf-8?B?UWgyak5BR2pFaUlBSndMcVg4QThlTDFUN29Bbms1c1BEbStxRjBFZ29rSmVP?=
 =?utf-8?B?Zm5qcjUvcGNSYzBERUJWTWZnUFJmNzM3ZVVOV0s3ZDdneEZoV1l2VGpoamx1?=
 =?utf-8?B?YXYxbXBtMVJXTFpZZ0dFbVJEVUc5V1BCMXY2T25hMXBBR1AvUXkvL2JtZWNZ?=
 =?utf-8?B?bDQrM1QvTHJLTmNlcGZPdHdWT1BKY3FLUHIrZWFRM1N5R0ZaZmN6M1lwVDhV?=
 =?utf-8?B?aEMxUk9pa0VOdS9nUE1vSkk5L3FxT0syM1RlandhWmlhMG1uNGRZektNWXVV?=
 =?utf-8?B?cEpWRHpJeTZKQm0xaUlqMDFqMWpIaUtBa25nMWVVSCt4WTFKelR6S2drYko1?=
 =?utf-8?Q?9Q+yxQDKKVMZeFwSUBFFPFr3N?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9112666B998AA4449FEDF363875C1020@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a9e91f-7861-418c-316f-08dca298d930
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 17:34:14.2001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMSBEoTO2vkRbj63jdC1wNCSFgUVVQbx8hPuDxnGKztJEvGsOpXP2L/VXFXhiNdD0Ml044UN9yKQJ/RF7rIWwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5815

T24gNy8xMi8yMDI0IDc6MDcgQU0sIERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+IFdlIGNoZWNrZWQg
dGhhdCAicGlwIiBpcyBub24tTlVMTCBhdCB0aGUgc3RhcnQgb2YgdGhlIGlmIGVsc2Ugc3RhdGVt
ZW50DQo+IHNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2sgYWdhaW4gaGVyZS4gIERlbGV0ZSB0
aGUgY2hlY2suDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyPGRhbi5jYXJwZW50
ZXJAbGluYXJvLm9yZz4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBL
dWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
