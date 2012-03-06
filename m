Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q26KUYwH213645 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 14:30:35 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rthTr4xg3uOHfqX4 for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 12:30:32 -0800 (PST)
Date: Wed, 7 Mar 2012 07:30:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
Message-ID: <20120306203020.GG3592@dastard>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
	<1330983612.28645.18.camel@utemp.mieszkanie>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330983612.28645.18.camel@utemp.mieszkanie>
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
To: =?utf-8?B?UmFmYcWC?= Kupka <kupson@kupson.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

T24gTW9uLCBNYXIgMDUsIDIwMTIgYXQgMTA6NDA6MTJQTSArMDEwMCwgUmFmYcWCIEt1cGthIHdy
b3RlOgo+IE9uIFNhdCwgMjAxMi0wMy0wMyBhdCAwNjo0NCAtMDUwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiBPbiBTYXQsIE1hciAwMywgMjAxMiBhdCAxMjozNzowN1BNICswMTAwLCBS
YWZhPz8gS3Vwa2Egd3JvdGU6Cj4gPiA+IE9uIEZyaSwgMjAxMi0wMy0wMiBhdCAwNTo0MyAtMDUw
MCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gSGksCj4gCj4gSSd2ZSBjb21wbGV0ZWQgYmlz
ZWN0aW9uIHByb2Nlc3MuIEl0IGxvb2tzIGxpa2Uga2VybmVsIHVwIHRvCj4gCj4gNzA0YjI5MDcg
InhmczogcmVnaXN0ZXIgdGhlIGlub2RlIGNhY2hlIHNocmlua2VyIGJlZm9yZSBxdW90YWNoZWNr
cyIKPiAKPiBpcyBnb29kIGFuZCBmaXJzdCBiYWQgY29tbWl0IGlzOgo+IAo+IDBlNmU4NDdmICJ4
ZnM6IHN0b3AgdXNpbmcgdGhlIHBhZ2UgY2FjaGUgdG8gYmFjayB0aGUgYnVmZmVyIGNhY2hlIgoK
V2hpY2ggY2hhbmdlZCBpbnRlcm5hbHMgb2YgdGhlIGJ1ZmZlciBjYWNoZSwgYnV0IG5vdCB0aGUg
ZXh0ZXJuYWwKaW50ZXJmYWNlcy4KCj4gSSBkb3VibGUgdGVzdGVkIGl0IC0gNzA0YjI5MDcgY2Fu
IGRvIDYwKyBsb29wcyBvZiB4ZnNkdW1wIHdpdGhvdXQgYW55Cj4gdHJvdWJsZSBhbmQgMGU2ZTg0
N2YgYnJlYWtzIGluIDwxMCBpdGVyYXRpb25zLgoKV2hhdCBpcyB5b3VyIHRlc3QgY2FzZT8KCkFs
c28sIGl0IG1pZ2h0IGJlIHdvcnRod2hpbGUgdG8gY2FwdHVyZSBhbiBldmVudCB0cmFjZSAoZS5n
LiBhbGwgdGhlCnhmc19idWYgZXZlbnRzKSB0byBzZWUgd2hhdCBvY2N1cnMganVzdCBiZWZvcmUg
dGhlIGVycm9yIGlzCnRyaWdnZXJlZC4gVGhhdCBtaWdodCB0ZWxsIHVzIGV4YWN0bCB3aGF0IHNl
cXVlbmNlIGhhcyBvY2N1cnJlZApsZWFkaW5nIHVwIHRvIHRoZSBlcnJvci4KCkNoZWVycywKCkRh
dmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
