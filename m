Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32BAD7CD5
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 06:56:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87E64AC002
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 04:56:26 -0700 (PDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com
	[74.125.82.68]) by cuda.sgi.com with ESMTP id k8R0apvYQyTz1Plm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 04:56:24 -0700 (PDT)
Received: by mail-wm0-f68.google.com with SMTP id e201so3738644wme.2
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 04:56:24 -0700 (PDT)
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 2/2] mm, debug: report when GFP_NO{FS,
	IO} is used explicitly from memalloc_no{fs, io}_{save,
	restore} context
Date: Tue, 26 Apr 2016 13:56:12 +0200
Message-Id: <1461671772-1269-3-git-send-email-mhocko@kernel.org>
In-Reply-To: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
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
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, Chris Mason <clm@fb.com>, Michal Hocko <mhocko@suse.com>, linux-mtd@lists.infradead.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

From: Michal Hocko <mhocko@suse.com>

THIS PATCH IS FOR TESTING ONLY AND NOT MEANT TO HIT LINUS TREE

It is desirable to reduce the direct GFP_NO{FS,IO} usage at minimum and
prefer scope usage defined by memalloc_no{fs,io}_{save,restore} API.

Let's help this process and add a debugging tool to catch when an
explicit allocation request for GFP_NO{FS,IO} is done from the scope
context. The printed stacktrace should help to identify the caller
and evaluate whether it can be changed to use a wider context or whether
it is called from another potentially dangerous context which needs
a scope protection as well.

The checks have to be enabled explicitly by debug_scope_gfp kernel
command line parameter.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 86bb5d6ddd7d..085d00280496 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3750,6 +3750,61 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static bool debug_scope_gfp;
+
+static int __init enable_debug_scope_gfp(char *unused)
+{
+	debug_scope_gfp = true;
+	return 0;
+}
+
+/*
+ * spit the stack trace if the given gfp_mask clears flags which are context
+ * wide cleared. Such a caller can remove special flags clearing and rely on
+ * the context wide mask.
+ */
+static inline void debug_scope_gfp_context(gfp_t gfp_mask)
+{
+	gfp_t restrict_mask;
+
+	if (likely(!debug_scope_gfp))
+		return;
+
+	/* both NOFS, NOIO are irrelevant when direct reclaim is disabled */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
+		return;
+
+	if (current->flags & PF_MEMALLOC_NOIO)
+		restrict_mask = __GFP_IO;
+	else if ((current->flags & PF_MEMALLOC_NOFS) && (gfp_mask & __GFP_IO))
+		restrict_mask = __GFP_FS;
+	else
+		return;
+
+	if ((gfp_mask & restrict_mask) != restrict_mask) {
+		/*
+		 * If you see this this warning then the code does:
+		 * memalloc_no{fs,io}_save()
+		 * ...
+		 *    foo()
+		 *      alloc_page(GFP_NO{FS,IO})
+		 * ...
+		 * memalloc_no{fs,io}_restore()
+		 *
+		 * allocation which is unnecessary because the scope gfp
+		 * context will do that for all allocation requests already.
+		 * If foo() is called from multiple contexts then make sure other
+		 * contexts are safe wrt. GFP_NO{FS,IO} semantic and either add
+		 * scope protection into particular paths or change the gfp mask
+		 * to GFP_KERNEL.
+		 */
+		pr_info("Unnecesarily specific gfp mask:%#x(%pGg) for the %s task wide context\n", gfp_mask, &gfp_mask,
+				(current->flags & PF_MEMALLOC_NOIO)?"NOIO":"NOFS");
+		dump_stack();
+	}
+}
+early_param("debug_scope_gfp", enable_debug_scope_gfp);
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -3796,6 +3851,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 				ac.nodemask);
 
 	/* First allocation attempt */
+	debug_scope_gfp_context(gfp_mask);
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
 	if (likely(page))
 		goto out;
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
