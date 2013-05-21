Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF5E37F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A9E498F8035
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:25:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IRpGdGiI6rXUqw3j for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:25:22 -0700 (PDT)
Date: Tue, 21 May 2013 10:25:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/14] xfs: remote attribute allocation may be contiguous
Message-ID: <20130521002518.GI24543@dastard>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-9-git-send-email-david@fromorbit.com>
	<519A7395.9060806@redhat.com> <20130520220418.GF20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130520220418.GF20028@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, May 20, 2013 at 05:04:18PM -0500, Ben Myers wrote:
> On Mon, May 20, 2013 at 03:03:49PM -0400, Brian Foster wrote:
> > On 05/19/2013 07:51 PM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When CRCs are enabled, there may be multiple allocations made if the
> > > headers cause a length overflow. This, however, does not mean that
> > > the number of headers required increases, as the second and
> > > subsequent extents may be contiguous with the previous extent. Hence
> > > when we map the extents to write the attribute data, we may end up
> > > with less extents than allocations made. Hence the assertion that we
> > > consume th enumber of headers we calculated in the allocation loop
> 	    the 
> 
> > > is incorrect and needs to be removed.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_attr_remote.c |    6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> > > index dee8446..aad95b0 100644
> > > --- a/fs/xfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/xfs_attr_remote.c
> > > @@ -359,6 +359,11 @@ xfs_attr_rmtval_set(
> > >  		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
> > >  		 * spill for another block every 9 headers we require in this
> > >  		 * loop.
> > > +		 *
> > > +		 * Note that this can result in contiguous allocation of blocks,
> > > +		 * so we don't use all the space we allocate for headers as we
> > > +		 * have one less header for each contiguous allocation that
> > > +		 * occurs in the map/write loop below.
> > >  		 */
> > >  		if (crcs && blkcnt == 0) {
> > >  			int total_len;
> > > @@ -439,7 +444,6 @@ xfs_attr_rmtval_set(
> > >  		lblkno += map.br_blockcount;
> > >  	}
> > >  	ASSERT(valuelen == 0);
> > > -	ASSERT(hdrcnt == 0);
> > 
> > I can't say I grok the context enough atm to send a Reviewed-by, but if
> > we're removing this, why not just remove the hdrcnt-- a few lines up as
> > well? It doesn't appear to be used after the first loop at this point.

Yup, I noticed that later on....

> Could also keep a separate variable for each loop and compare them here.  The
> count for the 2nd loop should always be smaller than for the first... The
> assert was worth adding so maybe it is worth fixing too?  Either way is fine
> with me.

Well, I'm not convinced the code is correct yet, anyway. My
overnight runs on a 1k block size filesystem (can't use 512 byte
block size with 512 byte inodes) tripped over the same assert that I
was seeing with 4k block size filesystems and these patches fix.

By "not convinced", I mean that I think I've made a mistake in just
putting a header at the start of each extent. Call it preamture
optimisation, if you want, as it seems like a good idea at the time.

The main issue is that we don't know ahead of time how big an
attribute is going to be because it will have a variable number of
headers, and hence we don't know where the attribute data actually
ends from a mapping lookup as there can be trailing contiguous
blocks that hold other attribute data.

IOWs, I've found that this code is incredibly fragile, difficult to
verify and hard to debug. And I'm pretty certain the mapping of
trailing blocks is almost impossible to solve sanely.

What I'd like to do right now is change this format to
have a header per filesystem block. The reason for doing this is
that all the unknowns are removed - we have a direct relationship
between the attribute data length and the number of blocks needed to
store the data (it is always what xfs_attr3_rmt_blocks() returns)
and that greatly simplifies all this code.

It gets rid of the multiple allocation loop, the complexity of
contiguous allocation from multiple loop instances, etc. It does
make the parsing/verification of the attribute data a little more
complex, but that is a constant rather than the mess I've created
right now...

The only issue is that it is a change of the on-disk format. I'm
happy just to go change it as this is marked experimental, it hasn't
reached an initial public release yet and the only people using it
are developers and testers using volatile data...

I'm going to do this today, based on top of this series - this series
allows much more testing to be done, so it should be committed
anyway. Yeah, it's a pain, but this code is going to cause us long
term problems if we don't fix these problems now...

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
