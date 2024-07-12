Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD741DFD8;
	Fri, 12 Jul 2024 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798782; cv=none; b=eTfoWKJgNjOF0MXjHyM+V64K40ZhnXq1s018xnbVqF9p0qZUV5PGCaCk9iaj/GlIx8+9VnfzR9O0zwzVGK4p68+cY2orK8I+fIXJcnSQjGkEfu0XjvLXjRrwMDr7K6WmKI0Yp45kXQrcAsy/HGVG7aKkyAONnwOU6C/2RCUI7Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798782; c=relaxed/simple;
	bh=adpEV9JF2pKzYuAk8fj/UWv25EhH9cy0lCpIx202+hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4e3MF7XI1Pqzwb6B93e+hpoiZVk9pklJwadtu4QBYs6c23cn/fkLjfP4Y/ws+GniNcpEjGCBkGkXOMBeHFveLD/upM88qUGoV4O1jj58qFuN4ga7eAcmWiW4pdsJyi2e5tQhDQqE6CYGd/iLnope/TBeFtj8PaawVDIeQ7Voe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3l7f/Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3l7f/Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227F6C32782;
	Fri, 12 Jul 2024 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720798782;
	bh=adpEV9JF2pKzYuAk8fj/UWv25EhH9cy0lCpIx202+hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3l7f/ZwqtoxwS+a25WAVxgXoJmZVvoTi0Uhe0FsPBgQahKnmnUc41AsReWhlxfZw
	 UqYdO/CrE3m2KBl2J0XR6qmvQZpp3/UyjxqMzXBtulnjeYixH409q7nOzqfB/92m4v
	 VvJ71TwVYShaTWJd9CqRe+XsTMmi7y91QbIqtrGmwrZuwy75OToVDSJGHcqaHwejXB
	 tZz0yaDTa6qBmvck9J0jcr39H9UoSdcImps29Y1KZpuJ+Xzev/SaKzOX7tFgNIrIt7
	 M3km88w+IpT4EN2uw1n6HXrqrq9TBS1/Ik+xxZ6cL29ec+f7aZgbl2a9Obu6G3bDZE
	 BKnCXOP+xAODA==
Date: Fri, 12 Jul 2024 08:39:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/2] xfs/242: fix test failure due to incorrect filtering
 in _filter_bmap
Message-ID: <20240712153941.GU612460@frogsfrogsfrogs>
References: <20240712064716.3385793-1-leo.lilong@huawei.com>
 <20240712064716.3385793-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712064716.3385793-2-leo.lilong@huawei.com>

On Fri, Jul 12, 2024 at 02:47:16PM +0800, Long Li wrote:
> I got a failure in xfs/242 as follows, it can be easily reproduced
> when I run xfs/242 as a cyclic test.
> 
>   13. data -> unwritten -> data
>   0: [0..127]: data
>   -1: [128..511]: unwritten
>   -2: [512..639]: data
>   +1: [128..639]: unwritten
> 
> The root cause, as Dave pointed out in previous email [1], is that
> _filter_bmap may incorrectly match the AG-OFFSET in column 5 for datadev
> files. On the other hand, _filter_bmap missing a "next" to jump out when
> it matches "data" in the 5th column, otherwise it might print the result
> twice. The issue was introduced by commit 7d5d3f77154e ("xfs/242: fix
> _filter_bmap for xfs_io bmap that does rt file properly"). The failure
> disappeared when I retest xfs/242 by reverted commit 7d5d3f77154e.
> 
> Fix it by matching the 7th column first and then the 5th column in
> _filter_bmap, because the rtdev file only has 5 columns in the `bmap -vp`
> output.
> 
> [1] https://lore.kernel.org/all/Zh9UkHEesvrpSQ7J@dread.disaster.area/
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  common/punch | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/common/punch b/common/punch
> index 9e730404..43ccab69 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -188,7 +188,10 @@ _filter_hole_fiemap()
>  	_coalesce_extents
>  }
>  
> -# Column 7 for datadev files and column 5 for rtdev files
> +# Column 7 for datadev files and column 5 for rtdev files, To prevent the
> +# 5th column in datadev files from being potentially matched incorrectly,
> +# we need to match Column 7 for datadev files first, because the rtdev
> +# file only has 5 columns in the `bmap -vp` output.

Yeah, checking column 7 before 5 seems reasonable.  Longer term, maybe
these tools should emit json to cut down on the amount of string parsing
that fstests has to do.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  #     10000 Unwritten preallocated extent
>  #     01000 Doesn't begin on stripe unit
>  #     00100 Doesn't end   on stripe unit
> @@ -201,18 +204,19 @@ _filter_bmap()
>  			print $1, $2, $3;
>  			next;
>  		}
> -		$5 ~ /1[01][01][01][01]/ {
> +		$7 ~ /1[01][01][01][01]/ {
>  			print $1, $2, "unwritten";
>  			next;
>  		}
> -		$5 ~ /0[01][01][01][01]/ {
> +		$7 ~ /0[01][01][01][01]/ {
>  			print $1, $2, "data"
> +			next;
>  		}
> -		$7 ~ /1[01][01][01][01]/ {
> +		$5 ~ /1[01][01][01][01]/ {
>  			print $1, $2, "unwritten";
>  			next;
>  		}
> -		$7 ~ /0[01][01][01][01]/ {
> +		$5 ~ /0[01][01][01][01]/ {
>  			print $1, $2, "data"
>  		}' |
>  	_coalesce_extents
> -- 
> 2.39.2
> 
> 
