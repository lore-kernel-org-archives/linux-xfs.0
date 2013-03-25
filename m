Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32D1A7F37
	for <xfs@oss.sgi.com>; Sun, 24 Mar 2013 23:35:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 222A530404E
	for <xfs@oss.sgi.com>; Sun, 24 Mar 2013 21:35:23 -0700 (PDT)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	m1XzCo1iGz2IFqQl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Mar 2013 21:35:22 -0700 (PDT)
Received: by mail-pd0-f178.google.com with SMTP id u10so2342361pdi.37
	for <xfs@oss.sgi.com>; Sun, 24 Mar 2013 21:35:21 -0700 (PDT)
Message-ID: <514FD3FA.701@gmail.com>
Date: Mon, 25 Mar 2013 12:35:06 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead
	of the removed _require_nobigloopfs
References: <514AA503.4060101@gmail.com>
In-Reply-To: <514AA503.4060101@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <dchinner@redhat.com>, xfstests <xfs@oss.sgi.com>, linux-btrfs@vger.kernel.org

T24gMjAxM+W5tDAz5pyIMjHml6UgMTQ6MTMsIFdhbmcgU2hlbmctSHVpIHdyb3RlOgo+IF9yZXF1
aXJlX25vYmlnbG9vcGZzIGhhcyBiZWVuIHJlbW92ZWQuCj4gV2Ugc2hvdWxkIHVzZSBfcmVxdWly
ZV9ub19sYXJnZV9zY3JhdGNoX2RldiBpbiB0aGUgdGVzdCBzY3JpcHQuCj4KPiBTaWduZWQtb2Zm
LWJ5OiBXYW5nIFNoZW5nLUh1aSA8c2hodWl3QGdtYWlsLmNvbT4KPiAtLS0KPiAgIDI3NiB8ICAg
IDMgKy0tCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0p
Cj4KPiBkaWZmIC0tZ2l0IGEvMjc2IGIvMjc2Cj4gaW5kZXggNDBiMzBjZi4uODczNjNjYSAxMDA3
NTUKPiAtLS0gYS8yNzYKPiArKysgYi8yNzYKPiBAQCAtNTgsOCArNTgsNyBAQCBfbmVlZF90b19i
ZV9yb290Cj4gICBfc3VwcG9ydGVkX2ZzIGJ0cmZzCj4gICBfc3VwcG9ydGVkX29zIExpbnV4Cj4g
ICBfcmVxdWlyZV9zY3JhdGNoCj4gLQo+IC1fcmVxdWlyZV9ub2JpZ2xvb3Bmcwo+ICtfcmVxdWly
ZV9ub19sYXJnZV9zY3JhdGNoX2Rldgo+ICAgX3JlcXVpcmVfYnRyZnMgaW5zcGVjdC1pbnRlcm5h
bAo+ICAgX3JlcXVpcmVfY29tbWFuZCAiL3Vzci9zYmluL2ZpbGVmcmFnIgo+CgpEb2VzIGFueW9u
ZSBub3RpY2UgdGhpcz8KSSB1c2UgdGhlIHVwc3RyZWFtIHhmc3Rlc3RzIGFuZCBmYWlsZWQgdGhp
cyBjYXNlIGZvciB0aGUgYWxyZWFkeS1yZW1vdmVkIGZ1bmN0aW9uLgpJIHRoaW5rIHNvbWVvbmUg
cGF0Y2hlZCBpbiBidXQgbWl4ZWQgdGhlIG9sZCBmdW5jdGlvbi4KSSd2ZSBzZW5kIG91dCB0aGlz
IHBhdGNoIGZvciBkYXlzLCBidXQgc2VlbXMgbm8gb25lIGNhcmVzIGFib3V0IGl0LgoKSWYgSSdt
IHdyb25nLCBwbGVhc2UgbGV0IG1lIGtub3cuCgpUaGFua3MsCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
