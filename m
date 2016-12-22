Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:35967 "EHLO
        mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755379AbcLVN1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 08:27:46 -0500
Received: by mail-qt0-f179.google.com with SMTP id w33so234278765qtc.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 05:27:46 -0800 (PST)
Message-ID: <1482413261.3924.17.camel@redhat.com>
Subject: Re: [RFC PATCH v1 30/30] fs: convert i_version counter over to an
 atomic64_t
From: Jeff Layton <jlayton@redhat.com>
Date: Thu, 22 Dec 2016 08:27:41 -0500
In-Reply-To: <CAOQ4uxi_z1DK4tM3DVTtyAM8matJk+KqakUnaequsEXS2En9Xg@mail.gmail.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <1482339827-7882-31-git-send-email-jlayton@redhat.com>
         <CAOQ4uxi_z1DK4tM3DVTtyAM8matJk+KqakUnaequsEXS2En9Xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs@vger.kernel.org

On Thu, 2016-12-22 at 10:38 +0200, Amir Goldstein wrote:
> On Wed, Dec 21, 2016 at 7:03 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > The spinlock is only used to serialize callers that want to increment
> > the counter. We can achieve the same thing with an atomic64_t and
> > get the i_lock out of this codepath.
> > 
> 
> Cool work! See some nits and suggestions below.
> 
> > 
> > +/*
> > + * We borrow the top bit in the i_version to use as a flag to tell us whether
> > + * it has been queried since we last bumped it. If it has, then we must bump
> > + * it and set the flag. Note that this means that we have to handle wrapping
> > + * manually.
> > + */
> > +#define INODE_I_VERSION_QUERIED                (1ULL<<63)
> > +
> >  /**
> >   * inode_set_iversion - set i_version to a particular value
> >   * @inode: inode to set
> > @@ -1976,7 +1980,7 @@ static inline void inode_dec_link_count(struct inode *inode)
> >  static inline void
> >  inode_set_iversion(struct inode *inode, const u64 new)
> >  {
> > -       inode->i_version = new;
> > +       atomic64_set(&inode->i_version, new);
> >  }
> > 
> 
> Maybe needs an overflow sanity check !(new & INODE_I_VERSION_QUERIED)??
> See API change suggestion below.
> 
> 

Possibly. Note that in some cases (when the i_version can be stored on
disk across a remount), we need to ensure that we set this flag when the
inode is read in from disk. It's always possible that we'll get a query
for it, and then crash so we always set the flag just in case.

> > 
> >  /**
> > @@ -2010,16 +2011,26 @@ inode_set_iversion_read(struct inode *inode, const u64 new)
> >  static inline bool
> >  inode_inc_iversion(struct inode *inode, bool force)
> >  {
> > -       bool ret = false;
> > +       u64 cur, old, new;
> > +
> > +       cur = (u64)atomic64_read(&inode->i_version);
> > +       for (;;) {
> > +               /* If flag is clear then we needn't do anything */
> > +               if (!force && !(cur & INODE_I_VERSION_QUERIED))
> > +                       return false;
> > +
> > +               new = (cur & ~INODE_I_VERSION_QUERIED) + 1;
> > +
> > +               /* Did we overflow into flag bit? Reset to 0 if so. */
> > +               if (unlikely(new == INODE_I_VERSION_QUERIED))
> > +                       new = 0;
> > 
> 
> Did you consider changing f_version type and the signature of the new
> i_version API to set/get s64 instead of u64?
> 
> It makes a bit more sense from API users perspective to know that
> the valid range for version is >=0.
> 
> file->f_version is not the only struct member used to store&compare
> i_version. nfs and xfs have other struct members for that, but even
> if all those members are not changed to type s64, the explicit cast
> to (s64) and back to (u64) will serve as a good documentation in
> the code about the valid range of version in the new API.
> 

This API is definitely not set in stone. That said, we have to consider
that there are really three classes of filesystems here:

1) ones that treat i_version as an opaque value: Mostly AFS and NFS,
as they get this value from the server. These both can also use the
entire u64 field, so we need to ensure that we don't monkey with the
flag bit on them.

2) filesystems that just use it internally: These don't set MS_I_VERSION
and mostly use it to detect directory changes that occur during readdir.
i_version is initialized to some value (0 or 1) when the struct inode is
allocated and bump it on directory changes.

3) filesystems where the kernel manages it completely: these set
MS_I_VERSION and the kernel handles bumping it on writes. Currently,
this is btrfs, ext4 and xfs. These are persistent across remounts as
well.

So, we have to ensure that this API encompasses all 3 of these use
cases.

> >  /**
> > @@ -2080,7 +2099,7 @@ inode_get_iversion(struct inode *inode)
> >  static inline s64
> >  inode_cmp_iversion(const struct inode *inode, const u64 old)
> >  {
> > -       return (s64)inode->i_version - (s64)old;
> > +       return (s64)(atomic64_read(&inode->i_version) << 1) - (s64)(old << 1);
> >  }
> > 
> 
> IMO, it is better for the API to determine that 'old' is valid a value
> returned from
> inode_get_iversion* and therefore should not have the MSB set.
> Unless the reason you chose to shift those 2 values is because it is cheaper
> then masking INODE_I_VERSION_QUERIED??
> 
> 

No, we need to do that in order to handle wraparound correctly. We want
this check to work something like the time_before/after macros in the
kernel that handle jiffies wraparound.

So, the sign returned here matters, as positive values indicate that the
current one is "newer" than the old one. That's the main reason for the
shift here.

Note that that that should be documented here too, I'll plan to add that
for the next revision.

Thanks for the comments so far!
-- 
Jeff Layton <jlayton@redhat.com>
