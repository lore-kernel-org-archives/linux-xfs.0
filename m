Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51584 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933628AbcKHUsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 15:48:07 -0500
Date: Tue, 8 Nov 2016 12:48:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 0/4] xfs: basic cow fork speculative preallocation
Message-ID: <20161108204800.GA16813@birch.djwong.org>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2016 at 03:27:32PM -0500, Brian Foster wrote:
> Hi all,
> 
> This is an experiment based on an idea for COW fork speculative
> preallocation. This is experimental, lightly/barely tested and sent in
> RFC form to solicit thoughts, ideas or flames before I spend time taking
> it further.
> 
> Patch 1 probably stands on its own. Patches 2 and 3 are some refactoring
> and patch 4 implements the basic idea, which is described in the commit
> log description. The testing I've done so far is basically similar to
> how one would test the effects of traditional speculative preallocation:
> write to multiple reflinked files in parallel and examine the resulting
> fragmentation. Specifically, I wrote sequentially to 16 different
> reflinked files of the same 8GB original (which has two data extents,
> completely shared). Without preallocation, the test results in ~248
> extents across the 16 files. With preallocation, the test results in 32
> extents across the 16 files (i.e., 2 extents per file, same as the
> source file).
> 
> An obvious tradeoff is the unnecessarily aggressive allocation that
> might occur in the event of random writes to a large file (such as in
> the cloned VM disk image use case), but my thinking is that the
> cowblocks tagging and reclaim infrastructure should manage that
> sufficiently (lack of testing notwithstanding). In any event, I'm
> interested in any thoughts along the lines of whether this is useful at
> all, alternative algorithm ideas, etc.

Was about to step out to lunch when this came in, but...

Is there an xfstest for this, so I can play too? :)

As far as random writes go, some of the reflink tests look at fragmentation
behavior.  generic/301 generic/302 xfs/180 xfs/182 xfs/184 xfs/192 xfs/193
xfs/198 xfs/200 xfs/204 xfs/208 xfs/208 xfs/211 xfs/215 xfs/218 xfs/219 xfs/221
xfs/223 xfs/224 xfs/225 xfs/226 xfs/228 xfs/230 xfs/231 xfs/232 xfs/344 xfs/345
xfs/346 xfs/347 are the ones that grep 'new extents:' picked up.

Will look at the patches when I get back.

--D

> 
> Brian
> 
> Brian Foster (4):
>   xfs: clean up cow fork reservation and tag inodes correctly
>   xfs: logically separate iomap range from allocation range
>   xfs: reuse xfs_file_iomap_begin_delay() for cow fork delalloc
>   xfs: implement basic COW fork speculative preallocation
> 
>  fs/xfs/xfs_iomap.c   | 132 +++++++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_reflink.c |  28 ++---------
>  2 files changed, 111 insertions(+), 49 deletions(-)
> 
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
