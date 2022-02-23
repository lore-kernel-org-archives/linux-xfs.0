Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA813C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 08:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238707AbiBWIM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Feb 2022 03:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiBWIM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Feb 2022 03:12:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E07236305
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 00:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D34B81E7F
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 08:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F28EC340E7;
        Wed, 23 Feb 2022 08:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645603917;
        bh=jOTU+dGSJoWq0NNRtf77UVHIOJSgKKpvQOLINbx8TDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KoL0A540cBhlPpxA8+enCBTrMjaG3svs1aEmImDRedfRMQL0AR2f7VxgES6qP2tXc
         P9A0K7TABPYOtXP4p2cIIOivAZOHLljweAD2DhIeonAh+t2EVStRrqkBD4fTIiJNj4
         YrqMaOxQLpo6HH9/8SuAZTnMhl5QRB6x6nkVEP2+4FInx9UUU1Mh/xLZ8Z3ddte59z
         mhEGC8ykW2RRAHy6W8uNv1Vlxipw/+MAPVkqnvCSmr2yLU1lUVH4+vQ7e92zGxTNn3
         RSqdjP6xRRLWx2WHPr3hoys0J2ejTBMNSkwJUIi1soKp/zTXqktG7BcQ/Q96uc3cME
         juUSICUKCU3tA==
Date:   Wed, 23 Feb 2022 09:11:52 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220223081152.m2vddhq7znmjhabd@wittgenstein>
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

Ok, good. Can you send a patch that removes this code and add the tests
we talked about? That would be great!

Thanks!
Christian
