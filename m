Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164C2CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 11:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B672087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 11:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfJ3LsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:48:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:58516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfJ3LsX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Oct 2019 07:48:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A09FB147;
        Wed, 30 Oct 2019 11:48:21 +0000 (UTC)
Date:   Wed, 30 Oct 2019 06:48:18 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        darrick.wong@oracle.com, hch@infradead.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, gujx@cn.fujitsu.com,
        qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH v2 0/7] xfs: reflink & dedupe for fsdax (read/write
 path).
Message-ID: <20191030114818.emvmgfgqadiqintw@fiona>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12:13 30/10, Shiyang Ruan wrote:
> This patchset aims to take care of this issue to make reflink and dedupe
> work correctly (actually in read/write path, there still has some problems,
> such as the page->mapping and page->index issue, in mmap path) in XFS under
> fsdax mode.

Have you managed to solve the problem of multi-mapped pages? I don't
think we can include this until we solve that problem. This is the
problem I faced when I was doing the btrfs dax support.

Suppose there is an extent shared with multiple files. You map data for
both files. Which inode should page->mapping->host (precisely
page->mapping) point to? As Dave pointed out, this needs to be fixed at
the mm level, and will not only benefit dax with CoW but other
areas such as overlayfs and possibly containers.

-- 
Goldwyn


> 
> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and the latest
> iomap.  I borrowed some patches related and made a few fix to make it
> basically works fine.
> 
> For dax framework: 
>   1. adapt to the latest change in iomap (two iomaps).
> 
> For XFS:
>   1. distinguish dax write/zero from normal write/zero.
>   2. remap extents after COW.
>   3. add file contents comparison function based on dax framework.
>   4. use xfs_break_layouts() instead of break_layout to support dax.
> 
> 
> Goldwyn Rodrigues (3):
>   dax: replace mmap entry in case of CoW
>   fs: dedup file range to use a compare function
>   dax: memcpy before zeroing range
> 
> Shiyang Ruan (4):
>   dax: Introduce dax_copy_edges() for COW.
>   dax: copy data before write.
>   xfs: handle copy-on-write in fsdax write() path.
>   xfs: support dedupe for fsdax.
> 
>  fs/btrfs/ioctl.c       |   3 +-
>  fs/dax.c               | 211 +++++++++++++++++++++++++++++++++++++----
>  fs/iomap/buffered-io.c |   8 +-
>  fs/ocfs2/file.c        |   2 +-
>  fs/read_write.c        |  11 ++-
>  fs/xfs/xfs_bmap_util.c |   6 +-
>  fs/xfs/xfs_file.c      |  10 +-
>  fs/xfs/xfs_iomap.c     |   3 +-
>  fs/xfs/xfs_iops.c      |  11 ++-
>  fs/xfs/xfs_reflink.c   |  79 ++++++++-------
>  include/linux/dax.h    |  16 ++--
>  include/linux/fs.h     |   9 +-
>  12 files changed, 291 insertions(+), 78 deletions(-)
> 
> -- 
> 2.23.0
> 
> 
> 

-- 
Goldwyn
