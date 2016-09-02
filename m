Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DE697CA7
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 18:06:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CD148F8037
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 16:06:22 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3vZZzNiLRSk3HbMB for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2016 16:06:19 -0700 (PDT)
Date: Sat, 3 Sep 2016 09:06:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: shadow agfl indexes in the per-ag structures
Message-ID: <20160902230612.GG30056@dastard>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-3-git-send-email-david@fromorbit.com>
	<d32c1b10-107c-a1fc-3864-76223661ab71@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d32c1b10-107c-a1fc-3864-76223661ab71@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Sep 02, 2016 at 08:25:12AM -0500, Eric Sandeen wrote:
> On 9/1/16 9:27 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To verify that the AGFL contents is sane, we need to have access to
> > the indexes that tell us what part of the AGFL is active. We cannot
> > access the AGF buffer from the AGFL verifier, so we need to shadow
> > these values in the struct xfs_perag so we check them when required.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 4 ++++
> >  fs/xfs/xfs_mount.h        | 2 ++
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 23559b9..1aef556 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2255,6 +2255,7 @@ xfs_alloc_get_freelist(
> >  	be32_add_cpu(&agf->agf_flcount, -1);
> >  	xfs_trans_agflist_delta(tp, -1);
> >  	pag->pagf_flcount--;
> > +	pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
> >  	xfs_perag_put(pag);
> >  
> >  	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
> 
> Still reviewing, but this kind of jumped out at me, seems like the get/put
> functions are a bit jumbled up:

Gets cleaned up in a later patch.

> sync, should there be a wrapper to encapsulate it all?
> 
> like:
> 
> xfs_agf_{advance/drop/remove}_first(mp, agf, pagf)

Not really necessary for single use functions whose express purpose
is manipulating the agfl indexes

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
