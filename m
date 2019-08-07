Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33940 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfHGBdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 21:33:52 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v3 04/41] net/rds: convert put_page() to put_user_page*()
Date: Tue,  6 Aug 2019 18:33:03 -0700
Message-Id: <20190807013340.9706-5-jhubbard@nvidia.com>
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/rds/info.c    |  5 ++---
 net/rds/message.c |  2 +-
 net/rds/rdma.c    | 15 +++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index 03f6fd56d237..ca6af2889adf 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -162,7 +162,6 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 	struct rds_info_lengths lens;
 	unsigned long nr_pages = 0;
 	unsigned long start;
-	unsigned long i;
 	rds_info_func func;
 	struct page **pages = NULL;
 	int ret;
@@ -235,8 +234,8 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 		ret = -EFAULT;
 
 out:
-	for (i = 0; pages && i < nr_pages; i++)
-		put_page(pages[i]);
+	if (pages)
+		put_user_pages(pages, nr_pages);
 	kfree(pages);
 
 	return ret;
diff --git a/net/rds/message.c b/net/rds/message.c
index 50f13f1d4ae0..d7b0d266c437 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -404,7 +404,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			int i;
 
 			for (i = 0; i < rm->data.op_nents; i++)
-				put_page(sg_page(&rm->data.op_sg[i]));
+				put_user_page(sg_page(&rm->data.op_sg[i]));
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
 			mm_unaccount_pinned_pages(mmp);
 			ret = -EFAULT;
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 916f5ec373d8..6762e8696b99 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -162,8 +162,7 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
 				  pages);
 
 	if (ret >= 0 && ret < nr_pages) {
-		while (ret--)
-			put_page(pages[ret]);
+		put_user_pages(pages, ret);
 		ret = -EFAULT;
 	}
 
@@ -276,7 +275,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	if (IS_ERR(trans_private)) {
 		for (i = 0 ; i < nents; i++)
-			put_page(sg_page(&sg[i]));
+			put_user_page(sg_page(&sg[i]));
 		kfree(sg);
 		ret = PTR_ERR(trans_private);
 		goto out;
@@ -464,9 +463,10 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 		 * to local memory */
 		if (!ro->op_write) {
 			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
+			put_user_pages_dirty_lock(&page, 1, true);
+		} else {
+			put_user_page(page);
 		}
-		put_page(page);
 	}
 
 	kfree(ro->op_notifier);
@@ -481,8 +481,7 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	/* Mark page dirty if it was possibly modified, which
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
-	set_page_dirty(page);
-	put_page(page);
+	put_user_pages_dirty_lock(&page, 1, true);
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
@@ -867,7 +866,7 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	return ret;
 err:
 	if (page)
-		put_page(page);
+		put_user_page(page);
 	rm->atomic.op_active = 0;
 	kfree(rm->atomic.op_notifier);
 
-- 
2.22.0
