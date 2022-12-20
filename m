Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DB8C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 05:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiLTFA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 00:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiLTFAH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 00:00:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FDA13DD6
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 21:00:05 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so15338435pjp.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 21:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rw+CgAj/5VtQVjZFW9Cis0SCYvbbhcjHTggYpaHEXh4=;
        b=uiyTqUhVpes7tuKWeU5MYdfO61ZsuMcW5aDHFZqjdE6Bv38SiSP6OBfvBA+pOFtZrd
         fm7IztP17N6GhQZxTUbQKsCLFhFYcOVNM/t7s1zKAWGuRczgnhzq8ebVTgHSFm45zV9q
         wxOGd2jZn72CMwRz1S+HsbesG/n3umJLYi5Zo5Nx9kLsCLoJNmw21LSQ81aNE3Z87aGj
         BJ4cQDhDBpAnMgFJrgseLqMObjWIs9j8wPDaFgYWaVKZAD1oyHUQX+jLILojjnctDUrv
         0d2k+lY4xcAWDJDCsO1I1Ba+NT6GmlXDk1cDoZUIQAGTlYN8G3yXXLxprfWRlISzHf6+
         XZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rw+CgAj/5VtQVjZFW9Cis0SCYvbbhcjHTggYpaHEXh4=;
        b=2LyP1PwV16nTYgH+lVQbt24JW9da8+NC05QnzB/t6pllp/rsE1Qm4sp/PyFnI4doT7
         MM3NaJ/GeCGutvIqyQyLLRsLHGfn72MIOaJC6zFkE2hn3U+sdFMSrxLPCFWK3brVDrKE
         ctyQJSLFn5u7HCIn2ySSWv3Ma3hA5dnf811mdc4sa9uirwKd35dsJlDQFvdLAYbO4PNL
         ugSm24/V38zXnkTiGhCXjaTi9gnWcq9IkY50rAIVmBYx7ckUQILeVG9+83B1i2T3dhQS
         jeRLNNqMG8Ye18iDoDtmqRFeYHYuyO21OiQWg9GoYKSKg3tos1XdBHhy2wXnoHNIIcoA
         Tkog==
X-Gm-Message-State: AFqh2komGJyrjCHwPLAN1wpJ2knydbAp2BXQnfHgs1N06qaI3Vgmc1Tp
        QeAFSOGEwvVcH/Lvt2XrHLHqBQ==
X-Google-Smtp-Source: AMrXdXvPj/FE+CR+cxjadvv7msfEW1mU6ZbT3FJduPw4U8pefhQ5Bq4/U1FDsr4aXwJ6IU1syMlwwg==
X-Received: by 2002:a17:902:b109:b0:190:bf01:3a45 with SMTP id q9-20020a170902b10900b00190bf013a45mr14251253plr.25.1671512404836;
        Mon, 19 Dec 2022 21:00:04 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b0016d773aae60sm8101432pll.19.2022.12.19.21.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 21:00:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7UjR-00AaB9-LG; Tue, 20 Dec 2022 16:00:01 +1100
Date:   Tue, 20 Dec 2022 16:00:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix off-by-one error in
 xfs_btree_space_to_height
Message-ID: <20221220050001.GK1971568@dread.disaster.area>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149471987.336919.3277522603824048839.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149471987.336919.3277522603824048839.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:05:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Lately I've been stress-testing extreme-sized rmap btrees by using the
> (new) xfs_db bmap_inflate command to clone bmbt mappings billions of
> times and then using xfs_repair to build new rmap and refcount btrees.
> This of course is /much/ faster than actually FICLONEing a file billions
> of times.
> 
> Unfortunately, xfs_repair fails in xfs_btree_bload_compute_geometry with
> EOVERFLOW, which indicates that xfs_mount.m_rmap_maxlevels is not
> sufficiently large for the test scenario.  For a 1TB filesystem (~67
> million AG blocks, 4 AGs) the btheight command reports:
> 
> $ xfs_db -c 'btheight -n 4400801200 -w min rmapbt' /dev/sda
> rmapbt: worst case per 4096-byte block: 84 records (leaf) / 45 keyptrs (node)
> level 0: 4400801200 records, 52390491 blocks
> level 1: 52390491 records, 1164234 blocks
> level 2: 1164234 records, 25872 blocks
> level 3: 25872 records, 575 blocks
> level 4: 575 records, 13 blocks
> level 5: 13 records, 1 block
> 6 levels, 53581186 blocks total
> 
> The AG is sufficiently large to build this rmap btree.  Unfortunately,
> m_rmap_maxlevels is 5.  Augmenting the loop in the space->height
> function to report height, node blocks, and blocks remaining produces
> this:
> 
> ht 1 node_blocks 45 blockleft 67108863
> ht 2 node_blocks 2025 blockleft 67108818
> ht 3 node_blocks 91125 blockleft 67106793
> ht 4 node_blocks 4100625 blockleft 67015668
> final height: 5
> 
> The goal of this function is to compute the maximum height btree that
> can be stored in the given number of ondisk fsblocks.  Starting with the
> top level of the tree, each iteration through the loop adds the fanout
> factor of the next level down until we run out of blocks.  IOWs, maximum
> height is achieved by using the smallest fanout factor that can apply
> to that level.
> 
> However, the loop setup is not correct.  Top level btree blocks are
> allowed to contain fewer than minrecs items, so the computation is
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ah, that's the critical piece of information I was looking for. I
couldn't work out from the code change below what was wrong with
limits[1]. So....

> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 4c16c8c31fcb..8d11d3f5e529 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4666,7 +4666,11 @@ xfs_btree_space_to_height(
>  	const unsigned int	*limits,
>  	unsigned long long	leaf_blocks)
>  {
> -	unsigned long long	node_blocks = limits[1];
> +	/*
> +	 * The root btree block can have a fanout between 2 and maxrecs because
> +	 * the tree might not be big enough to fill it.
> +	 */

Can you change this comment to say something like:

	/*
	 * The root btree block can have less than minrecs pointers
	 * in it because the tree might not be big enough to require
	 * that amount of fanout. Hence it has a minimum size of
	 * 2 pointers, not limits[1].
	 */

Otherwise it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +	unsigned long long	node_blocks = 2;
>  	unsigned long long	blocks_left = leaf_blocks - 1;
>  	unsigned int		height = 1;

For future consideration, we don't use maxrecs in this calculation
at all - should we just pass minrecs into the function rather than
an array of limits?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
