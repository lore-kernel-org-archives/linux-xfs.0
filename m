Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79B647F37
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 04:19:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07E84AC001
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 02:19:48 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id 3VXkqdNzETz3EDO4 for <xfs@oss.sgi.com>;
	Mon, 25 Mar 2013 02:19:46 -0700 (PDT)
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id BED386AC1ED
	for <xfs@oss.sgi.com>; Mon, 25 Mar 2013 10:19:45 +0100 (CET)
Message-ID: <515016B1.4090607@jan-o-sch.net>
Date: Mon, 25 Mar 2013 10:19:45 +0100
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: use _require_no_large_scratch_dev instead
	of the removed _require_nobigloopfs
References: <514AA503.4060101@gmail.com> <514FD3FA.701@gmail.com>
In-Reply-To: <514FD3FA.701@gmail.com>
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

Ck9uIE1vbiwgTWFyY2ggMjUsIDIwMTMgYXQgMDU6MzUgKCswMTAwKSwgV2FuZyBTaGVuZy1IdWkg
d3JvdGU6Cj4gT24gMjAxM+W5tDAz5pyIMjHml6UgMTQ6MTMsIFdhbmcgU2hlbmctSHVpIHdyb3Rl
Ogo+PiBfcmVxdWlyZV9ub2JpZ2xvb3BmcyBoYXMgYmVlbiByZW1vdmVkLgo+PiBXZSBzaG91bGQg
dXNlIF9yZXF1aXJlX25vX2xhcmdlX3NjcmF0Y2hfZGV2IGluIHRoZSB0ZXN0IHNjcmlwdC4KPj4K
Pj4gU2lnbmVkLW9mZi1ieTogV2FuZyBTaGVuZy1IdWkgPHNoaHVpd0BnbWFpbC5jb20+Cj4+IC0t
LQo+PiAgIDI3NiB8ICAgIDMgKy0tCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAyIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvMjc2IGIvMjc2Cj4+IGluZGV4IDQw
YjMwY2YuLjg3MzYzY2EgMTAwNzU1Cj4+IC0tLSBhLzI3Ngo+PiArKysgYi8yNzYKPj4gQEAgLTU4
LDggKzU4LDcgQEAgX25lZWRfdG9fYmVfcm9vdAo+PiAgIF9zdXBwb3J0ZWRfZnMgYnRyZnMKPj4g
ICBfc3VwcG9ydGVkX29zIExpbnV4Cj4+ICAgX3JlcXVpcmVfc2NyYXRjaAo+PiAtCj4+IC1fcmVx
dWlyZV9ub2JpZ2xvb3Bmcwo+PiArX3JlcXVpcmVfbm9fbGFyZ2Vfc2NyYXRjaF9kZXYKPj4gICBf
cmVxdWlyZV9idHJmcyBpbnNwZWN0LWludGVybmFsCj4+ICAgX3JlcXVpcmVfY29tbWFuZCAiL3Vz
ci9zYmluL2ZpbGVmcmFnIgo+Pgo+IAo+IERvZXMgYW55b25lIG5vdGljZSB0aGlzPwo+IEkgdXNl
IHRoZSB1cHN0cmVhbSB4ZnN0ZXN0cyBhbmQgZmFpbGVkIHRoaXMgY2FzZSBmb3IgdGhlIGFscmVh
ZHktcmVtb3ZlZCBmdW5jdGlvbi4KPiBJIHRoaW5rIHNvbWVvbmUgcGF0Y2hlZCBpbiBidXQgbWl4
ZWQgdGhlIG9sZCBmdW5jdGlvbi4KPiBJJ3ZlIHNlbmQgb3V0IHRoaXMgcGF0Y2ggZm9yIGRheXMs
IGJ1dCBzZWVtcyBubyBvbmUgY2FyZXMgYWJvdXQgaXQuCgpOb3RpY2VkIGl0LCB0b28uIEknZCBq
dXN0IGRlbGV0ZSB0aGF0IGxpbmUgaW5zdGVhZCAtIHRoZSB0ZXN0IGRvZXNuJ3QgZGVwZW5kIG9u
CnNjcmF0Y2ggZGV2IHNpemUuCgpUaGFua3MsCi1KYW4KCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
