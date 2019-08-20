Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05CFC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9B0C206DD
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 22:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfHTWIl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 18:08:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:23905 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbfHTWIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 18:08:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 15:08:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="180837181"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga003.jf.intel.com with ESMTP; 20 Aug 2019 15:08:40 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 20 Aug 2019 15:08:39 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 fmsmsx116.amr.corp.intel.com ([169.254.2.181]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 15:08:39 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "hch@lst.de" <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzqcA9LwAgAAIcACAAKWeAIAAbhuAgAA90wCAAAYTAIAAAzOAgAABtICAAAMbAIABkriAgAAUDACAACclAIAAE9WAgADOroCAAAbXAA==
Date:   Tue, 20 Aug 2019 22:08:38 +0000
Message-ID: <85bde038615a6a82d79708fd04944671ca8580c5.camel@intel.com>
References: <20190819000831.GX6129@dread.disaster.area>
         <20190819034948.GA14261@lst.de> <20190819041132.GA14492@lst.de>
         <20190819042259.GZ6129@dread.disaster.area> <20190819042905.GA15613@lst.de>
         <20190819044012.GA15800@lst.de> <20190820044135.GC1119@dread.disaster.area>
         <20190820055320.GB27501@lst.de> <20190820081325.GA21032@ming.t460p>
         <20190820092424.GB21032@ming.t460p>
         <20190820214408.GG1119@dread.disaster.area>
In-Reply-To: <20190820214408.GG1119@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.185]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3DC649C046C4A47BED7A667C3C8711A@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTIxIGF0IDA3OjQ0ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+
IA0KPiBIb3dldmVyLCB0aGUgY2FzZSBoZXJlIGlzIHRoYXQ6DQo+IA0KPiA+ID4gPiA+IGkuZS4g
cGFnZQkJb2Zmc2V0CWxlbglzZWN0b3INCj4gPiA+ID4gPiAwMDAwMDAwMGE3N2YwMTQ2CTc2OAkz
MzI4CTB4N2QwMDQ4DQo+ID4gPiA+ID4gMDAwMDAwMDA2Y2VjYTkxZQkwCTc2OAkweDdkMDA0ZQ0K
PiANCj4gVGhlIHNlY29uZCBwYWdlIGFkZGVkIHRvIHRoZSBidmVjIGlzIGFjdHVhbGx5IG9mZnNl
dCBhbGlnbmVkci4gSGVuY2UNCj4gdGhlIGNoZWNrIHdvdWxkIGRvIG5vdGhpbmcgb24gdGhlIGZp
cnN0IHBhZ2UgYmVjYXVzZSB0aGUgYnZlYyBhcnJheQ0KPiBpcyBlbXB0eSAoc28gZ29lcyBpbnRv
IGEgbmV3IGJ2ZWMgYW55d2F5KSwgYW5kIHRoZSBjaGVjayBvbiB0aGUNCj4gc2Vjb25kIHBhZ2Ug
d291bGQgZG8gbm90aGluZyBhbiBpdCB3b3VsZCBtZXJnZSB3aXRoIGZpcnN0IGJlY2F1c2UNCj4g
dGhlIG9mZnNldCBpcyBhbGlnbmVkIGNvcnJlY3RseS4gSW4gYm90aCBjYXNlcywgdGhlIGxlbmd0
aCBvZiB0aGUNCj4gc2VnbWVudCBpcyBub3QgYWxpZ25lZCwgc28gdGhhdCBuZWVkcyB0byBiZSBj
aGVja2VkLCB0b28uDQo+IA0KPiBJT1dzLCBJIHRoaW5rIHRoZSBjaGVjayBuZWVkcyB0byBiZSBp
biBiaW9fYWRkX3BhZ2UsIGl0IG5lZWRzIHRvDQo+IGNoZWNrIGJvdGggdGhlIG9mZnNldCBhbmQg
bGVuZ3RoIGZvciBhbGlnbm1lbnQsIGFuZCBpdCBuZWVkcyB0byBncmFiDQo+IHRoZSBhbGlnbm1l
bnQgZnJvbSBxdWV1ZV9kbWFfYWxpZ25tZW50KCksIG5vdCB1c2UgYSBoYXJkIGNvZGVkIHZhbHVl
DQo+IG9mIDUxMS4NCj4gDQpTbyBzb21ldGhpbmcgbGlrZSB0aGlzPw0KDQpkaWZmIC0tZ2l0IGEv
YmxvY2svYmlvLmMgYi9ibG9jay9iaW8uYw0KaW5kZXggMjk5YTBlNzY1MWVjLi44MGY0NDlkMjNl
NWEgMTAwNjQ0DQotLS0gYS9ibG9jay9iaW8uYw0KKysrIGIvYmxvY2svYmlvLmMNCkBAIC04MjIs
OCArODIyLDEyIEBAIEVYUE9SVF9TWU1CT0xfR1BMKF9fYmlvX2FkZF9wYWdlKTsNCiBpbnQgYmlv
X2FkZF9wYWdlKHN0cnVjdCBiaW8gKmJpbywgc3RydWN0IHBhZ2UgKnBhZ2UsDQogICAgICAgICAg
ICAgICAgIHVuc2lnbmVkIGludCBsZW4sIHVuc2lnbmVkIGludCBvZmZzZXQpDQogew0KKyAgICAg
ICBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSA9IGJpby0+YmlfZGlzay0+cXVldWU7DQogICAgICAg
IGJvb2wgc2FtZV9wYWdlID0gZmFsc2U7DQogDQorICAgICAgIGlmIChvZmZzZXQgJiBxdWV1ZV9k
bWFfYWxpZ25tZW50KHEpIHx8IGxlbiAmIHF1ZXVlX2RtYV9hbGlnbm1lbnQocSkpDQorICAgICAg
ICAgICAgICAgcmV0dXJuIDA7DQorDQogICAgICAgIGlmICghX19iaW9fdHJ5X21lcmdlX3BhZ2Uo
YmlvLCBwYWdlLCBsZW4sIG9mZnNldCwgJnNhbWVfcGFnZSkpIHsNCiAgICAgICAgICAgICAgICBp
ZiAoYmlvX2Z1bGwoYmlvLCBsZW4pKQ0KICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7
DQoNCkkgdHJpZWQgdGhpcywgYnV0IHRoZSAnbW91bnQnIGp1c3QgaGFuZ3MgLSB3aGljaCBsb29r
cyBsaWtlIGl0IG1pZ2h0IGJlDQpkdWUgdG8geGZzX3J3X2JkZXYoKSBkb2luZzoNCg0KICB3aGls
ZSAoYmlvX2FkZF9wYWdlKGJpbywgcGFnZSwgbGVuLCBvZmYpICE9IGxlbikgew0KICAJLi4uDQoN
Cg==
