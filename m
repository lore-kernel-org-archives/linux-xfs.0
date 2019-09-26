Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D33EC4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 12:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 024E9222C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 12:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbfIZM7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 08:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfIZM7b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 08:59:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A16BC56F9;
        Thu, 26 Sep 2019 12:59:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38766608C2;
        Thu, 26 Sep 2019 12:59:30 +0000 (UTC)
Date:   Thu, 26 Sep 2019 08:59:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Max Reitz <mreitz@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: xfs_alloc_file_space() rounds len independently of offset
Message-ID: <20190926125928.GC26832@bfoster>
References: <6d62fb2a-a4e6-3094-c1bf-0ca5569b244c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d62fb2a-a4e6-3094-c1bf-0ca5569b244c@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 26 Sep 2019 12:59:30 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 12:57:49PM +0200, Max Reitz wrote:
> Hi,
> 
> I’ve noticed that fallocating some range on XFS sometimes does not
> include the last block covered by the range, when the start offset is
> unaligned.
> 
> (Tested on 5.3.0-gf41def397.)
> 
> This happens whenever ceil((offset + len) / block_size) - floor(offset /
> block_size) > ceil(len / block_size), for example:
> 
> Let block_size be 4096.  Then (on XFS):
> 
> $ fallocate -o 2048 -l 4096 foo   # Range [2048, 6144)
> $ xfs_bmap foo
> foo:
>         0: [0..7]: 80..87
>         1: [8..15]: hole
> 
> There should not be a hole there.  Both of the first two blocks should
> be allocated.  XFS will do that if I just let the range start one byte
> sooner and increase the length by one byte:
> 
> $ rm -f foo
> $ fallocate -o 2047 -l 4097 foo   # Range [2047, 6144)
> $ xfs_bmap foo
> foo:
>         0: [0..15]: 88..103
> 
> 
> (See [1] for a more extensive reasoning why this is a bug.)
> 
> 
> The problem is (as far as I can see) that xfs_alloc_file_space() rounds
> count (which equals len) independently of the offset.  So in the
> examples above, 4096 is rounded to one block and 4097 is rounded to two;
> even though the first example actually touches two blocks because of the
> misaligned offset.
> 
> Therefore, this should fix the problem (and does fix it for me):
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0910cb75b..4f4437030 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -864,6 +864,7 @@ xfs_alloc_file_space(
>  	xfs_filblks_t		allocatesize_fsb;
>  	xfs_extlen_t		extsz, temp;
>  	xfs_fileoff_t		startoffset_fsb;
> +	xfs_fileoff_t		endoffset_fsb;
>  	int			nimaps;
>  	int			quota_flag;
>  	int			rt;
> @@ -891,7 +892,8 @@ xfs_alloc_file_space(
>  	imapp = &imaps[0];
>  	nimaps = 1;
>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
> -	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
> +	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
> +	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
> 
>  	/*
>  	 * Allocate file space until done or until there is an error
> 

That looks like a reasonable fix to me and it's in the spirit of how
xfs_free_file_space() works as well (outside of the obvious difference
in how unaligned boundary blocks are handled). Care to send a proper
patch?

Brian

> 
> Thanks and kind regards,
> 
> Max
> 
> 
> [1] That this is a bug can be proven as follows:
> 
> 1. The fallocate(2) man page states "subsequent writes into the range
> specified by offset and len are guaranteed not to fail because of lack
> of disk space."
> 
> 2. Run this test (anywhere, e.g. tmpfs):
> 
> $ truncate -s $((4096 * 4096)) test_fs
> $ mkfs.xfs -b size=4096 test_fs
> [Success-indicating output, I hope]
> 
> $ mkdir mount_point
> $ sudo mount -o loop test_fs mount_point
> $ sudo chmod go+rwx mount_point
> $ cd mount_point
> 
> $ free_blocks=$(df -B4k . | tail -n 1 \
>       | awk '{ split($0, f); print f[4] }')
> 
> $ falloc_length=$((free_blocks * 4096))
> 
> $ while true; do \
>      fallocate -o 2048 -l $falloc_length test_file && break; \
>      falloc_length=$((falloc_length - 4096)); \
> done
> fallocate: fallocate failed: No space left on device
> fallocate: fallocate failed: No space left on device
> fallocate: fallocate failed: No space left on device
> fallocate: fallocate failed: No space left on device
> 
>   # Now we have a test_file with an fallocated range of
>   # [2048, 2048 + $falloc_length)
>   # So we should be able to write anywhere in that area without
>   # encountering ENOSPC; but that is what happens when we write
>   # to the last block covered by the range:
> 
> $ dd if=/dev/zero of=test_file bs=1 conv=notrunc \
>     seek=$falloc_length count=2048
> dd: error writing 'test_file': No space left on device
> 1+0 records in
> 0+0 records out
> 0 bytes copied, 0.000164691 s, 0.0 kB/s
> 
> 
> When I apply the diff shown above, I get one more “No space left on
> device” line (indicating that fallocate consistently takes one
> additional block), and then:
> 
> $ uname -sr
> Linux 5.3.0-gf41def397-dirty
> 
> $ dd if=/dev/zero of=test_file bs=1 conv=notrunc \
>     seek=$falloc_length count=2048
> 2048+0 records in
> 2048+0 records out
> 2048 bytes (2.0 kB, 2.0 KiB) copied, 0.0121903 s, 168 kB/s
> 
> (i.e., what I’d expect)
