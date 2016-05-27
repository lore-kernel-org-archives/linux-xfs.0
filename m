Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B96B47CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 23:11:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AF01304039
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 21:11:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PRDamVzG3GvD5s1v (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 21:11:41 -0700 (PDT)
Date: Thu, 26 May 2016 21:11:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fail ->bmap for reflink inodes
Message-ID: <20160527041127.GA5053@birch.djwong.org>
References: <1464267724-31423-1-git-send-email-hch@lst.de>
	<1464267724-31423-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1464267724-31423-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

T24gVGh1LCBNYXkgMjYsIDIwMTYgYXQgMDM6MDI6MDRQTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+
Cj4gLS0tCj4gIGZzL3hmcy94ZnNfYW9wcy5jIHwgMTEgKysrKysrKysrKysKPiAgMSBmaWxlIGNo
YW5nZWQsIDExIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19hb3Bz
LmMgYi9mcy94ZnMveGZzX2FvcHMuYwo+IGluZGV4IGE5NTU1NTIuLmQwNTNhOWUgMTAwNjQ0Cj4g
LS0tIGEvZnMveGZzL3hmc19hb3BzLmMKPiArKysgYi9mcy94ZnMveGZzX2FvcHMuYwo+IEBAIC0x
ODI5LDYgKzE4MjksMTcgQEAgeGZzX3ZtX2JtYXAoCj4gIAo+ICAJdHJhY2VfeGZzX3ZtX2JtYXAo
WEZTX0koaW5vZGUpKTsKPiAgCXhmc19pbG9jayhpcCwgWEZTX0lPTE9DS19TSEFSRUQpOwo+ICsK
PiArCS8qCj4gKwkgKiBUaGUgc3dhcCBjb2RlIChhYi0pdXNlcyAtPmJtYXAgdG8gZ2V0IGEgYmxv
Y2sgbWFwcGluZyBhbmQgdGhlbgo+ICsJICogYnlwYXNzZdGVIHRoZSBmaWxlIHN5c3RlbSBmb3Ig
YWN0dWFsIEkvTy4gIFdlIHJlYWxseSBjYW4ndCBhbGxvdwo+ICsJICogdGhhdCBvbiByZWZsaW5r
cyBpbm9kZXMsIHNvIHdlIGhhdmUgdG8gc2tpcCBvdXQgaGVyZS4gIEFuZCB5ZXMsCj4gKwkgKiAw
IGlzIHRoZSBtYWdpYyBjb2RlIGZvciBhIGJtYXAgZXJyb3IuLgo+ICsJICovCj4gKwlpZiAoeGZz
X2lzX3JlZmxpbmtfaW5vZGUoaXApKSB7Cj4gKwkJeGZzX2l1bmxvY2soaXAsIFhGU19JT0xPQ0tf
U0hBUkVEKTsKPiArCQlyZXR1cm4gMDsKPiArCX0KCi9tZSBhZGRzIHRvIHRoZSByZWZsaW5rIHBh
dGNocGlsZSwgdGhhbmtzLgoKSnVzdCBwb2tpbmcgYXQgbW0vc3dhcGZpbGUuYyBpdCBsb29rcyBs
aWtlIGlvbWFwIG1pZ2h0IHdvcmsgd2VsbAphcyBhIHJlcGxhY2VtZW50IGZvciByZXBlYXRlZCBi
bWFwKCkgY2FsbHMsIG9uY2UgdGhlIGlvbWFwIHZmcwpiaXRzIGdldCBpbi4KCi0tRAoKPiAgCWZp
bGVtYXBfd3JpdGVfYW5kX3dhaXQobWFwcGluZyk7Cj4gIAl4ZnNfaXVubG9jayhpcCwgWEZTX0lP
TE9DS19TSEFSRUQpOwo+ICAJcmV0dXJuIGdlbmVyaWNfYmxvY2tfYm1hcChtYXBwaW5nLCBibG9j
aywgeGZzX2dldF9ibG9ja3MpOwo+IC0tIAo+IDIuMS40Cj4gCgo+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4geGZzIG1haWxpbmcgbGlzdAo+IHhmc0Bv
c3Muc2dpLmNvbQo+IGh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
