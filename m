Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p48HErUm039224 for <xfs@oss.sgi.com>; Sun, 8 May 2011 12:14:53 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73BC4159CD36
	for <xfs@oss.sgi.com>; Sun,  8 May 2011 10:18:34 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ZR0UymAoX0nVdA7N
	for <xfs@oss.sgi.com>; Sun, 08 May 2011 10:18:34 -0700 (PDT)
Message-ID: <4DC6D067.1080208@hardwarefreak.com>
Date: Sun, 08 May 2011 12:18:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 2.6.38.4: xfs speed problem?
References: <alpine.DEB.2.02.1105071042210.20162@p34.internal.lan>
	<20110508003321.GI26837@dastard>
In-Reply-To: <20110508003321.GI26837@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org

On 5/7/2011 7:33 PM, Dave Chinner wrote:
> On Sat, May 07, 2011 at 12:09:46PM -0400, Justin Piszcz wrote:
>> Hello,
>>
>> Using 2.6.38.4 on two hosts:
>>
>> Host 1:
>> $ /usr/bin/time find geocities.data 1>  /dev/null
>> 80.92user 417.93system 2:19:07elapsed 5%CPU (0avgtext+0avgdata 105520maxresident)k
>> 0inputs+0outputs (0major+73373minor)pagefaults 0swaps
>>
>> # xfs_db -c frag -f /dev/sda1
>> actual 40203982, ideal 40088075, fragmentation factor 0.29%
>>
>> meta-data=/dev/sda1              isize=256    agcount=44, agsize=268435455 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=11718704640, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> --
>>
>> Host 2:
>> $ /usr/bin/time find geocities.data 1>/dev/null
>> 54.60user 337.20system 48:42.71elapsed 13%CPU (0avgtext+0avgdata 105632maxresident)k
>> 0inputs+0outputs (1major+72981minor)pagefaults 0swaps
>>
>> # xfs_db -c frag -f /dev/sdb1
>> actual 37998306, ideal 37939331, fragmentation factor 0.16%
>>
>> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=2441379328, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0


How much would it help, if any, with this specific 'test', or with 
overall XFS performance, if Justin were to...

>> Host 1: RAID-6 (7200 RPM Drives, 18+1 hot spare)

remake the fs on the above device with 'sw=16' or remount with 
appropriate sunit and swidth values?

>> Host 2: RAID-6 (7200 RPM Drives, 12)

remake the fs on the above device with 'sw=10' or remount with 
appropriate sunit and swidth values?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
