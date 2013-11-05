Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 702A97F93
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 18:25:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0450DAC002
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 16:25:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	zoo3kTgmcgGWxWlz for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 16:25:09 -0800 (PST)
Date: Tue, 5 Nov 2013 11:25:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/30] db: verify and calculate dquot CRCs
Message-ID: <20131105002506.GU6188@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-22-git-send-email-david@fromorbit.com>
	<20131104090627.GB23564@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131104090627.GB23564@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 04, 2013 at 01:06:27AM -0800, Christoph Hellwig wrote:
> On Wed, Oct 30, 2013 at 03:31:12PM +1100, Dave Chinner wrote:
> > When we set the current Io cursor to point at a dquot block, verify
> > that the dquot CRC is intact. And prior to writing such an IO
> > cursor, calculate the dquot CRC.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  db/io.c | 5 ++++-
> >  db/io.h | 1 +
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/db/io.c b/db/io.c
> > index 8ddb5e5..7281148 100644
> > --- a/db/io.c
> > +++ b/db/io.c
> > @@ -464,7 +464,9 @@ write_cur(void)
> >  
> >  	if (iocur_top->ino_buf)
> >  		libxfs_dinode_calc_crc(mp, iocur_top->data);
> > -
> > +	if (iocur_top->dquot_buf)
> > +		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
> > +				 XFS_DQUOT_CRC_OFF);
> 
> The patch looks good to get going, but it seems we'd be better off going
> through an ops vector here in some form..

Potentially - if we need a third object-within-a-buffer verification
then it will be worthwhile to do this. However, for the moment we
only have to support inodes and dquots and so for the moment I don't
see that further abstraction is necessary.

Hence right now I'd prefer to make it explicit that we are doing
these CRC calculations here and just keep in mind that if we are
going to add more we need to abstract it into an ops vector at that
time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
