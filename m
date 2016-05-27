Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 756F17CA6
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 12:41:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 463ED304032
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 10:41:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eJO3Jx13eG8b6SPY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 May 2016 10:40:58 -0700 (PDT)
Date: Fri, 27 May 2016 10:40:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fail ->bmap for reflink inodes
Message-ID: <20160527174050.GA3509@birch.djwong.org>
References: <1464267724-31423-1-git-send-email-hch@lst.de>
	<1464267724-31423-2-git-send-email-hch@lst.de>
	<71afd256-5dfe-2ff9-ac25-b7519dadd5f9@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <71afd256-5dfe-2ff9-ac25-b7519dadd5f9@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

T24gRnJpLCBNYXkgMjcsIDIwMTYgYXQgMDg6MzI6MThQTSArMDMwMCwgQXZpIEtpdml0eSB3cm90
ZToKPiBPbiAwNS8yNi8yMDE2IDA0OjAyIFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+
U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gPi0tLQo+ID4g
IGZzL3hmcy94ZnNfYW9wcy5jIHwgMTEgKysrKysrKysrKysKPiA+ICAxIGZpbGUgY2hhbmdlZCwg
MTEgaW5zZXJ0aW9ucygrKQo+ID4KPiA+ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYW9wcy5jIGIv
ZnMveGZzL3hmc19hb3BzLmMKPiA+aW5kZXggYTk1NTU1Mi4uZDA1M2E5ZSAxMDA2NDQKPiA+LS0t
IGEvZnMveGZzL3hmc19hb3BzLmMKPiA+KysrIGIvZnMveGZzL3hmc19hb3BzLmMKPiA+QEAgLTE4
MjksNiArMTgyOSwxNyBAQCB4ZnNfdm1fYm1hcCgKPiA+ICAJdHJhY2VfeGZzX3ZtX2JtYXAoWEZT
X0koaW5vZGUpKTsKPiA+ICAJeGZzX2lsb2NrKGlwLCBYRlNfSU9MT0NLX1NIQVJFRCk7Cj4gPisK
PiA+KwkvKgo+ID4rCSAqIFRoZSBzd2FwIGNvZGUgKGFiLSl1c2VzIC0+Ym1hcCB0byBnZXQgYSBi
bG9jayBtYXBwaW5nIGFuZCB0aGVuCj4gPisJICogYnlwYXNzZdGVIHRoZSBmaWxlIHN5c3RlbSBm
b3IgYWN0dWFsIEkvTy4gIFdlIHJlYWxseSBjYW4ndCBhbGxvdwo+ID4rCSAqIHRoYXQgb24gcmVm
bGlua3MgaW5vZGVzLCBzbyB3ZSBoYXZlIHRvIHNraXAgb3V0IGhlcmUuICBBbmQgeWVzLAo+ID4r
CSAqIDAgaXMgdGhlIG1hZ2ljIGNvZGUgZm9yIGEgYm1hcCBlcnJvci4uCj4gPisJICovCj4gPisJ
aWYgKHhmc19pc19yZWZsaW5rX2lub2RlKGlwKSkgewo+ID4rCQl4ZnNfaXVubG9jayhpcCwgWEZT
X0lPTE9DS19TSEFSRUQpOwo+ID4rCQlyZXR1cm4gMDsKPiA+Kwl9Cj4gPiAgCWZpbGVtYXBfd3Jp
dGVfYW5kX3dhaXQobWFwcGluZyk7Cj4gPiAgCXhmc19pdW5sb2NrKGlwLCBYRlNfSU9MT0NLX1NI
QVJFRCk7Cj4gPiAgCXJldHVybiBnZW5lcmljX2Jsb2NrX2JtYXAobWFwcGluZywgYmxvY2ssIHhm
c19nZXRfYmxvY2tzKTsKPiAKPiBEb24ndCB5b3UgYWxzbyBoYXZlIHRvIHByZXZlbnQgYSBzd2Fw
ZmlsZSBmcm9tIGJlaW5nIHJlZmxpbmtlZCBhZnRlciBpdCdzCj4gYm1hcHBlZD8gIE9yIGlzIHRo
YXQgYWxyZWFkeSB0YWtlbiBjYXJlIG9mPwoKQWxyZWFkeSB0YWtlbiBjYXJlIG9mLCBhdCBsZWFz
dCBmb3IgWEZTLgoKLS1ECgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
