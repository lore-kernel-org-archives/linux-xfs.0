Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32778 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdJDBmX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 21:42:23 -0400
Date: Tue, 3 Oct 2017 21:42:04 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 4/5] ext4: add fs freezing support on suspend/hibernation
Message-ID: <20171004014204.mztkdnm7wb7r6sl2@thunk.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-5-mcgrof@kernel.org>
 <20171003195930.ivgaccdabxczar62@thunk.org>
 <20171003201321.GE2294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003201321.GE2294@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 10:13:21PM +0200, Luis R. Rodriguez wrote:
> > After we remove add the NEEDS_RECOVERY flag, we need to make sure
> > recovery flag is pushed out to disk before any other changes are
> > allowed to be pushed out to disk.  That's why we originally did the
> > update synchronously.
> 
> I see. I had to try to dig through linux-history to see why this was done, and
> I actually could not find an exact commit which explained what you just did.
> Thanks!
> 
> Hrm, so on freeze we issue the same commit as well, so is a sync *really* needed
> on thaw?

So let me explain what's going on.  When we do a freeze, we make sure
all of the blocks that are written to the journal are writen to the
final location on disk, and the journal is is truncated.  (This is
called a "journal checkpoint".)  Then we clear the NEEDS RECOVERY
feature flag and set the EXT4_VALID_FS flags in the superblock.  In
the no journal case, we flush out all metadata writes, and we set the
EXT4_VALID_FS flag.  In both cases, we call ext4_commit_super(sb, 1)
to make sure the flags update is pushed out to disk.  This puts the
file system into a "quiscent" state; in fact, it looks like the file
system has been unmounted, so that it becomes safe to run
dump/restore, run fsck -n on the file system, etc.

The problem on the thaw side is that we need to make sure that
EXT4_VALID_FS flag is removed (and if journaling is enabled, the NEEDS
RECOVERY feature flag is set) and the superblock is flushed out to the
storage device before any other writes are persisted on the disk.  In
the case where we have journalling enabled, we could wait until the
first journal commit to write out the superblock, since in journal
mode all metadata updates to the disk are suppressed until the journal
commit.  We don't do that today, but it is a change we could make.

However, in the no journal node we need to make sure the EXT4_VALID_FS
flag is cleared on disk before any other metadata operations can take
place, and calling ext4_commit_super(sb, 1) is the only real way to do
that.

> No, it was am empirical evaluation done at testing, I observed bio_submit()
> stalls, we never get completion from the device. Even if we call thaw at the
> very end of resume, after the devices should be up, we still end up in the same
> situation. Given how I order freezing filesystems after freezing userspace I do
> believe we should thaw filesystems prior unfreezing userspace, its why I placed
> the call where it is now.

So when we call ext4_commit_super(sb, 1), we issue the bio, and then
we block waiting for the I/O to complete.  That's a blocking call.  Is
the thaw context one which allows blocking?  If userspace is still
frozen, does that imply that the scheduler isn't allow to run?  If
that's the case, then that's probably the problem.

More generally, if the thawing code needs to allocate memory, or do
any number of things that could potentially block, this could
potentially be an issue.  Or if we have a network block device, or
something else in the storage stack that needs to run a kernel thread
context (or a workqueue, etc.) --- is the fact that userspace is
frozen mean the scheduler is going to refuse to schedule()?

I know at one point we made a distinction between freezing userspace
threads and kernel threads, but were there people who didn't like this
because of unnecessary complexity.  It sounds to me like on the thaw
side, we might also need to unfreeze kernel threads first, and then
allow userspace threads to run.  Do we do that today, or in the new
freeze/thaw code?  It's been quite a while since I've looked at that
part of the kernel.

					- Ted
					
