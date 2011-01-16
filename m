Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0GDCDcE129778 for <xfs@oss.sgi.com>; Sun, 16 Jan 2011 07:12:13 -0600
Received: from gerard.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 174FA26B5BC
	for <xfs@oss.sgi.com>; Sun, 16 Jan 2011 05:14:28 -0800 (PST)
Received: from gerard.telenet-ops.be (gerard.telenet-ops.be [195.130.132.48])
	by cuda.sgi.com with ESMTP id XU1dODrH8YuToCB1 for
	<xfs@oss.sgi.com>; Sun, 16 Jan 2011 05:14:28 -0800 (PST)
Date: Sun, 16 Jan 2011 14:14:25 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] xfs: Do not name variables "panic"
Message-ID: <alpine.DEB.2.00.1101161409150.24311@ayla.of.borg>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: base64
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-arch@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

T24gcGxhdGZvcm1zIHRoYXQgY2FsbCBwYW5pYygpIGluc2lkZSB0aGVpciBCVUcoKSBtYWNybyAo
bTY4ay9zdW4zLCBhbmQKYWxsIHBsYXRmb3JtcyB0aGF0IGRvbid0IHNldCBIQVZFX0FSQ0hfQlVH
KSwgY29tcGlsYXRpb24gZmFpbHMgd2l0aDoKCnwgZnMveGZzL3N1cHBvcnQvZGVidWcuYzogSW4g
ZnVuY3Rpb24goXhmc19jbW5fZXJyojoKfCBmcy94ZnMvc3VwcG9ydC9kZWJ1Zy5jOjkyOiBlcnJv
cjogY2FsbGVkIG9iamVjdCChcGFuaWOiIGlzIG5vdCBhIGZ1bmN0aW9uCgphcyB0aGUgbG9jYWwg
dmFyaWFibGUgInBhbmljIiBjb25mbGljdHMgd2l0aCB0aGUgInBhbmljKCkiIGZ1bmN0aW9uLgpS
ZW5hbWUgdGhlIGxvY2FsIHZhcmlhYmxlIHRvIHJlc29sdmUgdGhpcy4KClNpZ25lZC1vZmYtYnk6
IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+Ci0tLQptNjhrL3N1bjM6
IGh0dHA6Ly9raXNza2IuZWxsZXJtYW4uaWQuYXUva2lzc2tiL2J1aWxkcmVzdWx0LzM3NzkwMDYv
Ck5vbmUgb2YgdGhlICFIQVZFX0FSQ0hfQlVHIGFyY2hzIChoODMwMCwgbTMyciwgbTY4a25vbW11
LCBtaWNyb2JsYXplLCBzY29yZSwKdGlsZSwgeHRlbnNhKSBzZWVtcyB0byBiZSBjb3ZlcmVkIGJ5
IGxpbnV4LW5leHQKCiBmcy94ZnMvc3VwcG9ydC9kZWJ1Zy5jIHwgICAgNiArKystLS0KIDEgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL3hmcy9zdXBwb3J0L2RlYnVnLmMgYi9mcy94ZnMvc3VwcG9ydC9kZWJ1Zy5jCmluZGV4IGU2
Y2Y5NTUuLjBkZjg4ODkgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy9zdXBwb3J0L2RlYnVnLmMKKysrIGIv
ZnMveGZzL3N1cHBvcnQvZGVidWcuYwpAQCAtNzUsMTEgKzc1LDExIEBAIHhmc19jbW5fZXJyKAog
ewogCXN0cnVjdCB2YV9mb3JtYXQJdmFmOwogCXZhX2xpc3QJCQlhcmdzOwotCWludAkJCXBhbmlj
ID0gMDsKKwlpbnQJCQlkb19wYW5pYyA9IDA7CiAKIAlpZiAoeGZzX3BhbmljX21hc2sgJiYgKHhm
c19wYW5pY19tYXNrICYgcGFuaWNfdGFnKSkgewogCQlwcmludGsoS0VSTl9BTEVSVCAiWEZTOiBU
cmFuc2Zvcm1pbmcgYW4gYWxlcnQgaW50byBhIEJVRy4iKTsKLQkJcGFuaWMgPSAxOworCQlkb19w
YW5pYyA9IDE7CiAJfQogCiAJdmFfc3RhcnQoYXJncywgZm10KTsKQEAgLTg5LDcgKzg5LDcgQEAg
eGZzX2Ntbl9lcnIoCiAJcHJpbnRrKEtFUk5fQUxFUlQgIkZpbGVzeXN0ZW0gJXM6ICVwViIsIG1w
LT5tX2ZzbmFtZSwgJnZhZik7CiAJdmFfZW5kKGFyZ3MpOwogCi0JQlVHX09OKHBhbmljKTsKKwlC
VUdfT04oZG9fcGFuaWMpOwogfQogCiB2b2lkCi0tIAoxLjcuMC40CgpHcntvZXRqZSxlZXRpbmd9
cywKCgkJCQkJCUdlZXJ0CgotLQpHZWVydCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9m
IExpbnV4IGJleW9uZCBpYTMyIC0tIGdlZXJ0QGxpbnV4LW02OGsub3JnCgpJbiBwZXJzb25hbCBj
b252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tl
ci4gQnV0CndoZW4gSSdtIHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3Jh
bW1lciIgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4KCQkJCQkJCSAgICAtLSBMaW51cyBUb3J2YWxk
cwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
