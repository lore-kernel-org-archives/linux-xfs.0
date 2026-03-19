Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8A93C8701
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939270; cv=none; b=XXCdG1bJcsWYCdjtigOt4krGNJszyX2WsIpiKDrjGAvtZAVqn/7NENm3UbFAnpMtzgHXwt1sSt9oBzvMEiPrciN3CpzIqJKIetcW9y5982ZPgVlqFQMYLaz7IXz3Cp3UfR88jNpUZ40JACnCHWbVGDGWDfYW35Fm3hdQcwBEENA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939270; c=relaxed/simple;
	bh=SXXXk8nYkAsAx8TYPLEPKfgmSKCaaU1/najHqq+nbUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJ/KwKz4Oue/orwVAZtgSL8fzJ4IinXLWiT5NIvKbGvb8yke2H/mxhvnen/KaS3dHo/drgQGTziSnZG5mdvh9nDiL57+o0Kcs07pyXzUlL0s/4AaxtHmwxAw6Pjso57/mUCGXisxz554nt4QyofgAnGydrZN2mgYAVI2PkvHwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBAvkCeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBAvkCeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F10FC19424;
	Thu, 19 Mar 2026 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939270;
	bh=SXXXk8nYkAsAx8TYPLEPKfgmSKCaaU1/najHqq+nbUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBAvkCeJFo1fIDNOVyI70ipmPo7qzZrype2dk7Bx1crbHw5unESpcyraYoi+JvsoA
	 BPVaHdcCzFSe9j8Pq5TOCzBRNK4RmVPHxMrR6MCXlq5S3GwRcb0KCb9iFUFKC8Q3Rt
	 04QtFmD+xUkUjk9EUTQwmnCK1hGgtcw+aHU9hpXZaPK0k1W3Y8mDi2JvhGujFhHZ27
	 9lzwh5LcZOtgN5fLqm+jYZxltLe+bzUo9ClRRrMF/u30DjJwRBiIxNf7dunFmOyYo1
	 a5v3bXFO5gXhxPgP65QPYk2E6QqUaDa1X7WmmBifAngEwBEoJkZ36LMVlzqTx85eQi
	 lsCQ70XFJAqWw==
Date: Thu, 19 Mar 2026 09:54:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 3/3] xfs: remove redundant validation in
 xlog_recover_attri_commit_pass2
Message-ID: <20260319165429.GR1770774@frogsfrogsfrogs>
References: <20260319010618.722448-1-leo.lilong@huawei.com>
 <20260319010618.722448-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319010618.722448-4-leo.lilong@huawei.com>

On Thu, Mar 19, 2026 at 09:06:18AM +0800, Long Li wrote:
> Remove the redundant post-parse validation switch. By the time that
> block is reached, xfs_attri_validate() has already guaranteed all name
> lengths are non-zero via xfs_attri_validate_namelen(), and
> xfs_attri_validate_name_iovec() has already returned -EFSCORRUPTED for
> NULL names. For the REMOVE case, attr_value and value_len are
> structurally guaranteed to be NULL/zero because the parsing loop only
> populates them when value_len != 0. All checks in that switch are
> therefore dead code.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Yeah, that was redundant.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c | 46 ------------------------------------------
>  1 file changed, 46 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 19eaf6b8cd43..b462e15d2329 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -1133,52 +1133,6 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	switch (op) {
> -	case XFS_ATTRI_OP_FLAGS_REMOVE:
> -		/* Regular remove operations operate only on names. */
> -		if (attr_value != NULL || value_len != 0) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> -		fallthrough;
> -	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
> -	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
> -	case XFS_ATTRI_OP_FLAGS_SET:
> -	case XFS_ATTRI_OP_FLAGS_REPLACE:
> -		/*
> -		 * Regular xattr set/remove/replace operations require a name
> -		 * and do not take a newname.  Values are optional for set and
> -		 * replace.
> -		 *
> -		 * Name-value set/remove operations must have a name, do not
> -		 * take a newname, and can take a value.
> -		 */
> -		if (attr_name == NULL || name_len == 0) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> -		break;
> -	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
> -		/*
> -		 * Name-value replace operations require the caller to
> -		 * specify the old and new names and values explicitly.
> -		 * Values are optional.
> -		 */
> -		if (attr_name == NULL || name_len == 0) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> -		if (attr_new_name == NULL || new_name_len == 0) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> -		break;
> -	}
> -
>  	/*
>  	 * Memory alloc failure will cause replay to abort.  We attach the
>  	 * name/value buffer to the recovered incore log item and drop our
> -- 
> 2.39.2
> 
> 
