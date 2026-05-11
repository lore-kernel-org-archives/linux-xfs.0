Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0005D3D9051;
	Mon, 11 May 2026 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778497114; cv=none; b=cHGCdx9PcpU8vBO39OD7bJq02qYztLWNafwbpUWV/fIs5JAPEGtrRAX+F0B3iEcaHCjpj3uToBomljcYxgnPo0fivG1FMurUJ5sekz9eYxXzOQNtIFRPQgaQIYEyW2uMoJacqnwk/pWYqFfntrujHdEBviizd9j6Uj3nGH+pPv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778497114; c=relaxed/simple;
	bh=EiVOPZl6Qs2Q5S717rMFQQXgTYTCWh6CEWXUCBTS7xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuScJoBmG0zsw/nyeueC3Isldmp6MJk/3HOlN1bT03/YCD8xOo3UBpUrn0fx3sdNZJ3uk6nluLW+F4/IE6W9CYX8ryPFLWza2uOehe7+pRIbSHDZELdj3x0JkD68Hr2VDKPX76z+9QKlydT1ou/RC933vfvvOky1JdMinOOObEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqSEYPle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqSEYPle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C75C2BCB0;
	Mon, 11 May 2026 10:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778497113;
	bh=EiVOPZl6Qs2Q5S717rMFQQXgTYTCWh6CEWXUCBTS7xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CqSEYPlegnQVowIYQfibj7a21JSWMabvSpJYxWpGmCmjjcfVuU5N5ZjNLvzeaCCIZ
	 sIL5Lf6kEO27QHvXYbrJcQ6GYYZxL27cwAhnT21SJ28aMFqO3gPp6TWIYge0bns4BF
	 ODb2emuq5l45dWQKz56RL24sOu+FVI9Z2EZOZO5NY6SE460QC6Xz4xVmGWDEf1HOVs
	 lxDL+AEDDypXXuuVpQ2dmByQLxfoEkTI8zHLQv9fPsucmnOUk7ZkuLUsPn7YAAW/tM
	 zA7lrq8ABlQE/K9zUhA9FF1UuSmBPZkz6ejAdZI1twDoCLzyxhvNxNNQ4bfHNexzRm
	 rtKmXQFV5/igQ==
Date: Mon, 11 May 2026 12:58:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Md Shofiqul Islam <shofiqtest@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v2] xfs: Fix typo in comment
Message-ID: <agG2J_aQvgsACdyA@nidhogg.toxiclabs.cc>
References: <C6jMuZzoBJA4hY9WiBIKpBD0eZNBS6RFki07XHjwG5uYm7IGIWOb4perbBt7yiEgMzoaa6Q-RmYr4CpOoMp3vA==@protonmail.internalid>
 <20260506163658.2318-1-shofiqtest@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506163658.2318-1-shofiqtest@gmail.com>

On Wed, May 06, 2026 at 07:36:58PM +0300, Md Shofiqul Islam wrote:
> Fix spelling mistake in comment:
>  - occured -> occurred
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>

FWIW you don't need to send a V2 if there is nothing to change just to
add a RwB tag.

> ---
>  fs/xfs/xfs_notify_failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 64c8afb935..b994ff15d5 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -350,7 +350,7 @@ xfs_dax_notify_dev_failure(
>  	/*
>  	 * Shutdown fs from a force umount in pre-remove case which won't fail,
>  	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
> -	 * CORRUPT flag if error occured or notify.want_shutdown was set during
> +	 * CORRUPT flag if error occurred or notify.want_shutdown was set during
>  	 * RMAP querying.
>  	 */
>  	if (mf_flags & MF_MEM_PRE_REMOVE)
> --
> 2.54.0.windows.1
