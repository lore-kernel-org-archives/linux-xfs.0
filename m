Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59043FD957;
	Fri, 26 Jun 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782485378; cv=none; b=sa02FQiztMTUXEBCv7qo8w6PilO4kDOcmTSDUg57AzUh2e/K3lco+VjNX2pN9QwVQwYasYPXCDWI+OtDmg6lk8auB4ZZ4enRv1c4Czp4+A7+ax1HmmsdmBn0qGopsjJMcVG2pZQ+UCaCquCbqALnEzV/3LI4XoOtcGZGhdjX/nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782485378; c=relaxed/simple;
	bh=6kIyebAgV73GN7L9ghWv6l7o8Ekv63QDtQwCnKoxTl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4BRHUk3FyGdyaa9h7PysKSdlVT+Zc5HGpWLxQpnL4qcDAlOK6aZzdynLMv36EKQ/5h9UNmd4tj+iD68nE9aMwMYEwfL7jZHAvpAV26AHNFVQRnVK/tHdlHAKxHgQ8Bt+DR/WSJh5C1zfEz5Msex2opHIk/APvt3OMj4mOk/WrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeqLjBBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeqLjBBX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F02561F00A3A;
	Fri, 26 Jun 2026 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485375;
	bh=k4x2V1Ce5QbMnxtO7thGJ+kYlbTzfX1T4ut1+O2edcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CeqLjBBXu2zTHHPJmy6hUE+J1HS1rFbndjTE4Xb4fAVDdWsyxmSPAApqg7QV8THiJ
	 3EwKdppFbnpgD1C05FsXmUmDNB0ZnPFCJpRtWCXAXc5zbGHzB1Ooyi20dj/sG1yzEG
	 Yj6Tejlum7U+LAGVo9QZRDbg9AK/7CyjaHaxNqCOGeQ3a/5aO3VTT/L7UQoMBUkmfi
	 n4jSrpslznVawccyvVWlmHqbtlzUB3uR1GIFW52cLFa1TlhzENA8mJg/SNi3zK4Pya
	 Sy36YY6y4bO2MrHCFG4S9eZ89+Rmd1lXeB1yy5K2lYFsWSeNfG/zy2/cpEqRnHdlJH
	 ThZB3fZIvmycw==
Date: Fri, 26 Jun 2026 07:49:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: Re: [PATCH 1/2] xfs: fix capabily check in xfs
Message-ID: <20260626144934.GR6078@frogsfrogsfrogs>
References: <20260626102934.57834-1-cem@kernel.org>
 <20260626102934.57834-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626102934.57834-2-cem@kernel.org>

Note: s/capabily/capability/ in the subject line

On Fri, Jun 26, 2026 at 12:29:24PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> An user reported a bug where he managed to evade group's quota
> by changing a file's gid to a different group id the same user
> belonged to, even though quotas were enforced on both gids and the
> file's size was big enough to exceed the quota's hardlimit.
> 
> Commit eba0549bc7d1 replaced a capable() call by a
> has_capability_noaudit() to prevent unnecessary selinux audit messages.
> Turns out that both calls have slightly different semantics even though
> their documentation seems similar. Where in a nutshell:
> 
> capable() - Tests the task's effective credentials
> has_ns_capability_noaudit() - Tests the task's real credentials
> 
> This most of the time has no practical difference but in some cases like
> changing attrs (specifically group id in this case) through a NFS client
> this will allow the quota code to use XFS_QMOPT_FORCE_RES, effectively
> bypassing quota accounting checks.
> 
> Using instead ns_capable_noaudit() should fix this issue and prevent
> selinux audit messages.
> 
> This also fix the remaining calls to has_capability_noaudit()
> 
> Fixes: eba0549bc7d1 ("xfs: don't generate selinux audit messages for capability testing")
> Cc: <stable@vger.kernel.org> # v5.18
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Reported-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_fsmap.c | 2 +-
>  fs/xfs/xfs_ioctl.c | 2 +-
>  fs/xfs/xfs_iops.c  | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index b6a3bc9f143c..7c79fbe0a74c 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1175,7 +1175,7 @@ xfs_getfsmap(
>  		return -EINVAL;
>  
>  	use_rmap = xfs_has_rmapbt(mp) &&
> -		   has_capability_noaudit(current, CAP_SYS_ADMIN);
> +		   ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 96af6b62ce39..852ff2ab4531 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -647,7 +647,7 @@ xfs_ioctl_setattr_get_trans(
>  		goto out_error;
>  
>  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> +			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 325c2200c501..9db9ef1d8c3a 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -835,7 +835,8 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -			has_capability_noaudit(current, CAP_FOWNER), &tp);
> +				ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> +				&tp);

Extra indenting of the second and third lines, but otherwise this looks
good to me.  With the indent fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  	if (error)
>  		goto out_dqrele;
>  
> -- 
> 2.54.0
> 
> 
