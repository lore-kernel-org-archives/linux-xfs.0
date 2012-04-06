Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q365rKJS133997 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 00:53:21 -0500
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	U5JG1qVmuPYovR3V (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 22:53:19 -0700 (PDT)
Received: by yenq2 with SMTP id q2so1544500yen.26
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 22:53:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20350.9643.379841.771496@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 07:53:18 +0200
Message-ID: <CAAxjCEwYVB4T2EHU6JWi5Oxf=hepoKjVVj+dVAYWo_t4KNFeyg@mail.gmail.com>
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
To: Peter Grandi <pg_xf2@xf2.for.to.sabi.co.uk>
Cc: Linux fs XFS <xfs@oss.sgi.com>

PiBXaGljaCBicmluZ3MgYW5vdGhlciBzdWJqZWN0OiB1c3VhbGx5IGh3IFJBSUQgaG9zdCBhZGFw
dGVyIGhhdmUKPiBjYWNoZSwgYW5kIGhhdmUgZmlybXdhcmUgdGhhdCBjbGV2ZXJseSByZWFycmFu
Z2VzIHdyaXRlcy4KPgo+IExvb2tpbmcgYXQgdGhlIHNwZWNzIG9mIHRoZSBQNDAwOgo+Cj4gwqBo
dHRwOi8vaDE4MDA0Lnd3dzEuaHAuY29tL3Byb2R1Y3RzL3NlcnZlcnMvcHJvbGlhbnRzdG9yYWdl
L2FycmF5Y29udHJvbGxlcnMvc21hcnRhcnJheXA0MDAvCj4KPiBpdCBzZWVtcyB0byBtZSB0aGF0
IGl0IGhhcyBzdGFuZGFyZCAyNTZNQiBvZiBjYWNoZSwgYW5kIG9ubHkKPiBzdXBwb3J0cyBSQUlE
NiB3aXRoIGEgYmF0dGVyeSBiYWNrZWQgd3JpdGUgY2FjaGUgKHdpc2UhKS4KPgo+IFdoaWNoIG1l
YW5zIHRoYXQgeW91ciBMaW51eC1sZXZlbCBzZWVrIGdyYXBocyBtYXkgYmUgbm90IHNvCj4gdXNl
ZnVsLCBiZWNhdXNlIHRoZSBob3N0IGFkYXB0ZXIgbWF5IGJlIGRyYXN0aWNhbGx5IHJlYXJyYW5n
aW5nCj4gdGhlIHNlZWsgcGF0dGVybnMsIGFuZCB5b3UgbWF5IG5lZWQgdG8gdHdlYWsgdGhlIFA0
MDAgZWxldmF0b3IsCj4gcmF0aGVyIHRoYW4gb3IgaW4gYWRkaXRpb24gdG8gdGhlIExpbnV4IGVs
ZXZhdG9yLgo+Cj4gVW5sZXNzIHBvc3NpYmx5IGJhcnJpZXJzIGFyZSBlbmFibGVkLCBhbmQgZXZl
biB3aXRoIGEgQkJXQyB0aGUKPiBQNDAwIHdyaXRlcyB0aHJvdWdoIG9uIHJlY2VpdmluZyBhIGJh
cnJpZXIgcmVxdWVzdC4gSUlSQyBYRlMgaXMKPiByYXRoZXIgc3RyaWN0ZXIgaW4gaXNzdWluZyBi
YXJyaWVyIHJlcXVlc3RzIHRoYW4gJ2V4dDQnLCBhbmQgeW91Cj4gbWF5IGJlIHNlZWluZyBtb3Jl
IHRoZSBlZmZlY3Qgb2YgdGhhdCB0aGFuIHRoZSBlZmZlY3Qgb2YgYWltaW5nCj4gdG8gc3BsaXR0
aW5nIHRoZSBhY2Nlc3MgcGF0dGVybnMgYmV0d2VlbiA0IEFHcyB0byBpbXByb3ZlIHRoZQo+IHBv
dGVudGlhbCBmb3IgbXVsdGl0aHJlYWRpbmcgKHdoaWNoIHlvdSBkZW55IGJlY2F1c2UgeW91IGFy
ZQo+IHVzaW5nIHdoYXQgaXMgbW9zdCBsaWtlbHkgYSBsYXJnZSBSQUlENiBzdHJpcGUgc2l6ZSB3
aXRoIGEgc21hbGwKPiBJTyBpbnRlbnNpdmUgd3JpdGUgd29ya2xvYWQsIGFzIHByZXZpb3VzbHkg
bm90ZWQpLgoKWWVzLCBpdCBkb2VzIGhhdmUgMjU2IE1CIEJCV0MsIGFuZCBpdCBpcyBlbmFibGVk
LiBXaGVuIEkgZGlzYWJsZWQgaXQsCnRoZSB0aW1lIG5lZWRlZCB3b3VsZCByaXNlIGZyb20gMTIw
IHNlYyBpbiB0aGUgQkJXQyBjYXNlIHRvIGEgd2hvcHBpbmcKMzMwIHNlYy4KCklJUkMsIEkgZGlk
IHRoZSBiZW5jaG1hcmsgd2l0aCBiYXJyaWVyPTAsIGJ1dCBjaGFuZ2luZyB0aGlzIGRpZCBub3QK
bWFrZSBhIGJpZyBkaWZmZXJlbmNlLiBOb3RoaW5nIGRpZDsgdGhhdOKAmXMgd2hhdCBmcnVzdHJh
dGVkIG1lIGEgYml0CjspLiBJIGFsc28gdHJpZWQgZGlmZmVyZW50IExpbnV4IElPIGVsZXZhdG9y
cywgYXMgeW91IHN1Z2dlc3RlZCBpbgp5b3VyIG90aGVyIHJlc3BvbnNlLCB3aXRob3V0IGFueSBt
ZWFzdXJhYmxlIGVmZmVjdC4KClRoZSBzdHJpcGUgc2l6ZSBpcyB0aGlzLCBidHcuOiBzdT0xNmss
c3c9NAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
