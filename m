Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46266 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751146AbdKTW1x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 17:27:53 -0500
Date: Tue, 21 Nov 2017 09:27:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171120222749.GO5858@dastard>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
 <20171120215100.GB8933@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120215100.GB8933@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Mon, Nov 20, 2017 at 01:51:00PM -0800, Matthew Wilcox wrote:
> On Tue, Nov 21, 2017 at 07:26:06AM +1100, Dave Chinner wrote:
> > On Mon, Nov 20, 2017 at 08:18:29AM -0800, Matthew Wilcox wrote:
> > > On Fri, Nov 17, 2017 at 11:39:25AM -0800, Darrick J. Wong wrote:
> > > > If two programs simultaneously try to write to the same part of a file
> > > > via direct IO and buffered IO, there's a chance that the post-diowrite
> > > > pagecache invalidation will fail on the dirty page.  When this happens,
> > > > the dio write succeeded, which means that the page cache is no longer
> > > > coherent with the disk!
> > > 
> > > This seems like a good opportunity to talk about what I've been working
> > > on for solving this problem.  The XArray is going to introduce a set
> > > of entries which can be stored to locations in the page cache that I'm
> > > calling 'wait entries'.
> > 
> > What's this XArray thing you speak of?
> 
> Ah, right, you were on sabbatical at LSFMM this year where I talked
> about it.  Briefly, it's a new API for the radix tree.  The data structure
> is essentially unchanged (minor enhancements), but I'm rationalising
> existing functionality and adding new abilities.  And getting rid of
> misfeatures like the preload API and implicit GFP flags.
> 
> My current working tree is here:
> 
> http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-2017-11-20

First thing I noticed was that "xa" as a prefix is already quite
widely used in XFS - it's shorthand for "XFS AIL". Indeed, xa_lock
already exists and is quite widely used, so having a generic
interface using the same prefixes and lock names is going to be
quite confusing in the XFS code. Especially considering there's
fair bit of radix tree use in XFS (e.g. the internal inode and
dquot caches).

FYI, from fs/xfs/xfs_trans_priv.h:

/*
 * Private AIL structures.
 *
 * Eventually we need to drive the locking in here as well.
 */
struct xfs_ail {
        struct xfs_mount        *xa_mount;
        struct task_struct      *xa_task;
        struct list_head        xa_ail;
        xfs_lsn_t               xa_target;
        xfs_lsn_t               xa_target_prev;
        struct list_head        xa_cursors;
        spinlock_t              xa_lock;
        xfs_lsn_t               xa_last_pushed_lsn;
        int                     xa_log_flush;
        struct list_head        xa_buf_list;
        wait_queue_head_t       xa_empty;
};


> Ignoring the prep patches, the excitement is all to be found with the
> commits which start 'xarray:'

FWIW, why is it named "XArray"?  "X" stands for what?  It still
looks like a tree structure to me, but without a design doc I'm a
bit lost to how it differs to the radix tree (apart from the API)
and why it's considered an "array".

> If you want an example of it in use, I'm pretty happy with this patch
> that switches the brd driver entirely from the radix tree API to the
> xarray API:
> 
> http://git.infradead.org/users/willy/linux-dax.git/commitdiff/dbf96ae943e43563cbbaa26e21b656b6fe8f4b0f

Looks pretty neat, but I'll reserve judgement for when I see the
conversion of the XFS radix tree code....

> I've been pretty liberal with the kernel-doc, but I haven't written out
> a good .rst file to give an overview of how to use it.

Let me know when you've written it :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
