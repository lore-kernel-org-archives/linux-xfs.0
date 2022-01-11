Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B615BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 19:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346125AbiAKTOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 14:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243270AbiAKTOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 14:14:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2E0C06173F;
        Tue, 11 Jan 2022 11:14:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AA4861727;
        Tue, 11 Jan 2022 19:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C05C36AE3;
        Tue, 11 Jan 2022 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641928446;
        bh=lZwFMu68V5iPIPfgxkVKLMOSLrfRrt8yA35331rZk+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C1SQZwDlJHn2etfy+QkDoRCFIYG5tCvd/jDNxrJgJtLWJxkIPBbeSXZo1h8nBxrWv
         eHEMCuf96+5DHVGqV+oe2VyPacTOraaawxYRLIL8y6eUOlhPXR+MoxM+rIyPcjaZwk
         ibhLNde7eNej+5mMVIRo2P1mIbuF4M045wo1rOu9ckMF3OR3dgMywqsysbZID2Au/L
         L1b65OCMrtrw8X/pfv1bAcs6ihEJuw0/igzxDeJg4kwHchY+0+6eBCz7UIx6OUssJJ
         l2kU457x10WOrlNBV3Z7AxvX5nf0JezdQFBVBv/3zbPlrHiEFU5ohg0Dpn7/IhggL4
         2SfAOk/NPSYPQ==
Date:   Tue, 11 Jan 2022 11:14:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     "allison.henderson@oracle.com" <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: Fix the free logic of state in
 xfs_attr_node_hasname
Message-ID: <20220111191406.GE656707@magnolia>
References: <20211029185024.GF24307@magnolia>
 <1635750020-2275-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <6184A132.3090901@fujitsu.com>
 <6191B7A8.9080903@fujitsu.com>
 <20211117015811.GO24282@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117015811.GO24282@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 05:58:11PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 15, 2021 at 01:27:28AM +0000, xuyang2018.jy@fujitsu.com wrote:
> > on 2021/11/5 11:12, xuyang2018.jy@fujitsu.com wrote:
> > > Hi Darrick, Allison
> > > 
> > > Any comment?
> > Ping.
> 
> FWIW I think it looks fine, but I was kinda wondering if Allison had any
> input?

Evidently I also pushed this into 5.16 but never RVBd this (???) on
list.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> --D
> 
> > > 
> > > Best Regards
> > > Yang Xu
> > >> When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
> > >> Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.
> > >>
> > >> The deadlock as below:
> > >> [983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
> > >> [  983.923405] Call Trace:
> > >> [  983.923410]  __schedule+0x2c4/0x700
> > >> [  983.923412]  schedule+0x37/0xa0
> > >> [  983.923414]  schedule_timeout+0x274/0x300
> > >> [  983.923416]  __down+0x9b/0xf0
> > >> [  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> > >> [  983.923453]  down+0x3b/0x50
> > >> [  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
> > >> [  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
> > >> [  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
> > >> [  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
> > >> [  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> > >> [  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
> > >> [  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
> > >> [  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
> > >> [  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
> > >> [  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
> > >> [  983.923624]  ? kmem_cache_alloc+0x12e/0x270
> > >> [  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
> > >> [  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
> > >> [  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
> > >> [  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
> > >> [  983.923686]  __vfs_removexattr+0x4d/0x60
> > >> [  983.923688]  __vfs_removexattr_locked+0xac/0x130
> > >> [  983.923689]  vfs_removexattr+0x4e/0xf0
> > >> [  983.923690]  removexattr+0x4d/0x80
> > >> [  983.923693]  ? __check_object_size+0xa8/0x16b
> > >> [  983.923695]  ? strncpy_from_user+0x47/0x1a0
> > >> [  983.923696]  ? getname_flags+0x6a/0x1e0
> > >> [  983.923697]  ? _cond_resched+0x15/0x30
> > >> [  983.923699]  ? __sb_start_write+0x1e/0x70
> > >> [  983.923700]  ? mnt_want_write+0x28/0x50
> > >> [  983.923701]  path_removexattr+0x9b/0xb0
> > >> [  983.923702]  __x64_sys_removexattr+0x17/0x20
> > >> [  983.923704]  do_syscall_64+0x5b/0x1a0
> > >> [  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > >> [  983.923707] RIP: 0033:0x7f080f10ee1b
> > >>
> > >> When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
> > >> xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
> > >> free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.
> > >>
> > >> Then subsequent removexattr will hang because of it.
> > >>
> > >> This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
> > >> It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
> > >> in this case. But xfs_attr_node_hasname will free state itself instead of caller if
> > >> xfs_da3_node_lookup_int fails.
> > >>
> > >> Fix this bug by moving the step of free state into caller.
> > >>
> > >> Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
> > >> xfs_attr_node_removename_setup function because we should free state ourselves.
> > >>
> > >> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> > >> Signed-off-by: Yang Xu<xuyang2018.jy@fujitsu.com>
> > >> ---
> > >>    fs/xfs/libxfs/xfs_attr.c | 17 +++++++----------
> > >>    1 file changed, 7 insertions(+), 10 deletions(-)
> > >>
> > >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > >> index fbc9d816882c..23523b802539 100644
> > >> --- a/fs/xfs/libxfs/xfs_attr.c
> > >> +++ b/fs/xfs/libxfs/xfs_attr.c
> > >> @@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
> > >>
> > >>    	state = xfs_da_state_alloc(args);
> > >>    	if (statep != NULL)
> > >> -		*statep = NULL;
> > >> +		*statep = state;
> > >>
> > >>    	/*
> > >>    	 * Search to see if name exists, and get back a pointer to it.
> > >>    	 */
> > >>    	error = xfs_da3_node_lookup_int(state,&retval);
> > >> -	if (error) {
> > >> -		xfs_da_state_free(state);
> > >> -		return error;
> > >> -	}
> > >> +	if (error)
> > >> +		retval = error;
> > >>
> > >> -	if (statep != NULL)
> > >> -		*statep = state;
> > >> -	else
> > >> +	if (!statep)
> > >>    		xfs_da_state_free(state);
> > >> +
> > >>    	return retval;
> > >>    }
> > >>
> > >> @@ -1112,7 +1109,7 @@ xfs_attr_node_addname_find_attr(
> > >>    	 */
> > >>    	retval = xfs_attr_node_hasname(args,&dac->da_state);
> > >>    	if (retval != -ENOATTR&&   retval != -EEXIST)
> > >> -		return retval;
> > >> +		goto error;
> > >>
> > >>    	if (retval == -ENOATTR&&   (args->attr_flags&   XATTR_REPLACE))
> > >>    		goto error;
> > >> @@ -1337,7 +1334,7 @@ int xfs_attr_node_removename_setup(
> > >>
> > >>    	error = xfs_attr_node_hasname(args, state);
> > >>    	if (error != -EEXIST)
> > >> -		return error;
> > >> +		goto out;
> > >>    	error = 0;
> > >>
> > >>    	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
> > > 
> > > 
