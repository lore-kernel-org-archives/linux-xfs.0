Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 977937CA0
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 22:12:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10927AC001
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 20:12:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Yn4FVrXza4fU5mev for <xfs@oss.sgi.com>;
	Mon, 30 May 2016 20:12:26 -0700 (PDT)
Date: Tue, 31 May 2016 13:10:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
Message-ID: <20160531031010.GB12670@dastard>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
	<9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
	<CAGbZs7i66XWt3PF1_-L-WeBtdH80nfAOv+-Ary+ORKHxFGOLFg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGbZs7i66XWt3PF1_-L-WeBtdH80nfAOv+-Ary+ORKHxFGOLFg@mail.gmail.com>
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
To: =?utf-8?B?6ZmI5a6X5b+X?= <baotiao@gmail.com>
Cc: xfs@oss.sgi.com

T24gVHVlLCBNYXkgMzEsIDIwMTYgYXQgMTA6NDM6MzZBTSArMDgwMCwg6ZmI5a6X5b+XIHdyb3Rl
Ogo+IEkgaGF2ZSBmaW50IHRoZSB3YXkgdG8gY2hhbmdlIHRoZSBleHRlbnQgc2l6ZSBoaW50Cj4g
bWtmcy54ZnMgLXIgZXh0c2l6ZT00MDk2MCAvZGV2L3NkYTEKCkFoLCBubywgdGhhdCBpc24ndCB0
aGUgZXh0c2l6ZSBJJ20gcmVmZXJpbmcgdG8uIFRoYXQncyBmb3IgcmVhbHRpbWUKZGV2aWNlIGNv
bmZpZ3VyYXRpb24gYXQgbWtmcywgbm90IGEgcGVyLWlub2RlIGV4dGVudCBzaXplIGhpbnQuCgpX
aGVuIHlvdSBjcmVhdGUgdGhlIGltYWdlIGZpbGUgZG8gdGhpczoKCiQgeGZzX2lvIC1mIC1jICJl
eHRzaXplIDFtIiAvcGF0aC90by9uZXcvdm1faW1hZ2UKJCBxZW11LWltYWdlIGNyZWF0ZSAtZiBx
Y293MiAvcGF0aC90by9uZXcvdm1faW1hZ2UgMTBnCiQgeGZzX2lvIC1jIGV4dHNpemUgL3BhdGgv
dG8vbmV3L3ZtX2ltYWdlClsxMDQ4NTc2XSAvcGF0aC90by9uZXcvdm1faW1hZ2UKJAoKQW5kIG5v
dyB0aGUgcWNvdzIgaW1hZ2UgZmlsZSB3aWxsIGhhdmUgZXh0ZW50cyBhbGxvY2F0ZWQgaW4KbXVs
dGlwbGVzIG9mIDFNQi4KCkNoZWVycywKCkRhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJv
bW9yYml0LmNvbQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
