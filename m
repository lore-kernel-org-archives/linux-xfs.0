Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6454C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 10:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiBVKYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 05:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiBVKYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 05:24:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30A71598D0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 02:24:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C886157D
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 10:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CB4C340E8;
        Tue, 22 Feb 2022 10:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645525450;
        bh=RAJk5Gac4RZ4hkdAIpcvSBbuaEqtJ1YJLbfdsSlkVs0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fE+B7SZP21CWKPYdgv/ZvD8g7HPHJbKhIylCqooBZ/XhSYe+ZiWnu8zf4M17MOeBL
         MM5reCnM5m5fD+FDRRjn4NrdSgVmI3fTgjA36D+aW8DdNJvDgx1tewSwPnfPvnkA93
         QNcZvvFTpfwQ9wL+V8jakfZsf3WLMRiDS8ytQwJYL44msuhMdMMMmoS6lDnfndPNzg
         zoqyfMu8xxkTHvHjJBQmarpVfqBo73nW5wx4L/r2sCG3I45BWmrtVW4CuAULMeM8oo
         7DuwISw1sdjIuRZDYztTTMy3o0A1HW5qtyV6/aV1vhAr27uL0a3S/dJqNP2q+qK7cN
         8dBbB8127kpVw==
Date:   Tue, 22 Feb 2022 11:24:05 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-xfs@vger.kernel.org, brauner@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220222102405.mmqlzimwabz7v67d@wittgenstein>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222083340.GA5899@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 22, 2022 at 09:33:40AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> > xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> > bits.
> > Unfortunately chown syscall results in different callstask:
> > i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> > has CAP_FSETID capable in init_user_ns rather than mntns userns.
> 
> Can you add an xfstests the exercises this path?
> 
> The fix itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

So for anything other than directories the s{g,u}id bits are cleared on
every chown in notify_change() by the vfs; even for the root user (Also
documented on chown(2) manpage).

So the only scenario were this change would be relevant is for
directories afaict:

1. So ext4 has the behavior:

   ubuntu@f2-vm|~
   > mkdir suid.dir
   ubuntu@f2-vm|~
   > perms ./suid.dir
   drwxrwxr-x 775 (1000:1000) ./suid.dir
   ubuntu@f2-vm|~
   > chmod u+s ./suid.dir/
   ubuntu@f2-vm|~
   > perms ./suid.dir
   drwsrwxr-x 4775 (1000:1000) ./suid.dir
   ubuntu@f2-vm|~
   > chmod g+s ./suid.dir/
   ubuntu@f2-vm|~
   > perms ./suid.dir
   drwsrwsr-x 6775 (1000:1000) ./suid.dir
   ubuntu@f2-vm|~
   > chown 1000:1000 ./suid.dir/
   ubuntu@f2-vm|~
   > perms ./suid.dir/
   drwsrwsr-x 6775 (1000:1000) ./suid.dir/
   
   meaning that both s{g,u}id bits are retained for directories. (Just to
   make this explicit: changing {g,u}id to the same {g,u}id still ends up
   calling into the filesystem.)

2. Whereas xfs currently has:

   brauner@wittgenstein|~
   > mkdir suid.dir
   brauner@wittgenstein|~
   > perms ./suid.dir
   drwxrwxr-x 775 ./suid.dir
   brauner@wittgenstein|~
   > chmod u+s ./suid.dir/
   brauner@wittgenstein|~
   > perms ./suid.dir
   drwsrwxr-x 4775 ./suid.dir
   brauner@wittgenstein|~
   > chmod g+s ./suid.dir/
   brauner@wittgenstein|~
   > perms ./suid.dir
   drwsrwsr-x 6775 ./suid.dir
   brauner@wittgenstein|~
   > chown 1000:1000 ./suid.dir/
   brauner@wittgenstein|~
   > perms ./suid.dir/
   drwxrwxr-x 775 ./suid.dir/
   
   meaning that both s{g,u}id bits are cleared for directories.

Since the vfs will always ensure that s{g,u}id bits are stripped for
anything that isn't a directory in the vfs:
- ATTR_KILL_S{G,U}ID is raised in chown_common():

	if (!S_ISDIR(inode->i_mode))
		newattrs.ia_valid |=
			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;

- and then in notify_change() we'll get the bits stripped and ATTR_MODE
  raised:

	if (ia_valid & ATTR_KILL_SUID) {
		if (mode & S_ISUID) {
			ia_valid = attr->ia_valid |= ATTR_MODE;
			attr->ia_mode = (inode->i_mode & ~S_ISUID);
		}
	}
	if (ia_valid & ATTR_KILL_SGID) {
		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
			if (!(ia_valid & ATTR_MODE)) {
				ia_valid = attr->ia_valid |= ATTR_MODE;
				attr->ia_mode = inode->i_mode;
			}
			attr->ia_mode &= ~S_ISGID;
		}
	}

we can change this codepath to just mirror setattr_copy() or switch
fully to setattr_copy() (if feasible).

Because as of right now the code seems to imply that the xfs code itself
is responsible for stripping s{g,u}id bits for all files whereas it is
the vfs that does it for any non-directory. So I'd propose to either try
and switch that code to setattr_copy() or to do open-code the
setattr_copy() check:

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b79b3846e71b..ff55b31521a2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -748,9 +748,13 @@ xfs_setattr_nonsize(
                 * The set-user-ID and set-group-ID bits of a file will be
                 * cleared upon successful return from chown()
                 */
-               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-                   !capable(CAP_FSETID))
-                       inode->i_mode &= ~(S_ISUID|S_ISGID);
+               if (iattr->ia_valid & ATTR_MODE) {
+                       umode_t mode = iattr->ia_mode;
+                       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
+                           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+                               mode &= ~S_ISGID;
+                       inode->i_mode = mode;
+               }

                /*
                 * Change the ownerships and register quota modifications

which aligns xfs with ext4 and any other filesystem. Any thoughts on
this?

For @Andrey specifically: the tests these should go into:

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c

Note that there are already setgid inheritance tests and set*id
execution tests in there.
You should be able to copy a lot of code from them. Could you please add
the test I sketched above and ideally also a test that the set{g,u}id
bits are stripped during chown for regular files?
