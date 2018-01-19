Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754809AbeASOgj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:36:39 -0500
Message-ID: <1516372594.3588.11.camel@kernel.org>
Subject: Re: [PATCH v5 02/19] fs: don't take the i_lock in inode_inc_iversion
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 19 Jan 2018 09:36:34 -0500
In-Reply-To: <20180118214534.GB5299@fieldses.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
         <20180109141059.25929-3-jlayton@kernel.org>
         <20180118214534.GB5299@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

On Thu, 2018-01-18 at 16:45 -0500, J. Bruce Fields wrote:
> On Tue, Jan 09, 2018 at 09:10:42AM -0500, Jeff Layton wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > The rationale for taking the i_lock when incrementing this value is
> > lost in antiquity. The readers of the field don't take it (at least
> > not universally), so my assumption is that it was only done here to
> > serialize incrementors.
> > 
> > If that is indeed the case, then we can drop the i_lock from this
> > codepath and treat it as a atomic64_t for the purposes of
> > incrementing it. This allows us to use inode_inc_iversion without
> > any danger of lock inversion.
> > 
> > Note that the read side is not fetched atomically with this change.
> > The assumption here is that that is not a critical issue since the
> > i_version is not fully synchronized with anything else anyway.
> 
> So I guess it's theoretically possible that e.g. if you read while it's
> incrementing from 2^32-1 to 2^32 you could read 0, 1, or 2^32+1?
>
> If so then you could see an i_version value reused and incorrectly
> decide that a file hadn't changed.
> 
> But it's such a tiny case, and I think you convert this to atomic64_t
> later anyway, so, whatever.
> 
> --b.
> 

Shrug...we have that problem with the spinlock in place too. The bottom
line is that reads of this value are not serialized with the increment
at all.

I'm not 100% thrilled with this patch, but I think it's probably better
not to add the i_lock all over the place, even as an interim step in
cleaning this stuff up.

The good news here (as you mention) is that this nastiness gets cleaned
up in the last patch when we convert the thing to an atomic64_t.


> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  include/linux/iversion.h | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/iversion.h b/include/linux/iversion.h
> > index d09cc3a08740..5ad9eaa3a9b0 100644
> > --- a/include/linux/iversion.h
> > +++ b/include/linux/iversion.h
> > @@ -104,12 +104,13 @@ inode_set_iversion_queried(struct inode *inode, u64 new)
> >  static inline bool
> >  inode_maybe_inc_iversion(struct inode *inode, bool force)
> >  {
> > -	spin_lock(&inode->i_lock);
> > -	inode->i_version++;
> > -	spin_unlock(&inode->i_lock);
> > +	atomic64_t *ivp = (atomic64_t *)&inode->i_version;
> > +
> > +	atomic64_inc(ivp);
> >  	return true;
> >  }
> >  
> > +
> >  /**
> >   * inode_inc_iversion - forcibly increment i_version
> >   * @inode: inode that needs to be updated
> > -- 
> > 2.14.3

-- 
Jeff Layton <jlayton@kernel.org>
