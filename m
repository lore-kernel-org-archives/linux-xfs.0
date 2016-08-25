Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3C8B7D17
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:39:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D232AC004
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ppZmfkI4z45ZgNH9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:19 -0700 (PDT)
Subject: [PATCH 67/71] xfs: fail ->bmap for reflink inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:39:13 -0700
Message-ID: <147216835350.867.14512964799631563964.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

RnJvbTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+CgpIYXZlIHhmc192bV9ibWFwIHJl
dHVybiB6ZXJvIGZvciByZWZsaW5rZWQgZmlsZXMuICBUaGlzIGhhY2sgcHJldmVudHMKdXNpbmcg
YSBmaWxlIHdpdGggc2hhcmVkIGJsb2NrcyBhcyBhIHN3YXAgZmlsZSwgYmVjYXVzZSB3ZSBkb24n
dCB3YW50CnRvIGRlYWwgd2l0aCBDb1cgd2hlbiB3ZSdyZSAocHJvYmFibHkpIGxvdyBvbiBtZW1v
cnkuCgpTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KW2RhcnJp
Y2sud29uZ0BvcmFjbGUuY29tOiBhZGQgYSBtb3JlIGRlc2NyaXB0aXZlIGNoYW5nZWxvZ10KU2ln
bmVkLW9mZi1ieTogRGFycmljayBKLiBXb25nIDxkYXJyaWNrLndvbmdAb3JhY2xlLmNvbT4KLS0t
CiBmcy94ZnMveGZzX2FvcHMuYyB8ICAgMTEgKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAx
MSBpbnNlcnRpb25zKCspCgoKZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfYW9wcy5jIGIvZnMveGZz
L3hmc19hb3BzLmMKaW5kZXggYTg1YmM2Mi4uZjU2NGQwMiAxMDA2NDQKLS0tIGEvZnMveGZzL3hm
c19hb3BzLmMKKysrIGIvZnMveGZzL3hmc19hb3BzLmMKQEAgLTE1NTMsNiArMTU1MywxNyBAQCB4
ZnNfdm1fYm1hcCgKIAogCXRyYWNlX3hmc192bV9ibWFwKFhGU19JKGlub2RlKSk7CiAJeGZzX2ls
b2NrKGlwLCBYRlNfSU9MT0NLX1NIQVJFRCk7CisKKwkvKgorCSAqIFRoZSBzd2FwIGNvZGUgKGFi
LSl1c2VzIC0+Ym1hcCB0byBnZXQgYSBibG9jayBtYXBwaW5nIGFuZCB0aGVuCisJICogYnlwYXNz
ZdGVIHRoZSBmaWxlIHN5c3RlbSBmb3IgYWN0dWFsIEkvTy4gIFdlIHJlYWxseSBjYW4ndCBhbGxv
dworCSAqIHRoYXQgb24gcmVmbGlua3MgaW5vZGVzLCBzbyB3ZSBoYXZlIHRvIHNraXAgb3V0IGhl
cmUuICBBbmQgeWVzLAorCSAqIDAgaXMgdGhlIG1hZ2ljIGNvZGUgZm9yIGEgYm1hcCBlcnJvci4u
CisJICovCisJaWYgKHhmc19pc19yZWZsaW5rX2lub2RlKGlwKSkgeworCQl4ZnNfaXVubG9jayhp
cCwgWEZTX0lPTE9DS19TSEFSRUQpOworCQlyZXR1cm4gMDsKKwl9CiAJZmlsZW1hcF93cml0ZV9h
bmRfd2FpdChtYXBwaW5nKTsKIAl4ZnNfaXVubG9jayhpcCwgWEZTX0lPTE9DS19TSEFSRUQpOwog
CXJldHVybiBnZW5lcmljX2Jsb2NrX2JtYXAobWFwcGluZywgYmxvY2ssIHhmc19nZXRfYmxvY2tz
KTsKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBt
YWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xp
c3RpbmZvL3hmcwo=
