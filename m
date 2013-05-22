Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 689757F63
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 03:11:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00FEDAC003
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 01:11:12 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	bFWQMlvAGPJWYJbE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 01:11:11 -0700 (PDT)
Message-ID: <519C7D97.50909@open-e.com>
Date: Wed, 22 May 2013 10:11:03 +0200
From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
MIME-Version: 1.0
Subject: Re: [BUG] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0,
	file: fs/xfs/xfs_mount.c, line: 272
References: <519B6738.9030603@open-e.com> <20130521233937.GX29466@dastard>
In-Reply-To: <20130521233937.GX29466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

SGVsbG8sCj4gT24gVHVlLCBNYXkgMjEsIDIwMTMgYXQgMDI6MjM6MjBQTSArMDIwMCwgQXJrYWRp
dXN6IEJ1YmHFgmEgd3JvdGU6Cj4gICAgCj4+IEhlbGxvLAo+PiBJJ3ZlIGdvdCBhIGNhbGwgdHJh
Y2Ugd2hpY2ggc2hvdWxkIGJlIGZpeGVkIGJ5ICJkcm9wIGJ1ZmZlciBpbwo+PiByZWZlcmVuY2Ug
d2hlbiBhIGJhZCBiaW8gaXMgYnVpbHQiIHBhdGNoCj4+IChodHRwOi8vcGF0Y2h3b3JrLnhmcy5v
cmcvcGF0Y2gvMzk1Ni8pLiBFcnJvciBvY2N1cmVkIG9uIGFscmVhZHkKPj4gcGF0Y2hlZCBMaW51
eCBrZXJuZWwgMy4yLjQyLgo+PiAgICAgIAo+IFRoYXQncyBhbiBvbGQga2VybmVsLiBDYW4geW91
IHJlcHJvZHVjZSBvbiBhIGN1cnJlbnQgVE9UIGtlcm5lbD8KPiBJdCdzIGVudGlyZWx5IHBvc3Np
YmxlIHRoYXQgdGhpcyBwcm9ibGVtIGhhcyBiZWVuIGZpeGVkIGFzIHdlCj4gZGVmaW5pdGVseSBt
YWUgc29tZSBjaGFuZ2VzIHRvIHRoZSBtb3VudCBlcnJvciBoYW5kbGluZyBwYXRoIHNpbmNlCj4g
My4yLi4uLgo+Cj4gICAgCk9rLiBJJ2xsIHRyeS4KPj4gVGVzdCBlbnZpcm9ubWVudCBjb25zaXN0
IHR3byBtYWNoaW5lcyB0YXJnZXQgYW5kIGluaXRpYXRvci4KPj4gRmlyc3QgbWFjaGluZSB3b3Jr
cyBhcyB0YXJnZXQgd2l0aCBRTG9naWMgQ29ycC4gSVNQMjQzMi1iYXNlZCA0R2IKPj4gRmlicmUg
Q2hhbm5lbCBkZXZpY2UuIFN0b3JhZ2UgaXMgcGxhY2VkIG9uIHR3byBLSU5HU1RPTiBTTlY0MjVT
IFNTRAo+PiB3b3JraW5nIGFzIFJBSUQwIGFycmF5LiBSQUlEIGlzIG1hbmFnZWQgYnkgTFNJIE1l
Z2FSQUlEIFNBUyAxMDY4Cj4+IGNvbnRyb2xsZXIuCj4+IFNlY29uZCBtYWNoaW5lIHdvcmtzIGFz
IGluaXRpYXRvciB3aXRoIHRoZSBzYW1lIFFMb2dpYyBjYXJkLgo+Pgo+PiBBZnRlciBmZXcgZGF5
cyBvZiBydW5uaW5nIHRlc3Qgc2NyaXB0IEkgZ290IGZvbGxvd2luZyBjYWxsIHRyYWNlIGFuZAo+
PiBYRlMgc3RvcHBlZCB3b3JraW5nLgo+PiAgICAgIAo+IENhbiB5b3UgbmFycm93IHRoaXMgZG93
biBmcm9tICJ0YWtlcyBzZXZlcmFsIGRheXMiIHRvIHRoZSBzaW1wbGVzdAo+IHBvc3NpYmxlIHJl
cHJvZHVjZXI/IEl0IGhhcHBlbmVkIGR1ZSB0byBJTyBlcnJvcnMgZHVyaW5nIG1vdW50LCBzbwo+
IG1heWJlIHlvdSBjYW4gZGlkIHRoYXQgcGFydCBvdXQgb2YgeW91ciBzY3JpcHQgYW5kIGdpdmUg
dXMgYSB0ZXN0Cj4gY2FzZSB0aGF0IHJlcHJvZHVjZXMgb24gdGhlIGZpcnN0IG1vdW50Pwo+Cj4g
ICAgCkkgJ2xsIHRyeS4gVGhpcyBlcnJvcnMgb2NjdXJzIG9ubHkgb24gaGVhdnkgbG9hZC4KSXMg
dGhlcmUgYW55IHBvc3NpYmlsaXR5IHRvIHNpbXVsYXRlIEkvTyBlcnJvcnMgb24gWEZTIGZpbGVz
eXN0ZW0/CgotLSAKQmVzdCByZWdhcmRzCkFya2FkaXVzeiBCdWJhxYJhCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
