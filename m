Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753340AbeDUXx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Apr 2018 19:53:28 -0400
Date: Sun, 22 Apr 2018 01:53:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20180421235323.ndj3gx65n7kmv5ta@quack2.suse.cz>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
 <20171130171310.GG28180@quack2.suse.cz>
 <20171130190548.GJ729@wotan.suse.de>
 <20171201114724.GC8365@quack2.suse.cz>
 <20171201211327.GQ729@wotan.suse.de>
 <20171221110329.GG31584@quack2.suse.cz>
 <20180418005936.j3fa5rogfm353clf@garbanzo.do-not-panic.com>
 <20180420184932.57as7jup75nx463v@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420184932.57as7jup75nx463v@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Kara <jack@suse.cz>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jlayton@redhat.com

On Fri 20-04-18 11:49:32, Luis R. Rodriguez wrote:
> On Tue, Apr 17, 2018 at 05:59:36PM -0700, Luis R. Rodriguez wrote:
> > On Thu, Dec 21, 2017 at 12:03:29PM +0100, Jan Kara wrote:
> > > Hello,
> > > 
> > > I think I owe you a reply here... Sorry that it took so long.
> > 
> > Took me just as long :)
> > 
> > > On Fri 01-12-17 22:13:27, Luis R. Rodriguez wrote:
> > > > 
> > > > I'll note that its still not perfectly clear if really the semantics behind
> > > > freeze_bdev() match what I described above fully. That still needs to be
> > > > vetted for. For instance, does thaw_bdev() keep a superblock frozen if we
> > > > an ioctl initiated freeze had occurred before? If so then great. Otherwise
> > > > I think we'll need to distinguish the ioctl interface. Worst possible case
> > > > is that bdev semantics and in-kernel semantics differ somehow, then that
> > > > will really create a holy fucking mess.
> > > 
> > > I believe nobody really thought about mixing those two interfaces to fs
> > > freezing and so the behavior is basically defined by the implementation.
> > > That is:
> > > 
> > > freeze_bdev() on sb frozen by ioctl_fsfreeze() -> EBUSY
> > > freeze_bdev() on sb frozen by freeze_bdev() -> success
> > > ioctl_fsfreeze() on sb frozen by freeze_bdev() -> EBUSY
> > > ioctl_fsfreeze() on sb frozen by ioctl_fsfreeze() -> EBUSY
> > > 
> > > thaw_bdev() on sb frozen by ioctl_fsfreeze() -> EINVAL
> > 
> > Phew, so this is what we want for the in-kernel freezing so we're good
> > and *can* combine these then.
> 
> I double checked, and I don't see where you get EINVAL for this case.
> We *do* keep the sb frozen though, which is good, and the worst fear
> I had was that we did not. However we return 0 if there was already
> a prior freeze_bdev() or ioctl_fsfreeze() other than the context that
> started the prior freeze (--bdev->bd_fsfreeze_count > 0).
> 
> The -EINVAL is only returned currently if there were no freezers.
> 
> int thaw_bdev(struct block_device *bdev, struct super_block *sb)
> {
> 	int error = -EINVAL;
> 
> 	mutex_lock(&bdev->bd_fsfreeze_mutex);
> 	if (!bdev->bd_fsfreeze_count)
> 		goto out;

But this is precisely where we'd bail if we freeze sb by ioctl_fsfreeze()
but try to thaw by thaw_bdev(). ioctl_fsfreeze() does not touch
bd_fsfreeze_count...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
