Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E719337FF63
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782486886; cv=none; b=SaRXhIPg0WyZ6kfTjJUg04C0cW13AWRQSv0AFVNoZqY8ZBBlm9EAuXJ+4wAQ4PQcU/i5w3Q+pHmtgK60RxnWH/rS8w563yfFb8B5ayEZ8wrTXX3Eo+DqhBy0tJeFDQkztLVKeoMrWdroMoeghlj2KSvtee4TUf4D7ltlQxebL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782486886; c=relaxed/simple;
	bh=3qUepbRnXeB8DQUA+QfBtCfdF73ruJis54Z+op25kZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRNG8+stl57mcMqL2qccXFDgiYkPGuRPkspevT0ms1eVa6f98PiaVkxeUeFuQzHd9SfP6xXArhVDhqnzqbPiBTx0q1HRb+yWYQev5R1SZ5AviWLvpL1/tj46CFPNlUaVzBJbKJlPru9Kf3of+XK7P7N/VT2BHKHdRTHHjZxlETc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIlSWluN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIlSWluN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2742C1F000E9;
	Fri, 26 Jun 2026 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782486879;
	bh=h8ftG8hAgKs2IqxwVqI/QudSKvwFyYFBGJyn1INdt0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GIlSWluNUqN3gMRpWbPfceFSHo6crGh5LRBCi6V3AcTz+h3CpZry/HehSR2jeHnDA
	 ac6rKev1PPU/7Rlw3zW6Iq36Nx5V4qDwRhVdcAHZ1oUWOKHY8ndFaKem8byOmRUSQM
	 8ixGsj1BUicNA6v+r4zUJqlNzTUqM7wBSPZWzDj1G2h4wxwIp3ujMM4FML1rTocKoe
	 iJIxo8QZ1YBL3zhYxzW7zQP2DhRiIow9weBogHDjqCYZY1WsRPbrUYp1tCn+Qh4oZY
	 kFfMsx1fzjjZtR6nwT1xOXymG2JGzVCpVFObp70aVMTae8fWPNXViQhI/OWa2HiJdW
	 IBx3G0PhqKiXw==
Date: Fri, 26 Jun 2026 08:14:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: lift quota capability check to xfs_trans_dqresv
Message-ID: <20260626151438.GS6078@frogsfrogsfrogs>
References: <20260626102934.57834-1-cem@kernel.org>
 <20260626102934.57834-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626102934.57834-3-cem@kernel.org>

On Fri, Jun 26, 2026 at 12:29:25PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Instead of calling into ns_capable_noaudit() as an argument to
> xfs_trans_alloc_ichange(), just pass false where XFS_QMOPT_FORCE_RES is
> not explicitly required and let xfs_trans_dqresv() decide if quotas
> should be bypassed or not.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c       | 3 +--
>  fs/xfs/xfs_iops.c        | 4 +---
>  fs/xfs/xfs_trans_dquot.c | 6 ++++--
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 852ff2ab4531..480feddc0e51 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -646,8 +646,7 @@ xfs_ioctl_setattr_get_trans(
>  	if (xfs_is_shutdown(mp))
>  		goto out_error;
>  
> -	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			ns_capable_noaudit(&init_user_ns, CAP_FOWNER), &tp);
> +	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp, false, &tp);
>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 9db9ef1d8c3a..d2ae682f749f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -834,9 +834,7 @@ xfs_setattr_nonsize(
>  			return error;
>  	}
>  
> -	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -				ns_capable_noaudit(&init_user_ns, CAP_FOWNER),
> -				&tp);
> +	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL, false, &tp);

Hrm.  On second viewing, I don't really like burying the capability
check down in the transaction code because this overrides the higher
level logic that sets (or doesn't set) XFS_QMOPT_FORCE_RES.

>  	if (error)
>  		goto out_dqrele;
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index eaf9de6e07fd..50e5b323f7f1 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -832,8 +832,10 @@ xfs_trans_dqresv(
>  		qlim = &defq->rtb;
>  	}
>  
> -	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
> -	    xfs_dquot_is_enforced(dqp)) {
> +	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
> +	    dqp->q_id &&
> +	    xfs_dquot_is_enforced(dqp) &&
> +	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE)) {

The other thing that bugs me is changing CAP_FOWNER to CAP_SYS_RESOURCE
-- that's not mentioned in the commit message even though it's a
potentially breaking change for any program that already internalized
doing that on only XFS.  At a minimum we'd also have to change the
xfs_scrub service files to have CAP_SYS_RESOURCE (in addition to FOWNER)
avoid EDQUOT during online repairs.

Looking back in the history of XFS and VFS quotas, I guess XFS has been
doing CAP_FOWNER since 2.4.25, and VFS has been doing CAP_SYS_RESOURCE
since 2.3.30.  So XFS was the one that deviated (possibly because FOWNER
was the established privilege on Irix?) but I think that means XFS has
to accept either.

Going back to my idea from yesterday, I now amend it to:

static inline bool
current_may_ignore_quota_limits(void)
{
	/*
	 * Linux VFS quota code allows ignoring hard limits on
	 * chown/chgrp if the effective credentials include
	 * CAP_SYS_RESOURCE.
	 */
	if (ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE))
		return true;

	/*
	 * Historically, XFS also allows that if the current process'
	 * effective credentials include CAP_FOWNER, then they're
	 * allowed to ignore the hard limit.
	 */
	return ns_capable_noaudit(&init_user_ns, CAP_FOWNER);
}

The callsites are still:

	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
			current_may_ignore_quota_limits(), &tp);

--D

>  		int		quota_nl;
>  		bool		fatal;
>  
> -- 
> 2.54.0
> 
> 
