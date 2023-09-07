Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31FCEC8741
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Sep 2023 16:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjIGQNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbjIGQNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2023 12:13:08 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D49E4C38
        for <linux-xfs@vger.kernel.org>; Thu,  7 Sep 2023 08:50:01 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6b9a2416b1cso806972a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Sep 2023 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1694101722; x=1694706522; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJGl3PdZRvfd0BooNBkYtUJChhaTuf25G8ErXGwZSzc=;
        b=FFbbdcNJBmgM74vwO9QaOf2C/ZCiXVZyUHRwJnvPtfDcFYWC7AWIpt6yowwpmy/KiY
         IZlN2SsyKNOOKgugAwSl4BovuokYI4NpNZhDvI28/IWJKghQoAFmujbsD/vJhJkrDe7s
         LkxfO6fLy40yFfAGhYgNcoOQ0uefFT+rmbnZ7zf4kyqOaHeiElUbLQlmT9ApHhNS8AyG
         /5Vazu26Mg8NqwFDAs6b3JYBDyf0xTf21ZpJ6hMRPLQSMTRTCxkeBwE7m6AjrKoKFR+n
         QoytvePRUyiSWx319qUYe6I3b4HKO2mqYY0+maz17/HkSaEYkEotAddX9rOmY07vpVIQ
         lU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694101722; x=1694706522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJGl3PdZRvfd0BooNBkYtUJChhaTuf25G8ErXGwZSzc=;
        b=PHUXc9lj6ELyVtp9Z9GwoQN0jWEWgZAUCfO2s8/TFdnaq0dJxR2g+b9Jjc2mvz2DEX
         bT1N4huCm8u02yZgJR8Tk7yFJAUM5v38Nepipx/Q4vk8WiWxuO5XR/yJFNTlndBctmy0
         0X3EQs02MmeSMR+qVuEcFFyYvDE8KCvrAcaXP0Uvu3/LwYrSv0jerKc9wCV6X09aDIYZ
         bfH7TwwpU3tq+aDzv+Txt9vNqKB8mowuT96O1uGmtGm7r5120qk8qCpE+fsele7V2tb7
         oX2A/DHTHBG8LnTrwKzvMWSGvf6lPju2UkP1XQJ95b/WZe3c4R/z/xE+OH9KXkjOyrTp
         GfLw==
X-Gm-Message-State: AOJu0YyEZ8ZyWhVQdtrXOvO6XY463qCuwTfQ3sX3iX6zdVGCs4Rq8iKW
        jNWvep6MDWnfr5wKrHlprQFXTgSSurT/AOVvpeY=
X-Google-Smtp-Source: AGHT+IFXYIgB2dFs6Q25/8Wps3UoDS8jsu8VaUFSGs7mLtJCrGhaGvhexssp70QpD2QIyodenJUtRg==
X-Received: by 2002:a05:6e02:1bcf:b0:34c:ebe8:9900 with SMTP id x15-20020a056e021bcf00b0034cebe89900mr23712199ilv.3.1694070135357;
        Thu, 07 Sep 2023 00:02:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id mj11-20020a17090b368b00b0026fb228fafasm844148pjb.18.2023.09.07.00.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 00:02:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qe91o-00BvaR-18;
        Thu, 07 Sep 2023 17:02:12 +1000
Date:   Thu, 7 Sep 2023 17:02:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: reload entire unlinked bucket lists
Message-ID: <ZPl1dFZFlNtWIMpD@dread.disaster.area>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375775896.3323693.9893712061608339722.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169375775896.3323693.9893712061608339722.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2023 at 09:15:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The previous patch to reload unrecovered unlinked inodes when adding a
> newly created inode to the unlinked list is missing a key piece of
> functionality.  It doesn't handle the case that someone calls xfs_iget
> on an inode that is not the last item in the incore list.  For example,
> if at mount time the ondisk iunlink bucket looks like this:
> 
> AGI -> 7 -> 22 -> 3 -> NULL
> 
> None of these three inodes are cached in memory.  Now let's say that
> someone tries to open inode 3 by handle.  We need to walk the list to
> make sure that inodes 7 and 22 get loaded cold, and that the
> i_prev_unlinked of inode 3 gets set to 22.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_export.c |    6 +++
>  fs/xfs/xfs_inode.c  |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |    9 +++++
>  fs/xfs/xfs_itable.c |    9 +++++
>  fs/xfs/xfs_trace.h  |   20 ++++++++++
>  5 files changed, 144 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index 1064c2342876..f71ea786a6d2 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -146,6 +146,12 @@ xfs_nfs_get_inode(
>  		return ERR_PTR(error);
>  	}
>  
> +	error = xfs_inode_reload_unlinked(ip);
> +	if (error) {
> +		xfs_irele(ip);
> +		return ERR_PTR(error);
> +	}

We don't want to be creating an empty transaction, locking the inode
and then cancelling the transaction having done nothing on every
NFS handle we have to resolve. We only want to do this if the link
count is zero and i_prev_unlinked == 0, at which point we can then
take the slow path (i.e call xfs_inode_reload_unlinked()) to reload
the unlinked list. Something like:

	if (xfs_inode_unlinked_incomplete(ip)) {
		error = xfs_inode_reload_unlinked(ip);
		if (error) {
			xfs_irele(ip);
			return ERR_PTR(error);
		}
	}


Hmmmm.  if i_nlink is zero on ip and we call xfs_irele() on it, the
it will be punted straight to inactivation, which will try to remove
it from the unlinked list and free it. But we just failed to reload
the unlinked list, so inactivation is going to go badly...

So on reload error, shouldn't we be shutting down the filesystem
because we know we cannot safely remove this inode from the unlinked
list and free it?

> +
>  	if (VFS_I(ip)->i_generation != generation) {
>  		xfs_irele(ip);
>  		return ERR_PTR(-ESTALE);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6cd2f29b540a..56f6bde6001b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3607,3 +3607,103 @@ xfs_iunlock2_io_mmap(
>  	if (ip1 != ip2)
>  		inode_unlock(VFS_I(ip1));
>  }
> +
> +/*
> + * Reload the incore inode list for this inode.  Caller should ensure that
> + * the link count cannot change, either by taking ILOCK_SHARED or otherwise
> + * preventing other threads from executing.
> + */
> +int
> +xfs_inode_reload_unlinked_bucket(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*agibp;
> +	struct xfs_agi		*agi;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> +	xfs_agino_t		prev_agino, next_agino;
> +	unsigned int		bucket;
> +	bool			foundit = false;
> +	int			error;
> +
> +	/* Grab the first inode in the list */
> +	pag = xfs_perag_get(mp, agno);
> +	error = xfs_ialloc_read_agi(pag, tp, &agibp);
> +	xfs_perag_put(pag);
> +	if (error)
> +		return error;
> +
> +	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
> +	agi = agibp->b_addr;
> +
> +	trace_xfs_inode_reload_unlinked_bucket(ip);
> +
> +	xfs_info_ratelimited(mp,
> + "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating list recovery.",
> +			agino, agno);
> +
> +	prev_agino = NULLAGINO;
> +	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
> +	while (next_agino != NULLAGINO) {
> +		struct xfs_inode	*next_ip = NULL;
> +
> +		if (next_agino == agino) {
> +			/* Found this inode, set its backlink. */
> +			next_ip = ip;
> +			next_ip->i_prev_unlinked = prev_agino;
> +			foundit = true;
> +		}
> +		if (!next_ip) {
> +			/* Inode already in memory. */
> +			next_ip = xfs_iunlink_lookup(pag, next_agino);
> +		}
> +		if (!next_ip) {
> +			/* Inode not in memory, reload. */
> +			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
> +					next_agino);
> +			if (error)
> +				break;
> +
> +			next_ip = xfs_iunlink_lookup(pag, next_agino);
> +		}
> +		if (!next_ip) {
> +			/* No incore inode at all?  We reloaded it... */
> +			ASSERT(next_ip != NULL);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}

Not a great fan of this logic construct, nor am I great fan of
asking you to restructure code for vanity reasons. However, I do
think a goto improves it quite a lot:

	while (next_agino != NULLAGINO) {
		struct xfs_inode	*next_ip = NULL;

		if (next_agino == agino) {
			/* Found this inode, set its backlink. */
			next_ip = ip;
			next_ip->i_prev_unlinked = prev_agino;
			foundit = true;
			goto next_inode;
		}

		/* Try in-memory lookup first. */
		next_ip = xfs_iunlink_lookup(pag, next_agino);
		if (next_ip)
			goto next_inode;

		/* Inode not in memory, try reloading it. */
		error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
				next_agino);
		if (error)
			break;

		/* Grab the reloaded inode */
		next_ip = xfs_iunlink_lookup(pag, next_agino);
		if (!next_ip) {
			/* No incore inode at all, list must be corrupted. */
			ASSERT(next_ip != NULL);
			error = -EFSCORRUPTED;
			break;
		}
next_inode:
		prev_agino = next_agino;
		next_agino = next_ip->i_next_unlinked;
	}

If you think it's better, feel free to use this. Otherwise I can
live with the code until I have to touch this code again...

......

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index f225413a993c..ea38d69b9922 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -80,6 +80,15 @@ xfs_bulkstat_one_int(
>  	if (error)
>  		goto out;
>  
> +	if (xfs_inode_unlinked_incomplete(ip)) {
> +		error = xfs_inode_reload_unlinked_bucket(tp, ip);
> +		if (error) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			xfs_irele(ip);
> +			return error;
> +		}
> +	}

Same question here about shutdown on error being necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
