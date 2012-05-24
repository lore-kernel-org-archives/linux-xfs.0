Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OLl28F113032 for <xfs@oss.sgi.com>; Thu, 24 May 2012 16:47:02 -0500
Received: from boosthardware.localdomain (boosthardware.com [88.198.122.139])
	by cuda.sgi.com with ESMTP id pANpc6bdSW6FpJWS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 May 2012 14:47:00 -0700 (PDT)
Message-ID: <60350.110.32.169.6.1337896017.squirrel@boosthardware.com>
In-Reply-To: <20120524153339.GC3963@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
	<20120511165012.GC16099@sgi.com>
	<59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
	<20120514142948.GS3963@sgi.com>
	<64776.110.174.53.110.1337043522.squirrel@boosthardware.com>
	<20120515151331.GG16099@sgi.com>
	<56000.110.174.53.110.1337135447.squirrel@boosthardware.com>
	<20120524153339.GC3963@sgi.com>
Date: Thu, 24 May 2012 23:46:57 +0200 (CEST)
Subject: Re: file corruption issue
From: "Patrick Shirkey" <pshirkey@boosthardware.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com


On Thu, May 24, 2012 5:33 pm, Ben Myers wrote:
> Hey Patrick,
>
> On Wed, May 16, 2012 at 04:30:47AM +0200, Patrick Shirkey wrote:
>> On Tue, May 15, 2012 5:13 pm, Ben Myers wrote:
>> > On Tue, May 15, 2012 at 02:58:42AM +0200, Patrick Shirkey wrote:
>> >> Unfortunately I cannot unmount the partition/s to run xfs_metadump
>> because
>> >> they are in use.
>> >>
>> >> I have found some files that were truncated on a recent crash. Is
>> there
>> >> any tool I can run on those files to get info that might be useful?
>> >
>> > Hrm.. xfs_bmap output could be helpful so we can see the block map.
>> Do you
>> > know how big they are supposed to be?  How much was truncated?
>> >
>>
>> The files that we have as examples were originally 28bytes but are now
>> 0byte.
>>
>> Running xfs_bmap on the 0 byte file returns "no extent".
>>
>> ex.
>>
>> These files are located next to each other in the same folder.
>>
>> - 28 byte file: EXT: FILE-OFFSET      BLOCK-RANGE              AG
>> AG-OFFSET
>> TOTAL 0: [0..7]:          28230136440..28230136447 13
>> (312849120..312849127)
>> 8
>>
>> - 0 byte file: no extents
>
> So how old are the files that get truncated?  Were they created very
> recently?
>

Most of the corrupted files were create weeks earlier and many of them
have been through several reboots before getting chomped. We have seen it
on SSD and HDD's in multiple different partitions. All of them are xfs
partitions.

We thought it might be something to do with file descriptors but the
amount of data corruption and the random blockiness suggests it is a
different issue.

We do not see the problem with any other hardware. It seems to be directly
related to these HP machines. To replicate we just need to pull the plug
and we see data loss/corruption across the drives. It may be that it is a
hardware issue with the mobo and raid controller which is spiking the
disks? HP have installed a firmware upgrade which didn't make any
difference.

At this stage we are trying to understand how it could be possible so
would like to rule out or confirm if it would be possible in XFS. Some of
our research suggest that there are known issues with XFS in some cases of
high load but we don't want to point the finger unless we are sure.





>> - A few more details that may be relevant.
>>
>> 1: We are running openvz and LVM on these machines. Are there any known
>> issue/s with file corruption after a hard reset with openvz/LVM running?
>
> I don't know about openvz/LVM...
>
>> 2: We have observed that while there is no obvious pattern in the data
>> corruption is does happen in chunks. It appears to be random chunks of
>> files
>> that are corrupted after a crash->reset sequence.
>
> ...and the data corruption happened in files that are read only?  Again..
> when
> were they created?
>
> Thanks,
> Ben
>


--
Patrick Shirkey
Boost Hardware Ltd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
