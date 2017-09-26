Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:44603 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967161AbdIZLOA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 07:14:00 -0400
Date: Tue, 26 Sep 2017 21:09:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926110957.GR10955@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
 <20170926093548.GB13627@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170926093548.GB13627@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 11:35:48AM +0200, Jan Kara wrote:
> On Tue 26-09-17 09:38:12, Dave Chinner wrote:
> > On Mon, Sep 25, 2017 at 05:13:58PM -0600, Ross Zwisler wrote:
> > > Before support for the per-inode DAX flag was disabled the XFS the code had
> > > an issue where the user couldn't reliably tell whether or not DAX was being
> > > used to service page faults and I/O when the DAX mount option was used.  In
> > > this case each inode within the mounted filesystem started with S_DAX set
> > > due to the mount option, but it could be cleared if someone touched the
> > > individual inode flag.
> > > 
> > > For example (v4.13 and before):
> > > 
> > >   # mount | grep dax
> > >   /dev/pmem0 on /mnt type xfs
> > >   (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)
> > > 
> > >   # touch /mnt/a /mnt/b   # both files currently use DAX
> > > 
> > >   # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
> > >   ----------e----- /mnt/a
> > >   ----------e----- /mnt/b
> > > 
> > >   # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a
> > > 
> > >   # xfs_io -c "lsattr" /mnt/*
> > >   ----------e----- /mnt/a
> > >   ----------e----- /mnt/b
> > 
> > That's really a bug in the lsattr code, yes? If we've cleared the
> > S_DAX flag for the inode, then why is it being reported in lsattr?
> > Or if we failed to clear the S_DAX flag in the 'chattr -x' call,
> > then isn't that the bug that needs fixing?
> > 
> > Remember, the whole point of the dax inode flag was to be able to
> > override the mount option setting so that admins could turn off/on
> > dax for the things that didn't/did work with DAX correctly so they
> > didn't need multiple filesystems on pmem to segregate the apps that
> > did/didn't work with DAX...
> 
> So I think there is some confusion that is created by the fact that whether
> DAX is used or not is controlled by both a mount option and an inode flag.
> We could define that "Inode flag always wins" which is what you seem to
> suggest above but then mount option has no practical effect since on-disk
> S_DAX flag will always overrule it.

Well, quite frankly, I never wanted the mount option for XFS. It was
supposed to be for initial testing only, then we'd /always/ use the
the inode flags. For a filesystem to default to using DAX, we
set the DAX flag on the root inode at mkfs time, and then everything
inode flag based just works.

But it seems that we're now stuck with the stupid, blunt, brute
force mount option because that's what the first commit on ext4
used.  Now we're just about stuck with this silly "but we can't turn
it off" problem because of the mount option overriding everything.

If we have to keep the mount option, then lets fix it to mean "mount
option sets inheritable inode flag on directory creation" and
/maybe/ "mount option sets inode flag on file creation".

This then allows the inode flag to control everything else. i.e the
mount option sets the initial flag value rather than the behaviour
of the inode. The behaviour of the inode should be entirely
controlled by the inode flag, hence after initial creation the
chattr +/-x commands do what they advertise regardless of the mount
option value.

Yes, it means that existing users are going to have to run chattr -R
+x on their pmem filesystems to get the inode flags on disk, but
this is all tagged with EXPERIMENTAL and this is the sort of change
that is expected from experimental functionality.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
