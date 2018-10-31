Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:45716 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728819AbeJaKGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 06:06:35 -0400
Date: Wed, 31 Oct 2018 12:05:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20181031010557.GU19305@dastard>
References: <20181031112244.71b62e67@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031112244.71b62e67@canb.auug.org.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

On Wed, Oct 31, 2018 at 11:22:44AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in:
> 
>   Documentation/filesystems/porting
> 
> between commit:
> 
>   1a16dbaf798c ("Document d_splice_alias() calling conventions for ->lookup() users.")
> 
> from Linus' tree and commit:
> 
>   2e5dfc99f2e6 ("vfs: combine the clone and dedupe into a single remap_file_range")
> 
> from the xfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc Documentation/filesystems/porting
> index 321d74b73937,e6d4466268dd..000000000000
> --- a/Documentation/filesystems/porting
> +++ b/Documentation/filesystems/porting
> @@@ -623,13 -623,7 +623,18 @@@ in your dentry operations instead
>   	On success you get a new struct file sharing the mount/dentry with the
>   	original, on failure - ERR_PTR().
>   --
>  +[recommended]
>  +	->lookup() instances doing an equivalent of
>  +		if (IS_ERR(inode))
>  +			return ERR_CAST(inode);
>  +		return d_splice_alias(inode, dentry);
>  +	don't need to bother with the check - d_splice_alias() will do the
>  +	right thing when given ERR_PTR(...) as inode.  Moreover, passing NULL
>  +	inode to d_splice_alias() will also do the right thing (equivalent of
>  +	d_add(dentry, NULL); return NULL;), so that kind of special cases
>  +	also doesn't need a separate treatment.
> ++--
> + [mandatory]
> + 	->clone_file_range() and ->dedupe_file_range have been replaced with
> + 	->remap_file_range().  See Documentation/filesystems/vfs.txt for more
> + 	information.

Looks good - I knew about this one from merging back into a recent
Linus kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
