Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-4.ukservers.net ([217.10.138.158]:34075 "EHLO
        auth-4.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbeALNcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 08:32:54 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5A58B901.7080609@youngman.org.uk>
Date: Fri, 12 Jan 2018 13:32:49 +0000
MIME-Version: 1.0
In-Reply-To: <20180111030723.GU16421@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 11/01/18 03:07, Dave Chinner wrote:
> XFS comes from a different background - high performance, high
> reliability and hardware RAID storage. Think hundreds of drives in a
> filesystem, not a handful. i.e. The XFS world is largely enterprise
> and HPC storage, not small DIY solutions for a home or back-room
> office.  We live in a different world, and MD rarely enters mine.

So what happens when the hardware raid structure changes?

Ext allows you to grow a filesystem. Btrfs allows you to grow a
filesystem. Reiser allows you to grow a file system. Can you add more
disks to XFS and grow the filesystem?

My point is that all this causes geometries to change, and ext and btrfs
amongst others can clearly handle this. Can XFS?

Because if it can, it seems to me the obvious solution to changing raid
geometries is that you need to grow the filesystem, and get that to
adjust its geometries.

Bear in mind, SUSE has now adopted XFS as the default filesystem for
partitions other than /. This means you are going to get a lot of
"hobbyist" systems running XFS on top of MD and LVM. Are you telling me
that XFS is actually very badly suited to be a default filesystem for SUSE?

What concerns me here is, not having a clue how LVM handles changing
partition sizes, what effect this will have on filesystems ... The
problem is the Unix philosophy of "do one thing and do it well".
Sometimes that's just not practical. The Unix philosophy says "leave
partition management to lvm, leave redundancy to md, leave the files to
the filesystem, ..." and then the filesystem comes along and says "hey,
I can't do my job very well, if I don't have a clue about the physical
disk layout". It's a hard circle to square ... :-)

(Anecdotes about btrfs are that it's made a right pigs ear of trying to
do everything itself.)

Cheers,
Wol
