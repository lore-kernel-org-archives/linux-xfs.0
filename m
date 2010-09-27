Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R0tQEY144619 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 19:55:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90D9BE79732
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 18:09:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	L7Gj8Nn3HKnTUkIi for <xfs@oss.sgi.com>;
	Sun, 26 Sep 2010 18:09:15 -0700 (PDT)
Date: Mon, 27 Sep 2010 10:56:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/18] xfs: serialise inode reclaim within an AG
Message-ID: <20100927005613.GA5665@dastard>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
	<1285331476-23015-17-git-send-email-david@fromorbit.com>
	<20100925234929.GB23975@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100925234929.GB23975@infradead.org>
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

T24gU2F0LCBTZXAgMjUsIDIwMTAgYXQgMDc6NDk6MjlQTSAtMDQwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gSSByZWFsbHkgZG9uJ3QgbGlrZSB0aGUgd2F5IHRoZSAidHJ5bG9jayIgdmFy
aWFibGUgaXMgb3ZlcmxvYWRlZCBoZXJlLgo+IEp1c3QgYWRkIGEgbmV3IHNraXBwZWQgdmFyaWFi
bGUgZm9yIHJlc3RhcnRpbmcgdGhlIHNjYW4gYW5kIG90aGVyd2lzZQo+IHVzZSAoZmxhZ3MgJiBT
WU5DX1RSWUxPQ0spIGRpcmVjdGx5Lgo+IAo+ID4gKwlpbnQJCQl0cnlsb2NrID0gISEoZmxhZ3Mg
JiBTWU5DX1RSWUxPQ0spOwo+ID4gIAo+ID4gK3Jlc3RhcnQ6Cj4gPiAgCWFnID0gMDsKPiA+ICAJ
d2hpbGUgKChwYWcgPSB4ZnNfcGVyYWdfZ2V0X3RhZyhtcCwgYWcsIFhGU19JQ0lfUkVDTEFJTV9U
QUcpKSkgewo+ID4gIAkJdW5zaWduZWQgbG9uZwlmaXJzdF9pbmRleCA9IDA7Cj4gPiBAQCAtODM3
LDYgKzgzOSwxNyBAQCB4ZnNfcmVjbGFpbV9pbm9kZXNfYWcoCj4gPiAgCj4gPiAgCQlhZyA9IHBh
Zy0+cGFnX2Fnbm8gKyAxOwo+ID4gIAo+ID4gKwkJaWYgKCFtdXRleF90cnlsb2NrKCZwYWctPnBh
Z19pY2lfcmVjbGFpbV9sb2NrKSkgewo+ID4gKwkJCWlmICh0cnlsb2NrKSB7Cj4gPiArCQkJCXRy
eWxvY2srKzsKPiA+ICsJCQkJY29udGludWU7Cj4gPiArCQkJfQo+ID4gKwkJCW11dGV4X2xvY2so
JnBhZy0+cGFnX2ljaV9yZWNsYWltX2xvY2spOwo+ID4gKwkJfQo+ID4gKwo+ID4gKwkJaWYgKHRy
eWxvY2spCj4gPiArCQkJZmlyc3RfaW5kZXggPSBwYWctPnBhZ19pY2lfcmVjbGFpbV9jdXJzb3I7
Cj4gCj4gQWxzbyB0aGlzIGNvdWxkIGJlIG1hZGUgbW9yZSBjbGVhciBieToKPiAKPiAJaWYgKGZs
YWdzICYgU1lOQ19UUllMT0NLKSB7Cj4gCQlpZiAoIW11dGV4X3RyeWxvY2soJnBhZy0+cGFnX2lj
aV9yZWNsYWltX2xvY2spKSB7Cj4gCQkJc2tpcHBlZCsrOwo+IAkJCWNvbnRpbnVlOwo+IAkJfQo+
IAo+IAkJZmlyc3RfaW5kZXggPSBwYWctPnBhZ19pY2lfcmVjbGFpbV9jdXJzb3I7Cj4gCX0gZWxz
ZSB7Cj4gCQltdXRleF9sb2NrKCZwYWctPnBhZ19pY2lfcmVjbGFpbV9sb2NrKTsKPiAJfQoKSSds
bCBsZWF2ZSB0aGUgdHJ5bG9jayB2YXJpYWJsZSwgYnV0IGFkZCBhIHNraXBwZWQgdmFyaWFibGUu
IFRoZQp0cnlsb2NrIHR3by1wYXNzIGFsZ29yaXRobSAod2hlcmUgdGhlIHNlY29uZCBwYXNzIGdv
ZXMgaW50byBmdWxsCmJsb2NraW5nIHJlY2xhaW0gbW9kZSkgaXMgaW50ZW50aW9uYWwgdG8gZW5z
dXJlIHRoYXQgd2UgYmxvY2sKc2hyaW5rZXIgY2FsbHMgd2hlbiB0aGVyZSBhcmUgbW9yZSBzaHJp
bmtlcnMgdGhhbiBBR3MgcmF0aGVyIHRoYW4Kc3Bpbm5pbmcganVzdCB0cnlpbmcgdG8gZ2V0IHBl
ci1hZyByZWNsYWltIGxvY2tzLiBSZWdhcmRsZXNzLCBJJ2xsCmNsZWFuIHVwIHRoZSBjb2RlIGxp
a2UgeW91IHN1Z2dlc3QgYmVjYXVzZSBpdCBpcyBuZWF0ZXIuCgo+IAo+ID4gKwo+ID4gIAkJZG8g
ewo+ID4gIAkJCXN0cnVjdCB4ZnNfaW5vZGUgKmJhdGNoW1hGU19MT09LVVBfQkFUQ0hdOwo+ID4g
IAkJCWludAlpOwo+ID4gQEAgLTg4OSw4ICs5MDIsMTkgQEAgeGZzX3JlY2xhaW1faW5vZGVzX2Fn
KAo+ID4gIAo+ID4gIAkJfSB3aGlsZSAobnJfZm91bmQgJiYgIWRvbmUgJiYgKm5yX3RvX3NjYW4g
PiAwKTsKPiA+ICAKPiA+ICsJCXBhZy0+cGFnX2ljaV9yZWNsYWltX2N1cnNvciA9IChkb25lIHx8
ICF0cnlsb2NrKSA/IDAgOiBmaXJzdF9pbmRleDsKPiAKPiAJCWlmICgoZmxhZ3MgJiBTWU5DX1RS
WUxPQ0spICYmICFkb25lKQo+IAkJCXBhZy0+cGFnX2ljaV9yZWNsYWltX2N1cnNvciA9IGZpcnN0
X2luZGV4Owo+IAkJZWxzZQo+IAkJCXBhZy0+cGFnX2ljaV9yZWNsYWltX2N1cnNvciA9IDA7Cj4g
Cj4gPiArCS8qCj4gPiArCSAqIGlmIHdlIHNraXBwZWQgYW55IEFHLCBhbmQgd2Ugc3RpbGwgaGF2
ZSBzY2FuIGNvdW50IHJlbWFpbmluZywgZG8KPiA+ICsJICogYW5vdGhlciBwYXNzIHRoaXMgdGlt
ZSB3YWl0aW5nIG9uIHRoZSByZWNsYWltIGxvY2tzLgo+ID4gKwkgKi8KPiA+ICsJaWYgKHRyeWxv
Y2sgPiAxICYmICpucl90b19zY2FuKSB7Cj4gPiArCQl0cnlsb2NrID0gMDsKPiA+ICsJCWdvdG8g
cmVzdGFydDsKPiA+ICsJfQo+IAo+IEluIGFkZGl0aW9uIHRvIHdhaXRpbmcgb24gdGhlIGxvY2sg
dGhpcyBhbHNvIGlnbm9yZXMgdGhlIHJlY2xhaW0gY3Vyc29yLgoKRml4ZWQgdGhlIGNvbW1lbnQg
dG8gaW5kaWNhdGUgdGhpcyBpcyBpbnRlbnTRlm9uYWwuCgpDaGVlcnMsCgpEYXZlLgoKLS0gCkRh
dmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
