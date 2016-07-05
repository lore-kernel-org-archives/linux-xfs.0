Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 646FB7CDF
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 10:39:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C496AAC001
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 08:38:57 -0700 (PDT)
Received: from mail-qt0-f172.google.com (mail-qt0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	7BuNUPIhIBgDpotF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 08:38:52 -0700 (PDT)
Received: by mail-qt0-f172.google.com with SMTP id m2so102823398qtd.1
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2016 08:38:52 -0700 (PDT)
Message-ID: <1467733130.3800.36.camel@redhat.com>
Subject: Re: [PATCH v23 10/22] posix_acl: Improve xattr fixup code
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 05 Jul 2016 11:38:50 -0400
In-Reply-To: <1467294433-3222-11-git-send-email-agruenba@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-11-git-send-email-agruenba@redhat.com>
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
b3RlOgo+IEJvdGggWEFUVFJfTkFNRV9QT1NJWF9BQ0xfQUNDRVNTIGFuZCBYQVRUUl9OQU1FX1BP
U0lYX0FDTF9ERUZBVUxUIGhhdmUKPiB0aGUgc2FtZSBYQVRUUl9TWVNURU1fUFJFRklYIHByZWZp
eDsgZG9uJ3QgY2hlY2sgZm9yIHRoZSBzYW1lIHByZWZpeAo+IHJlcGVhdGVkbHkuCj4gCj4gU2ln
bmVkLW9mZi1ieTogQW5kcmVhcyBHcnVlbmJhY2hlciA8YWdydWVuYmFAcmVkaGF0LmNvbT4KPiBS
ZXZpZXdlZC1ieTogU3RldmUgRnJlbmNoIDxzdGV2ZS5mcmVuY2hAcHJpbWFyeWRhdGEuY29tPgo+
IC0tLQo+IMKgZnMveGF0dHIuYyB8IDI5ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tCj4g
wqAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKPiAKPiBk
aWZmIC0tZ2l0IGEvZnMveGF0dHIuYyBiL2ZzL3hhdHRyLmMKPiBpbmRleCA0YmVhZmM0Li42MWFj
MjE4IDEwMDY0NAo+IC0tLSBhL2ZzL3hhdHRyLmMKPiArKysgYi9mcy94YXR0ci5jCj4gQEAgLTI5
NSw2ICsyOTUsMTYgQEAgb3V0Ogo+IMKgfQo+IMKgRVhQT1JUX1NZTUJPTF9HUEwodmZzX3JlbW92
ZXhhdHRyKTsKPiDCoAo+ICtzdGF0aWMgdm9pZAo+ICtmaXhfeGF0dHJfZnJvbV91c2VyKGNvbnN0
IGNoYXIgKmtuYW1lLCB2b2lkICprdmFsdWUsIHNpemVfdCBzaXplKQo+ICt7Cj4gKwlpZiAoc3Ry
bmNtcChrbmFtZSwgWEFUVFJfU1lTVEVNX1BSRUZJWCwgWEFUVFJfU1lTVEVNX1BSRUZJWF9MRU4p
KQo+ICsJCXJldHVybjsKPiArCWtuYW1lICs9IFhBVFRSX1NZU1RFTV9QUkVGSVhfTEVOOwo+ICsJ
aWYgKCFzdHJjbXAoa25hbWUsIFhBVFRSX1BPU0lYX0FDTF9BQ0NFU1MpIHx8Cj4gKwnCoMKgwqDC
oCFzdHJjbXAoa25hbWUsIFhBVFRSX1BPU0lYX0FDTF9ERUZBVUxUKSkKPiArCQlwb3NpeF9hY2xf
Zml4X3hhdHRyX2Zyb21fdXNlcihrdmFsdWUsIHNpemUpOwo+ICt9Cj4gwqAKPiDCoC8qCj4gwqAg
KiBFeHRlbmRlZCBhdHRyaWJ1dGUgU0VUIG9wZXJhdGlvbnMKPiBAQCAtMzI5LDkgKzMzOSw3IEBA
IHNldHhhdHRyKHN0cnVjdCBkZW50cnkgKmQsIGNvbnN0IGNoYXIgX191c2VyICpuYW1lLCBjb25z
dCB2b2lkIF9fdXNlciAqdmFsdWUsCj4gwqAJCQllcnJvciA9IC1FRkFVTFQ7Cj4gwqAJCQlnb3Rv
IG91dDsKPiDCoAkJfQo+IC0JCWlmICgoc3RyY21wKGtuYW1lLCBYQVRUUl9OQU1FX1BPU0lYX0FD
TF9BQ0NFU1MpID09IDApIHx8Cj4gLQkJwqDCoMKgwqAoc3RyY21wKGtuYW1lLCBYQVRUUl9OQU1F
X1BPU0lYX0FDTF9ERUZBVUxUKSA9PSAwKSkKPiAtCQkJcG9zaXhfYWNsX2ZpeF94YXR0cl9mcm9t
X3VzZXIoa3ZhbHVlLCBzaXplKTsKPiArCQlmaXhfeGF0dHJfZnJvbV91c2VyKGtuYW1lLCBrdmFs
dWUsIHNpemUpOwo+IMKgCX0KPiDCoAo+IMKgCWVycm9yID0gdmZzX3NldHhhdHRyKGQsIGtuYW1l
LCBrdmFsdWUsIHNpemUsIGZsYWdzKTsKPiBAQCAtMzk2LDYgKzQwNCwxNyBAQCBTWVNDQUxMX0RF
RklORTUoZnNldHhhdHRyLCBpbnQsIGZkLCBjb25zdCBjaGFyIF9fdXNlciAqLCBuYW1lLAo+IMKg
CXJldHVybiBlcnJvcjsKPiDCoH0KPiDCoAo+ICtzdGF0aWMgdm9pZAo+ICtmaXhfeGF0dHJfdG9f
dXNlcihjb25zdCBjaGFyICprbmFtZSwgdm9pZCAqa3ZhbHVlLCBzaXplX3Qgc2l6ZSkKPiArewo+
ICsJaWYgKHN0cm5jbXAoa25hbWUsIFhBVFRSX1NZU1RFTV9QUkVGSVgsIFhBVFRSX1NZU1RFTV9Q
UkVGSVhfTEVOKSkKPiArCQlyZXR1cm47Cj4gKwlrbmFtZSArPSBYQVRUUl9TWVNURU1fUFJFRklY
X0xFTjsKPiArCWlmICghc3RyY21wKGtuYW1lLCBYQVRUUl9QT1NJWF9BQ0xfQUNDRVNTKSB8fAo+
ICsJwqDCoMKgwqAhc3RyY21wKGtuYW1lLCBYQVRUUl9QT1NJWF9BQ0xfREVGQVVMVCkpCj4gKwkJ
cG9zaXhfYWNsX2ZpeF94YXR0cl90b191c2VyKGt2YWx1ZSwgc2l6ZSk7Cj4gK30KPiArCj4gwqAv
Kgo+IMKgICogRXh0ZW5kZWQgYXR0cmlidXRlIEdFVCBvcGVyYXRpb25zCj4gwqAgKi8KPiBAQCAt
NDI2LDkgKzQ0NSw3IEBAIGdldHhhdHRyKHN0cnVjdCBkZW50cnkgKmQsIGNvbnN0IGNoYXIgX191
c2VyICpuYW1lLCB2b2lkIF9fdXNlciAqdmFsdWUsCj4gwqAKPiDCoAllcnJvciA9IHZmc19nZXR4
YXR0cihkLCBrbmFtZSwga3ZhbHVlLCBzaXplKTsKPiDCoAlpZiAoZXJyb3IgPiAwKSB7Cj4gLQkJ
aWYgKChzdHJjbXAoa25hbWUsIFhBVFRSX05BTUVfUE9TSVhfQUNMX0FDQ0VTUykgPT0gMCkgfHwK
PiAtCQnCoMKgwqDCoChzdHJjbXAoa25hbWUsIFhBVFRSX05BTUVfUE9TSVhfQUNMX0RFRkFVTFQp
ID09IDApKQo+IC0JCQlwb3NpeF9hY2xfZml4X3hhdHRyX3RvX3VzZXIoa3ZhbHVlLCBzaXplKTsK
PiArCQlmaXhfeGF0dHJfdG9fdXNlcihrbmFtZSwga3ZhbHVlLCBzaXplKTsKPiDCoAkJaWYgKHNp
emUgJiYgY29weV90b191c2VyKHZhbHVlLCBrdmFsdWUsIGVycm9yKSkKPiDCoAkJCWVycm9yID0g
LUVGQVVMVDsKPiDCoAl9IGVsc2UgaWYgKGVycm9yID09IC1FUkFOR0UgJiYgc2l6ZSA+PSBYQVRU
Ul9TSVpFX01BWCkgewoKTWlnaHQgYmUgbmljZSB0byBtb3ZlIHRoaXMgb25lIHRvIHRoZSBoZWFk
IG9mIHRoZSBxdWV1ZS4gSSBkb24ndCBzZWUgaXQKYXMgYmVpbmcgYSBjb250cm92ZXJzaWFsIGNo
YW5nZSwgYW5kIGl0IGNvdWxkIGdvIGluIGJlZm9yZSB0aGUgcmVzdCBvZgp0aGUgcGF0Y2hlcy4K
ClJldmlld2VkLWJ5OiBKZWZmIExheXRvbiA8amxheXRvbkByZWRoYXQuY29tPgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
