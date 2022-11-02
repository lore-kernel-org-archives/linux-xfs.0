Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F76EC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 20:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiKBUnq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiKBUno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 16:43:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8AF64C4
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 13:43:42 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y203so3333144pfb.4
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 13:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cx3NoX491Oer6XcixYK3usOZxNDB2P5ZUgsskm34TkM=;
        b=Hp/67Z1dqfGWQXGnOUGho6JxKEsaUVM8mXtlzyAKHDsZ0fz7Iam/5vQjNTpmIsUw2N
         mR26FiMDpHndtFHTPbxPDiG+bkGvEFuaRunbKoiHSLKOPaNWDfM8NnvxNMoDPzn9k+xR
         TX3x0gRJqlLfb4veQgNtYfAHiygkhmbv4eBK04JbapFqxGwBH4aB9Qp4ACarhCEQ3WUT
         iI0qCWpmlhNttvx8aT60+n7N1brrhdoKCTiy98HvspA8k3L3dJ/ETfqcwe5LQSXEunko
         2+Ev2RZXlLwbuKstXJ9KoGxfR+ziT2F6beJK/8jN87x395nJ17whvYCa8bztZsrrsz58
         J+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cx3NoX491Oer6XcixYK3usOZxNDB2P5ZUgsskm34TkM=;
        b=OSmN7UE/4lvb3gDDX9Y4ZaX96uipzdE3iH+9ajmsFVXoEpptCvjOdmosumSo8wyXM8
         tOlxt1M2EBBs9BpvsuGfqppOW8DWvs8KcGEhqhO4n8YOwRX8gIc2Ayex0nPbGbNUqywZ
         GwIvsapo79ogiAycIJAiTkm9BblPVvu6kKLhF9n7BfZKYqSieGCGQsv9g8JU6e8zbtrl
         SxwpEXTcdodqCqhU38btAfqraQjHsRzxOlxhUT7uRfChfoghNiiU+ZY4D/19V2YbFIqG
         qCdAqyT5S1QKtbkCIW/fL1EMFj6XQcMcRZAparnUlbi2jZwjUmASNyZ6gkzbD5nOxvzn
         qm4A==
X-Gm-Message-State: ACrzQf2mtFiiWIg08GgyRza7rjYAk1f+jLSL+ntUJIkIrVaPsWhgDcmo
        MAfX4mB1Ztdqds0J/3jkxrWY7PUttRwN9g==
X-Google-Smtp-Source: AMsMyM4+k4aAnbkrK4d+vplgnVfozWlMZqLzWcT9PJNwvt3Ajk82YxsiyZUhLqY3uMquHd6OKZwpSw==
X-Received: by 2002:a05:6a00:1747:b0:56c:d93a:ac3e with SMTP id j7-20020a056a00174700b0056cd93aac3emr27029265pfc.23.1667421822331;
        Wed, 02 Nov 2022 13:43:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id h75-20020a62834e000000b0056b932f3280sm8845145pfe.103.2022.11.02.13.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:43:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqKaJ-009Vwf-6c; Thu, 03 Nov 2022 07:43:39 +1100
Date:   Thu, 3 Nov 2022 07:43:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com
Subject: Re: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <20221102204339.GX3600936@dread.disaster.area>
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
> machine into rescue shell. To address this problem, mount and
> umount the fs before running xfs_repair.
> 
> Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
> Replay the logs only if fsck.mode=force and fsck.repair=yes. For
> other option -fa and -f drop to the resuce shell if repair detects
> any corruptions
> 
> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
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
> +               echo "Replaying log for $DEV"
> +               mkdir -p /tmp/repair_mnt || exit 1
> +               for x in $(cat /proc/cmdline); do
> +                       case $x in
> +                               rootflags=*)
> +                                       ROOTFLAGS="-o ${x#rootflags=}"
> +                               ;;

What if fsck is being called on all devices (i.e. -a) or something
other than the root device? Don't we have to match the root flags to
the root dev? It's likely that there will be a root=<dev> parameter
on the CLI, so we'd want to grab that and check that it matches $DEV
before using ROOTFLAGS, right?

Otherwise this looks OK.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
