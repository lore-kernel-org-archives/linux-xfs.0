Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:58601
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1031408AbeBNVsD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 16:48:03 -0500
Date: Thu, 15 Feb 2018 08:48:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Behavior of falloc collapse range when preceded by falloc keep
 size : Possible eof block loss
Message-ID: <20180214214800.GH7000@dastard>
References: <CA+EzBbBtpD=shOwnWLwTfkb-mmyaznndGNL3saSEobX0uT7MfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EzBbBtpD=shOwnWLwTfkb-mmyaznndGNL3saSEobX0uT7MfA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 10:56:31AM -0600, Jayashree Mohan wrote:
> Hi,
> 
> I am Jayashree Mohan, a PhD student at the University of Texas at
> Austin, working with Prof. Vijay Chidambaram. I've been working on the
> Crashmonkey project, which is a test harness for file system crash
> consistency checks[1].
> 
> While trying to reproduce some of the reported bugs on filesystems
> using CrashMonkey we stumbled upon the following issue:
> 
> Whenever we have a collapse_range operation that follows fallocate
> with keep_size that allocated blocks beyond the end-of-file, the eof
> blocks are lost due to the collapse_range operation in f2fs and xfs.

.....

> If we didn't have the keep_size option with fallocate in step 2, then
> we see the xfs_bmap after step 3 to be
> 0: [0..223]: 160..383
> 1: [224..823]: 416..1015
> 2: [824..831]: 1016..1023
> 
> This clearly shows, the blocks allocated beyond the eof are lost
> during the collapse_range operation, if keep_size was specified while
> allocating these blocks. This behavior is seen in both f2fs and xfs,
> while ext4 seems to preserve the allocated blocks. All these were
> tested on linux kernel 4.15. Shouldn't f2fs and xfs also behave like
> ext4?

Yup, XFS trims post-eof blocks before a collapse because:

        /*
         * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
         * into the accessible region of the file.
         */
        if (xfs_can_free_eofblocks(ip, true)) {
                error = xfs_free_eofblocks(ip);
                if (error)
                        return error;
        }

we can retain uninitialised extents beyond EOF. I think that
uninitialised preallocation beyond EOF cannot occur in ext4 (i.e.
it can only have unwritten extents beyond EOF) but you'll need to
check that.

IOWs, ext4 needs to be considered "potentially dangerous" in
terms of it's behaviour here, and that both XFS and f2fs are doing
the obviously safe thing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
