Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdIUMwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 08:52:54 -0400
Date: Thu, 21 Sep 2017 05:52:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iomap_dio_rw: Allocate AIO completion queue before
 submitting dio
Message-ID: <20170921125253.GA10039@infradead.org>
References: <20170921095234.12401-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921095234.12401-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, eguan@redhat.com, linux-fsdevel@vger.kernel.org

> +	if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
> +		!inode->i_sb->s_dio_done_wq) {
> +		ret = sb_init_dio_done_wq(inode->i_sb);

Wrong indentation for the continuation of the if conditional.

Except for that the patch looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
