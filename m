Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38166 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfFZPhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:37:12 -0400
Date: Wed, 26 Jun 2019 08:35:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] vfs: create a generic checking function for
 FS_IOC_FSSETXATTR
Message-ID: <20190626153542.GE5171@magnolia>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
 <156151633829.2283456.834142172527987802.stgit@magnolia>
 <20190626041133.GB32272@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626041133.GB32272@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Jun 26, 2019 at 05:11:33AM +0100, Al Viro wrote:
> On Tue, Jun 25, 2019 at 07:32:18PM -0700, Darrick J. Wong wrote:
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -373,10 +373,9 @@ static int check_xflags(unsigned int flags)
> >  static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
> >  {
> >  	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
> > -	struct fsxattr fa;
> > -
> > -	memset(&fa, 0, sizeof(fa));
> > -	fa.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags);
> > +	struct fsxattr fa = {
> > +		.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags),
> > +	};
> 
> Umm...  Sure, there's no padding, but still - you are going to copy that thing
> to userland...  How about
> 
> static inline void simple_fill_fsxattr(struct fsxattr *fa, unsigned xflags)
> {
> 	memset(fa, 0, sizeof(*fa));
> 	fa->fsx_xflags = xflags;
> }
> 
> and let the compiler optimize the crap out?

The v2 series used to do that, but Christoph complained that having a
helper for a two-line memset and initialization was silly[1] so now we
have this version.

I don't mind reinstating it as a static inline helper, but I'd like some
input from any of the btrfs developers (or you, Al) about which form is
preferred.

--D

[1] https://lkml.org/lkml/2019/6/25/533
