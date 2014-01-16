Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EB067F5D
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:23:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BAD2304084
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 15:23:28 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MoqCVjt2rCKLIAeV for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 15:23:23 -0800 (PST)
Date: Fri, 17 Jan 2014 10:21:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allow logical-sector sized O_DIRECT for any fs
	sector size
Message-ID: <20140116232132.GT3431@dastard>
References: <52D6CC91.6000408@redhat.com> <20140115223848.GZ3469@dastard>
	<52D71115.1070309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52D71115.1070309@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 15, 2014 at 04:52:05PM -0600, Eric Sandeen wrote:
> On 1/15/14, 4:38 PM, Dave Chinner wrote:
> > On Wed, Jan 15, 2014 at 11:59:45AM -0600, Eric Sandeen wrote:
> >> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> >> index 33ad9a7..1f3431f 100644
> >> --- a/fs/xfs/xfs_ioctl.c
> >> +++ b/fs/xfs/xfs_ioctl.c
> >> @@ -1587,7 +1587,12 @@ xfs_file_ioctl(
> >>  			XFS_IS_REALTIME_INODE(ip) ?
> >>  			mp->m_rtdev_targp : mp->m_ddev_targp;
> >>  
> >> -		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
> >> +		/*
> >> +		 * Report device physical sector size as "optimal" minimum,
> >> +		 * unless blocksize is smaller than that.
> >> +		 */
> >> +		da.d_miniosz = min(target->bt_pssize, target->bt_bsize);
> > 
> > Just grab the filesysetm block size from the xfs_mount:
> > 
> > 		da.d_miniosz = min(target->bt_pssize, mp->m_sb.sb_blocksize);
> > 
> >> +		da.d_mem = da.d_miniosz;
> > 
> > I'd suggest that this should be PAGE_SIZE - it's for memory buffer
> > alignment, not IO alignment, so using the IO alignment just seems
> > wrong to me...
> 
> Ok.  Was just sticking close to what we had before.
> 
> So:
>  		da.d_miniosz = min(target->bt_pssize, mp->m_sb.sb_blocksize);
> 		da.d_mem = PAGE_SIZE;
> 
> ?  Then we can have a minimum IO size of 512, and a memory alignment of
> 4k, isn't that a little odd?
> 
> (IOWs we could do 512-aligned memory before, right?  What's the downside,
> or the value in changing it now?)

We can do arbitrary byte aligned buffers if I understand
get_user_pages() correctly - it just maps the page under the buffer
into the kernel address space and then the bio is pointed at it.
AFAICT, the reason for the "memory buffer needs 512 byte alignment"
is simply that this is the minimum IO size supported.

However, for large IOs, 512 byte alignment is not really optimal. If
we don't align the buffer to PAGE_SIZE, then we have partial head
and tail pages, so for a 512k IO we need to map 129 pages into a bio
instead of 128. When you have hardware that can only handle 128
segments in a DMA transfer, that means the 512k IO needs to be sent
in two IOs rather than one.

There's quite a bit of hardware out there that have a limit of 128
segments to each IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
