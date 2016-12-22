Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34067 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbcLVIih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 03:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <1482339827-7882-31-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com> <1482339827-7882-31-git-send-email-jlayton@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Dec 2016 10:38:36 +0200
Message-ID: <CAOQ4uxi_z1DK4tM3DVTtyAM8matJk+KqakUnaequsEXS2En9Xg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 30/30] fs: convert i_version counter over to an atomic64_t
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Dec 21, 2016 at 7:03 PM, Jeff Layton <jlayton@redhat.com> wrote:
> The spinlock is only used to serialize callers that want to increment
> the counter. We can achieve the same thing with an atomic64_t and
> get the i_lock out of this codepath.
>

Cool work! See some nits and suggestions below.

> +/*
> + * We borrow the top bit in the i_version to use as a flag to tell us whether
> + * it has been queried since we last bumped it. If it has, then we must bump
> + * it and set the flag. Note that this means that we have to handle wrapping
> + * manually.
> + */
> +#define INODE_I_VERSION_QUERIED                (1ULL<<63)
> +
>  /**
>   * inode_set_iversion - set i_version to a particular value
>   * @inode: inode to set
> @@ -1976,7 +1980,7 @@ static inline void inode_dec_link_count(struct inode *inode)
>  static inline void
>  inode_set_iversion(struct inode *inode, const u64 new)
>  {
> -       inode->i_version = new;
> +       atomic64_set(&inode->i_version, new);
>  }
>

Maybe needs an overflow sanity check !(new & INODE_I_VERSION_QUERIED)??
See API change suggestion below.


>  /**
> @@ -2010,16 +2011,26 @@ inode_set_iversion_read(struct inode *inode, const u64 new)
>  static inline bool
>  inode_inc_iversion(struct inode *inode, bool force)
>  {
> -       bool ret = false;
> +       u64 cur, old, new;
> +
> +       cur = (u64)atomic64_read(&inode->i_version);
> +       for (;;) {
> +               /* If flag is clear then we needn't do anything */
> +               if (!force && !(cur & INODE_I_VERSION_QUERIED))
> +                       return false;
> +
> +               new = (cur & ~INODE_I_VERSION_QUERIED) + 1;
> +
> +               /* Did we overflow into flag bit? Reset to 0 if so. */
> +               if (unlikely(new == INODE_I_VERSION_QUERIED))
> +                       new = 0;
>

Did you consider changing f_version type and the signature of the new
i_version API to set/get s64 instead of u64?

It makes a bit more sense from API users perspective to know that
the valid range for version is >=0.

file->f_version is not the only struct member used to store&compare
i_version. nfs and xfs have other struct members for that, but even
if all those members are not changed to type s64, the explicit cast
to (s64) and back to (u64) will serve as a good documentation in
the code about the valid range of version in the new API.

>  /**
> @@ -2080,7 +2099,7 @@ inode_get_iversion(struct inode *inode)
>  static inline s64
>  inode_cmp_iversion(const struct inode *inode, const u64 old)
>  {
> -       return (s64)inode->i_version - (s64)old;
> +       return (s64)(atomic64_read(&inode->i_version) << 1) - (s64)(old << 1);
>  }
>

IMO, it is better for the API to determine that 'old' is valid a value
returned from
inode_get_iversion* and therefore should not have the MSB set.
Unless the reason you chose to shift those 2 values is because it is cheaper
then masking INODE_I_VERSION_QUERIED??


Cheers,
Amir.
