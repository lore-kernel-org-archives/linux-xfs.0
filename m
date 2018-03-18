Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3625 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbeCRECk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Mar 2018 00:02:40 -0400
Date: Sun, 18 Mar 2018 12:02:17 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] ext2, dax: ext2_dax_aops can be static
Message-ID: <20180318040217.GA87179@cairo>
References: <152112911591.24669.7494781212673308769.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152112911591.24669.7494781212673308769.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: kbuild-all@01.org, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, david@fromorbit.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org


Fixes: 97affa6a9d1c ("ext2, dax: introduce ext2_dax_aops")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9590712..8ea394c8 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -989,7 +989,7 @@ const struct address_space_operations ext2_nobh_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
-const struct address_space_operations ext2_dax_aops = {
+static const struct address_space_operations ext2_dax_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_dax_writepages,
 	.set_page_dirty		= noop_set_page_dirty,
