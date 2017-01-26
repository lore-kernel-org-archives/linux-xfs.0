Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752723AbdAZFIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 00:08:41 -0500
Date: Thu, 26 Jan 2017 13:08:38 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v5 0/9] xfstests: online scrub/repair support
Message-ID: <20170126050838.GN1859@eguan.usersys.redhat.com>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, Jan 21, 2017 at 12:10:19AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is the fifth revision of a patchset that adds to XFS userland tools
> support for online metadata scrubbing and repair.
> 
> The new patches in this series do three things: first, they expand the
> filesystem populate commands inside xfstests to be able to create all
> types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
> functions to iterate all fields present in a given metadata object and
> fuzz them in various ways.  Finally, for each metadata object type there
> is a separate test that iteratively fuzzes all fields of that object and
> runs it through the mount/scrub/repair loop to see what happens.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].

Are your github trees synced with kernel.org trees? Seems so, and I did
my tests with your kernel.org trees.

> The kernel patches in the git trees should apply to 4.10-rc4; xfsprogs
> patches to for-next; and xfstest to master.
> 
> The patches have survived all auto group xfstests both with scrub-only
> mode and also a special debugging mode to xfs_scrub that forces it to
> rebuild the metadata structures even if they're not damaged.

I have trouble finishing running all the tests so far, the tests need
long time to run and in some tests xfs_repair or xfs_scrub are just
spinning there, sometimes I can kill them to make test continue,
sometimes I can't (e.g. xfs/1312, I tried to kill the xfs_scrub process,
but it became <defunc>).

And in most tests I have run, I see such failures:

    +scrub didn't fail with length = ones.
    +scrub didn't fail with length = firstbit.
    +scrub didn't fail with length = middlebit.
    +scrub didn't fail with length = lastbit.
    ....

Not sure if that's expected?

I also hit xfs_scrub and xfs_repair double free bug in xfs/1312 (perhaps
that's why I can't kill it).

OTOH, all these failures/issues seem like kernel or userspace bug, I
went through all the patches and new tests and I didn't find anything
wrong obviously. So I think it's fine to merge them in this week's
update. Unless you have a second thought?

Thanks,
Eryu
