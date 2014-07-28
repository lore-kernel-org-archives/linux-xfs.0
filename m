Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F36F7F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 09:24:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1982DAC005
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 07:24:06 -0700 (PDT)
Received: from zene.cmpxchg.org (zene.cmpxchg.org [85.214.230.12]) by
	cuda.sgi.com with ESMTP id CzqGv4pzkqDHCMhx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 07:24:05 -0700 (PDT)
Date: Mon, 28 Jul 2014 10:23:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix direct reclaim writeback regression
Message-ID: <20140728142313.GN1725@cmpxchg.org>
References: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
	<53D42F80.7000000@suse.cz>
	<alpine.LSU.2.11.1407261600570.14577@eggly.anvils>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407261600570.14577@eggly.anvils>
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
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>

On Sat, Jul 26, 2014 at 04:15:25PM -0700, Hugh Dickins wrote:
> On Sun, 27 Jul 2014, Vlastimil Babka wrote:
> > On 07/26/2014 09:58 PM, Hugh Dickins wrote:
> > > Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
> > > freeing callback") has provided such a way to compaction: if migrating
> > > a SwapBacked page fails, its newpage may be put back on the list for
> > > later use with PageSwapBacked still set, and nothing will clear it.
> > 
> > Ugh good catch. So is this the only flag that can become "stray" like
> > this? It seems so from quick check...
> 
> Yes, it seemed so to me too; but I would prefer a regime in which
> we only mess with newpage once it's sure to be successful.
> 
> > > --- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
> > > +++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
> > > @@ -988,9 +988,10 @@ out:
> > >  	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
> > >  	 * during isolation.
> > >  	 */
> > > -	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
> > > +	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
> > > +		ClearPageSwapBacked(newpage);
> > >  		put_new_page(newpage, private);
> > > -	else
> > > +	} else
> > >  		putback_lru_page(newpage);
> > >  
> > >  	if (result) {
> > 
> > What about unmap_and_move_huge_page()? Seems to me it can also get the
> > same stray flag. Although compaction, who is the only user so far of
> > custom put_new_page, wouldn't of course migrate huge pages. But might
> > bite us in the future, if a new user appears before a cleanup...
> 
> I think you're right, thanks for pointing it out.  We don't have an
> actual bug there at present, so no need to rush back and fix up the
> patch now in Linus's tree; but unmap_and_move_huge_page() gives
> another reason why my choice was "probably the worst place to fix it".
> 
> More reason for a cleanup, but not while the memcg interface is in flux.
> In mmotm I'm a little anxious about the PageAnon case when newpage's
> mapping is left set, I wonder if that might also be problematic: I
> mailed Hannes privately to think about that - perhaps that will give
> more impulse for a cleanup, though I've not noticed any bug from it.

I made that change for oldpage because uncharge in the final put_page
relies on PageAnon() to work for statistics.

The newpage case could have been left alone, but it looked like an
anomaly to me - anonymous mappings are usually sticky and only cleared
by the page allocator - so I was eager to make the cases symmetrical.
I don't see a bug there because if the page is reused its mapping will
be overwritten right away, and if freed the allocator will reset it.

mem_cgroup_migrate() has since changed to fully uncharge the old page
and not leave this task to the final put_page, so ->mapping does not
need to be maintained past that point.  I'll send a revert of these
conditional ->mapping resets to Andrew.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
