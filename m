Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F41857CA4
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 13:46:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6081304039
	for <xfs@oss.sgi.com>; Sun,  8 May 2016 11:46:15 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	d6J5PvlqwEcdAtxa for <xfs@oss.sgi.com>;
	Sun, 08 May 2016 11:46:14 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v5 3/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
Date: Sun, 8 May 2016 18:46:13 +0000
Message-ID: <1462733173.3006.7.camel@intel.com>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
	<1462571591-3361-4-git-send-email-vishal.l.verma@intel.com>
	<20160508085203.GA10160@infradead.org>
In-Reply-To: <20160508085203.GA10160@infradead.org>
Content-Language: en-US
Content-ID: <D60809FA56FCC54089DF6F708EA1BE89@intel.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "hch@infradead.org" <hch@infradead.org>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "boaz@plexistor.com" <boaz@plexistor.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

T24gU3VuLCAyMDE2LTA1LTA4IGF0IDAxOjUyIC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gRnJpLCBNYXkgMDYsIDIwMTYgYXQgMDM6NTM6MDlQTSAtMDYwMCwgVmlzaGFsIFZl
cm1hIHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IE1hdHRoZXcgV2lsY294IDxtYXR0aGV3LnIud2ls
Y294QGludGVsLmNvbT4NCj4gPiANCj4gPiBkYXhfY2xlYXJfc2VjdG9ycygpIGNhbm5vdCBoYW5k
bGUgcG9pc29uZWQgYmxvY2tzLsKgwqBUaGVzZSBtdXN0IGJlDQo+ID4gemVyb2VkIHVzaW5nIHRo
ZSBCSU8gaW50ZXJmYWNlIGluc3RlYWQuwqDCoENvbnZlcnQgZXh0MiBhbmQgWEZTIHRvDQo+ID4g
dXNlDQo+ID4gb25seSBzYl9pc3N1ZV96ZXJvdXQoKS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5
OiBNYXR0aGV3IFdpbGNveCA8bWF0dGhldy5yLndpbGNveEBpbnRlbC5jb20+DQo+ID4gW3Zpc2hh
bDogQWxzbyByZW1vdmUgdGhlIGRheF9jbGVhcl9zZWN0b3JzIGZ1bmN0aW9uIGVudGlyZWx5XQ0K
PiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KPiBKdXN0IHRvIG1ha2Ugc3VyZTrCoMKgdGhlIGV4aXN0aW5nIHNiX2lzc3VlX3plcm91dCBh
cyBpbiA0LjYtcmMNCj4gaXMgYWxyZWFkeSBkb2luZyB0aGUgcmlnaHQgdGhpbmcgZm9yIERBWD/C
oMKgSSd2ZSBnb3QgYSBwZW5kaW5nDQo+IHBhdGNoc2V0DQo+IGZvciBYRlMgdGhhdCBpbnRyb2R1
Y2VzIGFub3RoZXIgZGF4X2NsZWFyX3NlY3RvcnMgdXNlcnMsIGJ1dCBpZiBpdCdzDQo+IGFscmVh
ZHkgc2FmZSB0byB1c2UgYmxrZGV2X2lzc3VlX3plcm9vdXQgSSBjYW4gc3dpdGNoIHRvIHRoYXQg
YW5kDQo+IGF2b2lkDQo+IHRoZSBtZXJnZSBjb25mbGljdC4NCg0KSSBiZWxpZXZlIHNvIC0gSmFu
IGhhcyBtb3ZlZCBhbGwgdW53cml0dGVuIGV4dGVudCBjb252ZXJzaW9ucyBvdXQgb2YNCkRBWCB3
aXRoIGhpcyBwYXRjaCBzZXQsIGFuZCBJIGJlbGlldmUgemVyb2luZyB0aHJvdWdoIHRoZSBkcml2
ZXIgaXMNCmFsd2F5cyBmaW5lLiBSb3NzIG9yIEphbiBjb3VsZCBjb25maXJtIHRob3VnaC7CoApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
