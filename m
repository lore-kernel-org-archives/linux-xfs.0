Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1D3E7F51
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 20:38:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B4118F8033
	for <xfs@oss.sgi.com>; Sat, 21 Dec 2013 18:38:30 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [147.172.2.110]) by
	cuda.sgi.com with ESMTP id cAd9Dd5kwWUUG98z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Dec 2013 18:38:27 -0800 (PST)
Received: from 77-22-27-29-dynip.superkabel.de ([77.22.27.29]
	helo=[192.168.178.40])
	by mail.pzystorm.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76) (envelope-from <xfs@pzystorm.de>)
	id 1VuYvw-0005Bn-12; Sun, 22 Dec 2013 03:38:24 +0100
Message-ID: <52B6500D.3050800@pzystorm.de>
Date: Sun, 22 Dec 2013 03:35:57 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de>
	<52B118A9.8080905@hardwarefreak.com>	<52B178AA.6040302@pzystorm.de>
	<52B2FE9E.50307@hardwarefreak.com> <52B41B67.9030308@pzystorm.de>
	<52B439D1.3020205@hardwarefreak.com>
In-Reply-To: <52B439D1.3020205@hardwarefreak.com>
Reply-To: xfs@pzystorm.de
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
To: stan@hardwarefreak.com, xfs@oss.sgi.com

Okay, well, I've run your fio config... but with so many results and
abbrevations I currently feel a bit overchallenged :)
So, please dont take badly, if I just paste the whole results.
I have tried with a stripe cache size of 1024, 2048 and 4096.

Btw, I also have /dev/md1, this is a 15GB unencrypted array using the
same 5 disks like my LUKS-md2 array, so nearly the same just without
this LUKS layer. If helpful, I can execute some fio tests on this
filesystem, too.


So long :)
Kevin


$ echo 1024 > /sys/block/md2/md/stripe_cache_size
> Jobs: 1 (f=1): [____________W___] [99.7% done] [0K/99.24M /s] [0 /193  iops] [eta 00m:06s]
> read: (groupid=0, jobs=8): err= 0: pid=12987
>   read : io=81920MB, bw=189835KB/s, iops=370 , runt=441890msec
>     slat (usec): min=32 , max=4561 , avg=76.28, stdev=28.66
>     clat (msec): min=5 , max=1115 , avg=334.19, stdev=151.18
>      lat (msec): min=5 , max=1115 , avg=334.26, stdev=151.18
>     bw (KB/s) : min=    0, max=261120, per=12.79%, avg=24288.95, stdev=11586.29
>   cpu          : usr=0.05%, sys=0.50%, ctx=157180, majf=0, minf=16982
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=163840/0/0, short=0/0/0
> 
>      lat (msec): 10=0.52%, 20=0.71%, 50=3.01%, 100=6.17%, 250=14.59%
>      lat (msec): 500=68.81%, 750=4.87%, 1000=1.08%, 2000=0.25%
> write: (groupid=1, jobs=8): err= 0: pid=13202
>   write: io=81920MB, bw=58504KB/s, iops=114 , runt=1433851msec
>     slat (usec): min=45 , max=1729 , avg=212.20, stdev=56.68
>     clat (msec): min=14 , max=11691 , avg=1101.17, stdev=1116.82
>      lat (msec): min=14 , max=11691 , avg=1101.39, stdev=1116.82
>     bw (KB/s) : min=    0, max=106666, per=14.35%, avg=8395.94, stdev=6752.35
>   cpu          : usr=0.28%, sys=0.10%, ctx=117451, majf=0, minf=3410
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/163840/0, short=0/0/0
> 
>      lat (msec): 20=0.01%, 50=0.17%, 100=2.03%, 250=17.02%, 500=22.20%
>      lat (msec): 750=12.22%, 1000=8.66%, 2000=20.04%, >=2000=17.64%
> 
> Run status group 0 (all jobs):
>    READ: io=81920MB, aggrb=189834KB/s, minb=194390KB/s, maxb=194390KB/s, mint=441890msec, maxt=441890msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=81920MB, aggrb=58504KB/s, minb=59908KB/s, maxb=59908KB/s, mint=1433851msec, maxt=1433851msec
> 
> Disk stats (read/write):
>   dm-0: ios=327681/327756, merge=0/0, ticks=78591352/353235376, in_queue=431834680, util=100.00%, aggrios=327681/327922, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>     md2: ios=327681/327922, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=171660/222845, aggrmerge=4561629/9494657, aggrticks=16341417/4008187, aggrin_queue=20351472, aggrutil=85.78%
>     sdc: ios=181512/222455, merge=4583055/9505634, ticks=15650600/5944080, in_queue=21596560, util=85.78%
>     sdd: ios=180545/224362, merge=4526197/9587956, ticks=14356708/5542120, in_queue=19900820, util=85.42%
>     sde: ios=179853/224317, merge=4519718/9540999, ticks=13375156/5676828, in_queue=19053876, util=83.90%
>     sdf: ios=157605/222569, merge=4551205/9459549, ticks=18828608/1234632, in_queue=20065204, util=75.36%
>     sdg: ios=158787/220525, merge=4627970/9379150, ticks=19496016/1643276, in_queue=21140904, util=77.26%

$ echo 2048 > /sys/block/md2/md/stripe_cache_size
> Jobs: 1 (f=1): [_________W______] [99.6% done] [0K/92182K /s] [0 /175  iops] [eta 00m:06s]
> read: (groupid=0, jobs=8): err= 0: pid=6392
>   read : io=81920MB, bw=185893KB/s, iops=363 , runt=451259msec
>     slat (usec): min=32 , max=524 , avg=75.08, stdev=26.00
>     clat (msec): min=8 , max=1849 , avg=335.65, stdev=149.76
>      lat (msec): min=8 , max=1849 , avg=335.72, stdev=149.76
>     bw (KB/s) : min=    0, max=105860, per=13.08%, avg=24308.99, stdev=7467.64
>   cpu          : usr=0.05%, sys=0.49%, ctx=157968, majf=0, minf=17171
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=163840/0/0, short=0/0/0
> 
>      lat (msec): 10=0.01%, 20=0.06%, 50=2.32%, 100=7.44%, 250=15.36%
>      lat (msec): 500=69.09%, 750=4.50%, 1000=0.87%, 2000=0.35%
> write: (groupid=1, jobs=8): err= 0: pid=6663
>   write: io=81920MB, bw=75377KB/s, iops=147 , runt=1112887msec
>     slat (usec): min=46 , max=6453.8K, avg=988.13, stdev=46664.22
>     clat (msec): min=10 , max=8631 , avg=854.18, stdev=683.37
>      lat (msec): min=10 , max=8631 , avg=855.17, stdev=684.82
>     bw (KB/s) : min=    0, max=100352, per=14.04%, avg=10581.97, stdev=6871.80
>   cpu          : usr=0.34%, sys=0.11%, ctx=92502, majf=0, minf=1531
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/163840/0, short=0/0/0
> 
>      lat (msec): 20=0.01%, 50=0.09%, 100=1.14%, 250=11.19%, 500=24.64%
>      lat (msec): 750=18.78%, 1000=13.40%, 2000=24.53%, >=2000=6.23%
> 
> Run status group 0 (all jobs):
>    READ: io=81920MB, aggrb=185893KB/s, minb=190354KB/s, maxb=190354KB/s, mint=451259msec, maxt=451259msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=81920MB, aggrb=75376KB/s, minb=77186KB/s, maxb=77186KB/s, mint=1112887msec, maxt=1112887msec
> 
> Disk stats (read/write):
>   dm-0: ios=327701/328169, merge=0/0, ticks=79402348/261890568, in_queue=341301888, util=100.00%, aggrios=327701/328481, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>     md2: ios=327701/328481, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=127112/146994, aggrmerge=3364061/7997232, aggrticks=18091347/5817941, aggrin_queue=23914356, aggrutil=94.20%
>     sdc: ios=135729/149357, merge=3341205/8134447, ticks=18312932/8398716, in_queue=26721324, util=92.77%
>     sdd: ios=135561/151584, merge=3312121/8238249, ticks=16877204/8190968, in_queue=25077332, util=92.44%
>     sde: ios=135741/146023, merge=3345948/7981968, ticks=17659792/8659780, in_queue=26322124, util=94.20%
>     sdf: ios=114396/143768, merge=3413295/7801050, ticks=18551976/1652924, in_queue=20207384, util=72.89%
>     sdg: ios=114134/144241, merge=3407738/7830447, ticks=19054832/2187320, in_queue=21243620, util=74.96%

$ echo 4096 > /sys/block/md2/md/stripe_cache_size
> Jobs: 1 (f=1): [________W_______] [100.0% done] [0K/95848K /s] [0 /182  iops] [eta 00m:00s]
> read: (groupid=0, jobs=8): err= 0: pid=11787
>   read : io=81920MB, bw=189274KB/s, iops=369 , runt=443200msec
>     slat (usec): min=31 , max=4511 , avg=75.47, stdev=29.74
>     clat (msec): min=5 , max=1338 , avg=336.39, stdev=155.14
>      lat (msec): min=5 , max=1338 , avg=336.47, stdev=155.14
>     bw (KB/s) : min=    0, max=253455, per=12.77%, avg=24162.01, stdev=11368.71
>   cpu          : usr=0.05%, sys=0.49%, ctx=157193, majf=0, minf=17313
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=163840/0/0, short=0/0/0
> 
>      lat (msec): 10=0.47%, 20=0.66%, 50=2.95%, 100=6.33%, 250=14.56%
>      lat (msec): 500=68.12%, 750=5.42%, 1000=1.15%, 2000=0.33%
> write: (groupid=1, jobs=8): err= 0: pid=12060
>   write: io=81920MB, bw=64993KB/s, iops=126 , runt=1290687msec
>     slat (usec): min=61 , max=16991 , avg=197.22, stdev=110.87
>     clat (msec): min=14 , max=2820 , avg=980.92, stdev=366.56
>      lat (msec): min=14 , max=2821 , avg=981.12, stdev=366.56
>     bw (KB/s) : min=    0, max=103770, per=13.11%, avg=8517.92, stdev=3794.28
>   cpu          : usr=0.28%, sys=0.08%, ctx=84352, majf=0, minf=723
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/163840/0, short=0/0/0
> 
>      lat (msec): 20=0.01%, 50=0.03%, 100=0.28%, 250=0.22%, 500=5.37%
>      lat (msec): 750=22.02%, 1000=31.66%, 2000=39.27%, >=2000=1.16%
> 
> Run status group 0 (all jobs):
>    READ: io=81920MB, aggrb=189273KB/s, minb=193816KB/s, maxb=193816KB/s, mint=443200msec, maxt=443200msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=81920MB, aggrb=64993KB/s, minb=66553KB/s, maxb=66553KB/s, mint=1290687msec, maxt=1290687msec
> 
> Disk stats (read/write):
>   dm-0: ios=327681/327629, merge=0/0, ticks=78990724/301988444, in_queue=380991692, util=100.00%, aggrios=327681/327709, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>     md2: ios=327681/327709, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=120158/119573, aggrmerge=2858405/7663126, aggrticks=17291831/9119008, aggrin_queue=26414023, aggrutil=99.60%
>     sdc: ios=135579/119976, merge=2813832/7324879, ticks=13974928/2192484, in_queue=16167996, util=66.57%
>     sdd: ios=136115/127048, merge=2826584/7736191, ticks=12932248/2477796, in_queue=15410924, util=68.08%
>     sde: ios=136007/130908, merge=2844473/7936354, ticks=12642232/3141268, in_queue=15784336, util=71.86%
>     sdf: ios=78473/94458, merge=2882361/7865984, ticks=29053772/37421808, in_queue=66488856, util=99.60%
>     sdg: ios=114620/125479, merge=2924777/7452224, ticks=17855976/361684, in_queue=18218004, util=54.84%





Am 20.12.2013 13:36, schrieb Stan Hoeppner:
> On 12/20/2013 4:26 AM, Kevin Richter wrote:
>> Thanks a lot for your huge replies!
> 
> You're welcome.
> 
>>> Oh, that's quite old. I'd suggest upgrading to a much more recent
>>> kernel as we've fixed lots of issues in this area since then.
>>
>> First I have switched to the newer kernel from Ubuntu Saucy:
>> $ uname -a
>> Linux 3.11.0-14-generic #21~precise1-Ubuntu SMP
>>
>> Thus, it seems that the default scheduler has been changed to deadline.
>> I did not change anything. After a reboot the schedulers of all disks
>> are now deadline.
> 
> Good move Ubuntu.
> 
>>> Model # of the CPUs so I can look up the specs?
>> Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz
> 
> Strong CPUs.
> 
>> I have prepared a folder with 60GB for the tests. This is nearly twice
>> of the available memory, so the process should be forced to actually
>> write the stuff to the disk - and not only hold in the memory.
>>
>>> $ echo 256 > /sys/block/md2/md/stripe_cache_size
>>> $ time cp -a /olddisk/testfolder /6tb/foo1/
>>> real    25m38.925s
>>> user    0m0.595s
>>> sys     1m23.182s
>>>
>>> $ echo 1024 > /sys/block/md2/md/stripe_cache_size
>>> $ time cp -a /olddisk/testfolder /raid/foo2/
>>> real    7m32.824s
>>> user    0m0.438s
>>> sys     1m6.759s
>>>
>>> $ echo 2048 > /sys/block/md2/md/stripe_cache_size
>>> $ time cp -a /olddisk/testfolder /raid/foo3/
>>> real    5m32.847s
>>> user    0m0.418s
>>> sys     1m5.671s
>>>
>>> $ echo 4096 > /sys/block/md2/md/stripe_cache_size
>>> $ time cp -a /olddisk/testfolder /raid/foo4/
>>> real    5m54.554s
>>> user    0m0.437s
>>> sys     1m6.268s
>>
>> The difference is really amazing! So 2048 seems to be the best choice.
>> 60GB in 5,5minutes are 180MB/sek. That sounds a bit high, doesnt it?
>> The RAID only consist of 5 SATA disks with 7200rpm.
> 
> A lot of the source data is being cached between runs so these numbers
> aren't accurate.  The throughput of this copy operation will be limited
> by the speed of the single source disk, not the array.  To make the
> elapsed times of this copy test accurate you need to execute something
> like these commands after each run:
> 
> # sync
> # echo 3 > /proc/sys/vm/drop_caches
> 
> But this copy test will not inform you about the potential peak
> performance of your array.  That's why I suggested you test with FIO,
> the flexible IO tester.
> 
> # aptitude install fio
> # man fio
> 
> Sample job file suitable for your system:
> 
> [global]
> directory=/your/XFS/test/directory
> zero_buffers
> numjobs=8
> group_reporting
> blocksize=512k
> ioengine=libaio
> iodepth=16
> direct=1
> size=10g
> 
> [read]
> rw=read
> stonewall
> 
> [write]
> rw=write
> stonewall
> 
> This should give you a relatively accurate picture of the actual
> potential throughput of your array and filesystem.
> 
>> 'top' while copying with stripe size of 2048 (the source disk is ntfs):
>>> top - 10:48:24 up 1 day,  1:41,  2 users,  load average: 5.66, 3.53, 2.17
>>> Tasks: 210 total,   2 running, 208 sleeping,   0 stopped,   0 zombie
>>> Cpu(s):  0.1%us, 35.8%sy,  0.0%ni, 46.0%id, 17.9%wa,  0.0%hi,  0.2%si,  0.0%st
>>> Mem:  32913992k total, 32709208k used,   204784k free, 10770344k buffers
>>> Swap:  7812496k total,        0k used,  7812496k free, 20866844k cached
>>>
>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>> 19524 root      20   0     0    0    0 R   93  0.0   4:00.12 kworker/3:1
>>> 23744 root      20   0     0    0    0 S   55  0.0   0:50.84 kworker/0:1
>>> 23738 root      20   0     0    0    0 S   29  0.0   0:56.94 kworker/4:0
>>>  3893 root      20   0     0    0    0 S   28  0.0  36:47.50 md2_raid6
>>>  4551 root      20   0 22060 3328  720 D   25  0.0  20:21.61 mount.ntfs
>>> 23273 root      20   0     0    0    0 S   22  0.0   1:54.86 kworker/7:2
>>> 23734 root      20   0 21752 1280 1040 D   21  0.0   0:49.84 cp
>>>    84 root      20   0     0    0    0 S    7  0.0   8:19.34 kswapd1
>>>    83 root      20   0     0    0    0 S    6  0.0  11:55.81 kswapd0
>>> 23745 root      20   0     0    0    0 S    2  0.0   0:33.60 kworker/1:2
>>> 21598 root      20   0     0    0    0 D    1  0.0   0:11.33 kworker/u17:1
> 
> Hmm, what's kworker/3:1?  That's not a crypto thread eating 93% of a
> SandyBridge core at only ~180 MB/s throughput is it?
> 
>> And the best thing at all:
>> While all of these tests there are no warnings/panics in the syslog.
>>
>> With best regards,
>> Kevin
> 
> Even though XFS wasn't the cause of the problem I'm glad we were able to
> help you fix it nonetheless.  I'm really curious to see what kind of
> throughput you can achieve with FIO, and whether crypto is a bottleneck
> at the 250-350 MB/s your array should be capable of.  It would be great
> if you would play around a bit with FIO and post some numbers.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
