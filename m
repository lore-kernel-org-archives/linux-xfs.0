Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1DE27F4E
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 12:54:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29F51AC006
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 10:54:52 -0700 (PDT)
Received: from mail-we0-f182.google.com (mail-we0-f182.google.com
	[74.125.82.182]) by cuda.sgi.com with ESMTP id UVKFkUhubZemRqEm
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Jul 2014 10:54:48 -0700 (PDT)
Received: by mail-we0-f182.google.com with SMTP id q59so4514762wes.13
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 10:54:47 -0700 (PDT)
From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH] Fix trivial typo in xfsrestore warning message
Date: Mon, 14 Jul 2014 19:54:42 +0200
Message-Id: <1405360482-28870-1-git-send-email-iusty@k1024.org>
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
Cc: Iustin Pop <iusty@k1024.org>

QWxzbyBtb2RpZnkgdGhlIHBvLyBmaWxlcywgYWx0aG91Z2ggbm90IHN1cmUgaWYgdGhhdCdzIHRo
ZSBjb3JyZWN0CnByb2NlZHVyZS4KClNpZ25lZC1vZmYtYnk6IEl1c3RpbiBQb3AgPGl1c3R5QGsx
MDI0Lm9yZz4KLS0tCiBwby9kZS5wbyAgICAgICB8IDIgKy0KIHBvL3BsLnBvICAgICAgIHwgMiAr
LQogcmVzdG9yZS90cmVlLmMgfCAyICstCiAzIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9wby9kZS5wbyBiL3BvL2RlLnBvCmluZGV4
IDg4MTEzNTYuLjhiZGQ3NTYgMTAwNjQ0Ci0tLSBhL3BvL2RlLnBvCisrKyBiL3BvL2RlLnBvCkBA
IC0yODMyLDcgKzI4MzIsNyBAQCBtc2dzdHIgImNobW9kICVzIGZlaGxnZXNjaGxhZ2VuOiAlc1xu
IgogIywgYy1mb3JtYXQKIG1zZ2lkICIiCiAiYXR0ZW1wdCB0byBzZXQgZXh0ZW5kZWQgYXR0cmli
dXRlcyAoeGZsYWdzIDB4JXgsIGV4dHNpemUgPSAweCV4LCBwcm9qaWQgPSAweCUiCi0ieClvZiAl
cyBmYWlsZWQ6ICVzXG4iCisieCkgb2YgJXMgZmFpbGVkOiAlc1xuIgogbXNnc3RyICIiCiAiVmVy
c3VjaCBlcndlaXRlcnRlIEF0dHJpYnV0ZSAoeGZsYWdzIDB4JXgsIGV4dHNpemUgPSAweCV4LCBw
cm9qaWQgPSAweCV4KSAiCiAidm9uICVzIHp1IHNldHplbiBmZWhsZ2VzY2hsYWdlbjogJXNcbiIK
ZGlmZiAtLWdpdCBhL3BvL3BsLnBvIGIvcG8vcGwucG8KaW5kZXggZDRkNjhiNC4uM2NlODIzZSAx
MDA2NDQKLS0tIGEvcG8vcGwucG8KKysrIGIvcG8vcGwucG8KQEAgLTM3NzAsNyArMzc3MCw3IEBA
IG1zZ3N0ciAiY2htb2QgJXMgbmllIHBvd2lvZMWCbyBzacSZOiAlc1xuIgogIywgYy1mb3JtYXQK
IG1zZ2lkICIiCiAiYXR0ZW1wdCB0byBzZXQgZXh0ZW5kZWQgYXR0cmlidXRlcyAoeGZsYWdzIDB4
JXgsIGV4dHNpemUgPSAweCV4LCBwcm9qaWQgPSAweCIKLSIleClvZiAlcyBmYWlsZWQ6ICVzXG4i
CisiJXgpIG9mICVzIGZhaWxlZDogJXNcbiIKIG1zZ3N0ciAiIgogInByw7NiYSB1c3Rhd2llbmlh
IHJvenN6ZXJ6b255Y2ggYXRyeWJ1dMOzdyAoeGZsYWdzIDB4JXgsIGV4dHNpemUgPSAweCV4LCAi
CiAicHJvamlkID0gMHgleCkgJXMgbmllIHBvd2lvZMWCYSBzacSZOiAlc1xuIgpkaWZmIC0tZ2l0
IGEvcmVzdG9yZS90cmVlLmMgYi9yZXN0b3JlL3RyZWUuYwppbmRleCA3ZTYxMjdmLi4wOGUxNzdm
IDEwMDY0NAotLS0gYS9yZXN0b3JlL3RyZWUuYworKysgYi9yZXN0b3JlL3RyZWUuYwpAQCAtMjYx
Nyw3ICsyNjE3LDcgQEAgc2V0ZGlyYXR0ciggZGFoX3QgZGFoLCBjaGFyICpwYXRoICkKIAkJICAg
ICAgICJleHRlbmRlZCBhdHRyaWJ1dGVzICIKIAkJICAgICAgICIoeGZsYWdzIDB4JXgsICIKIAkJ
ICAgICAgICJleHRzaXplID0gMHgleCwgIgotCQkgICAgICAgInByb2ppZCA9IDB4JXgpIgorCQkg
ICAgICAgInByb2ppZCA9IDB4JXgpICIKIAkJICAgICAgICJvZiAlcyBmYWlsZWQ6ICIKIAkJICAg
ICAgICIlc1xuIiksCiAJCSAgICAgZnN4YXR0ci5mc3hfeGZsYWdzLAotLSAKMi4wLjAucmM0Cgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
