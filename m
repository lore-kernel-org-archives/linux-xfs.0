Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55C257F37
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 00:37:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36AC0304053
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 22:37:58 -0800 (PST)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com
	[209.85.218.48]) by cuda.sgi.com with ESMTP id vmK2vQlu0lj26RAm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 22:37:53 -0800 (PST)
Received: by oiad129 with SMTP id d129so11380165oia.0
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 22:37:53 -0800 (PST)
Subject: Re: [PATCH] libxfs: Optimize the loop for xfs_bitmap_empty
References: <1447079482-10650-1-git-send-email-hejianet@gmail.com>
	<20151110125403.GC21670@bfoster.bfoster>
From: hejianet <hejianet@gmail.com>
Message-ID: <5642E23F.6050009@gmail.com>
Date: Wed, 11 Nov 2015 14:37:51 +0800
MIME-Version: 1.0
In-Reply-To: <20151110125403.GC21670@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

CkhpIEJyaWFuClRoYW5rcywgSSB3aWxsIHJlc2VuZCB0aGUgcGF0Y2ggVjIKCkIuUi4KSnVzdGlu
CgrlnKggMTEvMTAvMTUgODo1NCBQTSwgQnJpYW4gRm9zdGVyIOWGmemBkzoKPiBPbiBNb24sIE5v
diAwOSwgMjAxNSBhdCAxMDozMToyMlBNICswODAwLCBKaWEgSGUgd3JvdGU6Cj4+IElmIHRoZXJl
IGlzIGFueSBub24gemVybyBiaXQgaW4gYSBsb25nIGJpdG1hcCwgaXQgY2FuIGp1bXAgb3V0IG9m
IHRoZSBmb3IKPj4gbG9vcCBhbmQgZmluaXNoIHRoZSBmdW5jdGlvbiBhcyBzb29uIGFzIHBvc3Np
YmxlLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKaWEgSGUgPGhlamlhbmV0QGdtYWlsLmNvbT4KPj4g
Q2M6IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4KPj4gQ2M6IEJyaWFuIEZvc3Rl
ciA8YmZvc3RlckByZWRoYXQuY29tPgo+PiAtLS0KPj4gICBmcy94ZnMvbGlieGZzL3hmc19iaXQu
YyB8IDIgKysKPj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYg
LS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19iaXQuYyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2JpdC5j
Cj4+IGluZGV4IDBlODg4NWEuLjg0NjE0YjAgMTAwNjQ0Cj4+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX2JpdC5jCj4+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2JpdC5jCj4+IEBAIC0zNiw2ICsz
Niw4IEBAIHhmc19iaXRtYXBfZW1wdHkodWludCAqbWFwLCB1aW50IHNpemUpCj4+ICAgCj4+ICAg
CWZvciAoaSA9IDA7IGkgPCBzaXplOyBpKyspIHsKPj4gICAJCXJldCB8PSBtYXBbaV07Cj4+ICsJ
CWlmIChyZXQgIT0gMCkKPj4gKwkJCXJldHVybiAwOwo+PiAgIAl9Cj4+ICAgCj4gU2VlbXMgT2sg
dG8gbWUsIGJ1dCBpZiB3ZSdyZSBnb2luZyB0byBkbyB0aGlzLCB3aHkgbm90IGp1c3Qga2lsbCBy
ZXQKPiBlbnRpcmVseT8gRm9yIGV4YW1wbGUsIGNoZWNrICdpZiAobWFwW2ldICE9IDApIHJldHVy
biAwOycgaW4gdGhlIGxvb3AKPiBhbmQgdW5jb25kaXRpb25hbGx5IHJldHVybiAxIGlmIHdlIG1h
a2UgaXQgdG8gdGhlIGVuZC4KPgo+IEJyaWFuCj4KPj4gICAJcmV0dXJuIChyZXQgPT0gMCk7Cj4+
IC0tIAo+PiAyLjUuMAo+Pgo+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwo+PiB4ZnMgbWFpbGluZyBsaXN0Cj4+IHhmc0Bvc3Muc2dpLmNvbQo+PiBodHRw
Oi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKPiBfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+IHhmcyBtYWlsaW5nIGxpc3QKPiB4ZnNAb3Nz
LnNnaS5jb20KPiBodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMKPgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
