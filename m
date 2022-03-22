Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4984C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 08:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiCVIow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 04:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiCVIov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 04:44:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC43653E17
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 01:43:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AD2E310E4A4B;
        Tue, 22 Mar 2022 19:43:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWa6q-008RyM-7d; Tue, 22 Mar 2022 19:43:20 +1100
Date:   Tue, 22 Mar 2022 19:43:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, pvorel@suse.cz
Subject: Re: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Message-ID: <20220322084320.GN1544202@dread.disaster.area>
References: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62398c2b
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=Wb_aD08fx7dQDbkmtpYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 04:04:17PM +0800, Yang Xu wrote:
> Petr reported a problem that S_ISGID bit was not clean when testing ltp
> case create09[1] by using umask(077).

Ok. So what is the failure message from the test?

When did the test start failing? Is this a recent failure or
something that has been around for years? If it's recent, what
commit broke it?

> It fails because xfs will call posix_acl_create before xfs_init_new_node
> calls inode_init_owner, so S_IXGRP mode will be clear when enable CONFIG_XFS_POSIXACL
> and doesn't set acl or default acl on dir, then inode_init_owner will not clear
> S_ISGID bit.

I don't really follow what you are saying is the problem here - the
rule we are supposed to be following is not clear to me, nor how XFS
is behaving contrary to the rule. Can you explain the rule (e.g.
from the test failure results) rather than try to explain where the
code goes wrong, please?

> The calltrace as below:
> 
> use inode_init_owner(mnt_userns, inode)
> [  296.760675]  xfs_init_new_inode+0x10e/0x6c0
> [  296.760678]  xfs_create+0x401/0x610
> use posix_acl_create(dir, &mode, &default_acl, &acl);
> [  296.760681]  xfs_generic_create+0x123/0x2e0
> [  296.760684]  ? _raw_spin_unlock+0x16/0x30
> [  296.760687]  path_openat+0xfb8/0x1210
> [  296.760689]  do_filp_open+0xb4/0x120
> [  296.760691]  ? file_tty_write.isra.31+0x203/0x340
> [  296.760697]  ? __check_object_size+0x150/0x170
> [  296.760699]  do_sys_openat2+0x242/0x310
> [  296.760702]  do_sys_open+0x4b/0x80
> [  296.760704]  do_syscall_64+0x3a/0x80
> 
> Fix this is simple, we can call posix_acl_create after xfs_init_new_inode completed,
> so inode_init_owner can clear S_ISGID bit correctly like ext4 or btrfs does.
>
> But commit e6a688c33238 ("xfs: initialise attr fork on inode create") has created
> attr fork in advance according to acl, so a better solution is that moving these
> functions into xfs_init_new_inode.

No, you can't do that. Xattrs cannot be created within the
transaction context of the create operation because they require
their own transaction context to run under. We cannot nest
transaction contexts in XFS, so the ACL and other security xattrs
must be created after the inode create has completed.

Commit e6a688c33238 only initialises the inode attribute fork in the
create transaction rather than requiring a separate transaction to
do it before the xattrs are then created. It does not allow xattrs
to be created from within the create transaction context.

Hence regardless of where the problem lies, a different fix will be
required to address it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
