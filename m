Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2CE17F80
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 14:38:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73FF1304048
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 12:37:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ytbXsTkVivMEgwxv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 12:37:56 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 2C109379E4D
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 19:37:56 +0000 (UTC)
Date: Thu, 25 Jun 2015 15:37:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/17] mkfs: sanitise ftype parameter values.
Message-ID: <20150625193754.GF36162@bfoster.bfoster>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-3-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434711726-13092-3-git-send-email-jtulak@redhat.com>
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
To: Jan =?utf-8?B?xaR1bMOhaw==?= <jtulak@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

T24gRnJpLCBKdW4gMTksIDIwMTUgYXQgMDE6MDE6NTFQTSArMDIwMCwgSmFuIMWkdWzDoWsgd3Jv
dGU6Cj4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IEJlY2F1
c2UgcGFzc2luZyAiLW4gZnR5cGU9MiIgc2hvdWxkIGZhaWwuCj4gCj4gU2lnbmVkLW9mZi1ieTog
RGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEphbiDF
pHVsw6FrIDxqdHVsYWtAcmVkaGF0LmNvbT4KPiAtLS0KClJldmlld2VkLWJ5OiBCcmlhbiBGb3N0
ZXIgPGJmb3N0ZXJAcmVkaGF0LmNvbT4KCj4gIG1rZnMveGZzX21rZnMuYyB8IDUgKysrKy0KPiAg
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYg
LS1naXQgYS9ta2ZzL3hmc19ta2ZzLmMgYi9ta2ZzL3hmc19ta2ZzLmMKPiBpbmRleCBkMGRlOTBk
Li4xNjUyOTAzIDEwMDY0NAo+IC0tLSBhL21rZnMveGZzX21rZnMuYwo+ICsrKyBiL21rZnMveGZz
X21rZnMuYwo+IEBAIC0xNjE3LDEyICsxNjE3LDE1IEBAIF8oImNhbm5vdCBzcGVjaWZ5IGJvdGgg
Y3JjIGFuZCBmdHlwZVxuIikpOwo+ICAJCQkJCQlyZXF2YWwoJ24nLCBub3B0cywgTl9GVFlQRSk7
Cj4gIAkJCQkJaWYgKG5mdHlwZSkKPiAgCQkJCQkJcmVzcGVjKCduJywgbm9wdHMsIE5fRlRZUEUp
Owo+IC0JCQkJCWRpcmZ0eXBlID0gYXRvaSh2YWx1ZSk7Cj4gKwkJCQkJYyA9IGF0b2kodmFsdWUp
Owo+ICsJCQkJCWlmIChjIDwgMCB8fCBjID4gMSkKPiArCQkJCQkJaWxsZWdhbCh2YWx1ZSwgIm4g
ZnR5cGUiKTsKPiAgCQkJCQlpZiAoY3Jjc19lbmFibGVkKSB7Cj4gIAkJCQkJCWZwcmludGYoc3Rk
ZXJyLAo+ICBfKCJjYW5ub3Qgc3BlY2lmeSBib3RoIGNyYyBhbmQgZnR5cGVcbiIpKTsKPiAgCQkJ
CQkJdXNhZ2UoKTsKPiAgCQkJCQl9Cj4gKwkJCQkJZGlyZnR5cGUgPSBjOwo+ICAJCQkJCW5mdHlw
ZSA9IDE7Cj4gIAkJCQkJYnJlYWs7Cj4gIAkJCQlkZWZhdWx0Ogo+IC0tIAo+IDIuMS4wCj4gCj4g
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiB4ZnMgbWFp
bGluZyBsaXN0Cj4geGZzQG9zcy5zZ2kuY29tCj4gaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
