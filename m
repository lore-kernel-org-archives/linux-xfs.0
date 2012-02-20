Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KF0PQe088406 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 09:00:25 -0600
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id CuYzQ1FcT3rE8QqY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Feb 2012 07:00:22 -0800 (PST)
Received: by bkcit16 with SMTP id it16so5246481bkc.26
	for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 07:00:21 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: xfs_repair: phase7.c:148: phase7: Assertion `no_modify || nrefs > 0'
	failed.
Date: Mon, 20 Feb 2012 16:00:18 +0100
MIME-Version: 1.0
Message-Id: <201202201600.19086.arekm@maven.pl>
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

Cnhmc19yZXBhaXIgZnJvbSB4ZnNwcm9ncy1kZXYgZ2l0Lmtlcm5lbC5vcmcgcmVwb3NpdG9yeQoK
b24gIGh0dHA6Ly9yb3V0aW5nLmNvbS5wbC94ZnMtbWV0YWR1bXAtMjAxMi0wMi0yMC5iejIgZmFp
bHMgd2l0aDoKCnJlc2V0dGluZyBpbm9kZSAyNjg3NDA4MzcgbmxpbmtzIGZyb20gNiB0byA1CnJl
c2V0dGluZyBpbm9kZSAyNjg3NDI3MjggbmxpbmtzIGZyb20gMTc4IHRvIDE3MgpyZXNldHRpbmcg
aW5vZGUgMjY4ODYxNjIyIG5saW5rcyBmcm9tIDQ1IHRvIDQ0CnJlc2V0dGluZyBpbm9kZSAyNjg5
MDI0MzggbmxpbmtzIGZyb20gNCB0byAzCnJlc2V0dGluZyBpbm9kZSAyNjg5MjA5MTggbmxpbmtz
IGZyb20gMTA1MDAgdG8gMTA0ODMKcmVzZXR0aW5nIGlub2RlIDI2OTEzMzgyMCBubGlua3MgZnJv
bSAxNDUwMSB0byA5NTI3CnJlc2V0dGluZyBpbm9kZSAyNjk0OTYzNDAgbmxpbmtzIGZyb20gNjEg
dG8gNTUKcmVzZXR0aW5nIGlub2RlIDI2OTc2ODc5MyBubGlua3MgZnJvbSA0IHRvIDMKcmVzZXR0
aW5nIGlub2RlIDI3MDUzMjYyNiBubGlua3MgZnJvbSA5IHRvIDgKcmVzZXR0aW5nIGlub2RlIDMz
OTYzMDMyMSBubGlua3MgZnJvbSA1IHRvIDQKcmVzZXR0aW5nIGlub2RlIDMzOTYzMDMyMiBubGlu
a3MgZnJvbSA0NSB0byAzOQpyZXNldHRpbmcgaW5vZGUgMzM5NjMwMzI3IG5saW5rcyBmcm9tIDI1
IHRvIDIwCnJlc2V0dGluZyBpbm9kZSA1MzY4NzI5NjAgbmxpbmtzIGZyb20gMiB0byAtNDI3Ngpu
bGlua3MgLTQyNzYgd2lsbCBvdmVyZmxvdyB2MSBpbm8sIGlubyA1MzY4NzI5NjAgd2lsbCBiZSBj
b252ZXJ0ZWQgdG8gdmVyc2lvbiAyCnJlc2V0dGluZyBpbm9kZSA1MzY4NzI5NjEgbmxpbmtzIGZy
b20gMiB0byAzMTcKeGZzX3JlcGFpcjogcGhhc2U3LmM6MTQ4OiBwaGFzZTc6IEFzc2VydGlvbiBg
bm9fbW9kaWZ5IHx8IG5yZWZzID4gMCcgZmFpbGVkLgoKd2hvbGUgbG9nOiBodHRwOi8vaXhpb24u
cGxkLWxpbnV4Lm9yZy9+YXJla20veGZzLWxvZy5negoKUGF0Y2hlcyB0byB0ZXN0IHdlbGNvbWUg
Oi0pCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFtCmFyZWtt
IC8gbWF2ZW4ucGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
