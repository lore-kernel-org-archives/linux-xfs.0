Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40E13B287
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721753521; cv=none; b=CtBT3BMkG7CtdhY1+9nVxTmEv+YE3LR/Fpcq0iR15FXOWYc28xo9l450mG4fAlTZB0L8WpTMkszGRKlUZbOz8BQ8So2MzPpKh+Zwe0YLxAMOiNIKIW9BA4lRPGHCSE4H0I7i0nS6NNXIBaZxM5PfIvRyCkJlAtGZdmEhcCiaglg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721753521; c=relaxed/simple;
	bh=Y7YMT6qOfJAtXzUoNf4n2G9SALnPlce825oSrEbL75U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jt2NI7fy/q/8rCnYZxjUChFMCueYTon7ajkDy73SAZXLpIKG06Itu+RFTiNUialxsmEyae7qZoTonkRCj8+S3MM8K8vnXDPMvjLSUkW1Z8IIR9jHPyuvSwp3KeOyQ6wvgwbn5hi4z9hctrMYSrV9wpdmdW5+TGBR2m6gZpXgsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GeQrrXf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GeQrrXf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD13C4AF0A;
	Tue, 23 Jul 2024 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721753520;
	bh=Y7YMT6qOfJAtXzUoNf4n2G9SALnPlce825oSrEbL75U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GeQrrXf+2SlrFjcD7x2xYgKmW1wE+Oi2W55VhVxmtlzGoeMaeDvOo/c9UPSPY8MWo
	 O5RIKlPRmfaVg2Vk9cUoIYsFCLxDSL7Viw0Ax5ryGe2i0gYTq0xByGodN8cYnNWfUG
	 FJtg1iV8Mt7RFKsQ/jXMnRdCP/GakDHCA75N25uzO/LBiOWZaTWKoNNvhcIlImv/x9
	 0ugFFvwFprOrAhcw3chnuhwWPDw9W4U4x8yvfqmnHLgsnB3V0cpFZS2GmUsL1P2GvZ
	 wyJ2G5G3oknUfOiR8oknFbysIYor3iKASu9tD8ZfLFUWBZNYAHqwzE/a/xrO6m6Sf5
	 Dvr/Z/3EFpILw==
Date: Tue, 23 Jul 2024 09:52:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V3] xfs: allow SECURE namespace xattrs to use reserved
 block pool
Message-ID: <20240723165200.GR612460@frogsfrogsfrogs>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
 <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>

On Tue, Jul 23, 2024 at 09:59:41AM -0500, Eric Sandeen wrote:
> We got a report from the podman folks that selinux relabels that happen
> as part of their process were returning ENOSPC when the filesystem is
> completely full. This is because xattr changes reserve about 15 blocks
> for the worst case, but the common case is for selinux contexts to be
> the sole, in-inode xattr and consume no blocks.
> 
> We already allow reserved space consumption for XFS_ATTR_ROOT for things
> such as ACLs, and SECURE namespace attributes are not so very different,
> so allow them to use the reserved space as well.
> 
> Code-comment-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Remove local variable, add comment.
> V3: Add Dave's preferred comment
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index ab3d22f662f2..85e7be094943 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -110,7 +110,26 @@ xfs_attr_change(
>  	args->whichfork = XFS_ATTR_FORK;
>  	xfs_attr_sethash(args);
>  
> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
> +	/*
> +	 * Some xattrs must be resistent to allocation failure at

Nit: resistant

> +	 * ENOSPC. e.g. creating an inode with ACLs or security
> +	 * attributes requires the allocation of the xattr holding
> +	 * that information to succeed. Hence we allow xattrs in the
> +	 * VFS TRUSTED, SYSTEM, POSIX_ACL and SECURITY (LSM xattr)
> +	 * namespaces to dip into the reserve block pool to allow
> +	 * manipulation of these xattrs when at ENOSPC. These VFS
> +	 * xattr namespaces translate to the XFS_ATTR_ROOT and
> +	 * XFS_ATTR_SECURE on-disk namespaces.
> +	 *
> +	 * For most of these cases, these special xattrs will fit in
> +	 * the inode itself and so consume no extra space or only
> +	 * require temporary extra space while an overwrite is being
> +	 * made. Hence the use of the reserved pool is largely to
> +	 * avoid the worst case reservation from preventing the
> +	 * xattr from being created at ENOSPC.
> +	 */
> +	return xfs_attr_set(args, op,
> +			args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE));

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
>  
> 
> 
> 
