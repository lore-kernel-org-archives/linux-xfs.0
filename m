Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FB0M2J091592 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 05:00:22 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23A0C1514F31
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 03:01:18 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id iIgUV7upY1xvGrw5 for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 03:01:18 -0800 (PST)
Message-ID: <4B504B03.7050604@news-service.com>
Date: Fri, 15 Jan 2010 12:01:23 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31 xfs_fs_destroy_inode:
	cannot reclaim)
References: <89c4f90c0910270341r7833f490g60810f2817eb0950@mail.gmail.com>	<89c4f90c0910280519k759230c1r7b1586932ac792f7@mail.gmail.com>	<20091030101601.GA11142@infradead.org>	<4AF0422D.1070104@news-service.com>	<20091114162126.GB17658@infradead.org>	<4B0A8075.8080008@news-service.com>	<20091211115932.GA20632@infradead.org>	<4B3F9F88.9030307@news-service.com>	<20100107110446.GA13802@discord.disaster>	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
In-Reply-To: <20100108113114.GA8654@discord.disaster>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

SGkgRGF2ZSwKCkkgdGhpbmsgaXQncyBzYXZlIHRvIGNvbnNpZGVyIHRoaXMgaXNzdWUgZml4ZWQu
IFdlIGhhdmUgY3VycmVudGx5IDkgCnNlcnZlcnMgb3BlcmF0aW9uYWwgd2l0aCB0aGVzZSBwYXRj
aGVzIGFuZCB0aGV5IGhhdmUgYmVlbiBzdGFibGUgc28gZmFyLiAKRm9yIGEgMTAwJSBjZXJ0YWlu
dHkgd2UnbGwgaGF2ZSB0byB0ZXN0L3dhaXQgYSBsaXR0bGUgYml0IGxvbmdlciwgYnV0IApjb25z
aWRlcmluZyB0aGUgZnJlcXVlbmN5IG9mIGNyYXNoZXMgd2Ugc2F3IGVhcmxpZXIgaSB0aGluayBp
dCdzIHNhdmUgdG8gCmNvbWUgdG8gYSBjb25jbHVzaW9uLgoKSSBob3BlIHRoZXNlIHBhdGNoZXMg
d2lsbCBiZSBpbmNsdWRlZCBpbiAyLjYuMzMgYW5kIHdpbGwgYmUgYmFjayBwb3J0ZWQgCnRvIGF0
IGxlYXN0IDIuNi4zMi4KCk1hbnkgdGhhbmtzIHRvIERhdmUgYW5kIHRvIENocmlzdG9waCBmb3Ig
Zml4aW5nIHRoaXMgYXBwYXJlbnRseSByYXJlIGFuZCAKc2VsZG9tIHRyaWdnZXJlZCBjb25kaXRp
b24uCgotUGF0cmljawoKRGF2ZSBDaGlubmVyIHdyb3RlOgo+IEhpIFBhdHJpY2ssCj4gCj4gSSd2
ZSBhdHRhY2hlZCB0d28gY29tcGVuZGl1bSBwYXRjaGVzIHRoYXQgd2lsbCBob3BlZnVsbHkgZml4
Cj4gdGhlIGlub2RlIHJlY2xhaW0gcHJvYmxlbXMgeW91J3ZlIGJlZW4gc2VlaW5nIC0gb25lIGlz
IGZvciAyLjYuMzEsCj4gdGhlIG90aGVyIGlzIGZvciAyLjYuMzIuIEkndmUgY2MnZCB0aGlzIHRv
IHRoZSBYRlMgbGlzdCDRlW8gdGhhdAo+IGFueW9uZSBlbHNlIHdobyBoYXMgYmVlbiBzZWVpbmcg
Y3Jhc2hlcywgYXNzZXJ0IGZhaWx1cmVzIGFuZAo+IGdlbmVyYWwgbmFzdGluZXNzIGFyb3VuZCBp
bm9kZSByZWNsYWltIGNhbiB0ZXN0IHRoZW0gYXMgd2VsbC4KPiAKPiBUaGVzZSBhcmUgbm90IGZp
bmFsIHBhdGNoZXMgLSB0aGVyZSdzIGEgZmV3IGNoYW5nZXMgdGhhdCBDaHJpc3RvcGgKPiBoYXMg
cGlja2VkIHVwIG9uIGR1cmluZyByZXZpZXcgLSBzbyB0aGVyZSdsbCBiZSBhbm90aGVyIHJvdW5k
IG9mCj4gcGF0Y2hlcyBiZWZvcmUgY2hlY2tpbnMgYW5kIC1zdGFibGUgYmFja3BvcnRzIGNhbiBi
ZSByZXF1ZXN0ZWQuCj4gCj4gSSdtIGhvcGluZyB0aGF0IHRoZXNlIHBhdGNoZXMgZml4IHlvdXIg
cHJvYmxlbSwgYmVjYXVzZSB3aXRoIHRoZW0KPiBJIGNhbid0IG1ha2UgbXkgbWFjaGluZXMgZmFs
bCBvdmVyIGFueW1vcmUuLi4uCj4gCj4gQ2hlZXJzLAo+IAo+IERhdmUuCj4gCj4gCj4gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCj4gCj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
