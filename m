Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2MFtx8x257954 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 10:56:00 -0500
Date: Thu, 22 Mar 2012 10:56:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [GIT PULL] XFS update for 3.4-rc1
Message-ID: <20120322155607.GK8451@sgi.com>
References: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
	<CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
	<20120321220652.GJ8451@sgi.com>
	<CA+55aFzzoLDs0MSo7zoNEDL7gzMmqR+Vr1WYh337xeSVyDhJ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFzzoLDs0MSo7zoNEDL7gzMmqR+Vr1WYh337xeSVyDhJ0w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus, =


On Wed, Mar 21, 2012 at 03:59:49PM -0700, Linus Torvalds wrote:
> On Wed, Mar 21, 2012 at 3:06 PM, Ben Myers <bpm@sgi.com> wrote:
> > Unfortunately the stuff in: =A0git://oss.sgi.com/xfs/xfs master
> >
> > Conflicts with the stuff in: =A0git://oss.sgi.com/xfs/xfs for-linus
> =

> There's still nothng in 'for-linus'.

D'oh.  I'll give it another whirl...

Please pull from git://oss.sgi.com/xfs/xfs for-linus  =


I've updated it with changes for 3.4.  We have scalability improvements
for quotas, log grant code cleanups, bugfixes and other cleanups large
and small.

> > I've resolved the conflict here: =A0git://oss.sgi.com/xfs/xfs for-linus=
-merged
> =

> I actually prefer to merge things myself to see what is up, especially
> since everybody else writes horrible merge messages (but also because
> I simply want to know what the conflicts are). I appreciate more
> complex pull requests that *also* have a "pre-merged" branch just in
> case (I tend to use that for verification if there was anything even
> remotely questionable going on), but I really do not generally want
> pre-merging.

I understand.  Here's a pre-merged branch (just in case):

git://oss.sgi.com/xfs/xfs for-linus-merged
 =

> I'm used to resolving conflicts. I'm so used to it, in fact, that
> there have been cases where I did it right despite not really knowing
> the code and the maintainer did it wrong, just because I know what to
> look for.
> =

> > I would like to figure out how to
> > 1) send important bugfixes upstream after rc1, and
> > 2) not hold up development commits to xfs/master, while
> > 3) avoiding conflicts like this.
> =

> Avoiding conflicts isn't that important. Getting too many of them
> implies that there is something odd going on. But a few conflicts due
> to upstream bugfixes are basically "normal". Judging by the merge I
> see, there wasn't anything complicated going on.

Ok, I won't worry too much about avoiding conflict anymore.  Summary and
diffstat below.

Thanks,
	Ben

The following changes since commit 30d73f375238441d6dc31de0d90bc39f5bb0bfe5:

  Merge tag 'dlm-3.4' of git://git.kernel.org/pub/scm/linux/kernel/git/teig=
land/linux-dlm (2012-03-21 13:54:22 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: only take the ILOCK in xfs_reclaim_inode()

Amit Sahrawat (1):
      xfs: kill the unused XFS_BB_FSB_OFFSET macro

Chandra Seetharaman (4):
      Define a new function xfs_this_quota_on()
      Define a new function xfs_inode_dquot()
      Change xfs_sb_from_disk() interface to take a mount pointer
      Define new macro XFS_ALL_QUOTA_ACTIVE and simply some usage

Christoph Hellwig (29):
      xfs: use a normal shrinker for the dquot freelist
      xfs: split tail_lsn assignments from log space wakeups
      xfs: do exact log space wakeups in xlog_ungrant_log_space
      xfs: remove xfs_trans_unlocked_item
      xfs: cleanup xfs_log_space_wake
      xfs: remove log space waitqueues
      xfs: add the xlog_grant_head structure
      xfs: add xlog_grant_head_init
      xfs: add xlog_grant_head_wake_all
      xfs: share code for grant head waiting
      xfs: share code for grant head wakeups
      xfs: share code for grant head availability checks
      xfs: split and cleanup xfs_log_reserve
      xfs: merge xfs_qm_export_dquot into xfs_qm_scall_getquota
      xfs: include reservations in quota reporting
      quota: make Q_XQUOTASYNC a noop
      xfs: use per-filesystem I/O completion workqueues
      xfs: do not require an ioend for new EOF calculation
      xfs: log file size updates as part of unwritten extent conversion
      xfs: log file size updates at I/O completion time
      xfs: log timestamp updates
      xfs: make xfs_inode_item_size idempotent
      xfs: split in-core and on-disk inode log item fields
      xfs: reimplement fdatasync support
      xfs: use common code for quota statistics
      xfs: per-filesystem dquot LRU lists
      xfs: use per-filesystem radix trees for dquot lookup
      xfs: remove the per-filesystem list of dquots
      xfs: remove the global xfs_Gqm structure

Dave Chinner (5):
      xfs: clean up minor sparse warnings
      xfs: fix inode lookup race
      xfs: remove remaining scraps of struct xfs_iomap
      xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
      xfs: fallback to vmalloc for large buffers in xfs_getbmap

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when compare is =
intended

Mitsuo Hayasaka (4):
      xfs: show uuid when mount fails due to duplicate uuid
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general
      xfs: cleanup quota check on disk blocks and inodes reservations

 fs/quota/quota.c         |    3 +-
 fs/xfs/Makefile          |    3 -
 fs/xfs/kmem.h            |    6 -
 fs/xfs/xfs_aops.c        |  183 +++++++----
 fs/xfs/xfs_aops.h        |    4 +-
 fs/xfs/xfs_bmap.c        |   13 +-
 fs/xfs/xfs_buf.c         |   17 -
 fs/xfs/xfs_dfrag.c       |   24 +-
 fs/xfs/xfs_dir2_block.c  |    1 +
 fs/xfs/xfs_dquot.c       |  539 +++++++++--------------------
 fs/xfs/xfs_dquot.h       |   49 ++--
 fs/xfs/xfs_file.c        |   84 +----
 fs/xfs/xfs_iget.c        |   41 ++-
 fs/xfs/xfs_inode.c       |   94 ++----
 fs/xfs/xfs_inode.h       |   23 +-
 fs/xfs/xfs_inode_item.c  |  297 ++++++----------
 fs/xfs/xfs_inode_item.h  |   16 +-
 fs/xfs/xfs_ioctl.c       |   14 +-
 fs/xfs/xfs_ioctl32.c     |    2 +-
 fs/xfs/xfs_iomap.c       |   19 +-
 fs/xfs/xfs_iops.c        |   71 +----
 fs/xfs/xfs_itable.c      |   21 +-
 fs/xfs/xfs_log.c         |  612 ++++++++++++++-------------------
 fs/xfs/xfs_log.h         |   16 +-
 fs/xfs/xfs_log_priv.h    |   28 +-
 fs/xfs/xfs_log_recover.c |   12 +-
 fs/xfs/xfs_mount.c       |    8 +-
 fs/xfs/xfs_mount.h       |    5 +-
 fs/xfs/xfs_qm.c          |  863 ++++++++++++++++--------------------------=
----
 fs/xfs/xfs_qm.h          |   63 +---
 fs/xfs/xfs_qm_bhv.c      |   42 +--
 fs/xfs/xfs_qm_stats.c    |  105 ------
 fs/xfs/xfs_qm_stats.h    |   53 ---
 fs/xfs/xfs_qm_syscalls.c |  134 +++-----
 fs/xfs/xfs_quota.h       |    2 +
 fs/xfs/xfs_quota_priv.h  |   11 -
 fs/xfs/xfs_sb.h          |    1 -
 fs/xfs/xfs_stats.c       |   99 +++++-
 fs/xfs/xfs_stats.h       |   10 +
 fs/xfs/xfs_super.c       |  164 +++++-----
 fs/xfs/xfs_super.h       |    8 +-
 fs/xfs/xfs_sync.c        |   46 +---
 fs/xfs/xfs_sync.h        |    2 -
 fs/xfs/xfs_trace.h       |   33 +-
 fs/xfs/xfs_trans.c       |   35 ++-
 fs/xfs/xfs_trans_ail.c   |   83 +----
 fs/xfs/xfs_trans_buf.c   |   25 +--
 fs/xfs/xfs_trans_dquot.c |   19 +-
 fs/xfs/xfs_trans_inode.c |    8 +-
 fs/xfs/xfs_trans_priv.h  |    3 -
 fs/xfs/xfs_vnode.h       |    1 -
 fs/xfs/xfs_vnodeops.h    |    3 -
 52 files changed, 1502 insertions(+), 2516 deletions(-)
 delete mode 100644 fs/xfs/xfs_qm_stats.c
 delete mode 100644 fs/xfs/xfs_qm_stats.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
