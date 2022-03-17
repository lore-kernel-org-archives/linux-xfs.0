Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4EDC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 02:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355027AbiCQCdI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 22:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354709AbiCQCdH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 22:33:07 -0400
Received: from m13115.mail.163.com (m13115.mail.163.com [220.181.13.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F6121FA5A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 19:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=QSoLL
        2+5JYZ8u69IL3RFBtacsfyEjVG7c3eNXdTLX/o=; b=BuPriFhVhVCpnaGk4VCTv
        4XGHwpXLxBDi3ThwVEldLi5sBQN7Ue9Tyifv5SpzKHZ22iJD6pneI9PZ5wEt5qoa
        FqW2Zoe5bVeshhmBgoXZsQpc4Z2v3iutY3rl7QOA+aIRyyTTnqmC3INa7Q/Uy9nw
        vSET1mboKOf+sZOeRtYGGQ=
Received: from 15147193722$163.com ( [110.16.107.22] ) by
 ajax-webmail-wmsvr115 (Coremail) ; Thu, 17 Mar 2022 10:31:47 +0800 (CST)
X-Originating-IP: [110.16.107.22]
Date:   Thu, 17 Mar 2022 10:31:47 +0800 (CST)
From:   guodf <15147193722@163.com>
To:     linux-xfs@vger.kernel.org
Subject: Metadata CRC error detected at xfs_bmbt block 0x1868f56bb0/0x1000
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <16d2444c.2cc8.17f95b788b9.Coremail.15147193722@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: c8GowAB388aWnTJi_HoRAA--.32146W
X-CM-SenderInfo: jprvikyxrzjliss6il2tof0z/xtbBaQDFlFXlw479ggAEs+
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

CgpIZWxsbzoKwqAgwqAgwqBBIGZhdGFsIGVycm9yIG9jY3VycmVkIGluIHRoZSBYRlMgZmlsZSBz
eXN0ZW0gb2YgbXkgcHJvZHVjdGlvbiBlbnZpcm9ubWVudCB3aGVuIEkgcnVuIHRoZSBmb2xsb3dp
bmcgY29tbWFuZArCoCDCoCDCoGVycm9y77yaCsKgIMKgIFtyb290QGxvY2FsaG9zdCAwMzE2XSMg
eGZzX21ldGFkdW1wwqAgLWcgLW8gLXcgL2Rldi9jZW50b3MvaG9tZSB4ZnMuaW1nCk1ldGFkYXRh
IENSQyBlcnJvciBkZXRlY3RlZCBhdCB4ZnNfYWdmIGJsb2NrIDB4MTg3ZmZmZmU3OS8weDIwMAp4
ZnNfbWV0YWR1bXA6IGNhbm5vdCBpbml0IHBlcmFnIGRhdGEgKC03NCkuIENvbnRpbnVpbmcgYW55
d2F5LgpDb3B5aW5nIGZyZWUgc3BhY2UgdHJlZXMgb2YgQUcgMTDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoMKgCk1ldGFkYXRhIENSQyBlcnJvciBkZXRlY3RlZCBhdCB4ZnNf
Ym1idCBibG9jayAweDE4NjhmNTZiYjAvMHgxMDAwCgoKeGZzX21ldGFkdW1wOiBpbnZhbGlkIG51
bXJlY3MgKDY1MDc5KSBpbiBibWFwYnRkIGJsb2NrIDQ4LzIyMDExNDM0MgpDb3B5aW5nIGZyZWUg
c3BhY2UgdHJlZXMgb2YgQUcgMjLCoCBNZXRhZGF0YSBDUkMgZXJyb3IgZGV0ZWN0ZWQgYXQgeGZz
X2JtYnQgYmxvY2sgMHgxOGE2ZmZlYjM4LzB4MTAwMAoKCnhmc19tZXRhZHVtcDogaW52YWxpZCBu
dW1yZWNzICgzOTAzMSkgaW4gYm1hcGJ0ZCBibG9jayA0OS84MTc4ODMxMgpNZXRhZGF0YSBDUkMg
ZXJyb3IgZGV0ZWN0ZWQgYXQgeGZzX2JtYnQgYmxvY2sgMHgxOWExZmZlZGE4LzB4MTAwMAp4ZnNf
bWV0YWR1bXA6IGludmFsaWQgbnVtcmVjcyAoNDk2MDYpIGluIGJtYXBidGQgYmxvY2sgNTEvNzEz
MDI2MzIKTWV0YWRhdGEgQ1JDIGVycm9yIGRldGVjdGVkIGF0IHhmc19ibWJ0IGJsb2NrIDB4MWE5
Y2ZmZjAxOC8weDEwMDAKeGZzX21ldGFkdW1wOiBpbnZhbGlkIG51bXJlY3MgKDQxOTQpIGluIGJt
YXBidGQgYmxvY2sgNTMvNjA4MTY5NTIKQ29weWluZyBmcmVlIHNwYWNlIHRyZWVzIG9mIEFHIDQ4
wqAgwqBiYWQgbWFnaWMgbnVtYmVyCgoKeGZzX21ldGFkdW1wOiBjYW5ub3QgcmVhZCBzdXBlcmJs
b2NrIGZvciBhZyA0OQpNZXRhZGF0YSBDUkMgZXJyb3IgZGV0ZWN0ZWQgYXQgeGZzX2FnaSBibG9j
ayAweDE4N2ZmZmZlN2EvMHgyMDAKTWV0YWRhdGEgQ1JDIGVycm9yIGRldGVjdGVkIGF0IHhmc19h
Z2ZsIGJsb2NrIDB4MTg3ZmZmZmU3Yi8weDIwMAovdXNyL3NiaW4veGZzX21ldGFkdW1wOiBsaW5l
IDMzOsKgIDYzNjkgU2VnbWVudGF0aW9uIGZhdWx0wqAgwqAgwqAgKGNvcmUgZHVtcGVkKSB4ZnNf
ZGIkREJPUFRTIC1pIC1wIHhmc19tZXRhZHVtcCAtYyAibWV0YWR1bXAkT1BUUyAkMiIgJDEKCgpJ
IGhhdmUgdHdvIHF1ZXN0aW9ucyBhbmQgaG9wZSB0byBnZXQgeW91ciByZXBseQox77yaTWV0YWRh
dGEgQ1JDIGVycm9yIGRldGVjdGVkIGF0IHhmc19hZ2ZsIGJsb2NrwqAweDE4N2ZmZmZlN2IvMHgy
MDAKCldoYXQgZG9lcyB0aGUgcmVkIGZvbnQgbWVhbu+8n1doYXQgZG9lcyBpdCBtZWFu77yfCgoy
77yaSG93IGNhbiBJIGZpeCBpdAoKClRoYW5rIHlvdSB2ZXJ5IG11Y2gKCg==
