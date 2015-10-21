Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6629329DF5
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 04:28:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2D84AC001
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 02:27:59 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	QhKAYN0SzSLiivPN (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2015 02:27:56 -0700 (PDT)
Received: by wicll6 with SMTP id ll6so65125486wic.1
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 02:27:54 -0700 (PDT)
Received: from xps.localnet ([91.234.176.242])
	by smtp.gmail.com with ESMTPSA id v9sm9130935wjv.45.2015.10.21.02.27.53
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 21 Oct 2015 02:27:54 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: very long log recovery at mount
Date: Wed, 21 Oct 2015 11:27:52 +0200
MIME-Version: 1.0
Message-Id: <201510211127.52794.arekm@maven.pl>
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
To: xfs <xfs@oss.sgi.com>

CkhpLgoKSSBnb3Qgc3VjaCBzaXR1YXRpb24sIGZyZXNoIGJvb3QsIDQuMS4xMCBrZXJuZWwsIGlu
aXQgc2NyaXB0cyBzdGFydCBtb3VudGluZyAKZmlsZXN5c3RlbXMuIE9uZSBmcyB3YXNuJ3QgdmVy
eSBsdWNreToKClsgICAxNS45Nzk1MzhdIFhGUyAobWQzKTogTW91bnRpbmcgVjQgRmlsZXN5c3Rl
bQpbICAgMTYuMjU2MzE2XSBYRlMgKG1kMyk6IEVuZGluZyBjbGVhbiBtb3VudApbICAgMjguMzQz
MzQ2XSBYRlMgKG1kNCk6IE1vdW50aW5nIFY0IEZpbGVzeXN0ZW0KWyAgIDI4LjYyOTkxOF0gWEZT
IChtZDQpOiBFbmRpbmcgY2xlYW4gbW91bnQKWyAgIDI4LjY2MjEyNV0gWEZTIChtZDUpOiBNb3Vu
dGluZyBWNCBGaWxlc3lzdGVtClsgICAyOC45ODAxNDJdIFhGUyAobWQ1KTogRW5kaW5nIGNsZWFu
IG1vdW50ClsgICAyOS4wNDk0MjFdIFhGUyAobWQ2KTogTW91bnRpbmcgVjQgRmlsZXN5c3RlbQpb
ICAgMjkuNDQ3NzI1XSBYRlMgKG1kNik6IFN0YXJ0aW5nIHJlY292ZXJ5IChsb2dkZXY6IGludGVy
bmFsKQpbIDQ1MTcuMzI3MzMyXSBYRlMgKG1kNik6IEVuZGluZyByZWNvdmVyeSAobG9nZGV2OiBp
bnRlcm5hbCkKCkl0IHRvb2sgb3ZlciAxaCB0byBtb3VudCBtZDYgZmlsZXN5c3RlbS4KClF1ZXN0
aW9uczoKLSBpcyBpdCBwb3NzaWJsZSB0byBsb2cgaG93IG11Y2ggZGF0YSBpcyBuZWVkZWQgdG8g
YmUgcmVjb3ZlcmVkIGZyb20gbG9nPyBTb21lIApkYXRhIHRoYXQgd291bGQgZ2l2ZSBhIGhpbnQg
b24gaG93IGJpZyB0aGlzIGlzIChhbmQgdGh1cyByb3VnaCBlc3RpbWF0ZSBvbiBob3cgCmxvbmcg
aXQgd2lsbCB0YWtlKS4gTm90IHN1cmUgaWYgdGhhdCdzIGtub3duIGF0IHRpbWUgd2hlbiB0aGlz
IG1lc3NhZ2UgaXMgCmJlaW5nIHByaW50ZWQuCgpYRlMgKG1kNik6IFN0YXJ0aW5nIHJlY292ZXJ5
IChsb2dkZXY6IGludGVybmFsLCB0byByZWNvdmVyOiB4eXpNQiAoPykpCgotIG5vdyBzdWNoIGxv
bmcgbW91bnQgdGltZSBpcyBhbG1vc3QgaW5zYW5lLCBzbyBJIHdvbmRlciB3aHkgY291bGQgYmUg
dGhlIApyZWFzb24uIElzIHRoZSBwcm9jZXNzIG11bHRpdGhyZWFkZWQsIHNpbmdsZSB0aHJlYWRl
ZD8gY3B1cyB3ZXJlIGlkbGUKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8gKCBt
YXZlbi5wbCB8IHBsZC1saW51eC5vcmcgKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
