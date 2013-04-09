Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 968D229DFA
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:05:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70D88304067
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 06:05:33 -0700 (PDT)
Received: from mail-ia0-f182.google.com (mail-ia0-f182.google.com
	[209.85.210.182]) by cuda.sgi.com with ESMTP id
	v0lWqWj7N6f0G1su (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 06:05:32 -0700 (PDT)
Received: by mail-ia0-f182.google.com with SMTP id u20so1635884iag.13
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 06:05:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
Date: Tue, 9 Apr 2013 21:05:32 +0800
Message-ID: <CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, yongtaofu@gmail.com

QWxzbyBJIHdhbnQgdG8ga25vdyB3aHkgYWxsIHRoZSBzZXJ2ZXIsIGFsbCBjcmFzaCB3aXRoIHRo
ZSBzYW1lIGNyYXNoIHN0YWNrPwpUaGFuayB5b3UsIHJlYWxseSBuZWVkIHlvdXIgaGVscC4KCjIw
MTMvNC85LCC3+9PAzM4gPHlvbmd0YW9mdUBnbWFpbC5jb20+Ogo+IEJUVwo+IHhmc19pbmZvIC9k
ZXYvc2RiCj4gbWV0YS1kYXRhPS9kZXYvc2RiICAgICAgICAgICAgICAgaXNpemU9MjU2ICAgIGFn
Y291bnQ9MjgsIGFnc2l6ZT0yNjg0MzU0NDAKPiBibGtzCj4gICAgICAgICAgPSAgICAgICAgICAg
ICAgICAgICAgICAgc2VjdHN6PTUxMiAgIGF0dHI9Mgo+IGRhdGEgICAgID0gICAgICAgICAgICAg
ICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9NzMyNDMwMzM2MCwgaW1heHBjdD01Cj4gICAg
ICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc3VuaXQ9MTYgICAgIHN3aWR0aD0xNjAgYmxr
cwo+IG5hbWluZyAgID12ZXJzaW9uIDIgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBhc2NpaS1j
aT0wCj4gbG9nICAgICAgPWludGVybmFsICAgICAgICAgICAgICAgYnNpemU9NDA5NiAgIGJsb2Nr
cz01MjE3MjgsIHZlcnNpb249Mgo+ICAgICAgICAgID0gICAgICAgICAgICAgICAgICAgICAgIHNl
Y3Rzej01MTIgICBzdW5pdD0xNiBibGtzLCBsYXp5LWNvdW50PTEKPiByZWFsdGltZSA9bm9uZSAg
ICAgICAgICAgICAgICAgICBleHRzej00MDk2ICAgYmxvY2tzPTAsIHJ0ZXh0ZW50cz0wCj4KPiAy
MDEzLzQvOSwgt/vTwMzOIDx5b25ndGFvZnVAZ21haWwuY29tPjoKPj4gRGVhciB4ZnMgZXhwZXJ0
cywKPj4gSSByZWFsbHkgbmVlZCB5b3VyIGhlbHAgc2luY2VyZWx5ISEhIEluIG91ciBwcm9kdWN0
aW9uIGVudmlyb21lbnQgd2UKPj4gcnVuIGdsdXN0ZXJmcyBvdmVyIHRvcCBvZiB4ZnMgb24gRGVs
bCB4NzIwRChSYWlkIDYpLiBBbmQgdGhlIHhmcyBmaWxlCj4+IHN5c3RlbSBjcmFzaCBvbiBzb21l
IG9mIHRoZSBzZXJ2ZXIgZnJlcXVlbnRseSBhYm91dCBldmVyeSB0d28gd2Vla3MuCj4+IENhbiB5
b3UgaGVscCB0byBnaXZlIG1lIGEgZGlyZWN0aW9uIGFib3V0IGhvdyB0byBkZWJ1ZyB0aGlzIGlz
c3VlIGFuZAo+PiBob3cgdG8gYXZvaWQgaXQ/IFRoYW5rIHlvdSB2ZXJ5IHZlcnkgbXVjaCEKPj4K
Pj4gdW5hbWUgLWEKPj4gTGludXggY3FkeC5taWFveWFuLmNsdXN0ZXIxLm5vZGUxMS5xaXlpLmRv
bWFpbiAyLjYuMzItMjc5LmVsNi54ODZfNjQKPj4gIzEgU01QIFdlZCBKdW4gMTMgMTg6MjQ6MzYg
RURUIDIwMTIgeDg2XzY0IHg4Nl82NCB4ODZfNjQgR05VL0xpbnV4Cj4+Cj4+IEV2ZXJ5IHRpbWUg
dGhlIGNyYXNoIGxvZyBpcyBzYW1lLCBhcyBmb2xsb3dpbmcKPj4KPj4gMDM4IEFwciAgOSAwOTo0
MTozNiBjcWR4IGtlcm5lbDogWEZTIChzZGIpOiB4ZnNfaXVubGlua19yZW1vdmU6Cj4+IHhmc19p
bm90b2JwKCkgcmV0dXJuZWQgZXJyb3IgMjIuCj4+IDEwMzkgQXByICA5IDA5OjQxOjM2IGNxZHgg
a2VybmVsOiBYRlMgKHNkYik6IHhmc19pbmFjdGl2ZTogeGZzX2lmcmVlCj4+IHJldHVybmVkIGVy
cm9yIDIyCj4+IDEwNDAgQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6Cj4+
IHhmc19kb19mb3JjZV9zaHV0ZG93bigweDEpIGNhbGxlZCBmcm9tIGxpbmUgMTE4NCBvZiBmaWxl
Cj4+IGZzL3hmcy94ZnNfdm5vZGVvcHMuYy4gIFJldHVybiBhZGRyZXNzID0gMHhmZmZmZmZmZmEw
MmVlMjBhCj4+IDEwNDEgQXByICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IEkv
TyBFcnJvciBEZXRlY3RlZC4KPj4gU2h1dHRpbmcgZG93biBmaWxlc3lzdGVtCj4+IDEwNDIgQXBy
ICA5IDA5OjQxOjM2IGNxZHgga2VybmVsOiBYRlMgKHNkYik6IFBsZWFzZSB1bW91bnQgdGhlCj4+
IGZpbGVzeXN0ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykKPj4gMTA0MyBBcHIgIDkgMDk6
NDE6NTMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNQo+PiBy
ZXR1cm5lZC4KPj4gMTA0NCBBcHIgIDkgMDk6NDI6MjMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTog
eGZzX2xvZ19mb3JjZTogZXJyb3IgNQo+PiByZXR1cm5lZC4KPj4gMTA0NSBBcHIgIDkgMDk6NDI6
NTMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNQo+PiByZXR1
cm5lZC4KPj4gMTA0NiBBcHIgIDkgMDk6NDM6MjMgY3FkeCBrZXJuZWw6IFhGUyAoc2RiKTogeGZz
X2xvZ19mb3JjZTogZXJyb3IgNQo+PiByZXR1cm5lZC4KPj4KPj4gLS0KPj4gt/vTwMzOCj4+Cj4K
Pgo+IC0tCj4gt/vTwMzOCj4KCgotLSAKt/vTwMzOCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
