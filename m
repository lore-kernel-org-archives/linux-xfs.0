Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34463 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757135AbdEGWJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 May 2017 18:09:48 -0400
Received: by mail-vk0-f41.google.com with SMTP id y190so20099975vkc.1
        for <linux-xfs@vger.kernel.org>; Sun, 07 May 2017 15:09:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505032905.GF17542@dastard>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap> <20170502073501.GB6679@infradead.org>
 <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap> <20170505032905.GF17542@dastard>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Sun, 7 May 2017 10:52:25 +0300
Message-ID: <CAOcd+r176-WeOXoN0O81h57LgdsKjepet_xCcMzrmR8dpkQzMg@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

>> [1]
>>   from      to extents  blocks    pct
>>      1       1  155759  155759   0.00
>>      2       3    1319    3328   0.00
>>      4       7   13153   56265   0.00
>>      8      15  152663 1752813   0.03
>>     16      31 143626908 4019133338  60.17
>
> There's your problem. 143 million small free space extents totalling
> 4TB of free space. That's going to require (roughly speaking)
> somewhere between 3-500,000 4k btree leaf blocks to index. i.e a
> footprint of 10-20GB of metadata.
>
> Even accounting for it being evenly spread across 50AGs, that's
> still a 5-10k of btree blocks per free space btree per AG, and so if
> that's not in cache when we end up doing a linear search for a near
> block of a size that falls into this bucket, it's going to get stuck
> reading btree leaf siblings from disk synchronously....
>
> Perhaps this "near block" search needs to terminate after at a
> certain search radius, similar to how the old AGI btree searches
> during inode allocation were terminated after a certain radius of
> allocated inode clusters were searched for free inodes....
Thank you for your response, Dave, this makes sense.

Alex.
