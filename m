Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFCD27CA0
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 23:12:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94283304032
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 21:12:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TFcTfSJCaG17E49D for <xfs@oss.sgi.com>;
	Fri, 08 Apr 2016 21:12:13 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 142EE56A
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 23:12:13 -0500 (CDT)
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5708811C.5090909@sandeen.net>
Date: Fri, 8 Apr 2016 23:12:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
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

CgpPbiA0LzgvMTYgOTo1OCBBTSwgSmFuIFR1bGFrIHdyb3RlOgo+ICAgICBUaGlzIG9uZSBjYXVz
ZXMgYXQgbGVhc3Qgb25lIGludGVyZXN0aW5nIGlzc3VlOgo+IAo+ICAgICAjbWtmcy9ta2ZzLnhm
cwo+ICAgICBFcnJvciBhY2Nlc3Npbmcgc3BlY2lmaWVkIGRldmljZSAobnVsbCk6IEJhZCBhZGRy
ZXNzCj4gICAgIFVzYWdlOiBta2ZzLnhmcwo+ICAgICAuLi4KPiAKPiAgICAgYmVjYXVzZToKPiAK
PiAgICAgICAgICAgICBjaGVja19kZXZpY2VfdHlwZShkZmlsZSwgJnhpLmRpc2ZpbGUsICFkc2l6
ZSwgIWRmaWxlLAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE5mbGFnID8gTlVMTCA6
ICZ4aS5kY3JlYXQsIGZvcmNlX292ZXJ3cml0ZSwgImQiKTsKPiAKPiAgICAgc28gImRmaWxlIiBj
YW4gYmUgTlVMTCwgYnV0IHRoYXQgZnVuY3Rpb24gaW1tZWRpYXRlbHkgdHJpZXMgdG8gc3RhdCBp
dC4KPiAKPiAKPiDigItBIHNpbXBsZSBpZiBOVUxMLCB0aGVuIHVzYWdlKCkgc2hvdWxkIHRha2Ug
Y2FyZSBvZiB0aGlzLi4uCgpXZWxsLCB0aGluayBoYXJkIGFib3V0IHRoYXQuICBJZiBkZmlsZSA9
PSBOVUxMIGFuZCBiYWlscyB3aXRoIHVzYWdlKCksIHRoZW4Kd2hhdCBpcyB0aGUgcG9pbnQgb2Yg
aGF2aW5nICFkZmlsZSBhcyBhIGZ1bmN0aW9uIGFyZ3VtZW50PwoKVmFsaWRhdGlvbiBvZiBoYXZp
bmcgYSB0YXJnZXQgc3BlY2lmaWVkIGFzIGVpdGhlciAtZGZpbGU9IG9yIGFzIHRoZSBsYXN0IGFy
Z3VtZW50CnNob3VsZCBwcm9iYWJseSBoYXBwZW4gYmVmb3JlIHRoZSBjYWxsIHRvIGNoZWNrX2Rl
dmljZV90eXBlLgoKLUVyaWMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
