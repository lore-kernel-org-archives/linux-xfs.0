Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Lbjk8109619 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 16:37:45 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	z4EXrCdxNSxbhGFx for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 14:39:14 -0700 (PDT)
Date: Wed, 10 Oct 2012 08:39:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] 260: Add another corner case where length is zero
Message-ID: <20121009213913.GQ23644@dastard>
References: <1349785012-28588-1-git-send-email-lczerner@redhat.com>
	<20121009194019.GJ23644@dastard>
	<alpine.LFD.2.00.1210092320480.2326@(none)>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210092320480.2326@(none)>
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

T24gVHVlLCBPY3QgMDksIDIwMTIgYXQgMTE6MjM6MTNQTSArMDIwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+IE9uIFdlZCwgMTAgT2N0IDIwMTIsIERhdmUgQ2hpbm5lciB3cm90ZToKPiAKPiA+
IERhdGU6IFdlZCwgMTAgT2N0IDIwMTIgMDY6NDA6MTkgKzExMDAKPiA+IEZyb206IERhdmUgQ2hp
bm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4KPiA+IFRvOiBMdWthcyBDemVybmVyIDxsY3plcm5l
ckByZWRoYXQuY29tPgo+ID4gQ2M6IHhmc0Bvc3Muc2dpLmNvbQo+ID4gU3ViamVjdDogUmU6IFtQ
QVRDSF0gMjYwOiBBZGQgYW5vdGhlciBjb3JuZXIgY2FzZSB3aGVyZSBsZW5ndGggaXMgemVybwo+
ID4gCj4gPiBPbiBUdWUsIE9jdCAwOSwgMjAxMiBhdCAwMjoxNjo1MlBNICswMjAwLCBMdWthcyBD
emVybmVyIHdyb3RlOgo+ID4gPiBUaGlzIGNvbW1pdCBhZGRzIGFub3RoZXIgY29ybmVyIGNhc2Ug
dG8gdGVzdCBGSVRSSU0gYXJndW1lbnQgaGFuZGxpbmcuCj4gPiA+IEluIHRoaXMgY2FzZSB3ZSBz
ZXQgbGVuZ3RoIHRvIHplcm8gYW5kIHdlIGV4cGVjdCB0aGUgbnVtYmVyIG9mIGRpc2NhcmRlZAo+
ID4gPiBieXRlcyB0byBiZSBvYnZpb3VzbHkgemVybywgaG93ZXZlciB3ZSd2ZSBoYWQgYnVnIGlu
IGJvdGggZXh0NCBhbmQgeGZzCj4gPiA+IHdoZXJlIHRoZSBpbnRlcm5hbCB2YXJpYWJsZSB3b3Vs
ZCB1bmRlcmZsb3cuIFRoaXMgdGVzdCBjYXNlIHdpbGwgYmUgYWJsZQo+ID4gPiB0byBjYXRjaCB0
aGF0IGluIGZ1dHVyZS4KPiA+ID4gCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEx1a2FzIEN6ZXJuZXIg
PGxjemVybmVyQHJlZGhhdC5jb20+Cj4gPiAKPiA+IEknZCBjcmVhdGUgYW5vdGhlciB0ZXN0IGZv
ciB0aGlzLCByYXRoZXIgdGhhbiBtYWtpbmcgMjYwIHN1ZGRlbmx5Cj4gPiBmYWlsIGZvciBldmVy
eW9uZS4uLi4KPiAKPiBIbW0sIEkgYW0gbm90IHN1cmUgd2hhdCBpcyB0aGUgcG9pbnQuIEkndmUg
Y3JlYXRlZCAyNjAgZXhhY3RseSBmb3IKPiB0aGlzIHJlYXNvbiBvZiB0ZXN0aW5nIEZJVFJJTSBh
cmd1bWVudCBoYW5kbGluZyBhbmQgaXQgYWxyZWFkeQo+IGNvbnRhaW5zIG51bWJlciBvZiB0ZXN0
cyBsaWtlIHRoaXMgb25lLiBJIGFtIG5vdCBzdHJvbmdseSBhZ2FpbnN0Cj4gaGF2aW5nIHRoaXMg
aW4gc2VwYXJhdGUgdGVzdCwgaG93ZXZlciBpdCBzZWVtcyByYXRoZXIgdW5uZWNlc3NhcnkgdG8K
PiBtZS4KCklUJ3MgYSByZWdyZXNzaW9uIHRlc3QgLSBpdCdzIG9ubHkgc3VwcG9zZWQgdG8gc3Rh
cnQgZmFpbGluZyB3aGVuCnRoZSBrZXJuZWwgZnVuY3Rpb25hbGl0eSBpcyBicm9rZW4uICBUaGF0
IGlzLCBzb21lb25lIHdobyBpcwp0cmFja2luZyBmYWlsdXJlcyBvdmVyIHRpbWUgd2lsbCBzdWRk
ZW5seSBzZWUgYSBuZXcgZmFpbHVyZSBpbiAyNjAKYW5kIHdvbmRlciB3aGF0IGtlcm5lbCBjb2Rl
IGJyb2tlLCB3aGVuIGluIGZhY3Qgbm90aGluZyB3YXMgY2hhbmdlZAppbiB0aGUga2VybmVsIGNv
ZGUuIElPV3MsIGNoYW5naW5nIHRoZSB0ZXN0IGludmFsaWRhdGVzIGFsbCBwYXN0Cmhpc3Rvcnkg
b2YgcnVubmluZyB0aGUgdGVzdCwgYW5kIHRoYXQgaW4gdHVybiBicmVha3MgaGlzdG9yaWMKcmVn
cmVzc2lvbiB0cmFja2luZyBtZXRyaWNzLi4uCgpUaGlzIGlzIHdoeSB3ZSBoaXN0b3JpY2FsbHkg
aGF2ZSBhdm9pZGVkIGNoYW5naW5nIGV4aXN0aW5nIHRlc3RzIGFuZAppbnN0ZWFkIHdyb3RlIG5l
dyB0ZXN0cywgbm8gbWF0dGVyIGhvdyBzaW1pbGFyIHRoZSBmdW5jdGlvbmFsaXR5CmJldHdlZW4g
dGhlIG9sZCBhbmQgbmV3IHRlc3RzIGFyZS4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5u
ZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
