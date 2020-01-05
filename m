Return-Path: <SRS0=eaCE=22=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7C3C33C8C
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jan 2020 21:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8360B207FD
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jan 2020 21:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgAEVEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jan 2020 16:04:53 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38621 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbgAEVEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jan 2020 16:04:53 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5647043FEDD;
        Mon,  6 Jan 2020 08:04:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ioD4q-0005m1-CC; Mon, 06 Jan 2020 08:04:48 +1100
Date:   Mon, 6 Jan 2020 08:04:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     darrick.wong@oracle.com, bfoster@redhat.com, dchinner@redhat.com,
        sandeen@sandeen.net, cmaiolino@redhat.com, hch@lst.de,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengbin13@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 1/2] xfs: introduce xfs_bmap_split_da_extent
Message-ID: <20200105210448.GB23128@dread.disaster.area>
References: <20191226134721.43797-1-yukuai3@huawei.com>
 <20191226134721.43797-2-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226134721.43797-2-yukuai3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8 a=Vn3VGTz9AK5qLcwCOF4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 26, 2019 at 09:47:20PM +0800, yu kuai wrote:
> Add a new function xfs_bmap_split_da_extent to split a delalloc extent
> into two delalloc extents.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 26 ++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.h |  1 +
>  2 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4c2e046fbfad..8247054c1e2b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6117,7 +6117,7 @@ xfs_bmap_split_extent_at(
>  	/*
>  	 * Convert to a btree if necessary.
>  	 */
> -	if (xfs_bmap_needs_btree(ip, whichfork)) {
> +	if (tp && xfs_bmap_needs_btree(ip, whichfork)) {
>  		int tmp_logflags; /* partial log flag return val */
>  
>  		ASSERT(cur == NULL);

You can't use xfs_bmap_split_extent_at() to split delalloc extents
just by avoiding transactional context.

delalloc extents only exist in the in-core extent list, not in the
on-disk BMBT extent list. xfs_bmap_split_extent_at() is for splitting
on-disk BMBT extents and, as such, it modifies the BMBT directly. It
may not be obvious that the bmbt cursor holds a pointer to the
transaction context, but it does and that's how we log all the
modifications to the BMBT done via the generic btree code.

IOWs, if the inode extent list is in btree format, this code will
not work correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
