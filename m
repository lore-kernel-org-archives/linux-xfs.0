Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EHrEHQ218204 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 12:53:14 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id FdeFdBnJNR9dwSdz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 10:53:12 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S7sNs-000666-FJ
	for xfs@oss.sgi.com; Wed, 14 Mar 2012 10:53:12 -0700
Message-ID: <33504119.post@talk.nabble.com>
Date: Wed, 14 Mar 2012 10:53:12 -0700 (PDT)
From: troby <Thorn.Roby@harlandfs.com>
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
In-Reply-To: <20120314073752.GA44708@nsrc.org>
MIME-Version: 1.0
References: <33498437.post@talk.nabble.com> <20120314073752.GA44708@nsrc.org>
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
To: xfs@oss.sgi.com


The choice of RAID5 was a compromise due to the need to store 30TB of data on
each of 2 systems (a master and a replicated slave) - we couldn't afford
that much space on our SAN for this application, but we could afford a
12-bay system with 3TB SATA drives. My hope was that since the write pattern
was expected to be large sequential writes with no updates that the RAID5
penalty would not be significant. And it's quite possible that would be the
case if I had got the stripe width right. The 8K element size was chosen
because the actual average request size I was seeing on previous
installations of the database was around 60K, which is still smaller than
the stripe width over 12 drives even using 8K. I did try btrfs early on to
take advantage of compression, but it failed. This was about six months ago,
though.


Brian Candler wrote:
> 
> On Tue, Mar 13, 2012 at 04:21:07PM -0700, troby wrote:
>> there is very little metadata activity). When I created the filesystem I
>> (mistakenly) believed the stripe width of the filesystem should count all
>> 12
>> drives rather than 11. I've seen some opinions that this is correct, but
>> a
>> larger number which have convinced me that it is not.
> 
> With a 12-disk RAID5 you have 11 data disks, so the optimal filesystem
> alignment is 11 x stripe size.  This is auto-detected for software (md)
> raid, but may or may not be for hardware RAID controllers.
> 
> For example, here is a 12-disk RAID6 md array (10 data, 2 parity):
> 
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4]
> [raid10] 
> md127 : active raid6 sdf[4] sdb[0] sdh[6] sdj[8] sdi[7] sdd[2] sdm[10]
> sdk[9] sdc[1] sdl[11] sdg[5] sde[3]
>       29302654080 blocks super 1.2 level 6, 64k chunk, algorithm 2 [12/12]
> [UUUUUUUUUUUU]
>       
> And here is the XFS filesystem which was created on it:
> 
> $ xfs_info /dev/md127
> meta-data=/dev/md127             isize=256    agcount=32, agsize=228926992
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=7325663520, imaxpct=5
>          =                       sunit=16     swidth=160 blks
> naming   =version 2              bsize=16384  ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The parameters were detected automatically. sunit=16 x 4K = 64K, swidth=
> 160 x 4K = 640K.
> 
>> I also set up the RAID
>> BIOS to use a small stripe element of 8KB per drive, based on the I/O
>> request size I was seeing at the time in previous installations of the
>> same
>> application, which was generally doing writes around 100KB.
> 
> I'd say this is almost guaranteed to give poor performance, because there
> will always be partial stripe write if you are doing random writes.  e.g. 
> consider the best case, which is when the 100KB is aligned with the start
> of
> the stripe.  You will have:
> 
> - a 88KB write across the whole stripe
>   - 12 disks seek and write; this will take a whole revolution before
>     it completes on every drive, i.e. 8.3ms rotational latency, in
> addition
>     to seek time. The transfer time will be insignificant
>   - one tiny write
> - 12KB write across a partial stripe. This will involve an 8K write to
> block
>   A, a 4K read of block B and block P (parity), and a 4K write of block B
>   and block P.
> 
> Now consider what it would have been with a 256KB stripe size. If you're
> lucky and the whole 100K fits within a chunk, you'll have:
> 
> - read 100K from block A and block P
> - write 100K to block A and block P
> 
> There is less rotational latency, only slightly higher transfer time
> (for a slow drive which does 100MB/sec, 100KB will take 1ms), and will
> allow
> concurrent writers in the same area of disk, and much faster access if
> there
> are concurrent readers of those 100K chunks.
> 
> The performance will still suck however, compared to RAID10.
> 
>> I'm unclear on the role of the RAID hardware cache in this. Since the
>> writes
>> are sequential, and since the volume of data written is such that it
>> would
>> take about 3 minutes to actually fill the RAID cache, I would think the
>> data
>> would be resident in the cache long enough to assemble a full-width
>> stripe
>> at the hardware level and avoid the 4 I/O RAID5 penalty. 
> 
> Only if you're writing sequentially. For example, if you were untarring a
> huge tar file containing 100KB files, all in the same directory, XFS can
> allocate the extents one after the other, and so you will be doing pure
> stripe writes.
> 
> But for *random* I/O, which I'm pretty sure is what mongodb will be doing,
> you won't have a chance. The controller will be forced to read the
> existing
> data and parity blocks so it can write back the updated parity.
> 
> So the conclusion is: do you actually care about performance for this
> application?  If you do, I'd say don't use RAID5.  If you absolutely must
> use parity RAID then go buy a Netapp ($$$) or experiment with btrfs
> (risky). 
> The cost of another 10 disks for a RAID10 array is going to be small in
> comparison.
> 
> Regards,
> 
> Brian.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

-- 
View this message in context: http://old.nabble.com/How-to-deal-with-XFS-stripe-geometry-mismatch-with-hardware-RAID5-tp33498437p33504119.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
