Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40044 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdICSVe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 14:21:34 -0400
Date: Sun, 3 Sep 2017 20:21:33 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC][PATCH] fstests: regression test for xfs leftover CoW
        extent error
Message-ID: <20170903182133.GA1757@lst.de>
References: <1504451271-29202-1-git-send-email-amir73il@gmail.com> <20170903174513.GI4073@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903174513.GI4073@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

> So basically there are two bugs here -- the fcollapse/finsert code needs
> to shift the CoW fork extents down and up;

Or make sure that we don't have any extents in the COW fork?

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9207d61..ae3b18f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1625,7 +1625,7 @@ xfs_itruncate_extents(
>         /*
>          * Clear the reflink flag if we truncated everything.
>          */
> -       if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
> +       if (ip->i_d.di_nblocks == 0 && ip->i_cnextents == 0 && xfs_is_reflink_inode(ip)) {

Btw, it seems like we should generally clear the reflink flag and
tag if ip->i_cnextents is zero and not even bother looking at di_nblocks.
