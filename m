Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04709387375;
	Tue,  7 Apr 2026 11:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775559997; cv=none; b=IvJT0Rid03XV2LtWKzIoX5kcr7jG3n8VU+lvfwSWoijxj2bpM2L09IgzuXU6+ivohfxladWesiC2Xf/FcHN8ozb+WK9UiLrrsq4B12khDU7W+FHxVQbqla/v9Th1Gb3ckxpgsGpi0kH5IbK/h+IyYvMyekIgL3HJiQws8Zp1e0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775559997; c=relaxed/simple;
	bh=Ul9l6WAXk+XnuKUNInbczs9dI6SZ8VzW2Um1ngKrjoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHbfplttqw07WPXRHAnWgyNQTaYdzynEHwFjnN5A6YY+NPY0LF01arr2meaYDM3/Z8N6BriXJeuknwuc4RB8Q1rqTkT1/7GL9sdDfowrUpyPYQryAjF1Lwz1Qq4UosNkIRetz7uFEfy2BWbfrqCm/xdromhEhsg1MFuLJWCbb0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfiAy8O7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfiAy8O7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF59C116C6;
	Tue,  7 Apr 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775559996;
	bh=Ul9l6WAXk+XnuKUNInbczs9dI6SZ8VzW2Um1ngKrjoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IfiAy8O7tr6qIFrRUDnT8KWEEBf33CL3miwwIFdEV61FxEuIv3OrACExxkpmj9rVD
	 FSeOAAsp2dgXg3zp8EohOqYcb4YYMQtKCY0l1Nk83vEx7TRdqpDmAhLQzd8BZZn969
	 KZjUyVEi9vsyBVt+sDk7TfnByOchoWZE295OEM/rWfn8gruX7y4VbyNnS9Vdf/xgMS
	 KgJ0bdA1OLVd8AlD4/jgC2vF0modKmKbuyDceue8gm5VTXYtsuFy+o33Z5RZeLXVrV
	 jMGzycbSQHs3KzuVZ65Fnj+vAzlLVpQAYzvGH9mEP+sE+ONtwSqrV6x7e8kBZLUjkW
	 o6Nezw0rUstvA==
Date: Tue, 7 Apr 2026 13:06:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Dave Chinner <dchinner@redhat.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: fix potential integer overflow in sort
 comparators
Message-ID: <adTlLnp4T22rkqGs@nidhogg.toxiclabs.cc>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328173407.43057-4-ytohnuki@amazon.com>

On Sat, Mar 28, 2026 at 05:34:08PM +0000, Yuto Ohnuki wrote:
> Several sort comparators in XFS subtract two uint32_t values and
> return the result as int, which can overflow when the difference
> exceeds INT_MAX.
> 
> Use cmp_int() instead, as was done in commit 362c49098086
> ("xfs: fix integer overflow in bmap intent sort comparator").
> 
> Patch 1 fixes the deferred intent comparators (rmap, extfree, refcount).
> Patch 2 fixes the busy extent comparator.
> 
> Yuto Ohnuki (2):
>   xfs: fix integer overflow in deferred intent sort comparators
>   xfs: fix integer overflow in busy extent sort comparator
> 
>  fs/xfs/xfs_extent_busy.c   | 4 ++--
>  fs/xfs/xfs_extfree_item.c  | 2 +-
>  fs/xfs/xfs_refcount_item.c | 2 +-
>  fs/xfs/xfs_rmap_item.c     | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 

For the series:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
