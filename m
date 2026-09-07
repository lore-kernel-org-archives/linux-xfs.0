Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42338B67E;
	Mon,  7 Sep 2026 04:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756712; cv=none; b=TwPPwiOtQHQ21i8+9DAq4ixQLe5OmZeQNOl+QOlCsGE0ECVfteKpHgtQKlBPIVOuehtIp3/jURk/iqpk3qBcVBR8n6Y5HubK/3OA7Qx6JmVC/F/c+dQDOp8w3P7aXt3xxKt/WEaYYthgKZkATmj8FaJMriEbBGrlHgdDjOU9y6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756712; c=relaxed/simple;
	bh=+MXKlJAov58gtG93q8tDLmznKP8z0hLSfSynIEcXGng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qX63Qy0QLS6uuNmYlz6DvKbOG3mx2Jz9GLc4DxzgJUObcSB32MA0KxxiO0+dFngyNuyqnZSKIyEGqMfH8MO0sIrvb6q2VgfeEyOei7thxhKKYPOYCYfrxh751Mywf3X33i2AZimmgp0jETr+L2GYiGXJsVcuNtIgmrtGVdTXaiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jq6Ege4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jq6Ege4T"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C8C6C1F00A3F;
	Mon,  7 Sep 2026 04:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788756710;
	bh=1Ikc1biHGxJou0UnQc3IcR3YBL3trRjV6xLxFc4bRA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jq6Ege4TL5ao/eTCGUFfM/ECBPTTu1evKZBrdjpQwgWevTxE6aJfAiIaJQFG1C45J
	 +229QiSd+SpoWPjZqR0XZ/OkxkQ3o768RiMhzDuo9uiWj66Y1D/48MObvuKOC8d0Gz
	 PS1gbN6fxY8JnOr5aCfTVMZWEwAikgNlj9PztYXRRrNx2MzsCfQWftKM1K8HxyHV6R
	 8ywywxZmHj1bPpADX3IrklD6ZOWrVAIyBTWHymBTBIiAF7yQvfYh3a72UZFg74gFeW
	 OgM1t0bDj/gWG8UJwSxID0XO4bGbfUZg42aT130g+I5TC9vpH1TNc1RicZQVjCwgso
	 uCn65MqlAX3dA==
Date: Sun, 6 Sep 2026 21:51:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <20260907045150.GI1933798@frogsfrogsfrogs>
References: <20260906144629.17009-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906144629.17009-1-kartikey406@gmail.com>

On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> __xfs_healthmon_insert() asserts that hm->lock is held
> (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> after allocating hm, before ever taking the lock, triggering a
> lockdep warning.
> 
> Take hm->lock around the call.
> 
> Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Heh, I added a patch just like this one to my own tree.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_healthmon.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 3ae5f4496ad1..2f762f90d329 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -1219,7 +1219,9 @@ xfs_ioc_health_monitor(
>  	}
>  	running_event->type = XFS_HEALTHMON_RUNNING;
>  	running_event->domain = XFS_HEALTHMON_MOUNT;
> +	mutex_lock(&hm->lock);
>  	__xfs_healthmon_insert(hm, running_event);
> +	mutex_unlock(&hm->lock);
>  
>  	/*
>  	 * Preallocate the unmount event so that we can't fail to notify the
> -- 
> 2.34.1
> 
> 
