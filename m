Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408E33F8B4;
	Mon, 29 Jun 2026 20:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782763492; cv=none; b=qP3Pqt8WLX0TNvPwpNKkagfymVPC8zxYyd6DKowmD3lxhln7wvxaxmh2qulMpLQuiqvZx7IyzRsu0raMqorL0ziT+7jriuyV0PpSScE0Lz4phd3RkQj3rfEmq3u1MuS9h9+olU0FfRHuN1OW4tG5o0s0tSWgtDdtRzADaBu7eRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782763492; c=relaxed/simple;
	bh=WaJLFRCMGBs9oDFsFYVBl0jds4Goea18ENlYdd0tXW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/0iW47KMWgVkiZqobrBaVW/V0S3h1cr1y54rAOKPbP2a42IXWaOO1nkrYJK9teH8cZ6aDHd6P43BGyyZsZJixkKFUouHGcq45M/RiOabXi2sQJH6b0oI/wbUtvDca7A2pVOKIU39LxQvcxoq+IJWfoXPyriurN0Jj4ajFW0TWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lILhwzeb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lILhwzeb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E83A71F000E9;
	Mon, 29 Jun 2026 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782763490;
	bh=4Ob/wvSNyCMAzv5Z7UpCcvR+1yeJxsnqWMhoik2Ne54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lILhwzebmZgULzE5CEaVE3l5eyt8DrTVQpyd/H7TQHky4mUigbgXz77zdprWXBLuw
	 vCwL2XKzgeJUGlAetdoFMM6XZodB2AjqhIEfqLwe9+RlLsw3KXWN7WrO1W4hTUedHv
	 1WUCg/GNUteTdko6GNZjlt3MIIwiN0vvKtJ2MTaxKQgYou6TTqLei6g7q0alNyLfpF
	 jZAedKVRsVGGf/3qRr+yPUppgPZa4UE3rqaWRWZwESwl5/84fQLTwviIjo4VD13hrj
	 pBq9LT2Oe3oxR5bZr1xvooxaodTqyroNEaFgduF5VJ+AmVZJoe2GrQjpXK1R60wT9O
	 mQPAXh4agFvhQ==
Date: Mon, 29 Jun 2026 13:04:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dawei Feng <dawei.feng@seu.edu.cn>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, jianhao.xu@seu.edu.cn, zilin@seu.edu.cn
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dqinode_metadir_create()
Message-ID: <20260629200449.GB6078@frogsfrogsfrogs>
References: <20260627060402.2544349-1-dawei.feng@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627060402.2544349-1-dawei.feng@seu.edu.cn>

On Sat, Jun 27, 2026 at 02:04:02PM +0800, Dawei Feng wrote:
> If xfs_metadir_create() fails in xfs_dqinode_metadir_create(), the current
> code returns directly, leaking the allocated update and transaction state.
> If the subsequent commit fails, the caller-owned inode reference is left
> behind.
> 
> Fix this memory leak by routing the create failure path through
> xfs_metadir_cancel().  For both create and commit failures, finish and
> release any inode returned to the caller, mirroring the unwind pattern in
> xfs_metadir_mkdir().
> 
> The bug was first flagged by an experimental analysis tool we are
> developing for kernel memory-management bugs while analyzing
> v6.13-rc1. The tool is still under development and is not yet publicly
> available. Manual inspection confirms that the bug is still
> present in v7.1.1.
> 
> An x86_64 allyesconfig build showed no new warnings. Runtime validation
> used kprobe fault injection during `mount -o uquota` on a metadir XFS
> image. Injecting xfs_metadir_create() reproduced the old active-update path
> that left mount stuck later in mount setup; after this change, the same
> injection reported cancel_hits=1 and irele_hits=1. Injecting
> xfs_metadir_commit() exercised the old inode-reference leak path; after
> this change, it reported irele_hits=1.
> 
> Fixes: e80fbe1ad8ef ("xfs: use metadir for quota inodes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>

Heh, I have a patch just like this one in my tree courtesy of codex,
so I think this is fair:

Cc: <stable@vger.kernel.org> # v6.13
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index ce767b40482f..bbada0d3cc08 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -436,17 +436,27 @@ xfs_dqinode_metadir_create(
>  
>  	error = xfs_metadir_create(&upd, S_IFREG);
>  	if (error)
> -		return error;
> +		goto out_cancel;
>  
>  	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
>  
>  	error = xfs_metadir_commit(&upd);
>  	if (error)
> -		return error;
> +		goto out_irele;
>  
>  	xfs_finish_inode_setup(upd.ip);
>  	*ipp = upd.ip;
>  	return 0;
> +
> +out_cancel:
> +	xfs_metadir_cancel(&upd, error);
> +out_irele:
> +	/* Have to finish setting up the inode to ensure it's deleted. */
> +	if (upd.ip) {
> +		xfs_finish_inode_setup(upd.ip);
> +		xfs_irele(upd.ip);
> +	}
> +	return error;
>  }
>  
>  #ifndef __KERNEL__
> -- 
> 2.34.1
> 
> 
