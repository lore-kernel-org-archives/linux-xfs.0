Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013044.outbound.protection.outlook.com [40.107.201.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D23397E61;
	Wed,  8 Apr 2026 07:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775634973; cv=fail; b=nIEgojYsMyR5xN7m29r/Jes6iIENbF0Tk9nzoCsucBzU0nNC54ANt7D6sYTxiARSDit+9eUgUhg3Yda7jbqGXGHTjAcqxY8hIoaSEVgobUYEbs7nybuF6+Y7SzXCQvWlajBscm/dG64wBRS+Lw26lPDXBJfgfbAChSkLcsn7fpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775634973; c=relaxed/simple;
	bh=ecrldF7312QM8/zxeBUgR9u/rcwYVe4wHk/xLFS5qi4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dTQUbg2eDOS/hy4ZJhn5HziCxSoZMGMhUM1Pa2hyg6y3VpEFfkbaPGnMwrrjn0oc1s5AQj3gzI4epescXrH3KQFE1VmIwADTx0cL4EjH8pN8wOf5XLQUQs7POj8xus8d3omfJ5wPPV4ddP2c4G3pvxDW50ob56m9e+9I6LFfOiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nPrO7XcV; arc=fail smtp.client-ip=40.107.201.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nPrO7XcV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=diItHYelt9NIN7ebv9S4QtXbXU5s6gjYA10iid3XkAScBV99fAAJ2BwE8GBYVkdm/ns7Z+u8Ejs33MOogrw97FXkKFBxlrP7syWM+b0UWghR5ygZQsdNG4JQpLEBcspTG9ervlewEWds4HYLSjatflVjMouAWJo3TeVKSGhpy2eARmi9m0Dm1f3e8iJatmMW/m6tL/SdBMN1Z/hPqcG10l915vblKq6o7b/u/HWYUVoGIJiuPgD7KqzV2mmfcDGNuhS6TPlvHf7ycMrmN6Jjwqdt0JOQVJb37v+KEC3VxrTQuwtvPAmvsLY7JrtGdcQ9fsK6Fy8TX03ya36yhXgYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecrldF7312QM8/zxeBUgR9u/rcwYVe4wHk/xLFS5qi4=;
 b=lHbQn7FVLrVF68OcJJZWW8OhVN00i5Jxr2qcJnVx1F91IXBrrboPHoWMtKRdGkkdLEqZpApG5/63Hu0DBml062EzzpiXDVLac/D6l3bOaOxqzgulhUZozP+YS6wbvOedMLGSDtah2PtbcwsrksFyC+tYrnDBWSe8c09sUAa7hfQTNSi02qeHsVbxAfdY/eoUz/NK6HVkeFoqEsD/KMP2Q9WspWFtCMi37i7PwDs7NLwlpZvPoOpBPWQGDy6NC+jHotO/cKzjLO2wQRrvdWK1Cc+GvOsJ1esUDwmD32kKVaKYF1pAsAeqXVYWxHEMsPHj9b/WRcCJezBpi+U797lRmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecrldF7312QM8/zxeBUgR9u/rcwYVe4wHk/xLFS5qi4=;
 b=nPrO7XcVKwnnTwFIwQdr+KiOVupP2xNQA31bqtq8Ak/rdtbFn3Vxg0r1paBhi5SvIucfLzjAqo7f3WUj0J3vXih+veYU+lX61gHPeBtj0ahmQ0lbWWl0g86WV7wO2frFgow5LhkYJzFOP6sMCoyNRiUcmuICUJ/8OQ/aVoTNMs0aeQ2tCGRJ1iydka1Wf7AwdJ0TXQxRNUJsYB5tJkUu2dFffK9RCJwSYZKy4EiI2VIhTkNG+Gq/qJy4ZBKExYNC4dcHfeoKCl4VbmQsUZQrM6vuwhNckVjF89HVp02jnDiSTaoa3YLQtL9Taet4PYzeD+yWc2VtxFTh2KdMu5AuPQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by BN7PPF862C85B20.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 07:56:09 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::2109:679c:3b3e:b008%6]) with mapi id 15.20.9769.017; Wed, 8 Apr 2026
 07:56:08 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] block: unify the synchronous bi_end_io callbacks
Thread-Topic: [PATCH 2/5] block: unify the synchronous bi_end_io callbacks
Thread-Index: AQHcxpeqkvIty1URA0iPDKIJZZYkdrXUzSEA
Date: Wed, 8 Apr 2026 07:56:08 +0000
Message-ID: <ff65bf57-95db-4195-8404-8a23292859a1@nvidia.com>
References: <20260407140538.633364-1-hch@lst.de>
 <20260407140538.633364-3-hch@lst.de>
In-Reply-To: <20260407140538.633364-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|BN7PPF862C85B20:EE_
x-ms-office365-filtering-correlation-id: b02857f2-0fad-457f-dd61-08de95444b70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 TumuIz5vHts6pliZWoS6G59vqQYTmERA/TJXoGXyYnvbZSGYog9cnxMAEdmcW9j8xXWcNid5ha2jjQr2SWKyoUmb59fh5dKn/iGQhILF8tRug19VpVzeQVsAX4xvANgTC0jZTZJRiTKflwyz+XsBRM06uJAo6LI4CbeaW7HO/ljmS3kpfgkTdjth2krycAK7rLfC0O+PA6MRvKAgQmbKrL1AOx3XbYQ6wXqi458aAtixC8FpYghd8VbG5t3cdiCLIebKlVIKY3YeFomb1INHB5OccIahElPlOphCr/pd8+k7l42e7+Nsfr1or1W0P3fv8hoGqNIPrvjnVkiV9Jpbs9ipDibooPxpisGtimgfgXP2Zgo0nSUwXwDPHN/79udzSmeQarF4oqPiE3npCgqQQAQC5o2PzVn5Qi89qOeJHJYQUJAa/5bU+HPQAXPrcHrIQUs611BUAW4ai/vWWQchPp8ppFNpgt72lvuHO+yI9vkIqfynzixsz+7mEkHqPY9+kGq7Zz83A4YOO8gQmMNva7NHVA7n0H9tPDqJOIyPCUGRcG2DvRRTmG9l/FfEm9WyqZrWRuzO3r4tpHH98obN56CPeirMoqOShofsMYOPsRPBJYIDTlvMTHFH+XazAisEJHiwT44tgRnwY9WSM8SyBYIF9FnEA4TkAL8Bi36xILcL5hcGCyluZ2DNCo/zFMsS4+AgJaSCpKykLarOMCVfDsSu8B+r4WpuK2kydQobIkKjDwW7Xp7IanBV+JX0X625CHrJ0v5ouoD+GIxH0HQv2keXWGQk1BgSH11Ap7rWN0s=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dGNHdHd5TjZ3c0tDeWtLTmdwVS9FNXIyc1Rqd2p5dTcrQTdwYjhiczcyZUxm?=
 =?utf-8?B?ZTN0bitNQnpOVk1udktpT2dKdlBQQS9yWEJEdnUrNURuV1BVbmo2dnVZbFRv?=
 =?utf-8?B?TnNCYm1ZQlBhekRRQlBPMVdDVkMzU2VuTFQvbWY2T2lhcVhEK0hIQVNwaVdw?=
 =?utf-8?B?WU51YlI1TERJdjRuVmU3bWtrdkpYWUIwUDVrejdJUm0yYVJVeG10bWRVbzF5?=
 =?utf-8?B?ekxPV1NscTJ3UVhDd0tJdWFLZC9Gc0ovQUxZVnpUanVINzF5MXh6cHE5QXJG?=
 =?utf-8?B?MEhRYVBXNjZyR2NyVlVHNURvNmRFeXdxY2d6ZHdWRytLZHNKWERxb052dXNE?=
 =?utf-8?B?U3Z2Yk9rbmQ3N0JDR21mdFQraldFMlFvdTNwY1l2QTh0Yyt1N21ZcE9mak83?=
 =?utf-8?B?WjNvV0ZvSmx3Q1J6d09HbG1VWW5rWXU2VFluU1laYmkzdDI0VU9KSTdOeFRn?=
 =?utf-8?B?WEtBZVJDaklkcUFuc3NVZ1lKdCtwM1h5OThzT25iUzVTcFVpdG9CK2taOW5o?=
 =?utf-8?B?Q3dZbEZISll5YURIQ1ptenk1YXpKa29LWUh3OFZWaDQ2SnRlTkNVeUJGYjFJ?=
 =?utf-8?B?aXhzbmtUV0MwU1k3Zi9SL0JSSGZIV2RuNjlxeThiSVRuZk9FemwzM0Jjczgv?=
 =?utf-8?B?cVltbWo3RTFMQ1JEU0k2TFcxTkRwbGorYUFjNWgxWmIzakYreE9PM2twRlRa?=
 =?utf-8?B?RTV1MFF4OUxReCtMcWNUL0VQdDhkekQ2V29JcWF0Y1RsRk1TcmZHK291RHc2?=
 =?utf-8?B?L3pvM2haMml6ODdraTNMeDEybE5TOEpEd0ZIdnNLNFdKTVU3dTF5ek9PZjF2?=
 =?utf-8?B?VkxZU1p2WjJueG5QNUlSMnllMmFHV2pVWGlwTk12MWhTNUc3b1ZUS1JyWEhw?=
 =?utf-8?B?aVowcnFSWnBRYnduZWk0SWlIUlRzRzJGOHcvcW1KeFI3aTAwWHAvUGRQcDRy?=
 =?utf-8?B?bnFMTXpWa1RlcFNGYzZhSy94QWl4K1RwTjhueDJtMlRzZjFmY0t4WTlLWWQ3?=
 =?utf-8?B?aW13cE9qODRyN1p5aXVJRytPSitrQ3I5TGJmOWc4clFXejNDalNqYVNMUWMx?=
 =?utf-8?B?MmdXOHB3Q3R6aU1wZjYvM3g5M1U3VndGMlBzcUZyWGlveHlEL2ZLejhzSzM0?=
 =?utf-8?B?dmZjZkhDSitVZDRqNGxMSDVWRy9Ganh6TXQyM3AyOXlzUStGNTczMjFVbzhD?=
 =?utf-8?B?OWNlU3pTWitxaVBmcnEwYnM4NENJbElQNld4OCtNcWpTSG1rTVN2ZUt3NEEx?=
 =?utf-8?B?WFlRQlFMSDVDZmVxdHZod2EyQ1d1aWNIYjI2czhyVHQydWFidWFhNHBNZWVF?=
 =?utf-8?B?cHNzMmR0bW4rc0pBZ0ZVNDJLQ0NhYjhHVEtWNXJmS3pTUjV5eHI5SVk3Z1pJ?=
 =?utf-8?B?VGZoVjdaMEliNnFmc2I5TjNPcFAzYzU5WGtEWm5RRERoYUg2SHIwYm5aWklv?=
 =?utf-8?B?eVZUV3grVzNzVGUwQk9LL1Uxcm1ZVFBIdjBJYlA2dzd1UEdjd0g5b3RiYlZO?=
 =?utf-8?B?ckVEQitTa0RHMmpKZGV6SXVDQnFkUXBDV2hEY3Z3dEZtQ2p1T0FlRC8xbG9U?=
 =?utf-8?B?OHBuR1FBMmhldU1CejY4a29SdnRWeGY0NXNCRVU3MXVuQjBvSFRpVFZLZHhr?=
 =?utf-8?B?N3dPVStGelFVa1VCNTlUa09KUFFYY2Ewa3FmaWZiZnlxMGIwQURFVzB4Tmta?=
 =?utf-8?B?WEk2SVVvSy9OV2V6amg3ZDhXYjEwbXUxelN2NmRDUWs4bjhXN05aTmluMEMw?=
 =?utf-8?B?MVExaFpSTFUydW5LajF5cmRJTFNNNTNOTS9HTHd5ZnliaHdmTyswVlRlaDJq?=
 =?utf-8?B?eFA5WVNaYS9iQUdhWkVZbHVHWDVBSFZrRlFsVU9ZZHd5WW9OZjZCMGs4VmN3?=
 =?utf-8?B?Q0hWeTJjNE50WFpjaVZRcTgyUURCWHdQUWFHN21aWWwrZFExOTdJWUs1WVNT?=
 =?utf-8?B?a3hjS0tEenhQZUkrSXoxeGZOVmRseVVTV0U0aHJFZG9wOUJYS0Fjdm5idmg2?=
 =?utf-8?B?NDVaUjNGWGxGcTlLek41ak1wcXE0M2ZnUXJhQWx0LzU0Rm9TSGQrUlBWbkRO?=
 =?utf-8?B?cmpObDdhd3dZdndneUh6TVZEMzFYZ3owcjNWZGV3ays0L0JTM2k5dGVPU0NN?=
 =?utf-8?B?THNwQjlWdGZsbEZpUEN1OEJ2Q2M0dVZ0cW1JM0w4Y0p4L1lvbDZKSmtDOGhp?=
 =?utf-8?B?TWRRK3Z4UkxQWW5lL1JkK1BNdjZOKzhwaEZlQmtOM0JaZDVSSmpuaUhkN0tW?=
 =?utf-8?B?emw0NXJacWVlbVZPVzJrQUVScVNmcFF3ZCswTjNtY2pmdERnY290cmYwcHlO?=
 =?utf-8?B?SzRra29KeTRKU1ZXMVl4TGFwbGN5T0Rkc0x1dnhCSk1CeFI5ejNKYUxka2oz?=
 =?utf-8?Q?LkYpfz91JvPVteC+Cmad6so6Ws4tn88ZAk96P1Mm0ONga?=
x-ms-exchange-antispam-messagedata-1: j/Mh7ELbOyceJg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E33D9C97825FA42BC3D15798B4AEC06@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b02857f2-0fad-457f-dd61-08de95444b70
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 07:56:08.8929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZPEMOKgdbjn/4PlsBjOF4wkCntKZeaCdX69HZfHmAcfYLfujHIL4FU+P+MK/ZK46ywgPftrQ+kYkND8o3yuKUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF862C85B20

T24gNC83LzI2IDA3OjA1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gUHV0IHRoZSBiaW8g
aW4gYmlvX2F3YWl0X2NoYWluIGFmdGVyIHdhaXRpbmcgZm9yIHRoZSBjb21wbGV0aW9uLCBhbmQN
Cj4gc2hhcmUgdGhlIG5vdyBpZGVudGljYWwgY2FsbGJhY2tzIGJldHdlZW4gc3VibWl0X2Jpb193
YWl0IGFuZA0KPiBiaW9fYXdhaXRfY2hhaW4uDQo+DQo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnPGhjaEBsc3QuZGU+DQo+IFJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGU8YnZh
bmFzc2NoZUBhY20ub3JnPg0KPiBSZXZpZXdlZC1ieTogRGFtaWVuIExlIE1vYWw8ZGxlbW9hbEBr
ZXJuZWwub3JnPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGth
cm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K
