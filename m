Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A42E7F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 15:36:53 -0600 (CST)
Date: Fri, 1 Feb 2013 15:36:49 -0600
From: Ben Myers <bpm@sgi.com>
Subject: xfsprogs: fix warning in libxcmd/input.c
Message-ID: <20130201213649.GM30652@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Rml4IGFuIGVycm9yIHdoZW4gYnVpbGRpbmcgd2l0aCAtV2Vycm9yPWZvcm1hdC1zZWN1cml0eS4K
CmlucHV0LmM6IEluIGZ1bmN0aW9uICdmZXRjaGxpbmUnOgppbnB1dC5jOjkxOjI6IGVycm9yOiBm
b3JtYXQgbm90IGEgc3RyaW5nIGxpdGVyYWwgYW5kIG5vIGZvcm1hdCBhcmd1bWVudHMgWy1XZXJy
b3I9Zm9ybWF0LXNlY3VyaXR5XQoKU2lnbmVkLW9mZi1ieTogQmVuIE15ZXJzIDxicG1Ac2dpLmNv
bT4KUmVwb3J0ZWQgYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Cklu
ZGV4OiB4ZnNwcm9ncy9saWJ4Y21kL2lucHV0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0geGZzcHJvZ3Mub3Jp
Zy9saWJ4Y21kL2lucHV0LmMJMjAxMy0wMi0wMSAxNToyOTo0Ny4wNjk4OTQ1MjIgLTA2MDAKKysr
IHhmc3Byb2dzL2xpYnhjbWQvaW5wdXQuYwkyMDEzLTAyLTAxIDE1OjMwOjAwLjg0NTg5NTE4OCAt
MDYwMApAQCAtODgsNyArODgsNyBAQAogCiAJaWYgKCFsaW5lKQogCQlyZXR1cm4gTlVMTDsKLQlw
cmludGYoZ2V0X3Byb21wdCgpKTsKKwlwcmludGYoIiVzIiwgZ2V0X3Byb21wdCgpKTsKIAlmZmx1
c2goc3Rkb3V0KTsKIAlpZiAoIWZnZXRzKGxpbmUsIE1BWFJFQURMSU5FU1osIHN0ZGluKSkgewog
CQlmcmVlKGxpbmUpOwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
