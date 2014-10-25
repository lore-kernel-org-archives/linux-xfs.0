Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8EC067F37
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 21:28:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C59C8F8049
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 19:28:27 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 8YNJoiQziqtyRSaQ
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 19:28:23 -0700 (PDT)
Message-ID: <544B0AE5.9090500@hardwarefreak.com>
Date: Fri, 24 Oct 2014 21:28:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: gather write metrics on multiple files
References: <543611CF.6030904@hardwarefreak.com>
	<543613E7.70508@gmail.com>	<54361C04.5090404@hardwarefreak.com>	<20141009211339.GD4376@dastard>	<544202AE.3000003@hardwarefreak.com>	<5442AE9A.7030703@hardwarefreak.com>	<20141019222434.GL17506@dastard>
	<5446F29F.7090406@hardwarefreak.com>
In-Reply-To: <5446F29F.7090406@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On 10/21/2014 06:56 PM, Stan Hoeppner wrote:
> 
> On 10/19/2014 05:24 PM, Dave Chinner wrote:
...
>>>> The filesystems were aligned at make time
>>>> w/768K stripe width, so each prealloc file should be aligned on
>>>> a stripe boundary.
>>
>> "should be aligned"? You haven't verified they are aligned by using
>> with 'xfs_bmap -vp'?
> 
> If I divide the start of the block range by 192 (768k/4k) those files
> checked so far return a fractional value.  So I assume this means these
> files are not stripe aligned.  What might cause that given I formatted
> with alignment?

It seems file alignment isn't a big problem after all as the controllers
are doing relatively few small destages, about 1/250th of full stripe
destages.  And some of these are journal and metadata writes.

...
>>> The 350 streams are written to 350 preallocated files in parallel.
>>
>> And they layout of those files are? If you don't know the physical
>> layout of the files and what disks in the storage array they map to,
>> then you can't determine what the seek times should be. If you can't
>> work out what the seek times should be, then you don't know what the
>> stream capacity of the storage should be.

Took some time but I worked out a rough map of the files.  SG0, SG1, and
SG2 are the large, medium, and small file counts respectively.

AG  SG0 SG1 SG2		AG  SG0 SG1 SG2		AG  SG0 SG1 SG2		AG  SG0 SG1 SG2

 0    0 129 520		11  162 132 514		22  160 131 519		33  164 133 522
 1  164 129 518		12  160 132 520		23  161 132 518		34  161 130 517
 2  164 133 521		13  164 129 522		24  163 131 521		35  162 132 518
 3  159 129 518		14  164 130 522		25  162 129 519		36  161 131 518
 4   92 257 518		15  163 130 522		26  163 128 520		37  158 131 515
 5   91 256 516		16  163 131 521		27  162 130 523		38    0 132 518
 6   91 263 519		17  161 130 518		28  161 130 524		39    0 128 523
 7   92 261 518		18  165 127 520		29  163 129 517		40    0 131 521
 8   91 253 515		19  161 130 517		30  166 129 520		41    0 130 522
 9   94 257 451		20  167 128 525		31  162 129 521		42    0 128 517
10  172 129 455		21  164 130 515		32  161 129 515		43    0 131 516

All 3 file sizes are fairly evenly spread across all AGs, and that is a
problem.  The directory structure is setup so that each group directory
has one subdir per stream and multiple files which are written in
succession as they fill, and we start with the first file in each
directory.  SG0 has two streams/subdirs, SG1 has 50, and SG2 has 350.
Write stream rates:

SG0	  2@ 94.0  MB/s,
SG1	 50@  2.4  MB/s
SG2	350@  0.14 MB/s

This is 357 MB/s aggregate targeted at a 12+1 RAID5 or 12+2 RAID6, the
former in this case.  In either case we can't maintain this rate.  A
~36-45 hour run writes all files once.  During this duration we see the
controller go into congestion hundreds of times.  Wait goes up,
bandwidth down, and we drop application buffers because they're on a
timer.  If we can't write a buffer in X seconds we drop it.

The directory/file layout indicates highly variable AG access patterns
throughout the run, thus lots of AG-to-AG seeking, thus seeking lots of
platter surface all the time.  It also indicates large sweeps of the
actuators when concurrent file accesses are in low and high numbered
AGs.  And this tends to explain the relatively stable throughput some of
the time with periods of high IO wait and low bandwidth at other times.
 Too much seek delay with these latter access patterns.

I haven't profiled the application to verify which files are written in
parallel at a given point in the run, but I think that would be a waste
of time given the file/AG distribution we see above.  And I don't have
enough time left on my contract to do it anyway.

I've can attach tree or 'ls -lavR' output if that would help paint a
clearer picture of ho the filesystem is organized.


Thanks,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
