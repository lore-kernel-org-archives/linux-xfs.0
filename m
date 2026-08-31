Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35483B8D75
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 08:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788166426; cv=none; b=rOEknEls2jFEmifJINkNlqSI3XKrI53jxMkqRxrVgpQFqVHx2VpMJAIgy8EmdtgjmtKkiSBtHiGn59e04Bh2B5BsjlSOiqb8Mhe/lILtAjRVhStXiCS+/ac6xw/63/O8BbtMSREAeCBLFSHrKYIlfCQfvwZRNak0A/4Z/jNJo08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788166426; c=relaxed/simple;
	bh=a94g1sLhwI22q0pOePQO2UFtd2eQ+xqy1DZhYUuMbZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aL5WNkWS2dLImjS1OQnUyaEj8f3eEnkrCDP0DRakOfz9y8yH3uHvrX3EqkJUiN2k9yHYv5w0O7AHwrWgCw7FUdJZAODa68VqmmqJuWNuc3rHL5JlkZSsn8o3QH0BWLxIaI64/cS1dqCV5y55rfr+7AZAq/ukIp/BhYcf//l9/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcVgjJc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcVgjJc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084AA1F000E9;
	Mon, 31 Aug 2026 08:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166425;
	bh=YLIek0U2oqf7TpHrEKm4EN8XF0t0jfhTPXKnKxFQnHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JcVgjJc/cHtOg9HvVydMdTDn3f/USBJqJBK5scYeIvN+GblmYCo07vsyotHiWIYIE
	 bt9/NwzEBrX3lha5W2XVvhbIhGQN6/iu9RxKE5M4lLRmE3kLwq7RZmZBHhSSgGHItw
	 aX+SNmVY2hPJIH+wUdK8EY3M94ApUvv6v2JjENIWeOKXcWrmHK+6i2dNNbaHZFJKCG
	 aNVlY6l9NnfDHTt/XytuuieqMBmce5i8E2y5rF93BmzXrjlHL0BF9Hzd+qOwksOcH1
	 1agfXnFbLGwZWXiIQaEwD3Ly8JypM3dtnBH/0u9cOOyIak/UOpr7lDKXO6DefKf77v
	 DQ3tmFRdWm7QA==
Date: Mon, 31 Aug 2026 10:53:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: release alleged child inode on metapath unlink error
Message-ID: <apVBCUZFmdxuOKS4@andromeda.toxiclabs.cc>
References: <CGME20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff@epcas5p3.samsung.com>
 <20260831064157.758165-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064157.758165-1-anuj20.g@samsung.com>

On Mon, Aug 31, 2026 at 12:11:57PM +0530, Anuj Gupta wrote:
> If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
> succeeds, release the inode reference before returning.
> 
> Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/scrub/metapath.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
> index ff1ff762b300..79fd69d2de68 100644
> --- a/fs/xfs/scrub/metapath.c
> +++ b/fs/xfs/scrub/metapath.c
> @@ -550,6 +550,8 @@ xrep_metapath_try_unlink(
>  	}
>  	if (error) {
>  		xchk_trans_cancel(sc);
> +		if (ip)
> +			xchk_irele(sc, ip);
>  		return error;
>  	}
>  

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.25.1
> 
