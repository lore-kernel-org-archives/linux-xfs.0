Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BD5C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 18:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF09360FF2
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 18:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhJ2Swy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Oct 2021 14:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhJ2Swy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Oct 2021 14:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 417E060F22;
        Fri, 29 Oct 2021 18:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635533425;
        bh=57xS40nL0zNGTIdKnRw4OnhwXLi3aAZ2USDbOetdzig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s7HvOTCMIk3sXsPDPqGZ1qcJga04ih5AWwo9tQGP1VpB4lG/1KvMKk9hMues5u0N8
         kOzbcKi3tol2k2wZFEk6wEgiNIWA+Uv0pUQvBikZHkxccqk2Nqmuqlo8VjVoWTcMS4
         R316sUEY7YLXtSx8is/i5aCKgeJQ13Dg5f2osW1D00Hik8k+Cp5D/iXQbF/1vnReW6
         X6uqJIjnbMJFizd6WUIMMVbNYMKsrgsg/gysAe/O5eRboB2+RKpKEWHhAM2asGxpA+
         IKLzX2GT+v9q0Uvwlfx3lrXr3xKnJwUFtxjNkQxx0PijC3CfvyjRtqRi/UZ/tn6IqC
         31RmYpS3J8aeg==
Date:   Fri, 29 Oct 2021 11:50:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        Allison Henderson <allison.henderson@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix the free logic of state in xfs_attr_node_hasname
Message-ID: <20211029185024.GF24307@magnolia>
References: <1635497520-8168-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635497520-8168-1-git-send-email-xuyang2018.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[adding the resident xattrs expert]

On Fri, Oct 29, 2021 at 04:52:00PM +0800, Yang Xu wrote:
> When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
> Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.
> 
> The deadlock as below:
> [983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
> [  983.923405] Call Trace:
> [  983.923410]  __schedule+0x2c4/0x700
> [  983.923412]  schedule+0x37/0xa0
> [  983.923414]  schedule_timeout+0x274/0x300
> [  983.923416]  __down+0x9b/0xf0
> [  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> [  983.923453]  down+0x3b/0x50
> [  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
> [  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> [  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
> [  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
> [  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
> [  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
> [  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
> [  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
> [  983.923624]  ? kmem_cache_alloc+0x12e/0x270
> [  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
> [  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
> [  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
> [  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
> [  983.923686]  __vfs_removexattr+0x4d/0x60
> [  983.923688]  __vfs_removexattr_locked+0xac/0x130
> [  983.923689]  vfs_removexattr+0x4e/0xf0
> [  983.923690]  removexattr+0x4d/0x80
> [  983.923693]  ? __check_object_size+0xa8/0x16b
> [  983.923695]  ? strncpy_from_user+0x47/0x1a0
> [  983.923696]  ? getname_flags+0x6a/0x1e0
> [  983.923697]  ? _cond_resched+0x15/0x30
> [  983.923699]  ? __sb_start_write+0x1e/0x70
> [  983.923700]  ? mnt_want_write+0x28/0x50
> [  983.923701]  path_removexattr+0x9b/0xb0
> [  983.923702]  __x64_sys_removexattr+0x17/0x20
> [  983.923704]  do_syscall_64+0x5b/0x1a0
> [  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [  983.923707] RIP: 0033:0x7f080f10ee1b
> 
> When getxattr calls xfs_attr_node_get, xfs_da3_node_lookup_int fails in
> xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
> free stat and xfs_attr_node_get doesn't do xfs_buf_trans release job.
> 
> Then subsequent removexattr will hang because of it.
> 
> This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
> It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
> in this case. But xfs_attr_node_hasname will free stat itself instead of caller if
> xfs_da3_node_lookup_int fails.
> 
> Fix this bug by moving the step of free state into caller.
> 
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>

Ah, I knew this function was gross.  Before, we would set *statep to
NULL upon entry to the function, and we would pass the newly allocated
da state back out if !error.  However, the caller has no idea if the
return value came from error or retval, other than (I guess) the comment
implies (or had better imply) that ENOATTR/EEXIST only come from retval.

Now you're changing it to always pass state out via **statep even if the
da3 lookup returns error and we want to pass that out.  But then
xfs_attr_node_addname_find_attr does this:

retval = xfs_attr_node_hasname(args, &dac->da_state);
if (retval != -ENOATTR && retval != -EEXIST)
	return error;

without ever clearing dac->da_state.  Won't that leak the da state?

Granted, I wonder if the xfs_attr_node_hasname call in
xfs_attr_node_removename_setup will also leak the state if the return
value is ENOATTR?

If you ask me the whole ENOATTR/EEXIST thing still needs to be replaced
with an enum xfs_attr_lookup_result passed out separately so that we
don't have to think about which magic errno values are not really
errors.

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fbc9d816882c..6ad50a76fd8d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
>  
>  	state = xfs_da_state_alloc(args);
>  	if (statep != NULL)
> -		*statep = NULL;
> +		*statep = state;
>  
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
>  	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error) {
> -		xfs_da_state_free(state);
> -		return error;
> -	}
> +	if (error)
> +		retval = error;
>  
> -	if (statep != NULL)
> -		*statep = state;
> -	else
> +	if (!statep)
>  		xfs_da_state_free(state);
> +
>  	return retval;
>  }
>  
> -- 
> 2.23.0
> 
