Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.tencent.com ([163.177.67.195]:45359 "EHLO
        mail2.tencent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388648AbeKWASB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 19:18:01 -0500
From: =?gb2312?B?ZGJ5aW4o0vzsxyk=?= <dbyin@tencent.com>
Subject: [PATCH] fs/xfs: fix f_ffree value for statfs when project quota is
 set
Date: Thu, 22 Nov 2018 13:28:04 +0000
Message-ID: <6EC51EE77FA0264BB8DAD779E0C341C9014BD77C91@EXMBX-SZMAIL003.tencent.com>
Content-Language: zh-CN
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?gb2312?B?ZGJ5aW4o0vzsxyk=?= <dbyin@tencent.com>

V2hlbiBwcm9qZWN0IGlzIHNldCwgd2Ugc2hvdWxkIHVzZSBpbm9kZSBsaW1pdCBtaW51cyB0aGUg
dXNlZCBjb3VudA0KDQpTaWduZWQtb2ZmLWJ5OiBZZSBZaW4gPGRieWluQHRlbmNlbnQuY29tPg0K
LS0tDQogZnMveGZzL3hmc19xbV9iaHYuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfcW1fYmh2
LmMgYi9mcy94ZnMveGZzX3FtX2Jodi5jDQppbmRleCA3M2ExZDc3ZWMxODcuLjMwOTFlNGJjMDRl
ZiAxMDA2NDQNCi0tLSBhL2ZzL3hmcy94ZnNfcW1fYmh2LmMNCisrKyBiL2ZzL3hmcy94ZnNfcW1f
Ymh2LmMNCkBAIC00MCw3ICs0MCw3IEBAIHhmc19maWxsX3N0YXR2ZnNfZnJvbV9kcXVvdCgNCiAg
ICAgICAgICAgICAgICBzdGF0cC0+Zl9maWxlcyA9IGxpbWl0Ow0KICAgICAgICAgICAgICAgIHN0
YXRwLT5mX2ZmcmVlID0NCiAgICAgICAgICAgICAgICAgICAgICAgIChzdGF0cC0+Zl9maWxlcyA+
IGRxcC0+cV9yZXNfaWNvdW50KSA/DQotICAgICAgICAgICAgICAgICAgICAgICAgKHN0YXRwLT5m
X2ZmcmVlIC0gZHFwLT5xX3Jlc19pY291bnQpIDogMDsNCisgICAgICAgICAgICAgICAgICAgICAg
ICAoc3RhdHAtPmZfZmlsZXMgLSBkcXAtPnFfcmVzX2ljb3VudCkgOiAwOw0KICAgICAgICB9DQog
fQ0KIA0KLS0gDQoyLjE2LjINCg==
