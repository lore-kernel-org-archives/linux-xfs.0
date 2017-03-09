Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:39004 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdCIG50 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 01:57:26 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 3/5] fs, xfs: convert xlog_ticket.t_ref from atomic_t to
 refcount_t
Date: Thu, 9 Mar 2017 06:57:07 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C569A2@IRSMSX102.ger.corp.intel.com>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
 <1488963219-11709-4-git-send-email-elena.reshetova@intel.com>
 <20170308155059.GA4353@infradead.org>
 <CAGXu5jK3x+cPe4pccv0Q5W+9eDxu7n3Enih-TVRkysmwDwzGCA@mail.gmail.com>
In-Reply-To: <CAGXu5jK3x+cPe4pccv0Q5W+9eDxu7n3Enih-TVRkysmwDwzGCA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>
Cc: "darrick.wong@oracle.com" <darrick.wong@oracle.com>, LKML <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

DQo+IE9uIFdlZCwgTWFyIDgsIDIwMTcgYXQgNzo1MCBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gPj4gLSAgICAgQVNTRVJUKGF0b21pY19yZWFkKCZ0
aWNrZXQtPnRfcmVmKSA+IDApOw0KPiA+PiAtICAgICBhdG9taWNfaW5jKCZ0aWNrZXQtPnRfcmVm
KTsNCj4gPj4gKyAgICAgQVNTRVJUKHJlZmNvdW50X3JlYWQoJnRpY2tldC0+dF9yZWYpID4gMCk7
DQo+ID4+ICsgICAgIHJlZmNvdW50X2luYygmdGlja2V0LT50X3JlZik7DQo+ID4NCj4gPiBXaXRo
IHN0cmljdCByZWZjb3VudCBzZW1hbnRpY3MgcmVmY291bnRfaW5jIHNob3VsZCBjaGVjayB0aGF0
DQo+ID4gdGhlIGNvdW50IGlzIGxhcmdlciB0aGFuIDAsIG90aGVyd2lzZSB3ZSdkIG5lZWQgdG8g
dXNlDQo+ID4gcmVjb3VudF9pbmNfbm90X3plcm8gb3Igd2hhdGV2ZXIgeW91J3JlIGdvaW5nIHRv
IGNhbGwgaXQuDQo+ID4NCj4gPiBJcyB0aGF0IHNvbWV0aGluZyB0aGUgcmVjb3VudCBjb2RlIGRv
ZXMgLyBjb3VsZCBkbz8NCj4gDQo+IFllcywgcmVmY291bnRfaW5jKCkgd2lsbCBub3QgaW5jcmVt
ZW50IGZyb20gMCBhbmQgV0FSTnMuIEl0IGxvb2tzIGxpa2UNCj4geGZzJ3MgQVNTRVJUIGlzIGFs
c28gYSB3YXJuICh0aG91Z2ggd2l0aCBYRlMtc3BlY2lmaWMgZm9ybWF0dGluZyksIHNvDQo+IHBl
cmhhcHMgdGhlIEFTU0VSVCBjb3VsZCBiZSBkcm9wcGVkPyBJSVVDLCBFbGVuYSdzIGFwcHJvYWNo
IHRvIHRoZXNlDQo+IGNoYW5nZXMgd2FzIHRvIGJlIGNvbnNlcnZhdGl2ZSBhYm91dCByZW1vdmlu
ZyB0aGUgZXhpc3RpbmcgY2hlY2tzLg0KDQpJIGFtIHJlbW92aW5nIHRoZSBleGlzdGluZyBXQVJO
cyBub3cgd2hlcmUgdGhleSBhcmUgMTAwJSBub3QgbmVlZGVkLCBidXQgbGVhdmluZyB0aGUgb25l
cyBsaWtlIHRoaXMgQVNTRVJULCANCmJlY2F1c2UgSSBhbSB0aGlua2luZyB0aGF0IHlvdSBtaWdo
dCBoYXZlIHRlc3QgY2FzZXMgdGhhdCBhcmUgZGVwZW5kZW50IG9uIHRoZXNlIEFTU0VSVHMgd2l0
aCBzcGVjaWZpYyBmb3JtYXR0aW5nIGFuZCBJIGRvbid0IHdhbnQgdG8gYnJlYWsgdGhlbS4gDQpJ
ZiB5b3UgZG9uJ3QgbmVlZCB0aGVtLCBJIGNhbiByZW1vdmUgdGhlbSBhbHNvLiANCg0KQmVzdCBS
ZWdhcmRzLA0KRWxlbmENCg0KPiANCj4gLUtlZXMNCj4gDQo+IC0tDQo+IEtlZXMgQ29vaw0KPiBQ
aXhlbCBTZWN1cml0eQ0K
