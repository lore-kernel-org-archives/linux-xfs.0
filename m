Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31900 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751969AbdHaXeT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 19:34:19 -0400
Date: Fri, 1 Sep 2017 09:34:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
Message-ID: <20170831233416.GU10621@dastard>
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
 <20170831150334.GI3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831150334.GI3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org

On Thu, Aug 31, 2017 at 08:03:34AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 31, 2017 at 10:17:10PM +0800, Hou Tao wrote:
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
> > You also could apply an udevd rule to a specific XFS filesystem by
> > UUID filtering:
> > 
> >     ACTION=="online", SUBSYSTEM=="xfs", \
> >     ENV{UUID}=="8f789c27-391f-4bd7-b17d-9bcf2443dc9c", \
> >     RUN+="/bin/sh -c 'echo 5 > /sys%p/error/metadata/EIO/max_retries'"

Nice!

> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> > v2:
> >     * add UUID property for mount uevent
> >     * add an udev example for UUID filtering
> > v1:
> >     * http://www.spinics.net/lists/linux-xfs/msg09484.html
> > ---
> >  fs/xfs/xfs_super.c | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 3a3812b4..6f8351c 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -70,6 +70,11 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
> >  #endif
> >  
> > +enum {
> > +	XFS_UEVENT_ENV_CNT = 2,
> 
> XFS_UEVENT_MAX_ENV_COUNT ?

Why 2 when there's only one environment string passed?

> > +	XFS_UEVENT_UUID_LEN = UUID_STRING_LEN + 6,

And the magic number needs a comment.

Actually, I think it needs more than this - it's tightly bound to
the implementation in xfs_fs_uevent(), so this enum should be
defined there, not as a global all this distance away.....

> > +};
> > +
> >  /*
> >   * Table driven mount option parser.
> >   */
> > @@ -1530,6 +1535,28 @@ xfs_destroy_percpu_counters(
> >  	percpu_counter_destroy(&mp->m_fdblocks);
> >  }
> >  
> > +static void
> > +xfs_fs_uevent(
> > +	struct xfs_mount	*mp,
> > +	enum kobject_action	action)
> > +{
> > +	int err;
> > +	char *envp[XFS_UEVENT_ENV_CNT];
> > +	int i = 0;

Indent the variables to match the function declaration.

> > +
> > +	if (!uuid_is_null(&mp->m_super->s_uuid)) {

This will never be false. XFS filesystems should always have a valid
UUID.

> > +		char uuid[XFS_UEVENT_UUID_LEN];
> > +
> > +		snprintf(uuid, sizeof(uuid), "UUID=%pUb", &mp->m_super->s_uuid);

That buffer is not a uuid. i.e. this code looks to me like it is
encoding a string larger than a uuid into a uuid that is the
size of a uuid. Perhaps something like this?

		char *id = "ID_FS_UUID=";
		char buf[UUID_STRING_LEN + strlen(id) + 1] = {};

		snprintf(buf, sizeof(buf), "%s%pUb", id, &mp->m_super->s_uuid);

> Should this be "ID_FS_UUID=%pUb" to keep the name consistent with
> what blkid injects into the udev environment for block devices?

Sounds like a good idea to me...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
