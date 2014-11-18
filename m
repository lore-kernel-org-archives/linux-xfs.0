Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CC8E7F3F
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 07:32:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEDD6AC00A
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 05:32:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jB2CJ3N6DEUhxC9n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 05:32:13 -0800 (PST)
Date: Tue, 18 Nov 2014 08:32:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
Message-ID: <20141118133206.GA5226@bfoster.bfoster>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
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
To: Mukul Malhotra <smilemukul2005@gmail.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCBOb3YgMTgsIDIwMTQgYXQgMDY6MDU6NThQTSArMDUzMCwgTXVrdWwgTWFsaG90cmEg
d3JvdGU6Cj4g4oCLSGVsbG8sCj4gCj4gRG9lcyB4ZnMgaGF2ZSByZXNlcnZlZCBibG9ja3MgdG9v
LCBsaWtlIGV4dCogPyBpZiB5ZXMsIGhvdyBjYW4gdGhleSBiZQo+IGRldGVybWluZWQgP+KAiwo+
IAoKWEZTIHJlc2VydmVzIGJsb2NrcyBpbnRlcm5hbGx5IHN1Y2ggdGhhdCBpdCBjYW4gcGVyZm9y
bSBvcGVyYXRpb25zIHdoZW4KYWxsIGZyZWUgc3BhY2UgaXMgY29uc3VtZWQsIGV0Yy4gSXQgbG9v
a3MgbGlrZSA1JSBpcyB0aGUgZGVmYXVsdC4KCkkgZG9uJ3QgdGhpbmsgaXQncyAibGlrZSBleHQ0
LCIgaG93ZXZlciwgd2hpY2ggcmVzZXJ2ZXMgYmxvY2tzIGZvciB0aGUKcm9vdCB1c2VyLiBJIGRv
bid0IGJlbGlldmUgdGhlIHJlc2VydmVkIGJsb2NrcyBpbiBYRlMgYXJlIGFjY2Vzc2libGUgZm9y
CmZpbGUgYWxsb2NhdGlvbiBieSBhbnkgdXNlciB1bmxlc3MgdGhlIHJlc2VydmUgcG9vbCBpcyBt
b2RpZmllZCBhcyBzdWNoLgoKPiBDYW4geW91IHByb3ZpZGUgdGhlIHNwZWNpZmljIGNvbW1hbmQu
Cj4gCgpUaGUgZm9sbG93aW5nIGNvbW1hbmQgY2FuIGdldC9zZXQgdGhlIHJlc2VydmVkIGJsb2Nr
IGNvdW50IG9uIGFuIGFjdGl2ZQptb3VudDoKCnhmc19pbyAteCAtYyAicmVzYmxrcyIgPG1udD4K
Ck5vdGUgdGhhdCB0aGlzIGNhbiBsZWFkIHRvIHByb2JsZW1zIGlmIHJlZHVjZWQgdG9vIG11Y2gg
YW5kIGFsbCBzcGFjZSBpcwpjb25zdW1lZCwgYXMgc29tZXRpbWVzIGJsb2NrIGFsbG9jYXRpb24g
aXMgcmVxdWlyZWQgdG8gcGVyZm9ybSBzcGFjZQpmcmVlaW5nIG9wZXJhdGlvbnMgKHJlbW92aW5n
IGEgZmlsZSwgZXRjLikuIFRoaXMgaXMgcHJvYmFibHkgYSByZWFzb24KdGhlIHJlc2Jsa3MgY29t
bWFuZCBpcyBvbmx5IGF2YWlsYWJsZSBpbiB4ZnNfaW8gZXhwZXJ0IG1vZGUuIDspCgpCcmlhbgoK
PiBUaGFua3MKPiBNdWt1bAoKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3NzLnNnaS5jb20KPiBodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
