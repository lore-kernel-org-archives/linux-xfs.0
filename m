Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbcLFPYL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Dec 2016 10:24:11 -0500
Date: Tue, 6 Dec 2016 23:24:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206152409.GY29149@eguan.usersys.redhat.com>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161206134847.GA10181@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161206134847.GA10181@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2016 at 05:48:47AM -0800, Christoph Hellwig wrote:
> Hi Eryu,
> 
> my attempts at reproducing this are still not very reliable, someimes
> it takes three iterations, sometimes it's doing fine for 100+.
> 
> Can you try reverting commit 0af32fb46 ("xfs: fix bogus space
> reservation in xfs_iomap_write_allocate") and give this a spin on your
> test setup?  I wonder if somehow our accounting for the case where

Sure, test is running now.

Looking at this commit, reminds me another bug I reported in Aug. that I
wasn't able to find a simpler reproducer..

https://www.spinics.net/lists/xfs/msg42159.html

Thanks,
Eryu

> we convert from inline extents to the btree format is not correct,
> and the code before that commit was papering over that fact.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
