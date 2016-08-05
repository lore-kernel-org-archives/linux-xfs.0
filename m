Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD1277CA1
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 06:57:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55AD6AC003
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 04:57:21 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id JERgP0HF7lJnL910 for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 04:57:20 -0700 (PDT)
Message-ID: <1470398236.2311.89.camel@gmail.com>
Subject: Re: [PATCH v7 00/47] xfs: add reverse mapping support
From: Artem Bityutskiy <dedekind1@gmail.com>
Date: Fri, 05 Aug 2016 14:57:16 +0300
In-Reply-To: <20160805104950.GF16044@dastard>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
	<20160803194536.GJ5316@wotan.suse.de>
	<20160803205520.GQ8590@birch.djwong.org>
	<20160804005843.GJ8593@birch.djwong.org>
	<20160804021852.GK5316@wotan.suse.de>
	<20160804154845.GV8590@birch.djwong.org>
	<20160804235015.GC16044@dastard>
	<1470380474.2311.71.camel@gmail.com> <20160805104950.GF16044@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@suse.de>, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

T24gRnJpLCAyMDE2LTA4LTA1IGF0IDIwOjQ5ICsxMDAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
T24gRnJpLCBBdWcgMDUsIDIwMTYgYXQgMTA6MDE6MTRBTSArMDMwMCwgQXJ0ZW0gQml0eXV0c2tp
eSB3cm90ZToKPiA+IAo+ID4gT24gRnJpLCAyMDE2LTA4LTA1IGF0IDA5OjUwICsxMDAwLCBEYXZl
IENoaW5uZXIgd3JvdGU6Cj4gPiA+IAo+ID4gPiBJJ2QgbXVjaCBwcmVmZXIgdGhhdCBmaWVtYXAg
Z2l2ZXMgZXhhY3QgaW5mb3JtYXRpb24gYWJvdXQgc2hhcmVkCj4gPiA+IGV4dGVudHMuIEZJRU1B
UCBpcyBhIGRpYWdub3N0aWMgdG9vbCBhbmQgYXMgc3VjaCB3ZSBuZWVkIGl0IHRvCj4gPiA+IGFj
Y3VyYXRlbHkgcmVmbGVjdCB0aGUgZXhhY3QgZXh0ZW50IG1hcCBvZiB0aGUgaW5vZGUgYmVpbmcK
PiA+ID4gcXVlcmllZAo+ID4gPiBzbyB3ZSBhcmVuJ3QgbWlzbGVhZCBhYm91dCB0aGUgbGF5b3V0
IG9mIHRoZSBmaWxlIGR1cmluZyB0cm91YmxlCj4gPiA+IHNob290aW5nLgo+ID4gCj4gPiBIaSBE
YXZlLCB5b3UgYXJlIHJpZ2h0LCBhbmQgaGVyZSBpcyBhIHNpZGUgbm90ZTogwqB3ZSB3ZXJlIHVz
aW5nCj4gPiBGSUVNQVAKPiA+IGZvciBvcHRpbWl6aW5nIGltYWdlIGRlcGxveW1lbnQgaW4gcHJv
ZHVjdGlvbiwgc28gaXQgaXMgYQo+ID4gZGlhZ25vc3RpYwo+ID4gdG9vbCBhbmQgbW9yZS4KPiAK
PiBZYXksIGRhdGEgY29ycnVwdGlvbiBhaG95IQo+IAo+IEhhc24ndCAvYW55b25lLyBsaXN0ZW5l
ZCB0byB0aGUgcmVwZWF0ZWQgc3RhdGVtZW50cyBmcm9tIGZzCj4gZGV2ZWxvcGVycyB0aGF0IEZJ
RU1BUCBpcyBub3QgYSBzYWZlIG1ldGhvZCBvZiBvcHRpbWlzaW5nIGRhdGEKPiBjb3B5aW5nPwoK
WWVzLCB3aGljaCBpcyBraW5kIG9mIHNhZCBmcm9tIHRoZSB1c2VyJ3MgcGVyc3BlY3RpdmUuIFdl
IGhhZCBpc3N1ZXMKd2l0aCBYRlMsIG5vdCBleHQ0LCBhbmQgdHdlYWtpbmcgcHJlYWxsb2NhdGlv
biBoZWxwZWQuCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
