Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6CF77CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:11:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B0AA8F8037
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:11:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OTUXB4wFrCfomNNS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:11:21 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
Date: Fri, 15 Apr 2016 13:11:17 -0400
In-Reply-To: <1460739288.3012.3.camel@intel.com> (Vishal L. Verma's message of
	"Fri, 15 Apr 2016 16:54:48 +0000")
Message-ID: <x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

IlZlcm1hLCBWaXNoYWwgTCIgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JpdGVzOgoKPiBP
biBGcmksIDIwMTYtMDQtMTUgYXQgMTI6MTEgLTA0MDAsIEplZmYgTW95ZXIgd3JvdGU6Cj4+IFZp
c2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPiB3cml0ZXM6Cj4+ID4gKwlpZiAo
SVNfREFYKGlub2RlKSkgewo+PiA+ICsJCXJldCA9IGRheF9kb19pbyhpb2NiLCBpbm9kZSwgaXRl
ciwgb2Zmc2V0LAo+PiA+IGJsa2Rldl9nZXRfYmxvY2ssCj4+ID4gwqAJCQkJTlVMTCwgRElPX1NL
SVBfRElPX0NPVU5UKTsKPj4gPiAtCXJldHVybiBfX2Jsb2NrZGV2X2RpcmVjdF9JTyhpb2NiLCBp
bm9kZSwgSV9CREVWKGlub2RlKSwKPj4gPiBpdGVyLCBvZmZzZXQsCj4+ID4gKwkJaWYgKHJldCA9
PSAtRUlPICYmIChpb3ZfaXRlcl9ydyhpdGVyKSA9PSBXUklURSkpCj4+ID4gKwkJCXJldF9zYXZl
ZCA9IHJldDsKPj4gPiArCQllbHNlCj4+ID4gKwkJCXJldHVybiByZXQ7Cj4+ID4gKwl9Cj4+ID4g
Kwo+PiA+ICsJcmV0ID0gX19ibG9ja2Rldl9kaXJlY3RfSU8oaW9jYiwgaW5vZGUsIElfQkRFVihp
bm9kZSksCj4+ID4gaXRlciwgb2Zmc2V0LAo+PiA+IMKgCQkJCcKgwqDCoMKgYmxrZGV2X2dldF9i
bG9jaywgTlVMTCwgTlVMTCwKPj4gPiDCoAkJCQnCoMKgwqDCoERJT19TS0lQX0RJT19DT1VOVCk7
Cj4+ID4gKwlpZiAocmV0IDwgMCAmJiByZXRfc2F2ZWQpCj4+ID4gKwkJcmV0dXJuIHJldF9zYXZl
ZDsKPj4gPiArCj4+IEhtbSwgZGlkIHlvdSBqdXN0IGJyZWFrIGFzeW5jIERJTz/CoMKgSSB0aGlu
ayB5b3UgZGlkIcKgwqA6KQo+PiBfX2Jsb2NrZGV2X2RpcmVjdF9JTyBjYW4gcmV0dXJuIC1FSU9D
QlFVRVVFRCwgYW5kIHlvdSd2ZSBub3cgdHVybmVkCj4+IHRoYXQKPj4gaW50byAtRUlPLsKgwqBS
ZWFsbHksIEkgZG9uJ3Qgc2VlIGEgcmVhc29uIHRvIHNhdmUgdGhhdCBmaXJzdAo+PiAtRUlPLsKg
wqBUaGUKPj4gc2FtZSBhcHBsaWVzIHRvIGFsbCBpbnN0YW5jZXMgaW4gdGhpcyBwYXRjaC4KPgo+
IFRoZSByZWFzb24gSSBzYXZlZCBpdCB3YXMgaWYgX19ibG9ja2Rldl9kaXJlY3RfSU8gZmFpbHMg
Zm9yIHNvbWUKPiByZWFzb24sIHdlIHNob3VsZCByZXR1cm4gdGhlIG9yaWdpbmFsIGNhdXNlIG8g
dGhlIGVycm9yLCB3aGljaCB3YXMgYW4KPiBFSU8uLiBpLmUuIHdlIHNob3VsZG4ndCBiZSBoaWRp
bmcgdGhlIEVJTyBpZiB0aGUgZGlyZWN0X0lPIGZhaWxzIHdpdGgKPiBzb21ldGhpbmcgZWxzZS4u
CgpPSy4KCj4gQnV0LCBob3cgZG9lcyBfRUlPQ0JRVUVVRUQgd29yaz8gTWF5YmUgd2UgbmVlZCBh
biBleGNlcHRpb24gZm9yIGl0PwoKRm9yIGFzeW5jIGRpcmVjdCBJL08sIG9ubHkgdGhlIHNldHVw
IHBoYXNlIG9mIHRoZSBJL08gaXMgcGVyZm9ybWVkIGFuZAp0aGVuIHdlIHJldHVybiB0byB0aGUg
Y2FsbGVyLiAgLUVJT0NCUVVFVUVEIHNpZ25pZmllcyB0aGlzLgoKWW91J3JlIGhlYWRpbmcgdG93
YXJkcyBjb2RlIHRoYXQgbG9va3MgbGlrZSB0aGlzOgoKICAgICAgICBpZiAoSVNfREFYKGlub2Rl
KSkgewogICAgICAgICAgICAgICAgcmV0ID0gZGF4X2RvX2lvKGlvY2IsIGlub2RlLCBpdGVyLCBv
ZmZzZXQsIGJsa2Rldl9nZXRfYmxvY2ssCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
TlVMTCwgRElPX1NLSVBfRElPX0NPVU5UKTsKICAgICAgICAgICAgICAgIGlmIChyZXQgPT0gLUVJ
TyAmJiAoaW92X2l0ZXJfcncoaXRlcikgPT0gV1JJVEUpKQogICAgICAgICAgICAgICAgICAgICAg
ICByZXRfc2F2ZWQgPSByZXQ7CiAgICAgICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiByZXQ7CiAgICAgICAgfQoKICAgICAgICByZXQgPSBfX2Jsb2NrZGV2X2Rp
cmVjdF9JTyhpb2NiLCBpbm9kZSwgSV9CREVWKGlub2RlKSwgaXRlciwgb2Zmc2V0LAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBibGtkZXZfZ2V0X2Jsb2NrLCBOVUxMLCBOVUxM
LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBESU9fU0tJUF9ESU9fQ09VTlQp
OwogICAgICAgIGlmIChyZXQgPCAwICYmIHJldCAhPSAtRUlPQ0JRVUVVRUQgJiYgcmV0X3NhdmVk
KQogICAgICAgICAgICAgICAgcmV0dXJuIHJldF9zYXZlZDsKClRoZXJlJ3MgYSBsb3Qgb2Ygc3Bl
Y2lhbCBjYXNpbmcgaGVyZSwgc28geW91IG1pZ2h0IGNvbnNpZGVyIGFkZGluZwpjb21tZW50cy4K
CkNoZWVycywKSmVmZgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29t
L21haWxtYW4vbGlzdGluZm8veGZzCg==
