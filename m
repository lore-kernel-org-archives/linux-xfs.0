Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6F6D7F5D
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 05:01:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94FC230407A
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 03:01:01 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 10 Jul 2013 12:00:57 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH 10/13] xfs: use =?UTF-8?Q?get=5Funused=5Ffd=5Fflags=28?=
	=?UTF-8?Q?=30=29=20instead=20of=20get=5Funused=5Ffd=28=29?=
In-Reply-To: <20130709205321.GV20932@sgi.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
	<8d21b76c621dbfc59b2dbbfc933f96170835304d.1372777600.git.ydroneaud@opteya.com>
	<20130708224133.GA23250@sgi.com> <20130709205321.GV20932@sgi.com>
Message-ID: <70a3a6971c3127226563e9538ae53bec@meuh.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: ydroneaud@opteya.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

SGksCgpMZSAwOS4wNy4yMDEzIDIyOjUzLCBCZW4gTXllcnMgYSDDqWNyaXTCoDoKPiBPbiBNb24s
IEp1bCAwOCwgMjAxMyBhdCAwNTo0MTozM1BNIC0wNTAwLCBCZW4gTXllcnMgd3JvdGU6Cj4+IE9u
IFR1ZSwgSnVsIDAyLCAyMDEzIGF0IDA2OjM5OjM0UE0gKzAyMDAsIFlhbm4gRHJvbmVhdWQgd3Jv
dGU6Cgo+PiA+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lvY3RsLmMgYi9mcy94ZnMveGZzX2lv
Y3RsLmMKPj4gPiBpbmRleCA1ZTk5OTY4Li5kYzViNjU5IDEwMDY0NAo+PiA+IC0tLSBhL2ZzL3hm
cy94ZnNfaW9jdGwuYwo+PiA+ICsrKyBiL2ZzL3hmcy94ZnNfaW9jdGwuYwo+PiA+IEBAIC0yNDgs
NyArMjQ4LDcgQEAgeGZzX29wZW5fYnlfaGFuZGxlKAo+PiA+ICAJCWdvdG8gb3V0X2RwdXQ7Cj4+
ID4gIAl9Cj4+ID4KPj4gPiAtCWZkID0gZ2V0X3VudXNlZF9mZCgpOwo+PiA+ICsJZmQgPSBnZXRf
dW51c2VkX2ZkX2ZsYWdzKDApOwo+PiAKPj4gT19DTE9FWEVDIHNob3VsZCBiZSBmaW5lIGluIHRo
aXMgY2FzZS4KPj4gCj4+IFJldmlld2VkLWJ5OiBCZW4gTXllcnMgPGJwbUBzZ2kuY29tPgo+IAo+
IEFwcGxpZWQgYXQgZ2l0Oi8vb3NzLnNnaS5jb20veGZzL3hmcy5naXQuICBMb29rcyBsaWtlIEkg
d2FzIHdyb25nIGFib3V0Cj4gT19DTE9FWEVDIGJlaW5nIG9rIGhlcmUuICBUaGVyZSBtYXkgYmUg
YXBwbGljYXRpb25zIHdoaWNoIAo+IG9wZW5fYnlfaGFuZGxlIHRoZW4KPiBmb3JrL2V4ZWMgYW5k
IGV4cGVjdCB0byBzdGlsbCBiZSBhYmxlIHRvIHVzZSB0aGF0IGZpbGUgZGVzY3JpcHRvci4KPiAK
Ck9LLCBpdCdzIHZlcnkgaW1wb3J0YW50IHRvIG5vdCBjYXVzZSByZWdyZXNzaW9uIGhlcmUuCgpG
b3IgdGhlIHJlY29yZCwgeGZzX29wZW5fYnlfaGFuZGxlKCkgaXMgbm90IHJlbGF0ZWQgdG8gCm9w
ZW5fYnlfaGFuZGxlX2F0KCkgc3lzY2FsbC4KCkl0J3MgYW4gaW9jdGwgKFhGU19JT0NfT1BFTl9C
WV9IQU5ETEUpIHdoaWNoIGlzIHVzZWQgYnkgeGZzcHJvZ3MncyAKbGliaGFuZGxlCmluIGZ1bmN0
aW9ucyBvcGVuX2J5X2ZzaGFuZGxlKCkgYW5kIG9wZW5fYnlfaGFuZGxlKCkuCgpodHRwOi8vc291
cmNlcy5kZWJpYW4ubmV0L3NyYy94ZnNwcm9ncy8zLjEuOS9saWJoYW5kbGUvaGFuZGxlLmM/aGw9
Mjg0I0wyODQKaHR0cDovL3NvdXJjZXMuZGViaWFuLm5ldC9zcmMveGZzcHJvZ3MvMy4xLjkvbGli
aGFuZGxlL2hhbmRsZS5jP2hsPTMwOCNMMzA4CgpBY2NvcmRpbmcgdG8gY29kZXNlYXJjaC5kZWJp
YW4ub3JnLCBsaWJoYW5kbGUncyBvcGVuX2J5X2hhbmRsZSgpIGlzIG9ubHkgCnVzZWQKYnkgeGZz
ZHVtcAoKaHR0cDovL3NvdXJjZXMuZGViaWFuLm5ldC9zcmMveGZzZHVtcC8zLjEuMS9yZXN0b3Jl
L3RyZWUuYz9obD0yNTM0I0wyNTM0CgpTbyB0aGVyZSdzIG5vIG1hbnkgKmtub3duKiB1c2VycyBv
ZiB0aGlzIGZlYXR1cmVzIC4uLiBidXQgaXQncyBtb3JlIAppbXBvcnRhbnQKbm90IHRvIGJyZWFr
ICp1bmtub3duKiB1c2VycyBvZiBpdC4KCkJUVywgdGhhbmtzIGZvciB0aGUgcmV2aWV3IGFuZCBh
cHBseWluZy4KClJlZ2FyZHMuCgotLSAKWWFubiBEcm9uZWF1ZApPUFRFWUEKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
