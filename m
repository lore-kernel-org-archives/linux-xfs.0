Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B02C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EDF5207E0
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbfIEQbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:31:41 -0400
Received: from verein.lst.de ([213.95.11.211]:50178 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730500AbfIEQbl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Sep 2019 12:31:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7EE7168B20; Thu,  5 Sep 2019 18:31:37 +0200 (CEST)
Date:   Thu, 5 Sep 2019 18:31:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        darrick.wong@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 12/15] btrfs: Use iomap_dio_rw for performing direct
 I/O writes
Message-ID: <20190905163137.GD22450@lst.de>
References: <20190905150650.21089-1-rgoldwyn@suse.de> <20190905150650.21089-13-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905150650.21089-13-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lots of lines > 80 chars, and various indentation errors, I'm not
going to point them out invdividually.


>  ssize_t btrfs_dio_iomap_read(struct kiocb *iocb, struct iov_iter *to)
> @@ -437,7 +536,58 @@ ssize_t btrfs_dio_iomap_read(struct kiocb *iocb, struct iov_iter *to)
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	ssize_t ret;
>  	inode_lock_shared(inode);
> -	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, NULL);
> +	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dops);

So the read did not previously need the submit callback, but it does
now?  That seems a little odd.

>  	inode_unlock_shared(inode);
>  	return ret;
>  }
> +
> +ssize_t btrfs_dio_iomap_write(struct kiocb *iocb, struct iov_iter *from)

Why not just brfs_dio_write?

> +	written = iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dops);
> +	if (written < count) {
> +		ssize_t done = (written < 0) ? 0 : written;
> +		btrfs_delalloc_release_space(inode, data_reserved, pos, count - done,
> +	                       true);

Line > 80 characters.

> +out:
> +	if (written > 0 && iocb->ki_pos > i_size_read(inode))
> +			i_size_write(inode, iocb->ki_pos);

Odd indentation.

> +	return written ? written : err;

But not:

	if (!written)
		return err;

	if (iocb->ki_pos > i_size_read(inode))
		i_size_write(inode, iocb->ki_pos);
	return written;
