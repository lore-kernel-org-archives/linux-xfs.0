Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1FD3C6606
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 09:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625232; cv=none; b=onc8G1lA9CvZcoTvWgDZDp4rsJjO14JcB3DpVzXehR6/OsXJ+YZuCEAnF43zUxa7/0SeAldNK5jcpMtXm828RnjSJcq18rzIdTfvpmuGF0LreN9DHXL0L/PfIItyJfWLlAaqPe2EofAlZ0/gy7zdV3yPd+uMVkzb8oFHiwEtmfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625232; c=relaxed/simple;
	bh=cYuF8goels6gMUxcsVfS8u+F7YhKnXwv1TPT/HdOAV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htyr7Wd+izLW49mfWQCfqPdldfO/2e4r5979P7mqQCy7hj/JTq2uWizHTx5AS33vMhyIQMTpPdfGcIaSAhHtxoKPh+mLfCGl+P810jVVP9NLz/7cDiU+rxXwVFnvt+7/WFJ0MSuNgBmDRkGin9hnDs9WuXcwR4ShrusdNU06i/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7gkgxXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7gkgxXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A801F00A3A;
	Tue, 21 Jul 2026 09:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625231;
	bh=W6qVJGFBo+KXNHg/+X8lHnHX/WeTOqXb6q4MOGw53dI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7gkgxXZs+QrScG8lsRmdq56/DIgCg0yZSNYruMOXsqPfF4VFWDDQcI6rt4KZ+b9c
	 4BwJgx7J8sHI1yjraxqHIWVr/9NR/txK4mrlDx5XzE1EWxl7EaOa6yNV38s6Fe8yeJ
	 aEdAXzMOsYPrD1LysVQOSm6cXXewcZ4LF5WGVO3Q71YgHE6O+yhvx4OzaccvCreLBk
	 RsNvBiyxngvqJCzDHPkS1oD3cn+OcqRDoLKRKfcNCFWUJtzsynZq/LFCIQZd2/lGGd
	 JShYvAzIwvYynVgNR5hvNA4Jxcj1NNshsU7Y1rmkaAZ5voyCiUjcBhiBchylmK63hK
	 gXXPzeAWEMsxg==
Date: Tue, 21 Jul 2026 11:13:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't flush and invalidate internal RT device twice
 in xfs_shutdown_devices
Message-ID: <al84N-KUG_j8lSPg@nidhogg.toxiclabs.cc>
References: <20260720140921.2269927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720140921.2269927-1-hch@lst.de>

On Mon, Jul 20, 2026 at 04:09:21PM +0200, Christoph Hellwig wrote:
> Check for an internal RT device to remove a bit of extra work.
> 
> Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 63c4bcbe6c2b..d96f3781d791 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -445,7 +445,7 @@ xfs_shutdown_devices(
>  		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev);
>  		invalidate_bdev(mp->m_logdev_targp->bt_bdev);
>  	}
> -	if (mp->m_rtdev_targp) {
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
>  		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
>  	}
> -- 
> 2.53.0
> 
> 
