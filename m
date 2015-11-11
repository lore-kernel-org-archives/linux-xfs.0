Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C83C7F80
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 10:19:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AA5B304032
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 08:19:55 -0800 (PST)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	6FMJMRH4tgiRhFjA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 08:19:48 -0800 (PST)
Received: by lbbkw15 with SMTP id kw15so19645836lbb.0
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 08:19:47 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: memory reclaim problems on fs usage
Date: Wed, 11 Nov 2015 17:19:42 +0100
References: <201511102313.36685.arekm@maven.pl>
	<5643658B.9090206@I-love.SAKURA.ne.jp>
In-Reply-To: <5643658B.9090206@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Message-Id: <201511111719.44035.arekm@maven.pl>
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

T24gV2VkbmVzZGF5IDExIG9mIE5vdmVtYmVyIDIwMTUsIFRldHN1byBIYW5kYSB3cm90ZToKPiBP
biAyMDE1LzExLzExIDc6MTMsIEFya2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToKPiA+IFRoZSB1
c3VhbCAocmVwZWF0YWJsZSkgcHJvYmxlbSBpcyBsaWtlIHRoaXM6Cj4gPiAKPiA+IGZ1bGwgZG1l
c2c6IGh0dHA6Ly9zcHJ1bmdlLnVzL1ZFaUUgKG1vcmUgaW4gaXQgdGhlbiBpbiBwYXJ0aWFsIGxv
ZyBiZWxvdykKPiAKPiBNYXliZSBzb21lYm9keSBkb2luZyBHRlBfTk9JTyBhbGxvY2F0aW9uIHdo
aWNoIFhGUyBkcml2ZXIgZG9pbmcgR0ZQX05PRlMKPiBhbGxvY2F0aW9uIGlzIHdhaXRpbmcgZm9y
IGlzIHN0YWxsaW5nIGluc2lkZSBtZW1vcnkgYWxsb2NhdG9yLiBJIHRoaW5rIHRoYXQKPiBjaGVj
a2luZyB0YXNrcyB3aGljaCBhcmUgc3RhbGxpbmcgaW5zaWRlIG1lbW9yeSBhbGxvY2F0b3Igd291
bGQgaGVscC4KPiAKPiBQbGVhc2UgdHJ5IHJlcHJvZHVjaW5nIHRoaXMgcHJvYmxlbSB3aXRoIGEg
ZGVidWcgcHJpbnRrKCkgcGF0Y2ggc2hvd24gYmVsb3cKPiBhcHBsaWVkLiBUaGlzIGlzIGEgcGF0
Y2ggd2hpY2ggSSB1c2VkIGZvciBkZWJ1Z2dpbmcgc2lsZW50IGxvY2t1cCBwcm9ibGVtLgo+IFdo
ZW4gbWVtb3J5IGFsbG9jYXRpb24gZ290IHN0dWNrLCBsaW5lcyB3aXRoIE1lbUFsbG9jIGtleXdv
cmQgd2lsbCBiZQo+IHByaW50ZWQuCj4gCj4gLS0tCj4gICBmcy94ZnMva21lbS5jICAgICAgICAg
IHwgIDEwICsrLQo+ICAgZnMveGZzL3hmc19idWYuYyAgICAgICB8ICAgMyArLQo+ICAgaW5jbHVk
ZS9saW51eC9tbXpvbmUuaCB8ICAgMSArCj4gICBpbmNsdWRlL2xpbnV4L3Ztc3RhdC5oIHwgICAx
ICsKPiAgIG1tL3BhZ2VfYWxsb2MuYyAgICAgICAgfCAyMTcKPiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrIG1tL3Ztc2Nhbi5jICAgICAgICAgICAgfAo+
ICAyMiArKysrKwo+ICAgNiBmaWxlcyBjaGFuZ2VkLCAyNDkgaW5zZXJ0aW9ucygrKSwgNSBkZWxl
dGlvbnMoLSkKClRoaXMgcGF0Y2ggaXMgYWdhaW5zdCB3aGljaCB0cmVlPyAodHJpZWQgNC4xLCA0
LjIgYW5kIDQuMykKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8gKCBtYXZlbi5w
bCB8IHBsZC1saW51eC5vcmcgKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5z
Z2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
