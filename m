Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EDFE67F3F
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 03:46:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E0203304053
	for <xfs@oss.sgi.com>; Tue, 31 Dec 2013 01:46:26 -0800 (PST)
Message-ID: <52C29265.8030701@oracle.com>
Date: Tue, 31 Dec 2013 17:46:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/10] xfs: introduce xfs_bulkstat_ichunk_ra
References: <52BEB459.7020202@oracle.com> <52C1A5F7.2040604@sgi.com>
In-Reply-To: <52C1A5F7.2040604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

T24gMjAxM+W5tDEy5pyIMzHml6UgMDA6NTcsIE1hcmsgVGluZ3VlbHkgd3JvdGU6Cj4gT24gMTIv
MjgvMTMgMDU6MjIsIEplZmYgTGl1IHdyb3RlOgo+PiBGcm9tOiBKaWUgTGl1PGplZmYubGl1QG9y
YWNsZS5jb20+Cj4+Cj4+IEludHJvZHVjZSB4ZnNfYnVsa3N0YXRfaWNodW5rX3JhKCkgdG8gbG9v
cCBvdmVyIGFsbCBjbHVzdGVycyBpbgo+PiB0aGUgbmV4dCBpbm9kZSBjaHVuaywgdGhlbiBwZXJm
b3JtcyByZWFkYWhlYWQgaWYgdGhlcmUgYXJlIGFueQo+PiBhbGxvY2F0ZWQgaW5vZGVzIGluIHRo
YXQgY2x1c3Rlci4KPj4KPj4gUmVmYWN0b3IgeGZzX2J1bGtzdGF0KCkgd2l0aCBpdC4KPj4KPj4g
U2lnbmVkLW9mZi1ieTogSmllIExpdTxqZWZmLmxpdUBvcmFjbGUuY29tPgo+PiAtLS0KPiAKPiBI
YWQgc29tZSBwcm9ibGVtcyBhcHBseWluZyB0aGlzIHBhdGNoLgo+IC4uLgo+IAo+PiArU1RBVElD
IHZvaWQKPj4gK3hmc19idWxrc3RhdF9pY2h1bmtfcmEoCj4+ICsgICAgc3RydWN0IHhmc19tb3Vu
dCAgICAgICAgKm1wLAo+PiArICAgIHhmc19hZ251bWJlcl90ICAgICAgICAgICAgYWdubywKPj4g
KyAgICBzdHJ1Y3QgeGZzX2lub2J0X3JlY19pbmNvcmUgICAgKmlyZWMpCj4+ICt7Cj4+ICsgICAg
eGZzX2FnYmxvY2tfdCAgICAgICAgICAgIGFnYm5vOwo+PiArICAgIHN0cnVjdCBibGtfcGx1ZyAg
ICAgICAgICAgIHBsdWc7Cj4+ICsgICAgaW50ICAgICAgICAgICAgICAgIGJsa3NfcGVyX2NsdXN0
ZXI7Cj4+ICsgICAgaW50ICAgICAgICAgICAgICAgIGlub2Rlc19wZXJfY2x1c3RlcjsKPj4gKyAg
ICBpbnQgICAgICAgICAgICAgICAgaTsgICAgLyogaW5vZGUgY2h1bmsgaW5kZXggKi8KPj4gKwo+
PiArICAgIGFnYm5vID0gWEZTX0FHSU5PX1RPX0FHQk5PKG1wLCBpcmVjLT5pcl9zdGFydGlubyk7
Cj4+ICsgICAgYmxrc19wZXJfY2x1c3RlciA9IHhmc19pY2x1c3Rlcl9zaXplX2ZzYihtcCk7Cj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXl5eXl4KPiBkb2VzIG5vdCBleGlzdC4KVGhpcyBw
YXRjaCBzZXJpZXMgaXMgYmFzZWQgb24gbXkgcHJldmlvdXMgY29kZSByZWZhY3RvcmluZyBvZgpp
bnRyb2R1Y2luZyB4ZnNfaWNsdXN0ZXJfc2l6ZV9mc2IoKSBoZWxwZXIuICBJIGd1ZXNzIHlvdSB3
b3VsZAphcHBseSB0aGlzIHBhdGNoIG9uIHRvcCBvZiB0aGF0IHdpdGhvdXQgdGhlIGN1cnJlbnQg
cHJvYmxlbXMuCgpUaGFua3MsCi1KZWZmCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
