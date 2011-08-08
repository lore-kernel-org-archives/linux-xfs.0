Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78LhTrA058231 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 16:43:30 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01A071891E83
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 14:43:28 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id Ur0TYok4haOOYOYM for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2011 14:43:27 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Mon, 8 Aug 2011 23:11:27 +0200
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl>
	<20110807001446.GI3162@dastard>
In-Reply-To: <20110807001446.GI3162@dastard>
MIME-Version: 1.0
Message-Id: <201108082311.28190.rjw@sisk.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph <cr2005@u-club.de>, Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

On Sunday, August 07, 2011, Dave Chinner wrote:
> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Freeze all filesystems during the freezing of tasks by calling
> > freeze_bdev() for each of them and thaw them during the thawing
> > of tasks with the help of thaw_bdev().
> > 
> > This is needed by hibernation, because some filesystems (e.g. XFS)
> > deadlock with the preallocation of memory used by it if the memory
> > pressure caused by it is too heavy.
> > 
> > The additional benefit of this change is that, if something goes
> > wrong after filesystems have been frozen, they will stay in a
> > consistent state and journal replays won't be necessary (e.g. after
> > a failing suspend or resume).  In particular, this should help to
> > solve a long-standing issue that in some cases during resume from
> > hibernation the boot loader causes the journal to be replied for the
> > filesystem containing the kernel image and initrd causing it to
> > become inconsistent with the information stored in the hibernation
> > image.
> > 
> > This change is based on earlier work by Nigel Cunningham.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> > OK, so nobody except for Pavel appears to have any comments, so I assume
> > that everyone except for Pavel is fine with the approach, interestingly enough.
> > 
> > I've removed the MS_FROZEN Pavel complained about from freeze_filesystems()
> > and added comments explaining why lockdep_off/on() are used.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  fs/block_dev.c         |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fs.h     |    6 +++++
> >  kernel/power/process.c |    7 +++++-
> >  3 files changed, 68 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/include/linux/fs.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/fs.h
> > +++ linux-2.6/include/linux/fs.h
> > @@ -211,6 +211,7 @@ struct inodes_stat_t {
> >  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
> >  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> >  #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
> > +#define MS_FROZEN	(1<<25) /* bdev has been frozen */
> >  #define MS_NOSEC	(1<<28)
> >  #define MS_BORN		(1<<29)
> >  #define MS_ACTIVE	(1<<30)
> > @@ -2047,6 +2048,8 @@ extern struct super_block *freeze_bdev(s
> >  extern void emergency_thaw_all(void);
> >  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
> >  extern int fsync_bdev(struct block_device *);
> > +extern void freeze_filesystems(void);
> > +extern void thaw_filesystems(void);
> >  #else
> >  static inline void bd_forget(struct inode *inode) {}
> >  static inline int sync_blockdev(struct block_device *bdev) { return 0; }
> > @@ -2061,6 +2064,9 @@ static inline int thaw_bdev(struct block
> >  {
> >  	return 0;
> >  }
> > +
> > +static inline void freeze_filesystems(void) {}
> > +static inline void thaw_filesystems(void) {}
> >  #endif
> >  extern int sync_filesystem(struct super_block *);
> >  extern const struct file_operations def_blk_fops;
> > Index: linux-2.6/fs/block_dev.c
> > ===================================================================
> > --- linux-2.6.orig/fs/block_dev.c
> > +++ linux-2.6/fs/block_dev.c
> > @@ -314,6 +314,62 @@ out:
> >  }
> >  EXPORT_SYMBOL(thaw_bdev);
> >  
> > +/**
> > + * freeze_filesystems - Force all filesystems into a consistent state.
> > + */
> > +void freeze_filesystems(void)
> > +{
> > +	struct super_block *sb;
> > +
> > +	/*
> > +	 * This is necessary, because some filesystems (e.g. ext3) lock
> > +	 * mutexes in their .freeze_fs() callbacks and leave them locked for
> > +	 * their .unfreeze_fs() callbacks to unlock.  This is done under
> > +	 * bdev->bd_fsfreeze_mutex, which is then released, but it makes
> > +	 * lockdep think something may be wrong when freeze_bdev() attempts
> > +	 * to acquire bdev->bd_fsfreeze_mutex for the next filesystem.
> > +	 */
> > +	lockdep_off();
> 
> I thought those problems were fixed. If they aren't, then they most
> certainly need to be because holding mutexes over system calls is a
> bug.
> 
> Well, well:
> 
> [252182.603134] ================================================
> [252182.604832] [ BUG: lock held when returning to user space! ]
> [252182.606086] ------------------------------------------------
> [252182.607400] xfs_io/4917 is leaving the kernel with locks still held!
> [252182.608905] 1 lock held by xfs_io/4917:
> [252182.609739]  #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff812a2aaf>] journal_lock_updates+0xef/0x100
> 
> <sigh>
> 
> Looks like the problem was fixed for ext4, but not ext3.  Please
> report this to the ext3/4 list and get it fixed, don't work around
> it here.

OK, but I guess I'll have to post a patch to fix this myself so that
anyone notices. :-)

> > +	/*
> > +	 * Freeze in reverse order so filesystems depending on others are
> > +	 * frozen in the right order (eg. loopback on ext3).
> > +	 */
> > +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> > +		if (!sb->s_root || !sb->s_bdev ||
> > +		    (sb->s_frozen == SB_FREEZE_TRANS) ||
> > +		    (sb->s_flags & MS_RDONLY))
> > +			continue;
> > +
> > +		freeze_bdev(sb->s_bdev);
> > +		sb->s_flags |= MS_FROZEN;
> > +	}
> 
> AFAIK, that won't work for btrfs - you have to call freeze_super()
> directly for btrfs because it has a special relationship with
> sb->s_bdev. And besides, all freeze_bdev does is get an active
> reference on the superblock and call freeze_super().

OK, so do you mean I should call freeze_super() rather than freeze_bdev()?

> Also, that's traversing the list of superblock with locking and
> dereferencing the superblock without properly checking that the
> superblock is not being torn down. You should probably use
> iterate_supers (or at least copy the code), with a function that
> drops the s_umount read lock befor calling freeze_super() and then
> picks it back up afterwards.

Hmm, I'll try that, but I doubt I'll get it right first time. :-)

> > +
> > +	lockdep_on();
> > +}
> > +
> > +/**
> > + * thaw_filesystems - Make all filesystems active again.
> > + */
> > +void thaw_filesystems(void)
> > +{
> > +	struct super_block *sb;
> > +
> > +	/*
> > +	 * This is necessary for the same reason as in freeze_filesystems()
> > +	 * above.
> > +	 */
> > +	lockdep_off();
> > +
> > +	list_for_each_entry(sb, &super_blocks, s_list)
> > +		if (sb->s_flags & MS_FROZEN) {
> > +			sb->s_flags &= ~MS_FROZEN;
> > +			thaw_bdev(sb->s_bdev, sb);
> > +		}
> 
> And once again, iterate_supers() is what you want here.

OK

> And you should only call thaw_bdev() as it needs to do checks other
> than checking MS_FROZEN

Hmm, I'm not really sure what you mean?

> e.g. the above will unfreeze filesystems that
> were already frozen at the time a suspend occurs, and that could
> lead to corruption depending on why the filesystem was frozen...
> 
> Also, you still need to check for a valid sb->s_bdev here, otherwise
> <splat>.

I see.

Thanks,
Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
