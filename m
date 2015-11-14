Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC9D27F5D
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 18:07:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D6CAAC011
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 16:07:08 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	hTfsQfhoq1yfMYkr for <xfs@oss.sgi.com>;
	Fri, 13 Nov 2015 16:07:05 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
Date: Fri, 13 Nov 2015 17:06:42 -0700
Message-Id: <1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
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

Currently the PMEM driver doesn't accept REQ_FLUSH or REQ_FUA bios.  These
are sent down via blkdev_issue_flush() in response to a fsync() or msync()
and are used by filesystems to order their metadata, among other things.

When we get an msync() or fsync() it is the responsibility of the DAX code
to flush all dirty pages to media.  The PMEM driver then just has issue a
wmb_pmem() in response to the REQ_FLUSH to ensure that before we return all
the flushed data has been durably stored on the media.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/pmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0ba6a97..b914d66 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (do_acct)
 		nd_iostat_end(bio, start);
 
-	if (bio_data_dir(bio))
+	if (bio_data_dir(bio) || (bio->bi_rw & (REQ_FLUSH|REQ_FUA)))
 		wmb_pmem();
 
 	bio_endio(bio);
@@ -189,6 +189,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+	blk_queue_flush(pmem->pmem_queue, REQ_FLUSH|REQ_FUA);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
 
 	disk = alloc_disk(0);
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
