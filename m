Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D46BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 06:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiKKG2q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 01:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiKKG2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 01:28:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED267C8CE
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 22:24:29 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so3895117pjd.4
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 22:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGF214jhqMsvXm/RYbiHRRRbsIBf0/4l13Bb39of/lI=;
        b=jMpEp4p/aEp7NtEk9zJW5P6tA7IeINQ2xRP3tzo1paKgFtAfUW7mRPcBWtbgctDY0d
         pqn+iRkIx1Z1NnY1hwktVpMcu804XmqdDK1P9M/kP2caHdpUzU62P7UFinejWvMFlTv1
         S87tDfuhWR44IpTH44d5w5w3Sq42uOGXsf9NnDJwjaq/F0k0N+P10YF0pwrdoqSXAjhO
         28V5L0tX26/ESVlNTIyd3mvSVmlsvBl0Hdynho//7EUnw7pX91mgvt90zzB0jJ+Dmbfj
         IbVolPwnEkDYN7lS8+mzMAMkbwsenMr+dBaKHr2XqpUPPIpSnrC7F9rNmHwVn0BeOcCT
         0I6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zGF214jhqMsvXm/RYbiHRRRbsIBf0/4l13Bb39of/lI=;
        b=EOS6oqU0owL4kYxe0zN55KCUi94EBoFtOQd8RSfZkQVD8iR1kbdour+hVnLkNMWRb8
         PtPJ5LNt5tAwrl1Wfnm+7gidvP6QOaOjIOvK1/dl2rHXiUeZHTRlfwk6p9peA1Sph8qf
         6MvAcwlFG/K0R0lSMbTneAkxHuZs5tQsM4HRUIW7alv8uvARASD1juaEbo33u+Md3+tB
         lDnHzRHD42QY/JdYUmWwvYFxsbwn1hDCnM/an1zBVV8pZWDbD1lVEgIELAgru0MC3n+v
         X3eaK/S7jm2kepYgkqC3ybz/Tvgm3CI7IArtvQ/6K8giGIr4mxW7UN8mDIa4/3kTBJSm
         wJdA==
X-Gm-Message-State: ANoB5pk40Ki1NYLdHWUfv7st3tSe5xD7Zv1Bkn5c++mZDudDihdWPIOH
        leof/33eOEBoIcREQJDcqdZroGyGPGE=
X-Google-Smtp-Source: AA0mqf7p9LU4YyRymbHwPeIz1jphM+sd2AoLcPAMNGVEGqr7HDrBuSbziXxq+0f7s4DGn3Q3Y6Vafw==
X-Received: by 2002:a17:902:6904:b0:185:4880:91cd with SMTP id j4-20020a170902690400b00185488091cdmr1112881plk.130.1668147869017;
        Thu, 10 Nov 2022 22:24:29 -0800 (PST)
Received: from [30.221.128.160] ([47.246.101.48])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ab8100b00174c1855cd9sm757251plr.267.2022.11.10.22.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 22:24:28 -0800 (PST)
Message-ID: <190cba7f-30a0-4eb3-6587-5b42d7251868@gmail.com>
Date:   Fri, 11 Nov 2022 14:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Content-Language: en-US
To:     Srikanth C S <srikanth.c.s@oracle.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com, david@fromorbit.com
References: <20221104061011.4063-1-srikanth.c.s@oracle.com>
From:   Joseph Qi <jiangqi903@gmail.com>
In-Reply-To: <20221104061011.4063-1-srikanth.c.s@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi，

On 11/4/22 2:10 PM, Srikanth C S wrote:
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
> +               if [ $(basename $DEV) = $(basename $ROOT) ]; then
> +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
> +               else
> +                       mount $DEV /tmp/repair_mnt || exit 1
> +               fi

If do normal boot, it will try to mount according to fstab.
So in the crash case you've described, it seems that it can't mount
successfully? Or am I missing something?

Thanks,
Joseph

> +               umount /tmp/repair_mnt
> +               xfs_repair -e $DEV
> +               error=$?
> +               rm -d /tmp/repair_mnt
> +       fi
> +       repair2fsck_code $error
>         exit $?
>  fi
>  
