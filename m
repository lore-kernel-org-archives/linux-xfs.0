Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C50717F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 12:01:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3909304039
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 10:01:22 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id Ll1yowWRgGXE1HOl for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 10:01:20 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v7 1/9] dax: fix NULL pointer dereference in __dax_dbg()
Date: Wed,  6 Jan 2016 11:00:55 -0700
Message-Id: <1452103263-1592-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
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

__dax_dbg() currently assumes that bh->b_bdev is non-NULL, passing it into
bdevname() where is is dereferenced.  This assumption isn't always true -
when called for reads of holes, ext4_dax_mmap_get_block() returns a buffer
head where bh->b_bdev is never set.  I hit this BUG while testing the DAX
PMD fault path.

Instead, verify that we have a valid bh->b_bdev, else just say "unknown"
for the block device.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7af8797..03cc4a3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -563,7 +563,12 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
 {
 	if (bh) {
 		char bname[BDEVNAME_SIZE];
-		bdevname(bh->b_bdev, bname);
+
+		if (bh->b_bdev)
+			bdevname(bh->b_bdev, bname);
+		else
+			snprintf(bname, BDEVNAME_SIZE, "unknown");
+
 		pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
 			"length %zd fallback: %s\n", fn, current->comm,
 			address, bname, bh->b_state, (u64)bh->b_blocknr,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
