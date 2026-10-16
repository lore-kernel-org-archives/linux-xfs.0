Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3953B42D9
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179896; cv=none; b=nh2ZGkF8vQNp4RCDUOYzBXlrFgjpLI3eiKIbV8LlAznKYvuWBhGVquksiT/wG3ZXhvKJcjCJ03q1SmBtjJ8Fz03hVx8zokpRGTgLb2bnBf19gA3zI2guVpdLQ9h2Zbjw17rRkyEcbffs2Wp6yALi3nxBbLBYl3tYteZ/giako9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179896; c=relaxed/simple;
	bh=hU38OxjfRYxnSOa4bLQsqRoY8PQSAyexFmlQUp53EbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5W0utV4SDGA9DqR6EFtc54fyW7jdxTpkodptK5jVUYTyWMiAj+sfd5LQBTEIr3h58MXkBajJt8cbVS1hzjwSdqS75E3OIGgbuQRKP0E+5hE7/7iTm9l2POfeOgxJ4r7i1LpLToLc8iRPXQ3hEvJQHaJSJlxXXAEHfcmIvEmRjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4lh6ZQd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4lh6ZQd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 458121F000C4;
	Fri, 16 Oct 2026 19:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179895;
	bh=SJsumActhcrsz/Bv5jogwiWItEfLTf8+pUg3mVLa3/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a4lh6ZQdojFl4ZhfLWtiDqzEzXIV5lIK7rHOLsW7RBSL/JDmRa6XtvqYP0Q2VQZd+
	 pZt0S06SbuqYOaKB4BvwYpknG8BG4s2kUQKYGQya33DqhjUlxrN+w88ohF88AxtHEj
	 5/9xXS7lK+nHoT0nRFX5GpL9x8vK7sAVrT9t0N1Yk4QEzlmA24reE9GhtPAc29bgtG
	 5bQWSSVJcOWFQ3j0GxRFj7zfKlS7iL+dYWIyiu8MQMiiv0cQww0q9JXT7DGUgOit9X
	 +s7G9a4VN8Qur/h2iP+udRtVx0oyRfwRWra6bHeLjqjzV/5T1WOS+AwtprO2IQW4lC
	 8KFVeBirwpbew==
Date: Fri, 16 Oct 2026 12:44:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de, dgc@kernel.org
Subject: Re: [PATCH 2/8] xfs: remove redundant stat checks after
 xfs_refcount_insert()
Message-ID: <20261016194454.GD107986@frogsfrogsfrogs>
References: <20261016193422.1630907-1-sandeen@redhat.com>
 <20261016193422.1630907-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016193422.1630907-3-sandeen@redhat.com>

On Fri, Oct 16, 2026 at 02:29:02PM -0500, Eric Sandeen wrote:
> xfs_refcount_insert() simply returns the error and status from
> xfs_btree_insert, which has already validated the insert or returned
> an error.
> 
> This makes every instance of the 2nd test in this idiom:
> 
> 	if ((error = xfs_refcount_insert(cnt_cur, &i)))
> 		return error;
> 	if (XFS_IS_CORRUPT(mp, i != 1)) {
> 		xfs_btree_mark_sick(cnt_cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> unnecessary/unreachable code. Remove them.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 49e9993ce360..aec6c839220a 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -457,12 +457,8 @@ xfs_refcount_split_extent(
>  	error = xfs_refcount_insert(cur, &tmp, &found_rec);
>  	if (error)
>  		goto out_error;
> -	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
> -		xfs_btree_mark_sick(cur);
> -		error = -EFSCORRUPTED;
> -		goto out_error;
> -	}
> -	return error;
> +
> +	return 0;
>  
>  out_error:
>  	trace_xfs_refcount_split_extent_error(cur, error, _RET_IP_);
> @@ -1191,12 +1187,6 @@ xfs_refcount_adjust_extents(
>  						&found_tmp);
>  				if (error)
>  					goto out_error;
> -				if (XFS_IS_CORRUPT(cur->bc_mp,
> -						   found_tmp != 1)) {
> -					xfs_btree_mark_sick(cur);
> -					error = -EFSCORRUPTED;
> -					goto out_error;
> -				}
>  			} else {
>  				error = xrefc_free_extent(cur, &tmp);
>  				if (error)
> @@ -1841,11 +1831,6 @@ xfs_refcount_adjust_cow_extents(
>  				&found_tmp);
>  		if (error)
>  			goto out_error;
> -		if (XFS_IS_CORRUPT(cur->bc_mp, found_tmp != 1)) {
> -			xfs_btree_mark_sick(cur);
> -			error = -EFSCORRUPTED;
> -			goto out_error;
> -		}
>  		break;
>  	case XFS_REFCOUNT_ADJUST_COW_FREE:
>  		/* Removing a CoW reservation, there should be one extent. */
> -- 
> 2.55.0
> 
> 
