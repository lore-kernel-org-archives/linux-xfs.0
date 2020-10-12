Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0841C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DEE920797
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 16:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dag1db25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgJLQDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390201AbgJLQDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 12:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602518595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WtXGWBunas8n5o+z8jbwam4wAOgJw6mF0z49dWjSiZs=;
        b=Dag1db25K36oVDLWGkouMnl8LFfGpZuLzeF1nQyB6GuPMvDUuBUrHXpFrACow2KWvUsI5a
        nx0+2cQA+fN/dKBccRhPFK050JvWgeyhfV2OqKaXjwlaaYFyffHioNWT2tCn67Qx1sBNdW
        heg+LkOd7IIPkX0eLKx5Jsd6DzKoai0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-NcPdc_wuNwOG20oXHiW35w-1; Mon, 12 Oct 2020 12:03:11 -0400
X-MC-Unique: NcPdc_wuNwOG20oXHiW35w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 995FD8030A9
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 16:03:10 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 334EF73663;
        Mon, 12 Oct 2020 16:03:10 +0000 (UTC)
Date:   Mon, 12 Oct 2020 12:03:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201012160308.GH917726@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-2-preichl@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 09:55:12PM +0200, Pavel Reichl wrote:
> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> state of rw_semaphores hold by inode.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_inode.h | 21 +++++++++++++-------
>  2 files changed, 54 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c06129cffba9..7c1ceb4df4ec 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -345,9 +345,43 @@ xfs_ilock_demote(
>  }
>  
>  #if defined(DEBUG) || defined(XFS_WARN)
> -int
> +static inline bool
> +__xfs_rwsem_islocked(
> +	struct rw_semaphore	*rwsem,
> +	int			lock_flags)
> +{
> +	int			arg;
> +
> +	if (!debug_locks)
> +		return rwsem_is_locked(rwsem);
> +
> +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> +		/*
> +		 * The caller could be asking if we have (shared | excl)
> +		 * access to the lock. Ask lockdep if the rwsem is
> +		 * locked either for read or write access.
> +		 *
> +		 * The caller could also be asking if we have only
> +		 * shared access to the lock. Holding a rwsem
> +		 * write-locked implies read access as well, so the
> +		 * request to lockdep is the same for this case.
> +		 */
> +		arg = -1;
> +	} else {
> +		/*
> +		 * The caller is asking if we have only exclusive access
> +		 * to the lock. Ask lockdep if the rwsem is locked for
> +		 * write access.
> +		 */
> +		arg = 0;
> +	}

Are these arg values documented somewhere? A quick look at the function
below didn't show anything..

Also, I find the pattern of shifting in the caller slightly confusing,
particularly with the 'lock_flags' name being passed down through the
caller. Any reason we couldn't pass the shift value as a parameter and
do the shift at the top of the function so the logic is clear and in one
place?

> +
> +	return lockdep_is_held_type(rwsem, arg);
> +}
> +
> +bool
>  xfs_isilocked(
> -	xfs_inode_t		*ip,
> +	struct xfs_inode	*ip,
>  	uint			lock_flags)
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
...
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e9a8bb184d1f..77776af75c77 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -268,12 +268,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>   * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
>   *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
>   */
> -#define	XFS_IOLOCK_EXCL		(1<<0)
> -#define	XFS_IOLOCK_SHARED	(1<<1)
> -#define	XFS_ILOCK_EXCL		(1<<2)
> -#define	XFS_ILOCK_SHARED	(1<<3)
> -#define	XFS_MMAPLOCK_EXCL	(1<<4)
> -#define	XFS_MMAPLOCK_SHARED	(1<<5)
> +
> +#define XFS_IOLOCK_FLAG_SHIFT	0
> +#define XFS_ILOCK_FLAG_SHIFT	2
> +#define XFS_MMAPLOCK_FLAG_SHIFT	4
> +
> +#define XFS_SHARED_LOCK_SHIFT	1
> +
> +#define XFS_IOLOCK_EXCL		(1 << (XFS_IOLOCK_FLAG_SHIFT))
> +#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> +#define XFS_ILOCK_EXCL		(1 << (XFS_ILOCK_FLAG_SHIFT))
> +#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
> +#define XFS_MMAPLOCK_EXCL	(1 << (XFS_MMAPLOCK_FLAG_SHIFT))
> +#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
>  

Any reason for the extra params around the shift values?

Brian

>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
>  void		xfs_iunlock(xfs_inode_t *, uint);
>  void		xfs_ilock_demote(xfs_inode_t *, uint);
> -int		xfs_isilocked(xfs_inode_t *, uint);
> +bool		xfs_isilocked(struct xfs_inode *, uint);
>  uint		xfs_ilock_data_map_shared(struct xfs_inode *);
>  uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  
> -- 
> 2.26.2
> 

