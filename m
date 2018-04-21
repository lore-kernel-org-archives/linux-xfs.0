Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40590 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbeDUSnO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Apr 2018 14:43:14 -0400
Date: Sat, 21 Apr 2018 11:42:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/11] xfs: create the XFS_QMOPT_QUOTIP_LOCKED flag
Message-ID: <20180421184251.GA26268@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401917977.11465.9543981144688523511.stgit@magnolia>
 <20180419083224.GA17515@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419083224.GA17515@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 01:32:24AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 17, 2018 at 07:39:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a new QMOPT flag to signal that we've already locked the quota
> > inode.  This will be used by the quota scrub code refactoring to avoid
> > dropping the quota ip lock during scrub.  The flag is incompatible with
> > the DQALLOC flag because dquot allocation creates a transaction, and we
> > shouldn't be doing that with the ILOCK held.
> 
> Locked flag are always a sign for code smell.  And this already is
> pretty smelly code before that flag is added.  I think someone (i.e.
> either you or me :)) needs to do a major refactoring here first.

Bleh... ok, I marched through that swamp and refactored all that goopy
dqget crud into a ton of smaller helper functions that only do one thing,
killed off QMOPT_NEXT, and renamed DQALLOC to make it obvious it's for
dqget only.  So now we have...

xfs_qm_dqget (get dquot based on id/type, can take XFS_DQGET_DQALLOC to
allocate if not present)

xfs_qm_dqget_inode (get dquot based on inode/type, contains all the
locking and looping mess to one function, can take _DQALLOC)

xfs_qm_dqget_next (get this or the next higher dquot, no DQALLOC allowed
here, contain all the NEXT looping mess to this function)

xfs_qm_dqread (read dquot from disk and return incore dquot, do not
check in radix tree, no longer takes DQALLOC)

xfs_qm_dqiterate (iterate all the dquots for the given quota type)

I also cleaned out a bunch of unnecessary parameters and other junk,
and refactored mount time quotacheck so that it doesn't need to
ILOCK_EXCL every inode in the system.  In theory that should be fine
because we only needed ILOCK_EXCL to make sure nobody can chown/chproj
the inode on us, which shouldn't be happening during mount.

As a bonus I realized that scrub and repair don't actually need to
maintain the ilock once they're done fixing all of the things that can
cause dqget to fail, so the ILOCKED flag goes away entirely.

Will have a revised megaseries out on the list ideally some time before
LSF starts... though it did add another 12 patches to the review queue. :P

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
