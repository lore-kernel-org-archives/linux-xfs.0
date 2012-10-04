Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9416crd049764 for <xfs@oss.sgi.com>; Wed, 3 Oct 2012 20:06:38 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dAzEvgNhZ4ZYEoxa for <xfs@oss.sgi.com>;
	Wed, 03 Oct 2012 18:08:02 -0700 (PDT)
Date: Thu, 4 Oct 2012 11:07:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
Message-ID: <20121004010726.GZ23520@dastard>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
	<506A38D1.6090204@redhat.com> <506AE5AD.60509@redhat.com>
	<20121002205124.GS23520@dastard> <20121004000552.GO13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121004000552.GO13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Oct 03, 2012 at 07:05:52PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Wed, Oct 03, 2012 at 06:51:24AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > writeback_inodes_sb_if_idle() is not sufficient to trigger delalloc
> > conversion fast enough to prevent spurious ENOSPC whent here are
> > hundreds of writers, thousands of small files and GBs of free RAM.
> > Change this to use sync_sb_inodes() to block callers while we wait
> > for writeback like the previous xfs_flush_inodes implementation did.
> > 
> > We have to hold the s_umount lock here, but because this call can
> > nest inside i_mutex (the parent directory in the create case, held
> > by the VFS), we have to use down_read_trylock() to avoid potential
> > deadlocks. In practice, this trylock will succeed on almost every
> > attempt as unmount/remount type operations are exceedingly rare.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
<snip>

> Is this the one you want to go with?  I'd prefer to apply this to patch 6
> itself rather than check in the regression followed by the fix.  If you'd like
> resubmit this patch that's great, otherwise I'll be happy to repost the result.

Yes, this is the version that is necessary. Folding it back
into the original patch is fine as long as you fold the commit
message as well to explain why it was implemented this way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
