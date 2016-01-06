Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0633D7F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 10:16:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78BBEAC004
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 08:16:53 -0800 (PST)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
	[209.85.217.176]) by cuda.sgi.com with ESMTP id
	CIT9LE02Pnt2I4or (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 08:16:48 -0800 (PST)
Received: by mail-lb0-f176.google.com with SMTP id sv6so186096574lbb.0
	for <xfs@oss.sgi.com>; Wed, 06 Jan 2016 08:16:48 -0800 (PST)
Received: from xps.localnet (85-222-71-204.dynamic.chello.pl. [85.222.71.204])
	by smtp.gmail.com with ESMTPSA id
	h196sm17584491lfb.48.2016.01.06.08.16.45 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Wed, 06 Jan 2016 08:16:45 -0800 (PST)
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH] xfs: handle dquot buffer readahead in log recovery
	correctly
Date: Wed, 6 Jan 2016 17:16:44 +0100
References: <1452052834-20605-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1452052834-20605-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201601061716.44402.arekm@maven.pl>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

T24gV2VkbmVzZGF5IDA2IG9mIEphbnVhcnkgMjAxNiwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IEZy
b206IERhdmUgQ2hpbm5lciA8ZGNoaW5uZXJAcmVkaGF0LmNvbT4KPiAKPiBXaGVuIHdlIGRvIGRx
dW90IHJlYWRhaGVhZCBpbiBsb2cgcmVjb3ZlcnksIHdlIGRvIG5vdCB1c2UgYSB2ZXJpZmllcgo+
IGFzIHRoZSB1bmRlcmx5aW5nIGJ1ZmZlciBtYXkgbm90IGhhdmUgZHF1b3RzIGluIGl0LiBlLmcu
IHRoZQo+IGFsbG9jYXRpb24gb3BlcmF0aW9uIGhhc24ndCB5ZXQgYmVlbiByZXBsYXllZC4gSGVu
Y2Ugd2UgZG8gbm90IHdhbnQKPiB0byBmYWlsIHJlY292ZXJ5IGJlY2F1c2Ugd2UgZGV0ZWN0IGFu
IG9wZXJhdGlvbiB0byBiZSByZXBsYXllZCBoYXMKPiBub3QgYmVlbiBydW4geWV0LiBUaGlzIHBy
b2JsZW0gd2FzIGFkZHJlc3NlZCBmb3IgaW5vZGVzIGluIGNvbW1pdAo+IGQ4OTE0MDAgKCJ4ZnM6
IGlub2RlIGJ1ZmZlcnMgbWF5IG5vdCBiZSB2YWxpZCBkdXJpbmcgcmVjb3ZlcnkKPiByZWFkYWhl
YWQiKSBidXQgdGhlIHByb2JsZW0gd2FzIG5vdCByZWNvZ25pc2VkIHRvIGV4aXN0IGZvciBkcXVv
dHMKPiBhbmQgdGhlaXIgYnVmZmVycyBhcyB0aGUgZHF1b3QgcmVhZGFoZWFkIGRpZCBub3QgaGF2
ZSBhIHZlcmlmaWVyLgo+IAo+IFRoZSByZXN1bHQgb2Ygbm90IHVzaW5nIGEgdmVyaWZpZXIgaXMg
dGhhdCB3aGVuIHRoZSBidWZmZXIgaXMgdGhlbgo+IG5leHQgcmVhZCB0byByZXBsYXkgYSBkcXVv
dCBtb2RpZmljYXRpb24sIHRoZSBkcXVvdCBidWZmZXIgdmVyaWZpZXIKPiB3aWxsIG9ubHkgYmUg
YXR0YWNoZWQgdG8gdGhlIGJ1ZmZlciBpZiAqcmVhZGFoZWFkIGlzIG5vdCBjb21wbGV0ZSouCj4g
SGVuY2Ugd2UgY2FuIHJlYWQgdGhlIGJ1ZmZlciwgcmVwbGF5IHRoZSBkcXVvdCBjaGFuZ2VzIGFu
ZCB0aGVuIGFkZAo+IGl0IHRvIHRoZSBkZWx3cmkgc3VibWlzc2lvbiBsaXN0IHdpdGhvdXQgaXQg
aGF2aW5nIGEgdmVyaWZpZXIKPiBhdHRhY2hlZCB0byBpdC4gVGhpcyB0aGVuIGdlbmVyYXRlcyB3
YXJuaW5ncyBpbiB4ZnNfYnVmX2lvYXBwbHkoKSwKPiB3aGljaCBjYXRjaGVzIGFuZCB3YXJucyBh
Ym91dCB0aGlzIGNhc2UuCj4gCj4gRml4IHRoaXMgYW5kIG1ha2UgaXQgaGFuZGxlIHRoZSBzYW1l
IHJlYWRhaGVhZCB2ZXJpZmllciBlcnJvciBjYXNlcwo+IGFzIGZvciBpbm9kZSBidWZmZXJzIGJ5
IGFkZGluZyBhIG5ldyByZWFkYWhlYWQgdmVyaWZpZXIgdGhhdCBoYXMgYQo+IHdyaXRlIG9wZXJh
dGlvbiBhcyB3ZWxsIGFzIGEgcmVhZCBvcGVyYXRpb24gdGhhdCBtYXJrcyB0aGUgYnVmZmVyIGFz
Cj4gbm90IGRvbmUgaWYgYW55IGNvcnJ1cHRpb24gaXMgZGV0ZWN0ZWQuICBBbHNvIG1ha2Ugc3Vy
ZSB3ZSBkb24ndCBydW4KPiByZWFkYWhlYWQgaWYgdGhlIGRxdW90IGJ1ZmZlciBoYXMgYmVlbiBt
YXJrZWQgYXMgY2FuY2VsbGVkIGJ5Cj4gcmVjb3ZlcnkuCj4gCj4gVGhpcyB3aWxsIHJlc3VsdCBp
biByZWFkYWhlYWQgZWl0aGVyIHN1Y2NlZWRpbmcgYW5kIHRoZSBidWZmZXIKPiBoYXZpbmcgYSB2
YWxpZCB3cml0ZSB2ZXJpZmllciwgb3IgcmVhZGFoZWFkIGZhaWxpbmcgYW5kIHRoZSBidWZmZXIK
PiBzdGF0ZSByZXF1aXJpbmcgdGhlIHN1YnNlcXVlbnQgcmVhZCB0byByZXN1Ym1pdCB0aGUgSU8g
d2l0aCB0aGUgbmV3Cj4gdmVyaWZpZXIuICBJbiBlaXRoZXIgY2FzZSwgdGhpcyB3aWxsIHJlc3Vs
dCBpbiB0aGUgYnVmZmVyIGFsd2F5cwo+IGVuZGluZyB1cCB3aXRoIGEgdmFsaWQgd3JpdGUgdmVy
aWZpZXIgb24gaXQuCgpDaGVja2VkIHRoaXMgcGF0Y2ggb24gNC4xLjE1LgoKV2hlbiB0aGUgaXNz
dWUgb2NjdXJlZCBJIHN0YXJ0ZWQgc2VlaW5nIHRob3VzYW5kcyBvZiAiX3hmc19idWZfaW9hcHBs
eTogbm8gb3BzIApvbiBibG9jayAuLi4iICBlbnRyaWVzIGluIGxvZ3MuCgpXaXRoIHRoaXMgcGF0
Y2ggdGhlc2UgYXJlIGFsbCBnb25lLgoKLS0gCkFya2FkaXVzeiBNacWba2lld2ljeiwgYXJla20g
LyAoIG1hdmVuLnBsIHwgcGxkLWxpbnV4Lm9yZyApCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpo
dHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
