Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6736F7CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 18:54:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D87D0AC001
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:54:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	C5z19R9VImSiQCRp for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 16:54:28 -0700 (PDT)
Date: Wed, 29 May 2013 09:54:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATH 0/9] xfs: fixes for 3.10-rc4
Message-ID: <20130528235424.GY29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<20130528175627.GZ20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130528175627.GZ20028@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, May 28, 2013 at 12:56:27PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, May 27, 2013 at 04:38:18PM +1000, Dave Chinner wrote:
> > This is an update for all the fixes I have for 3,10-rc4.
> > 
> > All the comments on the previous patches have been updated in this
> > series, and there are two new patches. The first patch adds support
> > for indicating that the filesystem has CRC enabled to userspace, and
> > the second fixes the missing CRC updates on the unlinked inode list
> > manipulations.
> 
> This seems to be getting a bit out of hand for a release candidate pull
> request:

You don't need to send them all at once. The ones you committed from
my initial -rc2 series could just be sent to Linus immediately, and
that halves the current outstanding queue. Then there's only 8-9
patches remaining...

> 
> Fixes for xfs without crcs:
> f648167f xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
> 	 xfs: fix split buffer vector log recovery support
> 	 xfs: kill suid/sgid through the truncate path.

And the log recovery ordering fix I just sent out.

> Fixes for xfs with crcs:
> 90253cf1 xfs: remote attribute allocation may be contiguous 
> 913e96bc xfs: remote attribute read too short
> 4af3644c xfs: remote attribute tail zeroing does too much
> 6863ef84 xfs: correctly map remote attr buffers during removal
> 8517de2a xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
> d4c712bc xfs: fully initialise temp leaf in xfs_attr3_leaf_compact

All of which fix filesystem corruption or - in the case of the
buffer cache coherency problems -  can lead to stale data exposure.

> ad1858d7 xfs: rework remote attr CRCs

Fixes cache coherency issues via a change in the on-disk format for
remote attributes. We need to get that included before a full
release is made, otherwise we need feature bits to distinguish
between the original and the new formats. 

> 9a5b6dee xfs: fix incorrect remote symlink block count
> 	 xfs: rework dquot CRCs

More filesystem corruption fixes.

> 	 xfs: inode unlinked list needs to recalculate the inode CRC 	* replaced with "2-3 patches"

Another corruption fix, now with an addition log recovery ordering
fix which prevents log recovery from potentially causing silent
filesystem corruption.

> 	 xfs: fix dir3 freespace block corruption			* maybe this effects filesystems w/o crcs?

Again, a filesystem corruption, including fixing a problem in the
on-disk format definition. While it probably doesn't affect
non-crc filesystems, it's a landmine that should be removed....

> Dev work for xfs with crcs:
> 	 xfs: increase number of ACL entries for V5 superblocks

On disk format change. We need to get that out before release,
otherwise it needs a feature bit.

> 	 xfs: don't emit v5 superblock warnings on write

Fixes a nasty log spamming problem. Certainly not development code.

> 	 xfs: add fsgeom flag for v5 superblock support.

Needed for userspace support of CRC filesystems, trivial patch. if
we expect anyone to test this kernel code, we need this patch so
userspace can correctly identify crc-enabled filesystems.

> 	 xfs: disable swap extents ioctl on CRC enabled filesystems

Filesystem corruption fix, caused simply by running xfs_fsr.

But, really, this entire series is not that much change in terms of
volume:

$ git diff --stat b38958d..bf6331a -- fs/xfs
 fs/xfs/xfs_acl.c         |   31 ++--
 fs/xfs/xfs_acl.h         |   30 +++-
 fs/xfs/xfs_attr_leaf.c   |   74 ++++++---
 fs/xfs/xfs_attr_remote.c |  408 +++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_attr_remote.h |   10 ++
 fs/xfs/xfs_buf.c         |    1 +
 fs/xfs/xfs_buf_item.c    |    7 +-
 fs/xfs/xfs_dfrag.c       |    8 +
 fs/xfs/xfs_dir2_format.h |    1 +
 fs/xfs/xfs_dir2_node.c   |   13 +-
 fs/xfs/xfs_dquot.c       |   37 ++---
 fs/xfs/xfs_fs.h          |    1 +
 fs/xfs/xfs_fsops.c       |    4 +-
 fs/xfs/xfs_inode.c       |   42 ++++-
 fs/xfs/xfs_iops.c        |   47 ++++--
 fs/xfs/xfs_log_recover.c |   95 ++++++++++-
 fs/xfs/xfs_mount.c       |   18 ++-
 fs/xfs/xfs_qm.c          |   36 +++--
 fs/xfs/xfs_qm_syscalls.c |   40 +++--
 fs/xfs/xfs_quota.h       |    2 +
 fs/xfs/xfs_symlink.c     |   20 +--
 21 files changed, 612 insertions(+), 313 deletions(-)

And a large proportion of that change is the single attr CRC rework
patch.

> We're representing 3 patches which are clearly approprate for a release
> candidate, 11 fixes for CRCs + 2 more for the rework of unlinked lists patch,
> and 4 patches which are development work.

Most file filesystem corruptions. Without those fixes, CRC enabled
filesystems simple cannot be used without all these patches being
applied.  It's not an experimental feature at this point - it's just
broken.

> We pulled in the CRC work with the understanding that it is an
> experimental feature that might not be perfect, and with a focus
> upon preventing regression for existing users.  This did not imply
> that we're going after perfection for CRCs during the 3.10 release
> candidate series.

Right, but there was also the understanding that the CRC code would
be usable by release time, and so there would be fixes committed
throughout the -rc series to fix problems with the CRC code so that
it is usable.

As it is, the result of all these patches is that xfstests is almost
entirely passing on a 4k block size filesystem. The only tests that
aren't passing are those that already fail or require userspace
support that isn't currently available (e.g. xfs-db write support,
metadump). And 1k block size filesystems mostly pass xfstests, too,
though there are random assert failures from time to time.

IOWs after this patch set is applied, the CRC functionality fits the
definition of the 'experimental' tag.  It mostly works, but still
has some lurking issues that need to be flushed out. I'm unlikely to
be posting 2-3 bug fix patches a day from this point onwards....

Indeed, the last two days I've been doing 3.11 development work
because xfstests on CRC enabled filesystems is now usable for
regression testing. i.e. the majority of the "easy-to-hit" problems
have been flushed out by this patchset.

> I'll be happy to review the 17 CRC related patches for inclusion
> in the master branch ASAP,

That's a good start, but...

> but I'm afraid 17 patches is a bit much
> to ask for a release candidate, even if it were -rc2.

... I think you're being way too conservative here.

BTRFS in january for an -rc merge:

https://lkml.org/lkml/2013/1/25/11

That was 30 commits and +300/-100 lines. There was a another pull
request 2 weeks later with another 9 commits. The same thing
happened with the RAID5/6 integration into btrfs in 3.9 - the -rc
merges following it had 13, 7 and 15 commits. And for 3.10-rc, the
first post-rc1 merge was 25 commits (+350/-250 lines).

And if you want another example, the ext4 extent status cache fixes
that went into 3.9-rc4:

https://lkml.org/lkml/2013/3/21/644

that was 21 commits and +540/-81 lines.

Yup, new filesystem code has bugs, and they get fixed in -rc
releases. What makes new XFS code so special we can't do this?

The amount of change we are talking about here is not unreasonable
even for an -rc4 release, as evidenced by other filesystems under
development. Hence I don't think "it's too late" is really a viable
reason for not fixing all these filesystem corruption issues in the
CRC code...

> Here we are in 3.11/feature-bit territory.

I'd much prefer that we don't have to add code to 3.11 to reject any
CRC-enabled filesystem without any feature bits set because we don't
support a broken remote attr format that was fixed weeks before 3.10
released but was not allowed to be fixed in 3.10. That's just crazy
from any release management perspective you care to look at it from.

Ben, if the problem is that you can't review all the fixes in a
timely manner, then we can fix that. I'm sure that Mark, Eric and
Brian can help review the code if this is the sticking point.  There
are also people like Michael who are actively testing the CRC code
and reporting bugs to me all the time, so there's demand for these
fixes to be integrated into the 3.10 tree...

Everyone knew there would be fixes for the CRC code coming along in
the -rc period - we discussed it on the weekly concall before the
the CRC code was merged into 3.10. Hence I'm a bit surprised to get
what appears to be a blanket rejection for these fixes to the CRC
code this early in the 3.10-rc cycle.

Let's not waste all the effort that we put into getting the CRC code
into 3.10 by not fixing known corruptions and on-disk format
deficiencies. Releasing CRC support in a seriously broken state that
we need to add permanent workarounds for in 3.11 is about the worst
possible outcome that could occur right now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
