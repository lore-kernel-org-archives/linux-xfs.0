Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9DFB7F4E
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 03:41:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4411304051
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 01:41:10 -0700 (PDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id 5KcwvQtCdiD87xcN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Jul 2014 01:41:05 -0700 (PDT)
Received: by mail-wg0-f49.google.com with SMTP id a1so2165636wgh.8
	for <xfs@oss.sgi.com>; Tue, 08 Jul 2014 01:41:04 -0700 (PDT)
Received: from t400.localnet ([91.234.176.246])
	by mx.google.com with ESMTPSA id
	i12sm94888539wjr.32.2014.07.08.01.41.03 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 08 Jul 2014 01:41:03 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: usrquota,
	prjquota mount success on 3.16rc4 but Failed to initialize disk
	quotas on 3.10.43
Date: Tue, 8 Jul 2014 10:41:01 +0200
MIME-Version: 1.0
Message-Id: <201407081041.02020.arekm@maven.pl>
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

Ck15IGJyb2tlbiBmcwpodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vcDIveDEvd2Vi
Mi1ob21lLm1ldGFkdW1wLmd6CnRoYW5rcyB0byAieGZzcHJvZ3M6IGZpeGVzIGZvciAzLjIuMSIg
YnkgRGF2ZSBpcyBub3cgYWxtb3N0IGluIGdvb2Qgc2hhcGUuCgpXaGF0IEkgZm91bmQgaW50ZXJl
c3RpbmcgaXMgdGhhdCByZXBhaXJpbmcgaXQgd2l0aCBjdXJyZW50IGdpdCB4ZnNfcmVwYWlyIGFu
ZCAKdGhlbiBtb3VudGluZyAoLW8gdXNycXVvdGEscHJqcXVvdGEpIG9uIDMuMTYuMC1yYzQgZ2l2
ZXMgbWU6CgpbMzIyMDguMTQyMzE2XSBYRlMgKHNkYik6IE1vdW50aW5nIFY0IEZpbGVzeXN0ZW0K
WzMyMjA4LjIwNTQ0OV0gWEZTIChzZGIpOiBFbmRpbmcgY2xlYW4gbW91bnQKWzMyMjA4LjI1ODk5
MV0gWEZTIChzZGIpOiBRdW90YWNoZWNrIG5lZWRlZDogUGxlYXNlIHdhaXQuClszMjgyMS45MzA0
MzddIFhGUyAoc2RiKTogUXVvdGFjaGVjazogRG9uZS4KClRoZW4gSSB1bW91bnQgaXQgYW5kIG1v
dW50IGFnYWluIChzYW1lIG9wdGlvbnMgYXMgYmVmb3JlKSBidXQgb24gMy4xMC40MyAKa2VybmVs
OgoKWyAgMTExLjMyNTg4OV0gWEZTIChzZGIpOiBNb3VudGluZyBGaWxlc3lzdGVtClsgIDExMS40
MTkzMzFdIFhGUyAoc2RiKTogRmFpbGVkIHRvIGluaXRpYWxpemUgZGlzayBxdW90YXMuClsgIDEx
MS40MTkzMzldIFhGUyAoc2RiKTogRW5kaW5nIGNsZWFuIG1vdW50CgpXaGF0IGRpZCBjaGFuZ2Ug
aW4gbGF0ZXIga2VybmVscyB0aGF0IGNvdWxkIGhhdmUgbWVhbmluZyBoZXJlPyAoc28gSSBjb3Vs
ZCB0cnkgCnRvIGJhY2twb3J0IHRoYXQgY2hhbmdlKS4KCkZvciB0ZXN0aW5nIEkgbW91bnRlZCBh
Z2FpbiBvbiAzLjE2IGFuZDoKWzMzODcwLjQ3Mjc2OV0gWEZTIChzZGIpOiBNb3VudGluZyBWNCBG
aWxlc3lzdGVtClszMzg3MC41NDM1MzldIFhGUyAoc2RiKTogRW5kaW5nIGNsZWFuIG1vdW50Clsz
Mzg3MC41OTc3OTFdIFhGUyAoc2RiKTogUXVvdGFjaGVjayBuZWVkZWQ6IFBsZWFzZSB3YWl0Lgpb
MzQ0ODQuMzMyODc5XSBYRlMgKHNkYik6IFF1b3RhY2hlY2s6IERvbmUKCmFuZCBhZ2FpbiBvbiAz
LjEwLjQzOgpbIDE2NDkuMjE1MzkwXSBYRlMgKHNkYik6IE1vdW50aW5nIEZpbGVzeXN0ZW0KWyAx
NjQ5LjMxNjg5NF0gWEZTIChzZGIpOiBGYWlsZWQgdG8gaW5pdGlhbGl6ZSBkaXNrIHF1b3Rhcy4K
WyAxNjQ5LjMxNjkwMl0gWEZTIChzZGIpOiBFbmRpbmcgY2xlYW4gbW91bnQKCgoodGhlcmUgd2Fz
IGFuIGFkZGl0aW9uYWwgcHJvYmxlbXMgd2l0aCBoYW5ncyBvbiBxdW90YWNoZWNrIGxpa2UgCmh0
dHA6Ly9zcHJ1bmdlLnVzL0xZUU8gKDMuMTYuMC1yYzMtMDAwMDYtZzE2ODc0YjIpCmh0dHA6Ly9z
cHJ1bmdlLnVzL0ZmaFIgKDMuMTUuMykKaHR0cDovL3NwcnVuZ2UudXMvT2JXSSAoMy4xMC4yMCkK
YnV0IGl0IG9ubHkgaGFwcGVuZWQgd2hlbiBkb2luZyBxdW90YWNoZWNrIG9uIGltYWdlIG1vdW50
ZWQgdmlhIGxvb3AuIFdhc24ndCAKYWJsZSB0byB0cmlnZ2VyIGl0IHdoZW4gdXNpbmcgcmVhbCBk
aXNrLCBzbyBibGFtaW5nIGxvb3AgY29kZSBmb3Igbm93KQoKLS0gCkFya2FkaXVzeiBNacWba2ll
d2ljeiwgYXJla20gLyBtYXZlbi5wbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
