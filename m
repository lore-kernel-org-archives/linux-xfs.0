Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfBVON2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 09:13:28 -0500
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
        <yq17edsil17.fsf@oracle.com> <20190222111532.4ead81dc@natsu>
Date: Fri, 22 Feb 2019 09:12:44 -0500
In-Reply-To: <20190222111532.4ead81dc@natsu> (Roman Mamedov's message of "Fri,
        22 Feb 2019 11:15:32 +0500")
Message-ID: <yq136ofj4ir.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Roman Mamedov <rm@romanrm.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, Keith Busch <keith.busch@intel.com>, Ric Wheeler <ricwheeler@gmail.com>, Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org


Roman,

>> Consequently, many of the modern devices that claim to support
>> discard to make us software folks happy (or to satisfy a purchase
>> order requirements) complete the commands without doing anything at
>> all.  We're simply wasting queue slots.
>
> Any example of such devices? Let alone "many"? Where you would issue a
> full-device blkdiscard, but then just read back old data.

I obviously can't mention names or go into implementation details. But
there are many drives out there that return old data. And that's
perfectly within spec.

At least some of the pain in the industry in this department can be
attributed to us Linux folks and RAID device vendors. We all wanted
deterministic zeroes on completion of DSM TRIM, UNMAP, or DEALLOCATE.
The device vendors weren't happy about that and we ended up with weasel
language in the specs. This lead to the current libata whitelist mess
for SATA SSDs and ongoing vendor implementation confusion in SCSI and
NVMe devices.

On the Linux side the problem was that we originally used discard for
two distinct purposes: Clearing block ranges and deallocating block
ranges. We cleaned that up a while back and now have BLKZEROOUT and
BLKDISCARD. Those operations get translated to different operations
depending on the device. We also cleaned up several of the
inconsistencies in the SCSI and NVMe specs to facilitate making this
distinction possible in the kernel.

In the meantime the SSD vendors made great strides in refining their
flash management. To the point where pretty much all enterprise device
vendors will ask you not to issue discards. The benefits simply do not
outweigh the costs.

If you have special workloads where write amplification is a major
concern it may still be advantageous to do the discards and reduce WA
and prolong drive life. However, these workloads are increasingly moving
away from the classic LBA read/write model. Open Channel originally
targeted this space. Right now work is underway on Zoned Namespaces and
Key-Value command sets in NVMe.

These curated application workload protocols are fundamental departures
from the traditional way of accessing storage. And my postulate is that
where tail latency and drive lifetime management is important, those new
command sets offer much better bang for the buck. And they make the
notion of discard completely moot. That's why I don't think it's going
to be terribly important in the long term.

This leaves consumer devices and enterprise devices using the
traditional LBA I/O model.

For consumer devices I still think fstrim is a good compromise. Lack of
queuing for DSM hurt us for a long time. And when it was finally added
to the ATA command set, many device vendors got their implementations
wrong. So it sucked for a lot longer than it should have. And of course
FTL implementations differ.

For enterprise devices we're still in the situation where vendors
generally prefer for us not to use discard. I would love for the
DEALLOCATE/WRITE ZEROES mess to be sorted out in their FTLs, but I have
fairly low confidence that it's going to happen. Case in point: Despite
a lot of leverage and purchasing power, the cloud industry has not been
terribly successful in compelling the drive manufacturers to make
DEALLOCATE perform well for typical application workloads. So I'm not
holding my breath...

-- 
Martin K. Petersen	Oracle Linux Engineering
