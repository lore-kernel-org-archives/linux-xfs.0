Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58L0OgJ117622 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 16:00:24 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CEE51E41F68
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 14:00:22 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qVexKAechbdECvg4
	for <xfs@oss.sgi.com>; Wed, 08 Jun 2011 14:00:22 -0700 (PDT)
Message-ID: <4DEFE2E6.9010206@hardwarefreak.com>
Date: Wed, 08 Jun 2011 16:00:22 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Defragging XFS File Systems
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>	<4DEE1422.7060902@hardwarefreak.com>
	<BANLkTikBSL8-eTAbF7a94ckLuZNyWCM=Eg@mail.gmail.com>
In-Reply-To: <BANLkTikBSL8-eTAbF7a94ckLuZNyWCM=Eg@mail.gmail.com>
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
To: Kenneth Emerson <kenneth.emerson@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 6/8/2011 2:55 PM, Kenneth Emerson wrote:
> On Tue, Jun 7, 2011 at 7:05 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:
> 
>> On 6/6/2011 10:52 PM, Kenneth Emerson wrote:
>>> I hadn't given much thought to fragmentation of my TV recordings volume
>>> (XFS) until reading through some MythTV-users threads recently that
>>> mentioned how fragmented an XFS file system could become.  After running
>>> xfs_db, I found out that my fs appeared to be quite bad:
>>>
>>> $ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv
>>>  actual 1138668, ideal 11023, fragmentation factor 99.03%
>>>
>>> I then ran xfs_fsr with all defaults (ran for two hours) and then re-ran
>>
>> From man xfs_fsr:
>>
>>       It runs for up to two hours after which it records the
>>       filesystem where it left off, so it can start there the next
>>       time.  This  information  is stored in the file
>>       /var/tmp/.fsrlast_xfs.  If the information found here is somehow
>>       inconsistent or out of date it is ignored and reorganization
>>       starts at the beginning of the first filesystem found in
>>       /etc/mtab.
>>
>> If xfs_fsr stopped at 2 hours, multiple additional runs will likely be
>> required to get good defragmentation.
>>
> 
> After some more research, I don't think I would ever be able to defrag this
> volume.  It is too badly fragmented and too full.

Then you have a couple of options:

1.  Delete files to free up space for xfs_fsr to work properly
2.  Dump, delete, re-create, and restore the filesystem

The first will likely leave you with fragmentation.  The second will
eliminate all fragmentation.

>>> xfs_db and got the following results:
>>>
>>> $ sudo xfs_db -c frag -r /dev/mapper/appl_vg-appl_lv
>>
>> The -r above suggests you created a large realtime section for your
>> MythTV storage.  It may be helpful for you to provide xfs_info output
>> for the heavily fragmented filesystem.

> I thought the -r was just for read only so that I didn't have to un-mount
> it before running the report.

According to man xfs_db, '-r' immediately following the frag command:
...
	-r  enables processing of realtime file data

>>> invalid numrecs (27111) in bmapbtd block
>>> invalid numrecs (4716) in bmapbtd block
>>> invalid numrecs (58978) in bmapbtd block
>>>
>>> I'll leave these errors for one of the devs to tackle.
>
> These errors 'disappeared' when I ran xfs_db again later.

Maybe a cache consistency issue.

>>> actual 1034793, ideal 11024, fragmentation factor 98.93%
>>>
>>> The fragmentation level was reduced,
>>
>> It was likely reduced much more than this.  Dropping caches or
>> unmounting and remounting the filesystem is often necessary after
>> running xfs_fsr in order to show the actual fragmentation level.  Try:
>>
>> # echo 3 > /proc/sys/vm/drop_caches
>>
>> and then run xfs_db again.

> I did this, but the numbers did not change much.  Many of the files are >
> 4GiB and have over a hundred extents.  When I tried to defrag a single file,
> it reported that it wan't possible.

Looks like a dump/remake/restore is in your future.

>>> but I was concerned about the error
>>> messages.  Before I go any further, am I corrupting my file system with
>> the
>>> defragging or are these "invalid numrecs" messages unimportant?
>>
>> Run 'xfs_check' or 'xfs_repair -n' and post the results.

> Not necessary since the errors are now gone.  I have ordered a 3TB disk
> that I can connect via e-sata and copy the entire volume off of the RAID
> set.  I will then reformat and put the files back.  After that, I will make
> a cron job to run on a regular basis to keep the volume from getting so
> fragmented again.

Bang on that eSATA drive/interface/driver thoroughly before relying on
it for your intended purpose.  Look in dmesg regularly for errors while
burning it in.  Be mindful of partition alignment if he 3TB drive is an
"Advanced Format" hybrid 512/4096 byte drive.

> Thanks for your input.

You're welcome.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
