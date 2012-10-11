Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLY2aV242795 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:34:02 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JTstMN0WYL9UH3Rx for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:35:34 -0700 (PDT)
Date: Fri, 12 Oct 2012 08:35:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: avoid underflow in xfs_ioc_trim()
Message-ID: <20121011213533.GE2739@dastard>
References: <1349944432-13776-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349944432-13776-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 10:33:52AM +0200, Lukas Czerner wrote:
> Currently if len argument in xfs_ioc_trim() is smaller than one FSB
> the 'end' variable underflow. Avoid that by returning EINVAL when
> range is smaller than FSB.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Just a thought - wouldn't this be better done at the VFS so it is
consistent across all filesystems? i.e. using inode->i_blkbits?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
