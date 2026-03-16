Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19652377575
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701193; cv=none; b=c0tUdBrzRaVL1Cz6CTKP23dQqyY+JLC5s4hIIT7eX4+ANUVu1JhtdNPV18yl0R994e07uiXJkFL79zo1aZg0evJ2v2kpiLWUdnyMp90QlkTIfssJZsramp1YJrZTmD6ae4cT3KKDRbmad6KHqL+l0m7vgyqF1mdSLoQfKcXBd50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701193; c=relaxed/simple;
	bh=549AgGP8SC/FX6+F65LidC8t8gPIEe3YjLqnu/fEPok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRAzO4acroNUdaLuuBy+K2tg2UqTtsncosJpQjO/BcE+3mgrYbuTfIDtsaH5BIQP7+2gH6WuFWnmTPWs12QFP4hOCmY//T/Ho10Krmf2DqPt8uf6NqNg4RuzkCI0ydqNSWkNcaeXaC58nC1XFBG+6JMhpaI57p+G6nw2rdEREbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZo9nw9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZo9nw9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F1BC19421;
	Mon, 16 Mar 2026 22:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773701192;
	bh=549AgGP8SC/FX6+F65LidC8t8gPIEe3YjLqnu/fEPok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oZo9nw9QW0/jONA1mgK9KjHeT95sRELRtjxQW3WQu+UgjfT4DMCjf2TOQqZAqUKKI
	 aPv/o/cgXe9BeNBHsqqGOR/8Aea6TxkTMxKDcw+rlIYngmjUwft3uios64xdB0DGT3
	 Q2+lKz2IGh+Dz7R74XO8z5tewPi8i5bMdgQnIT01Ckd4DIWX0enBLEwGyUEyABhNIz
	 IUiJODfHezEODl94WDLypAIcWBSDwQoUD+XvZwDy4VHYudL+KR0OfGVM3j5Nn1rBKD
	 d+LT+Nad3MuNYmB6xCrus7fyTpVGuJWh++5rhRqwh57p9hlxLvjjNYxRI6Z+XPR3tI
	 oSrJUd0oZH1gg==
Date: Mon, 16 Mar 2026 15:46:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 3/3] xfs: simplify iovec validation in
 xlog_recover_attri_commit_pass2
Message-ID: <20260316224632.GE1770774@frogsfrogsfrogs>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-4-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316012416.2413909-4-leo.lilong@huawei.com>

On Mon, Mar 16, 2026 at 09:24:16AM +0800, Long Li wrote:
> Consolidate the per-case ri_total checks into a single comparison by
> assigning the expected iovec count to a local variable inside each
> switch arm, removing four nearly identical error blocks.
> 
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
> ---
>  fs/xfs/xfs_attr_item.c | 79 +++++++-----------------------------------
>  1 file changed, 12 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 21da995ba4e7..32236f5008ec 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -1016,12 +1016,13 @@ xlog_recover_attri_commit_pass2(
>  	unsigned int			new_name_len = 0;
>  	unsigned int			new_value_len = 0;
>  	unsigned int			op, i = 0;
> +	unsigned int			expected = 0;
>  
>  	/* Validate xfs_attri_log_format before the large memory allocation */
>  	len = sizeof(struct xfs_attri_log_format);
>  	if (item->ri_buf[i].iov_len != len) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
> +				item->ri_buf[i].iov_base, item->ri_buf[i].iov_len);
>  		return -EFSCORRUPTED;
>  	}
>  
> @@ -1038,32 +1039,20 @@ xlog_recover_attri_commit_pass2(
>  	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
>  	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
>  		/* Log item, attr name, attr value */
> -		if (item->ri_total != 3) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> +		expected = 3;
>  		name_len = attri_formatp->alfi_name_len;
>  		value_len = attri_formatp->alfi_value_len;
>  		break;
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  		/* Log item, attr name, attr value */
> -		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> +		expected = 2 + !!attri_formatp->alfi_value_len;
>  		name_len = attri_formatp->alfi_name_len;
>  		value_len = attri_formatp->alfi_value_len;
>  		break;
>  	case XFS_ATTRI_OP_FLAGS_REMOVE:
>  		/* Log item, attr name */
> -		if (item->ri_total != 2) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> +		expected = 2;
>  		name_len = attri_formatp->alfi_name_len;
>  		break;
>  	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
> @@ -1071,11 +1060,7 @@ xlog_recover_attri_commit_pass2(
>  		 * Log item, attr name, new attr name, attr value, new attr
>  		 * value
>  		 */
> -		if (item->ri_total != 5) {
> -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> -					     attri_formatp, len);
> -			return -EFSCORRUPTED;
> -		}
> +		expected = 5;
>  		name_len = attri_formatp->alfi_old_name_len;
>  		new_name_len = attri_formatp->alfi_new_name_len;
>  		new_value_len = value_len = attri_formatp->alfi_value_len;
> @@ -1085,6 +1070,12 @@ xlog_recover_attri_commit_pass2(
>  				     attri_formatp, len);
>  		return -EFSCORRUPTED;
>  	}
> +
> +	if (item->ri_total != expected) {
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,

The downside to this change is that XFS_CORRUPTION_ERROR prints the
source file and line number, so now anyone looking through the logs
cannot identify a specific line number.  However...

> +				attri_formatp, len);
> +		return -EFSCORRUPTED;
> +	}
>  	i++;
>  
>  	/* Validate the attr name */
> @@ -1133,52 +1124,6 @@ xlog_recover_attri_commit_pass2(
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

...this part is indeed redundant.

--D

> -
>  	/*
>  	 * Memory alloc failure will cause replay to abort.  We attach the
>  	 * name/value buffer to the recovered incore log item and drop our
> -- 
> 2.39.2
> 
> 
