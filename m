Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43989 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751537AbcK2Wsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 17:48:53 -0500
Subject: Re: an iomap-based direct I/O implementation V4
References: <1480440496-25737-1-git-send-email-hch@lst.de>
From: Jens Axboe <axboe@fb.com>
Message-ID: <d085f813-d7a9-7384-dd70-a21885ea3a12@fb.com>
Date: Tue, 29 Nov 2016 15:22:09 -0700
MIME-Version: 1.0
In-Reply-To: <1480440496-25737-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

On 11/29/2016 10:28 AM, Christoph Hellwig wrote:
> Hi all,
>
> this series adds a new direct I/O implementation based on the iomap
> interface, and switches XFS to use it.
>
> The first two patches are a resend of my earlier series to remove the
> XFS iolock.  They are needed for the lockdep assert in the new iomap
> code.
>
> The rest implements a new iomap_dio_rw direct I/O implementation and
> switches XFS to use it.
>
> It requires a patch from the block tree which we'll need to cherry-pick
> into the XFS tree to avoid pulling in the whole block tree:
>
> 9cd56d91 ("block: add bio_iov_iter_get_pages()")
>
> To make everyones lifer easie I also have a git tree that includes this
> cherry pick:
>
>     git://git.infradead.org/users/hch/vfs.git iomap-dio.4
>
> Note that with this patch I see somewhat increased failure rates on
> generic/209.  This is not because of any locking or invalidation changes
> in this series, but just because it's always been fundamentally race,
> and the new direct I/O code is a lot faster, which causes the direct
> writes in this test to race significantly more often with readahead.

Ran some testing here, and it seems to perform well. Lower CPU 
utilization, or increased performance in the cases where we are maxing 
out the CPUs.

You can add my Tested-by to the series.

-- 
Jens Axboe

