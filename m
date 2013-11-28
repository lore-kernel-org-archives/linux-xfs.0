Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E76E7F50
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 13:59:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77398304053
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 11:59:54 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mLx5unKOPPqtauXo
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 11:59:53 -0800 (PST)
Message-ID: <5297A0B4.5020303@hardwarefreak.com>
Date: Thu, 28 Nov 2013 13:59:48 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: ARC-1120 and MD very sloooow
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com>	<20131126061458.GM8803@dastard>	<529455CB.6050907@hardwarefreak.com>
	<CAMqSRmCJEp1i9QXGRBZ+2Ohv95=JfTkwO9oTnE3fkX0K1f6hug@mail.gmail.com>
In-Reply-To: <CAMqSRmCJEp1i9QXGRBZ+2Ohv95=JfTkwO9oTnE3fkX0K1f6hug@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/28/2013 9:59 AM, Jimmy Thrasibule wrote:
>> Right.  It's unusual to see this many mount options.  FYI, the XFS
>> default is relatime, which is nearly identical to noatime.  Specifying
>> noatime won't gain you anything.  Do you really need nosuid, nodev, noexec?
> 
> Well better say what I don't want on the filesystem no?
> 
>  >Do you also see the low write speed and slow ls on md0, any/all of your
>> md/RAID10 arrays?
> 
> Yes, all drive operations are slow, unfortunately, I have no drives in
> the machine
> that are not managed by the controller to push tests further.

Testing a single drive might provide a useful comparison.

>> The usual: "iostat -x -d -m 5" output while the test is running.
>> Also, you are using buffered IO, so changing it to use direct IO
>> will tell us exactly what the disks are doing when Io is issued.
>> blktrace is your friend here....
> 
> I've ran the following:
>
>     # dd if=/dev/zero of=/srv/store/video/test.zero bs=512K count=6000
> oflag=direct
>     6000+0 records in
>     6000+0 records out
>     3145728000 bytes (3.1 GB) copied, 179.945 s, 17.5 MB/s

While O_DIRECT writing will give a more accurate picture of the
throughput at the disks, single threaded O_DIRECT is usually not a good
test due to serialization.  That said, 17.5MB/s is very slow even for a
single thread.

>     # dd if=/srv/store/video/test.zero of=/dev/null iflag=direct
>     6144000+0 records in
>     6144000+0 records out
>     3145728000 bytes (3.1 GB) copied, 984.317 s, 3.2 MB/s

This is useless.  Never use O_DIRECT on input with dd.  The result will
always be ~20x lower than actual drive throughput.

> Traces are huge for the read test so I put them on Google Drive + SHA1 sums:
> https://drive.google.com/folderview?id=0BxJZG8aWsaMaVWkyQk1ELU5yX2c
> 
> Drives `sdc` to `sdf` are part of the RAID10 array. Only drives `sdc` and `sde`
> are used when reading.
> 
>> That makes me wonder if the controller and drive write caches have been disabled.
>> That could explain this.
> 
> Caching is enabled for the controller but not much information.
> 
>     > sys info
>     The System Information
>     ===========================================
>     Main Processor     : 500MHz
>     CPU ICache Size    : 32KB
>     CPU DCache Size    : 32KB
>     CPU SCache Size    : 0KB
>     System Memory      : 128MB/333MHz/ECC
>     Firmware Version   : V1.49 2010-12-02
>     BOOT ROM Version   : V1.49 2010-12-02
>     Serial Number      : Y611CAABAR200126
>     Controller Name    : ARC-1120
>     ===========================================

This doesn't tell you if the read/write cache is enabled or disabled.
This is simply the controller information summary.

> By the way is enabling the controller cache a good idea? I would disable
> it and let the kernel manage.

With any decent RAID card the cache is enabled automatically for reads.
 The write cache will only be enabled automatically if a battery module
is present and the firmware test shows it is in good condition.  Some
controllers allow manually enabling the write cache without battery.
This is usually not advised.  Since barriers are enabled in XFS by
default, you may try enabling write cache on the controller to see if
this helps performance.  It may not depending on how the controller
handles barriers.  And of course, using md you'll want drive caches
enabled or performance will be horrible.  Which is why I recommending
checking to make sure they're enabled.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
