Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002B456DEC;
	Tue, 28 Jul 2026 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251478; cv=none; b=pSudpKVJuaesjrUkiKSHEgeO2HhQ6CL3cHuwWhNQhc+t4tHHtgW/iJge+dkZS8OCaUBOnKQesCWwjkoRTatw7CPov9SvFpjNTYYoUpkvyxLM8EXwB1LaTPRGpR9Zm6Kmey5f9Kv8GbOHBBLpPq6/3BIqdoQumv8bSB2tPNITqmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251478; c=relaxed/simple;
	bh=wjz3HuM1nOW0/tTE8o03gFjrZPApOxtOA+rDa4YttCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDEUWZJKg6FdxjdtX0DbAUONUPo4MxOM/CW1Q2cKiO6ia7iPi5MUuonos32a0Foq2NewSQ91JgCN9CdkT+A2pZDLQjDGhVwATJeakXA2pvXVulKEIh77DCVYo3h6KW8qogwvA4amRACqbjjwA/S5gEEgwRVRN9iJJDXl516fu38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NT84b8QO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NT84b8QO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB5081F000E9;
	Tue, 28 Jul 2026 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785251476;
	bh=hYNj5zZdX9y9vcOK9E04bgbJiBRa/ibqxz9fbodRO9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NT84b8QOCMz0ynh6z0zXB+a/TwHBCYY98Doai4sqjN4AHCsfDd9NW0CXd+1EwDDJb
	 kLbFc9TPfh77tmM5CWICPko+77RpOpe3++jcUWEABJfzUWE6MzI1VYeYHLm2xuJoMR
	 rj6ec3XvUfjtAAlIfx3MnrRPkTmg6d/KpkMIjvStX8SvshnWvv0dRuuNEyE79uQ0He
	 4wff620dBc1IMMB9nurSiRzxZhJu5WI/Zd8KQ+vGHi/lA6ozSb+SbA26a+I9fbBePp
	 7Fh8CHE32NOi+ClnTTVChks6n/RHg5eQws1/oB/R9gn6acYyeMi0mk2XZNZwuS3Cvh
	 dkDcclszzkMvg==
Date: Tue, 28 Jul 2026 08:11:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Miao Zhao <muel@nova.gal>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, bfoster@redhat.com,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH xfs] xfs: validate remote attr value length in the leaf
 verifier
Message-ID: <20260728151116.GL2901224@frogsfrogsfrogs>
References: <20260728062451.1296908-1-muel@nova.gal>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728062451.1296908-1-muel@nova.gal>

On Tue, Jul 28, 2026 at 06:24:51AM +0000, Miao Zhao wrote:
> xfs_attr3_leaf_verify_entry() checks a remote attr entry's namelen and
> valueblk but never its valuelen. A crafted image can set valuelen to a
> value with the high bit set; xfs_attr3_leaf_getvalue() then stores it
> in the signed int args->rmtvaluelen, where it goes negative. The
> negative length bypasses the -ERANGE size check in xfs_attr_copy_value()
> because the comparison is signed, and xfs_attr_rmtval_get() then
> reinterprets it as a huge unsigned value, driving the memcpy loop in
> xfs_attr_rmtval_copyout() past the end of the getxattr(2) result buffer
> with image-controlled data (up to ~64KB on v5, where the remote block
> header verifier caps rm_offset + rm_bytes at XFS_XATTR_SIZE_MAX;
> unbounded on v4, where remote blocks carry no header at all).
> 
> Any unprivileged user with read access to the file can trigger this
> with getxattr(2) once a crafted image is mounted, e.g. by a privileged
> auto-mount daemon:
> 
>  BUG: KASAN: slab-out-of-bounds in xfs_attr_rmtval_copyout
>  Write of size 4040 at addr 0000000061bf4ee0 by task xattr_tool/37
>  CPU: 0 UID: 65534 PID: 37 Comm: xattr_tool Not tainted 7.2.0-rc5 #1
>  Call Trace:
>   memcpy
>   xfs_attr_rmtval_copyout
>   xfs_attr_rmtval_get
>   xfs_attr_copy_value
>   xfs_attr3_leaf_getvalue
>   xfs_attr_node_get
>   xfs_attr_get
>   xfs_xattr_get
>   vfs_getxattr
>   sys_getxattr
> 
> The same unchecked valuelen is consumed on the INCOMPLETE sweep path
> (xfs_attr_inactive.c) to size stale remote blocks, so validate it for
> all remote entries: reject valuelen larger than XFS_XATTR_SIZE_MAX,
> and reject a zero valuelen on complete entries (a value is only stored
> remotely when it is too large for the local format, so zero is never
> valid there; INCOMPLETE entries legitimately carry a zeroed valuelen
> until the operation completes).
> 
> Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miao Zhao <muel@nova.gal>

Isn't this a duplicate of
https://lore.kernel.org/linux-xfs/20260707190038.3811440-3-qwe.aldo@gmail.com/#t
?

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 86c5c09a5db4..b8ae25be639a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -336,8 +336,11 @@ xfs_attr3_leaf_verify_entry(
>  		name_end = (char *)rentry + namesize;
>  		if (rentry->namelen == 0)
>  			return __this_address;
> +		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
> +			return __this_address;
>  		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
> -		    rentry->valueblk == 0)
> +		    (rentry->valueblk == 0 ||
> +		     be32_to_cpu(rentry->valuelen) == 0))
>  			return __this_address;
>  	}
>  
> -- 
> 2.34.1
> 
> 
