Return-Path: <SRS0=AdL6=EN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CCCC388F7
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 20:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB24208FE
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Nov 2020 20:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgKGUrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Nov 2020 15:47:55 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35098 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgKGUry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Nov 2020 15:47:54 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E990B58C03C;
        Sun,  8 Nov 2020 07:47:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kbV7j-008kzQ-5r; Sun, 08 Nov 2020 07:47:47 +1100
Date:   Sun, 8 Nov 2020 07:47:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Recover preallocated space after a crash?
Message-ID: <20201107204747.GH7391@dread.disaster.area>
References: <274ec62926defe526850a4253d2b96a8@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <274ec62926defe526850a4253d2b96a8@assyoma.it>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=7-415B0cAAAA:8
        a=nHAAI5wXA9Jvdu6jZWgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 07, 2020 at 08:55:50PM +0100, Gionatan Danti wrote:
> Hi list,
> it is my understanding that XFS can preallocate some "extra" space via
> speculative EOF preallocation and speculative COW preallocation.
> 
> During normal system operation, that extra space is recovered after some
> time. But what if system crashes? Can it be even recovered? If so, it is
> done at mount time or via a (more invasive) fsck?

It will be done silently the next time the inode is cycled through
memory via an open()/close() pair as specualtive prealloc is removed
on the final close() of a file.

Alternatively, you can trigger reclaim on the current set of
in-memory inodes by running:

# xfs_spaceman -c "prealloc -m 64k -s" /mnt

to remove speculative preallocations of more than 64k from all
inodes that are in-memory and wait for the operation to complete.

You still need to bring the inodes into memory, so you can do this
via find command that reads some inode metadata (e.g. find /mnt
-ctime 2>&1 /dev/null). This means you don't need to actually
open/close each inode in userspace - the filesystem will traversal
all the in-memory inodes and clear the prealloc space itself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
