Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfHLR5P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:15 -0400
From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH 3/8] xfs_io/encrypt: add new encryption modes
Date: Mon, 12 Aug 2019 10:56:29 -0700
Message-Id: <20190812175635.34186-4-ebiggers@kernel.org>
In-Reply-To: <20190812175635.34186-1-ebiggers@kernel.org>
References: <20190812175635.34186-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add new encryption modes: AES-128-CBC and AES-128-CTS (supported since
Linux v4.11), and Adiantum (supported since Linux v5.0).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index ac473ed7..11eb4a3e 100644
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
2.23.0.rc1.153.gdeed80330f-goog
