Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11D4C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 22:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbiKNW7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237504AbiKNW7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 17:59:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D302E186CF
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 14:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5537A6148C
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 22:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1BCC433D6;
        Mon, 14 Nov 2022 22:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668466742;
        bh=SmMuCB0JHc0igm/TouZK0Hb/BMm4h5DxJMoR8u+Kl84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gIB8/W9vdripWxwBfRmryX6Uhtu6OBJrnAJxZJ49LtPsn32a+Y2fMq0EUP8CNeqDB
         CLcuVZ9jgMAXFMxU8Y4gjC790ko0mv406SpGblJ15IRsIK3TlQLyj5BNunDbGY7pwO
         yHz7qRWOG0ufGJhMuxeRXAwrmmGVjXdc0C4BU5GRpn6cq/aafKfal/YKqcnZBGXLDH
         cnGIUzxrW306Kcfyclvj8Ui5PH66zAKYuQslKJMo9KhTetsN2SHMw7jtM0uUrYd433
         e3sXJjeHeEfwFKMf8rQEN+qv+wBMu6G8Q1wwERqP9D438h6B72TrVEyutGScjHwfz1
         QHcvZWSjbgjUg==
Date:   Mon, 14 Nov 2022 14:59:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Joseph Qi <jiangqi903@gmail.com>
Cc:     Srikanth C S <srikanth.c.s@oracle.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com, david@fromorbit.com
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y3LINrI4HbuxjRn+@magnolia>
References: <20221104061011.4063-1-srikanth.c.s@oracle.com>
 <190cba7f-30a0-4eb3-6587-5b42d7251868@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <190cba7f-30a0-4eb3-6587-5b42d7251868@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 11, 2022 at 02:24:25PM +0800, Joseph Qi wrote:
> Hi，
> 
> On 11/4/22 2:10 PM, Srikanth C S wrote:
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
> > +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
> > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> > +               else
> > +                       mount $DEV /tmp/repair_mnt || exit 1
> > +               fi
> 
> If do normal boot, it will try to mount according to fstab.
> So in the crash case you've described, it seems that it can't mount
> successfully? Or am I missing something?

Yes, we're assuming that support has injected the magic command lines
into the bootloader to trigger xfs_repair after boot failed due to a
bad/corrupt rootfs.

--D

> Thanks,
> Joseph
> 
> > +               umount /tmp/repair_mnt
> > +               xfs_repair -e $DEV
> > +               error=$?
> > +               rm -d /tmp/repair_mnt
> > +       fi
> > +       repair2fsck_code $error
> >         exit $?
> >  fi
> >  
