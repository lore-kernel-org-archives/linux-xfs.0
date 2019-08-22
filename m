Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB47C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69F0B233A2
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 06:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbfHVGC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 02:02:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56403 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731568AbfHVGC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 02:02:27 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0D255361321;
        Thu, 22 Aug 2019 16:02:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0g9t-0006W3-S2; Thu, 22 Aug 2019 16:01:17 +1000
Date:   Thu, 22 Aug 2019 16:01:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsdump: find root inode, not first inode
Message-ID: <20190822060117.GW1119@dread.disaster.area>
References: <f66f26f7-5e29-80fc-206c-9a53cf4640fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f66f26f7-5e29-80fc-206c-9a53cf4640fa@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=1kad8rFdik17FAJnUxYA:9 a=Vg4aASO0UcAMcRfx:21
        a=o6WZqzqBzUfawC5l:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 05:14:51PM -0500, Eric Sandeen wrote:
> The prior effort to identify the actual root inode in a filesystem
> failed in the (rare) case where inodes were allocated with a lower
> number than the root.  As a result, the wrong root inode number
> went into the dump, and restore would fail with:
> 
> xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
> 
> Fix this by iterating over a chunk's worth of inodes until we find
> a directory inode with generation 0, which should only be true
> for the real root inode.

I'm not sure addresses the actual case that can cause this error.

i.e. the root inode is always the first inode in the "root chunk"
that is allocated at mkfs time. THat location is where repair will
always calculate it to be, and it will be the inode that it uses
to rebuild the root dir from.

The problem, as I understand it, is that we have a situation where
the per-ag btree root blocks have moved (due to split/merge) from
the their original location which is packed against the AG headers.
The root inode chunk is located at the lowest inode cluster aligned
block after these AG btree roots.

Once the btree roots have moved, they may be space between the AG
headers and the root inode chunk to allocate a new inode chunk,
in which case we have at least 64 inodes allocated underneath the
root inode. And if we have 64k blocks and 256 byte inodes, we could
have 256 inodes per fs block between the AG headers and the root
indoe chunk.

Hence scanning all the inodes in the first indoe chunk won't find
the root indoe if any of these situations has occurred, and we may
have to scan 1500 or more inodes in to find the root chunk (6 btree
roots - BNOBT,CNTBT,INOBT,FINOBT,RMAPBT,REFCBT - and 64k blocks).

So I think the best thing to do here is try to calculate the root
inode number as per xfs_repair, and then bulkstat that. i.e. see
the calculation of "first_prealloc_ino" in repair/xfs_repair.c
(about line 450). Probably requires a XFS_IOC_FSGEOMETRY_V1 call to
get the necessary info to calculate it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
