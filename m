Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B849C19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 03:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiG1Div (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 23:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiG1Dir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 23:38:47 -0400
Received: from esa18.fujitsucc.c3s2.iphmx.com (esa18.fujitsucc.c3s2.iphmx.com [216.71.158.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2346B98;
        Wed, 27 Jul 2022 20:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1658979525; x=1690515525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BKhUlQ6b9O/VeB5vGIjXF4IjA/iQ2Bghh4fanhgWgus=;
  b=TiYjwYq2NoRAjCGy5dV9S4mxsHNu9aF0SmaWzNjpKqMsspzmD2U+6+iP
   LmDy6O18VcKy4OzDb2EDPI/4ETeEx4sUfGLfdApn5LDnQICoDvW7IhHgK
   MZxPkQWvDr2SsZOA6Om47jlbwxLe5dRsmwxXhRKSdmE8zIyW+zguF1OT8
   VueuTxhcJWe24NHaXnajqwuY4O2qKDQwAkeLMfkSsTmLFakK5dhhrxikz
   Thv9pvGx4tks1VTieQTbNskJhHhPgltpDTSVdrODITlaOlniPAIMxTJep
   +Kr5vKrICnpkv9G89sMlpbI2HT7CzRUZwAJMQ0zSt9IfC91bSfrOJ8X1q
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="62972719"
X-IronPort-AV: E=Sophos;i="5.93,196,1654527600"; 
   d="scan'208";a="62972719"
Received: from mail-os0jpn01lp2110.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.110])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:38:41 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzaWNPpqsr+gNrwE/ERBoVaABwIAF4aKRjjuEAlGqk48ao03bxuf6rZ78i6y3CJHkiHj3X5KOrrDS8vV5oPm+1aWUPgW5zvrenadns/oPD8Rd9AMla1+DHpw/GFw+21IdxVeBTAeXd3b+3UatL72MnOQok3SJ/cuU+mleV/K8++TQmgRdBZ161CSDhSZmA/FjoZjir91M+xbF6lFr1P6kKM7kF46i7LjgVZiACkhuGm6VFa/KIvIILfYSUYwm3wNZ+sD+iZRaSuYvhnNqPKVVl4JjRWcl9tBLDUt1eY7xpZN3NVUvfKEYma6RESqK5kUMtxgBU4u9TmPmDwTEMSUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKhUlQ6b9O/VeB5vGIjXF4IjA/iQ2Bghh4fanhgWgus=;
 b=LhP29aR7QeLCYjDhBB+/6Gxo9RSNQgtAgMZMexLmn7Jqf0QJu+Yzt5P8m9UHKT7og76KiBlOAbi0f6/rUkFVI53QFIi3QnVpsuVWi4er9gDZDWDc7GehIxfrBL9sKCBpQ9D6MgfWn33QM5EZbCMcvP12/zskla2eC+9mocAcOjQ9Qq/cDfDYlN3CmrCZOMHlUY8ZgCMMxKCuDIVqdRfTWSMShfKs6PRXLNZwATzW7NBSikbHOwK4gjzvxyE4bgbV5eTKPX+j3x+kv3DYid7dS4b1bclbcsWz/ltvxHjJJQaK6t0ldDeZCIpecr6WApugeUf9UBAV0XuGcNi00J7/Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OS0PR01MB6481.jpnprd01.prod.outlook.com (2603:1096:604:107::13)
 by OS3PR01MB7995.jpnprd01.prod.outlook.com (2603:1096:604:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 03:38:38 +0000
Received: from OS0PR01MB6481.jpnprd01.prod.outlook.com
 ([fe80::ccd:ccc6:1a42:94cd]) by OS0PR01MB6481.jpnprd01.prod.outlook.com
 ([fe80::ccd:ccc6:1a42:94cd%9]) with mapi id 15.20.5482.006; Thu, 28 Jul 2022
 03:38:38 +0000
From:   "liuyd.fnst@fujitsu.com" <liuyd.fnst@fujitsu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "zlang@redhat.com" <zlang@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Thread-Topic: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Thread-Index: AQHYiy0iU/1u1BnWYU+VNSIpIwfG7K2TLs8AgAAQ8ICAABEEgA==
Date:   Thu, 28 Jul 2022 03:38:38 +0000
Message-ID: <45012000-087a-e98d-7322-4f1079bbb1d8@fujitsu.com>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768327.1045534.10420155448662856970.stgit@magnolia>
 <3f63e720-c252-a836-b700-7a5739312b1b@fujitsu.com>
 <YuH2h1DiRm8r3p2j@magnolia>
In-Reply-To: <YuH2h1DiRm8r3p2j@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b322a2f-6d3d-474c-b7a8-08da704aa87f
x-ms-traffictypediagnostic: OS3PR01MB7995:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tZmW3BkVNWxrSmlMKfF4oIuBvKBv8SoFC97VvqArJ/mdQhPHgdNKF4Wp6hB9APQafoAJ88ZlNp9qkYIq8uDgIWJMXpyPP83nF8z9xgNL+Np4LWwRMcVIsYuvzgu2xJykpOZeqmwpj4gtLPipN8/cQQ4WhoLOz+1vkx4qLRHGy75bT1sf0H5oCRGGR1mj/0lho5HKpjqgbp7hSz62o3/1x+YAaWA6HiohVwGj2eU9lg7HVuIJJBuVUg1szA3IXFQlEmewc9vUKutBy19r7j08uQ0c+5SNG3j15I978uCs9TcEGEIOwFeEhE5hn5cM0TFHd0jlgYya6ZDAebOGBSPYp1f9CNS06bEje629XRiAksY3O/mm3Nem4BTc1Vl2ZGpwpuRMwfhTPnhyFaaIm1EQJaVdxHuR6FUJd9I3rsxvTDMjanC6fte6HMqyyeg1VD3NRmEYYPto+HQPJSeEKVjUz6qMWqhPRPDQgzmICH+SExDhHlUsXB9ekzKKlqYz+IXlepx7ZcOPkSXK1tY2NhpedaZaVBpuxwKdyxbgK5tBl3sJsBtNHQH9XcU4c5jm5UwBtiec9ilxtEv+pRtJLS2XbZYtEK2oVtJTeIzZm8I3WszkMCBrt/oJPvuJ5LYwv1VgXyv771leSs+bcpgC8Z1M725iAgd2sgXn0COI4FSzAQPsRW8toczn9wHRpvUUFy/wFzhrtghNZfu7qkcoa/pnMY8jDKYlsNCvE7vAQGdq+Fv3KnvJ9DhNwoICh5l0r3Mq4s7MubE+zHFnYeLe5Dlt8w0h9lnVHFNlWp/ypopaQU/Bq7yUd1axeyReuR9RV+VkETK9y6EvV5J9GEz7Z8UoVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB6481.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(2616005)(31696002)(82960400001)(91956017)(85182001)(83380400001)(53546011)(38070700005)(86362001)(26005)(31686004)(6512007)(122000001)(186003)(8936002)(36756003)(6506007)(38100700002)(41300700001)(66446008)(478600001)(2906002)(316002)(54906003)(6916009)(71200400001)(6486002)(8676002)(66946007)(76116006)(66476007)(64756008)(4326008)(66556008)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkFHUzVDUzNIODh2WER3WitYWUYzcyt0NlMza21uQnh1YkZ5cXhuUU9uQksz?=
 =?utf-8?B?eGJVcy83T3NZQkxwbFlqL1hLcFNSVnF3UnlUcTlRcEo4OXRLVDFDdnU4VXln?=
 =?utf-8?B?aXRHYjBaU0NaZzg5V0c4UEQ4dXhqK1hEUzVWY0ZpZDN1dFZGNEVPTDV1TVpN?=
 =?utf-8?B?cFlWY1FlNFVEV2JWaklTb21WdTBaUG1XOTlLZWtlWjB1a05nYVNkQXd3TC9l?=
 =?utf-8?B?YTEyNDVDaTNybWh5SllLLzhhVXZETlhIbjltR0hDYkE5ckNmYUhOd1BTRER0?=
 =?utf-8?B?TklwMFFRdnZ1VVdXTXdzZ0dtelFqcUYxSDlSRGN0cnJ2RTRSU3pGRTJBS0k4?=
 =?utf-8?B?OVRIWXBZT2I2dHRUTWlHTXZYaHRsd21LaGZDZjJTRWZQam9KbWx5MVZTZzBM?=
 =?utf-8?B?ZEZLcFZtVERxYmc4NEc0Mlc3R1gzT3VCb2IvRHIxZS81WmRub1RPaml4RTFU?=
 =?utf-8?B?Y3NnWnFQOWZ4ZGdQUzY0VUlUQzROak9OemJONnFWWmxRSE9BRXo4K2JHY1dp?=
 =?utf-8?B?NURHRUhuYmRtZ0dqT2ZQTTNkSGlGbEYrSzE3Z3U5N3hJL3VFWDgxRTZoaGgy?=
 =?utf-8?B?TG0xekNLa3JSZjlEd0xObnZ0YkVIaXg4Um1HUTdQQWJIbHVXcFAvR09nTEsr?=
 =?utf-8?B?RlVpd2NKQkFCeXpYNXhVNllxdnNBNGMxQUZBeW5MVndqemM4czBZeVR6cCs3?=
 =?utf-8?B?ZEx0R2hQM0VRaTA5U3ptRjM3SHBFWVNLVWRFNkt5MGZkczNtTUdXWXVWL29S?=
 =?utf-8?B?NFFVVlA4cXlZYkU3b3d2bXFnazFUYVl6WlJTbjh0NU1QaHlVM056KzJKZjlE?=
 =?utf-8?B?aW9PS0plaDBLRjFvdmRsT2Y2VWNJQnRGSTNhVCtZU3VRY2Y4MTZHcnZQWHFS?=
 =?utf-8?B?b3RVZk1yZTlrM0ZoKzJXVUlWcTU5Sk1oQVFsWHVtQlduOGdWZEp2RmtGNGFH?=
 =?utf-8?B?R3pZYjJFcEk3Vkk3S3lwUHYrSDAxdkdDVHphOGNiSERRNUhpSlUxNVd0UjNM?=
 =?utf-8?B?dDVVRDQxclJvY3Q3UVpZaFZIVk5JaXpqZGNoN2pkdnJmSFVWWUZHczAzYXgy?=
 =?utf-8?B?ckVuU09nMFFoUEk3dE5kL0xhR0IrMGZ5ZHc3d1c0MXMyR1VqTHpLMER5WERl?=
 =?utf-8?B?c1lZNW9DcnVwcHJCL3kyL1JlZndQRDU5SE9BaXBNNm1ldCtNamVEeFNMQnNN?=
 =?utf-8?B?RmpaOFphNDRlMjlGUnl1TTkyNXJ3Yk9MSHhPMytSU3hUZGdubDN1YS82V1h3?=
 =?utf-8?B?dWhrWjFhVkJXb3ptV0NQaUwzdjR1eVVEb1h6d3FQM1NNYnprOVJQZDBSQTlu?=
 =?utf-8?B?SEJhOUhlUmhqQW83MXBEallOeGhJYUJXL2J2UHRnQzEyYmJKdFRVcURNWktB?=
 =?utf-8?B?bGU4OXA2NkZnTjRZUHlPNWozMGJaRmdZNnBITjlNSUdxbzlLVjJzMzEzOExa?=
 =?utf-8?B?a3lLcUZoaW02ek9lWHpvMFVRb0pkUVVLMlpjZWM4R21jNW5ra1hkQXh1V3Zl?=
 =?utf-8?B?cUtDbytiMDNhVEVVendyZGRFR3B3aVIxRUM2WktLVUlxTitCS283T3gyRlBY?=
 =?utf-8?B?RnFPWDF2TCtDRjhmY2o5TlBaWWdJakRzeEVwVlU2NDI3MjRENUI1aG5kT2xE?=
 =?utf-8?B?eGpWbS85c2haOHBtTWNyQTFzRWJrUDJDVmZwOUJzS3NZOFg1bjhlTStqQm1i?=
 =?utf-8?B?SVVLSlhaWDlYWVNoVVdzS3M1ODd5T0QxTWMvMHJDbWt3cXhwQktKL2hhNk54?=
 =?utf-8?B?aS96MC9tRE9qdHRraDg5MGhpVzB1TlF1dXJWU3dZQUV1V2xmM0g2K0x4K0Iv?=
 =?utf-8?B?dW1WVDJxMTJ0cXRvWEhLNDFJRUpLb3ZjQVZ4d2pITVkrOVBCSUVFcnliSTVr?=
 =?utf-8?B?Vjhra2xFNHpmZDNjTkVsb0xoNm92TWFOa2gzL012MkZCMXE5RWcwTTNOdXN6?=
 =?utf-8?B?VmRzN3MzRnZKMlpCcis1bVJkbUpHM3pmS1NmVWtQaUI1b09LRHBBLzJ2SWwv?=
 =?utf-8?B?N0hlYjFpQUl1YXc0eVZrYnJGRDlvazZFa0g4Yk45OTBueVhvWHhycHRaWWpR?=
 =?utf-8?B?RDBrZGgrYVFUWVZla2ppd0tjLzhsaVU3cklxd1NzSm1LdVFuRllRZ2VyUHov?=
 =?utf-8?B?alNZbEtVQ3BlWG14OTFjd1pYdEJ3SDhJUGZ4dUdTZythY0FXQ0k5Zml6K1U0?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7B0E77CF1612B43B5AC9A6BD1B74772@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB6481.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b322a2f-6d3d-474c-b7a8-08da704aa87f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 03:38:38.2868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RW7p9GfC0pP8j0rHaQhBk7nc44Jbx98F/H59jAE/5NRP+mjh0lsMlcYgz03rJ1IpWjA6nwTLA9G/QNb9CreUZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7995
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGksIERhcnJpY2suDQoNCg0KT24gNy8yOC8yMiAxMDozNywgRGFycmljayBKLiBXb25nIHdyb3Rl
Og0KPiBEb2VzIHRoaXMgcGF0Y2ggZml4IE5GUyBmb3IgeW91Pw0KDQpJdCB3b3JrcyBmb3IgbWUu
IFRoYW5rcy4NCkJUVy4gSXQgaGFzIGNvbmZsaWN0IGR1cmluZyAiZ2l0IGFtIi4gTG9va3MgbGlr
ZSB5b3VyIGJyYW5jaCBhcmUgYWhlYWQgDQpvZiBtYXN0ZXIuDQoNCj4gDQo+IC0tRA0KPiAtLS0N
Cj4gRnJvbTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4NCj4gDQo+IHNlZWtf
c2FuaXR5X3Rlc3Q6IHVzZSBYRlMgaW9jdGxzIHRvIGRldGVybWluZSBmaWxlIGFsbG9jYXRpb24g
dW5pdCBzaXplDQo+IA0KPiBsaXV5ZC5mbnN0QGZ1aml0c3UuY29tIHJlcG9ydGVkIHRoYXQgbXkg
cmVjZW50IGNoYW5nZSB0byB0aGUgc2VlayBzYW5pdHkNCj4gdGVzdCBicm9rZSBORlMuICBJIGZv
b2xpc2hseSB0aG91Z2h0IHRoYXQgc3RfYmxrc2l6ZSB3YXMgc3VmZmljaWVudCB0bw0KPiBmaW5k
IHRoZSBmaWxlIGFsbG9jYXRpb24gdW5pdCBzaXplIHNvIHRoYXQgYXBwbGljYXRpb25zIGNvdWxk
IGZpZ3VyZSBvdXQNCj4gdGhlIFNFRUtfSE9MRSBncmFudWxhcml0eS4gIFJlcGxhY2UgdGhhdCB3
aXRoIGFuIGV4cGxpY2l0IGNhbGxvdXQgdG8gWEZTDQo+IGlvY3RscyBzbyB0aGF0IHhmcyByZWFs
dGltZSB3aWxsIHdvcmsgYWdhaW4uDQo+IA0KPiBGaXhlczogZTg2MWEzMDIgKCJzZWVrX3Nhbml0
eV90ZXN0OiBmaXggYWxsb2NhdGlvbiB1bml0IGRldGVjdGlvbiBvbiBYRlMgcmVhbHRpbWUiKQ0K
PiBSZXBvcnRlZC1ieTogbGl1eWQuZm5zdEBmdWppdHN1LmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBE
YXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPg0KPiAtLS0NCj4gICBzcmMvTWFrZWZp
bGUgICAgICAgICAgIHwgICAgNCArKysrDQo+ICAgc3JjL3NlZWtfc2FuaXR5X3Rlc3QuYyB8ICAg
NDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAgIDIgZmlsZXMg
Y2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9zcmMvTWFrZWZpbGUgYi9zcmMvTWFrZWZpbGUNCj4gaW5kZXggMzg2MjhhMjIuLmI4OWE3
YTVlIDEwMDY0NA0KPiAtLS0gYS9zcmMvTWFrZWZpbGUNCj4gKysrIGIvc3JjL01ha2VmaWxlDQo+
IEBAIC04Miw2ICs4MiwxMCBAQCBpZmVxICgkKEhBVkVfTElCQ0FQKSwgdHJ1ZSkNCj4gICBMTERM
SUJTICs9IC1sY2FwDQo+ICAgZW5kaWYNCj4gICANCj4gK2lmZXEgKCQoSEFWRV9GU1hBVFRSX1hG
TEFHX0hBU0FUVFIpLCB5ZXMpDQo+ICtMQ0ZMQUdTICs9IC1ESEFWRV9GU1hBVFRSX1hGTEFHX0hB
U0FUVFINCj4gK2VuZGlmDQo+ICsNCj4gICBpZmVxICgkKEhBVkVfU0VFS19EQVRBKSwgeWVzKQ0K
PiAgICBpZmVxICgkKEhBVkVfRlNYQVRUUl9YRkxBR19IQVNBVFRSKSwgeWVzKQ0KPiAgICAgaWZl
cSAoJChIQVZFX05GVFcpLCB5ZXMpDQo+IGRpZmYgLS1naXQgYS9zcmMvc2Vla19zYW5pdHlfdGVz
dC5jIGIvc3JjL3NlZWtfc2FuaXR5X3Rlc3QuYw0KPiBpbmRleCAxMDMwZDBjNS4uYjUzZjQ4NjIg
MTAwNjQ0DQo+IC0tLSBhL3NyYy9zZWVrX3Nhbml0eV90ZXN0LmMNCj4gKysrIGIvc3JjL3NlZWtf
c2FuaXR5X3Rlc3QuYw0KPiBAQCAtNDAsNiArNDAsMzIgQEAgc3RhdGljIHZvaWQgZ2V0X2ZpbGVf
c3lzdGVtKGludCBmZCkNCj4gICAJfQ0KPiAgIH0NCj4gICANCj4gKyNpZmRlZiBIQVZFX0ZTWEFU
VFJfWEZMQUdfSEFTQVRUUg0KPiArLyogQ29tcHV0ZSB0aGUgZmlsZSBhbGxvY2F0aW9uIHVuaXQg
c2l6ZSBmb3IgYW4gWEZTIGZpbGUuICovDQo+ICtzdGF0aWMgaW50IGRldGVjdF94ZnNfYWxsb2Nf
dW5pdChpbnQgZmQpDQo+ICt7DQo+ICsJc3RydWN0IGZzeGF0dHIgZnN4Ow0KPiArCXN0cnVjdCB4
ZnNfZnNvcF9nZW9tIGZzZ2VvbTsNCj4gKwlpbnQgcmV0Ow0KPiArDQo+ICsJcmV0ID0gaW9jdGwo
ZmQsIFhGU19JT0NfRlNHRU9NRVRSWSwgJmZzZ2VvbSk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0
dXJuIC0xOw0KPiArDQo+ICsJcmV0ID0gaW9jdGwoZmQsIEZTX0lPQ19GU0dFVFhBVFRSLCAmZnN4
KTsNCj4gKwlpZiAocmV0KQ0KPiArCQlyZXR1cm4gLTE7DQo+ICsNCj4gKwlhbGxvY19zaXplID0g
ZnNnZW9tLmJsb2Nrc2l6ZTsNCj4gKwlpZiAoZnN4LmZzeF94ZmxhZ3MgJiBGU19YRkxBR19SRUFM
VElNRSkNCj4gKwkJYWxsb2Nfc2l6ZSAqPSBmc2dlb20ucnRleHRzaXplOw0KPiArDQo+ICsJcmV0
dXJuIDA7DQo+ICt9DQo+ICsjZWxzZQ0KPiArIyBkZWZpbmUgZGV0ZWN0X3hmc19hbGxvY191bml0
KGZkKSAoLTEpDQo+ICsjZW5kaWYNCj4gKw0KPiAgIHN0YXRpYyBpbnQgZ2V0X2lvX3NpemVzKGlu
dCBmZCkNCj4gICB7DQo+ICAgCW9mZl90IHBvcyA9IDAsIG9mZnNldCA9IDE7DQo+IEBAIC00Nyw2
ICs3MywxMCBAQCBzdGF0aWMgaW50IGdldF9pb19zaXplcyhpbnQgZmQpDQo+ICAgCWludCBzaGlm
dCwgcmV0Ow0KPiAgIAlpbnQgcGFnZXN6ID0gc3lzY29uZihfU0NfUEFHRV9TSVpFKTsNCj4gICAN
Cj4gKwlyZXQgPSBkZXRlY3RfeGZzX2FsbG9jX3VuaXQoZmQpOw0KPiArCWlmICghcmV0KQ0KPiAr
CQlnb3RvIGRvbmU7DQo+ICsNCj4gICAJcmV0ID0gZnN0YXQoZmQsICZidWYpOw0KPiAgIAlpZiAo
cmV0KSB7DQo+ICAgCQlmcHJpbnRmKHN0ZGVyciwgIiAgRVJST1IgJWQ6IEZhaWxlZCB0byBmaW5k
IGlvIGJsb2Nrc2l6ZVxuIiwNCj4gQEAgLTU0LDE2ICs4NCw4IEBAIHN0YXRpYyBpbnQgZ2V0X2lv
X3NpemVzKGludCBmZCkNCj4gICAJCXJldHVybiByZXQ7DQo+ICAgCX0NCj4gICANCj4gLQkvKg0K
PiAtCSAqIHN0X2Jsa3NpemUgaXMgdHlwaWNhbGx5IGFsc28gdGhlIGFsbG9jYXRpb24gc2l6ZS4g
IEhvd2V2ZXIsIFhGUw0KPiAtCSAqIHJvdW5kcyB0aGlzIHVwIHRvIHRoZSBwYWdlIHNpemUsIHNv
IGlmIHRoZSBzdGF0IGJsb2Nrc2l6ZSBpcyBleGFjdGx5DQo+IC0JICogb25lIHBhZ2UsIHVzZSB0
aGlzIGl0ZXJhdGl2ZSBhbGdvcml0aG0gdG8gc2VlIGlmIFNFRUtfREFUQSB3aWxsIGhpbnQNCj4g
LQkgKiBhdCBhIG1vcmUgcHJlY2lzZSBhbnN3ZXIgYmFzZWQgb24gdGhlIGZpbGVzeXN0ZW0ncyAo
cHJlKWFsbG9jYXRpb24NCj4gLQkgKiBkZWNpc2lvbnMuDQo+IC0JICovDQo+ICsJLyogc3RfYmxr
c2l6ZSBpcyB0eXBpY2FsbHkgYWxzbyB0aGUgYWxsb2NhdGlvbiBzaXplICovDQo+ICAgCWFsbG9j
X3NpemUgPSBidWYuc3RfYmxrc2l6ZTsNCj4gLQlpZiAoYWxsb2Nfc2l6ZSAhPSBwYWdlc3opDQo+
IC0JCWdvdG8gZG9uZTsNCj4gICANCj4gICAJLyogdHJ5IHRvIGRpc2NvdmVyIHRoZSBhY3R1YWwg
YWxsb2Mgc2l6ZSAqLw0KPiAgIAl3aGlsZSAocG9zID09IDAgJiYgb2Zmc2V0IDwgYWxsb2Nfc2l6
ZSkgew==
