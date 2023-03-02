Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83765C6FA8E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 14:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCBOGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 09:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBOGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 09:06:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00A317146
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 06:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677765948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mzxqT/82eghJHi/A12/GzK4yJegSBl5g7iy38wvVo6c=;
        b=ZMZNkLk2xkP1ckSTZFc0HpWixyRcnugfJPQDJtd0YOuvjXkte9jB6UIwMu5JbFrvi/4PXd
        kKFE6Q7gcbtc+JxA6rzI6M4kSOSXVlX/xZsR7Q8k3kzOWkwv11O2vYeTq8GjE7oSCm/Muu
        qUJMO1YeTIxeL5wHgJSWpTVq1IWzl/c=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-538-30BCzfheN7WN2PkXeOhqMw-1; Thu, 02 Mar 2023 09:05:47 -0500
X-MC-Unique: 30BCzfheN7WN2PkXeOhqMw-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1728f81744fso9064985fac.15
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 06:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677765645;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzxqT/82eghJHi/A12/GzK4yJegSBl5g7iy38wvVo6c=;
        b=icMliQLkwe3swz27rZHA9EcLJ6E395QyyzEto8fSusDV09S67CAHj1wW80qI1L5s9t
         r+0fu+h2WGjArlS/THXgd0CQXcVhtj3E0mz3dcwV8DviN7TtE8tecP0pWrWTQG4R9/TK
         rTgI9bQp8Fm893yRgHhfocDM05LlbIrxmvgo5oMxr2zNw30aMbpFnv+uKhtMiP4OQJwH
         JE48hvDL1NOhABa2FB7J/mzrOg6orKtYyg8YT2m+cHNGigmC4EowbYMK25T4j6zswn1p
         P+3qZlVkNny5l5QVENJIDdLrN+TCSuhlAlHliKhGCBitIMvRGwggC013Q5EWfJVMC74q
         hCkg==
X-Gm-Message-State: AO0yUKXuUOM3Gzon4GjxarrL9ePr7gA6+ZjinYwYoEmaffZ0V/6P6+CK
        I7Xg76G1ZR0dKduPD2DAAD7f9BbE/fWZ9U6k6Tow3M+TQyNOgd18P9wx2gWsL2d9tKbBDz0+UYq
        lk5ouWC4FKCfiPYVRGq36
X-Received: by 2002:a05:6870:3322:b0:171:a571:2116 with SMTP id x34-20020a056870332200b00171a5712116mr6094381oae.9.1677765645659;
        Thu, 02 Mar 2023 06:00:45 -0800 (PST)
X-Google-Smtp-Source: AK7set+XXo0XybOq0+lg8x3/be2IvSuOu3oOvihizc9upCOP4ziqItFr1Ht0JiuPi0OpiNiAYGtv5Q==
X-Received: by 2002:a05:6870:3322:b0:171:a571:2116 with SMTP id x34-20020a056870332200b00171a5712116mr6094341oae.9.1677765644888;
        Thu, 02 Mar 2023 06:00:44 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q11-20020a37430b000000b00742a252ba06sm8744805qka.135.2023.03.02.06.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 06:00:44 -0800 (PST)
Date:   Thu, 2 Mar 2023 09:02:24 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [RFCv3 3/3] iomap: Support subpage size dirty tracking to
 improve write performance
Message-ID: <ZACscHnzmywRaXvu@bfoster>
References: <cover.1677428794.git.ritesh.list@gmail.com>
 <9650ef88e09c6227b99bb5793eef2b8e47994c7d.1677428795.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9650ef88e09c6227b99bb5793eef2b8e47994c7d.1677428795.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 01:13:32AM +0530, Ritesh Harjani (IBM) wrote:
> On a 64k pagesize platforms (specially Power and/or aarch64) with 4k
> filesystem blocksize, this patch should improve the performance by doing
> only the subpage dirty data write.
> 
> This should also reduce the write amplification since we can now track
> subpage dirty status within state bitmaps. Earlier we had to
> write the entire 64k page even if only a part of it (e.g. 4k) was
> updated.
> 
> Performance testing of below fio workload reveals ~16x performance
> improvement on nvme with XFS (4k blocksize) on Power (64K pagesize)
> FIO reported write bw scores improved from around ~28 MBps to ~452 MBps.
> 
> 1. <test_randwrite.fio>
> [global]
> 	ioengine=psync
> 	rw=randwrite
> 	overwrite=1
> 	pre_read=1
> 	direct=0
> 	bs=4k
> 	size=1G
> 	dir=./
> 	numjobs=8
> 	fdatasync=1
> 	runtime=60
> 	iodepth=64
> 	group_reporting=1
> 
> [fio-run]
> 
> 2. Also our internal performance team reported that this patch improves there
>    database workload performance by around ~83% (with XFS on Power)
> 
> Reported-by: Aravinda Herle <araherle@in.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/gfs2/aops.c         |   2 +-
>  fs/iomap/buffered-io.c | 104 +++++++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_aops.c      |   2 +-
>  fs/zonefs/super.c      |   2 +-
>  include/linux/iomap.h  |   1 +
>  5 files changed, 99 insertions(+), 12 deletions(-)
> 
...
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index e0b0be16278e..fb55183c547f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
...
> @@ -1630,7 +1715,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  		struct writeback_control *wbc, struct inode *inode,
>  		struct folio *folio, u64 end_pos)
>  {
> -	struct iomap_page *iop = iomap_page_create(inode, folio, 0);
> +	struct iomap_page *iop = iomap_page_create(inode, folio, 0, true);
>  	struct iomap_ioend *ioend, *next;
>  	unsigned len = i_blocksize(inode);
>  	unsigned nblocks = i_blocks_per_folio(inode, folio);
> @@ -1646,7 +1731,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
>  	 * invalid, grab a new one.
>  	 */
>  	for (i = 0; i < nblocks && pos < end_pos; i++, pos += len) {
> -		if (iop && !iop_test_uptodate(iop, i, nblocks))
> +		if (iop && !iop_test_dirty(iop, i, nblocks))
>  			continue;
> 
>  		error = wpc->ops->map_blocks(wpc, inode, pos);

Hi Ritesh,

I'm not sure if you followed any of the discussion on the imap
revalidation series that landed in the last cycle or so, but the
associated delalloc punch error handling code has a subtle dependency on
current writeback behavior and thus left a bit of a landmine for this
work. For reference, more detailed discussion starts around here [1].
The context is basically that the use of mapping seek hole/data relies
on uptodate status, which means in certain error cases the filesystem
might allocate a delalloc block for a write, but not punch it out of the
associated write happens to fail and the underlying portion of the folio
was uptodate.

This doesn't cause a problem in current mainline because writeback maps
every uptodate block in a dirty folio, and so the delalloc block will
convert at writeback time even though it wasn't written. This no longer
occurs with the change above, which means there's a vector for a stale
delalloc block to be left around in the inode. This is a free space
accounting corruption issue on XFS. Here's a quick example [2] on a 1k
FSB XFS filesystem to show exactly what I mean:

# xfs_io -fc "truncate 4k" -c "mmap 0 4k" -c "mread 0 4k" -c "pwrite 0 1" -c "pwrite -f 2k 1" -c fsync /mnt/file
# xfs_io -c "fiemap -v" /mnt/file 
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
...
   2: [4..5]:          0..1                 2   0x7
...
(the above shows delalloc after an fsync)
# umount /mnt
  kernel:XFS: Assertion failed: xfs_is_shutdown(mp) || percpu_counter_sum(&mp->m_delalloc_blks) == 0, file: fs/xfs/xfs_super.c, line: 1068
# xfs_repair -n /dev/vdb2 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
...
sb_fdblocks 20960187, counted 20960195
...
#

I suspect this means either the error handling code needs to be updated
to consider dirty state (i.e. punch delalloc if the block is !dirty), or
otherwise this needs to depend on a broader change in XFS to reclaim
delalloc blocks before inode eviction (along the lines of Dave's recent
proposal to do something like that for corrupted inodes). Of course the
caveat with the latter is that doesn't help for any other filesystems
(?) that might have similar expectations for delayed allocation and want
to use iomap.

Brian

[1] https://lore.kernel.org/linux-fsdevel/Y3TsPzd0XzXXIzQv@bfoster/

[2] This test case depends on a local xfs_io hack to co-opt the -f flag
into inducing a write failure. A POC patch for that is available here,
if you wanted to replicate:

https://lore.kernel.org/linux-xfs/20221123181322.3710820-1-bfoster@redhat.com/

