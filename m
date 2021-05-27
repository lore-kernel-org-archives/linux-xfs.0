Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127E5C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31D2613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhE0GEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 02:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhE0GEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 02:04:13 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A57AC061574
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 23:02:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d20so1789951pls.13
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 23:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=GW/h6RivuSeKzpTUyPSD0j3OYmtx07JI46Fo1pXFIPw=;
        b=CWyiJyxp1Pf19Iji2llq/ZCsgm4T7untWhvvTa0zuuSI2ZhNzzpnYKg9hYgBhxMg92
         Oq3PZUKpnC9Zrq0DkunCqhoUd1Ny2YoeVU8wiiePXzLP97i9hdGw6R/68yefkSBWYW7+
         vVuui+Uvo1m7KJBItr5Kul1DXO/oAqv7zN1W/ecRw/jngdgpCGJbFTYpM0BdYP5VUN3/
         L5Pk3CFjjhaAQK99b5tTlr9DYR7PYJV4T71KX1QXMGhb5qCC64y4XJ+d0qJJxrfYbsrX
         r0kFutXGd4i78a3Nl0yIBRI37knF6jFNy5HiqyK98xbbIe84NPF2JAesbdOpiTHXnhAf
         QyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=GW/h6RivuSeKzpTUyPSD0j3OYmtx07JI46Fo1pXFIPw=;
        b=SYKiQ6kek8UgZJpu9o1IucoxqKTOyfet+jF4tSed/c4uV4pTD3V+jA1W2XDRN8w3i3
         rrLAq7jVYkVayx++1Bd0UONF1bnycMrcnXV7gmzjjKvSf4oFA0nfd0o3zVg3WTEgxroe
         iCEXrmAAzDbVoh43oY4C0JyJO7Wcpi+0cg+020uWI4OLsO9+ULNvqbytgikmdBCJoQTv
         PoPA6lH+VyxFb8c1SgeijncuxbwbmnqmfqOuOPwfgElnwI4iwqnIGD+EdBCrZjDT3Ny+
         w9Z3CJMvY44MKFzaQeBxMI85MwRN30W5RQkzLYxUx8WL/eYH/Oj325w+YuVfO7Yg2QY+
         bv2g==
X-Gm-Message-State: AOAM533nqSF07DCw4o87GMhrxC13Avb8buWpQUva3aSH4lk3VkWNU7sf
        NhpHlfA6nFDRpw2vgLH58tvhH92dE2abtg==
X-Google-Smtp-Source: ABdhPJzHAB6Waic9rC11lxWt3BfhZ/cIjSqVX67+3HWjUzNeVGRifuuattz+BFNVCg0MRh4tazi8mQ==
X-Received: by 2002:a17:90a:dac1:: with SMTP id g1mr7653435pjx.199.1622095359888;
        Wed, 26 May 2021 23:02:39 -0700 (PDT)
Received: from garuda ([122.171.209.190])
        by smtp.gmail.com with ESMTPSA id y26sm822011pge.94.2021.05.26.23.02.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 May 2021 23:02:39 -0700 (PDT)
References: <20210527001942.1115586-1-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: btree format inode forks can have zero extents
In-reply-to: <20210527001942.1115586-1-david@fromorbit.com>
Date:   Thu, 27 May 2021 11:32:36 +0530
Message-ID: <87k0nkogsj.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 May 2021 at 05:49, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> xfs/538 is assert failing with this trace when testing with
> directory block sizes of 64kB:
>
> XFS: Assertion failed: !xfs_need_iread_extents(ifp), file: fs/xfs/libxfs/xfs_bmap.c, line: 608
> ....
> Call Trace:
>  xfs_bmap_btree_to_extents+0x2a9/0x470
>  ? kmem_cache_alloc+0xe7/0x220
>  __xfs_bunmapi+0x4ca/0xdf0
>  xfs_bunmapi+0x1a/0x30
>  xfs_dir2_shrink_inode+0x71/0x210
>  xfs_dir2_block_to_sf+0x2ae/0x410
>  xfs_dir2_block_removename+0x21a/0x280
>  xfs_dir_removename+0x195/0x1d0
>  xfs_remove+0x244/0x460
>  xfs_vn_unlink+0x53/0xa0
>  ? selinux_inode_unlink+0x13/0x20
>  vfs_unlink+0x117/0x220
>  do_unlinkat+0x1a2/0x2d0
>  __x64_sys_unlink+0x42/0x60
>  do_syscall_64+0x3a/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> This is a check to ensure that the extents have been read into
> memory before we are doing a ifork btree manipulation. This assert
> is bogus in the above case.
>
> We have a fragmented directory block that has more extents in it
> than can fit in extent format, so the inode data fork is in btree
> format. xfs_dir2_shrink_inode() asks to remove all remaining 16
> filesystem blocks from the inode so it can convert to short form,
> and __xfs_bunmapi() removes all the extents. We now have a data fork
> in btree format but have zero extents in the fork. This incorrectly
> trips the xfs_need_iread_extents() assert because it assumes that an
> empty extent btree means the extent tree has not been read into
> memory yet. This is clearly not the case with xfs_bunmapi(), as it
> has an explicit call to xfs_iread_extents() in it to pull the
> extents into memory before it starts unmapping.
>
> Also, the assert directly after this bogus one is:
>
> 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
>
> Which covers the context in which it is legal to call
> xfs_bmap_btree_to_extents just fine. Hence we should just remove the
> bogus assert as it is clearly wrong and causes a regression.
>
> The returns the test behaviour to the pre-existing assert failure in
> xfs_dir2_shrink_inode() that indicates xfs_bunmapi() has failed to
> remove all the extents in the range it was asked to unmap.
>

The functions calling xfs_bmap_btree_to_extents() have indeed read all the
extents of the corresponding inode fork into memory. Hence, removal of the
assert() statement is not an issue.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

--
chandan
