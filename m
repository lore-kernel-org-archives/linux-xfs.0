Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05093386541;
	Mon,  6 Apr 2026 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775488986; cv=none; b=ZQB2FzlSmcEqjHsphqKIAzMcQ+4o+VQYHxSxFurlxayGqmJ1W0CoMrs4oJEzZMW6NaxyOr5YJysBxXw1SAF+v99CUvlYxTD8bQKcOUwVeWo8qH2Er3gLoZ4H7kNwgROPtryWyX6tE9hQoiqYOtLttC/dqq1/Wnbw0ZKzzzyAKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775488986; c=relaxed/simple;
	bh=mI3DCUNMTv/Npf2hqArQIS8lD+OtZfb1C3uVpcosI2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2fV2u5nM67gk8/7wueWY4G1cPX145MY0ZakA+HBg66tEIDXYHUk2Apid40YSz4j/gd094Wm48GR5HG+Nrrh+/+M9Eufssqj7dbwpVLLM5e/Q/LHo20INVzNjUVaH5XsmCIP65bvYFsYt33uO0eHAjQw/3ZOF4c69uTkaABTte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6xR5C5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6xR5C5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAA7C4CEF7;
	Mon,  6 Apr 2026 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775488985;
	bh=mI3DCUNMTv/Npf2hqArQIS8lD+OtZfb1C3uVpcosI2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U6xR5C5D9KhdzeyS5M/LTOcZHNH9LhaySgpA3zZV1MCOFmSnlOwT+ymoELeUfOq8q
	 4uJC495YFgasW6ga+2aGbbFT6tgfcghQnxZ+NvZ6QXGHGT+j0MV35WjQgd7zJgG+bc
	 0rxCb8K9f8jtU2bfNTtontp1XeS8sMM1GbJqMBREDPna4CYZ2SW9cCbGxAPLdbwnJV
	 3diOKkz86xj5AGGqjVV1SqyBIaYEvNGIGMCnCFh4gRoewMT07rIiu4l0b98cpAMim8
	 ZDIHc6miqOvwoLHK0ZBzPwDj4lxyLAR3zOwe1qLvg0iyzzUd6BI9wSRtURr+NycIH2
	 jxRzrnrMeeAsg==
Date: Mon, 6 Apr 2026 08:23:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check da node block pad field during scrub
Message-ID: <20260406152304.GB1048989@frogsfrogsfrogs>
References: <20260404143043.65268-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404143043.65268-2-ytohnuki@amazon.com>

On Sat, Apr 04, 2026 at 03:30:44PM +0100, Yuto Ohnuki wrote:
> The da node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Add a check for this during directory and
> attribute btree scrubbing so that non-zero padding is flagged as
> corruption.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/scrub/dabtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 1a71d36898b1..73d5a3bd936a 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -454,7 +454,12 @@ xchk_da_btree_block(
>  			}
>  		}
>  
> -		/* XXX: Check hdr3.pad32 once we know how to fix it. */

Same question as the previous patch -- does xfs_da3_node_create actually
zero out the pad field?

> +		if (xfs_has_crc(ip->i_mount)) {
> +			struct xfs_da3_node_hdr *nodehdr3 = blk->bp->b_addr;
> +
> +			if (be32_to_cpu(nodehdr3->__pad32) != 0)
> +				xchk_da_set_corrupt(ds, level);

and same comment about how you can only set xchk_da_set_preen if old
kernels were ok with nonzero __pad32.

--D

> +		}
>  		break;
>  	default:
>  		xchk_da_set_corrupt(ds, level);
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
