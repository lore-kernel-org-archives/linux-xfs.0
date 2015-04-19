Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65D7229DFE
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2015 18:59:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 375D3304032
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2015 16:59:42 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GWNJFSZDrFPoEelM for <xfs@oss.sgi.com>;
	Sun, 19 Apr 2015 16:59:35 -0700 (PDT)
Date: Mon, 20 Apr 2015 09:59:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150419235932.GI21261@dastard>
References: <20150417125843.GA63169@bfoster.bfoster>
	<20150417130120.GB63169@bfoster.bfoster>
	<20150418231745.GH21261@dastard>
	<20150419133301.GA41769@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150419133301.GA41769@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Apr 19, 2015 at 09:33:01AM -0400, Brian Foster wrote:
> On Sun, Apr 19, 2015 at 09:17:45AM +1000, Dave Chinner wrote:
> > [compund reply]
> > 
> > On Fri, Apr 17, 2015 at 08:58:44AM -0400, Brian Foster wrote:
> > > On Fri, Apr 17, 2015 at 08:28:29AM +1000, Dave Chinner wrote:
...
> > > Even if that is the case, it seems at some level this alters the
> > > semantics of the extent size hint. Maybe that's fine and we just
> > > document it such that rather than extent size hints potentially
> > > resulting in 2x allocations, unaligned I/Os simply result in multiple
> > > aligned allocations. IIUC, that shouldn't really have much user visible
> > > impact, if at all..?
> > 
> > I don't think it has any visible user impact at all, just a slight
> > difference in CPU usage. We'll still end up with the same allocation
> > being done because we hold the AGF locked over both the allocations,
> > and the "contiguous allocation block target" should result in the
> > same free space extents being chosen as if it was a single
> > allocation...
> 
> Indeed, a bit of a longer path for the overall allocation... and given
> that the purpose of the hint is to cause larger allocations, we'll
> naturally end up doing less of them overall for a given workload.
> 
> The idea that the same allocation is guaranteed doesn't seem always the
> case, however. If we bubble up out of xfs_bmapi_write(), the calling
> code commits and starts a new transaction. It does look like the
> "first_block" mechanism will certainly try to pick up where it left off,
> if I'm following that correctly, so perhaps that is the real world
> result most of the time (just as an optimization as opposed to a hard
> guarantee).

Right, that's effectively what will happen - other mechanisms in the
allocator will give contiguous allocation, so we won't notice
anything unusual in most cases.

> That still seems reasonable to me regardless since we're still doing
> extent size allocations. I don't see any major reason why the hint
> mechanism needs to guarantee everything is single allocation as opposed
> to just ensuring allocations are of the requested size, provided the
> file mapping allows it. The way I understand it, we're just disabling a
> small optimization that happens to cause problems under certain
> conditions. FWIW, another approach could be to limit the scope of the
> optimization (e.g., do the outward rounding depending on the size of the
> hint with respect to maxextlen), but at that point we're getting into
> territory where it makes things even harder to test for questionable
> value in return...

Well, that's effectively what the change does - it only rounds
inward if the alignment result is larger than MAXEXTLEN. So in the
majority of cases we aren't ever going to trigger this inward
rounding case and that's likely why it's not been noticed as being
broken. And why we need a fstest to cover this case ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
