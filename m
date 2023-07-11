Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6266AEB64DD
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 07:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjGKHFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 03:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjGKHFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 03:05:35 -0400
Received: from smtp2.onthe.net.au (smtp2.onthe.net.au [203.22.196.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C9D5B1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 00:05:33 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 3859F94E;
        Tue, 11 Jul 2023 17:05:31 +1000 (AEST)
Received: from smtp2.onthe.net.au ([10.200.63.13])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10024)
        with ESMTP id hJd83ltTHRbc; Tue, 11 Jul 2023 17:05:31 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 1805CCD;
        Tue, 11 Jul 2023 17:05:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onthe.net.au;
        s=default; t=1689059131;
        bh=mpeqNPFGHPh2conuTVh0mvFtTHX7vYT8xbaPx4xwXho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=euHahkzZIO5DjbmA6nHNYISzsQf1NO5VTyK3IwZi3GapDNdUrrdaUEQ27ZQPnsOID
         LBcZqyXRxZidXV1dXs27coLaHpwYBVT9Ezw0YtzI0cr/piJWnr/NJCuTvg4xysTYQ0
         lXm26G43KEnP7ZoxeH6KBeS62hfVN437weeEhnCfmfHA+81dFqFgVXKPZVoNY2Dsgt
         itZFvorNxRQYamVaf3zW88ZCkxKbqkgqrHKkrl8HS2wX2cnOOEMwjO53GK7nz5tbaV
         CDEwEqcT/VAOBkUXMtkn5QCb2Qt5ke4goLOqY3IVwQO59V78JJqtp9Cz3YVF3OkS1R
         nrlIUuX18RRzg==
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id EE0B768061B; Tue, 11 Jul 2023 17:05:30 +1000 (AEST)
Date:   Tue, 11 Jul 2023 17:05:30 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <20230711070530.GA761114@onthe.net.au>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 01:10:11PM +1000, Dave Chinner wrote:
> FYI, Chris: google is classifying your email as spam because it
> doesn't have any dkim/dmarc authentication on it. You're lucky I
> even got this, because I know that gmail mostly just drops such
> email in a black hole now....

Dkim hopefully fixed now.

More on the problem topic below, and apologies for the aside, but this is 
my immediate concern: post the reboot into v5.15.118 I have one of the 
filesystems failing to mount with:

Jul 11 16:13:10 b2 kernel: XFS (dm-146): Metadata CRC error detected at xfs_allocbt_read_verify+0x12/0xb0 [xfs], xfs_bnobt block 0x10a00f7f8
Jul 11 16:13:10 b2 kernel: XFS (dm-146): Unmount and run xfs_repair
Jul 11 16:13:10 b2 kernel: XFS (dm-146): First 128 bytes of corrupted metadata buffer:
Jul 11 16:13:10 b2 kernel: 00000000: 41 42 33 42 00 00 01 ab 05 0a 78 fe 02 c0 2b ff  AB3B......x...+.
Jul 11 16:13:10 b2 kernel: 00000010: 00 00 00 01 0a 00 f7 f8 00 00 00 26 00 3b 2d 40  ...........&.;-@
Jul 11 16:13:10 b2 kernel: 00000020: cf 42 ed 07 78 a1 4e ff 9e 20 e3 d9 6f fc 3e 30  .B..x.N.. ..o.>0
Jul 11 16:13:10 b2 kernel: 00000030: 00 00 00 02 80 b2 25 41 08 c7 6c 00 00 00 01 28  ......%A..l....(
Jul 11 16:13:10 b2 kernel: 00000040: 08 c7 6d 3e 00 00 00 c2 08 c7 6f 65 00 00 00 a7  ..m>......oe....
Jul 11 16:13:10 b2 kernel: 00000050: 08 c7 70 a5 00 00 00 3a 08 c7 71 00 00 00 00 c4  ..p....:..q.....
Jul 11 16:13:10 b2 kernel: 00000060: 08 c7 71 e8 00 00 00 18 08 c7 72 50 00 00 02 c3  ..q.......rP....
Jul 11 16:13:10 b2 kernel: 00000070: 08 c7 75 b1 00 00 02 4b 08 c7 78 db 00 00 02 3d  ..u....K..x....=
Jul 11 16:13:10 b2 kernel: XFS (dm-146): log mount/recovery failed: error -74
Jul 11 16:13:10 b2 kernel: XFS (dm-146): log mount failed

Then xfs_repair comes back with: 

# xfs_repair /dev/vg-name/lv-name
Phase 1 - find and verify superblock...
         - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
         - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

At this point is "xfs_repair -L" (and attendant potential data loss) my 
only option?


> On Tue, Jul 11, 2023 at 11:57:16AM +1000, Chris Dunlop wrote:
>> On Tue, Jul 11, 2023 at 10:13:31AM +1000, Chris Dunlop wrote:
>>> On Tue, Jul 11, 2023 at 07:53:54AM +1000, Chris Dunlop wrote:
>>>> Hi,
>>>>
>>>> This box is newly booted into linux v6.1.35 (2 days ago), it was
>>>> previously running v5.15.118 without any problems (other than that
>>>> fixed by "5e672cd69f0a xfs: non-blocking inodegc pushes", the reason
>>>> for the upgrade).
>>>>
>>>> I have rm operations on two files that have been stuck for in excess
>>>> of 22 hours and 18 hours respectively:
...
>>
>> Full sysrq-w output at:
>>
>> https://file.io/tg7F5OqIWo1B
>
> Ok, you have XFS on dm-writecache on md raid 5 and
> everything is stuck in either dm-writecache or md.

Yes, dm-writecache, with the cache on SSD md raid6, in front of the XFS 
devices on lvm / ceph-rbd.

> This task holds the wc_lock() while it is doing this writeback
> flush.
>
> All the XFS filesystems are stuck in similar ways, such as trying to
> push the journal and getting stuck in IO submission in
> dm-writecache:
...
> These are getting into dm-writecache, and the lock they are getting
> stuck on is the wc_lock().
...
>
> Directory reads are getting stuck in dm-write-cache:
...
> Same lock.
>
> File data reads are getting stuck the same way in dm-writecache.
>
> File data writes (i.e. writeback) are getting stuck the same way
> in dm-writecache.
>
> Yup, everything is stuck on dm-writecache flushing to the underlying
> RAID-5 device.
>
> I don't see anything indicating a filesystem problem here. This
> looks like a massively overloaded RAID 5 volume. i.e. the fast
> storage that makes up the write cache has filled, and now everything
> is stuck waiting for the fast cache to drain to the slow backing
> store before new writes can be made to the fast cache. IOWs,
> everything is running as RAID5 write speed and there's a huge
> backlog of data being written to the RAID 5 volume(s) keeping them
> 100% busy.

This had never been an issue with v5.15. Is it possible the upgrade to 
v6.1 had a hand in this or that's probably just coincidence?

In particular, could "5e672cd69f0a xfs: non-blocking inodegc pushes" cause 
a significantly greater write load on the cache?

I note that there's one fs (separate to the corrupt one above) that's 
still in mount recovery since the boot some hours ago. On past experience 
that indicates the inodegc stuff is holding things up, i.e. it would have 
been running prior to the reboot - or at least trying to.

> If there is no IO going to the RAID 5 volumes, then you've got a
> RAID 5 or physical IO hang of some kind. But I can't find any
> indication of that - everything looks like it's waiting on RAID 5
> stripe population to make write progress...

There's been no change to the cache device over the reboot, and it
currently looks busy, but it doesn't look completely swamped:

                     load %user %nice  %sys  %iow  %stl %idle  dev rrqm/s wrqm/s    r/s    w/s    rkB/s    wkB/s  arq-sz  aqu-sz    await   rwait   wwait %util
2023-07-11-16:10:00 16.7   0.6   0.0   1.0  15.0   0.0  82.5 md10    0.0    0.0  172.5 1060.1 17131.66 27450.08   72.34    6.33     5.13    0.56     5.9  48.8
2023-07-11-16:11:00 17.2   0.8   0.0   1.1  15.6   0.0  81.7 md10    0.0    0.0  185.7 1151.4 18202.36 20681.51   58.16    8.18     6.12    0.53     7.0  44.0
2023-07-11-16:12:00 18.9   0.5   0.0   1.0  17.0   0.0  80.6 md10    0.0    0.0  179.9 1139.6 15617.51 26579.51   63.96    7.62     5.78    0.46     6.6  47.5
2023-07-11-16:13:00 18.7   0.6   0.0   1.0  15.4   0.0  82.1 md10    0.0    0.0  161.8 1399.7 15751.70 26273.20   53.83   11.47     7.35    0.51     8.1  47.4
2023-07-11-16:14:00 17.2   0.5   0.0   0.9  13.9   0.0  83.8 md10    0.0    0.0  190.2 1251.1 15207.77 20907.73   50.12   14.19     9.85    2.16    11.0  42.2
2023-07-11-16:15:00 17.0   0.6   0.0   1.0  13.8   0.0  83.7 md10    0.0    0.0  163.5 1571.2 14561.41 24508.45   45.05   14.38     8.29    0.53     9.1  46.7
2023-07-11-16:16:00 18.7   0.8   0.0   1.0  15.5   0.0  81.8 md10    0.0    0.0  164.6 1294.7 13256.49 20737.23   46.59   12.54     8.59    0.50     9.6  42.3
2023-07-11-16:17:00 18.9   0.6   0.0   1.0  14.0   0.0  83.4 md10    0.0    0.0  179.4 1026.7 14079.12 19095.93   55.01    9.12     7.56    0.91     8.7  44.8
2023-07-11-16:18:00 19.4   0.6   0.0   1.0  13.8   0.0  83.7 md10    0.0    0.0  151.6 1315.5 12935.14 23547.30   49.73   11.80     8.04    0.43     8.9  48.5
2023-07-11-16:19:00 19.6   0.6   0.0   1.0  11.9   0.0  85.7 md10    0.0    0.0  168.6 1895.9 14153.63 23810.50   36.78   16.75     8.11    0.77     8.8  48.5

It should be handling about the same load as prior to the reboot.


Cheers,

Chris
