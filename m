Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 19:14:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B2EFE9026336
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 19:14:17 -0700
Message-ID: <47FEC997.5060506@sgi.com>
Date: Fri, 11 Apr 2008 12:14:47 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: iget behaviour in xlog_recover_process_iunlinks
References: <20080410190453.GA8083@lst.de>
In-Reply-To: <20080410190453.GA8083@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> shouldn't we call xfs_iget with the XFS_IGET_CREATE flag here?
> 
> the code seems to be perfectly happy with zero-ed out inodes as long as
> di_next_unlinked is valid.
> 


So looking at this code...

we look at each bucket in the AGI bucket list and
walk the di_next_unlinked list of inodes.
We do an xfs_iget with 0 for flags which will mean
in xfs_iget_core it will error
out if it finds an inode with zeroed mode
(which happens on inodes which have been zeroed b/c it is new
or inativated with the mode reset in xfs_ifree,
however, it wouldn't all be zeroed as di_next_unlinked is
non zero).

And yet in the xlog_recover_process_iunlinks() it
later checks for a zero mode or not.
>  if (ip->i_d.di_mode == 0)
>          xfs_iput_new(ip, 0);
>  else
>          IRELE(ip);
....
> void
> xfs_iput_new(xfs_inode_t        *ip,
>              uint               lock_flags)
> {
>         struct inode    *inode = ip->i_vnode;
> 
>         xfs_itrace_entry(ip);
> 
>         if ((ip->i_d.di_mode == 0)) {
>                 ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
>                 make_bad_inode(inode);
>         }
>         if (inode->i_state & I_NEW)
>                 unlock_new_inode(inode);
>         if (lock_flags)
>                 xfs_iunlock(ip, lock_flags);
>         IRELE(ip);
> }

And if it does get an error from xfs_iget, it will ditch
the rest of the list and the bucket.

So yeah to me it looks like we need XFS_IGET_CREATE or we
have handling code for zero mode which never happens or
we are risking ditching some unlinked inodes.

Was that what you were noticing?

--Tim
