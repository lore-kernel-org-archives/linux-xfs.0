Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C381C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 23:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiJJX3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 19:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJJX3i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 19:29:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74B3C3B2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 16:29:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 719191101D09;
        Tue, 11 Oct 2022 10:29:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oi2DE-000U82-8P; Tue, 11 Oct 2022 10:29:32 +1100
Date:   Tue, 11 Oct 2022 10:29:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Darrick Wong <darrick.wong@oracle.com>
Cc:     Srikanth C S <srikanth.c.s@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Message-ID: <20221010232932.GW3600936@dread.disaster.area>
References: <MWHPR10MB1486754F03696347F4E7FEE5A3209@MWHPR10MB1486.namprd10.prod.outlook.com>
 <CO1PR10MB44992848A2000EFE3A930871F8209@CO1PR10MB4499.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR10MB44992848A2000EFE3A930871F8209@CO1PR10MB4499.namprd10.prod.outlook.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6344aadd
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=7mz5x0ZcfSVhkIDmIPAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2022 at 03:40:51PM +0000, Darrick Wong wrote:
> LGTM, want to send this to the upstream list to start that discussion?
> 
> --D
> 
> ________________________________________
> From: Srikanth C S <srikanth.c.s@oracle.com>
> Sent: Monday, October 10, 2022 08:24
> To: linux-xfs@vger.kernel.org; Darrick Wong
> Cc: Rajesh Sivaramasubramaniom; Junxiao Bi
> Subject: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
> 
> fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
> possible that when the machine crashes, the fs is in inconsistent
> state with the journal log not yet replayed. This can put the
> machine into rescue shell. To address this problem, mount and
> umount the fs before running xfs_repair.

What's the purpose of forcing xfs_repair to be run on every boot?
The whole point of having a journalling filesystem is to avoid
needing to run fsck on every boot.

I get why one might want to occasionally force a repair check on
boot (e.g. to repair a problem with the root filesystem), but this
is a -rescue operation- and really shouldn't be occurring
automatically on every boot or after a kernel crash.

If it is only occurring during rescue operations, then why is it a problem
dumping out to a shell for the admin performing rescue
operations to deal with this directly? e.g. if the fs has a
corrupted journal, then a mount cycle will not fix the problem and
the admin will still get dumped into a rescue shell to fix the
problem manually.

Hence I don't really know why anyone would be configuring their
systems like this:

> Run xfs_repair -e when fsck.mode=force and repair=auto or yes.

as it makes no sense at all for a journalling filesystem.

> If fsck.mode=force and fsck.repair=no, run xfs_repair -n without
> replaying the logs.

Nor is it clear why anyone would want force a boot time fsck and
then not repair the damage that might be found....

More explanation, please!

> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> ---
>  fsck/xfs_fsck.sh | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> index 6af0f22..21a8c19 100755
> --- a/fsck/xfs_fsck.sh
> +++ b/fsck/xfs_fsck.sh
> @@ -63,8 +63,24 @@ if [ -n "$PS1" -o -t 0 ]; then
>  fi
> 
>  if $FORCE; then
> -       xfs_repair -e $DEV
> -       repair2fsck_code $?
> +       if $AUTO; then
> +               xfs_repair -e $DEV
> +                error=$?
> +                if [ $error -eq 2 ]; then
> +                        echo "Replaying log for $DEV"
> +                        mkdir -p /tmp/tmp_mnt
> +                        mount $DEV /tmp/tmp_mnt
> +                        umount /tmp/tmp_mnt
> +                        xfs_repair -e $DEV
> +                        error=$?
> +                        rmdir /tmp/tmp_mnt
> +                fi
> +        else
> +                #fsck.mode=force is set but fsck.repair=no
> +                xfs_repair -n $DEV
> +                error=$?
> +        fi
> +       repair2fsck_code $error
>          exit $?
>  fi

As a side note, the patch has damaged whitespace....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
