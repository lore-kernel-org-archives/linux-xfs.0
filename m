Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C8487F47
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2015 14:40:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A008AC001
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2015 12:40:49 -0800 (PST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
	[209.85.215.51]) by cuda.sgi.com with ESMTP id 4PqmRYwHsrZU9IRw
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 14 Nov 2015 12:40:41 -0800 (PST)
Received: by lfs39 with SMTP id 39so68944163lfs.3
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2015 12:40:40 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory reclaim problems on fs usage
Date: Sat, 14 Nov 2015 21:40:38 +0100
References: <201511102313.36685.arekm@maven.pl>
	<56449E44.7020407@I-love.SAKURA.ne.jp>
	<201511122228.26399.arekm@maven.pl>
In-Reply-To: <201511122228.26399.arekm@maven.pl>
MIME-Version: 1.0
Message-Id: <201511142140.38245.arekm@maven.pl>
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
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

T24gVGh1cnNkYXkgMTIgb2YgTm92ZW1iZXIgMjAxNSwgQXJrYWRpdXN6IE1pxZtraWV3aWN6IHdy
b3RlOgo+IE9uIFRodXJzZGF5IDEyIG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90
ZToKPiA+IE9uIDIwMTUvMTEvMTIgMTU6MDYsIEFya2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToK
PiA+ID4gT24gV2VkbmVzZGF5IDExIG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90
ZToKPiA+ID4+IEFya2FkaXVzeiBNaT9raWV3aWN6IHdyb3RlOgo+ID4gPj4+IFRoaXMgcGF0Y2gg
aXMgYWdhaW5zdCB3aGljaCB0cmVlPyAodHJpZWQgNC4xLCA0LjIgYW5kIDQuMykKPiA+ID4+IAo+
ID4gPj4gT29wcy4gV2hpdGVzcGFjZS1kYW1hZ2VkLiBUaGlzIHBhdGNoIGlzIGZvciB2YW5pbGxh
IDQuMS4yLgo+ID4gPj4gUmVwb3N0aW5nIHdpdGggb25lIGNvbmRpdGlvbiBjb3JyZWN0ZWQuCj4g
PiA+IAo+ID4gPiBIZXJlIGlzIGxvZzoKPiA+ID4gCj4gPiA+IGh0dHA6Ly9peGlvbi5wbGQtbGlu
dXgub3JnL35hcmVrbS9sb2ctbW0tMS50eHQuZ3oKPiA+ID4gCj4gPiA+IFVuY29tcHJlc3NlcyBp
cyAxLjRNQiwgc28gbm90IHBvc3RpbmcgaGVyZS4KPiA+IAo+ID4gVGhhbmsgeW91IGZvciB0aGUg
bG9nLiBUaGUgcmVzdWx0IGlzIHVuZXhwZWN0ZWQgZm9yIG1lLgo+IAo+IFsuLi5dCj4gCj4gPiB2
bXN0YXRfdXBkYXRlKCkgYW5kIHN1Ym1pdF9mbHVzaGVzKCkgcmVtYWluZWQgcGVuZGluZyBmb3Ig
YWJvdXQgMTEwCj4gPiBzZWNvbmRzLiBJZiB4bG9nX2NpbF9wdXNoX3dvcmsoKSB3ZXJlIHNwaW5u
aW5nIGluc2lkZSBHRlBfTk9GUwo+ID4gYWxsb2NhdGlvbiwgaXQgc2hvdWxkIGJlIHJlcG9ydGVk
IGFzIE1lbUFsbG9jOiB0cmFjZXMsIGJ1dCBubyBzdWNoIGxpbmVzCj4gPiBhcmUgcmVjb3JkZWQu
IEkgZG9uJ3Qga25vdyB3aHkgeGxvZ19jaWxfcHVzaF93b3JrKCkgZGlkIG5vdCBjYWxsCj4gPiBz
Y2hlZHVsZSgpIGZvciBzbyBsb25nLiBBbnl3YXksIGFwcGx5aW5nCj4gPiBodHRwOi8vbGttbC5r
ZXJuZWwub3JnL3IvMjAxNTExMTExNjAzMzYuR0QxNDMyQGRoY3AyMi5zdXNlLmN6IHNob3VsZAo+
ID4gc29sdmUgdm1zdGF0X3VwZGF0ZSgpIHBhcnQuCj4gCj4gVG8gYXBwbHkgdGhhdCBwYXRjaCBv
biB0b3Agb2YgNC4xLjEzIEkgYWxzbyBoYWQgdG8gYXBwbHkgcGF0Y2hlcyBsaXN0ZWQKPiBiZWxv
dy4KPiAKPiBTbyBpbiBzdW1tYXJ5IGFwcGxsaWVkOgo+IGh0dHA6Ly9zcHJ1bmdlLnVzL0dZQmIK
PiBodHRwOi8vc3BydW5nZS51cy9YV1VYCj4gaHR0cDovL3NwcnVuZ2UudXMvalpqVgoKSSd2ZSB0
cmllZCBtb3JlIHRvIHRyaWdnZXIgInBhZ2UgYWxsb2NhdGlvbiBmYWlsdXJlIiB3aXRoIHVzdWFs
IGFjdGlvbnMgdGhhdCAKdHJpZ2dlcmVkIGl0IHByZXZpb3VzbHkgYnV0IGNvdWxkbid0IHJlcHJv
ZHVjZS4gV2l0aCB0aGVzZSBwYXRjaGVzIGFwcGxpZWQgaXQgCmRvZXNuJ3QgaGFwcGVuLgoKTG9n
cyBmcm9tIG15IHRlc3RzOgoKaHR0cDovL2l4aW9uLnBsZC1saW51eC5vcmcvfmFyZWttL2xvZy1t
bS0zLnR4dC5negpodHRwOi8vaXhpb24ucGxkLWxpbnV4Lm9yZy9+YXJla20vbG9nLW1tLTQudHh0
Lmd6ICh3aXRoIHN3YXAgYWRkZWQpCgpCdXQgYXJlIHRoZXNlIHBhdGNoZXMgc29sdmluZyB0aGUg
cHJvYmxlbSBvciBqdXN0IGhpZGluZyBpdD8KCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFy
ZWttIC8gKCBtYXZlbi5wbCB8IHBsZC1saW51eC5vcmcgKQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
