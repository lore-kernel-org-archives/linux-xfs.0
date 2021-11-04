Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD9CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 23:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C87D6120D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 23:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhKDXHj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 19:07:39 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:34927 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhKDXHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 19:07:38 -0400
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au [49.180.20.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 154B5865D92;
        Fri,  5 Nov 2021 10:04:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1milmt-004x9w-UX; Fri, 05 Nov 2021 10:04:51 +1100
Date:   Fri, 5 Nov 2021 10:04:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211104230451.GG449541@dread.disaster.area>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104090915.GW32555@pcnci.linuxbox.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6184671a
        a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=7-415B0cAAAA:8
        a=ro6Xg-DOMQXQUr96T-oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 04, 2021 at 10:09:15AM +0100, Nikola Ciprich wrote:
> Hello fellow XFS users and developers,
> 
> we've stumbled upon strange problem which I think might be somewhere
> in XFS code.
> 
> we have very large ceph-based storage on top which there is 1.5PiB volume
> with XFS filesystem. This contains very large (ie 500TB) sparse files,
> partially filled with data.
> 
> problem is, trying to read those files leads to processes blocked in D
> state showing very very bad performance - ~200KiB/s, 50IOPS.

It's been told it to go slow... :/

> I tried running xfs_repair on the volume, but this seems to behave in
> very similar way - very quickly it gets into almost stalled state, without
> almost any progress..
> 
> [root@spbstdnas ~]# xfs_repair -P -t 60 -v -v -v -v /dev/sdk

.... because "-P" turns off prefetching and all the IO optimisation
that comes along with the prefetching mechanisms. In effect, "-P"
means "go really slowly".

Try:

# xfs_repair -o bhash_size=101371 -o ag_stride=100 /dev/sdk

To get a good sized buffer cache and a decent (but not excessive)
amount of concurrency in the scanning processing. It still may end
up being slow if it has to single thread walk a huge btree
(essentially pointer chasing on disk), but at least that won't hold
up all the other scanning that isn't dependent on that huge btree..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
