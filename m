Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B00C57F4E
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 06:07:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E6308F8049
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 04:07:14 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id s5t3wGpGw0OFLhG8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2014 04:07:12 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 90CDCD48015
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 13:05:35 +0100 (CET)
Date: Mon, 15 Dec 2014 13:07:15 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141215130715.4dfaaa8e@harpe.intellique.com>
In-Reply-To: <20141211123936.1f3d713d@harpe.intellique.com>
References: <20141211123936.1f3d713d@harpe.intellique.com>
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

TGUgVGh1LCAxMSBEZWMgMjAxNCAxMjozOTozNiArMDEwMApFbW1hbnVlbCBGbG9yYWMgPGVmbG9y
YWNAaW50ZWxsaXF1ZS5jb20+IMOpY3JpdmFpdDoKCj4gV2hhdCBoYXBwZW5zOiB3aGlsZSB0aGUg
YXJyYXkgaXMgcmVidWlsZGluZywgc2ltdWx0YW5lb3VzbHkgcmVhZGluZwo+IGFuZCB3cml0aW5n
IGlzIGEgc3VyZSB3YXkgdG8gYnJlYWsgdGhlIGZpbGVzeXN0ZW0gYW5kIGF0IHRpbWVzLAo+IGNv
cnJ1cHQgZGF0YS4KPiAKCkkndmUgcmVydW4gdGhlIHNhbWUgdGVzdCAoaGVhdnkgcmVhZC93cml0
ZSBJTyB3aGlsZSByZWJ1aWxkaW5nKSB3aXRoCmRpc2sgZHJpdmVzIHdyaXRlIGNhY2hlIG9mZiAo
dGhhdCBpcyBSQUlEIGNvbnRyb2xsZXIgaXMgcnVubmluZwppbiB3cml0ZS1iYWNrIG1vZGUsIGJ1
dCB0aGUgaW5kZXBlbmRhbnQgZGlza3MgY2FjaGVzIGFyZSBzZXQgdG8Kd3JpdGUtdGhyb3VnaCku
CgpUaGUgZmlsZXN5c3RlbSB3ZW50IGNvcnJ1cHRlZCB0b28sIGhvd2V2ZXIgbXVjaCBsZXNzIHRo
YW4gcHJldmlvdXNseToKaXQgd2VudCBiYWNrIHVwIG9ubGluZSBhZnRlciBhIHVtb3VudC9tb3Vu
dCBjeWNsZS4gTm90aGluZyBhdCBhbGwKYXBwZWFycyBpbiB4ZnNfcmVwYWlyIG91dHB1dC4gSG93
ZXZlciB0aGUgSU8gZXJyb3IgaXMgd2VpcmQgYXMgdGhlIFJBSUQKY29udHJvbGxlciByZXBvcnRl
ZCBubyBzdWNoIGVycm9yLgoKCkRlYyAxMiAwMDo0MDoxOCBURVNULUFEQVBURUMga2VybmVsOiBY
RlMgKGRtLTApOiB4ZnNfZG9fZm9yY2Vfc2h1dGRvd24oMHgxKSBjYWxsZWQgZnJvbSBsaW5lIDM4
MyBvZiBmaWxlIGZzL3hmcy94ZnNfdHJhbnNfYnVmLmMuICBSZXR1cm4gYWRkcmVzcyA9IDB4ZmZm
ZmZmZmY4MTI1Y2M5MApEZWMgMTIgMDA6NDA6MzEgVEVTVC1BREFQVEVDIGtlcm5lbDogWEZTIChk
bS0wKTogeGZzX2xvZ19mb3JjZTogZXJyb3IgNSByZXR1cm5lZC4KRGVjIDEyIDAwOjQxOjAyIFRF
U1QtQURBUFRFQyBrZXJuZWw6IFhGUyAoZG0tMCk6IHhmc19sb2dfZm9yY2U6IGVycm9yIDUgcmV0
dXJuZWQuCgoKU3RpbGwgaW52ZXN0aWdhdGluZy4uLgoKLS0gCi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpFbW1h
bnVlbCBGbG9yYWMgICAgIHwgICBEaXJlY3Rpb24gdGVjaG5pcXVlCiAgICAgICAgICAgICAgICAg
ICAgfCAgIEludGVsbGlxdWUKICAgICAgICAgICAgICAgICAgICB8CTxlZmxvcmFjQGludGVsbGlx
dWUuY29tPgogICAgICAgICAgICAgICAgICAgIHwgICArMzMgMSA3OCA5NCA4NCAwMgotLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwo=
