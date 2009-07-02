Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n62Ac65X081583 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 05:38:07 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94C6033A941
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2009 03:38:37 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	Oo3ZNDpq8OpckOyb for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2009 03:38:37 -0700 (PDT)
Received: by bwz10 with SMTP id 10so1317372bwz.20
	for <xfs@oss.sgi.com>; Thu, 02 Jul 2009 03:38:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <584076313.830951246499556455.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <824092896.830901246499419777.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<584076313.830951246499556455.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Date: Thu, 2 Jul 2009 14:38:36 +0400
Message-ID: <a4423d670907020338h430a4e53o2cf1b65d2ac14dfa@mail.gmail.com>
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

MjAwOS83LzIgTGFjaGxhbiBNY0lscm95IDxsbWNpbHJveUByZWRoYXQuY29tPjoKPiBBbGV4YW5k
ZXIsCj4KPiBBcmUgeW91IHJ1bm5pbmcgd2l0aCB0aGlzIGZpeD8KPgo+IGh0dHA6Ly9naXQua2Vy
bmVsLm9yZy8/cD1saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC0yLjYuMjkueS5naXQ7YT1j
b21taXRkaWZmO2g9ZDQxNTg2N2UwYWJjMzVlM2IyZjBkNDE5NmU5OGMzMzlkNmZlMjlhMgoKWWVz
LCBJIHVzZSAyLjYuMzEtcmMxLWdpdCBhbmQgaXQgY29udGFpbnMgdGhpcyBmaXguCj4KPiBJJ3Zl
IHNlZW4gdGhpcyBhc3NlcnRpb24gYmVmb3JlIGFuZCB0aGUgYWJvdmUgcGF0Y2ggZml4ZWQgaXQK
PiBmb3IgbWUuIMKgSG1tbSwgbG9va3MgbGlrZSB5b3UncmUgcnVubmluZyBhIHJlY2VudCBrZXJu
ZWwgc28KPiB5b3Ugc2hvdWxkIGhhdmUgdGhpcyBmaXggLSBtYXliZSB0aGUgZml4IHdhc24ndCBx
dWl0ZSByaWdodC4KPgo+IExhY2hsYW4KPgo+Cj4gLS0tLS0gIkFsZXhhbmRlciBCZXJlZ2Fsb3Yi
IDxhLmJlcmVnYWxvdkBnbWFpbC5jb20+IHdyb3RlOgo+Cj4+IDIwMDkvNi81IEFsZXhhbmRlciBC
ZXJlZ2Fsb3YgPGEuYmVyZWdhbG92QGdtYWlsLmNvbT46Cj4+ID4gMjAwOS82LzQgRGF2ZSBDaGlu
bmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPjoKPj4gPj4gT24gTW9uLCBKdW4gMDEsIDIwMDkgYXQg
MDc6MjI6NTZQTSArMDQwMCwgQWxleGFuZGVyIEJlcmVnYWxvdgo+PiB3cm90ZToKPj4gPj4+IEhp
Cj4+ID4+Pgo+PiA+Pj4gQXNzZXJ0aW9uIGZhaWxlZDogKm5tYXAgPj0gMSwgZmlsZTogZnMveGZz
L3hmc19ibWFwLmMsIGxpbmU6IDQ4NDYKPj4gPj4gLi4uLi4KPj4gPj4+IENhbGwgVHJhY2U6Cj4+
ID4+PiDCoFs8ZmZmZmZmZmY4MDNkNmJhZD5dIHhmc19ibWFwaSsweGFkLzB4MWFkMAo+PiA+Pj4g
wqBbPGZmZmZmZmZmODAzZWU1YzA+XSB4ZnNfZGlyMl9sZWFmX2dldGRlbnRzKzB4NjQwLzB4N2Iw
Cj4+ID4+PiDCoFs8ZmZmZmZmZmY4MDNlOTc1Yz5dIHhmc19yZWFkZGlyKzB4MTJjLzB4MTQwCj4+
ID4+PiDCoFs8ZmZmZmZmZmY4MDQzMGI1Nz5dIHhmc19maWxlX3JlYWRkaXIrMHg0Ny8weDcwCj4+
ID4+PiDCoFs8ZmZmZmZmZmY4MDJlYzUwMD5dIHZmc19yZWFkZGlyKzB4ZDAvMHhmMAo+PiA+Pj4g
wqBbPGZmZmZmZmZmODAyZWM2YjY+XSBzeXNfZ2V0ZGVudHMrMHg5Ni8weDExMAo+PiA+Pj4gwqBb
PGZmZmZmZmZmODAyMGJhNmI+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKPj4gPj4K
Pj4gPj4gSSdkIHNheSB0aGlzIGluZGljYXRlcyBhIGNvcnJ1cHRlZCBkaXJlY3RvcnkuIMKgQ2Fu
IHlvdSBydW4KPj4gPj4gJ3hmc19yZXBhaXIgLW4nIG92ZXIgdGhlIGZpbGVzeXN0ZW0gYW5kIHNl
ZSBpZiBpdCBmaW5kcyBhIGJhZAo+PiA+PiBkaXJlY3Rvcnk/Cj4+Cj4+IFN0aWxsIGNhbm5vdCBm
aXggdGhlIGZpbGVzeXN0ZW0uIEFmdGVyIHJlcGFpcmluZyBhbGwgY29ycnVwdGlvbnMgZnJvbQo+
PiBMaXZlQ0QgaXQgc3RpbGwgZmFpbHMgb24gdGhlIHNhbWUgd29ya2xvYWQuCj4+Cj4+IERvIHlv
dSBuZWVkIG1ldGFkdW1wIG9yIGFueXRoaW5nIGVsc2U/Cj4+Cj4+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+IHhmcyBtYWlsaW5nIGxpc3QKPj4geGZz
QG9zcy5zZ2kuY29tCj4+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo+
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
