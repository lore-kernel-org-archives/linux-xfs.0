Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7QAJEdV023789 for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 05:19:14 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 948311D7BF6A
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 03:19:47 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id f8eGz4CH9IW2HYJD for
	<xfs@oss.sgi.com>; Thu, 26 Aug 2010 03:19:47 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] Disallow 32bit project quota id.
Date: Thu, 26 Aug 2010 12:19:43 +0200
Message-Id: <1282817983-3301-1-git-send-email-arekm@maven.pl>
In-Reply-To: <20100826081247.GD705@dastard>
References: <20100826081247.GD705@dastard>
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
To: xfs@oss.sgi.com

Q3VycmVudGx5IG9uLWRpc2sgc3RydWN0dXJlIGlzIGFibGUgdG8ga2VlcCBvbmx5IDE2Yml0IHBy
b2plY3QgcXVvdGEgaWQsCnNvIGRpc2FsbG93IDMyYml0IG9uZXMuIFRoaXMgZml4ZXMgYSBwcm9i
bGVtIHdoZXJlIHBhcnRzIG9mIGtlcm5lbApzdHJ1Y3R1cmVzIGhvbGRpbmcgcHJvamVjdCBxdW90
YSBpZCBhcmUgMzJiaXQgd2hpbGUgcGFydHMgKG9uLWRpc2spCmFyZSAxNmJpdCB2YXJpYWJsZXMg
d2hpY2ggY2F1c2VzIHByb2plY3QgcXVvdGEgbWVtYmVyIGZpbGVzIHRvIGJlCmluYWNjZXNzaWJs
ZSBmb3Igc29tZSBvcGVyYXRpb25zIChsaWtlIG12L3JtKS4KClNpZ25lZC1vZmYtYnk6IEFya2Fk
aXVzeiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Ci0tLQoKSXNzdWVzIHNvbHZlZDoKLSBG
U1hfUFJPSklEIGluIG1hc2sgaXMgY2hlY2tlZAotIDgwIGNvbHVtbiBpc3N1ZSBmaXhlZAotIGNo
ZWNrcGF0aC5wbCBjaGVja2VkCgoKIGZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMgfCAgICA3
ICsrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMgYi9mcy94ZnMvbGlu
dXgtMi42L3hmc19pb2N0bC5jCmluZGV4IDIzN2Y1ZmYuLjRmZWM0MjcgMTAwNjQ0Ci0tLSBhL2Zz
L3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMKKysrIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9j
dGwuYwpAQCAtOTA3LDYgKzkwNywxMyBAQCB4ZnNfaW9jdGxfc2V0YXR0cigKIAkJcmV0dXJuIFhG
U19FUlJPUihFSU8pOwogCiAJLyoKKwkgKiBEaXNhbGxvdyAzMmJpdCBwcm9qZWN0IGlkcyBiZWNh
dXNlIG9uLWRpc2sgc3RydWN0dXJlCisJICogaXMgMTZiaXQgb25seS4KKwkgKi8KKwlpZiAoKG1h
c2sgJiBGU1hfUFJPSklEKSAmJiAoZmEtPmZzeF9wcm9qaWQgPiAoX191aW50MTZfdCktMSkpCisJ
CXJldHVybiBYRlNfRVJST1IoRUlOVkFMKTsKKworCS8qCiAJICogSWYgZGlzayBxdW90YXMgaXMg
b24sIHdlIG1ha2Ugc3VyZSB0aGF0IHRoZSBkcXVvdHMgZG8gZXhpc3Qgb24gZGlzaywKIAkgKiBi
ZWZvcmUgd2Ugc3RhcnQgYW55IG90aGVyIHRyYW5zYWN0aW9ucy4gVHJ5aW5nIHRvIGRvIHRoaXMg
bGF0ZXIKIAkgKiBpcyBtZXNzeS4gV2UgZG9uJ3QgY2FyZSB0byB0YWtlIGEgcmVhZGxvY2sgdG8g
bG9vayBhdCB0aGUgaWRzCi0tIAoxLjcuMi4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
