Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27I7xUi137621 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 12:07:59 -0600
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	grcvf47DyBGB2Fxc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Mar 2012 10:07:56 -0800 (PST)
Received: by eaa1 with SMTP id 1so3302519eaa.26
	for <xfs@oss.sgi.com>; Wed, 07 Mar 2012 10:07:55 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
Date: Wed, 7 Mar 2012 19:07:53 +0100
References: <4F5798F9.2050809@redhat.com>
	<20120307173313.GA20399@josefsipek.net>
In-Reply-To: <20120307173313.GA20399@josefsipek.net>
MIME-Version: 1.0
Message-Id: <201203071907.53488.arekm@maven.pl>
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
To: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDA3IG9mIE1hcmNoIDIwMTIsIEpvc2VmICdKZWZmJyBTaXBlayB3cm90ZToK
PiBPbiBXZWQsIE1hciAwNywgMjAxMiBhdCAxMToyMDo1N0FNIC0wNjAwLCBFcmljIFNhbmRlZW4g
d3JvdGU6Cj4gPiBGcm9tOiBEYXZlIENoaW5uZXIgPGRjaGlubmVyQHJlZGhhdC5jb20+Cj4gPiAK
PiA+IERlZmF1bHQgdG8gYWxsb3dpbmcgNjQtYml0IGlub2RlcyBvbiB0aGUgZmlsZXN5c3RlbS4K
PiA+IAo+ID4gQWRkIGEgZmVhdHVyZSBiaXQgdG8gdGhlIHRoZSBzdXBlcmJsb2NrIHRvIHJlY29y
ZCB3aGV0aGVyIDY0IGJpdCBpbm9kZXMKPiA+IGhhdmUgYmVlbiBhbGxvY2F0ZWQgb24gdGhlIGZp
bGVzeXN0ZW0gb3Igbm90LiBUaGlzIGFsbG93cyB1cyB0byByZWplY3QKPiA+IG1vdW50aW5nIHRo
ZSBmaWxlc3l0ZW0gd2l0aCBpbm9kZTMyIGlmIDY0IGJpdCBpbm9kZXMgYXJlIHByZXNlbnQuCj4g
PiAKPiA+IE9uY2UgYSA2NCBiaXRpbm9kZSBpcyBhbGxvY2F0ZWQsIHRoZSBpbm9kZTY0IHN1cGVy
YmxvY2sgZmVhdHVyZSBiaXQgd2lsbAo+ID4gYmUgc2V0LiBPbmNlIHRoZSBzdXBlcmJsb2NrIGZl
YXR1cmUgYml0IGlzIHNldCwgdGhlIGZpbGVzeXN0ZW0gd2lsbAo+ID4gZGVmYXVsdCB0byA2NCBi
aXQgaW5vZGVzIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBpbm9kZTY0IGlzIHNwZWNpZmllZCBhcyBh
Cj4gPiBtb3VudCBvcHRpb24uCj4gPiAKPiA+IFRvIGVuc3VyZSBvbmx5IDMyIGJpdCBpbm9kZXMg
YXJlIGNyZWF0ZWQsIHRoZSBpbm9kZTMyIG1vdW50IG9wdGlvbiBtdXN0Cj4gPiBiZSB1c2VkLiBJ
ZiB0aGVyZSBhcmUgYWxyZWFkeSA2NCBiaXQgaW5vZGVzIGFzIGZsYWdnZWQgYnkgdGhlIHN1cGVy
YmxvY2sKPiA+IGZlYXR1cmUgYml0LCB0aGVuIHRoZSBpbm9kZTMyIG1vdW50IHdpbGwgYmUgcmVm
dXNlZC4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRo
YXQuY29tPgo+IAo+IExvdmUgaXQhIAoKKzEgZm9yIGxvdmUuIEkgaGFkIHRvbyBtYW55IHByb2Js
ZW1zIHdpdGggZm9yZ2V0dGluZyB0byBtb3VudCB3aXRoIGlub2RlNjQgCm9wdGlvbi4KCi0tIApB
cmthZGl1c3ogTWnFm2tpZXdpY3ogICAgICAgIFBMRC9MaW51eCBUZWFtCmFyZWttIC8gbWF2ZW4u
cGwgICAgICAgICAgICBodHRwOi8vZnRwLnBsZC1saW51eC5vcmcvCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
