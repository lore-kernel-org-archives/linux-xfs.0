Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2BCC4321E
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 23:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiK1XEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiK1XEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 18:04:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E122B249
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 15:04:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC9DC61416
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 23:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E6DC433D6;
        Mon, 28 Nov 2022 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669676661;
        bh=ZSx9ZmtGciVASJKC6sfhG5nCUqOoj6WOIe3shtTdi64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3uzYxDaDolkJEdMHkaSYD6PNt7EP5GKG9uNxw1oyEDj5xRsrkcan2D6fgtg9hYPU
         QMiV7fGH4Cpz0UaYY1eEF/jOWmFbS98BtX9Wp5/fXaumYLhMU5hL39Gu7YtjBU0YKL
         soAS6F+z3sBX3WC8+FwCieoPyuXI8C7SI+a30NNPkMQzCw0ant31oSWo6PP+KZzSEw
         At7EVogKKs4GXNcdd1z1qNeIxLgLxQLbV02DnyO4AXT+7RYVX83YyRzeRLB+kZaijq
         wdfAjNYoCcjUoplhUhecKZPfqal7Jw+m9U7LzYF53eymPkBpuX4j3Tz5R+wPEZ1ire
         i3aBEtNHf6wYQ==
Date:   Mon, 28 Nov 2022 15:04:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     Carlos Maiolino <cem@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Message-ID: <Y4U+dDlv2ylHApxo@magnolia>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221123083636.el5fivqey5qmx6ie@andromeda>
 <c-vuqhpmmrL6JSN0ZRnqX7c1BUcXw5gJ9L2UZ2lG3H8hCJRNIn_uan2rVHLDUPwgY24Nv3WZpiBt2nflhVadtA==@protonmail.internalid>
 <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
 <20221123122305.oht2bspxqb6ndnlm@andromeda>
 <MWHPR10MB148619277A997E1D8A715257A30E9@MWHPR10MB1486.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR10MB148619277A997E1D8A715257A30E9@MWHPR10MB1486.namprd10.prod.outlook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 25, 2022 at 12:09:39PM +0000, Srikanth C S wrote:
> 
> 
> > -----Original Message-----
> > From: Carlos Maiolino <cem@kernel.org>
> > Sent: 23 November 2022 05:53 PM
> > To: Srikanth C S <srikanth.c.s@oracle.com>
> > Cc: linux-xfs@vger.kernel.org; Darrick Wong <darrick.wong@oracle.com>;
> > Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>;
> > Junxiao Bi <junxiao.bi@oracle.com>; david@fromorbit.com
> > Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
> > replay log before running xfs_repair
> > 
> > On Wed, Nov 23, 2022 at 11:40:53AM +0000, Srikanth C S wrote:
> > >    Hi
> > >
> > >    I resent the same patch as I did not see any review comments.
> > 
> > Unless I'm looking at the wrong patch, there were comments on your
> > previous
> > submission:
> > 
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-
> > xfs/Y2ie54fcHDx5bcG4@B-P7TQMD6M-
> > 0146.local/T/*t__;Iw!!ACWV5N9M2RV99hQ!J2Z-
> > 2NThyyDm__z9ivhioF9QoHsaHh4Tk733jtNbVMPGeA2vbmbw3h4ZGxOywQF
> > v_lA1Zs_jsUgr$
> > 
> > Am I missing something?

Err.... whose comments, Joseph's or Gao's?

> All the previous comments addressing this patch were about having
> journal replay code in the userspace. But Darricks comments indicate
> that this requires making the log endian safe because of kernel's
> inability to recover a log from a platform with a different
> endianness.
> 
> So I am still wondering on how to proceed with this patch. Any
> comments would be helpful.

Same here, though the long holiday weekend probably didn't help.

--D

> > Also, if you are sending the same patch, you can 'flag' it as a resend, so, it's
> > easier to identify you are simply resending the same patch. You can do it by
> > appending/prepending 'RESEND', to the patch tag:
> > 
> > [RESEND PATCH] <subject>
> Thanks for the info. Didn't know this.
> > 
> > Cheers.
> > 
> > >
> > >    -Srikanth
> > >
> > >
> > __________________________________________________________
> > ________
> > >
> > >    From: Carlos Maiolino <cem@kernel.org>
> > >    Sent: Wednesday, November 23, 2022 2:06 PM
> > >    To: Srikanth C S <srikanth.c.s@oracle.com>
> > >    Cc: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>; Darrick Wong
> > >    <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
> > >    <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi
> > >    <junxiao.bi@oracle.com>; david@fromorbit.com
> > <david@fromorbit.com>
> > >    Subject: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
> > >    replay log before running xfs_repair
> > >
> > >    Hi.
> > >    Did you plan to resend V3 again, or is this supposed to be V4?
> > >    On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
> > >    > After a recent data center crash, we had to recover root filesystems
> > >    > on several thousands of VMs via a boot time fsck. Since these
> > >    > machines are remotely manageable, support can inject the kernel
> > >    > command line with 'fsck.mode=force fsck.repair=yes' to kick off
> > >    > xfs_repair if the machine won't come up or if they suspect there
> > >    > might be deeper issues with latent errors in the fs metadata, which
> > >    > is what they did to try to get everyone running ASAP while
> > >    > anticipating any future problems. But, fsck.xfs does not address the
> > >    > journal replay in case of a crash.
> > >    >
> > >    > fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> > >    > possible that when the machine crashes, the fs is in inconsistent
> > >    > state with the journal log not yet replayed. This can drop the
> > >    machine
> > >    > into the rescue shell because xfs_fsck.sh does not know how to clean
> > >    the
> > >    > log. Since the administrator told us to force repairs, address the
> > >    > deficiency by cleaning the log and rerunning xfs_repair.
> > >    >
> > >    > Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> > >    > Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> > >    > other option -fa and -f drop to the rescue shell if repair detects
> > >    > any corruptions.
> > >    >
> > >    > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> > >    > ---
> > >    >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> > >    >  1 file changed, 29 insertions(+), 2 deletions(-)
> > >    >
> > >    > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > >    > index 6af0f22..62a1e0b 100755
> > >    > --- a/fsck/xfs_fsck.sh
> > >    > +++ b/fsck/xfs_fsck.sh
> > >    > @@ -31,10 +31,12 @@ repair2fsck_code() {
> > >    >
> > >    >  AUTO=false
> > >    >  FORCE=false
> > >    > +REPAIR=false
> > >    >  while getopts ":aApyf" c
> > >    >  do
> > >    >         case $c in
> > >    > -       a|A|p|y)        AUTO=true;;
> > >    > +       a|A|p)          AUTO=true;;
> > >    > +       y)              REPAIR=true;;
> > >    >         f)              FORCE=true;;
> > >    >         esac
> > >    >  done
> > >    > @@ -64,7 +66,32 @@ fi
> > >    >
> > >    >  if $FORCE; then
> > >    >         xfs_repair -e $DEV
> > >    > -       repair2fsck_code $?
> > >    > +       error=$?
> > >    > +       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
> > >    > +               echo "Replaying log for $DEV"
> > >    > +               mkdir -p /tmp/repair_mnt || exit 1
> > >    > +               for x in $(cat /proc/cmdline); do
> > >    > +                       case $x in
> > >    > +                               root=*)
> > >    > +                                       ROOT="${x#root=}"
> > >    > +                               ;;
> > >    > +                               rootflags=*)
> > >    > +                                       ROOTFLAGS="-o
> > >    ${x#rootflags=}"
> > >    > +                               ;;
> > >    > +                       esac
> > >    > +               done
> > >    > +               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
> > >    > +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
> > >    > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit
> > >    1
> > >    > +               else
> > >    > +                       mount $DEV /tmp/repair_mnt || exit 1
> > >    > +               fi
> > >    > +               umount /tmp/repair_mnt
> > >    > +               xfs_repair -e $DEV
> > >    > +               error=$?
> > >    > +               rm -d /tmp/repair_mnt
> > >    > +       fi
> > >    > +       repair2fsck_code $error
> > >    >         exit $?
> > >    >  fi
> > >    >
> > >    > --
> > >    > 1.8.3.1
> > >    --
> > >    Carlos Maiolino
> > 
> > --
> > Carlos Maiolino
> 
> Regards,
> Srikanth
