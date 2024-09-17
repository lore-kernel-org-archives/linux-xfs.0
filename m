Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11231178368
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726597187; cv=none; b=oFjE2TYIUUKQTgx4ggmF3PUCV0VQ2kXdx7N5Jo52qoxh2TujGEkGZX9M9ooIcdnpLs5jAL0rry3r1wI1uiu1V8SO4monkYjQrZDlbMJTM/o9rdLE+gTV6n3+uIYWpl+4sOTwzIMptDPzCz4DVVakPPynNzZEtY4kjc+4XG9UNu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726597187; c=relaxed/simple;
	bh=JQLOuUpBKwpTdurDQUlBUhA1DttI85HBD8rT8qf2RRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDMqVGjD5WCApe2Ib5qzQN8dMt2rn4rV2j6YeEeEiiMJf+PG2iHHE7yhkMcyZEDt93Hde6P35fm3oGyr5FWuokvQ462dcu48v/l85l4oBBiGLaklvsBkNZdhgFw5yIoAvtHlZ8Sduz8np4L7L2/91BpVkh9xyu6wvf9npU6UrZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBidT5nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBidT5nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF84C4CEC5;
	Tue, 17 Sep 2024 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726597186;
	bh=JQLOuUpBKwpTdurDQUlBUhA1DttI85HBD8rT8qf2RRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FBidT5nlbyiX/+Ow7ttUowlHUXK1fYHB0sJdnZHrduKP4WUYnoPwT8US1x671nx6i
	 xWXOb9xTbmAFSpuYFYgPcqdel1DsIeXJG49sRz07tSrpNQN/0GUo0jWbw/9wzmYCh5
	 T6NQFyjFB0ueKdebo1zmNBRtHPIJ9wDxdORrpTpYzJFulqOcgOVcyEMpkWSCXNmMdS
	 20OW7zcDsQK7aoeQLifBSY5123tLZ+IKtn3aU8HTP0RgSy+PmLNMalkIs97K3ZOaeY
	 KGL2HgjUujx6/L3AIgXZ2PrreOWxLxKm3P09Jnp6JeM1OZdIbyLJFKJxYb2rEoV8o7
	 L1+7RRPkwcCAw==
Date: Tue, 17 Sep 2024 11:19:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: distinguish extra split from real ENOSPC from
 xfs_attr_node_try_addname
Message-ID: <20240917181946.GF182194@frogsfrogsfrogs>
References: <20240904053820.2836285-1-hch@lst.de>
 <20240904053820.2836285-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904053820.2836285-5-hch@lst.de>

On Wed, Sep 04, 2024 at 08:37:55AM +0300, Christoph Hellwig wrote:
> Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
> -ENOSPC both for an actual failure to allocate a disk block, but also
> to signal the caller to convert the format of the attr fork.  Use magic
> 1 to ask for the conversion here as well.
> 
> Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
> only found by code review.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0bf4f718be462f..c63da14eee0432 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -597,7 +597,7 @@ xfs_attr_node_addname(
>  		return error;
>  
>  	error = xfs_attr_node_try_addname(attr);
> -	if (error == -ENOSPC) {
> +	if (error == 1) {
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> @@ -1386,9 +1386,12 @@ xfs_attr_node_addname_find_attr(
>  /*
>   * Add a name to a Btree-format attribute list.
>   *
> - * This will involve walking down the Btree, and may involve splitting
> - * leaf nodes and even splitting intermediate nodes up to and including
> - * the root node (a special case of an intermediate node).
> + * This will involve walking down the Btree, and may involve splitting leaf
> + * nodes and even splitting intermediate nodes up to and including the root
> + * node (a special case of an intermediate node).
> + *
> + * If the tree was still in single leaf format and needs to converted to
> + * real node format return 1 and let the caller handle that.
>   */
>  static int
>  xfs_attr_node_try_addname(
> @@ -1410,7 +1413,7 @@ xfs_attr_node_try_addname(
>  			 * out-of-line values so it looked like it *might*
>  			 * have been a b-tree. Let the caller deal with this.
>  			 */
> -			error = -ENOSPC;
> +			error = 1;
>  			goto out;
>  		}
>  
> -- 
> 2.45.2
> 
> 
