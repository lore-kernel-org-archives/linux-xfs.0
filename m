Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3AvjuB000407 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:57:45 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 716E5154182B
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 03:57:41 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id xH22a61IRaZMybZD for
	<xfs@oss.sgi.com>; Thu, 03 Nov 2011 03:57:41 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: xfs_repair fails with corrupt dinode 17491441757, extent total = 1,
	nblocks = 0.  This is a bug.
Date: Thu, 3 Nov 2011 11:57:38 +0100
References: <201110311156.20421.arekm@maven.pl>
	<201111031140.46783.arekm@maven.pl>
	<20111103104850.GA26259@infradead.org>
In-Reply-To: <20111103104850.GA26259@infradead.org>
MIME-Version: 1.0
Message-Id: <201111031157.39179.arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

T24gVGh1cnNkYXkgMDMgb2YgTm92ZW1iZXIgMjAxMSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6
Cj4gT24gVGh1LCBOb3YgMDMsIDIwMTEgYXQgMTE6NDA6NDZBTSArMDEwMCwgQXJrYWRpdXN6IE1p
Pz9raWV3aWN6IHdyb3RlOgo+ID4gVGhpcyBzZXJ3ZXIgaGFzIDE2IHZhcmlvdXMgU0FUQSBkaXNr
IGNvbm5lY3RlZCB0byBhcnQtb2YtY3JhcCBjb250cm9sbGVyCj4gPiAtIFByb21pc2UgU3VwZXJU
cmFrIEVYMTYzNTAuCj4gPiAKPiA+IFRoZSBzeXN0ZW0gZXhoaWJpdHMgZnVubnkgaXNzdWVzIHdp
dGggaW50ZWxfaWRsZSBkcml2ZXIKPiA+IChodHRwczovL2xrbWwub3JnL2xrbWwvMjAxMS8xMC8y
OC8yNzApLgo+ID4gCj4gPiBJdCBoYXMgb25seSA4R0Igb2YgcmFtIHdoaWNoIHhmc19yZXBhaXIg
ZWF0cyBmb3IgYnJlYWtmYXN0IGNhdXNpbmcKPiA+IHdhdGNoZG9nIHRvIHJlYm9vdCBtYWNoaW5l
IHdoaWxlIHhmc19yZXBhaXIgd2FzIGluIHByb2dyZXNzICh3b3VsZCBiZQo+ID4gbmljZSBpZiBy
ZXBhaXIgY291bGQgZXN0aW1hdGUgbmVlZGVkIHJhbSBiZWZvcmUgaXQgaXMgdG9vIGxhdGUpLgo+
IAo+IFllcy4gIFNvIGZhciBtb3N0IG9mIHRoZSBpc3N1ZXMgYXJlIHdpdGggdGhlIGludGVybmFs
IGJ1ZmZlcmNhY2hlIGFuZCBJCj4gc3VzcGVjdCB3ZSBjb3VsZCBkbyBiZXR0ZXIgc2l6aW5nIGRl
Y2lzaW9ucyB0aGVyZS4gIElmIHlvdSBjYW4gcHJvdmlkZQo+IHNvbWUgdGVzdGluZyAoeGZzX3Jl
cGFpciAtbiBzaG91bGQgYmUgZW5vdWdoKSBJJ2xsIGhhcHBpbHkgc2VuZCB5b3UKPiBzb21lIFJG
QyBwYXRjaGVzIGFzIHNvb24gYXMgSSBnZXQgdGltZSBmb3IgaXQuCgpJIGNhbiBkbyBzb21lIHRl
c3RpbmcgKG9uIGltYWdlIHRob3VnaCBidXQgdGhhdCBzaG91bGRuJ3QgbWF0dGVyKS4KCj4gCj4g
SW4gdGhlIG1lYW50aW1lIGlzIHRoZXJlIGFueSBjaGFuY2UgeW91IGNvdWxkIHNlbmQgdGhlIG91
dHB1dCBvZgo+IAo+IAl4ZnNfcmVwYWlyIC1uIC12diAtbSAxCj4gCj4gZm9yIHRoaXMgZmlsZXN5
c3RlbT8KCldpbGwgc3VjaCByZXBhaXIgZG9uZSBvbiBtZXRhZHVtcGVkICYgcmVzdG9yZWQgaW1h
Z2UgYmUgZW5vdWdoIGZvciB5b3U/CgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6ICAgICAgICBQ
TEQvTGludXggVGVhbQphcmVrbSAvIG1hdmVuLnBsICAgICAgICAgICAgaHR0cDovL2Z0cC5wbGQt
bGludXgub3JnLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
