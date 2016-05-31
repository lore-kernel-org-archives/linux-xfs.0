Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 195CF7CCD
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 07:14:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E00A0304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:14:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UH5RGwGY8NOcFMPI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 05:14:07 -0700 (PDT)
Date: Tue, 31 May 2016 14:14:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
Message-ID: <20160531121402.GA15274@redhat.com>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
	<9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
	<CAGbZs7i66XWt3PF1_-L-WeBtdH80nfAOv+-Ary+ORKHxFGOLFg@mail.gmail.com>
	<20160531031010.GB12670@dastard>
	<CAGbZs7g9nfDFXKkhW-pgiVu1quRQDwMYxeAtLoky+xFcfx7WmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGbZs7g9nfDFXKkhW-pgiVu1quRQDwMYxeAtLoky+xFcfx7WmQ@mail.gmail.com>
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
Cc: baotiao@gmail.com

T24gVHVlLCBNYXkgMzEsIDIwMTYgYXQgMDc6MDA6MjJQTSArMDgwMCwg6ZmI5a6X5b+XIHdyb3Rl
Ogo+ICAgIGNhbiB3ZSBjaGFuZ2UgdGhlIGV4aXN0aW5nIGZpbGUncyBleHRlbnQgc2l6ZT8KPiAK
Tm8sIHlvdSBjYW4gb25seSBzZXQgZXh0ZW50IGhpbnQgc2l6ZSBmb3IgZW1wdHkgZmlsZXMsIG9y
LCBtb3JlIHByZWNpc2VseSBmb3IKZmlsZXMgd2hvc2UgZG9lcyBub3QgaGF2ZSBhbGxvY2F0ZWQg
ZXh0ZW50cwoKPiAgICBPbiBUdWUsIE1heSAzMSwgMjAxNiBhdCAxMToxMCBBTSwgRGF2ZSBDaGlu
bmVyIDxbMV1kYXZpZEBmcm9tb3JiaXQuY29tPgo+ICAgIHdyb3RlOgo+IAo+ICAgICAgT24gVHVl
LCBNYXkgMzEsIDIwMTYgYXQgMTA6NDM6MzZBTSArMDgwMCwg6ZmI5a6X5b+XIHdyb3RlOgo+ICAg
ICAgPiBJIGhhdmUgZmludCB0aGUgd2F5IHRvIGNoYW5nZSB0aGUgZXh0ZW50IHNpemUgaGludAo+
ICAgICAgPiBta2ZzLnhmcyAtciBleHRzaXplPTQwOTYwIC9kZXYvc2RhMQo+ICAgICAgQWgsIG5v
LCB0aGF0IGlzbid0IHRoZSBleHRzaXplIEknbSByZWZlcmluZyB0by4gVGhhdCdzIGZvciByZWFs
dGltZQo+ICAgICAgZGV2aWNlIGNvbmZpZ3VyYXRpb24gYXQgbWtmcywgbm90IGEgcGVyLWlub2Rl
IGV4dGVudCBzaXplIGhpbnQuCj4gICAgICBXaGVuIHlvdSBjcmVhdGUgdGhlIGltYWdlIGZpbGUg
ZG8gdGhpczoKPiAgICAgICQgeGZzX2lvIC1mIC1jICJleHRzaXplIDFtIiAvcGF0aC90by9uZXcv
dm1faW1hZ2UKPiAgICAgICQgcWVtdS1pbWFnZSBjcmVhdGUgLWYgcWNvdzIgL3BhdGgvdG8vbmV3
L3ZtX2ltYWdlIDEwZwo+ICAgICAgJCB4ZnNfaW8gLWMgZXh0c2l6ZSAvcGF0aC90by9uZXcvdm1f
aW1hZ2UKPiAgICAgIFsxMDQ4NTc2XSAvcGF0aC90by9uZXcvdm1faW1hZ2UKPiAgICAgICQKPiAg
ICAgIEFuZCBub3cgdGhlIHFjb3cyIGltYWdlIGZpbGUgd2lsbCBoYXZlIGV4dGVudHMgYWxsb2Nh
dGVkIGluCj4gICAgICBtdWx0aXBsZXMgb2YgMU1CLgo+IAo+ICAgIENoZWVycywKPiAgICBEYXZl
Lgo+ICAgIC0tCj4gICAgRGF2ZSBDaGlubmVyCj4gICAgWzJdZGF2aWRAZnJvbW9yYml0LmNvbQo+
IAo+ICAgIC0tCj4gICAgLS0tCj4gICAgQmxvZzogWzNdaHR0cDovL3d3dy5jaGVuem9uZ3poaS5p
bmZvCj4gICAgVHdpdHRlcjogWzRdaHR0cHM6Ly90d2l0dGVyLmNvbS9iYW90aWFvCj4gICAgR2l0
OiBbNV1odHRwczovL2dpdGh1Yi5jb20vYmFvdGlhbwo+IAo+IFJlZmVyZW5jZXMKPiAKPiAgICAx
LiBtYWlsdG86ZGF2aWRAZnJvbW9yYml0LmNvbQo+ICAgIDIuIG1haWx0bzpkYXZpZEBmcm9tb3Ji
aXQuY29tCj4gICAgMy4gaHR0cDovL3d3dy5jaGVuem9uZ3poaS5pbmZvLwo+ICAgIDQuIGh0dHBz
Oi8vdHdpdHRlci5jb20vIyEvYmFvdGlhbwo+ICAgIDUuIGh0dHBzOi8vZ2l0aHViLmNvbS9iYW90
aWFvCgo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4g
eGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL3hmcwoKCi0tIApDYXJsb3MKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29t
Cmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
