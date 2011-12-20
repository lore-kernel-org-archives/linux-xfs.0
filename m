Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBKM4cji189086 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 16:04:38 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MCcGNq88qu6u9hTG for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 14:04:36 -0800 (PST)
Date: Wed, 21 Dec 2011 09:04:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: attempt to access beyond end of device
Message-ID: <20111220220433.GZ23662@dastard>
References: <CADDb1s1cSM0vS3gnO369hwHwe5dJ0Afaf_6wNVDf0eT-jTvKCg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s1cSM0vS3gnO369hwHwe5dJ0Afaf_6wNVDf0eT-jTvKCg@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

T24gVHVlLCBEZWMgMjAsIDIwMTEgYXQgMDc6MTg6MTVQTSArMDUzMCwgQW1pdCBTYWhyYXdhdCB3
cm90ZToKPiBIaSwKPiAKPiBXaGlsZSB0cnlpbmcgdG8gb3BlbiBhIGZpbGUgd2l0aCBhIGxhcmdl
IG51bWJlciBvZiBleHRlbnRzIGluIGFwcGVuZAo+IG1vZGUg4oCTIGl0IHJlc3VsdGVkIGluIHRo
ZSBiZWxvdyBlcnJvciBsb2dzIGNvbnRpbnVhbGx5Lgo+IEkgd2FzIHRyeWluZyB0byBvcGVuIHRo
ZSBmaWxlIGluIGFwcGVuZCBtb2RlLCBidXQgaXQgc2hvd2VkIGVycm9yLCBzbwo+IEkgY2hlY2tl
ZCBmb3IgdGhlIGV4dGVudHMg4oCTIGl0IGhhcyBhcm91bmQgMjIzOCBleHRlbnRzLiBBbHRob3Vn
aCwgaXQKClRoZSBmaXJzdCBxdWVzdGlvbiB5b3UgaGF2ZSB0byBnZXQgdG8gdGhlIGJvdHRvbSBv
ZiBpcyBpZiB0aGVyZSBhcmUKb25seSAyMjM4IGV4dGVudHMgaW4gdGhlIGZpbGUsIHdoeSBpcyB0
aGUgeGZzX2JtYXAgb3V0cHV0IHNob3dpbmcKbW9yZSB0aGFuIHRoYXQ/Cgo+IGlzIG5vdCByZXBl
dGl0aXZlLCB3aGVuIEkgdHJ5IG9uIG5leHQgbW91bnQgYW5kIHdyaXRlIOKAkyBpdCBpcyB3b3Jr
aW5nCj4gZmluZSBhdCB0aW1lcy4KPiBBbHNvLCB0aGUgc3lzdGVtIGRvZXMgbm90IHNlZW0gdG8g
YmUgY29ycnVwdGVkLiBTaW5jZSwgcnVubmluZwo+IHhmc19yZXBhaXIgYWZ0ZXIgdW1vdW50IGRv
ZXMgbm90IHNob3cgYW55IGVycm9ycy4KCldoaWNoIGltcGxpZXMgbWVtb3J5IGNvcnJ1cHRpb24u
IEhhdmUgeW91IHR1cm5lZCBvbiBtZW1vcnkgcG9pc29uaW5nCmFuZCB0aGUgbWVtb3J5IGxlYWsg
ZGV0ZWN0aW9uIHRvIHNlZSBpZiBpdCBkZXRlY3RzIGFueSBwcm9ibGVtcz8KCldoYXQgYWJvdXQg
cnVubmluZyB3aXRoIENPTkZJR19YRlNfREVCVUc9eT8gRG9lcyB0aGF0IHRyaXAgYW55CnByb2Js
ZW1zIHNvb25lciB0aGFuIHRoZSBjb3JydXB0aW9uIGlzIGRldGVjdGVkPwoKQ2hlZXJzLAoKRGF2
ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Mu
c2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
