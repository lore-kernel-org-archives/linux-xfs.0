Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDFD23EAB4
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 00:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718531; cv=none; b=gXSY1pagdN5ovv+rRCjv06Mcf+z6SdSntDBVh/2bQMOdBGvNHW8niJHvujgSgjX7gBEccj7cQRIe+4mI2JjPFvCsvu544SNPJCSz1UVLlVY8RV76yPFX0DmQ/NzYbIWOH98H1ifLgh9VUmgnXxoxJqQocHAzirwKTyVjSB4h7qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718531; c=relaxed/simple;
	bh=UU+ytjo8ipAttVeDHm1+zXKX5dsqZXJE/2JZ9lc48Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNwzWyzhvOmujV3xcYlN+cNT1CSwDHkKvZinj/Bz9z48NB9QhEYHfSXlORRqWEEBbXYHMPkivqLAgB6ll/2louQTEw0O+qd+9sFaW97lZuxL40wxzFjGdSIMFKHXPKMo3DwVD/WwSOcVeZ8W19wXfMutMLxdt9Nhg5LrWsQRk8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdjRneId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdjRneId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75163C19425;
	Thu, 14 May 2026 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778718531;
	bh=UU+ytjo8ipAttVeDHm1+zXKX5dsqZXJE/2JZ9lc48Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WdjRneIdMHRi+TTgOzXSZa6d+fkY3uqizjMhvRbkU47lTjkrbvSu5I7iGY8uMyoLs
	 s7PI+Rbzu2ZQMOWnWHTmFIZZ+cWtZwPA/lbJDUWCMuCFyeG8lNQboVlHLihjqSV7iB
	 RU9febtUp+ZdN3eLl+YapXglIxxl0onJsuQfC7hNNq1fYyoByLkP7DDhnDeOvaDZrU
	 1XvpJKLu3hQdHDJzkn1rTe0dhT2ef2v55mCYxfh92Q+l/8+32ZFz6epWKTjnM2+qj6
	 yhiCjPqqqC2R6kNcIpunfX226cvl6xaiFZI22Ka5sToKXsZpKTDa9fSPfZuMA7x1qK
	 d5mKyzLrSXPsQ==
Date: Wed, 13 May 2026 17:28:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] gitignore: add xfs_healer binaries and services
Message-ID: <20260514002850.GT9555@frogsfrogsfrogs>
References: <20260513193040.2130-1-ailiop@suse.com>
 <20260513193040.2130-5-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513193040.2130-5-ailiop@suse.com>

On Wed, May 13, 2026 at 09:30:40PM +0200, Anthony Iliopoulos wrote:
> Update gitignore with the various binaries and services that have been
> introduced by xfs_healer.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  .gitignore | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 6867d669c93d..eb3decd108be 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -60,6 +60,9 @@ cscope.*
>  /estimate/xfs_estimate
>  /fsr/xfs_fsr
>  /growfs/xfs_growfs
> +/healer/xfs_healer
> +/healer/xfs_healer_start
> +/healer/*.service
>  /io/xfs_io
>  /logprint/xfs_logprint
>  /mdrestore/xfs_mdrestore
> -- 
> 2.49.0
> 
> 
