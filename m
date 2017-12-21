Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752615AbdLULDd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 06:03:33 -0500
Date: Thu, 21 Dec 2017 12:03:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20171221110329.GG31584@quack2.suse.cz>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
 <20171130171310.GG28180@quack2.suse.cz>
 <20171130190548.GJ729@wotan.suse.de>
 <20171201114724.GC8365@quack2.suse.cz>
 <20171201211327.GQ729@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171201211327.GQ729@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Kara <jack@suse.cz>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

I think I owe you a reply here... Sorry that it took so long.

On Fri 01-12-17 22:13:27, Luis R. Rodriguez wrote:
> On Fri, Dec 01, 2017 at 12:47:24PM +0100, Jan Kara wrote:
> > On Thu 30-11-17 20:05:48, Luis R. Rodriguez wrote:
> > > > In fact, what might be a cleaner solution is to introduce a 'freeze_count'
> > > > for superblock freezing (we already do have this for block devices). Then
> > > > you don't need to differentiate these two cases - but you'd still need to
> > > > properly handle cleanup if freezing of all superblocks fails in the middle.
> > > > So I'm not 100% this works out nicely in the end. But it's certainly worth
> > > > a consideration.
> > > 
> > > Ah, there are three important reasons for doing it the way I did it which are
> > > easy to miss, unless you read the commit log message very carefully.
> > > 
> > > 0) The ioctl interface causes a failure to be sent back to userspace if
> > > you issue two consecutive freezes, or two thaws. Ie, once a filesystem is
> > > frozen, a secondary call will result in an error. Likewise for thaw.
> > 
> > Yep. But also note that there's *another* interface to filesystem freezing
> > which behaves differently - freeze_bdev() (used internally by dm). That
> > interface uses the counter and freezing of already frozen device succeeds.
> 
> Ah... so freeze_bdev() semantics matches the same semantics I was looking
> for.
> 
> > IOW it is a mess.
> 
> To say the least.
> 
> > We cannot change the behavior of the ioctl but we could
> > still provide an in-kernel interface to freeze_super() with the same
> > semantics as freeze_bdev() which might be easier to use by suspend - maybe
> > we could call it 'exclusive' (for the current freeze_super() semantics) and
> > 'non-exclusive' (for the freeze_bdev() semantics) since this is very much
> > like O_EXCL open of block devices...
> 
> Sure, now typically I see we make exclusive calls with the postfix _excl() so
> I take it you'd be OK in renaming freeze_super() freeze_super_excl() eventually
> then?

In principle yes but let's leave the naming disputes to a later time when
it is clear what API do we actually want to provide.

> I totally missed freeze_bdev() otherwise I think I would have picked up on the
> shared semantics stuff and I would have just made a helper out of what
> freeze_bdev() uses, and then have both in-kernel and freeze_bdev() use it.
> 
> I'll note that its still not perfectly clear if really the semantics behind
> freeze_bdev() match what I described above fully. That still needs to be
> vetted for. For instance, does thaw_bdev() keep a superblock frozen if we
> an ioctl initiated freeze had occurred before? If so then great. Otherwise
> I think we'll need to distinguish the ioctl interface. Worst possible case
> is that bdev semantics and in-kernel semantics differ somehow, then that
> will really create a holy fucking mess.

I believe nobody really thought about mixing those two interfaces to fs
freezing and so the behavior is basically defined by the implementation.
That is:

freeze_bdev() on sb frozen by ioctl_fsfreeze() -> EBUSY
freeze_bdev() on sb frozen by freeze_bdev() -> success
ioctl_fsfreeze() on sb frozen by freeze_bdev() -> EBUSY
ioctl_fsfreeze() on sb frozen by ioctl_fsfreeze() -> EBUSY

thaw_bdev() on sb frozen by ioctl_fsfreeze() -> EINVAL
ioctl_fsthaw() on sb frozen by freeze_bdev() -> success

What I propose is the following API:

freeze_super_excl()
  - freezes superblock, returns EBUSY if the superblock is already frozen
    (either by another freeze_super_excl() or by freeze_super())
freeze_super()
  - this function will make sure superblock is frozen when the function
    returns with success. It can be nested with other freeze_super() or
    freeze_super_excl() calls (this second part is different from how
    freeze_bdev() behaves currently but AFAICT this behavior is actually
    what all current users of freeze_bdev() really want - just make sure
    fs cannot be written to)
thaw_super()
  - counterpart to freeze_super(), would fail with EINVAL if we were to
    drop the last "freeze reference" but sb was actually frozen with
    freeze_super_excl()
thaw_super_excl()
  - counterpart to freeze_super_excl(). Fails with EINVAL if sb was not
    frozen with freeze_super_excl() (this is different to current behavior
    but I don't believe anyone relies on this and doing otherwise is asking
    for data corruption).

I'd implement it by a freeze counter in the superblock (similar to what we
currently have in bdev) where every call to freeze_super() or
freeze_super_excl() would add one. Additionally we'd have a flag in the
superblock whether the first freeze (it could not be any other since those
would fail with EBUSY) came from freeze_super_excl().

Then we could make ioctl interface use the _excl() variant of the freezing
API, freeze_bdev() would use the non-exclusive variant (we could drop the
freeze counter in bdev completely), your freezing on suspend could then use
the non-exclusive variant as well.

Also when doing this, you'd need to move code like:

        if (sb->s_op->freeze_super)
                error = sb->s_op->freeze_super(sb);
        else
                error = freeze_super(sb);

into the freeze_super() / freeze_super_excl() handler behind the
freeze counting code which might be a bit tricky WRT locking. GFS2 is the
only fs having ->freeze_super() and that callback was implemented specifically
so that it can do its own (cluster wide) locking before generic code grabbing
s_umount semaphore. Then internally GFS2 ends up calling freeze_super()
from freeze_go_sync() when cluster lock is acquired.


> > 2) It is not that normal users + one special user (who owns the "flag" in
> > the superblock in form of a special freeze state) setup. We'd simply have
> > exclusive and non-exclusive users of superblock freezing and there can be
> > arbitrary numbers of them.
> 
> Sorry I did not understand this point. Can you rephrase perhaps a bit?
> 
> Anyway, I just tried implementing this and it seemed rather easy to
> use a pivot, however note that then freeze_processes() which calls
> fs_suspend_freeze() would somehow need to pass the failed sb... do
> we want to have let fs_suspend_freeze() pass a parameter to be set
> to the failed sb of it failed? Locking-wise this seems racy.

So with your iterate_supers_excl() doing this is somewhat difficult but you
could have something like:

int freeze_all_supers(void)
{
	struct super_block *sb, *p = NULL;
	int error = 0;

	spin_lock(&sb_lock);
	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
		if (hlist_unhashed(&sb->s_instances))
			continue;
		sb->s_count++;
		spin_unlock(&sb_lock);

		down_write(&sb->s_umount);
		if (sb->s_root && (sb->s_flags & SB_BORN)) {
			error = freeze_super(sb, arg);
			if (error) {
				up_write(&sb->s_umount);
				spin_lock(&sb_lock);
				if (p)
					__put_super(p);
				p = sb;
				list_for_each_entry_continue(sb, &super_blocks,
							     s_list) {
					if (hlist_unhashed(&sb->s_instances))
						continue;
					sb->s_count++;
					spin_unlock(&sb_lock);

					down_write(&sb->s_umount);
					if (sb->s_root && (sb->s_flags & SB_BORN))
						thaw_super(sb, arg);
					up_write(&sb->s_umount);

					spin_lock(&sb_lock);
					if (p)
						__put_super(p);
					p = sb;
				}
				break;
			}
		}
		up_write(&sb->s_umount);

		spin_lock(&sb_lock);
		if (p)
			__put_super(p);
		p = sb;
	}
	if (p)
		__put_super(p);
	spin_unlock(&sb_lock);

	return error;
}

And you could possibly factor that out into two helper functions for
iterating the superblocks, just they'd need more parameters and you'd need
to pass reference (sb->count) when passing in the 'pivot' as you call it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
