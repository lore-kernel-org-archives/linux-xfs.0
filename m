Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p074ZMRB233627 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 22:35:22 -0600
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F0C9236FCC
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 20:37:32 -0800 (PST)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id UDxe77WXA4Kfao7S for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 20:37:32 -0800 (PST)
Subject: Re: TRIM details
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <4D2686ED.7000304@philkarn.net>
Date: Thu, 06 Jan 2011 23:35:57 -0500
In-Reply-To: <4D2686ED.7000304@philkarn.net> (Phil Karn's message of "Thu, 06
	Jan 2011 19:22:21 -0800")
Message-ID: <yq1mxndnxea.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

>>>>> "Phil" == Phil Karn <karn@philkarn.net> writes:

Phil> I'd like to know exactly how the drives implement TRIM but I've
Phil> only found bits and pieces. Can anyone suggest a current and
Phil> complete reference for the complete SATA command set that includes
Phil> all the TRIM related stuff?

You kind-of have to be T13 member to get it. But try googling ATA
ACS-2...


Phil> As I understand it, there's a SATA (and SCSI?) command that will
Phil> repeatedly write a fixed block of data to some number of
Phil> consecutive LBAs (WRITE SAME), and an "unmap" bit in the write
Phil> command can be set to indicate that instead of actually writing
Phil> the blocks, they can be marked for erasure and placed in the free
Phil> pool.

There are several commands and variations...

For ATA there's the DSM TRIM command which allows you to indicate ranges
of blocks to discard. The ranges are stored in the data blocks and not
the command itself. A device can indicate how many blocks of payload it
supports. Many don't. Some of those that do blow up if you actually send
more than one block.

In SCSI there are three ways:

1. WRITE SAME with a zeroed payload
2. WRITE SAME with the UNMAP bit set
3. UNMAP command

UNMAP, like ATA DSM, takes a set of ranges in the data payload. Just to
make things more interesting they are not the same format and don't have
a 1:1 mapping with the ATA ranges.

There is no official support for (1) at the protocol level. You have to
know via means outside the standard whether the device supports logical
block provisioning with zero detection. There are a few storage arrays
out there that do.

Whether the device supports (2) or (3) is indicated in a set of VPD
pages that also indicate preferred granularity, alignment, etc. That
didn't use to be the case so for a while you just had to guess. We have
some heuristics in place that pick the right command depending on the
device.

Furthermore, in Linux, ATA sits underneath SCSI. So we translate WRITE
SAME(16) with the UNMAP bit set to DSM TRIM in our SCSI-ATA Translation
Layer.

Finally, there are a set of bits in both ATA and SCSI that indicate
whether read after a discard will return zeroes or garbage. Some devices
report that they return zeroes but don't in all cases.

The kernel goes through a lot of blah to make sure we're doing the right
thing. I really don't think that's a headache that's worth repeating.

Thankfully, at the top of the stack we have a generic block device ioctl
that hides all the complexity from the user. If you want to tinker
that's a much better place to start.

If you check the archives you'll also see that the filesystem-specific
FITRIM ioctl is being worked on. Plus some filesystems have the option
of doing discards in realtime.


Phil> Just have the drive interpret an ordinary write of all 0's to any
Phil> LBA as an implicit "unmap" indication for that LBA. As long as the
Phil> drive returns all 0's when an unmapped LBA is read (and I believe
Phil> this is already a requirement) then were an application to write a
Phil> block of real data that just happens to contain all 0's, it would
Phil> still get back what it wrote.

See above.


Phil> Then you could manually trim a drive with something like

Phil> dd if=/dev/zero of=foobar bs=1024k count=10240k rm foobar

But if the device does not detect zeroes then you'll end up:

 - transferring a bunch of useless data across the bus which will slow
   things to a grinding halt

and

 - if it's an SSD, wear out a lot of flash cells for no reason

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
