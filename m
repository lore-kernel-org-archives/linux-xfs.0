Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D03A7D01
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:17:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9061AC001
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:03 -0700 (PDT)
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	by cuda.sgi.com with ESMTP id NZhtVQZpMFm1uyLl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:02 -0700 (PDT)
Message-ID: <1460747308.4597.9.camel@hpe.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Toshi Kani <toshi.kani@hpe.com>
Date: Fri, 15 Apr 2016 13:08:28 -0600
In-Reply-To: <1460746909.4597.7.camel@hpe.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
	<CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	<x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
	<1460746909.4597.7.camel@hpe.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@fb.com" <axboe@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

T24gRnJpLCAyMDE2LTA0LTE1IGF0IDEzOjAxIC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOgo+IE9u
IEZyaSwgMjAxNi0wNC0xNSBhdCAxMToxNyAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+ID4g
Cj4gPiBPbiBGcmksIEFwciAxNSwgMjAxNiBhdCAxMTowNiBBTSwgSmVmZiBNb3llciA8am1veWVy
QHJlZGhhdC5jb20+IHdyb3RlOgo+ID4gPiAKPiA+ID4gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+IHdyaXRlczoKPiA+ID4gwqAKPiA+ID4gPiA+ID4gVGhlcmUncyBhIGxv
dCBvZiBzcGVjaWFsIGNhc2luZyBoZXJlLCBzbyB5b3UgbWlnaHQgY29uc2lkZXIKPiA+ID4gPiA+
ID4gYWRkaW5nIGNvbW1lbnRzLgo+ID4gPiA+ID4gQ29ycmVjdCAtIG1heWJlIHdlIHNob3VsZCBy
ZWNvbnNpZGVyIHdyYXBwZXItaXppbmcgdGhpcz8gOikKPiA+ID4gPiBBbm90aGVyIG9wdGlvbiBp
cyBqdXN0IHRvIHNraXAgZGF4X2RvX2lvKCkgYW5kIHRoaXMgc3BlY2lhbCBjYXNpbmcKPiA+ID4g
PiBmYWxsYmFjayBlbnRpcmVseSBpZiBlcnJvcnMgYXJlIHByZXNlbnQuwqDCoEkuZS4gb25seSBh
dHRlbXB0Cj4gPiA+ID4gZGF4X2RvX2lvIHdoZW46IElTX0RBWCgpICYmIGdlbmRpc2stPmJiICYm
IGJiLT5jb3VudCA9PSAwLgo+ID4gPgo+ID4gPiBTbywgaWYgdGhlcmUncyBhbiBlcnJvciBhbnl3
aGVyZSBvbiB0aGUgZGV2aWNlLCBwZW5hbGl6ZSBhbGwgSS9PIChub3QKPiA+ID4ganVzdCB3cml0
ZXMsIGFuZCBub3QganVzdCBvbiBzZWN0b3JzIHRoYXQgYXJlIGJhZCk/wqDCoEknbSBub3Qgc3Vy
ZQo+ID4gPiB0aGF0J3MgYSBncmVhdCBwbGFuLCBlaXRoZXIuCj4gPiA+IAo+ID4gSWYgZXJyb3Jz
IGFyZSByYXJlIGhvdyBtdWNoIGFyZSB3ZSBhY3R1YWxseSBsb3NpbmcgaW4gcHJhY3RpY2U/Cj4g
PiBNb3Jlb3Zlciwgd2UncmUgZ29pbmcgdG8gZG8gdGhlIGZ1bGwgYmFkYmxvY2tzIGxvb2t1cCBh
bnl3YXkgd2hlbiB3ZQo+ID4gY2FsbCAtPmRpcmVjdF9hY2Nlc3MoKS7CoMKgSWYgd2UgaGFkIHRo
YXQgaW5mb3JtYXRpb24gZWFybGllciB3ZSBjYW4KPiA+IGF2b2lkIHRoaXMgZmFsbGJhY2sgZGFu
Y2UuCj4KPiBBIHN5c3RlbSBydW5uaW5nIHdpdGggREFYIG1heSBoYXZlIGFjdGl2ZSBkYXRhIHNl
dCBpbiBOVkRJTU0gbGFnZXIgdGhhbgo+IFJBTSBzaXplLiDCoEluIHRoaXMgY2FzZSwgZmFsbGlu
ZyBiYWNrIHRvIG5vbi1EQVggd2lsbCBhbGxvY2F0ZSBwYWdlIGNhY2hlCj4gZm9yIHRoZSBkYXRh
LCB3aGljaCB3aWxsIHNhdHVyYXRlIHRoZSBzeXN0ZW0gd2l0aCBtZW1vcnkgcHJlc3N1cmUuCgpP
aCwgc29ycnksIHdlIGFyZSBzdGlsbCBpbiBESU8gcGF0aC4gwqBGYWxsaW5nIGJhY2sgdG8gRElP
IHNob3VsZCBub3QgY2F1c2UKdGhpcyBpc3N1ZS4KCi1Ub3NoaQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
