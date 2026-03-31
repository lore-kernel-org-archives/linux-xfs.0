Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1513A4F2F;
	Tue, 31 Mar 2026 10:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774953597; cv=none; b=NiA5PvoDnuXp9SZ5CTedsb7U7QuwqMFh/R5xSL5NsC2n5wGt0o6bth5WJzxfa2EYNE4AqmHi7USqCTBi+BpHo/XwXEi59EmmzCpcVPzuiRu02fFNLlqoUNM6wOUrn3pVUZI6OnacYhVkCtcRksjCx3ea55bS/k4C1yirloyUwJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774953597; c=relaxed/simple;
	bh=i5WStOZl6vAyzIT7A4hzQwI+IQ620Hpq4xCv5ziUciA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCF4ZZ5r0ostmZFezYli/l6RmrFpKq16fEWwoa70lHyB+IpjDm6keGFq6Sc/pnHvQuWnZCkeQUUeAp/MajylIDfMdmWCiyqnuWAkRSIz4i8Aoh+yIrAovjhIGYzZYKgZBhf9ydI4I+RidCE8lodWhX/pvUtThQclSz/07hpVAnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uraYR/Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uraYR/Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC62FC19423;
	Tue, 31 Mar 2026 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774953597;
	bh=i5WStOZl6vAyzIT7A4hzQwI+IQ620Hpq4xCv5ziUciA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uraYR/Dybjpku/vFsoxC1uobPoK1Nlz5vvBV9H8hkrz+o/n51AMgUhrRFxc8jlVl+
	 l+2C8+5GZnJpDD7x9U4OBAmeUEgBxfZUSgj448cf1MZ+CDVy6KVj6qWhzBHfV2FzPl
	 ThrUjcSJexGTGs5IlneVUnZ+SFLe8odiM7SZMibe1c5GfAlbgWf9wtbz1QSQsPICAb
	 /HLk2EiDJkgxHExJ0OimngXPkLAj1U9pLPnl9/hW1INwOpMuPKs5n8JQFvjbJcePNK
	 1lajFD4mWj32eRzb3uYgRa5ehqH0asu1wC8emIli+fyV4WCXqPKMq5Ieq8hh/lPWHs
	 aS6eDquQLz4Pw==
Date: Tue, 31 Mar 2026 12:39:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	adilger@dilger.ca, jack@suse.com, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3] xfs: return default quota limits for IDs without a
 dquot
Message-ID: <acukaX9CqWpcP3d1@nidhogg.toxiclabs.cc>
References: <20260317065947.306954-1-ravising@redhat.com>
 <20260330061414.1190802-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330061414.1190802-1-ravising@redhat.com>

On Mon, Mar 30, 2026 at 02:14:14PM +0800, Ravi Singh wrote:
> When an ID has no dquot on disk, Q_XGETQUOTA returns -ENOENT even
> though default quota limits are configured and enforced against that
> ID.  This means unprivileged users who have never used any resources
> cannot see the limits that apply to them.
> 
> When xfs_qm_dqget() returns -ENOENT for a non-zero ID, return a
> zero-usage response with the default limits filled in from
> m_quotainfo rather than propagating the error.  This is consistent
> with the enforcement behavior in xfs_qm_adjust_dqlimits(), which
> pushes the same default limits into a dquot when it is first
> allocated.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ravi Singh <ravising@redhat.com>

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  v3:
>   - Return -ENOENT when no default limits are configured
>     instead of returning a zero-filled response (Darrick)
> 
>  v2:
>   - Moved fix from VFS (fs/quota/quota.c) to XFS
>     (fs/xfs/xfs_qm_syscalls.c) per review feedback
>   - Return default limits on ENOENT instead of granting
>     unprivileged access to ID 0's dquot
> 
>  fs/xfs/xfs_qm_syscalls.c | 43 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index d50b7318c..21a784986 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -391,6 +391,38 @@ xfs_qm_scall_setqlim(
>  	return error;
>  }
>  
> +/*
> + * Fill out the default quota limits for an ID that has no dquot on disk.
> + * Returns 0 if default limits are configured
> + * and were filled in, -ENOENT otherwise.
> + */
> +static int
> +xfs_qm_scall_getquota_fill_defaults(
> +	struct xfs_mount	*mp,
> +	xfs_dqtype_t		type,
> +	struct qc_dqblk		*dst)
> +{
> +	struct xfs_def_quota	*defq;
> +
> +	defq = xfs_get_defquota(mp->m_quotainfo, type);
> +
> +	if (!defq->blk.soft && !defq->blk.hard &&
> +	    !defq->ino.soft && !defq->ino.hard &&
> +	    !defq->rtb.soft && !defq->rtb.hard) {
> +		return -ENOENT;
> +	}
> +
> +	memset(dst, 0, sizeof(*dst));
> +	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, defq->blk.soft);
> +	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, defq->blk.hard);
> +	dst->d_ino_softlimit = defq->ino.soft;
> +	dst->d_ino_hardlimit = defq->ino.hard;
> +	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, defq->rtb.soft);
> +	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, defq->rtb.hard);
> +
> +	return 0;
> +}
> +
>  /* Fill out the quota context. */
>  static void
>  xfs_qm_scall_getquota_fill_qc(
> @@ -451,8 +483,17 @@ xfs_qm_scall_getquota(
>  	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
>  	 */
>  	error = xfs_qm_dqget(mp, id, type, false, &dqp);
> -	if (error)
> +	if (error) {
> +		/*
> +		 * If there is no dquot on disk and default limits are
> +		 * configured, return them with zero usage so that
> +		 * unprivileged users can see what limits apply to them.
> +		 */
> +		if (error == -ENOENT && id != 0 &&
> +		    !xfs_qm_scall_getquota_fill_defaults(mp, type, dst))
> +			return 0;
>  		return error;
> +	}
>  
>  	/*
>  	 * If everything's NULL, this dquot doesn't quite exist as far as
> -- 
> 2.49.0
> 
