Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434DCC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 16:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2081422DD6
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 16:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfHTQa7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:30:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:7313 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfHTQa7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 12:30:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 09:30:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="185956463"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Aug 2019 09:30:57 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 20 Aug 2019 09:30:57 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.127]) by
 FMSMSX110.amr.corp.intel.com ([169.254.14.63]) with mapi id 14.03.0439.000;
 Tue, 20 Aug 2019 09:30:57 -0700
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "hch@lst.de" <hch@lst.de>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Thread-Topic: 5.3-rc1 regression with XFS log recovery
Thread-Index: AQHVVHWHW9jyoVVDjkW5IFS3q2GBzqcA9LwAgAAIcACAAKWeAIAAbhuAgAA90wCAAAYTAIAAAzOAgAABtICAAAMbAIABkriAgAAUDACAACclAIAAE9WAgAB3KwA=
Date:   Tue, 20 Aug 2019 16:30:56 +0000
Message-ID: <70d0f825df98351d586285e0629fff16ce345438.camel@intel.com>
References: <20190818173426.GA32311@lst.de>
         <20190819000831.GX6129@dread.disaster.area> <20190819034948.GA14261@lst.de>
         <20190819041132.GA14492@lst.de> <20190819042259.GZ6129@dread.disaster.area>
         <20190819042905.GA15613@lst.de> <20190819044012.GA15800@lst.de>
         <20190820044135.GC1119@dread.disaster.area> <20190820055320.GB27501@lst.de>
         <20190820081325.GA21032@ming.t460p> <20190820092424.GB21032@ming.t460p>
In-Reply-To: <20190820092424.GB21032@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.185]
Content-Type: text/plain; charset="utf-8"
Content-ID: <96E25D766D03C448814B99ECAA06EBF4@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTIwIGF0IDE3OjI0ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gDQo+
IEl0IGNhbiBiZSBxdWl0ZSBoYXJkIHRvIGRlYWwgd2l0aCBub24tNTEyIGFsaWduZWQgc2VjdG9y
IGJ1ZmZlciwgc2luY2UNCj4gb25lIHNlY3RvciBidWZmZXIgbWF5IGNyb3NzIHR3byBwYWdlcywg
c28gZmFyIG9uZSB3b3JrYXJvdW5kIEkgdGhvdWdodA0KPiBvZiBpcyB0byBub3QgbWVyZ2Ugc3Vj
aCBJTyBidWZmZXIgaW50byBvbmUgYnZlYy4NCj4gDQo+IFZlcm1hLCBjb3VsZCB5b3UgdHJ5IHRo
ZSBmb2xsb3dpbmcgcGF0Y2g/DQoNCkhpIE1pbmcsDQoNCkkgY2FuIGhpdCB0aGUgc2FtZSBmYWls
dXJlIHdpdGggdGhpcyBwYXRjaC4NCkZ1bGwgdGhyZWFkLCBpbiBjYXNlIHlvdSBoYXZlbid0IGFs
cmVhZHkgc2VlbiBpdDoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy9lNDlhNmEz
YTI0NGRiMDU1OTk1NzY5ZWI4NDRjMjgxZjkzZTUwYWI5LmNhbWVsQGludGVsLmNvbS8NCg0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Jpby5jIGIvYmxvY2svYmlvLmMNCj4gaW5kZXggMjRhNDk2
ZjVkMmUyLi40OWRlYWIyYWM4YzQgMTAwNjQ0DQo+IC0tLSBhL2Jsb2NrL2Jpby5jDQo+ICsrKyBi
L2Jsb2NrL2Jpby5jDQo+IEBAIC03NjksNiArNzY5LDkgQEAgYm9vbCBfX2Jpb190cnlfbWVyZ2Vf
cGFnZShzdHJ1Y3QgYmlvICpiaW8sIHN0cnVjdA0KPiBwYWdlICpwYWdlLA0KPiAgCWlmIChXQVJO
X09OX09OQ0UoYmlvX2ZsYWdnZWQoYmlvLCBCSU9fQ0xPTkVEKSkpDQo+ICAJCXJldHVybiBmYWxz
ZTsNCj4gIA0KPiArCWlmIChvZmYgJiA1MTEpDQo+ICsJCXJldHVybiBmYWxzZTsNCj4gKw0KPiAg
CWlmIChiaW8tPmJpX3ZjbnQgPiAwKSB7DQo+ICAJCXN0cnVjdCBiaW9fdmVjICpidiA9ICZiaW8t
PmJpX2lvX3ZlY1tiaW8tPmJpX3ZjbnQgLSAxXTsNCj4gIA0KPiANCj4gVGhhbmtzLA0KPiBNaW5n
DQoNCg==
