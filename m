Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8299m7E195922 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 04:09:49 -0500
Received: from web45811.mail.sp1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 835BF15DBCD6
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 02:21:07 -0700 (PDT)
Received: from web45811.mail.sp1.yahoo.com (web45811.mail.sp1.yahoo.com
	[68.180.199.56]) by cuda.sgi.com with SMTP id 3KZK13zk1Pbe4drC
	for <xfs@oss.sgi.com>; Thu, 02 Sep 2010 02:21:07 -0700 (PDT)
Message-ID: <388312.90213.qm@web45811.mail.sp1.yahoo.com>
Date: Thu, 2 Sep 2010 02:10:26 -0700 (PDT)
From: Poyo VL <poyo_vl@yahoo.com>
Subject: [PATCH] 2.6.35.4: Fixed simple warning (array subscript is above
	array bounds)
MIME-Version: 1.0
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

RnJvbTogSW9udXQgR2FicmllbCBQb3Blc2N1IDxwb3lvX3ZsQHlhaG9vLmNvbT4KCldoZW4gSSB0
cmllZCB0byBjb21waWxlLCBJIGdvdCB0aGUgZm9sbG93aW5nIHdhcm5pbmc6CmZzL3hmcy94ZnNf
ZGlyMl9ibG9jay5jOiBJbiBmdW5jdGlvbiDigJh4ZnNfZGlyMl9zZl90b19ibG9ja+KAmToKZnMv
eGZzL3hmc19kaXIyX2Jsb2NrLmM6MTE1MzoyNjogd2FybmluZzogYXJyYXkgc3Vic2NyaXB0IGlz
IGFib3ZlIGFycmF5IGJvdW5kcwpUaGUgY29kZSAoZnMveGZzL3hmc19kaXIyX2Jsb2NrLmMgbGlu
ZSAxMTUzKSBpczoKZGVwLT5uYW1lWzBdID0gZGVwLT5uYW1lWzFdID0gJy4nOwpkZXAgaXMgYSBw
b2ludGVyIHRvIGEgeGZzX2RpcjJfZGF0YV9lbnRyeV90IHN0cnVjdHVyZSB3aGVyZSBuYW1lIGlz
IGRlZmluZWQgYXM6Cl9fdTggICAgICAgICAgICBuYW1lWzFdOyAgICAvKiBuYW1lIGJ5dGVzLCBu
byBudWxsICovClNvIGl0IGlzIGEgc2luZ2xlIGVsZW1lbnQgYXJyYXksIG5hbWVbMF0gbm90IGFs
c28gbmFtZVsxXSBzbyBJIGdvdCB0aGF0IHdhcm5pbmcuClBhdGNoaW5nIGlzIGEgc2ltcGxlIHJl
cGxhY2VtZW50IG9mIDEgd2l0aCAyLgoKU2lnbmVkLW9mZi1ieTogSW9udXQgR2FicmllbCBQb3Bl
c2N1IDxwb3lvX3ZsQHlhaG9vLmNvbT4KLS0tCgotLS0gYS9mcy94ZnMveGZzX2RpcjJfZGF0YS5o
ICAgIDIwMTAtMDktMDIgMTE6MTM6MTEuNjMyMDA3NTM2ICswMzAwCisrKyBiL2ZzL3hmcy94ZnNf
ZGlyMl9kYXRhLmggICAgMjAxMC0wOS0wMiAxMToxMzoyOC4wODAwMDY0ODggKzAzMDAKQEAgLTg3
LDcgKzg3LDcgQEAKIHR5cGVkZWYgc3RydWN0IHhmc19kaXIyX2RhdGFfZW50cnkgewogICAgIF9f
YmU2NCAgICAgICAgICAgIGludW1iZXI7ICAgIC8qIGlub2RlIG51bWJlciAqLwogICAgIF9fdTgg
ICAgICAgICAgICBuYW1lbGVuOyAgICAvKiBuYW1lIGxlbmd0aCAqLwotICAgIF9fdTggICAgICAg
ICAgICBuYW1lWzFdOyAgICAvKiBuYW1lIGJ5dGVzLCBubyBudWxsICovCisgICAgX191OCAgICAg
ICAgICAgIG5hbWVbMl07ICAgIC8qIG5hbWUgYnl0ZXMsIG5vIG51bGwgKi8KICAgICAgICAgICAg
ICAgICAgICAgICAgIC8qIHZhcmlhYmxlIG9mZnNldCAqLwogICAgIF9fYmUxNiAgICAgICAgICAg
IHRhZzsgICAgICAgIC8qIHN0YXJ0aW5nIG9mZnNldCBvZiB1cyAqLwogfSB4ZnNfZGlyMl9kYXRh
X2VudHJ5X3Q7CgoKICAgICAgCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
