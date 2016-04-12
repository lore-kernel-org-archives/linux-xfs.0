Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39A557CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 06:29:21 -0500 (CDT)
Subject: Re: [PATCH 4/5] xfs: xfs_inode_free() isn't RCU safe
References: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
From: Brent Bice <bbice@sgi.com>
Message-ID: <570CDC0B.3070802@sgi.com>
Date: Tue, 12 Apr 2016 05:29:15 -0600
MIME-Version: 1.0
In-Reply-To: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com
Cc: Shyam Kaushik <shyam@zadarastorage.com>

ICAgIENvdWxkIHlvdSByZXNlbmQgaXQgdG8gYmUgc3VyZT8gSSBmbGFnZ2VkIGl0IGZvciByZWRl
bGl2ZXJ5IHRoZSBkYXkgCkkgZW1haWxlZCB5b3Ugc28gaWYgbm9ib2R5IGVsc2UgaGFzIHNlZW4g
aXQgeWV0IHRoZW4gc29tZXRoaW5nIHN0aWxsIApkaWRuJ3Qgd29yay4gIEkgd2FzIHByZXR0eSBz
dXJlIEknZCBzZWVuIGl0IGdldCBkZWxpdmVyZWQgb2sgdG8gb3NzLCAKYnV0Li4uIChzaHJ1ZykK
CkJyZW50CgpPbiAwNC8xMi8yMDE2IDAyOjU2IEFNLCBBbGV4IEx5YWthcyB3cm90ZToKPiBIZWxs
byBEYXZlLAo+IExvb2tpbmcgYXQgdGhlIHBhdGNoLCBJIHNlZSB0aGF0IG5vdyB3ZSBjYWxsIHhm
c19pZGVzdHJveV9mb3JrKCkgaW4gUkNVCj4gY2FsbGJhY2suIFRoaXMgY2FuIGRvIHRoZSBmb2xs
b3dpbmcgY2hhaW46Cj4geGZzX2lleHRfZGVzdHJveSA9PiB4ZnNfaWV4dF9pcmVjX3JlbW92ZSA9
PiB4ZnNfaWV4dF9yZWFsbG9jX2luZGlyZWN0PT4KPiBrbWVtX3JlYWxsb2MgPT4ga21lbV9hbGxv
YyA9PiBrbWVtX2FsbG9jID0+IGNvbmdlc3Rpb25fd2FpdCgpCj4gQXQgbGVhc3QgYWNjb3JkaW5n
IHRvIGRvY3VtZW50YXRpb24sIHRoZSBSQ1UgY2FsbGJhY2sgY2Fubm90IGJsb2NrLAo+IHNpbmNl
IGl0IG1heSBiZSBjYWxsZWQgZnJvbSBzb2Z0aXJxIGNvbnRleHQuIElzIHRoaXMgZmluZT8KPiBU
aGFua3MsCj4gQWxleC4KPiBQLlMuOiBJIGhhdmUgc3VibWl0dGVkIGEgcGF0Y2ggY2FsbGVkIOKA
nFtQQVRDSF0geGZzOiBvcHRpbWl6ZSBkZXN0cnVjdGlvbgo+IG9mIHRoZSBpbmRpcmVjdGlvbiBh
cnJheeKAnSwgd2hpY2ggY2hhbmdlcyB4ZnNfaWV4dF9kZXN0cm95IHRvIGNhbGwgb25seQo+IGtt
ZW1fZnJlZSgpLiBCdXQgdGhpcyBwYXRjaCBnb3Qgc3R1Y2sgaW4gdGhlIHNwYW0gZmlsdGVyIG9m
IHRoZSBtYWlsaW5nCj4gbGlzdCwgYW5kIEJyZW50IGlzIHdvcmtpbmcgdG8gcmVsZWFzZSBpdCBm
cm9tIHRoZXJlLgo+Cj4KPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2ku
Y29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
