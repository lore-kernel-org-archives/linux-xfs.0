Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4D3C1744B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 20:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2AB21E6F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 20:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=corp.ovh.com header.i=@corp.ovh.com header.b="clral5HS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLUWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 15:22:55 -0500
Received: from 1.mo301.mail-out.ovh.net ([137.74.110.64]:51925 "EHLO
        1.mo301.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKLUWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 15:22:55 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 15:22:54 EST
Received: from EX4.OVH.local (gw1.corp.ovh.com [51.255.55.226])
        by mo301.mail-out.ovh.net (Postfix) with ESMTPS id 8CEBE753F5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2019 21:13:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=corp.ovh.com;
        s=mailout; t=1573589586;
        bh=bEeg2RB0dVJMFMKr+vsdjoF3jdIb8e4Hvlr0LM4SuXM=;
        h=From:To:Subject:Date:From;
        b=clral5HSR30FKknsxVA1nejjcPOdfwt9hqqX+ZFanNcQImMRzZ8HIfiuTL81NAuDV
         VC7i2LaylU6OKRTKLMh6+bnJXvbdb/jBc4Dwzn0RXSYXsaXSsS6iXmZa5413FdGfT0
         jYFuUclsJEhPwtznMpKtbF8BukBNelzPPIQMy408=
Received: from EX3.OVH.local (172.16.2.3) by EX4.OVH.local (172.16.2.4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1531.1; Tue, 12
 Nov 2019 21:13:06 +0100
Received: from EX3.OVH.local ([fe80::7806:9f98:c0b4:db47]) by EX3.OVH.local
 ([fe80::7806:9f98:c0b4:db47%13]) with mapi id 15.01.1531.001; Tue, 12 Nov
 2019 21:13:06 +0100
From:   Romain Le Disez <romain.le-disez@corp.ovh.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: State of realtime option
Thread-Topic: State of realtime option
Thread-Index: AQHVmZWY5531JiQ4xkaQALEvvO4OCQ==
Date:   Tue, 12 Nov 2019 20:13:06 +0000
Message-ID: <9953B8E1-9FC7-45D8-8351-76BA568D9A17@corp.ovh.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [149.56.136.2]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BE8DEC0E23B1F49935BD4B7970C3805@corp.ovh.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Ovh-Tracer-Id: 1320117641451498887
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 49
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedruddvledgudefjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjqdffgfeufgfipdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenucfjughrpefhvffuthffkffoihgtgfggsehtsghmtdhhtdejnecuhfhrohhmpeftohhmrghinhcunfgvucffihhsvgiiuceorhhomhgrihhnrdhlvgdqughishgviiestghorhhprdhovhhhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrihhopdhgihhthhhusgdrtghomhenucfkpheptddrtddrtddrtddpudegledrheeirddufeeirddvpdhfvgektdemmeejkedtieemlehfleekmegttdgsgeemuggsgeejnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopefgigegrdfqggfjrdhlohgtrghlpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrohhmrghinhdrlhgvqdguihhsvgiisegtohhrphdrohhvhhdrtghomhdprhgtphhtthhopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGkgYWxsLA0KDQpJ4oCZbSB3b3JraW5nIHdpdGggYSBzb2Z0d2FyZSAoT3BlbnN0YWNrIFN3aWZ0
KSB3aGljaCBkb2VzIGEgbG90IG9mIGZpbGVzeXN0ZW0gbWV0YWRhdGEgb3BlcmF0aW9uczoNCi0g
cmVjdXJzaXZlIGxpc3RpbmcNCi0geGF0dHIgZ2V0L3NldA0KLSBkZWxldGluZyBmaWxlcw0KLSBj
cmVhdGluZyBlbXB0eSBmaWxlcw0KDQooSXQgYWxzbyBkb2VzICJkYXRhIiBvcGVyYXRpb25zLCBv
ZiBjb3Vyc2UpDQoNClRoZXNlIGRheXMsIEhERHMgZ2V0cyBiaWdnZXIgYnV0IHRoZWlycyBwZXJm
b3JtYW5jZXMgZG9lcyBub3QgaW5jcmVhc2UgYXMgbXVjaC4gT24gYSBiaWdnZXIgZGlzaywgdGhl
cmUgaXMgbW9yZSBkYXRhLCBzbyBzdGF0aXN0aWNhbGx5IG1vcmUgcmVxdWVzdCBmb3IgZGF0YSwg
YnV0IHRoZSBJL08gYnVkZ2V0IHN0YXlzIHByZXR0eSBtdWNoIHRoZSBzYW1lLg0KDQpXZSBhcmUg
Y29uc2lkZXJpbmcgdmFyaW91cyBzb2x1dGlvbnMgdG8gdGhpcyBpc3N1ZS4gT25lIG9mIHRoZSBt
b3N0IGludGVyZXN0aW5nIGlkZWEgaXMgdG8gc3RvcmUgZmlsZXN5c3RlbSBtZXRhZGF0YSBvbiBh
IGZhc3RlciBkZXZpY2UgKFNTRC9OVk1lKS4gWkZTIGltcGxlbWVudGVkIHRoaXMgZmVhdHVyZSBh
Ym91dCBhIHllYXIgYWdvIFsxXS4gSW50ZWwgaGFzIGJlZW4gd29ya2luZyBvbiBhIGdlbmVyaWMg
c29sdXRpb24gY2FsbGVkIE9wZW5DQVMgWzJdLg0KDQpYRlMgaGFkIGZvciBhIGxvbmcgdGltZSB0
aGUgcmVhbHRpbWUgb3B0aW9uIHdoaWNoIHNlZW1zIHRvIHByb3ZpZGUgdGhhdCBmZWF0dXJlLCBl
dmVuIGlmIGl0IHdhcyBub3QgZGVzaWduZWQgZm9yIHRoaXMgcGFydGljdWxhciB1c2UgY2FzZS4g
SSByZWFkIHZhcmlvdXMgdGhpbmdzLCBhbmQgaXQgc2VlbXMgdGhhdCBpbiAyMDE3IHRoaXMgZmVh
dHVyZSB3YXMgbm90IGNvbnNpZGVyZWQgc3RhYmxlLCBub3QgZXZlbiB0ZXN0ZWQgWzNdLg0KDQpT
aW5jZSAyMDE3LCB3aGVuIGxvb2tpbmcgYXQgdGhlIGdpdCBsb2csIEkgZm91bmQgbWFueSBjb21t
aXRzIG1lbnRpb25pbmcgdGhpcyBmZWF0dXJlLCBhcyBtdWNoIGFzIGZyb20gMjAwNSB0byAyMDE3
Lg0KDQpTbyBteSBxdWVzdGlvbiBpczogd2hhdCBpcyB0aGUgY3VycmVudCBzdGF0ZSBvZiByZWFs
dGltZT8gRGlkIGl0IGNoYW5nZSBhbmQgaXMgbm93IHN0YWJsZS9wcm9kdWN0aW9uIHJlYWR5Lg0K
SWYgbm90LCBpcyB0aGVyZSBhbnkgd2lsbGluZyB0byBnbyB0aGlzIHdheSB0byBtYXRjaCB0aGlz
IGtpbmQgb2YgdXNlIGNhc2U/DQoNCk1heWJlIHlvdSBldmVuIGhhdmUgYW4gb3RoZXIgaWRlYSB0
byBlbnN1cmUgZ29vZCByZWFkL3dyaXRlIHBlcmZvcm1hbmNlIG9uIGZpbGVzeXN0ZW0gbWV0YWRh
dGE/DQoNClRoeCBmb3IgeW91ciBhbnN3ZXIuDQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20vemZz
b25saW51eC96ZnMvcHVsbC81MTgyDQpbMl0gaHR0cHM6Ly9vcGVuLWNhcy5naXRodWIuaW8vDQpb
M10gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC85OTMzMjM3LyMyMDg5NTIyOQ0K
DQotLSANClJvbWFpbg0KDQo=
