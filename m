Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07C6C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D3B2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 10:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jM7BTIsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbgJOKcq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 06:32:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgJOKcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 06:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602757964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xy0Y/gxifH+cu47LjIy5jlL78Oa1eetTzmqQwIkIqSA=;
        b=jM7BTIsrNULvbxPlHiljVT+fZo98sJfD0aic0uGOg5jHncN5Mv6Z6wD3XowOTNhzXBnpSa
        HN6nXQUIKQq8R+wy7a8otPV7oqdS0RTiTBOdBYoHb+B9mcwpyyTB9atE1qU7W8s0+F9UZT
        y7z6N3gBTwmD0vLjh29AJMg+9UuIcqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-KIwsMLPQP7K3sb7R-H5cIw-1; Thu, 15 Oct 2020 06:32:42 -0400
X-MC-Unique: KIwsMLPQP7K3sb7R-H5cIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01F971084C94
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 10:32:42 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3FC810027AB;
        Thu, 15 Oct 2020 10:32:41 +0000 (UTC)
Date:   Thu, 15 Oct 2020 06:32:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201015103239.GA1123529@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-2-preichl@redhat.com>
 <20201012160308.GH917726@bfoster>
 <fbbead0a-c691-f870-a33d-b80a6177ce4f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbbead0a-c691-f870-a33d-b80a6177ce4f@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 11:04:31PM +0200, Pavel Reichl wrote:
> 
> 
> On 10/12/20 6:03 PM, Brian Foster wrote:
> > On Fri, Oct 09, 2020 at 09:55:12PM +0200, Pavel Reichl wrote:
> >> Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> >> __xfs_rwsem_islocked() is a helper function which encapsulates checking
> >> state of rw_semaphores hold by inode.
> >>
> >> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> >> Suggested-by: Dave Chinner <dchinner@redhat.com>
> >> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> >> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> ---
> >>  fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
> >>  fs/xfs/xfs_inode.h | 21 +++++++++++++-------
> >>  2 files changed, 54 insertions(+), 15 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> index c06129cffba9..7c1ceb4df4ec 100644
> >> --- a/fs/xfs/xfs_inode.c
> >> +++ b/fs/xfs/xfs_inode.c
> >> @@ -345,9 +345,43 @@ xfs_ilock_demote(
> >>  }
> >>  
> >>  #if defined(DEBUG) || defined(XFS_WARN)
> >> -int
> >> +static inline bool
> >> +__xfs_rwsem_islocked(
> >> +	struct rw_semaphore	*rwsem,
> >> +	int			lock_flags)
> >> +{
> >> +	int			arg;
> >> +
> >> +	if (!debug_locks)
> >> +		return rwsem_is_locked(rwsem);
> >> +
> >> +	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> >> +		/*
> >> +		 * The caller could be asking if we have (shared | excl)
> >> +		 * access to the lock. Ask lockdep if the rwsem is
> >> +		 * locked either for read or write access.
> >> +		 *
> >> +		 * The caller could also be asking if we have only
> >> +		 * shared access to the lock. Holding a rwsem
> >> +		 * write-locked implies read access as well, so the
> >> +		 * request to lockdep is the same for this case.
> >> +		 */
> >> +		arg = -1;
> >> +	} else {
> >> +		/*
> >> +		 * The caller is asking if we have only exclusive access
> >> +		 * to the lock. Ask lockdep if the rwsem is locked for
> >> +		 * write access.
> >> +		 */
> >> +		arg = 0;
> >> +	}
> ...
> > 
> > Also, I find the pattern of shifting in the caller slightly confusing,
> > particularly with the 'lock_flags' name being passed down through the
> > caller. Any reason we couldn't pass the shift value as a parameter and
> > do the shift at the top of the function so the logic is clear and in one
> > place?
> > 
> 
> Hi Brian, is following change what you had in mind? Thanks!
> 

Yep, pretty much. I find shifted_lock_flags to be a little verbose as a
name. I'd be fine with just doing something like 'lock_flags >>= shift'
near the top of the function, but that's more of a personal nit. I also
like Christoph's suggestion to avoid the arg variable (along with the
comment update suggested in the discussion with Darrick).

Brian

> 
> >> @@ -349,14 +349,16 @@ xfs_ilock_demote(
>  static inline bool
>  __xfs_rwsem_islocked(
>  	struct rw_semaphore	*rwsem,
> -	int			lock_flags)
> +	int			lock_flags,
> +	int			shift)
>  {
>  	int			arg;
> +	const int		shifted_lock_flags = lock_flags >> shift;
>  
>  	if (!debug_locks)
>  		return rwsem_is_locked(rwsem);
>  
> -	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
> +	if (shifted_lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
>  		/*
>  		 * The caller could be asking if we have (shared | excl)
>  		 * access to the lock. Ask lockdep if the rwsem is
> @@ -387,20 +389,20 @@ xfs_isilocked(
>  {
>  	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
>  		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
> -		return __xfs_rwsem_islocked(&ip->i_lock,
> -				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
> +		return __xfs_rwsem_islocked(&ip->i_lock, lock_flags,
> +				XFS_ILOCK_FLAG_SHIFT);
>  	}
>  
>  	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
>  		ASSERT(!(lock_flags &
>  			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
> -		return __xfs_rwsem_islocked(&ip->i_mmaplock,
> -				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
> +		return __xfs_rwsem_islocked(&ip->i_mmaplock, lock_flags,
> +				XFS_MMAPLOCK_FLAG_SHIFT);
>  	}
>  
>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> -		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
> -				(lock_flags >> XFS_IOLOCK_FLAG_SHIFT));
> +		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem, lock_flags,
> +				XFS_IOLOCK_FLAG_SHIFT);
>  	}
>  
>  	ASSERT(0);
> 

