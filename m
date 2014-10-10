Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA9D77F69
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9BD28F8050
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id WKtWKuCXWiKl8Lun (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mm: Fixup pagecache_isize_extended() definitions for
	!CONFIG_MMU
Date: Fri, 10 Oct 2014 16:23:26 +0200
Message-Id: <1412951028-4085-22-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

For !CONFIG_MMU systems we defined pagecache_isize_extended() in both
include/linux/mm.h and mm/truncate.c which causes compilation error.
Although pagecache_isize_extended() doesn't do anything useful for
!CONFIG_MMU systems, it could do something in future and it's overhead
isn't huge. So don't try to be too smart and remove !CONFIG_MMU
definition of pagecache_isize_extended().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0e53e5a3b17..5005464fe012 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1155,14 +1155,7 @@ static inline void unmap_shared_mapping_range(struct address_space *mapping,
 
 extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
-#ifdef CONFIG_MMU
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
-#else
-static inline void pagecache_isize_extended(struct inode *inode, loff_t from,
-					    loff_t to)
-{
-}
-#endif
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
