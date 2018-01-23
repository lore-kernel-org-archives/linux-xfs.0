Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbeAWP2y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 10:28:54 -0500
Date: Tue, 23 Jan 2018 10:28:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180123152852.GA32478@bfoster.bfoster>
References: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 04:57:03PM +0200, Avi Kivity wrote:
> I'm seeing the equivalent[*] of xfs_extent_busy_flush() sleeping in my
> beautiful io_submit() calls.
> 
> 
> Questions:
> 
>  - Is it correct that RWF_NOWAIT will not detect the condition that led to
> the log being forced?
> 
>  - If so, can it be fixed?
> 
>  - Can I do something to reduce the odds of this occurring? larger logs,
> more logs, flush more often, resurrect extinct species and sacrifice them to
> the xfs gods?
> 
>  - Can an xfs developer do something? For example, make it RWF_NOWAIT
> friendly (if the answer to the first question was "correct")
> 

So RWF_NOWAIT eventually works its way to IOMAP_NOWAIT, which looks like
it skips any write call that would require allocation in
xfs_file_iomap_begin(). The busy flush should only happen in the block
allocation path, so something is missing here. Do you have a backtrace
for the log force you're seeing?

Brian

> 
> [*] equivalent, because I'm actually looking at an older kernel that lacks
> this function. But I'm moderately confident that the xfs_log_force I'm
> seeing was transformed into xfs_extent_busy_flush by
> ebf55872616c7d4754db5a318591a72a8d5e6896
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
