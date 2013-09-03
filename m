Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33B6D7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 14:35:45 -0500 (CDT)
Date: Tue, 3 Sep 2013 14:35:41 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfs: dtype changed xfs_dir2_sfe_put_ino to
	xfs_dir3_sfe_put_ino
Message-ID: <20130903193541.GM1935@sgi.com>
References: <1377843681-31878-1-git-send-email-david@fromorbit.com>
	<1377843681-31878-2-git-send-email-david@fromorbit.com>
	<20130902021559.GC23571@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902021559.GC23571@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Mon, Sep 02, 2013 at 12:15:59PM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2013 at 04:21:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > So fix up the export in xfs_dir2.h that is needed by userspace.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Well, this patch now causes a compilation failure.  Why?
> xfs_dir3_sfe_put_ino() got marked as static because it didn't have a
> matching export.
> 
> Perhaps we should be a little less hasty in merging auto-generated
> patches from random build-farms? The patch was wrong - fixing the
> prototype like in v1 of this patch was the correct thing to do....
> 
> So, the updated patch below adds the revert.
> 
> Cheers,
> 
> Dave.
> 
> PS: Ben, when you merge a patch from a reply in an email thread,
> can you please pull the commit subject line from the patch, not the
> title of the email thread? One of the recent commits got it wrong.
> i.e. commit 3780437 
> 
> "XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file:"
> 
> should have had the title
> 
> "xfs: fix calculation of the number of node entries in a dir3 node"

I'll keep an eye out, thanks.

> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> So fix up the export in xfs_dir2.h that is needed by userspace.
> 
> <sigh>
> 
> Now xfs_dir3_sfe_put_ino has been made static. Revert 98f7462 ("xfs:
> xfs_dir3_sfe_put_ino can be static") to being non static so that the
> code shared with userspace is identical again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ah.. sorry I missed that it's used in your userspace series.  Could you repost
your userspace series soon?

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
