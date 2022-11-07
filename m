Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5872C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 06:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiKGGAR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 01:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKGGAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 01:00:16 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE37BCBD
        for <linux-xfs@vger.kernel.org>; Sun,  6 Nov 2022 22:00:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VU6gRLZ_1667800808;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VU6gRLZ_1667800808)
          by smtp.aliyun-inc.com;
          Mon, 07 Nov 2022 14:00:10 +0800
Date:   Mon, 7 Nov 2022 14:00:07 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Srikanth C S <srikanth.c.s@oracle.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <Y2ie54fcHDx5bcG4@B-P7TQMD6M-0146.local>
Mail-Followup-To: Srikanth C S <srikanth.c.s@oracle.com>,
        darrick.wong@oracle.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20221104061011.4063-1-srikanth.c.s@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221104061011.4063-1-srikanth.c.s@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

On Fri, Nov 04, 2022 at 11:40:11AM +0530, Srikanth C S wrote:
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

We'd also like to get a formal solution about this for our production
so that xfs_repair can work properly with log recovery.

However, may I ask if it's the preferred way to implement this which
just acts as another mount-unmount cycle, since I'm not sure if there
are some customized initramfs-es which could get the fs busy so that it
won't unmount properly.

Alternatively, do we consider another way like exporting the log
recovery functionality with ioctl() so that log recovery can work
without the actual fs mounting? Is it affordable?

Thanks,
Gao Xiang

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
> 
