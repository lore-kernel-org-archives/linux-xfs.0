Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F9427F56
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 17:05:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C9F28F8068
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 15:04:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8TzVwggDzneBO1Eq for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 15:04:57 -0700 (PDT)
Date: Fri, 1 Nov 2013 09:04:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/30 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131031220438.GP4446@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
	<20131030215940.GH6188@dastard> <20131031041343.GK6188@dastard>
	<20131031150024.GP22359@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031150024.GP22359@infradead.org>
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

On Thu, Oct 31, 2013 at 08:00:24AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 31, 2013 at 03:13:43PM +1100, Dave Chinner wrote:
> > -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
> > -		if (mp->m_rootip)
> > -			libxfs_iput(mp->m_rootip, 0);
> > +	/* set up the realtime inodes if they exist */
> > +	error = rtmount_inodes(mp);
> > +	if (error)
> >  		return NULL;
> > -	}
> >  
> >  	/*
> >  	 * mkfs calls mount before the AGF/AGI structures are written.
> >  	 */
> > -	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
> > +	if (sbp->sb_rootino != NULLFSINO &&
> >  	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> 
> Oh, I hadn't noticed that LIBXFS_MOUNT_ROOTINOS does more than reading
> the root inode.  Seems like mkfs might need the rt inodes if a file with
> the rt flag is specified in the proto file.

mkfs always allocates the rt inodes directly after the root
directory is created.

> I can't see how xfs_copy could need either the rt inodes nor the perag
> data.

Right, it doesn't need them, but it doesn't hurt at all to
initialise them because all the ag headers are about to be read to
find all the used space, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
