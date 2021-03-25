Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D920C433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C40761A16
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhCYQpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 12:45:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:45408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhCYQol (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 12:44:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616690680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EwaRIE09GX8AfoBaJ3oYa6KimMdVtHo8D7Q+Ms/Hd6U=;
        b=s9rAuH+GWzW69Bn+DQSgrHNrG3hdRhy2/JMYaSQqPcfPjiBicgrd/obf3TMlC1DkORIKAO
        S8lE6ov9J8MtHL79IeAT4S8AYXhO5JygT/5R+Vzgq3Vwv7kzXzlflwoyH5G4V0Yg1NaEGb
        ZM+9l+fFyDyYyOG/O6mKAZ2b21IorUk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B67BACFC
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 16:44:40 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix xfs_trans slab cache name
Date:   Thu, 25 Mar 2021 17:47:50 +0100
Message-Id: <20210325164750.19599-1-ailiop@suse.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removal of kmem_zone_init wrappers accidentally changed a slab cache
name from "xfs_trans" to "xf_trans". Fix this so that userspace
consumers of /proc/slabinfo and /sys/kernel/slab can find it again.

Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 699c61637961..f816137ae976 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1905,7 +1905,7 @@ xfs_init_zones(void)
 	if (!xfs_ifork_zone)
 		goto out_destroy_da_state_zone;
 
-	xfs_trans_zone = kmem_cache_create("xf_trans",
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
 	if (!xfs_trans_zone)
-- 
2.31.0

