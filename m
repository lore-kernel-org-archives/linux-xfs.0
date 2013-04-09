Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D48C7FD8
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 11:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FBF08F8035
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 09:01:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W5kxP8JCNNoLTXTg for
	<xfs@oss.sgi.com>; Tue, 09 Apr 2013 09:01:09 -0700 (PDT)
Message-ID: <51643AAA.20802@redhat.com>
Date: Tue, 09 Apr 2013 11:58:34 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
	<CADFMGuLu5Vz6=7rBU5ECPxupcxWS5rk8j0BKkX6kyJSdGgSrXg@mail.gmail.com>
	<51643749.5080800@sandeen.net>
	<CADFMGu+N+aE-PENHcn6fOLxrJtHVWkG_meMFaFZjrT4bFX2iQQ@mail.gmail.com>
In-Reply-To: <CADFMGu+N+aE-PENHcn6fOLxrJtHVWkG_meMFaFZjrT4bFX2iQQ@mail.gmail.com>
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
To: =?UTF-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gMDQvMDkvMjAxMyAxMTo0OCBBTSwg56ym5rC45rabIHdyb3RlOgo+IEknbGwgd29yayBvbiBy
ZXByb2R1Y2luZyB0aGUgaXNzdWUsIGNhbiB5b3Ugc2hhcmUgc29tZSB0cmFjaW5nIHNjcmlwdCB0
bwo+IG1lPyBUaGFuayB5b3UuCj4gCgpIaSwKCldlJ3JlIGludGVyZXN0ZWQgaW4gdHJhY2tpbmcg
dGhpcyBwcm9ibGVtIGRvd24gYW5kIGFyZSB3b3JraW5nIG9uIGEKc2NyaXB0IHRoYXQgbWlnaHQg
aGVscCB1cyBnYXRoZXIgbW9yZSBpbmZvcm1hdGlvbi4gV2Ugc3RpbGwgaGF2ZSBzb21lCnJlc2Vh
cmNoIHRvIGRvIHRoZXJlLCBzbyBwbGVhc2UgYmUgcGF0aWVudCEgV2UnbGwgc2hhcmUgaXQgd2hl
biByZWFkeS4KCkluIHRoZSBtZWFudGltZSwgSSB0aGluayBpdCB3b3VsZCBiZSBoZWxwZnVsIHRv
IHRha2UgRXJpYydzIGFkdmljZSBpZgp0aGlzIG9jY3VycyBhZ2FpbjoKCi0gdW1vdW50L3JlbW91
bnQgdG8gcmVwbGF5IHRoZSBYRlMgbG9nLgotIHVtb3VudCBhbmQgY29sbGVjdCBhIG1ldGFkdW1w
IG9mIHRoZSBmaWxlc3lzdGVtICh4ZnNfbWV0YWR1bXApLiBXZSdkCmJlIGludGVyZXN0ZWQgdG8g
c2VlIHRoaXMgaWYgeW91J3JlIHdpbGxpbmcvYWJsZSB0byBjb2xsZWN0IGFuZCBzaGFyZSBpdAoo
bm90ZSB0aGF0IHRoaXMgY292ZXJzIHRoZSBmcyBwcmlvciB0byByZXBhaXIpLgotIGNhcHR1cmUg
dGhlIHhmc19yZXBhaXIgb3V0cHV0IGFuZCBzaGFyZSB0aGF0IGFzIHdlbGwuCgpUaGFua3MuCgpC
cmlhbgoKPiAKPiAyMDEzLzQvOSBFcmljIFNhbmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQgPG1h
aWx0bzpzYW5kZWVuQHNhbmRlZW4ubmV0Pj4KPiAKPiAgICAgT24gNC85LzEzIDEwOjIzIEFNLCDn
rKbmsLjmtpsgd3JvdGU6Cj4gICAgID4gU28gbXkgcXVlc3Rpb24gaXMgd2h5IHhmcyBzaHV0ZG93
biBhbHdheXMgIGhhcHBlbnM/IFdpdGggc2FtZQo+ICAgICA+IHJlYXNvbih4ZnNfaXVubGlua19y
ZW1vdmU6IHhmc19pbm90b2JwKCkgcmV0dXJuZWQgZXJyb3IgMjIKPiAgICAgPiB4ZnNfaW5hY3Rp
dmU6IHhmc19pZnJlZSByZXR1cm5lZCBlcnJvciAyMiB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24pLgo+
ICAgICA+IFRoZSBzZXJ2ZXIgbG9hZCBpcyBoaWdoIGFuZCBpcyBpdCByZWxhdGVkPwo+IAo+ICAg
ICBXZSBkb24ndCBrbm93IHlldC4gIDopCj4gCj4gICAgIEknZCBsaWtlIHRvIGtub3cgd2hhdCB3
YXMgcGFzc2VkIHRvIHhmc19pbm90b2JwIHdoZW4gaXQgc2h1dCBkb3duLAo+ICAgICBhbmQgd2hh
dCBjYXVzZWQgdGhlIEVJTlZBTCAoMjIpIHJldHVybi4gIFBlcmhhcHMgc29tZSB0cmFjaW5nCj4g
ICAgIG9yIHN5c3RlbXRhcCBzY3JpcHRzIGNvdWxkIHRvIGl0Lgo+IAo+ICAgICBJZiB5b3Ugb25s
eSBoaXQgdGhpcyBldmVyeSBmZXcgd2Vla3MsIHRob3VnaCwgaXQncyBnb2luZyB0byBiZQo+ICAg
ICBkaWZmaWN1bHQgdG8gY2F0Y2guCj4gCj4gICAgIC1FcmljCj4gCj4gICAgID4gZnJlZSAtbQo+
ICAgICA+ICAgICAgICAgICAgICB0b3RhbCAgICAgICB1c2VkICAgICAgIGZyZWUgICAgIHNoYXJl
ZCAgICBidWZmZXJzICAgIAo+ICAgICBjYWNoZWQKPiAgICAgPiBNZW06ICAgICAgICAxMjkwMTYg
ICAgIDEyODA2NyAgICAgICAgOTQ4ICAgICAgICAgIDAgICAgICAgICAxMCAgICAKPiAgICAgMTE5
OTA1Cj4gICAgID4gLS8rIGJ1ZmZlcnMvY2FjaGU6ICAgICAgIDgxNTAgICAgIDEyMDg2NQo+ICAg
ICA+IFN3YXA6ICAgICAgICAgNDA5MyAgICAgICAgICAwICAgICAgIDQwOTMKPiAgICAgPgo+ICAg
ICA+Cj4gCj4gCj4gCj4gCj4gLS0gCj4g56ym5rC45rabCj4gCj4gCj4gX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMgbWFpbGluZyBsaXN0Cj4geGZz
QG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCj4g
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
