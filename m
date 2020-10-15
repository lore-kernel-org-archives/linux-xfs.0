Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4154EC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0442224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U71xhKSh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbgJOIUC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388046AbgJOIUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:20:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FF8C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9uznFTFh3UNDz1oqX994L3kR6K2RIfrD7Y2o5UPQDnM=; b=U71xhKShj3WMtpmDyWZPeQ2rBc
        DQT5uyqoGX3Yvqgzok5C7N0TGRdJ2xl6ohv25n7VcqlveI0Q6wnq0LzPmPyqWVIeYa/fKVxOf9V12
        biv4U4cfNCbDK54iS4sJgJkRYnrzabwCQJapGZm/xV3jXdefb/GMHFsvAHjTfJoo/gxdzzlZgzrXX
        gB/xpUzU1bZIulmGi7mx+q7iEvCRwMBoYZ4Xb2X5HoqYpg6lriAyUu/O0YKkhQVuhMX7kQMYpLoqv
        ry5SEhoG9VBvrIK2/RgmXPBf/kvdyQzKP2DAJI5/v4FgcgD09zLTlHeXEWCAQ1B4OV7qLCwmJ696y
        D+XuZp0w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyUS-0000nR-7h; Thu, 15 Oct 2020 08:20:00 +0000
Date:   Thu, 15 Oct 2020 09:20:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20201015082000.GD1882@infradead.org>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009195515.82889-2-preichl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
> +
> +	return lockdep_is_held_type(rwsem, arg);

Why not write this as:

	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
		...
		return lockdep_is_held_type(rwsem, 1);
	}

	...
	return lockdep_is_held_type(rwsem, 0);
}

which seems a lot easier to read compare to the strange arg variable.

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
