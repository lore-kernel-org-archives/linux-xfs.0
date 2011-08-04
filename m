Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MgBl7089708 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:42:11 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45F36B8D7C
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 15:42:07 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id UxQfSF7hlSvCh1o5 for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 15:42:07 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM / Freezer: Freeze filesystems along with freezing
	processes (was: Re: PM / hibernate xfs lock up /
	xfs_reclaim_inodes_ag)
Date: Fri, 5 Aug 2011 00:25:09 +0200
References: <4E1C70AD.1010101@u-club.de> <20110803172922.GA2126@ucw.cz>
	<201108041127.30944.rjw@sisk.pl>
In-Reply-To: <201108041127.30944.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201108050025.09792.rjw@sisk.pl>
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
To: Pavel Machek <pavel@ucw.cz>
Cc: Christoph <cr2005@u-club.de>, Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

On Thursday, August 04, 2011, Rafael J. Wysocki wrote:
> On Wednesday, August 03, 2011, Pavel Machek wrote:
> > Hi!
> > 
> > > Freeze all filesystems during the freezing of tasks by calling
> > > freeze_bdev() for each of them and thaw them during the thawing
> > > of tasks with the help of thaw_bdev().
> > > 
> > > This is needed by hibernation, because some filesystems (e.g. XFS)
> > > deadlock with the preallocation of memory used by it if the memory
> > > pressure caused by it is too heavy.
> > > 
> > > The additional benefit of this change is that, if something goes
> > > wrong after filesystems have been frozen, they will stay in a
> > > consistent state and journal replays won't be necessary (e.g. after
> > > a failing suspend or resume).  In particular, this should help to
> > > solve a long-standing issue that in some cases during resume from
> > > hibernation the boot loader causes the journal to be replied for the
> > > filesystem containing the kernel image and initrd causing it to
> > > become inconsistent with the information stored in the hibernation
> > > image.
> > 
> > > +/**
> > > + * freeze_filesystems - Force all filesystems into a consistent state.
> > > + */
> > > +void freeze_filesystems(void)
> > > +{
> > > +	struct super_block *sb;
> > > +
> > > +	lockdep_off();
> > 
> > Ouch. So... why do we need to silence this?
> 
> So that it doesn't complain? :-)
> 
> I'll need some time to get the exact details here.

So, this is because ext3_freeze() that doesn't call
journal_unlock_updates() on success, which quite frankly looks like
a bug in ext3 to me.  At least that's different from what ext4 does
in exactly the same situation (which looks correct).

If ext3_freeze() called journal_unlock_updates() on success too and
the call to journal_unlock_updates() is removed from ext3_unfreeze(),
we wouldn't need that lockdep_off()/lockdep_on() around the loop.

I need someone with ext3/ext4 knowledge to comment here, though.

Moreover, I'm not sure if other filesystems don't do such things.

Anyway, this is just a false-positive, even with the ext3 code as is.

> > > +	/*
> > > +	 * Freeze in reverse order so filesystems dependant upon others are
> > > +	 * frozen in the right order (eg. loopback on ext3).
> > > +	 */
> > > +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> > > +		if (!sb->s_root || !sb->s_bdev ||
> > > +		    (sb->s_frozen == SB_FREEZE_TRANS) ||
> > > +		    (sb->s_flags & MS_RDONLY) ||
> > > +		    (sb->s_flags & MS_FROZEN))
> > > +			continue;
> > 
> > Should we stop NFS from modifying remote server, too?
> 
> What do you mean exactly?
> 
> > Plus... ext3 writes to read-only filesystems on mount; not sure if it
> > does it later. But RDONLY means 'user cant write to it' not 'bdev will
> > not be modified'. Should we freeze all?
> > 
> > How can 'already frozen' happen?
> > 
> > > +	list_for_each_entry(sb, &super_blocks, s_list)
> > > +		if (sb->s_flags & MS_FROZEN) {
> > > +			sb->s_flags &= ~MS_FROZEN;
> > > +			thaw_bdev(sb->s_bdev, sb);
> > > +		}
> > 
> > ...because we'll unfreeze it even if we did not freeze it...
> 
> So we need not check MS_FROZEN in freeze_filesystems().  OK

Thanks,
Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
