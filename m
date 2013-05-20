Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE7407F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:04:21 -0500 (CDT)
Date: Mon, 20 May 2013 17:04:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/14] xfs: remote attribute allocation may be contiguous
Message-ID: <20130520220418.GF20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-9-git-send-email-david@fromorbit.com>
	<519A7395.9060806@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519A7395.9060806@redhat.com>
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

On Mon, May 20, 2013 at 03:03:49PM -0400, Brian Foster wrote:
> On 05/19/2013 07:51 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When CRCs are enabled, there may be multiple allocations made if the
> > headers cause a length overflow. This, however, does not mean that
> > the number of headers required increases, as the second and
> > subsequent extents may be contiguous with the previous extent. Hence
> > when we map the extents to write the attribute data, we may end up
> > with less extents than allocations made. Hence the assertion that we
> > consume th enumber of headers we calculated in the allocation loop
	    the 

> > is incorrect and needs to be removed.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_attr_remote.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> > index dee8446..aad95b0 100644
> > --- a/fs/xfs/xfs_attr_remote.c
> > +++ b/fs/xfs/xfs_attr_remote.c
> > @@ -359,6 +359,11 @@ xfs_attr_rmtval_set(
> >  		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
> >  		 * spill for another block every 9 headers we require in this
> >  		 * loop.
> > +		 *
> > +		 * Note that this can result in contiguous allocation of blocks,
> > +		 * so we don't use all the space we allocate for headers as we
> > +		 * have one less header for each contiguous allocation that
> > +		 * occurs in the map/write loop below.
> >  		 */
> >  		if (crcs && blkcnt == 0) {
> >  			int total_len;
> > @@ -439,7 +444,6 @@ xfs_attr_rmtval_set(
> >  		lblkno += map.br_blockcount;
> >  	}
> >  	ASSERT(valuelen == 0);
> > -	ASSERT(hdrcnt == 0);
> 
> I can't say I grok the context enough atm to send a Reviewed-by, but if
> we're removing this, why not just remove the hdrcnt-- a few lines up as
> well? It doesn't appear to be used after the first loop at this point.

Could also keep a separate variable for each loop and compare them here.  The
count for the 2nd loop should always be smaller than for the first... The
assert was worth adding so maybe it is worth fixing too?  Either way is fine
with me.

Reviewed-by: Ben Myers <bpm@sgi.com>

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
