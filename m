Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7Q8CHVa019804 for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 03:12:17 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBD5827CD6
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 01:12:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	6XgAjfGHIAQRtypY for <xfs@oss.sgi.com>;
	Thu, 26 Aug 2010 01:12:50 -0700 (PDT)
Date: Thu, 26 Aug 2010 18:12:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Disallow 32bit project quota id.
Message-ID: <20100826081247.GD705@dastard>
References: <1282806131-20163-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282806131-20163-1-git-send-email-arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

T24gVGh1LCBBdWcgMjYsIDIwMTAgYXQgMDk6MDI6MTFBTSArMDIwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOgo+IEN1cnJlbnRseSBvbi1kaXNrIHN0cnVjdHVyZSBpcyBhYmxlIHRvIGtl
ZXAgb25seSAxNmJpdCBwcm9qZWN0IHF1b3RhIGlkLAo+IHNvIGRpc2FsbG93IDMyYml0IG9uZXMu
IFRoaXMgZml4ZXMgYSBwcm9ibGVtIHdoZXJlIHBhcnQgb2Yga2VybmVsCj4gc3RydWN0dXJlcyBo
b2xkaW5nIHByb2plY3QgcXVvdGEgaWQgdXNlcyAzMmJpdCB2YXJpYWJsZSB3aGlsZSBwYXJ0Cj4g
KG9uLWRpc2spIHVzZXMgMTZiaXQgdmFyaWFibGUgd2hpY2ggY2F1c2VzIHByb2plY3QgcXVvdGEg
bWVtYmVyIGZpbGVzCj4gdG8gYmUgaW5hY2Nlc3NpYmxlIGZvciBzb21lIG9wZXJhdGlvbnMgKGxp
a2UgbXYvcm0pLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJl
a21AbWF2ZW4ucGw+Cj4gLS0tCj4gCj4gUGxlYXNlIHF1ZXVlIGZvciB1cGNvbWluZyAyLjYuMzYg
Zml4ZXMuCj4gCj4gCj4gIGZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMgfCAgICA0ICsrKysK
PiAgMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL2ZzL3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMgYi9mcy94ZnMvbGludXgt
Mi42L3hmc19pb2N0bC5jCj4gaW5kZXggMjM3ZjVmZi4uMDE2NjIyNiAxMDA2NDQKPiAtLS0gYS9m
cy94ZnMvbGludXgtMi42L3hmc19pb2N0bC5jCj4gKysrIGIvZnMveGZzL2xpbnV4LTIuNi94ZnNf
aW9jdGwuYwo+IEBAIC05MDYsNiArOTA2LDEwIEBAIHhmc19pb2N0bF9zZXRhdHRyKAo+ICAJaWYg
KFhGU19GT1JDRURfU0hVVERPV04obXApKQo+ICAJCXJldHVybiBYRlNfRVJST1IoRUlPKTsKPiAg
Cj4gKwkvKiBEaXNhbGxvdyAzMmJpdCBwcm9qZWN0IGlkcyB0aGF0IGJlY2F1c2Ugb24tZGlzayBz
dHJ1Y3R1cmUgaXMgMTZiaXQgb25seSAqLwo+ICsJaWYgKGZhLT5mc3hfcHJvamlkID4gKF9fdWlu
dDE2X3QpLTEpCj4gKwkJcmV0dXJuIFhGU19FUlJPUihFSU5WQUwpOwo+ICsKCklmIHRoaW5rIHRo
YXQgbmVlZHMgdG8gaW5jbHVkZSBhIChtYXNrICYgRlNYX1BST0pJRCkgY2hlY2sgZmlyc3QuCmku
ZS4gb25seSB2YWxpZGF0ZSB0aGUgcHJvamlkIGlmIGl0IHdhcyBzZXQgYnkgdXNlcnNwYWNlLgoK
Q2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZpZEBmcm9tb3JiaXQuY29tCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBs
aXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94
ZnMK
