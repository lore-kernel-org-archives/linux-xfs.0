Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0BBC7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 19:46:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34904AC001
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 17:46:06 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EsjMNdMQtGNfCcXu for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 17:46:04 -0700 (PDT)
Date: Thu, 30 May 2013 10:46:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: fix incorrect remote symlink block count
Message-ID: <20130530004602.GE29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-3-git-send-email-david@fromorbit.com>
	<51A62F45.5000004@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A62F45.5000004@redhat.com>
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

On Wed, May 29, 2013 at 12:39:33PM -0400, Brian Foster wrote:
> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When CRCs are enabled, the number of blocks needed to hold a remote
> > symlink on a 1k block size filesystem may be 2 instead of 1. The
> > transaction reservation for the allocated bloks was not taking this
> > into account and only allocating one block. hence when trying to
> > read or invalidate such symlinks, we are mapping a hole where there
> > should be a block and things go bad at that point.
> > 
> > Fix the reservation to use the correct block count, clean up the
> > block count calculation similar to the remote attribute calculation,
> > and add a debug guard to detect when we don't write the entire
> > symlink to disk.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Unrelated question... I noticed we update di_size in xfs_symlink(). I
> presume this is safe because, even in the non-local case, we actually
> log the data (the path) in the buffers as well, right?

Yes, the remote symlink block allocation and contents is logged in
the same transaction so cwit is safe to update di_size directly and
log that, too.

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
