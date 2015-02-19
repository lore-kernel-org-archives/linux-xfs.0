Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BCEF37F59
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:38:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48B38AC003
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:38:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Mfa1SBAEzWFzxX4N for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:38:13 -0800 (PST)
Date: Fri, 20 Feb 2015 08:37:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
Message-ID: <20150219213746.GV12722@dastard>
References: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
	<20150219172028.GC2291@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219172028.GC2291@laptop.bfoster>
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
Cc: Pratyush Anand <panand@redhat.com>, jbastian@redhat.com, ddutile@redhat.com, xfs@oss.sgi.com

On Thu, Feb 19, 2015 at 12:20:28PM -0500, Brian Foster wrote:
> On Thu, Feb 19, 2015 at 06:54:33PM +0530, Pratyush Anand wrote:
> > My root file system is xfs. As soon as I enable event for
> > xfs_trans_read_buf `echo xfs:xfs_trans_read_buf >>
> > /sys/kernel/debug/tracing/set_event`, I see a kernel panic.
> > 
> > A little bit of debugging shows that bp->b_fspriv is NULL many a time
> > when trace_xfs_trans_read_buf(bp->b_fspriv) is called.
> > 
> > I do not have any idea about xfs filesystem. So, I am not sure, if it
> > is expected to have bp->b_fspriv = NULL at this location.
> > 
> > This patch fixes the issue, until we have a better fix.
> > 
> > Signed-off-by: Pratyush Anand <panand@redhat.com>
> > ---
> 
> A fix for this has been posted here:
> 
> http://oss.sgi.com/archives/xfs/2015-02/msg00101.html

It's already in the 3.20-rc0 kernel, and it was marked as a stable
patch so should be fixed in the next 3.19 stable kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
