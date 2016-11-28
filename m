Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:46849 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcK1Jvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 04:51:51 -0500
Subject: Re: Slow file stat/deletion
References: <bef58272-f791-52bf-cc4c-1cb1b7c9efec@assyoma.it>
 <20161127221433.GV28177@dastard>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <a5774248-db44-bdfe-2310-bb1a327756fb@assyoma.it>
Date: Mon, 28 Nov 2016 10:51:42 +0100
MIME-Version: 1.0
In-Reply-To: <20161127221433.GV28177@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Gionatan Danti <g.danti@assyoma.it>



On 27/11/2016 23:14, Dave Chinner wrote:
>
> Ah, hard link farms. aka "How to fragment the AGI btrees for fun and
> profit."
>

Interesting... there is anything I can read about AGI fragmentation?

>
> Not now. Speed is a factor of the inode layout and seek times. Find
> relies on sequential directory access which is sped up on XFS by
> internal btree readahead and it doesn't require reading the extent
> list. rm processes inodes one at a time and requires reading of the
> extent list so per-inode there is more IO, a lot more CPU time spent
> and more per-op latency, so it's no surprise it's much slower than
> find.
>

To tell the truth, "find" and "rm" show quite similar results: ~24 
minutes for the former, ~30 minutes for the latter. I perfectly 
understand that "rm" is going to be slower than find; my point is that 
*even* "find" seems quite slow...

>
> finobt=0.
>
> finobt was added primarily to solve inode allocation age-related
> degradation for hard link farm style workloads. It will have
> significant impact on unlink as well, because initial inode
> allocation patterns will be better...
>

This is a very interesting information; thank you.

>
> Nope, but it means that what should be sequential IO is probably
> going to be random. i.e. instead of directory/inode/extent reading
> IO having minimum track-track seek latency because they are all
> nearby (1-2ms), they'll be average seeks (6-7ms) because locality is no
> longer as the filesystem has optimised for.
>

Should not thinp overhead be minimized by the big (8 MB) chunk size? Are 
inode allocation so much scattered around LBAs? Maybe the slowdown can 
be increased by bad journal placement (I imagine it is near the start of 
the disk, while current read/write activity surely happen near the end)?

>
> noalign affects data placement only, and only for filesystems that
> have a stripe unit/width set, which yours doesn't:
>
>> 			sunit=0      swidth=0 blks

Isn't that the proper results of "noalign"? By opting for "noalign" I am 
telling mkfs to discard any stripe information, right?

>
> Yes. Made worse by being on a thinp volume.
>

I can't do anything for that?

>
> Only used for data readahead. Will make no difference to
> directory/stat/unlink performance.

Thank you again for valuable information.

>
> Cheers,
>
> Dave.
>

Thanks Dave.


-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
