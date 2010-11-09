Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA928w3E130117 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 20:08:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34C56139CD8E
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 18:10:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id svwO9H8BKrAm1dlD for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 18:10:25 -0800 (PST)
Date: Mon, 8 Nov 2010 21:10:03 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109021002.GC27816@dhcp231-156.rdu.redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<20101109011222.GD2715@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101109011222.GD2715@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, Josef Bacik <josef@redhat.com>, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> On Mon, Nov 08, 2010 at 03:32:02PM -0500, Josef Bacik wrote:
> > Hole punching has already been implemented by XFS and OCFS2, and has the
> > potential to be implemented on both BTRFS and EXT4 so we need a generic way to
> > get to this feature.  The simplest way in my mind is to add FALLOC_FL_PUNCH_HOLE
> > to fallocate() since it already looks like the normal fallocate() operation.
> > I've tested this patch with XFS and BTRFS to make sure XFS did what it's
> > supposed to do and that BTRFS failed like it was supposed to.  Thank you,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/open.c              |    2 +-
> >  include/linux/falloc.h |    1 +
> >  2 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/open.c b/fs/open.c
> > index 4197b9e..ab8dedf 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EINVAL;
> >  
> >  	/* Return error if mode is not supported */
> > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
> >  		return -EOPNOTSUPP;
> >  
> >  	if (!(file->f_mode & FMODE_WRITE))
> > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > index 3c15510..851cba2 100644
> > --- a/include/linux/falloc.h
> > +++ b/include/linux/falloc.h
> > @@ -2,6 +2,7 @@
> >  #define _FALLOC_H_
> >  
> >  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
> > +#define FALLOC_FL_PUNCH_HOLE	0X02 /* de-allocates range */
> 
> Hole punching was not included originally in fallocate() for a
> variety of reasons. IIRC, they were along the lines of:
> 
> 	1 de-allocating of blocks in an allocation syscall is wrong.
> 	  People wanted a new syscall for this functionality.
> 	2 no glibc interface needs it
> 	3 at the time, only XFS supported punching holes, so there
> 	  is not need to support it in a generic interface
> 	4 the use cases presented were not considered compelling
> 	  enough to justify the additional complexity (!)
> 
> In the end, I gave up arguing for it to be included because just
> getting the FALLOC_FL_KEEP_SIZE functionality was a hard enough
> battle.
> 
> Anyway, #3 isn't the case any more, #4 was just an excuse not to
> support anything ext4 couldn't do and lots of apps are calling
> fallocate directly (because glibc can't use FALLOC_FL_KEEP_SIZE) so
> #2 isn't an issue, either. I guess that leaves #1 to be debated;
> I don't think there is any problem with doing what you propose.
>
> What I will suggest is that this requires a generic xfstest to be
> written and support added to xfs_io to enable that test (and others)
> to issue hole punches. Something along the lines of test 242 which I
> wrote for testing all the edge case of XFS_IOC_ZERO_RANGE (*) would be
> good.

Sounds good.  Do you want me to build my PUNCH_HOLE patch ontop of your
ZERO_RANGE patch?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
