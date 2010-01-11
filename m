Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BKLYS5176128 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 14:21:35 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29134153143
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 12:22:28 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id Vmy03xlFR6R3oxhk for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 12:22:28 -0800 (PST)
Message-ID: <4B4B8882.2010209@news-service.com>
Date: Mon, 11 Jan 2010 21:22:26 +0100
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

SGkgRGF2ZSwKCkp1c3Qgd2FudGVkIHRvIGxldCB5b3Uga25vdyB3ZSBhcmUgcnVubmluZyBhIGZl
dyBzZXJ2ZXJzIHdpdGggeW91ciAKcGF0Y2hlcy4gU28gZmFyIHNvIGdvb2QsIGJ1dCBpdCdzIGEg
YnV0IHRvbyBlYXJseSB0byBjb25jbHVkZSBhbnl0aGluZy4KClRoYW5rcyBmb3IgdGhlIHBhdGNo
ZXMuIEknbGwga2VlcCB5b3UgcG9zdGVkIG9uIG91ciByZXN1bHRzLgoKLVBhdHJpY2sKCk9uIDgt
MS0yMDEwIDEyOjMxLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gSGkgUGF0cmljaywKPgo+IEkndmUg
YXR0YWNoZWQgdHdvIGNvbXBlbmRpdW0gcGF0Y2hlcyB0aGF0IHdpbGwgaG9wZWZ1bGx5IGZpeAo+
IHRoZSBpbm9kZSByZWNsYWltIHByb2JsZW1zIHlvdSd2ZSBiZWVuIHNlZWluZyAtIG9uZSBpcyBm
b3IgMi42LjMxLAo+IHRoZSBvdGhlciBpcyBmb3IgMi42LjMyLiBJJ3ZlIGNjJ2QgdGhpcyB0byB0
aGUgWEZTIGxpc3Qg0ZVvIHRoYXQKPiBhbnlvbmUgZWxzZSB3aG8gaGFzIGJlZW4gc2VlaW5nIGNy
YXNoZXMsIGFzc2VydCBmYWlsdXJlcyBhbmQKPiBnZW5lcmFsIG5hc3RpbmVzcyBhcm91bmQgaW5v
ZGUgcmVjbGFpbSBjYW4gdGVzdCB0aGVtIGFzIHdlbGwuCj4KPiBUaGVzZSBhcmUgbm90IGZpbmFs
IHBhdGNoZXMgLSB0aGVyZSdzIGEgZmV3IGNoYW5nZXMgdGhhdCBDaHJpc3RvcGgKPiBoYXMgcGlj
a2VkIHVwIG9uIGR1cmluZyByZXZpZXcgLSBzbyB0aGVyZSdsbCBiZSBhbm90aGVyIHJvdW5kIG9m
Cj4gcGF0Y2hlcyBiZWZvcmUgY2hlY2tpbnMgYW5kIC1zdGFibGUgYmFja3BvcnRzIGNhbiBiZSBy
ZXF1ZXN0ZWQuCj4KPiBJJ20gaG9waW5nIHRoYXQgdGhlc2UgcGF0Y2hlcyBmaXggeW91ciBwcm9i
bGVtLCBiZWNhdXNlIHdpdGggdGhlbQo+IEkgY2FuJ3QgbWFrZSBteSBtYWNoaW5lcyBmYWxsIG92
ZXIgYW55bW9yZS4uLi4KPgo+IENoZWVycywKPgo+IERhdmUuCj4KPgo+Cj4gX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4g
eGZzQG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
