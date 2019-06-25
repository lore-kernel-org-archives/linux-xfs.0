Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfFYSSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 14:18:38 -0400
Date: Tue, 25 Jun 2019 11:17:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] vfs: create a generic checking function for
 FS_IOC_SETFLAGS
Message-ID: <20190625181733.GG5375@magnolia>
References: <156116136742.1664814.17093419199766834123.stgit@magnolia>
 <156116138140.1664814.9610454726122206157.stgit@magnolia>
 <20190625171254.GT8917@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625171254.GT8917@twin.jikos.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dsterba@suse.cz, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue, Jun 25, 2019 at 07:12:54PM +0200, David Sterba wrote:
> On Fri, Jun 21, 2019 at 04:56:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a generic checking function for the incoming FS_IOC_SETFLAGS flag
> > values so that we can standardize the implementations that follow ext4's
> > flag values.
> 
> I checked a few samples what's the type of the flags, there are unsigned
> types while the proposed VFS functions take signed type.
> 
> > +int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags);
> 
> Specifically ext4 uses unsigned type and his was the original API that
> got copied so I'd think that it should unsigned everywhere.

Yeah, I'll change it.

> >  fs/btrfs/ioctl.c    |   13 +++++--------
> 
> For the btrfs bits
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> and besides the signedness, the rest of the changes look good to me.

Thanks for the look around!  I'll have a new revision with all changes
out by the end of the day. :)

--D
