Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B704F7CA3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 20:03:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8774F8F8035
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 18:03:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GkDOMVdEEkIZRKTT for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 18:03:22 -0700 (PDT)
Date: Wed, 22 Jun 2016 11:03:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160622010320.GR12670@dastard>
References: <20160520001714.GC26977@dastard>
	<20160601131758.GO26601@dhcp22.suse.cz>
	<20160601181617.GV3190@twins.programming.kicks-ass.net>
	<20160602145048.GS1995@dhcp22.suse.cz>
	<20160602151116.GD3190@twins.programming.kicks-ass.net>
	<20160602154619.GU1995@dhcp22.suse.cz>
	<20160602232254.GR12670@dastard>
	<20160606122022.GH11895@dhcp22.suse.cz>
	<20160615072154.GF26977@dastard>
	<20160621142628.GG30848@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160621142628.GG30848@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, Qu Wenruo <quwenruo@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>

On Tue, Jun 21, 2016 at 04:26:28PM +0200, Michal Hocko wrote:
> On Wed 15-06-16 17:21:54, Dave Chinner wrote:
> [...]
> > Hopefully you can see the complexity of the issue - for an allocation
> > in the bmap btree code that could occur outside both inside and
> > outside of a transaction context, we've got to work out which of
> > those ~60 high level entry points would need to be annotated. And
> > then we have to ensure that in future we don't miss adding or
> > removing an annotation as we change the code deep inside the btree
> > implementation. It's the latter that is the long term maintainence
> > problem the hihg-level annotation approach introduces.
> 
> Sure I can see the complexity here. I might still see this over
> simplified but I originally thought that the annotation would be used at
> the highest level which never gets called from the transaction or other
> NOFS context. So all the layers down would inherit that automatically. I
> guess that such a place can be identified from the lockdep report by a
> trained eye.

Which, as I said before, effectively becomes "turn off lockdep
reclaim context checking at all XFS entry points". Yes, we could do
that, but it's a "big hammer" solution and there are more entry
points than there are memory allocations that need annotations....

> > > > I think such an annotation approach really requires per-alloc site
> > > > annotation, the reason for it should be more obvious from the
> > > > context. e.g. any function that does memory alloc and takes an
> > > > optional transaction context needs annotation. Hence, from an XFS
> > > > perspective, I think it makes more sense to add a new KM_ flag to
> > > > indicate this call site requirement, then jump through whatever
> > > > lockdep hoop is required within the kmem_* allocation wrappers.
> > > > e.g, we can ignore the new KM_* flag if we are in a transaction
> > > > context and so the flag is only activated in the situations were
> > > > we currently enforce an external GFP_NOFS context from the call
> > > > site.....
> > > 
> > > Hmm, I thought we would achive this by using the scope GFP_NOFS usage
> > > which would mark those transaction related conctexts and no lockdep
> > > specific workarounds would be needed...
> > 
> > There are allocations outside transaction context which need to be
> > GFP_NOFS - this is what KM_NOFS was originally intended for.
> 
> Is it feasible to mark those by the scope NOFS api as well and drop
> the direct KM_NOFS usage? This should help to identify those that are
> lockdep only and use the annotation to prevent from the false positives.

I don't understand what you are suggesting here. This all started
because we use GFP_NOFS in a handful of places to shut up lockdep
and you didn't want us to use GFP_NOFS like that. Now it sounds to
me like you are advocating setting unconditional GFP_NOFS allocation
contexts for entire XFS code paths - whether it's necessary or
not - to avoid problems with lockdep false positives.

I'm clearly not understanding something here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
