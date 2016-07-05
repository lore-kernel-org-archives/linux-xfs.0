Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EE867CC9
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 06:12:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A66CAC002
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 04:12:19 -0700 (PDT)
Received: from mail-qt0-f180.google.com (mail-qt0-f180.google.com
	[209.85.216.180]) by cuda.sgi.com with ESMTP id
	CTKHRamLM6AZM5yG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 04:12:17 -0700 (PDT)
Received: by mail-qt0-f180.google.com with SMTP id f89so98749536qtd.2
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2016 04:12:17 -0700 (PDT)
Message-ID: <1467717134.3800.7.camel@redhat.com>
Subject: Re: [PATCH v23 04/22] vfs: Make the inode passed to inode_change_ok
	non-const
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 05 Jul 2016 07:12:14 -0400
In-Reply-To: <1467294433-3222-5-git-send-email-agruenba@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-5-git-send-email-agruenba@redhat.com>
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

T24gVGh1LCAyMDE2LTA2LTMwIGF0IDE1OjQ2ICswMjAwLCBBbmRyZWFzIEdydWVuYmFjaGVyIHdy
b3RlOgo+IFdlIHdpbGwgbmVlZCB0byBjYWxsIGlvcC0+cGVybWlzc2lvbiBhbmQgaW9wLT5nZXRf
YWNsIGZyb20KPiBpbm9kZV9jaGFuZ2Vfb2soKSBmb3IgYWRkaXRpb25hbCBwZXJtaXNzaW9uIGNo
ZWNrcywgYW5kIGJvdGggdGFrZSBhCj4gbm9uLWNvbnN0IGlub2RlLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbmJhQHJlZGhhdC5jb20+Cj4gUmV2aWV3ZWQt
Ynk6IEouIEJydWNlIEZpZWxkcyA8YmZpZWxkc0ByZWRoYXQuY29tPgo+IFJldmlld2VkLWJ5OiBB
bmRyZWFzIERpbGdlciA8YWRpbGdlckBkaWxnZXIuY2E+Cj4gUmV2aWV3ZWQtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RldmUuZnJlbmNoQHByaW1hcnlkYXRhLmNvbT4KPiAtLS0KPiDCoGZzL2F0dHIuY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgfCAyICstCj4gwqBpbmNsdWRlL2xpbnV4L2ZzLmggfCAyICstCj4g
wqAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBk
aWZmIC0tZ2l0IGEvZnMvYXR0ci5jIGIvZnMvYXR0ci5jCj4gaW5kZXggMjViMjRkMC4uN2NhN2Zh
MCAxMDA2NDQKPiAtLS0gYS9mcy9hdHRyLmMKPiArKysgYi9mcy9hdHRyLmMKPiBAQCAtMjgsNyAr
MjgsNyBAQAo+IMKgICogU2hvdWxkIGJlIGNhbGxlZCBhcyB0aGUgZmlyc3QgdGhpbmcgaW4gLT5z
ZXRhdHRyIGltcGxlbWVudGF0aW9ucywKPiDCoCAqIHBvc3NpYmx5IGFmdGVyIHRha2luZyBhZGRp
dGlvbmFsIGxvY2tzLgo+IMKgICovCj4gLWludCBpbm9kZV9jaGFuZ2Vfb2soY29uc3Qgc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGlhdHRyICphdHRyKQo+ICtpbnQgaW5vZGVfY2hhbmdlX29r
KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBpYXR0ciAqYXR0cikKPiDCoHsKPiDCoAl1bnNp
Z25lZCBpbnQgaWFfdmFsaWQgPSBhdHRyLT5pYV92YWxpZDsKPiDCoAo+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2ZzLmggYi9pbmNsdWRlL2xpbnV4L2ZzLmgKPiBpbmRleCA4NmJmYTEwLi4y
MDhmNzNiIDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUvbGludXgvZnMuaAo+ICsrKyBiL2luY2x1ZGUv
bGludXgvZnMuaAo+IEBAIC0yOTkzLDcgKzI5OTMsNyBAQCBleHRlcm4gaW50IGJ1ZmZlcl9taWdy
YXRlX3BhZ2Uoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKiwKPiDCoCNkZWZpbmUgYnVmZmVyX21pZ3Jh
dGVfcGFnZSBOVUxMCj4gwqAjZW5kaWYKPiDCoAo+IC1leHRlcm4gaW50IGlub2RlX2NoYW5nZV9v
ayhjb25zdCBzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGlhdHRyICopOwo+ICtleHRlcm4gaW50IGlu
b2RlX2NoYW5nZV9vayhzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGlhdHRyICopOwo+IMKgZXh0ZXJu
IGludCBpbm9kZV9uZXdzaXplX29rKGNvbnN0IHN0cnVjdCBpbm9kZSAqLCBsb2ZmX3Qgb2Zmc2V0
KTsKPiDCoGV4dGVybiB2b2lkIHNldGF0dHJfY29weShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBjb25z
dCBzdHJ1Y3QgaWF0dHIgKmF0dHIpOwo+IMKgCgpZdWNrLiBCdW1tZXIgdG8gbG9zZSB0aGUgImNv
bnN0IiB0aGVyZSwgYnV0IGl0IGRvZXNuJ3QgbG9vayBsaWtlIGl0J3MKcG9zc2libGUgdG8gbWFr
ZSB0aG9zZSBvcHMgdGFrZSBhIGNvbnN0IGFyZy4KClJldmlld2VkLWJ5OiBKZWZmIExheXRvbiA8
amxheXRvbkByZWRoYXQuY29tPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
