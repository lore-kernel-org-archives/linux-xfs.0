Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13CD87F47
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 16:35:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F32588F8037
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 14:35:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yBBEbDK3FRh7vmDb for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 14:35:29 -0800 (PST)
Date: Wed, 19 Nov 2014 09:35:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
Message-ID: <20141118223518.GR23575@dastard>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
	<20141118133206.GA5226@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141118133206.GA5226@bfoster.bfoster>
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
Cc: Mukul Malhotra <smilemukul2005@gmail.com>, xfs@oss.sgi.com

T24gVHVlLCBOb3YgMTgsIDIwMTQgYXQgMDg6MzI6MDdBTSAtMDUwMCwgQnJpYW4gRm9zdGVyIHdy
b3RlOgo+IE9uIFR1ZSwgTm92IDE4LCAyMDE0IGF0IDA2OjA1OjU4UE0gKzA1MzAsIE11a3VsIE1h
bGhvdHJhIHdyb3RlOgo+ID4g4oCLSGVsbG8sCj4gPiAKPiA+IERvZXMgeGZzIGhhdmUgcmVzZXJ2
ZWQgYmxvY2tzIHRvbywgbGlrZSBleHQqID8gaWYgeWVzLCBob3cgY2FuIHRoZXkgYmUKPiA+IGRl
dGVybWluZWQgP+KAiwo+ID4gCj4gCj4gWEZTIHJlc2VydmVzIGJsb2NrcyBpbnRlcm5hbGx5IHN1
Y2ggdGhhdCBpdCBjYW4gcGVyZm9ybSBvcGVyYXRpb25zIHdoZW4KPiBhbGwgZnJlZSBzcGFjZSBp
cyBjb25zdW1lZCwgZXRjLiBJdCBsb29rcyBsaWtlIDUlIGlzIHRoZSBkZWZhdWx0LgoKTm90IHF1
aXRlLgoKICAgICAgICAvKgogICAgICAgICAqIFdlIGRlZmF1bHQgdG8gNSUgb3IgODE5MiBmc2Jz
IG9mIHNwYWNlIHJlc2VydmVkLCB3aGljaGV2ZXIgaXMKICAgICAgICAgKiBzbWFsbGVyLiAgVGhp
cyBpcyBpbnRlbmRlZCB0byBjb3ZlciBjb25jdXJyZW50IGFsbG9jYXRpb24KICAgICAgICAgKiB0
cmFuc2FjdGlvbnMgd2hlbiB3ZSBpbml0aWFsbHkgaGl0IGVub3NwYy4gVGhlc2UgZWFjaCByZXF1
aXJlIGEgNAogICAgICAgICAqIGJsb2NrIHJlc2VydmF0aW9uLiBIZW5jZSBieSBkZWZhdWx0IHdl
IGNvdmVyIHJvdWdobHkgMjAwMCBjb25jdXJyZW50CiAgICAgICAgICogYWxsb2NhdGlvbiByZXNl
cnZhdGlvbnMuCiAgICAgICAgICovCgpTbywgaW4gbW9zdCBjYXNlcywgdGhlcmUgYXJlIDMyTUIg
b2YgcmVzZXJ2ZWQgYmxvY2tzIGF2YWlsYWJsZSBmb3IKaW50ZXJuYWwgZW1lcmdlbmN5IHVzZS4K
Cj4gSSBkb24ndCB0aGluayBpdCdzICJsaWtlIGV4dDQsIiBob3dldmVyLCB3aGljaCByZXNlcnZl
cyBibG9ja3MgZm9yIHRoZQo+IHJvb3QgdXNlci4gSSBkb24ndCBiZWxpZXZlIHRoZSByZXNlcnZl
ZCBibG9ja3MgaW4gWEZTIGFyZSBhY2Nlc3NpYmxlIGZvcgo+IGZpbGUgYWxsb2NhdGlvbiBieSBh
bnkgdXNlciB1bmxlc3MgdGhlIHJlc2VydmUgcG9vbCBpcyBtb2RpZmllZCBhcyBzdWNoLgoKTW9z
dCBkZWZpbml0ZWx5IG5vdCAibGlrZSBleHQ0Ii4gVGhlIHJlc2VydmVkIGJsb2NrcyBhcmUgY29u
c2lkZXJlZAoidXNlZCBzcGFjZSIgKGkuZS4gbm90IGF2YWlsYWJsZSB0byBhbnkgdXNlcikgYW5k
IGFyZSByZXBvcnRlZCBhcwpzdWNoIGluIHN0YXRmcygpIG91dHB1dCAoZS5nLiB2aWEgZGYpLgoK
Q2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
