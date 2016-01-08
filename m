Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D14C27F51
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 23:28:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B62BA304039
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 21:28:15 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id ApuzZACdMC0luqc8 for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 21:28:13 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 1/9] dax: fix NULL pointer dereference in __dax_dbg()
Date: Thu,  7 Jan 2016 22:27:51 -0700
Message-Id: <1452230879-18117-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1452230879-18117-1-git-send-email-ross.zwisler@linux.intel.com>
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

In __dax_pmd_fault() we currently assume that get_block() will always set
bh.b_bdev and we unconditionally dereference it in __dax_dbg().  This
assumption isn't always true - when called for reads of holes
ext4_dax_mmap_get_block() returns a buffer head where bh->b_bdev is never
set.  I hit this BUG while testing the DAX PMD fault path.

Instead, initialize bh.b_bdev before passing bh into get_block().  It is
possible that the filesystem's get_block() will update bh.b_bdev, and this
is fine - we just want to initialize bh.b_bdev to something reasonable so
that the calls to __dax_dbg() work and print something useful.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index 7af8797..513bba5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -624,6 +624,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
 
 	bh.b_size = PMD_SIZE;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
