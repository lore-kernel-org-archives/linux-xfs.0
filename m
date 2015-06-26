Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5843E7F69
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 14:32:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01DB4AC001
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 12:32:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y2DgcR80BCV1101q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2015 12:32:42 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 527E5C1316
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 19:32:42 +0000 (UTC)
Date: Fri, 26 Jun 2015 15:32:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/17] mkfs: move spinodes crc check
Message-ID: <20150626193240.GM40750@bfoster.bfoster>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-18-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434711726-13092-18-git-send-email-jtulak@redhat.com>
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
Cc: xfs@oss.sgi.com

T24gRnJpLCBKdW4gMTksIDIwMTUgYXQgMDE6MDI6MDZQTSArMDIwMCwgSmFuIMWkdWzDoWsgd3Jv
dGU6Cj4gU3Bpbm9kZXMgY3JjIGNoZWNrIGlzIG5vdyBtb3ZlZCB0byBiZSBpbiB0aGUgc2FtZSB3
YXkgYXMgZmlub2J0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEphbiDFpHVsw6FrIDxqdHVsYWtAcmVk
aGF0LmNvbT4KPiAtLS0KClNlZW1zIGZpbmU6CgpSZXZpZXdlZC1ieTogQnJpYW4gRm9zdGVyIDxi
Zm9zdGVyQHJlZGhhdC5jb20+Cgo+ICBta2ZzL3hmc19ta2ZzLmMgfCAxMSArKysrKystLS0tLQo+
ICAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQo+IAo+IGRp
ZmYgLS1naXQgYS9ta2ZzL3hmc19ta2ZzLmMgYi9ta2ZzL3hmc19ta2ZzLmMKPiBpbmRleCAyZTQ1
NWRiLi42NTNmYzViIDEwMDY0NAo+IC0tLSBhL21rZnMveGZzX21rZnMuYwo+ICsrKyBiL21rZnMv
eGZzX21rZnMuYwo+IEBAIC0yMzQ3LDEyICsyMzQ3LDEzIEBAIF8oIjMyIGJpdCBQcm9qZWN0IElE
cyBhbHdheXMgZW5hYmxlZCBvbiBDUkMgZW5hYmxlZCBmaWxlc3l0ZW1zXG4iKSk7Cj4gIF8oIndh
cm5pbmc6IGZpbm9idCBub3Qgc3VwcG9ydGVkIHdpdGhvdXQgQ1JDIHN1cHBvcnQsIGRpc2FibGVk
LlxuIikpOwo+ICAJCQlzYl9mZWF0LmZpbm9idCA9IDA7Cj4gIAkJfQo+IC0JfQo+ICAKPiAtCWlm
IChzYl9mZWF0LnNwaW5vZGVzICYmICFzYl9mZWF0LmNyY3NfZW5hYmxlZCkgewo+IC0JCWZwcmlu
dGYoc3RkZXJyLAo+IC1fKCJ3YXJuaW5nOiBzcGFyc2UgaW5vZGVzIG5vdCBzdXBwb3J0ZWQgd2l0
aG91dCBDUkMgc3VwcG9ydCwgZGlzYWJsZWQuXG4iKSk7Cj4gLQkJc2JfZmVhdC5zcGlub2RlcyA9
IDA7Cj4gKwkJaWYgKHNiX2ZlYXQuc3Bpbm9kZXMpIHsKPiArCQkJZnByaW50ZihzdGRlcnIsCj4g
KwlfKCJ3YXJuaW5nOiBzcGFyc2UgaW5vZGVzIG5vdCBzdXBwb3J0ZWQgd2l0aG91dCBDUkMgc3Vw
cG9ydCwgZGlzYWJsZWQuXG4iKSk7Cj4gKwkJCXNiX2ZlYXQuc3Bpbm9kZXMgPSAwOwo+ICsJCX0K
PiArCj4gIAl9Cj4gIAo+ICAJaWYgKG5zZmxhZyB8fCBubGZsYWcpIHsKPiAtLSAKPiAyLjEuMAo+
IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4geGZz
IG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
