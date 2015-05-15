Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E721A7F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 02:21:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D74FA304039
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 00:21:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UtzEAzE29L1JCyeX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 00:21:07 -0700 (PDT)
Date: Fri, 15 May 2015 15:21:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests/common/renameat2: pass the renameat2 flags from
	_rename_tests to _rename_tests_source_dest
Message-ID: <20150515072100.GI1140@dhcp-13-216.nay.redhat.com>
References: <1430467867-5565-1-git-send-email-shhuiw@foxmail.com>
	<55554311.2070904@foxmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55554311.2070904@foxmail.com>
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
To: Wang Sheng-Hui <shhuiw@foxmail.com>
Cc: xfs@oss.sgi.com

T24gRnJpLCBNYXkgMTUsIDIwMTUgYXQgMDg6NTE6MjlBTSArMDgwMCwgV2FuZyBTaGVuZy1IdWkg
d3JvdGU6Cj4gCj4gCj4gT24gMjAxNeW5tDA15pyIMDHml6UgMTY6MTEsIFdhbmcgU2hlbmctSHVp
IHdyb3RlOgo+ID4gX3JlbmFtZV90ZXN0cygpIHJlY29yZHMgdGhlICdmbGFncycgYXJnIGJ1dCBk
b2Vzbid0IHBhc3MgaXQgdG8KPiA+IF9yZW5hbWVfdGVzdHNfc291cmNlX2Rlc3QoKSBpbiBvbGQg
Y29kZSwgdGh1cyBhbnkgJ2ZsYWdzJyB0bwo+ID4gcmVuYW1lYXQyIGlzIG1pc3NlZC4gRml4IHRo
ZSBtaXNzaW5nLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBXYW5nIFNoZW5nLUh1aSA8c2hodWl3
QGZveG1haWwuY29tPgo+ID4gLS0tCj4gPiAgY29tbW9uL3JlbmFtZWF0MiB8IDUgKysrLS0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ID4gCj4g
PiBkaWZmIC0tZ2l0IGEvY29tbW9uL3JlbmFtZWF0MiBiL2NvbW1vbi9yZW5hbWVhdDIKPiA+IGlu
ZGV4IGEzMzUxNjkuLmRmMmRmMmUgMTAwNjQ0Cj4gPiAtLS0gYS9jb21tb24vcmVuYW1lYXQyCj4g
PiArKysgYi9jb21tb24vcmVuYW1lYXQyCj4gPiBAQCAtNzgsNiArNzgsNyBAQCBfcmVuYW1lX3Rl
c3RzX3NvdXJjZV9kZXN0KCkKPiA+ICAJbG9jYWwgc291cmNlPSQxCj4gPiAgCWxvY2FsIGRlc3Q9
JDIKPiA+ICAJbG9jYWwgb3B0aW9ucz0kMwo+ID4gKwlsb2NhbCBmbGFncz0kNAo+ID4gIAo+ID4g
IAlmb3Igc3R5cGUgaW4gbm9uZSByZWd1IHN5bWIgZGlyZSB0cmVlOyBkbwo+ID4gIAkJZm9yIGR0
eXBlIGluIG5vbmUgcmVndSBzeW1iIGRpcmUgdHJlZTsgZG8KPiA+IEBAIC0xMDcsMTEgKzEwOCwx
MSBAQCBfcmVuYW1lX3Rlc3RzKCkKPiA+ICAJbG9jYWwgZmxhZ3M9JDIKPiA+ICAKPiA+ICAJI3Nh
bWUgZGlyZWN0b3J5IHJlbmFtZXMKPiA+IC0JX3JlbmFtZV90ZXN0c19zb3VyY2VfZGVzdCAkdGVz
dGRpci9zcmMgJHRlc3RkaXIvZHN0ICAgICAic2FtZWRpciAiCj4gPiArCV9yZW5hbWVfdGVzdHNf
c291cmNlX2Rlc3QgJHRlc3RkaXIvc3JjICR0ZXN0ZGlyL2RzdCAgICAgInNhbWVkaXIgIiAkZmxh
Z3MKPiA+ICAKPiA+ICAJI2Nyb3NzIGRpcmVjdG9yeSByZW5hbWVzCj4gPiAgCW1rZGlyICR0ZXN0
ZGlyL3ggJHRlc3RkaXIveQo+ID4gLQlfcmVuYW1lX3Rlc3RzX3NvdXJjZV9kZXN0ICR0ZXN0ZGly
L3gvc3JjICR0ZXN0ZGlyL3kvZHN0ICJjcm9zc2RpciIKPiA+ICsJX3JlbmFtZV90ZXN0c19zb3Vy
Y2VfZGVzdCAkdGVzdGRpci94L3NyYyAkdGVzdGRpci95L2RzdCAiY3Jvc3NkaXIiICRmbGFncwo+
ID4gIAlybWRpciAkdGVzdGRpci94ICR0ZXN0ZGlyL3kKPiA+ICB9Cj4gPiAgCj4gPiAKPiAKPiBB
bnkgY29tbWVudHM/CgpZb3UgY2FuIHNlbmQgeGZzdGVzdHMgcGF0Y2ggdG8gZnN0ZXN0c0B2Z2Vy
Lmtlcm5lbC5vcmcgbmV4dCB0aW1lLgoKVGhhbmtzLApFcnl1CgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dp
LmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
