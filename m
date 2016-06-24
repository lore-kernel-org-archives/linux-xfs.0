Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85DE67CA2
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 18:03:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5C81AC002
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 16:03:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y4LkFc9fnZSWC0u5 for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 16:03:47 -0700 (PDT)
Date: Sat, 25 Jun 2016 09:03:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug (?) : cumulative xfsrestore does not restore files and
	folders in a directory which was renamed
Message-ID: <20160624230346.GH12670@dastard>
References: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
	<20160622220959.GV12670@dastard> <20160622222328.GW12670@dastard>
	<20160623014217.GZ12670@dastard>
	<eacabe85-cdff-7fbc-8bb6-c8eb51fc0dac@recia.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eacabe85-cdff-7fbc-8bb6-c8eb51fc0dac@recia.fr>
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
To: Damien Gombault <damien.gombault@recia.fr>
Cc: xfs@oss.sgi.com

T24gRnJpLCBKdW4gMjQsIDIwMTYgYXQgMDM6NTE6NTdQTSArMDIwMCwgRGFtaWVuIEdvbWJhdWx0
IHdyb3RlOgo+IEhpLgo+IAo+IFRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoLgo+IAo+IFRoZSBwYXRj
aCBmaXhlcyBzaW1wbGUgY2FzZXMgKGxpa2UgbXkgcmVwcm9kdWNlcikgYnV0IGl0IGRvZXMgbm90
IGZpeAo+IHJlc3RvcmF0aW9uIG9mIG1vcmUgY29tcGxleCBkaXJlY3Rvcnkgc3RydWN0dXJlcyA6
IEkgaGF2ZSB0ZXN0ZWQgdGhlCj4gcGF0Y2ggb24gbXkKPiByZWFsIGRhdGEsIGl0IGZpeGVzIHNv
bWUgYnV0IG5vdCBhbGwgd2FybmluZ3MgKGEgdXNlciByZW5hbWVkL21vdmVkCj4gYSBsb3RzIG9m
Cj4gZmlsZXMgYW5kIGRpcmVjdG9yeSBiZXR3ZWVuIHRoZSAyIGR1bXBzKS4KPiAKPiBIZXJlIGlz
IGFub3RoZXIgdGVzdGNhc2Ugd2hpY2ggZmFpbHMgKHdpdGggdGhlIHBhdGNoKSA6Cj4gCj4gbWtk
aXIgZGlyYQo+IG1rZGlyIGRpcmEvZGlyYwo+IHRvdWNoIGRpcmEvZGlyYy9maWxlYQo+IG1rZGly
IGRpcmIKPiAKPiAuCj4g4pSc4pSA4pSAIGRpcmEKPiDilIIgICDilJTilIDilIAgZGlyYwo+IOKU
giAgICAgICDilJTilIDilIAgZmlsZWEKPiDilJTilIDilIAgZGlyYgo+IAo+IE1ha2UgYSBsZXZl
bCAwIGR1bXAuCj4gCj4gbXYgZGlyYiBkaXJhL2RpckIKPiBtdiBkaXJhL2RpcmMvIGRpcmEvZGly
Qi9kaXJDCj4gdG91Y2ggZGlyYS9kaXJCL2RpckMvZmlsZWIKPiAKPiAuCj4g4pSU4pSA4pSAIGRp
cmEKPiAgICAg4pSU4pSA4pSAIGRpckIKPiAgICAgICAgIOKUlOKUgOKUgCBkaXJDCj4gICAgICAg
ICAgICAg4pSc4pSA4pSAIGZpbGVhCj4gICAgICAgICAgICAg4pSU4pSA4pSAIGZpbGViCgpXZWxs
LCB5ZXMuIEkgc3BlY2lmaWNhbGx5IHNhaWQgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9uIHRoYXQg
aXQKZG9lc24ndCBmaXggdGhvc2UgbmVzdGVkIGRlcGVuZGVuY3kgY2FzZXMgYW5kIHRoYXQgbXVj
aCBkZWVwZXIKc3VyZ2VyeSBpcyBuZWVkZWQgdG8gaGFuZGxlIHRob3NlIGNhc2VzLgoKQ2hlZXJz
LAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
