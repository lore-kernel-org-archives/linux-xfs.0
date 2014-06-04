Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CDA07F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 23:57:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC47E8F8074
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 21:57:41 -0700 (PDT)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id S65XdZCIH2fxdB1V (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 21:57:40 -0700 (PDT)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N6M00BYQOG1CAD0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 04 Jun 2014 13:57:37 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
	<alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
	<000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
	<alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
	<002201cf7e59$2e684c10$8b38e430$@samsung.com>
	<alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
	<20140602150258.GG30598@thunk.org>
In-reply-to: <20140602150258.GG30598@thunk.org>
Subject: RE: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Wed, 04 Jun 2014 13:57:37 +0900
Message-id: <000e01cf7fb1$814ab6d0$83e02470$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Theodore Ts'o' <tytso@mit.edu>, 'Dave Chinner' <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, =?UTF-8?Q?'Luk=C3=A1=C5=A1_Czerner'?= <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

PiBPbiBNb24sIEp1biAwMiwgMjAxNCBhdCAwMzowNjoxM1BNICswMjAwLCBMdWvDocWhIEN6ZXJu
ZXIgd3JvdGU6Cj4gPiA+ID4gU28gd2hhdCB3aWxsIGhhcHBlbiB3aGVuIHRoZXJlIGlzIG5vdCBl
bm91Z2ggc3BhY2Ugd2hlbiAiaW5zZXJ0aW5nIGEKPiA+ID4gPiByYW5nZSIgPyBBbmQgaG93IHNo
b3VsZCB1c2VyIHByb2NlZWQgZnJvbSB0aGVyZSA/Cj4gPiA+IElmIGluc2VydCByYW5nZSBmYWls
cyB3aXRoIGFuIEVOT1NQQyBlcnJvciwgdXNlciBjb3VsZCB1c2UgY29sbGFwc2UKPiA+ID4gcmFu
Z2Ugb24gdGhlIHNhbWUgcmFuZ2UgdG8gcmVtb3ZlIHRoZSBob2xlLgo+ID4gPiBBbmQgYWZ0ZXIg
ZnJlZWluZyBtb3JlIHNwYWNlLCBoZSBjYW4gYWdhaW4gdHJ5IGluc2VydGluZyByYW5nZS4KPiA+
ID4gT2Zjb3Vyc2UsIHRoaXMgdHlwZSBvZiBndWlkYW5jZSBzaG91bGQgYmUgcHJvcGVybHkgZG9j
dW1lbnRlZCBpbgo+ID4gPiBtYW5wYWdlLiBXaGVuIHVwZGF0aW5nIGZhbGxvY2F0ZSgyKSBtYW5w
YWdlLCBJIHdpbGwga2VlcCAgaW4gbWluZCB0bwo+ID4gPiBkZXNjcmliZSBFTk9TUEMgaGFuZGxp
bmcuCj4gPgo+ID4gV2h5IGNvbGxhcHNlID8gVGhlIGhvbGUgaXMgYWxyZWFkeSB0aGVyZSByaWdo
dCA/IFdoeSBub3QganVzdCB1c2UKPiA+IGZhbGxvY2F0ZSB0byBhbGxvY2F0ZSB0aGUgc3BhY2Ug
Zm9yIHRoZSBob2xlLiBBbmQgdGhhdCdzIG15IHBvaW50Cj4gPiBhY3R1YWxseS4gV2h5IG5vdCBk
byBpdCB0aGlzIHdheSBpbiB0aGUgZmlyc3QgcGxhY2UsIGJlY2F1c2UgdGhpcyBpcwo+ID4gcmVh
bGx5IGNvdW50ZXJpbnR1aXRpdmUuCj4gCj4gSXQncyB3b3JzZSB0aGFuIHRoYXQuICBJdCdzIHBv
c3NpYmxlIHRoYXQgdGhlIHJlYXNvbiB3aHkgeW91IGdvdCB0aGUKPiBFTk9TUEMgd2FybmluZyB3
YXMgYmVjYXVzZSB0aGUgb3BlcmF0aW9uIHRvIG1vdmUgdGhlIGV4dGVudHMgZG93bgo+IHJlcXVp
cmVkIGFsbG9jYXRpbmcgYSBibG9jaywgYW5kIGl0IHdhcyAqdGhhdCogYmxvY2sgYWxsb2NhdGlv
biB3aGljaAo+IGZhaWxlZC4gIFNvIGl0J3Mgbm90IGRldGVybWluaXN0aWMgd2hldGhlciBvciBu
b3QgdGhlIGZpbGUncyBleHRlbnQKPiBtYXBwaW5ncyB3ZXJlIG1vZGlmaWVkIGFmdGVyIGEgRU5P
U1BDIGVycm9yLCBhbmQgc28gaXQncyBub3QgY2xlYXIKPiB3aGV0aGVyIG9yIG5vdCBhIGNvbGxh
cHNlX3JhbmdlIGZ1bmN0aW9uIHdpbGwgdW5kbyB0aGUgcmFuZ2UgdGhhdCBoYWQKPiBiZWVuIGlu
c2VydGVkIC0tLSBvciB3aGV0aGVyIGl0IGVuZHMgdXAgZGVsZXRpbmcgZXhpc3RpbmcgZGF0YSBi
bG9ja3MuCj4gCj4gSW4gZ2VuZXJhbGx5LCB5b3UgcmVhbGx5IHdhbnQgc3lzdGVtIGNhbGxzIHRv
IGhhdmUgYWxsLW9yLW5vdGhpbmcKPiBlZmZlY3RzLCB3aGVyZSBpZiB0aGUgc3lzdGVtIGNhbGwg
cmV0dXJucyBhbiBlcnJvciwgdGhlIHN0YXRlIG9mIHRoZQo+IGZpbGUgaGFzIG5vdCBiZWVuIGNo
YW5nZWQuICBBbmQgZm9yIHRoYXQgcmVhc29uLCBJIGFncmVlIHdpdGggTHVrw6HFoQo+IHRoYXQg
aXQgaXMgcmVhbGx5IGEgZ29vZCBpZGVhIHRvIGRlY291cGxlIG1vdmluZyB0aGUgYmxvY2tzIGRv
d24sIGFuZAo+IGFsbG9jYXRpbmcgc3BhY2UgLS0tIGFuZCB0byBtYWtlIHN1cmUgdGhhdCBpZiB0
aGVyZSBpcyBhbnkgZmFpbHVyZQo+IHdoaWxlIGluc2VydGluZyB0aGUgcmFuZ2UsIHRoZSBzdGF0
ZSBvZiB0aGUgZmlsZSBpcyBub3QgbW9kaWZpZWQgYXQgYWxsLgpPa2F5LCBJIHdpbGwgcmVtb3Zl
IGFsbG9jYXRpbmcgc3BhY2UgcGFydCBpbiBpbnNlcnQgcmFuZ2UgcGF0Y2guCkJ1dCByZW5hbWlu
ZyBmbGFncyBhcyBGQUxMT0NfRkxfSU5TRVJUX0hPTEUgaXMgbmVlZGVkIHRvIGNvbmNlbnQgd2l0
aApYRlMgcGVvcGxlLiBCZWNhdXNlIERhdmUgcHJlZmVyZWQgdG8gY2FsbCBpdCBGQUxMT0NfRkxf
SU5TRVJUX1JBTkdFCnNvIHRoYXQgaXQgbG9va3MgbGlrZSBpdCBpcyByZWxhdGVkIHRvIGNvbGxh
cHNlIHJhbmdlLgoKSGkgRGF2ZS4KRG8geW91IGhhdmUgYW55IG9iamVjdGlvbiBhYm91dCByZW5h
bWluZyBhcyBpbnNlcnQgaG9sZSA/CgpUaGFua3MgZm9yIG9waW5pb25zIQoKPiAKPiBDaGVlcnMs
Cj4gCj4gCQkJCQktIFRlZAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
