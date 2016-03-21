Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 586897CA3
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 16:53:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22EA38F8039
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 14:53:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2vNbqT1PnNOLAFwz for <xfs@oss.sgi.com>;
	Mon, 21 Mar 2016 14:53:35 -0700 (PDT)
Date: Tue, 22 Mar 2016 08:53:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/9] block: add block_device_operations methods to
	set and get reserved space
Message-ID: <20160321215333.GM11812@dastard>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
	<1458225037-24155-2-git-send-email-bfoster@redhat.com>
	<20160321120829.GB25476@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321120829.GB25476@redhat.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, Mar 21, 2016 at 01:08:29PM +0100, Carlos Maiolino wrote:
> Hi,
> 
> Good news about this interface, I just have a small suggestion in this patch:
> 
> On Thu, Mar 17, 2016 at 10:30:29AM -0400, Brian Foster wrote:
> > From: Mike Snitzer <snitzer@redhat.com>
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  fs/block_dev.c         | 20 ++++++++++++++++++++
> >  include/linux/blkdev.h |  5 +++++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index 826b164..375a2e4 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -497,6 +497,26 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
> >  }
> >  EXPORT_SYMBOL_GPL(bdev_direct_access);
> >  
> > +int blk_reserve_space(struct block_device *bdev, sector_t nr_sects)
> > +{
> > +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> > +
> > +	if (!ops->reserve_space)
> > +		return -EOPNOTSUPP;
> > +	return ops->reserve_space(bdev, nr_sects);
> > +}
> > +EXPORT_SYMBOL_GPL(blk_reserve_space);
> 
> Wouldn't be better to have this function name standardized accordingly to the
> next one? Something like blk_set_reserved_space() maybe?

Personally I see no point in wrappers like this. We don't add
wrappers for ops methods in any other layers of the stack,
filesystems are quite capable of checking if the method is available
directly, so it seems pretty pointless to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
