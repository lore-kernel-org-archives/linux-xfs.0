Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE9DC7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 14:19:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8508C8F8035
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 12:19:53 -0700 (PDT)
Received: from smtp-out-so.shaw.ca (smtp-out-so.shaw.ca [64.59.136.137]) by
	cuda.sgi.com with ESMTP id PcHZDjUpSUJHiVno (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 12:19:51 -0700 (PDT)
Subject: Re: xfs_repair fails after trying to format log cycle?
References: <56F6DE67.60403@shaw.ca> <20160328085541.GA27040@bfoster.bfoster>
	<570C8D4D.3060304@shaw.ca> <20160412140512.GA59690@bfoster.bfoster>
	<570D578D.5010706@shaw.ca> <570DB6CD.1000007@shaw.ca>
	<20160413045129.GO567@dastard> <57523CE6.7020906@shaw.ca>
	<20160606173336.027917f5@harpe.intellique.com>
From: Andrew Ryder <tireman@shaw.ca>
Message-ID: <5755CCD7.1000104@shaw.ca>
Date: Mon, 6 Jun 2016 15:19:51 -0400
MIME-Version: 1.0
In-Reply-To: <20160606173336.027917f5@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-raid@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

CgpPbiAwNi8wNi8yMDE2IDExOjMzIEFNLCBFbW1hbnVlbCBGbG9yYWMgd3JvdGU6Cj4gTGUgRnJp
LCAzIEp1biAyMDE2IDIyOjI4OjU0IC0wNDAwCj4gQW5kcmV3IFJ5ZGVyIDx0aXJlbWFuQHNoYXcu
Y2E+IMOpY3JpdmFpdDoKPgo+PiBTb3JyeSB0byBkaWcgdXAgb2xkIHN0dWZmIGhlcmUgYnV0IGFm
dGVyIHJlcGxhY2luZyBoYXJkd2FyZSBhbmQKPj4gcHVsbGluZyBteSBoYWlyIG91dCB0byBubyBl
bmQsIEkgdHJhY2VkIHRoZSBzb3VyY2Ugb2YgdGhlIHByb2JsZW0gb3V0Lgo+Pgo+PiBPbiBldmVy
eSBkcml2ZSBpbiB0aGUgYXJyYXksIHRoZSBwb2ludHMgb24gdGhlIFBDQiB3aGljaCB0aGUgY29u
dGFjdHMKPj4gZm9yIHRoZSBkcml2ZXMgbW90b3JzIGFuZCBoZWFkL2FjdHVhdG9ycyBtYWtlIGNv
bnRhY3Qgd2l0aCB3ZXJlCj4+IG94aWRpemVkIGVub3VnaCB0byBjYXVzZSB0aGUgaXNzdWUuIEkg
ZW5kZWQgdXAgcHVsbGluZyB0aGUgUENCIG9mZgo+PiBlYWNoIGRyaXZlIGFuZCBjbGVhbmluZyB0
aGVtIGFzIHdlbGwgYXMgY2xlYW5pbmcgb3V0IGFsbCBvdGhlciBjYWJsZQo+PiBhbmQgZHJpdmUg
Y29ubmVjdG9ycyBmcm9tIHRoZSBIQkEgb3V0d2FyZCBhbmQgZXZlcnl0aGluZyBpcyBoYXBweQo+
PiBhZ2Fpbi4KPj4KPj4gaHR0cDovL3MzMy5wb3N0aW1nLm9yZy91aGptdnc0ZHIvTm90X0NsZWFu
ZWQuanBnCj4+IGh0dHA6Ly9zMzMucG9zdGltZy5vcmcveG85NGllaWk3L1BhcnRpYWxfQ2xlYW5l
ZF8xLmpwZwo+PiBodHRwOi8vczMzLnBvc3RpbWcub3JnL2hvcWd5dW1nZi9QYXJ0aWFsX0NsZWFu
ZWRfMi5qcGcKPj4gaHR0cDovL3MzMy5wb3N0aW1nLm9yZy82OGsyMHQ4YTcvUGFydGlhbF9DbGVh
bmVkXzMuanBnCj4+Cj4KPiBHb29kIGpvYiwgdGhhdCB3YXMgcXVpdGUgdW5leHBlY3RlZCA6KSBB
cmUgeW91IG5leHQgdG8gdGhlCj4gc2Vhc2hvcmU/Cj4KCgpOby4gSSdtIHVwIGluIE5XIE9udGFy
aW8gaW4gQ2FuYWRhIGFjdHVhbGx5LCBmYXIgYXdheSBmcm9tIGFueSBzYWx0IAp3YXRlci4gSSdt
IGd1ZXNzaW5nIGl0IHdhcyBmcm9tIHRoZSBjb21iaW5hdGlvbiBvZiBhaXIgCnBvbGx1dGFudHMv
aHVtaWRpdHkgYW5kIGhlYXQgZ2l2ZW4gdGhlIGRyaXZlcyBhcmUgbm90IGluIHRoZSBtb3N0IApo
b3NwaXRhYmxlIGVudmlyb25tZW50IGVzcCBkdXJpbmcgdGhlIHN1bW1lciAuLi4gYnV0IGFmdGVy
IGNsZWFuaW5nIHRoZSAKYm9hcmQgY29udGFjdHMgdXAgYXMgd2VsbCBhcyB0aGUgZXNhdGEgY2Fi
bGUgZW5kcy9wb3J0cywgaXRzIHdvcmtpbmcgCmdyZWF0IGFnYWluLgoKSSdtIGJlZ2lubmluZyB0
byB0aGluayB3aGVuIEkgZG8gcmVwbGFjZSBhbnkgZHJpdmVzLCBhZnRlciB3YXJyYW50eSBpcyAK
dXAgb24gdGhlbSwgcHVsbCBvZmYgdGhlIFBDQiwgY2xlYW4gaXQgdXAgYW5kIGNvYXQgdGhlIGNv
bnRhY3RzIHdpdGggYSAKZ29vZCBzbWVhcmluZyBvZiBkaWVsZWN0cmljIGdyZWFzZSB0byBrZWVw
IHRoZSBpc3N1ZSBmcm9tIGhhcHBlbmluZy4KCk1ha2VzIG1lIHdvbmRlciBob3cgbWFueSBvdGhl
ciBwZW9wbGUgb3V0IHRoZXJlIHN1ZmZlciBmcm9tIHRoZSBzYW1lIAppc3N1ZSBnaXZlbiB0aGUg
YW1vdW50IG9mIHVucmVzb2x2ZWQgc2ltaWxhciBodyBlcnJvcnMgSSd2ZSBmb3VuZCB3aGlsZSAK
Z29vZ2xpbmcgdGhlIGVycm9ycy4uCgpUaGFua3MgYWdhaW4sCkFuZHJldwoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNA
b3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
