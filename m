Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36226 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752792AbdAZGol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2017 01:44:41 -0500
Date: Wed, 25 Jan 2017 22:44:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 0/9] xfstests: online scrub/repair support
Message-ID: <20170126064434.GD2584@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <20170126050838.GN1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170126050838.GN1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jan 26, 2017 at 01:08:38PM +0800, Eryu Guan wrote:
> On Sat, Jan 21, 2017 at 12:10:19AM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is the fifth revision of a patchset that adds to XFS userland tools
> > support for online metadata scrubbing and repair.
> > 
> > The new patches in this series do three things: first, they expand the
> > filesystem populate commands inside xfstests to be able to create all
> > types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
> > functions to iterate all fields present in a given metadata object and
> > fuzz them in various ways.  Finally, for each metadata object type there
> > is a separate test that iteratively fuzzes all fields of that object and
> > runs it through the mount/scrub/repair loop to see what happens.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> 
> Are your github trees synced with kernel.org trees? Seems so, and I did
> my tests with your kernel.org trees.

Yes, they are.  (Or at least they should be, if I did it correctly.)

> > The kernel patches in the git trees should apply to 4.10-rc4; xfsprogs
> > patches to for-next; and xfstest to master.
> > 
> > The patches have survived all auto group xfstests both with scrub-only
> > mode and also a special debugging mode to xfs_scrub that forces it to
> > rebuild the metadata structures even if they're not damaged.
> 
> I have trouble finishing running all the tests so far, the tests need
> long time to run and in some tests xfs_repair or xfs_scrub are just

Yes, the amount of dmesg noise slows the tests wayyyyyy down.  One of
the newer patches reduces the amount of spew when the scrubbers are
running.

(FWIW when I run them I have a debug patch that shuts up all the
warnings.)

> spinning there, sometimes I can kill them to make test continue,

There are some undiagnosed deadlocks in xfs_repair, and some OOM
problems in xfs_db that didn't get fixed until recently.

> sometimes I can't (e.g. xfs/1312, I tried to kill the xfs_scrub process,
> but it became <defunc>).

That's odd.  Next time that happens can you sysrq-t to find out where
the scrub threads are stuck, please?

> And in most tests I have run, I see such failures:
> 
>     +scrub didn't fail with length = ones.
>     +scrub didn't fail with length = firstbit.
>     +scrub didn't fail with length = middlebit.
>     +scrub didn't fail with length = lastbit.
>     ....
> 
> Not sure if that's expected?

Yes, that's expected.  The scrub routines expect that the repairing
program (xfs_{scrub,repair}) will complain about the corrupt field,
repair it, and a subsequent re-run will exit cleanly.  There are quite a
few fields like uid/gid and timestamps that have no inherent meaning to
XFS.  As a result, there's no problem to be detected.  Some of the
fuzzes will prevent the fs from mounting, which causes other error
messages.

The rest could be undiagnosed problems in other parts of XFS (or scrub).
I've not had time to triage a lot of it.  I've been recording exactly
what and where things fail and I'll have a look at them as time allows.

> I also hit xfs_scrub and xfs_repair double free bug in xfs/1312 (perhaps
> that's why I can't kill it).

Maybe.  In theory the page refcounts get reset, I think, but I've seen
the VM crash with double-fault errors and other weirdness that seem to
go away when the refcount bugs go away.

> OTOH, all these failures/issues seem like kernel or userspace bug, I
> went through all the patches and new tests and I didn't find anything
> wrong obviously. So I think it's fine to merge them in this week's
> update. Unless you have a second thought?

Sure.  I will never enable them in any of the heavily used groups, so
that should be fine.  Though I do have a request -- the 13xx numbers are
set up so that if test (1300+x) fuzzes object X and tries to xfs_repair
it, then test (1340+x) fuzzes the same X but tries to xfs_scrub it.
Could you interweave them when you renumber the tests?

e.g. 1302 -> 510, 1342 -> 511, 1303 -> 512, 1343 -> 513?

That'll help me to keep together the repair & scrub fuzz tests.

--D
