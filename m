Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D95F319860
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764938264; cv=none; b=FgRa3mzG70mTuCNdT4RNQu3pCBBv9fRlLkzQ6dLoPaOJUX6vykXRW8ZTL5RywGP57vLMT5uh1oh4PDgvxxOVZhZ26r7WAr/MyPAyP12/1d/bmPOMD7feo9eAo5mWCIZkHFZn7zpiOKWAJrEmrfKLUM+ERkpHw+QrhtuoZIwY2F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764938264; c=relaxed/simple;
	bh=vSRUqDGj3C5m35z4OVNmPkrTdccl/ybmdLyNVQEMp6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qISVaERh0o5JLfmMuKdbn5r/jOhlSlh55pcRiYXhKmF3S+nI8DAi6EyjEYLhtIqYPYliWywTvnz6J5ss2u5sh33CXrqV2l6QZl6KSSGoVdmX0a50ERvdfzK+9ehVlNDBsFq+p9m2JDv/SEQWBOLWo+0amC7gESN/3gFrJltcdMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQeMXhVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQeMXhVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEE2C113D0;
	Fri,  5 Dec 2025 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764938263;
	bh=vSRUqDGj3C5m35z4OVNmPkrTdccl/ybmdLyNVQEMp6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mQeMXhVhEOT6LHxCgkxpcSS+y5jBkvShkz1IHWRRq8U75i40Bxbhq1h8ZhNTpC3OM
	 pZv26QYVuCLvZ/SsWT+ksXOnoImOSqGAdr47evqS2WK8yzV8ecB0jtUUIhTiZ4sgVI
	 IBe82+eUnz2JXmUVmNz6QdqdocTF1D+73e4YZ3u+MrJ8zcIRjqHuZyHbAfj5ZsZG+U
	 NYHzHAhZdBBB88pz6rfjdvgRlcglLczJKi5V1g76eBt4tZL5i8I85LsKh/6DYRZokP
	 enn98FMKDWFw160EOn+57xOv4YI0iH868N6Aa4Ok8GgJhtY2/AwhegbWV0PBB51dKD
	 odcFJr0sYD6dA==
Date: Fri, 5 Dec 2025 13:37:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix stupid compiler warning
Message-ID: <cnnktwv253eglupmgrl5ywmc5tqf5pookssb7vfr2kiz432u2q@qr6ger4o3vj5>
References: <Khc6xOetpuN9dzi_PRxPss-T6HOWuFeASPJz6c_HH-WpdNt2jmHRGSStcQp5-bVTxhzrcz4OYSMOr5phJDh9Ng==@protonmail.internalid>
 <20251204214415.GN89472@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251204214415.GN89472@frogsfrogsfrogs>

On Thu, Dec 04, 2025 at 01:44:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> gcc 14.2 warns about:
> 
> xfs_attr_item.c: In function ‘xfs_attr_recover_work’:
> xfs_attr_item.c:785:9: warning: ‘ip’ may be used uninitialized [-Wmaybe-uninitialized]
>   785 |         xfs_trans_ijoin(tp, ip, 0);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> xfs_attr_item.c:740:42: note: ‘ip’ was declared here
>   740 |         struct xfs_inode                *ip;
>       |                                          ^~
> 
> I think this is bogus since xfs_attri_recover_work either returns a real
> pointer having initialized ip or an ERR_PTR having not touched it, but
> the tools are smarter than me so let's just null-init the variable
> anyway.
> 
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: e70fb328d52772 ("xfs: recreate work items when recovering intent items")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_item.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index c3a593319bee71..e8fa326ac995bc 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -737,7 +737,7 @@ xfs_attr_recover_work(
>  	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>  	struct xfs_attr_intent		*attr;
>  	struct xfs_mount		*mp = lip->li_log->l_mp;
> -	struct xfs_inode		*ip;
> +	struct xfs_inode		*ip = NULL;
>  	struct xfs_da_args		*args;
>  	struct xfs_trans		*tp;
>  	struct xfs_trans_res		resv;

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
