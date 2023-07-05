Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2927EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 15:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjGEPUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjGEPUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 11:20:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E3F1737
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 08:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 690B56156A
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 15:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8142C433C7;
        Wed,  5 Jul 2023 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688570435;
        bh=Pwp5y4EohTFE+up8rxfG2JBsEV4rOpL/0dlcUn67oLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFkZUMmga27bjXerK21KgwFxFxNONAKwIjIK1gRNmXFibDZr9x5Rj8N3VXpNYEy9K
         MZu3YsA2SR9R81njJ2Vin7imutZxJFG0zIYU4mXO7FAi6QpvrTTHC1ULy1JG/zrIGk
         c2+b9vu2ZLUaemEvEBKGxoW9soN1UEwxZJbbvNvTXQr9Kh3IYtGA1f1x783un3LkMS
         ufXGRC/pszSjOXpWst5zdtyDaI8g4bJ9PaC0Ja0z0YmnGGnFZlcG1JkbKkMw+8gfAC
         MbbeXmskeBQY9NXi4G5g+LjJVsyBX5PE7qBBhhfOYyZ5d/GPC734WZ25r5jBL+0oVq
         ec0ccU61nJdTA==
Date:   Wed, 5 Jul 2023 08:20:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] mkfs.xfs: fix segmentation fault caused by accessing
 a null pointer
Message-ID: <20230705152035.GQ11441@frogsfrogsfrogs>
References: <182e9ac9-933f-ed8e-1f5a-9ffc2d730eb7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182e9ac9-933f-ed8e-1f5a-9ffc2d730eb7@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 29, 2023 at 10:20:30AM +0800, Wu Guanghao wrote:
> We encountered a segfault while testing the mkfs.xfs + iscsi.
> 
> (gdb) bt
> #0 libxfs_log_sb (tp=0xaaaafaea0630) at xfs_sb.c:810
> #1 0x0000aaaaca991468 in __xfs_trans_commit (tp=<optimized out>, tp@entry=0xaaaafaea0630, regrant=regrant@entry=true) at trans.c:995
> #2 0x0000aaaaca991790 in libxfs_trans_roll (tpp=tpp@entry=0xfffffe1f3018) at trans.c:103
> #3 0x0000aaaaca9bcde8 in xfs_dialloc_roll (agibp=0xaaaafaea2fa0, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1561
> #4 xfs_dialloc_try_ag (ok_alloc=true, new_ino=<synthetic pointer>, parent=0, pag=0xaaaafaea0210, tpp=0xfffffe1f31c8) at xfs_ialloc.c:1698
> #5 xfs_dialloc (tpp=tpp@entry=0xfffffe1f31c8, parent=0, mode=mode@entry=16877, new_ino=new_ino@entry=0xfffffe1f3128) at xfs_ialloc.c:1776
> #6 0x0000aaaaca9925b0 in libxfs_dir_ialloc (tpp=tpp@entry=0xfffffe1f31c8, dp=dp@entry=0x0, mode=mode@entry=16877, nlink=nlink@entry=1, rdev=rdev@entry=0, cr=cr@entry=0xfffffe1f31d0,
>     fsx=fsx@entry=0xfffffe1f36a4, ipp=ipp@entry=0xfffffe1f31c0) at util.c:525
> #7 0x0000aaaaca988fac in parseproto (mp=0xfffffe1f36c8, pip=0x0, fsxp=0xfffffe1f36a4, pp=0xfffffe1f3370, name=0x0) at proto.c:552
> #8 0x0000aaaaca9867a4 in main (argc=<optimized out>, argv=<optimized out>) at xfs_mkfs.c:4217
> 
> (gdb) p bp
> $1 = 0x0
> 
> ```
> void
> xfs_log_sb(
>         struct xfs_trans        *tp)
> {
>         // iscsi offline
>         ...
>         // failed to read sb, bp = NULL
>         struct xfs_buf          *bp = xfs_trans_getsb(tp);
>         ...
> }
> ```
> 
> When writing data to sb, if the device is abnormal at this time,
> the bp may be empty. Using it without checking will result in
> a segfault.
> 
> So it's necessary to ensure that the superblock has been cached.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  mkfs/xfs_mkfs.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7b3c2304..8d0ec4b5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4406,6 +4406,15 @@ main(
>                 exit(1);
>         }
> 
> +       /*
> +        *  Cached superblock to ensure that xfs_trans_getsb() will not return NULL.
> +        */
> +       buf = libxfs_getsb(mp);

prepare_devices() already creates an uncached xfs_buf for the
superblock.  Why not reuse that instead of rereading the buffer here?

> +       if (!buf || buf->b_error) {
> +               fprintf(stderr, _("%s: read superblock failed, err=%d\n"),
> +                               progname, !buf ? EIO : -buf->b_error);
> +               exit(1);
> +       }
>         /*
>          * Initialise the freespace freelists (i.e. AGFLs) in each AG.
>          */
> @@ -4433,6 +4442,7 @@ main(
>          * Need to drop references to inodes we still hold, first.
>          */
>         libxfs_rtmount_destroy(mp);
> +       libxfs_buf_relse(buf);
>         libxfs_bcache_purge();
> 
>         /*

...and then we don't have read it yet again down here to clear the
sb_inprogress field?

--D

> --
> 2.27.0
