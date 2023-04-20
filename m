Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2F3C77B72
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 14:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjDTOBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 10:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDTOBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 10:01:07 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63F5C6584
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 07:01:03 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7000B122F;
        Thu, 20 Apr 2023 09:01:02 -0500 (CDT)
Message-ID: <901a579d-f43a-157a-72df-6725cd391599@sandeen.net>
Date:   Thu, 20 Apr 2023 09:01:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Marcos Mello <marcosfrm@gmail.com>
Subject: [PATCH] xfsprogs: nrext64 option should be in [inode] section of mkfs
 conf files
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

nrext64 is an inode (-i) section option, not a metadata (-m) section option.

Reported-by: Marcos Mello <marcosfrm@gmail.com>
Fixes: 69e7272213 ("mkfs: Add option to create filesystem with large extent counters")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 751be45e..8b2bdd7a 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -2,7 +2,6 @@
 # kernel was released at the end of 2018.
 
 [metadata]
-nrext64=0
 bigtime=0
 crc=1
 finobt=1
@@ -12,3 +11,4 @@ rmapbt=0
 
 [inode]
 sparse=1
+nrext64=0
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index a1c991ce..40189310 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -2,7 +2,6 @@
 # kernel was released at the end of 2020.
 
 [metadata]
-nrext64=0
 bigtime=0
 crc=1
 finobt=1
@@ -12,3 +11,4 @@ rmapbt=0
 
 [inode]
 sparse=1
+nrext64=0
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index d751f4c4..aeecc035 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -2,7 +2,6 @@
 # kernel was released at the end of 2021.
 
 [metadata]
-nrext64=0
 bigtime=1
 crc=1
 finobt=1
@@ -12,3 +11,4 @@ rmapbt=0
 
 [inode]
 sparse=1
+nrext64=0
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 7e8a0ff0..0a40718b 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -2,7 +2,6 @@
 # kernel was released at the end of 2019.
 
 [metadata]
-nrext64=0
 bigtime=0
 crc=1
 finobt=1
@@ -12,3 +11,4 @@ rmapbt=0
 
 [inode]
 sparse=1
+nrext64=0
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index 08bbe9f3..452abdf8 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -2,7 +2,6 @@
 # kernel was released at the end of 2022.
 
 [metadata]
-nrext64=0
 bigtime=1
 crc=1
 finobt=1
@@ -12,3 +11,4 @@ rmapbt=0
 
 [inode]
 sparse=1
+nrext64=0

