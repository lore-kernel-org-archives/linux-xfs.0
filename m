Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4F46AEE2;
	Tue, 30 Jun 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782835492; cv=none; b=lplv2/EiQFizcOPjeYArN1KQ09bKehdNPdWcBhnV2Pa6vCUMNm2K3jZNLSGsb2UEaWGn/ltZR+oQTxk0dwmmaWY/Zu3fwN2EcOLCYbJh4Q7CNSVDX4PMZfkNpaVWpN4fIs47baPHUUIf3FKWml2KWfWw0dHnWzwH1A2m97mUWrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782835492; c=relaxed/simple;
	bh=m8ubQEzYN9wUMvEDdXsR8GvLoyJQsl/90h1gsmWq6IU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqCawST4pk+DC8x7lk1YdMqVsGz4Z0BhPWeOqIL+Cpkr8rcU1ARo/7bcbpHUE2ke9VLMjzorJlymhWTRPjMH79UfQ+UMnK2BBBSW92B86WuBEabgP+tkHza8XlUhULxQVRrRCta3/NSRxXKR07yTqYBkFAeSmVQKbxCfGD35+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkaMRFtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkaMRFtR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 252B61F00AC4;
	Tue, 30 Jun 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782835489;
	bh=QesfPcZNprlavXfSBU02g5izCfA79PSfySOG273cUO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkaMRFtRGKFKB9zCEDFe3sy+Xv9IT6JFxHfOCYFNm2h1xHdVPBOCdUH/yS8c9bq0c
	 pBexjMkrNWtvjmZn6PzQ3H/SRjCPysIxsVt0S6bB1KhA5yOM+o3v8wYeenMW9Ewmck
	 FdPvgDew12gBpVgH3BYAKSF7I4AXBnrxmHjvduwK+3gRe3qynCWrzGTK8pcoyXq3cE
	 +/MoeS/yTc8nODuP9F2h9CX6FYp6fInn0rwHSGNZpil/vCBSqDgPyzoQB+Us29+Xpx
	 pvVyNdP/HPUxsHMbu9y9Nk5UVViHeGRG7CNGTC5h5CwHOIsS57MXEtT5iRdDDF0FL1
	 hSIPDjB46wSPQ==
Date: Tue, 30 Jun 2026 09:04:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>, f@magnolia.djwong.org
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] xfs: use null daddr for unset first bad log block
Message-ID: <20260630160448.GA6526@frogsfrogsfrogs>
References: <20260630100607.7150-1-alhouseenyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630100607.7150-1-alhouseenyousef@gmail.com>

On Tue, Jun 30, 2026 at 12:06:07PM +0200, Yousef Alhouseen wrote:
> xlog_do_recovery_pass() may return before setting first_bad.  The caller
> must distinguish that case from an error at a valid log block, including
> block zero after the log wraps.
> 
> Initialize first_bad to XFS_BUF_DADDR_NULL and test it explicitly before
> treating the error as a torn write.
> 
> Fixes: 7088c4136fa1 ("xfs: detect and trim torn writes during log recovery")
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v4.5

> Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>

Much better now, thanks.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> Changes in v2:
> - Use XFS_BUF_DADDR_NULL instead of zero as the unset sentinel.
> - Test the sentinel explicitly before handling a torn write.
> 
>  fs/xfs/xfs_log_recover.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca487..5f984bf5698a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1028,7 +1028,7 @@ xlog_verify_head(
>  {
>  	struct xlog_rec_header	*tmp_rhead;
>  	char			*tmp_buffer;
> -	xfs_daddr_t		first_bad;
> +	xfs_daddr_t		first_bad = XFS_BUF_DADDR_NULL;
>  	xfs_daddr_t		tmp_rhead_blk;
>  	int			found;
>  	int			error;
> @@ -1057,7 +1057,8 @@ xlog_verify_head(
>  	 */
>  	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
>  				      XLOG_RECOVER_CRCPASS, &first_bad);
> -	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
> +	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) &&
> +	    first_bad != XFS_BUF_DADDR_NULL) {
>  		/*
>  		 * We've hit a potential torn write. Reset the error and warn
>  		 * about it.
> @@ -3575,4 +3576,3 @@ xlog_recover_cancel(
>  	if (xlog_recovery_needed(log))
>  		xlog_recover_cancel_intents(log);
>  }
> -
> -- 
> 2.54.0
> 
