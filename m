Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7888D7F37
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:04:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17067AC002
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:04:32 -0700 (PDT)
Received: from mail-ee0-f45.google.com (mail-ee0-f45.google.com
	[74.125.83.45]) by cuda.sgi.com with ESMTP id v61ZILXYFdYshKvI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Jun 2013 22:04:31 -0700 (PDT)
Received: by mail-ee0-f45.google.com with SMTP id c1so1179251eek.18
	for <xfs@oss.sgi.com>; Thu, 06 Jun 2013 22:04:29 -0700 (PDT)
Received: from t400.localnet (89-69-21-174.dynamic.chello.pl. [89.69.21.174])
	by mx.google.com with ESMTPSA id
	cf47sm6982269eeb.17.2013.06.06.22.04.28 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Thu, 06 Jun 2013 22:04:29 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
Date: Fri, 7 Jun 2013 07:04:27 +0200
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
	<20130607035046.GJ29338@dastard>
In-Reply-To: <20130607035046.GJ29338@dastard>
MIME-Version: 1.0
Message-Id: <201306070704.28004.arekm@maven.pl>
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
To: xfs@oss.sgi.com

T24gRnJpZGF5IDA3IG9mIEp1bmUgMjAxMywgRGF2ZSBDaGlubmVyIHdyb3RlOgoKPiA+IEkgc3Vz
cGVjdCB0aGF0IHVwb24gcmUtbW91bnQsIFhGUyBpcyBydW5uaW5nIGEgcXVvdGEgY2hlY2sgb24g
dGhlIDE0VEIKPiA+IFJBSUQuIE15IHF1ZXN0aW9uIGlzOiBob3cgZG8gSSBkaXNhYmxlIHRoZSBp
bml0aWFsIHF1b3RhIGNoZWNrIHNvIGl0Cj4gPiBjYW4gbW91bnQgaXQgcHJvcGVybHkgYW5kIGhh
dmUgcXVvdGEgY2hlY2sgcnVuIGluIHRoZSBiYWNrZ3JvdW5kPwo+IAo+IFlvdSBjYW4ndC4gcXVv
dGFjaGVjayByZWxpZXMgb24gZXhjbHVzaXZlIGFjY2VzcyB0byB0aGUgZmlsZXN5c3RlbSwKPiBh
bmQgc28gdGhlIG1vdW50IGNhbm5vdCBwcm9jZXNzIHVudGlsIGl0IGNvbXBsZXRlcy4gUXVvdGFz
IG5lZWQgdG8KPiBiZSBjb25zaXN0ZW50IGJlZm9yZSB5b3UgY2FuIHN0YXJ0IHVzaW5nIHRoZSBm
aWxlc3lzdGVtLi4uLgo+IAo+IE5vdywgdGhlcmUncyB0aGUgcG9zc2liaWxpdHkgdGhhdCB3ZSBj
b3VsZCBwYXJhbGxlbGlzZSBxdW90YWNoZWNrCj4gYmVjYXVzZSBpdCB1c2VzIGJ1bGtzdGF0IGZv
ciBpdGVyYXRpb24sIGJ1dCBzb21lYm9keSB3b3VsZCBoYXZlIHRvCj4gZmluZCB0aGUgdGltZSB0
byBkbyB0aGF0IGFuZCBpdCB3b24ndCBzb2x2ZSB5b3VyIGltbWVkaWF0ZSBwcm9ibGVtLgoKSSdt
IGZhY2luZyBzaW1pbGFyIHByb2JsZW0gc29tZXRpbWVzLiBUaGUgcGFyYWxsZWxpc2F0aW9uIHdv
dWxkIGJlIG5pY2UgYnV0IApJJ20gbWlzc2luZyBzb21ldGhpbmcgbW9yZSBvYnZpb3VzIC0ga2lu
ZCBvZiBwcm9ncmVzcyBpbmRpY2F0b3IsIGxpa2UgcHJpbnRrZWQgCm1lc3NhZ2UgKG9yIGluIHBy
b2Mvc3lzZnMpIGFmdGVyIHByb2Nlc3Npbmcgc29tZSBrbm93biBwYXJ0IG9mIGpvYi4KClRoaXMg
aXMgbmVlZGVkIHB1cmVseSBmb3IgZXN0aW1hdGluZyBkb3dudGltZSBvZiB0aGUgc2VydmljZS4K
Cj4gSGVuY2UgSSBzdWdnZXN0IGp1c3Qgd2FpdGluZyBmb3IgaXQgdG8gY29tcGxldGUgLSBpZiB5
b3UgaGF2ZQo+IG1pbGxpb25zIG9mIGlub2RlcyBpdCBjb3VsZCBob3VycyB0byBjb21wbGV0ZSwg
c28ganVzdCBsZXQgaXQgZ28KPiBvdmVybmlnaHQuLi4KCi4uLiBhbmQgc2F5IHVzZXJzIGdvb2Ri
eWUgOykKCj4gCj4gQ2hlZXJzLAo+IAo+IERhdmUuCgoKLS0gCkFya2FkaXVzeiBNacWba2lld2lj
eiwgYXJla20gLyBtYXZlbi5wbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
