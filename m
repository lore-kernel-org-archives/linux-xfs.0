Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E0427F69
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 13:39:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 30CA88F8054
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2015 11:39:45 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	f4p60ffAHuPCbEP5 for <xfs@oss.sgi.com>;
	Wed, 23 Dec 2015 11:39:43 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v6 7/7] xfs: call dax_pfn_mkwrite() for DAX fsync/msync
Date: Wed, 23 Dec 2015 12:39:20 -0700
Message-Id: <1450899560-26708-8-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

To properly support the new DAX fsync/msync infrastructure filesystems
need to call dax_pfn_mkwrite() so that DAX can track when user pages are
dirtied.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f5392ab..40ffbb1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1603,9 +1603,8 @@ xfs_filemap_pmd_fault(
 /*
  * pfn_mkwrite was originally inteneded to ensure we capture time stamp
  * updates on write faults. In reality, it's need to serialise against
- * truncate similar to page_mkwrite. Hence we open-code dax_pfn_mkwrite()
- * here and cycle the XFS_MMAPLOCK_SHARED to ensure we serialise the fault
- * barrier in place.
+ * truncate similar to page_mkwrite. Hence we cycle the XFS_MMAPLOCK_SHARED
+ * to ensure we serialise the fault barrier in place.
  */
 static int
 xfs_filemap_pfn_mkwrite(
@@ -1628,6 +1627,8 @@ xfs_filemap_pfn_mkwrite(
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
 		ret = VM_FAULT_SIGBUS;
+	else if (IS_DAX(inode))
+		ret = dax_pfn_mkwrite(vma, vmf);
 	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-- 
2.6.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
