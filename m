Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4105FC83F18
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbjH3BCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbjH3BCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:02:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97B4CCF
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:02:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-68a41031768so3661038b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357320; x=1693962120; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUAoN2LL+wNxB4HFbzc1MNXMt8bLM1mD8DRWF9DdJpM=;
        b=jIH9k15s/A9/4mr29EcsI+L+smLyUH6egd8HwWckJmBhlCNrt6srIrcSvbPUgD0QyJ
         JzMTMYlCkfcg3NXLiIOSgYE33wyU+q3vmvcusz6NLtEVnOgttg8QL2Eu63JsH38/GAWU
         vnUjG+XZaD602Adsb4c5/wcfFUuIXrWs4oIgM4xi6P/uuygtZ0TdgQD4b8F7HSNGOPfy
         WFsJHzbpIi7Tou64IVxiXxuRkAyZrOPpM0gDly6l53ec23UPxOC6zkf/vQdHRHBpdUPV
         P/Vnj7vfHpIJEI56IQazdg6SGtHPdPYlPMUn/syvhcODbJhunkcH0fGokfLMyu6zK997
         H3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357320; x=1693962120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUAoN2LL+wNxB4HFbzc1MNXMt8bLM1mD8DRWF9DdJpM=;
        b=DMckax2TVUYWZrPuqJjEihTmYmfIIdGXOvOlxs7j9ugY3auDzjt6p7NfF676n/zmfL
         exns9V3S4werGKROEuPMoz0GBTY2XRifwjfKfoaT3Cqq/6zR5OuW/Bl4qMRBG5IKeS6j
         wRcbj+RB0/3OfxWFT41bjn1TjEugKzQfJFbPc6SZxKceC3qAr7qRus+I6b876BC+fOXG
         pScR4REsG5TRqTa5kr28kTg9WWZns4ndPdZXwBFPqgE2rNWE/7kHZNwtRGT/LgJwa3L5
         XHLtlaTxPaoXibi4ih4K4P8c90RTnBi1yjrh8lO5/np7U1uwkiGAwU/ULLn7jfmvZLaf
         B/hg==
X-Gm-Message-State: AOJu0Yw3ynlBvtGphFrjizuMMa1X8XKiVQEmxawdxUQ6KKyCW9rlIr1U
        HGU//ofGsAfB1mPKPrwFZUL+DQ==
X-Google-Smtp-Source: AGHT+IE9Fa9rJ5dJK/ZUvqGA++6ZyBJzqK+SbSPBhREJGER0uiXBZXy5TEJZg6I4+ynNHjy+qLDTtA==
X-Received: by 2002:a17:902:934c:b0:1bc:5924:2da2 with SMTP id g12-20020a170902934c00b001bc59242da2mr648690plp.56.1693357320149;
        Tue, 29 Aug 2023 18:02:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:01:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb8ps-008I69-1W;
        Wed, 30 Aug 2023 10:13:28 +1000
Date:   Wed, 30 Aug 2023 10:13:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [RFC PATCH] xfs: load uncached unlinked inodes into memory on
 demand
Message-ID: <ZO6JqOBOOUCcS4ac@dread.disaster.area>
References: <20230829232043.GE28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829232043.GE28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:20:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> shrikanth hegde reports that filesystems fail shortly after mount with
> the following failure:
> 
> 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> 
> This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
> 
> 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
> 
> From diagnostic data collected by the bug reporters, it would appear
> that we cleanly mounted a filesystem that contained unlinked inodes.
> Unlinked inodes are only processed as a final step of log recovery,
> which means that clean mounts do not process the unlinked list at all.
> 
> Prior to the introduction of the incore unlinked lists, this wasn't a
> problem because the unlink code would (very expensively) traverse the
> entire ondisk metadata iunlink chain to keep things up to date.
> However, the incore unlinked list code complains when it realizes that
> it is out of sync with the ondisk metadata and shuts down the fs, which
> is bad.
> 
> Ritesh proposed to solve this problem by unconditionally parsing the
> unlinked lists at mount time, but this imposes a mount time cost for
> every filesystem to catch something that should be very infrequent.
> Instead, let's target the places where we can encounter a next_unlinked
> pointer that refers to an inode that is not in cache, and load it into
> cache.
> 
> Note: This patch does not address the problem of iget loading an inode
> from the middle of the iunlink list and needing to set i_prev_unlinked
> correctly.
> 
> Link: https://lore.kernel.org/linux-xfs/e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com/
> Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++++
>  2 files changed, 92 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6ee266be45d4..3ab140ec09bb 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
>  
>  	rcu_read_lock();
>  	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +	if (!ip) {
> +		/* Caller can handle inode not being in memory. */
> +		rcu_read_unlock();
> +		return NULL;
> +	}
>  
>  	/*
> -	 * Inode not in memory or in RCU freeing limbo should not happen.
> -	 * Warn about this and let the caller handle the failure.
> +	 * Inode in RCU freeing limbo should not happen.  Warn about this and
> +	 * let the caller handle the failure.
>  	 */
> -	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
> +	if (WARN_ON_ONCE(!ip->i_ino)) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}

I think we should still log a message about this situation, as it implies
that we had an unrecovered unlinked list on the filesystem and that
should "never happen" in normal conditions.

i.e. something like:

XFS(dev): Found unrecovered unlinked inodes in AG X. Runtime recovery initiated.

which uses a perag state flag to only issue the message once per AG
per mount. At least this way, if we get weird stuff happening
because of loading an inode in the middle of an unlinked list (the
unhandled prev_agino case) we know why weird stuff might be
happening...

> @@ -1902,6 +1907,60 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> +/*
> + * Load the inode @next_agino into the cache and set its prev_unlinked pointer
> + * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
> + * to the unlinked list.
> + */
> +STATIC int
> +xfs_iunlink_reload_next(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
> +	xfs_agino_t		prev_agino,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_perag	*pag = agibp->b_pag;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*next_ip = NULL;
> +	xfs_ino_t		ino;
> +	int			error;
> +
> +	ASSERT(next_agino != NULLAGINO);
> +
> +#ifdef DEBUG
> +	rcu_read_lock();
> +	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
> +	ASSERT(next_ip == NULL);
> +	rcu_read_unlock();
> +#endif
> +
> +	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
> +	if (error)
> +		return error;

WHy are we using XFS_IGET_UNTRUSTED here? A comment explaining why
we don't trust the agino on th eunlinked list we are about to try to
recover (i.e. trust!) would be good.

> +	/* If this is not an unlinked inode, something is very wrong. */
> +	if (VFS_I(next_ip)->i_nlink != 0) {
> +		error = -EFSCORRUPTED;
> +		goto rele;
> +	}

*nod*

> +
> +	next_ip->i_prev_unlinked = prev_agino;
> +	trace_xfs_iunlink_reload_next(next_ip);
> +rele:
> +	/*
> +	 * We're running in transaction context, so we cannot run any inode
> +	 * release code.  Clear DONTCACHE on this inode to prevent the VFS from
> +	 * initiating writeback and to force the irele to push this inode to
> +	 * the LRU instead of dropping it immediately.
> +	 */
> +	spin_lock(&VFS_I(next_ip)->i_lock);
> +	VFS_I(next_ip)->i_state &= ~I_DONTCACHE;
> +	spin_unlock(&VFS_I(next_ip)->i_lock);
> +	xfs_irele(next_ip);

Huh. We just loaded the next_ip into memory - how is it dirty,
and what writeback will happen? Also, how would I_DONTCACHE get set
in the first place here?


> +	return error;
> +}
> +
>  static int
>  xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> @@ -1933,6 +1992,8 @@ xfs_iunlink_insert_inode(
>  	 * inode.
>  	 */
>  	error = xfs_iunlink_update_backref(pag, agino, next_agino);
> +	if (error == -ENOLINK)
> +		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
>  	if (error)
>  		return error;

Where does this -ENOLINK error come from?
xfs_iunlink_update_backref() returns either -EFSCORRUPTED or 0. Is
the patch missing hunks or is it dependent on some other patch that
does this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
