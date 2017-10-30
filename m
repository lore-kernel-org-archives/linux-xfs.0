Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33448 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752019AbdJ3Vji (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Oct 2017 17:39:38 -0400
Date: Tue, 31 Oct 2017 08:39:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RAID6 + XFS + Application Workload write performance question
Message-ID: <20171030213935.GB5858@dastard>
References: <8BB5896C-2789-4EB6-9B1B-7DFD4DA9101B@fireeye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8BB5896C-2789-4EB6-9B1B-7DFD4DA9101B@fireeye.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kyle Ames <kyle.ames@FireEye.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Mon, Oct 30, 2017 at 04:43:15PM +0000, Kyle Ames wrote:
> Hello!
> 
> I’m trying to track down odd write performance from a test of
> our application’s I/O workload. Admittedly I am not extremely
> experienced with this domain (file systems, storage, tuning,
> etc.). I’ve done a ton of research and I think I’ve gotten
> as far as I possibly can without reaching out for help from domain
> experts.
>
> Here is the setup:
> 
> OS: CentOS 7.3
> Kernel: 3.10.0-693.2.2.el7.x86_64
> RAID: LSI RAID controller - RAID 6 with 10 disks - Strip Size 128 (and thus a stripe size of 1MB if I understand correctly)

[snip]

> mkfs.xfs -d su=128k,sw=8 -L DATA -f /dev/mapper/vgdata-lvdata
> mkfs.xfs: Specified data stripe width 2048 is not the same as the volume stripe width 512        (KEA: I’m not sure if this is an actual problem or not from googling around)

That's telling you there's a problem with your stripe alignment
setup somewhere. LVM is telling XFS that a total stripe width
of 256k, not 1MB. So it's likely your LVM setup isn't aligned/sized
properly to the RAID6 volume.

> meta-data=/dev/mapper/vgdata-lvdata isize=512    agcount=73, agsize=268435424 blks

73 ags.

<....>

> Our application writes to a nested directory hierarchy as follows:
> 
> <THREAD>/<DATE>/<HOUR>/<MINUTE>/<DATE>-<HOUR><MINUTE<SECOND>.data

<snip>

> What we’re seeing is that write performance starts off around 1400-1500 MB/s, decreasing approximately linearly all the way down to around ~600 MB/s after ~18 minutes before suddenly shooting back up to 1400-1500 MB/s. This cycle continues, with the crest and troughs slowly decreasing as the disk fills up (which I believe is expected).
> 
> We tried running it with 2 threads. We saw the same degradation and recovery performance profile, except it took ~36 minutes to bottom out and recover. Likewise, with only 1 thread it took ~72 minutes. In all cases the pattern continued until the disk was full.

72 minute cycle. Coincidence that it matches the AG count? Not at
all.

Once a minute, the workload changes directory. The directory for
the next minute gets put in the next AG. Over 73 minutes, we
have a set of files in 73 AGs. AG 0 is at the outer edge of
all the disks in the LUN. AG 73 is at the inner edge of all the
disks in the lun.

Typical manufacturer quoted transfer speed for spinning rust is
the outer edge (usually >200MB/s these days), so if we take into
latencies involved in writing to all disks at once, 190MB/s per disk
gives 1500MB/s.

However, at the inner edge of the disks, transfer rates to the media
are usually in the range of 50-100MB/s. 8x75MB/s = 600MB/s.

The cycle time was halved for two threads because there are 2
directories per minute, so it cycles through the 73 AGs at twice the
rate.

Essentially, XFS is demonstrating the exact performance of your
underlying array.

> We thought perhaps the directory structure was problematic, so we tried the following directory structure too: <THREAD>/<DATE>/<DATE>-<HOUR><MINUTE<SECOND>.data. This also had one file per second. This time, it took about 12.2 hours for the performance to bottom out before instantly shooting back up again.

Yup, this time you'll probably find it slowly walked AGs until it
ran out of stripe unit aligned free space, then it went back to AG 0
where the parent directory is and started filling holes.

So, two things - there's probably an issue with your stripe
alignment, and the behaviour you are seeing is a direct result of
the way XFS physically isolates per-directory data and the
underlying device performance across it's address space.

> Some other notes:
> 
> - I ran the same test with an Adaptec RAID controller as well,
> which gave the same performance profile.

It should.

> - I ran the same test with an ext4 filesystem just to see if it
> gave the same performance profile. It did not - the performance
> slowly degraded over time before a quick dropoff as the disk
> reached max capacity. I expected a different profile, but just
> wanted to run something to make sure that would be the case.

Also as expected. ext4 fills from the outer edge to the inner edge -
it does not segregate directories to different regions of the
filesystem like XFS does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
