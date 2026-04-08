Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09053171BB;
	Wed,  8 Apr 2026 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684426; cv=none; b=rO9aRu2q/vyfpTQ9sJ6/JUZ/UF688j7An+Ed/sMDn2DQE6KNgqAV/X2peQgTpMSR/iWok76NS2eab4oYeE6GnSBhYkt26m8AL+h2RSZMBdIPaJapLaGHjKng12tYD/tt/oORZtHUdHUkLpxROO2Rk2aNkpvDBfhFWcKMt5MSezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684426; c=relaxed/simple;
	bh=/NxFqezc6QUvtwbo7dj+ZRaZmgHx8RyX/8lcwxDH3Ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAWJJdYN6IbsV4YOhw0BOHejeMja2o6Lr8R/le5/vL7uZYJiyXvT3AvHdn74s2w38AhvQs7qgevhgSSeVt+tti7irQE/UXerDLCEvm7+SAbEWkbaSR5Byu4mLCLqWUBODVKn9X8MDsDy9j9r5J0O/okF+762EggMrG7k13o+j60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT6AS4c7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IT6AS4c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC6EC19421;
	Wed,  8 Apr 2026 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775684425;
	bh=/NxFqezc6QUvtwbo7dj+ZRaZmgHx8RyX/8lcwxDH3Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IT6AS4c7iE7WEi+C/7OU9WkVlag4SVCr7B9Jp+Hchbca0ECFjInJ3OXrVTuIZBIU9
	 LlzNTiIvaUQ6p0O+nRwdFdOBDlR3KaTWyakeMlT0iyE41oivAgOH7U9Y+EjGuIcdY+
	 j2Zmdg5f7bNmW6yIv+iVDH92MU/tr3ZXBYKTBatC8fv1n8yZvU6Mq+6SvSo3WSxTgk
	 djt/WYZd8N4uI3HE+iPoU2eEm7UbRAyp+HK3BxGkPQ/XovDDY44G9wPRyZoHYsEj91
	 WT4AiXm+364QLWq0I7v48rGN7gi7EtWL6jLMIty7uGRjSzfgVgmxsPYJ3H588ljp8S
	 TLhz2pqEXhCYA==
Date: Thu, 9 Apr 2026 07:40:17 +1000
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: check da node block pad field during scrub
Message-ID: <adbLQXN3g5XChaJL@dread>
References: <20260408174033.4165-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408174033.4165-2-ytohnuki@amazon.com>

On Wed, Apr 08, 2026 at 06:40:34PM +0100, Yuto Ohnuki wrote:
> The da node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Add a check for this during directory and
> attribute btree scrubbing.
> 
> Since old kernels may have written non-zero padding without issues, flag
> this as an optimization opportunity (preen) rather than corruption.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
> Changes in v2:
> - Use xchk_da_set_preen instead of xchk_da_set_corrupt since
>   old kernels may have written non-zero padding without issues.
> - Link to v1: https://lore.kernel.org/all/20260404143043.65268-2-ytohnuki@amazon.com/
> ---
>  fs/xfs/scrub/dabtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 1a71d36898b1..b55922d3e988 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -454,7 +454,12 @@ xchk_da_btree_block(
>  			}
>  		}
>  
> -		/* XXX: Check hdr3.pad32 once we know how to fix it. */
> +		if (xfs_has_crc(ip->i_mount)) {
> +			struct xfs_da3_node_hdr *nodehdr3 = blk->bp->b_addr;
> +
> +			if (be32_to_cpu(nodehdr3->__pad32) != 0)
> +				xchk_da_set_preen(ds, level);
> +		}

Endian conversion not necessary on comaprison to zero.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
