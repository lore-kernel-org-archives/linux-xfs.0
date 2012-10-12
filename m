Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5m23w073761 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:48:02 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xpXxFkTyzS7amQqH for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 22:49:33 -0700 (PDT)
Date: Fri, 12 Oct 2012 16:49:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: avoid underflow in xfs_ioc_trim()
Message-ID: <20121012054927.GM2739@dastard>
References: <1349944432-13776-1-git-send-email-lczerner@redhat.com>
	<20121011213533.GE2739@dastard>
	<alpine.LFD.2.00.1210120727170.6401@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210120727170.6401@localhost>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBPY3QgMTIsIDIwMTIgYXQgMDc6MzU6MzlBTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIEZyaSwgMTIgT2N0IDIwMTIsIERhdmUgQ2hpbm5lciB3cm90ZToKPiAKPiA+
IERhdGU6IEZyaSwgMTIgT2N0IDIwMTIgMDg6MzU6MzMgKzExMDAKPiA+IEZyb206IERhdmUgQ2hp
bm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4KPiA+IFRvOiBMdWthcyBDemVybmVyIDxsY3plcm5l
ckByZWRoYXQuY29tPgo+ID4gQ2M6IHhmc0Bvc3Muc2dpLmNvbQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2Ml0geGZzOiBhdm9pZCB1bmRlcmZsb3cgaW4geGZzX2lvY190cmltKCkKPiA+IAo+ID4g
T24gVGh1LCBPY3QgMTEsIDIwMTIgYXQgMTA6MzM6NTJBTSArMDIwMCwgTHVrYXMgQ3plcm5lciB3
cm90ZToKPiA+ID4gQ3VycmVudGx5IGlmIGxlbiBhcmd1bWVudCBpbiB4ZnNfaW9jX3RyaW0oKSBp
cyBzbWFsbGVyIHRoYW4gb25lIEZTQgo+ID4gPiB0aGUgJ2VuZCcgdmFyaWFibGUgdW5kZXJmbG93
LiBBdm9pZCB0aGF0IGJ5IHJldHVybmluZyBFSU5WQUwgd2hlbgo+ID4gPiByYW5nZSBpcyBzbWFs
bGVyIHRoYW4gRlNCLgo+ID4gPiAKPiA+ID4gU2lnbmVkLW9mZi1ieTogTHVrYXMgQ3plcm5lciA8
bGN6ZXJuZXJAcmVkaGF0LmNvbT4KPiA+IAo+ID4gSnVzdCBhIHRob3VnaHQgLSB3b3VsZG4ndCB0
aGlzIGJlIGJldHRlciBkb25lIGF0IHRoZSBWRlMgc28gaXQgaXMKPiA+IGNvbnNpc3RlbnQgYWNy
b3NzIGFsbCBmaWxlc3lzdGVtcz8gaS5lLiB1c2luZyBpbm9kZS0+aV9ibGtiaXRzPwo+ID4gCj4g
PiBDaGVlcnMsCj4gPiAKPiA+IERhdmUuCj4gCj4gQ3VycmVudGx5IEkgYW0gd29ya2luZyBvbiBw
YXRjaGVzIGZvciBvdGhlciBmaWxlIHN5c3RlbSwgc28gd2UnbGwKPiBnZXQgaXQgZml4LiBIYXZp
bmcgdGhlIGNoZWNrIGluIFZGUyB3b3VsZCByZXF1aXJlIHRvIG1ha2UgRklUUklNCj4gZmlsZSBz
eXN0ZW0gKGlub2RlPykgb3BlcmF0aW9uCgpOb3QgYXQgYWxsIC0gZmlscC0+bWFwcGluZy0+aG9z
dCBnZXRzIHlvdSB0aGUgaW5vZGUuLi4uCj4KPiAsIG9yIGFkZGluZyBjbWQgc3BlY2lmaWMgc2Vj
dGlvbnMgdG8KPiB0aGUgdmZzX2lvY3RsKCkuCgpCdXQgdGhhdCdzIGEgZmFpciByZWFzb24gbm90
IHRvLi4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQu
Y29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
