Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFF73BADB5
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 22:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782943724; cv=none; b=eZUaGKGjshOk66lWGOyASWlDbCkYtnXrZFf0tYH6rK09DVkWjkOiWhJUkMqt5EnKyp1qPfL9pUPhg+IT5X1BBFdvuYVOPhU6n3zl6M1Cba3+Qm1QYmGvFk8/i4bbxQ/j0SvxmoOy5MFWy7N7RMVrcIgPON76FHVZKT/HJ9Po4pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782943724; c=relaxed/simple;
	bh=8sIaQ/NZVYpNJNiYOvU6mWQJl2LAhfr8vlC1wBtLPhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESWv47Ejiu/d99mPShO9XUpqrvooQI+PsJuXgog4EeaOQJ31XiMcxR0fX1gca/1oSVIKjfkSkG+ySO9SO1XpiOfQJHuHlj6UWGy1jy8ayi+T2EKjLa2/PQF7Z87GzDzhQKig6AKOeAJFQJDC9gLNCoRkQsSEohqxhUx+u2DfpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NYT8ss2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NYT8ss2z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 498AA1F00A3A;
	Wed,  1 Jul 2026 22:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782943719;
	bh=RGdCKLh+AeNS/gQqf6/GZjTAR7Mme/aJkYqaLCzh4N4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NYT8ss2zsdNQZtK+v3LBPdTDYsaGIQH6qXRHubzVx+CSOxN5YZ/1x3PzcCuSHZ55B
	 1lDbXkPPqPuR18IfriMm+Ua2kXrluR6kQrVWrlskApucg4xtuUTmdlUTgnKgVhk1EA
	 c4OxUarXsMcyqSn9BVb1VZZRg2AQTPey5oJajHLLBH49eNU/EyoxQ+3C42HM97WyFN
	 bKA/rpaCHFoYmYmdOM36SAjiQnSl4iECEXvsy6JGGfd7BdMK6usVY9g1RWFqB+4yNL
	 UcisumhSFMJ3UA5WF9hV7PkVYBHsd97Ljqa+HdsG8u/CE/hnHYI1cWQS3/zDNqh3Mr
	 CrAeGnOFVAn2g==
Date: Wed, 1 Jul 2026 15:08:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 3/3] xfs: fail recovery on a committed log item with
 no regions
Message-ID: <20260701220838.GI6526@frogsfrogsfrogs>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-5-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701153833.3155514-5-bestswngs@gmail.com>

On Wed, Jul 01, 2026 at 08:38:33AM -0700, Weiming Shi wrote:
> If the first op of a transaction is a bare transaction header
> (len == sizeof(struct xfs_trans_header)), xlog_recover_add_to_trans()
> adds a recovery item but no region, leaving it on r_itemq with
> ri_cnt == 0 and ri_buf == NULL.
> 
> If a commit op follows, xlog_recover_reorder_trans() calls ITEM_TYPE()
> on the item, which reads *(unsigned short *)item->ri_buf[0].iov_base and
> faults on the NULL ri_buf.

How do we escape xlog_recover_add_to_trans with item->ri_cnt==0 when
there's a bare transaction header?  Is this the "!len" case at the top
of xlog_recover_add_to_trans?

Why don't we abort log recovery right then and there?  Are we hoping
that a subsequent "continue" section will supply some items, and that's
why we can only check ri_cnt/ri_buf if the ondisk transaction is
committed?

> The log is CRC-checked, so this op sequence comes from a crafted image,
> not media corruption.  It faults the kernel when such an image is
> mounted:
> 
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  RIP: 0010:xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
>   xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2043)
>   xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2501)
>   xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3244)
>   xlog_recover (fs/xfs/xfs_log_recover.c:3493)
>   xfs_log_mount (fs/xfs/xfs_log.c:618)
>   xfs_mountfs (fs/xfs/xfs_mount.c:1034)
>   xfs_fs_fill_super (fs/xfs/xfs_super.c:1938)
>   vfs_get_tree (fs/super.c:1695)
>   path_mount (fs/namespace.c:4161)
>   __x64_sys_mount (fs/namespace.c:4367)
> 
> A committed item always carries its format descriptor in ri_buf[0], so
> one with no regions is invalid.  Reject it with -EFSCORRUPTED, like the
> unrecognized item type below.
> 
> Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

Cc: <stable@vger.kernel.org> # v4.3

I agree that a totally empty log item is a sign of corruption, or at
least something going seriously wrong.  Can the runtime log code ever be
tricked into emitting a bare transaction header?

--D

> ---
>  fs/xfs/xfs_log_recover.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5347f6a5ec42..461e847c32a2 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1907,6 +1907,15 @@ xlog_recover_reorder_trans(
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
>  		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
>  
> +		/* a committed item with no regions has a NULL ri_buf[0] */
> +		if (!item->ri_cnt || !item->ri_buf) {
> +			xfs_warn(log->l_mp,
> +				"%s: committed log item has no regions",
> +				__func__);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +
>  		item->ri_ops = xlog_find_item_ops(item);
>  		if (!item->ri_ops) {
>  			xfs_warn(log->l_mp,
> -- 
> 2.43.0
> 
> 
