Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DECC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 23:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiBQXZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 18:25:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBQXZs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 18:25:48 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4998A2D599D
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 15:25:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2566C52DD77;
        Fri, 18 Feb 2022 10:20:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nKq4f-00DHNs-F2; Fri, 18 Feb 2022 10:20:33 +1100
Date:   Fri, 18 Feb 2022 10:20:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <20220217232033.GD59715@dread.disaster.area>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217172518.3842951-4-bfoster@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=620ed842
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=PptQcWbZQmPDmZSXHg8A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 17, 2022 at 12:25:17PM -0500, Brian Foster wrote:
> The free inode btree currently tracks all inode chunk records with
> at least one free inode. This simplifies the chunk and allocation
> selection algorithms as free inode availability can be guaranteed
> after a few simple checks. This is no longer the case with busy
> inode avoidance, however, because busy inode state is tracked in the
> radix tree independent from physical allocation status.
> 
> A busy inode avoidance algorithm relies on the ability to fall back
> to an inode chunk allocation one way or another in the event that
> all current free inodes are busy. Hack in a crude allocation
> fallback mechanism for experimental purposes. If the inode selection
> algorithm is unable to locate a usable inode, allow it to return
> -EAGAIN to perform another physical chunk allocation in the AG and
> retry the inode allocation.
> 
> The current prototype can perform this allocation and retry sequence
> repeatedly because a newly allocated chunk may still be covered by
> busy in-core inodes in the radix tree (if it were recently freed,
> for example). This is inefficient and temporary. It will be properly
> mitigated by background chunk removal. This defers freeing of inode
> chunk blocks from the free of the last used inode in the chunk to a
> background task that only frees chunks once completely idle, thereby
> providing a guarantee that a new chunk allocation always adds
> non-busy inodes to the AG.

I think you can get rid of this simply by checking the radix tree
tags for busy inodes at the location of the new inode chunk before
we do the cluster allocation. If there are busy inodes in the range
of the chunk (pure gang tag lookup, don't need to dereference any of
the inodes), just skip to the next chunk offset and try that. Hence
we only ever end up allocating a chunk that we know there are no
busy inodes in and this retry mechanism is unnecessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
