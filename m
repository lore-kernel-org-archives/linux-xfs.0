Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12316 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdJCUco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:32:44 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Date: Tue, 3 Oct 2017 20:32:39 +0000
Message-ID: <1507062758.2567.22.camel@wdc.com>
References: <20171003185313.1017-1-mcgrof@kernel.org>
         <20171003185313.1017-3-mcgrof@kernel.org> <1507060941.2567.6.camel@wdc.com>
         <20171003202335.GF2294@wotan.suse.de>
In-Reply-To: <20171003202335.GF2294@wotan.suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <7893554CB41F9846846273F6834A9827@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

T24gVHVlLCAyMDE3LTEwLTAzIGF0IDIyOjIzICswMjAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gT24gVHVlLCBPY3QgMDMsIDIwMTcgYXQgMDg6MDI6MjJQTSArMDAwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxNy0xMC0wMyBhdCAxMTo1MyAtMDcwMCwgTHVp
cyBSLiBSb2RyaWd1ZXogd3JvdGU6DQo+ID4gPiArc3RhdGljIGJvb2wgc3VwZXJfYWxsb3dzX2Zy
ZWV6ZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQ0KPiA+ID4gK3sNCj4gPiA+ICsJcmV0dXJuICEh
KHNiLT5zX3R5cGUtPmZzX2ZsYWdzICYgRlNfRlJFRVpFX09OX1NVU1BFTkQpOw0KPiA+ID4gK30N
Cj4gPiANCj4gPiBBIG1pbm9yIGNvbW1lbnQ6IGlmICIhISIgd291bGQgYmUgbGVmdCBvdXQgdGhl
IGNvbXBpbGVyIHdpbGwgcGVyZm9ybSB0aGUNCj4gPiBjb252ZXJzaW9uIGZyb20gaW50IHRvIGJv
b2wgaW1wbGljaXRseQ0KPiANCj4gRm9yIGFsbCBjb21waWxlcnM/DQoNCkxldCdzIGhhdmUgYSBs
b29rIGF0IHRoZSBvdXRwdXQgb2YgdGhlIGZvbGxvd2luZyBjb21tYW5kczoNCg0KJCBQQUdFUj0g
Z2l0IGdyZXAgJ3R5cGVkZWYuKltbOmJsYW5rOl1dYm9vbDsnIGluY2x1ZGUNCmluY2x1ZGUvbGlu
dXgvdHlwZXMuaDp0eXBlZGVmIF9Cb29sICAgICAgICAgICAgICAgICAgICAgYm9vbDsNCiQgUEFH
RVI9IGdpdCBncmVwIHN0ZD0gTWFrZWZpbGUNCk1ha2VmaWxlOiAgICAgICAgICAgICAgIC1mb21p
dC1mcmFtZS1wb2ludGVyIC1zdGQ9Z251ODkgJChIT1NUX0xGU19DRkxBR1MpDQpNYWtlZmlsZTog
ICAgICAgICAgICAgICAgICAtc3RkPWdudTg5ICQoY2FsbCBjYy1vcHRpb24sLWZuby1QSUUpDQoN
CkZyb20gaHR0cHM6Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2djYy03LjIuMC9nY2MvQy1EaWFs
ZWN0LU9wdGlvbnMuaHRtbCNDLURpYWxlY3QtT3B0aW9uczoNCuKAmGdudTg54oCZDQpHTlUgZGlh
bGVjdCBvZiBJU08gQzkwIChpbmNsdWRpbmcgc29tZSBDOTkgZmVhdHVyZXMpLg0KDQpJIHRoaW5r
IHRoaXMgbWVhbnMgdGhhdCB0aGUgTGludXgga2VybmVsIHRyZWUgY2FuIG9ubHkgYmUgY29tcGls
ZWQgY29ycmVjdGx5DQpieSBjb21waWxlcnMgdGhhdCBzdXBwb3J0IHRoZSBDMTEgdHlwZSBfQm9v
bC4NCg0KPiA+IEFueXdheSwgSSBhZ3JlZSB3aXRoIHRoZSBhcHByb2FjaCBvZiB0aGlzIHBhdGNo
IGFuZCBJIHRoaW5rDQo+ID4gdGhhdCBmcmVlemluZyBmaWxlc3lzdGVtcyBiZWZvcmUgcHJvY2Vz
c2VzIGFyZSBmcm96ZW4gd291bGQgYmUgYSBiaWcgc3RlcA0KPiA+IGZvcndhcmQuDQo+IA0KPiBH
cmVhdCEgQnV0IHBsZWFzZSBub3RlLCB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBjYWxscyBm
c19zdXNwZW5kX2ZyZWV6ZSgpDQo+ICphZnRlciogdHJ5X3RvX2ZyZWV6ZV90YXNrcygpLCBpZTog
dGhpcyBpbXBsZW1lbnRhdGlvbiBmcmVlemVzIHVzZXJzcGFjZSBhbmQNCj4gb25seSBhZnRlciB0
aGVuIGZpbGVzeXN0ZW1zLg0KDQpXaGF0IHdpbGwgdGhlIGltcGFjdCBiZSBvZiB0aGF0IGNob2lj
ZSBvbiBmaWxlc3lzdGVtcyBpbXBsZW1lbnRlZCBpbiB1c2Vyc3BhY2U/DQoNClRoYW5rcywNCg0K
QmFydC4=
