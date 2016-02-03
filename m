Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C95AD7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 14:02:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9ECF3304039
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 12:02:08 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1scYn2T9EXKHXdVI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 12:02:04 -0800 (PST)
Date: Wed, 3 Feb 2016 12:01:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: vfs/xfs: directio updates to ease COW handling V2
Message-ID: <20160203200159.GK20038@birch.djwong.org>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Wed, Feb 03, 2016 at 02:43:02PM -0500, Jeff Moyer wrote:
> Hi, Christoph,
> 
> Can you explain a bit what you mean by easing COW handling?  Whenever I
> see COW referenced near DIO, my mind always turns to g_u_p vs. fork.

Just to clarify, I'm talking about copy on write for disk blocks, not for
memory pages.

Basically, XFS implements (disk block) copy on write for (perfectly block
aligned) directio writes by allocating a set of replacement blocks, mapping the
dio writes to the new blocks, and playing a punch/remap trick to map the new
blocks into the file at the appropriate offset.

If the write fails then we don't want do the remap, so the dio_complete handler
has to know whether or not the IO succeeded, hence the new parameter.
Furthermore, if the write succeeds but the remap fails, we also want to be able
to report that to userspace, hence the change of return value from void to int.

(If the dio write isn't block aligned, we fall back to the page cache.)

Hope that helps,

--D

> 
> Thanks!
> Jeff
> 
> Christoph Hellwig <hch@lst.de> writes:
> 
> > See http://www.infradead.org/rpr.html
> >
> > The first patch ensures ->end_io is always called for direct I/O requests
> > that pass it in, even if there was a zero length write, or if an error
> > occured.  The existing users have been updated to ignore it, but XFS
> > will make use of it in the future, and a comment in ext4 suggests it
> > might be useful for it as well.
> >
> > The other two simplify the XFS direct I/O code.
> >
> > Changes since V1:
> >  - allow ->end_io to return errors
> >  - a comment spelling fix
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
