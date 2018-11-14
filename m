Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:34014 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbeKNSNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 13:13:41 -0500
Date: Wed, 14 Nov 2018 19:10:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: take a ref on failed bufs in xfs_inode_item_push
Message-ID: <20181114081053.GV19305@dastard>
References: <20181107201055.25883-1-josef@toxicpanda.com>
 <20181107201055.25883-3-josef@toxicpanda.com>
 <20181107233740.GZ19305@dastard>
 <20181112142347.gh2biojf6suzngjr@MacBook-Pro-91.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112142347.gh2biojf6suzngjr@MacBook-Pro-91.local>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-xfs@vger.kernel.org

On Mon, Nov 12, 2018 at 09:23:48AM -0500, Josef Bacik wrote:
> On Thu, Nov 08, 2018 at 10:37:40AM +1100, Dave Chinner wrote:
> > xfs: fix transient reference count error in xfs_buf_resubmit_failed_buffers
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When retrying a failed inode or dquot buffer,
> > xfs_buf_resubmit_failed_buffers() clears all the failed flags from
> > the inode/dquot log items. In doing so, it also drops all the
> > reference counts on the buffer that the failed log items hold. This
> > means it can drop all the active references on the buffer and hence
> > free the buffer before it queues it for write again.
> > 
> > Putting the buffer on the delwri queue takes a reference to the
> > buffer (so that it hangs around until it has been written and
> > completed), but this goes bang if the buffer has already been freed.
> > 
> > Hence we need to add the buffer to the delwri queue before we remove
> > the failed flags from the log items attached to the buffer to ensure
> > it always remains referenced during the resubmit process.
> > 
> > Reported-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Dave,
> 
> Are you planning on sending this along as is?  I'm going to throw it in our
> kernel if you are happy with it.  Thanks,

I'm planning to, it's just my stack of fixes is growing faster than
I can QA them at the moment. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
