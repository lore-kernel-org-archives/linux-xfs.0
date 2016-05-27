Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC6FC7CA3
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 12:32:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80AB08F804C
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 10:32:26 -0700 (PDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id 1w1Qi3pZppZBV98v
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 May 2016 10:32:22 -0700 (PDT)
Received: by mail-wm0-f41.google.com with SMTP id z87so1299698wmh.0
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 10:32:22 -0700 (PDT)
Subject: Re: [PATCH] xfs: fail ->bmap for reflink inodes
References: <1464267724-31423-1-git-send-email-hch@lst.de>
	<1464267724-31423-2-git-send-email-hch@lst.de>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <71afd256-5dfe-2ff9-ac25-b7519dadd5f9@scylladb.com>
Date: Fri, 27 May 2016 20:32:18 +0300
MIME-Version: 1.0
In-Reply-To: <1464267724-31423-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, darrick.wong@oracle.com
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

T24gMDUvMjYvMjAxNiAwNDowMiBQTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gU2lnbmVk
LW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBmcy94ZnMv
eGZzX2FvcHMuYyB8IDExICsrKysrKysrKysrCj4gICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKQo+Cj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYW9wcy5jIGIvZnMveGZzL3hmc19h
b3BzLmMKPiBpbmRleCBhOTU1NTUyLi5kMDUzYTllIDEwMDY0NAo+IC0tLSBhL2ZzL3hmcy94ZnNf
YW9wcy5jCj4gKysrIGIvZnMveGZzL3hmc19hb3BzLmMKPiBAQCAtMTgyOSw2ICsxODI5LDE3IEBA
IHhmc192bV9ibWFwKAo+ICAgCj4gICAJdHJhY2VfeGZzX3ZtX2JtYXAoWEZTX0koaW5vZGUpKTsK
PiAgIAl4ZnNfaWxvY2soaXAsIFhGU19JT0xPQ0tfU0hBUkVEKTsKPiArCj4gKwkvKgo+ICsJICog
VGhlIHN3YXAgY29kZSAoYWItKXVzZXMgLT5ibWFwIHRvIGdldCBhIGJsb2NrIG1hcHBpbmcgYW5k
IHRoZW4KPiArCSAqIGJ5cGFzc2XRlSB0aGUgZmlsZSBzeXN0ZW0gZm9yIGFjdHVhbCBJL08uICBX
ZSByZWFsbHkgY2FuJ3QgYWxsb3cKPiArCSAqIHRoYXQgb24gcmVmbGlua3MgaW5vZGVzLCBzbyB3
ZSBoYXZlIHRvIHNraXAgb3V0IGhlcmUuICBBbmQgeWVzLAo+ICsJICogMCBpcyB0aGUgbWFnaWMg
Y29kZSBmb3IgYSBibWFwIGVycm9yLi4KPiArCSAqLwo+ICsJaWYgKHhmc19pc19yZWZsaW5rX2lu
b2RlKGlwKSkgewo+ICsJCXhmc19pdW5sb2NrKGlwLCBYRlNfSU9MT0NLX1NIQVJFRCk7Cj4gKwkJ
cmV0dXJuIDA7Cj4gKwl9Cj4gICAJZmlsZW1hcF93cml0ZV9hbmRfd2FpdChtYXBwaW5nKTsKPiAg
IAl4ZnNfaXVubG9jayhpcCwgWEZTX0lPTE9DS19TSEFSRUQpOwo+ICAgCXJldHVybiBnZW5lcmlj
X2Jsb2NrX2JtYXAobWFwcGluZywgYmxvY2ssIHhmc19nZXRfYmxvY2tzKTsKCkRvbid0IHlvdSBh
bHNvIGhhdmUgdG8gcHJldmVudCBhIHN3YXBmaWxlIGZyb20gYmVpbmcgcmVmbGlua2VkIGFmdGVy
IAppdCdzIGJtYXBwZWQ/ICBPciBpcyB0aGF0IGFscmVhZHkgdGFrZW4gY2FyZSBvZj8KCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxp
c3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hm
cwo=
