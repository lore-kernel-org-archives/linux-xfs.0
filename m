Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 987DE7D0D
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 13:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 210B6AC00D
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 11:31:18 -0700 (PDT)
Received: from mail-qk0-f173.google.com (mail-qk0-f173.google.com
	[209.85.220.173]) by cuda.sgi.com with ESMTP id
	BMacTwAEik81l6Dy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jul 2016 11:31:17 -0700 (PDT)
Received: by mail-qk0-f173.google.com with SMTP id t127so322465457qkf.1
	for <xfs@oss.sgi.com>; Wed, 06 Jul 2016 11:31:17 -0700 (PDT)
Message-ID: <1467829873.2908.1.camel@redhat.com>
Subject: Re: [PATCH v23 12/22] vfs: Add get_richacl and set_richacl inode
	operations
From: Jeff Layton <jlayton@redhat.com>
Date: Wed, 06 Jul 2016 14:31:13 -0400
In-Reply-To: <1467294433-3222-13-git-send-email-agruenba@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-13-git-send-email-agruenba@redhat.com>
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
b3RlOgo+IFRoZXNlIG9wZXJhdGlvbnMgYXJlIHNpbWlsYXIgdG8gdGhlIGdldF9hY2wgYW5kIHNl
dF9hY2wgb3BlcmF0aW9ucyBmb3IKPiBQT1NJWCBBQ0xzLsKgwqBUaGUgZGlzdGluY3Rpb24gYmV0
d2VlbiBhY2Nlc3MgYW5kIGRlZmF1bHQgQUNMcyBkb2Vzbid0IGV4aXN0Cj4gZm9yIHJpY2hhY2xz
Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbmJhQHJlZGhh
dC5jb20+Cj4gUmV2aWV3ZWQtYnk6IFN0ZXZlIEZyZW5jaCA8c3RldmUuZnJlbmNoQHByaW1hcnlk
YXRhLmNvbT4KPiAtLS0KPiDCoGluY2x1ZGUvbGludXgvZnMuaCB8IDIgKysKPiDCoDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9m
cy5oIGIvaW5jbHVkZS9saW51eC9mcy5oCj4gaW5kZXggMDZhMzBiMC4uYWM5NmJkYSAxMDA2NDQK
PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2ZzLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2ZzLmgKPiBA
QCAtMTcyNiw2ICsxNzI2LDcgQEAgc3RydWN0IGlub2RlX29wZXJhdGlvbnMgewo+IMKgCWNvbnN0
IGNoYXIgKiAoKmdldF9saW5rKSAoc3RydWN0IGRlbnRyeSAqLCBzdHJ1Y3QgaW5vZGUgKiwgc3Ry
dWN0IGRlbGF5ZWRfY2FsbCAqKTsKPiDCoAlpbnQgKCpwZXJtaXNzaW9uKSAoc3RydWN0IGlub2Rl
ICosIGludCk7Cj4gwqAJc3RydWN0IHBvc2l4X2FjbCAqICgqZ2V0X2FjbCkoc3RydWN0IGlub2Rl
ICosIGludCk7Cj4gKwlzdHJ1Y3QgcmljaGFjbCAqICgqZ2V0X3JpY2hhY2wpKHN0cnVjdCBpbm9k
ZSAqKTsKPiDCoAo+IMKgCWludCAoKnJlYWRsaW5rKSAoc3RydWN0IGRlbnRyeSAqLCBjaGFyIF9f
dXNlciAqLGludCk7Cj4gwqAKPiBAQCAtMTc1Niw2ICsxNzU3LDcgQEAgc3RydWN0IGlub2RlX29w
ZXJhdGlvbnMgewo+IMKgCQkJwqDCoMKgdW1vZGVfdCBjcmVhdGVfbW9kZSwgaW50ICpvcGVuZWQp
Owo+IMKgCWludCAoKnRtcGZpbGUpIChzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IGRlbnRyeSAqLCB1
bW9kZV90KTsKPiDCoAlpbnQgKCpzZXRfYWNsKShzdHJ1Y3QgaW5vZGUgKiwgc3RydWN0IHBvc2l4
X2FjbCAqLCBpbnQpOwo+ICsJaW50ICgqc2V0X3JpY2hhY2wpKHN0cnVjdCBpbm9kZSAqLCBzdHJ1
Y3QgcmljaGFjbCAqKTsKPiDCoH0gX19fX2NhY2hlbGluZV9hbGlnbmVkOwo+IMKgCj4gwqBzc2l6
ZV90IHJ3X2NvcHlfY2hlY2tfdXZlY3RvcihpbnQgdHlwZSwgY29uc3Qgc3RydWN0IGlvdmVjIF9f
dXNlciAqIHV2ZWN0b3IsCgpMb29rcyBPSywgdGhvdWdoIGl0J3MgaGFyZCB0byByZXZpZXcgc29t
ZXRoaW5nIGxpa2UgdGhpcyB3aXRob3V0IHNvbWUKY29udGV4dC4gTWF5YmUgdGhpcyBwYXRjaCBz
aG91bGQgYmUgZm9sZGVkIGluIHdpdGggdGhlIHBhdGNoIHRoYXQKYWN0dWFsbHkgYWRkcyB0aGUg
Y2FsbHMgZm9yIHRoZXNlIG9wZXJhdGlvbnM/CgpSZXZpZXdlZC1ieTogSmVmZiBMYXl0b24gPGps
YXl0b25AcmVkaGF0LmNvbT4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
