Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE64C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 09:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiCVJY4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 05:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiCVJYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 05:24:55 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 938F9275D0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 02:23:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B189010E4AF6;
        Tue, 22 Mar 2022 20:23:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWaja-008SZu-Jl; Tue, 22 Mar 2022 20:23:22 +1100
Date:   Tue, 22 Mar 2022 20:23:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, pvorel@suse.cz
Subject: Re: [RFC RESEND] xfs: fix up non-directory creation in SGID
 directories when umask S_IXGRP
Message-ID: <20220322092322.GO1544202@dread.disaster.area>
References: <1647936257-3188-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <20220322084320.GN1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322084320.GN1544202@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6239958d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8
        a=1XWaLZrsAAAA:8 a=drOt6m5kAAAA:8 a=7-415B0cAAAA:8 a=lUUSfwFQRV29FVf-fLEA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=HkZW87K1Qel5hWWM3VKY:22
        a=RMMjzBEyIzXRtoq5n5K6:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 07:43:20PM +1100, Dave Chinner wrote:
> On Tue, Mar 22, 2022 at 04:04:17PM +0800, Yang Xu wrote:
> > Petr reported a problem that S_ISGID bit was not clean when testing ltp
> > case create09[1] by using umask(077).
> 
> Ok. So what is the failure message from the test?
> 
> When did the test start failing? Is this a recent failure or
> something that has been around for years? If it's recent, what
> commit broke it?

Ok, I went and looked at the test, and it confirmed my suspicion.  I
can't find the patch that introduced this change on lore.kernel.org.
Looks like one of those silent security fixes that nobody gets told
about, gets no real review, has no test cases written for it, etc.

And nobody wrote a test for until August 2021 and that's when people
started to notice broken filesystems.

This is the commit that failed to fix several filesystems:

commit 0fa3ecd87848c9c93c2c828ef4c3a8ca36ce46c7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 3 17:10:19 2018 -0700

    Fix up non-directory creation in SGID directories
    
    sgid directories have special semantics, making newly created files in
    the directory belong to the group of the directory, and newly created
    subdirectories will also become sgid.  This is historically used for
    group-shared directories.
    
    But group directories writable by non-group members should not imply
    that such non-group members can magically join the group, so make sure
    to clear the sgid bit on non-directories for non-members (but remember
    that sgid without group execute means "mandatory locking", just to
    confuse things even more).
    
    Reported-by: Jann Horn <jannh@google.com>
    Cc: Andy Lutomirski <luto@kernel.org>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/inode.c b/fs/inode.c
index 2c300e981796..8c86c809ca17 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1999,8 +1999,14 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
        inode->i_uid = current_fsuid();
        if (dir && dir->i_mode & S_ISGID) {
                inode->i_gid = dir->i_gid;
+
+               /* Directories are special, and always inherit S_ISGID */
                if (S_ISDIR(mode))
                        mode |= S_ISGID;
+               else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
+                        !in_group_p(inode->i_gid) &&
+                        !capable_wrt_inode_uidgid(dir, CAP_FSETID))
+                       mode &= ~S_ISGID;
        } else
                inode->i_gid = current_fsgid();
        inode->i_mode = mode;

The problem is it takes away mode bits that the VFS passed to us
deep in the VFS inode initialisation done during on-disk inode
initialisation, and it's hidden well away from sight of the
filesystems.

Oh, what a mess - this in_group_p() && capable_wrt_inode_uidgid()
check is splattered all over filesystems in random places to clear
SGID bits. e.g ceph_finish_async_create() is an open coded
inode_init_owner() call. There's special case
code in fuse_set_acl() to clear SGID. There's a special case in
ovl_posix_acl_xattr_set() for ACL xattrs to clear SGID. And so on.

No consistency anywhere - shouldn't the VFS just be stripping the
SGID bit before it passes the mode down to filesystems? It has all
the info it needs - it doesn't need the filesystems to do everything
correctly with the mode and ensuring that they order things like
posix acl setup functions correctly with inode_init_owner() to strip
the SGID bit...

Just strip the SGID bit at the VFS, and then the filesystems can't
get it wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
