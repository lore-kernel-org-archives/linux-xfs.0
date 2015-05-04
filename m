Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A51F7F5D
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 21:25:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 922B7304032
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 19:25:43 -0700 (PDT)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166]) by
	cuda.sgi.com with ESMTP id 8kjjWMg4rf0Q4BK8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 19:25:40 -0700 (PDT)
Message-ID: <5546D89A.1070504@foxmail.com>
Date: Mon, 04 May 2015 10:25:30 +0800
From: Wang Sheng-Hui <shhuiw@foxmail.com>
MIME-Version: 1.0
Subject: Re: xfstests: what's the difference between generic/043 and
	generic/044
References: <tencent_5AC82BAD44B2E3AE054828D2@qq.com>
	<20150504020242.GB21261@dastard>
In-Reply-To: <20150504020242.GB21261@dastard>
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
Cc: xfs <xfs@oss.sgi.com>

CgpPbiAyMDE15bm0MDXmnIgwNOaXpSAxMDowMiwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IFtjYyBm
c3Rlc3RzQHZnZXIua2VybmVsLm9yZy4gUGxlYXNlIHNlbmQgeGZzdGVzdHMgcXVlc3Rpb25zIHRo
ZXJlLiBdCj4gCj4gT24gTW9uLCBNYXkgMDQsIDIwMTUgYXQgMDk6NDk6MjBBTSArMDgwMCwgV2Fu
ZyBTaGVuZy1IdWkgd3JvdGU6Cj4+IEhpLAo+Pgo+PiBJJ20gcmVhZGluZyB0aGUgc291cmNlIGNv
ZGUgb2YgZ2VuZXJpYy8wNDQgaW4geGZzdGVzdHMsIGFuZCBJIGNhbm5vdCBmaWd1cmUgb3V0IHRo
ZQo+PiBkaWZmZXJlbmNlIGNvbXBhcmVkIHdpdGggMDQzIHRlc3RjYXNlOgo+PiAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCj4+ICQgZGlmZiAtTnUgMDQzIDA0NAo+PiAtLS0gMDQzIDIwMTUtMDMtMDkg
MTA6MDM6NDguMDEzODg3NTgyICswODAwCj4+ICsrKyAwNDQgMjAxNS0wMy0wOSAxMDowMzo0OC4w
MTM4ODc1ODIgKzA4MDAKPj4gQEAgLTEsNSArMSw1IEBACj4+ICAjISAvYmluL2Jhc2gKPj4gLSMg
RlNRQSBUZXN0IE5vLiAwNDMKPj4gKyMgRlNRQSBUZXN0IE5vLiAwNDQKPj4gICMKPj4gICMgVGVz
dCBmb3IgTlVMTCBmaWxlcyBwcm9ibGVtCj4+ICAjCj4+IEBAIC01Niw2ICs1NiwxMiBAQAo+PiAg
ICAgICAgICAgICAgICAgZWNobyBlcnJvciBjcmVhdGluZy93cml0aW5nIGZpbGUgJGZpbGUKPj4g
ICAgICAgICAgICAgICAgIGV4aXQKPj4gICAgICAgICBmaQo+PiArICAgICAgIHhmc19pbyAtYyAi
dHJ1bmNhdGUgNjRrIiAkZmlsZSAmZ3Q7IC9kZXYvbnVsbAo+PiArICAgICAgIGlmIFsgJD8gLW5l
IDAgXQo+PiArICAgICAgIHRoZW4KPj4gKyAgICAgICAgICAgICAgIGVjaG8gZXJyb3IgdHJ1bmNh
dGluZyBmaWxlICRmaWxlCj4+ICsgICAgICAgICAgICAgICBleGl0Cj4+ICsgICAgICAgZmkKPj4g
ICAgICAgICBsZXQgaT0kaSsxCj4+ICBkb25lCj4+Cj4+Cj4+IEJ1dCBiZWZvcmUgdGhlICd0cnVu
Y2F0ZSA2NEsnLCBvbmx5IDY0SyBzaXplZCBmaWxlcyBhcmUgY3JlYXRlZDoKPj4gICAgICAgICAg
ICAgICAgICB4ZnNfaW8gLWYgLWMgInB3cml0ZSAtYiA2NGsgLVMgMHhmZiAwIDY0ayIgJGZpbGUg
Jmd0OyAvZGV2L251bGwKPj4gU28gSSB0aGluayBpdCdzIHVzZWxlc3MgaGVyZSwgb3Igc29tZSB0
eXBvIGUuZyBzbWFsbGVyIHRydW5jYXRlIG5lZWRlZD8KPiAKPiBJdCdzIHRlc3RpbmcgYSBjb3Ju
ZXIgY2FzZSBpbiB0aGUgdHJ1bmNhdGUgY29kZSwgd2hlcmUgbmV3X3NpemUgPT0KPiBvbGRfc2l6
ZS4gR28gYmFjayB5ZWFycyBhZ28gKGkuZS4gYmVmb3JlIH4yMDA3KSB3aGVuIHRoZSAiTlVMTAo+
IGZpbGVzIiBwcm9ibGVtIGV4aXN0ZWQsIHRoaXMgd291bGQgcmVzdWx0IGluIFhGUyB3cml0aW5n
IGEgc2l6ZSBvZgo+IDY0ayB0byB0aGUgaW5vZGUsIGJ1dCBub25lIG9mIHRoZSBkYXRhIHdyaXR0
ZW4gaW50byB0aGUga2VybmVsIHdvdWxkCj4gZXhpc3Qgb24gZGlzay4gIEhlbmNlIHlvdSdkIGdl
dCBhICJOVUxMIGZpbGUiIGFmdGVyIGNyYXNoIHJlY292ZXJ5Cj4gaWYgeW91IGRpZCB0aGlzLgo+
IAo+IGdlbmVyaWMvMDQzIGlzIHNpbXBseSB0ZXN0aW5nIHdyaXRlIHdpdGhvdXQgdHJ1bmNhdGUg
LSB0aGUgcmVzdWx0Cj4gdGhlcmUgd2FzIGRlcGVuZGVudCBvbiB0aW1pbmcgb2Ygd3JpdGViYWNr
LCBzbyBub3QgZ3VhcmFudGVlZCB0bwo+IGZhaWwuIFRoZSB0cnVuY2F0ZSBjYXNlIHByZXR0eSBt
dWNoIGd1YXJhbnRlZWQgTlVMTCBmaWxlcyB3b3VsZAo+IGV4aXN0IGFuZCBzbyB0aGUgdGVzdCBh
bHdheXMgZmFpbGVkLi4uLgoKVGhhbmtzIGZvciB5b3VyIGV4cGxhbmF0aW9uLCBEYXZlLgoKUmVn
YXJkcywKU2hlbmctSHVpCgo+IAo+IENoZWVycywKPiAKPiBEYXZlLgo+IAoKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
