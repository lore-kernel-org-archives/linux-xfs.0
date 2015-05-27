Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 00E367F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 12:17:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8FDF8F8089
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 10:17:55 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Nte1I2WwjeBCidGv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 10:17:51 -0700 (PDT)
Date: Wed, 27 May 2015 10:17:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
Message-ID: <20150527171738.GD10175@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225132.26434.82404.stgit@birch.djwong.org>
	<20150527054536.GB10175@birch.djwong.org>
	<5565DAA7.4040406@sandeen.net> <5565DFEB.9040000@sandeen.net>
	<5565E265.5040202@sandeen.net> <5565EB29.4080200@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5565EB29.4080200@gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

T24gV2VkLCBNYXkgMjcsIDIwMTUgYXQgMDY6MDQ6NTdQTSArMDIwMCwgRmFuYWVsIExpbml0aGll
biB3cm90ZToKPiBPbiAyMDE1LTA1LTI3IDE3OjI3LCBFcmljIFNhbmRlZW4gd3JvdGU6Cj4gPgo+
ID5JIHdvbmRlciBpZiBzb21ldGhpbmcgbGlrZToKPiA+Cj4gPgkvKiBMb29rIGZvciBWNSBmZWF0
dXJlIGZsYWdzIHdlIGRvbid0IGtub3cgYWJvdXQgKi8KPiA+CWlmIChYRlNfU0JfVkVSU0lPTl9O
VU0oc2IpID49IFhGU19TQl9WRVJTSU9OXzUgJiYKPiA+CSAgICAoeGZzX3NiX2hhc19yb19jb21w
YXRfZmVhdHVyZShzYiwgWEZTX1NCX0ZFQVRfUk9fQ09NUEFUX1VOS05PV04pIHx8Cj4gPgkgICAg
IHhmc19zYl9oYXNfaW5jb21wYXRfZmVhdHVyZShzYiwgWEZTX1NCX0ZFQVRfSU5DT01QQVRfVU5L
Tk9XTikgfHwKPiA+CSAgICAgeGZzX3NiX2hhc19jb21wYXRfZmVhdHVyZShzYiwgWEZTX1NCX0ZF
QVRfQ09NUEFUX1VOS05PV04pKSkgewo+ID4JCXByaW50ZigidW5rbm93biBmZWF0dXJlIGZsYWdz
IDB4JXgvMHgleC8weCV4XG4iLAo+ID4JCQlzYi0+c2JfZmVhdHVyZXNfcm9fY29tcGF0ICYgWEZT
X1NCX0ZFQVRfUk9fQ09NUEFUX1VOS05PV04sCj4gPgkJCXNiLT5zYl9mZWF0dXJlc19pbmNvbXBh
dCAmIFhGU19TQl9GRUFUX0lOQ09NUEFUX1VOS05PV04sCj4gPgkJCXNiLT5zYl9mZWF0dXJlc19j
b21wYXQgJiBYRlNfU0JfRkVBVF9DT01QQVRfVU5LTk9XTik7Cj4gPgkJLi4uCj4gPgo+ID53b3Vs
ZCBzdWZmaWNlLCBnaXZlbiB0aGF0IHRoZSB1c2VyIHdpbGwgbmVlZCB0byByZWFkIGNvZGUgdG8g
dW5lcnN0YW5kIHRoZSBoZXgKPiA+dmFsdWVzLCBhbnl3YXkuCgo8c2hydWc+IEkgZ3Vlc3MgcmVw
YWlyIGNvdWxkIGRvIHRoYXQuICBJJ2QgYnJva2VuIHRoaW5ncyBvdXQgc2VwYXJhdGVseQooa2V5
IHdvcmQ6IGJyb2tlbiA7KSkgdG8gYXZvaWQgY29tcGxhaW5pbmcgYWJvdXQgd2hpY2hldmVyIGZp
ZWxkcyBhcmVuJ3QKYnJva2VuLCBidXQgSSBzdXBwb3NlIGl0IGRvZXNuJ3QgcmVhbGx5IG1hdHRl
ci4KCj4gPgkKPiA+SG0sIGFuZCBhcyBGYW5hZWwgYWxzbyBwb2ludGVkIG91dCwgImNvbXBhdCIg
ZmVhdHVyZXMgLi4uIHNob3VsZCBiZSBvaywgcmlnaHQsCj4gPmFuZCBjYW4gYmUgcmVtb3ZlZCBm
cm9tIHRoZSBleGNsdXNpb25zPwo+IAo+IEknbSBub3QgZW50aXJlbHkgc3VyZSBzaWxlbnRseSBp
Z25vcmluZyB1bmtub3duIGNvbXBhdCBmZWF0dXJlcyBpbgo+IHhmc19yZXBhaXIgaXMgYSBnb29k
IGlkZWEuIENvbnNpZGVyIHRoaXMgZXh0MiBleGFtcGxlOiB4YXR0ciBzdXBwb3J0Cj4gaXMgYSBj
b21wYXQgZmxhZy4gSXQncyBva2F5IHRvIHJ3IG1vdW50IGEgRlMgd2l0aCB4YXR0cnMgb24gc29t
ZQo+IGFuY2llbnQgKG9yIG5vbi1MaW51eCkga2VybmVsIHdpdGhvdXQgeGF0dHIgc3VwcG9ydCDi
gJQgZXZlcnl0aGluZwo+IHdpbGwgYmUgZmluZSwgZXZlbiB0aG91Z2ggdGhlcmUncyBubyB3YXkg
dG8gYWNjZXNzIHRoZW0g4oCUIGJ1dCBpZiB0aGUKPiBmc2NrIHRvb2wgZG9lc24ndCB1bmRlcnN0
YW5kIHRoZW0sIGl0IHdvdWxkbid0IGJlIGFibGUgdG8gZGlhZ25vc2UKPiB4YXR0ciBjb3JydXB0
aW9uLgo+IAo+IEknZCBlaXRoZXIgd2FybiB0aGUgdXNlciBhYm91dCB1bmtub3duIGNvbXBhdCBm
ZWF0dXJlcywgdGVsbGluZyB0aGVtCj4gdGhleSdyZSBvbiB0aGVpciBvd24gaWYgc29tZXRoaW5n
IGluIHRoZSBGUyBpcyBzdGlsbCBicm9rZW47IG9yIGJhcmYKPiBvdXRyaWdodC4KCkkgcHJlZmVy
IGFueSByZXBhaXIgdG9vbCBiZSBmb3J0aGNvbWluZyBhYm91dCBub3Qga25vd2luZyB3aGF0IHNv
bWV0aGluZyBpcy4KCi0tRAoKPiAKPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3NzLnNnaS5jb20KPiBodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2ku
Y29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
