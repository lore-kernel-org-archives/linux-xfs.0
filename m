Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C30377F4E
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 18:42:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47C58AC006
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 16:42:04 -0700 (PDT)
Received: from mail-we0-f179.google.com (mail-we0-f179.google.com
	[74.125.82.179]) by cuda.sgi.com with ESMTP id X7tVYzcrvKivv53A
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Jun 2014 16:41:57 -0700 (PDT)
Received: by mail-we0-f179.google.com with SMTP id w62so5924740wes.38
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 16:41:56 -0700 (PDT)
Received: from t400.localnet (89-65-189-48.dynamic.chello.pl. [89.65.189.48])
	by mx.google.com with ESMTPSA id
	i8sm1683718wiw.22.2014.06.27.16.41.55 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 27 Jun 2014 16:41:55 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: xfs_repair 3.2.0 cannot (?) fix fs
Date: Sat, 28 Jun 2014 01:41:54 +0200
MIME-Version: 1.0
Message-Id: <201406280141.54350.arekm@maven.pl>
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

CkhlbGxvLgoKSSBoYXZlIGEgZnMgKG1ldGFkdW1wIG9mIGl0Cmh0dHA6Ly9peGlvbi5wbGQtbGlu
dXgub3JnL35hcmVrbS9wMi94MS93ZWIyLWhvbWUubWV0YWR1bXAuZ3opCnRoYXQgeGZzX3JlcGFp
ciAzLjIuMCBpcyB1bmFibGUgdG8gZml4IHByb3Blcmx5LgoKUnVubmluZyB4ZnNfcmVwYWlyIGZl
dyB0aW1lcyBzaG93cyB0aGUgc2FtZSBlcnJvcnMgcmVwZWF0aW5nOgpodHRwOi8vaXhpb24ucGxk
LWxpbnV4Lm9yZy9+YXJla20vcDIveDEvcmVwYWlyMi50eHQKaHR0cDovL2l4aW9uLnBsZC1saW51
eC5vcmcvfmFyZWttL3AyL3gxL3JlcGFpcjMudHh0Cmh0dHA6Ly9peGlvbi5wbGQtbGludXgub3Jn
L35hcmVrbS9wMi94MS9yZXBhaXI0LnR4dApodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJl
a20vcDIveDEvcmVwYWlyNS50eHQKCihyZXBhaXIxLnR4dCBhbHNvIGV4aXN0cyAtIGl0IHdhcyBp
bml0aWFsLCB2ZXJ5IGJpZy9sb25nIHJlcGFpcikKCk5vdGUgdGhhdCBmcyBtb3VudHMgZmluZSAo
YW5kIHdhcyBtb3VudGluZyBmaW5lIGJlZm9yZSBhbmQgYWZ0ZXIgcmVwYWlyKSBidXQgCnhmc19y
ZXBhaXIgaW5kaWNhdGVzIHRoYXQgbm90IGV2ZXJ5dGhpbmcgZ290IGZpeGVkLgoKClVuZm9ydHVu
YXRlbHkgdGhlcmUgbG9va3MgdG8gYmUgYSBwcm9ibGVtIHdpdGggbWV0YWR1bXAgaW1hZ2UuIHhm
c19yZXBhaXIgaXMgCmFibGUgdG8gZmluaXNoIGZpeGluZyBvbiBhIHJlc3RvcmVkIGltYWdlIGJ1
dCBpcyBub3QgYWJsZSAoc2VlIHJlcGFpclgudHh0KSAKYWJvdmUgb24gcmVhbCBkZXZpY2VzLiBI
dWg/CgpFeGFtcGxlcyBvZiBwcm9ibGVtcyByZXBlYXRpbmcgZWFjaCB0aW1lIHhmc19yZXBhaXIg
aXMgcnVuOgoKMSkKcmVzZXQgYmFkIHNiIGZvciBhZyA1Cm5vbi1udWxsIGdyb3VwIHF1b3RhIGlu
b2RlIGZpZWxkIGluIHN1cGVyYmxvY2sgNwoKMikgCmNvcnJlY3RpbmcgbmJsb2NrcyBmb3IgaW5v
ZGUgOTY1MTk1ODU4LCB3YXMgMTkgLSBjb3VudGVkIDIwCmNvcnJlY3RpbmcgbmV4dGVudHMgZm9y
IGlub2RlIDk2NTE5NTg1OCwgd2FzIDE2IC0gY291bnRlZCAxNwoKMykgY2xlYXJpbmcgc29tZSBl
bnRyaWVzOyBtb3ZpbmcgdG8gbG9zdCtmb3VuZCAodGhlIHNhbWUgZmlsZXMpCgo0KSAKUGhhc2Ug
NyAtIHZlcmlmeSBhbmQgY29ycmVjdCBsaW5rIGNvdW50cy4uLgpJbnZhbGlkIGlub2RlIG51bWJl
ciAweGZlZmZmZmZmZmZmZmZmZmYKeGZzX2Rpcl9pbm9fdmFsaWRhdGU6IFhGU19FUlJPUl9SRVBP
UlQKTWV0YWRhdGEgY29ycnVwdGlvbiBkZXRlY3RlZCBhdCBibG9jayAweDExZmJiNjk4LzB4MTAw
MApsaWJ4ZnNfd3JpdGVidWZyOiB3cml0ZSB2ZXJpZmVyIGZhaWxlZCBvbiBibm8gMHgxMWZiYjY5
OC8weDEwMDAKSW52YWxpZCBpbm9kZSBudW1iZXIgMHhmZWZmZmZmZmZmZmZmZmZmCnhmc19kaXJf
aW5vX3ZhbGlkYXRlOiBYRlNfRVJST1JfUkVQT1JUCk1ldGFkYXRhIGNvcnJ1cHRpb24gZGV0ZWN0
ZWQgYXQgYmxvY2sgMHgxMWZiYjY5OC8weDEwMDAKbGlieGZzX3dyaXRlYnVmcjogd3JpdGUgdmVy
aWZlciBmYWlsZWQgb24gYm5vIDB4MTFmYmI2OTgvMHgxMDAwCmRvbmUKCjUpTWV0YWRhdGEgQ1JD
IGVycm9yIGRldGVjdGVkIGF0IGJsb2NrIDB4MC8weDIwMApidXQgaXQgaXMgbm90IENSQyBlbmFi
bGVkIGZzCgotLSAKQXJrYWRpdXN6IE1pxZtraWV3aWN6LCBhcmVrbSAvIG1hdmVuLnBsCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
