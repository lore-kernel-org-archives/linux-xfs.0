Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E737E7F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 09:03:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75A2CAC007
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 07:03:40 -0700 (PDT)
Received: from zene.cmpxchg.org (zene.cmpxchg.org [85.214.230.12]) by
	cuda.sgi.com with ESMTP id wQ7xm5BGI1m2i7DX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 07:03:38 -0700 (PDT)
Date: Mon, 28 Jul 2014 10:01:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix direct reclaim writeback regression
Message-ID: <20140728140157.GM1725@cmpxchg.org>
References: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
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
To: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Jul 26, 2014 at 12:58:23PM -0700, Hugh Dickins wrote:
> Shortly before 3.16-rc1, Dave Jones reported:
> 
> WARNING: CPU: 3 PID: 19721 at fs/xfs/xfs_aops.c:971
>          xfs_vm_writepage+0x5ce/0x630 [xfs]()
> CPU: 3 PID: 19721 Comm: trinity-c61 Not tainted 3.15.0+ #3
> Call Trace:
>  [<ffffffffc023068e>] xfs_vm_writepage+0x5ce/0x630 [xfs]
>  [<ffffffff8316f759>] shrink_page_list+0x8f9/0xb90
>  [<ffffffff83170123>] shrink_inactive_list+0x253/0x510
>  [<ffffffff83170c93>] shrink_lruvec+0x563/0x6c0
>  [<ffffffff83170e2b>] shrink_zone+0x3b/0x100
>  [<ffffffff831710e1>] shrink_zones+0x1f1/0x3c0
>  [<ffffffff83171414>] try_to_free_pages+0x164/0x380
>  [<ffffffff83163e52>] __alloc_pages_nodemask+0x822/0xc90
>  [<ffffffff831abeff>] alloc_pages_vma+0xaf/0x1c0
>  [<ffffffff8318a931>] handle_mm_fault+0xa31/0xc50
> etc.
> 
>  970   if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
>  971                   PF_MEMALLOC))
> 
> I did not respond at the time, because a glance at the PageDirty block
> in shrink_page_list() quickly shows that this is impossible: we don't do
> writeback on file pages (other than tmpfs) from direct reclaim nowadays.
> Dave was hallucinating, but it would have been disrespectful to say so.
> 
> However, my own /var/log/messages now shows similar complaints
> WARNING: CPU: 1 PID: 28814 at fs/ext4/inode.c:1881 ext4_writepage+0xa7/0x38b()
> WARNING: CPU: 0 PID: 27347 at fs/ext4/inode.c:1764 ext4_writepage+0xa7/0x38b()
> from stressing some mmotm trees during July.
> 
> Could a dirty xfs or ext4 file page somehow get marked PageSwapBacked,
> so fail shrink_page_list()'s page_is_file_cache() test, and so proceed
> to mapping->a_ops->writepage()?
> 
> Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
> freeing callback") has provided such a way to compaction: if migrating
> a SwapBacked page fails, its newpage may be put back on the list for
> later use with PageSwapBacked still set, and nothing will clear it.
>
> Whether that can do anything worse than issue WARN_ON_ONCEs, and get
> some statistics wrong, is unclear: easier to fix than to think through
> the consequences.
> 
> Fixing it here, before the put_new_page(), addresses the bug directly,
> but is probably the worst place to fix it.  Page migration is doing too
> many parts of the job on too many levels: fixing it in move_to_new_page()
> to complement its SetPageSwapBacked would be preferable, except why is it
> (and newpage->mapping and newpage->index) done there, rather than down in
> migrate_page_move_mapping(), once we are sure of success?  Not a cleanup
> to get into right now, especially not with memcg cleanups coming in 3.17.

That needs verification that no ->migratepage() expects mapping
(working PageAnon()) and index to be set up on newpage.

The freelist putback looks quite fragile, we should probably add
something like free_pages_prepare() / free_page_check() in there.

> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
