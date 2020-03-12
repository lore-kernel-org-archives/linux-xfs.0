Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BABC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0746E206F1
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="FCWoYjGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725268AbgCLIJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:09:58 -0400
Received: from mail-vi1eur05on2110.outbound.protection.outlook.com ([40.107.21.110]:64513
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgCLIJ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 04:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwetLNqB7UN6EzWdYqNUxETesyqxVlj9lr+FK6wzFxcJ0sSxbiGN52hss76a+yAs3Kt8lAdiYDfOOL+Q2Fxs2DTbas3AEgm9P6RtFelv1Ef3Ms0kwnUix3b+c2HjWpTk2+HU/+XZ1cNLjSwJHWvT+nqQZCpulxI0Cr1d1iaNE5ImenB5gYL29ltGRQQdXWzmYsUXNmKhj5pginhhk+Deank8V5CTH2onnOW6bADu/EFPSuKw/7gu+18wjbBnv2KKHEso2HCm+vs1qcB+HQdiprkeCGwa6N6eZZVx9PR3EB8Dhx7x8QWN8Q9ec0g6ATW43RnznC6mhdL1UVgey58IsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za5BDCSgKncg6ZYVZzVL8RmfNmNOJHxpOLp5pOyM0W8=;
 b=R9Zr1jXN9TnahD3XrOjB10LLD1Vsj+CObBNerx4VDuXmXecA6V3esWxf7YdH+rQXcoQkQBdgJeKDVVf74NOpXTOQ1qQgFqAuq7I3rN3bl8LlWajKlVDLYkFNE5sbmIwGkG2ghkZ14sLs/12Bmxw68Y06BbRPMKLqr5kiHDsbnvyHQiMzy2SduTBChfDTZferfCUAVhDtoRqU0WkvEFSpAbDKiRaWrxv0S27vReadN+vL9Z+WEGFGR6RdJL0+E6G9h7VthJL8G7JsvsdNh9SzpbPTG2diAI5Zkq6utAEsmmo2AB1urPn/trkZxZkv6++qcJEnCe/bZR1bXbaePQMzXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za5BDCSgKncg6ZYVZzVL8RmfNmNOJHxpOLp5pOyM0W8=;
 b=FCWoYjGk3DMKwvN5kLMuQJ0IyF3XQSsIJVdIA0808k3GX370zt/KVHCpgXZakGEiV1NJhtSGydNL+/Xf0hJMGBenUk1YX2ghZGuhhHUrparJ7ZYBka6wzJEMu7cjKyozExI++aSGYrA57SBILrFWhM1oJiGSDsEHRuuSYkzc9vI=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3738.eurprd07.prod.outlook.com (52.133.6.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.9; Thu, 12 Mar 2020 08:09:53 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 08:09:53 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 5.5 XFS getdents regression?
Thread-Topic: 5.5 XFS getdents regression?
Thread-Index: AQHV9rhRbXPUS+vCVkG2reFy3jRV26hCZPwAgAE8UoCAAASPAIAA9+kA
Date:   Thu, 12 Mar 2020 08:09:53 +0000
Message-ID: <1a10a2ec66bd9c72ef317f7a0834b30e6b739e8e.camel@nokia.com>
References: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
         <20200310221406.GO10776@dread.disaster.area>
         <862b6c718957aff7156bf04964b7242f5075e8a7.camel@nokia.com>
         <20200311172234.GA26340@lst.de>
In-Reply-To: <20200311172234.GA26340@lst.de>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 61967bb7-5f97-4094-0292-08d7c65cbeb4
x-ms-traffictypediagnostic: HE1PR0702MB3738:
x-microsoft-antispam-prvs: <HE1PR0702MB37387A1EFB07536AAA409EEDB4FD0@HE1PR0702MB3738.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(6512007)(6486002)(4326008)(76116006)(54906003)(2616005)(478600001)(2906002)(6916009)(71200400001)(316002)(66946007)(36756003)(966005)(8936002)(26005)(8676002)(81156014)(7116003)(81166006)(86362001)(186003)(66476007)(66556008)(5660300002)(66446008)(64756008)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3738;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11SKoL8bW/OMVdB7zWl7jsEhyyeEr5GbdSRBmeVvsnSQNv5WDnARch0ibJgURY//L0Wp3M9qzH3zZ97C5nRRm7HOixVn82kd0Rmpvx1p7e4jDBiVq4hzCgUKU7SrxM1Nr4YaxAouVuuhnrt7dybtM7bMRMwPMMA1j1hliya5WaBtJZUnnBqQSr17PsIrjDaqHXcHGb/JCaqyYNve9+1XYa0ShNetfeaajgq8dA6mL5GyWHLvPpIhjSPR3t1m0wxe2Bi5Pcx/OMVaxnFaMsEoY3fVnjzPkoxhenRQV77Rxel1dOzLtvSYC7uxEXLP/BdT+KJ13ehyOKQHGX3+4soc0LFiO5bmWJVj+NuJ0VUELspbSCgeuVTxOiXL3CgjL6/P4fhMbTRLNBxQE6m9/JTfIKMxX6oiEabRKg8LwJIILerLPQJxoL1wVNz+bnjmw4es3JR6ONS2igYNCCU9/GuY6uFz+pFo1GrmUVysNnBu/frqu8i3fpZdhaUyxSZ21cPD/OXgt7uyB0A20+/sFEwxbA==
x-ms-exchange-antispam-messagedata: vMhlMtkTeWAjPuc2gtNLG2YelZnNxAdk0vuQpm9b7rGOSaYMbQI2yIao4rOq4rj+jfHF5rvmPyHJa2HFJdxaEwD/7Rw2L3bjOe7NJO0hGTMU3M6JNT0H2WWDk2beaktClXTwIu8h+yG+joHq9Bzdog==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <25D9EE5F7BCAED48B255E0F329B71D19@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61967bb7-5f97-4094-0292-08d7c65cbeb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 08:09:53.3474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLO0KeefRtGDae41cp3kV1FpXD3SrCfS8DQW8GehZnOVuIZfiOMSYTN9xzRli7OtPBPhJrQZtmAMucS1gZrm8eXYGQuhL/B61nq03KqJKWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3738
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTExIGF0IDE4OjIyICswMTAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBXZWQsIE1hciAxMSwgMjAyMCBhdCAwNTowNjoxNlBNICswMDAwLCBSYW50YWxhLCBUb21taSBU
LiAoTm9raWEgLQ0KPiBGSS9Fc3Bvbykgd3JvdGU6DQo+ID4gT24gV2VkLCAyMDIwLTAzLTExIGF0
IDA5OjE0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIE1hciAxMCwg
MjAyMCBhdCAwODo0NTo1OEFNICswMDAwLCBSYW50YWxhLCBUb21taSBULiAoTm9raWEgLQ0KPiA+
ID4gRkkvRXNwb28pIHdyb3RlOg0KPiA+ID4gPiBIZWxsbywNCj4gPiA+ID4gDQo+ID4gPiA+IE9u
ZSBvZiBteSBHaXRMYWIgQ0kgam9icyBzdG9wcGVkIHdvcmtpbmcgYWZ0ZXIgdXBncmFkaW5nIHNl
cnZlcg0KPiA+ID4gPiA1LjQuMTgtDQo+ID4gPiA+IDEwMC5mYzMwLng4Nl82NCAtPiA1LjUuNy0x
MDAuZmMzMC54ODZfNjQuDQo+ID4gPiA+ICh0ZXN0ZWQgNS41LjgtMTAwLmZjMzAueDg2XzY0IHRv
bywgbm8gY2hhbmdlKQ0KPiA+ID4gPiBUaGUgc2VydmVyIGlzIGZlZG9yYTMwIHdpdGggWEZTIHJv
b3Rmcy4NCj4gPiA+ID4gVGhlIHByb2JsZW0gcmVwcm9kdWNlcyBhbHdheXMsIGFuZCB0YWtlcyBv
bmx5IGNvdXBsZSBtaW51dGVzIHRvDQo+ID4gPiA+IHJ1bi4NCj4gPiA+ID4gDQo+ID4gPiA+IFRo
ZSBDSSBqb2IgZmFpbHMgaW4gdGhlIGJlZ2lubmluZyB3aGVuIGRvaW5nICJnaXQgY2xlYW4iIGlu
IGRvY2tlcg0KPiA+ID4gPiBjb250YWluZXIsIGFuZCBmYWlsaW5nIHRvIHJtZGlyIHNvbWUgZGly
ZWN0b3J5Og0KPiA+ID4gPiAid2FybmluZzogZmFpbGVkIHRvIHJlbW92ZSANCj4gPiA+ID4gLnZl
bmRvci9wa2cvbW9kL2dvbGFuZy5vcmcveC9uZXRAdjAuMC4wLTIwMjAwMTE0MTU1NDEzLTZhZmI1
MTk1ZTVhYS9pbg0KPiA+ID4gPiB0ZXJuDQo+ID4gPiA+IGFsL3NvY2tldDogRGlyZWN0b3J5IG5v
dCBlbXB0eSINCj4gPiA+ID4gDQo+ID4gPiA+IFF1aWNrIGdvb2dsZSBzZWFyY2ggZmluZHMgc29t
ZSBvdGhlciBwZW9wbGUgcmVwb3J0aW5nIHNpbWlsYXINCj4gPiA+ID4gcHJvYmxlbXMNCj4gPiA+
ID4gd2l0aCA1LjUuMDoNCj4gPiA+ID4gaHR0cHM6Ly9naXRsYWIuY29tL2dpdGxhYi1vcmcvZ2l0
bGFiLXJ1bm5lci9pc3N1ZXMvMzE4NQ0KPiA+ID4gDQo+ID4gPiBXaGljaCBhcHBlYXJzIHRvIGJl
IGNhdXNlZCBieSBtdWx0aXBsZSBnaXRsYWIgcHJvY2Vzc2VzIG1vZGlmeWluZw0KPiA+ID4gdGhl
IGRpcmVjdG9yeSBhdCB0aGUgc2FtZSB0aW1lLiBpLmUuIHNvbWV0aGluZyBpcyBhZGRpbmcgYW4g
ZW50cnkgdG8NCj4gPiA+IHRoZSBkaXJlY3RvcnkgYXQgdGhlIHNhbWUgdGltZSBzb21ldGhpbmcg
aXMgdHJ5aW5nIHRvIHJtIC1yZiBpdC4NCj4gPiA+IFRoYXQncyBhIHJhY2UgY29uZGl0aW9uLCBh
bmQgd291bGQgbGVhZCB0byB0aGUgZXhhY3Qgc3ltcHRvbXMgeW91DQo+ID4gPiBzZWUgaGVyZSwg
ZGVwZW5kaW5nIG9uIHdoZXJlIGluIHRoZSBkaXJlY3RvcnkgdGhlIG5ldyBlbnRyeSBpcw0KPiA+
ID4gYWRkZWQuDQo+ID4gDQo+ID4gT0sgdHJhY2VkICJleGVjdmUiIHdpdGggc3RyYWNlIHRvbywg
YW5kIGl0IHNob3dzIHRoYXQgaXQncyAiZ2l0IGNsZWFuDQo+ID4gLWZmZHgiIGNvbW1hbmQgKHNp
bmdsZSBwcm9jZXNzKSB0aGF0IGlzIGJlaW5nIGV4ZWN1dGVkIGluIHRoZQ0KPiA+IGNvbnRhaW5l
ciwNCj4gPiB3aGljaCBpcyBkb2luZyB0aGUgY2xlYW51cC4NCj4gPiANCj4gPiBUZXN0ZWQgd2l0
aCA1LjYtcmM1LCBpdCdzIGZhaWxpbmcgdGhlIHNhbWUgd2F5Lg0KPiA+IA0KPiA+IFNwZW50IHNv
bWUgdGltZSB0byBiaXNlY3QgdGhpcywgYW5kIHRoZSBwcm9ibGVtIGlzIGludHJvZHVjZWQgYnkg
dGhpczoNCj4gPiANCj4gPiBjb21taXQgMjYzZGRlODY5YmQwOWIxYTcwOWZkOTIxMThjN2ZmZjgz
Mjc3MzY4OQ0KPiA+IEF1dGhvcjogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+ID4g
RGF0ZTogICBGcmkgTm92IDggMTU6MDU6MzIgMjAxOSAtMDgwMA0KPiA+IA0KPiA+ICAgICB4ZnM6
IGNsZWFudXAgeGZzX2RpcjJfYmxvY2tfZ2V0ZGVudHMNCj4gPiAgICAgDQo+ID4gICAgIFVzZSBh
biBvZmZzZXQgYXMgdGhlIG1haW4gbWVhbnMgZm9yIGl0ZXJhdGlvbiwgYW5kIG9ubHkgZG8gcG9p
bnRlcg0KPiA+ICAgICBhcml0aG1ldGljcyB0byBmaW5kIHRoZSBkYXRhL3VudXNlZCBlbnRyaWVz
Lg0KPiA+ICAgICANCj4gPiAgICAgU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBsc3QuZGU+DQo+ID4gICAgIFJldmlld2VkLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRhcnJpY2su
d29uZ0BvcmFjbGUuY29tPg0KPiA+ICAgICBTaWduZWQtb2ZmLWJ5OiBEYXJyaWNrIEouIFdvbmcg
PGRhcnJpY2sud29uZ0BvcmFjbGUuY29tPg0KPiA+IA0KPiA+IA0KPiA+IA0KPiA+IEhtbW1tbSwg
bG9va2luZyBhdCB0aGF0IGNvbW1pdCwgSSB0aGluayBpdCBzbGlnaHR5IGNoYW5nZWQgaG93IHRo
ZQ0KPiA+ICJvZmZzZXQiIGlzIHVzZWQgY29tcGFyZWQgdG8gaG93IHRoZSBwb2ludGVycyB3ZXJl
IHVzZWQuDQo+ID4gDQo+ID4gVGhpcyBjdXJlcyB0aGUgaXNzdWUgZm9yIG1lLCB0ZXN0ZWQgKGJy
aWVmbHkpIG9uIHRvcCBvZiA1LjYtcmM1Lg0KPiA+IERvZXMgaXQgbWFrZSBzZW5zZS4uLj8NCj4g
PiAoRW1haWwgY2xpZW50IHByb2JhYmx5IGRhbWFnZXMgd2hpdGUtc3BhY2UsIHNvcnJ5LCBJJ2xs
IHNlbmQgdGhpcw0KPiA+IHByb3Blcmx5DQo+ID4gc2lnbmVkLW9mZiB3aXRoIGdpdC1zZW5kLWVt
YWlsIGlmIGl0J3MgT0spDQo+IA0KPiBUaGFua3MsIHRoaXMgbG9va3MgZ29vZC4gIEFsdGhvdWdo
IEkgd29uZGVyIGlmIHRoZSBzbGlnaHRseSBkaWZmZXJlbnQNCj4gdmVyc2lvbiBiZWxvdyBtaWdo
dCBiZSBhIGxpdHRsZSBtb3JlIGVsZWdhbnQ/DQoNClllcyB0aGF0J3MgYmV0dGVyIGluZGVlZCwg
dGhhbmtzIQ0KLVRvbW1pDQoNCg0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19kaXIyX3JlYWRk
aXIuYyBiL2ZzL3hmcy94ZnNfZGlyMl9yZWFkZGlyLmMNCj4gaW5kZXggMGQzYjY0MGNmMWNjLi44
NzFlYzIyYzlhZWUgMTAwNjQ0DQo+IC0tLSBhL2ZzL3hmcy94ZnNfZGlyMl9yZWFkZGlyLmMNCj4g
KysrIGIvZnMveGZzL3hmc19kaXIyX3JlYWRkaXIuYw0KPiBAQCAtMTQ3LDcgKzE0Nyw3IEBAIHhm
c19kaXIyX2Jsb2NrX2dldGRlbnRzKA0KPiAgCXhmc19vZmZfdAkJY29vazsNCj4gIAlzdHJ1Y3Qg
eGZzX2RhX2dlb21ldHJ5CSpnZW8gPSBhcmdzLT5nZW87DQo+ICAJaW50CQkJbG9ja19tb2RlOw0K
PiAtCXVuc2lnbmVkIGludAkJb2Zmc2V0Ow0KPiArCXVuc2lnbmVkIGludAkJb2Zmc2V0LCBuZXh0
X29mZnNldDsNCj4gIAl1bnNpZ25lZCBpbnQJCWVuZDsNCj4gIA0KPiAgCS8qDQo+IEBAIC0xNzMs
OSArMTczLDEwIEBAIHhmc19kaXIyX2Jsb2NrX2dldGRlbnRzKA0KPiAgCSAqIExvb3Agb3ZlciB0
aGUgZGF0YSBwb3J0aW9uIG9mIHRoZSBibG9jay4NCj4gIAkgKiBFYWNoIG9iamVjdCBpcyBhIHJl
YWwgZW50cnkgKGRlcCkgb3IgYW4gdW51c2VkIG9uZSAoZHVwKS4NCj4gIAkgKi8NCj4gLQlvZmZz
ZXQgPSBnZW8tPmRhdGFfZW50cnlfb2Zmc2V0Ow0KPiAgCWVuZCA9IHhmc19kaXIzX2RhdGFfZW5k
X29mZnNldChnZW8sIGJwLT5iX2FkZHIpOw0KPiAtCXdoaWxlIChvZmZzZXQgPCBlbmQpIHsNCj4g
Kwlmb3IgKG9mZnNldCA9IGdlby0+ZGF0YV9lbnRyeV9vZmZzZXQ7DQo+ICsJICAgICBvZmZzZXQg
PCBlbmQ7DQo+ICsJICAgICBvZmZzZXQgPSBuZXh0X29mZnNldCkgew0KPiAgCQlzdHJ1Y3QgeGZz
X2RpcjJfZGF0YV91bnVzZWQJKmR1cCA9IGJwLT5iX2FkZHIgKw0KPiBvZmZzZXQ7DQo+ICAJCXN0
cnVjdCB4ZnNfZGlyMl9kYXRhX2VudHJ5CSpkZXAgPSBicC0+Yl9hZGRyICsNCj4gb2Zmc2V0Ow0K
PiAgCQl1aW50OF90IGZpbGV0eXBlOw0KPiBAQCAtMTg0LDE0ICsxODUsMTUgQEAgeGZzX2RpcjJf
YmxvY2tfZ2V0ZGVudHMoDQo+ICAJCSAqIFVudXNlZCwgc2tpcCBpdC4NCj4gIAkJICovDQo+ICAJ
CWlmIChiZTE2X3RvX2NwdShkdXAtPmZyZWV0YWcpID09IFhGU19ESVIyX0RBVEFfRlJFRV9UQUcp
IHsNCj4gLQkJCW9mZnNldCArPSBiZTE2X3RvX2NwdShkdXAtPmxlbmd0aCk7DQo+ICsJCQluZXh0
X29mZnNldCA9IG9mZnNldCArIGJlMTZfdG9fY3B1KGR1cC0+bGVuZ3RoKTsNCj4gIAkJCWNvbnRp
bnVlOw0KPiAgCQl9DQo+ICANCj4gIAkJLyoNCj4gIAkJICogQnVtcCBwb2ludGVyIGZvciB0aGUg
bmV4dCBpdGVyYXRpb24uDQo+ICAJCSAqLw0KPiAtCQlvZmZzZXQgKz0geGZzX2RpcjJfZGF0YV9l
bnRzaXplKGRwLT5pX21vdW50LCBkZXAtDQo+ID5uYW1lbGVuKTsNCj4gKwkJbmV4dF9vZmZzZXQg
PSBvZmZzZXQgKw0KPiArCQkJeGZzX2RpcjJfZGF0YV9lbnRzaXplKGRwLT5pX21vdW50LCBkZXAt
Pm5hbWVsZW4pOw0KPiAgDQo+ICAJCS8qDQo+ICAJCSAqIFRoZSBlbnRyeSBpcyBiZWZvcmUgdGhl
IGRlc2lyZWQgc3RhcnRpbmcgcG9pbnQsIHNraXANCj4gaXQuDQoNCg==
