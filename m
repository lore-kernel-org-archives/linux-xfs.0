Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C41C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 00:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9340421929
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568938814;
	bh=/iBbWJUHXXeizMoV7RFiy8dyUlcRnueuVF6qOxMeDNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=L8crmIQbe3iHHe/oaDx0NFWpWxf9tdcilCzWsmXgJ3bXKskV2yBXw+OxHkYIZgR7/
	 jpw2jWSmz9ne+m3p4P65xZsLDNR/qiX6ieMe1arSzgALGvlrk4wy6fUVeq71v2cL1I
	 u/km1YfXli5TAcxali/nuhTtbCacwMTwIhPL06tY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392719AbfITAUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 20:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391401AbfITAUH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:07 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 217CE21924;
        Fri, 20 Sep 2019 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938803;
        bh=/iBbWJUHXXeizMoV7RFiy8dyUlcRnueuVF6qOxMeDNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkThbXT2O3BgCUSff5nGiS8tOEyB2rkMb/PREifE3naegUKA2pybrCBZ5cZXV9VfI
         iny1r9JKnrlhUOPsVkHLJx4fOngPpGtEuFcC/hkW5yhI7kvKxN2BP6BnchaLR2NyKp
         qWtWUXtmdFhMwP7j4uoDnI2G9xpOaRR90qEHj89E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 3/8] xfs_io/encrypt: add new encryption modes
Date:   Thu, 19 Sep 2019 17:18:17 -0700
Message-Id: <20190920001822.257411-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920001822.257411-1-ebiggers@kernel.org>
References: <20190920001822.257411-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add new encryption modes: AES-128-CBC and AES-128-CTS (supported since
Linux v4.11), and Adiantum (supported since Linux v5.0).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 011a6410..f5046e5b 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -156,7 +156,7 @@ set_encpolicy_help(void)
 " -v VERSION -- version of policy structure\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"
-"    AES-256-XTS, AES-256-CTS\n"
+"    AES-256-XTS, AES-256-CTS, AES-128-CBC, AES-128-CTS, Adiantum\n"
 " FLAGS and VERSION must be numeric.\n"
 "\n"
 " Note that it's only possible to set an encryption policy on an empty\n"
@@ -170,6 +170,9 @@ static const struct {
 } available_modes[] = {
 	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
 	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
+	{FSCRYPT_MODE_AES_128_CBC, "AES-128-CBC"},
+	{FSCRYPT_MODE_AES_128_CTS, "AES-128-CTS"},
+	{FSCRYPT_MODE_ADIANTUM, "Adiantum"},
 };
 
 static bool
-- 
2.23.0.351.gc4317032e6-goog

