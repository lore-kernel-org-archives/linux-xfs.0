Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 256547F37
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 17:45:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6FA7AC001
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 15:45:26 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3WIqVJLmAULfCvWa (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 26 Jul 2014 15:45:24 -0700 (PDT)
Message-ID: <53D42F80.7000000@suse.cz>
Date: Sun, 27 Jul 2014 00:45:20 +0200
From: Vlastimil Babka <vbabka@suse.cz>
MIME-Version: 1.0
Subject: Re: [PATCH] mm: fix direct reclaim writeback regression
References: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
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
To: Hugh Dickins <hughd@google.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>

On 07/26/2014 09:58 PM, Hugh Dickins wrote:
> Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
> freeing callback") has provided such a way to compaction: if migrating
> a SwapBacked page fails, its newpage may be put back on the list for
> later use with PageSwapBacked still set, and nothing will clear it.

Ugh good catch. So is this the only flag that can become "stray" like
this? It seems so from quick check...

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
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> 
>  mm/migrate.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
> +++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
> @@ -988,9 +988,10 @@ out:
>  	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
>  	 * during isolation.
>  	 */
> -	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
> +	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
> +		ClearPageSwapBacked(newpage);
>  		put_new_page(newpage, private);
> -	else
> +	} else
>  		putback_lru_page(newpage);
>  
>  	if (result) {

What about unmap_and_move_huge_page()? Seems to me it can also get the
same stray flag. Although compaction, who is the only user so far of
custom put_new_page, wouldn't of course migrate huge pages. But might
bite us in the future, if a new user appears before a cleanup...

Vlastimil


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
