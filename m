Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 94FCE7CDF
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 10:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 647DE304067
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 08:01:50 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id 6CHvCc3lQOotXJbP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Apr 2016 08:01:44 -0700 (PDT)
Message-ID: <1461682892.26226.23.camel@kernel.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Vishal Verma <vishal@kernel.org>
Date: Tue, 26 Apr 2016 09:01:32 -0600
In-Reply-To: <20160426083332.GB364@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160426083332.GB364@infradead.org>
Mime-Version: 1.0
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
To: "hch@infradead.org" <hch@infradead.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

T24gVHVlLCAyMDE2LTA0LTI2IGF0IDAxOjMzIC0wNzAwLCBoY2hAaW5mcmFkZWFkLm9yZyB3cm90
ZToKPiBPbiBNb24sIEFwciAyNSwgMjAxNiBhdCAwNToxNDozNlBNICswMDAwLCBWZXJtYSwgVmlz
aGFsIEwgd3JvdGU6Cj4gPiAKPiA+IC0gQXBwbGljYXRpb24gaGl0cyBFSU8gZG9pbmcgZGF4X0lP
IG9yIGxvYWQvc3RvcmUgaW8KPiA+IAo+ID4gLSBJdCBjaGVja3MgYmFkYmxvY2tzIGFuZCBkaXNj
b3ZlcnMgaXQncyBmaWxlcyBoYXZlIGxvc3QgZGF0YQo+ID4gCj4gPiAtIEl0IHdyaXRlKClzIHRo
b3NlIHNlY3RvcnMgKHBvc3NpYmx5IGNvbnZlcnRlZCB0byBmaWxlIG9mZnNldHMKPiA+IHVzaW5n
Cj4gPiBmaWVtYXApCj4gPiA/PyA/PyAqIFRoaXMgdHJpZ2dlcnMgdGhlIGZhbGxiYWNrIHBhdGgs
IGJ1dCBpZiB0aGUgYXBwbGljYXRpb24gaXMKPiA+IGRvaW5nCj4gPiB0aGlzIGxldmVsIG9mIHJl
Y292ZXJ5LCBpdCB3aWxsIGtub3cgdGhlIHNlY3RvciBpcyBiYWQsIGFuZCB3cml0ZQo+ID4gdGhl
Cj4gPiBlbnRpcmUgc2VjdG9yCj4gVGhpcyBzb3VuZHMgbGlrZSBhIG1lc3MuCj4gCj4gPiAKPiA+
IEkgdGhpbmsgaWYgd2Ugd2FudCB0byBrZWVwIGFsbG93aW5nIGFyYml0cmFyeSBhbGlnbm1lbnRz
IGZvciB0aGUKPiA+IGRheF9kb19pbyBwYXRoLCB3ZSdkIG5lZWQ6Cj4gPiAxLiBUbyByZXByZXNl
bnQgYmFkYmxvY2tzIGF0IGEgZmluZXIgZ3JhbnVsYXJpdHkgKGxpa2VseSBjYWNoZQo+ID4gbGlu
ZXMpCj4gPiAyLiBUbyBhbGxvdyB0aGUgZHJpdmVyIHRvIGRvIElPIHRvIGEgKmJsb2NrIGRldmlj
ZSogYXQgc3ViLXNlY3Rvcgo+ID4gZ3JhbnVsYXJpdHkKPiBJdCdzIG5vdCBhIGJsb2NrIGRldmlj
ZSBpZiBpdCBzdXBwb3J0cyBEQVguwqDCoEl0J3MgYnl0ZSBhZGRyZXNzYWJsZQo+IG1lbW9yeSBt
YXNxdWVyYWRpbmcgYXMgYSBibG9jayBkZXZpY2UuCgpZZXMgYnV0IHdlIG1hZGUgdGhhdCBkZWNp
c2lvbiBhIHdoaWxlIGJhY2sgd2l0aCBwbWVtIDopCkFyZSB5b3Ugc2F5aW5nIGl0IHNob3VsZCBz
dG9wIGJlaW5nIGEgYmxvY2sgZGV2aWNlIGFueW1vcmU/Cgo+IC0tCj4gVG8gdW5zdWJzY3JpYmUg
ZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxpbnV4LQo+IGJsb2Nr
IiBpbgo+IHRoZSBib2R5IG9mIGEgbWVzc2FnZSB0byBtYWpvcmRvbW9Admdlci5rZXJuZWwub3Jn
Cj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdMKgwqBodHRwOi8vdmdlci5rZXJuZWwub3JnL21ham9y
ZG9tby1pbmZvLmh0bWwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
