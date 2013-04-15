Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 393537F50
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 08:57:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 107BE8F8037
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:57:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BEqITWLdfKKg442n for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 06:57:37 -0700 (PDT)
Message-ID: <516C0752.8070007@sandeen.net>
Date: Mon, 15 Apr 2013 08:57:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
	<CADFMGuK-tJQFQzN9wN0LiWWj6SY4tg_c0W9dJadctg=ytegB+w@mail.gmail.com>
	<516798AE.9050908@sandeen.net>
	<CADFMGuK67G85+J3LAjS=w_nkkSrj7At9HnPLSL-DBO6g0V=ThA@mail.gmail.com>
	<CADFMGuLNmSpA+e2Wo0qS5y2evQM=q_oVJJPf6kZkfAP4jfk=6w@mail.gmail.com>
	<CADFMGuJoar_uKB_Lrq0nKFsbdjyZWFaHXU-ni2ky3sToSQwUSQ@mail.gmail.com>
	<516800F7.80502@redhat.com>
	<CADFMGuKH_jYhuxzMQ_4mj_Zv4EgPfpuBYR=fpqBfJPWf=POJPQ@mail.gmail.com>
	<CADFMGuJmNLTcyb4aQmbto--dgFBgP55QWeaP+grAoPL+q8eRCg@mail.gmail.com>
	<CADFMGuKsDHFt_XOvjHKR=s6c7LsJYw=Jr5DXvTyswrXQT2g7yA@mail.gmail.com>
	<CADFMGuJMjKc1QoS-Ewt6wG2uSWjyWfQevQg7ZVMer0XSpx3Vjg@mail.gmail.com>
	<CADFMGuJDhq810CRE1TMJga6LN25i+Xm9EeGEhO_wTZrbXe8EFg@mail.gmail.com>
	<CADFMGuKdUJ6U5_tVNGStZRyALp94n=M7x7C_CVqAfAbEwsuBFw@mail.gmail.com>
	<CADFMGuJ5vngJZDKUPn0=i32-Y_8fpJC+DRzutZ7+D9NSrfCy=Q@mail.gma
	il.com>
In-Reply-To: <CADFMGuJ5vngJZDKUPn0=i32-Y_8fpJC+DRzutZ7+D9NSrfCy=Q@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gNC8xNS8xMyA4OjQ1IEFNLCC3+9PAzM4gd3JvdGU6Cj4gQW5kIGF0IHRoZSBzYW1lIHRpbWUg
d2UgZ290IHRoZSBmb2xsb3dpbmcgZXJyb3IgbG9nIG9mIGdsdXN0ZXJmczoKPiBbMjAxMy0wNC0x
NSAyMDo0MzowMy44NTExNjNdIEkgW2RodC1yZWJhbGFuY2UuYzoxNjExOmdmX2RlZnJhZ19zdGF0
dXNfZ2V0XSAwLWdsdXN0ZXJmczogUmViYWxhbmNlIGlzIGNvbXBsZXRlZAo+IFsyMDEzLTA0LTE1
IDIwOjQzOjAzLjg1MTI0OF0gSSBbZGh0LXJlYmFsYW5jZS5jOjE2MTQ6Z2ZfZGVmcmFnX3N0YXR1
c19nZXRdIDAtZ2x1c3RlcmZzOiBGaWxlcyBtaWdyYXRlZDogMTYyOSwgc2l6ZTogMTU4MjMyOTA2
NTk1NCwgbG9va3VwczogMTEwMzYsIGZhaWx1cmVzOiA1NjEKPiBbMjAxMy0wNC0xNSAyMDo0Mzow
My44ODc2MzRdIFcgW2dsdXN0ZXJmc2QuYzo4MzE6Y2xlYW51cF9hbmRfZXhpdF0gKC0tPi9saWI2
NC9saWJjLnNvLjYoY2xvbmUrMHg2ZCkgWzB4M2JkMTZlNzY3ZF0gKC0tPi9saWI2NC9saWJwdGhy
ZWFkLnNvLjAoKSBbMHgzYmQxYTA3ODUxXSAoLS0+L3Vzci9zYmluL2dsdXN0ZXJmcyhnbHVzdGVy
ZnNfc2lnd2FpdGVyKzB4ZGQpIFsweDQwNWM5ZF0pKSkgMC06IHJlY2VpdmVkIHNpZ251bSAoMTUp
LCBzaHV0dGluZyBkb3duCj4gWzIwMTMtMDQtMTUgMjA6NDM6MDMuODg3ODc4XSBFIFtycGNzdmMu
YzoxMTU1OnJwY3N2Y19wcm9ncmFtX3VucmVnaXN0ZXJfcG9ydG1hcF0gMC1ycGMtc2VydmljZTog
Q291bGQgbm90IHVucmVnaXN0ZXIgd2l0aCBwb3J0bWFwCj4gCgpXZSdsbCB0YWtlIGEgbG9vaywg
dGhhbmtzLgoKR29pbmcgZm9yd2FyZCwgY291bGQgSSBhc2sgdGhhdCB5b3UgdGFrZSBhIGZldyBt
aW51dGVzIHRvIGJhdGNoIHVwIHRoZSBpbmZvcm1hdGlvbiwgcmF0aGVyIHRoYW4gc2VuZGluZyBz
ZXZlcmFsIGVtYWlscyBpbiBhIHJvdz8gIEl0IG1ha2VzIGl0IG11Y2ggaGFyZGVyIHRvIGNvbGxl
Y3QgdGhlIGluZm9ybWF0aW9uIHdoZW4gaXQncyBzcHJlYWQgYWNyb3NzIHNvIG1hbnkgZW1haWxz
LgoKVGhhbmtzLAotRXJpYwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
