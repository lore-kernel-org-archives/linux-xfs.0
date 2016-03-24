Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 241E47CAF
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 18:18:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E80C48F8049
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:17:57 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	w1APIkDVJ9YNYqGI for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 16:17:56 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 2/5] dax: fallback from pmd to pte on error
Date: Thu, 24 Mar 2016 17:17:27 -0600
Message-Id: <1458861450-17705-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

From: Dan Williams <dan.j.williams@intel.com>

From: Dan Williams <dan.j.williams@intel.com>

In preparation for consulting a badblocks list in pmem_direct_access(),
teach dax_pmd_fault() to fallback rather than fail immediately upon
encountering an error.  The thought being that reducing the span of the
dax request may avoid the error region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bbb2ad7..bb7e9f8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -940,8 +940,8 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		long length = dax_map_atomic(bdev, &dax);
 
 		if (length < 0) {
-			result = VM_FAULT_SIGBUS;
-			goto out;
+			dax_pmd_dbg(&bh, address, "dax-error fallback");
+			goto fallback;
 		}
 		if (length < PMD_SIZE) {
 			dax_pmd_dbg(&bh, address, "dax-length too small");
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
