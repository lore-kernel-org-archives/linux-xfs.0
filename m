Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05228C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 17:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA19F2087E
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 17:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfHSRTr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 13:19:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:39979 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfHSRTr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 13:19:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 10:19:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="172187975"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2019 10:19:46 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 FMSMSX108.amr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Mon, 19 Aug 2019 10:19:45 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzqcA9LwAgAAIcACAAKWeAIABjjkA
Date:   Mon, 19 Aug 2019 17:19:44 +0000
Message-ID: <e406b35363cba77f9e87ff80522f026b3634a3c0.camel@intel.com>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
         <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de>
         <20190818173426.GA32311@lst.de>
In-Reply-To: <20190818173426.GA32311@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.185]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEEED67E58C9AE4AAD56E3E3FAB8A1C9@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gU3VuLCAyMDE5LTA4LTE4IGF0IDE5OjM0ICswMjAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiAN
Cj4gU28gSSBjYW4gYWxzbyByZXByb2R1Y2UgdGhlIHNhbWUgaXNzdWUgd2l0aCB0aGUgcmFtZGlz
ayBkcml2ZXIsIGJ1dCBub3QNCj4gd2l0aCBhbnkgb3RoZXIgNGsgc2VjdG9yIHNpemUgZGV2aWNl
IChudm1ldCwgc2NzaSB0YXJnZXQsIHNjc2lfZGVidWcsDQo+IGxvb3ApLiAgV2hpY2ggbWFkZSBt
ZSB3b25kZXIgaWYgdGhlcmUgaXMgc29tZSBpc3N1ZSBhYm91dCB0aGUgbWVtb3J5DQo+IHBhc3Nl
ZCBpbiwgYW5kIGluZGVlZCBqdXN0IHN3aXRjaGluZyB0byBwbGFpbiB2bWFsbG9jIHZzIHRoZSBY
RlMNCj4ga21lbV9hbGxvY19sYXJnZSB3cmFwcGVyIHRoYXQgZWl0aGVyIHVzZXMga21hbGxvYyBv
ciB2bWFsbG9jIGZpeGVzDQo+IHRoZSBpc3N1ZSBmb3IgbWUuICBJIGRvbid0IHJlYWxseSB1bmRl
cnN0YW5kIHdoeSB5ZXQsIG1heWJlIEkgbmVlZCB0bw0KPiBkaWcgb3V0IGFsaWdubWVudCB0ZXN0
aW5nIHBhdGNoZXMuDQoNCldpdGggdGhlIHBhdGNoIGJlbG93LCBJIGNhbid0IHJlcHJvZHVjZSB0
aGUgZmFpbHVyZSAtIGlmIHRoaXMgaXMgZ29pbmcNCmludG8gNS4zLXJjLCBmZWVsIGZyZWUgdG8g
YWRkOg0KDQpUZXN0ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19sb2dfcmVjb3Zlci5jIGIvZnMveGZz
L3hmc19sb2dfcmVjb3Zlci5jDQo+IGluZGV4IDEzZDFkM2U5NWI4OC4uOTE4YWQzYjg4NGE3IDEw
MDY0NA0KPiAtLS0gYS9mcy94ZnMveGZzX2xvZ19yZWNvdmVyLmMNCj4gKysrIGIvZnMveGZzL3hm
c19sb2dfcmVjb3Zlci5jDQo+IEBAIC0xMjUsNyArMTI1LDcgQEAgeGxvZ19hbGxvY19idWZmZXIo
DQo+ICAJaWYgKG5iYmxrcyA+IDEgJiYgbG9nLT5sX3NlY3RCQnNpemUgPiAxKQ0KPiAgCQluYmJs
a3MgKz0gbG9nLT5sX3NlY3RCQnNpemU7DQo+ICAJbmJibGtzID0gcm91bmRfdXAobmJibGtzLCBs
b2ctPmxfc2VjdEJCc2l6ZSk7DQo+IC0JcmV0dXJuIGttZW1fYWxsb2NfbGFyZ2UoQkJUT0IobmJi
bGtzKSwgS01fTUFZRkFJTCk7DQo+ICsJcmV0dXJuIHZtYWxsb2MoQkJUT0IobmJibGtzKSk7DQo+
ICB9DQo+ICANCj4gIC8qDQo+IEBAIC00MTYsNyArNDE2LDcgQEAgeGxvZ19maW5kX3ZlcmlmeV9j
eWNsZSgNCj4gIAkqbmV3X2JsayA9IC0xOw0KPiAgDQo+ICBvdXQ6DQo+IC0Ja21lbV9mcmVlKGJ1
ZmZlcik7DQo+ICsJdmZyZWUoYnVmZmVyKTsNCj4gIAlyZXR1cm4gZXJyb3I7DQo+ICB9DQo+ICAN
Cj4gQEAgLTUyNyw3ICs1MjcsNyBAQCB4bG9nX2ZpbmRfdmVyaWZ5X2xvZ19yZWNvcmQoDQo+ICAJ
CSpsYXN0X2JsayA9IGk7DQo+ICANCj4gIG91dDoNCj4gLQlrbWVtX2ZyZWUoYnVmZmVyKTsNCj4g
Kwl2ZnJlZShidWZmZXIpOw0KPiAgCXJldHVybiBlcnJvcjsNCj4gIH0NCj4gIA0KPiBAQCAtNzgx
LDcgKzc4MSw3IEBAIHhsb2dfZmluZF9oZWFkKA0KPiAgCQkJZ290byBvdXRfZnJlZV9idWZmZXI7
DQo+ICAJfQ0KPiAgDQo+IC0Ja21lbV9mcmVlKGJ1ZmZlcik7DQo+ICsJdmZyZWUoYnVmZmVyKTsN
Cj4gIAlpZiAoaGVhZF9ibGsgPT0gbG9nX2JibnVtKQ0KPiAgCQkqcmV0dXJuX2hlYWRfYmxrID0g
MDsNCj4gIAllbHNlDQo+IEBAIC03OTUsNyArNzk1LDcgQEAgeGxvZ19maW5kX2hlYWQoDQo+ICAJ
cmV0dXJuIDA7DQo+ICANCj4gIG91dF9mcmVlX2J1ZmZlcjoNCj4gLQlrbWVtX2ZyZWUoYnVmZmVy
KTsNCj4gKwl2ZnJlZShidWZmZXIpOw0KPiAgCWlmIChlcnJvcikNCj4gIAkJeGZzX3dhcm4obG9n
LT5sX21wLCAiZmFpbGVkIHRvIGZpbmQgbG9nIGhlYWQiKTsNCj4gIAlyZXR1cm4gZXJyb3I7DQo+
IEBAIC0xMDQ5LDcgKzEwNDksNyBAQCB4bG9nX3ZlcmlmeV90YWlsKA0KPiAgCQkiVGFpbCBibG9j
ayAoMHglbGx4KSBvdmVyd3JpdGUgZGV0ZWN0ZWQuIFVwZGF0ZWQgdG8gMHglbGx4IiwNCj4gIAkJ
CSBvcmlnX3RhaWwsICp0YWlsX2Jsayk7DQo+ICBvdXQ6DQo+IC0Ja21lbV9mcmVlKGJ1ZmZlcik7
DQo+ICsJdmZyZWUoYnVmZmVyKTsNCj4gIAlyZXR1cm4gZXJyb3I7DQo+ICB9DQo+ICANCj4gQEAg
LTEwOTYsNyArMTA5Niw3IEBAIHhsb2dfdmVyaWZ5X2hlYWQoDQo+ICAJZXJyb3IgPSB4bG9nX3Jz
ZWVrX2xvZ3JlY19oZHIobG9nLCAqaGVhZF9ibGssICp0YWlsX2JsaywNCj4gIAkJCQkgICAgICBY
TE9HX01BWF9JQ0xPR1MsIHRtcF9idWZmZXIsDQo+ICAJCQkJICAgICAgJnRtcF9yaGVhZF9ibGss
ICZ0bXBfcmhlYWQsICZ0bXBfd3JhcHBlZCk7DQo+IC0Ja21lbV9mcmVlKHRtcF9idWZmZXIpOw0K
PiArCXZmcmVlKHRtcF9idWZmZXIpOw0KPiAgCWlmIChlcnJvciA8IDApDQo+ICAJCXJldHVybiBl
cnJvcjsNCj4gIA0KPiBAQCAtMTQyOSw3ICsxNDI5LDcgQEAgeGxvZ19maW5kX3RhaWwoDQo+ICAJ
CWVycm9yID0geGxvZ19jbGVhcl9zdGFsZV9ibG9ja3MobG9nLCB0YWlsX2xzbik7DQo+ICANCj4g
IGRvbmU6DQo+IC0Ja21lbV9mcmVlKGJ1ZmZlcik7DQo+ICsJdmZyZWUoYnVmZmVyKTsNCj4gIA0K
PiAgCWlmIChlcnJvcikNCj4gIAkJeGZzX3dhcm4obG9nLT5sX21wLCAiZmFpbGVkIHRvIGxvY2F0
ZSBsb2cgdGFpbCIpOw0KPiBAQCAtMTQ3Nyw3ICsxNDc3LDcgQEAgeGxvZ19maW5kX3plcm9lZCgN
Cj4gIAlmaXJzdF9jeWNsZSA9IHhsb2dfZ2V0X2N5Y2xlKG9mZnNldCk7DQo+ICAJaWYgKGZpcnN0
X2N5Y2xlID09IDApIHsJCS8qIGNvbXBsZXRlbHkgemVyb2VkIGxvZyAqLw0KPiAgCQkqYmxrX25v
ID0gMDsNCj4gLQkJa21lbV9mcmVlKGJ1ZmZlcik7DQo+ICsJCXZmcmVlKGJ1ZmZlcik7DQo+ICAJ
CXJldHVybiAxOw0KPiAgCX0NCj4gIA0KPiBAQCAtMTQ4OCw3ICsxNDg4LDcgQEAgeGxvZ19maW5k
X3plcm9lZCgNCj4gIA0KPiAgCWxhc3RfY3ljbGUgPSB4bG9nX2dldF9jeWNsZShvZmZzZXQpOw0K
PiAgCWlmIChsYXN0X2N5Y2xlICE9IDApIHsJCS8qIGxvZyBjb21wbGV0ZWx5IHdyaXR0ZW4gdG8g
Ki8NCj4gLQkJa21lbV9mcmVlKGJ1ZmZlcik7DQo+ICsJCXZmcmVlKGJ1ZmZlcik7DQo+ICAJCXJl
dHVybiAwOw0KPiAgCX0NCj4gIA0KPiBAQCAtMTUzNSw3ICsxNTM1LDcgQEAgeGxvZ19maW5kX3pl
cm9lZCgNCj4gIA0KPiAgCSpibGtfbm8gPSBsYXN0X2JsazsNCj4gIG91dF9mcmVlX2J1ZmZlcjoN
Cj4gLQlrbWVtX2ZyZWUoYnVmZmVyKTsNCj4gKwl2ZnJlZShidWZmZXIpOw0KPiAgCWlmIChlcnJv
cikNCj4gIAkJcmV0dXJuIGVycm9yOw0KPiAgCXJldHVybiAxOw0KPiBAQCAtMTY0Nyw3ICsxNjQ3
LDcgQEAgeGxvZ193cml0ZV9sb2dfcmVjb3JkcygNCj4gIAl9DQo+ICANCj4gIG91dF9mcmVlX2J1
ZmZlcjoNCj4gLQlrbWVtX2ZyZWUoYnVmZmVyKTsNCj4gKwl2ZnJlZShidWZmZXIpOw0KPiAgCXJl
dHVybiBlcnJvcjsNCj4gIH0NCj4gIA0KPiBAQCAtNTI5MSw3ICs1MjkxLDcgQEAgeGxvZ19kb19y
ZWNvdmVyeV9wYXNzKA0KPiAgCQkJaGJsa3MgPSBoX3NpemUgLyBYTE9HX0hFQURFUl9DWUNMRV9T
SVpFOw0KPiAgCQkJaWYgKGhfc2l6ZSAlIFhMT0dfSEVBREVSX0NZQ0xFX1NJWkUpDQo+ICAJCQkJ
aGJsa3MrKzsNCj4gLQkJCWttZW1fZnJlZShoYnApOw0KPiArCQkJdmZyZWUoaGJwKTsNCj4gIAkJ
CWhicCA9IHhsb2dfYWxsb2NfYnVmZmVyKGxvZywgaGJsa3MpOw0KPiAgCQl9IGVsc2Ugew0KPiAg
CQkJaGJsa3MgPSAxOw0KPiBAQCAtNTMwNyw3ICs1MzA3LDcgQEAgeGxvZ19kb19yZWNvdmVyeV9w
YXNzKA0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIAlkYnAgPSB4bG9nX2FsbG9jX2J1ZmZlcihs
b2csIEJUT0JCKGhfc2l6ZSkpOw0KPiAgCWlmICghZGJwKSB7DQo+IC0JCWttZW1fZnJlZShoYnAp
Ow0KPiArCQl2ZnJlZShoYnApOw0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIAl9DQo+ICANCj4g
QEAgLTU0NjgsOSArNTQ2OCw5IEBAIHhsb2dfZG9fcmVjb3ZlcnlfcGFzcygNCj4gIAl9DQo+ICAN
Cj4gICBicmVhZF9lcnIyOg0KPiAtCWttZW1fZnJlZShkYnApOw0KPiArCXZmcmVlKGRicCk7DQo+
ICAgYnJlYWRfZXJyMToNCj4gLQlrbWVtX2ZyZWUoaGJwKTsNCj4gKwl2ZnJlZShoYnApOw0KPiAg
DQo+ICAJLyoNCj4gIAkgKiBTdWJtaXQgYnVmZmVycyB0aGF0IGhhdmUgYmVlbiBhZGRlZCBmcm9t
IHRoZSBsYXN0IHJlY29yZCBwcm9jZXNzZWQsDQoNCg==
