Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722E3AB29D;
	Tue,  9 Jun 2026 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781017065; cv=none; b=oif+U+aVrkHjyBLJlUBAZXYPWJhYsTyT2+D3F+q7LVT1GqPWLZuaANtxw/CSi9nF1e1j0foqciniCvMuo3VTxDkflJqG+c6mlSuOSLAqSdO9S/Rz3DWM5FTDOkG1vm38b/UdtfeK0rdxeqi/zW4qpaAkBjX9CQnARWFSn+haAiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781017065; c=relaxed/simple;
	bh=wv/JeWepOy4P9psAtehOgtQUYgHnGS45M0DQiZ9HAVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYHq9LlL+LLggO2jxQXnSwbuCKj4+I0MVUbUbJYP0EgVyMCOSbAR5Qu/Tg1YK01e4h8PfCL0OqX3YyaVwutrZpoxVdiGpLVaZ6qpipJxef8EQt5qx29gx1T9CXgVeQpiKrHP2xERlM32Y6v7WN36vTWaNMIgXoWl6eKxMamdP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wiy+C/g6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wiy+C/g6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AED171F00893;
	Tue,  9 Jun 2026 14:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781017060;
	bh=cuqgcuXeS4rHJ0/9tcD5W0K7ogSUdW74eXMt0RRoUio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wiy+C/g6NPYueyM9Kr8gGAgHb+aho1Vrm7zaQ3+6z06MReohHggBmP/al/6eKgh/8
	 vrtYdeUyXEDtcfjt9GsOYPXvxaZayY1m071ZHsOBU3Ar9arHtcj0LzSql/OqIBk0oI
	 Xt1Hk0evO/AdbFwD7s0gokaj+7KOSKLEjsAYSq81V7jD232QFhvDoDCClTqjfqftXf
	 Y/d15dFKFPcTAogIXXpyAgikM9SI41SoZLnA90QlTANO3UnbbhIlO4b8HEwRfM8oTI
	 nzJ0uSroyYtMbLO7RWD3/3bNdlRF2Jh3S8aNOv+p6GZYezxjZNoSrSmZ2e5E12BYge
	 h0GZsqxVIIPZA==
Date: Tue, 9 Jun 2026 07:57:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix inode ref leak in attr intent recovery
Message-ID: <20260609145740.GC6078@frogsfrogsfrogs>
References: <20260609111619.1866748-1-gaoyingjie@uniontech.com>
 <20260609111619.1866748-2-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609111619.1866748-2-gaoyingjie@uniontech.com>

On Tue, Jun 09, 2026 at 07:16:18PM +0800, Yingjie Gao wrote:
> xfs_attri_recover_work() grabs the target inode, attaches it to the
> reconstructed attr work item, and adds that work item to the defer
> pending list.
> 
> If xfs_attr_recover_work() fails to allocate the recovery transaction,
> it returns immediately without dropping the inode reference.  The later
> cancel path only frees the attr work item state, so the inode reference
> leaks.
> 
> Release the inode before returning the transaction allocation failure.
> 
> Fixes: e70fb328d527 ("xfs: recreate work items when recovering intent items")
> Cc: <stable@vger.kernel.org> # v6.8
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> ---
>  fs/xfs/xfs_attr_item.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index deab14f31b38..c3d96c7a5bca 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -773,8 +773,10 @@ xfs_attr_recover_work(
>  	}
>  	resv = xlog_recover_resv(&resv);
>  	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
> -	if (error)
> +	if (error) {
> +		xfs_irele(ip);

Seems fine but I wonder why you don't just add an out_rele label on the
line above the existing xfs_irele() call and make this goto there?

--D

>  		return error;
> +	}
>  	args->trans = tp;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -- 
> 2.20.1
> 
> 
