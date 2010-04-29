Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T0EeK6020669 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:14:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BF221AF2715
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 17:16:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Ean2D5vSLUuji4xJ for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 17:16:43 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	22474273-1927428
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:46:42 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O7HQh-0007Pn-Ux
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:35 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O7HQY-0007ey-Ap
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfsqa: clean up 030 repair output
Date: Thu, 29 Apr 2010 10:16:24 +1000
Message-Id: <1272500186-29393-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1272500186-29393-1-git-send-email-david@fromorbit.com>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
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

V2l0aCB0aGUgbmV3IGNoZWNrcyBpbiB4ZnNfcmVwYWlyLCBpdCBvdXRwdXRzIG1vcmUgaW5mb3Jt
YXRpb24KYWJvdXQgZXJyb3JzIGZvdW5kIHRoYW4gcHJldmlvdXNseS4gVGhpcyBuZXcgb3V0cHV0
IGNhbiBiZSBpZ25vcmVkCmZvciB0aGUgcHVycG9zZdGVIG9mIHRoaXMgdGVzdCwgc28gZmlsdGVy
IGl0IGFsbCBvdXQuIFRoaXMgd2lsbAphbGxvdyB0aGUgdGVzdCB0byBydW4gb24gbmV3IGFuZCBv
bGQgcmVhcGlyIGJpbmFyaWVzLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkYXZpZEBm
cm9tb3JiaXQuY29tPgotLS0KIGNvbW1vbi5yZXBhaXIgfCAgICA1ICsrKysrCiAxIGZpbGVzIGNo
YW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9jb21t
b24ucmVwYWlyIGIvY29tbW9uLnJlcGFpcgppbmRleCBiYTQyYjhmLi4yM2ExZWQ2IDEwMDY0NAot
LS0gYS9jb21tb24ucmVwYWlyCisrKyBiL2NvbW1vbi5yZXBhaXIKQEAgLTcyLDYgKzcyLDExIEBA
IHMvICAgICAgICAtIGdlbmVyYXRlIHJlYWx0aW1lIHN1bW1hcnkgaW5mbyBhbmQgYml0bWFwLi4u
XG4vL2c7CiBzL1xzKy0gY3JlYXRpbmcgXGQrIHdvcmtlciB0aHJlYWRcKHNcKVxuLy9nOwogcy9c
cystIHJlcG9ydGluZyBwcm9ncmVzcyBpbiBpbnRlcnZhbHMgb2YgXGQrIG1pbnV0ZXNcbi8vZzsK
IHMvXHMrLSBcZCs6XGRcZDpcZFxkOi4qXG4vL2c7CisjIDMuMS4wIGV4dHJhIGFjY291bnRpbmcg
b3V0cHV0CisvXmFnZl8vICYmIG5leHQ7ICMgcmVtb3ZlIGFnZiBjb3VudHMKKy9eYWdpXy8gJiYg
bmV4dDsgIyByZW1vdmUgYWdpIGNvdW50cworL15zYl8vICYmIG5leHQ7ICMgcmVtb3ZlIHNiIGNv
dW50cworL15hZ2kgdW5saW5rZWQvICYmIG5leHQ7ICMgcmVtb3ZlIGFnaSB1bmxpbmtlZCBidWNr
ZXQgd2FybmluZwogCXByaW50OycKIH0KIAotLSAKMS41LjYuNQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
