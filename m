Return-Path: <SRS0=lajH=XX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7750C388F3
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Sep 2019 00:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF3A821841
	for <linux-xfs@archiver.kernel.org>; Sat, 28 Sep 2019 00:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569629026;
	bh=UsogPjngA9eL0uet4QxTG+iA9tjVFy/4skK34PyKJko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p0EHuRBAhhiR/cK7Y0Nr8J/LnkKaOOZlOH6gmyEDc+/6LPTaTdnpjFxnqHT8Bh90h
	 j2ofIsJSw5B8VxxEHRkG5wy3WD0KU7qGKJ2mfTqPPu0XR6Og5SMYT/mdZuW4TV2nlq
	 czyt8OQPl0Y2YSLzeb63YE5udSybDBu17pDllQGY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfI1ADq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Sep 2019 20:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbfI1ADp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Sep 2019 20:03:45 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE93921841;
        Sat, 28 Sep 2019 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569629025;
        bh=UsogPjngA9eL0uet4QxTG+iA9tjVFy/4skK34PyKJko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO6Mu4DtylVKt8fP91tFYNUrhDJztpbk9RAAswACVF0Ojg0dkStH68+ECwiv7bgCY
         KuqqNgWxo8Hev5Q0WYcUQ36QLnHh/FPS4sLwJnIZcmj8Fxzkyi60iDmVZw8VUZ9m1h
         Ev+ZTjbFP5zhZSTI0E6brPkc9Y8R0pbRiN4XYbc8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 4/9] xfs_io/encrypt: add new encryption modes
Date:   Fri, 27 Sep 2019 17:02:38 -0700
Message-Id: <20190928000243.77634-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
In-Reply-To: <20190928000243.77634-1-ebiggers@kernel.org>
References: <20190928000243.77634-1-ebiggers@kernel.org>
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
 io/encrypt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/encrypt.c b/io/encrypt.c
index 7d3e3b73..8a511379 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -142,6 +142,9 @@ static const struct {
 } available_modes[] = {
 	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
 	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
+	{FSCRYPT_MODE_AES_128_CBC, "AES-128-CBC"},
+	{FSCRYPT_MODE_AES_128_CTS, "AES-128-CTS"},
+	{FSCRYPT_MODE_ADIANTUM, "Adiantum"},
 };
 
 static cmdinfo_t get_encpolicy_cmd;
-- 
2.23.0.444.g18eeb5a265-goog

