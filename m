Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S7gMYa203579 for <xfs@oss.sgi.com>; Fri, 28 May 2010 02:42:23 -0500
Received: from mgw-mx06.nokia.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB678130BDBA
	for <xfs@oss.sgi.com>; Fri, 28 May 2010 00:46:39 -0700 (PDT)
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233]) by
	cuda.sgi.com with ESMTP id cPl3IybG6zDk0J7r for
	<xfs@oss.sgi.com>; Fri, 28 May 2010 00:46:39 -0700 (PDT)
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
From: Artem Bityutskiy <dedekind1@gmail.com>
In-Reply-To: <20100527133223.efa4740a.akpm@linux-foundation.org>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<20100527133223.efa4740a.akpm@linux-foundation.org>
Date: Fri, 28 May 2010 10:42:06 +0300
Message-ID: <1275032526.15516.83.camel@localhost>
Mime-Version: 1.0
Reply-To: dedekind1@gmail.com
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

T24gVGh1LCAyMDEwLTA1LTI3IGF0IDEzOjMyIC0wNzAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOgo+
IE9uIFR1ZSwgMjUgTWF5IDIwMTAgMTg6NTM6MDMgKzEwMDAKPiBEYXZlIENoaW5uZXIgPGRhdmlk
QGZyb21vcmJpdC5jb20+IHdyb3RlOgo+IAo+ID4gVGhpcyBzZXJpZXMgcmV3b3JrcyB0aGUgZmls
ZXN5c3RlbSBzaHJpbmtlcnMuIFdlIGN1cnJlbnRseSBoYXZlIGEKPiA+IHNldCBvZiBpc3N1ZXMg
d2l0aCB0aGUgY3VycmVudCBmaWxlc3lzdGVtIHNocmlua2VyczoKPiA+IAo+ID4gICAgICAgICAx
LiBUaGVyZSBpcyBhbiBkZXBlbmRlbmN5IGJldHdlZW4gZGVudHJ5IGFuZCBpbm9kZSBjYWNoZQo+
ID4gICAgICAgICAgICBzaHJpbmtpbmcgdGhhdCBpcyBvbmx5IGltcGxpY2l0bHkgZGVmaW5lZCBi
eSB0aGUgb3JkZXIgb2YKPiA+ICAgICAgICAgICAgc2hyaW5rZXIgcmVnaXN0cmF0aW9uLgo+ID4g
ICAgICAgICAyLiBUaGUgc2hyaW5rZXJzIG5lZWQgdG8gd2FsayB0aGUgc3VwZXJibG9jayBsaXN0
IGFuZCBwaW4KPiA+ICAgICAgICAgICAgdGhlIHN1cGVyYmxvY2sgdG8gYXZvaWQgdW5tb3VudCBy
YWNlcyB3aXRoIHRoZSBzYiBnb2luZwo+ID4gICAgICAgICAgICBhd2F5Lgo+ID4gICAgICAgICAz
LiBUaGUgZGVudHJ5IGNhY2hlIHVzZXMgcGVyLXN1cGVyYmxvY2sgTFJVcyBhbmQgcHJvcG9ydGlv
bnMKPiA+ICAgICAgICAgICAgcmVjbGFpbSBiZXR3ZWVuIGFsbCB0aGUgc3VwZXJibG9ja3Mgd2hp
Y2ggbWVhbnMgd2UgYXJlCj4gPiAgICAgICAgICAgIGRvaW5nIGJyZWFkdGggYmFzZWQgcmVjbGFp
bS4gVGhpcyBtZWFucyB3ZSB0b3VjaCBldmVyeQo+ID4gICAgICAgICAgICBzdXBlcmJsb2NrIGZv
ciBldmVyeSBzaHJpbmtlciBjYWxsLCBhbmQgbWF5IG9ubHkgcmVjbGFpbQo+ID4gICAgICAgICAg
ICBhIHNpbmdsZSBkZW50cnkgYXQgYSB0aW1lIGZyb20gYSBnaXZlbiBzdXBlcmJsb2NrLgo+ID4g
ICAgICAgICA0LiBUaGUgaW5vZGUgY2FjaGUgaGFzIGEgZ2xvYmFsIExSVSwgc28gaXQgaGFzIGRp
ZmZlcmVudAo+ID4gICAgICAgICAgICByZWNsYWltIHBhdHRlcm5zIHRvIHRoZSBkZW50cnkgY2Fj
aGUsIGRlc3BpdGUgdGhlIGZhY3QKPiA+ICAgICAgICAgICAgdGhhdCB0aGUgZGVudHJ5IGNhY2hl
IGlzIGdlbmVyYWxseSB0aGUgb25seSB0aGluZyB0aGF0Cj4gPiAgICAgICAgICAgIHBpbnMgaW5v
ZGVzIGluIG1lbW9yeS4KPiA+ICAgICAgICAgNS4gRmlsZXN5c3RlbXMgbmVlZCB0byByZWdpc3Rl
ciB0aGVpciBvd24gc2hyaW5rZXJzIGZvcgo+ID4gICAgICAgICAgICBjYWNoZXMgYW5kIGNhbid0
IGNvLW9yZGluYXRlIHRoZW0gd2l0aCB0aGUgZGVudHJ5IGFuZAo+ID4gICAgICAgICAgICBpbm9k
ZSBjYWNoZSBzaHJpbmtlcnMuCj4gCj4gTmljZSBkZXNjcmlwdGlvbiwgYnV0Li4uICBpdCBuZXZl
ciBhY3R1YWxseSB0b2xkIHVzIHdoYXQgdGhlIGJlbmVmaXQgb2YKPiB0aGUgY2hhbmdlcyBhcmUu
ICBQcmVzdW1hYmx5IHNvbWUgdW5kZXNjcmliZWQgd29ya2xvYWQgaGFkIHNvbWUKPiB1bmRlc2Ny
aWJlZCB1c2VyLXZpc2libGUgcHJvYmxlbS4gIEJ1dCB3aGF0IHdhcyB0aGF0IHdvcmtsb2FkLCBh
bmQgd2hhdAo+IHdhcyB0aGUgdXNlci12aXNpYmxlIHByb2JsZW0sIGFuZCBob3cgZG9lcyB0aGUg
cGF0Y2ggYWZmZWN0IGFsbCB0aGlzPwoKRm9yIFVCSUZTIGl0IHd3aWxsIGdpdmUgYSBiZW5lZml0
IGluIHRlcm1zIG9mIHNpbXBsZXIgVUJJRlMgY29kZSAtIHdlCm5vdyBoYXZlIHRvIGtlZXAgb3Vy
IG93biBsaXN0IG9mIFVCSUZTIHN1cGVyYmxvY2tzLCBwcm92aWRlIGxvY2tpbmcgZm9yCml0LCBh
bmQgbWFpbnRhaW4uIFRoaXMgaXMganVzdCBleHRyYSBidXJkZW4uIFNvIHRoZSBpdGVtIDIgYWJv
dmUgd2lsbCBiZQp1c2VmdWwgZm9yIFVCSUZTLgoKLS0gCkJlc3QgUmVnYXJkcywKQXJ0ZW0gQml0
eXV0c2tpeSAo0JDRgNGC0ZHQvCDQkdC40YLRjtGG0LrQuNC5KQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
