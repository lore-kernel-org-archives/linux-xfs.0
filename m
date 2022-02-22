Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6E0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Feb 2022 15:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiBVPEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiBVPDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 10:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D910E57C
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 07:03:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9916D6151A
        for <linux-xfs@vger.kernel.org>; Tue, 22 Feb 2022 15:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36F2C340E8;
        Tue, 22 Feb 2022 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645542191;
        bh=e7KilYDzSlB02kpBrM0zZRXOGsdN0SdeNcTQGABQm0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NL2Dy/H5797MYAG60ka/QRXT6YPX1r0aU/F7tmSKNPnllR8F9IPws0V844TnsMe18
         OPWUgKrS17FBs/LprS2feqODU6VSMKfXo2ykEyl6osRtLLIUV43mp6LW42P4sb7eLe
         cl8MsZy8NGIQMl6cPC521YR4n77rLLzB94dFOcD/3kt6mIf44ZtX1h4di+2dVjd2Se
         DvCKdLFyXmzxb6n5cNDzZQKQk4psWL6nO+PVlEY8HX6NnDbuNa3FRy6vw/qUMN9t2U
         m3XM4WchYX+tsAxs5BgiEZVMAfXaV+zRHy2RbAIndK31G4ffS/Vw2PzOjqL4JnI4+m
         idWJqi5WuIVtA==
Date:   Tue, 22 Feb 2022 16:03:06 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220222150306.jba5v4v7cxaspivy@wittgenstein>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220222083340.GA5899@lst.de>
 <20220222102405.mmqlzimwabz7v67d@wittgenstein>
 <bdfa9081-1994-95f9-6feb-6710d34b33a1@virtuozzo.com>
 <20220222122331.ijeapomur76h7xf6@wittgenstein>
 <20220222123656.433l67bxhv3s2vbo@wittgenstein>
 <48bcd8ac-f9e5-a83c-604c-5af602cb362a@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48bcd8ac-f9e5-a83c-604c-5af602cb362a@virtuozzo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 22, 2022 at 05:54:07PM +0300, Andrey Zhadchenko wrote:
> 
> 
> On 2/22/22 15:36, Christian Brauner wrote:
> > On Tue, Feb 22, 2022 at 01:23:31PM +0100, Christian Brauner wrote:
> > > On Tue, Feb 22, 2022 at 02:19:16PM +0300, Andrey Zhadchenko wrote:
> > > > On 2/22/22 13:24, Christian Brauner wrote:
> > > > > On Tue, Feb 22, 2022 at 09:33:40AM +0100, Christoph Hellwig wrote:
> > > > > > On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> > > > > > > xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> > > > > > > bits.
> > > > > > > Unfortunately chown syscall results in different callstask:
> > > > > > > i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> > > > > > > has CAP_FSETID capable in init_user_ns rather than mntns userns.
> > > > > > 
> > > > > > Can you add an xfstests the exercises this path?
> > > > > > 
> > > > > > The fix itself looks good:
> > > > > > 
> > > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > > 
> > > > > So for anything other than directories the s{g,u}id bits are cleared on
> > > > > every chown in notify_change() by the vfs; even for the root user (Also
> > > > > documented on chown(2) manpage).
> > > > 
> > > > Only exception - chown preserves setgid bit set on a non-group-executable
> > > > file (also documented there) but do not take root privileges into account at
> > > > vfs level.
> > > > 
> > > > > 
> > > > > So the only scenario were this change would be relevant is for
> > > > > directories afaict:
> > > > > 
> > > > > 1. So ext4 has the behavior:
> > > > > 
> > > > >      ubuntu@f2-vm|~
> > > > >      > mkdir suid.dir
> > > > >      ubuntu@f2-vm|~
> > > > >      > perms ./suid.dir
> > > > >      drwxrwxr-x 775 (1000:1000) ./suid.dir
> > > > >      ubuntu@f2-vm|~
> > > > >      > chmod u+s ./suid.dir/
> > > > >      ubuntu@f2-vm|~
> > > > >      > perms ./suid.dir
> > > > >      drwsrwxr-x 4775 (1000:1000) ./suid.dir
> > > > >      ubuntu@f2-vm|~
> > > > >      > chmod g+s ./suid.dir/
> > > > >      ubuntu@f2-vm|~
> > > > >      > perms ./suid.dir
> > > > >      drwsrwsr-x 6775 (1000:1000) ./suid.dir
> > > > >      ubuntu@f2-vm|~
> > > > >      > chown 1000:1000 ./suid.dir/
> > > > >      ubuntu@f2-vm|~
> > > > >      > perms ./suid.dir/
> > > > >      drwsrwsr-x 6775 (1000:1000) ./suid.dir/
> > > > >      meaning that both s{g,u}id bits are retained for directories. (Just to
> > > > >      make this explicit: changing {g,u}id to the same {g,u}id still ends up
> > > > >      calling into the filesystem.)
> > > > > 
> > > > > 2. Whereas xfs currently has:
> > > > > 
> > > > >      brauner@wittgenstein|~
> > > > >      > mkdir suid.dir
> > > > >      brauner@wittgenstein|~
> > > > >      > perms ./suid.dir
> > > > >      drwxrwxr-x 775 ./suid.dir
> > > > >      brauner@wittgenstein|~
> > > > >      > chmod u+s ./suid.dir/
> > > > >      brauner@wittgenstein|~
> > > > >      > perms ./suid.dir
> > > > >      drwsrwxr-x 4775 ./suid.dir
> > > > >      brauner@wittgenstein|~
> > > > >      > chmod g+s ./suid.dir/
> > > > >      brauner@wittgenstein|~
> > > > >      > perms ./suid.dir
> > > > >      drwsrwsr-x 6775 ./suid.dir
> > > > >      brauner@wittgenstein|~
> > > > >      > chown 1000:1000 ./suid.dir/
> > > > >      brauner@wittgenstein|~
> > > > >      > perms ./suid.dir/
> > > > >      drwxrwxr-x 775 ./suid.dir/
> > > > >      meaning that both s{g,u}id bits are cleared for directories.
> > > > > 
> > > > > Since the vfs will always ensure that s{g,u}id bits are stripped for
> > > > > anything that isn't a directory in the vfs:
> > > > > - ATTR_KILL_S{G,U}ID is raised in chown_common():
> > > > > 
> > > > > 	if (!S_ISDIR(inode->i_mode))
> > > > > 		newattrs.ia_valid |=
> > > > > 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
> > > > > 
> > > > > - and then in notify_change() we'll get the bits stripped and ATTR_MODE
> > > > >     raised:
> > > > > 
> > > > > 	if (ia_valid & ATTR_KILL_SUID) {
> > > > > 		if (mode & S_ISUID) {
> > > > > 			ia_valid = attr->ia_valid |= ATTR_MODE;
> > > > > 			attr->ia_mode = (inode->i_mode & ~S_ISUID);
> > > > > 		}
> > > > > 	}
> > > > > 	if (ia_valid & ATTR_KILL_SGID) {
> > > > > 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
> > > > 
> > > > So SGID is not killed if there is no S_IXGRP (yet no capability check)
> > > > 
> > > > Actually I do not really understand why do kernel expects filesystems to
> > > > further apply restrictions with CAP_FSETID. Why not kill it here since we
> > > > have all info?
> > > 
> > > Some filesystems do treat the sgid behavior of directories special (some
> > > network filesystems do where they send that information to the server
> > > before updating the inode afair). So I'd rather not do that in there as
> > > we're risking breaking expectations and it's a very sensitive change.
> > > 
> > > Plus, the logic is encapsulated in the vfs generic setattr_copy() helper
> > > which nearly all filesystems call.
> > > 
> > > > 
> > > > > 			if (!(ia_valid & ATTR_MODE)) {
> > > > > 				ia_valid = attr->ia_valid |= ATTR_MODE;
> > > > > 				attr->ia_mode = inode->i_mode;
> > > > > 			}
> > > > > 			attr->ia_mode &= ~S_ISGID;
> > > > > 		}
> > > > > 	}
> > > > > 
> > > > > we can change this codepath to just mirror setattr_copy() or switch
> > > > > fully to setattr_copy() (if feasible).
> > > > > 
> > > > > Because as of right now the code seems to imply that the xfs code itself
> > > > > is responsible for stripping s{g,u}id bits for all files whereas it is
> > > > > the vfs that does it for any non-directory. So I'd propose to either try
> > > > > and switch that code to setattr_copy() or to do open-code the
> > > > > setattr_copy() check:
> 
> I did some more research on it and seems like modes are already stripped
> enough.
> 
> notify_change() -> inode->i_op->setattr() -> xfs_vn_setattr() ->
> xfs_vn_change_ok() -> prepare_setattr()
> which has the following:
>         if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
>                          i_gid_into_mnt(mnt_userns, inode)) &&
>              !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
>                  attr->ia_mode &= ~S_ISGID;
> 
> After xfs_vn_change_ok() xfs_setattr_nonsize() is finally called and
> additionally strips sgid and suid.
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 09211e1d08ad..7fda5ff3ef17 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -767,16 +767,6 @@ xfs_setattr_nonsize(
>                 gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>                 uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> 
> -               /*
> -                * CAP_FSETID overrides the following restrictions:
> -                *
> -                * The set-user-ID and set-group-ID bits of a file will be
> -                * cleared upon successful return from chown()
> -                */
> -               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> -                   !capable(CAP_FSETID))
> -                       inode->i_mode &= ~(S_ISUID|S_ISGID);
> -
>                 /*
>                  * Change the ownerships and register quota modifications
>                  * in the transaction.
> 
> 
> root@debian:/mnt/xfs# unshare -U --map-root
> root@debian:/mnt/xfs# touch testfile
> root@debian:/mnt/xfs# chmod g+s testfile
> root@debian:/mnt/xfs# ls -la testfile
> -rw-r-Sr-- 1 root root 0 Feb 22 14:46 testfile
> root@debian:/mnt/xfs# chown 0:0 testfile
> root@debian:/mnt/xfs# ls -la testfile
> -rw-r-Sr-- 1 root root 0 Feb 22 14:46 testfile
> root@debian:/mnt/xfs#
> 
> root@debian:/mnt/xfs# mkdir testdir
> root@debian:/mnt/xfs# chmod u+s testdir
> root@debian:/mnt/xfs# chmod u+g testdir
> root@debian:/mnt/xfs#
> root@debian:/mnt/xfs# ls -la
> total 4
> drwxr-xr-x 4 root root   50 Feb 22 14:47 .
> drwxr-xr-x 4 root root 4096 Feb 22 13:45 ..
> drwsr-sr-x 2 root root    6 Feb 22 14:42 test1
> drwsr-xr-x 2 root root    6 Feb 22 14:47 testdir
> -rw-r-Sr-- 1 root root    0 Feb 22 14:46 testfile
> root@debian:/mnt/xfs# chown 0:0 testdir
> root@debian:/mnt/xfs# ls -la
> total 4
> drwxr-xr-x 4 root root   50 Feb 22 14:47 .
> drwxr-xr-x 4 root root 4096 Feb 22 13:45 ..
> drwsr-sr-x 2 root root    6 Feb 22 14:42 test1
> drwsr-xr-x 2 root root    6 Feb 22 14:47 testdir
> -rw-r-Sr-- 1 root root    0 Feb 22 14:46 testfile
> 
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > > index b79b3846e71b..ff55b31521a2 100644
> > > > > --- a/fs/xfs/xfs_iops.c
> > > > > +++ b/fs/xfs/xfs_iops.c
> > > > > @@ -748,9 +748,13 @@ xfs_setattr_nonsize(
> > > > >                    * The set-user-ID and set-group-ID bits of a file will be
> > > > >                    * cleared upon successful return from chown()
> > > > >                    */
> > > > > -               if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
> > > > > -                   !capable(CAP_FSETID))
> > > > > -                       inode->i_mode &= ~(S_ISUID|S_ISGID);
> > > > > +               if (iattr->ia_valid & ATTR_MODE) {
> > > > > +                       umode_t mode = iattr->ia_mode;
> > > > > +                       if (!in_group_p(i_gid_into_mnt(mnt_userns, inode)) &&
> > > > > +                           !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
> > > > > +                               mode &= ~S_ISGID;
> > > > > +                       inode->i_mode = mode;
> > > > > +               }
> > > > > 
> > > > >                   /*
> > > > >                    * Change the ownerships and register quota modifications
> > > > > 
> > > > > which aligns xfs with ext4 and any other filesystem. Any thoughts on
> > > > > this?
> > > > > 
> > > > > For @Andrey specifically: the tests these should go into:
> > > > > 
> > > > > https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/src/idmapped-mounts/idmapped-mounts.c
> > > > > 
> > > > > Note that there are already setgid inheritance tests and set*id
> > > > > execution tests in there.
> > > > > You should be able to copy a lot of code from them. Could you please add
> > > > > the test I sketched above and ideally also a test that the set{g,u}id
> > > > > bits are stripped during chown for regular files?
> > > > Thanks for the link. To clarify what tests and result you expect:
> > > > - for directory chown we expect to preserve s{g,u}id
> > > > - for regfile chown we expect to preserve S_ISGID only if S_IXGRP is absent
> > > > and CAP_FSETID is present
> > > 
> > > So specifically for chown():
> > > 1. if regfile
> > >     -> strip suid bit unconditionally
> > >     -> strip sgid bit if inode has sgid bit and file is group-executable
> > > 2. if directory
> > >     -> strip sgid bit if inode's gid is neither among the caller's groups
> > >        nor is the caller capable wrt to that inode
> > > The behavior described in 2. is encoded in the vfs generic
> > > setattr_copy() helper. And that is what we should see.
> > > 
> > > The behavior of ext4 and btrfs is what we should see afaict as both use
> > > setattr_copy().
> > > 
> > > > 
> > > > JFYI: I found out this problem while running LTP (specifically
> > > > syscalls/chown02 test) on idmapped XFS. Maybe I will be able to find more,
> > > > who knows.
> > > 
> > > Hm, if you look above, then you can see that the failure (or difference
> > > in behavior) you're reporting is independent of idmapped mounts. An
> > > ext4 directory shows different behavior than an xfs directory on a
> > > regular system without any idmapped mounts used. So I'm not clear how
> > > that's specifically related to idmapped mounts yet.
> 
> I guess my commit message is pretty poor. Initially I found out that chown()
> on idmapped xfs (+userns) drops sgid unconditionally on regfiles. I did not
> thought about directories at all. It is good that you pointed it out.
> The problem is indeed independent from idmapping. However I thought this
> belonged to it since most of the checks were updated with idmapped series.
> Thanks for the explanation

No, not at all. It's perfectly fine to not know all the details right of
the bat! Thank your for bringing this up so I could take a closer look
at this.

> 
> > 
> > So for example, in order to cause the sgid bit stripped while it should
> > be preserved if xfs were to use setattr_copy() I can simply do:
> > 
> > brauner@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> > > unshare -U --map-root
> > root@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> > > PATH=$PATH:$PWD ./chown02
> > tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> > tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> > chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> > chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> > chown02.c:57: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700
> > 
> > Summary:
> > passed   2
> > failed   1
> > broken   0
> > skipped  0
> > warnings 1
> > 
> > There's no idmapped mounts here in play. The caller simply has been
> > placed in a new user namespace and thus they fail the current
> > capable(CAP_FSETID) check which will cause xfs to strip the sgid bit >
> > Now trying the same with ext4:
> > 
> > ubuntu@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown$ unshare -U --map-root
> > root@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown# PATH=$PATH:$PWD ./chown02
> > tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> > tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> > chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> > chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> > 
> > Summary:
> > passed   2
> > failed   0
> > broken   0
> > skipped  0
> > warnings 1
> > 
> > it passes since ext4 uses setattr_copy() and thus the capability is
> > checked for in the caller's user namespace.
> > 
> > > 
> > > Fwiw, one part in your commit message is a bit misleading:
> > > 
> > > > > > > has CAP_FSETID capable in init_user_ns rather than mntns userns.
> > > 
> > > that's not what capable_wrt_to_inode_uidgid() does. What it does is to
> > > check whether the caller is capable in their current user namespace.
> > > That's how capable_wrt_to_inode_uidgid() has always worked.
> > > The mnt_userns is only used to idmap the inode's {g,u}id. So if the
> > > caller has CAP_FSETID in its current userns and the inode's {g,u}id have
> > > a valid mapping in the mnt's userns the caller is considered privileged
> > > over that inode.
> > > 
> 
