Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730445AbeIRWtC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 18:49:02 -0400
Date: Tue, 18 Sep 2018 13:15:28 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <b3a162a8-7c2b-8a66-6f11-2abff3381690@sandeen.net>
Message-ID: <alpine.LRH.2.02.1809181310550.7172@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com> <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com> <20180918123238.GI27618@dastard> <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net> <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <8975ad6d-bfde-0a50-e60c-59228493f1b2@sandeen.net> <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net> <alpine.LRH.2.02.1809181024150.28565@file01.intranet.prod.int.rdu2.redhat.com> <b359bcc7-bc76-33cc-30fb-2c8ad2ba4682@sandeen.net>
 <alpine.LRH.2.02.1809181038350.28565@file01.intranet.prod.int.rdu2.redhat.com> <b3a162a8-7c2b-8a66-6f11-2abff3381690@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>



On Tue, 18 Sep 2018, Eric Sandeen wrote:

> > is tight on disk space and doesn't care about performance).
> 
> I think you may be conflating sector size with filesystem block size.
> 
> ext4 makes no distinction between the two.
> 
> XFS has both sector size (metadata atomic IO unit) and filesystem block size
> (file data allocation unit) as configurable mkfs-time options. The sector size
> can be smaller than, and up to, the filesystem block size.
> 
> mkfs.xfs defaults to 4k filesystem blocks and device-physical-sector-sized
> sectors, i.e. the largest atomic IO the device advertises, because XFS
> metadata journaling relies on this IO atomicity.  We allocate file data in
> 4k chunks, and do atomic metadata IO in device-sector-sized chunks.

You can have 512-byte metadata sectors and you can read and write them in 
4k chunks (so that you avoid the read-modify-write logic in the SSDs). If 
data blocks are allocated on 4k boundary, there's no risk of 
metadata-vs-data buffer races.

> ext4 doesn't - it's true - but I cannot help but believe that ext4 occasionally
> gets harmed by this choice, because it's absolutely possible that a 4k
> metadata write gets only partly-persisted if power fails on a 512/512 disk,
> for example.  In practice it seems to generally work out ok, but it is going
> beyond what the device says it can guarantee.
> 
> -Eric

I implemented journal in the dm-integrity driver and I solved this problem
with partial writes by tagging every 512-byte journal sector with an
8-byte tag. If the tags don't match, there was power failure during write
and the partially written journal section will not be replayed. The
journal is written using 4k-aligned writes because they perform better.

ext4 solves this problem by using checksums.

Mikulas
