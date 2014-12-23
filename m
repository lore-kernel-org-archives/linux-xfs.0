Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 835587F3F
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 01:19:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71D2F304032
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 23:19:32 -0800 (PST)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id IbY609xBXbo0WqHL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2014 23:19:23 -0800 (PST)
Received: by mail-wg0-f43.google.com with SMTP id l18so8370105wgh.16
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 23:19:23 -0800 (PST)
Received: from xps.localnet ([91.234.176.242])
	by mx.google.com with ESMTPSA id p14sm16137520wie.1.2014.12.22.23.19.21
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 22 Dec 2014 23:19:22 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: weird quota issue
Date: Tue, 23 Dec 2014 08:19:20 +0100
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
	<20141223024248.GC4521@dastard>
In-Reply-To: <20141223024248.GC4521@dastard>
MIME-Version: 1.0
Message-Id: <201412230819.20935.arekm@maven.pl>
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

T24gVHVlc2RheSAyMyBvZiBEZWNlbWJlciAyMDE0LCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gT24g
VHVlLCBEZWMgMjMsIDIwMTQgYXQgMDI6MTI6MTVBTSArMDAwMCwgV2ViZXIsIENoYXJsZXMgKE5J
SC9OSUEvSVJQKSBbRV0gCndyb3RlOgo+ID4gaGVyZSB5b3UgZ28KPiA+IAo+ID4gIyB4ZnNfZGIg
LWMgImlub2RlIDEzMSIgLWMgcCAvZGV2L2RtLTcKPiAKPiBOb3RoaW5nIG9idmlvdXNseSB3cm9u
ZyB0aGVyZSwgc28gdGhlcmUncyBubyBjbGVhciBpbmRpY2F0aW9uIG9mIHdoeQo+IHRoZSBxdW90
YSBpbml0aWFsaXNhdGlvbiBmYWlsZWQuCgpncXVvdGlubyBzaG91bGQgYmUgc2V0IHRvIG51bGws
IHNldHRpbmcgaXQgdmlhIHhmc19kYiBzaG91bGQgZml4IHRoZSBwcm9ibGVtCgo+IHVxdW90aW5v
ID0gMTMxCj4gZ3F1b3Rpbm8gPSAwCj4gcWZsYWdzID0gMAoKCk90aGVyd2lzZSB3ZSBlbmQgdXAg
d2l0aCBteSBsYXN0IHByb2JsZW0KCmh0dHA6Ly9vc3Muc2dpLmNvbS9hcmNoaXZlcy94ZnMvMjAx
NC0wNy9tc2cwMDEyMS5odG1sCgoiLSAzLjEwIGtlcm5lbCBpcyBub3QgYWJsZSB0byBoYW5kbGUg
Y2FzZSB3aGVuIHVxdW90aW5vID09IHZhbHVlLCBncXVvdGlubyA9PSAKMC4gRm9yIDMuMTAgdGhp
cyBjYXNlIGlzIGltcG9zc2libGUgLyBzaG91bGQgbmV2ZXIgaGFwcGVuLiAzLjEwIGV4cGVjdHMg
Cih1cXVvdGlubyA9PSB2YWx1ZSwgZ3F1b3Rpbm8gPT0gbnVsbCkgb3IgKHVxdW90aW5vID09IHZh
bHVlLCBncXVvdGlubyA9PSAKb3RoZXJ2YWx1ZSkgb3IgKHVxb3RpbmZvID09IG51bGwsIGdydW90
aW5vID09IHZhbHVlKSBvbmx5LiIKClNvIEkgZ3Vlc3MgMi42LjMyIGlzIGRvaW5nIHRoZSBzYW1l
LgogCkFGQUlLIHhmc19yZXBhaXIgZG9lc24ndCBmaXggdGhpcyBpc3N1ZS4gTm90IHN1cmUuCgo+
IERhdmUuCgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20gLyAoIG1hdmVuLnBsIHwg
cGxkLWxpbnV4Lm9yZyApCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
