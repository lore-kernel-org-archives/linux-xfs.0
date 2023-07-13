Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07877EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 05:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjGMFU0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjGMFUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 01:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3A32116
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 22:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF3461A0F
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 05:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22EBC433C8;
        Thu, 13 Jul 2023 05:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689225622;
        bh=8nc/JcZek1J/g/vF8iesTESFNrOHmywNGHeTxjH6CgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eyF31Dq2vwI0pMiDZVOLjjDg4/kqaeS2Y0s/0x1KcGAZPg4Ecproi9ipqrB0YGlrD
         0ZCV9ZYgGm2NKSF0vaYRW5RIJZBjY4UXZMMl2BLzy8lWe1o/2fzZjZThEa2fBzPy5p
         jIC+povCZU2Q7CkJpEN7RX+BVpwNDUgxWv13DH/RWy+Qhf+vX6RaugmFO8rk9HGoWl
         dZWnbaEZmsRET4XiAGARfFyrO8uhGuD9Bbuu2WTjYMtnPdXNVyWp7Ttu4DN/PTwRqK
         +QmzFsPj+rGSrEHbqvQ+tluZjNpWlWLePFXSSbaXqiPLetWUs/Cc52Tj0EFkibV4zB
         LQGowmybaqYDQ==
Date:   Wed, 12 Jul 2023 22:20:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH]xfs_repair: fix the problem of repair failure caused by
 dirty flag being abnormally set on buffer
Message-ID: <20230713052022.GP108251@frogsfrogsfrogs>
References: <0bdbc18a-e062-9d39-2d01-75a0480c692e@huawei.com>
 <eb138689-d7c9-5d1c-d7bf-acdf2859a879@huawei.com>
 <20230610024412.GT72267@frogsfrogsfrogs>
 <426f7bd4-1b31-664e-bff0-68d9d26940fb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <426f7bd4-1b31-664e-bff0-68d9d26940fb@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 10:36:09AM +0800, Wu Guanghao wrote:
> 
> 
> 在 2023/6/10 10:44, Darrick J. Wong 写道:
> > On Fri, Jun 09, 2023 at 09:08:01AM +0800, Wu Guanghao wrote:
> >> We found an issue where repair failed in the fault injection.
> >>
> >> $ xfs_repair test.img
> >> ...
> >> Phase 3 - for each AG...
> >>         - scan and clear agi unlinked lists...
> >>         - process known inodes and perform inode discovery...
> >>         - agno = 0
> >>         - agno = 1
> >>         - agno = 2
> >> Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
> >>         - agno = 3
> >> Metadata CRC error detected at 0x55a30e420c7d, xfs_bmbt block 0x51d68/0x1000
> >> btree block 0/41901 is suspect, error -74
> >> bad magic # 0x58534c4d in inode 3306572 (data fork) bmbt block 41901
> >> bad data fork in inode 3306572
> >> cleared inode 3306572
> >> ...
> >> Phase 7 - verify and correct link counts...
> >> Metadata corruption detected at 0x55a30e420b58, xfs_bmbt block 0x51d68/0x1000
> >> libxfs_bwrite: write verifier failed on xfs_bmbt bno 0x51d68/0x8
> >> xfs_repair: Releasing dirty buffer to free list!
> >> xfs_repair: Refusing to write a corrupt buffer to the data device!
> >> xfs_repair: Lost a write to the data device!
> >>
> >> fatal error -- File system metadata writeout failed, err=117.  Re-run xfs_repair.
> >>
> >>
> >> $ xfs_db test.img
> >> xfs_db> inode 3306572
> >> xfs_db> p
> >> core.magic = 0x494e
> >> core.mode = 0100666		  // regular file
> >> core.version = 3
> >> core.format = 3 (btree)	
> >> ...
> >> u3.bmbt.keys[1] = [startoff]
> >> 1:[6]
> >> u3.bmbt.ptrs[1] = 41901	 // btree root
> >> ...
> >>
> >> $ hexdump -C -n 4096 41901.img
> >> 00000000  58 53 4c 4d 00 00 00 00  00 00 01 e8 d6 f4 03 14  |XSLM............|
> >> 00000010  09 f3 a6 1b 0a 3c 45 5a  96 39 41 ac 09 2f 66 99  |.....<EZ.9A../f.|
> >> 00000020  00 00 00 00 00 05 1f fb  00 00 00 00 00 05 1d 68  |...............h|
> >> ...
> >>
> >> The block data associated with inode 3306572 is abnormal, but check the CRC first
> >> when reading. If the CRC check fails, badcrc will be set. Then the dirty flag
> >> will be set on bp when badcrc is set. In the final stage of repair, the dirty bp
> >> will be refreshed in batches. When refresh to the disk, the data in bp will be
> >> verified. At this time, if the data verification fails, resulting in a repair
> >> error.
> >>
> >> After scan_bmapbt returns an error, the inode will be cleaned up. Then bp
> >> doesn't need to set dirty flag, so that it won't trigger writeback verification
> >> failure.
> >>
> >> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> >> ---
> >>  repair/scan.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/repair/scan.c b/repair/scan.c
> >> index 7b720131..b5458eb8 100644
> >> --- a/repair/scan.c
> >> +++ b/repair/scan.c
> >> @@ -185,7 +185,7 @@ scan_lbtree(
> >>
> >>  	ASSERT(dirty == 0 || (dirty && !no_modify));
> >>
> >> -	if ((dirty || badcrc) && !no_modify) {
> >> +	if (!err && (dirty || badcrc) && !no_modify) {
> >>  		libxfs_buf_mark_dirty(bp);
> >>  		libxfs_buf_relse(bp);
> > 
> > Hm.  So if scan_lbtree returns 1, that means that we clear the inode.
> > Hence there's no point in dirtying this buffer since we're going to zap
> > the whole inode anyway.
> > 
> > This looks correct to me, so
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > But that said, you could refactor this part:
> > 
> > 	if (!err && (dirty || badcrc) && !no_modify)
> > 		libxfs_buf_mark_dirty(bp);
> > 	libxfs_buf_relse(bp);
> > 
> > More questions: Let's say that the btree-format fork has this btree:
> > 
> >         fork
> >        / | \
> >       A  B  C
> > 
> > Are there any cases where A is corrupt enough that the write verifier
> > will trip but scan_lbtree/scan_bmapbt return 0?
> > 
> I'm sorry for replying so late.

Don't worry about it, I'm just as slow. :)

> This situation should not exist.
> scan_bmapbt() performs the following checks:
> 1. Check the magic of the block
> 2. Check the level of the block
> 3. Check which inode the owner of the block belongs to.
> 4. If it is a V5 filesystem,it will check three items: UUID, block consistency,
> and which inode the block belongs to.
> 5. Calculate which AG the block belongs to and see the usage of the block
> 6. If it is a leaf node, it will check whether the number of records exceeds the maximum value
> 
> xfs_bmbt_write_verify() performs the following checks:
> 1. Check the magic of the block
> 2. If it is a V5 filesystem,it will check three items: UUID, block consistency,
> and which inode the block belongs to.
> 3. Check if the level of the block is within the specified range
> 4. Check if the number of nodes in the block record exceeds the maximum limit
> 5. Check if the left and right nodes of the block are within the range of the file system
> 
> As can be seen from above, scan_bmapbt() checks more and in more detail than
> xfs_bmbt_write_verify(). Therefore, if scan_bmapbt() returns 0,
> xfs_bmbt_write_verify() will not report an error.
> 
> > Or, let's say that we dirty A, then scan_bmapbt decides that B is total
> > garbage and returns 1.  Should we then mark A stale so that it doesn't
> > get written out unnecessarily?
> > 
> We can allocate space in process_btinode() and pass it to scan_lbtree/scan_bmapbt.
> If a bp is set as dirty, we record it. If the inode needs to be cleaned up,
> we set all recorded bps as stale.However, this does not affect the repair process.
> Even if no record is kept, it only adds some unnecessary data writing.
> 
> If there is nothing wrong with this，I will push V2 patch.

Hmm.  It's tempting to have scan_bmapbt put all the buffers it finds on
a list.  The corrected ones would be marked dirty, the good ones just
end up on the list.  If we decide to kill the bmbt we can then
invalidate all the buffers.  If we keep it, then we can write the dirty
blocks.

Ugh.  But that gets gross -- if the bmbt is larger than memory, we then
can end up OOMing xfs_repair.  Creating an interval bitmap of fsblock
numbers visited buffers might be less bad, but who knows.

(Or I guess we could just apply this patch and see if anyone complains
about A being written after we decided to kill the bmbt due to B. ;))

--D

> Thanks
> 
> Guanghao
> 
> > Or, let's say that A is corrupt enough to trip the write verifier but
> > scan_lbtree/scan_bmapbt return 0; and B is corrupt enough that
> > scan_bmapbt returns 1.  In that case, we'd need to mark A stale so that
> > we clear the inode and repair can complete without tripping over A or B.
> > Does that actually happen?
> > 
> 
> > --D
> > 
> >>  	}
> >> -- 
> >> 2.27.0
> >>
> > .
> > 
