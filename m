Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HN2iMu013419 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:02:45 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92AE6145FA87
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:05:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	9NTDVUDoEQOjmGbl for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:05:59 -0700 (PDT)
Date: Tue, 18 May 2010 09:04:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Message-ID: <20100517230453.GM8120@dastard>
References: <20100510022033.GB7165@dastard> <4BF1B4FE.7020503@redhat.com>
	<20100517214532.GL8120@dastard> <4BF1C0B4.5090009@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF1C0B4.5090009@redhat.com>
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
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com

T24gTW9uLCBNYXkgMTcsIDIwMTAgYXQgMDY6MTg6MjhQTSAtMDQwMCwgRG91ZyBMZWRmb3JkIHdy
b3RlOgo+IE9uIDA1LzE3LzIwMTAgMDU6NDUgUE0sIERhdmUgQ2hpbm5lciB3cm90ZToKPiA+IE9u
IE1vbiwgTWF5IDE3LCAyMDEwIGF0IDA1OjI4OjMwUE0gLTA0MDAsIERvdWcgTGVkZm9yZCB3cm90
ZToKPiA+PiBPbiAwNS8wOS8yMDEwIDEwOjIwIFBNLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4gPj4+
IE9uIFN1biwgTWF5IDA5LCAyMDEwIGF0IDA4OjQ4OjAwUE0gKzAyMDAsIFJhaW5lciBGdWVnZW5z
dGVpbiB3cm90ZToKPiA+Pj4+Cj4gPj4+PiB0b2RheSBpbiB0aGUgbW9ybmluZyBzb21lIGRhZW1v
biBwcm9jZXNzZXMgdGVybWluYXRlZCBiZWNhdXNlIG9mCj4gPj4+PiBlcnJvcnMgaW4gdGhlIHhm
cyBmaWxlIHN5c3RlbSBvbiB0b3Agb2YgYSBzb2Z0d2FyZSByYWlkNSwgY29uc2lzdGluZwo+ID4+
Pj4gb2YgNCoxLjVUQiBXRCBjYXZpYXIgZ3JlZW4gU0FUQSBkaXNrcy4KPiA+Pj4KPiA+Pj4gUmVt
aW5kcyBtZSBvZiBhIHJlY2VudCgtaXNoKSBtZC9kbSByZWFkYWhlYWQgY2FuY2VsbGF0aW9uIGZp
eCAtIHRoYXQKPiA+Pj4gd291bGQgZml0IHRoZSBzeW1wdG9tcyBvZiAoYnRyZWUgY29ycnVwdGlv
biBzaG93aW5nIHVwIHVuZGVyIGhlYXZ5IElPCj4gPj4+IGxvYWQgYnV0IG5vIGNvcnJ1cHRpb24g
b24gZGlzay4gSG93ZXZlciwgSSBjYW4ndCBzZWVtIHRvIGZpbmQgYW55Cj4gPj4+IHJlZmVyZW5j
ZXMgdG8gaXQgYXQgdGhlIG1vbWVudCAoY2FuJ3QgcmVtZW1iZXIgdGhlIGJ1ZyB0aXRsZSksIGJ1
dAo+ID4+PiBwZXJoYXBzIHlvdXIgZGlzdHJvIGRvZXNuJ3QgaGF2ZSB0aGUgZml4IGluIGl0Pwo+
ID4+Pgo+ID4+PiBDaGVlcnMsCj4gPj4+Cj4gPj4+IERhdmUuCj4gPj4KPiA+PiBUaGF0IHNvdW5k
cyBwbGF1c2libGUsIGFzIGRvZXMgaGFyZHdhcmUgZXJyb3IuICBBIG1lbW9yeSBiaXQgZmxpcCB1
bmRlcgo+ID4+IGhlYXZ5IGxvYWQgd291bGQgY2F1c2UgdGhlIGluIG1lbW9yeSBkYXRhIHRvIGJl
IGNvcnJ1cHQgd2hpbGUgdGhlIG9uCj4gPj4gZGlzayBkYXRhIGlzIGdvb2QuCj4gPiAKPiA+IFRo
ZSBkYXRhIGR1bXBzIGZyb20gdGhlIGJhZCBibG9ja3Mgd2VyZW4ndCB3cm9uZyBieSBhIHNpbmds
ZSBiaXQgLQo+ID4gdGhleSB3ZXJlIHVucmVjb2duadGVYWJsZSBnYXJiYWdlIC0gc28gdGhhdCBp
dCB2ZXJ5IHVubGlrZWx5IHRvIGJlCj4gPiBhIG1lbW9yeSBlcnJvIGNhdXNpbmcgdGhlIHByb2Js
ZW0uCj4gCj4gTm90IHRydWUuICBJdCBjYW4gc3RpbGwgYmUgYSBzaW5nbGUgYml0IGVycm9yIGJ1
dCBhIHNpbmdsZSBiaXQgZXJyb3IKPiBoaWdoZXIgdXAgaW4gdGhlIGNoYWluLiAgQWthIGEgc2lu
Z2xlIGJpdCBlcnJvciBpbiB0aGUgc2NzaSBjb21tYW5kIHRvCj4gcmVhZCB2YXJpb3VzIHNlY3Rv
cnMsIHRoZW4geW91IHJlYWQgaW4gYWxsIHNvcnRzIG9mIHdyb25nIGRhdGEgYW5kCj4gZXZlcnl0
aGluZyBmcm9tIHRoZXJlIGlzIHRvdGFsbHkgd2hhY2tlZC4KCkkgZGlkbid0IHNheSBpdCAqY291
bGRuJ3QgYmUqIGEgYml0IGVycm9yLCBqdXN0IGl0IHdhcyBfdmVyeQp1bmxpa2VseV8uICBIYXJk
d2FyZSBlcnJvcnMgdGhhdCByZXN1bHQgb25seSBpbiByZXBlYXRlZCBYRlMgYnRyZWUKY29ycnVw
dGlvbiBpbiBtZW1vcnkgb3IgY2F1c2luZyBvdGhlciBlcnJvcnMgaW4gdGhlIHN5c3RlbSBpcwpz
b21ldGhpbmcgSSd2ZSBuZXZlciBzZWVuLCBldmVuIG9uIG1hY2hpbmVzIHdpdGgga25vd24gYmFk
IG1lbW9yeSwKSEJBcywgaW50ZXJjb25uZWN0cywgZXRjLiBBcHBseWluZyBPY2NhbSdzIFJhem9y
IHRvIHRoaXMgY2FzZQppbmRpY2F0ZXMgdGhhdCBpdCBpcyBnb2luZyB0byBiZSBjYXVzZWQgYnkg
YSBzb2Z0d2FyZSBwcm9ibGVtLgoKWWVzLCBpdCdzIHN0aWxsIHBvc3NpYmxlIHRoYXQgaXQncyBh
IGhhcmR3YXJlIGlzc3VlLCBqdXN0IHZlcnksIHZlcnkKdW5saWtlbHkuIEFuZCBpZiBpdCBpcyBo
YXJkd2FyZSBhbmQgeW91IGNhbiBwcm92ZSB0aGF0IGl0IHdhcyB0aGUKY2F1c2UsIHRoZW4gSSBz
dWdnZXN0IHdlIGFsbCBidXkgYSBsb3R0ZXJ5IHRpY2tldC4uLi4gOykKCkNoZWVycywKCkRhdmUu
Ci0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
