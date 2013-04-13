Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1E757F37
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 05:18:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC86C8F808E
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 03:18:56 -0700 (PDT)
Received: from mail-ia0-f181.google.com (mail-ia0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	FjXtgeXEdENsuV64 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 13 Apr 2013 03:18:52 -0700 (PDT)
Received: by mail-ia0-f181.google.com with SMTP id y25so2103314iay.26
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 03:18:52 -0700 (PDT)
Message-ID: <51693104.2020707@gmail.com>
Date: Sat, 13 Apr 2013 18:18:44 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
References: <51678D0D.1070002@gmail.com> <20130412074034.GC30622@dastard>
	<5168396C.6020801@gmail.com> <20130413003222.GG30622@dastard>
In-Reply-To: <20130413003222.GG30622@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

T24gMjAxM+W5tDA05pyIMTPml6UgMDg6MzIsIERhdmUgQ2hpbm5lciB3cm90ZToKPiBPbiBTYXQs
IEFwciAxMywgMjAxMyBhdCAxMjo0MjoyMEFNICswODAwLCBXYW5nIFNoZW5nLUh1aSB3cm90ZToK
Pj4gT24gMjAxM+W5tDA05pyIMTLml6UgMTU6NDAsIERhdmUgQ2hpbm5lciB3cm90ZToKPj4+IE9u
IEZyaSwgQXByIDEyLCAyMDEzIGF0IDEyOjI2OjUzUE0gKzA4MDAsIFdhbmcgU2hlbmctSHVpIHdy
b3RlOgo+Pj4+ICsjCj4+Pj4gKwo+Pj4+ICtUT1BESVIgPSAuLgo+Pj4+ICtpbmNsdWRlICQoVE9Q
RElSKS9pbmNsdWRlL2J1aWxkZGVmcwo+Pj4+ICsKPj4+PiArVEVTVFNfU1VCRElSUyA9ICQoc2hl
bGwgZmluZCAuIC1tYXhkZXB0aCAxIC10eXBlIGQgfCBzZWQgLW4gLWUgJ3MvXC5cLy8vZ3AnKQo+
Pj4KPj4+IFRoaXMgaXMgbXVjaCBuZWF0ZXI6Cj4+Pgo+Pj4gVEVTVFNfU1VCRElSUyA9ICQoc29y
dCAkKGRpciAkKHdpbGRjYXJkICAkKFBXRCkvKi8pKSkKPj4KPj4gSGkgRGF2ZSwKPj4KPj4gSSBp
bnRyb2R1Y2VzIE1ha2VmaWxlIHVuZGVyIHRlc3RzLywgd2hpY2ggd291bGQgcmV0dXJuIHRvIFRF
U1RTX1NVQkRJUlMgd2l0aCB0aGUKPj4gJChkaXIgZnVuY3Rpb24uIEJ5IHJ1bm5pbmcgZmluZCBp
biAkKHNoZWxsLCBURVNUX1NVQkRJUlMgd2lsbCBvbmx5IGdldCB0aGUgZGlyIG5hbWVzLAo+PiBh
bmQgbm8gTWFrZWZpbGUuCj4KPiBJIHRoaW5rIHlvdSBtaXN1bmRlcnN0YW5kLiBUaGUgd2lsZGNh
cmQgYWJvdmUgb25seSByZXR1cm5zCj4gZGlyZWN0b3JpZXM6Cj4KPiAkIHB3ZAo+ICAgMCAgfi9z
cmMveGZzdGVzdHMtZGV2L3Rlc3RzCj4gJCBjYXQgfi90bXAvTWFrZWZpbGUKPiBmb289JChzb3J0
ICQoZGlyICQod2lsZGNhcmQgICQoUFdEKS8qLykpKQo+Cj4gZGVmYXVsdDoKPiAgICAgICAgICBA
ZWNobyAkKGZvbykKPiAkIG1ha2UgLWYgfi90bXAvTWFrZWZpbGUKPiAvaG9tZS9kYXZlL3NyYy94
ZnN0ZXN0cy1kZXYvdGVzdHMvYnRyZnMvIC9ob21lL2RhdmUvc3JjL3hmc3Rlc3RzLWRldi90ZXN0
cy9leHQ0LyAvaG9tZS9kYXZlL3NyYy94ZnN0ZXN0cy1kZXYvdGVzdHMvZ2VuZXJpYy8gL2hvbWUv
ZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3NoYXJlZC8gL2hvbWUvZGF2ZS9zcmMveGZzdGVz
dHMtZGV2L3Rlc3RzL3VkZi8gL2hvbWUvZGF2ZS9zcmMveGZzdGVzdHMtZGV2L3Rlc3RzL3hmcy8K
PiAkCj4KCkRhdmUsCgpUaGUgb3V0cHV0IG9uIG15IGJveCBpcyBkaWZmZXJlbnQgd2l0aCB5b3Vy
cy4KCiMgcHdkCi9yb290L3dvcmtzcGFjZS94ZnN0ZXN0cy90ZXN0cwojIGNhdCAvdG1wL01ha2Vm
aWxlCmZvbz0kKHNvcnQgJChkaXIgJCh3aWxkY2FyZCAgJChQV0QpLyovKSkpCmZvbzoKCUBlY2hv
ICQoZm9vKQojIG1ha2UgLWYgL3RtcC9NYWtlZmlsZSBmb28KL3Jvb3Qvd29ya3NwYWNlL3hmc3Rl
c3RzL3Rlc3RzLyAvcm9vdC93b3Jrc3BhY2UveGZzdGVzdHMvdGVzdHMvYnRyZnMvIC9yb290L3dv
cmtzcGFjZS94ZnN0ZXN0cy90ZXN0cy9leHQ0LyAvcm9vdC93b3Jrc3BhY2UveGZzdGVzdHMvdGVz
dHMvZ2VuZXJpYy8gL3Jvb3Qvd29ya3NwYWNlL3hmc3Rlc3RzL3Rlc3RzL3NoYXJlZC8gL3Jvb3Qv
d29ya3NwYWNlL3hmc3Rlc3RzL3Rlc3RzL3VkZi8gL3Jvb3Qvd29ya3NwYWNlL3hmc3Rlc3RzL3Rl
c3RzL3hmcy8KCkl0IGFsd2F5cyBvdXRwdXQgdGhlIHRlc3RzLyBkaXIgaXRzZWxmLiBJZiBJIHVz
ZWQgdGhpcyBmb3IgeGZzdGVzdHMKJ21ha2UgaW5zdGFsbCcsIGl0IHdpbGwgZmFsbCBpbnRvIGVu
ZGxlc3MgbG9vcCwgZm9yIGl0IHdpbGwgcmVydW4KTWFrZWZpbGUgdW5kZXIgL3Rlc3RzLgoKPiBD
aGVlcnMsCj4KPiBEYXZlLgo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNn
aS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
