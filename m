Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719980;
	b=V/sG+wcK+d+NxZUQbG+SGFp7LWp733ALLxTyAgnSt4qP1iRzpdylocTo1+h5Nc7KMB57
	 T/YBlpXKGaUH9qTI3d1QEiOfGnEJN5YWRtBVMxWrqsatfnTRGui4wBVtjlRiUy+d1QQ/P
	 QAPxKtsIwkdmfB6lbEM1zBwVOyNF1Hnjk0rr01toS/OKKftw3aK4sL0L0OGc08spcxJxb
	 33WM83RkQ3qmLw/ehh0hsBAap87XU5eWFRTXTiX5pWLNrX9UtUNhltr4po7WS9+s0R27i
	 HVtzJQythDwkLYGJQm1yVIti86OGHCT1BrrzRqn3vTHjPtiJkok7U9CFbWnG+EBNH2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719980;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PWsvbulylLPc/MZjsg7bEUrnSl6xePrJR8OJvu66xZU=;
	b=zA6LdfPqrvIAByquiEeM2pDFo+7bksmZ5WLgyiGSnpt6clXkOqo4nxQdV34nBqDfPPrE
	 43VnWDntOhToTwVJ5sJfKXYzr0BtwgWCA5cjgv6icDoe4Eh4Ial0X3ocEwB0cbfFtkbWU
	 n4ETqVBAXvNAsty67P6MFm5tU3ga4hpuOiLx29kygOON6cLoa28SGEUzVmLoP7fDhuVtH
	 sqriW+zPKRZjUWK8bM6x+Jey3tuf7g1EHZKo+EadHWtuPBXsHBJJTgV8Y7UNttzXMBC5S
	 IScO7egd8xdGuTrXv36TmT8UBMnEqq32UTMNd+DMHnN9a8OXNSpaYiv6lS1lZCERQLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wq+wpvCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DD7606EEB7;
	Tue,  3 Nov 2026 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wq+wpvCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391051F000C1;
	Tue,  3 Nov 2026 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719979;
	bh=PWsvbulylLPc/MZjsg7bEUrnSl6xePrJR8OJvu66xZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wq+wpvCQJyC90wEzcZFbvBIZ0vtnbPqNVvUVql+LfZk52zvG8KjIXQuuiGDN2ewYv
	 fnHIjU7fHf6xRwmNCY58wakU0NXaLfxEVxzHj67KME0kfmSiidcn2OrXSXADVBNGZf
	 iMhnyzWdOKFgu4u4PJgGu1jItcpB+zjXfAotF98ukMYY4AGSq07pDmdzFaj330nofC
	 7RzQQjxjjXTRiWx3vXv4dgh8ahOl7Oy8EJMiwkSjhUI2CYVeIX5F65X+1CBfb9a8Ta
	 BGff6F5PJYwCwvgMSX3soMp+PGGHG9nBNU7E4F6eSkBqqQhEA08IRtkLF3NxPoS+Qv
	 7ieJl0YgZACog==
Date: Tue, 3 Nov 2026 16:32:54 +0100
From: Carlos Maiolino <cem@kernel.org>
To: jianyungao89@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Eric Sandeen <sandeen@redhat.com>, Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>, 
	Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, Dave Chinner <dchinner@redhat.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix spurious len double-counting in rmap three-way
 merge check
Message-ID: <aun6-mywXYg2VTL4@nidhogg.toxiclabs.cc>
References: <20261103144148.14430-1-jianyungao89@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103144148.14430-1-jianyungao89@gmail.com>

On Tue, Nov 03, 2026 at 10:41:44PM +0800, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> In xfs_rmap_map, the left-edge merge path already executes
> ltrec.rm_blockcount += len at line 1119 before checking whether the
> right record is also contiguous and can be merged.  The subsequent
> overflow guard therefore must compare the already-incremented
> ltrec.rm_blockcount plus gtrec.rm_blockcount against XFS_RMAP_LEN_MAX,
> but it incorrectly adds len a second time:
> 
> (unsigned long)ltrec.rm_blockcount + len +
>    gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX
> 
> The extra len makes the check too strict: when the real merged length
> does not overflow but the inflated value exceeds XFS_RMAP_LEN_MAX, the
> three-way merge is rejected and the code falls back to a two-way merge,
> leaving the right record unmerged.  This produces rmap btree
> fragmentation but does not corrupt on-disk metadata.
> 
> Remove the spurious len from the overflow check.
> 
> Fixes: 0a1b0b3855cf7 ("xfs: add an extent to the rmap btree")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Hi, even though this looks reasonably correct, how did you find this
issue?
Did you test this at all against any regressions (i.e. running it
against xfstests)? This is touching critical logic on the rmap trees
which can potentially end really bad.

Cheers.

> ---
>  fs/xfs/libxfs/xfs_rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 14aef87837a9..c2b2f8e7502d 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -1120,7 +1120,7 @@ xfs_rmap_map(
>  		if (have_gt &&
>  		    bno + len == gtrec.rm_startblock &&
>  		    (ignore_off || offset + len == gtrec.rm_offset) &&
> -		    (unsigned long)ltrec.rm_blockcount + len +
> +		    (unsigned long)ltrec.rm_blockcount +
>  				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
>  			/*
>  			 * right edge also contiguous, delete right record
> -- 
> 2.34.1
> 
> 
