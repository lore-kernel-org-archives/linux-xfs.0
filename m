Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3EBUDmc195497 for <xfs@oss.sgi.com>; Sat, 14 Apr 2012 06:30:13 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id o36XUrOTLYfYM3EX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 14 Apr 2012 04:30:12 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so2836571yhj.26
	for <xfs@oss.sgi.com>; Sat, 14 Apr 2012 04:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F892808.2040003@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<20120407104912.44881be3@galadriel.home>
	<4F81F5FD.1090809@hardwarefreak.com>
	<20120408234555.695e291f@galadriel.home>
	<4F827341.2000607@hardwarefreak.com>
	<20120409144558.6072c1eb@galadriel.home>
	<CAAxjCEw-WZ9AtEJTZ6eS9+mjm+yh=e_19aJqxUN-ABRp8r3ZyQ@mail.gmail.com>
	<4F892808.2040003@hardwarefreak.com>
Date: Sat, 14 Apr 2012 13:30:11 +0200
Message-ID: <CAAxjCEy0X_74XRkES6GosieYv-ucOmFDxvHh2xh8aKRDS0zZww@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

T24gU2F0LCBBcHIgMTQsIDIwMTIgYXQgOTozMiBBTSwgU3RhbiBIb2VwcG5lciA8c3RhbkBoYXJk
d2FyZWZyZWFrLmNvbT4gd3JvdGU6Cj4gT24gNC8xMy8yMDEyIDI6MzYgUE0sIFN0ZWZhbiBSaW5n
IHdyb3RlOgo+Pj4gTGV0J3MgcmVydW4gaXQgd2l0aCBmaWxlcyBjYWNoZWQgKHRoZSBtYWNoaW5l
IGhhcyAxNiBHQiBSQU0sIHNvCj4+PiBldmVyeSBzaW5nbGUgZmlsZSBtdXN0IGJlIGNhY2hlZCk6
Cj4+Pgo+Pj4gIyB0aW1lIHRhciB4ZiB0ZXN0LnRhcgo+Pj4KPj4+IHJlYWwgwqAgwqAwbTUwLjg0
MnMKPj4+IHVzZXIgwqAgwqAwbTAuODA5cwo+Pj4gc3lzIMKgIMKgIDBtMTMuNzY3cwo+Pgo+PiBU
aGF04oCZcyBhYm91dCB0aGUgc2FtZSB0aW1lIEnigJltIGdldHRpbmcgb24gYSBmcmVzaCAobm9u
LWZyYWdtZW50ZWQpCj4+IGZpbGUgc3lzdGVtIHdpdGggdGhlIFJBSUQgNiB2b2x1bWUuCj4+Cj4g
V2hhdCBjb25maWd1cmF0aW9uIGFyZSB5b3UgcnVubmluZyByaWdodCBub3cgU3RlZmFuPyDCoFlv
dSBzYWlkIHlvdSB3ZW50Cj4gYmFjayB0byBYRlMgZHVlIHRvIHRoZSBFWFQ0IGxvY2t1cHMsIGJ1
dCBJIGNhbid0IHJlY2FsbCB3aGF0IFJBSUQgY29uZmlnCj4geW91IHB1dCB1bmRlcm5lYXRoIGl0
IHRoaXMgdGltZS4KClJBSUQgNiA0KzIsIExWTSAoc2luZ2xlIHZvbHVtZSksIDMya2Igc3RyaXBl
IHNpemUgKD0+IGZ1bGwgc3RyaXBlOgoxMjhrYiksIGFnY291bnQ9NAoKRXhjZXB0IGZvciB0aGUg
c3RyaXBlIHNpemUsIHRoZSBzYW1lIGNvbmZpZyBJIGhhZCBvcmlnaW5hbGx5LiBUaGUgb25seQpp
bnN0YW5jZSBvZiByZWFsbHkgcG9vciBiZWhhdmlvciBpcyB3aXRoIHRoZSAoYXJ0aWZpY2lhbGx5
KSBmcmFnbWVudGVkCmZyZWUgc3BhY2UuCgpJIGhhdmUgbW92ZWQgZXZlcnl0aGluZyBlbHNld2hl
cmUgZm9yIGEgd2hpbGUsIHNvIEkgY2FuIG9uY2UgYWdhaW4gZG8Kc29tZSB0ZXN0aW5nIHRoYXQg
aW52b2x2ZXMgZGVzdHJveWluZyBhbmQgcmVidWlsZGluZyBldmVyeXRoaW5nLgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
