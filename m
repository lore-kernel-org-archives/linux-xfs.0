Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D3AC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 17:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiKBRtS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiKBRtS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 13:49:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF545FF9
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 10:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F75A61908
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 17:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0E5C433D6;
        Wed,  2 Nov 2022 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667411356;
        bh=5qygGJQ29Doh7hh+SLuTZQRxr9SncNeYCJpCmvFBh/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suA64iqHMMs1XZRwzcEMizPvRgqPlr4GNHi+C7iIuIP1WGdVLGOjD4UZY+BMaSUkR
         ToHiIDS18bMC7xyofThf5kLWpIyhZ/ytYiXfv2UNCwz6/eOa09LCNtCCsvn7SusOdt
         FgmFrhSN9jXYFq+mxzqvvzVx//4b/BWXKETp9WXVoQcVt1AHxelKVy9odeF9ud1Efz
         QFW9P+faKlUSYb3GGMxH/NLxv00ahCLkkRaIR6yp3pQrfTotg3LnlmOICgLufV9nbO
         WFDnX/alTDmn+6GnZ8cukLZ65J5g1a+3eJYY7r3eASYie/Eb+eLsan2yKUd9m/vKMF
         qpNg05BlaJ2sA==
Date:   Wed, 2 Nov 2022 10:49:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com
Subject: Re: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y2Ktm96molO8Kd6r@magnolia>
References: <20221102142946.3454-1-srikanth.c.s@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102142946.3454-1-srikanth.c.s@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 07:59:46PM +0530, Srikanth C S wrote:
> After a recent data center crash, we had to recover root filesystems
> on several thousands of VMs via a boot time fsck. Since these
> machines are remotely manageable, support can inject the kernel
> command line with 'fsck.mode=force fsck.repair=yes' to kick off
> xfs_repair if the machine won't come up or if they suspect there
> might be deeper issues with latent errors in the fs metadata, which
> is what they did to try to get everyone running ASAP while
> anticipating any future problems. But, fsck.xfs does not address the
> journal replay in case of a crash.
> 
> fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> possible that when the machine crashes, the fs is in inconsistent
> state with the journal log not yet replayed. This can put the
> machine into rescue shell. To address this problem, mount and umount
> the fs before running xfs_repair.

"This can drop the machine into the rescue shell because xfs_fsck.sh
does not know how to clean the log.  Since the administrator told us to
force repairs, address the deficiency by cleaning the log and rerunning
xfs_repair."

> Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> other option -fa and -f drop to the resuce shell if repair detects

s/resuce/rescue/

> any corruptions
> 
> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>

Ah good, your email works again.

> ---
>  fsck/xfs_fsck.sh | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 6af0f22..4ef61db 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -31,10 +31,12 @@ repair2fsck_code() {
> 
>  AUTO=false
>  FORCE=false
> +REPAIR=false
>  while getopts ":aApyf" c
>  do
>         case $c in
> -       a|A|p|y)        AUTO=true;;
> +       a|A|p)          AUTO=true;;
> +       y)              REPAIR=true;;
>         f)              FORCE=true;;
>         esac
>  done
> @@ -64,7 +66,24 @@ fi
> 
>  if $FORCE; then
>         xfs_repair -e $DEV
> -       repair2fsck_code $?
> +       error=$?
> +       if [ $error -eq 2 ] && [ -n "$REPAIR" ]; then

test -n checks that its argument "$REPAIR" is nonzero length.  Since you
set REPAIR=false above, this test will always return success.  I think
you wanted:

	if [ $error -eq 2 ] && [ $REPAIR = true ]; then

here?

> +               echo "Replaying log for $DEV"
> +               mkdir -p /tmp/repair_mnt || exit 1
> +               for x in $(cat /proc/cmdline); do
> +                       case $x in
> +                               rootflags=*)
> +                                       ROOTFLAGS="-o ${x#rootflags=}"
> +                               ;;
> +                       esac
> +               done
> +               mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> +               umount /tmp/repair_mnt
> +               xfs_repair -e $DEV
> +               error=$?
> +               rm -d /tmp/repair_mnt
> +       fi
> +       repair2fsck_code $error

The rest of the logic looks ok to me.  The new behavior needs to be
documented in the manpage.  Here's a fugly troff snippet that could be
added towards the end of man/man8/fsck.xfs.8:

If the system administrator adds "fsck.mode=force fsck.repair=yes" to
the kernel command line,
.B fsck.xfs
will detect a dirty log and mount and unmount the filesystem to clean
the log before running
.BR xfs_repair (8).

--D

>         exit $?
>  fi
> 
> --
> 1.8.3.1
