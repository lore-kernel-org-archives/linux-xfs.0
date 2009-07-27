Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R6l32m077809
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jul 2009 01:47:03 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CCD110C45BB
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jul 2009 23:56:25 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	0cRzIY17myUTyI5y for <linux-xfs@oss.sgi.com>;
	Sun, 26 Jul 2009 23:56:25 -0700 (PDT)
Received: by bwz10 with SMTP id 10so2289912bwz.20
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jul 2009 23:47:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6D075B.9060601@sandeen.net>
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
	<4A6D075B.9060601@sandeen.net>
Date: Mon, 27 Jul 2009 14:47:46 +0800
Message-ID: <389deec70907262347g1ca3637fn469596ec1e05148@mail.gmail.com>
Subject: Re: How to solve "No space left" problem on my 32bit machine?
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

MjAwOS83LzI3IEVyaWMgU2FuZGVlbiA8c2FuZGVlbkBzYW5kZWVuLm5ldD46Cj4gaGFuayBwZW5n
IHdyb3RlOgo+PiBIaSwgZm9sa3M6Cj4+IEkgaGF2ZSBhIDIuNVQgZmlsZSBzeXN0ZW0gZm9ybWF0
dGVkIHdpdGggWEZTLCBkZiB0ZWxscyBtZSBpdCBzdGlsbAo+PiBoYXZlIGFib3V0IDEwRyBzcGFj
ZSBhdmFpbGFibGUsIGJ1dCBJIGNhbid0IGNyZWF0ZSBuZXcgZmlsZXMgb3IKPj4gZGlyZWN0b3J5
IGFueSBtb3JlLiBSZXR1cm4gbWVzc2FnZSBpcyAiTm8gc3BhY2UgbGVmdCBvbiB0aGlzIGRldmlj
ZSIuCj4+IEkgc2VhcmNoZWQgc29sdXRpb24gZm9yIHRoaXMgcHJvYmxlbSB0aHJvdWdoIGdvb2ds
ZSwgYW5kIGZvdW5kIHRoaXM6Cj4+IGh0dHA6Ly9vc3Muc2dpLmNvbS9hcmNoaXZlcy94ZnMvMjAw
NS0wNi9tc2cwMDM0Ny5odG1sLiBJIHRoaW5rIGl0IGlzIGEKPj4ga25vd24gIk5vIHNwYWNlIGxl
ZnQiIHByb2JsZW0uIEkgd29uZGVyIHdoZXRoZXIgaXQgY2FuIG9ubHkKPj4gYmUgc29sdmVkIG9u
IDY0LWJpdCBtYWNoaW5lPyBJZiBvbiBteSAzMi1iaXQgbWFjaGluZSwgd2hhdCBzaG91bGQgSSBk
bz8KPgo+IE9uIHZlcnkgcmVjZW50IGtlcm5lbHMgeW91IGNhbiB1c2UgNjQtYml0IGlub2RlcyBv
biAzMi1iaXQgbWFjaGluZXM7IHlvdQo+IGNhbiB0cnkgbW91bnRpbmcgd2l0aCAtbyBpbm9kZTY0
IHQgYWxsb3cgdGhpcy4KPgpJIHRyaWVkIC1vIGlub2RlNjQgb3B0aW9uLCBidXQga2VybmVsIGdp
dmVzIG1lIGVycm9yIG1lc3NhZ2U6ClhGUzogaW5vZGU2NCBvcHRpb24gbm90IGFsbG93ZWQgb24g
dGhpcyBzeXN0ZW0KSSBkb3VidCB0aGlzIG9wdGlvbiBjYW4ndCBiZSB1c2VkIG9uIDMyLWJpdCBt
YWNoaW5lLgoKPiBCZSB3YXJuZWQgdGhvdWdoIHRoYXQgc29tZSBhcHBsaWNhdGlvbnMgdXNlIDMy
LWJpdCBzdGF0IGNhbGxzIHN0aWxsLAo+IHJhdGhlciB0aGFuIDY0LWJpdCB2YXJpYW50cywgYW5k
IHlvdSBtYXkgaGF2ZSBzb21lIHByb2JsZW1zLiDCoFlvdSBzaG91bGQKPiBmaWxlIGJ1Z3MgYWdh
aW5zdCBhbnkgc3VjaCBhcHBsaWNhdGlvbnMgdGhhdCB5b3UgZmluZC4uLgo+Cj4gLWVyaWMKPgoK
CgotLSAKVGhlIHNpbXBsZXN0IGlzIG5vdCBhbGwgYmVzdCBidXQgdGhlIGJlc3QgaXMgc3VyZWx5
IHRoZSBzaW1wbGVzdCEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNv
bS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
