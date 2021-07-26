Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66A9C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9788A60F6C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhGZRQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhGZRQd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 13:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B826660F8F;
        Mon, 26 Jul 2021 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627322221;
        bh=a4G+rsgJ0+ruT2bjk5+Dy0MrhhqDo9qimCH1XHqbINU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4cubjnFBtplID0t0TSlXFybLj5efC7MMDttZuXjAUFpganbVe1efIpM5sWTXnLP9
         7jhL3R3aMQcTgudxwKJqmAGKnDJ4MUWXFXIAf1RKR+8SHb10fDe1/KTB6rgoo2Zwfr
         bjH1zXH9f0FA1jbDMTLJyA9iPB9r9hruIkjmWiLYcCGRapKcFYloJJOdsj5KrL3p96
         bSjHO2repb1lmeXk6T/hJE6v4OBB2QFApalkrQZ7+niRC4QzOjGatZG6p3KKUeYfRH
         V1TnBDaYiL5EUMYYon0fPHrXDYCd9Z/m5z2NQF4ucXzEfN0mTzgeldnDRDA8R5AhMj
         pHCl/QlxzLI6w==
Date:   Mon, 26 Jul 2021 10:57:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: Enforce attr3 buffer recovery order
Message-ID: <20210726175701.GY559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From the department of "WTAF? How did we miss that!?"...
> 
> When we are recovering a buffer, the first thing we do is check the
> buffer magic number and extract the LSN from the buffer. If the LSN
> is older than the current LSN, we replay the modification to it. If
> the metadata on disk is newer than the transaction in the log, we
> skip it. This is a fundamental v5 filesystem metadata recovery
> behaviour.
> 
> generic/482 failed with an attribute writeback failure during log
> recovery. The write verifier caught the corruption before it got
> written to disk, and the attr buffer dump looked like:
> 
> XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_verify+0x275/0x2e0, xfs_attr3_leaf block 0x19be8
> XFS (dm-3): Unmount and run xfs_repair
> XFS (dm-3): First 128 bytes of corrupted metadata buffer:
> 00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 4d 2a 01 e1  ........;...M*..
> 00000010: 00 00 00 00 00 01 9b e8 00 00 00 01 00 00 05 38  ...............8
>                                   ^^^^^^^^^^^^^^^^^^^^^^^
> 00000020: df 39 5e 51 58 ac 44 b6 8d c5 e7 10 44 09 bc 17  .9^QX.D.....D...
> 00000030: 00 00 00 00 00 02 00 83 00 03 00 cc 0f 24 01 00  .............$..
> 00000040: 00 68 0e bc 0f c8 00 10 00 00 00 00 00 00 00 00  .h..............
> 00000050: 00 00 3c 31 0f 24 01 00 00 00 3c 32 0f 88 01 00  ..<1.$....<2....
> 00000060: 00 00 3c 33 0f d8 01 00 00 00 00 00 00 00 00 00  ..<3............
> 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> .....
> 
> The highlighted bytes are the LSN that was replayed into the
> buffer: 0x100000538. This is cycle 1, block 0x538. Prior to replay,
> that block on disk looks like this:
> 
> $ sudo xfs_db -c "fsb 0x417d" -c "type attr3" -c p /dev/mapper/thin-vol
> hdr.info.hdr.forw = 0
> hdr.info.hdr.back = 0
> hdr.info.hdr.magic = 0x3bee
> hdr.info.crc = 0xb5af0bc6 (correct)
> hdr.info.bno = 105448
> hdr.info.lsn = 0x100000900
>                ^^^^^^^^^^^
> hdr.info.uuid = df395e51-58ac-44b6-8dc5-e7104409bc17
> hdr.info.owner = 131203
> hdr.count = 2
> hdr.usedbytes = 120
> hdr.firstused = 3796
> hdr.holes = 1
> hdr.freemap[0-2] = [base,size]
> 
> Note the LSN stamped into the buffer on disk: 1/0x900. The version
> on disk is much newer than the log transaction that was being
> replayed. That's a bug, and should -never- happen.
> 
> So I immediately went to look at xlog_recover_get_buf_lsn() to check
> that we handled the LSN correctly. I was wondering if there was a
> similar "two commits with the same start LSN skips the second
> replay" problem with buffers. I didn't get that far, because I found
> a much more basic, rudimentary bug: xlog_recover_get_buf_lsn()
> doesn't recognise buffers with XFS_ATTR3_LEAF_MAGIC set in them!!!
> 
> IOWs, attr3 leaf buffers fall through the magic number checks
> unrecognised, so trigger the "recover immediately" behaviour instead
> of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
> buffers and that causes silent on disk corruption of inode attribute
> forks and potentially other things....
> 
> Git history shows this is *another* zero day bug, this time
> introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
> superblocks during recovery") which failed to handle the attr3 leaf
> buffers in recovery. And we've failed to handle them ever since...

I wonder, what happens if we happen to have a rt bitmap block where a
sparse allocation pattern at the start of the rt device just happens to
match one of these magic numbers + fs UUID?  Does that imply that log
recovery can be tricked into forgetting to replay rtbitmap blocks?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item_recover.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index d44e8b4a3391..05fd816edf59 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -796,6 +796,7 @@ xlog_recover_get_buf_lsn(
>  	switch (magicda) {
>  	case XFS_DIR3_LEAF1_MAGIC:
>  	case XFS_DIR3_LEAFN_MAGIC:
> +	case XFS_ATTR3_LEAF_MAGIC:
>  	case XFS_DA3_NODE_MAGIC:
>  		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
>  		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
> -- 
> 2.31.1
> 
