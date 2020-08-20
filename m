Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C46C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 00:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C37E207FB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 00:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597881929;
	bh=YpO6n/hx+XryrWAOxjzu0xvCNugcUj0aDwhi0NSNc6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WuDe+dQUIMAQ+AG/U/qqD4so0kLIKolvJlv8vM7m/l76o3htkqx6cst/9BjJ74Iyk
	 p4y1180vOlTiYYi67bNpBfWhHNYaMNGOLVBoZlzbcC3JidvIuwyq8Agy2tbCMsVf2R
	 a3bZ3jXinn8LQiypD+ebOU/fbJf7pPwCqjrI/daI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgHTAFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 20:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgHTAED (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Aug 2020 20:04:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D81207FB;
        Thu, 20 Aug 2020 00:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881843;
        bh=YpO6n/hx+XryrWAOxjzu0xvCNugcUj0aDwhi0NSNc6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElgjYdxrDVOyOEzTk7h1/PiRWiotOYONwqa1D9c7GnnsvqYWi/2f+FDjubq8A62Eg
         jc1WZ2clCNNweYj7pg6qEczvx0PNPkNUmjMbLLhsTrax2YbVYC/V+RUbZv9PZpn/MI
         Lze5Q0DIy7JruB4gasS/Oj+Ag5p8QJdRqEH7MwUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/11] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
Date:   Wed, 19 Aug 2020 20:03:47 -0400
Message-Id: <20200820000348.215911-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000348.215911-1-sashal@kernel.org>
References: <20200820000348.215911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eiichi Tsukata <devel@etsukata.com>

[ Upstream commit 96cf2a2c75567ff56195fe3126d497a2e7e4379f ]

If xfs_sysfs_init is called with parent_kobj == NULL, UBSAN
shows the following warning:

  UBSAN: null-ptr-deref in ./fs/xfs/xfs_sysfs.h:37:23
  member access within null pointer of type 'struct xfs_kobj'
  Call Trace:
   dump_stack+0x10e/0x195
   ubsan_type_mismatch_common+0x241/0x280
   __ubsan_handle_type_mismatch_v1+0x32/0x40
   init_xfs_fs+0x12b/0x28f
   do_one_initcall+0xdd/0x1d0
   do_initcall_level+0x151/0x1b6
   do_initcalls+0x50/0x8f
   do_basic_setup+0x29/0x2b
   kernel_init_freeable+0x19f/0x20b
   kernel_init+0x11/0x1e0
   ret_from_fork+0x22/0x30

Fix it by checking parent_kobj before the code accesses its member.

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: minor whitespace edits]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_sysfs.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index d04637181ef21..980c9429abec5 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -44,9 +44,11 @@ xfs_sysfs_init(
 	struct xfs_kobj		*parent_kobj,
 	const char		*name)
 {
+	struct kobject		*parent;
+
+	parent = parent_kobj ? &parent_kobj->kobject : NULL;
 	init_completion(&kobj->complete);
-	return kobject_init_and_add(&kobj->kobject, ktype,
-				    &parent_kobj->kobject, "%s", name);
+	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
 }
 
 static inline void
-- 
2.25.1

