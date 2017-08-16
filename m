Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36283 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdHPHQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 03:16:58 -0400
Received: by mail-qk0-f175.google.com with SMTP id o124so7150113qke.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 00:16:58 -0700 (PDT)
Date: Wed, 16 Aug 2017 04:16:53 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170816071649.GA4143@debian.home>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
 <20170815084430.GK21024@dastard>
 <20170815192938.GA1247@debian.home>
 <20170816002511.GM21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170816002511.GM21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>

On Wed, Aug 16, 2017 at 10:25:11AM +1000, Dave Chinner wrote:
> On Tue, Aug 15, 2017 at 04:29:39PM -0300, Ernesto A. Fernández wrote:
> > On Tue, Aug 15, 2017 at 06:44:30PM +1000, Dave Chinner wrote:
> > > On Tue, Aug 15, 2017 at 03:18:58AM -0300, Ernesto A. Fernández wrote:
> > > But I have to ask - why do we even need to modify the mode first?
> > > Why not change the ACL first, then modify the mode+timestamp? If
> > > setting the ACL fails, then we don't have anything to undo and all
> > > is good....
> > 
> > I intended for the mode to be committed as part of the same transaction
> > that sets or removes the ACL. In my mind making the changes later, as part
> > of a separate transaction, would have meant that a crash between the two
> > left the filesystem in an inconsistent state,
> 
> No, it will not leave the fileystem in an inconsistent state. It
> will leave the inode permissions in an /unwanted/ state, but there
> is no filesystem metadata inconsistency. 
> 
> > with a new ACL but without
> > the corresponding mode bits.
> 
> Yup, but that's no different from right now, where a crash after
> setting the mode bits could be applied but the ACL update is
> missing.
> 
> Either way is even rarely than "crash at the wrong time" implies,
> because we've also got to have a complete journal checkpoint occur
> between the two operations and then crash between the checkpoint and
> the second operation. Yes, it's possible, but in the entire time
> I've been working on XFS (almost 15 years now) I can count on one
> hand the number of times such a problem has occurred and been
> reported...
> 
> So, it's a rare problem, and one that will get solved in time
> because there's much more to solving the problem than just this
> case. e.g. I worte this in 2008:
> 
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
> 
> And we've really only got the infrastructure we could use to
> implement this in a widespread manner with the rmap/reflink
> functionality. But implementing it will require a large amount of
> re-organisation of filesystem operations, so it's something that
> will take time to roll out.

Alright, thanks for the explanation.
 
> With that in mind, here's waht I suggested above: set the mode after
> the xattr. I haven't tested it - can you check it solves the problem
> case you are testing?

It does. Of course the test still fails, as I said before, now claiming that
the filesystem is inconsistent. But that's a separate issue.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> xfs: don't change inode mode if ACL update fails
> 
> XXX: untested
> 
> ---
>  fs/xfs/xfs_acl.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 7034e17535de..3354140de07e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -247,6 +247,8 @@ xfs_set_mode(struct inode *inode, umode_t mode)
>  int
>  xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
> +	umode_t mode;
> +	bool set_mode = false;
>  	int error = 0;
>  
>  	if (!acl)
> @@ -257,16 +259,24 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		return error;
>  
>  	if (type == ACL_TYPE_ACCESS) {
> -		umode_t mode;
> -
>  		error = posix_acl_update_mode(inode, &mode, &acl);
>  		if (error)
>  			return error;
> -		error = xfs_set_mode(inode, mode);
> -		if (error)
> -			return error;
> +		set_mode = true;
>  	}
>  
>   set_acl:
> -	return __xfs_set_acl(inode, acl, type);
> +	error =  __xfs_set_acl(inode, acl, type);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * We set the mode after successfully updating the ACL xattr because the
> +	 * xattr update can fail at ENOSPC and we don't want to change the mode
> +	 * if the ACL update hasn't been applied.
> +	 */
> +	if (set_mode)
> +		error = xfs_set_mode(inode, mode);
> +
> +	return error;
>  }
