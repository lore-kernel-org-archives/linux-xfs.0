Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B9C78F2B;
	Fri, 26 Jun 2026 20:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782507179; cv=none; b=ft6YvDOAHYtEBVhp89cUBwjiCK0f01KdJ0L5hmEGbWyu6DOn3W5oDasHUp/217nzbdZczNstRlE62ZanfJOymbjuysq+KIrLOQFeHytDnMtcAm+bCHfFHQ49lSwdo6pStUx1zhAXQyLygL0FFpi+KevCiq95By0LpbI3I74q9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782507179; c=relaxed/simple;
	bh=AdmWqW7+aH7z44hHUdy5+iMl8R4xgHAdUu4Tc7KC+Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nB4JZ/aafXjPrigOhBAH/922PRupu4HgQRSSZOEb8A9px5qoWWWO3Hr8WRJlEzN3aOqXfrNETcioiZwcXfz7OL6U7rIu+I5ZaqraAnfttk55+c+vPNHmCYG5biOT1wnnTvrYddPPYiUqUhe6d0kR38R8jlgRbp1NDjbb7Hauu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AirO9kWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AirO9kWn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D31A81F000E9;
	Fri, 26 Jun 2026 20:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782507177;
	bh=qRZReqeD94m3kwV5ZKf0XzaStglKHtbD+U9buui1d1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AirO9kWneoHQILC21eiscrbdstDi7eYe4OwDGSMYbxnsK3myTG0t+TOeKQWb6wMtW
	 IN7ZK6Hlq7mjtC/ZV1kzUKPY+MDxG0VeYd0ya7AFCVwQWUnl8Kj6kTGwzRsH4I5peX
	 T9BjeqHumiD5arWUuOm3qh7/+/dS5JTLBTZNDihGkH6+Hb6Hy3r9LJ7OERrXbZ+C5J
	 ZTFPr95zPrmxnuhQYbV3+PRCwFNNsSZfrMD9TCduiX6QhUw5DFyQhX9tvrG9E6Y+Et
	 FUn5gk85zZzWPoQlIgh9kdXNCSA855YQJzeB42D/MAEzSxPI6FH10B16cGjDhIW+DZ
	 znAxh+V5KGmVA==
Date: Fri, 26 Jun 2026 13:52:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs: retry dqpurge when dquot buffer is busy
Message-ID: <20260626205257.GA6078@frogsfrogsfrogs>
References: <20260626095253.3445540-1-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626095253.3445540-1-gaoyingjie@uniontech.com>

On Fri, Jun 26, 2026 at 05:52:53PM +0800, Yingjie Gao wrote:
> xfs_qm_dqpurge() marks a zero-reference dquot dead before trying to flush
> a dirty dquot. If the attached buffer is busy, xfs_dquot_use_attached_buf()
> returns -EAGAIN.
> 
> The error path restores q_lockref.count but then jumps to out_funlock,
> which continues into the successful purge tail and destroys the dquot.  At
> that point the attached buffer has not been detached and the dquot log item
> may still be in the AIL.
> 
> Restore the retry behavior by dropping the locks and returning -EAGAIN
> after resurrecting the lockref.
> 
> Link: https://lore.kernel.org/linux-xfs/20260625175519.GF6078@frogsfrogsfrogs/
> Fixes: 0c5e80bd579f ("xfs: use a lockref for the xfs_dquot reference count")
> Cc: stable@vger.kernel.org # v6.19+
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>

Yeah, that's more like what we did before 0c5e80bd579f.  I think the
lockref resurrection part still looks ok, but maybe hch has an opinion?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aa0d2976f1c3..0622c72292d8 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -155,8 +155,12 @@ xfs_qm_dqpurge(
>  		error = xfs_dquot_use_attached_buf(dqp, &bp);
>  		if (error == -EAGAIN) {
>  			/* resurrect the refcount from the dead. */
> +			xfs_dqfunlock(dqp);
> +			mutex_unlock(&dqp->q_qlock);
> +			spin_lock(&dqp->q_lockref.lock);
>  			dqp->q_lockref.count = 0;
> -			goto out_funlock;
> +			spin_unlock(&dqp->q_lockref.lock);
> +			return -EAGAIN;
>  		}
>  		if (!bp)
>  			goto out_funlock;
> -- 
> 2.20.1
> 
> 
