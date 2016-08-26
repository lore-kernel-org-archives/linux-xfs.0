Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41BB87CCC
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 09:33:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBCD2304048
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:33:56 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id NAWbOSvc39ddPKmw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 07:33:46 -0700 (PDT)
Date: Fri, 26 Aug 2016 16:33:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: rewrite and optimize the delalloc write path
Message-ID: <20160826143344.GB21535@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-5-git-send-email-hch@lst.de>
	<20160825143708.GD25041@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160825143708.GD25041@bfoster.bfoster>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

T24gVGh1LCBBdWcgMjUsIDIwMTYgYXQgMTA6Mzc6MDlBTSAtMDQwMCwgQnJpYW4gRm9zdGVyIHdy
b3RlOgo+IE9uIGp1c3Qgc2tpbW1pbmcgb3ZlciB0aGlzIHNvIGZhciwgSSBmZWVsIGxpa2UgdGhp
cyBzaG91bGQgYmUgYXQgbGVhc3QKPiB0d28gcGF0Y2hlcywgcG9zc2libHkgMzoKPiAKPiAtIEtp
bGwgeGZzX2JtYXBpX2RlbGF5KCkgYW5kIHB1bGwgdXAgYXNzb2NpYXRlZCBiaXRzIHRvIGlvbWFw
KCkuCgpBcyBpbiBqdXN0IGEgbW92ZSBvZiBjb2RlIHRvIHhmc19pb21hcC5jIG9yIGFsc28gbWVy
Z2VkIGl0IHdpdGggYQpwYXJ00ZZhbCBjb3B5IG9mIHhmc19maWxlX2lvbWFwX2JlZ2luPyAgVGhl
IGZpcnN0IGlzIHRyaXZpYWwsIGJ1dCBhbHNvCnJhdGhlciBwb2ludGxlc3MuICBUaGUgc2Vjb25k
IGlzIGEgYml0IG1vcmUgd29yaywgc3RpbGwgdmVyeSBkb2FibGUKYnV0IHByb2JhYmx5IGFsc28g
bm90IHRoYXQgdXNlZnVsIGFzIHdlJ3JlIGdvaW5nIHRvIHRvdGFsbHkgcmV3cml0ZSBpdAphZ2Fp
biBpbiB0aGUgbmV4dCBzdGVwLgoKPiAtIFBvc3NpYmx5IHNlcGFyYXRlIG91dCB0aGUgcGFydCB0
aGF0IG1vdmVzIGl0ZXJhdGlvbiBmcm9tIHRoZSAoZm9ybWVyKQo+ICAgeGZzX2JtYXBpX2RlbGF5
KCkgY29kZSB1cCB0byB0aGUgaW9tYXAgY29kZSwgaWYgd2UgY2FuIGRvIHNvIGNsZWFubHkuCgpX
ZWxsLCB0aGUgbWFqb3IgcG9pbnQgaXMgdGhhdCB3ZSBnZXQgcmlkIG9mIHRoZSBpdGVyYXRpb24g
YXMgdGhlcmUgaXNuJ3QKYW55IGFjdHVhbCBuZWVkIGZvciBpdC4KCj4gLSBSZWZhY3Rvci9yZXdv
cmsgdGhlIHByZWFsbG9jYXRlIGxvZ2ljLgoKQnV0IEkgZ3Vlc3MgSSBjb3VsZCBkbyBhIHBhc3Mg
dGhhdCBjcmVhdGVzIHhmc19maWxlX2lvbWFwX2JlZ2luX2RlbGF5CmFzIGluIHRoZSBuZXcgdmVy
c2lvbiBleGNlcHQgd2l0aG91dCB0aGUgcHJlYWxsb2MgY2hhbmdlcywgYW5kIHRoZW4Kc2VwYXJh
dGUgdGhlbSBvdXQuICBJIGRvbid0IHF1aXRlIHNlZSB0aGUgcG9pbnQsIHRob3VnaC4uCj4gSSdt
IG5vdCBuZWNlc3NhcmlseSBhZ2FpbnN0IGNsZWFuaW5nIHVwL3Jld29ya2luZyB0aGUgcHJlYWxs
b2MgYml0cywgYnV0Cj4gSSdtIG5vdCBhIGh1Z2UgZmFuIG9mIG9wZW4gY29kaW5nIGFsbCBvZiB0
aGlzIGhlcmUgaW4gdGhlIGlvbWFwCj4gZnVuY3Rpb24uIElmIG5vdGhpbmcgZWxzZSwgdGhlIGlu
ZGVudGF0aW9uIHN0YXJ0cyB0byBtYWtlIG15IGV5ZXMKPiBjcm9zcy4uLiBjb3VsZCB3ZSByZXRh
aW4gb25lIGxldmVsIG9mIGFic3RyYWN0aW9uIGhlcmUgZm9yIHRoaXMgaHVuayBvZgo+IGxvZ2lj
IHRoYXQgdXBkYXRlcyBlbmRfZnNiPwoKV2UncmUgb25seSBoYXZpbmcgdGhyZWUgdGFicyBvZiBp
bmRlbnRhdGlvbi4gIEkgYWN0dWFsbHkgbG9va2VkIGludG8KYSBoZWxwZXIgZm9yIHRoYXQgd2hv
bGUgYmxvY2ssIGJ1dCB3ZSdkIG5lZWQgdG8gcGFzczoKCmlwLCBpZHgsIHByZXYsIG9mZnNldF9m
c2IsIG9mZnNldCwgY291bnQsIG1heGJ5dGVzX2ZzYgoKKHdlIGNvdWxkIHBvdGVudGlhbGx5IHJl
LWRlcml2ZSBvZmZzZXRfZnNiIGZyb20gb2Zmc2V0IGlmIHdlIGRvbid0Cm1pbmQgdGhlIGluZWZm
aWNpZW55IGFuZCByZWNhbGN1bGF0ZSBtYXhieXRlc19mc2IuICBUaGlzIGFscmVhZHkKYXNzdW1l
cyBtcCBpcyB0cml2aWFsbHkgZGVyaXZlZCBmcm9tIGlwKQoKYW5kIHJldHVybgoKYWxsb2NfYmxv
Y2tzLCBlbmRfZnNiCgpzbyB0aGUgZnVuY3Rpb24gd291bGQgYmUgcXVpdGUgYSBtb25zdGVyIGlu
IHRlcm1zIG9mIGl0cyBjYWxsaW5nCmNvbnZlbnRpb24uICBBZGRpdGlvbmFsbHkgd2UnZCBoYXZl
IHRoZSByZWxhdGVkIGJ5IG5vdCBxdXRlIHRoZQpzYW1lIGlmIGJsb2NrcyBhcm91bmQgWEZTX01P
VU5UX0RGTFRfSU9TSVpFIGFuZCB0aGUgaXNpemUgc3BsaXQKb3ZlciB0d28gZnVuY3Rpb25zLCB3
aGljaCBkb2Vzbid0IGV4YWN0bHkgaGVscCB1bmRlcnN0YW5kaW5nCnRoZSBmbG93LgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
