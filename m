Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6EAF7F9A
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 00:45:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23F6DAC001
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 22:45:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0tbOunyi4HH0UdUf for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 22:45:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6vY5-0001m2-5R
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6vY5-0000ob-4g
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 15:45:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] dump: fix translation build errors
Date: Tue, 15 Jul 2014 15:45:06 +1000
Message-Id: <1405403106-3084-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1405403106-3084-1-git-send-email-david@fromorbit.com>
References: <1405403106-3084-1-git-send-email-david@fromorbit.com>
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

RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgoKVGhlIHRyYW5zbGF0aW9u
cyBmYWlsIHRvIGJ1aWxkIGJlY2F1c2Ugb2YgZHVwbGljYXRlIG1lc3NhZ2Ugc3RyaW5ncy4KUmVt
b3ZlIHRoZSBkdXBsaWNhdGUuCgpBbHNvLCBmaXggdGhlIG1pc3NpbmcgImxhbmd1YWdlIiB0YWcg
ZnJvbSB0aGUgZ2VybWFuIHRyYW5zbGF0aW9uLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVy
IDxkY2hpbm5lckByZWRoYXQuY29tPgotLS0KIHBvL2RlLnBvIHwgMTAgKy0tLS0tLS0tLQogcG8v
cGwucG8gfCAgOSAtLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDE4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3BvL2RlLnBvIGIvcG8vZGUucG8KaW5kZXggOGJk
ZDc1Ni4uNjJmYWNlOCAxMDA2NDQKLS0tIGEvcG8vZGUucG8KKysrIGIvcG8vZGUucG8KQEAgLTEw
LDYgKzEwLDcgQEAgbXNnc3RyICIiCiAiUE8tUmV2aXNpb24tRGF0ZTogMjAxMi0wOC0yOCAxMDo1
OCswMjAwXG4iCiAiTGFzdC1UcmFuc2xhdG9yOiBDaHJpcyBMZWljayA8Yy5sZWlja0B2b2xsYmlv
LmRlPlxuIgogIkxhbmd1YWdlLVRlYW06IEdlcm1hbiA8ZGViaWFuLWwxMG4tZ2VybWFuQGxpc3Rz
LmRlYmlhbi5vcmc+XG4iCisiTGFuZ3VhZ2U6IGRlXG4iCiAiTUlNRS1WZXJzaW9uOiAxLjBcbiIK
ICJDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLThcbiIKICJDb250ZW50LVRy
YW5zZmVyLUVuY29kaW5nOiA4Yml0XG4iCkBAIC0zNDcwLDE1ICszNDcxLDYgQEAgbXNnc3RyICJW
ZXJzdWNoLCAlcyBtaXQgwrtzdGF0wqsgYWJ6dWZyYWdlbiwgZmVobGdlc2NobGFnZW46ICVzXG4i
CiBtc2dpZCAiYXR0ZW1wdCB0byB0cnVuY2F0ZSAlcyBmYWlsZWQ6ICVzXG4iCiBtc2dzdHIgIlZl
cnN1Y2gsICVzIHp1IGvDvHJ6ZW4sIGZlaGxnZXNjaGxhZ2VuOiAlc1xuIgogCi0jOiAuLi8uL3Jl
c3RvcmUvY29udGVudC5jOjczMzcgLi4vLi9yZXN0b3JlL2NvbnRlbnQuYzo3NTg1Ci0jLCBjLWZv
cm1hdAotbXNnaWQgIiIKLSJhdHRlbXB0IHRvIHNldCBleHRlbmRlZCBhdHRyaWJ1dGVzICh4Zmxh
Z3MgMHgleCwgZXh0c2l6ZSA9IDB4JXgsIHByb2ppZCA9IDB4JSIKLSJ4KSBvZiAlcyBmYWlsZWQ6
ICVzXG4iCi1tc2dzdHIgIiIKLSJWZXJzdWNoLCBlcndlaXRlcnRlIEF0dHJpYnV0ZSAoeGZsYWdz
IDB4JXgsIGV4dHNpemUgPSAweCV4LCBwcm9qaWQgPSAweCV4KSAiCi0idm9uICVzIHp1IHNldHpl
biwgZmVobGdlc2NobGFnZW46ICVzXG4iCi0KICM6IC4uLy4vcmVzdG9yZS9jb250ZW50LmM6NzQ5
MyAuLi8uL3Jlc3RvcmUvY29udGVudC5jOjc3NjAKICMsIGMtZm9ybWF0CiBtc2dpZCAidW5hYmxl
IHRvIHNldCBhY2Nlc3MgYW5kIG1vZGlmaWNhdGlvbiB0aW1lcyBvZiAlczogJXNcbiIKZGlmZiAt
LWdpdCBhL3BvL3BsLnBvIGIvcG8vcGwucG8KaW5kZXggM2NlODIzZS4uNjJkZWU5YSAxMDA2NDQK
LS0tIGEvcG8vcGwucG8KKysrIGIvcG8vcGwucG8KQEAgLTM3NjYsMTUgKzM3NjYsNiBAQCBtc2dz
dHIgImNob3duICh1aWQ9JWQsIGdpZD0lZCkgJXMgbmllIHBvd2lvZMWCbyBzacSZOiAlc1xuIgog
bXNnaWQgImNobW9kICVzIGZhaWxlZDogJXNcbiIKIG1zZ3N0ciAiY2htb2QgJXMgbmllIHBvd2lv
ZMWCbyBzacSZOiAlc1xuIgogCi0jOiAuLi8uL3Jlc3RvcmUvdHJlZS5jOjI2MTYKLSMsIGMtZm9y
bWF0Ci1tc2dpZCAiIgotImF0dGVtcHQgdG8gc2V0IGV4dGVuZGVkIGF0dHJpYnV0ZXMgKHhmbGFn
cyAweCV4LCBleHRzaXplID0gMHgleCwgcHJvamlkID0gMHgiCi0iJXgpIG9mICVzIGZhaWxlZDog
JXNcbiIKLW1zZ3N0ciAiIgotInByw7NiYSB1c3Rhd2llbmlhIHJvenN6ZXJ6b255Y2ggYXRyeWJ1
dMOzdyAoeGZsYWdzIDB4JXgsIGV4dHNpemUgPSAweCV4LCAiCi0icHJvamlkID0gMHgleCkgJXMg
bmllIHBvd2lvZMWCYSBzacSZOiAlc1xuIgotCiAjOiAuLi8uL3Jlc3RvcmUvdHJlZS5jOjI2NDMK
ICMsIGMtZm9ybWF0CiBtc2dpZCAidW5hYmxlIHRvIHJtZGlyICVzOiBub3QgZW1wdHlcbiIKLS0g
CjIuMC4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
