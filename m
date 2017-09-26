Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:38580 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965543AbdIZSuJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 14:50:09 -0400
Date: Tue, 26 Sep 2017 12:50:08 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926185008.GA31146@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925233812.GM10955@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

On Tue, Sep 26, 2017 at 09:38:12AM +1000, Dave Chinner wrote:
> On Mon, Sep 25, 2017 at 05:13:58PM -0600, Ross Zwisler wrote:
> > Before support for the per-inode DAX flag was disabled the XFS the code had
> > an issue where the user couldn't reliably tell whether or not DAX was being
> > used to service page faults and I/O when the DAX mount option was used.  In
> > this case each inode within the mounted filesystem started with S_DAX set
> > due to the mount option, but it could be cleared if someone touched the
> > individual inode flag.
> > 
> > For example (v4.13 and before):
> > 
> >   # mount | grep dax
> >   /dev/pmem0 on /mnt type xfs
> >   (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)
> > 
> >   # touch /mnt/a /mnt/b   # both files currently use DAX
> > 
> >   # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
> >   ----------e----- /mnt/a
> >   ----------e----- /mnt/b
> > 
> >   # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a
> > 
> >   # xfs_io -c "lsattr" /mnt/*
> >   ----------e----- /mnt/a
> >   ----------e----- /mnt/b
> 
> That's really a bug in the lsattr code, yes? If we've cleared the
> S_DAX flag for the inode, then why is it being reported in lsattr?
> Or if we failed to clear the S_DAX flag in the 'chattr -x' call,
> then isn't that the bug that needs fixing?

No, I think lsattr/chattr are working correctly.  In both the examples above
the DAX inode flag (which is represeted by an 'x') is never set.  S_DAX is the
in-memory inode flag (not the on-media inode flag) which is not manipulated
directly by lsattr/chattr, but instead reflects whether the inode is actually
using DAX or not.

Manipulating and displaying the on-media inode flag works as expected with
lsattr/chattr:

  # xfs_io -c "lsattr" ./a 
  ---------------- ./a 
  
  # xfs_io -c "chattr +x" ./a 
  
  # xfs_io -c "lsattr" ./a 
  --------------x- ./a 

- Ross
