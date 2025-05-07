Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023021C9E3
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746652000; cv=none; b=dZHxmU1+RaoTmqP8J91bue+ItQ8Un5ZTAAgp5zwzCmPh+RR75l+ADTF2LHiEB/Q6Vsy430YcB11acHK+yXqDuYuTArJVuM0pOzdMiCEZPKulTGu3eAJ8C20fT/q3HP9LxMdK6pEDJlHtKFLn5PUrThdExLoA3T6iz3GNJi74RPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746652000; c=relaxed/simple;
	bh=MijUCcy6aMQ8w5tuE/F/v+O3qCnf0Lr8aNUK4P27F2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM4HCgR9UnJNlr5iDbKPYMrKgLuuDCpC/wd2aHPbBuhr1RyX9Mg8gQp0pL6bWyEaPzDcLiEtWWV9EL5H04rI++aqTqiQ34e4ecNH0pIOOEw0PGli9ipkRp9k7fD5KOQU9/AbvvlT975DU6JhqJE4E6je1cCs/tWeptpm2OVFkOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoig+LqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoig+LqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6906C4CEE2;
	Wed,  7 May 2025 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746652000;
	bh=MijUCcy6aMQ8w5tuE/F/v+O3qCnf0Lr8aNUK4P27F2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hoig+LqR8AbgEqwsedchZ0sBfFGqQCKis7dhMdIdAXCGSyLtnM/PhyFa7TnbnYwja
	 5C10tR7QP36/GnShD3LLWqLs23js8burqOqmD9GxDDIt3Tql/gSqRuu9wEYXaaBtXQ
	 kR9n9IUym2bzN6KnGzdUO6cdoPkosz9KjaivlNXuTlOck5wkdakwrublnTIUr/Y74U
	 JxKkQVy+9EMxsKE/ZiGynL65RnqKhogdHxQRIagab/kItEeYrxz0MZ+aKZFudWr1TE
	 ZbFNCh5kRC11+NMIfO2SU670WPium2m2ScAfGHPS1RgZ7CirJAFn32pDtJQZH3TQmp
	 S08vUod82ujFQ==
Date: Wed, 7 May 2025 14:06:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix comment on xfs_ail_delete
Message-ID: <20250507210639.GI25675@frogsfrogsfrogs>
References: <20250507095239.477105-1-cem@kernel.org>
 <20250507095239.477105-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507095239.477105-2-cem@kernel.org>

On Wed, May 07, 2025 at 11:52:30AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> It doesn't return anything.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Indeed it does not.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_ail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 85a649fec6ac..7d327a3e5a73 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -315,7 +315,7 @@ xfs_ail_splice(
>  }
>  
>  /*
> - * Delete the given item from the AIL.  Return a pointer to the item.
> + * Delete the given item from the AIL.
>   */
>  static void
>  xfs_ail_delete(
> -- 
> 2.49.0
> 
> 
