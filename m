Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35359 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdEDNyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:54:00 -0400
Received: by mail-vk0-f44.google.com with SMTP id v20so7894992vke.2
        for <linux-xfs@vger.kernel.org>; Thu, 04 May 2017 06:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170504122535.GB3248@bfoster.bfoster>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap> <20170502073501.GB6679@infradead.org>
 <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap> <20170504122535.GB3248@bfoster.bfoster>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Thu, 4 May 2017 16:53:59 +0300
Message-ID: <CAOcd+r2F_tAifjYLZ4hD-cZYAPMXJjbQZXp17On91Kv5ae60zw@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

Hi Brian,

> This is probably dropping into the fallback allocation algorithm in
> xfs_alloc_ag_vextent_near(), explained by the following comment:
>
>         /*
>          * Second algorithm.
>          * Search in the by-bno tree to the left and to the right
>          * simultaneously, until in each case we find a space big enough,
>          * or run into the edge of the tree.  When we run into the edge,
>          * we deallocate that cursor.
>          * If both searches succeed, we compare the two spaces and pick
>          * the better one.
>          * With alignment, it's possible for both to fail; the upper
>          * level algorithm that picks allocation groups for allocations
>          * is not supposed to do this.
>          */
>
> So what is happening here is that the algorithm is starting at a point
> in an AG based on a starting blockno (e.g., such as the inode block) and
> searching left and right from there for a suitable range of free blocks.
> Depending on the size of the tree, fragmentation of free space, size of
> the allocation request, etc., it can certainly take a while to seek/read
> all of the btree blocks required to satisfy the allocation.
Yes, according to my profiling, indeed all the slow allocation
incidents end up in the "second" algorithm.

Thanks,
Alex.
