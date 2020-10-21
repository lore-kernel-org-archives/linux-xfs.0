Return-Path: <SRS0=FA9X=D4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D777AC4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50FF122249
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 09:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RHOQIezf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438313AbgJUJzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:55:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409250AbgJUJzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Oct 2020 05:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603274128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ow5t4pDe7zGSND9ilgio5C5itsjqu5EFch0N6vA90Io=;
        b=RHOQIezfFHpKSUBI3Wu4YMaeLug04M+TRG/eMBX6madpuANXKj6ynZGQr2kNDsAv+B6mUd
        rZJrnIjHGouIZuYZBIicSmXjSNPerAYa84Rp9MulRvUJy47XOQNQJPzppYoK6CGTD1gASy
        wEcQvctEtIF1Rv7A2oiDsEc3AqaLEiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-ZQnwJVxvM0yvOTILy5VosA-1; Wed, 21 Oct 2020 05:55:26 -0400
X-MC-Unique: ZQnwJVxvM0yvOTILy5VosA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE8B710866A7;
        Wed, 21 Oct 2020 09:55:24 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D3C410002A4;
        Wed, 21 Oct 2020 09:55:21 +0000 (UTC)
Date:   Wed, 21 Oct 2020 05:55:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201021095519.GA1327166@bfoster>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014170139.GC1109375@bfoster>
 <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20201020145012.GA1272590@bfoster>
 <20201021031922.GA31275@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021031922.GA31275@hsiangkao-HP-ZHAN-66-Pro-G1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 11:19:28AM +0800, Gao Xiang wrote:
> On Tue, Oct 20, 2020 at 10:50:12AM -0400, Brian Foster wrote:
> > On Thu, Oct 15, 2020 at 09:49:15AM +0800, Gao Xiang wrote:
> 
> ...
> 
> > > > 
> > > > Interesting... this seems fundamentally sane when narrowing the scope
> > > > down to tail AG shrinking. Does xfs_repair flag any issues in the simple
> > > > tail AG shrink case?
> > > 
> > > Yeah, I ran xfs_repair together as well, For smaller sizes, it seems
> > > all fine, but I did observe some failure when much larger values
> > > passed in, so as a formal patch, it really needs to be solved later.
> > > 
> > 
> > I'm curious to see what xfs_repair complained about if you have a record
> > of it. That might call out some other things we could be overlooking.
> 
> Sorry for somewhat slow progress...
> 
> it could show random "SB summary counter sanity check failed" runtime message
> when the shrink size is large (much close to ag start).
> 

Ok. That error looks associated with a few different checks:

        if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
            (sbp->sb_fdblocks > sbp->sb_dblocks ||
             !xfs_verify_icount(mp, sbp->sb_icount) ||
             sbp->sb_ifree > sbp->sb_icount)) {
                xfs_warn(mp, "SB summary counter sanity check failed");
                return -EFSCORRUPTED;
        }

Though I think the inode counters should be a subset of allocated space
(i.e. inode chunks) so are unlikely to be impacted by a removal of free
space. Without looking into details, I'd guess it's most likely just an
accounting bug and it's easiest to dump the relevant values that land in
the superblock and work backwards from there. FWIW, the followon
shutdown, repair (dirty log) and log recovery behavior (write and read
verifier failures) are typical and to be expected on metadata
corruption. IOW, I suspect that if we address the write verifier
failure, the followon issues will likely be resolved as well.

> # mkfs.xfs -mrmapbt=1 -f /dev/sdb
> meta-data=/dev/sdb               isize=512    agcount=4, agsize=98304 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1
> data     =                       bsize=4096   blocks=393216, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=3693, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> (98304*3 = 294912)
> 
> # /tmp/mnt1/shrink /tmp/mnt2 297000
> # /tmp/mnt1/shrink /tmp/mnt2 296999
> # /tmp/mnt1/shrink /tmp/mnt2 296998
> # /tmp/mnt1/shrink /tmp/mnt2 296997
> [   76.852075] XFS (sdb): SB summary counter sanity check failed
> [   76.854958] XFS (sdb): Metadata corruption detected at xfs_sb_write_verify+0x57/0x100, xfs_sb block 0xffffffffffffffff                                                                                         
> [   76.859602] XFS (sdb): Unmount and run xfs_repair
> [   76.861311] XFS (sdb): First 128 bytes of corrupted metadata buffer:
> [   76.864794] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 88 25  XFSB...........%
> [   76.869368] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   76.871662] 00000020: 01 fa 92 14 04 e7 4f 7e 8e 65 77 bd ff d9 d2 f9  ......O~.ew.....
> [   76.873636] 00000030: 00 00 00 00 00 04 00 07 00 00 00 00 00 00 00 80  ................
> [   76.875544] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> [   76.877050] 00000050: 00 00 00 01 00 01 80 00 00 00 00 04 00 00 00 00  ................
> [   76.878473] 00000060: 00 00 0e 6d b4 a5 02 00 02 00 00 08 00 00 00 00  ...m............
> [   76.879634] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 11 00 00 00  ................
> [   76.880818] XFS (sdb): xfs_do_force_shutdown(0x8) called from line 1582 of file fs/xfs/xfs_buf.c. Return address = ffffffffbbbb7e84                                                                            
> [   76.882223] XFS (sdb): Corruption of in-memory data detected.  Shutting down filesystem
> [   76.883187] XFS (sdb): Please unmount the filesystem and rectify the problem(s)
> 
> and
> 
> # xfs_repair /dev/sdb
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> 
> cannot replay the log as well, as follows:
> # mount /dev/sdb /tmp/mnt2
> [  298.811478] XFS (sdb): Mounting V5 Filesystem
> [  298.888455] XFS (sdb): Starting recovery (logdev: internal)
> [  298.892614] XFS (sdb): SB summary counter sanity check failed
> [  298.893201] XFS (sdb): Metadata corruption detected at xfs_sb_write_verify+0x57/0x100, xfs_sb block 0x0
> [  298.894113] XFS (sdb): Unmount and run xfs_repair
> [  298.894572] XFS (sdb): First 128 bytes of corrupted metadata buffer:
> [  298.895180] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 88 26  XFSB...........&
> [  298.895965] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  298.896777] 00000020: 01 fa 92 14 04 e7 4f 7e 8e 65 77 bd ff d9 d2 f9  ......O~.ew.....
> [  298.897564] 00000030: 00 00 00 00 00 04 00 07 00 00 00 00 00 00 00 80  ................
> [  298.898330] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> [  298.899111] 00000050: 00 00 00 01 00 01 80 00 00 00 00 04 00 00 00 00  ................
> [  298.900075] 00000060: 00 00 0e 6d b4 a5 02 00 02 00 00 08 00 00 00 00  ...m............
> [  298.901130] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 11 00 00 00  ................
> [  298.902142] XFS (sdb): xfs_do_force_shutdown(0x8) called from line 1582 of file fs/xfs/xfs_buf.c. Return address = ffffffffbbbb7e84
> [  298.903564] XFS (sdb): Corruption of in-memory data detected.  Shutting down filesystem
> [  298.904559] XFS (sdb): Please unmount the filesystem and rectify the problem(s)
> [  298.905477] XFS (sdb): log mount/recovery failed: error -117
> [  298.906258] XFS (sdb): log mount failed
> 
> and ignore the log is not working as well.
> # xfs_repair -L /dev/sdb
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> invalid length 98291 in record 0 of bno btree block 3/1
> invalid length 98291 in record 0 of cnt btree block 3/2
> agf_freeblks 98291, counted 0 in ag 3
> agf_longest 98291, counted 0 in ag 3
> sb_icount 0, counted 64
> sb_ifree 0, counted 61
> sb_fdblocks 0, counted 291196
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
> 
> fatal error -- unable to add AG 0 reverse-mapping data to btree.
> 
> 
> I haven't digged into that for now, will look into that later.
> 
> > 
> 
> ...
> 
> > > 
> > > > > +int
> > > > > +xfs_alloc_vextent_shrink(
> > > > > +	struct xfs_trans	*tp,
> > > > > +	struct xfs_buf		*agbp,
> > > > > +	xfs_agblock_t		agbno,
> > > > > +	xfs_extlen_t		len)
> > > > > +{
> > > > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > > > +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> > > > > +	struct xfs_alloc_arg	args = {
> > > > > +		.tp = tp,
> > > > > +		.mp = mp,
> > > > > +		.type = XFS_ALLOCTYPE_THIS_BNO,
> > > > > +		.agbp = agbp,
> > > > > +		.agno = agno,
> > > > > +		.agbno = agbno,
> > > > > +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
> > > > > +		.minlen = len,
> > > > > +		.maxlen = len,
> > > > > +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> > > > > +		.resv = XFS_AG_RESV_NONE,
> > > > > +		.prod = 1,
> > > > > +		.alignment = 1,
> > > > > +		.pag = agbp->b_pag
> > > > > +	};
> > > > > +	int			error;
> > > > > +
> > > > > +	error = xfs_alloc_ag_vextent_exact(&args);
> > > > > +	if (error || args.agbno == NULLAGBLOCK)
> > > > > +		return -EBUSY;
> > > > 
> > > > I think it's generally better to call into the top-level allocator API
> > > > (xfs_alloc_vextent()) because it will handle internal allocator business
> > > > like fixing up the AGFL and whatnot. Then you probably don't have to
> > > > specify as much in the args structure as well. The allocation mode
> > > > you've specified (THIS_BNO) will fall into the exact allocation codepath
> > > > and should enforce the semantics we need here (i.e. grant the exact
> > > > allocation or fail).
> > > 
> > > Actually, I did in the same way (use xfs_alloc_vextent()) in my previous
> > > hack version
> > > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4
> > > 
> > > yet Dave pointed out in private agfl fix could dirty the transaction
> > > and if the later allocation fails, it would be unsafe to cancel
> > > the dirty transaction. So as far as my current XFS knowledge, I think
> > > that makes sense so I introduce a separate helper
> > > xfs_alloc_vextent_shrink()...
> > > 
> > 
> > Yeah, I could see that being an issue. I'm curious if we're exposed to
> > that problem with exact allocation requests in other places.  We only
> > use it in a couple places that look like they have fallback allocation
> > requests. Combine that with the pre-allocation space checks and perhaps
> > this isn't something we'd currently hit in practice.
> > 
> > That said, I don't think this justifies diving directly into the lower
> > levels of the allocator (or branching any of the code, etc.). I suspect
> > not doing the agfl fixups and whatnot could cause other problems if they
> > are ultimately required for the subsequent allocation. The easiest
> > workaround is to just commit the transaction instead of cancelling it
> > once the allocation call is made. A more involved followon fix might be
> > to improve the early checks for exact allocations, but it's not clear at
> > this stage if that's really worth the extra code. We might also
> > eventually want to handle that another way to ensure that the agfl fixup
> > doesn't actually do an allocation that conflicts with the shrink itself.
> 
> Ok, I will commit the transaction if the allocation fails and
> the transaction is dirty.
> 
> > 
> > > > 
> > > > We probably need to rethink the bit of logic above this check for
> > > > shrinking. It looks like the current code checks for the minimum
> > > > supported AG size and if not satisfied, reduces the size the grow to the
> > > > next smaller AG count. That would actually increase the size of the
> > > > shrink from what the user requested, so we'd probably want to do the
> > > > opposite and reduce the size of the requested shrink. For now it
> > > > probably doesn't matter much since we fail to shrink the agcount.
> > > > 
> > > > That said, if I'm following the growfs behavior correctly it might be
> > > > worth considering analogous behavior for shrink. E.g., if the user asks
> > > > to trim 10GB off the last AG but only the last 4GB are free, then shrink
> > > > the fs by 4GB and report the new size to the user.
> > > 
> > > I thought about this topic as well, yeah, anyway, I think it needs
> > > some clearer documented words about the behavior (round down or round
> > > up). My original idea is to unify them. But yeah, increase the size
> > > of the shrink might cause unexpected fail.
> > > 
> > 
> > It's probably debatable as to whether we should reduce the size of the
> > shrink or just fail the operation, but I think to increase the size of
> > the shrink from what the user requested (even if it occurs "by accident"
> > due to the AG size rules) is inappropriate. With regard to the former,
> > have you looked into how shrink behaves on other filesystems (ext4)? I
> > think one advantage of shrinking what's available is to at least give
> > the user an opportunity to make incremental progress.
> 
> I quickly check what resize2fs does.
> 
> errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
> 			 ext2fs_block_bitmap reserve_blocks, blk64_t new_size)
> ...
> 	ext2fs_blocks_count_set(fs->super, new_size);
> 	fs->super->s_overhead_clusters = 0;
> 
> retry:
> ...
> 	/*
> 	 * Overhead is the number of bookkeeping blocks per group.  It
> 	 * includes the superblock backup, the group descriptor
> 	 * backups, the inode bitmap, the block bitmap, and the inode
> 	 * table.
> 	 */
> 	overhead = (int) (2 + fs->inode_blocks_per_group);
> ...
> 	/*
> 	 * See if the last group is big enough to support the
> 	 * necessary data structures.  If not, we need to get rid of
> 	 * it.
> 	 */
> 	rem = (ext2fs_blocks_count(fs->super) - fs->super->s_first_data_block) %
> 		fs->super->s_blocks_per_group;
> 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
> 		return EXT2_ET_TOOSMALL;
> 	if ((fs->group_desc_count > 1) && rem && (rem < overhead+50)) {
> 		ext2fs_blocks_count_set(fs->super,
> 					ext2fs_blocks_count(fs->super) - rem);
> 		goto retry;
> 	}
> 
> from the code itself it seems for some cases it increases the size of
> the shrink from what the user requested. and for the other cases, it
> just errors out.
> 
> and I also tried with some configuration:
> 
> First block:              1
> Block size:               1024
> Fragment size:            1024
> Group descriptor size:    64
> Reserved GDT blocks:      256
> Blocks per group:         8192
> Fragments per group:      8192
> Inodes per group:         2016
> Inode blocks per group:   252
> 
> # resize2fs test.ext4.img 262500
> resize2fs 1.44.5 (15-Dec-2018)
> Resizing the filesystem on test.ext4.img to 262500 (1k) blocks.
> The filesystem on test.ext4.img is now 262500 (1k) blocks long.
> 
> # resize2fs test.ext4.img 262403
> resize2fs 1.44.5 (15-Dec-2018)
> Resizing the filesystem on test.ext4.img to 262403 (1k) blocks.
> The filesystem on test.ext4.img is now 262145 (1k) blocks long.
> 

Interesting. It looks like there's similar logic around having a minimum
size "allocation group" to support internal structures, but I really
don't know enough about ext4 to comment further. I suppose this behavior
does make sense if you consider that a common purpose of shrink is to
inform the filesystem of a pending block device size change. In that
case, the desired result is to ensure the fs fits within the new,
smaller device and thus it might make sense to either increase the size
of the shrink and otherwise have straightforward success or failure
semantics. Thanks for the research.

Brian

> > 
> 
> ...
> 
> > > 
> > > > 
> > > > >  	oagcount = mp->m_sb.sb_agcount;
> > > > >  
> > > > >  	/* allocate the new per-ag structures */
> > > > > @@ -67,10 +77,14 @@ xfs_growfs_data_private(
> > > > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > > > >  		if (error)
> > > > >  			return error;
> > > > > +	} else if (nagcount != oagcount) {
> > > > > +		/* TODO: shrinking a whole AG hasn't yet implemented */
> > > > > +		return -EINVAL;
> > > > >  	}
> > > > >  
> > > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > > > +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
> > > > > +			XFS_TRANS_RESERVE, &tp);
> > > > >  	if (error)
> > > > >  		return error;
> > > > >  
> > > > > @@ -103,15 +117,22 @@ xfs_growfs_data_private(
> > > > >  			goto out_trans_cancel;
> > > > >  		}
> > > > >  	}
> > > > > -	error = xfs_buf_delwri_submit(&id.buffer_list);
> > > > > -	if (error)
> > > > > -		goto out_trans_cancel;
> > > > > +
> > > > > +	if (!list_empty(&id.buffer_list)) {
> > > > > +		error = xfs_buf_delwri_submit(&id.buffer_list);
> > > > > +		if (error)
> > > > > +			goto out_trans_cancel;
> > > > > +	}
> > > > 
> > > > The list check seems somewhat superfluous since we won't do anything
> > > > with an empty list anyways. Presumably it would be incorrect to ever
> > > > init a new AG on shrink so it might be cleaner to eventually refactor
> > > > this bit of logic out into a helper that we only call on extend since
> > > > this is a new AG initialization mechanism.
> > > 
> > > Yeah, actually my previous hack version
> > > https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4
> > > 
> > > did like this, but in this version I'd like to avoid touching unrelated
> > > topic as much as possible.
> > > 
> > > xfs_buf_delwri_submit() is not no-op for empty lists. Anyway, I will
> > > use 2 independent logic for entire extend / shrink seperately.
> > > 
> > 
> > I'm not sure we need to split out the entire function. It just might
> > make some sense to refactor the existing code a bit so the common code
> > is clearly readable for shrink/grow and that any larger hunks of code
> > specific to either grow or shrink are factored out into separate
> > functions.
> 
> Ok.
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > Thanks for your suggestion!
> > > 
> > > Thanks,
> > > Gao Xiang
> > > 
> > > > 
> > > > Brian
> > > 
> > 
> 

