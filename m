Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D710A2C2354;
	Mon, 15 Sep 2025 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757960458; cv=none; b=ntMzGPoRzBERgH3fQu9lHJ4ubGXJaClyDOyD4iB8lJsrnEUGd5Xoeer7aSqujU7AErGORfLo/tAvAxG3itPK08bRXrl+zgO7WD9n8Cvc+BQwAwZaDKPWChMuACoZ/1197nms4JbIIE0/N215kG1JldvDtIIxZdmc40ajdEanPJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757960458; c=relaxed/simple;
	bh=C+jlw61u8ZmAqA0aRDKtJ2SMaA4kWKFBfzyeC1aSKlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6tSRIOOH13MyUkYtcTwKozHCysYKdCs6r+BGi5HJQzHzq3tmlwnFvDXm941/Jn+iRax629Rs97PfSqwC7PKB//aGbRaTce8x9TcMPeBl/lPam66EX7rtYu923M3/XmnLk64/1QSHi+BzKSy0gpIz6i8PAz0XrgExmyAZzawVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ii1Im98I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii1Im98I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71161C4CEF1;
	Mon, 15 Sep 2025 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757960457;
	bh=C+jlw61u8ZmAqA0aRDKtJ2SMaA4kWKFBfzyeC1aSKlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ii1Im98IiZudOz56pMvlutKTZjh2F2ni2qJNyZg8+heQA1qwGI/U4HdRVCmno2LvR
	 1wIdWZaDlhrHC7be4w6d2WkwT4pu7f/ahGiDwnWj9ctFjpY8SWSQ59PErO3GWfO/LH
	 3ZRfZD++RmQdOT74G0CSLqk/RjbPaqq8GDDVsym3jt2m1XUJXL36kM0q1GxKvznxbX
	 sJym0YgCeFtN7fyx1USRdZo0/YLkyAOvDh6GeUY6cj1ZaJ7kkS8Jb/aerBeid+FIJ5
	 //0FpOSI8HDj1Swtlj1T9iPWbExvXrfUt4jtLGtZ8wTDcAAfLhyDkE+lO2dx8D35so
	 VNfr7SzRRmbuA==
Date: Mon, 15 Sep 2025 11:20:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
Message-ID: <20250915182056.GO8096@frogsfrogsfrogs>
References: <20250913030503.433914-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250913030503.433914-1-amir73il@gmail.com>

On Sat, Sep 13, 2025 at 05:05:02AM +0200, Amir Goldstein wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
> 
> With parent pointers enabled, a rename operation can update up to 5
> inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> their dquots to a be attached to the transaction chain, so we need
> to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> function xfs_dqlockn to lock an arbitrary number of dquots.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> [amir: backport to kernels prior to parent pointers to fix an old bug]
> 
> A rename operation of a directory (i.e. mv A/C/ B/) may end up changing
> three different dquot accounts under the following conditions:
> 1. user (or group) quotas are enabled
> 2. A/ B/ and C/ have different owner uids (or gids)
> 3. A/ blocks shrinks after remove of entry C/
> 4. B/ blocks grows before adding of entry C/
> 5. A/ ino <= XFS_DIR2_MAX_SHORT_INUM
> 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> 7. C/ is converted from sf to block format, because its parent entry
>    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock)
> 
> When all conditions are met (observed in the wild) we get this assertion:
> 
> XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: 207
> 
> The upstream commit fixed this bug as a side effect, so decided to apply
> it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable kernels.

Heh.  Indeed, you only need MAXDQS==5 for filesystems that support
parent pointers, because only on those filesystems can you end up
needing to allocate a xattr block either to the new whiteout file or
free one from the file being unlinked.

> The Fixes commit below is NOT the commit that introduced the bug, but
> for some reason, which is not explained in the commit message, it fixes
> the comment to state that highest number of dquots of one type is 3 and
> not 2 (which leads to the assertion), without actually fixing it.

Agree.

> The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> suggests that there may have been a confusion between "the number of
> dquote of one type" and "the number of dquot types" (which is also 3),
> so the comment change was only accidentally correct.

I interpret the "OR" -> "and" change to reflect the V4 -> V5 transition
where you actually can have all three dquot types because group/project
quota are no longer mutually exclusive.

The "...involved in a transaction is 3" part I think is separate, and
strange that XFS_QM_TRANS_MAXDQS wasn't updated.

> Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dqlockedjoin")
> Cc: stable@vger.kernel.org
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christoph,
> 
> This is a cognitive challenge. can you say what you where thinking in
> 2013 when making the comment change in the Fixes commit?
> Is my speculation above correct?
> 
> Catherine and Leah,
> 
> I decided that cherry-pick this upstream commit as is with a commit
> message addendum was the best stable tree strategy.
> The commit applies cleanly to 5.15.y, so I assume it does for 6.6 and
> 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did not
> try to reproduce these complex assertion in a test.
> 
> Could you take this candidate backport patch to a spin on your test
> branch?
> 
> What do you all think about this?

I only think you need MAXDQS==5 for 6.12 to handle parent pointers.

The older kernels could have it set to 3 instead.  struct xfs_dqtrx on a
6.17-rc6 kernel is 88 bytes.  Stuffing 9 of them into struct
xfs_dquot_acct instead of 15 means that the _acct struct is only 792
bytes instead of 1392, which means we can use the 1k slab instead of the
2k slab.

--D

> Thanks,
> Amir.
> 
>  fs/xfs/xfs_dquot.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_dquot.h       |  1 +
>  fs/xfs/xfs_qm.h          |  2 +-
>  fs/xfs/xfs_trans_dquot.c | 15 ++++++++++-----
>  4 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c15d61d47a06..6b05d47aa19b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1360,6 +1360,47 @@ xfs_dqlock2(
>  	}
>  }
>  
> +static int
> +xfs_dqtrx_cmp(
> +	const void		*a,
> +	const void		*b)
> +{
> +	const struct xfs_dqtrx	*qa = a;
> +	const struct xfs_dqtrx	*qb = b;
> +
> +	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
> +		return 1;
> +	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
> +		return -1;
> +	return 0;
> +}
> +
> +void
> +xfs_dqlockn(
> +	struct xfs_dqtrx	*q)
> +{
> +	unsigned int		i;
> +
> +	BUILD_BUG_ON(XFS_QM_TRANS_MAXDQS > MAX_LOCKDEP_SUBCLASSES);
> +
> +	/* Sort in order of dquot id, do not allow duplicates */
> +	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
> +		unsigned int	j;
> +
> +		for (j = 0; j < i; j++)
> +			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
> +	}
> +	if (i == 0)
> +		return;
> +
> +	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
> +
> +	mutex_lock(&q[0].qt_dquot->q_qlock);
> +	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
> +		mutex_lock_nested(&q[i].qt_dquot->q_qlock,
> +				XFS_QLOCK_NESTED + i - 1);
> +}
> +
>  int __init
>  xfs_qm_init(void)
>  {
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 6b5e3cf40c8b..0e954f88811f 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -231,6 +231,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
>  void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  
>  void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
> +void		xfs_dqlockn(struct xfs_dqtrx *q);
>  
>  void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
>  
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 442a0f97a9d4..f75c12c4c6a0 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -121,7 +121,7 @@ enum {
>  	XFS_QM_TRANS_PRJ,
>  	XFS_QM_TRANS_DQTYPES
>  };
> -#define XFS_QM_TRANS_MAXDQS		2
> +#define XFS_QM_TRANS_MAXDQS		5
>  struct xfs_dquot_acct {
>  	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
>  };
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 955c457e585a..99a03acd4488 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -268,24 +268,29 @@ xfs_trans_mod_dquot(
>  
>  /*
>   * Given an array of dqtrx structures, lock all the dquots associated and join
> - * them to the transaction, provided they have been modified.  We know that the
> - * highest number of dquots of one type - usr, grp and prj - involved in a
> - * transaction is 3 so we don't need to make this very generic.
> + * them to the transaction, provided they have been modified.
>   */
>  STATIC void
>  xfs_trans_dqlockedjoin(
>  	struct xfs_trans	*tp,
>  	struct xfs_dqtrx	*q)
>  {
> +	unsigned int		i;
>  	ASSERT(q[0].qt_dquot != NULL);
>  	if (q[1].qt_dquot == NULL) {
>  		xfs_dqlock(q[0].qt_dquot);
>  		xfs_trans_dqjoin(tp, q[0].qt_dquot);
> -	} else {
> -		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
> +	} else if (q[2].qt_dquot == NULL) {
>  		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
>  		xfs_trans_dqjoin(tp, q[0].qt_dquot);
>  		xfs_trans_dqjoin(tp, q[1].qt_dquot);
> +	} else {
> +		xfs_dqlockn(q);
> +		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
> +			if (q[i].qt_dquot == NULL)
> +				break;
> +			xfs_trans_dqjoin(tp, q[i].qt_dquot);
> +		}
>  	}
>  }
>  
> -- 
> 2.47.1
> 
> 
