Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0F4A7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 14:35:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1B10304032
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 12:35:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EyGCBE0Hm7yG8eki for <xfs@oss.sgi.com>;
	Tue, 23 Dec 2014 12:35:18 -0800 (PST)
Date: Wed, 24 Dec 2014 07:35:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: weird quota issue
Message-ID: <20141223203515.GD4521@dastard>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
	<20141223024248.GC4521@dastard> <201412230819.20935.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201412230819.20935.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gVHVlLCBEZWMgMjMsIDIwMTQgYXQgMDg6MTk6MjBBTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIFR1ZXNkYXkgMjMgb2YgRGVjZW1iZXIgMjAxNCwgRGF2ZSBDaGlu
bmVyIHdyb3RlOgo+ID4gT24gVHVlLCBEZWMgMjMsIDIwMTQgYXQgMDI6MTI6MTVBTSArMDAwMCwg
V2ViZXIsIENoYXJsZXMgKE5JSC9OSUEvSVJQKSBbRV0gCj4gd3JvdGU6Cj4gPiA+IGhlcmUgeW91
IGdvCj4gPiA+IAo+ID4gPiAjIHhmc19kYiAtYyAiaW5vZGUgMTMxIiAtYyBwIC9kZXYvZG0tNwo+
ID4gCj4gPiBOb3RoaW5nIG9idmlvdXNseSB3cm9uZyB0aGVyZSwgc28gdGhlcmUncyBubyBjbGVh
ciBpbmRpY2F0aW9uIG9mIHdoeQo+ID4gdGhlIHF1b3RhIGluaXRpYWxpc2F0aW9uIGZhaWxlZC4K
PiAKPiBncXVvdGlubyBzaG91bGQgYmUgc2V0IHRvIG51bGwsIHNldHRpbmcgaXQgdmlhIHhmc19k
YiBzaG91bGQgZml4IHRoZSBwcm9ibGVtCgojIHVtb3VudCAvZGV2L2RtLTcKIyB4ZnNfZGIgLXgg
LWMgInNiIDAiIC1jICJ3cml0ZSBncXVvdGlubyAtMSIgL2Rldi9kbS03Cgo+ID4gdXF1b3Rpbm8g
PSAxMzEKPiA+IGdxdW90aW5vID0gMAo+ID4gcWZsYWdzID0gMAo+IAo+IE90aGVyd2lzZSB3ZSBl
bmQgdXAgd2l0aCBteSBsYXN0IHByb2JsZW0KPiAKPiBodHRwOi8vb3NzLnNnaS5jb20vYXJjaGl2
ZXMveGZzLzIwMTQtMDcvbXNnMDAxMjEuaHRtbAo+IAo+ICItIDMuMTAga2VybmVsIGlzIG5vdCBh
YmxlIHRvIGhhbmRsZSBjYXNlIHdoZW4gdXF1b3Rpbm8gPT0gdmFsdWUsIGdxdW90aW5vID09IAo+
IDAuIEZvciAzLjEwIHRoaXMgY2FzZSBpcyBpbXBvc3NpYmxlIC8gc2hvdWxkIG5ldmVyIGhhcHBl
bi4gMy4xMCBleHBlY3RzIAo+ICh1cXVvdGlubyA9PSB2YWx1ZSwgZ3F1b3Rpbm8gPT0gbnVsbCkg
b3IgKHVxdW90aW5vID09IHZhbHVlLCBncXVvdGlubyA9PSAKPiBvdGhlcnZhbHVlKSBvciAodXFv
dGluZm8gPT0gbnVsbCwgZ3J1b3Rpbm8gPT0gdmFsdWUpIG9ubHkuIgo+IAo+IFNvIEkgZ3Vlc3Mg
Mi42LjMyIGlzIGRvaW5nIHRoZSBzYW1lLgoKRXhjZXB0IHRoYXQgdGhlIHByb2JsZW0geW91IHNh
dyByZXF1aXJlZCBydW5uaW5nIGEgMy4xNiBrZXJuZWwgdG8KdHJpZ2dlciB0aGUgdW5oYW5kbGVk
IHN0YXRlLiBJIGNhbid0IHNlZSB3aHkgYSBzeXN0ZW0gb25seSBydW5uaW5nCmEgMi42LjMyIGtl
cm5lbCB3b3VsZCBldmVyIGdldCBpbnRvIHRoaXMgc3RhdGUuLi4uCgo+IEFGQUlLIHhmc19yZXBh
aXIgZG9lc24ndCBmaXggdGhpcyBpc3N1ZS4gTm90IHN1cmUuCgpDZXJ0YWlubHkgbm90IHRoZSBv
bmUgdGhhdCBjb21lcyB3aXRoIGNlbnRvcyA2IC0gMCBhbmQgTlVMTCBhcmUgYm90aAp2YWxpZCB2
YWx1ZXMuLi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0
LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
