Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E8C07F6D
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 01:13:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C7B58F8054
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 23:13:35 -0700 (PDT)
Received: from mail-wg0-f49.google.com (mail-wg0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id Heqy43q2ZbrgDaxJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Jul 2014 23:13:32 -0700 (PDT)
Received: by mail-wg0-f49.google.com with SMTP id k14so1279956wgh.32
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 23:13:30 -0700 (PDT)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH] Catch under/overflow cases in cvtnum() and cvttime().
Date: Sat, 12 Jul 2014 08:13:27 +0200
References: <1405107244-14234-1-git-send-email-arekm@maven.pl>
	<53C06FF3.2090600@sandeen.net>
In-Reply-To: <53C06FF3.2090600@sandeen.net>
MIME-Version: 1.0
Message-Id: <201407120813.27317.arekm@maven.pl>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

T24gU2F0dXJkYXkgMTIgb2YgSnVseSAyMDE0LCBFcmljIFNhbmRlZW4gd3JvdGU6Cj4gT24gNy8x
MS8xNCwgMjozNCBQTSwgQXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+ID4gY3Z0bnVtKCkg
YW5kIGN2dHRpbWUoKSBzaWxlbnRseSBpZ25vcmUgb3ZlcmZsb3dzLiBUaGlzIGxlYWRzIHRvIGVy
cm9yCj4gPiBjb25kaXRpb25zIG5vdCBiZWluZyBjYXRjaGVkLiBFeGFtcGxlOgo+ID4gCj4gPiAk
IHhmc19xdW90YSAteCAtYyAnbGltaXQgLXUgYnNvZnQ9OTg3NjU0MzIxMDk4NzY1NDMyMTk5IFwK
PiA+IAo+ID4gICAgICAgICBiaGFyZD05ODc2NTQzMjEwOTg3NjU0MzIxOTkgOTk5JyAvCj4gPiAK
PiA+ICQKPiA+IAo+ID4gRml4ZWQgdmVyc2lvbjoKPiA+ICQgeGZzX3F1b3RhIC14IC1jICdsaW1p
dCAtdSBic29mdD05ODc2NTQzMjEwOTg3NjU0MzIxOTkgXAo+ID4gCj4gPiAgICAgICAgIGJoYXJk
PTk4NzY1NDMyMTA5ODc2NTQzMjE5OSA5OTknIC8KPiA+IAo+ID4geGZzX3F1b3RhOiBFcnJvcjog
Y291bGQgbm90IHBhcnNlIHNpemUgOTg3NjU0MzIxMDk4NzY1NDMyMTk5Lgo+ID4geGZzX3F1b3Rh
OiB1bnJlY29nbmlzZWQgYXJndW1lbnQgYnNvZnQ9OTg3NjU0MzIxMDk4NzY1NDMyMTk5Cj4gCj4g
U28sIHN0cnRvbCgzKSBzdWdnZXN0cyBzZXR0aW5nIGVycm5vIHRvIDAgYmVmb3JlIHRoZSBjYWxs
Ogo+IAo+IE5PVEVTCj4gICAgICAgIFNpbmNlICBzdHJ0b2woKSAgY2FuICBsZWdpdGltYXRlbHkg
IHJldHVybiAgMCwgIExPTkdfTUFYLCAgb3IgCj4gTE9OR19NSU4gKExMT05HX01BWCBvciBMTE9O
R19NSU4gZm9yIHN0cnRvbGwoKSkgb24gYm90aCBzdWNjZXNzIGFuZAo+IGZhaWx1cmUsIHRoZSBj
YWxsaW5nICBwcm9ncmFtIHNob3VsZCBzZXQgZXJybm8gdG8gMCBiZWZvcmUgdGhlIGNhbGwsIGFu
ZAo+IHRoZW4gZGV0ZXItIG1pbmUgaWYgYW4gZXJyb3Igb2NjdXJyZWQgYnkgY2hlY2tpbmcgIHdo
ZXRoZXIgIGVycm5vICBoYXMgIGEgCj4gbm9uLXplcm8gdmFsdWUgYWZ0ZXIgdGhlIGNhbGwuCj4g
Cj4gRGl0dG8gZm9yIHN0cnRvdWwoKS4KCkhtLCBteSBtYW4gcGFnZXMgMy43MCBkb24ndCBoYXZl
IHN1Y2ggbm90ZXMsIHN0cnRvbCgzKToKCk5PVEVTCiAgICAgICBJbiBsb2NhbGVzIG90aGVyIHRo
YW4gdGhlICJDIiBsb2NhbGUsIGFsc28gb3RoZXIgc3RyaW5ncyBtYXkgYmUgCmFjY2VwdGVkLiAg
KEZvciBleGFtcGxlLCB0aGUgdGhvdXNhbmRzIHNlcGFyYXRvciBvZiB0aGUgY3VycmVudCBsb2Nh
bGUgbWF5IGJlIApzdXBwb3J0ZWQuKQoKICAgICAgIEJTRCBhbHNvIGhhcwoKICAgICAgICAgICBx
dWFkX3QKICAgICAgICAgICBzdHJ0b3EoY29uc3QgY2hhciAqbnB0ciwgY2hhciAqKmVuZHB0ciwg
aW50IGJhc2UpOwoKICAgICAgIHdpdGggY29tcGxldGVseSBhbmFsb2dvdXMgZGVmaW5pdGlvbi4g
IERlcGVuZGluZyBvbiB0aGUgd29yZHNpemUgb2YgdGhlIApjdXJyZW50IGFyY2hpdGVjdHVyZSwg
dGhpcyBtYXkgYmUgZXF1aXZhbGVudCB0byBzdHJ0b2xsKCkgb3IgdG8gc3RydG9sKCkuCgo+IAo+
IEkgZ3Vlc3MgdGhhdCBpcyBqdXN0IHRvIGVuc3VyZSB0aGF0IHRoZXJlJ3Mgbm90IGEgbGVmdG92
ZXIgZXJybm8KPiB3aGVuIHdlIG1ha2UgdGhlIGNhbGw/ICBXb3J0aCBkb2luZywgbWF5YmU/CgpF
UkFOR0UgaXMgY2hlY2tlZCBpbiBmZXcgb3RoZXIgcGxhY2VzIGFscmVhZHkgaW4gaW5wdXQuYyBh
bmQgbm9uZSBpbml0aWFsaXplIAplcnJubyBiZWZvcmUgc3RydG91bCgpIGNhbGwuCgo+IAo+IFRo
YW5rcywKPiAtRXJpYwo+IAo+ID4gU2lnbmVkLW9mZi1ieTogQXJrYWRpdXN6IE1pxZtraWV3aWN6
IDxhcmVrbUBtYXZlbi5wbD4KPiA+IC0tLQo+ID4gCj4gPiAgbGlieGNtZC9pbnB1dC5jIHwgNCAr
KysrCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQo+ID4gCj4gPiBkaWZmIC0t
Z2l0IGEvbGlieGNtZC9pbnB1dC5jIGIvbGlieGNtZC9pbnB1dC5jCj4gPiBpbmRleCBjMDZiNWI4
Li4zOTdhMTI0IDEwMDY0NAo+ID4gLS0tIGEvbGlieGNtZC9pbnB1dC5jCj4gPiArKysgYi9saWJ4
Y21kL2lucHV0LmMKPiA+IEBAIC0xNTQsNiArMTU0LDggQEAgY3Z0bnVtKAo+ID4gCj4gPiAgCWlu
dAkJYzsKPiA+ICAJCj4gPiAgCWkgPSBzdHJ0b2xsKHMsICZzcCwgMCk7Cj4gPiAKPiA+ICsJaWYg
KChpID09IExMT05HX01JTiB8fCBpID09IExMT05HX01BWCkgJiYgZXJybm8gPT0gRVJBTkdFKQo+
ID4gKwkJcmV0dXJuIC0xTEw7Cj4gPiAKPiA+ICAJaWYgKGkgPT0gMCAmJiBzcCA9PSBzKQo+ID4g
IAkKPiA+ICAJCXJldHVybiAtMUxMOwo+ID4gIAkKPiA+ICAJaWYgKCpzcCA9PSAnXDAnKQo+ID4g
Cj4gPiBAQCAtMjM4LDYgKzI0MCw4IEBAIGN2dHRpbWUoCj4gPiAKPiA+ICAJY2hhcgkJKnNwOwo+
ID4gIAkKPiA+ICAJaSA9IHN0cnRvdWwocywgJnNwLCAwKTsKPiA+IAo+ID4gKwlpZiAoaSA9PSBV
TE9OR19NQVggJiYgZXJybm8gPT0gRVJBTkdFKQo+ID4gKwkJcmV0dXJuIDA7Cj4gPiAKPiA+ICAJ
aWYgKGkgPT0gMCAmJiBzcCA9PSBzKQo+ID4gIAkKPiA+ICAJCXJldHVybiAwOwo+ID4gIAkKPiA+
ICAJaWYgKCpzcCA9PSAnXDAnKQoKCi0tIApBcmthZGl1c3ogTWnFm2tpZXdpY3osIGFyZWttIC8g
bWF2ZW4ucGwKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWls
bWFuL2xpc3RpbmZvL3hmcwo=
