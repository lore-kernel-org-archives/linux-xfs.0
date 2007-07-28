Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jul 2007 20:08:33 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6S38Tbm028851
	for <xfs@oss.sgi.com>; Fri, 27 Jul 2007 20:08:31 -0700
Message-ID: <46AAA340.60208@agami.com>
Date: Fri, 27 Jul 2007 19:00:32 -0700
From: "William J. Earl" <earl@agami.com>
MIME-Version: 1.0
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com>
In-Reply-To: <20070726233129.GM12413810@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@agami.com>, markgw@sgi.com

David Chinner wrote:
> On Thu, Jul 26, 2007 at 10:53:02AM -0700, Michael Nishimoto wrote:
>   
> ...
>> Is CRC checking being added to xfs log data?
>>     
>
> Yes. it's a little used debug option right now, and I'm
> planning on making it default behaviour.
>
>   
>> If so, what data has been collected to show that this needs to be added?
>>     
>
> The size of high-end filesystems are now at the same order of
> magnitude as the bit error rate of the storage hardware. e.g. 1PB =
> 10^16 bits. The bit error rate of high end FC drives? 1 in 10^16
> bits.  For "enterprise" SATA drives? 1 in 10^15 bits. For desktop
> SATA drives it's 1 in 10^14 bits (i.e. 1 in 10TB).
>
> We've got filesystems capable of moving > 2 x 10^16 bits of data
> *per day* and we see lots of instances of multi-TB arrays made out
> of desktop SATA disks. Given the recent studies of long-term disk
> reliability, these vendor figures are likely to be the best error
> rates we can hope for.....
>
> IOWs, we don't need evidence to justify this sort of error detection
> detection because simple maths says there is going to be errors.  We
> have to deal with that, and hence we are going to be adding CRC
> checking to on-disk metadata structures so we can detect bit errors
> that would otherwise go undetected and result in filesystem
> corruption.
>
> This means that instead of getting shutdown reports for some strange
> and unreproducable btree corruption, we'll get a shutdown for a CRC
> failure on the btree block. It is very likely that this will occur
> much earlier than a subtle btree corruption would otherwise be
> detected and hence we'll be less likely to propagate errors around
> the fileystem.
> ...
         Mike Nishimoto pointed out this thread to me, and suggested I 
reply, since I have worked on the analyzing the disk failure modes.  

       First, note that the claimed bit error rates are rates of 
reported bad blocks, not rates of silent data corruption.   The latter, 
while not quoted, are far lower.

       With large modern disks, it is unrealistic to not use RAID 1, 
RAID 5, or RAID 6 to mask reported disk bit errors.   A CRC in a 
filesystem data structure, however, is not required to detect disk 
errors, even without RAID protection, since the disks report error 
correction failures.   The rates of 1 in 10**14 (desktop SATA), 1 in 
10**15 (Enterprise SATA and some FC), and 1 in 10**16 (some FC) bits 
read are detected and reported error rates.   From conversations with 
drive vendors, these are actually fairly conservative, and assume you 
write the data once and read it after 10 years without rewriting it, as 
in an archive, which is the worst case, since you have ten years of 
accumulated deterioration.  

       With RAID protection, seeing reported errors which are not masked 
by the RAID layer is extremely unlikely, except in the case of a drive 
failure, where it is necessary to read all of the surviving drives to 
reconstruct the contents of the lost drive.    With 500 GB drives and a 
7D+1P RAID 5 group, we need to read 350 GB to rebuild the RAID array 
using a replacement drive, which is to say about 2.8 * 10**12 bits.   
This implies we would see one block not reconstructed in every 35 
rebuilds on desktop SATA drives, if the data were archive data written 
once and the rebuild happened after 10 years.     We would expect about 
one rebuild in 10 years.

       With more RAID groups, the chance of data loss grows very 
high.    With 100 groups, we would see a rebuild every  month or so, so 
we would expect an unmasked read error every few years.    With better 
drives, the chance is of course reduced, but is still significant in 
multi-PB storage systems.   RAID 6 largely eliminates the chance of 
seeing a read error, at some cost in performance.

       Note that some people have reported both much higher annual 
failure rates for drives (which increases the frequency of RAID 
reconstructions and hence the chance of data loss) and higher read error 
rates.    Based on personal experience with a large number of drives, I 
believe that both of these are a consequence of systems (including 
software and disk host bus adapters) dealing poorly with common 
transient disk problems, not actual errors on the surface of the disk.   
For example, if the drive firmware gets confused and stops talking, the 
controller will treat it as a read timeout, and the software may simply 
report "read failure", which in turn may be interpreted as "drive 
failed", even though an adequate drive reset would return the drive to 
service with no harm done to the data.  

     In addition, many people have taken up using desktop drives for 
primary storage, for which they are not designed.   Desktop drives are 
typically rated at 800,000 to  1,000,000 hours MTBF at 30% duty 
cycle.    Using them at 100% duty cycle drastically decreases their 
MTBF, which in turn drastically increases the rate of unmasked read 
errors, as a consequence of the extra RAID reconstructions.

      Lastly, quite a few "white box" vendors have shipped chassis which 
do not adequately cool and power the drives, and excessive heat can also 
drastically reduce the MTBF.

       In a well-designed chassis, with software which correctly 
recovers from transient drive issues, I have observed higher than 
claimed MTBF and much lower than claimed bit error rates.    The 
undetected error rate from a modern drive is not quoted publicly, but 
the block ECC is quite strong (since it has to mask raw bit error rates 
as high as 1 in 10**3) and hence can detect most error scenarios and 
correct many of them.

       None of the above, however, implies that we need CRCs on 
filesystem data structures.   That is, if you get EIO on a disk read, 
then you don't need a CRC to know the block is bad.    Other concerns, 
however, can motivate having CRCs.   In particular, if the path between 
drive and memory can corrupt the data, then CRCs can help us recover to 
some extent.    This has been a recurring problem with various 
technologies, but was particularly common on IDE (PATA) drives with 
their vulnerable cables, where mishandling of the cable could lead to 
silent data corruption.    CRCs on just filesystem data structures, 
however, only help with metadata integrity, leaving file data integrity 
in the dark.   Some vendors at various times,   such as Tandem and 
NetApp, have added a checksum to each block, usually when they were 
having data integrity issues which turned out in the end to be bad 
cables or bad software, but which could be masked by RAID recovery, if 
detected by the block checksum.   It is usually cost-effective, however, 
to simply select a reliable disk subsystem.   

       With SATA, SAS, and FC, which have link-level integrity checks, 
silent data corruption on the link is unlikely.   This leaves mainly the 
host bus adapter, the main memory, and the path between them.   If those 
are bad, however, it is hard to see how much the filesystem can help.

      In conclusion, I doubt that CRCs are worth the added 
complexity.    If I wanted to mask flaky hardware, I would look at using 
RAID 6 and validating parity on all reads and doing RAID recovery on any 
errors, but doing offline testing of the hardware and repairing or 
replacing any broken bits would be yet simpler.


     
