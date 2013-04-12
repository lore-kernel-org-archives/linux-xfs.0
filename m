Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C528F7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 20:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1C3D30404E
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 18:07:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gSZPoCsX74T0zvkA for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 18:07:53 -0700 (PDT)
Message-ID: <51675E67.7030600@sandeen.net>
Date: Thu, 11 Apr 2013 20:07:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
In-Reply-To: <516746AC.3090808@redhat.com>
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
Cc: Ben Myers <bpm@sgi.com>, =?UTF-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8xMS8xMyA2OjI2IFBNLCBCcmlhbiBGb3N0ZXIgd3JvdGU6Cj4gT24gMDQvMTEvMjAxMyAw
MzoxMSBQTSwg56ym5rC45rabIHdyb3RlOgo+PiBJdCBoYXBwZW5zIHRvbmlnaHQgYWdhaW4gb24g
b25lIG9mIG91ciBzZXJ2ZXJzLCBob3cgdG8gZGVidWcgdGhlIHJvb3QKPj4gY2F1c2U/IFRoYW5r
IHlvdS4KPj4KPiAKPiBIaSwKPiAKPiBJJ3ZlIGF0dGFjaGVkIGEgc3lzdGVtIHRhcCBzY3JpcHQg
KHN0YXAgLXYgeGZzLnN0cCkgdGhhdCBzaG91bGQKPiBob3BlZnVsbHkgcHJpbnQgb3V0IGEgYml0
IG1vcmUgZGF0YSBzaG91bGQgdGhlIGlzc3VlIGhhcHBlbiBhZ2Fpbi4gRG8KPiB5b3UgaGF2ZSBh
IHNtYWxsIGVub3VnaCBudW1iZXIgb2Ygbm9kZXMgKG9yIHByZWRpY3RhYmxlIGVub3VnaCBwYXR0
ZXJuKQo+IHRoYXQgeW91IGNvdWxkIHJ1biB0aGlzIG9uIHRoZSBub2RlcyB0aGF0IHRlbmQgdG8g
ZmFpbCBhbmQgY29sbGVjdCB0aGUKPiBvdXRwdXQ/Cj4gCj4gQWxzbywgY291bGQgeW91IGNvbGxl
Y3QgYW4geGZzX21ldGFkdW1wIG9mIHRoZSBmaWxlc3lzdGVtIGluIHF1ZXN0aW9uCj4gYW5kIG1h
a2UgaXQgYXZhaWxhYmxlIGZvciBkb3dubG9hZCBhbmQgYW5hbHlzaXMgc29tZXdoZXJlPyBJIGJl
bGlldmUgdGhlCj4gaWRlYWwgYXBwcm9hY2ggaXMgdG8gbW91bnQvdW1vdW50IHRoZSBmaWxlc3lz
dGVtIGZpcnN0IHRvIHJlcGxheSB0aGUgbG9nCj4gYmVmb3JlIGNvbGxlY3RpbmcgYSBtZXRhZHVt
cCwgYnV0IHNvbWVib2R5IGNvdWxkIGNvcnJlY3QgbWUgb24gdGhhdCAodG8KPiBiZSBzYWZlLCB5
b3UgY291bGQgY29sbGVjdCBtdWx0aXBsZSBkdW1wczogcHJlLW1vdW50IGFuZCBwb3N0LW1vdW50
KS4KCkRhdmUgc3VnZ2VzdGVkIHllc3RlcmRheSB0aGF0IHRoaXMgd291bGQgYmUgYmVzdDogbWV0
YWR1bXAgcmlnaHQKYWZ0ZXIgdW5tb3VudGluZyBwb3N0LWZhaWx1cmUsIHRoZW4gbW91bnQvdW1v
dW50ICYgZ2VuZXJhdGUgYW5vdGhlciBtZXRhZHVtcC4KCi1FcmljCgo+IENvdWxkIHlvdSBhbHNv
IGRlc2NyaWJlIHlvdXIgd29ya2xvYWQgYSBsaXR0bGUgYml0PyBUaGFua3MuCj4gCj4gQnJpYW4K
PiAKPj4gQXByIDEyIDAyOjMyOjEwIGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19pdW5saW5r
X3JlbW92ZToKPj4geGZzX2lub3RvYnAoKSByZXR1cm5lZCBlcnJvciAyMi4KPj4gQXByIDEyIDAy
OjMyOjEwIGNxZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19pbmFjdGl2ZTogeGZzX2lmcmVlIHJl
dHVybmVkCj4+IGVycm9yIDIyCj4+IEFwciAxMiAwMjozMjoxMCBjcWR4IGtlcm5lbDogWEZTIChz
ZGIpOiB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24oMHgxKQo+PiBjYWxsZWQgZnJvbSBsaW5lIDExODQg
b2YgZmlsZSBmcy94ZnMveGZzX3Zub2Rlb3BzLmMuICBSZXR1cm4gYWRkcmVzcyA9Cj4+IDB4ZmZm
ZmZmZmZhMDJlZTIwYQo+PiBBcHIgMTIgMDI6MzI6MTAgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTog
SS9PIEVycm9yIERldGVjdGVkLiBTaHV0dGluZwo+PiBkb3duIGZpbGVzeXN0ZW0KPj4gQXByIDEy
IDAyOjMyOjEwIGNxZHgga2VybmVsOiBYRlMgKHNkYik6IFBsZWFzZSB1bW91bnQgdGhlIGZpbGVz
eXN0ZW0gYW5kCj4+IHJlY3RpZnkgdGhlIHByb2JsZW0ocykKPj4gQXByIDEyIDAyOjMyOjE5IGNx
ZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19sb2dfZm9yY2U6IGVycm9yIDUgcmV0dXJuZWQuCj4+
IEFwciAxMiAwMjozMjo0OSBjcWR4IGtlcm5lbDogWEZTIChzZGIpOiB4ZnNfbG9nX2ZvcmNlOiBl
cnJvciA1IHJldHVybmVkLgo+PiBBcHIgMTIgMDI6MzM6MTkgY3FkeCBrZXJuZWw6IFhGUyAoc2Ri
KTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNSByZXR1cm5lZC4KPj4gQXByIDEyIDAyOjMzOjQ5IGNx
ZHgga2VybmVsOiBYRlMgKHNkYik6IHhmc19sb2dfZm9yY2U6IGVycm9yIDUgcmV0dXJuZWQuCj4+
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
