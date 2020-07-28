Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0FBC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 02:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3688720759
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 02:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgG1CAM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 22:00:12 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39234 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726283AbgG1CAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 22:00:12 -0400
X-IronPort-AV: E=Sophos;i="5.75,404,1589212800"; 
   d="scan'208";a="96964965"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Jul 2020 10:00:09 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 261524CE5076;
        Tue, 28 Jul 2020 10:00:09 +0800 (CST)
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 28 Jul 2020 10:00:08 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local ([fe80::5ce6:5645:817a:34a4])
 by G08CNEXMBPEKD04.g08.fujitsu.local ([fe80::5ce6:5645:817a:34a4%14]) with
 mapi id 15.00.1497.006; Tue, 28 Jul 2020 10:00:08 +0800
From:   "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
CC:     "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "Gotou, Yasunori" <y-goto@fujitsu.com>
Subject: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Thread-Topic: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
Thread-Index: AdZkgkZYa39eKDGBSXGgU6Kg+bZxog==
Date:   Tue, 28 Jul 2020 02:00:08 +0000
Message-ID: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.167.225.206]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 261524CE5076.A95B8
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lihao2018.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGksDQoNCkkgaGF2ZSBub3RpY2VkIHRoYXQgd2UgaGF2ZSB0byBkcm9wIGNh
Y2hlcyB0byBtYWtlIHRoZSBjaGFuZ2luZyBvZiBTX0RBWA0KZmxhZyB0YWtl
IGVmZmVjdCBhZnRlciB1c2luZyBjaGF0dHIgK3ggdG8gdHVybiBvbiBEQVgg
Zm9yIGEgZXhpc3RpbmcNCnJlZ3VsYXIgZmlsZS4gVGhlIHJlbGF0ZWQgZnVu
Y3Rpb24gaXMgeGZzX2RpZmxhZ3NfdG9faWZsYWdzLCB3aG9zZQ0Kc2Vjb25k
IHBhcmFtZXRlciBkZXRlcm1pbmVzIHdoZXRoZXIgd2Ugc2hvdWxkIHNldCBT
X0RBWCBpbW1lZGlhdGVseS4NCg0KSSBjYW4ndCBmaWd1cmUgb3V0IHdoeSB3
ZSBkbyB0aGlzLiBJcyB0aGlzIGJlY2F1c2UgdGhlIHBhZ2UgY2FjaGVzIGlu
DQphZGRyZXNzX3NwYWNlLT5pX3BhZ2VzIGFyZSBoYXJkIHRvIGRlYWwgd2l0
aD8gSSBhbHNvIHdvbmRlciB3aGF0IHdpbGwNCmhhcHBlbiBpZiB3ZSBzZXQg
U19EQVggdW5jb25kaXRpb25hbGx5LiBUaGFua3MhDQoNClJlZ2FyZHMsDQpI
YW8gTGkNCgoK
