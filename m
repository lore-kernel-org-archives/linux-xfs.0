Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754525AbcLAK06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 05:26:58 -0500
Date: Thu, 1 Dec 2016 02:26:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use xfs_vn_setattr_size to check on new size
Message-ID: <20161201102635.GA23215@infradead.org>
References: <20161201101800.11419-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201101800.11419-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 01, 2016 at 06:18:00PM +0800, Eryu Guan wrote:
> Commit 6552321831dc ("xfs: remove i_iolock and use i_rwsem in the
> VFS inode instead") introduced a regression that truncate(2) doesn't
> check on new size, so it succeeds even if the new size exceeds the
> current resource limit. Because xfs_setattr_size() was used instead
> of xfs_vn_setattr_size(), and the latter calls xfs_vn_change_ok()
> first to do sanity check on permission and new size.

Oops, looks like this was a merge error..

> 
> This is found by truncate03 test from ltp, and the following is a
> simplified reproducer:
> 
>   #!/bin/bash
>   dev=/dev/sda5
>   mnt=/mnt/xfs
> 
>   mkfs -t xfs -f $dev
>   mount $dev $mnt
> 
>   # set max file size to 16k
>   ulimit -f 16
>   truncate -s $((16 * 1024 + 1)) /mnt/xfs/testfile
>   [ $? -eq 0 ] && echo "FAIL: truncate exceeded max file size"
>   ulimit -f unlimited
>   umount $mnt

Can you add this to xfstests?

The patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
