Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CE2C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Dec 2022 12:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiLLMNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Dec 2022 07:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiLLMNU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2022 07:13:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92007FC1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Dec 2022 04:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2D2B80D0A
        for <linux-xfs@vger.kernel.org>; Mon, 12 Dec 2022 12:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3CC433EF;
        Mon, 12 Dec 2022 12:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670847196;
        bh=aRnfE5RbPji2aEMjVOvkAZAZDlT1XwMr+nxbnELJZSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdHvphSa794ZdHWqPvg0cN+vR+69QI/hz3jXOe48P/CHaKz5GoMP8hvSFDKpeo9jm
         XW6xCJ6X5SGnhWRKSM1VXQS8D5WtuuRltPi501yL4MvQXEc7Rn1IoO5D3A2cHb4RwL
         hEZQnuC5WGt2AL6BAJZNdY54Al014szy4kQkdJ9nwC7Yl5i3ESiA7Y/+7TyrPTCltE
         uHJ/n9b5JbzfTGWilIHmLY3UE3RbqA5biRRORC/J+oKS0sG+n+UCGdZwq0kNZSUBhd
         ZiwWuaxBRIrlFx7+m7RxIaJkHWjk87626Ubv9AjSC0ZSXJ6pAxCaZSQ0JlLHH/7LXc
         7waaoP7OerKug==
Date:   Mon, 12 Dec 2022 13:13:11 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <20221212121311.xtgsscljhtzgro4t@andromeda>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123063050.208-1-srikanth.c.s@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
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
> state with the journal log not yet replayed. This can drop the machine
> into the rescue shell because xfs_fsck.sh does not know how to clean the
> log. Since the administrator told us to force repairs, address the
> deficiency by cleaning the log and rerunning xfs_repair.
> 
> Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> other option -fa and -f drop to the rescue shell if repair detects
> any corruptions.
> 
> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>

Apologies it took so long, the patch seems fine to me. Will test.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 6af0f22..62a1e0b 100755
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
> @@ -64,7 +66,32 @@ fi
> 
>  if $FORCE; then
>         xfs_repair -e $DEV
> -       repair2fsck_code $?
> +       error=$?
> +       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
> +               echo "Replaying log for $DEV"
> +               mkdir -p /tmp/repair_mnt || exit 1
> +               for x in $(cat /proc/cmdline); do
> +                       case $x in
> +                               root=*)
> +                                       ROOT="${x#root=}"
> +                               ;;
> +                               rootflags=*)
> +                                       ROOTFLAGS="-o ${x#rootflags=}"
> +                               ;;
> +                       esac
> +               done
> +               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
> +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
> +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> +               else
> +                       mount $DEV /tmp/repair_mnt || exit 1
> +               fi
> +               umount /tmp/repair_mnt
> +               xfs_repair -e $DEV
> +               error=$?
> +               rm -d /tmp/repair_mnt
> +       fi
> +       repair2fsck_code $error
>         exit $?
>  fi
> 
> --
> 1.8.3.1

-- 
Carlos Maiolino
