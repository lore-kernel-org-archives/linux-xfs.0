Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4323C7CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 00:57:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8AB2AC002
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:57:17 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id jBCu5YcIt6yObQlW (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2016 22:57:15 -0700 (PDT)
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block devices
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <7f5bf66e-cbe7-3ec3-3325-0a2e01a54593@suse.de>
Date: Thu, 29 Sep 2016 07:57:13 +0200
MIME-Version: 1.0
In-Reply-To: <147510959149.8940.2897845352082568677.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com

T24gMDkvMjkvMjAxNiAwMjozOSBBTSwgRGFycmljayBKLiBXb25nIHdyb3RlOgo+IEFmdGVyIG11
Y2ggZGlzY3Vzc2lvbiwgaXQgc2VlbXMgdGhhdCB0aGUgZmFsbG9jYXRlIGZlYXR1cmUgZmxhZwo+
IEZBTExPQ19GTF9aRVJPX1JBTkdFIG1hcHMgbmljZWx5IHRvIFNDU0kgV1JJVEUgU0FNRTsgYW5k
IHRoZSBmZWF0dXJlCj4gRkFMTE9DX0ZMX1BVTkNIX0hPTEUgbWFwcyBuaWNlbHkgdG8gdGhlIGRl
dmljZXMgdGhhdCBoYXZlIGJlZW4KPiB3aGl0ZWxpc3RlZCBmb3IgemVyb2luZyBTQ1NJIFVOTUFQ
LiAgUHVuY2ggc3RpbGwgcmVxdWlyZXMgdGhhdAo+IEZBTExPQ19GTF9LRUVQX1NJWkUgaXMgc2V0
LiAgQSBsZW5ndGggdGhhdCBnb2VzIHBhc3QgdGhlIGVuZCBvZiB0aGUKPiBkZXZpY2Ugd2lsbCBi
ZSBjbGFtcGVkIHRvIHRoZSBkZXZpY2Ugc2l6ZSBpZiBLRUVQX1NJWkUgaXMgc2V0OyBvciB3aWxs
Cj4gcmV0dXJuIC1FSU5WQUwgaWYgbm90LiAgQm90aCBzdGFydCBhbmQgbGVuZ3RoIG11c3QgYmUg
YWxpZ25lZCB0byB0aGUKPiBkZXZpY2UncyBsb2dpY2FsIGJsb2NrIHNpemUuCj4gCj4gU2luY2Ug
dGhlIHNlbWFudGljcyBvZiBmYWxsb2NhdGUgYXJlIGZhaXJseSB3ZWxsIGVzdGFibGlzaGVkIGFs
cmVhZHksCj4gd2lyZSB1cCB0aGUgdHdvIHBpZWNlcy4gIFRoZSBvdGhlciBmYWxsb2NhdGUgdmFy
aWFudHMgKGNvbGxhcHNlIHJhbmdlLAo+IGluc2VydCByYW5nZSwgYW5kIGFsbG9jYXRlIGJsb2Nr
cykgYXJlIG5vdCBzdXBwb3J0ZWQuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFycmljayBKLiBXb25n
IDxkYXJyaWNrLndvbmdAb3JhY2xlLmNvbT4KPiAtLS0KPiB2MjogSW5jb3Jwb3JhdGUgZmVlZGJh
Y2sgZnJvbSBDaHJpc3RvcGggJiBMaW51cy4gIFRlbnRhdGl2ZWx5IGFkZAo+IGEgcmVxdWlyZW1l
bnQgdGhhdCB0aGUgZmFsbG9jYXRlIGFyZ3VtZW50cyBiZSBhbGlnbmVkIHRvIGxvZ2ljYWwgYmxv
Y2sKPiBzaXplLCBhbmQgcHV0IGluIGEgZmV3IFhYWCBjb21tZW50cyBhaGVhZCBvZiBMU0YgZGlz
Y3Vzc2lvbi4KPiB2MzogRm9yd2FyZCBwb3J0IHRvIDQuNy4KPiB2NDogRm9yd2FyZCBwb3J0IHRv
IDQuOC4KPiAtLS0KPiAgZnMvYmxvY2tfZGV2LmMgfCAgIDc4ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIGZzL29wZW4uYyAgICAgIHwg
ICAgMyArLQo+ICAyIGZpbGVzIGNoYW5nZWQsIDgwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmNvbT4KCkNoZWVy
cywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZQkJICAgICAgelNlcmllcyAmIFN0b3Jh
Z2UKaGFyZUBzdXNlLmRlCQkJICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBMSU5VWCBQcm9k
dWN0cyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEouIEhhd24sIEou
IEd1aWxkLCBGLiBJbWVuZMO2cmZmZXIsIEhSQiAxNjc0NiAoQUcgTsO8cm5iZXJnKQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlz
dAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZz
Cg==
