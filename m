Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D7EC2BBFD
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 04:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D72206E9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 04:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405010AbgDNEBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 00:01:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:61616 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgDNEAs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Apr 2020 00:00:48 -0400
IronPort-SDR: +QZ6YAMwmEC5weDal5VlXOA3YbM7BAz7YutOeYNNIMDPtXzRdNnm1MOBrgAAf+aPRaqgtTL2Hj
 DcBtwuIDebuA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 21:00:47 -0700
IronPort-SDR: /vezDxyYNg30j1gO5/hvVLA4z6VaporjKFteFDpq7AIxmDSuWr+A+ECKUegOUqtdyh42rSGGuH
 fY3mM13b9f2g==
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="241859904"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 21:00:46 -0700
From:   ira.weiny@intel.com
To:     linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC 3/8] fs/ext4: Disallow encryption if inode is DAX
Date:   Mon, 13 Apr 2020 21:00:25 -0700
Message-Id: <20200414040030.1802884-4-ira.weiny@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414040030.1802884-1-ira.weiny@intel.com>
References: <20200414040030.1802884-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Encryption and DAX are incompatible.  Changing the DAX mode due to a
change in Encryption mode is wrong without a corresponding
address_space_operations update.

Make the 2 options mutually exclusive by returning an error if DAX was
set first.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/ext4/super.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0c7c4adb664e..b14863058115 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1325,7 +1325,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (inode->i_ino == EXT4_ROOT_INO)
 		return -EPERM;
 
-	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+	if (WARN_ON_ONCE(IS_DAX(inode)))
 		return -EINVAL;
 
 	res = ext4_convert_inline_data(inode);
@@ -1349,10 +1349,6 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 			ext4_clear_inode_state(inode,
 					EXT4_STATE_MAY_INLINE_DATA);
-			/*
-			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-			 * S_DAX may be disabled
-			 */
 			ext4_set_inode_flags(inode);
 		}
 		return res;
@@ -1376,10 +1372,6 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 				    ctx, len, 0);
 	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-		/*
-		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-		 * S_DAX may be disabled
-		 */
 		ext4_set_inode_flags(inode);
 		res = ext4_mark_inode_dirty(handle, inode);
 		if (res)
-- 
2.25.1

