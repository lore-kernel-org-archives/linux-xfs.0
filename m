Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E4A29992B;
	Wed,  1 Apr 2026 04:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775017304; cv=none; b=MWUF5ZxLwOEA1jpoSrHBfVhFb8pkDUzWU0UKZrKJcmaQ0BkSvuLs5kNTc7F+GwDro6TGRoOXx6l6nTBpP2VQdypIwJvFh5Jx7e223irT+2TopRawMO9AXpKhXibGeDomhGovVkbeuI5IBut6Chlwfdfcn1m5CqO1m02oV9WP9Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775017304; c=relaxed/simple;
	bh=FIDbLrfbR6fUnlgjD/2v1iNHH75EA8hTJvGx3FtCy+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBhn/gMDVg3Pbu70iXSHh4+Vob7iMBPHJqGu3ikEJNtSorjnHVdBMDK9mHQREsf2GpTvG1ruG/012fBhlktVqIcEjlpcrjfHkkhUwI/nTXCk+tgPwFyCTQFI8moZOZWJkFFnugF6Dbv3sGGG4oxBtYYJc1efNajKbHHVkG+j7Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqUgJzrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqUgJzrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34633C4CEF7;
	Wed,  1 Apr 2026 04:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775017304;
	bh=FIDbLrfbR6fUnlgjD/2v1iNHH75EA8hTJvGx3FtCy+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqUgJzrKe3NRjw5Yuws6b+Ze88soHcExq5Zrbi/mw3U5ad40stuCm0oKPKM+nPO0n
	 q3DFlRnXWEd8TMMHetr+B4/9FNuCnPHm2P9szQ6XclwTcZCb53XhjXyy2+mwr0NmuV
	 lmAT8NhoFMBrZuNy+QUMtdiubNtMnJAGBobUQeUGQzQiyghAi5U9xB9pwV39CWD0WP
	 qlxCWFVP2DyGuBMWkorcNrTbsnfDtMuDHoBZ9+ozG315Nlt7VhuihJaSryr9WAfohe
	 CTlNlXIc0CDx1eQnFaXi/Uqr/dm2GLP+HGAM35qiCD1GBgcyOlwNy/OFeki0X0FYVg
	 SUFApz4oSwdaw==
Date: Tue, 31 Mar 2026 21:21:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: cem@kernel.org, ruansy.fnst@fujitsu.com, akpm@linux-foundation.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a resource leak in xfs_alloc_buftarg()
Message-ID: <20260401042143.GR6254@frogsfrogsfrogs>
References: <20260401040241.560314-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401040241.560314-1-lihaoxiang@isrc.iscas.ac.cn>

On Wed, Apr 01, 2026 at 12:02:41PM +0800, Haoxiang Li wrote:
> In the error path, call fs_put_dax() to drop the DAX
> device reference.
> 
> Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

Yep, that's definitely a leak...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 47edf3041631..1ca95ef46a73 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1831,6 +1831,7 @@ xfs_alloc_buftarg(
>  	return btp;
>  
>  error_free:
> +	fs_put_dax(btp->bt_daxdev, mp);
>  	kfree(btp);
>  	return ERR_PTR(error);
>  }
> -- 
> 2.25.1
> 
