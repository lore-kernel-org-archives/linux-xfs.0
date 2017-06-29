Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0135.outbound.protection.outlook.com ([104.47.40.135]:58272
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbdF2SV4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 14:21:56 -0400
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: RE: [PATCH v8 12/18] Documentation: flesh out the section in vfs.txt
 on storing and reporting writeback errors
Date: Thu, 29 Jun 2017 18:21:50 +0000
Message-ID: <BY2PR21MB003653755FD85FCE2C49393ECBD20@BY2PR21MB0036.namprd21.prod.outlook.com>
References: <20170629131954.28733-1-jlayton@kernel.org>
         <20170629131954.28733-13-jlayton@kernel.org>
         <20170629171137.GE5874@birch.djwong.org>
 <1498760014.22569.13.camel@poochiereds.net>
In-Reply-To: <1498760014.22569.13.camel@poochiereds.net>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@poochiereds.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, "jlayton@kernel.org" <jlayton@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>, "axboe@kernel.dk" <axboe@kernel.dk>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "corbet@lwn.net" <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

RnJvbTogSmVmZiBMYXl0b24gW21haWx0bzpqbGF5dG9uQHBvb2NoaWVyZWRzLm5ldF0NCj4gT24g
VGh1LCAyMDE3LTA2LTI5IGF0IDEwOjExIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6DQo+
ID4gT24gVGh1LCBKdW4gMjksIDIwMTcgYXQgMDk6MTk6NDhBTSAtMDQwMCwgamxheXRvbkBrZXJu
ZWwub3JnIHdyb3RlOg0KPiA+ID4gK0hhbmRsaW5nIGVycm9ycyBkdXJpbmcgd3JpdGViYWNrDQo+
ID4gPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICtNb3N0IGFwcGxp
Y2F0aW9ucyB0aGF0IHV0aWxpemUgdGhlIHBhZ2VjYWNoZSB3aWxsIHBlcmlvZGljYWxseSBjYWxs
DQo+ID4gPiArZnN5bmMgdG8gZW5zdXJlIHRoYXQgZGF0YSB3cml0dGVuIGhhcyBtYWRlIGl0IHRv
IHRoZSBiYWNraW5nIHN0b3JlLg0KPiA+DQo+ID4gL21lIHdvbmRlcnMgaWYgdGhpcyBzZW50ZW5j
ZSBvdWdodCB0byBiZSB3b3JkZWQgbW9yZSBzdHJvbmdseSwgZS5nLg0KPiA+DQo+ID4gIkFwcGxp
Y2F0aW9ucyB0aGF0IHV0aWxpemUgdGhlIHBhZ2VjYWNoZSBtdXN0IGNhbGwgYSBkYXRhDQo+ID4g
c3luY2hyb25pemF0aW9uIHN5c2NhbGwgc3VjaCBhcyBmc3luYywgZmRhdGFzeW5jLCBvciBtc3lu
YyB0byBlbnN1cmUNCj4gPiB0aGF0IGRhdGEgd3JpdHRlbiBoYXMgbWFkZSBpdCB0byB0aGUgYmFj
a2luZyBzdG9yZS4iDQo+IA0KPiBXZWxsLi4ub25seSBpZiB0aGV5IGNhcmUgYWJvdXQgdGhlIGRh
dGEuIFRoZXJlIGFyZSBzb21lIHRoYXQgZG9uJ3QuIDopDQoNCkFsc28sIGFwcGxpY2F0aW9ucyBk
b24ndCAidXRpbGl6ZSB0aGUgcGFnZWNhY2hlIjsgZmlsZXN5c3RlbXMgdXNlIHRoZSBwYWdlY2Fj
aGUuDQpBcHBsaWNhdGlvbnMgbWF5IG9yIG1heSBub3QgdXNlIGNhY2hlZCBJL08uICBIb3cgYWJv
dXQgdGhpczoNCg0KQXBwbGljYXRpb25zIHdoaWNoIGNhcmUgYWJvdXQgZGF0YSBpbnRlZ3JpdHkg
YW5kIHVzZSBjYWNoZWQgSS9PIHdpbGwNCnBlcmlvZGljYWxseSBjYWxsIGZzeW5jKCksIG1zeW5j
KCkgb3IgZmRhdGFzeW5jKCkgdG8gZW5zdXJlIHRoYXQgdGhlaXINCmRhdGEgaXMgZHVyYWJsZS4N
Cg0KPiBXaGF0IHNob3VsZCB3ZSBkbyBhYm91dCBzeW5jX2ZpbGVfcmFuZ2UgaGVyZT8gSXQgZG9l
c24ndCBjdXJyZW50bHkgY2FsbA0KPiBhbnkgZmlsZXN5c3RlbSBvcGVyYXRpb25zIGRpcmVjdGx5
LCBzbyB3ZSBkb24ndCBoYXZlIGEgZ29vZCB3YXkgdG8gbWFrZQ0KPiBpdCBzZWxlY3RpdmVseSB1
c2UgZXJyc2VxX3QgaGFuZGxpbmcgdGhlcmUuDQo+IA0KPiBJIGNvdWxkIHJlc3VycmVjdCB0aGUg
RlNfKiBmbGFnIGZvciB0aGF0LCB0aG91Z2ggSSBkb24ndCByZWFsbHkgbGlrZQ0KPiB0aGF0LiBT
aG91bGQgSSBqdXN0IGdvIGFoZWFkIGFuZCBjb252ZXJ0IGl0IG92ZXIgdG8gdXNlIGVycnNlcV90
IHVuZGVyDQo+IHRoZSB0aGVvcnkgdGhhdCBtb3N0IGNhbGxlcnMgd2lsbCBldmVudHVhbGx5IHdh
bnQgdGhhdCBhbnl3YXk/DQoNCkkgdGhpbmsgc28uDQoNCg==
