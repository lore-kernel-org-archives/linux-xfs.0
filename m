Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F212C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 17:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 410C221872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 17:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfHZRcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 13:32:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:62952 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbfHZRcp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 13:32:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:32:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="380615865"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga006.fm.intel.com with ESMTP; 26 Aug 2019 10:32:44 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 26 Aug 2019 10:32:44 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 fmsmsx115.amr.corp.intel.com ([169.254.4.219]) with mapi id 14.03.0439.000;
 Mon, 26 Aug 2019 10:32:44 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzqcA9LwAgAAIcACAAKWeAIAMkiyA
Date:   Mon, 26 Aug 2019 17:32:43 +0000
Message-ID: <4b8ea10de04768fe118238c281dfaa5209c9b2c3.camel@intel.com>
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
Content-ID: <1ADAC5BDC7BEC142927EA670B970B8EC@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gU3VuLCAyMDE5LTA4LTE4IGF0IDE5OjM0ICswMjAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBTdW4sIEF1ZyAxOCwgMjAxOSBhdCAwOTo0MTo0MEFNICswMjAwLCBoY2hAbHN0LmRlIHdyb3Rl
Og0KPiA+IE9uIFN1biwgQXVnIDE4LCAyMDE5IGF0IDA5OjExOjI4QU0gKzAyMDAsIGhjaEBsc3Qu
ZGUgd3JvdGU6DQo+ID4gPiA+IFRoZSBrZXJuZWwgbG9nIHNob3dzIHRoZSBmb2xsb3dpbmcgd2hl
biB0aGUgbW91bnQgZmFpbHM6DQo+ID4gPiANCj4gPiA+IElzIGl0IGFsd2F5cyB0aGF0IHNhbWUg
bWVzc2FnZT8gIEknbGwgc2VlIGlmIEkgY2FuIHJlcHJvZHVjZSBpdCwNCj4gPiA+IGJ1dCBJIHdv
bid0IGhhdmUgdGhhdCBtdWNoIG1lbW9yeSB0byBzcGFyZSB0byBjcmVhdGUgZmFrZSBwbWVtLA0K
PiA+ID4gaG9wZSB0aGlzIGFsc28gd29ya3Mgd2l0aCBhIHNpbmdsZSBkZXZpY2UgYW5kL29yIGxl
c3MgbWVtb3J5Li4NCj4gPiANCj4gPiBJJ3ZlIHJlcHJvZHVjZWQgYSBzaW1pbGFyIEFTU0VSVCB3
aXRoIGEgc21hbGwgcG1lbSBkZXZpY2UsIHNvIEkgaG9wZQ0KPiA+IEkgY2FuIGRlYnVnIHRoZSBp
c3N1ZSBsb2NhbGx5IG5vdy4NCj4gDQo+IFNvIEkgY2FuIGFsc28gcmVwcm9kdWNlIHRoZSBzYW1l
IGlzc3VlIHdpdGggdGhlIHJhbWRpc2sgZHJpdmVyLCBidXQgbm90DQo+IHdpdGggYW55IG90aGVy
IDRrIHNlY3RvciBzaXplIGRldmljZSAobnZtZXQsIHNjc2kgdGFyZ2V0LCBzY3NpX2RlYnVnLA0K
PiBsb29wKS4gIFdoaWNoIG1hZGUgbWUgd29uZGVyIGlmIHRoZXJlIGlzIHNvbWUgaXNzdWUgYWJv
dXQgdGhlIG1lbW9yeQ0KPiBwYXNzZWQgaW4sIGFuZCBpbmRlZWQganVzdCBzd2l0Y2hpbmcgdG8g
cGxhaW4gdm1hbGxvYyB2cyB0aGUgWEZTDQo+IGttZW1fYWxsb2NfbGFyZ2Ugd3JhcHBlciB0aGF0
IGVpdGhlciB1c2VzIGttYWxsb2Mgb3Igdm1hbGxvYyBmaXhlcw0KPiB0aGUgaXNzdWUgZm9yIG1l
LiAgSSBkb24ndCByZWFsbHkgdW5kZXJzdGFuZCB3aHkgeWV0LCBtYXliZSBJIG5lZWQgdG8NCj4g
ZGlnIG91dCBhbGlnbm1lbnQgdGVzdGluZyBwYXRjaGVzLg0KPiANCj4gZGlmZiAtLWdpdCBhL2Zz
L3hmcy94ZnNfbG9nX3JlY292ZXIuYyBiL2ZzL3hmcy94ZnNfbG9nX3JlY292ZXIuYw0KPiBpbmRl
eCAxM2QxZDNlOTViODguLjkxOGFkM2I4ODRhNyAxMDA2NDQNCj4gLS0tIGEvZnMveGZzL3hmc19s
b2dfcmVjb3Zlci5jDQo+ICsrKyBiL2ZzL3hmcy94ZnNfbG9nX3JlY292ZXIuYw0KPiBAQCAtMTI1
LDcgKzEyNSw3IEBAIHhsb2dfYWxsb2NfYnVmZmVyKA0KPiAgCWlmIChuYmJsa3MgPiAxICYmIGxv
Zy0+bF9zZWN0QkJzaXplID4gMSkNCj4gIAkJbmJibGtzICs9IGxvZy0+bF9zZWN0QkJzaXplOw0K
PiAgCW5iYmxrcyA9IHJvdW5kX3VwKG5iYmxrcywgbG9nLT5sX3NlY3RCQnNpemUpOw0KPiAtCXJl
dHVybiBrbWVtX2FsbG9jX2xhcmdlKEJCVE9CKG5iYmxrcyksIEtNX01BWUZBSUwpOw0KPiArCXJl
dHVybiB2bWFsbG9jKEJCVE9CKG5iYmxrcykpOw0KDQpJcyB0aGUgcGxhbiB0byB1c2UgdGhpcyB2
bWFsbG9jIGZpeCBmb3IgNS4zPyBJcyB0aGVyZSBhbnl0aGluZyBJIGNhbg0KaGVscCB3aXRoIHRv
IG1ha2UgcHJvZ3Jlc3Mgb24gdGhpcz8NCg0KCS1WaXNoYWwNCg==
