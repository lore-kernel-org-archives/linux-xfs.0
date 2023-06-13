Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F087C7EE29
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jun 2023 04:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbjFMEs2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jun 2023 00:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbjFMEs1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2023 00:48:27 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF713E
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 21:48:26 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75ea05150b3so53908385a.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 21:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686631705; x=1689223705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O6bhUQ1FibYDNnHjkPM8LhSmLOo/G3+UCPTaWza0g7E=;
        b=FFVkKSv9mqgiK41B4/t/nyeTzKpJExvkSPQ4bI++zGpgQWnUj0pmlUyAFKOQAJxwVD
         h51k2GeA4yTWI+BfcjY9ZpG3RLnZPxafWFBO96L7bvUjerIgZlYFm42jY11DPK1rYwNh
         s/V/gP1nTRrLg4MEJWquDrO+PfSvF6paleK6DQff8mwVdevFOn8s/jC+O26cyzp8wS+o
         Dg1q7Ft6Ol173hvHSvBshU+i4W/X79Yxlwj+WE6iZ+83QYPQCLRjKL8QmYQvaju4NH1x
         86G8y00BilavaE3ucz0FfMS/rm87zZzFxyVz2amJnYt+398CsrmMLe6d/Y7RdW49sFjf
         v3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686631705; x=1689223705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O6bhUQ1FibYDNnHjkPM8LhSmLOo/G3+UCPTaWza0g7E=;
        b=HEYeeyrNsJzDBwrvskOgXYG8UQoUrhXjUDJcP2YA91AD36yBHOCAQ5JYdRwoDOt2Y+
         wvUbn8mV9rO2fHYxo7Jy/ghq4FGNuv4fh9u+6gPVuechNCvYWijjwkp1TBtoksJzRQ3w
         tRZMcJrwgEirRs+SQgv2pyNIXe3lpNd5NQ7X8t7dDkrW2iiaARFgbvFfI0ai3wasyFny
         ln7k4cBD9x4RbMIIH9rrO2ogSET4wiJxILqZ3LX/NN+mVcEvAgOQDBVS9rXP3uMSA922
         iPPhVaC41PYUij2veIycatu4QdeWfnSHQHOATHiVz5AZmiIQHHcMPwz5ScghWvaEbros
         Krrw==
X-Gm-Message-State: AC+VfDwBoSIcxO5kORNtkf2m9W/unR1NRQScwaqmxgtm20qf8MfaAkzM
        plVOcooxctAmVPk3xUcDBgsTJw==
X-Google-Smtp-Source: ACHHUZ4XNsmj05O25KLQQfjo+KTVVxKZ1m4z8jyb89R6sElZe5fvPiI8iK8Jnp4FWCtQCQ1p+m22yw==
X-Received: by 2002:a05:620a:8008:b0:75b:23a1:8320 with SMTP id ee8-20020a05620a800800b0075b23a18320mr12970234qkb.27.1686631705487;
        Mon, 12 Jun 2023 21:48:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id ge13-20020a17090b0e0d00b00259bcb44113sm10070997pjb.32.2023.06.12.21.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 21:48:24 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q8vx8-00B9ID-1w;
        Tue, 13 Jun 2023 14:48:22 +1000
Date:   Tue, 13 Jun 2023 14:48:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Zhang Yi <yi.zhang@huaweicloud.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        yi.zhang@huawei.com, leo.lilong@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH 2/2] xfs: atomic drop extent entries when inactiving attr
Message-ID: <ZIf1FgqvYh+RoJ4K@dread.disaster.area>
References: <20230613030434.2944173-1-yi.zhang@huaweicloud.com>
 <20230613030434.2944173-3-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613030434.2944173-3-yi.zhang@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2023 at 11:04:34AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When inactiving an unlinked inode and it's attrs, if xlog is shutdown
> either during or just after the process of recurse deleting attribute
> nodes/leafs in xfs_attr3_root_inactive(), the log will records some
> buffer cancel items, but doesn't contain the corresponding extent
> entries and inode updates, this is incomplete and inconsistent.

What is incomplete and inconsistent? The directory block on disk
will still contain the previously written directory block contents,
so it will still be able to be read just fine and do the right thing
even if it was cancelled during recovery...

(Yes, I know the answer, but the commit message needs to spell out
how the metadata becomes inconsistent so people trying to decide if
this needs backporting can understand the scope of the problem
fully.)

> Because
> of the inactiving process is not completed and the unlinked inode is
> still in the agi_unlinked table, it will continue to be inactived after
> replaying the log on the next mount,

Yes, that's normal behaviour.

> the attr node/leaf blocks' created
> record before the cancel items could not be replayed but the inode
> does. So we could get corrupted data when reading the canceled blocks.

The dabtree iteration is depth first, so it should always cancels
leaf blocks before it cancels node blocks, right?

Hence the dabtree itself is should never be inconsistent - it should
be removing the index in the node block in the same transaction that
invalidating the leaf block.

IOWs, if we recover the buffer cancel for a leaf block, it should
also have been removed from the node block that references it in the
same transaction.

.....

Oh, that's the root cause of the problem, isn't it? It's following
a stale pointer in the dabtree, yes?

>  XFS (pmem0): Metadata corruption detected at
>  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
>  XFS (pmem0): Unmount and run xfs_repair
>  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
>  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> 
> In order to fix the issue, we need to remove the extent entries, update
> inode and attr btree atomically when staling attr node/leaf blocks. And
> note that we may also need to log and update the parent attr node
> entry when removing child or leaf attr block.

That's what xfs_itruncate_extents(ATTR_FORK) does. Doing it dablk by
dablk is rather inefficient - the code as it stands is an attempt to
minimise the overhead or removing a large dabtree.

So it looks to me like they problem is that when the child is
invalidated, the parent is left with a stale pointer to the
invalidated child in the dabtree. That's the problem you are trying
to fix by unmapping the dablk before invalidation?

But then you don't remove the reference in the parent block, and
instead rely on the side-effect of a "read into a hole is not
corruption" flag to allow recovery to follow pointers to known
stale, freed dablks? i.e. we trade a "detected an invalidated block"
error with a potential intentional use-after-free situation?

So, yeah, I think we need to rewrite the dablkno the parent holds
for the child at the same time we invalidate the child. If we
rewrite the child dabno to a directory block offset we know will
always be invalid (i.e. land in a hole beyond the directory size
limit), then xfs_dabuf_map() will always find a hole and return a
null buffer pointer. We never have to follow a pointer to a
potentially freed block...

We already re-read the parent buffer to get the next child and have
to juggle buffer locks, etc to deal with that, so all we actually
need to do is move this code up into the transaction that
invalidates the child and log the rewritten dablkno in the parent
block.

I think we could simplify the code quite significantly by doing
this.


>   * Invalidate any incore buffers associated with this remote attribute value
> @@ -139,7 +140,8 @@ xfs_attr3_node_inactive(
>  	xfs_daddr_t		parent_blkno, child_blkno;
>  	struct xfs_buf		*child_bp;
>  	struct xfs_da3_icnode_hdr ichdr;
> -	int			error, i;
> +	int			error, i, done;
> +	xfs_filblks_t		count = mp->m_attr_geo->fsbcount;
>  
>  	/*
>  	 * Since this code is recursive (gasp!) we must protect ourselves.
> @@ -172,10 +174,13 @@ xfs_attr3_node_inactive(
>  		 * traversal of the tree so we may deal with many blocks
>  		 * before we come back to this one.
>  		 */
> -		error = xfs_da3_node_read(*trans, dp, child_fsb, &child_bp,
> -					  XFS_ATTR_FORK);
> +		error = __xfs_da3_node_read(*trans, dp, child_fsb,
> +					    XFS_DABUF_MAP_HOLE_OK, &child_bp,
> +					    XFS_ATTR_FORK);
>  		if (error)
>  			return error;
> +		if (!child_bp)
> +			goto next_entry;

Hmmmm. If the kernel is down-graded after a crash with this
invalidation in progress, the older kernel that doesn't have this
check will crash, right?

I suspect that anything we do here will have that same problem,
but this is the sort of thing the commit message needs to point
out because it is an important consideration in determining if this
is the best fix or not...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
