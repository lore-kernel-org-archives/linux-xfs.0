Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1113398E
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227660; cv=none; b=gyXeAWbmLG9T1XeUfs1fIdM5+7FREzPharxfwqtT+ypoj6ya8OPLMCuUYT9uinYDuQvu3sueGy7UnnYftjWHU8Qis/oOcm6+zIhvdEuqZjgNaLqvZ4ZGlzBB/kRkM3RuZqA4dkkmfJxn3/nNPbjfDlW7pGKd/SPdwBHxVoXLxIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227660; c=relaxed/simple;
	bh=fYU7+6ljDBP/NRZqq+GUEE+UrGiQUB+q2S8yaOo7sAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLaAkZwvcom3WwMn2aFXByyxPVifUKgiZWgVF5urJhVfJ9hchbrfhMBiBYt5PDGM/loNJBFAN3tTzTdqHQ/eFBMXLkRhHYIAZ6Z3PTp64nlEYXrYNN4L1YpfdNltG/7TXSdKon9aec/mP3vZn5iDJCuzFOGxvNvKJG/ObLd0Weo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rjoq7EOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rjoq7EOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D884C2BD10;
	Mon, 20 May 2024 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716227660;
	bh=fYU7+6ljDBP/NRZqq+GUEE+UrGiQUB+q2S8yaOo7sAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rjoq7EOzC6yqOcHTIjHC4ebnECkfHQpHmtaiKYEwJ0MoC8ZMVpnQcwbfYgeKQdOTs
	 FirLjljMk1L1Tv17ZDJdO6hpi+S7sW8wphipyf3NsxrtGMxD5RFLkoPo70IbCZmgHL
	 Uh/hb8GvQLC1f8354jIhrJPnWpNB602x1GS3gQyOM+mGnAD7FkDlUs4ipW01g6o/TH
	 p0RDJmRVFkUjKBLLKIdA7eTEWrUPUZzfLvKSlpgAFecUcy/jFpmcGwjQ0qjda49UL9
	 d4CshfzJkeoWSuplJT1PM2QAU9JdMqpLxxXO3ikMWP93+BhmGUJc33tLRtOhVcTJja
	 4ZKt/IlPBmHZA==
Date: Mon, 20 May 2024 10:54:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-fsdevel@vgre.kernel.org, linux-xfs@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH v2 4/4] xfs: add fileattr_set/get for symlinks
Message-ID: <20240520175419.GF25518@frogsfrogsfrogs>
References: <20240520164624.665269-2-aalbersh@redhat.com>
 <20240520164624.665269-6-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520164624.665269-6-aalbersh@redhat.com>

On Mon, May 20, 2024 at 06:46:23PM +0200, Andrey Albershteyn wrote:
> As there are now FS_IOC_FS[GET|SET]XATTRAT ioctls, xfs_quota will
> call them on special files. These new ioctls call
> ->xfs_fileattr_set/get. Symlink inodes don't have operations to
> set extended attributes, so add ones used by other inodes. The
> attribute value combinations are checked in fileattr_set_prepare().
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Seems fine to me
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ff222827e550..63f1a055a64a 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1199,6 +1199,8 @@ static const struct inode_operations xfs_symlink_inode_operations = {
>  	.setattr		= xfs_vn_setattr,
>  	.listxattr		= xfs_vn_listxattr,
>  	.update_time		= xfs_vn_update_time,
> +	.fileattr_get		= xfs_fileattr_get,
> +	.fileattr_set		= xfs_fileattr_set,
>  };
>  
>  /* Figure out if this file actually supports DAX. */
> -- 
> 2.42.0
> 
> 
