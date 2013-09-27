Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53DDF7F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 13:01:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE905AC005
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:01:18 -0700 (PDT)
Received: from mail-qe0-f46.google.com (mail-qe0-f46.google.com
	[209.85.128.46]) by cuda.sgi.com with ESMTP id Hk312XUMC0LVZD94
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:01:17 -0700 (PDT)
Received: by mail-qe0-f46.google.com with SMTP id x7so2079659qeu.33
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:01:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
References: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
	<CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
Date: Fri, 27 Sep 2013 15:01:16 -0300
Message-ID: <CAGG-pUSiKyXSg7P+XnW965GoVQLib3FdZyCreXS8VDK8cLxnBA@mail.gmail.com>
Subject: Re: [XFS MAINTAINERS] fs/xfs/xfs_dir2_node.c: xfs:
	xfs_dir2_leafn_add: Variables Uninitialized
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

SGkgTWFpbnRhaW5lcnMsCgpJIHN1cHBvc2UgdGhlIHZhcmlhYmxlcyAiaGlnaHN0YWxlIiBhbmQg
Imxvd3N0YWxlIiBhcmUgYmVpbmcgdXNlZApkZXNwaXRlIG5vdCBoYXZpbmcgYmVlbiBpbml0aWFs
aXplZC4KCkZpbGU6IGZzL3hmcy94ZnNfZGlyMl9ub2RlLmMKRnVuY3Rpb246IHhmc19kaXIyX2xl
YWZuX2FkZAoKTDQ5MToKPiAvKgo+ICogSW5zZXJ0IHRoZSBuZXcgZW50cnksIGxvZyBldmVyeXRo
aW5nLgo+ICovCj4gbGVwID0geGZzX2RpcjNfbGVhZl9maW5kX2VudHJ5KCZsZWFmaGRyLCBlbnRz
LCBpbmRleCwgY29tcGFjdCwgbG93c3RhbGUsCj4gaGlnaHN0YWxlLCAmbGZsb2dsb3csICZsZmxv
Z2hpZ2gpOwoKVGhlIG9ubHkgcGxhY2UgdGhleSBhcmUgc3RhcnRlZCB1cCBpcyB3aXRoaW4gdGhp
cyBjb25kaXRpb246CgpMNDgwOgo+IGlmIChjb21wYWN0KQo+IHhmc19kaXIzX2xlYWZfY29tcGFj
dF94MSgmbGVhZmhkciwgZW50cywgJmluZGV4LCAmbG93c3RhbGUsCj4gJmhpZ2hzdGFsZSwgJmxm
bG9nbG93LCAmbGZsb2doaWdoKTsKClNvLCBpZiBpdCBpcyBub3QgY29tcGFjdCwgYm90aCBoYXZl
IGdhcmJhZ2UuCgpCZXN0IFJlZ2FyZHMuCgpHZXlzbGFuIEdyZWfDs3JpbyBCZW0KCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QK
eGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
