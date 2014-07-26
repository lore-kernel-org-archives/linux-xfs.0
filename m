Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2EDE7F47
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 18:17:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D10DA304039
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 16:17:11 -0700 (PDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id i0xsEjLHC9kttqXF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 26 Jul 2014 16:17:10 -0700 (PDT)
Received: by mail-pa0-f47.google.com with SMTP id kx10so8143546pab.34
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2014 16:17:09 -0700 (PDT)
Date: Sat, 26 Jul 2014 16:15:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: fix direct reclaim writeback regression
In-Reply-To: <53D42F80.7000000@suse.cz>
Message-ID: <alpine.LSU.2.11.1407261600570.14577@eggly.anvils>
References: <alpine.LSU.2.11.1407261248140.13796@eggly.anvils>
	<53D42F80.7000000@suse.cz>
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
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sun, 27 Jul 2014, Vlastimil Babka wrote:
> On 07/26/2014 09:58 PM, Hugh Dickins wrote:
> > Yes, 3.16-rc1's 68711a746345 ("mm, migration: add destination page
> > freeing callback") has provided such a way to compaction: if migrating
> > a SwapBacked page fails, its newpage may be put back on the list for
> > later use with PageSwapBacked still set, and nothing will clear it.
> 
> Ugh good catch. So is this the only flag that can become "stray" like
> this? It seems so from quick check...

Yes, it seemed so to me too; but I would prefer a regime in which
we only mess with newpage once it's sure to be successful.

> > --- 3.16-rc6/mm/migrate.c	2014-06-29 15:22:10.584003935 -0700
> > +++ linux/mm/migrate.c	2014-07-26 11:28:34.488126591 -0700
> > @@ -988,9 +988,10 @@ out:
> >  	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
> >  	 * during isolation.
> >  	 */
> > -	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
> > +	if (rc != MIGRATEPAGE_SUCCESS && put_new_page) {
> > +		ClearPageSwapBacked(newpage);
> >  		put_new_page(newpage, private);
> > -	else
> > +	} else
> >  		putback_lru_page(newpage);
> >  
> >  	if (result) {
> 
> What about unmap_and_move_huge_page()? Seems to me it can also get the
> same stray flag. Although compaction, who is the only user so far of
> custom put_new_page, wouldn't of course migrate huge pages. But might
> bite us in the future, if a new user appears before a cleanup...

I think you're right, thanks for pointing it out.  We don't have an
actual bug there at present, so no need to rush back and fix up the
patch now in Linus's tree; but unmap_and_move_huge_page() gives
another reason why my choice was "probably the worst place to fix it".

More reason for a cleanup, but not while the memcg interface is in flux.
In mmotm I'm a little anxious about the PageAnon case when newpage's
mapping is left set, I wonder if that might also be problematic: I
mailed Hannes privately to think about that - perhaps that will give
more impulse for a cleanup, though I've not noticed any bug from it.

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
