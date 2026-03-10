Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034B40DFBF
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773156580; cv=none; b=lnWyvUALI1oAyTqqg5QBCMuZ5EIOdClSIBpY6Kqjvfi+VSui47fpuMOFDJXwMV+Rq6MOs8DnGsuVikubrrD7oIL+MnjI0LC4uxaPNkpz+OiCFvhIKn2t3Z2eJ5NEQT1qoYyImUe+AgmpkBTz+7PXAq0iWa5bq9GglCtY28dt7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773156580; c=relaxed/simple;
	bh=1Gink/BFfXaUeyos047Uu+JMHuBiC+2kXFa6o/gRhx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3IqhubJo/G3AWehCFqvtIP75FwRtSeb+ORxkREUxT78FC6B2co4u9s8YVhWd5eZjKjI8o2B04M28tJ5Iy4vEes9Ekggmg8Mo4b+mZXAc+Ca10lTMZOd9zbmot/2bTj8dD1SH2LGuVK3uJ4Ja+xlkZH483878MQen3rC3Cr02Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjpRxuvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjpRxuvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1050C19423;
	Tue, 10 Mar 2026 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773156579;
	bh=1Gink/BFfXaUeyos047Uu+JMHuBiC+2kXFa6o/gRhx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjpRxuvPuGt69PhEyoAFWXO6EgASA7ALGmeHmXEDB91o3eiQTyHOTmF/+Oo8HClYr
	 lzMXAMF/sGh3ysfei430GAQC/wZVozOgxfKLI/kTMUfueKHXEJuVUVUROxb0oeDpDq
	 +YGgzwcacfbAG8ZmAgJ3jUO6E01AooXDSKZd9zCPDiVaBdysse1Rm/Ae7aY4mh/7Dg
	 B/J8zMvf1bVP8zG06EAZoN8ZjX3iMNyza0bGv/2S6GF0CG1PMIEEqFgExoEgJnkVsa
	 fCGL1p49quiRjj0CV7ulze67g+tDN7cnkCUCozdAhDdjoVuw+qMnGRtmvuq7ZBHRPs
	 LZkQ5zoKKOjFg==
Date: Tue, 10 Mar 2026 08:29:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH] xfs: fix integer overflow in bmap intent sort comparator
Message-ID: <20260310152939.GQ1105363@frogsfrogsfrogs>
References: <20260310123233.449659-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310123233.449659-1-leo.lilong@huawei.com>

On Tue, Mar 10, 2026 at 08:32:33PM +0800, Long Li wrote:
> xfs_bmap_update_diff_items() sorts bmap intents by inode number using
> a subtraction of two xfs_ino_t (uint64_t) values, with the result
> truncated to int. This is incorrect when two inode numbers differ by
> more than INT_MAX (2^31 - 1), which is entirely possible on large XFS
> filesystems.
> 
> Fix this by replacing the subtraction with cmp_int().
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 9f3afb57d5f1 ("xfs: implement deferred bmbt map/unmap operations")
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Cc: <stable@vger.kernel.org> # v4.9

> ---
>  fs/xfs/xfs_bmap_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e8775f254c89..b237a25d6045 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -245,7 +245,7 @@ xfs_bmap_update_diff_items(
>  	struct xfs_bmap_intent		*ba = bi_entry(a);
>  	struct xfs_bmap_intent		*bb = bi_entry(b);
>  
> -	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
> +	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);

oooooooooops :(

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  }
>  
>  /* Log bmap updates in the intent item. */
> -- 
> 2.39.2
> 
> 
