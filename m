Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3Q0ilcp045774 for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 19:44:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0B6E8AF817
	for <xfs@oss.sgi.com>; Sun, 25 Apr 2010 17:46:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	jCUg0vFj6rkojYBJ for <xfs@oss.sgi.com>;
	Sun, 25 Apr 2010 17:46:48 -0700 (PDT)
Date: Mon, 26 Apr 2010 10:46:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: remove nr_to_write writeback windup.
Message-ID: <20100426004645.GC11437@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-5-git-send-email-david@fromorbit.com>
	<20100422190936.GB19286@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422190936.GB19286@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 22, 2010 at 09:09:37PM +0200, Jan Kara wrote:
> On Tue 20-04-10 12:41:54, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that the background flush code has been fixed, we shouldn't need to
> > silently multiply the wbc->nr_to_write to get good writeback. Remove
> > that code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_aops.c |    8 --------
> >  1 files changed, 0 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> > index 9962850..2b2225d 100644
> > --- a/fs/xfs/linux-2.6/xfs_aops.c
> > +++ b/fs/xfs/linux-2.6/xfs_aops.c
> > @@ -1336,14 +1336,6 @@ xfs_vm_writepage(
> >  	if (!page_has_buffers(page))
> >  		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
> >  
> > -
> > -	/*
> > -	 *  VM calculation for nr_to_write seems off.  Bump it way
> > -	 *  up, this gets simple streaming writes zippy again.
> > -	 *  To be reviewed again after Jens' writeback changes.
> > -	 */
> > -	wbc->nr_to_write *= 4;
> > -
>   Hum, are you sure about this? I thought it's there because VM passes at
> most 1024 pages to write from background writeback and you wanted to write
> more in one go (at least ext4 wants to do this).

About 500MB/s sure. ;)

Seriously though, the problem that lead to us adding this
multiplication was that writeback was not feeding XFS 1024 pages at
a time - we were getting much less than this (somewhere in the order
of 32-64 pages at a time. With the fixes I posted, in every
circumstance I can see we are the correct number of pages (1024
pages or what is left over from the last inode) being passed into
->writepages, and writeback is back to full speed without needing
this crutch. Indeed, this multiplication now causes  nr_to_write to
go ballistic in some cirumstances, and that causes latency and
fairness problems that will significantly reduce write rates for
applications like NFS servers.

Realistically, XFS doesn't need to write more than 1024 pages in one
go - the reason ext4 needs to do this is it's amazingly convoluted
delayed allocation path and the fact that it's allocator is nowhere
near as good at contiguous allocation across multiple invocations as
the XFS allocator is. IOWs, XFS really just needs enough contiguous
pages to be able to form large IOs, and given that most hardware
limits the IO size to 1MB on x86_64, then 1024 pages is more than
enough to provide this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
