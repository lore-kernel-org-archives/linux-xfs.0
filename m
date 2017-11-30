Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25091 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbdK3Ux5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 15:53:57 -0500
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Date: Thu, 30 Nov 2017 20:53:52 +0000
Message-ID: <1512075231.2774.17.camel@wdc.com>
References: <20171129232356.28296-1-mcgrof@kernel.org>
         <1512061271.2774.10.camel@wdc.com> <20171130194249.GK729@wotan.suse.de>
In-Reply-To: <20171130194249.GK729@wotan.suse.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F388E6E5968B94FAA774C73F77B55F3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "mcgrof@kernel.org" <mcgrof@kernel.org>
Cc: "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "yu.chen.surf@gmail.com" <yu.chen.surf@gmail.com>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

T24gVGh1LCAyMDE3LTExLTMwIGF0IDIwOjQyICswMTAwLCBMdWlzIFIuIFJvZHJpZ3VleiB3cm90
ZToNCj4gT24gVGh1LCBOb3YgMzAsIDIwMTcgYXQgMDU6MDE6MTNQTSArMDAwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOg0KPiA+IFRoZSBtZCByZXN5bmMNCj4gPiB0aHJlYWQgbXVzdCBiZSBzdG9w
cGVkIGJlZm9yZSBhIHN5c3RlbSBpcyBmcm96ZW4uIFRvZGF5IHRoZSBtZCBkcml2ZXIgdXNlcw0K
PiA+IHRoZSBrdGhyZWFkIGZyZWV6aW5nIG1lY2hhbmlzbSBmb3IgdGhhdCBwdXJwb3NlLiBEbyB5
b3UgaGF2ZSBhIHBsYW4gZm9yDQo+ID4gaGFuZGxpbmcgdGhlIG1vcmUgY29tcGxpY2F0ZWQgc2Nl
bmFyaW9zLCBlLmcuIGEgZmlsZXN5c3RlbSB0aGF0IGV4aXN0cyBvbiB0b3ANCj4gPiBvZiBhbiBt
ZCBkZXZpY2Ugd2hlcmUgdGhlIG1kIGRldmljZSB1c2VzIG9uZSBvciBtb3JlIGZpbGVzIGFzIGJh
Y2tpbmcgc3RvcmUNCj4gPiBhbmQgd2l0aCB0aGUgbG9vcCBkcml2ZXIgYmV0d2VlbiB0aGUgbWQg
ZGV2aWNlIGFuZCB0aGUgZmlsZXM/DQo+IA0KPiBOb3BlIG5vdCB5ZXQuIEl0IHNlZW1zIHlvdSBo
YXZlIGdpdmVuIHRoaXMgc29tZSB0aG91Z2h0IHRob3VnaCBzbyB5b3UncmUgDQo+IGhlbHAgaGVy
ZSBpcyBncmVhdGx5IGFwcHJlY2lhdGVkLiBJbiBmYWN0IHRoZSB3YXkgd2Ugc2hvdWxkIHNlZSB0
aGUgbG9uZw0KPiB0ZXJtICdraWxsIGt0aHJlYWQgZnJlZXppbmcnIGVmZm9ydCBzaG91bGQgYmUg
YSBjb2xsYWJvcmF0aXZlIG9uZS4gSSd2ZQ0KPiBuZXZlciB0b3VjaGVkIG1kLCBzbyBmb2xrcyBt
b3JlIGZhbWlsaWFyIHdpdGggbWQgc2hvdWxkIGdpdmUgdGhpcyBzb21lDQo+IHRob3VnaHQuDQo+
IA0KPiBDYW4gZm9yIGluc3RhbmNlIG1kIHJlZ2lzdGVyX3BtX25vdGlmaWVyKCkgYW5kIHJlZ2lz
dGVyX3N5c2NvcmVfb3BzKCkNCj4gYW5kIGRvIGhhbmR5IHdvcmsgdG8gcGF1c2Ugc29tZSB3b3Jr
IHRvIHJlcGxhY2Uga3RocmVhZCBmcmVlemluZz8NCj4gTm90ZSB0aGF0IEkgYmVsaWV2ZSBhIHBt
IG5vdGlmaWVyIGlzIG5lZWRlZCBpbiBjYXNlIHN5c2NvcmVfc3VzcGVuZCgpDQo+IGlzIG5vdCBj
YWxsZWQsIHNheSBvbiBhIHN1c3BlbmQgZmFpbC4NCg0KU29ycnkgYnV0IEkgZG9uJ3QgdGhpbmsg
dGhhdCBhIHNvbHV0aW9uIGNhbiBiZSBiYXNlZCBvbiBhIG5vdGlmaWVyIG1lY2hhbmlzbS4NCkZy
ZWV6aW5nIGhhcyB0byBoYXBwZW4gaW4gdGhlIG9yZGVyIGluIHdoaWNoIGRyaXZlcnMgYW5kIGZp
bGVzeXN0ZW1zIGhhdmUNCmJlZW4gc3RhY2tlZCAoZmlsZXN5c3RlbSA+IG1kIGRldmljZSA+IGZp
bGVzeXN0ZW0gZm9yIHRoZSBhYm92ZSBleGFtcGxlKS4NClNpbmNlIHRoZSBvcmRlciBpbiB3aGlj
aCBub3RpZmllcnMgYXJlIGNhbGxlZCBpcyByZWxhdGVkIHRvIHRoZSBvcmRlciBpbg0Kd2hpY2gg
bm90aWZpZXJzIGhhdmUgYmVlbiByZWdpc3RlcmVkIEkgZG9uJ3QgdGhpbmsgdGhhdCBhIHNvbHV0
aW9uIGZvciB0aGUNCmV4YW1wbGUgSSBkZXNjcmliZWQgY2FuIGJlIGJhc2VkIG9uIG5vdGlmaWVy
cy4gV2hhdCBJIHRoaW5rIHdlIG5lZWQgaXMgYQ0KbWVjaGFuaXNtIGZvciB0cmF2ZXJzaW5nIHRo
ZSBzdG9yYWdlIHN0YWNrIHRoYXQgaW5jbHVkZXMgYmxvY2sgZHJpdmVycyBhbmQNCmFuIGVxdWl2
YWxlbnQgb2YgZnJlZXplX2ZzKCkgZm9yIGJsb2NrIGRyaXZlcnMuIEZyZWV6aW5nIHNob3VsZCBv
Y2N1ciBieQ0KY2FsbGluZyB0aGUgZnJlZXplX2ZzKCkgbWV0aG9kcyBmb3IgZWFjaCBzdG9yYWdl
IGxheWVyIHN0YXJ0aW5nIGF0IHRoZSB0b3Agb2YNCnRoZSBzdG9yYWdlIHN0YWNrIGFuZCBwcm9j
ZWVkaW5nIHRvd2FyZHMgdGhlIGJvdHRvbS4NCg0KQmFydC4=
