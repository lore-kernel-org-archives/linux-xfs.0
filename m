Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5B1XLsJ023432 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 20:33:21 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D82416EAC7C
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:33:19 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 5gH9sujbD1ALcjwU for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:33:19 -0700 (PDT)
Message-ID: <4DF2C5D4.6030507@tlinx.org>
Date: Fri, 10 Jun 2011 18:33:08 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: FYI: LSI rebuilding;
	and XFS speed V. raw - hints on maxing out 'dd'....(if not already
	obvious)...
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
	<20110502191323.417ef644@harpe.intellique.com>
In-Reply-To: <20110502191323.417ef644@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Paul Anderson <pha@umich.edu>, xfs@oss.sgi.com

CgpFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgTW9uLCAyIE1heSAyMDExIDExOjQ3OjQ4IC0w
NDAwCj4gUGF1bCBBbmRlcnNvbiA8cGhhQHVtaWNoLmVkdT4gw6ljcml2YWl0Ogo+IAo+PiBXZSBh
cmUgZGVwbG95aW5nIGZpdmUgRGVsbCA4MTBzLCAxOTJHaUIgUkFNLCAxMiBjb3JlLCBlYWNoIHdp
dGggdGhyZWUKPj4gTFNJIDkyMDAtOEUgU0FTIGNvbnRyb2xsZXJzLCBhbmQgdGhyZWUgU3VwZXJN
aWNybyA4NDcgNDUgZHJpdmUgYmF5Cj4+IGNhYmluZXRzIHdpdGggZW50ZXJwcmlzZSBncmFkZSAy
VEIgZHJpdmVzLgo+IAo+IEkgaGF2ZSB2ZXJ5IGxpdHRsZSBleHBlcmllbmNlIHdpdGggdGhlc2Ug
UkFJRCBjb29udHJvbGxlcnMuIEhvd2V2ZXIgSQo+IGhhdmUgYSA5MjEyIDRpNGUgKHNhbWUgY2Fy
ZCBnZW5lcmF0aW9uIGFuZCBzYW1lIGNoaXBzZXQpIGluIHRlc3QsIGFuZCBzbwo+IGZhciBJIG11
c3Qgc2F5IGl0IGxvb2tzIGxpa2UgX3V0dGVyXyBfY3JhcF8uIFRoZSBwZXJmb3JtYW5jZSBpcyBh
YnlzbWFsCj4gKGl0J3MgYmVlbiBidXN5IHJlYnVpbGRpbmcgYSAyMFRCIGFycmF5IGZvci4uLiA2
IGRheXMhKTsgdGhlIHNlcnZlcgotLS0tCkJ5IGRlZmF1bHQgdGhlIGNhcmQgb25seSBhbGxvY2F0
ZXMgYWJvdXQgMjAlIG9mIGl0J3MgZGlzayBjYXBhY2l0eSBmb3IKcmVidWlsZHMgd2l0aCB0aGUg
cmVzdCBhbGxvY2F0ZWQgZm9yICdyZWFsIHdvcmsnLiAgIEl0J3Mgbm90IHNvIHNtYXJ0IGFzCnRv
IHVzZSAxMDAlIHdoZW4gdGhlcmUgaXMgbm8gcmVhbCB3b3JrLi4uICAgSWYgeW91IGVudGVyIHRo
ZSBjb250cm9sIHNvZnR3YXJlLCAKKHJ1bnMgdW5kZXIgWCBvbiBsaW51eCAtLSBldmVuIGRpc3Bs
YXlzIG9uIEN5Z1gpLi4uIGFuZCBlbnRlciBzb21ldGhpbmcgbGlrZQo5MCUsIHlvdSdsbCBmaW5k
IHlvdXIgcmVidWlsZHMgd2lsbCBnbyBtdWNoIGZhc3RlciwgYnV0IHlvdSBjYW4gZXhwZWN0IGFu
eQpyZWFsLWFjY2VzcyB0byB0aGUgZGV2aWNlIHRvIHN1ZmZlciBhY2NvcmRpbmdseS4KCkkgaGF2
ZSBhIDkyODUtOEUgYW5kIGhhdmUgYmVlbiBwcmV0dHkgaGFwcHkgd2l0aCBpdCdzIHBlcmZvcm1h
bmNlLCBidXQgSSBvbmx5CmhhdmUgMTAgZGF0YSBkaXNrcyAoMng2LWRpc2sgUkFJRDUgPT5SQUlE
NTApIHdpdGggMlRCIFNBVEEncyBhbmQgZ2V0IDFHQiBwZXJmLi4uCmFib3V0IHdoYXQgSSdkIGV4
cGVjdCBmcm9tIGRpc2tzIHRoYXQgZ2V0IGFyb3VuZCAxMjBNQiBlYWNoIGFuZCBkb2luZyAyIFJB
SUQ1CmNhbGNzLi4uKS4uLgoKLS0tLQoKVGhlIG9ubHkgb3RoZXIgdGhpbmdzIEkgY2FuIHRoaW5r
IG9mIHdoZW4gYmVuY2hpbmcgWEZTIGZvciBtYXggdGhyb3VnaHB1dC4KCjEpIFJlYWx0aW1lIHBh
cnRpdGlvbiBtaWdodCBiZSBhbiBvcHRpb24gKG5ldmVyIHRyaWVkLCBidXQgdGhvdWdodCBJJ2Qg
bWVudGlvbgppdCkKCjIpIG9uICJkZCIsIGlmIHlvdSBhcmUgdGVzdGluZyAid3JpdGUiIHBlcmZv
cm1hbmNlLCB0cnkgcHJlLWFsbG9jYXRpbmcgdGhlIGZpbGUKdXNpbmcgKGZpbGxpbmcgaW4gdGhl
IHZhcnMuLi4pOgoKICAgeGZzX2lvIC1mIC1jICJ0cnVuY2F0ZSAkc2l6ZSIgLWMgInJlc3ZzcCAw
ICRzaXplIiAiJE5ld2ZpbGUiCgp0aGVuIHRlc3QgZm9yIGZyYWdtZW50YXRpb246CihzZWUgaWYg
aXQgaXMgaW4gMSAnZXh0ZW50Jy4uLi4sIDEvbGluZSk6CgoJeGZzX2JtYXAgICIkTmV3ZmlsZSIK
CmlmIG5lZWRlZCwgdHJ5IGRlZnJhZ2dpbmc6CiAgeGZzX2ZzciAiJE5ld2ZpbGUiCgpUaGVuIG9u
ICJkZCIgdXNlIHRoZSBjb252PSJub2NyZWF0LG5vdHJ1bmMiIGZsYWdzIC0tIHRoYXQgd2F5IHlv
dSdsbCBiZSBhYmxlCnRvIGR1bXAgSS9PIGRpcmVjdGx5IGludG8gdGhlIGZpbGUgd2l0aG91dCBp
dCBoYXZpbmcgdG8gYmUgImNyZWF0ZWQgb3IgYWxsb2NhdGVkIi4uLgoKCgoKCgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
