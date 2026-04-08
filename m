Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7020533F370;
	Wed,  8 Apr 2026 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775635024; cv=fail; b=guKocFCEajLTCPmISFTHHtoLDzQYsYfUKZBdzeQ2Eo8IDdSwatUNialE8/sg97xUA5U90riE2wiqm3E6VaWOHn3uJttwdRyYdfuGo4V4a0bV6Ni7swh21MFh8DCvFJw9BoIEdX2zxuxBBlIsb31t/Q2vYL6KqwcVmreXTfkmPMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775635024; c=relaxed/simple;
	bh=mHxBLP48Q1NdRx7Cw3h/U6/EB1rbn3wQz4OzRFuqToo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cnlFbbokEGdLJj/ILHiGwGWu6o421jDICRCb8EHAdEdHPMwHD2xWj8FYuHziK3ERLHrbuxv6A4wCY14sMw7pl1XP6ERB3VDK/OTHoOA5hp1AKtWp91Mvi0TsXdyY9yCeY0Ew+SveII9Tyu+++DxMriunQ7BVAhnA/igl6M8Ybxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PnWlcYQR; arc=fail smtp.client-ip=52.101.62.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PnWlcYQR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTWeTB76uHtVD9YAbyUknzvW8bHaJhoD7mi5gbB9liwXq3Geu/7EAZngvvVEU4JPxMz8O3kLoz3p3L57+tTj5oGdmuzBo4wgg1IGERxyixGQSoanh8GJLRuu4bFzMRJIB1tDV2iydIDn8i/9cdoIvuUsPjwPem4T37AlVK3UaH4uX0yCJsKlO20hlkoKbJb5nvqgiHmOlptXcRJRw2lnVwr6e58S0s6qCfW3ajGzg2osWqyYtSVpauGVhpmTWsYBtGSDjgN1ridi9E+S2aflPnCZkKizYQpD5hsx3eV32ldfQgIH/2qz1BRvD82mXkUmFeQpaM8Dxa9t2QBQKwk4kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHxBLP48Q1NdRx7Cw3h/U6/EB1rbn3wQz4OzRFuqToo=;
 b=JyvHcjWxzaUYNulsesTs1DoItRpuoDrI+OMXynSZDGkCUnSulmG0KCe8ao7RBs38euFiuBbO61TTmEoRbTZnVbeQyMbqYQw8ySvFh3FTSLtRfqS8GpaNL77afAhPo62Yx1CKJJIzY5gIPCkgWHcBFr3HxPbXOXzWxSh3C9UQIbsGcBDWg2BqYfQUZQ9liqp9SO/H45EOrwGiJAlCo9bxO8ZhLQLKwrs4sirjnuAAiPKzVu4F3dgYeEo1CNqocgxo8htLalzAB6zaxqNr83cW7E2l2RYyXAHhoDvPRqKFIe0HCWG/+mng9ONR05K06/QeN2nsLhiR+YMMBFpu7XZ1eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHxBLP48Q1NdRx7Cw3h/U6/EB1rbn3wQz4OzRFuqToo=;
 b=PnWlcYQRlddZTX41YDEzG3tH3oW/i85frqNxqjhZmp1ymRwaenfcJT76ntf0kWJ5NGUpY7R9R0wVgH70aas5qSdb8erDcf5UkV9oua+yHD3Hiio430gv6kjQ4Prk5LG/CqFDNziVOKqClz/vlSiqd6fHtFGnDs1xuI9mnjaqIsBVDjMzKx8G5VqJCGPKhZ1cnHu5s7UFxV0LY3y1Kar04rKxdzwrShr1dIp9pVBJISMdqz8eHjbEudZGf9MZD9enKG7zi68qb4ElYFE1xtfOCOMWqi/vUbyWuDx4IX348bRCy5iwq+Hy8BmdZr++E9Tyivo6zYhKcP53n2YmCk3JQA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by BN7PPF862C85B20.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 07:57:00 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9769.017; Wed, 8 Apr 2026
 07:57:00 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] xfs: use bio_await in xfs_zone_gc_reset_sync
Thread-Topic: [PATCH 5/5] xfs: use bio_await in xfs_zone_gc_reset_sync
Thread-Index: AQHcxpf0nt4sX2CLI0+td+upKD1t/LXUzV4A
Date: Wed, 8 Apr 2026 07:57:00 +0000
Message-ID: <ecf011a9-fb2c-4990-ad9a-5d3caae9759f@nvidia.com>
References: <20260407140538.633364-1-hch@lst.de>
 <20260407140538.633364-6-hch@lst.de>
In-Reply-To: <20260407140538.633364-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|BN7PPF862C85B20:EE_
x-ms-office365-filtering-correlation-id: 8be15453-ff5b-4c85-575c-08de95446a52
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 K4RiqXX3663R/By0dEJUgSzRCRlZv/WE4oorBva4UzK7hnSBgT6W0mz6bpJiNq5K4ttT8usDXF2eUBK7LlYd/vt0+55gdpMHSFjnGww68365mHpTrNnHIQWEP5jM1CZVdKyFkxb8WjcE1Ht5MmLHWEZfIZDXne/hfsxTAuwdXEROEt/adbJGZg1bq5Vj8TJz4hhvDyJgZ/hmqtJzeDPMlL5kQfB6bgG2Tp1L2uWvgx12G+rgWrWo71WSiiOoy8lXS7bHbv1IUmcgNQf7dlrE6mLRTyomOThbC1M93d/KTIz7bwZjzu861UDa8+Nu+xtn2QJcgynfyF91Al5/qoJ21fHA3WW4kUE+thSWaFiflfWO5yUcnTdUah6SMaGLMy2waP89zMKhVYndaX78quHy5QrcxlFD/owWxGR+RIDj+YIYrVbXcIK4NMbXQujdx8IecBJusJcBuC/l46AS5SwbEHCpD6IaYI3aYRN52IYmHvpbIG4Ejn7DDVqZW1EhQTyAK+/DHfeAneZduIXfbwlYd3ZnMaW3luB/+Hs77MFHefuXSAbocO7h80ORGaX3jY2iQMuZWgzX4t+FScLhkVG3Ur4YDc9XA3ig/MBmKcW/BCxiU18l1RkLDZsZia5SgPVgsyE88dPDXya40exfs1Z3hR6LYdWJuKC1iN5SZtVRT4y8xtkomYebcHZiucm5D8KborlmBzXe/vnL6mOmA5I3u4YOVkBb3p4g5zvT+duNw3SNpaWbClMdket335UzBC3LCbJ5BvqVxXcPDkoMwVof9OZsuhJv/NCAyB2mTMe31WE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T0pkN2E5ZFJyOFhIL2RUYW03WXZYQy82aGFKUHRMeUpnZHBqb3B5YWlzcklN?=
 =?utf-8?B?a29vUzlIKzZpN0RIZXdQZGtTeHZycVVDU1IvYjlwaDBmUE8yR2lHTmdQK1pV?=
 =?utf-8?B?NVFCRWRBQmdvWXhYc2tYMDFPWW1UazZKMXg2NUNaWlpScGdzakcwZmRKY0Qx?=
 =?utf-8?B?K09mSzZpNXhHV2IrUHZyQmZMSWY3aUZtZlNzc3FObzE5c2JpdTRtTE95UnRN?=
 =?utf-8?B?amdDdFl2UXl0cUtleW8zV3Ezd0NNV2JwMXhjTWVCbkpPR1ZBSWJXMEJoS0NH?=
 =?utf-8?B?UnNYK2IzbnZodGFFeTVhVzhCLzAzTzBBY0VHN0VHKzZQMEtOMEZuNEloM2J0?=
 =?utf-8?B?VVlVaFhoNEZOc1hsdlE2SzB4L3g2d3hnTFo3c3B3bTdpVC9YZmVaVjJtcFRW?=
 =?utf-8?B?Zk1DUGNhSkdYazd4YkdhamliMHRmeTlsTzNLMzI4ZXhJWCs4aDFoUVprV3Yz?=
 =?utf-8?B?cUdEeERiUjlCRXQyUEhXMlh6WWpXYnIrY21xNUpXMHZ3dUVjUktRVjRlU2Ey?=
 =?utf-8?B?WmswRkMwcnpsbGoyWVBhUmNjZGtCTDJkbXFEbzUyS3BpWUhoSGZJdGd5dWxW?=
 =?utf-8?B?NXB5ZC9EQUJsU2RRUkhLQnF1SG40RUcxQXMwS1NTeVNIZndsNkxkOWprMlRj?=
 =?utf-8?B?eE9DM2VoSWJaZGxwa2FidW5UZWRQVHFvUDJsUXB2UklwWnNIWTFJMFdUK1Zz?=
 =?utf-8?B?OWRRejFQZjR0SjFqQXE3dldFWDVqMWlkR2dMQS93bEhOY0wvWXBML2w0aEhD?=
 =?utf-8?B?aEpWajFDanBOUmsyOThESUJvR2ZmQSt3Zi96VmpJVmpsald3bHhhRmwrc0Fv?=
 =?utf-8?B?a1JkVklna0Uzci9IREtLdXVQK1p3SmlnWVpTZXUzQXR4NmxDYjErUGZmZDVl?=
 =?utf-8?B?ZnlTZ0VaZ3pWUEdwOTR2NGloNVYrYjNzbnM2czg5MHJZQmhPZ1BEL1hVTTht?=
 =?utf-8?B?OUJ5d1p4M2lKUVVpQUZaM1J4blNFeVFYcnJVOWkzc0IrVEI4THh1aXR5c3d5?=
 =?utf-8?B?YUJHMEk3Q3pNaGFWMzZhNTIwWGJoUkg4bk9lSmE2akowUTFPQkZTSURkYSt2?=
 =?utf-8?B?dkxFclVMZnkrdG9QWnZWc2VyUUVIcitpN0FHSEZtRkJjb0JEVHJNblBoWDEx?=
 =?utf-8?B?ZFI3QkwrbFIyakJmajF4eWtIRXlLSnpiMTlPNHBxaTVhSHpmZzFVYjVKOTg0?=
 =?utf-8?B?OXBKSWVCTXVmNWd0QjF3VTFxaUh2L09keEhOdDNQVzlSeXR3N21TRDBnNGZ4?=
 =?utf-8?B?SWtiL0xWV0FLSEdYNlViekc5KzFiQ0FRWkVReHJLTHB2Z2tsbUxPR3NvOW5w?=
 =?utf-8?B?NmJGajVjSisvMnFpekRNbFdMaUlYOWVYRmNkOEVEa0VFUG0xZEttT0syTW1m?=
 =?utf-8?B?bk5kZHRuaDdvMktJVXAwTDZtK2dHNTAxalZDb0htYkRKQksyMkw3WUFaOG5p?=
 =?utf-8?B?QmJkQlZhNnZ4SGVPbUhHa255azZ3Tmc4TXNEN3ZTWkR5eGJVMGphUDJDZ2ow?=
 =?utf-8?B?Mm5YVkFHRDJUdzEvUkloUUxhNG1jekg4VjBxeWhvSHZtQVcwZ2pyUjdrVXl0?=
 =?utf-8?B?TFd0Mm9UQVdTck1EYXlIQWcvMzFDSFhqc2Ivam9Tc1grVGRHZGNmQWlBK216?=
 =?utf-8?B?dEUvYk9RaUhaSFpwakkwc05yTXlmMFpodmV4K2xFeVA4aG85dy81dzVpN0t6?=
 =?utf-8?B?RFl2Rk9lTjdTaDR3QTJ6cGIvOUtCS3pBZ2RXU1RhU2J4S0VFb2FHZFhIMnRt?=
 =?utf-8?B?NExMTjFvZFVHV2dKZFlpTURxbVZCL0NPQklXNm5aN2VwNnN2YnhTWlNNSGhI?=
 =?utf-8?B?UG9QUE1wUVREcytOcmRXSUxNcDRvT09PdCs2THdOYlNnUW0vTmhpZzZ5UHZx?=
 =?utf-8?B?VkxjUGI0UFlxSkRaUHdjUVVoMmYzNkt6Q0NuYkVBSjMwbm5na2hab0RLUmdw?=
 =?utf-8?B?dkQyZzdNamx5d2E0TjBtMVdRd0tWR2pESGNVKzBPRXJGQnpXN0FvWC9Xcnph?=
 =?utf-8?B?L3NkOWlIa2tzT2R1Z1pVN3RYdGlIc0hoZDFxVnlKYkN6OXNCd21BU1dkb2pq?=
 =?utf-8?B?WUlUSHBWbnp0ZUEwdWN0eTRTVVgwQ3JtMEhNZnhQL3hlWHZMSTYzd1RkenEx?=
 =?utf-8?B?RlJkczVaYWptKzBoY1JZZnBtSFNvZXc0M08vYUlTS2x2Njhvc3pZbmpyYUZN?=
 =?utf-8?B?VXNtU0lXMHRkNlhCaEw2b2R3d2Uya0loeGZHL0tNRzNsNnBuOFF0YVIzM1lj?=
 =?utf-8?B?eElPOTBkYVNtME9CZGxaZnVsVExqT05aWEF5bFVSaFVUaGtPYWpuVGM5eG9Z?=
 =?utf-8?B?TWRsaFhCNUwySnVScEl3Nkx0V05XNEF2RFFXRWRRN1NPVW9GYitXTE1yRDVX?=
 =?utf-8?Q?c6316d2sxHxd9U0d9ZH4pP0orqd42SYZmXM+NKeBggCtf?=
x-ms-exchange-antispam-messagedata-1: 8898qjAY8//1cw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C144CC75D80BA94AB57DCCF2CB7B66CF@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be15453-ff5b-4c85-575c-08de95446a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 07:57:00.6671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I7offxMr2MGpPAFZpcZpE9BES6SwZS9OG6WTcUcjoiWt7uCOW5GBbxKcr/+fiBjncGRdt3wFLbrzVrn/cF3HZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF862C85B20

T24gNC83LzI2IDA3OjA1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gUmVwbGFjZSB0aGUg
b3Blbi1jb2RlZCBiaW8gd2FpdCBsb2dpYyB3aXRoIHRoZSBuZXcgYmlvX2F3YWl0IGhlbHBlci4N
Cj4NCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWc8aGNoQGxzdC5kZT4NCj4gUmV2
aWV3ZWQtYnk6IERhbWllbiBMZSBNb2FsPGRsZW1vYWxAa2VybmVsLm9yZz4NCg0KTG9va3MgZ29v
ZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoN
Ci1jaw0KDQoNCg==
