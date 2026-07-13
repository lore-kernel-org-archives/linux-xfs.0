Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A87D389472;
	Mon, 13 Jul 2026 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983443; cv=none; b=QQXHdAsZM4TDPZRQreXvQlHFsHpdEVUffhMU81WjNVDTKf+yYFcFAZURjtS1WwxMInKta1smcF4WXf/PUWHyYYXX4IkHLP734cTyUNY2mc1YSeAxbJ6pRFId1c0KVNM5FSdtnqFjTTqdVBw+tvaVRBLZwhrN/iH0jw02E4kk88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983443; c=relaxed/simple;
	bh=lAlbkyuFtk9eMY8meXRDlCOUUy9LoUu0C8gYdKsgKpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DXCALMaUoX2ZKShH3TSUgULECzssFCz+7fjbSId0e7tVXLI8/pIRvyncFXCdQQWjFJ9NLJJpr1AyMkziDaDRT/oelHQKtZtC3MLQKKgehxjPrdd5vegHaWjLrOtKuf4ww9Uzt1EJWWhkLOMQnB5pkriCf+IsgHIEfeJVhTwlXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBcWzFBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBcWzFBI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DA3821F000E9;
	Mon, 13 Jul 2026 22:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983441;
	bh=gIY0Sz1b1fly6B4i18qKb2IWQRktJK8W9xo6mITWjgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fBcWzFBIpFxRaH1CDVIv+IGL2Se4WfXqoagWgaue96FWv6wq4Mj+eHkhMcoImX2Hg
	 9y2OXZAZgP3g8gltsMHyOzo/DradtLxMR+AzYvCDi9YmYsabCleejmtyz6Rq+44kIQ
	 TSJkXoVdmZsYj67VIzbwJMYNX6YvghLgr0VSZdFXuy5sBaOtX2V0GOmAjqxTnhq2H9
	 EMY33ZYb3XgDz5hMbkpBUqHt4pn4xqp4oXIornneXpUhATZykZUTKbU6NLEiroIcY7
	 YsuGuRcnoA++QP+EmFTXAiHQueQZepg17bxckc+YBmcSmkcB35JpgB2HwgbkbFDqWp
	 XWOD1Xl8stwqQ==
Date: Mon, 13 Jul 2026 15:57:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH] xfs: reject log continuation for a header-only item in
 recovery
Message-ID: <20260713225721.GM7195@frogsfrogsfrogs>
References: <20260712220854.3131445-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712220854.3131445-1-xmei5@asu.edu>

On Sun, Jul 12, 2026 at 03:08:54PM -0700, Xiang Mei wrote:
> On an XLOG_WAS_CONT_TRANS op, xlog_recover_add_to_cont_trans() extends the
> tail item's last region via item->ri_buf[item->ri_cnt-1] without checking
> that the item has one. A header-only item, created by
> xlog_recover_add_to_trans() when a transaction's first op is a bare
> sizeof(struct xfs_trans_header) op carrying XFS_TRANS_HEADER_MAGIC, sits on
> r_itemq with ri_cnt == 0 and ri_buf == NULL. A crafted log whose ops are
> XLOG_START_TRANS, that header op, then XLOG_WAS_CONT_TRANS thus
> dereferences ((struct kvec *)NULL)[-1] and faults during mount(2) log
> recovery of an untrusted XFS image.
> 
> A valid XLOG_WAS_CONT_TRANS only follows a region written with
> XLOG_CONTINUE_TRANS, so ri_cnt >= 1 always holds for a real log. Reject the
> ri_cnt == 0 case as corruption with -EFSCORRUPTED, which the caller already
> propagates to abort recovery.
> 
>   BUG: unable to handle page fault for address: fffffffffffffff0
>   #PF: supervisor read access in kernel mode
>   Oops: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:xlog_recover_add_to_cont_trans (fs/xfs/xfs_log_recover.c:2135)
>   Call Trace:
>    xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2306)
>    xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2500)
>    xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3243)
>    xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3331)
>    xlog_do_recover (fs/xfs/xfs_log_recover.c:3368)
>    xlog_recover (fs/xfs/xfs_log_recover.c:3493)
>    xfs_log_mount (fs/xfs/xfs_log.c:617)
>    xfs_mountfs (fs/xfs/xfs_mount.c:1031)
>    xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
>    get_tree_bdev_flags (fs/super.c:1634)
>    vfs_get_tree (fs/super.c:1694)
>    fc_mount (fs/namespace.c:1198)
>    path_mount (fs/namespace.c:4161)
>    __x64_sys_mount (fs/namespace.c:4367)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>    entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>   Kernel panic - not syncing: Fatal exception
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  fs/xfs/xfs_log_recover.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5f984bf5698a..fa8e04bf1aac 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2131,6 +2131,9 @@ xlog_recover_add_to_cont_trans(
>  	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
>  			  ri_list);
>  
> +	if (item->ri_cnt == 0)
> +		return -EFSCORRUPTED;

Didn't Weiming Shi already post a similar patch?  Is this a duplicate,
or a complement?

--D

> +
>  	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
>  	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
>  
> -- 
> 2.43.0
> 
> 
