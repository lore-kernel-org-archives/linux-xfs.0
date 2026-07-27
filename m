Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0146539A4A4
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 03:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123657; cv=none; b=uQy7IxZgpRLCgAhbDNwu09OrQqxxayHmAoBTqggYOQ1b0toz+82GNaiOtvTxUN2maiV3b+G7t1ljOJwcQ9tj7i2X0MiQzlg+NQKMG001XS5kdfFUFKCvuLnVxvmBs8L7+46yeMGGuJfDu+Y38jo06v3lI2DBGb4PEzvPd6uT1Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123657; c=relaxed/simple;
	bh=hR3VmpAPgU2B9qS+6HOctFKrRQLcEifC/IMfoy656D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdKjsmaJF2vNPh+MXCup/mXMTxuyYfwTS1UgOv12y6s3UtnvSAiRzsiQaJ02aJrvR1elwoF4+BVLoMMC2h7eNXcA9/hYdYLuYjb6A59/QQGshZ406SzSIc5XNkik9+UJJv0pHxNw8Me76pgRkqtjvbFYbsxIPXDQS1UwMss4DdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7Vq2gDH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7Vq2gDH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 855D21F000E9;
	Mon, 27 Jul 2026 03:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785123655;
	bh=lZ/C40l53myXY62r/lK8lBIKRORrVLBqdY3Na3APA4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M7Vq2gDHbbxX0kl02Tu1Ce3P8++E94iRSMQZqA+fXHS+32093MrPhICN1m+06Sizf
	 QfeLqGUykeoAUZAHeBCjDyz2LNQ1myPV32XST5eY1Ie0CxehIM6YIOUFo7MMcveJzg
	 GPb5NPiA+HN0MFt+JmvQ5wr4Crv6e+Xc0RPx7YN/v5V07bvz+b9IDzqDHS6sUCuKiH
	 icLrx3+myFIFRrwB7pLqcAMbXg4zxh3IgZQfX9X5HObOPEo459yMMww/uPxarmqAQX
	 ChKyW1iMqsEe3i9/GKS5bnUXDZ3kUfofiZjz3idhdu2JcJNnJd+AgDgz3bnMMVLgX4
	 GVSX3fJq0WyXQ==
Date: Sun, 26 Jul 2026 20:40:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: don't swallow dquot recovery verification errors
Message-ID: <20260727034055.GC2901224@frogsfrogsfrogs>
References: <20260727023849.3247961-1-leo.lilong@huawei.com>
 <20260727023849.3247961-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727023849.3247961-2-leo.lilong@huawei.com>

On Mon, Jul 27, 2026 at 10:38:49AM +0800, Long Li wrote:
> xlog_recover_dquot_commit_pass2() validates the recovered dquot with
> xfs_dqblk_verify() and, on failure, sets error = -EFSCORRUPTED and jumps
> to out_release.  But out_release unconditionally returns 0, so the
> corruption error is discarded: the caller xlog_recover_items_pass2()
> sees success, log recovery proceeds as if the dquot were valid, and the
> corrupt quota buffer can be written back to disk.
> 
> Fixes: 9c235dfc3d3f ("xfs: dquot recovery does not validate the recovered dquot")
> Cc: <stable@vger.kernel.org> # v6.8
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Yep, that also looks like a bug
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot_item_recover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> index fe419b28de22..63bc9ab7d947 100644
> --- a/fs/xfs/xfs_dquot_item_recover.c
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -173,7 +173,7 @@ xlog_recover_dquot_commit_pass2(
>  
>  out_release:
>  	xfs_buf_relse(bp);
> -	return 0;
> +	return error;
>  }
>  
>  const struct xlog_recover_item_ops xlog_dquot_item_ops = {
> -- 
> 2.52.0
> 
> 
