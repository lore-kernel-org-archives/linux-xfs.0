Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbeJEIVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 04:21:16 -0400
Date: Thu, 4 Oct 2018 18:24:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/15] fs: fixes for serious clone/dedupe problems
Message-ID: <20181005012450.GN19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <20181005011718.GX31060@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005011718.GX31060@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Fri, Oct 05, 2018 at 11:17:18AM +1000, Dave Chinner wrote:
> On Thu, Oct 04, 2018 at 05:44:34PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > Dave, Eric, and I have been chasing a stale data exposure bug in the XFS
> > reflink implementation, and tracked it down to reflink forgetting to do
> > some of the file-extending activities that must happen for regular
> > writes.
> > 
> > We then started auditing the clone, dedupe, and copyfile code and
> > realized that from a file contents perspective, clonerange isn't any
> > different from a regular file write.  Unfortunately, we also noticed
> > that *unlike* a regular write, clonerange skips a ton of overflow
> > checks, such as validating the ranges against s_maxbytes, MAX_NON_LFS,
> > and RLIMIT_FSIZE.  We also observed that cloning into a file did not
> > strip security privileges (suid, capabilities) like a regular write
> > would.  I also noticed that xfs and ocfs2 need to dump the page cache
> > before remapping blocks, not after.
> > 
> > In fixing the range checking problems I also realized that both dedupe
> > and copyfile tell userspace how much of the requested operation was
> > acted upon.  Since the range validation can shorten a clone request (or
> > we can ENOSPC midway through), we might as well plumb the short
> > operation reporting back through the VFS indirection code to userspace.
> > 
> > So, here's the whole giant pile of patches[1] that fix all the problems.
> > The patch "generic: test reflink side effects" recently sent to fstests
> > exercises the fixes in this series.  Tests are in [2].
> 
> Hmmm. I've got a couple of patches to fix dedupe/reflink partial EOF
> block data corruptions, too. I'll have to see how they fit into this
> new series - combined they add this code just after the call to
> vfs_clone_file_prep_inodes():
> 
> ....
> +       u64                     blkmask = i_blocksize(inode_in) - 1;
> ....
> +       /*
> +        * If the dedupe data matches, chop off the partial EOF block
> +        * from the source file so we don't try to dedupe the partial
> +        * EOF block.
> +        */
> +       if (is_dedupe) {
> +               len &= ~blkmask;
> +       } else if (len & blkmask) {
> +               /*
> +                * The user is attempting to share a partial EOF block,
> +                * if it's inside the destination EOF then reject it
> +                */
> +               if (pos_out + len < i_size_read(inode_out)) {
> +                       ret = -EINVAL;
> +                       goto out_unlock;
> +               }
> +       }
> 
> It might be better to put these in with the eof-zeroing patch then
> add all the other changes on top? Let me post them separately,
> as they may be candidates for 4.19-rc7 along with the eof zeroing.

Yeah, maybe we want to push the first two for 4.19 and leave the rest
for 4.20/5.0.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
