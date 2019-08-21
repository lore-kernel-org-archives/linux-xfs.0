Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8209EC3A589
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 01:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CDD722DD3
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 01:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfHUB4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 21:56:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:16848 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfHUB4f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 21:56:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 18:56:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="378788221"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2019 18:56:34 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 20 Aug 2019 18:56:34 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 FMSMSX110.amr.corp.intel.com ([169.254.14.63]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 18:56:34 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzqcA9LwAgAAIcACAAKWeAIADl9qAgAAE5ICAAAa1gIAADYGA
Date:   Wed, 21 Aug 2019 01:56:33 +0000
Message-ID: <92a9a35a96235fba6537cfdc89cc42603db50fb9.camel@intel.com>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
         <20190818071128.GA17286@lst.de> <20190818074140.GA18648@lst.de>
         <20190818173426.GA32311@lst.de> <20190821002643.GK1119@dread.disaster.area>
         <20190821004413.GB20250@lst.de> <20190821010813.GL1119@dread.disaster.area>
In-Reply-To: <20190821010813.GL1119@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.251.152.70]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0937B63DC8A49A4884A471DB7D389AB5@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTIxIGF0IDExOjA4ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6DQo+
IE9uIFdlZCwgQXVnIDIxLCAyMDE5IGF0IDAyOjQ0OjEzQU0gKzAyMDAsIGhjaEBsc3QuZGUgd3Jv
dGU6DQo+ID4gT24gV2VkLCBBdWcgMjEsIDIwMTkgYXQgMTA6MjY6NDNBTSArMTAwMCwgRGF2ZSBD
aGlubmVyIHdyb3RlOg0KPiA+ID4gQWZ0ZXIgdGhpbmtpbmcgb24gdGhpcyBmb3IgYSBiaXQsIEkg
c3VzcGVjdCB0aGUgYmV0dGVyIHRoaW5nIHRvIGRvDQo+ID4gPiBoZXJlIGlzIGFkZCBhIEtNX0FM
SUdORUQgZmxhZyB0byB0aGUgYWxsb2NhdGlvbiwgc28gaWYgdGhlDQo+ID4gPiBpbnRlcm5hbA0K
PiA+ID4ga21lbV9hbGxvYygpIHJldHVybnMgYW4gdW5hbGlnbmVkIHBvaW50ZXIgd2UgZnJlZSBp
dCBhbmQgZmFsbA0KPiA+ID4gdGhyb3VnaCB0byB2bWFsbG9jKCkgdG8gZ2V0IGEgcHJvcGVybHkg
YWxpZ25lZCBwb2ludGVyLi4uLg0KPiA+ID4gDQo+ID4gPiBUaGF0IHdheSBub25lIG9mIHRoZSBv
dGhlciBpbnRlcmZhY2VzIGhhdmUgdG8gY2hhbmdlLCBhbmQgd2UgY2FuDQo+ID4gPiB0aGVuIHVz
ZSBrbWVtX2FsbG9jX2xhcmdlKCkgZXZlcnl3aGVyZSB3ZSBhbGxvY2F0ZSBidWZmZXJzIGZvciBJ
Ty4NCj4gPiA+IEFuZCB3ZSBkb24ndCBuZWVkIG5ldyBpbmZyYXN0cnVjdHVyZSBqdXN0IHRvIHN1
cHBvcnQgdGhlc2UgZGVidWcNCj4gPiA+IGNvbmZpZ3VyYXRpb25zLCBlaXRoZXIuDQo+ID4gPiAN
Cj4gPiA+IEFjdHVhbGx5LCBrbWVtX2FsbG9jX2lvKCkgbWlnaHQgYmUgYSBiZXR0ZXIgaWRlYSAt
IGtlZXAgdGhlDQo+ID4gPiBhbGlnbmVkDQo+ID4gPiBmbGFnIGludGVybmFsIHRvIHRoZSBrbWVt
IGNvZGUuIFNlZW1zIGxpa2UgYSBwcmV0dHkgc2ltcGxlDQo+ID4gPiBzb2x1dGlvbg0KPiA+ID4g
dG8gdGhlIGVudGlyZSBwcm9ibGVtIHdlIGhhdmUgaGVyZS4uLg0KPiA+IA0KPiA+IFRoZSBpbnRl
cmZhY2Ugc291bmRzIG9rLiAgVGhlIHNpbXBsZSB0cnkgYW5kIGZhbGxiYWNrIGltcGxlbWVudGF0
aW9uDQo+ID4gT1RPSCBtZWFucyB3ZSBhbHdheXMgZG8gdHdvIGFsbG9jYXRpb25zINGWZiBzbHVi
IGRlYnVnZ2luZyBpcw0KPiA+IGVuYWJsZWQsDQo+ID4gd2hpY2ggaXMgYSBsaXR0bGUgbGFzdHku
DQo+IA0KPiBTb21lIGNyZWF0aXZlIGlmZGVmZXJ5IGNvdWxkIGF2b2lkIHRoYXQsIGJ1dCBxdWl0
ZSBmcmFua2x5IGl0J3Mgb25seQ0KPiBuZWNlc3NhcnkgZm9yIGxpbWl0ZWQgYWxsb2NhdGlvbiBj
b250ZXh0cyBhbmQgc28gdGhlDQo+IG92ZXJoZWFkL2ludGVyYWN0aW9ucyB3b3VsZCBsYXJnZWx5
IGJlIHVubm90aWNhYmxlIGNvbXBhcmVkIHRvIHRoZQ0KPiB3aWRlciBpbXBhY3Qgb2YgbWVtb3J5
IGRlYnVnZ2luZy4uLg0KPiANCj4gPiBJIGd1ZXNzIHRoZSBiZXN0IHdlIGNhbiBkbyBmb3IgNS4z
IGFuZA0KPiA+IHRoZW4gZmlndXJlIG91dCBhIHdheSB0byBhdm9pZCBmb3IgbGF0ZXIuDQo+IA0K
PiBZZWFoLCBpdCBhbHNvIGhhcyB0aGUgYWR2YW50YWdlIG9mIGRvY3VtZW50aW5nIGFsbCB0aGUg
cGxhY2VzIHdlDQo+IG5lZWQgdG8gYmUgY2FyZWZ1bCBvZiBhbGxvY2F0aW9uIGFsaWdubWVudCwg
YW5kIGl0IHdvdWxkIGFsbG93IHVzIHRvDQo+IHNpbXBseSBwbHVnIGluIHdoYXRldmVyIGZ1dHVy
ZSBpbmZyYXN0cnVjdHVyZSBjb21lcyBhbG9uZyB0aGF0DQo+IGd1YXJhbnRlZXMgYWxsb2NhdGlv
biBhbGlnbm1lbnQgd2l0aG91dCBjaGFuZ2luZyBhbnkgb3RoZXIgWEZTDQo+IGNvZGUuLi4NCg0K
SnVzdCB0byBjbGFyaWZ5LCB0aGlzIHByZWNsdWRlcyB0aGUgY2hhbmdlcyB0byBiaW9fYWRkX3Bh
Z2UoKSB5b3UNCnN1Z2dlc3RlZCBlYXJsaWVyLCByaWdodD8NCg0KDQo=
