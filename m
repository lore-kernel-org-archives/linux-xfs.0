Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35887 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdICIuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 04:50:13 -0400
Date: Sun, 3 Sep 2017 01:50:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/3] fs/xfs: Add rtfallocmin mount option
Message-ID: <20170903085013.GE32385@infradead.org>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170902224145.1291030-4-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170902224145.1291030-4-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com

On Sat, Sep 02, 2017 at 03:41:45PM -0700, Richard Wareing wrote:
> - Gates real-time block device fallocation's to rtfallocmin bytes
> - Use case: Allows developers to send files to the SSD with ease simply
>   by fallocating them, if they are below rtfallocmin XFS will allocate the
>   blocks from the non-RT device (e.g. an SSD)
> - Useful to automagically store small files on the SSD vs. RT device
>   (HDD) for tiered XFS setups without having to rely on XFS specific
>   ioctl calls.  Userland tools such as rsync can also use fallocation
>   behavior to migrate files between SSD and RT (HDD) device without
>   modifiction (e.g. w/ --preallocate flag).

I'd be much happier if this was done inside the allocator, and in
affect for any initial allocation, not just fallocate, as that keeps
the layering and logic much cleaner.
