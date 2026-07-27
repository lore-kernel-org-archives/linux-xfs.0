Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800DD4248D2;
	Mon, 27 Jul 2026 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169293; cv=none; b=FQTAm/c+fPq4I40rj0YvtUbP/1u84ajwqMvmIlkztg71jlI8txin9wbLAk9IsB77I/x7w5vzqlQz+cKEOu9ZNFxHd2HnZI64x/cr7RBxZn2n1v3x9msrd1BB8e3q7BwB7bxGxrlOecbDf7Zip+blbuZVwVB6t+BDPDlDWDq8Zsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169293; c=relaxed/simple;
	bh=okETTFH1Y9E3loI+xtAY+f5lU0cxrxH1yIePN3OQsGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+awJTotoVMGTtfYIJllQpgvOyEgK04FiGk1HduNO2UZA1LdOt8qGI9XLwLhVDi+crO9DDJg0EyMlchffPYPOgiAIhL9b+vOUohwfvll8MC2gRfFf04VtV58Ss80RXwciFSZRi/UFa8aNIVT4IWzcczpkJjcC6TcHJ+GZvIEd2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANPhbjcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANPhbjcf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E4CB71F000E9;
	Mon, 27 Jul 2026 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785169291;
	bh=bG2/T3mc03zzZ7g3YzwI59DLS+QwpeHBdd+G/YNwvGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ANPhbjcfgS4DU1GwDd4ybGxqxIFjMux3XaUxsciVyWrj1bOP5fgpCnH4aHVntW2Vz
	 bY0aswmsxlvEeF/LuoaIWmOXxR2ObaZkEz4q6Iu49oYLXeWVqolWGNs4E+y3nyhhXZ
	 Tda1cNAYNGSw9b3P9aDjOkfqFtfSksQdwgrtqSCaJro3I4SNzr3CX0Qo5p0Sfmf2Fj
	 SuLT0wg2wg90DBUeBksEvS4olcuTuSTzIT1K1z++208coT77EUAAmRlGQgj2hpNf7N
	 4gAElfT3OF+WdqcfoB+1OgzUaTmg4F8OdO5gUvCP4taVB0pFHmiyC3UoKwr7MXxavF
	 jx4G4mWCt5jxg==
Date: Mon, 27 Jul 2026 09:21:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	jiapenglin@tencent.com
Subject: Re: [PATCH] xfs: fix exchange-range reflink flag clearing issue with
  INO1_WRITTEN
Message-ID: <20260727162130.GD2901224@frogsfrogsfrogs>
References: <20260727125210.28329-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727125210.28329-1-jiapenglin@tencent.com>

On Mon, Jul 27, 2026 at 08:52:03PM +0800, Lin Jiapeng wrote:
> When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
> can move the reflink inode flag from the file that currently has it to
> the other file, as long as exactly one side is marked.  This assumes
> that the file contents, and therefore all shared extents, are exchanged.
> 
> That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
> xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
> from file1, so an exchange can complete without moving every mapping
> that the earlier flag-swap decision accounted for.  In that case the
> post-operation cleanup can clear the reflink flag from an inode that
> still owns shared written extents.  Later writes then take the
> non-reflink write path and may update blocks that should still have
> been protected by CoW, which shows up as data corruption between
> reflink-related files.
> 
> Fix this by disabling the reflink flag exchange whenever
> XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
> proceed; the conservative outcome is that both inodes keep the reflink
> flag.  The regular reflink flag cleanup path can drop the extra flag
> later once the inode no longer has shared extents.
> 
> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>

Good catch!  Please add:

Cc: <stable@vger.kernel.org> # v6.10
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_exchmaps.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> index dcd0bd0b13b4..3efed37cb98a 100644
> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> @@ -959,6 +959,16 @@ xmi_can_exchange_reflink_flags(
>  {
>  	struct xfs_mount		*mp = req->ip1->i_mount;
>  
> +	/*
> +	 * The INO1_WRITTEN optimization can skip exchanging hole and
> +	 * unwritten mappings, which means we cannot guarantee that all
> +	 * shared extents actually moved to the other file.  Clearing the
> +	 * reflink flag of an inode that still holds shared extents breaks
> +	 * the CoW write path, so refuse to exchange the flags in that case.
> +	 */
> +	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
> +		return false;
> +
>  	if (hweight32(reflink_state) != 1)
>  		return false;
>  	if (req->startoff1 != 0 || req->startoff2 != 0)
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
