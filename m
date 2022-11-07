Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E022C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 16:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiKGQzw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 11:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbiKGQzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 11:55:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062EA21E3C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 08:55:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CA0611C6
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 16:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DDFC433C1;
        Mon,  7 Nov 2022 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667840147;
        bh=wffLabiKC+0JoV02ZMLMYqhUkl34fI36oEiz5YPNMWY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=sENUZ8TedeqEj+uoRdZ0ZlZSkdg5rOu1zWtkm6ahJgrzGHZu4fJNTHcAvQHmraKyV
         f4JxszjVMKR7/JFRSnHfKUMHSz26NSKFhq7A+0sJjyXb25Yme1weMjPQorYAUVze0R
         xIDl9gYJe1Cuu2ZJExd7L5wA1I83m3IOvmfEuQlW78SEoA3PD+qiML97zkRhLHzYkk
         nYMNlJ6M1VLOZgk1ynCTWPWcuNxirco/sH91WLIoQvuSdy1f8E2LSQy2tajSF2KMQH
         Yvo/dlNtgLdLKWMne65aUcaxjVhRtRK3R7MS0QeuWmfI5QqOXhFuxjowytD/ykohJf
         SiY2Gx8mtgHDQ==
Date:   Mon, 7 Nov 2022 08:55:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>, darrick.wong@oracle.com,
        david@fromorbit.com, linux-xfs@vger.kernel.org,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y2k4kwWg2UObmfqN@magnolia>
References: <20221104061011.4063-1-srikanth.c.s@oracle.com>
 <Y2ie54fcHDx5bcG4@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2ie54fcHDx5bcG4@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 02:00:07PM +0800, Gao Xiang wrote:
> Hi folks,
> 
> On Fri, Nov 04, 2022 at 11:40:11AM +0530, Srikanth C S wrote:
> > After a recent data center crash, we had to recover root filesystems
> > on several thousands of VMs via a boot time fsck. Since these
> > machines are remotely manageable, support can inject the kernel
> > command line with 'fsck.mode=force fsck.repair=yes' to kick off
> > xfs_repair if the machine won't come up or if they suspect there
> > might be deeper issues with latent errors in the fs metadata, which
> > is what they did to try to get everyone running ASAP while
> > anticipating any future problems. But, fsck.xfs does not address the
> > journal replay in case of a crash.
> > 
> > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> > possible that when the machine crashes, the fs is in inconsistent
> > state with the journal log not yet replayed. This can drop the machine
> > into the rescue shell because xfs_fsck.sh does not know how to clean the
> > log. Since the administrator told us to force repairs, address the
> > deficiency by cleaning the log and rerunning xfs_repair.
> > 
> > Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> > Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> > other option -fa and -f drop to the rescue shell if repair detects
> > any corruptions.
> > 
> > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > ---
> >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> >  1 file changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > index 6af0f22..62a1e0b 100755
> > --- a/fsck/xfs_fsck.sh
> > +++ b/fsck/xfs_fsck.sh
> > @@ -31,10 +31,12 @@ repair2fsck_code() {
> >  
> >  AUTO=false
> >  FORCE=false
> > +REPAIR=false
> >  while getopts ":aApyf" c
> >  do
> >         case $c in
> > -       a|A|p|y)        AUTO=true;;
> > +       a|A|p)          AUTO=true;;
> > +       y)              REPAIR=true;;
> >         f)              FORCE=true;;
> >         esac
> >  done
> > @@ -64,7 +66,32 @@ fi
> >  
> >  if $FORCE; then
> >         xfs_repair -e $DEV
> > -       repair2fsck_code $?
> > +       error=$?
> > +       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
> > +               echo "Replaying log for $DEV"
> > +               mkdir -p /tmp/repair_mnt || exit 1
> > +               for x in $(cat /proc/cmdline); do
> > +                       case $x in
> > +                               root=*)
> > +                                       ROOT="${x#root=}"
> > +                               ;;
> > +                               rootflags=*)
> > +                                       ROOTFLAGS="-o ${x#rootflags=}"
> > +                               ;;
> > +                       esac
> > +               done
> > +               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
> 
> We'd also like to get a formal solution about this for our production
> so that xfs_repair can work properly with log recovery.

My preferred solution is to port the log recovery code to userspace, and
then train xfs_repair to invoke it.  Handling the trivial case where
xfs_repair can recover logs created on the same platform as the support
script wouldn't be that hard (I think?) because log recovery is fairly
selfcontained nowadays.

But.

Inevitably someone will suggest fixing the kernel's inability to recover
a log from a platform with a different endianness, which will lead to a
discussion of making the ondisk log format endian safe.  Someone else
may also ask why not make userspace xfs_trans transactional, and... ;)

(All those extra asks are ok, but anyone taking on these task sets
should make it /very/ clear where the scope of each set begins and ends,
and in which order they'll be worked on.)

> However, may I ask if it's the preferred way to implement this which
> just acts as another mount-unmount cycle, since I'm not sure if there
> are some customized initramfs-es which could get the fs busy so that it
> won't unmount properly.

Seeing as initramfses are only supposed to turn on enough hardware so
that mount can find the root volume, I really hope there aren't
*background services* running here.

> Alternatively, do we consider another way like exporting the log
> recovery functionality with ioctl() so that log recovery can work
> without the actual fs mounting? Is it affordable?

I guess you could create a 'recoveryonly' mount option that would abort
the mount after recovering the log.  I'm not really a fan of that
approach.

--D

> Thanks,
> Gao Xiang
> 
> > +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
> > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> > +               else
> > +                       mount $DEV /tmp/repair_mnt || exit 1
> > +               fi
> > +               umount /tmp/repair_mnt
> > +               xfs_repair -e $DEV
> > +               error=$?
> > +               rm -d /tmp/repair_mnt
> > +       fi
> > +       repair2fsck_code $error
> >         exit $?
> >  fi
> >  
> > -- 
> > 1.8.3.1
> > 
