Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE28229DFA
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 10:36:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A46EAC001
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 08:36:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ppMWpngkhKO7DUcl for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 08:36:30 -0700 (PDT)
Message-ID: <5172B600.6060606@sandeen.net>
Date: Sat, 20 Apr 2013 08:36:32 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
References: <516C89DF.4070904@redhat.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
	<51720E49.9020001@sandeen.net>
	<CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
	<51721798.1060501@sandeen.net>
	<CADFMGuJAXcA0CTYEoaRNvsTv7DhHeOBgk+j_HiMceT1neoEzRQ@mail.gmail.com>
	<CADFMGuLBat2fWbtpRd=Sb0bQpZiTOdF2p8NA97rak8A=+GhN1A@mail.gmail.co!
	m> <51727E32.8080306@redhat.com>
In-Reply-To: <51727E32.8080306@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: =?UTF-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8yMC8xMyA0OjM4IEFNLCBCcmlhbiBGb3N0ZXIgd3JvdGU6Cj4gT24gMDQvMjAvMjAxMyAw
NjoxMCBBTSwg56ym5rC45rabIHdyb3RlOgo+PiBEZWFyIEVyaWMsCj4+IEkgaGF2ZSBhcHBsaWVk
IHlvdXIgbGF0ZXN0IHBhdGNoIGFuZCBjb2xsZWN0ZWQgdGhlIGZvbGxvd2luZyBsb2c6Cj4+Cj4+
IC92YXIvbG9nL21lc3NhZ2UKPj4gQXByIDIwIDE3OjI4OjIzIDEwIGtlcm5lbDogWEZTIChzZGIp
OiB4ZnNfaXVubGlua19yZW1vdmU6IHhmc19pbm90b2JwKCkKPj4gcmV0dXJuZWQgZXJyb3IgMjIg
Zm9yIGlub2RlIDB4MWIyMGIgYWcgMCBhZ2lubyAxYjIwYgo+PiBBcHIgMjAgMTc6Mjg6MjMgMTAg
a2VybmVsOgo+PiBBcHIgMjAgMTc6Mjg6MjMgMTAga2VybmVsOiBYRlMgKHNkYik6IHhmc19pbmFj
dGl2ZTogeGZzX2lmcmVlIHJldHVybmVkCj4+IGVycm9yIDIyCj4+IEFwciAyMCAxNzoyODoyMyAx
MCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2RvX2ZvcmNlX3NodXRkb3duKDB4MSkgY2FsbGVkCj4+
IGZyb20gbGluZSAxMTg0IG9mIGZpbGUgZnMveGZzL3hmc192bm9kZW9wcy5jLiAgUmV0dXJuIGFk
ZHJlc3MgPQo+PiAweGZmZmZmZmZmYTAyZDRkMGEKPj4gQXByIDIwIDE3OjI4OjIzIDEwIGtlcm5l
bDogWEZTIChzZGIpOiBJL08gRXJyb3IgRGV0ZWN0ZWQuIFNodXR0aW5nIGRvd24KPj4gZmlsZXN5
c3RlbQo+PiBBcHIgMjAgMTc6Mjg6MjMgMTAga2VybmVsOiBYRlMgKHNkYik6IFBsZWFzZSB1bW91
bnQgdGhlIGZpbGVzeXN0ZW0gYW5kCj4+IHJlY3RpZnkgdGhlIHByb2JsZW0ocykKPj4gQXByIDIw
IDE3OjI4OjM3IDEwIGtlcm5lbDogWEZTIChzZGIpOiB4ZnNfbG9nX2ZvcmNlOiBlcnJvciA1IHJl
dHVybmVkLgo+PiBBcHIgMjAgMTc6Mjk6MDcgMTAga2VybmVsOiBYRlMgKHNkYik6IHhmc19sb2df
Zm9yY2U6IGVycm9yIDUgcmV0dXJuZWQuCj4+IEFwciAyMCAxNzoyOTozNyAxMCBrZXJuZWw6IFhG
UyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNSByZXR1cm5lZC4KPj4gQXByIDIwIDE3OjMw
OjA3IDEwIGtlcm5lbDogWEZTIChzZGIpOiB4ZnNfbG9nX2ZvcmNlOiBlcnJvciA1IHJldHVybmVk
Lgo+Pgo+PiBkZWJ1Z2ZzIHRyYWNlOgo+PiBodHRwczovL2RvY3MuZ29vZ2xlLmNvbS9maWxlL2Qv
MEI3bjJDNFQ1dGZOQ1RsWkdVVnBuWkVOclozTS9lZGl0P3VzcD1zaGFyaW5nCj4+Cj4gCj4gRldJ
Vy4uLgo+IAo+IDwuLi4+LTY5MDggIFswMDFdICA4NzM5Ljk2NzYyMzogeGZzX2l1bmxpbms6IGRl
diA4OjE2IGlubyAweDgzYThiIG1vZGUKPiAwMTAwMDAwLCBmbGFncyAweDAKPiA8Li4uPi02OTA5
ICBbMDAxXSAgODczOS45NzAyNTI6IHhmc19pdW5saW5rOiBkZXYgODoxNiBpbm8gMHg4M2E4YiBt
b2RlCj4gMDEwMDAwMCwgZmxhZ3MgMHgwCgpJbnRlcmVzdGluZywgdGhpcyB0aW1lIGl0IHdhcyBv
biB0aGUgc2FtZSBDUFUgWzAwMV0KCkknZCBob3BlZCB0aGF0IHdlJ2Qgc2VlIHRoaXMgc2FtZSBp
bm9kZSBpbiBzb21lIG9mIHRoZSBuZXcgdHJhY2Vwb2ludHMKYnV0IHdlIGRvbid0LCBJJ20gbm90
IHN1cmUgd2h5OyBwZXJoYXBzIGl0IG92ZXJmbG93ZWQgdGhlIHRyYWNlIGJ1ZmZlcj8KCj4gMHg4
M2E4YiBhbmQgMHgxYjIwYiBib3RoIGhhc2ggdG8gdW5saW5rZWQgbGlzdCBidWNrZXQgMTEuCgp3
aGljaCBpcyB3aHkgdGhlIGVycm9yIHRyaWdnZXJlZCBvbiAweDFiMjBiLCBzaW5jZSB0aGUgbGlz
dCBpcyBub3cgY29ycnVwdC4gCgotRXJpYwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
