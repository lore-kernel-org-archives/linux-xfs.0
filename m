Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A42BC47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 12:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A174610E7
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 12:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhEaM4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 08:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhEaM4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 08:56:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A0FC061574
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 05:55:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c12so8973749pfl.3
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 05:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1kOa/InqQOhomoTltkOMpNUhz9d+d0cHta9R3KebJIg=;
        b=uzjMEqpwsBh0ar/rkdGE0zlEThVHzKjks5dsqZxyxe+41aQEqFw82rRBRW4HuR4DcK
         fop2IH929Wvr0xuwu8USbrkdk34eq9vYvJcXlxo5ycarADi4cz79DgaS6H6d+L04szC9
         SIFvdWlFgu1/UiZHRCndk799nsAZj5jjLqsThrqFLU5LNl++k8M6tKa1ShQRJA0bvnKg
         9bu72fYA5odenq0XxO8L++IMWzlHPiCpez6LxCZJU4O1571Q+JqdnEA7iekds6Fag2dS
         2RDLERGd+JdGoull2ePh9cuyCV9F1YgkfL3pXM5Bbo/qBC39LH6NI7GP1bPNVnD0hW8Y
         HKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1kOa/InqQOhomoTltkOMpNUhz9d+d0cHta9R3KebJIg=;
        b=kJmgXIg5iDlSUAKdRhzOOmDMka6T5Bwtp+xhlLTuc6zF2QI8cAlxu4F5eQByT98nrx
         eZMiS4ddqMJ6TauBhYZFHhuirPoSKvdrNT8SwZg3r1bPq8+9XFuAVRnMqAcq9XgCvUkB
         SvDjVhw1O2z9y/Qw94TaqBijZmjRE7BNaImhtsVSFBNzK6GzYzOXfh9YEq3uFVn0wQIF
         GvYPol3bQwN3y4fVfRim3UlULnSv5l0Lk+b5CscKHXXZ51B0btFUSzsAxA38Fdm3zljZ
         bfXz7XpE7MuJ6jHruHkJRV7TJjC+GSBJ3hSA5GO01F9TOkDZxpvBa+TtIlZWccTyAKLm
         0yrw==
X-Gm-Message-State: AOAM531S4DhYv0X//Ao0bGTROabWdg1J0l7HFN4Ow5xZ5138cut/Jos6
        O4W7uzV/Onj8+lbIsAHeoNrhtHil1MTicA==
X-Google-Smtp-Source: ABdhPJxxxjxB79j7ISSXyV9FbAwgGLViujLtsMql8rgSIFUCjtlSSN5IJIN6Dd70SsJDtp8Hmlz9sg==
X-Received: by 2002:a05:6a00:16cd:b029:2d0:d876:4707 with SMTP id l13-20020a056a0016cdb02902d0d8764707mr17324425pfc.64.1622465706844;
        Mon, 31 May 2021 05:55:06 -0700 (PDT)
Received: from garuda ([122.171.220.253])
        by smtp.gmail.com with ESMTPSA id s48sm10861269pfw.205.2021.05.31.05.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 May 2021 05:55:06 -0700 (PDT)
References: <20210527045202.1155628-1-david@fromorbit.com> <20210527045202.1155628-4-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_itruncate_extents has no extent count limitation
In-reply-to: <20210527045202.1155628-4-david@fromorbit.com>
Date:   Mon, 31 May 2021 18:25:03 +0530
Message-ID: <87eednukpk.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 May 2021 at 10:21, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Ever since we moved to freeing of extents by deferred operations,
> we've already freed extents via individual transactions. Hence the
> only limitation of how many extents we can mark for freeing in a
> single xfs_bunmapi() call bound only by how many deferrals we want
> to queue.
>
> That is xfs_bunmapi() doesn't actually do any AG based extent
> freeing, so there's no actually transaction reservation used up by
> calling bunmapi with a large count of extents to be freed. RT
> extents have always been freed directly by bunmapi, but that doesn't
> require modification of large number of blocks as there are no
> btrees to split.
>
> Some callers of xfs_bunmapi assume that the extent count being freed
> is bound by geometry (e.g. directories) and these can ask bunmapi to
> free up to 64 extents in a single call. These functions just work as
> tehy stand, so there's no reason for truncate to have a limit of
> just two extents per bunmapi call anymore.
>
> Increase XFS_ITRUNC_MAX_EXTENTS to 64 to match the number of extents
> that can be deferred in a single loop to match what the directory
> code already uses.
>
> For realtime inodes, where xfs_bunmapi() directly frees extents,
> leave the limit at 2 extents per loop as this is all the space that
> the transaction reservation will cover.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0369eb22c1bb..db220eaa34b8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -40,9 +40,18 @@ kmem_zone_t *xfs_inode_zone;
>
>  /*
>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
> - * freed from a file in a single transaction.
> + * we will unmap and defer for freeing in a single call to xfs_bunmapi().
> + * Realtime inodes directly free extents in xfs_bunmapi(), so are bound
> + * by transaction reservation size to 2 extents.
>   */
> -#define	XFS_ITRUNC_MAX_EXTENTS	2
> +static inline int
> +xfs_itrunc_max_extents(
> +	struct xfs_inode	*ip)
> +{
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return 2;
> +	return 64;
> +}
>
>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
> @@ -1402,7 +1411,7 @@ xfs_itruncate_extents_flags(
>  	while (unmap_len > 0) {
>  		ASSERT(tp->t_firstblock == NULLFSBLOCK);
>  		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
> -				flags, XFS_ITRUNC_MAX_EXTENTS);
> +				flags, xfs_itrunc_max_extents(ip));
>  		if (error)
>  			goto out;

The list of free extent items at xfs_defer_pending->dfp_work could
now contain XFS_EFI_MAX_FAST_EXTENTS (i.e. 16) entries in the worst case.

For a single transaction, xfs_calc_itruncate_reservation() reserves space for
logging only 4 extents (i.e. 4 exts * 2 trees * (2 * max depth - 1) * block
size). But with the above change, a single transaction can now free upto 16
extents. Wouldn't this overflow the reserved log space?

--
chandan
