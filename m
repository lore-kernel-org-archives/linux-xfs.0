Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A430C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 02:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiCACuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiCACuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 21:50:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465034755D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 18:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDC3160B60
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32269C340F0;
        Tue,  1 Mar 2022 02:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646102958;
        bh=F/IlGAFLz9wxOj+xk/62ysGupb321JrQKtofUxqWWV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QTnLMD6p9Hg7avzAA60EAFvpBwpuyZLD46E9/xuOory4CfBp4Czbwfih4oxxfiOm+
         NyyNxV7Wr1NUf9Ys/dbP8oP+gRrr6HtJouS1JcV9sRG8CJwz7ldkXI8UMFL1AxPnsr
         QilsXlcW3FzipogJWgqNkS0hnMCkNfE9R+583g1sqWym/kUzmTYTu0HT3TTpT6wrLl
         VBX9UNXZaz560Ej9r+Zkziiqb49VutHi/0rs9k7hWVNS5E5q08ZCU/EC4nFUXdKYEk
         Q442R7xQlVNvw/xStf5Ntlz+MPM5wO9NLm2UhWla9BZ9xRyD+GxOn4yMS9NAqM71GB
         b0YYAGxUb4f5A==
Date:   Mon, 28 Feb 2022 18:49:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't generate selinux audit messages for
 capability testing
Message-ID: <20220301024917.GE117732@magnolia>
References: <20220225200206.GS8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225200206.GS8313@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 25, 2022 at 12:02:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few places where we test the current process' capability set
> to decide if we're going to be more or less generous with resource
> acquisition for a system call.  If the process doesn't have the
> capability, we can continue the call, albeit in a degraded mode.
> 
> These are /not/ the actual security decisions, so it's not proper to use
> capable(), which (in certain selinux setups) causes audit messages to
> get logged.  Switch them to has_capability_noaudit.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

NAK, I'll resend with all the people I was supposed to cc an dforgot.

--D

> ---
>  fs/xfs/xfs_fsmap.c  |    4 ++--
>  fs/xfs/xfs_ioctl.c  |    2 +-
>  fs/xfs/xfs_iops.c   |    2 +-
>  kernel/capability.c |    1 +
>  4 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 48287caad28b..10e1cb71439e 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -864,8 +864,8 @@ xfs_getfsmap(
>  	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
>  		return -EINVAL;
>  
> -	use_rmap = capable(CAP_SYS_ADMIN) &&
> -		   xfs_has_rmapbt(mp);
> +	use_rmap = xfs_has_rmapbt(mp) &&
> +		   has_capability_noaudit(current, CAP_SYS_ADMIN);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2515fe8299e1..83481005317a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1189,7 +1189,7 @@ xfs_ioctl_setattr_get_trans(
>  		goto out_error;
>  
>  	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
> -			capable(CAP_FOWNER), &tp);
> +			has_capability_noaudit(current, CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_error;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a56f08314a3d..e6d910a6c35f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -723,7 +723,7 @@ xfs_setattr_nonsize(
>  	}
>  
>  	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
> -			capable(CAP_FOWNER), &tp);
> +			has_capability_noaudit(current, CAP_FOWNER), &tp);
>  	if (error)
>  		goto out_dqrele;
>  
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 46a361dde042..765194f5d678 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -360,6 +360,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>  {
>  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
>  }
> +EXPORT_SYMBOL(has_capability_noaudit);
>  
>  static bool ns_capable_common(struct user_namespace *ns,
>  			      int cap,
