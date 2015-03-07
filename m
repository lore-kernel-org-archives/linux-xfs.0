Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8160E7F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 18:21:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C52D304062
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 16:21:15 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id AddpqCvEBFLBQCVf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 16:21:13 -0800 (PST)
Date: Fri, 6 Mar 2015 19:20:55 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150307002055.GA29679@phnom.home.cmpxchg.org>
References: <20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard> <54F42FEA.1020404@suse.cz>
	<20150302223154.GJ18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150302223154.GJ18360@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rientjes@google.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, Vlastimil Babka <vbabka@suse.cz>

On Tue, Mar 03, 2015 at 09:31:54AM +1100, Dave Chinner wrote:
> What we don't know is how many objects we might need to scan to find
> the objects we will eventually modify.  Here's an (admittedly
> extreme) example to demonstrate a worst case scenario: allocate a
> 64k data extent. Because it is an exact size allocation, we look it
> up in the by-size free space btree. Free space is fragmented, so
> there are about a million 64k free space extents in the tree.
> 
> Once we find the first 64k extent, we search them to find the best
> locality target match.  The btree records are 16 bytes each, so we
> fit roughly 500 to a 4k block. Say we search half the extents to
> find the best match - i.e. we walk a thousand leaf blocks before
> finding the match we want, and modify that leaf block.
> 
> Now, the modification removed an entry from the leaf and tht
> triggers leaf merge thresholds, so a merge with the 1002nd block
> occurs. That block now demand pages in and we then modify and join
> it to the transaction. Now we walk back up the btree to update
> indexes, merging blocks all the way back up to the root.  We have a
> worst case size btree (5 levels) and we merge at every level meaning
> we demand page another 8 btree blocks and modify them.
> 
> In this case, we've demand paged ~1010 btree blocks, but only
> modified 10 of them. i.e. the memory we consumed permanently was
> only 10 4k buffers (approx. 10 slab and 10 page allocations), but
> the allocation demand was 2 orders of magnitude more than the
> unreclaimable memory consumption of the btree modification.
> 
> I hope you start to see the scope of the problem now...

Isn't this bounded one way or another?  Sure, the inaccuracy itself is
high, but when you put the absolute numbers in perspective it really
doesn't seem to matter: with your extreme case of 3MB per transaction,
you can still run 5k+ of them in parallel on a small 16G machine.
Occupy a generous 75% of RAM with anonymous pages, and you can STILL
run over a thousand transactions concurrently.  That would seem like a
decent pipeline to keep the storage device occupied.

The level of precision that you are asking for comes with complexity
and fragility that I'm not convinced is necessary, or justified.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
