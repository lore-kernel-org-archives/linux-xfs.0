Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 085507CB3
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 07:13:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE2FC304048
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 05:13:58 -0700 (PDT)
Received: from mail-qk0-f174.google.com (mail-qk0-f174.google.com
	[209.85.220.174]) by cuda.sgi.com with ESMTP id
	Vto4bHZ2f6wfdtox (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jul 2016 05:13:56 -0700 (PDT)
Received: by mail-qk0-f174.google.com with SMTP id p74so11454607qka.0
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2016 05:13:56 -0700 (PDT)
Message-ID: <1468325634.7798.24.camel@redhat.com>
Subject: Re: [PATCH v23 20/22] vfs: Add richacl permission checking
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 12 Jul 2016 08:13:54 -0400
In-Reply-To: <1467294433-3222-21-git-send-email-agruenba@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-21-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
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
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

T24gVGh1LCAyMDE2LTA2LTMwIGF0IDE1OjQ3ICswMjAwLCBBbmRyZWFzIEdydWVuYmFjaGVyIHdy
b3RlOgo+IEhvb2sgdGhlIHJpY2hhY2wgcGVybWlzc2lvbiBjaGVja2luZyBmdW5jdGlvbiBpbnRv
IHRoZSB2ZnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmVhcyBHcnVlbmJhY2hlciA8YWdydWVu
YmFAcmVkaGF0LmNvbT4KPiAtLS0KPiDCoGZzL25hbWVpLmMgfCA1NCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA1MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy9u
YW1laS5jIGIvZnMvbmFtZWkuYwo+IGluZGV4IDdhODIyZDAuLjQ4Yzk5NTggMTAwNjQ0Cj4gLS0t
IGEvZnMvbmFtZWkuYwo+ICsrKyBiL2ZzL25hbWVpLmMKPiBAQCAtMzQsNiArMzQsNyBAQAo+IMKg
I2luY2x1ZGUgCj4gwqAjaW5jbHVkZSAKPiDCoCNpbmNsdWRlIAo+ICsjaW5jbHVkZSAKPiDCoCNp
bmNsdWRlIAo+IMKgI2luY2x1ZGUgCj4gwqAjaW5jbHVkZSAKPiBAQCAtMjU2LDcgKzI1Nyw0MyBA
QCB2b2lkIHB1dG5hbWUoc3RydWN0IGZpbGVuYW1lICpuYW1lKQo+IMKgCQlfX3B1dG5hbWUobmFt
ZSk7Cj4gwqB9Cj4gwqAKPiAtc3RhdGljIGludCBjaGVja19hY2woc3RydWN0IGlub2RlICppbm9k
ZSwgaW50IG1hc2spCj4gK3N0YXRpYyBpbnQgY2hlY2tfcmljaGFjbChzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBpbnQgbWFzaykKPiArewo+ICsjaWZkZWYgQ09ORklHX0ZTX1JJQ0hBQ0wKPiArCWlmICht
YXNrICYgTUFZX05PVF9CTE9DSykgewo+ICsJCXN0cnVjdCBiYXNlX2FjbCAqYmFzZV9hY2w7Cj4g
Kwo+ICsJCWJhc2VfYWNsID0gcmN1X2RlcmVmZXJlbmNlKGlub2RlLT5pX2FjbCk7Cj4gKwkJaWYg
KCFiYXNlX2FjbCkKPiArCQkJZ290byBub19hY2w7Cj4gKwkJLyogbm8gLT5nZXRfcmljaGFjbCgp
IGNhbGxzIGluIFJDVSBtb2RlLi4uICovCj4gKwkJaWYgKGlzX3VuY2FjaGVkX2FjbChiYXNlX2Fj
bCkpCj4gKwkJCXJldHVybiAtRUNISUxEOwo+ICsJCXJldHVybiByaWNoYWNsX3Blcm1pc3Npb24o
aW5vZGUsIHJpY2hhY2woYmFzZV9hY2wpLAo+ICsJCQkJCcKgwqBtYXNrICYgfk1BWV9OT1RfQkxP
Q0spOwo+ICsJfSBlbHNlIHsKPiArCQlzdHJ1Y3QgcmljaGFjbCAqYWNsOwo+ICsKPiArCQlhY2wg
PSBnZXRfcmljaGFjbChpbm9kZSk7Cj4gKwkJaWYgKElTX0VSUihhY2wpKQo+ICsJCQlyZXR1cm4g
UFRSX0VSUihhY2wpOwo+ICsJCWlmIChhY2wpIHsKPiArCQkJaW50IGVycm9yID0gcmljaGFjbF9w
ZXJtaXNzaW9uKGlub2RlLCBhY2wsIG1hc2spOwo+ICsJCQlyaWNoYWNsX3B1dChhY2wpOwo+ICsJ
CQlyZXR1cm4gZXJyb3I7Cj4gKwkJfQo+ICsJfQo+ICtub19hY2w6Cj4gKyNlbmRpZgoKbml0OiBD
YW4geW91IG1vdmUgdGhlIGFib3ZlIHRvIGEgc3RhdGljIGlubGluZSBvciBzb21ldGhpbmcgdGhh
dCBiZWNvbWVzIGEgbm9vcCB3aGVuIHRoZSBjb25maWcgdmFyIGlzIHR1cm5lZCBvZmY/Cgo+ICsJ
aWYgKG1hc2sgJiAoTUFZX0RFTEVURV9TRUxGIHwgTUFZX1RBS0VfT1dORVJTSElQIHwKPiArCQnC
oMKgwqDCoE1BWV9DSE1PRCB8IE1BWV9TRVRfVElNRVMpKSB7Cj4gKwkJLyogRmlsZSBwZXJtaXNz
aW9uIGJpdHMgY2Fubm90IGdyYW50IHRoaXMuICovCj4gKwkJcmV0dXJuIC1FQUNDRVM7Cj4gKwl9
Cj4gKwlyZXR1cm4gLUVBR0FJTjsKPiArfQo+ICsKPiArc3RhdGljIGludCBjaGVja19wb3NpeF9h
Y2woc3RydWN0IGlub2RlICppbm9kZSwgaW50IG1hc2spCj4gwqB7Cj4gwqAjaWZkZWYgQ09ORklH
X0ZTX1BPU0lYX0FDTAo+IMKgCWlmIChtYXNrICYgTUFZX05PVF9CTE9DSykgewo+IEBAIC0yOTQs
MTEgKzMzMSwyNCBAQCBzdGF0aWMgaW50IGFjbF9wZXJtaXNzaW9uX2NoZWNrKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIGludCBtYXNrKQo+IMKgewo+IMKgCXVuc2lnbmVkIGludCBtb2RlID0gaW5vZGUt
PmlfbW9kZTsKPiDCoAo+ICsJLyoKPiArCcKgKiBXaXRoIFBPU0lYIEFDTHMsIHRoZSAobW9kZSAm
IFNfSVJXWFUpIGJpdHMgZXhhY3RseSBtYXRjaCB0aGUgb3duZXIKPiArCcKgKiBwZXJtaXNzaW9u
cywgYW5kIHdlIGNhbiBza2lwIGNoZWNraW5nIHBvc2l4IGFjbHMgZm9yIHRoZSBvd25lci4KPiAr
CcKgKiBXaXRoIHJpY2hhY2xzLCB0aGUgb3duZXIgbWF5IGJlIGdyYW50ZWQgZmV3ZXIgcGVybWlz
c2lvbnMgdGhhbiB0aGUKPiArCcKgKiBtb2RlIGJpdHMgc2VlbSB0byBzdWdnZXN0IChmb3IgZXhh
bXBsZSwgYXBwZW5kIGJ1dCBub3Qgd3JpdGUpLCBhbmQKPiArCcKgKiB3ZSBhbHdheXMgbmVlZCB0
byBjaGVjayB0aGUgcmljaGFjbC4KPiArCcKgKi8KPiArCj4gKwlpZiAoSVNfUklDSEFDTChpbm9k
ZSkpIHsKPiArCQlpbnQgZXJyb3IgPSBjaGVja19yaWNoYWNsKGlub2RlLCBtYXNrKTsKPiArCQlp
ZiAoZXJyb3IgIT0gLUVBR0FJTikKPiArCQkJcmV0dXJuIGVycm9yOwo+ICsJfQo+IMKgCWlmIChs
aWtlbHkodWlkX2VxKGN1cnJlbnRfZnN1aWQoKSwgaW5vZGUtPmlfdWlkKSkpCj4gwqAJCW1vZGUg
Pj49IDY7Cj4gwqAJZWxzZSB7Cj4gwqAJCWlmIChJU19QT1NJWEFDTChpbm9kZSkgJiYgKG1vZGUg
JiBTX0lSV1hHKSkgewo+IC0JCQlpbnQgZXJyb3IgPSBjaGVja19hY2woaW5vZGUsIG1hc2spOwo+
ICsJCQlpbnQgZXJyb3IgPSBjaGVja19wb3NpeF9hY2woaW5vZGUsIG1hc2spOwo+IMKgCQkJaWYg
KGVycm9yICE9IC1FQUdBSU4pCj4gwqAJCQkJcmV0dXJuIGVycm9yOwo+IMKgCQl9CgpMb29rcyBm
aW5lIG90aGVyIHRoYW4gdGhlIG5pdCBhYm92ZToKClJldmlld2VkLWJ5OiBKZWZmIExheXRvbiA8
amxheXRvbkByZWRoYXQuY29tPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
