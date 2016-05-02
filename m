Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69D817CCD
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 10:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B1DA304062
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 08:45:42 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id N1F6epShqG92CaYv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 08:45:40 -0700 (PDT)
Message-ID: <1462203935.11211.15.camel@kernel.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
From: Vishal Verma <vishal@kernel.org>
Date: Mon, 02 May 2016 09:45:35 -0600
In-Reply-To: <20160502145606.GD20589@infradead.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	<20160502145606.GD20589@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

T24gTW9uLCAyMDE2LTA1LTAyIGF0IDA3OjU2IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiA+IAo+ID4gaW5kZXggNzlkZWZiYS4uOTdhMWY1ZiAxMDA2NDQKPiA+IC0tLSBhL2ZzL2Js
b2NrX2Rldi5jCj4gPiArKysgYi9mcy9ibG9ja19kZXYuYwo+ID4gQEAgLTE2NywxMiArMTY3LDIx
IEBAIGJsa2Rldl9kaXJlY3RfSU8oc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QKPiA+IGlvdl9p
dGVyICppdGVyLCBsb2ZmX3Qgb2Zmc2V0KQo+ID4gwqAJc3RydWN0IGZpbGUgKmZpbGUgPSBpb2Ni
LT5raV9maWxwOwo+ID4gwqAJc3RydWN0IGlub2RlICppbm9kZSA9IGJkZXZfZmlsZV9pbm9kZShm
aWxlKTsKPiA+IMKgCj4gPiAtCWlmIChJU19EQVgoaW5vZGUpKQo+ID4gKwlpZiAoaW9jYl9pc19k
aXJlY3QoaW9jYikpCj4gPiArCQlyZXR1cm4gX19ibG9ja2Rldl9kaXJlY3RfSU8oaW9jYiwgaW5v
ZGUsCj4gPiBJX0JERVYoaW5vZGUpLCBpdGVyLAo+ID4gKwkJCQkJwqDCoMKgwqBvZmZzZXQsCj4g
PiBibGtkZXZfZ2V0X2Jsb2NrLCBOVUxMLAo+ID4gKwkJCQkJwqDCoMKgwqBOVUxMLAo+ID4gRElP
X1NLSVBfRElPX0NPVU5UKTsKPiA+ICsJZWxzZSBpZiAoaW9jYl9pc19kYXgoaW9jYikpCj4gPiDC
oAkJcmV0dXJuIGRheF9kb19pbyhpb2NiLCBpbm9kZSwgaXRlciwgb2Zmc2V0LAo+ID4gYmxrZGV2
X2dldF9ibG9jaywKPiA+IMKgCQkJCU5VTEwsIERJT19TS0lQX0RJT19DT1VOVCk7Cj4gPiAtCXJl
dHVybiBfX2Jsb2NrZGV2X2RpcmVjdF9JTyhpb2NiLCBpbm9kZSwgSV9CREVWKGlub2RlKSwKPiA+
IGl0ZXIsIG9mZnNldCwKPiA+IC0JCQkJwqDCoMKgwqBibGtkZXZfZ2V0X2Jsb2NrLCBOVUxMLCBO
VUxMLAo+ID4gLQkJCQnCoMKgwqDCoERJT19TS0lQX0RJT19DT1VOVCk7Cj4gPiArCWVsc2Ugewo+
ID4gKwkJLyoKPiA+ICsJCcKgKiBJZiB3ZSdyZSBpbiB0aGUgZGlyZWN0X0lPIHBhdGgsIGVpdGhl
ciB0aGUKPiA+IElPQ0JfRElSRUNUIG9yCj4gPiArCQnCoCogSU9DQl9EQVggZmxhZ3MgbXVzdCBi
ZSBzZXQuCj4gPiArCQnCoCovCj4gPiArCQlXQVJOX09OQ0UoMSwgIktlcm5lbCBCdWcgd2l0aCBp
b2NiIGZsYWdzXG4iKTsKPiA+ICsJCXJldHVybiAtRU5YSU87Cj4gPiArCX0KPiBEQVggc2hvdWxk
IG5vdCBldmVuIGVuZCB1cCBpbiAtPmRpcmVjdF9JTy4KCkRvIHlvdSBtZWFuIHRvIHNheSByZW1v
dmUgdGhlIGxhc3QgJ2Vsc2UnIGNsYXVzZSBlbnRpcmVseT8KSSBhZ3JlZSB0aGF0IGl0IHNob3Vs
ZCBuZXZlciBiZSBoaXQsIHdoaWNoIGlzIHdoeSBpdCBpcyBhIFdBUk4uLgpCdXQgSSdtIGhhcHB5
IHRvIHJlbW92ZSBpdC4KCj4gCj4gPiAKPiA+IC0tLSBhL2ZzL3hmcy94ZnNfZmlsZS5jCj4gPiAr
KysgYi9mcy94ZnMveGZzX2ZpbGUuYwo+ID4gQEAgLTMwMCw3ICszMDAsNyBAQCB4ZnNfZmlsZV9y
ZWFkX2l0ZXIoCj4gPiDCoAo+ID4gwqAJWEZTX1NUQVRTX0lOQyhtcCwgeHNfcmVhZF9jYWxscyk7
Cj4gPiDCoAo+ID4gLQlpZiAodW5saWtlbHkoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX0RJUkVDVCkp
Cj4gPiArCWlmICh1bmxpa2VseShpb2NiLT5raV9mbGFncyAmIChJT0NCX0RJUkVDVCB8IElPQ0Jf
REFYKSkpCj4gPiDCoAkJaW9mbGFncyB8PSBYRlNfSU9fSVNESVJFQ1Q7Cj4gcGxlYXNlIGFsc28g
YWRkIGEgWEZTX0lPX0lTREFYIGZsYWcgdG8gcHJvcGFnYXRlIHRoZSBpbmZvcm1hdGlvbgo+IHBy
b3Blcmx5IGFuZCBhbGxvdyB0cmFjaW5nIHRvIGRpc3BsYXkgdGhlIGFjdHVhbCBJL08gdHlwZS4K
CldpbGwgZG8uCgo+IAo+ID4gCj4gPiArc3RhdGljIGlubGluZSBib29sIGlvY2JfaXNfZGF4KHN0
cnVjdCBraW9jYiAqaW9jYikKPiA+IMKgewo+ID4gKwlyZXR1cm4gSVNfREFYKGZpbGVfaW5vZGUo
aW9jYi0+a2lfZmlscCkpICYmCj4gPiArCQkoaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX0RBWCk7Cj4g
PiArfQo+ID4gKwo+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpb2NiX2lzX2RpcmVjdChzdHJ1Y3Qg
a2lvY2IgKmlvY2IpCj4gPiArewo+ID4gKwlyZXR1cm4gaW9jYi0+a2lfZmxhZ3MgJiBJT0NCX0RJ
UkVDVDsKPiA+IMKgfQo+IE5vIG5lZWQgZm9yIHRoZXNlIGhlbHBlcnMgLSBlc3BlY2lhbGx5IGFz
IElPQ0JfREFYIHNob3VsZCBuZXZlciBiZQo+IHNldAo+IGlmIElTX0RBWCBpcyBmYWxzZS4KCk9r
LiBTbyBjaGVjayB0aGUgZmxhZ3MgZGlyZWN0bHkgd2hlcmUgbmVlZGVkPwoKPiAtLQo+IFRvIHVu
c3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5kIHRoZSBsaW5lICJ1bnN1YnNjcmliZSBsaW51
eC0KPiBibG9jayIgaW4KPiB0aGUgYm9keSBvZiBhIG1lc3NhZ2UgdG8gbWFqb3Jkb21vQHZnZXIu
a2VybmVsLm9yZwo+IE1vcmUgbWFqb3Jkb21vIGluZm8gYXTCoMKgaHR0cDovL3ZnZXIua2VybmVs
Lm9yZy9tYWpvcmRvbW8taW5mby5odG1sCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
