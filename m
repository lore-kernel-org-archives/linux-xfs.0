Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 813FA7FD5
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 08:23:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D045AC006
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 06:23:11 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id ntEvyh837JN5YXo3 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 06:23:10 -0800 (PST)
Date: Tue, 18 Feb 2014 09:23:05 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Message-ID: <20140218142305.GN26580@thunk.org>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<20140218010138.GE13997@dastard> <20140218083324.GB28666@dastard>
	<alpine.LFD.2.00.1402181006250.2216@localhost.localdomain>
	<20140218094142.GC28666@dastard>
	<alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
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
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

T24gVHVlLCBGZWIgMTgsIDIwMTQgYXQgMDE6MDQ6MjRQTSArMDEwMCwgTHVrw6HFoSBDemVybmVy
IHdyb3RlOgo+Cj4gPiBPaywgc28gaXQncyBhICJmYWxsb2NhdGUiIHRlc3QgZ3JvdXAsIHRoZW4/
Cj4gCj4gTW9yZSBsaWtlICJmc3hfZnNzdHJlc3MiIGdyb3VwLCB3aGljaCBtaWdodCBzb3VuZCBh
cyBhIHRlcnJpYmxlIG5hbWUKPiBmb3IgdGhlIGdyb3VwIGJ1dCBpdCBleHBsYWlucyBpdCBxdWl0
ZSB3ZWxsLiBTbyBpZiB5b3UgZG8gbm90IGhhdmUKPiBhbnl0aGluZyBhZ2FpbnN0IHRoYXQgSSds
bCBjYWxsIHRoZSBuZXcgZ3JvdXAgImZzeF9mc3N0cmVzcyIKCkhvdyBhYm91dCAiYmxvY2tfbWFw
IiBncm91cD8gIEkgbGlrZSBEYXZlJ3Mgc3VnZ2VzdGlvbiBhYm91dCBuYW1pbmcKdGhlIGdyb3Vw
IGFmdGVyIHdoYXQgaXQgaXMgdHJ5aW5nIHRvIHRlc3QsIGFzIG9wcG9zZWQgdG8gaG93IGl0IGRv
ZXMKdGhhdCB0ZXN0aW5nLiAgVGhpcyBpcyBhbHNvIGNvbnNpc3RlbnQgd2l0aCBob3cgdGhlIG90
aGVyIHRlc3RzIGdyb3VwcwphcmUgbmFtZWQgaW4geGZzdGVzdHMuCgpIb3dldmVyLCBleHRlbnRz
IGFyZSBhbiBpbXBsZW1lbnRhdGlvbiBzdHJhdGVneSwgYW5kIHlvdSBtaWdodCBqdXN0IGFzCmVh
c2lseSB1c2UgdGhpcyB0ZXN0IHRvIHZlcmlmeSB3aGV0aGVyIG9yIG5vdCB0aGUgcHVuY2ggaG9s
ZQpmdW5jdGlvbmFsaXR5IGZvciBpbmRpcmVjdCBibG9jayBtYXBzIHdvcmtlZCBjb3JyZWN0bHku
CgpXaGF0IEkgdGhpbmsgdXNpbmcgZnN4IGFuZCBmc3RyZXNzIHRvZ2V0aGVyIGhhdmUgaW4gY29t
bW9uIGlzIHRoYXQKaXQncyBhIGdyZWF0IHdheSBvZiBzdHJlc3MgdGVzdGluZyB3aGF0ZXZlciB0
aGUgZmlsZSBzeXN0ZW0gdXNlcyBmb3IKY3JlYXRpbmcgYW5kIG1haW50YWluaW5nIHRoZSB0cmFu
c2xhdGlvbiBtYXAgYmV0d2VlbiAoaW5vZGUsIGxvZ2ljYWwKYmxvY2spIHRvIHBoeXNpY2FsIGJs
b2NrLCBzbyB0aGF0J3Mgd2h5IHBlcmhhcHMgImJsb2NrX21hcCIgbWlnaHQgYmUgYQpnb29kIHRl
c3QgZ3JvdXAgbmFtZS4KClJlZ2FyZHMsCgoJCQkJCQktIFRlZAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
