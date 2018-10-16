Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from 2.mo302.mail-out.ovh.net ([137.74.110.75]:50750 "EHLO
        2.mo302.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeJPSWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Oct 2018 14:22:06 -0400
Received: from dag002ex3.OVH.local (gw1.corp.ovh.com [51.255.55.226])
        by mo302.mail-out.ovh.net (Postfix) with ESMTPS id 2BB214A5B5
        for <linux-xfs@vger.kernel.org>; Tue, 16 Oct 2018 12:22:23 +0200 (CEST)
From: Romain Le Disez <romain.le-disez@corp.ovh.com>
Subject: [QUESTION] multiple fsync() vs single sync()
Date: Tue, 16 Oct 2018 10:22:18 +0000
Message-ID: <6A65F394-C1BA-4339-AC9B-051885D12F65@corp.ovh.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <A39EDE220E43964BB69B3C2AA2E8DD16@corp.ovh.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

SGkgYWxsLA0KDQpJbiB0aGlzIHBzZXVkby1jb2RlIChleHRyYWN0ZWQgZnJvbSBPcGVuU3RhY2sg
U3dpZnQgWzFdKToNCiAgICBmZD1vcGVuKCIvdG1wL3RlbXBmaWxlIiwgT19DUkVBVCB8IE9fV1JP
TkxZKTsNCiAgICB3cml0ZShmZCwgLi4uKTsNCiAgICBmc2V0eGF0dHIoZmQsIC4uLik7DQogICAg
ZnN5bmMoZmQpOw0KICAgIHJlbmFtZSgiL3RtcC90ZW1wZmlsZSIsICIvZGF0YS9mb29iYXIiKTsN
CiAgICBkaXJmZCA9IG9wZW4oIi9kYXRhIiwgT19ESVJFQ1RPUlkgfCBPX1JET05MWSk7DQogICAg
ZnN5bmMoZGlyZmQpOw0KDQpPUiAodGhlIHNhbWUgd2l0aG91dCB0ZW1wb3JhcnkgZmlsZSk6DQog
ICAgZmQ9b3BlbigiL2RhdGEiLCBPX1RNUEZJTEUgfCBPX1dST05MWSk7DQogICAgd3JpdGUoZmQs
IC4uLik7DQogICAgZnNldHhhdHRyKGZkLCAuLi4pOw0KICAgIGZzeW5jKGZkKTsNCiAgICBsaW5r
YXQoQVRfRkRDV0QsICIvcHJvYy9zZWxmL2ZkLyIgKyBmZCwgQVRfRkRDV0QsICIvZGF0YS9mb29i
YXIiLCBBVF9TWU1MSU5LX0ZPTExPVyk7DQogICAgZGlyZmQgPSBvcGVuKCIvZGF0YSIsIE9fRElS
RUNUT1JZIHwgT19SRE9OTFkpOw0KICAgIGZzeW5jKGRpcmZkKTsNCg0KDQpJ4oCZbSBndWFyYW50
ZWVkIHRoYXQsIHdoYXQgZXZlciBoYXBwZW4sIEnigJlsbCBoYXZlIGEgY29tcGxldGUgZmlsZSAo
ZGF0YSt4YXR0cikgb3Igbm8gZmlsZSBhdCBhbGwgaW4gdGhlIGRpcmVjdG9yeSAvZGF0YS4NCg0K
Rmlyc3QgcXVlc3Rpb246IGlzIHRoYXQgYSBjb3JyZWN0IGFzc3VtcHRpb24gb3IgaXMgdGhlcmUg
YW55IGxvb3Bob2xlcz8NCg0KU2Vjb25kIHF1ZXN0aW9uLCBpZiBJIHJlcGxhY2UgdGhlIHR3byBm
c3luYygpIGJ5IG9uZSBzeW5jKCksIGRvIEkgZ2V0IHRoZSBzYW1lIGd1YXJhbnRlZT8NCiAgICBm
ZD1vcGVuKCIvZGF0YSIsIE9fVE1QRklMRSB8IE9fV1JPTkxZKTsNCiAgICB3cml0ZShmZCwgLi4u
KTsNCiAgICBmc2V0eGF0dHIoZmQsIC4uLik7DQogICAgbGlua2F0KEFUX0ZEQ1dELCDCqyAvcHJv
Yy9zZWxmL2ZkLyIgKyBmZCwgQVRfRkRDV0QsICIvZGF0YS9mb29iYXIiLCBBVF9TWU1MSU5LX0ZP
TExPVyk7DQogICAgc3luYygpOw0KDQpGcm9tIHdoYXQgSSB1bmRlcnN0YW5kIG9mIHRoZSBGQVEg
WzFdLCB3cml0ZV9iYXJyaWVyIGd1YXJhbnRlZSB0aGF0IGpvdXJuYWwgKGFrYSBsb2cpIHdpbGwg
YmUgd3JpdHRlbiBiZWZvcmUgdGhlIGlub2RlIChha2EgbWV0YWRhdGEpLiBEaWQgSSBtaXNzIHNv
bWV0aGluZz8NCg0KTWFueSB0aGFua3MgZm9yIHlvdXIgaGVscC4NCg0KWzFdIGh0dHBzOi8vZ2l0
aHViLmNvbS9vcGVuc3RhY2svc3dpZnQvYmxvYi8yLjE5LjAvc3dpZnQvb2JqL2Rpc2tmaWxlLnB5
I0wxNjc0LUwxNjk0DQpbMl0gaHR0cDovL3hmcy5vcmcvaW5kZXgucGhwL1hGU19GQVEjUTpfV2hh
dF9pc190aGVfcHJvYmxlbV93aXRoX3RoZV93cml0ZV9jYWNoZV9vbl9qb3VybmFsZWRfZmlsZXN5
c3RlbXMuM0YNCg0KLS0gDQpSb21haW4NCg0K
