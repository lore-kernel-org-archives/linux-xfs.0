Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E2EE27F3F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 09:33:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA4258F804B
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 07:33:30 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id qB8RahUQDzgBHCZg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 07:33:28 -0700 (PDT)
Received: from mail.zbfmail.de (localhost [127.0.0.1])
	by mail.zbfmail.de (Postfix) with ESMTP id EAD271BE46E
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 16:33:21 +0200 (CEST)
MIME-Version: 1.0
Date: Sat, 13 Sep 2014 16:33:21 +0200
From: Marko Weber|8000 <weber@zbfmail.de>
Subject: unclean shutdown of usb hdd destroyed xfs partially
Message-ID: <3999c95c0dc7ebfdfbb2853a6d13f7dc@zbfmail.de>
Reply-To: weber@zbfmail.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xfs <xfs@oss.sgi.com>

CmhlbGxvIGRhdmUgaGVsbG8gbGlzdCwKCmFuIHVuY2xlYW4gc2h1dGRvd24gb24gb2YgbXkgYm94
ZXMgbWFkZSB0aGUgeGZzIHBhcnRpYWxseSBjb3JydXB0LgoKaSB0cmllZCBhbiB4ZnNfcmVwYWly
IHdpdGggeGZzcHJvZ3MgMy4xLjEwCnRoZW4gaSByZWFkIHRoZSBjb3JydXB0IGRhdGEgdGhyZWFk
IGFuZCB0cmllZCBpdCB3aXRoIDMuMi4xIHZlcnNpb24gb2YgCnhmc3Byb2dzLgoKd2hlbiBpIG1v
dW50IHRoZSBwYXJ0aXRpb24gYW5kIGRvIGFuIGxzIC1sIGkgZ2V0OgoKICAjIGxzIC1sIC9tbnQv
dGVtcApsczogWnVncmlmZiBhdWYgL21udC90ZW1wL3NlcmllbiBuaWNodCBtw7ZnbGljaDogRGll
IFN0cnVrdHVyIG11c3MgCmJlcmVpbmlndCB3ZXJkZW4KbHM6IFp1Z3JpZmYgYXVmIC9tbnQvdGVt
cC9kb2t1dHYgbmljaHQgbcO2Z2xpY2g6IERpZSBTdHJ1a3R1ciBtdXNzIApiZXJlaW5pZ3Qgd2Vy
ZGVuCmluc2dlc2FtdCAwCj8/Pz8/Pz8/Pz8gID8gPyAgICAgPyAgICAgICAgICAgID8gICAgICAg
ICAgICAgPyBkb2t1dHYKZHJ3eHJ3eHIteCAzMyB3ZWJlciBtZWRpYXRvbWIgMTI4MyAyNS4gQXVn
IDIwMTMgIG1vdmllcwpkcnd4cnd4ci14IDEyIHdlYmVyIG1lZGlhdG9tYiAgMTUxICA2LiBBdWcg
MTg6NTcgbXAzCj8/Pz8/Pz8/Pz8gID8gPyAgICAgPyAgICAgICAgICAgID8gICAgICAgICAgICAg
PyBzZXJpZW4KCnRoZSBhYm92ZSBsaW5lcyB3aXRoIGxzIHNheXMgImFjY2VzcyBub3QgcG9zc2li
bGUgb24gc2VyaWVuIGFuZCBkb2t1dHYsIApzdHJ1Y3R1cmUgbmVlZHMgY2xlYW5pbmcuCgpUaGlz
IGlzIGFsc28gYWZ0ZXIgYW4geGZzX3JlcGFpciAtTCAvZGV2L3NkZTEKCmlzIHRoZXJlIGFueSB0
cmljayB0byBnZXQgdGhlIGRhdGEgYWNjZXNzYWJsZSBhZ2Fpbj8KCnRoYW5rcyBmb3IgYW55IGhp
bnRzIG9yIGhlbHAKCm1hcmtvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
