Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p182PBKC084399 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 20:25:11 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B25251234C99
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 18:27:44 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	Ob9M4Iot2gF5Y28H for <xfs@oss.sgi.com>;
	Mon, 07 Feb 2011 18:27:44 -0800 (PST)
Received: by vxc38 with SMTP id 38so2221147vxc.26
	for <xfs@oss.sgi.com>; Mon, 07 Feb 2011 18:27:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297128931.2078.32.camel@doink>
References: <AANLkTi=wi_Fhr5v1J4wopvFTY=hC2EA_QmJu4Uc_XgGs@mail.gmail.com>
	<AANLkTi=7dw1-r8BSdv7y51LzmWekxKjLrCv_Rky7EYx9@mail.gmail.com>
	<1297128931.2078.32.camel@doink>
Date: Tue, 8 Feb 2011 11:27:43 +0900
Message-ID: <AANLkTi=q1eh2zU26PRfSUt0sf1Spbui2VhB1ehCa4Ay8@mail.gmail.com>
Subject: Re: mkfs.xfs pagefault when removed storage during operation
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

T24gVHVlLCBGZWIgOCwgMjAxMSBhdCAxMDozNSBBTSwgQWxleCBFbGRlciA8YWVsZGVyQHNnaS5j
b20+IHdyb3RlOgo+IE9uIFdlZCwgMjAxMS0wMi0wMiBhdCAxNzowOSArMDkwMCwgQWplZXQgWWFk
YXYgd3JvdGU6Cj4+IElmIEkgc2VlIHRoZSBjdXJyZW50IHNpZ2ZhdWx0LCBpdHMgZWFzeSB0byBm
aXggYWRkaW5nIG9uZSBtb3JlIHBhdGNoCj4+IHRvIHhmc3Byb2dzLgo+IC4gLiAuCj4+Cj4+IEJ1
dCB3aGVuIEkgc3RhcnQgcmV2aWV3aW5nIHRoZSBjb21wbGV0ZSBwcm9qZWN0IHcuci50IHJlYWQo
KSAvCj4+IHJlYWQ2NCgpIC8gd3JpdGUoKSAvIHdyaXRlNjQoKSBtb3JlIGltcG9ydGFudGx5IGxp
Ynhmc19yZWFkYnVmcigpIC8KPj4gbGlieGZzX3dyaXRlYnVmcigpLgo+PiBJIGZpbmQgZXJyb3Ig
aGFuZGluZyBpcyBicm9rZW4gYXQgbWF5IHBsYWNlcyBhbmQgSSBnZXQgbXkgc2VsZiBsb3N0IGlu
Cj4+IG1ebiBjb21wbGV4aXR5IGFsc28gZXJybm8gaXMgbG9zdC4uIHRoZXJlZm9yZSBjYWxsZXIg
Y2Fubm90IGV4YW1pbmUKPj4gdGhlIGV4YWN0IGVycm9yLAo+Pgo+PiBCYWNrIGFnYWluIEkgdGhp
bmssIFdoYXQgaWYgSSBleGl0IG9uIGVycm9yID8gRG9lcyB4ZnNwcm9ncyB1c2VzCj4+IHJlYWQo
KSAvIHdyaXRlKCkgZXJyb3IgYXMgYSBwYXJ0IG9mIGl0cyBmdW5jdGlvbmFsaXR5LCBmb3IgZXhh
bXBsZQo+PiBkb2VzIHhmc19yZXBhaXIgdXNlcyB0aGVzZSBlcnJvcnMgYXMgYSBwYXJ0IG9mIHJl
cGFpciBmdW50aW9uYWxpdHkuCj4gLiAuIC4KPgo+IEkgdGhpbmsgdGhlc2UgYXJlIGdvb2Qgb2Jz
ZXJ2YXRpb25zIGFuZCBxdWVzdGlvbnMuCj4KPiBUaGlzIGRvZXNuJ3QgYW5zd2VyIHlvdXIgcXVl
c3Rpb25zLCBidXQgSSB3YW50IHRvIG1lbnRpb24gdG8KPiB5b3UgdGhhdCBsaWJ4ZnMgaXMganVz
dCBhYm91dCB0byBoYXZlIGEgbWFqb3IgdXBkYXRlIHRoYXQKPiBhZmZlY3RzIGxvdHMgb2YgZmls
ZXMuIMKgSSBleHBlY3QgdGhlIHVwZGF0ZSB3aWxsICpub3QqCj4gYWRkcmVzcyB0aGUgaXNzdWVz
IHlvdSBwb2ludCBvdXQgaGVyZSwgYnV0IEkgZ3Vlc3Mgd2hhdCBJJ2QKPiBsaWtlIHRvIGRvIGlz
IGdldCB1cyBtb3ZlZCB0byB0aGUgdXBkYXRlZCBjb2RlIGJlZm9yZSB0cnlpbmcKPiB0byBhZGRy
ZXNzIHByb2JsZW1zIHRoYXQgbWlnaHQgYmUgd2lkZXNwcmVhZCBsaWtlIHRoaXMuCj4KPiBJIGhv
cGUgdG8gY29tcGxldGUgdGhpcyB1cGRhdGUgcHJvY2VzcyBzb29uLCBidXQgSSBleHBlY3QKPiBp
dCB3aWxsIGJlIGEgd2VlayBvciBtb3JlIGJlZm9yZSB0aGF0IGhhcHBlbnMuCj4KPiDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoC1BbGV4
Cj4KPgpUaGFua3MsIEkgYW0gd2FpdGluZyBmb3IgdGhlIG5leHQgcmVsZWFzZSBvZiB4ZnNwcm9n
cy4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
