Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 709A97F53
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 04:29:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 285088F8033
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 02:29:54 -0800 (PST)
Received: from resqmta-ch2-08v.sys.comcast.net
	(resqmta-ch2-08v.sys.comcast.net [69.252.207.40]) by
	cuda.sgi.com with ESMTP id 8VuEId5xbSGuPk5C (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 02:29:52 -0800 (PST)
From: Joshua Kinard <kumba@gentoo.org>
Subject: [PATCH 2/3] xfsprogs: misc uClibc patches: use POSIX signal API
Message-ID: <569CBE85.4030800@gentoo.org>
Date: Mon, 18 Jan 2016 05:29:25 -0500
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

RnJvbTogSm9zaHVhIEtpbmFyZCA8a3VtYmFAZ2VudG9vLm9yZz4KCnVDbGliYyBkb2Vzbid0IHBy
b3ZpZGUgdGhlIHNpZ3JlbHNlIG9yIHNpZ2hvbGQgY2FsbHMsIHNvIHRoaXMgcGF0Y2ggcmVwbGFj
ZXMKdGhlbSB3aXRoIFBPU0lYIHNpZ25hbCBBUEkgY2FsbHMgKHNpZ3Byb2NtYXNrKDIpLCBldGMp
LgoKUmVmZXIgdG8gR2VudG9vIEJ1ZyAjNDc3NzU4OgpodHRwczovL2J1Z3MuZ2VudG9vLm9yZy9z
aG93X2J1Zy5jZ2k/aWQ9NDc3NzU4CgpTaWduZWQtb2ZmLWJ5OiBKb3NodWEgS2luYXJkIDxrdW1i
YUBnZW50b28ub3JnPgpTdWdnZXN0ZWQtYnk6IFJlbsOpIFJow6lhdW1lIDxyZW5lLnJoZWF1bWVA
Z21haWwuY29tPgotLS0KIGNvcHkveGZzX2NvcHkuYyB8ICAgMTYgKysrKysrKysrKysrKy0tLQog
MSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC1O
YXVycCB4ZnNwcm9ncy00LjMuMC5vcmlnL2NvcHkveGZzX2NvcHkuYyB4ZnNwcm9ncy00LjMuMC9j
b3B5L3hmc19jb3B5LmMKLS0tIHhmc3Byb2dzLTQuMy4wLm9yaWcvY29weS94ZnNfY29weS5jCTIw
MTUtMTAtMTUgMjE6MzE6MjYuMDAwMDAwMDAwICswMDAwCisrKyB4ZnNwcm9ncy00LjMuMC9jb3B5
L3hmc19jb3B5LmMJMjAxNi0wMS0wMSAxMDo1MzowNC43MjIyMjkwMDAgKzAwMDAKQEAgLTc1LDYg
Kzc1LDE2IEBAIHN0YXRpYyBpbnQJZm9ybWF0X2xvZ3Moc3RydWN0IHhmc19tb3VudAogI2RlZmlu
ZSBMQVNUCTB4MTAJCS8qIGZpbmFsIG1lc3NhZ2Ugd2UgcHJpbnQgKi8KIAogdm9pZAorc2lnbmFs
X21hc2tmdW5jKGludCBhZGRzZXQsIGludCBuZXdzZXQpCit7CisJc2lnc2V0X3Qgc2V0OworCisJ
c2lnZW1wdHlzZXQoJnNldCk7CisJc2lnYWRkc2V0KCZzZXQsIGFkZHNldCk7CisJc2lncHJvY21h
c2sobmV3c2V0LCAmc2V0LCBOVUxMKTsKK30KKwordm9pZAogZG9fbWVzc2FnZShpbnQgZmxhZ3Ms
IGludCBjb2RlLCBjb25zdCBjaGFyICpmbXQsIC4uLikKIHsKIAl2YV9saXN0CWFwOwpAQCAtNDc3
LDkgKzQ4Nyw5IEBAIHdyaXRlX3didWYodm9pZCkKIAkJaWYgKHRhcmdldFtpXS5zdGF0ZSAhPSBJ
TkFDVElWRSkKIAkJCXB0aHJlYWRfbXV0ZXhfdW5sb2NrKCZ0YXJnW2ldLndhaXQpOwkvKiB3YWtl
IHVwICovCiAKLQlzaWdyZWxzZShTSUdDSExEKTsKKwlzaWduYWxfbWFza2Z1bmMoU0lHQ0hMRCwg
U0lHX1VOQkxPQ0spOwogCXB0aHJlYWRfbXV0ZXhfbG9jaygmbWFpbndhaXQpOwotCXNpZ2hvbGQo
U0lHQ0hMRCk7CisJc2lnbmFsX21hc2tmdW5jKFNJR0NITEQsIFNJR19CTE9DSyk7CiB9CiAKIHZv
aWQKQEAgLTg5Myw3ICs5MDMsNyBAQCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKIAkvKiBz
ZXQgdXAgc2lnY2hpbGQgc2lnbmFsIGhhbmRsZXIgKi8KIAogCXNpZ25hbChTSUdDSExELCBoYW5k
bGVyKTsKLQlzaWdob2xkKFNJR0NITEQpOworCXNpZ25hbF9tYXNrZnVuYyhTSUdDSExELCBTSUdf
QkxPQ0spOwogCiAJLyogbWFrZSBjaGlsZHJlbiAqLwogCgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
