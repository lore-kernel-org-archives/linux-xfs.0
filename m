Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TFnQBU216056 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:49:27 -0600
Received: from nskntqsrv03p.mx.bigpond.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 481E4C9823
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 07:48:44 -0800 (PST)
Received: from nskntqsrv03p.mx.bigpond.com (nskntqsrv03p.mx.bigpond.com
	[61.9.168.237]) by cuda.sgi.com with ESMTP id hXowpzDseUvBv8Jc
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 07:48:44 -0800 (PST)
Message-ID: <4981BD32.2090405@bigpond.net.au>
Date: Fri, 30 Jan 2009 01:29:06 +1100
From: Donald Douwsma <ddouwsma@bigpond.net.au>
MIME-Version: 1.0
Subject: Re: [PATCH] [LIBXCMD]: Move error messages to appropriate places.
References: <1233167051-14711-1-git-send-email-arekm@maven.pl>
In-Reply-To: <1233167051-14711-1-git-send-email-arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

QXJrYWRpdXN6IE1pxZtraWV3aWN6IHdyb3RlOgo+IFJlcGxhY2UgcmF3IHBlcnJvcigpIHdpdGgg
cHJvcGVyIG1lc3NhZ2UgaW4KPiBmc190YWJsZV9pbml0aWFsaXNlX21vdW50cygpLgo+IAo+IFJl
cGxhY2UgcmF3IHBlcnJvcigpIHdpdGggcHJvcGVyIG1lc3NhZ2UgYW5kIG1vdmUgaXQgZnJvbQo+
IGZzX21vdW50X3BvaW50X2Zyb21fcGF0aCgpIHRvIGZzX3RhYmxlX2luaXRpYWxpc2VfcHJvamVj
dHMoKSB3aGVyZSB0aGlzCj4gbWVzc2FnZSBoYXMgbWVhbmluZy4KCkkgbGlrZSB5b3VyIGNoYW5n
ZSwgaXQgbWFrZXMgdGhpbmdzIGNsZWFyZXIuCgpCdXQgZG9lcyB0aGlzIHBhcnRpY3VsYXIgZXJy
b3IgYWN0dWFsbHkgaGVscCBwZW9wbGU/IEkndmUgc2VlbiBpdCBhIGZldyB0aW1lcwp3aGVuIHRl
c3RpbmcgcXVvdGEgY29kZSBpbiB0aGUgcGFzdC4gSXQncyBvbmx5IHVzZWQgd2hlbiByZWFkaW5n
IGluIHByb2plY3RzLAphbmQgY2F1c2VzIGVycm9ycyB0byBiZSBkaXNwbGF5ZWQgZXZlbiB3aGVu
IGlzc3Vpbmcgbm9uIHByb2plY3QgY29tbWFuZHMuCgokIHN1ZG8gYmFzaCAtYyAiZWNobyAxMDov
dmFyL25vbmV4aXN0YW50ZGlyID4+IC9ldGMvcHJvamVjdHMKJCB4ZnNfcXVvdGEgLWMgcHJpbnQK
L3Zhci9ub25leGlzdGFudGRpcjogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpGaWxlc3lzdGVt
ICAgICAgICAgIFBhdGhuYW1lCi9ob21lICAgICAgICAgICAgICAgL2Rldi9zZGE4CgpJJ2QgYmUg
dGVtcHRlZCB0byByZW1vdmUgdGhpcyBlcnJvciwgYW5kIGFkZCBlcnJvciBjaGVja2luZyBjb2Rl
IHRvIHRoZSBwcm9qZWN0IHNwZWNpZmljCmNvbW1hbmRzIHRoYXQgd2FsayB0cmVlJ3MuCgpVbmxl
c3MgdGhlcmUncyBzb21lIGNvcm5lciBjYXNlIEknbSBtaXNzaW5nLCBXaGF0IGRvIHlvdSB0aGlu
az8KCkRvbgoKPiAKPiBTaWduZWQtb2ZmLWJ5OiBBcmthZGl1c3ogTWnFm2tpZXdpY3ogPGFyZWtt
QG1hdmVuLnBsPgo+IC0tLQo+ICBsaWJ4Y21kL3BhdGhzLmMgfCAgICA5ICsrKysrKy0tLQo+ICAx
IGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPiAKPiBkaWZm
IC0tZ2l0IGEvbGlieGNtZC9wYXRocy5jIGIvbGlieGNtZC9wYXRocy5jCj4gaW5kZXggZmFjZWEw
Ni4uNmMzNmI3OSAxMDA2NDQKPiAtLS0gYS9saWJ4Y21kL3BhdGhzLmMKPiArKysgYi9saWJ4Y21k
L3BhdGhzLmMKPiBAQCAtMjQ4LDcgKzI0OCw4IEBAIGZzX3RhYmxlX2luaXRpYWxpc2VfbW91bnRz
KAo+ICAJZGlyID0gZnNuYW1lID0gZnNsb2cgPSBmc3J0ID0gTlVMTDsKPiAgCj4gIAlpZiAoKGNv
dW50ID0gZ2V0bW50aW5mbygmc3RhdHMsIDApKSA8IDApIHsKPiAtCQlwZXJyb3IoImdldG1udGlu
Zm8iKTsKPiArCQlmcHJpbnRmKHN0ZGVyciwgXygiJXM6IGdldG1udGluZm8oKSBmYWlsZWQ6ICVz
XG4iKSwKPiArCQkJCXByb2duYW1lLCBzdHJlcnJvcihlcnJubykpOwo+ICAJCXJldHVybiAwOwo+
ICAJfQo+ICAKPiBAQCAtMjk4LDcgKzI5OSw2IEBAIGZzX21vdW50X3BvaW50X2Zyb21fcGF0aCgK
PiAgCXN0cnVjdCBzdGF0NjQJczsKPiAgCj4gIAlpZiAoc3RhdDY0KGRpciwgJnMpIDwgMCkgewo+
IC0JCXBlcnJvcihkaXIpOwo+ICAJCXJldHVybiBOVUxMOwo+ICAJfQo+ICAKPiBAQCAtMzI3LDgg
KzMyNywxMSBAQCBmc190YWJsZV9pbml0aWFsaXNlX3Byb2plY3RzKAo+ICAJd2hpbGUgKChwYXRo
ID0gZ2V0cHJwYXRoZW50KCkpICE9IE5VTEwpIHsKPiAgCQlpZiAocHJvamVjdCAmJiBwcmlkICE9
IHBhdGgtPnBwX3ByaWQpCj4gIAkJCWNvbnRpbnVlOwo+IC0JCWlmICgoZnMgPSBmc19tb3VudF9w
b2ludF9mcm9tX3BhdGgocGF0aC0+cHBfcGF0aG5hbWUpKSA9PSBOVUxMKQo+ICsJCWlmICgoZnMg
PSBmc19tb3VudF9wb2ludF9mcm9tX3BhdGgocGF0aC0+cHBfcGF0aG5hbWUpKSA9PSBOVUxMKSB7
Cj4gKwkJCWZwcmludGYoc3RkZXJyLCBfKCIlczogY2Fubm90IGZpbmQgbW91bnQgcG9pbnQgZm9y
IHBhdGggYCVzJzogJXNcbiIpLAo+ICsJCQkJCXByb2duYW1lLCBwYXRoLT5wcF9wYXRobmFtZSwg
c3RyZXJyb3IoZXJybm8pKTsKPiAgCQkJY29udGludWU7Cj4gKwkJfQo+ICAJCWZvdW5kID0gMTsK
PiAgCQlkaXIgPSBzdHJkdXAocGF0aC0+cHBfcGF0aG5hbWUpOwo+ICAJCWZzbmFtZSA9IHN0cmR1
cChmcy0+ZnNfbmFtZSk7CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
