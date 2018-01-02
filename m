Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeABTDV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jan 2018 14:03:21 -0500
Message-ID: <1514919796.3462.23.camel@kernel.org>
Subject: Re: [PATCH v4 16/19] fs: only set S_VERSION when updating times if
 necessary
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 02 Jan 2018 14:03:16 -0500
In-Reply-To: <20180102165034.GA4911@quack2.suse.cz>
References: <20171222120556.7435-1-jlayton@kernel.org>
         <20171222120556.7435-17-jlayton@kernel.org>
         <20180102165034.GA4911@quack2.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Tue, 2018-01-02 at 17:50 +0100, Jan Kara wrote:
> On Fri 22-12-17 07:05:53, Jeff Layton wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > We only really need to update i_version if someone has queried for it
> > since we last incremented it. By doing that, we can avoid having to
> > update the inode if the times haven't changed.
> > 
> > If the times have changed, then we go ahead and forcibly increment the
> > counter, under the assumption that we'll be going to the storage
> > anyway, and the increment itself is relatively cheap.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/inode.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 19e72f500f71..2fa920188759 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -1635,17 +1635,21 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
> >  int generic_update_time(struct inode *inode, struct timespec *time, int flags)
> >  {
> >  	int iflags = I_DIRTY_TIME;
> > +	bool dirty = false;
> >  
> >  	if (flags & S_ATIME)
> >  		inode->i_atime = *time;
> >  	if (flags & S_VERSION)
> > -		inode_inc_iversion(inode);
> > +		dirty |= inode_maybe_inc_iversion(inode, dirty);
> >  	if (flags & S_CTIME)
> >  		inode->i_ctime = *time;
> >  	if (flags & S_MTIME)
> >  		inode->i_mtime = *time;
> > +	if ((flags & (S_ATIME | S_CTIME | S_MTIME)) &&
> > +	    !(inode->i_sb->s_flags & SB_LAZYTIME))
> > +		dirty = true;
> 
> When you pass 'dirty' to inode_maybe_inc_iversion(), it is always false.
> Maybe this condition should be at the beginning of the function? Once you
> fix that the patch looks good so you can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 

Thanks for the review! I've fixed it in my tree. I'll not re-post the
set unless I have to make another significant change or someone requests
it.

I did make one other change, and that was to drop the "const" qualifiers
on the integer arguments in the new API. David Howells pointed out that
they don't really help anything, and the prototypes look cleaner without
them.

This set is now in linux-next as well, so I'm going to try to get this
merged into v4.16, assuming no problems between now and the merge
window.
-- 
Jeff Layton <jlayton@kernel.org>
