Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673819D089
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400011; cv=fail; b=pLWvgocQ/DRiv5rsMSHeDYHCZnuNq8C/X5CFMoIJ5hOLOeq0gzxM1B29nKg9xRZmYHZAFAPAdTbSZMj69OaM2Eqs4B8CvpypkC4+wUA8xvet2M1y5YTkVZBkr73aAeTz3I5tbR30VuOciq5HKJle+U0o0KmKuHEvf2k5mMtc9qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400011; c=relaxed/simple;
	bh=2PoeSpbLFHetwGLInHszqZzK5B/sucBuL2ar+1olZPQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jHFjs7GvEPqE5SL/TQ+Eab470OWV9k/joNg2kHyBKnS/abRIkZeijJZDkK66SPSe5FDQPDFFoHV01McOO3dfALXLuoGvVQfJnOHxucTfYcan5BhBOnQBQAV5xYdF33KVkPioZTS07E/hDhc65KfwZiGqVgCxaLB2prNRr6JMQ34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I45mzZRj; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I45mzZRj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xXVI4rXmAEAlGSAVJZzxbtRThPIGfyO/Af0M3ISGOyQOA1mhiNRBB+kzpP+Ye6SznAk7SStIxq/DiEi7UpaIAlpR6lxcMwcvs6o0O1pQq2B4M0R9qT4MmkTxidy36q+0uJAwqJroXnJeJV7ViCV3CvNOTnSzkiLn/iEMuRL8nMZKL8rp8a3yfKupfTdMFJ74rVh9mBHoK+A6iPVldGIHtApyiFCunmxIejprwtLnD/Ofi+Lwh7hirJN3xY3IoIMVujgUEOVo2hoour3gZ4swBFn8sjlQwQzA4aBjBC+4EfWEYm3zjhBcBFBMRF6pUzlKD7ORLmUUAp9VSkMZ6ZrFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PoeSpbLFHetwGLInHszqZzK5B/sucBuL2ar+1olZPQ=;
 b=qCddp5jdWs8HOoXrKs54sVcmgfSxwMFOUWQ4JfKvQtd0Aj/+3+1pvYejnZzWc3JI7ofQTGX/3ynd6JhU1wZBklJGwGAgZNB4thdLdJLZx0iSH4nETep89CjvHj5/kjRx6kL7ulYJz48bKjWEnsMWX9m1Np5Cn/M8eokoqRB9bF3IO3as4lM0yO5mbDyHEyH33UdPzkdJ0bhkGpucvfVLzFBmJ6eWEIW/sK/VtFhwSx/QJhltpxextKk3kvxfSwaKTWzFaSIWHzSVojTRdg8nVFE6sw1LzrDHi2oD9s7Na6gokuGIsLtc7iCKb/YA00FA9et9EE1oJ5Lcf5zKvDpzcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PoeSpbLFHetwGLInHszqZzK5B/sucBuL2ar+1olZPQ=;
 b=I45mzZRjP4rb6LSFf9ONVRoYxOfyDDSQWnEuNJnmhSi70QuDZWCDhVoLTvjWqpxJMXLOI8pyoKWXpIvXIYSlnsB96570peNAXhNfqKtS2cKN5HJuaiXMy4qdb2cv0tn3we1kw6WpbNWQoqyzkoA1KnHnQEMlgSGwv5Mo9itC7OLp5F0YVTKkRaAzXJKvmMKRF4s7Jnj7g3gXjpIOkYI44IXpFQb5SXE8yPwfv8UTca9DjIrWA2Jj+qcxOiGnaXj1ymV+tNHUOaXxIdWKZsGgPT26zUNLZsrn/UOlc7Ht9Q6bAJ6Hp/jUzwdak2EKUD8jeKC0j6at/2d0D/y5shfoEg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SN7PR12MB8771.namprd12.prod.outlook.com (2603:10b6:806:32a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Thu, 31 Oct
 2024 18:40:05 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 18:40:04 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, "cem@kernel.org" <cem@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: simplify sector number calculation in
 xfs_zero_extent
Thread-Topic: [PATCH] xfs: simplify sector number calculation in
 xfs_zero_extent
Thread-Index: AQHbK5YT/nxVy8ih+EyR8Mk5kPRpILKhMW0A
Date: Thu, 31 Oct 2024 18:40:04 +0000
Message-ID: <e9123e05-aa95-41b7-97e3-f3e56ee53c3e@nvidia.com>
References: <20241031130854.163004-1-hch@lst.de>
In-Reply-To: <20241031130854.163004-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SN7PR12MB8771:EE_
x-ms-office365-filtering-correlation-id: 02599fb1-e9bb-4b3b-c68c-08dcf9db6fb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SVdJbzBzVERWa3pjUE5EWmFLaEtReFF4ZUU5NzZoTEhKQThNOERwY2dKdyt1?=
 =?utf-8?B?L2ZHd2pGMHZLcTVnVThnOWovWU50VVo1ZERPMS8vbFdXR21NT1hadzN2UlhO?=
 =?utf-8?B?dE9BTDZqSTk1Q3BDWHZ0em1ycXNtbE92bitVbU5iUnhLbU5vUnJHeWJrZFVy?=
 =?utf-8?B?MWZNbUFLZjNOSFNXZGp0M0N5YVpwaUYxUHVnTDBNTnVMODRZVEJhQmNLbVRH?=
 =?utf-8?B?MGdqQVVZWlFtSUlhS2t0LzB1WDQzeGo1LytscTJ6YWhUcnRvcGlkWHVYaS9j?=
 =?utf-8?B?ZTM2cnU3VHZPUHZWclhGbi9NQUxpa21FdEpqRjBsNGp5UzhHb0dyM0FwbHRl?=
 =?utf-8?B?VXJjMlAwYy9XbXFKejJaOUpIWXlDVGJTczVlYVFDKzJwMDAzY1o0a0hETkRo?=
 =?utf-8?B?RXY5OUhiVGFvaEt0OVArQ2UwWmEyRTRqcnN2bU93Z1Y2U3REcEFZdVFTWWRJ?=
 =?utf-8?B?Vjk2RlB1bk9jRElEbDVFajVFQ1MxOEtUWU4xTzVDYWhWeThnT2dSYzRpdS9Z?=
 =?utf-8?B?WnJsbUhwVng3KzgyL3grSHp4NUMzRjJVcHZlZVpxVFkwSlorNkFlTHNnOW4v?=
 =?utf-8?B?bEt3QXFlY0dUTHUrOEZYSHpqdmovaFZ1ODU1Q0VVWlB2Wk9sd2RlZmJ3TEJq?=
 =?utf-8?B?OFdIRytLUDlZR3hZak9Hc29CaTkwR01nVG9kKzlpclhYY3ZEQ0JlNVNiZDR0?=
 =?utf-8?B?dzh2R1RqVk8wZVhTczlwMGNJL3cxYWZzRnhwWmE0eHpHSzczbWFNZEt2ME55?=
 =?utf-8?B?dldEanRXSGg0eTQ1UTlQMDlLMGRBbVFTdGJuUGw4dmVGMGh1T2QydEt5ci9O?=
 =?utf-8?B?dC9IOE9WK2ZuZk9YK2dsQXpkdndDUm9GNlRpdEpHRGtvOWNFSjU4cEFsamZB?=
 =?utf-8?B?QWZuZkRHeHgrOEhYakNjL0tXY2xmdkVjUHdabnQydlBwbk1DcGZ0ZHlBRUh0?=
 =?utf-8?B?aWoxWjkveXliN0VQL1dUT3QyWDdKM016NXBodXp5Q2x1ZERhWDZEY2UxQ2pS?=
 =?utf-8?B?WjdYMVJQWlpGOVB0c0YwajV3MnR4TDZLanJFdmo1SWN3Mnd6ZmRNMlcwVnZ0?=
 =?utf-8?B?NjlRb2hLdDBmdWlyelgwZzB5WlpVclpKMkMwM2lKNUgyWkl0bk02Vkkvc3h0?=
 =?utf-8?B?emp0MVFmdVE4T2V3QkVoZWQrVWQ2U3hMbXVvaHlJblo3bW9KU080cldKYU90?=
 =?utf-8?B?TXpvNFF2TUdPYVEwdjNMQVlDKzVHTGFJZlN1b1lJc1RDcUl6cVR6eDhZOWsr?=
 =?utf-8?B?d1ptUG9jaUxBdHBaQS9uKzlmRHVYVnNLeGNaZ1RJcDhNeVI4Q2U1MmFYNVA3?=
 =?utf-8?B?dmpTZzY2d0dLdjhXd3Q4emxHRnVQdWVqc0RPbk9vQlVGYkxmbU1zS0xPbWY5?=
 =?utf-8?B?Z1AwTE53T00rMGNQc1FzUmVwVUJ2VmljcnFHbXJFeXNvWUQ0aEl4NXBUM2lQ?=
 =?utf-8?B?M1NuMHJKM3VFUldIMFNFL3VaSFRJWFB2Rndibm1zRjhNUUNRcVJHQ3A3TXg2?=
 =?utf-8?B?bUxqZHE5TVFrRVl3NlNrSXpDT1Y5dHdBbDcvVHM2NXJYQlcvRGljdXFXNktk?=
 =?utf-8?B?Ymx6d25JdFlSYklMWmZaeUtQVVVFczM1SXU2MlR2ZytEbktscVFhNXArREMy?=
 =?utf-8?B?MDREMW9hT05hWXNXQll1UDY3SkRrdkZnWWpDZU9YTGc1VEQ1ZEhZZkV3WGFQ?=
 =?utf-8?B?b2VncUxYMXJtRXlHUmVjVVpNUDN4NVo1TlF0RFBPRDVMMkJIM0NoUUVvL3M0?=
 =?utf-8?B?WnZwLzVBZjhKc0Rac2VCcFlrM0lzbW8yWDZua2JpU0ZRRS9xZDhieXZYanBO?=
 =?utf-8?Q?uh82oSyAfI+LvWNaGxzomzAzjpDL3TGUfacF8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q2Eyb1FyTmdpUWpsUFQ4WjZqdm85OWZnZ050NmtuRHpQb3c3RFNVZ3NVbHNC?=
 =?utf-8?B?dHVlRVNWcGZxdmttOG1DYXgxd04zWjBRVTYyOUtaM25zTlZNTllEZlBaRUsv?=
 =?utf-8?B?cmlQcHpSdi85ZlJJQWFJeDRmaExDNUVRaVVkZkJoU0M3MWlsazcyRU05cFVr?=
 =?utf-8?B?dzM3SFlkTWo3Y3ZSY0pUTXVrdm9xb2g3QTBISFpxQ1NLQ2puWlZ0bVpvd2ZO?=
 =?utf-8?B?Y1RUWUErUVpVUk5XUUUxU0x3ZjlTWXg4OElRK3E5RlU4WFFHQlJtYmxVakpa?=
 =?utf-8?B?c0NVNnlGNEV6OFBqd3Y2K2R2OUhrUFJmLzcrNFZ3WFJML0NROG5PS2N6aHgv?=
 =?utf-8?B?L2M4ZHVVOFgxd1RwaXB2ZUd3d05hc1BLbklWRXNubFpCcHVUT3MvMUxFS3p2?=
 =?utf-8?B?NXVnL0JSL2NoMW5BR2kxc2xwR3VFdFhualFhWG1yT2JpUlF4NkRjYTl6NUNT?=
 =?utf-8?B?WmlxYUJhVis1aDVyR0h1eUNwNzM2RDVOR1kxdlM1QlhKSFVlMkt3cUtmUkdx?=
 =?utf-8?B?QnYrUnpkVmRnMmVVQ3ZnckQranlWY2I1clIrMmRueUJSYy9qbjlDb2FRMlJj?=
 =?utf-8?B?dExwTU81eGhxMk5kNE5Rc2FJVjduQW5sdWpxR2k1c3ZVQTQ2V1FNdkVua0VI?=
 =?utf-8?B?TTkrRlpxWitjbkhSTUU1K0o5L2p4LzJyOFgxVjM1aDRDbDUrZk51VWV4eTZq?=
 =?utf-8?B?dmJMaCtDeSt3eGhaanJNaldXSEtTZ2txNlZGNzZlcmJZQThVYVB0WUg2M3M0?=
 =?utf-8?B?YTBqeFE2bFhFNzBOdExtSXBqalVLQTF3YUNPUjdiN0dodUxXTjNDR3RiMHhU?=
 =?utf-8?B?Qzg4cEFieGZzY0tMdUlNOHVEU2lJbkdrKzU5SzJiTWx3cDV2QTRkWmZUbldC?=
 =?utf-8?B?bVBRN2k3eGNkWGtnNEVtU1B0aXdnd1c5UVBzRThNVzl6SVlWL3dEUUQwenE5?=
 =?utf-8?B?cGVENE1jbXFKclFxNXhia2kyby81dTJHTUdja21QQXQ1OE9hVHFtZHp0M1kr?=
 =?utf-8?B?Q0hMeUVCSzkrMkNNTDhRMjBCRmg4OHdiRm55dHR4cnBYTDVGQ2tlN1RuU2VB?=
 =?utf-8?B?dEdFTGsvRHl3VkNDeFhvenRRQXZ4KzVyeEEzTUtuRUpNdVVKWDdPaW1LQkJq?=
 =?utf-8?B?R2I0bDVLMHNRR3E3OU8rSk1wVUFPOFhRdW10YkdCMURQcTVJYW5OV2RTeFMw?=
 =?utf-8?B?RUZiYkdUOHRKUkdsMlVxSEl4d2xrZUxiMkdGbUlEWlMzTUxidVFJMlBIUmxB?=
 =?utf-8?B?NEk0U3F1UmZ0aWhFWUtvd09RWENvNzZzWFI0cWNUanIwRzRBQjdpRnF3WVlm?=
 =?utf-8?B?SjBoSTAxQzdpUmVrL1N2NU5xbmlyeHF5RXNudmJyQkMvalVoeGJLaHRsUy9P?=
 =?utf-8?B?TVF4UndNLzlKbnRFYkpjRmhSRUJOVmdEYjRXcjJDbjJxSjRHT3R5aW1vbXJF?=
 =?utf-8?B?K3lnbVA0YXo5ZW9zWWo3SnVabzF5T2RheEVTYkdqUVE3Vld1cVh6cUxhVE5X?=
 =?utf-8?B?NjViL09EQWFWcEcxNTlYekhnRXpSMXo1SWlUcC9QekQyMmNSZFhveG5sMUN3?=
 =?utf-8?B?K0lTc1JaT0JDWmtPSDdVbnBvRG5idXRPUlpoNDg2d2sxS1ZWa1FjZ0FMbnpD?=
 =?utf-8?B?c1lJQmxtTmYxaVd0Zmx6all3ZXhOSjc2YnBxaG1iNnlyY0pydFo3bXZxazhG?=
 =?utf-8?B?UXR6V3NxLytGcXoxZ0FxWW44TVIwZEUwUVFzb3ZDalZmSUc4NHNQWFRCaW5C?=
 =?utf-8?B?L3YweFBOd1kyVktyaUppWjBkRGFMN3lnU214Z29zUnhzSEJHN1FrdktEem9P?=
 =?utf-8?B?Z1ZaV2kxYi82akJDQ2ZDRmtZS0pPVEZxU0JLM280RWo2R2dKY2pVOWcxYytS?=
 =?utf-8?B?ZXF4VGtubGp4bGlZc0dUYnhaWHV6M2FxN1l2VlhrckNpb1REUEtYNUFUQ3JS?=
 =?utf-8?B?ZnJRQWRob0hRTkZJUUVuZEFvejV2dzRUUklzazk1MFo1emdiWnpwQnFVNFo3?=
 =?utf-8?B?SGtwMmJGaHRPOUcwMEF3NXE2ZzA2TWlwckdGRnVNM3dMT3RNYWF5Y2JSQkcz?=
 =?utf-8?B?UEp2ZERKOUtmclM3SHZRQ05aMEdpQ2U0R1llc09QZU91NTFubnk4VFZWVlVv?=
 =?utf-8?Q?dwuZfjjj6nsY77hxwedhg/1f7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A59059DC4C646E4B8B7B868C7875042F@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02599fb1-e9bb-4b3b-c68c-08dcf9db6fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 18:40:04.7291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvhvIliROEKIqn0TDFfuxM5k/rzkyl4KtocYsj+BUsQ91xRBIH61rwPWOPvSHIvQRnEAaL8kCVFZanKLGnu3pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8771

T24gMTAvMzEvMjQgMDY6MDgsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiB4ZnNfemVyb19l
eHRlbnQgZG9lcyBzb21lIHJlYWxseSBvZGQgZ3ltbnN0aWNzIHRvIGNhbGN1bGF0ZSB0aGUgYmxv
Y2sNCj4gbGF5ZXIgc2VjdG9ycyBudW1iZXJzIHBhc3NlZCB0byBibGtkZXZfaXNzdWVfemVyb291
dC4gIFRoaXMgaXMgYmVjYXVzZSBpdA0KPiB1c2VkIHRvIGNhbGwgc2JfaXNzdWVfemVyb291dCBh
bmQgdGhlIGNhbGN1bGF0aW9ucyBpbiB0aGF0IGhlbHBlciBnb3QNCj4gb3BlbiBjb2RlZCBoZXJl
IGluIHRoZSByYXRoZXIgbWlzbGVhZGluZ2x5IG5hbWVkIGNvbW1pdCAzZGMyOTE2MTA3MGENCj4g
KCJkYXg6IHVzZSBzYl9pc3N1ZV96ZXJvdXQgaW5zdGVhZCBvZiBjYWxsaW5nIGRheF9jbGVhcl9z
ZWN0b3JzIikuDQo+DQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnPGhjaEBsc3Qu
ZGU+DQoNCm11Y2ggY2xlYW5lciBsaWtlIHdoYXQgeGZzX2Rpc2NhcmRfcnRkZXZfZXh0ZW50cygp
IGFuZCANCnhmc19kaXNjYXJkX2V4dGVudHMoKQ0KaXMgZG9pbmcuIExvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
DQo=
