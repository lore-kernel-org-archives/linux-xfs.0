Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q377RqM0201053 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 02:27:52 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	1FCNjSrqdnR1DhBf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Apr 2012 00:27:51 -0700 (PDT)
Received: by yenq2 with SMTP id q2so1981928yen.26
	for <xfs@oss.sgi.com>; Sat, 07 Apr 2012 00:27:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7F7C25.8040605@hardwarefreak.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
Date: Sat, 7 Apr 2012 09:27:50 +0200
Message-ID: <CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
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
Cc: Linux fs XFS <xfs@oss.sgi.com>

PiBJbnN0ZWFkLCBhIGZhciBtb3JlIG9wdGltYWwgc29sdXRpb24gd291bGQgYmUgdG8gc2V0IGFz
aWRlIDQgc3BhcmVzIHBlcgo+IGNoYXNzaXMgYW5kIGNyZWF0ZSAxNCBmb3VyIGRyaXZlIFJBREkx
MCBhcnJheXMuIMKgVGhpcyB3b3VsZCB5aWVsZCB+NjAwCj4gc2Vla3Mvc2VjIGFuZCB+NDAwTUIv
cyBzZXF1ZW50aWFsIHRocm91Z2hwdXQgcGVyZm9ybWFuY2UgcGVyIDIgc3BpbmRsZQo+IGFycmF5
LiDCoFdlJ2Qgc3RpdGNoIHRoZSByZXN1bHRpbmcgNTYgaGFyZHdhcmUgUkFJRDEwIGFycmF5cyB0
b2dldGhlciBpbgo+IGFuIG1kcmFpZCBsaW5lYXIgKGNvbmNhdGVuYXRlZCkgYXJyYXkuIMKgVGhl
biB3ZSdkIGZvcm1hdCB0aGlzIDExMgo+IGVmZmVjdGl2ZSBzcGluZGxlIGxpbmVhciBhcnJheSB3
aXRoIHNpbXBseToKPgo+ICQgbWtmcy54ZnMgLWQgYWdjb3VudD01NiAvZGV2L21kMAo+Cj4gU2lu
Y2UgZWFjaCBSQUlEMTAgaXMgOTAwR0IgY2FwYWNpdHksIHdlIGhhdmUgNTYgQUdzIG9mIGp1c3Qg
dW5kZXIgdGhlCj4gMVRCIGxpbWl0LCAxIEFHIHBlciAyIHBoeXNpY2FsIHNwaW5kbGVzLiDCoER1
ZSB0byB0aGUgMiBzdHJpcGUgc3BpbmRsZQo+IG5hdHVyZSBvZiB0aGUgY29uc3RpdHVlbnQgaGFy
ZHdhcmUgUkFJRDEwIGFycmF5cywgd2UgZG9uJ3QgbmVlZCB0byB3b3JyeQo+IGFib3V0IGFsaWdu
aW5nIFhGUyB3cml0ZXMgdG8gdGhlIFJBSUQgc3RyaXBlIHdpZHRoLiDCoFRoZSBoYXJkd2FyZSBj
YWNoZQo+IHdpbGwgdGFrZSBjYXJlIG9mIGZpbGxpbmcgdGhlIHNtYWxsIHN0cmlwZXMuIMKgTm93
IHdlJ3JlIGluIHRoZSBvcHBvc2l0ZQo+IHNpdHVhdGlvbiBvZiBoYXZpbmcgdG9vIG1hbnkgQUdz
IHBlciBzcGluZGxlLiDCoFdlJ3ZlIHB1dCAyIHNwaW5kbGVzIGluIGEKPiBzaW5nbGUgQUcgYW5k
IHR1cm5lZCB0aGUgc2VlayBzdGFydmF0aW9uIGlzc3VlcyBvbiBpdHMgaGVhZC4KClNvIGl0IHNv
dW5kcyBsaWtlIHRoYXQgZm9yIHBvb3IgZ3V5cyBsaWtlIHVzLCB3aG8gY2Fu4oCZdCBhZmZvcmQg
dGhlCmhhcmR3YXJlIHRvIGhhdmUgZG96ZW5zIG9mIHNwaW5kbGVzLCB0aGUgYmVzdCBvcHRpb24g
d291bGQgYmUgdG8KY3JlYXRlIHRoZSBYRlMgZmlsZSBzeXN0ZW0gd2l0aCBhZ2NvdW50PTE/IFRo
YXQgc2VlbXMgdG8gYmUgdGhlIG9ubHkKcmVhc29uYWJsZSBjb25jbHVzaW9uIHRvIG1lLCBzaW5j
ZSBhIHNpbmdsZSBSQUlEIGRldmljZSwgbGlrZSBhIHNpbmdsZQpkaXNrLCBjYW5ub3Qgd3JpdGUg
aW4gcGFyYWxsZWwgYW55d2F5LgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
