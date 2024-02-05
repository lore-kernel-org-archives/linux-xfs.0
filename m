Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2101.outbound.protection.outlook.com [40.107.237.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD231CAA4
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707138788; cv=fail; b=j4sdA22/uuq1fczarFNbmEIGN//vDVbRmkoHcUVQHegNoedZf8tTRgYDpG0ywhiVoYjV5RFENnQPrnSIKaf68J5Dd382oODHM2IyLkLcMui6lJoeMrXncRuxpqs3ahyq2VuGGpTN0FJEVaY0iz6tGh8sFsoV07/LndydVfg/J4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707138788; c=relaxed/simple;
	bh=7/RgqavDYxZ719QPFaVVjHXwRpXShnXYX+WcLQlSBqA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UcPxoEJrdhEBKgtaB96KKvpwYbMzuBBPx315hfQFn6GTP9s9R+6TcADkv4N0ix9zrT5iCdxngTcoo+vV+cYi+KBmNFZEWJ/PKwCJ1aSILE75lz1KuQA/vW/c5vn0/7H+lj/cE0jD2PDChoJ4eIKhyUm1TDZLDFy/Dp4c1wUGbxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=datacore.com; spf=pass smtp.mailfrom=datacore.com; dkim=pass (1024-bit key) header.d=datacore.com header.i=@datacore.com header.b=KN2TaZGB; arc=fail smtp.client-ip=40.107.237.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=datacore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=datacore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=datacore.com header.i=@datacore.com header.b="KN2TaZGB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZZt7zyCG/J/AVZp12m0lzOYN41/exLswuNwgmFWz/suOhS+6VKdD5YgbgZh3CsT790g3nTkL+bYVa06Dz346T/9yX/kdLfu7GvIRg0cBJxjnFR+fsyAajHuiF2kgtIGBMe6oP2NA7O1e+6BbvHaDy4i5N6W1ch0QqRTqInTUDnqNvxiXsT1ZFC7ImRWxjhwFHR0qQPOe2QlvFxDvEIuR2/3dzBUr9h69DmW+3650hfZUjrz+6OJUJhlyrDcQI7OSAwXKwqZuBvyJywLTz7tTjQdFGSqiCOvI08aW5Cb4BVJuyVqPMT2hpnF+EACHF1CERvRoac6X9IL/Xiqp9E2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/RgqavDYxZ719QPFaVVjHXwRpXShnXYX+WcLQlSBqA=;
 b=Ua04HdtdYOtWyRcXFDX5Kp++UYg34bWNu69F1akErzzupwNo1b8sq+YvUYIggZDVbtgqSehm+fDMngh2l/2T9VlcW2p6PZ86YDIuybKVIHgmq/7MVC0JTqmwzbbgzd+mUEycoms3yqqrAHRLYITeIZPRraGLagD9PBlT01YkjbJNGo/0RiNyWZE54iuX6QSp+925o2jIQOynh6D18JkY3UW8zkyiBPhWU9NlS11DnhfFPCF5hvI8t7YOmFLDo9JmuetkxN6fXMpOygJjOJtzGiuliR18eY0yoReBUO8kTuGasARqEuEUQ2up+PslRrCoVsfJR42+Qn1XNYA0llVQ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=datacore.com; dmarc=pass action=none header.from=datacore.com;
 dkim=pass header.d=datacore.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datacore.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/RgqavDYxZ719QPFaVVjHXwRpXShnXYX+WcLQlSBqA=;
 b=KN2TaZGBDOEyha94/OiLH2CBhFsFnbqS3V5XB+IWSNDLzwRljJOKciIRTr89HGR7qszPti8gdlyjBEXU2cSdEfKd1Lly5t0ZpTj3F+jGe/JNtLG9WprJrm9ooJFwbn6F2WnLvknRoC9XUMAPf6oZKPF/6XCY6aj2PzoXVqbJgok=
Received: from SJ0PR11MB5789.namprd11.prod.outlook.com (2603:10b6:a03:424::19)
 by IA0PR11MB7792.namprd11.prod.outlook.com (2603:10b6:208:409::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 13:13:02 +0000
Received: from SJ0PR11MB5789.namprd11.prod.outlook.com
 ([fe80::80b7:c950:bcbc:f32f]) by SJ0PR11MB5789.namprd11.prod.outlook.com
 ([fe80::80b7:c950:bcbc:f32f%4]) with mapi id 15.20.7249.032; Mon, 5 Feb 2024
 13:13:02 +0000
From: Abhinandan Purkait <abhinandan.purkait@datacore.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfs_repair reports filesystem as in consistent even on ensuring
 consistency
Thread-Topic: xfs_repair reports filesystem as in consistent even on ensuring
 consistency
Thread-Index: AQHaWDUM3DCtE9ssekCIkrjf7wZvpg==
Date: Mon, 5 Feb 2024 13:13:02 +0000
Message-ID: <B46A6877-1782-4AC7-91FB-F8F3082827A5@datacore.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=datacore.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5789:EE_|IA0PR11MB7792:EE_
x-ms-office365-filtering-correlation-id: 31ccc399-4e69-469b-506d-08dc264c2ea4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Xhe6y7SZQJQBFmnaTkFE2xUIVos3eKMuKR4MpxuzpBVKyoHFjExHZr5FkLeVy9RxmsC5qE9L43Mc4MG5kjnIsI1Od41jbzmWIY1HOnu0BSYX9U8qhFCzHyW1CSLrrYPr4Yanlps/l8o8AokBThTfhIZAruVZbDwc1xqQojax1eqzEwwDw3+bFNSVvgBho9+fZhUdfn4ZHnYRbIJK/Ijrx0dnjQej97q6IByij8Njnspk08bK5cJfKMukFtDMWq2YWQ2gv2xQ9oyZ8saHUBs8y0BrzQpzUZajRFFpFEKDn0IuSPD5nN2wfVkzes7SmzJr/eErkCdtD86ANsczGGndI1o2TJr1n3YKXpqQUwarntUM2/lJ1POCwKwdDG07dPqVFyg+25OqZM5Q26mzcjNaySO5EZztEXoKvOTFWZezh3Kgtz4hFJHMptSKTPV+Bar1ePx5ySYK40DPPfwB0bju6MGlgvDNQsh4okLpB6fHkyGz9SN6TmjxLBpCcfsPmLWcnwjspm3+QKGPUy4DA1Nl/JJ0cabwnVEMHxrJzkHS6Vlf81pxL3v0VUeBp0VcVii/rLXBzK8f+RBvuvoKfBvWt+tjP1E8vUhZAZxUv3GB5opN4z0fS4aQUM3+b2ef0ZVwzhzwTqUCmkmaPCSbrkyYpQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5789.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39850400004)(376002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(41300700001)(8936002)(33656002)(5660300002)(44832011)(8676002)(64756008)(6916009)(66946007)(316002)(66556008)(86362001)(76116006)(66446008)(478600001)(38070700009)(66476007)(6486002)(36756003)(2906002)(38100700002)(71200400001)(122000001)(6512007)(2616005)(6506007)(83380400001)(26005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?d0w5RFBsNUZ5aW1UL21wb0lMQ01ycTJ3dHEzL3dWLzNzYnJZc25FQ2NiL1FS?=
 =?utf-8?B?K1JGZzZ3WWdOR04yVVBJWlpjOEd2djNTN0l5VVZFMUNwZ0U4SFBFdWg2dEdx?=
 =?utf-8?B?TWdvTTlJbk1QQlpRVW9Vb2MrazB5U01kSzF1NkFLbW1VczRjbnRuSmFlV0lK?=
 =?utf-8?B?Z3lVbm1ORGY4citFV3IvK1pZakxzMzA1dUZxL21SMXJnYS90aThPUEpxUFZF?=
 =?utf-8?B?SG5VUTJ2TWJzNWVSTmx2MTRrZ0RPUzNsQVVld0tVMHlPMEFIYVRZaTErNHAz?=
 =?utf-8?B?U0s4V2xtd0JxYTB2Z2N0YTdEQjFwOXdhMWNFTXJmTXpiOFRRK2lLaGVqT092?=
 =?utf-8?B?d0lGVk1rSzMweDhDU1dRMkNYR0o1ZGZ4aDFlSEtJZUgwcy9TalFKaXNSc1hP?=
 =?utf-8?B?aEpxT0twS05kWSs5dy9keG1KU0x4QW90Z1V2MVRTSS83T2RiUU1TZEtSUkUr?=
 =?utf-8?B?bnBBV3dKZ0xTb0k3emYrQU8yYmg4eXQ4TlYrS1lnWWdET0FoYm9SaE1SdmxR?=
 =?utf-8?B?bDVSTmc5bXg1cTJlTnE1ZlFYZEQzeTBkR0hva29DYnpXT0M2TU5RV3Bqazlj?=
 =?utf-8?B?YnV5dm8vQ3ZwMDhQbktnK1A0U1RWYktMR2xiR2tXSk9qa0Y2ejVGZFVReFVF?=
 =?utf-8?B?MnBDMHlsUTRrUC9jaEVEam0zK2d0c3hCVXpaRTR6WG96WGl6a2N4cGxZZEV3?=
 =?utf-8?B?a0FONFlwMUNSbEl4bjlpaDh4SGtqV1lFeXA0NEduTTlDUnBNY3NNU1ppTTdH?=
 =?utf-8?B?NG83Z1ZxUmUzQXFQZWhlbUdDdzV0eUFhUG1DYkxNTzFPV0ovemc2cHdTRU1D?=
 =?utf-8?B?SzArNFhmWTNEaE02eDlCM05hdzRqMVNMbCtLN2JPM3c2YWdsL2JtQTVqTU11?=
 =?utf-8?B?dTdZUWMvMittVFFwUjJ2aVRrZEh5aFpDMUR5eTdnTDRXUlBlZEdERnNBQS9H?=
 =?utf-8?B?TEF6eDJsb0tVU0hPN0U2Q0VSR2hkQnZmbUppT3UwclBqZk1RVmJPdG5zbnho?=
 =?utf-8?B?WDNLMTFQY0xhenU1eVpDNFY2dHJ0Q0x5K3ZFcWdEYzczRXJmQ3FoYlZ5MW9D?=
 =?utf-8?B?cGxKZkU3T1RrOThqWHpWUVQwNHNqSGNKV2Z4ZE5YdXorNzJIcjBNVkdaQlZS?=
 =?utf-8?B?MXpDekZHT3RQQVNnQlhkTVp4dkEwM0piZndBTkJHcThRQWthbFNpYnJYcXBp?=
 =?utf-8?B?SXZzcEVnMXNUMmtYZnQ2eE5ScWlmNzNHOExHdk5Tckx4eUFtR1hCTFJVS0lS?=
 =?utf-8?B?WnpzbjF3eDYvWEZjSXh4d2JxOXZ3MHhwR0ljdVh0SXR2Z0Z1NGIyZGs0aGRa?=
 =?utf-8?B?V3ZndW92Y080QUhZYTByRy9vODEwdDRXeWN4K3JkNU5qNCtmWE44b3ZuVmIv?=
 =?utf-8?B?NlMrM2NreFUzdTRONVRNRnJIeEIySDVLbHJ0cGRudm9YL0MvaUppWU83dEJq?=
 =?utf-8?B?Y3FIMTkwaGw1QXh3WHhZMDVqTnBVMXNrcFJjRmFYSW55Yi9oeHlUVFkrQTdl?=
 =?utf-8?B?U2U1UlRSUHMrOHB5dWhwWkxNZmR1TWVuYk80SDNHTzYrVVgxbDBJS2UwREZM?=
 =?utf-8?B?TVNHaHU0eEJubGV6NWNYT0RFSFpFUHlCTFVJeTFnWXZXbzN6ZndNTmZTRjZV?=
 =?utf-8?B?NVZRR2NBdHBpZW5oSTdvKytCS28wM2d3WEZTemovazltdk9FM1NrYTlDMGlP?=
 =?utf-8?B?cE95KzFxNVUwcDhRRnczcmR1Q1Z5Tlc2T2hHdTMwTFdLd2tsejlUT2NaMDVH?=
 =?utf-8?B?ZHVsTm5OQ2dabXI1QmxHS3NsTkN0RzJtSG4xNkpNTTJqWTQvZU1ZdjU1aXk5?=
 =?utf-8?B?M0dvYU0yRVhkTmcxZTJBTmNlaXBKS2JRdHBpemtSZHgra2hVTEpna3k4NnRh?=
 =?utf-8?B?N1l3NXFQQzNyOUttM0dYalp0WSsvN010dFRidngxSTdwRzlibU5aeFQrd3lw?=
 =?utf-8?B?ZC92ZFBVMVN6MG5KOFVsZGZHVUs2SXcyUElTZHJlNWppaHl1bDllZnFjM3hI?=
 =?utf-8?B?RWhXM0svVzE1eVJVcFoybzFWejB6Y29mQ2FjNUY4aWdDTjZKaG15d3E1NXpm?=
 =?utf-8?B?MHJzRWMvajk1aGRiQTM4eWoyQlNYcStlMU1MVG52d0M2NVpXU0pwaVN3bFRD?=
 =?utf-8?B?R2dKR0Mya3lkWk1zcUNsa3RscDQyL0NJVDk0bXAxTGdqV3kvLy9GMDJnK2dL?=
 =?utf-8?Q?ZMrOB6unoE4Qyk5Rl16za3o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD67FD4FCA56234EA2C2F8768048C687@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: datacore.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5789.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ccc399-4e69-469b-506d-08dc264c2ea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 13:13:02.1340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7fdfb85b-a737-4b5e-b8db-82fae44d92c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZdbN13cKykcaYp1nPWs/uJdQCGhLqfPyHkDwWcB9DeMp+MWdIS/zVhj/PNMKekSvM6VwsCWK3z9i7CPuKDEYDviKk/RoFYGS1GYsOE3j3PI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7792

SGkgeGZzIGZvbGtzLA0KSSBoYXZlIGJlZW4gdHJ5aW5nIHhmcyBmaWxlc3lzdGVtIGNvbnNpc3Rl
bmN5IGZvciBhIHNuYXBzaG90IHVzZSBjYXNlLiBJIHRyaWVkIHVzaW5nIHhmc19mcmVlemUgYmVm
b3JlIHRha2luZyBzbmFwc2hvdCwgYnV0IHhmc19yZXBhaXIgc2hvd3MgdGhlIGZpbGVzeXN0ZW0g
YXMgaW4gY29uc2lzdGVudC4NCg0KSSB3aWxsIHdyaXRlIHRoZSBzdGVwcyBiZWxvdzoNCg0KMS4g
SSBoYXZlIGEgYmxvY2sgdm9sdW1lIHByb3Zpc2lvbmVkIGJ5IE9wZW5FQlMgTWF5YXN0b3IgYXMg
YmFja2VuZC4gTGV0J3Mgc2F5IHRoZSBibG9ja2RldmljZSBpcyBudm1lMG4xDQoyLiBJIGNyZWF0
ZWQgYSBmaWxlc3lzdGVtIG1rZnMueGZzIC1mIG52bWUwbjEuDQozLiBJIG1vdW50ZWQgdGhlIGZp
bGVzeXN0ZW0gb24gbXlkaXIuDQo0LiBJIHJhbiBmaW8gLS12ZXJpZnlfZHVtcD0xIC0tYnM9NDA5
NiAgLS1yYW5kb21fZ2VuZXJhdG9yPXRhdXN3b3J0aGU2NCAtLXJ3PXJhbmRydyAtLWlvZW5naW5l
PWxpYmFpbyAtLWlvZGVwdGg9MTYgLS12ZXJpZnlfZmF0YWw9MSAtLXZlcmlmeT1jcmMzMiAtLXZl
cmlmeV9hc3luYz0yIC0tbmFtZT1iZW5jaHRlc3QwIC0tZmlsZW5hbWU9bXlkaXIvdGVzdCAtLXRp
bWVfYmFzZWQgLS1ydW50aW1lPTYwIC0tc2l6ZT0xMjBNDQo1LiBOb3cgd2hpbGUgZmlvIGlzIGlu
IHByb2dyZXNzIEkgaXNzdWVkIHhmc19mcmVlemUgLWYgbXlkaXINCjYuIFRvb2sgdGhlIGJsb2Nr
IGxldmVsIHNuYXBzaG90Lg0KNy4gSSB1bmZyb3plIHRoZSBmaWxlc3lzdGVtIHhmc19mcmVlemUg
LXUgbXlkaXINCjguIEkgbGV0IHRoZSBmaW8gYXBwbGljYXRpb24gY29tcGxldGUuDQo5LiBOb3cg
d2hpbGUgY2hlY2tpbmcgdGhlIGZpbGVzeXN0ZW0gY29uc2lzdGVuY3kgb24gdGhlIHNuYXBzaG90
LCB1c2luZyB4ZnNfcmVwYWlyLiBJIGlzc3VlIHhmc19yZXBhaXIgLW4gbG9vcDgsIHdoZXJlIGxv
b3A4IGlzIG15IHNuYXBzaG90IGZpbGVzeXN0ZW0NCjEwLiBJIGdldCB0aGUgYmVsb3cNCg0KVGhl
IGZpbGVzeXN0ZW0gaGFzIHZhbHVhYmxlIG1ldGFkYXRhIGNoYW5nZXMgaW4gYSBsb2cgd2hpY2gg
aXMgYmVpbmcNCmlnbm9yZWQgYmVjYXVzZSB0aGUgLW4gb3B0aW9uIHdhcyB1c2VkLiAgRXhwZWN0
IHNwdXJpb3VzIGluY29uc2lzdGVuY2llcw0Kd2hpY2ggbWF5IGJlIHJlc29sdmVkIGJ5IGZpcnN0
IG1vdW50aW5nIHRoZSBmaWxlc3lzdGVtIHRvIHJlcGxheSB0aGUgbG9nLg0KDQpXaGF0IGFtIEkg
ZG9pbmcgd3JvbmcgaGVyZT8gSXMgdGhpcyB3YXkgb2YgY2hlY2tpbmcgZmlsZXN5c3RlbSBjb25z
aXN0ZW5jeSBpbmNvcnJlY3Q/DQoNCkkgaGF2ZSBub3RpY2VkIHRoYXQgZXZlbiB3aXRob3V0IGFu
eSBvcGVyYXRpb24gdGhlIGZpbGVzeXN0ZW0gZ2V0cyByZXBvcnRlZCBhcyBpbmNvbnNpc3RlbnQs
IGZvciBleGFtcGxlIGlzc3VpbmcgYSBzaW1wbGUgeGZzX2ZyZWV6ZSBvbiBhIG5ld2x5IGNyZWF0
ZWQgIHhmcyBmaWxlc3lzdGVtIHZvbHVtZSBhbmQgdGhlbiB1bm1vdW50aW5nIGFuZCBydW5uaW5n
IHhmc19yZXBhaXIgLW4gc29tZWRldmljZSBhbHNvIHNob3dzIHVwIGFzIGluY29uc2lzdGVudC4N
Cg0KSSB3b3VsZCBsaWtlIHNvbWUgaW5wdXRzIGhlcmUuDQoNClBsZWFzZSBwYXJkb24gaWYgc29t
ZSBvZiB0aGUgY29tbWFuZHMgYWJvdmUgbG9vayBmdW5ueSBhcyB0aGUgZGVsaXZlcnkgc3lzdGVt
IGlzIG5vdCBsZXR0aW5nIG1lIHNlbmQgdGhlIGNvbnRlbnQuDQoNClRoYW5rcywNCkFiaGluYW5k
YW4=
