Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F5FB7F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 18:15:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EBB4304039
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 16:15:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lQvdbJ9Fa4HdDb8d for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 16:14:59 -0700 (PDT)
Message-ID: <53C06FF3.2090600@sandeen.net>
Date: Fri, 11 Jul 2014 18:14:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Catch under/overflow cases in cvtnum() and cvttime().
References: <1405107244-14234-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1405107244-14234-1-git-send-email-arekm@maven.pl>
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
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>, xfs@oss.sgi.com

T24gNy8xMS8xNCwgMjozNCBQTSwgQXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+IGN2dG51
bSgpIGFuZCBjdnR0aW1lKCkgc2lsZW50bHkgaWdub3JlIG92ZXJmbG93cy4gVGhpcyBsZWFkcyB0
byBlcnJvcgo+IGNvbmRpdGlvbnMgbm90IGJlaW5nIGNhdGNoZWQuIEV4YW1wbGU6Cj4gCj4gJCB4
ZnNfcXVvdGEgLXggLWMgJ2xpbWl0IC11IGJzb2Z0PTk4NzY1NDMyMTA5ODc2NTQzMjE5OSBcCj4g
ICAgICAgICBiaGFyZD05ODc2NTQzMjEwOTg3NjU0MzIxOTkgOTk5JyAvCj4gJAo+IAo+IEZpeGVk
IHZlcnNpb246Cj4gJCB4ZnNfcXVvdGEgLXggLWMgJ2xpbWl0IC11IGJzb2Z0PTk4NzY1NDMyMTA5
ODc2NTQzMjE5OSBcCj4gICAgICAgICBiaGFyZD05ODc2NTQzMjEwOTg3NjU0MzIxOTkgOTk5JyAv
Cj4geGZzX3F1b3RhOiBFcnJvcjogY291bGQgbm90IHBhcnNlIHNpemUgOTg3NjU0MzIxMDk4NzY1
NDMyMTk5Lgo+IHhmc19xdW90YTogdW5yZWNvZ25pc2VkIGFyZ3VtZW50IGJzb2Z0PTk4NzY1NDMy
MTA5ODc2NTQzMjE5OQoKU28sIHN0cnRvbCgzKSBzdWdnZXN0cyBzZXR0aW5nIGVycm5vIHRvIDAg
YmVmb3JlIHRoZSBjYWxsOgoKTk9URVMKICAgICAgIFNpbmNlICBzdHJ0b2woKSAgY2FuICBsZWdp
dGltYXRlbHkgIHJldHVybiAgMCwgIExPTkdfTUFYLCAgb3IgIExPTkdfTUlOCiAgICAgICAoTExP
TkdfTUFYIG9yIExMT05HX01JTiBmb3Igc3RydG9sbCgpKSBvbiBib3RoIHN1Y2Nlc3MgYW5kIGZh
aWx1cmUsIHRoZQogICAgICAgY2FsbGluZyAgcHJvZ3JhbSBzaG91bGQgc2V0IGVycm5vIHRvIDAg
YmVmb3JlIHRoZSBjYWxsLCBhbmQgdGhlbiBkZXRlci0KICAgICAgIG1pbmUgaWYgYW4gZXJyb3Ig
b2NjdXJyZWQgYnkgY2hlY2tpbmcgIHdoZXRoZXIgIGVycm5vICBoYXMgIGEgIG5vbi16ZXJvCiAg
ICAgICB2YWx1ZSBhZnRlciB0aGUgY2FsbC4KCkRpdHRvIGZvciBzdHJ0b3VsKCkuCgpJIGd1ZXNz
IHRoYXQgaXMganVzdCB0byBlbnN1cmUgdGhhdCB0aGVyZSdzIG5vdCBhIGxlZnRvdmVyIGVycm5v
CndoZW4gd2UgbWFrZSB0aGUgY2FsbD8gIFdvcnRoIGRvaW5nLCBtYXliZT8KClRoYW5rcywKLUVy
aWMKCj4gU2lnbmVkLW9mZi1ieTogQXJrYWRpdXN6IE1pxZtraWV3aWN6IDxhcmVrbUBtYXZlbi5w
bD4KPiAtLS0KPiAgbGlieGNtZC9pbnB1dC5jIHwgNCArKysrCj4gIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvbGlieGNtZC9pbnB1dC5jIGIvbGlieGNt
ZC9pbnB1dC5jCj4gaW5kZXggYzA2YjViOC4uMzk3YTEyNCAxMDA2NDQKPiAtLS0gYS9saWJ4Y21k
L2lucHV0LmMKPiArKysgYi9saWJ4Y21kL2lucHV0LmMKPiBAQCAtMTU0LDYgKzE1NCw4IEBAIGN2
dG51bSgKPiAgCWludAkJYzsKPiAgCj4gIAlpID0gc3RydG9sbChzLCAmc3AsIDApOwo+ICsJaWYg
KChpID09IExMT05HX01JTiB8fCBpID09IExMT05HX01BWCkgJiYgZXJybm8gPT0gRVJBTkdFKQo+
ICsJCXJldHVybiAtMUxMOwo+ICAJaWYgKGkgPT0gMCAmJiBzcCA9PSBzKQo+ICAJCXJldHVybiAt
MUxMOwo+ICAJaWYgKCpzcCA9PSAnXDAnKQo+IEBAIC0yMzgsNiArMjQwLDggQEAgY3Z0dGltZSgK
PiAgCWNoYXIJCSpzcDsKPiAgCj4gIAlpID0gc3RydG91bChzLCAmc3AsIDApOwo+ICsJaWYgKGkg
PT0gVUxPTkdfTUFYICYmIGVycm5vID09IEVSQU5HRSkKPiArCQlyZXR1cm4gMDsKPiAgCWlmIChp
ID09IDAgJiYgc3AgPT0gcykKPiAgCQlyZXR1cm4gMDsKPiAgCWlmICgqc3AgPT0gJ1wwJykKPiAK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWls
aW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL3hmcwo=
