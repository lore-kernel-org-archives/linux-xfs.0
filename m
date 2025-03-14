Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D493E1EDA0F;
	Fri, 14 Mar 2025 09:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741945299; cv=none; b=eP+Mep5X7VX+DfLNtzpMBXZwJGn5zuj7Rkaq7p3hO8AKKIKtDfNlfHHz6FkZW3VwS/x5cf+7amDIEKAMfmpaKp2jngpNrwgblngJwV8Ew9H/ZXT+cyqIMUMbMIUObRtTgXMKazGGA4gx4n5CzE+O+fwZuKXNn+hOhv659sI/g8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741945299; c=relaxed/simple;
	bh=6gKZ51T+3DMC2j6IAwg/XsS8374WjbMxveqSF5Hz0WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOEFd3uWEwKmZ6wuonX4lRPDc2v0ZTzIss9qWxojx1bfivVkEswBSiXu8b02OS776R9gSxp/xmdN4iW4NUIoeblCYukl+o/0rgKP+RbqUFmckrNViP0SwuJxlm5efcMKnCo8INGZBPDMCoAf2vPsKjOeumdEKcYoUKx14qTglbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaO65foE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaO65foE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1380C4CEE3;
	Fri, 14 Mar 2025 09:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741945299;
	bh=6gKZ51T+3DMC2j6IAwg/XsS8374WjbMxveqSF5Hz0WA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BaO65foEUgh9pl9Wqsrm7qIDN2BzRQ6SfGDzJPbYZ1DcKIhxX0AAzIzvZhdnhbOQ8
	 E2Dk3dwizxVCq13YKUj+ASmOj6tyn7CAC+L8/fxfIJKMHYlE0blN9SX+gbbhne6flD
	 /kwF2ORtIxSlx9Kd0h66Xge3c6PaDZiWAemPwAo1vl9LprpDlS3th1uYA0dRhAXCfM
	 vEhQ7XOy6piZV3HGbPgk7YZFetPN1qLnXeD6Tb2PottbY02bCUhQVddyV2bowX5Mcx
	 hZy6twDeOtmuKUjMsTpbF562/mtxGy45pqT2lbJ7QYySbTiUZrg1WV224QuI++mybm
	 tE9+/rXHWkFKQ==
Date: Fri, 14 Mar 2025 10:41:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: long.yunjian@zte.com.cn
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mou.yi@zte.com.cn, zhang.xianwei8@zte.com.cn, 
	ouyang.maochun@zte.com.cn, jiang.xuexin@zte.com.cn, xu.lifeng1@zte.com.cn, 
	lv.mengzhao@zte.com.cn
Subject: Re: [PATCH] xfs: Fix spelling mistake "drity" -> "dirty"
Message-ID: <6ak3aylfkxp2vg4fcf54cvjzt2kafblnloetgv2bhk5n32aw2t@4bz64dxcfikj>
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

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> --
> 2.27.0
