Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47054 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbfHGBeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 21:34:31 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v3 28/41] mm/gup_benchmark.c: convert put_page() to put_user_page*()
Date: Tue,  6 Aug 2019 18:33:27 -0700
Message-Id: <20190807013340.9706-29-jhubbard@nvidia.com>
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Keith Busch <keith.busch@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Michael S . Tsirkin" <mst@redhat.com>, YueHaibing <yuehaibing@huawei.com>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Reviewed-by: Keith Busch <keith.busch@intel.com>

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup_benchmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7dd602d7f8db..515ac8eeb6ee 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -79,7 +79,7 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 	for (i = 0; i < nr_pages; i++) {
 		if (!pages[i])
 			break;
-		put_page(pages[i]);
+		put_user_page(pages[i]);
 	}
 	end_time = ktime_get();
 	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
-- 
2.22.0
