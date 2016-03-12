Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3CD97CA1
	for <xfs@oss.sgi.com>; Sat, 12 Mar 2016 15:13:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4AA81AC002
	for <xfs@oss.sgi.com>; Sat, 12 Mar 2016 13:13:19 -0800 (PST)
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148]) by cuda.sgi.com
	with ESMTP id UXXlwzNH2x8f1kH0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 12 Mar 2016 13:13:16 -0800 (PST)
Message-ID: <1457817147.3540.28.camel@samba.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
From: Simo <simo@samba.org>
Date: Sat, 12 Mar 2016 16:12:27 -0500
In-Reply-To: <20160311140757.GB13178@fieldses.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<20160311140757.GB13178@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

T24gRnJpLCAyMDE2LTAzLTExIGF0IDA5OjA3IC0wNTAwLCBKLiBCcnVjZSBGaWVsZHMgd3JvdGU6
Cj4gT24gRnJpLCBNYXIgMTEsIDIwMTYgYXQgMDY6MDE6MzRBTSAtMDgwMCwgQ2hyaXN0b3BoIEhl
bGx3aWcgd3JvdGU6Cj4gPiAKPiA+IE9uIE1vbiwgRmViIDI5LCAyMDE2IGF0IDA5OjE3OjA1QU0g
KzAxMDAsIEFuZHJlYXMgR3J1ZW5iYWNoZXIKPiA+IHdyb3RlOgo+ID4gPiAKPiA+ID4gQWwsCj4g
PiA+IAo+ID4gPiBjb3VsZCB5b3UgcGxlYXNlIG1ha2Ugc3VyZSB5b3UgYXJlIGhhcHB5IHdpdGgg
dGhlIGN1cnJlbnQgdmVyc2lvbgo+ID4gPiBvZiB0aGUKPiA+ID4gcmljaGFjbCBwYXRjaCBxdWV1
ZSBmb3IgdGhlIG5leHQgbWVyZ2Ugd2luZG93Pwo+ID4gSSdtIHN0aWxsIG5vdCBoYXBweS4KPiA+
IAo+ID4gRm9yIG9uZSBJIHN0aWxsIHNlZSBubyByZWFzb24gdG8gbWVyZ2UgdGhpcyBicm9rZW4g
QUNMIG1vZGVsIGF0Cj4gPiBhbGwuCj4gPiBJdCBwcm92aWRlcyBvdXIgYWN0dWFseSBMaW51eCB1
c2VycyBubyBiZW5lZml0IGF0IGFsbCwgd2hpbGUKPiA+IGJyZWFraW5nCj4gPiBhIGxvdCBvZiBh
c3N1bXB0aW9ucywgZXNwZWNpYWxseSBieSBhZGRpbmcgYWxsb3cgYW5kIGRlbnkgQUNFIGF0Cj4g
PiB0aGUKPiA+IHNhbWUgc2ltZS4KPiBDb3VsZCB5b3UgZXhwbGFpbiB3aGF0IHlvdSBtZWFuIGJ5
ICJhZGRpbmcgYWxsb3cgYW5kIGRlbnkgQUNFIGF0IHRoZQo+IHNhbWUgdGltZSI/Cj4gCj4gPiAK
PiA+IEl0IGFsc28gZG9lc24ndCBoZWxwIHdpdGggdGhlIGlzc3VlIHRoYXQgdGhlIG1haW4gdGhp
bmcgaXQncyB0cnlpbmcKPiA+IHRvIGJlIGNvbXBhdGlibGUgd2l0aCAoV2luZG93cykgYWN0dWFs
bHkgdXNlcyBhIGZ1bmRhbWVudGFsbHkKPiA+IGRpZmZlcmVudAo+ID4gaWRlbnRpZmllciB0byBh
cHBseSB0aGUgQUNMcyB0byAtIGFzIGxvbmcgYXMgeW91J3JlIHN0aWxsIGxpbWl0ZWQKPiA+IHRv
IHVzZXJzIGFuZCBncm91cHMgYW5kIG5vdCBndWlkcyB3ZSdsbCBzdGlsbCBoYXZlIHRoYXQgbWFw
cGluZwo+ID4gcHJvYmxlbQo+ID4gYW55d2F5Lgo+IEFncmVlZCwgYnV0LCBvbmUgc3RlcCBhdCBh
IHRpbWU/wqDCoE15IGltcHJlc3Npb24gaXMgdGhhdCB0aGUgU2FtYmEKPiBwZW9wbGUKPiBzdGls
bCBjb25zaWRlciB0aGlzIGEgc3RlcCBmb3J3YXJkIGZvciBMaW51eCBjb21wYXRpYmlsaXR5LgoK
SXQgaXMgYSBzdGVwIGZvcndhcmQsIGJ1dCBiZWluZyBhYmxlIHRvIHN0b3JlIFNJRHMgaW4gdGhl
IEFDTCwgd291bGQgYmUKYSBtdWNoIGJldHRlciBvbmUuCgpTaW1vLgoKPiAtLWIuCj4gCj4gPiAK
PiA+IAo+ID4gQnV0IGJlc2lkZXMgdGhhdCBmdW5kYW1lbnRhbCBxdWVzdGlvbiBvbiB0aGUgcHVy
cG9zZSBvZiBpdCBJIGFsc28KPiA+IGRvbid0IHRoaW5rIHRoZSBjb2RlIGlzIHN1aXRhYmxlLCBt
b3JlIGluIHRoZSBpbmRpdmlkdWFsIHBhdGNoZXMuCj4gLS0KPiBUbyB1bnN1YnNjcmliZSBmcm9t
IHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3JpYmUgbGludXgtY2lmcyIgCj4gaW4K
PiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIua2VybmVsLm9yZwo+IE1v
cmUgbWFqb3Jkb21vIGluZm8gYXTCoMKgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8t
aW5mby5odG1sCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFp
bG1hbi9saXN0aW5mby94ZnMK
