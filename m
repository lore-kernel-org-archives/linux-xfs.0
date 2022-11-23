Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C0BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 12:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiKWMX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbiKWMXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 07:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089342C650
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 04:23:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A79EBB81EEE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 12:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8C7C433D7;
        Wed, 23 Nov 2022 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669206190;
        bh=k7fHURteY1DtOrudoK6RVs8G3ouUJL9N7o/IrIZ+FNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cln6LSyyQXH/+6BUCWnppsjYfKtbfxIAfx1aJn6MbZoBX85LuhwsMlLThNqZngLOS
         /bLMOdX70VZK3Vu0zFSd8hEizxg94MrUxC/CHEtCdQrVhKqAoNNM+HQCIoqgnfDVn5
         7KEaWYRBcEZDjs4TBQaaKw4XWLLS2oElM4qXNDaW9dSFbGumM39Batt6x/FbR15BZN
         N7tf5QXk0RF5FHZ//u1g4vyDeUGU0e4YFvuFjYqP2IPhsRwMnjBbGf2sxcyhCqkjQw
         buBMx7NaW9lRqmW14egWn7PpZG4U9qVg7MpFDvL4CrZ1lPfzhNRuhv3s3fYFyRIN6V
         tycm3hczJkxgg==
Date:   Wed, 23 Nov 2022 13:23:05 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Message-ID: <20221123122305.oht2bspxqb6ndnlm@andromeda>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221123083636.el5fivqey5qmx6ie@andromeda>
 <c-vuqhpmmrL6JSN0ZRnqX7c1BUcXw5gJ9L2UZ2lG3H8hCJRNIn_uan2rVHLDUPwgY24Nv3WZpiBt2nflhVadtA==@protonmail.internalid>
 <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 23, 2022 at 11:40:53AM +0000, Srikanth C S wrote:
>    Hi
> 
>    I resent the same patch as I did not see any review comments.

Unless I'm looking at the wrong patch, there were comments on your previous
submission:

https://lore.kernel.org/linux-xfs/Y2ie54fcHDx5bcG4@B-P7TQMD6M-0146.local/T/#t

Am I missing something?

Also, if you are sending the same patch, you can 'flag' it as a resend, so, it's
easier to identify you are simply resending the same patch. You can do it by
appending/prepending 'RESEND', to the patch tag:

[RESEND PATCH] <subject>

Cheers.

> 
>    -Srikanth
>      __________________________________________________________________
> 
>    From: Carlos Maiolino <cem@kernel.org>
>    Sent: Wednesday, November 23, 2022 2:06 PM
>    To: Srikanth C S <srikanth.c.s@oracle.com>
>    Cc: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>; Darrick Wong
>    <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
>    <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi
>    <junxiao.bi@oracle.com>; david@fromorbit.com <david@fromorbit.com>
>    Subject: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
>    replay log before running xfs_repair
> 
>    Hi.
>    Did you plan to resend V3 again, or is this supposed to be V4?
>    On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
>    > After a recent data center crash, we had to recover root filesystems
>    > on several thousands of VMs via a boot time fsck. Since these
>    > machines are remotely manageable, support can inject the kernel
>    > command line with 'fsck.mode=force fsck.repair=yes' to kick off
>    > xfs_repair if the machine won't come up or if they suspect there
>    > might be deeper issues with latent errors in the fs metadata, which
>    > is what they did to try to get everyone running ASAP while
>    > anticipating any future problems. But, fsck.xfs does not address the
>    > journal replay in case of a crash.
>    >
>    > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
>    > possible that when the machine crashes, the fs is in inconsistent
>    > state with the journal log not yet replayed. This can drop the
>    machine
>    > into the rescue shell because xfs_fsck.sh does not know how to clean
>    the
>    > log. Since the administrator told us to force repairs, address the
>    > deficiency by cleaning the log and rerunning xfs_repair.
>    >
>    > Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
>    > Replay the logs only if fsck.mode=force and fsck.repair=yes. For
>    > other option -fa and -f drop to the rescue shell if repair detects
>    > any corruptions.
>    >
>    > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
>    > ---
>    >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
>    >  1 file changed, 29 insertions(+), 2 deletions(-)
>    >
>    > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
>    > index 6af0f22..62a1e0b 100755
>    > --- a/fsck/xfs_fsck.sh
>    > +++ b/fsck/xfs_fsck.sh
>    > @@ -31,10 +31,12 @@ repair2fsck_code() {
>    >
>    >  AUTO=false
>    >  FORCE=false
>    > +REPAIR=false
>    >  while getopts ":aApyf" c
>    >  do
>    >         case $c in
>    > -       a|A|p|y)        AUTO=true;;
>    > +       a|A|p)          AUTO=true;;
>    > +       y)              REPAIR=true;;
>    >         f)              FORCE=true;;
>    >         esac
>    >  done
>    > @@ -64,7 +66,32 @@ fi
>    >
>    >  if $FORCE; then
>    >         xfs_repair -e $DEV
>    > -       repair2fsck_code $?
>    > +       error=$?
>    > +       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
>    > +               echo "Replaying log for $DEV"
>    > +               mkdir -p /tmp/repair_mnt || exit 1
>    > +               for x in $(cat /proc/cmdline); do
>    > +                       case $x in
>    > +                               root=*)
>    > +                                       ROOT="${x#root=}"
>    > +                               ;;
>    > +                               rootflags=*)
>    > +                                       ROOTFLAGS="-o
>    ${x#rootflags=}"
>    > +                               ;;
>    > +                       esac
>    > +               done
>    > +               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
>    > +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
>    > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit
>    1
>    > +               else
>    > +                       mount $DEV /tmp/repair_mnt || exit 1
>    > +               fi
>    > +               umount /tmp/repair_mnt
>    > +               xfs_repair -e $DEV
>    > +               error=$?
>    > +               rm -d /tmp/repair_mnt
>    > +       fi
>    > +       repair2fsck_code $error
>    >         exit $?
>    >  fi
>    >
>    > --
>    > 1.8.3.1
>    --
>    Carlos Maiolino

-- 
Carlos Maiolino
