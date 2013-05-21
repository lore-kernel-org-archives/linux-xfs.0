Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CAA929DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:53:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 70CBE8F8059
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:53:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7j6QGIosfI1cofGe for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 15:53:34 -0700 (PDT)
Date: Wed, 22 May 2013 08:53:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: remote attribute read too short
Message-ID: <20130521225333.GS24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-4-git-send-email-david@fromorbit.com>
	<20130521205924.GM20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521205924.GM20028@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 03:59:24PM -0500, Ben Myers wrote:
> On Tue, May 21, 2013 at 06:02:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Reading a maximally size remote attribute fails when CRCs are
> > enabled with this verification error:
> > 
> > XFS (vdb): remote attribute header does not match required off/len/owner)
> > 
> > There are two reasons for this, the first being that the
> > length of the buffer being read is determined from the
> > args->rmtblkcnt which doesn't take into account CRC headers. Hence
> > the mapped length ends up being too short and so we need to
> > calculate it directly from the value length.
> > 
> > The second is that the byte count of valid data within a buffer is
> > capped by the length of the data and so doesn't take into account
> > that the buffer might be longer due to headers. Hence we need to
> > calculate the data space in the buffer first before calculating the
> > actual byte count of data.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_attr_remote.c |   15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> > index aad95b0..bcdc07c 100644
> > --- a/fs/xfs/xfs_attr_remote.c
> > +++ b/fs/xfs/xfs_attr_remote.c
> > @@ -52,9 +52,11 @@ xfs_attr3_rmt_blocks(
> >  	struct xfs_mount *mp,
> >  	int		attrlen)
> >  {
> > -	int		buflen = XFS_ATTR3_RMT_BUF_SPACE(mp,
> > -							 mp->m_sb.sb_blocksize);
> > -	return (attrlen + buflen - 1) / buflen;
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> > +		return (attrlen + buflen - 1) / buflen;
> > +	}
> > +	return XFS_B_TO_FSB(mp, attrlen);
> 
> xfs_attr_rmtval_set, xfs_attr3_rmt_blocks, and XFS_ATTR3_RMT_BUF_SPACE all have
> checks for crcs on the superblock.  It's like I'm seeing stars.

Sure - I'm not concerned about how efficient the code is at this
point. I just want it to work correctly. If that means we check for
CRC support more frequently than we need to, then that's no big deal
right now.

> 
> >  }
> >  
> >  static bool
> > @@ -206,8 +208,9 @@ xfs_attr_rmtval_get(
> >  
> >  	while (valuelen > 0) {
> >  		nmap = ATTR_RMTVALUE_MAPSIZE;
> > +		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
> >  		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
> > -				       args->rmtblkcnt, map, &nmap,
> > +				       blkcnt, map, &nmap,
> 
> Isn't blkcnt wrong on the 2nd or greater iteration of this loop?  Looks like an old bug.

Yes, args->rmtblkcnt is wrong on the 2nd+ loop iteration. And yes,
it's an old, old bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
