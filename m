Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 797C17F5F
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:02:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 69F2D304066
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:02:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id u8Bufw685WKSclrG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 04:02:11 -0700 (PDT)
From: =?UTF-8?q?Jan=20=C5=A4ul=C3=A1k?= <jtulak@redhat.com>
Subject: [PATCH 02/17] mkfs: sanitise ftype parameter values.
Date: Fri, 19 Jun 2015 13:01:51 +0200
Message-Id: <1434711726-13092-3-git-send-email-jtulak@redhat.com>
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
Cc: Dave Chinner <dchinner@redhat.com>

RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgoKQmVjYXVzZSBwYXNzaW5n
ICItbiBmdHlwZT0yIiBzaG91bGQgZmFpbC4KClNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8
ZGNoaW5uZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogSmFuIMWkdWzDoWsgPGp0dWxha0By
ZWRoYXQuY29tPgotLS0KIG1rZnMveGZzX21rZnMuYyB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9ta2ZzL3hmc19t
a2ZzLmMgYi9ta2ZzL3hmc19ta2ZzLmMKaW5kZXggZDBkZTkwZC4uMTY1MjkwMyAxMDA2NDQKLS0t
IGEvbWtmcy94ZnNfbWtmcy5jCisrKyBiL21rZnMveGZzX21rZnMuYwpAQCAtMTYxNywxMiArMTYx
NywxNSBAQCBfKCJjYW5ub3Qgc3BlY2lmeSBib3RoIGNyYyBhbmQgZnR5cGVcbiIpKTsKIAkJCQkJ
CXJlcXZhbCgnbicsIG5vcHRzLCBOX0ZUWVBFKTsKIAkJCQkJaWYgKG5mdHlwZSkKIAkJCQkJCXJl
c3BlYygnbicsIG5vcHRzLCBOX0ZUWVBFKTsKLQkJCQkJZGlyZnR5cGUgPSBhdG9pKHZhbHVlKTsK
KwkJCQkJYyA9IGF0b2kodmFsdWUpOworCQkJCQlpZiAoYyA8IDAgfHwgYyA+IDEpCisJCQkJCQlp
bGxlZ2FsKHZhbHVlLCAibiBmdHlwZSIpOwogCQkJCQlpZiAoY3Jjc19lbmFibGVkKSB7CiAJCQkJ
CQlmcHJpbnRmKHN0ZGVyciwKIF8oImNhbm5vdCBzcGVjaWZ5IGJvdGggY3JjIGFuZCBmdHlwZVxu
IikpOwogCQkJCQkJdXNhZ2UoKTsKIAkJCQkJfQorCQkJCQlkaXJmdHlwZSA9IGM7CiAJCQkJCW5m
dHlwZSA9IDE7CiAJCQkJCWJyZWFrOwogCQkJCWRlZmF1bHQ6Ci0tIAoyLjEuMAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4
ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
