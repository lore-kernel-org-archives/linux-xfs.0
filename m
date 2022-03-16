Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4079C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 10:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355150AbiCPKgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 06:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237750AbiCPKgh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 06:36:37 -0400
Received: from m13115.mail.163.com (m13115.mail.163.com [220.181.13.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D1246161
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 03:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=weEn2
        1bThhRN2fFfFKMuwT2sfArTYGOHOG6ydL8bjuU=; b=ZCkzliHZfRedX+Y9uX91z
        3cyTIv89vKyoITCIwMN9YKuGlZ6mQfFO7Z7ITn+U8rTZRtP4mJTUhOH3AOvD84mW
        KOCbh59oRT/NtRNiTCgxLwjzps+2DLxVlU7R1BUs7IFW1e+ktXxxTfmuPPnN4Duv
        EFuthLULBDr+8gkbcDHUfU=
Received: from 15147193722$163.com ( [111.56.38.11] ) by
 ajax-webmail-wmsvr115 (Coremail) ; Wed, 16 Mar 2022 18:35:03 +0800 (CST)
X-Originating-IP: [111.56.38.11]
Date:   Wed, 16 Mar 2022 18:35:03 +0800 (CST)
From:   guodf <15147193722@163.com>
To:     linux-xfs@vger.kernel.org
Subject: xfs_metadump: invalid numrecs (65079) in bmapbtd block 48/220114342
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <542a0599.ea87.17f924b9c3c.Coremail.15147193722@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: c8GowABHw8ZXvTFilhARAA--.29815W
X-CM-SenderInfo: jprvikyxrzjliss6il2tof0z/xtbBaQDFlFXlw479ggABs7
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

CgoKSGVsbG86CsKgIMKgIMKgQSBmYXRhbCBlcnJvciBvY2N1cnJlZCBpbiB0aGUgWEZTIGZpbGUg
c3lzdGVtIG9mIG15IHByb2R1Y3Rpb24gZW52aXJvbm1lbnQgd2hlbiBJIHJ1biB0aGUgZm9sbG93
aW5nIGNvbW1hbmQKwqAgwqAgwqBlcnJvcu+8mgrCoCDCoCBbcm9vdEBsb2NhbGhvc3QgMDMxNl0j
IHhmc19tZXRhZHVtcMKgIC1nIC1vIC13IC9kZXYvY2VudG9zL2hvbWUgeGZzLmltZwpNZXRhZGF0
YSBDUkMgZXJyb3IgZGV0ZWN0ZWQgYXQgeGZzX2FnZiBibG9jayAweDE4N2ZmZmZlNzkvMHgyMDAK
eGZzX21ldGFkdW1wOiBjYW5ub3QgaW5pdCBwZXJhZyBkYXRhICgtNzQpLiBDb250aW51aW5nIGFu
eXdheS4KQ29weWluZyBmcmVlIHNwYWNlIHRyZWVzIG9mIEFHIDEwwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqDCoApNZXRhZGF0YSBDUkMgZXJyb3IgZGV0ZWN0ZWQgYXQgeGZz
X2JtYnQgYmxvY2sgMHgxODY4ZjU2YmIwLzB4MTAwMAoKCnhmc19tZXRhZHVtcDogaW52YWxpZCBu
dW1yZWNzICg2NTA3OSkgaW4gYm1hcGJ0ZCBibG9jayA0OC8yMjAxMTQzNDIKQ29weWluZyBmcmVl
IHNwYWNlIHRyZWVzIG9mIEFHIDIywqAgTWV0YWRhdGEgQ1JDIGVycm9yIGRldGVjdGVkIGF0IHhm
c19ibWJ0IGJsb2NrIDB4MThhNmZmZWIzOC8weDEwMDAKCgp4ZnNfbWV0YWR1bXA6IGludmFsaWQg
bnVtcmVjcyAoMzkwMzEpIGluIGJtYXBidGQgYmxvY2sgNDkvODE3ODgzMTIKTWV0YWRhdGEgQ1JD
IGVycm9yIGRldGVjdGVkIGF0IHhmc19ibWJ0IGJsb2NrIDB4MTlhMWZmZWRhOC8weDEwMDAKeGZz
X21ldGFkdW1wOiBpbnZhbGlkIG51bXJlY3MgKDQ5NjA2KSBpbiBibWFwYnRkIGJsb2NrIDUxLzcx
MzAyNjMyCk1ldGFkYXRhIENSQyBlcnJvciBkZXRlY3RlZCBhdCB4ZnNfYm1idCBibG9jayAweDFh
OWNmZmYwMTgvMHgxMDAwCnhmc19tZXRhZHVtcDogaW52YWxpZCBudW1yZWNzICg0MTk0KSBpbiBi
bWFwYnRkIGJsb2NrIDUzLzYwODE2OTUyCkNvcHlpbmcgZnJlZSBzcGFjZSB0cmVlcyBvZiBBRyA0
OMKgIMKgYmFkIG1hZ2ljIG51bWJlcgoKCnhmc19tZXRhZHVtcDogY2Fubm90IHJlYWQgc3VwZXJi
bG9jayBmb3IgYWcgNDkKTWV0YWRhdGEgQ1JDIGVycm9yIGRldGVjdGVkIGF0IHhmc19hZ2kgYmxv
Y2sgMHgxODdmZmZmZTdhLzB4MjAwCk1ldGFkYXRhIENSQyBlcnJvciBkZXRlY3RlZCBhdCB4ZnNf
YWdmbCBibG9jayAweDE4N2ZmZmZlN2IvMHgyMDAKL3Vzci9zYmluL3hmc19tZXRhZHVtcDogbGlu
ZSAzMzrCoCA2MzY5IFNlZ21lbnRhdGlvbiBmYXVsdMKgIMKgIMKgIChjb3JlIGR1bXBlZCkgeGZz
X2RiJERCT1BUUyAtaSAtcCB4ZnNfbWV0YWR1bXAgLWMgIm1ldGFkdW1wJE9QVFMgJDIiICQxCgoK
SSBoYXZlIHR3byBxdWVzdGlvbnMgYW5kIGhvcGUgdG8gZ2V0IHlvdXIgcmVwbHkKMe+8mk1ldGFk
YXRhIENSQyBlcnJvciBkZXRlY3RlZCBhdCB4ZnNfYWdmbCBibG9jayAweDE4N2ZmZmZlN2IvMHgy
MDAKCldoYXQgZG9lcyB0aGUgcmVkIGZvbnQgbWVhbu+8n1doYXQgZG9lcyBpdCBtZWFu77yfCgoy
77yaSG93IGNhbiBJIGZpeCBpdAoKClRoYW5rIHlvdSB2ZXJ5IG11Y2gKCgoKCgrCoA==
