Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF13E7CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 11:14:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C5FCAC002
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:14:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pvzQSmLyLefACfnW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 09:14:33 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F2A7B7AE8E
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:14:32 +0000 (UTC)
Received: from zion.usersys.redhat.com (unused [10.10.50.219] (may be forged))
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u4BGEVJt003797
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 12:14:32 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: remove unused variable warning in
	xfs_finish_page_writeback
Date: Wed, 11 May 2016 18:14:26 +0200
Message-Id: <1462983266-15235-1-git-send-email-cmaiolino@redhat.com>
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

RnJvbTogQ2FybG9zIE1haW9saW5vIDxjbWFpb2xpbm9AcmVkaGF0LmNvbT4KCkR1ZSB0aGUgaW5p
dGlhbGl6YXRpb24gb2YgYmxvY2ttYXNrIHZhcmlhYmxlIHdpdGggaXRzIGRlZmluaXRpb24sIGdj
YyBpc3N1ZXMgdGhlCmZvbGxvd2luZyB3YXJuaW5nIGR1ZSBhbiB1bnVzZWQgdmFyaWFibGUgZHVy
aW5nIGNvbXBpbGF0aW9uIHRpbWUuCgpmcy94ZnMvL3hmc19hb3BzLmM6IEluIGZ1bmN0aW9uIOKA
mHhmc19maW5pc2hfcGFnZV93cml0ZWJhY2vigJk6CmZzL3hmcy8veGZzX2FvcHMuYzo5NzoxNTog
d2FybmluZzogdW51c2VkIHZhcmlhYmxlIOKAmGJsb2NrbWFza+KAmQpbLVd1bnVzZWQtdmFyaWFi
bGVdCiAgdW5zaWduZWQgaW50ICBibG9ja21hc2sgPSAoMSA8PCBpbm9kZS0+aV9ibGtiaXRzKSAt
IDE7CiAgICAgICAgICAgICAgIF4KUmVtb3ZlIHRoaXMgd2FybmluZyBieSBpbml0aWFsaXppbmcg
dGhlIHZhcmlhYmxlIGFmdGVyIGl0cyBkZWZpbml0aW9uLgoKVGhpcyBjaGFuZ2UgY2F1c2VzIG5v
IGRpZmZlcmVuY2UgaW4gdGhlIGdlbmVyYXRlZCBhc3NlbWJseSBjb2RlCgpTaWduZWQtb2ZmLWJ5
OiBDYXJsb3MgTWFpb2xpbm8gPGNtYWlvbGlub0ByZWRoYXQuY29tPgotLS0KIGZzL3hmcy94ZnNf
YW9wcy5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2FvcHMuYyBiL2ZzL3hmcy94ZnNfYW9wcy5j
CmluZGV4IDQwNjQ1YTQuLmY0ZTJkM2IgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy94ZnNfYW9wcy5jCisr
KyBiL2ZzL3hmcy94ZnNfYW9wcy5jCkBAIC05NCwxMSArOTQsMTIgQEAgeGZzX2ZpbmlzaF9wYWdl
X3dyaXRlYmFjaygKIAlzdHJ1Y3QgYmlvX3ZlYwkJKmJ2ZWMsCiAJaW50CQkJZXJyb3IpCiB7Ci0J
dW5zaWduZWQgaW50CQlibG9ja21hc2sgPSAoMSA8PCBpbm9kZS0+aV9ibGtiaXRzKSAtIDE7CisJ
dW5zaWduZWQgaW50CQlibG9ja21hc2s7CiAJdW5zaWduZWQgaW50CQllbmQgPSBidmVjLT5idl9v
ZmZzZXQgKyBidmVjLT5idl9sZW4gLSAxOwogCXN0cnVjdCBidWZmZXJfaGVhZAkqaGVhZCwgKmJo
OwogCXVuc2lnbmVkIGludAkJb2ZmID0gMDsKIAorCWJsb2NrbWFzayA9ICgxIDw8IGlub2RlLT5p
X2Jsa2JpdHMpIC0gMTsKIAlBU1NFUlQoYnZlYy0+YnZfb2Zmc2V0IDwgUEFHRV9TSVpFKTsKIAlB
U1NFUlQoKGJ2ZWMtPmJ2X29mZnNldCAmIGJsb2NrbWFzaykgPT0gMCk7CiAJQVNTRVJUKGVuZCA8
IFBBR0VfU0laRSk7Ci0tIAoyLjQuMTEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9v
c3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
