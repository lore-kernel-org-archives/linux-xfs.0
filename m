Return-Path: <SRS0=FA9X=D4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C969C388F9
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 13:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DA322249
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 13:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b72nf6/F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408672AbgJUNVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 09:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404801AbgJUNVZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Oct 2020 09:21:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603286482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sx3CLE+7AS9/xeQWK7EDHFhDB4umOTjrEB9hjciD+88=;
        b=b72nf6/F6708cgsmbtSXrVc/cgjJ0VDQ/RMp6a5u/+GPFUxoL27IqdwsZmBMRyrd1fDTVs
        o9QJE7lMc1X+EwigF9sreQYdEgULrXDQkrIGrreTcTc2Eq48XcNUZrBaGj1hW5xtygqnqZ
        TqBv5e5RN+sKKIIvoIgjU8xSHrdyfT8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-d13mBQyhNMiVCe337F7S4Q-1; Wed, 21 Oct 2020 09:21:20 -0400
X-MC-Unique: d13mBQyhNMiVCe337F7S4Q-1
Received: by mail-pf1-f198.google.com with SMTP id b195so1276817pfb.9
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2020 06:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sx3CLE+7AS9/xeQWK7EDHFhDB4umOTjrEB9hjciD+88=;
        b=jHl9rnuXrhCINo0rOIazJkLKFht+flzGrr5bPloSenQpzecAy94WKd01xA3/lKifiC
         cjgxnR+MEXnIkt6a1OlvahB9hlKdIgvuLfPyb7WBtb6MNrE72X8iOTTL8Yg0LKIZS65J
         8zE7Id0xxubo4EKKjiBEQGm9Ablu8SIG/FB+tnPwJxj3jc8QIxnoEmj/ap7WPrZMzl+m
         PboRPVz4w7pnSeX6hrGQH64yjSErJJ1/lQY4LzOndPQShm/cA2yGJsNYyEGGKedYoDxq
         ftzcoKPD/0ZnNQCDL9fUT6+Ev50KBNpU/0PN7UAfS/n8Qp7nCVG4LXiV2kgLjLGwUPq3
         670A==
X-Gm-Message-State: AOAM530h3wnJN9fQriEo/wplAbmkGyTIhLnf8lRgORk54lOjcdrPDKR+
        Q+YA/gXMps5uAlgN4ITEh4wzzdOX+Y63tVQ6ocX3oVx1oxk+Mu067BmBRqpE0M3GpDCRGA/WV/B
        S4UOKMKZs1wlZqjNMPZ+i
X-Received: by 2002:a65:6158:: with SMTP id o24mr3536539pgv.120.1603286478601;
        Wed, 21 Oct 2020 06:21:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykRNeVTO+kKx8IeBLg+XEcFAh2n19/rVk9ZVKf7/tZ6IgfhCQtiJceLuF0tKz3e3nl3Ue05g==
X-Received: by 2002:a65:6158:: with SMTP id o24mr3536520pgv.120.1603286478250;
        Wed, 21 Oct 2020 06:21:18 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 20sm2474113pfh.219.2020.10.21.06.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 06:21:17 -0700 (PDT)
Date:   Wed, 21 Oct 2020 21:21:08 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201021132108.GA25141@xiangao.remote.csb>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014170139.GC1109375@bfoster>
 <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20201020145012.GA1272590@bfoster>
 <20201021031922.GA31275@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20201021095519.GA1327166@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021095519.GA1327166@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 05:55:19AM -0400, Brian Foster wrote:
> On Wed, Oct 21, 2020 at 11:19:28AM +0800, Gao Xiang wrote:
> > On Tue, Oct 20, 2020 at 10:50:12AM -0400, Brian Foster wrote:
> > > On Thu, Oct 15, 2020 at 09:49:15AM +0800, Gao Xiang wrote:
> > 
> > ...
> > 
> > > > > 
> > > > > Interesting... this seems fundamentally sane when narrowing the scope
> > > > > down to tail AG shrinking. Does xfs_repair flag any issues in the simple
> > > > > tail AG shrink case?
> > > > 
> > > > Yeah, I ran xfs_repair together as well, For smaller sizes, it seems
> > > > all fine, but I did observe some failure when much larger values
> > > > passed in, so as a formal patch, it really needs to be solved later.
> > > > 
> > > 
> > > I'm curious to see what xfs_repair complained about if you have a record
> > > of it. That might call out some other things we could be overlooking.
> > 
> > Sorry for somewhat slow progress...
> > 
> > it could show random "SB summary counter sanity check failed" runtime message
> > when the shrink size is large (much close to ag start).
> > 
> 
> Ok. That error looks associated with a few different checks:
> 
>         if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
>             (sbp->sb_fdblocks > sbp->sb_dblocks ||
>              !xfs_verify_icount(mp, sbp->sb_icount) ||
>              sbp->sb_ifree > sbp->sb_icount)) {
>                 xfs_warn(mp, "SB summary counter sanity check failed");
>                 return -EFSCORRUPTED;
>         }
> 
> Though I think the inode counters should be a subset of allocated space
> (i.e. inode chunks) so are unlikely to be impacted by a removal of free
> space. Without looking into details, I'd guess it's most likely just an
> accounting bug and it's easiest to dump the relevant values that land in
> the superblock and work backwards from there. FWIW, the followon
> shutdown, repair (dirty log) and log recovery behavior (write and read
> verifier failures) are typical and to be expected on metadata
> corruption. IOW, I suspect that if we address the write verifier
> failure, the followon issues will likely be resolved as well.

After looking into a little bit, the exact failure condition is
sbp->sb_fdblocks > sbp->sb_dblocks,

and it seems sbp->sb_fdblocks doesn't decrease as expected when the shrink
size is large (in fact, it's still the number as the origin compared with
correct small shrink size) I'm still looking into what's exactly happening.

> 

...

> > > 
> > > It's probably debatable as to whether we should reduce the size of the
> > > shrink or just fail the operation, but I think to increase the size of
> > > the shrink from what the user requested (even if it occurs "by accident"
> > > due to the AG size rules) is inappropriate. With regard to the former,
> > > have you looked into how shrink behaves on other filesystems (ext4)? I
> > > think one advantage of shrinking what's available is to at least give
> > > the user an opportunity to make incremental progress.
> > 
> > I quickly check what resize2fs does.
> > 
> > errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
> > 			 ext2fs_block_bitmap reserve_blocks, blk64_t new_size)
> > ...
> > 	ext2fs_blocks_count_set(fs->super, new_size);
> > 	fs->super->s_overhead_clusters = 0;
> > 
> > retry:
> > ...
> > 	/*
> > 	 * Overhead is the number of bookkeeping blocks per group.  It
> > 	 * includes the superblock backup, the group descriptor
> > 	 * backups, the inode bitmap, the block bitmap, and the inode
> > 	 * table.
> > 	 */
> > 	overhead = (int) (2 + fs->inode_blocks_per_group);
> > ...
> > 	/*
> > 	 * See if the last group is big enough to support the
> > 	 * necessary data structures.  If not, we need to get rid of
> > 	 * it.
> > 	 */
> > 	rem = (ext2fs_blocks_count(fs->super) - fs->super->s_first_data_block) %
> > 		fs->super->s_blocks_per_group;
> > 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
> > 		return EXT2_ET_TOOSMALL;
> > 	if ((fs->group_desc_count > 1) && rem && (rem < overhead+50)) {
> > 		ext2fs_blocks_count_set(fs->super,
> > 					ext2fs_blocks_count(fs->super) - rem);
> > 		goto retry;
> > 	}
> > 
> > from the code itself it seems for some cases it increases the size of
> > the shrink from what the user requested. and for the other cases, it
> > just errors out.
> > 
> > and I also tried with some configuration:
> > 
> > First block:              1
> > Block size:               1024
> > Fragment size:            1024
> > Group descriptor size:    64
> > Reserved GDT blocks:      256
> > Blocks per group:         8192
> > Fragments per group:      8192
> > Inodes per group:         2016
> > Inode blocks per group:   252
> > 
> > # resize2fs test.ext4.img 262500
> > resize2fs 1.44.5 (15-Dec-2018)
> > Resizing the filesystem on test.ext4.img to 262500 (1k) blocks.
> > The filesystem on test.ext4.img is now 262500 (1k) blocks long.
> > 
> > # resize2fs test.ext4.img 262403
> > resize2fs 1.44.5 (15-Dec-2018)
> > Resizing the filesystem on test.ext4.img to 262403 (1k) blocks.
> > The filesystem on test.ext4.img is now 262145 (1k) blocks long.
> > 
> 
> Interesting. It looks like there's similar logic around having a minimum
> size "allocation group" to support internal structures, but I really
> don't know enough about ext4 to comment further. I suppose this behavior
> does make sense if you consider that a common purpose of shrink is to
> inform the filesystem of a pending block device size change. In that
> case, the desired result is to ensure the fs fits within the new,
> smaller device and thus it might make sense to either increase the size
> of the shrink and otherwise have straightforward success or failure
> semantics. Thanks for the research.

Yeah, I'm fine with either of that if we document the behavior well.

Thanks,
Gao Xiang

> 
> Brian
> 

