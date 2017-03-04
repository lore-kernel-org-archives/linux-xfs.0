Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35931 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdCDASM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 19:18:12 -0500
Received: by mail-qk0-f173.google.com with SMTP id 1so83450160qkl.3
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 16:18:11 -0800 (PST)
Message-ID: <1488586167.11672.1.camel@redhat.com>
Subject: Re: [RFC PATCH v1 11/30] fs: new API for handling i_version
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 03 Mar 2017 19:09:27 -0500
In-Reply-To: <20170303223649.GH13877@fieldses.org>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <1482339827-7882-12-git-send-email-jlayton@redhat.com>
         <20170303223649.GH13877@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, 2017-03-03 at 17:36 -0500, J. Bruce Fields wrote:
> The patch ordering is a little annoying as I'd like to be able to be
> able to verify the implementation at the same time these new interfaces
> are added, but, I don't know, I don't have a better idea.
> 

Fair point. My thinking was "add new API, convert everything over to it,
and then convert the implementation to do something different". Maybe
that's the wrong approach?

> Anyway, various nits:
> 
> On Wed, Dec 21, 2016 at 12:03:28PM -0500, Jeff Layton wrote:
> > We already have inode_inc_iversion. Add inode_set_iversion,
> > inode_get_iversion, inode_cmp_iversion and inode_iversion_need_inc.
> > 
> > These should encompass how i_version is currently accessed and
> > manipulated so that we can later change the implementation.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  include/linux/fs.h | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 104 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 2ba074328894..075c915fe2b1 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1962,18 +1962,117 @@ static inline void inode_dec_link_count(struct inode *inode)
> >  }
> >  
> >  /**
> > + * inode_set_iversion - set i_version to a particular value
> > + * @inode: inode to set
> > + * @new: new i_version value to set
> > + *
> > + * Set the inode's i_version. Should generally be called when initializing
> > + * a new inode.
> > + */
> > +static inline void
> > +inode_set_iversion(struct inode *inode, const u64 new)
> > +{
> > +	inode->i_version = new;
> > +}
> > +
> > +/**
> > + * inode_inc_iversion_locked - increment i_version while protected
> > + * @inode: inode to be updated
> > + *
> > + * Increment the i_version field in the inode. This version is usable
> > + * when there is some other sort of lock in play that would prevent
> > + * concurrent accessors.
> > + */
> > +static inline void
> > +inode_inc_iversion_locked(struct inode *inode)
> > +{
> > +	inode->i_version++;
> > +}
> > +
> > +/**
> > + * inode_set_iversion_read - set i_version to a particular value and flag
> > + * 			     set flag to indicate that it has been viewed
> 
> s/flag set flag/set flag/.
> 
> > + * @inode: inode to set
> > + * @new: new i_version value to set
> > + *
> > + * Set the inode's i_version, and flag the inode as if it has been viewed.
> > + * Should generally be called when initializinga new inode in memory from
> > + * from disk.
> 
> s/from from/from/.
> 
> > + */
> > +static inline void
> > +inode_set_iversion_read(struct inode *inode, const u64 new)
> > +{
> > +	inode_set_iversion(inode, new);
> > +}
> > +
> > +/**
> >   * inode_inc_iversion - increments i_version
> >   * @inode: inode that need to be updated
> >   *
> >   * Every time the inode is modified, the i_version field will be incremented.
> > - * The filesystem has to be mounted with i_version flag
> > + * The filesystem has to be mounted with MS_I_VERSION flag.
> 
> I'm not sure why that comment's there.  Filesystems can choose to
> increment i_version without requiring the mount option if they want,
> can't they?
> 

Yeah, it should probably be removed. It honestly doesn't make much sense
since we can end up bumping the thing regardless of whether it's set.

> > + */
> > +static inline bool
> 
> Document what the return value means?
> 

Will do.

> > +inode_inc_iversion(struct inode *inode)
> > +{
> > +	spin_lock(&inode->i_lock);
> > +	inode_inc_iversion_locked(inode);
> > +	spin_unlock(&inode->i_lock);
> > +	return true;
> > +}
> > +
> > +/**
> > + * inode_get_iversion_raw - read i_version without "perturbing" it
> > + * @inode: inode from which i_version should be read
> > + *
> > + * Read the inode i_version counter for an inode without registering it as a
> > + * read. Should typically be used by local filesystems that need to store an
> > + * i_version on disk.
> > + */
> > +static inline u64
> > +inode_get_iversion_raw(const struct inode *inode)
> > +{
> > +	return inode->i_version;
> > +}
> > +
> > +/**
> > + * inode_get_iversion - read i_version for later use
> > + * @inode: inode from which i_version should be read
> > + *
> > + * Read the inode i_version counter. This should be used by callers that wish
> > + * to store the returned i_version for later comparison.
> 
> I'm not sure what "for later comparison" means.  This is the "read"
> operation that actually flags the i_version as read, which you'd use
> (for example) to implement NFS getattr?  I wonder if there's a better
> way to say that.
> 

Yeah, I'm definitely open to better suggestions on naming.

> > + */
> > +static inline u64
> > +inode_get_iversion(const struct inode *inode)
> > +{
> > +	return inode_get_iversion_raw(inode);
> > +}
> > +
> > +/**
> > + * inode_cmp_iversion - check whether the i_version counter has changed
> > + * @inode: inode to check
> > + * @old: old value to check against its i_version
> > + *
> > + * Compare an i_version counter with a previous one. Returns 0 if they are
> > + * the same or non-zero if they are different.
> 
> Does this flag the i_version as read?  What's it for?  (OK, I guess I'll
> find out after a few more patches...).
> 

No, that won't flag it as read. 

Fetching an i_version value at a point in time must flag it as having
been read. But, we can always "peek" at the i_version and see if it has
changed from a given value without having to flag the new value as
having been read. We haven't recorded its value, so we don't have to
ensure that it changes on subsequent reads from where it is now.

This function implements the latter. Given a value that we fetched
earlier, has the current i_version value changed?

> >   */
> > +static inline s64
> > +inode_cmp_iversion(const struct inode *inode, const u64 old)
> > +{
> > +	return (s64)inode->i_version - (s64)old;
> > +}
> >  
> > -static inline void inode_inc_iversion(struct inode *inode)
> > +/**
> > + * inode_iversion_need_inc - is the i_version in need of being incremented?
> > + * @inode: inode to check
> > + *
> > + * Returns whether the inode->i_version counter needs incrementing on the next
> > + * change.
> > + */
> > +static inline bool
> > +inode_iversion_need_inc(struct inode *inode)
> >  {
> > -       spin_lock(&inode->i_lock);
> > -       inode->i_version++;
> > -       spin_unlock(&inode->i_lock);
> > +	return true;
> >  }
> >  
> >  enum file_time_flags {
> > -- 
> > 2.7.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jeff Layton <jlayton@redhat.com>
