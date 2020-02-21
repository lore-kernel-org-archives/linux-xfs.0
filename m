Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73957C11D28
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49CE4208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 00:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgBUAlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:41:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:20199 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729461AbgBUAlj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Feb 2020 19:41:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 16:41:39 -0800
X-IronPort-AV: E=Sophos;i="5.70,466,1574150400"; 
   d="scan'208";a="236419934"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 16:41:37 -0800
From:   ira.weiny@intel.com
To:     linux-kernel@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 01/13] fs/xfs: Remove unnecessary initialization of i_rwsem
Date:   Thu, 20 Feb 2020 16:41:22 -0800
Message-Id: <20200221004134.30599-2-ira.weiny@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200221004134.30599-1-ira.weiny@intel.com>
References: <20200221004134.30599-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

xfs_reinit_inode() -> inode_init_always() already handles calling
init_rwsem(i_rwsem).  Doing so again is unneeded.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
New for V4:

NOTE: This was found while ensuring the new i_aops_sem was properly
handled.  It seems like this is a layering violation so I think it is
worth cleaning up so as to not confuse others.
---
 fs/xfs/xfs_icache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8dc2e5414276..836a1f09be03 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -419,6 +419,7 @@ xfs_iget_cache_hit(
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 
+		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 		error = xfs_reinit_inode(mp, inode);
 		if (error) {
 			bool wake;
@@ -452,9 +453,6 @@ xfs_iget_cache_hit(
 		ip->i_sick = 0;
 		ip->i_checked = 0;
 
-		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-		init_rwsem(&inode->i_rwsem);
-
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
 	} else {
-- 
2.21.0

