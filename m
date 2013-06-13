Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63D4429DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 16:31:19 -0500 (CDT)
Date: Thu, 13 Jun 2013 16:31:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/3] xfs: fix implicit padding in directory and attr
	CRC formats
Message-ID: <20130613213115.GZ20932@sgi.com>
References: <1371003548-4026-1-git-send-email-david@fromorbit.com>
	<1371003548-4026-3-git-send-email-david@fromorbit.com>
	<20130613005819.GW20932@sgi.com> <20130613022729.GH29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613022729.GH29338@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

Hey Dave,

On Thu, Jun 13, 2013 at 12:27:29PM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2013 at 07:58:19PM -0500, Ben Myers wrote:
> > On Wed, Jun 12, 2013 at 12:19:07PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Michael L. Semon has been testing CRC patches ona 32 bit system and
> > 						on a
> > 
> > > been seeing assert failures in the directory code from xfs/080.
> > > Thanks to Michael's heroic efforts with printk debugging, we found
> > > that the problem was that the last free space being left in the
> > > directory structure was too small to fit a unused tag structure and
> > > it was being corrupted and attempting to log a region out of bounds.
> > > Hence the assert failure looked something like:
> > > 
> > > .....
> > > #5 calling xfs_dir2_data_log_unused() 36 32
> > > #1 4092 4095 4096
> > > #2 8182 8183 4096
> >      first? 
> >           last?
> >                bp->b_length?
> 
> Yup.
> 
> > > 
> > > Note that this only affects 32 bit systems with CRCs enabled.
> > > Everything else is just fine. Note that filesystems created before
> > 					 CRC enabled filesystems
> > 
> > I suggest this be added to head off any confusion.
> 
> Sure.  Do I need to resubmit this, or are you going to just modify
> the commit message yourself before applying it?

Nah, I'll do it.

> > > index 995f1f5..7826782 100644
> > > --- a/fs/xfs/xfs_dir2_format.h
> > > +++ b/fs/xfs/xfs_dir2_format.h
> > > @@ -266,6 +266,7 @@ struct xfs_dir3_blk_hdr {
> > >  struct xfs_dir3_data_hdr {
> > >  	struct xfs_dir3_blk_hdr	hdr;
> > >  	xfs_dir2_data_free_t	best_free[XFS_DIR2_DATA_FD_COUNT];
> > > +	__be32			pad;	/* 64 bit alignment */
> > 
> > I counted these up and it looks fine.  Nice work gents.
> 
> pahole is a much better way of determining structure size - it tells
> you exactly what the compiler did, rather than having to assume what
> the compiler is going to do...
> 
> $ pahole fs/xfs/xfs_dir2_data.o |less

Thanks, I'll check it out.  Applied this.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
