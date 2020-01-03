Return-Path: <SRS0=vgQ5=2Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153B6C00523
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 07:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A7662464E
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jan 2020 07:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rededucat.onmicrosoft.com header.i=@rededucat.onmicrosoft.com header.b="eKZ1P7xy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgACHWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 02:22:01 -0500
Received: from mail-eopbgr1370082.outbound.protection.outlook.com ([40.107.137.82]:49525
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgACHWB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Jan 2020 02:22:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGKoSzjj0bBREuoNV7qYUrZY921GpUM9EDB7oRWYAkcijbmj/y6vUuSh/m81djK7Wup8NnCy+QIzANLH5U2vC3+nBsukIJl77t7pn6u+v0tdQtPXqP6ODe9CFRHElDV88qbC9WcPta8L0l8YufQpiivL64Lw6MfgKw1Hm+yOwSXXMuFXbN4qcrQydcHyE8ogzexgCzIgfyTG4bu8VmfG3umheDb6lvykaB+nu7lDxC7EgYH2jfi6XRPVJXPOB536VvUT0ahSSL3aiOd5cKT5RzCrarUGJ3vf2gPaExFN1VlI+5vLSLC6cWWRIvFi48v9ZNOy4tx1MANKJ3h8mh2lSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFmoU9yfDllw3YR+0AfbPdN5UytPbXCF7Gbm8lxC8lk=;
 b=RheIsb6+TYQsxsdylx5p+WW/X0Z6gFZCECrS4q4QzO+gQcP8AP8sy/KThjYx+7kzItUgytf1X2p2MX+yOLzyfk/wBIRJU6wq/M4vssLHsaM6Us2hHniFkvwjTtED5IkmIKzqlOb00VHkxUsF2Rtu5QYh9y0sEfAvlxG0YOoSNu4RxYS2zJkt/U0Ny1LgjLmOl1jAM71WHnSa6AQqPx3jIoDUfLuJc91VeBo9mJ84k4RrAwZwghdvho3C629WbNkLJ5Bx0QsS5hMXxoiJ4GMKLoRP/gGAe+ALLeEdCf0NV18jVRBBRRko9o4XJubFHV9FfDt+iNq9Sq2SCM9dWyM1Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rededucation.com; dmarc=pass action=none
 header.from=rededucation.com; dkim=pass header.d=rededucation.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=rededucat.onmicrosoft.com; s=selector2-rededucat-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFmoU9yfDllw3YR+0AfbPdN5UytPbXCF7Gbm8lxC8lk=;
 b=eKZ1P7xyB3fNxnNo4G+D/p4RdCajcALs6S8GwQpt40lJQhQXa8fKZWGGF6FUSR19u1yQ61t7Mk8/uQ1pHLWp3dqONYueNaHD7WvAM786sS2/tE3ynOd1yg3Tbg7V0thFndQ4HrgEv2U+BbEu9AEZn9igaRpc/tAH7SQsPoK5Onc=
Received: from SY2PR01MB2619.ausprd01.prod.outlook.com (52.134.190.15) by
 SY2PR01MB2988.ausprd01.prod.outlook.com (52.134.187.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 3 Jan 2020 07:21:55 +0000
Received: from SY2PR01MB2619.ausprd01.prod.outlook.com
 ([fe80::8511:d802:5a8e:e0e4]) by SY2PR01MB2619.ausprd01.prod.outlook.com
 ([fe80::8511:d802:5a8e:e0e4%7]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 07:21:54 +0000
From:   Daniel Storey <daniel.storey@rededucation.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>,
        Daniel Storey <daniel.storey202@gmail.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair: superblock read failed, fatal error -- Input/output
 error
Thread-Topic: xfs_repair: superblock read failed, fatal error -- Input/output
 error
Thread-Index: AQHVwQI8ebYvBuePYEqAQoVupIqaD6fXQaGAgAAA4QCAABbLgIAAMlKAgABIIwCAALJZAIAAvTMA
Date:   Fri, 3 Jan 2020 07:21:53 +0000
Message-ID: <11994FD1-6462-46DA-86CF-D862328FB1B3@rededucation.com>
References: <FF3D9678-1449-467B-AA27-DA8C4B6A6DA2@rededucation.com>
 <379BEB4C-D422-4EE8-8C1C-CDF8AA3016E0@rededucation.com>
 <6C0FFC4B-AE04-4C97-87FF-BD86E610F549@rededucation.com>
 <0D8F4E6F-CA2E-4032-BFD5-E87F651E2585@rededucation.com>
 <20200102160807.dsoozldhtq7glw6z@orion.redhat.com>
 <MN2PR07MB59347B8FC6B9E92D0107D9A1A4200@MN2PR07MB5934.namprd07.prod.outlook.com>
 <20200103070438.wnyo3a6ubdccptz7@orion.redhat.com>
In-Reply-To: <20200103070438.wnyo3a6ubdccptz7@orion.redhat.com>
Accept-Language: en-AU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=daniel.storey@rededucation.com; 
x-originating-ip: [45.248.142.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec99ef76-7dfa-4f9a-5eff-08d7901d9c30
x-ms-traffictypediagnostic: SY2PR01MB2988:
x-microsoft-antispam-prvs: <SY2PR01MB2988C8B09C3013CE32A015998F230@SY2PR01MB2988.ausprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(396003)(136003)(39830400003)(346002)(51914003)(199004)(189003)(6506007)(33656002)(8936002)(86362001)(81156014)(81166006)(6486002)(6512007)(44832011)(110136005)(4326008)(186003)(2616005)(66946007)(8676002)(36756003)(76116006)(2906002)(64756008)(5660300002)(316002)(66446008)(508600001)(66476007)(26005)(66556008)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SY2PR01MB2988;H:SY2PR01MB2619.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: rededucation.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5L9sOF6WMMLsHcM9MWms3u4v3PPTEu+AOSDr++jJhyRgwBQ5oPQYEmU4vFGtfrymXspu8J2aR3mQV0MqEC1/M0Ibn7XFYwQQTm76aAgG78oEP+8CpqNnlFutu4Mem6BnjxXmfXzZqhVqR/KCCHK9IE+SOk/Mdetz12QiQgHveSYUesU8Fxg1w8CtBD4G3Zmrj2XuZoHUQaeVJBdHhBo8a33cFblFHP+43fiZz7xt8VacaNinlCAzmOH1HIjfnyVn/wvqbR0Xhq+Lp4yfwACLrCU+BDa0WSdRjf3HMDGbllspRoO5S/RLEF6lMtg+4TVa+SdlUHQpWE/tRXo44DmAfJXuOBntCEZQj/WSL2e5RH331s+X7qdbrF/Yp6V5mSz3jqoIBTUXe3pY6z3+CMrjJXzLGLk/YqoxAh07gEzH7h1fAla1lyP0+UtLfONDPyBvexPUUWV03wqPXMYKPM/vQ0zYFbB+HJGQ7qHxmtLkTkzQEDn+wgHYGW6aW4+p3eYs
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <76E8AAA47416674183BA0DBF99CCFF79@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: rededucation.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec99ef76-7dfa-4f9a-5eff-08d7901d9c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 07:21:53.8095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9070ef23-9a31-45a8-9b14-45111a4ebbbe
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S3BC5w4wHRmtDK6ovyZzme+UaX1dskZoTDzuujop309mHp/mNojJvTH74VwJWKkjeaKkgM8OtZKqJQbnTWlhvFukku8xsMrYtj9dlnIZH0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY2PR01MB2988
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T2sgLSBUaGFua3MsIENhcmxvcyENCg0KSSBoYXZlIGEgV2luZG93cyAxMCBtYWNoaW5lIHRoYXQg
SSdsbCBwbHVnIHRoZSBkZXZpY2VzIGludG8gYW5kIHNjYW4gdGhlbS4NCg0KQ2hlZXJzLA0KDQpE
YW5pZWwgU3RvcmV5DQoNCu+7v09uIDMvMS8yMCwgNjowNCBwbSwgImxpbnV4LXhmcy1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIENhcmxvcyBNYWlvbGlubyIgPGxpbnV4LXhmcy1v
d25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIGNtYWlvbGlub0ByZWRoYXQuY29tPiB3
cm90ZToNCg0KICAgIEhpIERhbmllbC4NCiAgICANCiAgICA+ICAgICBBbHNvIG9uIGEgdm13YXJl
IG1hY2hpbmU/IE9uIHRoZSBzYW1lIGh5cGVydmlzb3I/IEZvciBzdXJlIG5vdCBvbiB0aGUgc2Ft
ZSBob3N0LA0KICAgID4gICAgIHNpbmNlIFVGUyBleHBsb3JlciAoQUZBSUspIGRvZXMgbm90IGhh
dmUgYSBMaW51eCB2ZXJzaW9uLg0KICAgID4gDQogICAgPiBJdCBkb2VzLCBhY3R1YWxseSAoaGF2
ZSBhIExpbnV4IHZlcnNpb24pLiAgSSdtIHJ1bm5pbmcgaXQgb24gdGhlIHNhbWUgaG9zdC4NCiAg
ICANCiAgICBPaCwgSSBkaWRuJ3Qga25vdyB0aGF0LCB0aGFua3MgZm9yIHRoZSBpbmZvcm1hdGlv
bi4NCiAgICANCiAgICANCiAgICA+ICAgICANCiAgICA+ICAgICBBbmQgYnR3LCBVRlMgRXhwbG9y
ZXIgaXMgYnVpbHQgc28gdGhhdCB5b3UgY2FuIHNjYW4vcmVjb3ZlciBkYXRhIG9uIHZlcnkgZGFt
YWdlZA0KICAgID4gICAgIGZpbGVzeXN0ZW1zIGFuZCBkaXNrcywgd2hpbGUgZmlsZXN5c3RlbXMg
d29uJ3QgbGV0IHlvdSBtb3VudCBhIGNvcnJ1cHRlZA0KICAgID4gICAgIGZpbGVzeXN0ZW0gdG8g
YXZvaWQgZG9pbmcgZXZlbiBtb3JlIGRhbWFnZS4gU28sIHllYWgsIHlvdSBtaWdodCBzdGlsbCBz
ZWUNCiAgICA+ICAgICBmaWxlc3lzdGVtIGRhdGEvbWV0YWRhdGEgdXNpbmcgVUZTIGV4cGxvcmVy
IHdpdGggZGFtYWdlZCBmaWxlc3lzdGVtcyBvciBibG9jaw0KICAgID4gICAgIGRldmljZXMuDQog
ICAgPiAgICAgDQogICAgPiBPa2F5Lg0KICAgIA0KICAgIEp1c3QgYWRkaW5nIHRvIHRoZSBpbmZv
cm1hdGlvbiBhYm92ZSwgVUZTIChhbmQgYmFzaWNhbGx5IG1vc3Qgb2YgdGhlIGRpc2FzdGVyDQog
ICAgcmVjb3ZlcnkgdG9vbHMpLCB3aWxsIGlnbm9yZSBJTyBlcnJvcnMgYXMgbXVjaCBhcyBpdCBj
YW4sIGFzIGFuIGF0dGVtcHQgdG8gcmVhZA0KICAgIGFzIG11Y2ggZGF0YSBhcyBwb3NzaWJsZSBm
cm9tIHRoZSBmYWlsaW5nIGRldmljZXMuDQogICAgDQogICAgPiAgICAgDQogICAgPiAgICAgU28s
IGFnYWluLCBJJ2QgdHJ5IHRvIG9wZW4gdGhlc2UgZGV2aWNlcyBvbiBhIGJhcmUtbWV0YWwgbWFj
aGluZSBhbmQgY2hlY2sgdGhlDQogICAgPiAgICAgZGV2aWNlIGZvciBlcnJvcnMuIElmIHRoZSBl
cnJvcnMgYXJlIHN0aWxsIHByZXNlbnQsIHJlcGxhY2UgdGhlIGRldmljZXMuDQogICAgPiAgICAg
DQogICAgPiBPayAtIEknbGwgdHJ5IG9wZW5pbmcgdGhlc2UgZGV2aWNlcyBvbiBhIGJhcmUtbWV0
YWwgKG5vdCBhIFZNd2FyZSBob3N0KSBhbmQgY2hlY2sgdGhlbSBmb3IgZXJyb3JzLiBXaGF0IGRv
IEkgZG8gaWYgdGhlcmUgYXJlIG5vIGVycm9ycyBwcmVzZW50PyAgQXMgdGhlIFNNQVJUIGNoZWNr
IHJldmVhbGVkIG5vIHByb2JsZW1zIHdpdGggdGhlIGRpc2tzLg0KICAgID4gDQogICAgDQogICAg
SSBkaWQgYW5vdGhlciBsb29rIGludG8gdGhlIGRtZXNnIG91dHB1dCB5b3UgcHJvdmlkZWQsIGFu
ZDoNCiAgICANCiAgICA+ICAgICA+IFs1MjgxOS42MzcxNzldIEJ1ZmZlciBJL08gZXJyb3Igb24g
ZGV2IGRtLTQsIGxvZ2ljYWwgYmxvY2sgMTYxMDYxMjczMSwgYXN5bmMgcGFnZSByZWFkDQogICAg
DQogICAgVGhpcyBpcyBhbiBJL08gZXJyb3IgZXZlbiBiZWxvdyB0aGUgdmRvIGRyaXZlciwgc28g
YXMgbXVjaCBhcyBYRlMgaXMgb25seSB0aGUNCiAgICB2aWN0aW0gaGVyZSwgSSBhbSBpbmNsaW5l
ZCB0byBzYXkgYWdhaW4gVkRPIGlzIGFsc28gb25lIG1vcmUgdmljdGltIGhlcmUgb2YgYQ0KICAg
IGZhaWxpbmcgZGV2aWNlLCBldmVuIHRob3VnaCBJIGRvbid0IGtub3cgbXVjaCBkZXRhaWxzIGFi
b3V0IFZETyBkcml2ZXIuDQogICAgDQogICAgU28geW91IHJlYWxseSBuZWVkIHRvIGNoZWNrIHlv
dXIgc3RvcmFnZSBzdGFjayB0byBrbm93IHdoZXJlIHRoZSBlcnJvcnMgbWlnaHQNCiAgICBiZS4N
CiAgICANCiAgICBUaGUgSEREIGl0c2VsZiwgdGhlIHN0b3JhZ2UgZW5jbG9zdXJlLCB1c2IgY2Fi
bGUsIFZNV2FyZSBoeXBlcnZpc29yLCBldGMuIEkNCiAgICByZWFsbHkgY2FuJ3Qgc2F5LCBJIGNv
dWxkbid0IHNwb3QgYW55IGVycm9ycyBwb2ludGluZyB0byBhbnl0aGluZyBzcGVjaWZpYyBvdGhl
cg0KICAgIHRoYW4gZ2VuZXJpYyBJL08gZXJyb3JzLCB3aGljaCBlc3NlbnRpYWxseSBtZWFucyBr
ZXJuZWwgZmFpbGVkIHRvIGlzc3VlIEkvTw0KICAgIGNvbW1hbmRzIHRvIHlvdXIgZGV2aWNlLiBJ
dCB3aWxsIHJlcXVpcmUgc29tZSBpbnZlc3RpZ2F0aW9uIHRvIGRldGVybWluZSB3aGVyZQ0KICAg
IHRoZSBlcnJvciBsaWVzLCB0aGF0J3Mgd2h5IEkgc3VnZ2VzdGVkIHBsdWdnaW5nIHRoZSB1c2Ig
SEREIGludG8gYSBiYXJlLW1ldGFsDQogICAgbWFjaGluZSwgc28geW91IGNhbiBzdGFydCBieSBi
ZXR0ZXIgaXNvbGF0aW5nIHRoZSBwcm9ibGVtLg0KICAgIA0KICAgIEJ1dCBYRlMgdGhlcmUgaXMg
anVzdCB0aGUgbWVzc2VuZ2VyIHRoZXJlIG9mIHNvbWUgcHJvYmxlbSB3aXRoIHlvdXIgZGV2aWNl
IG9yDQogICAgc3RvcmFnZSBzdGFjay4NCiAgICANCiAgICBDaGVlcnMuDQogICAgDQogICAgLS0g
DQogICAgQ2FybG9zDQogICAgDQogICAgDQoNCg==
