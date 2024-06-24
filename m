Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB95A11D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719245023; cv=none; b=W1f4/fHkrP6nBXBmH3WJG4QImtBxLn2r9TT5J6tzgEE6RJuhlhgnspJ7v+AR+HCqwc2bFj2S2RrkZ6/vL0TowdjNvVWaYxzwUWCaoP3dURzSf7qyT+j+4JZbI7kh7SsQ2e+kKqs1nkt62VHqtodc/ejUy1nbTfDII33lipiHNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719245023; c=relaxed/simple;
	bh=vivHX83a5TVSAVIGjzCxkTKttay+wlgn7XM/CPwgtb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6ZPsw42vzXnpXP5v0i3CI6vH86yERnTcnbFG1TIo4+7fdzxMVoTWj1Yr4S6UEYZvQ0VztYW4R2H+RJx4lw0wwDy9KMjC89wLZS3B4Y1Bup+InbgA2OrKYFC7ZQasx+fBLtHoBvhvMsRl9u6AnJgfKKn0bmHg7Fws2T7PysJuaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHPHxahn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHPHxahn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFAEC2BBFC;
	Mon, 24 Jun 2024 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719245022;
	bh=vivHX83a5TVSAVIGjzCxkTKttay+wlgn7XM/CPwgtb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kHPHxahn5j1hGDSstf9+l3CHXr7lLn5cU98uAT0ASrMvaTGjuHctHS72u7n1kMJg3
	 QsGB81c2qwAJOteJ0cbkZX6U9fUdVJq8X007LEaStE3mr0Y8pvoc7Sx/XrhkEOdUJj
	 zvLrQw9pxJ1m1pC2lCaILLssj2cHribE1uhU9nANHHQR4pd1A3IgFoHG2GqWTp4SRN
	 cV5crQZdEV+B9fhIWyRxIJBhNbFhaQ4gM5UazPi+rgY4M6dMoVlPvwd4NJi14hnC5F
	 cLEgxeQOSfRjNr02/MtbFJfKegcHXzyaSjsw9CCwyglkOgYliXRstzau7N7rmeWGyh
	 KBz1CG/2G8ysA==
Date: Mon, 24 Jun 2024 09:03:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-ID: <20240624160342.GP3058325@frogsfrogsfrogs>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240622082631.2661148-1-leo.lilong@huawei.com>

On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
> xfs_attr_shortform_list() only called from a non-transactional context, it
> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> false positives by use __GFP_NOLOCKDEP to alloc memory
> in xfs_attr_shortform_list().
> 
> [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
> Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_list.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5c947e5ce8b8..8cd6088e6190 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->count * sizeof(*sbuf);
> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> +	sbp = sbuf = kmalloc(sbsize,
> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);

Why wouldn't we memalloc_nofs_save any time we take an ILOCK when we're
not in transaction context?  Surely you'd want to NOFS /any/ allocation
when the ILOCK is held, right?

--D

>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing
> -- 
> 2.39.2
> 
> 
