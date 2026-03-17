Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26378224B1E
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 21:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773783231; cv=none; b=J1CACLh4WLf0e7t+uKbV/iWEAJMHOrCs9s4FIRJOeSra/Fp8X1sD5aDZO8xlw6qBaXUOltRdY0vFCUSajYTMujCIblrrcyfRBHkJ9O/3igNEvB22KCu8lGJgSogFCluWfEjV6Cibm9DQOkv1oZ4lWBLA6Qt14z/Gx22qsVq1ezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773783231; c=relaxed/simple;
	bh=rSaeoSplGgpttE0wZJZypa8O0oMuVDvfE7RL3NRq+Yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QF0Be5S4pV5VNkmZrZPBpyF73RkgHFNAwLoQP/2m+FG8JawrXkB61Eiq0gMRn0rx+Jn9xxzRgxugbDt7N7aZj9V+v+DY0xP/NFP2U2ixAFJfxVmtBBcJbDkdRYlWf2A+M+3csNSr2HzhcOcWG/2rxIpn/GLBmWmTPY9SU+mlDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iauhcE7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iauhcE7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCBFC4CEF7;
	Tue, 17 Mar 2026 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773783230;
	bh=rSaeoSplGgpttE0wZJZypa8O0oMuVDvfE7RL3NRq+Yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iauhcE7y78dvK0h17v3krZ3sTDZ47QpekUxf/Yb7XxD5vJTmffZkMEcSP6WPZ41PD
	 phT2j+MrX81koXKwvpeNP/oUXowGTafzqtJcKbFrUTYCLR401/bKMWdY72jepueLxm
	 nsx7R8F0gFNwRf4PnYqrhakZdgerITv0s+he4qPIl9kLq1FnOW3+ULpxbc0/FfQW1l
	 Lxp3FcaXFz5sWoyVBLLkm/U4kCb8HamRRBQfi4hZK+CF24fFHY1xhw9WoQj0uFl8o8
	 nmLvv0Agt1Ehdu93OboT3KmDYPXErQc2DtXYvPVr41XeUjN6T/OQmxUsB4QqkWsdlc
	 aaK+t36uY+XnA==
Date: Wed, 18 Mar 2026 08:33:30 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/4] xfs: don't keep a reference for buffers on the LRU
Message-ID: <abnIqhTZXZxIb6VS@dread>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-2-hch@lst.de>

On Tue, Mar 17, 2026 at 02:40:52PM +0100, Christoph Hellwig wrote:
> @@ -942,10 +887,22 @@ xfs_buf_rele(
>  	struct xfs_buf		*bp)
>  {
>  	trace_xfs_buf_rele(bp, _RET_IP_);
> -	if (xfs_buf_is_uncached(bp))
> -		xfs_buf_rele_uncached(bp);
> -	else
> -		xfs_buf_rele_cached(bp);
> +
> +	spin_lock(&bp->b_lock);
> +	if (!--bp->b_hold) {
> +		if (xfs_buf_is_uncached(bp) || !atomic_read(&bp->b_lru_ref))
> +			goto kill;
> +		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
> +	}
> +	spin_unlock(&bp->b_lock);
> +	return;
> +
> +kill:
> +	bp->b_hold = -1;
> +	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
> +	spin_unlock(&bp->b_lock);
> +
> +	xfs_buf_destroy(bp);
>  }

The jump with the lock held is kinda nasty. The lock scope can be
straight-lined by inverting the logic like so:

	spin_lock(&bp->b_lock);
	if (--bp->b_hold) {
		spin_unlock(&bp->b_lock);
		return;
	}

	if (!xfs_buf_is_uncached(bp) && atomic_read(&bp->b_lru_ref)) {
		list_lru_add_obj(&bp->b_target->bt_lru, &bp->b_lru);
		spin_unlock(&bp->b_lock);
		return;
	}

	/* time to die */
	bp->b_hold = -1;
	list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru);
	spin_unlock(&bp->b_lock);

	xfs_buf_destroy(bp);

Otherwise the change looks OK.

-Dave.

-- 
Dave Chinner
dgc@kernel.org
