Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBE7C3A59D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 20:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04CA32133F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 20:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfHPU7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 16:59:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:20240 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbfHPU7q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Aug 2019 16:59:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 13:59:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,394,1559545200"; 
   d="scan'208";a="171524858"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2019 13:59:45 -0700
Received: from fmsmsx156.amr.corp.intel.com (10.18.116.74) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 16 Aug 2019 13:59:45 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 fmsmsx156.amr.corp.intel.com ([169.254.13.183]) with mapi id 14.03.0439.000;
 Fri, 16 Aug 2019 13:59:44 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzg==
Date:   Fri, 16 Aug 2019 20:59:44 +0000
Message-ID: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.251.152.70]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DACA2FF55A9B4146AFD44FB57EF33DA5@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGkgYWxsLA0KDQpXaGVuIHJ1bm5pbmcgdGhlICduZGN0bCcgdW5pdCB0ZXN0cyBhZ2FpbnN0IDUu
My1yYyBrZXJuZWxzLCBJIG5vdGljZWQgYQ0KZnJlcXVlbnQgZmFpbHVyZSBvZiB0aGUgJ21tYXAu
c2gnIHRlc3QgWzFdWzJdLg0KDQpbMV06IGh0dHBzOi8vZ2l0aHViLmNvbS9wbWVtL25kY3RsL2Js
b2IvbWFzdGVyL3Rlc3QvbW1hcC5zaA0KWzJdOiBodHRwczovL2dpdGh1Yi5jb20vcG1lbS9uZGN0
bC9ibG9iL21hc3Rlci90ZXN0L21tYXAuYw0KDQpCdXQgaW4gdHJ5aW5nIHRvIHBhcmUgZG93biB0
aGUgdGVzdCBmdXJ0aGVyLCBJIGZvdW5kIHRoYXQgSSBjYW4gc2ltcGx5DQpyZXByb2R1Y2UgdGhl
IHByb2JsZW0gYnk6DQoNCiAgbWtmcy54ZnMgLWYgL2Rldi9wbWVtMA0KICBtb3VudCAvZGV2L3Bt
ZW0wIC9tbnQvbWVtDQoNCldoZXJlICdwbWVtMCcgaXMgYSBsZWdhY3kgcG1lbSBuYW1lc3BhY2Ug
ZnJvbSByZXNlcnZlZCBtZW1vcnkgdXNpbmcgdGhlDQptZW1tYXA9IGNvbW1hbmQgbGluZSBvcHRp
b24uIChTcGVjaWZpY2FsbHksIEkgaGF2ZSB0aGlzOg0KbWVtbWFwPTNHITZHLDNHITlHICkNCg0K
VGhlIGFib3ZlIG1rZnMvbW91bnQgc3RlcHMgZG9uJ3QgcmVwcm9kdWNlIHRoZSBwcm9ibGVtIGEg
MTAwJSBvZiB0aGUNCnRpbWUsIGJ1dCBpdCBkb2VzIGhhcHBlbiBvbiBteSBxZW11IGJhc2VkIHNl
dHVwIG92ZXIgNzUlIG9mIHRoZSB0aW1lcy4NCg0KVGhlIGtlcm5lbCBsb2cgc2hvd3MgdGhlIGZv
bGxvd2luZyB3aGVuIHRoZSBtb3VudCBmYWlsczoNCg0KICAgW0F1ZzE2IDE0OjQxXSBYRlMgKHBt
ZW0wKTogTW91bnRpbmcgVjUgRmlsZXN5c3RlbQ0KICAgWyAgKzAuMDAxODU2XSBYRlMgKHBtZW0w
KTogdG90YWxseSB6ZXJvZWQgbG9nDQogICBbICArMC40MDI2MTZdIFhGUyAocG1lbTApOiBJbnRl
cm5hbCBlcnJvciB4bG9nX2NsZWFyX3N0YWxlX2Jsb2NrcygyKSBhdCBsaW5lIDE3MTUgb2YgZmls
ZSBmcy94ZnMveGZzX2xvZ19yZWNvdmVyLmMuICBDYWxsZXIgeGxvZ19maW5kX3RhaWwrMHgyMzAv
MHgzNDAgW3hmc10NCiAgIFsgICswLjAwMTc0MV0gQ1BVOiA3IFBJRDogMTc3MSBDb21tOiBtb3Vu
dCBUYWludGVkOiBHICAgICAgICAgICBPICAgICAgNS4yLjAtcmM0KyAjMTEyDQogICBbICArMC4w
MDA5NzZdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5
OTYpLCBCSU9TIHJlbC0xLjExLjEtMC1nMDU1MWE0YmUyYy1wcmVidWlsdC5xZW11LXByb2plY3Qu
b3JnIDA0LzAxLzIwMTQNCiAgIFsgICswLjAwMTUxNl0gQ2FsbCBUcmFjZToNCiAgIFsgICswLjAw
MDM1MV0gIGR1bXBfc3RhY2srMHg4NS8weGMwDQogICBbICArMC4wMDA0NTJdICB4bG9nX2NsZWFy
X3N0YWxlX2Jsb2NrcysweDE2ZC8weDE4MCBbeGZzXQ0KICAgWyAgKzAuMDAwNjY1XSAgeGxvZ19m
aW5kX3RhaWwrMHgyMzAvMHgzNDAgW3hmc10NCiAgIFsgICswLjAwMDU4MV0gIHhsb2dfcmVjb3Zl
cisweDJiLzB4MTYwIFt4ZnNdDQogICBbICArMC4wMDA1NTRdICB4ZnNfbG9nX21vdW50KzB4Mjgw
LzB4MmEwIFt4ZnNdDQogICBbICArMC4wMDA1NjFdICB4ZnNfbW91bnRmcysweDQxNS8weDg2MCBb
eGZzXQ0KICAgWyAgKzAuMDAwNTMzXSAgPyB4ZnNfbXJ1X2NhY2hlX2NyZWF0ZSsweDE4Yi8weDFm
MCBbeGZzXQ0KICAgWyAgKzAuMDAwNjY1XSAgeGZzX2ZzX2ZpbGxfc3VwZXIrMHg0YjAvMHg3MDAg
W3hmc10NCiAgIFsgICswLjAwMDYzOF0gID8geGZzX3Rlc3RfcmVtb3VudF9vcHRpb25zKzB4NjAv
MHg2MCBbeGZzXQ0KICAgWyAgKzAuMDAwNzEwXSAgbW91bnRfYmRldisweDE3Zi8weDFiMA0KICAg
WyAgKzAuMDAwNDQyXSAgbGVnYWN5X2dldF90cmVlKzB4MzAvMHg1MA0KICAgWyAgKzAuMDAwNDY3
XSAgdmZzX2dldF90cmVlKzB4MjgvMHhmMA0KICAgWyAgKzAuMDAwNDM2XSAgZG9fbW91bnQrMHgy
ZDQvMHhhMDANCiAgIFsgICswLjAwMDQxMV0gID8gbWVtZHVwX3VzZXIrMHgzZS8weDcwDQogICBb
ICArMC4wMDA0NTVdICBrc3lzX21vdW50KzB4YmEvMHhkMA0KICAgWyAgKzAuMDAwNDIwXSAgX194
NjRfc3lzX21vdW50KzB4MjEvMHgzMA0KICAgWyAgKzAuMDAwNDczXSAgZG9fc3lzY2FsbF82NCsw
eDYwLzB4MjQwDQogICBbICArMC4wMDA0NjBdICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJh
bWUrMHg0OS8weGJlDQogICBbICArMC4wMDA2NTVdIFJJUDogMDAzMzoweDdmNzMwZmVjOTFiZQ0K
ICAgWyAgKzAuMDAwNTA2XSBDb2RlOiA0OCA4YiAwZCBjZCAxYyAwYyAwMCBmNyBkOCA2NCA4OSAw
MSA0OCA4MyBjOCBmZiBjMyA2NiAyZSAwZiAxZiA4NCAwMCAwMCAwMCAwMCAwMCA5MCBmMyAwZiAx
ZSBmYSA0OSA4OSBjYSBiOCBhNSAwMCAwMCAwMCAwZiAwNSA8NDg+IDNkIDAxIGYwIGZmIGZmIDcz
IDAxIGMzIDQ4IDhiIDBkIDlhIDFjIDBjIDAwIGY3IGQ4IDY0IDg5IDAxIDQ4DQogICBbICArMC4w
MDIzMDVdIFJTUDogMDAyYjowMDAwN2ZmZGFkYmRiMTc4IEVGTEFHUzogMDAwMDAyNDYgT1JJR19S
QVg6IDAwMDAwMDAwMDAwMDAwYTUNCiAgIFsgICswLjAwMDkyMl0gUkFYOiBmZmZmZmZmZmZmZmZm
ZmRhIFJCWDogMDAwMDU1YjhmOWRiOGE0MCBSQ1g6IDAwMDA3ZjczMGZlYzkxYmUNCiAgIFsgICsw
LjAwMDg3NV0gUkRYOiAwMDAwNTViOGY5ZGJmZGIwIFJTSTogMDAwMDU1YjhmOWRiYjkzMCBSREk6
IDAwMDA1NWI4ZjlkYjhjMjANCiAgIFsgICswLjAwMDkxN10gUkJQOiAwMDAwN2Y3MzEwMDdmMWE0
IFIwODogMDAwMDAwMDAwMDAwMDAwMCBSMDk6IDAwMDA1NWI4ZjlkYzAxZjANCiAgIFsgICswLjAw
MDk0Ml0gUjEwOiAwMDAwMDAwMGMwZWQwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAw
MDAwMDAwMDAwMDAwMDANCiAgIFsgICswLjAwMDg3OF0gUjEzOiAwMDAwMDAwMGMwZWQwMDAwIFIx
NDogMDAwMDU1YjhmOWRiOGMyMCBSMTU6IDAwMDA1NWI4ZjlkYmZkYjANCiAgIFsgICswLjAwMDkx
NV0gWEZTIChwbWVtMCk6IGZhaWxlZCB0byBsb2NhdGUgbG9nIHRhaWwNCiAgIFsgICswLjAwMDYy
Ml0gWEZTIChwbWVtMCk6IGxvZyBtb3VudC9yZWNvdmVyeSBmYWlsZWQ6IGVycm9yIC0xMTcNCiAg
IFsgICswLjAxMjU2MF0gWEZTIChwbWVtMCk6IGxvZyBtb3VudCBmYWlsZWQNCg0KDQpBIGJpc2Vj
dCBwb2ludGVkIHRvIHRoaXMgY29tbWl0Og0KDQpjb21taXQgNmFkNWIzMjU1YjllM2Q2ZDk0MTU0
NzM4YWFjZDUxMTliZjljOGY2ZSAoSEVBRCAtPiBiaXNlY3QtYmFkLCByZWZzL2Jpc2VjdC9iYWQp
DQpBdXRob3I6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KRGF0ZTogICBGcmkgSnVu
IDI4IDE5OjI3OjI2IDIwMTkgLTA3MDANCg0KICAgIHhmczogdXNlIGJpb3MgZGlyZWN0bHkgdG8g
cmVhZCBhbmQgd3JpdGUgdGhlIGxvZyByZWNvdmVyeSBidWZmZXJzDQogICAgDQogICAgVGhlIHhm
c19idWYgc3RydWN0dXJlIGlzIGJhc2ljYWxseSB1c2VkIGFzIGEgZ2xvcmlmaWVkIGNvbnRhaW5l
ciBmb3INCiAgICBhIG1lbW9yeSBhbGxvY2F0aW9uIGluIHRoZSBsb2cgcmVjb3ZlcnkgY29kZS4g
IFJlcGxhY2UgaXQgd2l0aCBhDQogICAgY2FsbCB0byBrbWVtX2FsbG9jX2xhcmdlIGFuZCBhIHNp
bXBsZSBhYnN0cmFjdGlvbiB0byByZWFkIGludG8gb3INCiAgICB3cml0ZSBmcm9tIGl0IHN5bmNo
cm9ub3VzbHkgdXNpbmcgY2hhaW5lZCBiaW9zLg0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPg0KICAgIFJldmlld2VkLWJ5OiBEYXJyaWNrIEou
IFdvbmcgPGRhcnJpY2sud29uZ0BvcmFjbGUuY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IERhcnJp
Y2sgSi4gV29uZyA8ZGFycmljay53b25nQG9yYWNsZS5jb20+DQoNCkZ1bGwgYmlzZWN0IGxvZyBm
b2xsb3dzIGF0IHRoZSBlbmQuDQoNCkkgc2F3IFszXSwgYnV0IEkgY2FuIHN0aWxsIGVhc2lseSBo
aXQgdGhlIGZhaWx1cmUgYWZ0ZXIgbWFudWFsbHkNCmFwcGx5aW5nIHRoYXQgcGF0Y2ggb24gdGhl
IGFib3ZlIGNvbW1pdC4NCg0KWzNdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMv
MjAxOTA3MDkxNTIzNTIuMjc0NjUtMS1oY2hAbHN0LmRlLw0KDQpBbnkgdGhvdWdodHMgb24gd2hh
dCBtaWdodCBiZSBoYXBwZW5pbmc/IEknZCBiZSBoYXBweSB0byB0ZXN0IG91dA0KdGhlb3JpZXMv
cGF0Y2hlcy4NCg0KVGhhbmtzLA0KCS1WaXNoYWwNCg0K
