Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7777D1C878E;
	Fri, 14 Mar 2025 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741956638; cv=none; b=eJs/xfUfeFYHlxoUI6ct30AiMmPDFeVQfgVufG9gOspQNjrgHKsWQOjXDYCuwn294ZwcNoiFbjbGxiPygUNmKHGN4SAUCkCNhdM1z1O7AQPrcZ2dAnZoqORTLwhXj+FWcMoXIoYJ6gCz4ra8Ichho/Filwjqm3L1vjBHhKh+6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741956638; c=relaxed/simple;
	bh=OeGswBVPI/6SsI19fFlhJ44+XD/kiqe3Sytjmk3wOtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMmfW5kJJcOCzYW3eeYriYDuI2aHtVtHdpNuJWTGby0qyIpLtDJWxD1ggIh/K/eePaaeh3AvrkY6POlwNgmyzrqnWWvRc+A97P1WwyC1g/4DmXYolVN7M9SGbFWJNywz8QMxFmqbqIMut51oC89QnRs9f7Fv8NA0xUSrmbGok6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEKY3nMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEKY3nMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7783AC4CEE3;
	Fri, 14 Mar 2025 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741956638;
	bh=OeGswBVPI/6SsI19fFlhJ44+XD/kiqe3Sytjmk3wOtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oEKY3nMo7ZOBUxVAfSKtyUSDByLj0ugqUJ3MdSYx4HxLzN2bIHtoiok2D3LcgaLKM
	 2/FXBxCk0iYxJKCwUw6hs25p6UlJGmtTJOVpfV5fBW8Ug+n7sg9OPipPBzdYl9Gdhf
	 IYTNggWwyktbPEEUUDQ47tviQ3hwtyNnSj+Z5DOgiOohuW6rwLLkH2lWWN9UDkKZ2d
	 TG+KdO14rV4WHFMFbfS6gzijeRUWFRDGyhCkNpgyECrHufbIf9UVR9jBR2LzKQEgCj
	 Bi4Er8fTrDxMIXxM1dVE06mCYgFK7erFys5ovpXc0Lr8w8WmzADo3BauM/AA/Qzq0Z
	 miwxwfeoKTL9Q==
Date: Fri, 14 Mar 2025 13:50:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: long.yunjian@zte.com.cn
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mou.yi@zte.com.cn, zhang.xianwei8@zte.com.cn, 
	ouyang.maochun@zte.com.cn, jiang.xuexin@zte.com.cn, xu.lifeng1@zte.com.cn, 
	lv.mengzhao@zte.com.cn
Subject: Re: [PATCH] xfs: Fix spelling mistake "drity" -> "dirty"
Message-ID: <xau6zxgyzjfc5jdr7n32hs3rajy4fuq7iup6ps25p26ofazar5@rzqxxtuc4r7i>
References: <3eLFqScxqqqFtCE-kU0njYzH-fDA4KyBwtDLw0-CYrrAP2axi7rZATwik2Vb4EJgw08oZUhrr6patP6Aqz7wMw==@protonmail.internalid>
 <20250314142907818PyT07oeDc9Sr9svXo7qLc@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314142907818PyT07oeDc9Sr9svXo7qLc@zte.com.cn>

On Fri, Mar 14, 2025 at 02:29:07PM +0800, long.yunjian@zte.com.cn wrote:
> From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
> There is a spelling mistake in fs/xfs/xfs_log.c. Fix it.
> Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
> ---
> fs/xfs/xfs_log.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f8851ff835de..ba700785759a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2887,7 +2887,7 @@ xlog_force_and_check_iclog(
> *
> *     1. the current iclog is active and has no data; the previous iclog
> *             is in the active or dirty state.
> - *     2. the current iclog is drity, and the previous iclog is in the
> + *     2. the current iclog is dirty, and the previous iclog is in the
> *             active or dirty state.
> *
> * We may sleep if:


This patch does not apply. Please fix it and send in the correct format. Make
sure it applies on top of the tree with `git am`.

You can carry my previous RwB to the V2

> --
> 2.27.0
