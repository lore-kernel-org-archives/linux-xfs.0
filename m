Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n621qPsu054394 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 20:52:26 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 241089BDA0A
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 18:59:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id usLwxTjb8G11Ft8E for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2009 18:59:19 -0700 (PDT)
Date: Wed, 1 Jul 2009 21:52:36 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <584076313.830951246499556455.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <824092896.830901246499419777.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

QWxleGFuZGVyLAoKQXJlIHlvdSBydW5uaW5nIHdpdGggdGhpcyBmaXg/CgpodHRwOi8vZ2l0Lmtl
cm5lbC5vcmcvP3A9bGludXgva2VybmVsL2dpdC9zdGFibGUvbGludXgtMi42LjI5LnkuZ2l0O2E9
Y29tbWl0ZGlmZjtoPWQ0MTU4NjdlMGFiYzM1ZTNiMmYwZDQxOTZlOThjMzM5ZDZmZTI5YTIKCkkn
dmUgc2VlbiB0aGlzIGFzc2VydGlvbiBiZWZvcmUgYW5kIHRoZSBhYm92ZSBwYXRjaCBmaXhlZCBp
dApmb3IgbWUuICBIbW1tLCBsb29rcyBsaWtlIHlvdSdyZSBydW5uaW5nIGEgcmVjZW50IGtlcm5l
bCBzbwp5b3Ugc2hvdWxkIGhhdmUgdGhpcyBmaXggLSBtYXliZSB0aGUgZml4IHdhc24ndCBxdWl0
ZSByaWdodC4KCkxhY2hsYW4KCgotLS0tLSAiQWxleGFuZGVyIEJlcmVnYWxvdiIgPGEuYmVyZWdh
bG92QGdtYWlsLmNvbT4gd3JvdGU6Cgo+IDIwMDkvNi81IEFsZXhhbmRlciBCZXJlZ2Fsb3YgPGEu
YmVyZWdhbG92QGdtYWlsLmNvbT46Cj4gPiAyMDA5LzYvNCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+Ogo+ID4+IE9uIE1vbiwgSnVuIDAxLCAyMDA5IGF0IDA3OjIyOjU2UE0gKzA0
MDAsIEFsZXhhbmRlciBCZXJlZ2Fsb3YKPiB3cm90ZToKPiA+Pj4gSGkKPiA+Pj4KPiA+Pj4gQXNz
ZXJ0aW9uIGZhaWxlZDogKm5tYXAgPj0gMSwgZmlsZTogZnMveGZzL3hmc19ibWFwLmMsIGxpbmU6
IDQ4NDYKPiA+PiAuLi4uLgo+ID4+PiBDYWxsIFRyYWNlOgo+ID4+PiDCoFs8ZmZmZmZmZmY4MDNk
NmJhZD5dIHhmc19ibWFwaSsweGFkLzB4MWFkMAo+ID4+PiDCoFs8ZmZmZmZmZmY4MDNlZTVjMD5d
IHhmc19kaXIyX2xlYWZfZ2V0ZGVudHMrMHg2NDAvMHg3YjAKPiA+Pj4gwqBbPGZmZmZmZmZmODAz
ZTk3NWM+XSB4ZnNfcmVhZGRpcisweDEyYy8weDE0MAo+ID4+PiDCoFs8ZmZmZmZmZmY4MDQzMGI1
Nz5dIHhmc19maWxlX3JlYWRkaXIrMHg0Ny8weDcwCj4gPj4+IMKgWzxmZmZmZmZmZjgwMmVjNTAw
Pl0gdmZzX3JlYWRkaXIrMHhkMC8weGYwCj4gPj4+IMKgWzxmZmZmZmZmZjgwMmVjNmI2Pl0gc3lz
X2dldGRlbnRzKzB4OTYvMHgxMTAKPiA+Pj4gwqBbPGZmZmZmZmZmODAyMGJhNmI+XSBzeXN0ZW1f
Y2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKPiA+Pgo+ID4+IEknZCBzYXkgdGhpcyBpbmRpY2F0ZXMg
YSBjb3JydXB0ZWQgZGlyZWN0b3J5LiDCoENhbiB5b3UgcnVuCj4gPj4gJ3hmc19yZXBhaXIgLW4n
IG92ZXIgdGhlIGZpbGVzeXN0ZW0gYW5kIHNlZSBpZiBpdCBmaW5kcyBhIGJhZAo+ID4+IGRpcmVj
dG9yeT8KPiAKPiBTdGlsbCBjYW5ub3QgZml4IHRoZSBmaWxlc3lzdGVtLiBBZnRlciByZXBhaXJp
bmcgYWxsIGNvcnJ1cHRpb25zIGZyb20KPiBMaXZlQ0QgaXQgc3RpbGwgZmFpbHMgb24gdGhlIHNh
bWUgd29ya2xvYWQuCj4gCj4gRG8geW91IG5lZWQgbWV0YWR1bXAgb3IgYW55dGhpbmcgZWxzZT8K
PiAKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IHhm
cyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3NzLnNnaS5jb20KPiBodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
