Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52843 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751475AbdHXSEn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 14:04:43 -0400
Date: Thu, 24 Aug 2017 20:04:41 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Filesystem configuration parsers - (was: Re: [RESEND][PATCH] xfs:
 add online uevent for mount operation)
Message-ID: <20170824180441.GL27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824171028.GF4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

+ linux-fsdevel

On Thu, Aug 24, 2017 at 10:10:28AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2017 at 09:41:55PM +0800, Hou Tao wrote:
> > It will be useful if there is a corresponding online uevent after
> > a XFS filesystem has been mounted. A typical usage of the uevent
> > is setting the error configuration for a specific XFS filesystem
> > or all XFS filesystems by using udevd.
> > 
> > The following is an example of udevd rule which will shutdown
> > any XFS filesystem after the filesystem gets any IO error:
> > 
> >     ACTION=="online", SUBSYSTEM=="xfs", DEVPATH=="/fs/xfs/*", \
> >     RUN+="/bin/sh -c 'echo 0 > /sys%p/error/metadata/default/max_retries; \
> > 	    echo 0 > /sys%p/error/metadata/EIO/max_retries; \
> > 	    echo 0 > /sys%p/error/metadata/ENOSPC/max_retries; \
> > 	    echo 0 > /sys%p/error/metadata/ENODEV/max_retries'"
> >
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> >  fs/xfs/xfs_super.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 38aaacd..695fe85f 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1530,6 +1530,19 @@ xfs_destroy_percpu_counters(
> >  	percpu_counter_destroy(&mp->m_fdblocks);
> >  }
> >  
> > +static void
> > +xfs_fs_uevent(
> > +	struct xfs_mount	*mp,
> > +	enum kobject_action	action)
> > +{
> > +	int err;
> > +
> > +	err = kobject_uevent(&mp->m_kobj.kobject, action);
> 
> It might be useful to send kobject_uevent_env so that we can squeeze in
> things like the fs uuid for easier identification?  I envision a
> /etc/xfs/fs.conf file like this:
> 
> [903db5b1-82cd-4f26-8221-443a4ed0563a]
> error.metadata.EIO.max_retries = 0
> error.fail_at_unmount = 1
> config.cowextsize = 1048576
> config.inherit_noatime = 1
> 
> With a udev helper that uses the fsuuid to find the appropriate section
> of the ini^Wconfig file and load the appropriate values into sysfs.

Interesting, so yet-another possible configuration file for filesystems use
here could be of a udev helper scraping for matches. This in turn would mean
such udev helpers would need support to parse config files.

Reason I think this is important is it may raise the importance of evaluating
which file configuration parser we end up using for mkfs.xfs as well. While
they don't necessarily need to match, its perhaps ideal if they could. I
realize for instance e2fsprogs is using its own libprofile fork, and chances
of it moving off are low due to the gains libprofile provides for it: supports
different OSes easier, the size is great. However if in any way the more
filesystems will tend use adopt configuration files it may be a question to
raise once again for that filesystem if the parser of choice used is the best.
Or a general community one: do we want to share a common config file parser?

On that note FWIW, at this point I've reviewed 4 libraries for mkfs.xfs:

  o libconfig -- we want to stay away from this [0]
  o e2fsprogs libprofile -- its a fork of krb5 libparser, size-wise this is [1]
    a best option, however its also a fork on its own, or 
  o libini_config -- my pick and what I recommend [2] due it supporting
    uint64_t well, having a good new community traction, and a good set of
    tests
  o nfs: has its own incarnation of a library

*Iff* we want to share the same library for mkfs.xfs and also a udev helper,
then a new requirement here is perhaps also having a respective library on
other higher level language like python for instance, if not now perhaps
for the future. Unless of course we'd expect such udev heleprs to be C
based.

[0] https://gitlab.com/mcgrof/libconfig-int64-issues
[1] https://gitlab.com/mcgrof/libekprofile
[2] https://gitlab.com/mcgrof/libini_config-demo

> If
> we ever decide to expose more config knobs through sysfs then they'll
> be automatically supported.

While all this is nice, I'm sure we're all aware of the dangers of setting
things in stone through sysfs, its likely already decided for the above
tunables, but adding a uevent *is* yet another layer of user interface
which userspace can *expect* and we should be certain we want this so
we won't regress userspace later.

Just saying, we better damn be sure this is the way we want to go.

> > +	if (err)
> > +		xfs_notice(mp, "Sending XFS uevent %d got error %d",
> > +				action, err);
> > +}
> > +
> >  STATIC int
> >  xfs_fs_fill_super(
> >  	struct super_block	*sb,
> > @@ -1667,6 +1680,8 @@ xfs_fs_fill_super(
> >  		goto out_unmount;
> >  	}
> >  
> > +	xfs_fs_uevent(mp, KOBJ_ONLINE);
> 
> That said, I wonder if we ought to move this discussion to fsdevel to
> pull in any /other/ filesystems that have sysfs knobs that they might
> like to be able to persist?  ext4 has a bunch of tunables too...

Done :)

  Luis
