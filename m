Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF78C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 17:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245134AbiCJRfz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 12:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245139AbiCJRfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 12:35:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4032318FAE7
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 09:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 733B361DF6
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 17:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CF0C340E8;
        Thu, 10 Mar 2022 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646933690;
        bh=4SNPQETx9GVsxvP1Nl5RQxIESo9hNMbgG0ZbLnpix28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kcw0gCuvQ+CWD77dFfK3gu6ObAtTgaGWJtb82H3F6yTAJbcwNbBzBRp17JO002Euj
         bw2aRz7xvlU4vjDlaI0U4+cbrY2lp18l0Up5N+0trIFnea45nmI8WsDhK+Hrw37Bs8
         LCgTQ6uJl87raZww1FdGiBOt58vbLpfaljeXmu7vDxNW3YeyR/wyU/91IhoiOX0nRr
         W3mSWDIKdsn4rmyu4mceX5pPUwAv+24Gu1tX+TzbRQVa9ilfAAY+By7yX2642Cb6WB
         hmjUhh83yl8ew/WEA0PhIlTe7JaGuaRefWsr4DGcsngj38xo5Be+zOeTd3zGwRxakc
         gf4XWNApUsx0g==
Date:   Thu, 10 Mar 2022 09:34:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: use setattr_copy to set vfs inode attributes
Message-ID: <20220310173450.GI8224@magnolia>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
 <164685373184.495833.7593050602112292799.stgit@magnolia>
 <20220310101158.atqf7grb2qz7a73o@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310101158.atqf7grb2qz7a73o@wittgenstein>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 11:11:58AM +0100, Christian Brauner wrote:
> On Wed, Mar 09, 2022 at 11:22:11AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> > revocation isn't consistent with btrfs[1] or ext4.  Those two
> > filesystems use the VFS function setattr_copy to convey certain
> > attributes from struct iattr into the VFS inode structure.
> > 
> > Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> > decide if it should clear setgid and setuid on a file attribute update.
> > This is a second symptom of the problem that Filipe noticed.
> > 
> > XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> > xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> > /not/ a simple copy function; it contains additional logic to clear the
> > setgid bit when setting the mode, and XFS' version no longer matches.
> > 
> > The VFS implements its own setuid/setgid stripping logic, which
> > establishes consistent behavior.  It's a tad unfortunate that it's
> > scattered across notify_change, should_remove_suid, and setattr_copy but
> > XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> > functions and get rid of the old functions.
> > 
> > [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> > 
> > Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> 
> Fwiw, as I've pointed out in
> https://lore.kernel.org/linux-xfs/20220222122331.ijeapomur76h7xf6@wittgenstein/
> the original analysis that this commit message links to in [2] is not
> correct. But the thread clarifies it so I think it's fine.
> 
> But I think the fixes tag is wrong here afaict. As I've pointed out in
> https://lore.kernel.org/linux-xfs/20220222123656.433l67bxhv3s2vbo@wittgenstein/
> the faulty behavior should predate idmapped mounts by a lot. The bug is
> with capable(CAP_FSETID). A simple reproducer that should work on any
> pre 5.12 kernel is:
> 
> brauner@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> > unshare -U --map-root
> root@wittgenstein|~/src/git/linux/ltp/testcases/kernel/syscalls/chown|master %=
> > PATH=$PATH:$PWD ./chown02
> tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> chown02.c:57: TFAIL: testfile2: wrong mode permissions 0100700, expected 0102700
> 
> Summary:
> passed   2
> failed   1
> broken   0
> skipped  0
> warnings 1
> 
> There's no idmapped mounts here in play. The caller simply has been
> placed in a new user namespace and thus they fail the current
> capable(CAP_FSETID) check which will cause xfs to strip the sgid bit.
> 
> Now trying the same with ext4:
> 
> ubuntu@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown$ unshare -U --map-root
> root@f2-vm:~/src/git/linux/ltp/testcases/kernel/syscalls/chown# PATH=$PATH:$PWD ./chown02
> tst_memutils.c:157: TWARN: Can't adjust score, even with capabilities!?
> tst_test.c:1455: TINFO: Timeout per run is 0h 05m 00s
> chown02.c:45: TPASS: chown(testfile1, 0, 0) passed
> chown02.c:45: TPASS: chown(testfile2, 0, 0) passed
> 
> Summary:
> passed   2
> failed   0
> broken   0
> skipped  0
> warnings 1
> 
> it passes since ext4 uses setattr_copy() and thus the capability is
> checked for in the caller's user namespace.

Hmm.  The last person to touch the ATTR_MODE part of setattr_copy was
you, back in January 2021:

2f221d6f7b88 ("attr: handle idmapped mounts")

though I think that was merely switching the user_ns parameter to
inode_capable_wrt_uidgid.  The previous major change was made by Andy
Lutomirski in 2014:

23adbe12ef7d ("fs,userns: Change inode_capable to capable_wrt_inode_uidgid")

This seems to be the start(?) of the "_wrt_inode_uidgid" variants,
though I think the only real change in behavior was checking that the
inode's gid is mapped in the current userns?  Going back even further,
it looks like Eric Biederman started thsi whole process in 2012 with:

7fa294c8991c ("userns: Allow chown and setgid preservation")

This patch switched the VFS from purely checking process capabilities to
checking the privileges of the userns, I think.  From a purely code
inspection perspective, this is where the behavior divergence between
XFS and VFS began.

I'm ok with switching the fixes tag to 7fa294, though I won't be shocked
if this patch doesn't apply cleanly to fs/xfs/ from that era.

Thanks for the review!

<rant>
That said, I now have this bad habit of picking more recent commits for
Fixes because I get so much blowback from the stable maintainers it's
not worth any of the frustration.

I *do* still agree with the principle that a fixpatch should reference
the exact moment things went wrong, even if some autobackport bot can't
trivially apply the patch!

I fully expect to get complaints from the LTS maintainers like I always
do when I attach a Fixes tag without throughly compile-testing every LTS
branch between the tag and HEAD.  They clearly haven't taken any of my
hints, so I'll just say it: I DON'T HAVE TIME TO QA ANYTHING OTHER THAN
UPSTREAM!  Six LTS kernels (plus 3 distro kernels) will eat a week and a
half of time on the testing cloud, **per fix**.

Hell, you all have probably noticed: I haven't had sufficient mental
spoons to do much of anything with upstream, so there is no 5.18 merge
branch and reviews are getting sloppier.
</rant>

--D

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Other than the wrong Fixes:,
> Reviewed-by: Christian Brauner <brauner@kernel.org>
