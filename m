Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 234637FF0
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 13:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0D00AC003
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 11:50:51 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id j0gWP50KiAaVlCxb
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 11:50:50 -0700 (PDT)
Message-ID: <533EFF07.6050308@hardwarefreak.com>
Date: Fri, 04 Apr 2014 13:50:47 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs umount with i/o error hang/memory corruption
References: <CALjwKZAJ-R8dS13Rsj3+K3hM9p0z08qvi4ZVTYbDWKT1Biu=-Q@mail.gmail.com>
In-Reply-To: <CALjwKZAJ-R8dS13Rsj3+K3hM9p0z08qvi4ZVTYbDWKT1Biu=-Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Bob Mastors <bob.mastors@solidfire.com>, xfs@oss.sgi.com

T24gNC80LzIwMTQgMToxNSBQTSwgQm9iIE1hc3RvcnMgd3JvdGU6Cj4gR3JlZXRpbmdzLAo+IAo+
IEkgYW0gbmV3IHRvIHhmcyBhbmQgYW0gcnVubmluZyBpbnRvIGEgcHJvYmxlbQo+IGFuZCB3b3Vs
ZCBhcHByZWNpYXRlIGFueSBndWlkYW5jZSBvbiBob3cgdG8gcHJvY2VlZC4KPiAKPiBBZnRlciBh
biBpL28gZXJyb3IgZnJvbSB0aGUgYmxvY2sgZGV2aWNlIHRoYXQgeGZzIGlzIHVzaW5nLAo+IGFu
IHVtb3VudCByZXN1bHRzIGluIGEgbWVzc2FnZSBsaWtlOgo+IFsgIDM3MC42MzY0NzNdIFhGUyAo
c2R4KTogTG9nIEkvTyBFcnJvciBEZXRlY3RlZC4gIFNodXR0aW5nIGRvd24gZmlsZXN5c3RlbQo+
IFsgIDM3MC42NDQwNzNdIFhGUyAoaCAgICAgICAgICAg77+977+977+9aCJoICAgICAgICAgIO+/
ve+/ve+/vUgjaCAgICAgICAgICDvv73vv73vv71ic2cpOgo+IFBsZWFzZSB1bW91bnQgdGhlIGZp
bGVzeXN0ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykKPiBOb3RlIHRoZSBnYXJiYWdlIG9u
IHRoZSBwcmV2aW91cyBsaW5lIHdoaWNoIHN1Z2dlc3RzIG1lbW9yeSBjb3JydXB0aW9uLgo+IEFi
b3V0IGhhbGYgdGhlIHRpbWUgSSBnZXQgdGhlIGdhcmJsZWQgbG9nIG1lc3NhZ2UuIEFib3V0IGhh
bGYgdGhlIHRpbWUKPiB1bW91bnQgaGFuZ3MuCj4gCj4gQW5kIHRoZW4gSSBnZXQgdGhpcyBraW5k
IG9mIGVycm9yIGFuZCB0aGUgc3lzdGVtIGlzIHVucmVzcG9uc2l2ZToKPiBNZXNzYWdlIGZyb20g
c3lzbG9nZEBkZWJpYW4gYXQgQXByICA0IDA5OjI3OjQwIC4uLgo+ICBrZXJuZWw6WyAgNjgwLjA4
MDAyMl0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMyIHN0dWNrIGZvciAyMnMhIFt1bW91bnQ6Mjg0
OV0KPiAKPiBUaGUgcHJvYmxlbSBhcHBlYXJzIHRvIGJlIHNpbWlsYXIgdG8gdGhpcyBpc3N1ZToK
PiBodHRwOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXhmcy9tc2cwMDA2MS5odG1sCj4g
Cj4gSSBjYW4gcmVwcm9kdWNlIHRoZSBwcm9ibGVtIGVhc2lseSB1c2luZyBvcGVuLWlzY3NpIHRv
IGNyZWF0ZQo+IHRoZSBibG9jayBkZXZpY2Ugd2l0aCBhbiBpc2NzaSBpbml0aWF0b3IuCj4gSSB1
c2UgbGlvIHRvIGNyZWF0ZSBhbiBpc2NzaSB0YXJnZXQuCj4gCj4gVGhlIHByb2JsZW0gaXMgdHJp
Z2dlcmVkIGJ5IGRvaW5nIGFuIGlzY3NpIGxvZ291dCB3aGljaCBjYXVzZXMKPiB0aGUgYmxvY2sg
ZGV2aWNlIHRvIHJldHVybiBpL28gZXJyb3JzIHRvIHhmcy4KPiBTdGVwcyB0byByZXByb2R1Y2Ug
dGhlIHByb2JsZW0gYXJlIGJlbG93LgoKVGhpcyBpcyBub3QgYSBwcm9ibGVtIGJ1dCB0aGUgZXhw
ZWN0ZWQgYmVoYXZpb3IuICBYRlMgaXMgZGVzaWduZWQgdG8gZG8KdGhpcyB0byBwcmV2ZW50IGZp
bGVzeXN0ZW0gY29ycnVwdGlvbi4gIExvZ2dpbmcgb3V0IG9mIGEgTFVOIGlzIG5vCmRpZmZlcmVu
dCB0aGFuIHB1bGxpbmcgdGhlIHBvd2VyIHBsdWcgb24gYSBkaXJlY3QgYXR0YWNoZWQgZGlzayBk
cml2ZS4KU3VyZWx5IHlvdSB3b3VsZCBub3QgZG8gdGhhdCB0byBhIHJ1bm5pbmcgZmlsZXN5c3Rl
bS4KCj4gVXNpbmcgVmlydHVhbEJveCwgSSBjYW4gcmVwcm9kdWNlIGl0IHdpdGggdHdvIHByb2Nl
c3NvcnMgYnV0IG5vdCBvbmUuCj4gSSBmaXJzdCBzYXcgdGhpcyBvbiBhIDMuOCBrZXJuZWwgYW5k
IG1vc3QgcmVjZW50bHkgcmVwcm9kdWNlZCBpdCB3aXRoIDMuMTQrLgouLi4KClRoZSBvbmx5IHBy
b2JsZW0gSSBzZWUgaGVyZSBpcyB0aGF0IFhGUyBzaG91bGQgYmUgc2h1dHRpbmcgZG93biBldmVy
eQp0aW1lIHRoZSBkaXNrIGRldmljZSBkaXNhcHBlYXJzLiAgV2hpY2ggbWVhbnMgaW4geW91ciB0
ZXN0IGNhc2VzIHdoZXJlCml0IGRvZXMgbm90LCB5b3VyIFZNIGVudmlyb25tZW50IGlzbid0IHBh
c3NpbmcgdGhlIElPIGVycm9ycyB1cCB0aGUKc3RhY2ssIGFuZCBpdCBzaG91bGQgYmUuICBXaGlj
aCBtZWFucyB5b3VyIFZNIGVudmlyb25tZW50IGlzIGJyb2tlbi4KCkNoZWVycywKClN0YW4KCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGlu
ZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5m
by94ZnMK
