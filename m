Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1FWDn9145173
	for <linux-xfs@oss.sgi.com>; Tue, 1 Dec 2009 09:32:14 -0600
Received: from mail-px0-f180.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 006DC14EC947
	for <linux-xfs@oss.sgi.com>; Tue,  1 Dec 2009 07:32:43 -0800 (PST)
Received: from mail-px0-f180.google.com (mail-px0-f180.google.com
	[209.85.216.180]) by cuda.sgi.com with ESMTP id
	m9R0PQHxtpXsxU2A for <linux-xfs@oss.sgi.com>;
	Tue, 01 Dec 2009 07:32:43 -0800 (PST)
Received: by pxi10 with SMTP id 10so4018113pxi.33
	for <linux-xfs@oss.sgi.com>; Tue, 01 Dec 2009 07:32:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B152BAD.1000004@sandeen.net>
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
	<4B14936F.7040401@sandeen.net>
	<389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
	<4B14B077.5090500@sandeen.net>
	<389deec70911302234v2fc792ddt54bf88f5200500be@mail.gmail.com>
	<4B152BAD.1000004@sandeen.net>
Date: Tue, 1 Dec 2009 23:32:43 +0800
Message-ID: <389deec70912010732o72edd3c4q196088a1c01b801e@mail.gmail.com>
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
From: hank peng <pengxihan@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

MjAwOS8xMi8xIEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD46Cj4gaGFuayBwZW5n
IHdyb3RlOgo+Cj4+IFRvZGF5LCBJIGVuY291bnRlcmVkIGEgcHJvYmxlbToKPj4gSSB1c2UgInhm
c19yZXBhaXIgLUwg4oCcIG9uIGEgZGFtYWdlZCBmaWxlc3lzdGVtIGFuZCBhIGxvdCBvZiBtZXNz
YWdlcwo+Cj4gd2h5IGRpZCB5b3UgdXNlIC1MLCBkaWQgaXQgZmFpbCB0byBtb3VudCAmIHJlcGxh
eSB0aGUgbG9nIHByb3Blcmx5Pwo+CnVtb3VudCwgbW91bnQsIHVtb3VudCBhbmQgdGhlbiB4ZnNf
cmVwYWlyIGZhaWxlZCwgc28gSSBoYXZlIHRvIHVzZSAtTC4KCj4+IG91dHB1dCB3aGljaCBpbmNs
dWRlICJtb3ZpbmcgZGlzY29ubmVjdGVkIGlub2RlcyB0byBsb3N0K2ZvdW5kIC4uLiIuCj4+IFRo
ZW4gSSBjYW4gcmVtb3VudCB0aGUgZmlsZXN5c3RlbSBzdWNjZXNzZnVsbHkgYW5kIGRlY2lkZWQg
dG8gcmVtb3ZlCj4+IHRob3NlIGZpbGVzIGluIGxvc3QrZm91bmQgZGlyZWN0b3J5LCBidXQgaXQg
cHJpbnRlZCB0aGUgZm9sbG93aW5nCj4+IG1lc3NhZ2U6Cj4+IHJvb3RAMTIzNGRhaHVhOi9tbnQv
UG9vbF9tZDEvc3MxL2xvc3QrZm91bmQjIHJtIC1yZiAqCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzEw
JzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzI4JzogU3Ry
dWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzI5JzogU3RydWN0dXJl
IG5lZWRzIGNsZWFuaW5nCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzMwJzogU3RydWN0dXJlIG5lZWRz
IGNsZWFuaW5nCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzMxJzogU3RydWN0dXJlIG5lZWRzIGNsZWFu
aW5nCj4+IHJtOiBjYW5ub3Qgc3RhdCAnNzMyJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+
IHJtOiBjYW5ub3Qgc3RhdCAnNzMzJzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+IHJtOiBj
YW5ub3Qgc3RhdCAnNzM0JzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4+IHJtOiBjYW5ub3Qg
c3RhdCAnNzM1JzogU3RydWN0dXJlIG5lZWRzIGNsZWFuaW5nCj4KPiBMb29rIGF0IGRtZXNnIHRv
IHNlZSB3aGF0J3MgZ29uZSB3cm9uZy4uLi4KPgoKPj4gT3RoZXIgZGlyZWN0b3JpZXMgYW5kIGZp
bGVzIHNlZW1zIG5vcm1hbCB0byBhY2Nlc3MsIGlzIGl0IG5vdCBhbGxvd2VkCj4+IHRvIGRlbGV0
ZSBmaWxlcyBpbiBsb3N0K2ZvdW5kIGRpcmVjdG9yeSBhZnRlciByZXBhaXIsIHRoZW4gd2hhdCBz
aG91bGQKPj4gSSBkbz8KPgo+IFRoaXMgaXMgaW5kaWNhdGl2ZSBvZiBhIGJ1ZyBvciBJTyBlcnJv
ciB0aGF0IGNhdXNlZCB4ZnMgdG8gc2h1dCBkb3duLgo+Cj4gWW91IGhhdmVuJ3QgbWVudGlvbmVk
IHdoaWNoIGtlcm5lbCB2ZXJzaW9uLCBhcmNoaXRlY3R1cmUsIG9yCj4gdmVyc2lvbiBvZiB4ZnNw
cm9ncyB5b3UncmUgdXNpbmcgeWV0IC4uLiB0aGF0IG1heSBvZmZlciBzb21lIGNsdWVzLgo+Cgo+
IEknbSBndWVzc2luZyBhbiBvbGRlciBrZXJuZWwgYW5kIHVzZXJzcGFjZSBvbiBhcm0/IDopCj4K
a2VybmVsIHZlcnNpb24gaXMgMi42LjIzLCB4ZnNwcm9ncyBpcyAyLjkuNywgQ1BVIGlzIE1QQzg1
NDgsIHBvd2VycGMgYXJjaC4KSSBhbSBhdCBob21lIG5vdywgTWF5YmUgSSBjYW4gcHJvdmlkZSBz
b21lIGRldGFpbGVkIGluZm9ybWF0aW9uIHRvbW9ycm93LgoKPiAtRXJpYwo+CgoKCi0tIApUaGUg
c2ltcGxlc3QgaXMgbm90IGFsbCBiZXN0IGJ1dCB0aGUgYmVzdCBpcyBzdXJlbHkgdGhlIHNpbXBs
ZXN0IQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZz
IG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4v
bGlzdGluZm8veGZzCg==
