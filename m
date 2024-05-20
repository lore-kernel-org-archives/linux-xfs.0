Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88247A2D
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227018; cv=none; b=jb//ZBDkyVUFWg24vevcYp6ku1qQhsCja+NXddpIjFEOhibnstPNDveen0NPCAhcSz3ffCBDzhmSJ0eKLrpTF0J1s2qDe/s9w4zBf3u6dlnxhSlUdC7dSXPGJxWpXeLA+nupYEpI0QFwS+BQPeyo6bc+X3G1KXtUrAVv+Fvvnbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227018; c=relaxed/simple;
	bh=xbYENzT++56uzAhituN/4pn1IneOuWq8FCnNGk1Z0RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t18eIZ+ue+ppSYLGc5f0J08rILnC6O+M9i137QxihRmnF4OAcbK6fOwrq72v2TxyqmzedhluCD+zuVnDDHner0I9GhRWHgkvwOE2SO4yN+MLT8LEBVlUQM0uDSbSRSXD8v8fnY0WzjwhxABSmLPAHBzR/Z+PfwZ4tEfNPBLgAss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0MxgY+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0MxgY+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B7DC2BD10;
	Mon, 20 May 2024 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227018;
	bh=xbYENzT++56uzAhituN/4pn1IneOuWq8FCnNGk1Z0RQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0MxgY+MbOGyf3I27ZFSEaQ4280Wqldl94zZYk3myIA0bCzPk2hYQ/b6slnidqY57
	 TFqUVMcogCMUs2IuNFad0Zfqr5GSyY2aCCUsZo5XoqMQOUnDihCYMqWCNu7eyXy9Hk
	 eJ5as5yJcm8aE2udRPcvjiRSG7H0eTMd2mHLTOCeSt/DTSzQI9eU6pE/hZum5RF748
	 acKhCI1jc6dqDod/sgL4XQelzMqxYS3FximuwSY52RmvMjLkdeWrTABLxOwBYklnJk
	 rNaE/olKmKpCxroGbng5sDNoRI6l+UeSW7MHUowwk5i7iTPRaHOusWe95t7By11qpT
	 tDjoYxzD4cDwg==
Date: Mon, 20 May 2024 10:43:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH v2 1/4] xfs: allow renames of project-less inodes
Message-ID: <20240520174337.GC25518@frogsfrogsfrogs>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520164624.665269-3-aalbersh@redhat.com>

On Mon, May 20, 2024 at 06:46:20PM +0200, Andrey Albershteyn wrote:
> Identical problem as worked around in commit e23d7e82b707 ("xfs:
> allow cross-linking special files without project quota") exists
> with renames. Renaming special file without project ID is not
> possible inside PROJINHERIT directory.

I think you could move this paragraph down, and start with:

> Special files inodes can not have project ID set from userspace and

"Special file inodes cannot have..."

> are skipped during initial project setup. Those inodes are left
> project-less in the project directory. New inodes created after
> project initialization do have an ID. Creating hard links or
> renaming those project-less inodes then fails on different ID check.
> 
> Add workaround to allow renames of special files without project ID.
> Also, move it into the helper.

and then this second paragraph becomes:

"In commit e23d7e82b707 ("..."), we relaxed the project id checks to
allow hardlinking special files with differing project ids since the
projid cannot be changed.  Apply the same workaround for renaming
operations."

> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 64 ++++++++++++++++++++++++----------------------
>  1 file changed, 34 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 58fb7a5062e1..63f8814a3d16 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1297,6 +1297,35 @@ xfs_create_tmpfile(
>  	return error;
>  }
>  
> +static inline int
> +xfs_projid_differ(
> +	struct xfs_inode	*tdp,
> +	struct xfs_inode	*sip)
> +{
> +	/*
> +	 * If we are using project inheritance, we only allow hard link/renames
> +	 * creation in our tree when the project IDs are the same; else
> +	 * the tree quota mechanism could be circumvented.
> +	 */
> +	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> +		     tdp->i_projid != sip->i_projid)) {
> +		/*
> +		 * Project quota setup skips special files which can
> +		 * leave inodes in a PROJINHERIT directory without a
> +		 * project ID set. We need to allow links to be made
> +		 * to these "project-less" inodes because userspace
> +		 * expects them to succeed after project ID setup,
> +		 * but everything else should be rejected.
> +		 */
> +		if (!special_file(VFS_I(sip)->i_mode) ||
> +		    sip->i_projid != 0) {
> +			return -EXDEV;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  int
>  xfs_link(
>  	struct xfs_inode	*tdp,
> @@ -1346,27 +1375,9 @@ xfs_link(
>  		goto error_return;
>  	}
>  
> -	/*
> -	 * If we are using project inheritance, we only allow hard link
> -	 * creation in our tree when the project IDs are the same; else
> -	 * the tree quota mechanism could be circumvented.
> -	 */
> -	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> -		     tdp->i_projid != sip->i_projid)) {
> -		/*
> -		 * Project quota setup skips special files which can
> -		 * leave inodes in a PROJINHERIT directory without a
> -		 * project ID set. We need to allow links to be made
> -		 * to these "project-less" inodes because userspace
> -		 * expects them to succeed after project ID setup,
> -		 * but everything else should be rejected.
> -		 */
> -		if (!special_file(VFS_I(sip)->i_mode) ||
> -		    sip->i_projid != 0) {
> -			error = -EXDEV;
> -			goto error_return;
> -		}
> -	}
> +	error = xfs_projid_differ(tdp, sip);
> +	if (error)
> +		goto error_return;
>  
>  	if (!resblks) {
>  		error = xfs_dir_canenter(tp, tdp, target_name);
> @@ -3268,16 +3279,9 @@ xfs_rename(
>  	if (wip)
>  		xfs_trans_ijoin(tp, wip, 0);
>  
> -	/*
> -	 * If we are using project inheritance, we only allow renames
> -	 * into our tree when the project IDs are the same; else the
> -	 * tree quota mechanism would be circumvented.
> -	 */
> -	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
> -		     target_dp->i_projid != src_ip->i_projid)) {
> -		error = -EXDEV;
> +	error = xfs_projid_differ(target_dp, src_ip);
> +	if (error)
>  		goto out_trans_cancel;
> -	}
>  
>  	/* RENAME_EXCHANGE is unique from here on. */
>  	if (flags & RENAME_EXCHANGE) {
> -- 
> 2.42.0
> 
> 
