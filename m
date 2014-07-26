Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C3BA7F37
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 15:00:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09AD8304043
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 13:00:13 -0700 (PDT)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	nfbgTIZbzzLfEpV5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 26 Jul 2014 13:00:09 -0700 (PDT)
Received: by mail-pd0-f178.google.com with SMTP id w10so7590970pde.9
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 13:00:09 -0700 (PDT)
Date: Sat, 26 Jul 2014 12:58:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: fix direct reclaim writeback regression
Message-ID: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>

Shortly before 3.16-rc1, Dave Jones reported:

WARNING: CPU: 3 PID: 19721 at fs/xfs/xfs_aops.c:971
         xfs_vm_writepage+0x5ce/0x630 [xfs]()
CPU: 3 PID: 19721 Comm: trinity-c61 Not tainted 3.15.0+ #3
Call Trace:
 [<ffffffffc023068e>] xfs_vm_writepage+0x5ce/0x630 [xfs]
 [<ffffffff8316f759>] shrink_page_list+0x8f9/0xb90
 [<ffffffff83170123>] shrink_inactive_list+0x253/0x510
 [<ffffffff83170c93>] shrink_lruvec+0x563/0x6c0
 [<ffffffff83170e2b>] shrink_zone+0x3b/0x100
 [<ffffffff831710e1>] shrink_zones+0x1f1/0x3c0
 [<ffffffff83171414>] try_to_free_pages+0x164/0x380
 [<ffffffff83163e52>] __alloc_pages_nodemask+0x822/0xc90
 [<ffffffff831abeff>] alloc_pages_vma+0xaf/0x1c0
 [<ffffffff8318a931>] handle_mm_fault+0xa31/0xc50
etc.

 970   if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
 971                   PF_MEMALLOC))

I did not respond at the time, because a glance at the PageDirty block
in shrink_page_list() quickly shows that this is impossible: we don't do
writeback on file pages (other than tmpfs) from direct reclaim nowadays.
Dave was hallucinating, but it would have been disrespectful to say so.

However, my own /var/log/messages now shows similar complaints
WARNING: CPU: 1 PID: 28814 at fs/ext4/inode.c:1881 ext4_writepage+0xa7/0x38b()
WARNING: CPU: 0 PID: 27347 at fs/ext4/inode.c:1764 ext4_writepage+0xa7/0x38b()
from stressing some mmotm trees during July.

Could a dirty xfs or ext4 file page somehow get marked PageSwapBacked,
so fail shrink_page_list()'s page_is_file_cache() test, and so proceed
to mapping->a_ops->writepage()?

Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
freeing callback") has provided such a way to compaction: if migrating
a SwapBacked page fails, its newpage may be put back on the list for
later use with PageSwapBacked still set, and nothing will clear it.

Whether that can do anything worse than issue WARN_ON_ONCEs, and get
some statistics wrong, is unclear: easier to fix than to think through
the consequences.

Fixing it here, before the put_new_page(), addresses the bug directly,
but is probably the worst place to fix it.  Page migration is doing too
many parts of the job on too many levels: fixing it in move_to_new_page()
to complement its SetPageSwapBacked would be preferable, except why is it
(and newpage->mapping and newpage->index) done there, rather than down in
migrate_page_move_mapping(), once we are sure of success?  Not a cleanup
to get into right now, especially not with memcg cleanups coming in 3.17.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
+++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
@@ -988,9 +988,10 @@ out:
 	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
 	 * during isolation.
 	 */
-	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
+		ClearPageSwapBacked(newpage);
 		put_new_page(newpage, private);
-	else
+	} else
 		putback_lru_page(newpage);
 
 	if (result) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
