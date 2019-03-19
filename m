Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726740AbfCSVL3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Mar 2019 17:11:29 -0400
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC 2/2] mm, sl[aou]b: test whether kmalloc() alignment works as expected
Date: Tue, 19 Mar 2019 22:11:08 +0100
Message-Id: <20190319211108.15495-3-vbabka@suse.cz>
In-Reply-To: <20190319211108.15495-1-vbabka@suse.cz>
References: <20190319211108.15495-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ming Lei <ming.lei@redhat.com>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>

Quick and dirty init test that kmalloc() alignment works as expected for
power-of-two sizes after the previous patch.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index e591d5688558..de10ca9640e0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1621,3 +1621,22 @@ int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 	return 0;
 }
 ALLOW_ERROR_INJECTION(should_failslab, ERRNO);
+
+static int __init slab_kmalloc_test(void)
+{
+	int i;
+
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
+		unsigned int size = 1 << i;
+		void * obj = kmalloc(size, GFP_KERNEL);
+		unsigned long objaddr = (unsigned long) obj;
+
+		printk("Size %u obj %px alignment: %s", size, obj,
+			(((objaddr & (size - 1)) == 0) ? "OK" : "WRONG"));
+		kfree(obj);
+	}
+
+	return 0;
+}
+
+__initcall(slab_kmalloc_test);
-- 
2.21.0
