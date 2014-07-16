Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9ECC87FE7
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 18:32:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EDBB304051
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 16:32:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	99TmbhamaEjXCCkF for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 16:32:51 -0700 (PDT)
Date: Thu, 17 Jul 2014 09:32:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Detect strto* failures based on errno.
Message-ID: <20140716233249.GG4453@dastard>
References: <20140713230406.GE22339@dastard>
	<1405324619-25515-1-git-send-email-arekm@maven.pl>
	<20140716030132.GB20518@dastard>
	<201407160944.07266.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201407160944.07266.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gV2VkLCBKdWwgMTYsIDIwMTQgYXQgMDk6NDQ6MDdBTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IE9uIFdlZG5lc2RheSAxNiBvZiBKdWx5IDIwMTQsIERhdmUgQ2hpbm5l
ciB3cm90ZToKPiA+IE9uIE1vbiwgSnVsIDE0LCAyMDE0IGF0IDA5OjU2OjU5QU0gKzAyMDAsIEFy
a2FkaXVzeiBNacWba2lld2ljeiB3cm90ZToKPiA+ID4gQ29kZSB3YXMgdGVzdGluZyBmb3IgRVJB
TkdFIGVycm5vIG9ubHkgaW4gc29tZSBwbGFjZXMuIEluIG90aGVyIHBsYWNlcwo+ID4gPiBpdCBk
aWRuJ3QgZG8gYW55IGVycm5vIGNoZWNraW5nIGF0IGFsbC4KPiA+ID4gCj4gPiA+IFVuaWZ5IHN0
cnRvKiByZXN1bHQgdGVzdGluZyBieSB0cmVhdGluZyBhbnkgbm9uIHplcm8gZXJybm8gYXMgZmFp
bHVyZS4KPiA+ID4gCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8
YXJla21AbWF2ZW4ucGw+Cj4gPiAKPiA+IFRoaXMgcGF0Y2ggYXBwZWFycyB0byBjYXVzZSB4ZnMv
MDcxIHRvIGZhaWw6Cj4gPiAKPiA+IAo+ID4gCj4gPiAgICAgIFdyaXRpbmcgNTEyIGJ5dGVzLCBv
ZmZzZXQgaXMgKzAgKGRpcmVjdD1mYWxzZSkKPiA+ICAgICAtcHdyaXRlNjQ6IEZpbGUgdG9vIGxh
cmdlCj4gPiAgICAgK25vbi1udW1lcmljIG9mZnNldCBhcmd1bWVudCAtLSA8T0ZGU0VUPgo+ID4g
ICAgICBSZWFkaW5nIDUxMiBieXRlcyAoZGlyZWN0PWZhbHNlKQo+ID4gICAgICByZWFkIDAvNTEy
IGJ5dGVzIGF0IG9mZnNldCA8T0ZGU0VUPgo+ID4gICAgIC4uLgo+ID4gICAgIChSdW4gJ2RpZmYg
LXUgdGVzdHMveGZzLzA3MS5vdXQKPiA+IC9ob21lL2RhdmUvc3JjL3hmc3Rlc3RzLWRldi9yZXN1
bHRzLy94ZnMvMDcxLm91dC5iYWQnICB0byBzZWUgdGhlIGVudGlyZQo+ID4gZGlmZikKPiA+IAo+
ID4gQ2FuIHlvdSBoYXZlIGEgbG9vayBpbnRvIHRoaXM/Cj4gCj4gVGhlIHRlc3QgcnVuczoKPiB4
ZnNfaW8gLWMgJ3B3cml0ZSA5MjIzMzczMTM2MzY2NDAzNTgzIDUxMicgZmlsZQo+IAo+IHdoZXJl
IDkyMjMzNzMxMzYzNjY0MDM1ODMgaXMgYmlnZ2VyIHRoYW4gTExPTkdfTUFYICg5MjIzMzcyMDM2
ODU0Nzc1ODA3KSwgc28KPiAKPiAjIExDX0FMTD1DIHhmc19pbyAtYyAncHdyaXRlIDkyMjMzNzMx
MzYzNjY0MDM1ODMgNTEyJyAuL3gKPiAoTVlERUJVRylzdHJlcnJvcigzNCk6IE51bWVyaWNhbCBy
ZXN1bHQgb3V0IG9mIHJhbmdlCj4gbm9uLW51bWVyaWMgb2Zmc2V0IGFyZ3VtZW50IC0tIDkyMjMz
NzMxMzYzNjY0MDM1ODMKPiAKPiAKPiBXaGF0IHdvdWxkIGJlIGJlc3QgYXBwcm9hY2ggdG8gZml4
IHRoaXMgLSBzb21lIGN2dHVudW0gZm9yIHVuc2lnbmVkIGxvbmcgbG9uZz8KCkknbSBwcmV0dHkg
c3VyZSB0aGF0IGN2dG51bSBpcyBvbmx5IHN1cHBvc2VkIHRvIHdvcmsgd2l0aCBwb3NpdGl2ZQpp
bnRlZ2VycyAtIGl0IHJldHVybnMgbmVnYXRpdmUgdmFsdWVzIGFzIGFuIGVycm9yLiBoZW5jZSBq
dXN0CmNoYW5naW5nIHRvIHVzZSBzdHJ0b3VsbCgpIHdvdWxkIHByb2JhYmx5IGZpeCB0aGUgaXNz
dWUuCgpUaGUgY2FsbGVyIGNhbiBkZXRlcm1pbmUgaWYgYSBuZWdhdGl2ZSBudW1iZXIgaXMgdmFs
aWQgb3Igbm90Li4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9t
b3JiaXQuY29tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
