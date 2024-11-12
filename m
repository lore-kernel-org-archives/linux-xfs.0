Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB821C185
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 23:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455317; cv=none; b=KixmpScswgPmNugBLWbOTvC/YxtyKYOI3b1N4D+ysz0xRk5hBp/5EdAG6ojoSqPfI2MFBNUpt78VBo7Oj8ooehLEIFi4rFsndgnZeT2eyu3zEgKEs8/CoDmwCiPXX/Rrn+tYduqiG/q1m2iIN0th2GBnOCurkgLQYtGng7CYgaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455317; c=relaxed/simple;
	bh=I3PqW7L2yU5eJE320G+JR9CGrrJBdgiW2gEcGFfTMpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csvaRTEKS+OMu+3/6PfGNDpd8Db7zhFnBYO2mJmr0Nu4coOY8tvqRh9QlSiQq+DUMlthIsvvW8zHFQh560Q6+i9AYOcJvZm+kTgOUTUUej1D/wan/8IYv2/QOrLhHvQi544LKhgESuwWEyQhi0LAGlatS1j9gGELYQbjA+BkPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKHJ8KHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKHJ8KHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B02BC4CECD;
	Tue, 12 Nov 2024 23:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731455316;
	bh=I3PqW7L2yU5eJE320G+JR9CGrrJBdgiW2gEcGFfTMpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AKHJ8KHAX4PSEo/8yVuKDadiZX1lnhIBEK4LaCltWP3b5H19hRXF+IvIByS1BOYIF
	 7NgIyCr9pNWq1qllSny4Zg1GqHGDiJnGkg/lCkb/pSHbpIdG2HmrcQiQJ7hveyFNzt
	 KQlWdGokSOJ6YZXlpREau+vs/bNLhWSbp3wnyzX5MAJ2KTqkCdtophSNC88qdFRlGn
	 FVxydy5lojBZ9CCbWjlEOnLeK4oB9fsXJ/Wesn+S/Qoj078l4ozU0LQpfY2B5wKFpQ
	 6sLNoohTbW2zb9g6G8NqUPQzrZR6oKk1vndCHXmKqr6AJB3LZzkUtH9SvnYQ77K2N0
	 zeBux/6MCHCjA==
Date: Tue, 12 Nov 2024 15:48:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 2/3] xfs: delalloc and quota softlimit timers are
 incoherent
Message-ID: <20241112234835.GH9438@frogsfrogsfrogs>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-3-david@fromorbit.com>

On Wed, Nov 13, 2024 at 09:05:15AM +1100, Dave Chinner wrote:
> From: Supriya Wickrematillake <sup@sgi.com>

Wow, there are still people working at SGI??

> I've been seeing this failure on during xfs/050 recently:
> 
>  XFS: Assertion failed: dst->d_spc_timer != 0, file: fs/xfs/xfs_qm_syscalls.c, line: 435
> ....
>  Call Trace:
>   <TASK>
>   xfs_qm_scall_getquota_fill_qc+0x2a2/0x2b0
>   xfs_qm_scall_getquota_next+0x69/0xa0
>   xfs_fs_get_nextdqblk+0x62/0xf0
>   quota_getnextxquota+0xbf/0x320
>   do_quotactl+0x1a1/0x410
>   __se_sys_quotactl+0x126/0x310
>   __x64_sys_quotactl+0x21/0x30
>   x64_sys_call+0x2819/0x2ee0
>   do_syscall_64+0x68/0x130
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> It turns out that the _qmount call has silently been failing to
> unmount and mount the filesystem, so when the softlimit is pushed
> past with a buffered write, it is not getting synced to disk before
> the next quota report is being run.
> 
> Hence when the quota report runs, we have 300 blocks of delalloc
> data on an inode, with a soft limit of 200 blocks. XFS dquots
> account delalloc reservations as used space, hence the dquot is over
> the soft limit.
> 
> However, we don't update the soft limit timers until we do a
> transactional update of the dquot. That is, the dquot sits over the
> soft limit without a softlimit timer being started until writeback
> occurs and the allocation modifies the dquot and we call
> xfs_qm_adjust_dqtimers() from xfs_trans_apply_dquot_deltas() in
> xfs_trans_commit() context.
> 
> This isn't really a problem, except for this debug code in
> xfs_qm_scall_getquota_fill_qc():
> 
> #ifdef DEBUG
>         if (xfs_dquot_is_enforced(dqp) && dqp->q_id != 0) {
>                 if ((dst->d_space > dst->d_spc_softlimit) &&
>                     (dst->d_spc_softlimit > 0)) {
>                         ASSERT(dst->d_spc_timer != 0);
>                 }
> ....
> 
> It asserts taht if the used block count is over the soft limit,
> it *must* have a soft limit timer running. This is clearly not
> the case, because we haven't committed the delalloc space to disk
> yet. Hence the soft limit is only exceeded temporarily in memory
> (which isn't an issue) and we start the timer the moment we exceed
> the soft limit in journalled metadata.
> 
> This debug was introduced in:
> 
> commit 0d5ad8383061fbc0a9804fbb98218750000fe032
> Author: Supriya Wickrematillake <sup@sgi.com>
> Date:   Wed May 15 22:44:44 1996 +0000
> 
>     initial checkin
>     quotactl syscall functions.
> 
> The very first quota support commit back in 1996. This is zero-day
> debug for Irix and, as it turns out, a zero-day bug in the debug
> code because the delalloc code on Irix didn't update the softlimit
> timers, either.
> 
> IOWs, this issue has been in the code for 28 years.
> 
> We obviously don't care if soft limit timers are a bit rubbery when
> we have delalloc reservations in memory. Production systems running
> quota reports have been exposed to this situation for 28 years and
> nobody has noticed it, so the debug code is essentially worthless at
> this point in time.
> 
> We also have the on-disk dquot verifiers checking that the soft
> limit timer is running whenever the dquot is over the soft limit
> before we write it to disk and after we read it from disk. These
> aren't firing, so it is clear the issue is purely a temporary
> in-memory incoherency that I never would have noticed had the test
> not silently failed to unmount the filesystem.
> 
> Hence I'm simply going to trash this runtime debug because it isn't
> useful in the slightest for catching quota bugs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Agreed!  I've hit this once in a blue moon and didn't think it was
especially useful either.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm_syscalls.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 4eda50ae2d1c..0c78f30fa4a3 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -427,19 +427,6 @@ xfs_qm_scall_getquota_fill_qc(
>  		dst->d_ino_timer = 0;
>  		dst->d_rt_spc_timer = 0;
>  	}
> -
> -#ifdef DEBUG
> -	if (xfs_dquot_is_enforced(dqp) && dqp->q_id != 0) {
> -		if ((dst->d_space > dst->d_spc_softlimit) &&
> -		    (dst->d_spc_softlimit > 0)) {
> -			ASSERT(dst->d_spc_timer != 0);
> -		}
> -		if ((dst->d_ino_count > dqp->q_ino.softlimit) &&
> -		    (dqp->q_ino.softlimit > 0)) {
> -			ASSERT(dst->d_ino_timer != 0);
> -		}
> -	}
> -#endif
>  }
>  
>  /* Return the quota information for the dquot matching id. */
> -- 
> 2.45.2
> 
> 
