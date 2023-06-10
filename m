Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1075CC7EE25
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jun 2023 02:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjFJCoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 22:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjFJCoP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2023 22:44:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D40130F4
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 19:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DCB6601B6
        for <linux-xfs@vger.kernel.org>; Sat, 10 Jun 2023 02:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B49C433EF;
        Sat, 10 Jun 2023 02:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686365053;
        bh=MZPvJV/vySo3GBzvGwUOCKCnpDsSHlDswCA55TugBDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mje6pEah7re230x7KZQ7XMpwWLKlR02MqYMsGIe43UriUbUkj12NRzI2By5GHHRka
         4KmMlDFgoD8qzbQW0kQJ2z991efRBmxVN2rbE123ovaMMalQfFZHUWw7/GcyVZ964L
         jPqX+mOnEhsyOOeXHTWQy6tlCF83arGV4aWIQIYH+CoMGvoiQa+isYdJ+SOg7XsPxx
         X+9pZyrwLBVG0f6SpmwDcVjzpIaKq8w4ED9CG/IDrge49UQDJvvOgWz8uUA53UpQqZ
         qW9SYwuoQgUUABwjC8RbkuomZeM+FPsrG0bwhFtgl0CsqLGGHtpMEby5Tb0cdZWCM9
         uhsZUqBuEeiMg==
Date:   Fri, 9 Jun 2023 19:44:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH]xfs_repair: fix the problem of repair failure caused by
 dirty flag being abnormally set on buffer
Message-ID: <20230610024412.GT72267@frogsfrogsfrogs>
References: <0bdbc18a-e062-9d39-2d01-75a0480c692e@huawei.com>
 <eb138689-d7c9-5d1c-d7bf-acdf2859a879@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb138689-d7c9-5d1c-d7bf-acdf2859a879@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2023 at 09:08:01AM +0800, Wu Guanghao wrote:
> We found an issue where repair failed in the fault injection.
> 
> $ xfs_repair test.img
> ...
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
> Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
>         - agno = 3
> Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
> btree block 0/41901 is suspect, error -74
> bad magic # 0x58534c4d in inode 3306572 (data fork) bmbt block 41901
> bad data fork in inode 3306572
> cleared inode 3306572
> ...
> Phase 7 - verify and correct link counts...
> Metadata corruption detected at 0x55a30e420b58, xfs_bmbt block 0x51d68/0x1000
> libxfs_bwrite: write verifier failed on xfs_bmbt bno 0x51d68/0x8
> xfs_repair: Releasing dirty buffer to free list!
> xfs_repair: Refusing to write a corrupt buffer to the data device!
> xfs_repair: Lost a write to the data device!
> 
> fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.
> 
> 
> $ xfs_db test.img
> xfs_db> inode 3306572
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0100666		  // regular file
> core.version = 3
> core.format = 3 (btree)	
> ...
> u3.bmbt.keys[1] = [startoff]
> 1:[6]
> u3.bmbt.ptrs[1] = 41901	 // btree root
> ...
> 
> $ hexdump -C -n 4096 41901.img
> 00000000  58 53 4c 4d 00 00 00 00  00 00 01 e8 d6 f4 03 14  |XSLM............|
> 00000010  09 f3 a6 1b 0a 3c 45 5a  96 39 41 ac 09 2f 66 99  |.....<EZ.9A../f.|
> 00000020  00 00 00 00 00 05 1f fb  00 00 00 00 00 05 1d 68  |...............h|
> ...
> 
> The block data associated with inode 3306572 is abnormal, but check the CRC first
> when reading. If the CRC check fails, badcrc will be set. Then the dirty flag
> will be set on bp when badcrc is set. In the final stage of repair, the dirty bp
> will be refreshed in batches. When refresh to the disk, the data in bp will be
> verified. At this time, if the data verification fails, resulting in a repair
> error.
> 
> After scan_bmapbt returns an error, the inode will be cleaned up. Then bp
> doesn't need to set dirty flag, so that it won't trigger writeback verification
> failure.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  repair/scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 7b720131..b5458eb8 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -185,7 +185,7 @@ scan_lbtree(
> 
>  	ASSERT(dirty == 0 || (dirty && !no_modify));
> 
> -	if ((dirty || badcrc) && !no_modify) {
> +	if (!err && (dirty || badcrc) && !no_modify) {
>  		libxfs_buf_mark_dirty(bp);
>  		libxfs_buf_relse(bp);

Hm.  So if scan_lbtree returns 1, that means that we clear the inode.
Hence there's no point in dirtying this buffer since we're going to zap
the whole inode anyway.

This looks correct to me, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

But that said, you could refactor this part:

	if (!err && (dirty || badcrc) && !no_modify)
		libxfs_buf_mark_dirty(bp);
	libxfs_buf_relse(bp);

More questions: Let's say that the btree-format fork has this btree:

        fork
       / | \
      A  B  C

Are there any cases where A is corrupt enough that the write verifier
will trip but scan_lbtree/scan_bmapbt return 0?

Or, let's say that we dirty A, then scan_bmapbt decides that B is total
garbage and returns 1.  Should we then mark A stale so that it doesn't
get written out unnecessarily?

Or, let's say that A is corrupt enough to trip the write verifier but
scan_lbtree/scan_bmapbt return 0; and B is corrupt enough that
scan_bmapbt returns 1.  In that case, we'd need to mark A stale so that
we clear the inode and repair can complete without tripping over A or B.
Does that actually happen?

--D

>  	}
> -- 
> 2.27.0
> 
