Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43311 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbfHGBed (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 21:34:33 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v3 29/41] mm/memory.c: convert put_page() to put_user_page*()
Date: Tue,  6 Aug 2019 18:33:28 -0700
Message-Id: <20190807013340.9706-30-jhubbard@nvidia.com>
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Huang Ying <ying.huang@intel.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@surriel.com>, Souptick Joarder <jrdr.linux@gmail.com>, Will Deacon <will.deacon@arm.com>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e2bb51b6242e..8870968496ea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4337,7 +4337,7 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 						    buf, maddr + offset, bytes);
 			}
 			kunmap(page);
-			put_page(page);
+			put_user_page(page);
 		}
 		len -= bytes;
 		buf += bytes;
-- 
2.22.0
