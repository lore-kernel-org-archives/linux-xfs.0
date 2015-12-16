Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C7D97F47
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 21:05:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50EA9304048
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 19:05:03 -0800 (PST)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	NlrF1pwC7PDvABpq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Dec 2015 19:05:01 -0800 (PST)
Received: by mail-ob0-f181.google.com with SMTP id sd4so23260186obb.0
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 19:05:01 -0800 (PST)
Subject: Re: [PATCH v2] libxfs: Optimize the loop for xfs_bitmap_empty
References: <20151110125403.GC21670@bfoster.bfoster>
	<1447228141-17408-1-git-send-email-hejianet@gmail.com>
	<20151111124833.GB52153@bfoster.bfoster>
From: hejianet <hejianet@gmail.com>
Message-ID: <5670D4D8.9090500@gmail.com>
Date: Wed, 16 Dec 2015 11:04:56 +0800
MIME-Version: 1.0
In-Reply-To: <20151111124833.GB52153@bfoster.bfoster>
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
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: Brian Foster <bfoster@redhat.com>

SGkgRGF2aWQKCkRvIHlvdSBoYXZlIGFueSBjb21tZW50cyBmcm9tIHlvdXIgcG9pbnQgb2Ygdmll
dz8gVGhhbmtzIDspCgpCLlIuCkp1c3RpbgoK5ZyoIDExLzExLzE1IDg6NDggUE0sIEJyaWFuIEZv
c3RlciDlhpnpgZM6Cj4gT24gV2VkLCBOb3YgMTEsIDIwMTUgYXQgMDM6NDk6MDFQTSArMDgwMCwg
SmlhIEhlIHdyb3RlOgo+PiBJZiB0aGVyZSBpcyBhbnkgbm9uIHplcm8gYml0IGluIGEgbG9uZyBi
aXRtYXAsIGl0IGNhbiBqdW1wIG91dCBvZiB0aGUKPj4gbG9vcCBhbmQgZmluaXNoIHRoZSBmdW5j
dGlvbiBhcyBzb29uIGFzIHBvc3NpYmxlLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBKaWEgSGUgPGhl
amlhbmV0QGdtYWlsLmNvbT4KPj4gQ2M6IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNv
bT4KPj4gQ2M6IEJyaWFuIEZvc3RlciA8YmZvc3RlckByZWRoYXQuY29tPgo+PiAtLS0KPiBMb29r
cyBnb29kIHRvIG1lOgo+Cj4gUmV2aWV3ZWQtYnk6IEJyaWFuIEZvc3RlciA8YmZvc3RlckByZWRo
YXQuY29tPgo+Cj4+ICAgZnMveGZzL2xpYnhmcy94ZnNfYml0LmMgfCA2ICsrKy0tLQo+PiAgIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYg
LS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19iaXQuYyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2JpdC5j
Cj4+IGluZGV4IDBlODg4NWEuLjBhOTRjY2UgMTAwNjQ0Cj4+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX2JpdC5jCj4+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2JpdC5jCj4+IEBAIC0zMiwxMyAr
MzIsMTMgQEAgaW50Cj4+ICAgeGZzX2JpdG1hcF9lbXB0eSh1aW50ICptYXAsIHVpbnQgc2l6ZSkK
Pj4gICB7Cj4+ICAgCXVpbnQgaTsKPj4gLQl1aW50IHJldCA9IDA7Cj4+ICAgCj4+ICAgCWZvciAo
aSA9IDA7IGkgPCBzaXplOyBpKyspIHsKPj4gLQkJcmV0IHw9IG1hcFtpXTsKPj4gKwkJaWYgKG1h
cFtpXSAhPSAwKQo+PiArCQkJcmV0dXJuIDA7Cj4+ICAgCX0KPj4gICAKPj4gLQlyZXR1cm4gKHJl
dCA9PSAwKTsKPj4gKwlyZXR1cm4gMTsKPj4gICB9Cj4+ICAgCj4+ICAgLyoKPj4gLS0gCj4+IDIu
NS4wCj4+Cj4+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cj4+IHhmcyBtYWlsaW5nIGxpc3QKPj4geGZzQG9zcy5zZ2kuY29tCj4+IGh0dHA6Ly9vc3Muc2dp
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bvc3Muc2dpLmNvbQo+
IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo+CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bv
c3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
