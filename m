Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746811185;
	Sat, 13 Sep 2025 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757722985; cv=none; b=AEX+lTJXX4sNs6f1M7h579Yogx5SzNLEe7HQ73J269Ul/gQb2e24F7oce3gUP9XEN2Fu/BQA4IirWSN7C5AS71E2erPIIG89bAsDo6O5LDdDM7SoAwcICouMnXwKGJ3uKxMfTMw0H8iCNPVLGc9CH2lZpvjEfLPVgm4qTc6G9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757722985; c=relaxed/simple;
	bh=ZKT13uU+rBRBiYqQ/UK9c0KZ6k2mp/1Cd8u0HxwFKfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQQeJAT+Ubt958GsmcsLSlsKGjWOR5mxSFSLV7bK5DWQ/ayXlriLt9r90pwWYzzUwMyKyQawN0/KyGWbfZDv564uCMtqMq2i+QbRMHoDtyQGZnCwPckN40j4p6SqQvdt6Q/h2cfwLfm97JPRc7JJPukI6YFan/xON3oiwNhFFmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NY3Ldt9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY3Ldt9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D9CC4CEF1;
	Sat, 13 Sep 2025 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757722985;
	bh=ZKT13uU+rBRBiYqQ/UK9c0KZ6k2mp/1Cd8u0HxwFKfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NY3Ldt9GL64GBzIee72q72R+dzock9Ys6zdpbW17w1vzxS6Xn+dR/TaKR9F6nUNzU
	 al+MiVJtz4CSHTeLyi11jY2AQD6WpyM2Qu+a7KUk4X8/J26c+zzloXbEVZoYnKhpAn
	 U7rT0n+e6XPZvSrnMefm4ivp5l3yLzkDn+gLNbIpcOIPS5DM88wgMZitHyFAQpZTmJ
	 DcrspigiTYLsNdRXA1ClCXZkESwCTYmNePAm8+jgZheKy5ctCFU7zeKqjh8wsyn+24
	 Cu1Nc5GXewSGkwPD9w4DRUE7foII3qAblvjroz8xhK6MQcdvI5C0t3KzZosL7aMwVO
	 ubGqpeSYNsAIA==
Date: Fri, 12 Sep 2025 17:23:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux XFS <linux-xfs@vger.kernel.org>,
	David Chinner <david@fromorbit.com>,
	Carlos Maiolino <cem@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Charles Han <hanchunchao@inspur.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] xfs: extend removed sysctls table
Message-ID: <20250913002304.GR8117@frogsfrogsfrogs>
References: <20250909000431.7474-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909000431.7474-1-bagasdotme@gmail.com>

On Tue, Sep 09, 2025 at 07:04:31AM +0700, Bagas Sanjaya wrote:
> Commit 21d59d00221e4e ("xfs: remove deprecated sysctl knobs") moves
> recently-removed sysctls to the removed sysctls table but fails to
> extend the table, hence triggering Sphinx warning:
> 
> Documentation/admin-guide/xfs.rst:365: ERROR: Malformed table.
> Text in column margin in table line 8.
> 
> =============================   =======
>   Name                          Removed
> =============================   =======
>   fs.xfs.xfsbufd_centisec       v4.0
>   fs.xfs.age_buffer_centisecs   v4.0
>   fs.xfs.irix_symlink_mode      v6.18
>   fs.xfs.irix_sgid_inherit      v6.18
>   fs.xfs.speculative_cow_prealloc_lifetime      v6.18
> =============================   ======= [docutils]
> 
> Extend "Name" column of the table to fit the now-longest sysctl, which
> is fs.xfs.speculative_cow_prealloc_lifetime.
> 
> Fixes: 21d59d00221e ("xfs: remove deprecated sysctl knobs")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250908180406.32124fb7@canb.auug.org.au/
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Oof, thanks for fixing that for me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  Documentation/admin-guide/xfs.rst | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index d6f531f2c0e694..c85cd327af284d 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -355,15 +355,15 @@ None currently.
>  Removed Sysctls
>  ===============
>  
> -=============================	=======
> -  Name				Removed
> -=============================	=======
> -  fs.xfs.xfsbufd_centisec	v4.0
> -  fs.xfs.age_buffer_centisecs	v4.0
> -  fs.xfs.irix_symlink_mode      v6.18
> -  fs.xfs.irix_sgid_inherit      v6.18
> -  fs.xfs.speculative_cow_prealloc_lifetime      v6.18
> -=============================	=======
> +==========================================   =======
> +  Name                                       Removed
> +==========================================   =======
> +  fs.xfs.xfsbufd_centisec                    v4.0
> +  fs.xfs.age_buffer_centisecs                v4.0
> +  fs.xfs.irix_symlink_mode                   v6.18
> +  fs.xfs.irix_sgid_inherit                   v6.18
> +  fs.xfs.speculative_cow_prealloc_lifetime   v6.18
> +==========================================   =======
>  
>  Error handling
>  ==============
> 
> base-commit: e90dcba0a350836a5e1a1ac0f65f9e74644d7d3b
> -- 
> An old man doll... just what I always wanted! - Clara
> 
