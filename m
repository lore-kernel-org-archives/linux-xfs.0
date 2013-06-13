Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B00B7F56
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 19:51:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 375E98F804B
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 17:51:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HOBenRXUvzf2wbLa for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 17:50:58 -0700 (PDT)
Date: Thu, 13 Jun 2013 10:50:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/27] xfs: don't use speculative prealloc for small files
Message-ID: <20130613005050.GA29338@dastard>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-5-git-send-email-david@fromorbit.com>
	<51B89D58.80108@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B89D58.80108@redhat.com>
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

On Wed, Jun 12, 2013 at 12:10:00PM -0400, Brian Foster wrote:
> On 06/12/2013 06:22 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> ...
> > ---
> >  fs/xfs/xfs_iomap.c |   13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 8f8aaee..14be676 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -284,6 +284,15 @@ xfs_iomap_eof_want_preallocate(
> >  		return 0;
> >  
> >  	/*
> > +	 * If the file is smaller than the minimum prealloc and we are using
> > +	 * dynamic preallocation, don't do any preallocation at all as it is
> > +	 * likely this is the only write to the file that is going to be done.
> > +	 */
> > +	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
> > +	    XFS_ISIZE(ip) < mp->m_writeio_blocks)
> > +		return 0;
> > +
> 
> I stuck this on a box, got a 64k prealloc on an 8k file and then noticed
> this was comparing inode size against a block count. This should
> probably be:
> 
> 	XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)
> 
> Given that, we avoid preallocs entirely until the file size reaches the
> minimum write size (assuming dynamic prealloc mode).

Doh! Will fix.

Cheers

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
