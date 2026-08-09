Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0E8388369;
	Sun,  9 Aug 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301748; cv=none; b=D++xLCtzvXSRxZnGfZGh+CwsKE77MerNilkvrAToN8NqpkDQf9BXde8TVUY9SebFoFZ4kEhne2se7jJUaE5E8UtEnwrDdEFR4G7ctj7nT6qwJ74TxlpiwnkHLtVSJ6K8ohllb7Ne2b9RzxJNd2XaKowtVtMmGNP6JEFpCkEJo0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301748; c=relaxed/simple;
	bh=kUngxHP+j2X3MT0QCvM8qaLTr36UkYsEwbJ4ifIAOKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSfp/V8w53MRJLDOA8mzAJoQvgO/kvcrnhS4Og9OvsyowYA765MbgGiJNF2cu5559GoQnhkjtMitzWfyzztUA2dWjbcaGWXllVPgPdGQWIN+/UXK7yoMuWJNf51bn5mH0V8/YTeHUBZR0mhR6FWHKHHg6v+5abiTtGWlPlOT1xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTN+i+ID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTN+i+ID"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B1FE01F000E9;
	Sun,  9 Aug 2026 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786301746;
	bh=poxNIKIgIKAH69cBnEjuFefUVxh+oY3zx0o3w0MsI0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WTN+i+IDtIlA2kvnrs24N+fgcTh6dZ5DZnpDLLOqCXxqPDh3le62JJXBy+lD/YJFO
	 HSnfS3obKLuFXf3MqtgbmyTSJ/1hDcD0xBIbINTqfMeF1vG5J6EHWIOmU95HWFjBdK
	 p/o9kZfb9wgu+qQpQStJQauhez5WsnXec6VbqwTJsLjNqAwGRb7GKN7FdKNUxNmlBQ
	 440/H8FBPQDvf1PonwCQsp4p0G4IXLQvXGEDAKE09qukbjytIELIfnfmSFoo2NW0BX
	 W2rFpTbE9i7pakuaq3rmMyT/Dlt9BxkMm79NvBFL+teCjY+mZxGm0bJRZtDZrgQCPO
	 TMoRYVpzI/tbQ==
Date: Sun, 9 Aug 2026 11:55:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: correct the parent pointer space reservation
 comment
Message-ID: <20260809185546.GS7398@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260808234016.246054-11-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808234016.246054-11-floss@jetm.me>

On Sat, Aug 08, 2026 at 05:40:21PM -0600, Javier Tia wrote:
> The comment on xfs_parent_calc_space_res() claims parent pointers are
> "always the first attr in an attr tree".  They are not: a parent pointer
> is recorded per dirent, so an inode with N hardlinks carries N of them,
> and `xfs_io -c "parent -p"` on a 31-link file lists 31.  By the Nth link
> the attr fork is in leaf or node format and the insert is not into a
> fresh tree.
> 
> The reservation itself is fine, which is what makes the comment worth
> fixing rather than the code.  XFS_DAENTER_SPACE_RES() reserves
> XFS_DA_NODE_MAXDEPTH blocks plus a bmap allowance for each, i.e. enough
> to split every level of a maximum-depth attr dabtree.  That depth is a
> format ceiling, not a runtime property, so the result cannot depend on
> the format the fork happens to be in.  Anyone auditing a reservation
> shortfall here reads the comment, concludes the sizing rests on an
> assumption that demonstrably does not hold, and goes looking for a bug
> that is not there.
> 
> Record why no double split allowance is needed either, since that is one
> of two visible differences from xfs_attr_calc_size() and is not obvious
> from the expression: a parent pointer's name is a dirent name and its
> value is a struct xfs_parent_rec, so the leaf entry is local and at most
> round_up(3 + 255 + 12, 4) = 272 bytes.  Parent pointers require V5 and
> therefore XFS_MIN_CRC_BLOCKSIZE, so the smallest half-block this can be
> compared against is 512 and the double split branch is unreachable on
> every mountable geometry.  Locality is decided against a different
> threshold, xfs_attr_leaf_entsize_local_max() at three quarters of a
> block, which the 272 bytes also clears.
> 
> Record the other difference too.  The second term hands a byte count to
> XFS_NEXTENTADD_SPACE_RES(), whose parameter counts mappings, so it asks
> for more extent-add allowance than the one mapping a parent pointer
> adds.  The factor depends on the block size, because the macro divides
> by XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(), so the comment says only that it
> over-reserves - a patch whose whole point is that the old comment stated
> a geometry-dependent thing as invariant should not do the same.  That it
> over-reserves is why it is not a bug and why this patch leaves it alone.
> 
> Signed-off-by: Javier Tia <floss@jetm.me>
> ---
>  fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
> index 9b8f495c9049..c4cd547033e5 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.c
> +++ b/fs/xfs/libxfs/xfs_trans_space.c
> @@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
>  	unsigned int		namelen)
>  {
>  	/*
> -	 * Parent pointers are always the first attr in an attr tree, and never
> -	 * larger than a block
> +	 * A parent pointer is recorded per dirent, so an inode with N links
> +	 * carries N of them and the attr fork can already be in leaf or node
> +	 * format when one is added.  That does not affect the reservation:
> +	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
> +	 * maximum-depth attr dabtree, whatever format the fork is in now.
> +	 *
> +	 * The name is a dirent name and the value is a struct xfs_parent_rec,
> +	 * so the leaf entry is always local and never exceeds 272 bytes.
> +	 * Parent pointers require V5, hence a 1k minimum block size, so the
> +	 * entry always stays under half a block and this needs none of the
> +	 * double split allowance that xfs_attr_calc_size() makes.
> +	 *
> +	 * The second term hands a byte count to a macro whose parameter counts
> +	 * mappings, so it asks for more extent-add allowance than the single
> +	 * mapping a parent pointer adds - how much more depends on the block
> +	 * size.  It over-reserves either way, which is why it is left alone:
> +	 * correcting the unit would shrink a reservation that is only generous.

We should probably reduce this some day (new feature bit), but in the
meantime this checks out.  The commit message could be a lot shorter
since you don't need to reiterate the diff there....

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	 */
>  	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
>  	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
> -- 
> Javier Tia
> 
