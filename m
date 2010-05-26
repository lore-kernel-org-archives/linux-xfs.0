Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q743ZA067504 for <xfs@oss.sgi.com>; Wed, 26 May 2010 02:04:03 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87FB4A4CD28
	for <xfs@oss.sgi.com>; Wed, 26 May 2010 00:08:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	qbziKBRd5iHa2Dp5 for <xfs@oss.sgi.com>;
	Wed, 26 May 2010 00:08:08 -0700 (PDT)
Date: Wed, 26 May 2010 17:06:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100526070620.GT2150@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
	<20100524143428.6f3a117c@abend.internal.xtremedata.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100524143428.6f3a117c@abend.internal.xtremedata.com>
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
To: Roman Kononov <roman@binarylife.net>
Cc: xfs@oss.sgi.com

T24gTW9uLCBNYXkgMjQsIDIwMTAgYXQgMDI6MzQ6MjhQTSAtMDUwMCwgUm9tYW4gS29ub25vdiB3
cm90ZToKPiBPbiBTdW4sIDIzIE1heSAyMDEwIDIzOjEyOjI0IC0wNTAwIFN0YW4gSG9lcHBuZXIK
PiA8c3RhbkBoYXJkd2FyZWZyZWFrLmNvbT4gd3JvdGU6Cj4gPiAiVGhlIHdob2xlIG5vdGlvbiBv
ZiAiZGlyZWN0IElPIiBpcyB0b3RhbGx5IGJyYWluZGFtYWdlZC4gSnVzdCBzYXkgbm8uCj4gLi4u
Cj4gPiBGcm9tOiAgaHR0cDovL2xrbWwub3JnL2xrbWwvMjAwNy8xLzEwLzIzNQo+IAo+IEkgZGVm
aW5pdGVseSBtZWFzdXJlIGRyYW1hdGljIG92ZXJhbGwgcGVyZm9ybWFuY2UgYmVuZWZpdCB1c2lu
Zwo+IE9fRElSRUNUIGNhcmVmdWxseS4KPiAKPiBJbiB0aGF0IHRocmVhZCwgaXQgaXMgZG91YnRm
dWwgdGhhdCBtYWR2aXNlK21tYXArbXN5bmMgYWxsb3cKPiBhc3luY2hyb25vdXMgemVyby1jb3B5
IHJlYWRzIGFuZCB3cml0ZXMgdG8vZnJvbSBhbHJlYWR5IHBpbm5lZCBieSBhCj4gZGV2aWNlIGRy
aXZlciBtZW1vcnkgb2YgZGF0YSBwcm9kdWNlZC9jb25zdW1lZCBieSB0aGF0IGRldmljZSwgd2l0
aG91dAo+IGNhY2hlIHBvbGx1dGlvbiBhbmQgd2l0aCBpbnRlbGxpZ2VudCBoYW5kbGluZyBvZiBk
aXNrIGVycm9ycy4gQW0gSQo+IHdyb25nPwoKTm8sIHlvdSBhcmUgbm90IHdyb25nLgoKUmVtZW1i
ZXIsIGp1c3QgYmVjYXVzZSBMaW51cyBhc3NlcnRzIHNvbWV0aGluZyBpdCBkb2Vzbid0IG1lYW4g
aGUgaXMKcmlnaHQuIFllcywgaGUncyByaWdodCBhbiBhd2Z1bCBsb3Qgb2YgdGhlIHRpbWUsIGJ1
dCBub3QgYWx3YXlzLiAgSW4KdGhpcyBjYXNlLCBtb3N0IHBlb3BsZSB3aXRoIGV4cGVyaWVuY2Ug
aW4gd3JpdGluZyBoaWdoIHBlcmZvcm1hbmNlCklPIGVuZ2luZXMgd2l0aCB0ZWxsIHlvdXIgdGhh
dCBtbWFwKCkgYW5kIGFkdmlzb3J5IGludGVyZmFjZXMgYXJlIG5vCnN1YnN0aXR1dGUgZm9yIHRo
ZSBmaW5lIGdyYWluZWQgY29udHJvbCBvZiBJTyBpc3N1ZSB0aGF0IGRpcmVjdCBJTwpwcm92aWRl
cyB5b3Ugd2l0aC4KCkFuZCBpbiB0aGUgY2FzZSBvZiBYRlMsIG1tYXAgc2VyaWFsaXNl0ZUgd3Jp
dGUgcGFnZSBmYXVsdHMgdG8KZGlmZmVyZW50IGFyZWFzIG9mIHRoZSBzYW1lIGZpbGUsIHdoZXJl
YXMgZGlyZWN0IElPIGFsbG93cwpjb25jdXJyZW50IHJlYWRzIGFuZCB3cml0ZXMgdG8gZGlmZmVy
ZW50IHJlZ2lvbnMgb2YgdGhlIHNhbWUgZmlsZS4KVGhhdCBtYWtlcyBkaXJlY3QgSU8gZmFyIG1v
cmUgc2NhbGFibGUgdGhhbiB0aGFuIGFueSBtbWFwIGludGVyZmFjZQp3aWxsIGV2ZXIgYmUuLi4u
CgpDaGVlcnMsCgpEYXZlLgotLSAKRGF2ZSBDaGlubmVyCmRhdmlkQGZyb21vcmJpdC5jb20KCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5n
IGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZv
L3hmcwo=
