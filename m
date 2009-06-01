Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51HbqVH025820 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 12:37:52 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F5AE2C2B82
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 10:38:08 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	6DIUmbS94EKvd86Y for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2009 10:38:08 -0700 (PDT)
Received: by fxm25 with SMTP id 25so7279684fxm.20
	for <xfs@oss.sgi.com>; Mon, 01 Jun 2009 10:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B5660F1A-7940-4E4A-92E8-8C0F93C274BD@sgi.com>
References: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
	<B5660F1A-7940-4E4A-92E8-8C0F93C274BD@sgi.com>
Date: Mon, 1 Jun 2009 21:38:07 +0400
Message-ID: <a4423d670906011038qd809ebay22aebca5aaf271a4@mail.gmail.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com

MjAwOS82LzEgRmVsaXggQmx5YWtoZXIgPGZlbGl4YkBzZ2kuY29tPjoKPgo+IE9uIEp1biAxLCAy
MDA5LCBhdCAxMDoyMiBBTSwgQWxleGFuZGVyIEJlcmVnYWxvdiB3cm90ZToKPgo+PiBIaQo+Pgo+
PiBBc3NlcnRpb24gZmFpbGVkOiAqbm1hcCA+PSAxLCBmaWxlOiBmcy94ZnMveGZzX2JtYXAuYywg
bGluZTogNDg0Ngo+Cj4gQWxleGFuZGVyLCB3aGF0IHRlc3QgdHJpZ2dlcmVkIHRoaXMgYXNzZXJ0
aW9uPwo+Cj4+Cj4+IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQo+PiBrZXJu
ZWwgQlVHIGF0IGZzL3hmcy9zdXBwb3J0L2RlYnVnLmM6MTA5IQo+PiBpbnZhbGlkIG9wY29kZTog
MDAwMCBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwo+PiBsYXN0IHN5c2ZzIGZpbGU6
IC9zeXMva2VybmVsL3VldmVudF9zZXFudW0KPj4gQ1BVIDAKPj4gTW9kdWxlcyBsaW5rZWQgaW46
Cj4+IFBpZDogMzA2NjUsIGNvbW06IGVtZXJnZSBOb3QgdGFpbnRlZCAyLjYuMzAtcmM2LTAwMTQ0
LWc1ODA1OTc3ICMxCj4+IFBvd2VyRWRnZSAxOTUwCj4+IFJJUDogMDAxMDpbPGZmZmZmZmZmODA0
M2FiZWI+XSDCoFs8ZmZmZmZmZmY4MDQzYWJlYj5dIGFzc2ZhaWwrMHgyYi8weDMwCj4+IFJTUDog
MDAxODpmZmZmODgwMDMwM2MxYjk4IMKgRUZMQUdTOiAwMDAxMDI0Ngo+PiBSQVg6IDAwMDAwMDAw
MDAwMDAwNTQgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDAwMDAwMDAwMDMwMQo+PiBS
RFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAwMDAwMDAwMDAwMDAxIFJESTogMDAwMDAwMDAw
MDAwMDAwMQo+PiBSQlA6IGZmZmY4ODAwMzAzYzFiYTggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIw
OTogMDAwMDAwMDAwMDAwMDAwMAo+PiBSMTA6IDAwMDAwMDAwMDAwMDAwMDEgUjExOiAwMDAwMDAw
MDAwMDAwMDAxIFIxMjogMDAwMDAwMDgwMDAwMDAwMAo+PiBSMTM6IGZmZmY4ODAwNzhjMGNjYzAg
UjE0OiAwMDAwMDAwMDAwMDAwMDAyIFIxNTogZmZmZjg4MDA3ZWIzZjAwMAo+PiBGUzogwqAwMDAw
N2Y3ZTkyZGJjNmYwKDAwMDApIEdTOmZmZmY4ODAwMDUwMDAwMDAoMDAwMCkKPj4ga25sR1M6MDAw
MDAwMDAwMDAwMDAwMAo+PiBDUzogwqAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAw
MDA4MDA1MDAzMwo+PiBDUjI6IDAwMDAwMDAwMDFiMGEwMjQgQ1IzOiAwMDAwMDAwMDc0Y2IwMDAw
IENSNDogMDAwMDAwMDAwMDAwMDZlMAo+PiBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAw
MDAwMDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMAo+PiBEUjM6IDAwMDAwMDAwMDAwMDAw
MDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMAo+PiBQcm9jZXNz
IGVtZXJnZSAocGlkOiAzMDY2NSwgdGhyZWFkaW5mbyBmZmZmODgwMDMwM2MwMDAwLCB0YXNrCj4+
IGZmZmY4ODAwN2UzMzVlMTApCj4+IFN0YWNrOgo+PiBmZmZmODgwMDA1MWNlZmEwIDAwMDAwMDAw
NzgwZDg5YTMgZmZmZjg4MDAzMDNjMWQ4OCBmZmZmZmZmZjgwM2Q2YmFkCj4+IGZmZmZmZmZmODA0
YzlhZDggZmZmZmZmZmY4MTQ0OTdmOCBmZmZmODgwMDQ1YTcyMDAwIGZmZmY4ODAwNDVhNzJhYTgK
Pj4gZmZmZmZmZmY4MTQ0OTgwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDA3ODBkODlhMwo+PiBDYWxsIFRyYWNlOgo+PiBbPGZmZmZmZmZmODAzZDZiYWQ+XSB4ZnNf
Ym1hcGkrMHhhZC8weDFhZDAKPgo+IHhmc19ibWFwaSgpIGhlcmUgZG9lc24ndCBtYWtlIHNlbnNl
IGF0IGFsbC4KPiBVcCB0byB0aGlzIHBvaW50IHRoZSBzdGFjayBiYWNrdHJhY2Ugc2VlbXMgdG8g
YmUgcmlnaHQuCj4gU3RyYW5nZSAuLi4KCkl0IHdhcyBHZW50b28ncyBgZW1lcmdlIC0tbWV0YWRh
dGFgLiBJdCByZWFkcyBtYW55IHNtYWxsIGZpbGVzIChlYnVpbGRzKS4KSSBhbSBzdXJlIGl0IGNh
bm5vdCBiZSBlYXNpbHkgcmVwcm9kdWNlZC4KSXQgcnVucyBmaW5lIGV2ZXJ5ZGF5LiBJIGRvIG5v
dCBoYXZlIGEgdGVzdGNhc2UuCkkgY2FuIHRyeSB0byBydW4gaXQgZm9yZXZlciBpbiBsb29wIGlm
IHlvdSBuZWVkLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
