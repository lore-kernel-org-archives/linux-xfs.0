Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10EC07F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:46:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2B7E8F8064
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:46:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OhFzzEsYQlkyD9HB for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 02:46:15 -0700 (PDT)
Date: Tue, 22 Apr 2014 19:46:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Message-ID: <20140422094612.GJ18672@dastard>
References: <20140421204023.GB960@wallace>
	<20140422062816.GB31337@infradead.org>
	<20140422091443.GG15995@dastard>
	<20140422091620.GA4980@infradead.org>
	<alpine.LFD.2.00.1404221127240.7437@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404221127240.7437@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBBcHIgMjIsIDIwMTQgYXQgMTE6Mjg6MzFBTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFR1ZSwgMjIgQXByIDIwMTQsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+
IAo+ID4gRGF0ZTogVHVlLCAyMiBBcHIgMjAxNCAwMjoxNjoyMCAtMDcwMAo+ID4gRnJvbTogQ2hy
aXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZyYWRlYWQub3JnPgo+ID4gVG86IERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4KPiA+IENjOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJh
ZGVhZC5vcmc+LCBsaW51eC1leHQ0QHZnZXIua2VybmVsLm9yZywKPiA+ICAgICB4ZnNAb3NzLnNn
aS5jb20sIEVyaWMgV2hpdG5leSA8ZW53bGludXhAZ21haWwuY29tPgo+ID4gU3ViamVjdDogUmU6
IFtQQVRDSCAxLzNdIHhmc3Rlc3RzOiBhZGQgaGVscGVyIGZvciB6ZXJvIHJhbmdlIHN1cHBvcnQg
Y2hlY2sKPiA+IAo+ID4gT24gVHVlLCBBcHIgMjIsIDIwMTQgYXQgMDc6MTQ6NDNQTSArMTAwMCwg
RGF2ZSBDaGlubmVyIHdyb3RlOgo+ID4gPiBJIGRvbid0IHJlYWxseSBjYXJlIGVpdGhlciB3YXks
IGFzIGxvbmcgYXMgYWxsIHRoZSBjaGVja3MgYXJlIGRvbmUKPiA+ID4gY29uc2lzdGVudGx5LiBT
ZW5kIGEgcGF0Y2ggdG8gY2hhbmdlIHRoZW0gYWxsLi4uIDopCj4gPiAKPiA+IE15IGZsaW5rIHRl
c3QgYWxyZWFkeSBhdm9pZHMgdGhlIHdyYXBwZXIgOikKPiA+IAo+ID4gU28gaG93IGFib3V0IHdl
IHN0b3AgYWRkaW5nIHRoZW0gZm9yIG5vdyBhdCBsZWFzdC4KPiAKPiBJIGFncmVlLAo+IAo+IGV2
ZW4gdGhvdWdoIEkgc2NyZXdlZCB1cCB3aGVuIHVzaW5nIF9yZXF1aXJlX3hmc19pb19jb21tYW5k
IHdpdGgKPiBmemVybyA6KSBJIHRoaW5rIHRoYXQgd2UgY2FuIGF2b2lkIHRoZSB3cmFwcGVycyBh
bmQganVzdCB1c2UKPiBfcmVxdWlyZV94ZnNfaW9fY29tbWFuZCgpIHdpdGggdGhlIGNvbW1hbmQg
bmFtZS4KClNlbmQgcGF0Y2hlcyA7KQoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpk
YXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
