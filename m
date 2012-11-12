Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACNYHSp260557 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 17:34:17 -0600
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id SBqTKzn1Mj46aAZM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Nov 2012 15:36:19 -0800 (PST)
Received: by mail-la0-f53.google.com with SMTP id w12so2662044lag.26
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 15:36:17 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Nov 2012 21:36:17 -0200
Message-ID: <CACnwZYdPntxqWh_Hb2=fa4NPFhtZQSj-sRK3hMHcK6FdctQEXw@mail.gmail.com>
Subject: xfs: Use bool type rather than a custom boolean_t type.
From: Thiago Farina <tfransosi@gmail.com>
Content-Type: multipart/mixed; boundary=f46d0401692396fa1a04ce54c475
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux list <linux-kernel@vger.kernel.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

--f46d0401692396fa1a04ce54c475
Content-Type: text/plain; charset=UTF-8

Hi,

Please, take a look.

Patch attached.

Thanks,

--f46d0401692396fa1a04ce54c475
Content-Type: application/octet-stream;
	name="0001-xfs-Use-bool-type-rather-than-a-custom-boolean_t-typ.patch"
Content-Disposition: attachment;
	filename="0001-xfs-Use-bool-type-rather-than-a-custom-boolean_t-typ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h9g8cz5q0

RnJvbSA2NWU4ZTk1Y2FlYzhlMTg3ZDg3M2M2YzE0NTFhYjAwZmYxMzFkYmU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUaGlhZ28gRmFyaW5hIDx0ZmFyaW5hQGNocm9taXVtLm9yZz4K
RGF0ZTogTW9uLCAxMiBOb3YgMjAxMiAyMTozMjo1OSAtMDIwMApTdWJqZWN0OiBbUEFUQ0hdIHhm
czogVXNlIGJvb2wgdHlwZSByYXRoZXIgdGhhbiBhIGN1c3RvbSBib29sZWFuX3QgdHlwZS4KClNp
Z25lZC1vZmYtYnk6IFRoaWFnbyBGYXJpbmEgPHRmYXJpbmFAY2hyb21pdW0ub3JnPgotLS0KIGZz
L3hmcy94ZnNfbG9nLmMgfCA4ICsrKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfbG9nLmMgYi9mcy94
ZnMveGZzX2xvZy5jCmluZGV4IDRkYWQ3NTYuLjRlN2ViNzYgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy94
ZnNfbG9nLmMKKysrIGIvZnMveGZzL3hmc19sb2cuYwpAQCAtMTE4LDcgKzExOCw3IEBAIHhsb2df
dmVyaWZ5X2ljbG9nKAogCXN0cnVjdCB4bG9nCQkqbG9nLAogCXN0cnVjdCB4bG9nX2luX2NvcmUJ
KmljbG9nLAogCWludAkJCWNvdW50LAotCWJvb2xlYW5fdAkJc3luY2luZyk7CisJYm9vbCAgICAg
ICAgICAgICAgICAgICAgc3luY2luZyk7CiBTVEFUSUMgdm9pZAogeGxvZ192ZXJpZnlfdGFpbF9s
c24oCiAJc3RydWN0IHhsb2cJCSpsb2csCkBAIC0zNDUxLDcgKzM0NTEsNyBAQCB4bG9nX3Zlcmlm
eV9pY2xvZygKIAlzdHJ1Y3QgeGxvZwkJKmxvZywKIAlzdHJ1Y3QgeGxvZ19pbl9jb3JlCSppY2xv
ZywKIAlpbnQJCQljb3VudCwKLQlib29sZWFuX3QJCXN5bmNpbmcpCisJYm9vbCAgICAgICAgICAg
ICAgICAgICAgc3luY2luZykKIHsKIAl4bG9nX29wX2hlYWRlcl90CSpvcGhlYWQ7CiAJeGxvZ19p
bl9jb3JlX3QJCSppY3B0cjsKQEAgLTM0OTksNyArMzQ5OSw3IEBAIHhsb2dfdmVyaWZ5X2ljbG9n
KAogCQkvKiBjbGllbnRpZCBpcyBvbmx5IDEgYnl0ZSAqLwogCQlmaWVsZF9vZmZzZXQgPSAoX19w
c2ludF90KQogCQkJICAgICAgICgoeGZzX2NhZGRyX3QpJihvcGhlYWQtPm9oX2NsaWVudGlkKSAt
IGJhc2VfcHRyKTsKLQkJaWYgKHN5bmNpbmcgPT0gQl9GQUxTRSB8fCAoZmllbGRfb2Zmc2V0ICYg
MHgxZmYpKSB7CisJCWlmICghc3luY2luZyB8fCAoZmllbGRfb2Zmc2V0ICYgMHgxZmYpKSB7CiAJ
CQljbGllbnRpZCA9IG9waGVhZC0+b2hfY2xpZW50aWQ7CiAJCX0gZWxzZSB7CiAJCQlpZHggPSBC
VE9CQlQoKHhmc19jYWRkcl90KSYob3BoZWFkLT5vaF9jbGllbnRpZCkgLSBpY2xvZy0+aWNfZGF0
YXApOwpAQCAtMzUyMiw3ICszNTIyLDcgQEAgeGxvZ192ZXJpZnlfaWNsb2coCiAJCS8qIGNoZWNr
IGxlbmd0aCAqLwogCQlmaWVsZF9vZmZzZXQgPSAoX19wc2ludF90KQogCQkJICAgICAgICgoeGZz
X2NhZGRyX3QpJihvcGhlYWQtPm9oX2xlbikgLSBiYXNlX3B0cik7Ci0JCWlmIChzeW5jaW5nID09
IEJfRkFMU0UgfHwgKGZpZWxkX29mZnNldCAmIDB4MWZmKSkgeworCQlpZiAoIXN5bmNpbmcgfHwg
KGZpZWxkX29mZnNldCAmIDB4MWZmKSkgewogCQkJb3BfbGVuID0gYmUzMl90b19jcHUob3BoZWFk
LT5vaF9sZW4pOwogCQl9IGVsc2UgewogCQkJaWR4ID0gQlRPQkJUKChfX3BzaW50X3QpJm9waGVh
ZC0+b2hfbGVuIC0KLS0gCjEuOC4wLnJjMgoK
--f46d0401692396fa1a04ce54c475
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--f46d0401692396fa1a04ce54c475--
