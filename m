Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:19498 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933471AbeCHERk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 23:17:40 -0500
Date: Thu, 8 Mar 2018 15:17:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs_info: move to xfs_spaceman
Message-ID: <20180308041738.GQ18129@dastard>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993167183.22223.13501751102361596724.stgit@magnolia>
 <6cc21a4a-7936-eb7c-c655-1a5c826f7f07@sandeen.net>
 <20180307203350.GW18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307203350.GW18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Wed, Mar 07, 2018 at 12:33:50PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 06, 2018 at 09:50:09PM -0600, Eric Sandeen wrote:
> > On 3/1/18 1:14 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Move xfs_info to be under spaceman so that we can remove growfs -N.
> > 
> > A while back we made xfs_growfs/ xfs_info fail on not-mount-points:
> > 
> > [root@localhost sandeen]# touch file
> > 
> > file not on xfs:
> > 
> > [root@localhost sandeen]# xfs_info file
> > xfs_info: specified file ["/"] is not on an XFS filesystem
> > 
> > file on xfs,  not mounpoint:
> > 
> > [root@localhost sandeen]# xfs_info mnt/foo
> > xfs_info: mnt/foo is not a mounted XFS filesystem
> > 
> > now if we point at a file not on xfs:
> > 
> > # ./spaceman/xfs_spaceman -c info /tmp/foo 
> > XFS_IOC_FSGEOMETRY: Inappropriate ioctl for device
> > (we lost the friendly failure string)
> > 
> > if we point at a file that's on xfs but is not a mountpoint:
> > 
> > # ./spaceman/xfs_spaceman -c info foo
> 
> So this raises some theoretical issues.  Right now spaceman applies its
> management to whatever fs backs the inode that we opened from the cli
> arguments.  If this will be the only scope forever and ever then we
> could require that the pathnames on the cli actually be mountpoints and
> enforce with the same mntent parsing that scrub/fsr currently use.
> 
> Will we ever want to be able to perform space management on specific
> files?  I don't know that we do, but I also don't think we want to trade
> away that option.

Yes, yes we will. subvolume backing stores fall into this category.

> It occurs to me that the manpage for info and growfs both say "mount
> point", not "root directory of an xfs filesystem".  Since we can bind
> mount anything anywhere on Linux, what does that even mean?
> 
> If I do:
> 
> # mount /dev/sda1 /home
> # mount /home/djwong/foo /opt --bind
> # xfs_info /opt
> 
> Should that succeed?  The manpage would seem to say yes. 

The manpage wording pre-dates bind mounts and this capability. We
should not assume that the man page is the canonical truth that must
be obeyed, especially when it doesn't make sense anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
