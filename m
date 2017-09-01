Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50414 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbdIACGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 22:06:46 -0400
Date: Fri, 1 Sep 2017 12:06:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: add online uevent for mount operation
Message-ID: <20170901020643.GY10621@dastard>
References: <1504189030-18608-1-git-send-email-houtao1@huawei.com>
 <20170831150334.GI3775@magnolia>
 <20170831233416.GU10621@dastard>
 <70654563-0abd-6786-ef64-a3df4ce5fa34@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70654563-0abd-6786-ef64-a3df4ce5fa34@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Sep 01, 2017 at 09:26:08AM +0800, Hou Tao wrote:
> Hi,
> 
> On 2017/9/1 7:34, Dave Chinner wrote:
> >>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >>> index 3a3812b4..6f8351c 100644
> >>> --- a/fs/xfs/xfs_super.c
> >>> +++ b/fs/xfs/xfs_super.c
> >>> @@ -70,6 +70,11 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> >>>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
> >>>  #endif
> >>>  
> >>> +enum {
> >>> +	XFS_UEVENT_ENV_CNT = 2,
> >>
> >> XFS_UEVENT_MAX_ENV_COUNT ?
> > 
> > Why 2 when there's only one environment string passed?
> Will fix them, I take the last NULL pointer into account, and
> Yes, "XFS_UEVENT_MAX_ENV_COUNT" is a better name.
> 
> >>> +	XFS_UEVENT_UUID_LEN = UUID_STRING_LEN + 6,
> > 
> > And the magic number needs a comment.
> > 
> > Actually, I think it needs more than this - it's tightly bound to
> > the implementation in xfs_fs_uevent(), so this enum should be
> > defined there, not as a global all this distance away.....
> OK, I will move it into xfs_fs_uevent().
> 
> >>> +};
> >>> +
> >>>  /*
> >>>   * Table driven mount option parser.
> >>>   */
> >>> @@ -1530,6 +1535,28 @@ xfs_destroy_percpu_counters(
> >>>  	percpu_counter_destroy(&mp->m_fdblocks);
> >>>  }
> >>>  
> >>> +static void
> >>> +xfs_fs_uevent(
> >>> +	struct xfs_mount	*mp,
> >>> +	enum kobject_action	action)
> >>> +{
> >>> +	int err;
> >>> +	char *envp[XFS_UEVENT_ENV_CNT];
> >>> +	int i = 0;
> > 
> > Indent the variables to match the function declaration.
> I will fix them. I didn't event notice the indentations of these variables before.
> 
> >>> +
> >>> +	if (!uuid_is_null(&mp->m_super->s_uuid)) {
> > 
> > This will never be false. XFS filesystems should always have a valid
> > UUID.
> A null uuid is possible if we use "nouuid" to mount a XFS filesystem, so
> the check is still needed.

The "nouuid" mount option means "don't check if there is already a
filesystem ialready mounted with the same uuid as the one we are
mounting". It does not mean the filesystem does not have a UUID.

Indeed, in xfs_uuid_mount():

xfs_uuid_mount(
        struct xfs_mount        *mp)
{
        uuid_t                  *uuid = &mp->m_sb.sb_uuid;
        int                     hole, i;

        /* Publish UUID in struct super_block */
        uuid_copy(&mp->m_super->s_uuid, uuid);

        if (mp->m_flags & XFS_MOUNT_NOUUID)
                return 0;

We copy the filesystem's uuid into the VFS superblock before we
check the nouuid mount option flag. Hence a mounted XFS filesystem
always has a valid UUID in the superblock s_uuid field.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
