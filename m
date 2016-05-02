Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 15E197CBE
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 10:51:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB6B230405F
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 08:51:36 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id Ta4DCXiqugQyS6MP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 08:51:34 -0700 (PDT)
Message-ID: <1462204291.11211.20.camel@kernel.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
From: Vishal Verma <vishal@kernel.org>
Date: Mon, 02 May 2016 09:51:31 -0600
In-Reply-To: <5727753F.6090104@plexistor.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<5727753F.6090104@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

T24gTW9uLCAyMDE2LTA1LTAyIGF0IDE4OjQxICswMzAwLCBCb2F6IEhhcnJvc2ggd3JvdGU6Cj4g
T24gMDQvMjkvMjAxNiAxMjoxNiBBTSwgVmlzaGFsIFZlcm1hIHdyb3RlOgo+ID4gCj4gPiBBbGwg
SU8gaW4gYSBkYXggZmlsZXN5c3RlbSB1c2VkIHRvIGdvIHRocm91Z2ggZGF4X2RvX2lvLCB3aGlj
aAo+ID4gY2Fubm90Cj4gPiBoYW5kbGUgbWVkaWEgZXJyb3JzLCBhbmQgdGh1cyBjYW5ub3QgcHJv
dmlkZSBhIHJlY292ZXJ5IHBhdGggdGhhdAo+ID4gY2FuCj4gPiBzZW5kIGEgd3JpdGUgdGhyb3Vn
aCB0aGUgZHJpdmVyIHRvIGNsZWFyIGVycm9ycy4KPiA+IAo+ID4gQWRkIGEgbmV3IGlvY2IgZmxh
ZyBmb3IgREFYLCBhbmQgc2V0IGl0IG9ubHkgZm9yIERBWCBtb3VudHMuIEluIHRoZQo+ID4gSU8K
PiA+IHBhdGggZm9yIERBWCBmaWxlc3lzdGVtcywgdXNlIHRoZSBzYW1lIGRpcmVjdF9JTyBwYXRo
IGZvciBib3RoIERBWAo+ID4gYW5kCj4gPiBkaXJlY3RfaW8gaW9jYnMsIGJ1dCB1c2UgdGhlIGZs
YWdzIHRvIGlkZW50aWZ5IHdoZW4gd2UgYXJlIGluCj4gPiBPX0RJUkVDVAo+ID4gbW9kZSB2cyBu
b24gT19ESVJFQ1Qgd2l0aCBEQVgsIGFuZCBmb3IgT19ESVJFQ1QsIHVzZSB0aGUKPiA+IGNvbnZl
bnRpb25hbAo+ID4gZGlyZWN0X0lPIHBhdGggaW5zdGVhZCBvZiBEQVguCj4gPiAKPiBSZWFsbHk/
IFdoYXQgYXJlIHlvdXIgdGhpbmtpbmcgaGVyZT8KPiAKPiBXaGF0IGFib3V0IGFsbCB0aGUgY3Vy
cmVudCB1c2VycyBvZiBPX0RJUkVDVCwgeW91IGhhdmUganVzdCBtYWRlIHRoZW0KPiA0IHRpbWVz
IHNsb3dlciBhbmQgImxlc3MgY29uY3VycmVudCoiIHRoZW4gImJ1ZmZyZWQgaW8iIHVzZXJzLiBT
aW5jZQo+IGRpcmVjdF9JTyBwYXRoIHdpbGwgcXVldWUgYW4gSU8gcmVxdWVzdCBhbmQgYWxsLgo+
IChBbmQgaWYgaXQgaXMgbm90IHNvIHNsb3cgdGhlbiB3aHkgZG8gd2UgbmVlZCBkYXhfZG9faW8g
YXQgYWxsPwo+IFtSaGV0b3JpY2FsXSkKPiAKPiBJIGhhdGUgaXQgdGhhdCB5b3Ugb3ZlcmxvYWQg
dGhlIHNlbWFudGljcyBvZiBhIGtub3duIGFuZCBleHBlY3RlZAo+IE9fRElSRUNUIGZsYWcsIGZv
ciBzcGVjaWFsIHBtZW0gcXVpcmtzLiBUaGlzIGlzIGFuIGluY29tcGF0aWJsZQo+IGFuZCB1bnJl
bGF0ZWQgb3ZlcmxvYWQgb2YgdGhlIHNlbWFudGljcyBvZiBPX0RJUkVDVC4KCldlIG92ZXJsb2Fk
ZWQgT19ESVJFQ1QgYSBsb25nIHRpbWUgYWdvIHdoZW4gd2UgbWFkZSBEQVggcGlnZ3liYWNrIG9u
CnRoZSBzYW1lIHBhdGg6CgpzdGF0aWMgaW5saW5lIGJvb2wgaW9faXNfZGlyZWN0KHN0cnVjdCBm
aWxlICpmaWxwKQp7CglyZXR1cm4gKGZpbHAtPmZfZmxhZ3MgJiBPX0RJUkVDVCkgfHwgSVNfREFY
KGZpbHAtPmZfbWFwcGluZy0+aG9zdCk7Cn0KClllcyBPX0RJUkVDVCBvbiBhIERBWCBtb3VudGVk
IGZpbGUgc3lzdGVtIHdpbGwgbm93IGJlIHNsb3dlciwgYnV0IC0KCj4gCj4gPiAKPiA+IFRoaXMg
YWxsb3dzIHVzIGEgcmVjb3ZlcnkgcGF0aCBpbiB0aGUgZm9ybSBvZiBvcGVuaW5nIHRoZSBmaWxl
IHdpdGgKPiA+IE9fRElSRUNUIGFuZCB3cml0aW5nIHRvIGl0IHdpdGggdGhlIHVzdWFsIE9fRElS
RUNUIHNlbWFudGljcwo+ID4gKHNlY3Rvcgo+ID4gYWxpZ25tZW50IHJlc3RyaWN0aW9ucykuCj4g
PiAKPiBJIHVuZGVyc3RhbmQgdGhhdCB5b3Ugd2FudCBhIHNlY3RvciBhbGlnbmVkIElPLCByaWdo
dD8gZm9yIHRoZQo+IGNsZWFyIG9mIGVycm9ycy4gQnV0IEkgaGF0ZSBpdCB0aGF0IHlvdSBmb3Jj
ZWQgYWxsIE9fRElSRUNUIElPCj4gdG8gYmUgc2xvdyBmb3IgdGhpcy4KPiBDYW4geW91IG5vdCBt
YWtlIGRheF9kb19pbyBoYW5kbGUgbWVkaWEgZXJyb3JzPyBBdCBsZWFzdCBmb3IgdGhlCj4gcGFy
dHMgb2YgdGhlIElPIHRoYXQgYXJlIGFsaWduZWQuCj4gKEFuZCB5b3VyIHJlY292ZXJ5IHBhdGgg
YXBwbGljYXRpb24gYWJvdmUgY2FuIHVzZSBvbmx5IGFsaWduZWQKPiDCoElPIHRvIG1ha2Ugc3Vy
ZSkKPiAKPiBQbGVhc2UgbG9vayBmb3IgYW5vdGhlciBzb2x1dGlvbi4gRXZlbiBhIHNwZWNpYWwK
PiBJT0NUTF9EQVhfQ0xFQVJfRVJST1IKCsKgLSBzZWUgYWxsIHRoZSB2ZXJzaW9ucyBvZiB0aGlz
IHNlcmllcyBwcmlvciB0byB0aGlzIG9uZSwgd2hlcmUgd2UgdHJ5CnRvIGRvIGEgZmFsbGJhY2su
Li4KCj4gCj4gWyoibGVzcyBjb25jdXJyZW50IiBiZWNhdXNlIG9mIHRoZSBxdWV1aW5nIGRvbmUg
aW4gYmRldi4gTm90ZSBob3cKPiDCoCBwbWVtIGlzIG5vdCBldmVuIG11bHRpLXF1ZXVlLCBhbmQg
ZXZlbiBpZiBpdCB3YXMgaXQgd2lsbCBiZSBtdWNoCj4gwqAgc2xvd2VyIHRoZW4gREFYIGJlY2F1
c2Ugb2YgdGhlIGNvZGUgZGVwdGggYW5kIGFsbCB0aGUgbG9ja3MgYW5kCj4gdGFzawo+IMKgIHN3
aXRjaGVzIGRvbmUgaW4gdGhlIGJsb2NrIGxheWVyLiBJbiBEQVggdGhlIGZpbmFsIG1lbWNweSBp
cyBkb25lCj4gZGlyZWN0bHkKPiDCoCBvbiB0aGUgdXNlci1tb2RlIHRocmVhZF0KPiAKPiBUaGFu
a3MKPiBCb2F6Cj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
