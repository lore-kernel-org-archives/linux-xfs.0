Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A720C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 08:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbiCPIex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241869AbiCPIew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 04:34:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE59F3204A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 01:33:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5721110E4E9B;
        Wed, 16 Mar 2022 19:33:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUP65-0065GE-HY; Wed, 16 Mar 2022 19:33:33 +1100
Date:   Wed, 16 Mar 2022 19:33:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     nate <linux-xfs@linuxpowered.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink copy to different filesystem performance question
Message-ID: <20220316083333.GQ3927073@dread.disaster.area>
References: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6231a0df
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=3Dje42ugIqsejEKG6TYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 05:45:37PM -0700, nate wrote:
> Hello -
> 
> Blast from the past this is the first Majordomo mailing list I can recall
> joining in probably
> 15-18+ years..
> 
> Anyway, I ran into a situation today and was wondering if someone could
> clarify or point me to
> some docs so I just have a better understanding as to what is going on with
> this XFS setup.
> 
> Hardware: HP DL380 Gen10 6x8TB disks in hardware RAID 10
> Software: Ubuntu 20.04 kernel 5.4.0 using XFS with reflinks enabled
> Purpose: this system is used to store Veeam Backups (VMware VM backup)
> 
> I've used XFS off and on for many years but it wasn't until I set this up
> last year
> I had even heard of reflinks. Veeam docs specifically suggested enabling it
> if possible
> so I did. Things have been working fine since.

Yeah, Veeam appears to use the shared data extent functionality in
XFS for deduplication and cloning. reflink is the use facing name
for space efficient file cloning (via cp --reflink).

> Recently we had a situation come up where we want to copy some of this data
> to a
> local USB drive to ship to another location to restore the data. A simple
> enough
> process I thought just a basic file copy.
> 
> Total of 8.6TB, most of that is in a single 8.3TB file. We got a 18TB USB
> drive , I formatted
> it ext4 (feel more comfortable with ext4 on a USB drive).
> 
> I started an rsync to copy this data over as I assumed that would be the
> simplest method.
> I was pretty surprised to see rsync averaging between 25-30MB/sec. I
> expected more of course.
> I checked iostat and was even more surprised to see the 6 disk RAID 10 array
> showing
> 100% i/o utilization - the reads were maxed out, the USB drive was barely
> being touched.
> Consider me super confused at this point.. there was no other activity on
> the system.
> So I tried a basic cp -a command instead maybe data access for rsync is
> different, I
> didn't think so but couldn't help to try.. results were similar. iostat
> showed periodic
> bursts to 50-60MB/s but most often below 30MB/s. I like rsync with the
> --progress option
> so I went back to rsync again.

I'm guessing that you're trying to copy a deduplicated file,
resulting in the same physical blocks being read over and over again
at different file offsets and causing the disks to seek because it's
not physically sequential data.

> So then I looked for other data on the same filesystem that I knew was not
> Veeam data,
> so it would not be using reflinks. I found a stash of ~5GB of data and
> copied that,
> easily over 100MB/sec(files were smaller and going so fast it was hard to
> tell for
> sure).

It could have been using reflinks - upstream coreutils defaults to
reflink copies with cp these days (i.e. default is cp --reflink=auto
which means it tries a file clone first, then falls back to a data
copy if cloning fails. reflink copies are identical to the original
file - they *are* the original file - until they are overwritten.
Hence cp doesn't perform any differently with reflinked files vs
normal files.

[...]

> So I kicked off a copy using Veeam, I don't know what it does on the
> backend. But
> iostat showed sustained reads at over 200MB/sec, so call it 8X faster than
> rsync or cp. At this point the USB drive seemed more of the bottleneck
> (which
> is fine).

Because Veeam knows about the dedeuplicated data, it is quite likely
that it something smarter to optimise reading from files it has
deduplicated...

> I can only guess that Veeam is more intelligent in that it is using some API
> call to XFS to pull the sequential data for the most recent backup, vs using
> a linux CLI tool is pulling the entire file which probably has a ton of
> different
> pointers in it causing a lot more random I/O.

Maybe they are doing that with FIEMAP to resolve deduplicated
regions and caching them, or they have some other infomration in
their backup/deduplication data store that allows them to optimise
the IO. You'll need to actually run things like strace on the copies
to find out exactly what it is doing....

> So again, not having a problem really just looking to get a better simple
> understanding as to why a rsync or cp from reflinked data to another

rsync and cp are dumb, lowest common denominator copying programs.
They don't do anything smart like use threads, direct I/O, AIO,
io_uring, etc that applications that optimise for IO performance
typically use...

> and with that said are there tools that can copy reflinked data more
> intelligently from the command line (specifically to another filesystem)?

No, they don't exist because largely reading a reflinked file
performs no differently to reading a non-shared file.

> I checked the XFS faq and there is no mention of reflink. I couldn't
> find info on how to find how many "links" there were or how big each
> one was or how to reference them directly.

To do that efficiently (i.e. without a full filesystem scan) you
need to look up the filesystem reverse mapping table to find all the
owners of pointers to a given block.  I bet you didn't make the
filesystem with "-m rmapbt=1" to enable that functionality - nobody
does that unless they have a reason to because it's not enabled by
default (yet).

Cheers,

Dave.
> 
> thanks
> 
> nate
> 
> 

-- 
Dave Chinner
david@fromorbit.com
