Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 508AF7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 10:08:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 244F88F8035
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 08:08:05 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id g6JQIJaP5oMaemXb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 08:08:04 -0700 (PDT)
Date: Mon, 24 Aug 2015 17:08:08 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
Message-ID: <20150824170808.4129dcec@harpe.intellique.com>
In-Reply-To: <CAJtCNH1EyP6d+rGeJRzaAx7Mh+s89hEudDbfbwofYK_tJD6x4A@mail.gmail.com>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
	<CAJtCNH1EyP6d+rGeJRzaAx7Mh+s89hEudDbfbwofYK_tJD6x4A@mail.gmail.com>
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
To: Mukul Malhotra <smilemukul2005@gmail.com>
Cc: xfs@oss.sgi.com

TGUgTW9uLCAyNCBBdWcgMjAxNSAxMDoxNDo1MiArMDUzMApNdWt1bCBNYWxob3RyYSA8c21pbGVt
dWt1bDIwMDVAZ21haWwuY29tPiDDqWNyaXZhaXQ6Cgo+IEhpLAo+IAo+IEkgaGF2ZSBiZWxvdyBx
dWVyaWVzIG9uIFhGUyBsb2cgZGV2aWNlIGFzLAo+IAo+IDEuIEFmdGVyIGNyZWF0aW5nIGEgWEZT
IGZpbGVzeXN0ZW0gd2l0aCBhbiBleHRlcm5hbCBsb2cgZGV2aWNlCj4gKGpvdXJuYWwpLCBpcyB0
aGVyZSBhIHdheSB0byBtb3VudCB0aGUgZmlsZXN5c3RlbSBpZiBJIGxvc2UgdGhlCj4gZXh0ZXJu
YWwgbG9nIGRldmljZSBvciBhIHdheSB0byByZWNvdmVyIGZpbGVzPwoKWW91IGNhbiB1c2Ugc29t
ZSBvdGhlciBkZXZpY2UgdG8gaG9sZCB0aGUgbG9nLiBZb3UgY291bGQgdXNlIGEgcmFtZGlzaywK
YSBsb29wIGRldmljZSBwb2ludGluZyB0byBzb21lIGZpbGUsIGV0Yy4gTm8gcHJvYmxlbSBhcyBs
b25nIGFzIHlvdQp1bm1vdW50ZWQgdGhlIGZpbGVzeXN0ZW0gcHJvcGVybHkuCgo+IDIuIElzIHRo
ZXJlIGEgd2F5IHRvIGNvbnZlcnQgYW4gZXhpc3RpbmcgWEZTIGZpbGVzeXN0ZW0gd2hpY2ggaGFz
Cj4gaW50ZXJuYWwgbG9nIHRvIGV4dGVybmFsIGxvZyBhbmQgdmljZSB2ZXJzYS4KPgoKQXBwYXJl
bnRseSBuby4geGZzX2dyb3dmcyBzaG91bGQgYmUgYWJsZSB0byBkbyBpdCwgYnV0IHRoZSBtYW4g
cGFnZQpzdGF0ZXMgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIG5vdCBpbXBsZW1lbnRlZC4KCi0tIAot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1
ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAg
fAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEg
NzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
