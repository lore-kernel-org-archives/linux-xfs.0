Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfFTVkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 17:40:03 -0400
Date: Thu, 20 Jun 2019 14:36:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] vfs: don't allow most setxattr to immutable files
Message-ID: <20190620213629.GB5375@magnolia>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
 <156022840560.3227213.4776913678782966728.stgit@magnolia>
 <20190620140345.GI30243@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620140345.GI30243@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Jun 20, 2019 at 04:03:45PM +0200, Jan Kara wrote:
> On Mon 10-06-19 21:46:45, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The chattr manpage has this to say about immutable files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > However, we don't actually check the immutable flag in the setattr code,
> > which means that we can update inode flags and project ids and extent
> > size hints on supposedly immutable files.  Therefore, reject setflags
> > and fssetxattr calls on an immutable file if the file is immutable and
> > will remain that way.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/inode.c |   31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index a3757051fd55..adfb458bf533 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -2184,6 +2184,17 @@ int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags)
> >  	    !capable(CAP_LINUX_IMMUTABLE))
> >  		return -EPERM;
> >  
> > +	/*
> > +	 * We aren't allowed to change any other flags if the immutable flag is
> > +	 * already set and is not being unset.
> > +	 */
> > +	if ((oldflags & FS_IMMUTABLE_FL) &&
> > +	    (flags & FS_IMMUTABLE_FL)) {
> > +		if ((oldflags & ~FS_IMMUTABLE_FL) !=
> > +		    (flags & ~FS_IMMUTABLE_FL))
> 
> This check looks a bit strange when you've just check FS_IMMUTABLE_FL isn't
> changing... Why not just oldflags != flags?
> 
> > +	if ((old_fa->fsx_xflags & FS_XFLAG_IMMUTABLE) &&
> > +	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
> > +		if ((old_fa->fsx_xflags & ~FS_XFLAG_IMMUTABLE) !=
> > +		    (fa->fsx_xflags & ~FS_XFLAG_IMMUTABLE))
> 
> Ditto here...

Good point!  I'll fix it.

--D

> 
> > +			return -EPERM;
> > +		if (old_fa->fsx_projid != fa->fsx_projid)
> > +			return -EPERM;
> > +		if ((fa->fsx_xflags & (FS_XFLAG_EXTSIZE |
> > +				       FS_XFLAG_EXTSZINHERIT)) &&
> > +		    old_fa->fsx_extsize != fa->fsx_extsize)
> > +			return -EPERM;
> > +		if ((old_fa->fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
> > +		    old_fa->fsx_cowextsize != fa->fsx_cowextsize)
> > +			return -EPERM;
> > +	}
> > +
> >  	/* Extent size hints of zero turn off the flags. */
> >  	if (fa->fsx_extsize == 0)
> >  		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
