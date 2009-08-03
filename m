Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73EW4FZ094555
	for <linux-xfs@oss.sgi.com>; Mon, 3 Aug 2009 09:32:05 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7523312AD384
	for <linux-xfs@oss.sgi.com>; Mon,  3 Aug 2009 07:42:08 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	SGYHPRTcNUEsYBpx for <linux-xfs@oss.sgi.com>;
	Mon, 03 Aug 2009 07:42:08 -0700 (PDT)
Received: by bwz10 with SMTP id 10so2372436bwz.20
	for <linux-xfs@oss.sgi.com>; Mon, 03 Aug 2009 07:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6DAE5D.6060704@sandeen.net>
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
	<4A6D075B.9060601@sandeen.net>
	<389deec70907262347g1ca3637fn469596ec1e05148@mail.gmail.com>
	<4A6DAE5D.6060704@sandeen.net>
Date: Mon, 3 Aug 2009 22:32:47 +0800
Message-ID: <389deec70908030732n29d35220mc9acdb912ab10899@mail.gmail.com>
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
IHdyb3RlOgo+PiAyMDA5LzcvMjcgRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PjoK
Pj4+IGhhbmsgcGVuZyB3cm90ZToKPj4+PiBIaSwgZm9sa3M6Cj4+Pj4gSSBoYXZlIGEgMi41VCBm
aWxlIHN5c3RlbSBmb3JtYXR0ZWQgd2l0aCBYRlMsIGRmIHRlbGxzIG1lIGl0IHN0aWxsCj4+Pj4g
aGF2ZSBhYm91dCAxMEcgc3BhY2UgYXZhaWxhYmxlLCBidXQgSSBjYW4ndCBjcmVhdGUgbmV3IGZp
bGVzIG9yCj4+Pj4gZGlyZWN0b3J5IGFueSBtb3JlLiBSZXR1cm4gbWVzc2FnZSBpcyAiTm8gc3Bh
Y2UgbGVmdCBvbiB0aGlzIGRldmljZSIuCj4+Pj4gSSBzZWFyY2hlZCBzb2x1dGlvbiBmb3IgdGhp
cyBwcm9ibGVtIHRocm91Z2ggZ29vZ2xlLCBhbmQgZm91bmQgdGhpczoKPj4+PiBodHRwOi8vb3Nz
LnNnaS5jb20vYXJjaGl2ZXMveGZzLzIwMDUtMDYvbXNnMDAzNDcuaHRtbC4gSSB0aGluayBpdCBp
cyBhCj4+Pj4ga25vd24gIk5vIHNwYWNlIGxlZnQiIHByb2JsZW0uIEkgd29uZGVyIHdoZXRoZXIg
aXQgY2FuIG9ubHkKPj4+PiBiZSBzb2x2ZWQgb24gNjQtYml0IG1hY2hpbmU/IElmIG9uIG15IDMy
LWJpdCBtYWNoaW5lLCB3aGF0IHNob3VsZCBJIGRvPwo+Pj4gT24gdmVyeSByZWNlbnQga2VybmVs
cyB5b3UgY2FuIHVzZSA2NC1iaXQgaW5vZGVzIG9uIDMyLWJpdCBtYWNoaW5lczsgeW91Cj4+PiBj
YW4gdHJ5IG1vdW50aW5nIHdpdGggLW8gaW5vZGU2NCB0IGFsbG93IHRoaXMuCj4+Pgo+PiBJIHRy
aWVkIC1vIGlub2RlNjQgb3B0aW9uLCBidXQga2VybmVsIGdpdmVzIG1lIGVycm9yIG1lc3NhZ2U6
Cj4+IFhGUzogaW5vZGU2NCBvcHRpb24gbm90IGFsbG93ZWQgb24gdGhpcyBzeXN0ZW0KPj4gSSBk
b3VidCB0aGlzIG9wdGlvbiBjYW4ndCBiZSB1c2VkIG9uIDMyLWJpdCBtYWNoaW5lLgo+Cj4gVGhh
dCdzIHdoeSBJIHNhaWQgeW91IG5lZWQgYSB2ZXJ5IHJlY2VudCBrZXJuZWwsIGl0IHdhcyBhZGRl
ZCByZWxhdGl2ZWx5Cj4gcmVjZW50bHk6Cj4KPiBjb21taXQgNmMzMWI5M2ExNGE0NTNjODc1NmZm
ZDIyOGUyNDkxMGZmZGYzMGM1ZAo+IEF1dGhvcjogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBpbmZy
YWRlYWQub3JnPgo+IERhdGU6IMKgIEZyaSBOb3YgMjggMTQ6MjM6MzIgMjAwOCArMTEwMAo+Cj4g
wqAgwqBbWEZTXSBhbGxvdyBpbm9kZTY0IG1vdW50IG9wdGlvbiBvbiAzMiBiaXQgc3lzdGVtcwo+
Cj4gSSBiZWxpZXZlIHRoaXMgd2VudCBpbnRvIDIuNi4yOS4KPgpJIHRyaWVkIDIuNi4zMCBhbmQg
dGVzdCBpdAoxLiBjcmVhdGUgYW4gZXhhY3QgMlQgTFZNCjIuIGNyZWF0ZSBYRlMgb24gaXQKMy4g
bW9udCBpdCB3aXRoIGlub2RlNjQgb3B0aW9uCjQuIHdyaXRlIGZpbGVzIG9uIGl0IHRvIGZ1bGwg
ZXh0ZW50CjUuIHVzZSB4ZnNfZ3JvdyB0byBleHBhbmQgaXQgdG8gMi41VAo2LiB0b3VjaCBhIGZp
bGUgYW5kIG5vIGVycm9yIG1lc3NhZ2UgcmV0dXJuZWQKNy4gJ2xzIC1sJyBjYW4gbm90IHNob3cg
dGhlIGZpbGUgSSBjcmVhdGVkIGFib3ZlLgoKU28gSSB0aGluayBJIHNob3VsZCBkbyBzb21ldGhp
bmcgb24gdXNlcnNwYWNlIHRvb2xzLCBidXQgaG93Pwo+IC1FcmljCj4KPgoKCgotLSAKVGhlIHNp
bXBsZXN0IGlzIG5vdCBhbGwgYmVzdCBidXQgdGhlIGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVz
dCEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
