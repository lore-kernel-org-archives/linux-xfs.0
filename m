Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2A8WGJ108842 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 05:08:32 -0500
Received: from cpsmtpb-ews01.kpnxchange.com (cpsmtpb-ews01.kpnxchange.com
	[213.75.39.4]) by cuda.sgi.com with ESMTP id jMQT0TLkHI2BylvJ
	for <xfs@oss.sgi.com>; Fri, 02 Nov 2012 03:10:23 -0700 (PDT)
Message-ID: <1351851021.1597.27.camel@x61.thuisdomein>
Subject: [PATCH] xfs: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
Date: Fri, 02 Nov 2012 11:10:21 +0100
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

QnVpbGRpbmcgeGZzX2lvY3RsLm8gdHJpZ2dlcnMgdGhpcyBHQ0Mgd2FybmluZzoKICAgIEluIGZp
bGUgaW5jbHVkZWQgZnJvbSBmcy94ZnMveGZzX2xpbnV4Lmg6NDk6MCwKICAgICAgICAgICAgICAg
ICAgICAgZnJvbSBmcy94ZnMveGZzLmg6MjcsCiAgICAgICAgICAgICAgICAgICAgIGZyb20gZnMv
eGZzL3hmc19pb2N0bC5jOjE4OgogICAgZnMveGZzL3hmc19pb2N0bC5jOiBJbiBmdW5jdGlvbiDi
gJh4ZnNfZmluZF9oYW5kbGXigJk6CiAgICBpbmNsdWRlL2xpbnV4L2ZpbGUuaDozNzo3OiB3YXJu
aW5nOiDigJhmLmZpbGXigJkgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0
aW9uIFstV21heWJlLXVuaW5pdGlhbGl6ZWRdCiAgICBmcy94ZnMveGZzX2lvY3RsLmM6NzM6MTM6
IG5vdGU6IOKAmGYuZmlsZeKAmSB3YXMgZGVjbGFyZWQgaGVyZQoKSW4gdGhpcyBmdW5jdGlvbiAn
ZicgYW5kICgnZi5maWxlJykgYXJlIG9ubHkgdXNlZCBmb3IgdGhlClhGU19JT0NfRkRfVE9fSEFO
RExFIGNvbW1hbmQuIEl0IGlzIGNsZWFyIHRoYXQgJ2YuZmlsZScgaXMgYWx3YXlzIHVzZWQKaW5p
dGlhbGl6ZWQsIGJ1dCB0aGVyZSBhcHBlYXJzIHRvIGJlIG5vIGVhc3kgd2F5IHRvIGdpdmUgR0ND
IGVub3VnaAppbmZvcm1hdGlvbiB0byBkZXRlcm1pbmUgdGhhdC4gU28gbGV0J3Mgc2lsZW5jZSB0
aGlzIHdhcm5pbmcsIHVzaW5nIHRoZQpwYXR0ZXJuIEluZ28gTW9sbmFyIHJlY2VudGx5IHN1Z2dl
c3RlZC4KClNpZ25lZC1vZmYtYnk6IFBhdWwgQm9sbGUgPHBlYm9sbGVAdGlzY2FsaS5ubD4KLS0t
CjApIENvbXBpbGUgdGVzdGVkIG9ubHkuCgoxKSBJIGZlYXIgdGhhdCB0aGUgb25seSB3YXkgdG8g
Z2l2ZSBHQ0MgdGhlIGluZm9ybWF0aW9uIGl0IG5lZWRzIHRvIGRvCnRoZSBmbG93IGFuYWx5c2lz
IGNvcnJlY3RseSBpcyB0byBzcGxpdCB4ZnNfZmluZF9oYW5kbGUoKSBpbnRvIHRocmVlCnNlcGFy
YXRlIGZ1bmN0aW9ucywgb25lIGZvciBlYWNoIGNvbW1hbmQgaXQgaGFuZGxlcywgYW5kIGFkZCBv
bmUgb3IgdHdvCmhlbHBlciBmdW5jdGlvbnMgZm9yIHRoZSBjb2RlIGNvbW1vbiB0byBhbGwgdGhy
ZWUgZnVuY3Rpb25zLiBUaGF0IHNlZW1lZAphIGJpdCBkcmFzdGljLiBCdXQgcGVyaGFwcyB3ZSBz
aG91bGQgdHJ5IHRoYXQuCgogZnMveGZzL3hmc19pb2N0bC5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMveGZzL3hm
c19pb2N0bC5jIGIvZnMveGZzL3hmc19pb2N0bC5jCmluZGV4IDgzMDVmMmEuLjVjOThjZTMgMTAw
NjQ0Ci0tLSBhL2ZzL3hmcy94ZnNfaW9jdGwuYworKysgYi9mcy94ZnMveGZzX2lvY3RsLmMKQEAg
LTcwLDcgKzcwLDcgQEAgeGZzX2ZpbmRfaGFuZGxlKAogCWludAkJCWhzaXplOwogCXhmc19oYW5k
bGVfdAkJaGFuZGxlOwogCXN0cnVjdCBpbm9kZQkJKmlub2RlOwotCXN0cnVjdCBmZAkJZjsKKwlz
dHJ1Y3QgZmQJCWYgPSB7IH07IC8qIEF2b2lkIEdDQyB3YXJuaW5nICovCiAJc3RydWN0IHBhdGgJ
CXBhdGg7CiAJaW50CQkJZXJyb3I7CiAJc3RydWN0IHhmc19pbm9kZQkqaXA7Ci0tIAoxLjcuMTEu
NwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1h
aWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlz
dGluZm8veGZzCg==
