Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F0D27FB10;
	Fri,  8 Aug 2025 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754664769; cv=none; b=p4WoeUVcRDHesbSxZBCSo68DdwoZSFaBF5ge3RZP+j0sAUp4iR65BjS02qJHpZLBEAhVlyhxkvSAFWvg4JKaEwcYZ1UHOYVgMoskfTdRfFW3PMBU59lN0XUdp7MUmSZ5Y5fovRiO5imvaWKzx+IvYGvrzAk48iJ60B5ePgUt5qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754664769; c=relaxed/simple;
	bh=+8R8f5ossUYjzlupzncXya+tDUku1t2Hr80KJqFPnP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksTGiljs5Xqjj69wzWwOSAmnRUeJwc8CzDoQJSHpAFKas3HaL5L3ewJ5wB4tlOK1N7aTv5Eba1M48oE07AU9te1TN2M8w+MGjwz2yfLm6sWDyBSg6GB1yc7ti2yoORtfwQHHhtpuz1P+aBunwCHyMJR3hY+VVaW7t2MAB4eEVzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlqKf/YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlqKf/YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E908BC4CEED;
	Fri,  8 Aug 2025 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754664769;
	bh=+8R8f5ossUYjzlupzncXya+tDUku1t2Hr80KJqFPnP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rlqKf/YK0MP9ngePxLgR40gcu3sEQ78YYwXfKEwe54/obnlJicnDQM6WgTTEHAuo+
	 OPoUI374V8iQvNV6/mXJR6VxtYjPXeftM+DT6ci1NfLtAWhVtm2RcDXA6zgbyyiTRs
	 Tnnx/zWSx1cVndd2vYlhrnhGx7m+Aj/l5Doaq+tLC0tqWdDLPCODpRszueUyjnPVcz
	 zI3px2PRNrR4waZq/VeqSIAXLBW6k7cYVSR0YH4Q1v6EzBnyEiqrqN6+sCpuvyqbn7
	 nI6066knBgaNHe0TwbJUoyNvVmxVNonx+o3WLftq5+7NEeduBZw3TYs9weGDRP5z8I
	 09EIiu6rzDJyA==
Date: Fri, 8 Aug 2025 07:52:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix "acheive"->"achieve"
Message-ID: <20250808145248.GU2672049@frogsfrogsfrogs>
References: <20250808084321.230969-1-zhao.xichao@vivo.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808084321.230969-1-zhao.xichao@vivo.com>

On Fri, Aug 08, 2025 at 04:43:21PM +0800, Xichao Zhao wrote:
> Trivial fix to spelling mistake in comment text.

Already submitted to the list[1], please read the archives before you
hit send.

[1] https://lore.kernel.org/linux-xfs/jjpiu6ot5kndjcggvoochddt7qq6vxmijdlog2vcp7y6pldhy3@wmbpth6y5af4/T/#u

--D

> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9c39251961a3..4c66bbe23001 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1745,7 +1745,7 @@ xfs_ifree_cluster(
>  		 * IO and it won't be unlocked until the cluster freeing has
>  		 * been committed to the journal and the buffer unpinned. If it
>  		 * is written, we want to know about it, and we want it to
> -		 * fail. We can acheive this by adding a write verifier to the
> +		 * fail. We can achieve this by adding a write verifier to the
>  		 * buffer.
>  		 */
>  		bp->b_flags |= XBF_DONE;
> -- 
> 2.34.1
> 
> 
