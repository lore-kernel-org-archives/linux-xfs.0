Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6RFm8lh110519
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jul 2009 10:48:08 -0500
Received: from mail-fx0-f208.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF5F31214ECB
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jul 2009 08:57:33 -0700 (PDT)
Received: from mail-fx0-f208.google.com (mail-fx0-f208.google.com
	[209.85.220.208]) by cuda.sgi.com with ESMTP id
	A23xUACssoE1Qqb1 for <linux-xfs@oss.sgi.com>;
	Mon, 27 Jul 2009 08:57:33 -0700 (PDT)
Received: by fxm4 with SMTP id 4so2581527fxm.20
	for <linux-xfs@oss.sgi.com>; Mon, 27 Jul 2009 08:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6DAE5D.6060704@sandeen.net>
References: <389deec70907252030s3524b2ecj9b35da9ea376020f@mail.gmail.com>
	<4A6D075B.9060601@sandeen.net>
	<389deec70907262347g1ca3637fn469596ec1e05148@mail.gmail.com>
	<4A6DAE5D.6060704@sandeen.net>
Date: Mon, 27 Jul 2009 23:48:51 +0800
Message-ID: <389deec70907270848s339eeeefm3fcd05be3c941cb8@mail.gmail.com>
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
Cj4gSSBiZWxpZXZlIHRoaXMgd2VudCBpbnRvIDIuNi4yOS4KPgp0aHgsIGkgd2lsbCB0cnkgQVNB
UAo+IC1FcmljCj4KPgoKCgotLSAKVGhlIHNpbXBsZXN0IGlzIG5vdCBhbGwgYmVzdCBidXQgdGhl
IGJlc3QgaXMgc3VyZWx5IHRoZSBzaW1wbGVzdCEKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
