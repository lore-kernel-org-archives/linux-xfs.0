Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A9847F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 19:38:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 164868F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 17:38:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	t7mxt7rW6aqoJ9sU for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 17:38:25 -0700 (PDT)
Date: Fri, 10 Jul 2015 10:37:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/20] xfs: rmap btree requires more reserved free space
Message-ID: <20150710003744.GE7943@dastard>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-14-git-send-email-david@fromorbit.com>
	<20150625164103.GC36162@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150625164103.GC36162@bfoster.bfoster>
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

On Thu, Jun 25, 2015 at 12:41:04PM -0400, Brian Foster wrote:
> On Wed, Jun 03, 2015 at 04:04:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The rmap btree is allocated from the AGFL, which means we have to
> > ensure ENOSPC is reported to userspace before we run out of free
> > space in each AG. The last allocation in an AG can cause a full
> > height rmap btree split, and that means we have to reserve at least
> > this many blocks *in each AG* to be placed on the AGFL at ENOSPC.
> > Update the various space calculation functiosn to handle this.
> > 
> > Also, because the macros are now executing conditional code and are called quite
> > frequently, convert them to functions that initialise varaibles in the struct
> > xfs_mount, use the new variables everywhere and document the calculations
> > better.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> > + * so we set the number of set-aside blocks to 4 + 4*agcount when not using rmap
> > + * btrees.
> > + *
> > + * When rmap btrees are active, we have to consider that using the last block in
> > + * the AG can cause a full height rmap btree split and we need enough blocks on
> > + * the AGFL to be able to handle this. That means we have, in addition to the
> > + * above consideration, another (2 * mp->m_ag_levels) - 1 blocks required to be
> > + * available to the free list.
> > + */
> 
> BTW, I think I get the 2 block per level log requirement in that a split
> requires logging the two blocks involved. Where does the 2nd block per
> level come in as an allocation requirement?

Yup, you are right, I've mixed the two conditions up. Split only
requires an extra block per level, plus a new root block. e.g. see
xfs_alloc_min_freelist()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
