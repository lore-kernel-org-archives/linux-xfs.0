Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 325D77FB9
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:02:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 20FBC8F8066
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:02:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Me2RAgsF1tDN7cWb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 04:02:33 -0700 (PDT)
From: =?UTF-8?q?Jan=20=C5=A4ul=C3=A1k?= <jtulak@redhat.com>
Subject: [PATCH 17/17] mkfs: move spinodes crc check
Date: Fri, 19 Jun 2015 13:02:06 +0200
Message-Id: <1434711726-13092-18-git-send-email-jtulak@redhat.com>
In-Reply-To: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

U3Bpbm9kZXMgY3JjIGNoZWNrIGlzIG5vdyBtb3ZlZCB0byBiZSBpbiB0aGUgc2FtZSB3YXkgYXMg
Zmlub2J0LgoKU2lnbmVkLW9mZi1ieTogSmFuIMWkdWzDoWsgPGp0dWxha0ByZWRoYXQuY29tPgot
LS0KIG1rZnMveGZzX21rZnMuYyB8IDExICsrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21rZnMveGZzX21rZnMu
YyBiL21rZnMveGZzX21rZnMuYwppbmRleCAyZTQ1NWRiLi42NTNmYzViIDEwMDY0NAotLS0gYS9t
a2ZzL3hmc19ta2ZzLmMKKysrIGIvbWtmcy94ZnNfbWtmcy5jCkBAIC0yMzQ3LDEyICsyMzQ3LDEz
IEBAIF8oIjMyIGJpdCBQcm9qZWN0IElEcyBhbHdheXMgZW5hYmxlZCBvbiBDUkMgZW5hYmxlZCBm
aWxlc3l0ZW1zXG4iKSk7CiBfKCJ3YXJuaW5nOiBmaW5vYnQgbm90IHN1cHBvcnRlZCB3aXRob3V0
IENSQyBzdXBwb3J0LCBkaXNhYmxlZC5cbiIpKTsKIAkJCXNiX2ZlYXQuZmlub2J0ID0gMDsKIAkJ
fQotCX0KIAotCWlmIChzYl9mZWF0LnNwaW5vZGVzICYmICFzYl9mZWF0LmNyY3NfZW5hYmxlZCkg
ewotCQlmcHJpbnRmKHN0ZGVyciwKLV8oIndhcm5pbmc6IHNwYXJzZSBpbm9kZXMgbm90IHN1cHBv
cnRlZCB3aXRob3V0IENSQyBzdXBwb3J0LCBkaXNhYmxlZC5cbiIpKTsKLQkJc2JfZmVhdC5zcGlu
b2RlcyA9IDA7CisJCWlmIChzYl9mZWF0LnNwaW5vZGVzKSB7CisJCQlmcHJpbnRmKHN0ZGVyciwK
KwlfKCJ3YXJuaW5nOiBzcGFyc2UgaW5vZGVzIG5vdCBzdXBwb3J0ZWQgd2l0aG91dCBDUkMgc3Vw
cG9ydCwgZGlzYWJsZWQuXG4iKSk7CisJCQlzYl9mZWF0LnNwaW5vZGVzID0gMDsKKwkJfQorCiAJ
fQogCiAJaWYgKG5zZmxhZyB8fCBubGZsYWcpIHsKLS0gCjIuMS4wCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
