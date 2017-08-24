Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53593 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753314AbdHXSNU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 14:13:20 -0400
Date: Thu, 24 Aug 2017 20:13:18 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170824181318.GM27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824180441.GL27873@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On the other thread we can discuss the configuration file parser used,
this other thread we can use for the sysfs knobs and if it makes sense
to share anything in consideration for a possible future udev event.
More below.

On Thu, Aug 24, 2017 at 08:04:41PM +0200, Luis R. Rodriguez wrote:
> On Thu, Aug 24, 2017 at 10:10:28AM -0700, Darrick J. Wong wrote:
> > It might be useful to send kobject_uevent_env so that we can squeeze in
> > things like the fs uuid for easier identification?  I envision a
> > /etc/xfs/fs.conf file like this:
> > 
> > [903db5b1-82cd-4f26-8221-443a4ed0563a]
> > error.metadata.EIO.max_retries = 0
> > error.fail_at_unmount = 1
> > config.cowextsize = 1048576
> > config.inherit_noatime = 1
> > 
> > With a udev helper that uses the fsuuid to find the appropriate section
> > of the ini^Wconfig file and load the appropriate values into sysfs.
> 
> While all this is nice, I'm sure we're all aware of the dangers of setting
> things in stone through sysfs, its likely already decided for the above
> tunables,

<-- udev thing and now snip -->

> Just saying, we better damn be sure this is the way we want to go.
> 
> > > +	if (err)
> > > +		xfs_notice(mp, "Sending XFS uevent %d got error %d",
> > > +				action, err);
> > > +}
> > > +
> > >  STATIC int
> > >  xfs_fs_fill_super(
> > >  	struct super_block	*sb,
> > > @@ -1667,6 +1680,8 @@ xfs_fs_fill_super(
> > >  		goto out_unmount;
> > >  	}
> > >  
> > > +	xfs_fs_uevent(mp, KOBJ_ONLINE);
> > 
> > That said, I wonder if we ought to move this discussion to fsdevel to
> > pull in any /other/ filesystems that have sysfs knobs that they might
> > like to be able to persist?  ext4 has a bunch of tunables too...

So were you thinking perhaps if we are going to use udev that it may make
sense then to instead consider if we want to share tunables for uevents?
Then instead of each filesystem having its own parser, etc, we have set
of common knobs for any filesystem possible.

Is that what you had in mind to discuss?

  Luis
