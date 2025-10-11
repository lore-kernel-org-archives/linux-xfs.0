Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3113342050
	for <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207797; cv=none; b=RWknkEKzTxMaqgmqcAsIQ6hZaAdIzOQv94SZi3bwF5ftsAJ5bZg8mrMtspmT+qodFpgq2Z9MALnlZlufAp422p1iSOOnS6x3C81H/765+e1IgPGScfzJ9LYRzKWwmXSp623BnAvLNjoJfD56Dv0cfRhkvimeifTmzlU1zyu8VEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207797; c=relaxed/simple;
	bh=lZvjMAX4bA2BuXFUop6z3wRkIPRlfoQNDzCTz6rxuhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSMeQeSogT5dNzYZEq/hgrHXznau1iRUZ23KMwJUeWzgfNn2/vM1x7rJyHPOP38Z1CtlSUSSIkbBSw1nkpY4nm9GlooYlRgNsiDnxGITJ6a3eTnhbBpgcF0/ZQwmsrCG8RjjQA2sqCMj3A3NKhxEREcnzhFI/oobnjbjOJyh28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGJkrkne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGJkrkne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0E0C4CEF4;
	Sat, 11 Oct 2025 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207796;
	bh=lZvjMAX4bA2BuXFUop6z3wRkIPRlfoQNDzCTz6rxuhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGJkrknenxVaqG+A6ACr1NIDn4JJ0p/R3KdW6H8ZLBNr00WhAUDp3La7fU9wiNSuc
	 YHb08ruSEYW8vptKOd5Yj4dMxhd3ryU6P6C6uEAv2R+zeIYetAoWDChc0XkQ8tA9OI
	 T/l3Vj/aMdG1Iw+XJnzH0+kGdqDEoiNFhIxPcozrwXvKQry6/WTq+TJZa/yaxhFv+f
	 KHb/XlXtQf+4c1umrAjUhz+4wzJGYLB7PWWjNovuwGamLsL00TqnBiRTsIBqG/+M25
	 EvLEzH7YFlELci1IDKlRLLQCxTOiDKA5f5L/Tjs9il2JX1hKGbm+YbDOrMMsdxd61/
	 f2Wkcumrjw17g==
Date: Sat, 11 Oct 2025 11:36:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Torsten Rupp <torsten.rupp@gmx.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: SegFault in cache code 2
Message-ID: <20251011183636.GH6188@frogsfrogsfrogs>
References: <12998a08-acf3-4d18-9204-ecfdc37a70e5@gmx.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12998a08-acf3-4d18-9204-ecfdc37a70e5@gmx.net>

On Sat, Oct 11, 2025 at 10:39:24AM +0200, Torsten Rupp wrote:
> Dear XFS developers,
> 
> it seems the fix for the segmentation fault in xfsprogs 6.16.0 in the
> initialization of the cache is caused by a double initialization and free of
> "xfs_extfree_item_cache" in init.c:init_caches() resp.
> init.c:destroy_caches. This is already done in xfs_alloc.c as also valgrind
> showed me.
> 
> This patch remove the double initialization and free. The segmentation fault
> disappear with this patch and valgrind is also happy:
> 
> --- xfsprogs-6.16.0.org/libxfs/init.c   2025-06-23 13:48:41.000000000 +0200
> +++ xfsprogs-6.16.0/libxfs/init.c       2025-10-11 10:17:27.101472681 +0200
> @@ -214,9 +214,6 @@
>                 fprintf(stderr, "Could not allocate btree cursor
> caches.\n");
>                 abort();
>         }
> -       xfs_extfree_item_cache = kmem_cache_init(
> -                       sizeof(struct xfs_extent_free_item),
> -                       "xfs_extfree_item");
>         xfs_trans_cache = kmem_cache_init(
>                         sizeof(struct xfs_trans), "xfs_trans");
>         xfs_parent_args_cache = kmem_cache_init(
> @@ -236,7 +233,6 @@
>         leaked += kmem_cache_destroy(xfs_da_state_cache);
>         xfs_defer_destroy_item_caches();
>         xfs_btree_destroy_cur_caches();
> -       leaked += kmem_cache_destroy(xfs_extfree_item_cache);

Oh, yeah, that is redundant.  Can you add a Signed-off-by tag so that we
can review/include this?

--D

>         leaked += kmem_cache_destroy(xfs_trans_cache);
>         leaked += kmem_cache_destroy(xfs_parent_args_cache);
> 
> Best regards, Torsten
> 
> 
