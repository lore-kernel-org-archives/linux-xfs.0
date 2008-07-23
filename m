Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:50:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N7oa7m013039
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:50:36 -0700
Date: Wed, 23 Jul 2008 03:51:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [UPDATED RFC] Create with EA initial work
Message-ID: <20080723075145.GC24031@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1215675545-2707-1-git-send-email-xaiki@sgi.com> <20080722043851.GA7244@infradead.org> <87y73t9n8k.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y73t9n8k.fsf@cxhome.ath.cx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 03:35:23PM +1000, Niv Sardi wrote:
> > There are multiple ways to deal with inodes linked to transactions.
> >
> > In all cases it needs to be linked into the transaction by
> > xfs_trans_ijoin, or the opencoded equivalent for a new inode in
> > xfs_trans_iget.
> 
> Shouldn't the inode already be in the transaction ? we just created it
> and added it to the directory ?
> 
> xfs_create()
>   xfs_dir_ialloc(tp, dp, ip)
>     xfs_ialloc(tp, dp, ip)
>       xfs_trans_iget(tp, ip)
> 
> and it has a i_transp after dir_ialloc.
> 
> And is why don't we use ijoin in iget as we copy the exact same code a
> few lines later ? (like in [0])

Yes, it is in the transaction.  I just meant to say xfs_trans_iget
opencodes the transaction linking otherwise done in xfs_trans_ijoin.

> >  Then you can use xfs_trans_ihold to make sure on transaction commit
> > the inode reference count is not dropped and the inode is not
> > unlocked, or simply grab a reference to the inode and let the
> > transaction commit handler unlock it and decrement the reference
> > count.  The latter is what's used by xfs_create and the former is what
> > the attr code does, and as far as I can see the only things what works
> > with xfs_attr_rolltrans.
> 
> hum, that seemed to work on my UML, shall we require callers to do all
> the ihold, ijoin stuff or should we do that (or at least check it) from
> the new attr*_trans code ?

I'm not sure.  What we need to is to make sure we don't have multiple
linked transactions that use the iget + unlock style.  One way to do
that would to alwas use the xfs_trans_ihold style first and then
add a helper that just clears XFS_ILI_HOLD for the final transaction
in create.

> diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
> index 2a1c0f0..1dbcbe9 100644
> --- a/fs/xfs/xfs_trans_inode.c
> +++ b/fs/xfs/xfs_trans_inode.c
> @@ -138,35 +138,7 @@ xfs_trans_iget(
>  	}
>  	ASSERT(ip != NULL);
>  
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	if (ip->i_itemp == NULL)
> -		xfs_inode_item_init(ip, mp);
> -	iip = ip->i_itemp;
> -	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
> -
> -	xfs_trans_inode_broot_debug(ip);
> -
> -	/*
> -	 * If the IO lock has been acquired, mark that in
> -	 * the inode log item so we'll know to unlock it
> -	 * when the transaction commits.
> -	 */
> -	ASSERT(iip->ili_flags == 0);
> -	if (lock_flags & XFS_IOLOCK_EXCL) {
> -		iip->ili_flags |= XFS_ILI_IOLOCKED_EXCL;
> -	} else if (lock_flags & XFS_IOLOCK_SHARED) {
> -		iip->ili_flags |= XFS_ILI_IOLOCKED_SHARED;
> -	}
> -
> -	/*
> -	 * Initialize i_transp so we can find it with xfs_inode_incore()
> -	 * above.
> -	 */
> -	ip->i_transp = tp;
> -
> -	*ipp = ip;
> +	xfs_trans_ijoin(tp, ip, lock_flags);

Did you test this?  For one the *ipp assignment seems to be missing now,
and second I'd think we'd have to audit the ASSERTs in xfs_trans_ijoin
if they are correct for the iget case.  But I think this is a good idea,
and if the asserts are not okay just create an _xfs_trans_ijoin without
them that's used by xfs_trans_ijoin.
