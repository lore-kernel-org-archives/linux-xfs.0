Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD7512DD98
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715297286; cv=none; b=APDDhjqhmIRgyn+X8QOEiNCZJ04cRfUrHOLCrfqq37AB4fCuBL10sBujZbXWBSJ5CgHrBrnHu3jXaxEEP1g/L9azLW/jFkwcYBB/kAnCEtfjKBmR6c3uB5Cyrhcb2Z79QKE0YrR5WK6Z/fewlY0F4krlEcs9lFpebNrYwEJrPKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715297286; c=relaxed/simple;
	bh=PBl/ybH2/wgj14uok94Jdxw3wxOZZk9jIr0B4MuXyhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OxTfdpdOM6svm8512XkMuXmGUxgQxQVUsBNEPmaB4sj+EeXuZKT0vppvGU1pqmCZGlIy6cOAP80wZkFgcyci9NXFng/RZSbmB/FGtUV4t0uaxFYJgE+2sxWBG/jqiKzig9OEAmfPl+bYjOcX+YPVAVcWqS/UQV7soUeN4Y7JUxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYnpZJYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYnpZJYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA0BC116B1;
	Thu,  9 May 2024 23:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715297285;
	bh=PBl/ybH2/wgj14uok94Jdxw3wxOZZk9jIr0B4MuXyhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lYnpZJYQCbroOCHyP9uWYInx7TSQbI9wdnmHzhTEvYj9AQd76czABzePepVCE/upj
	 TBCSlCGbWz8+7LxH3mASHDh8fzkC5szZ1snbTtqwt2k8h52CN0ErxUlQOCGgdoiyHH
	 JEdcH5mExG3mZ0LTJWh3SemLt7m3V4mqQ40nc56OvLDAvVSV9p2gwkEbtck49OovPL
	 kqFishK84K0RvroCeKN8dgXydmSibmI+VUAdJtMwKLsXGTxiqNJ4d4ZmFAfrAaIK1B
	 1nAPQR5V9p6Ym1WUUbOFN1LMEl5lCV3xrwc8uNjCUfpja0EuZdqdQZBxpXXfvZe9PW
	 GW3mTSwk1FIrw==
Date: Thu, 9 May 2024 16:28:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: allow renames of project-less inodes
Message-ID: <20240509232805.GS360919@frogsfrogsfrogs>
References: <20240509151459.3622910-2-aalbersh@redhat.com>
 <20240509151459.3622910-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509151459.3622910-4-aalbersh@redhat.com>

On Thu, May 09, 2024 at 05:14:58PM +0200, Andrey Albershteyn wrote:
> Identical problem as worked around in commit e23d7e82b707 ("xfs:
> allow cross-linking special files without project quota") exists
> with renames. Renaming special file without project ID is not
> possible inside PROJINHERIT directory.
> 
> Special files inodes can not have project ID set from userspace and
> are skipped during initial project setup. Those inodes are left
> project-less in the project directory. New inodes created after
> project initialization do have an ID. Creating hard links or
> renaming those project-less inodes then fails on different ID check.
> 
> Add workaround to allow renames of special files without project ID.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 58fb7a5062e1..508113515eec 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3275,8 +3275,19 @@ xfs_rename(
>  	 */
>  	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
>  		     target_dp->i_projid != src_ip->i_projid)) {
> -		error = -EXDEV;
> -		goto out_trans_cancel;
> +		/*
> +		 * Project quota setup skips special files which can
> +		 * leave inodes in a PROJINHERIT directory without a
> +		 * project ID set. We need to allow renames to be made
> +		 * to these "project-less" inodes because userspace
> +		 * expects them to succeed after project ID setup,
> +		 * but everything else should be rejected.
> +		 */
> +		if (!special_file(VFS_I(src_ip)->i_mode) ||
> +		    src_ip->i_projid != 0) {
> +			error = -EXDEV;
> +			goto out_trans_cancel;
> +		}
>  	}

Should this be a shared helper called by xfs_rename and xfs_link?

--D

>  
>  	/* RENAME_EXCHANGE is unique from here on. */
> -- 
> 2.42.0
> 
> 
