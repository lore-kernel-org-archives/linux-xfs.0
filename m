Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A0E77F50
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:57:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7701304082
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:57:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OEFI8aJWvwokERz1 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:57:57 -0700 (PDT)
Date: Fri, 7 Jun 2013 15:57:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
Message-ID: <20130607055755.GK29338@dastard>
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
	<20130607035046.GJ29338@dastard>
	<201306070704.28004.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201306070704.28004.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gRnJpLCBKdW4gMDcsIDIwMTMgYXQgMDc6MDQ6MjdBTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIEZyaWRheSAwNyBvZiBKdW5lIDIwMTMsIERhdmUgQ2hpbm5lciB3
cm90ZToKPiAKPiA+ID4gSSBzdXNwZWN0IHRoYXQgdXBvbiByZS1tb3VudCwgWEZTIGlzIHJ1bm5p
bmcgYSBxdW90YSBjaGVjayBvbiB0aGUgMTRUQgo+ID4gPiBSQUlELiBNeSBxdWVzdGlvbiBpczog
aG93IGRvIEkgZGlzYWJsZSB0aGUgaW5pdGlhbCBxdW90YSBjaGVjayBzbyBpdAo+ID4gPiBjYW4g
bW91bnQgaXQgcHJvcGVybHkgYW5kIGhhdmUgcXVvdGEgY2hlY2sgcnVuIGluIHRoZSBiYWNrZ3Jv
dW5kPwo+ID4gCj4gPiBZb3UgY2FuJ3QuIHF1b3RhY2hlY2sgcmVsaWVzIG9uIGV4Y2x1c2l2ZSBh
Y2Nlc3MgdG8gdGhlIGZpbGVzeXN0ZW0sCj4gPiBhbmQgc28gdGhlIG1vdW50IGNhbm5vdCBwcm9j
ZXNzIHVudGlsIGl0IGNvbXBsZXRlcy4gUXVvdGFzIG5lZWQgdG8KPiA+IGJlIGNvbnNpc3RlbnQg
YmVmb3JlIHlvdSBjYW4gc3RhcnQgdXNpbmcgdGhlIGZpbGVzeXN0ZW0uLi4uCj4gPiAKPiA+IE5v
dywgdGhlcmUncyB0aGUgcG9zc2liaWxpdHkgdGhhdCB3ZSBjb3VsZCBwYXJhbGxlbGlzZSBxdW90
YWNoZWNrCj4gPiBiZWNhdXNlIGl0IHVzZXMgYnVsa3N0YXQgZm9yIGl0ZXJhdGlvbiwgYnV0IHNv
bWVib2R5IHdvdWxkIGhhdmUgdG8KPiA+IGZpbmQgdGhlIHRpbWUgdG8gZG8gdGhhdCBhbmQgaXQg
d29uJ3Qgc29sdmUgeW91ciBpbW1lZGlhdGUgcHJvYmxlbS4KPiAKPiBJJ20gZmFjaW5nIHNpbWls
YXIgcHJvYmxlbSBzb21ldGltZXMuIFRoZSBwYXJhbGxlbGlzYXRpb24gd291bGQgYmUgbmljZSBi
dXQgCj4gSSdtIG1pc3Npbmcgc29tZXRoaW5nIG1vcmUgb2J2aW91cyAtIGtpbmQgb2YgcHJvZ3Jl
c3MgaW5kaWNhdG9yLCBsaWtlIHByaW50a2VkIAo+IG1lc3NhZ2UgKG9yIGluIHByb2Mvc3lzZnMp
IGFmdGVyIHByb2Nlc3Npbmcgc29tZSBrbm93biBwYXJ0IG9mIGpvYi4KClBhdGNoZXMgd2VsY29t
ZSA7KQoKPiBUaGlzIGlzIG5lZWRlZCBwdXJlbHkgZm9yIGVzdGltYXRpbmcgZG93bnRpbWUgb2Yg
dGhlIHNlcnZpY2UuCgp4ZnN0ZXN0czpzcmMvYnN0YXQKCnRoYXQgd2lsbCBydW4gYSBzaW5nbGUg
dGhyZWFkZWQgYnVsa3N0YXQgcGFzcyBhY3Jvc3MgeW91cgpmaWxlc3lzdGVtLiBZb3UgY2FuIGRv
IGl0IG9ubGluZSwgd2hpbGUgdGhlIGZpbGVzeXN0ZW0gaXMgdXAgYW5kCmJlaW5nIHVzZWQsIGFu
ZCBpdCdzIHJ1bnRpbWUgd2lsbCBnaXZlIHlvdSBhbiBpbmRpY2F0aW9uIG9mIGhvdyBsb25nCmEg
cXVvdGFjaGVjayAoYSBzaW5nbGUgdGhyZWFkZWQgYnVsa3N0YXQgcGFzcykgd2lsbCB0YWtlIHRv
IHJ1bi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNv
bQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
