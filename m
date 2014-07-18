Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA8587F7E
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 03:51:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A4C538F8037
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 01:51:24 -0700 (PDT)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id 4KjHBMfCFncTVxgr (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Jul 2014 01:51:19 -0700 (PDT)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N8W007XEGKW8W10@mailout1.samsung.com> for
	xfs@oss.sgi.com; Fri, 18 Jul 2014 17:50:56 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004001cf9aa4$2670e280$7352a780$@samsung.com>
	<alpine.LFD.2.00.1407081558280.2180@localhost.localdomain>
	<87tx6ktiay.fsf@openvz.org>
In-reply-to: <87tx6ktiay.fsf@openvz.org>
Subject: RE: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
Date: Fri, 18 Jul 2014 17:50:55 +0900
Message-id: <002901cfa265$636d2e50$2a478af0$@samsung.com>
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
To: 'Dmitry Monakhov' <dmonakhov@openvz.org>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Brian Foster' <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Christoph Hellwig' <hch@infradead.org>, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, =?UTF-8?Q?'Luk=C3=A1=C5=A1_Czerner'?= <lczerner@redhat.com>, 'linux-ext4' <linux-ext4@vger.kernel.org>

PiBPbiBUdWUsIDggSnVsIDIwMTQgMTY6MDI6MjggKzAyMDAgKENFU1QpLCBMdWvDocWhIEN6ZXJu
ZXIgPGxjemVybmVyQHJlZGhhdC5jb20+IHdyb3RlOgo+IE5vbi10ZXh0IHBhcnQ6IE1VTFRJUEFS
VC9NSVhFRAo+ID4gT24gVHVlLCA4IEp1bCAyMDE0LCBOYW1qYWUgSmVvbiB3cm90ZToKPiA+Cj4g
PiA+IERhdGU6IFR1ZSwgMDggSnVsIDIwMTQgMjE6MDA6MDIgKzA5MDAKPiA+ID4gRnJvbTogTmFt
amFlIEplb24gPG5hbWphZS5qZW9uQHNhbXN1bmcuY29tPgo+ID4gPiBUbzogRGF2ZSBDaGlubmVy
IDxkYXZpZEBmcm9tb3JiaXQuY29tPiwgVGhlb2RvcmUgVHMnbyA8dHl0c29AbWl0LmVkdT4KPiA+
ID4gQ2M6IGxpbnV4LWV4dDQgPGxpbnV4LWV4dDRAdmdlci5rZXJuZWwub3JnPiwgbGludXgtZnNk
ZXZlbEB2Z2VyLmtlcm5lbC5vcmcsCj4gPiA+ICAgICBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnLCBMdWvDocWhIEN6ZXJuZXIgPGxjemVybmVyQHJlZGhhdC5jb20+LAo+ID4gPiAgICAgQnJp
YW4gRm9zdGVyIDxiZm9zdGVyQHJlZGhhdC5jb20+LCBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGlu
ZnJhZGVhZC5vcmc+LAo+ID4gPiAgICAgQXNoaXNoIFNhbmd3YW4gPGEuc2FuZ3dhbkBzYW1zdW5n
LmNvbT4sIHhmc0Bvc3Muc2dpLmNvbQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggMy8zXSBleHQ0OiBB
ZGQgc3VwcG9ydCBJT0NfTU9WX0RBVEEgaW9jdGwKPiA+ID4KPiA+ID4gVGhpcyBwYXRjaCBpbXBs
ZW1lbnRzIGZzIGlvY3RsJ3MgSU9DX01PVl9EQVRBIGZvciBFeHQ0Lgo+ID4KPiA+IEhtbSBpc24n
dCB0aGlzIGJhc2ljYWxseSB3aGF0IGV4dDRfbW92ZV9leHRlbnRzKCkgZG9lcyA/IGVnLgo+ID4g
RVhUNF9JT0NfTU9WRV9FWFQgPwo+ID4KPiA+IEkgZ3Vlc3MgdGhhdCB0aGUgaW50ZW50aW9uIGhl
cmUgaXMgdG8gZG8gdGhlIG1vdmUsIHdpdGhvdXQgYWN0dWFsbHkKPiA+IG1vdmluZyB0aGUgZGF0
YSByaWdodCA/IEJ1dCBuZXZlcnRoZWxlc3MgbWF5YmUgc29tZSBjb2RlIGNhbiBiZQo+ID4gc2hh
cmVkIHdpdGggZXh0NF9tb3ZlX2V4dGVudHMoKSA/Cj4gSXQgZGVmaW5pdGVseSBjYW4gYmUgc2hh
cmVkLCBiZWNhdXNlIGl0IGhhcyBzcGVjaWZpYyBjYXNlIGZvciB1bndyaXR0ZW4KPiBkYXRhIHNl
ZSBtb3ZlX2V4dGVudF9wZXJfcGFnZSgpLgpJZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5LCBtb3Zf
ZXh0ZW50X3Blcl9wYWdlIGNhbGxzIG1leHRfcmVwbGFjZV9icmFuY2hlcyB0bwpfcmVwbGFjZV8g
ZXh0ZW50cyBmcm9tIDEgaW5vZGUgdG8gb3RoZXIgaW5vZGUuIFBsZWFzZSBjb3JyZWN0IG1lIGlm
IEkgYW0gd3JvbmcuCmlvY19tb3ZfZGF0YSB3aWxsIG5vdCByZXBsYWNlIGV4dGVudHMsIGJ1dCBp
dCB3aWxsIGFjdHVhbGx5IF9tb3ZlXyBleHRlbnRzIGludG8KaG9sZSBmcm9tIGRvbm9yIHRvIHJl
Y2VpdmVyLCBsZWF2aW5nIGEgaG9sZSBhdCB0aGUgcGxhY2UgZnJvbSB3aGVyZSBleHRlbnRzIGFy
ZQptb3ZlZC4KQ291bGQgeW91IGVsYWJvcmF0ZSBtb3JlIGhvdyBpdCBjYW4gYmUgc2hhcmVkIGZv
ciB1bndyaXR0ZW4gZGF0YSBjYXNlID8KCj4gQnV0IEkgdGhpbmsgd2UgY2FuIG9ic2VydmUgYW5v
dGhlciB3YXkgdG8gdW5pZnkgdGhpcyB0d28gdGhpbmdzLgo+IEFuIGlkZWEgaW5zcGlyZWQgYnkg
dGhlIGZhY3QgdGhhdCBpb2NfbW92ZV9kYXRhIHdvcmtzIG9ubHkgZm9yCj4gcmVndWxhciBpbm9k
ZXMsIHdoZXJlIG9yaWdfb2Zmc2V0ID09IGRvbm9yX29mZnNldC4gCkNvdWxkIHlvdSBlbGFib3Jh
dGUgdGhpcyBwb2ludD8gCgo+IFRoaXMgaXMgc2hvd3N0b3BwZXIKPiBmb3IgIG15IHV0aWxpdHkg
ZTRkZWZyYWcyICggbmV3IHZlcnNpb24gb2YgZTRkZWZyYWcgd2hpY2ggaXMgYWJsZSBkZWZyYWdt
ZW50Cj4gcGFjayBzbWFsbCBmaWxlcyBhcyBkZXNjcmliZWQgaGVyZSA6Cj4gaHR0cDovL2xpc3Rz
Lm9wZW53YWxsLm5ldC9saW51eC1leHQ0LzIwMTQvMDQvMjgvMykKPiAKPiBQcm9wb3NlZCBBUEkg
aXMgdmVyeSBzaW1pbGFyIHRvIGV4dDRfZXh0X21pZ3JhdGU6Cj4gQXJnczoKPiAgIG9yaWdfZmls
ZTogaW5vZGUgd2hpY2ggd2Ugd2FudCB0byBkZWZyYWdtZW50Cj4gICBkb25vcl9maWxlOiBhIGZp
bGUgd2hpY2ggd2lsbCBiZSB1c2VkIGFzIGEgZG9ub3Igb2YgYmxvY2tzCj4gMSkgZmFsbG9jYXRl
IGJpZyBkb25vcl9maWxlCj4gMikgYSkgQ3JlYXRlIHRtcCBpbm9kZSB3aWNoIG5saW5rID0gMAo+
ICAgIGIpIG1vdmUgZXh0ZW50cyByZXF1aXJlZCBleHRlbnRzIGZyb20gIGRvbm9yIHRvIHRtcF9k
b25vcl9pbm9kZQo+ICAgIGMpIHJldHVybiBmaWxlIGRlc2NyaXB0b3IgKHRtcF9mZCkgdG8gdGhh
dCB0bXBfZG9ub3JfaW5vZGUKPiA0KSBNYXJrIG9yaWdfZmlsZSdzIGlub2RlIHdpdGggRVhUNF9T
VEFURV9FWFRfTUlHUkFURSBzdGF0ZQo+IDUpIENvcHkgZGF0YSBmcm9tIG9yaWdfZmlsZSB0byB0
bXBfZmQKPiA2KSBJT0NfU1dBUF9FWDogYXRvbWljYWxseSBzd2FwICBvcmlnX2ZpbGUtPmlfZGF0
YSBhbmQgdG1wX2ZkLT5pX2RhdGEKPiAgICBpZiBFWFQ0X1NUQVRFX0VYVF9NSUdSQVRFIHdhcyBu
b3QgY2xlYXJlZC4KPiAKPiBUaGlzIGFwcHJvYWNoIGNhbiB3b3JrcyBub3Qgb25seSBmb3IgcmVn
dWxhciBmaWxlIHcvbyBqb3VybmFsaW5nCj4gZW5hYmxlZCwgYnV0IGFsc28gZm9yIGpvdXJuYWxl
ZCBvbmVzLCBhbmQgZGlyZWN0b3JpZXMuCj4gCj4gCj4gCj4gCj4gPgo+ID4gLUx1a2FzCj4gPgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxp
bmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGlu
Zm8veGZzCg==
