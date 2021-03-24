Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8773AC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 08:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DFD619E5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 08:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhCXIoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 04:44:54 -0400
Received: from relay.herbolt.com ([37.46.208.54]:44726 "EHLO relay.herbolt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234417AbhCXIod (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 04:44:33 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 04:44:33 EDT
Received: from ip-78-102-244-147.net.upcbroadband.cz (ip-78-102-244-147.net.upcbroadband.cz [78.102.244.147])
        by relay.herbolt.com (Postfix) with ESMTPSA id CBBFE1034149
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 09:34:58 +0100 (CET)
Received: from mail.herbolt.com (http-server-2.local.lc [172.168.31.10])
        by mail.herbolt.com (Postfix) with ESMTPSA id 7A6DBD34A0A
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 09:34:58 +0100 (CET)
MIME-Version: 1.0
Date:   Wed, 24 Mar 2021 09:34:58 +0100
From:   lukas@herbolt.com
To:     linux-xfs@vger.kernel.org
Subject: xfs-docs question
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <481e3f11dda1f44efe5c93c24a3a70d9@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,
I came across chapter in XFS documentation "12.4.1 xfs_db AGI Example" 
quoting bellow:
---
recs[1-85] = [startino,freecount,free]1:[96,0,0] 2:[160,0,0] 3:[224,0,0] 
4:[288,0,0]
                                       5:[352,0,0] 6:[416,0,0] 
7:[480,0,0] 8:[544,0,0]
                                       9:[608,0,0] 10:[672,0,0] 
11:[736,0,0] 12:[800,0,0]
                                       ...
                                       85:[5792,9,0xff80000000000000]

Most of the inode chunks on this filesystem are totally full, since the 
free value is zero.
This means that we ought to expect inode 160 to be linked somewhere in 
the directory structure.
However, notice that 0xff80000000000000 in record 85 — this means that 
we would expect inode 5856
to be free. Moving on to the free inode B+tree, we see that this is 
indeed the case:
---

As there are 9 inodes free in the last chunk of 64 inodes it gives me 
first free inode 5847 (5792+55),
on the other hand inode 5856 is also free as it's last inode in the 
chunk.

My question is do I understand correctly that the first free inode in 
that AG is 5847?
Thanks, bellow possible patch.

---
diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc 
b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 992615d..cdc8545 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -1099,7 +1099,7 @@ recs[1-85] = [startino,freecount,free]
 Most of the inode chunks on this filesystem are totally full, since the 
+free+
 value is zero.  This means that we ought to expect inode 160 to be 
linked
 somewhere in the directory structure.  However, notice that 
0xff80000000000000
-in record 85 -- this means that we would expect inode 5856 to be free. 
 Moving
+in record 85 -- this means that we would expect inode 5847 to be free. 
 Moving
 on to the free inode B+tree, we see that this is indeed the case:
---

-- 
Lukas Herbolt
