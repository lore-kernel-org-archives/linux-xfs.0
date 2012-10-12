Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9C5YKn0069693 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 00:34:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mMQmqKVkEDg6BuNe for
	<xfs@oss.sgi.com>; Thu, 11 Oct 2012 22:35:53 -0700 (PDT)
Date: Fri, 12 Oct 2012 07:35:39 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfs: avoid underflow in xfs_ioc_trim()
In-Reply-To: <20121011213533.GE2739@dastard>
Message-ID: <alpine.LFD.2.00.1210120727170.6401@localhost>
References: <1349944432-13776-1-git-send-email-lczerner@redhat.com>
	<20121011213533.GE2739@dastard>
MIME-Version: 1.0
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
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Fri, 12 Oct 2012, Dave Chinner wrote:

> Date: Fri, 12 Oct 2012 08:35:33 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH v2] xfs: avoid underflow in xfs_ioc_trim()
> 
> On Thu, Oct 11, 2012 at 10:33:52AM +0200, Lukas Czerner wrote:
> > Currently if len argument in xfs_ioc_trim() is smaller than one FSB
> > the 'end' variable underflow. Avoid that by returning EINVAL when
> > range is smaller than FSB.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Just a thought - wouldn't this be better done at the VFS so it is
> consistent across all filesystems? i.e. using inode->i_blkbits?
> 
> Cheers,
> 
> Dave.

Currently I am working on patches for other file system, so we'll
get it fix. Having the check in VFS would require to make FITRIM
file system (inode?) operation, or adding cmd specific sections to
the vfs_ioctl(). All of this just for one check and file system
implementation would have to do other check anyway because we can
hardly do all of that in VFS. So I think it's not worth it.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
