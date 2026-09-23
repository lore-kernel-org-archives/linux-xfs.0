Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBD3535FC8;
	Wed, 23 Sep 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182759; cv=none; b=iLAMPPmkergZ0Fgu4919GW6AQoGlbUcVMLRiGSDugV9LEfXs6dZRip5ZCqgWoiioKODiZzmp1y5vXPPK5guM8JXqfVXJ52n9It63x+g41J57tWMnxaywwpmccEM4+SIqMd559uGjCB908l5CHhkfFYFZcAuQmp/lQuF853hgN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182759; c=relaxed/simple;
	bh=hLAF1y45+2q2nuqAsilV4NiKZ3vIaTXB6D5TZGA5Tic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVmXLZN/lPbYpKLwdbHMP5hGybRR6FUDpqqMt4/2/9INsHfFvCiCMpGB9w5SjNn6Bkc3KfKdwgG2hwaPdJi/EB16KRmwHu9XZuBfN0EYXP2hz3l13t3qK076JvLl/rqY2RtTSDVwlMMbyu2jbISg2ZKtZdZnnQSQBE7zvxw4DjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQsk/cjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQsk/cjj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 35EAE1F000FF;
	Wed, 23 Sep 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182757;
	bh=DL306poqW+jOzc+ComF19nRV87RRxGNX8IShpHNoIJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HQsk/cjj2r0FeSUiMsF+M/BS8KZIw/ywKJYnq68adb0hDsZoPKlL4RCbqIsVw4N8N
	 2cgYUi8tUbeFk8R4JP28xabCAIg52MLOem+oGw9Z06FjyZbBIsenYid5WcyDrXyyHO
	 7qCwqk8u3mIO3Kg1Uta3MoOpdQy4CW3kUVK2sBH9837AB7APjq1DvWWc0Fs1nksdtM
	 I2Me0vX4nqgmwZ4glaPGU8OmlnbbLS4GCxUaXotfaA/QQsMDAti/9VSkgssAnyGeyh
	 hbHxd8zmIxGCU+FqG5zLeGWmQ1fbl4UOR599WgLZhRW8xGfZWPhOcYKcq75wLOte95
	 x9XDie8xVP/Jg==
Date: Wed, 23 Sep 2026 09:59:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/2] xfs: reject out-of-range attribute value
 lengths in xfs_attr_copy_value
Message-ID: <20260923165916.GF2705364@frogsfrogsfrogs>
References: <20260923115823.3305596-1-qwe.aldo@gmail.com>
 <20260923115823.3305596-2-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115823.3305596-2-qwe.aldo@gmail.com>

On Wed, Sep 23, 2026 at 08:58:22AM -0300, Aldo Ariel Panzardo wrote:
> xfs_attr_copy_value() takes the value length as a signed int and, for a
> remote xattr, is handed args->rmtvaluelen.  That field is filled from the
> on-disk __be32 xfs_attr_leaf_name_remote.valuelen in
> xfs_attr3_leaf_getvalue(), so a crafted length such as 0x80000000 is
> stored into the signed rmtvaluelen as a negative number.
> 
> The "buffer too small" guard in xfs_attr_copy_value() is a signed
> comparison:
> 
> 	if (args->valuelen < valuelen)
> 		return -ERANGE;
> 
> A negative valuelen therefore compares as smaller than the caller's
> buffer size, skips the -ERANGE path, and is then used as a copy length,
> leading to an out-of-bounds copy of a full remote block into a small
> getxattr(2) buffer on a mounted crafted image.
> 
> Reject a value length that is negative or larger than the maximum xattr
> size before it is used, so a bogus on-disk length can no longer slip
> through the value copier.
> 
> Fixes: 9df243a1a9e6 ("xfs: consolidate attribute value copying")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

I wonder if we /really/ need this check now that the leaf verifier is
getting fixed, but I do see the value in making sure that crazy sizes
don't get passed to kvmalloc later on, so:

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v2: new patch (see the 0/2 cover letter).  Fixes the signed value-length
>     check in the consumer, xfs_attr_copy_value(), which is the root
>     cause Darrick pointed at in his review of the v1 verifier patch.
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 86c5c09a5db4..d0f7753659c9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -628,6 +628,17 @@ xfs_attr_copy_value(
>  	unsigned char		*value,
>  	int			valuelen)
>  {
> +	/*
> +	 * A value length that is negative or larger than the maximum xattr
> +	 * size is on-disk corruption.  The remote value length is an on-disk
> +	 * __be32 stored into the signed args->rmtvaluelen, so a crafted value
> +	 * such as 0x80000000 becomes negative and would slip past the
> +	 * "args->valuelen < valuelen" check below and be used as a copy
> +	 * length.  Reject it before that can happen.
> +	 */
> +	if (valuelen < 0 || valuelen > XFS_XATTR_SIZE_MAX)
> +		return -EFSCORRUPTED;
> +
>  	/*
>  	 * Parent pointer lookups require the caller to specify the name and
>  	 * value, so don't copy anything.
> -- 
> 2.53.0
> 
> 
