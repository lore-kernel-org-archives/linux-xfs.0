Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC73DC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 17:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiKGRYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 12:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiKGRYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 12:24:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936651DDCF
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 09:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E6A2B81604
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 17:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B563CC433D7;
        Mon,  7 Nov 2022 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667841878;
        bh=PgIHm60p+5gngTXSC2WqvsOAmcVDobf8Ra8YdAKBrh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BYur8i3oh+Vx0JEym3SJq67d9+hQf/mrkGg/D718E69h29VbXR6XvLJ/VvSp9YdHr
         5XRj2mVzqKKjoH+o9q58An5fPGut/S4kcaP5ngRNETzWTPlHJKmyGjO5yWo70Et+ni
         gDxO9/Zgj34egxGrFEHZXrke2ZXNotJxpXDHoKbPW6uaR9G/XiQG4JaO0PX/BpHOmd
         XKd9jS9GZM/HI7j7XCQCjiz7Xl/Dceil0nxuI4rb+QuHvnucKdBEGnSCphi6NDQgAK
         k04iWXo8nAlGFm2gqqfcJydkpEJExhrbZCaD0++5/bMZdlZPycOJy3F3Q5uIp7GiBu
         nHgLrcXC0UhmQ==
Date:   Tue, 8 Nov 2022 01:24:22 +0800
From:   Gao Xiang <xiang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Srikanth C S <srikanth.c.s@oracle.com>, darrick.wong@oracle.com,
        david@fromorbit.com, linux-xfs@vger.kernel.org,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y2k/Rl59q+S6IFFC@debian>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>, darrick.wong@oracle.com,
        david@fromorbit.com, linux-xfs@vger.kernel.org,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20221104061011.4063-1-srikanth.c.s@oracle.com>
 <Y2ie54fcHDx5bcG4@B-P7TQMD6M-0146.local>
 <Y2k4kwWg2UObmfqN@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2k4kwWg2UObmfqN@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Mon, Nov 07, 2022 at 08:55:47AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 07, 2022 at 02:00:07PM +0800, Gao Xiang wrote:
> > Hi folks,
> > 
> > On Fri, Nov 04, 2022 at 11:40:11AM +0530, Srikanth C S wrote:
> > > After a recent data center crash, we had to recover root filesystems
> > > on several thousands of VMs via a boot time fsck. Since these
> > > machines are remotely manageable, support can inject the kernel
> > > command line with 'fsck.mode=force fsck.repair=yes' to kick off
> > > xfs_repair if the machine won't come up or if they suspect there
> > > might be deeper issues with latent errors in the fs metadata, which
> > > is what they did to try to get everyone running ASAP while
> > > anticipating any future problems. But, fsck.xfs does not address the
> > > journal replay in case of a crash.
> > > 
> > > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> > > possible that when the machine crashes, the fs is in inconsistent
> > > state with the journal log not yet replayed. This can drop the machine
> > > into the rescue shell because xfs_fsck.sh does not know how to clean the
> > > log. Since the administrator told us to force repairs, address the
> > > deficiency by cleaning the log and rerunning xfs_repair.
> > > 
> > > Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> > > Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> > > other option -fa and -f drop to the rescue shell if repair detects
> > > any corruptions.
> > > 
> > > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > > ---
> > >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> > >  1 file changed, 29 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > > index 6af0f22..62a1e0b 100755
> > > --- a/fsck/xfs_fsck.sh
> > > +++ b/fsck/xfs_fsck.sh
> > > @@ -31,10 +31,12 @@ repair2fsck_code() {
> > >  
> > >  AUTO=false
> > >  FORCE=false
> > > +REPAIR=false
> > >  while getopts ":aApyf" c
> > >  do
> > >         case $c in
> > > -       a|A|p|y)        AUTO=true;;
> > > +       a|A|p)          AUTO=true;;
> > > +       y)              REPAIR=true;;
> > >         f)              FORCE=true;;
> > >         esac
> > >  done
> > > @@ -64,7 +66,32 @@ fi
> > >  
> > >  if $FORCE; then
> > >         xfs_repair -e $DEV
> > > -       repair2fsck_code $?
> > > +       error=$?
> > > +       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
> > > +               echo "Replaying log for $DEV"
> > > +               mkdir -p /tmp/repair_mnt || exit 1
> > > +               for x in $(cat /proc/cmdline); do
> > > +                       case $x in
> > > +                               root=*)
> > > +                                       ROOT="${x#root=}"
> > > +                               ;;
> > > +                               rootflags=*)
> > > +                                       ROOTFLAGS="-o ${x#rootflags=}"
> > > +                               ;;
> > > +                       esac
> > > +               done
> > > +               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
> > 
> > We'd also like to get a formal solution about this for our production
> > so that xfs_repair can work properly with log recovery.
> 
> My preferred solution is to port the log recovery code to userspace, and
> then train xfs_repair to invoke it.  Handling the trivial case where
> xfs_repair can recover logs created on the same platform as the support
> script wouldn't be that hard (I think?) because log recovery is fairly
> selfcontained nowadays.
> 

Yeah, my preferred way is also that it could be done like this, but
sadly in practice currently such ROI is low (considering only a small
number of ECS uses XFS at Alibaba Cloud..)

So.. Hopefully I could promote XFS first so we could have more manpower
and take more time on XFS ;)

> But.
> 
> Inevitably someone will suggest fixing the kernel's inability to recover
> a log from a platform with a different endianness, which will lead to a
> discussion of making the ondisk log format endian safe.  Someone else
> may also ask why not make userspace xfs_trans transactional, and... ;)
> 

Yeah, actually I talked with Eric two years ago about this.  The
log format endianness is still in a mess.  Yeah... You're right.

> (All those extra asks are ok, but anyone taking on these task sets
> should make it /very/ clear where the scope of each set begins and ends,
> and in which order they'll be worked on.)

Currently the part of my job is to aim at stablizing XFS first in order
to promote XFS to our production.  At least reflink with good performance
is somewhat a killer combination for the Cloud providers like us ;)

> 
> > However, may I ask if it's the preferred way to implement this which
> > just acts as another mount-unmount cycle, since I'm not sure if there
> > are some customized initramfs-es which could get the fs busy so that it
> > won't unmount properly.
> 
> Seeing as initramfses are only supposed to turn on enough hardware so
> that mount can find the root volume, I really hope there aren't
> *background services* running here.

Although it's much like impossible, from stability POV, I'm not sure
if some unusual users could behave like this. At least, it's currently
one of our concerns if it just acts as a mount-unmount cycle as a public
cloud provider.

> 
> > Alternatively, do we consider another way like exporting the log
> > recovery functionality with ioctl() so that log recovery can work
> > without the actual fs mounting? Is it affordable?
> 
> I guess you could create a 'recoveryonly' mount option that would abort
> the mount after recovering the log.  I'm not really a fan of that
> approach.

I'm not quite such fan to introduce a weird mount option too.  We
might evaluate such way internally as well, but if upstream prefers a
full mount-unmount cycle, I guess we will finally follow it.

Thank a lot,
Gao Xiang

> 
> --D
> 
