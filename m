Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27C7A7F60
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 08:13:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFAA5AC006
	for <xfs@oss.sgi.com>; Sun, 22 Dec 2013 06:13:29 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [147.172.2.110]) by
	cuda.sgi.com with ESMTP id QIyxspe3oqaw8Npv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Dec 2013 06:13:23 -0800 (PST)
Received: from 77-22-27-29-dynip.superkabel.de ([77.22.27.29]
	helo=[192.168.178.40])
	by mail.pzystorm.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76) (envelope-from <xfs@pzystorm.de>)
	id 1VujmQ-0007ey-NQ; Sun, 22 Dec 2013 15:13:18 +0100
Message-ID: <52B6F2ED.2010609@pzystorm.de>
Date: Sun, 22 Dec 2013 15:10:53 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de>	<52B118A9.8080905@hardwarefreak.com>	<52B178AA.6040302@pzystorm.de>	<52B2FE9E.50307@hardwarefreak.com>
	<52B41B67.9030308@pzystorm.de>	<52B439D1.3020205@hardwarefreak.com>
	<52B6500D.3050800@pzystorm.de> <52B69EF5.2060903@hardwarefreak.com>
In-Reply-To: <52B69EF5.2060903@hardwarefreak.com>
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

> I'm glad you changed to size=1G instead of size=10G
No no, I didnt change that. It has been written 160GB on these disks. 80
for the read part, 80 for the write part. Each test took round 30 minutes.

> This is also a RAID6 array, without dm-crypt?
Yeah, right. The same 5 disks in RAID6 mode, just in each case another
partition on these disks. And yes, of course, XFS.

So, with your new config I have made 7 fio runs:
1) 15GB RAID6 array, stripe 256
2) 15GB RAID6 array, stripe 1024
3) 15GB RAID6 array, stripe 2048
4) 15GB RAID6 array, stripe 4096
5) 3TB LUKS volume (no raid, just one single disk)
6) 6TB RAID6+LUKS array, stripe 256
7) 6TB RAID6+LUKS array, stripe 2048

In the 15GB array a stripe size of 4096 seems to get slightly more
throughput than 2048.

See below for the results :-)

Perhaps, I should give you another information about the server
hardware, which might (but hopefully do not) explain the low performance:
The server is that one:
http://www.supermicro.com/products/system/2u/6027/ssg-6027r-e1r12l.cfm
with a 12-port SAS expander, which is that one:
http://www.thomas-krenn.com/de/wiki/BPN-SAS-826EL1_SAS_Expander_Backplane
But the backplane should have a thoughput of 3Gb/s

However... I am very curious about your comments :-)

Bye,
Kevin


#################################
1) 15GB RAID6 volume, stripe 256:
> read: (groupid=0, jobs=4): err= 0: pid=3959
>   read : io=4092.0MB, bw=217900KB/s, iops=141 , runt= 19230msec
>     slat (usec): min=190 , max=1325 , avg=231.32, stdev=77.13
>     clat (msec): min=7 , max=326 , avg=111.45, stdev=67.48
>      lat (msec): min=7 , max=326 , avg=111.69, stdev=67.48
>     bw (KB/s) : min=29425, max=109280, per=24.98%, avg=54423.27, stdev=15887.11
>   cpu          : usr=0.03%, sys=0.90%, ctx=2614, majf=0, minf=6233
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 10=0.66%, 20=4.84%, 50=16.35%, 100=25.70%, 250=47.91%
>      lat (msec): 500=4.55%
> write: (groupid=1, jobs=4): err= 0: pid=3964
>   write: io=4092.0MB, bw=54044KB/s, iops=35 , runt= 77533msec
>     slat (msec): min=9 , max=339 , avg=113.48, stdev=36.86
>     clat (msec): min=2 , max=744 , avg=339.51, stdev=70.02
>      lat (msec): min=23 , max=927 , avg=453.00, stdev=82.81
>     bw (KB/s) : min= 5475, max=20756, per=24.92%, avg=13467.27, stdev=2107.66
>   cpu          : usr=0.58%, sys=6.26%, ctx=343060, majf=0, minf=550
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 4=0.04%, 10=0.04%, 50=0.11%, 100=0.26%, 250=5.94%
>      lat (msec): 500=91.50%, 750=2.13%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=217899KB/s, minb=223129KB/s, maxb=223129KB/s, mint=19230msec, maxt=19230msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=54044KB/s, minb=55341KB/s, maxb=55341KB/s, mint=77533msec, maxt=77533msec
> 
> Disk stats (read/write):
>   md1: ios=10912/10904, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=22836/29872, aggrmerge=364645/574313, aggrticks=216408/101340, aggrin_queue=317789, aggrutil=69.36%
>     sdc: ios=23542/29233, merge=377270/563331, ticks=217520/152300, in_queue=369860, util=67.99%
>     sdd: ios=23462/28930, merge=378915/557686, ticks=214104/142224, in_queue=356428, util=67.81%
>     sde: ios=22264/29920, merge=355831/576114, ticks=149184/99724, in_queue=248924, util=58.22%
>     sdf: ios=22240/30724, merge=352471/588412, ticks=126740/52916, in_queue=179696, util=55.44%
>     sdg: ios=22676/30557, merge=358741/586025, ticks=374496/59540, in_queue=434040, util=69.36%

#################################
2) 15GB RAID6 array, stripe 1024:
> read: (groupid=0, jobs=4): err= 0: pid=4334
>   read : io=4092.0MB, bw=237702KB/s, iops=154 , runt= 17628msec
>     slat (usec): min=196 , max=1469 , avg=232.84, stdev=88.56
>     clat (msec): min=6 , max=391 , avg=101.62, stdev=56.61
>      lat (msec): min=7 , max=391 , avg=101.85, stdev=56.61
>     bw (KB/s) : min=26482, max=107305, per=24.94%, avg=59289.94, stdev=14153.87
>   cpu          : usr=0.04%, sys=0.98%, ctx=2581, majf=0, minf=6241
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 10=0.22%, 20=3.08%, 50=16.83%, 100=31.01%, 250=47.10%
>      lat (msec): 500=1.76%
> write: (groupid=1, jobs=4): err= 0: pid=4340
>   write: io=4092.0MB, bw=120759KB/s, iops=78 , runt= 34699msec
>     slat (msec): min=1 , max=156 , avg=47.70, stdev=27.94
>     clat (msec): min=15 , max=520 , avg=152.37, stdev=53.34
>      lat (msec): min=28 , max=564 , avg=200.07, stdev=57.63
>     bw (KB/s) : min=    0, max=62270, per=25.04%, avg=30239.54, stdev=5435.51
>   cpu          : usr=1.34%, sys=5.68%, ctx=134184, majf=0, minf=94
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 20=0.04%, 50=1.10%, 100=12.02%, 250=82.18%, 500=4.62%
>      lat (msec): 750=0.04%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=237701KB/s, minb=243406KB/s, maxb=243406KB/s, mint=17628msec, maxt=17628msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=120758KB/s, minb=123656KB/s, maxb=123656KB/s, mint=34699msec, maxt=34699msec
> 
> Disk stats (read/write):
>   md1: ios=10912/10901, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=4062/6768, aggrmerge=109645/369712, aggrticks=157952/111924, aggrin_queue=270487, aggrutil=89.91%
>     sdc: ios=4070/6893, merge=109432/378682, ticks=173784/179392, in_queue=353780, util=89.88%
>     sdd: ios=4041/6961, merge=110017/380798, ticks=164960/160236, in_queue=325820, util=89.91%
>     sde: ios=4039/6727, merge=110658/366163, ticks=169804/166052, in_queue=336484, util=88.98%
>     sdf: ios=4080/6591, merge=108922/359343, ticks=39460/24636, in_queue=64820, util=52.33%
>     sdg: ios=4081/6668, merge=109197/363574, ticks=241752/29308, in_queue=271532, util=73.63%

#################################
3) 15GB RAID6 array, stripe 2048:
> read: (groupid=0, jobs=4): err= 0: pid=4102
>   read : io=4092.0MB, bw=207827KB/s, iops=135 , runt= 20162msec
>     slat (usec): min=122 , max=3904 , avg=230.75, stdev=99.04
>     clat (msec): min=5 , max=363 , avg=117.03, stdev=70.26
>      lat (msec): min=5 , max=363 , avg=117.27, stdev=70.25
>     bw (KB/s) : min=26533, max=104239, per=25.00%, avg=51947.24, stdev=13121.27
>   cpu          : usr=0.05%, sys=0.83%, ctx=2640, majf=0, minf=6241
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 10=0.55%, 20=4.99%, 50=14.96%, 100=21.33%, 250=53.01%
>      lat (msec): 500=5.17%
> write: (groupid=1, jobs=4): err= 0: pid=4108
>   write: io=4092.0MB, bw=145833KB/s, iops=94 , runt= 28733msec
>     slat (usec): min=768 , max=94184 , avg=1838.20, stdev=4140.24
>     clat (msec): min=15 , max=1155 , avg=145.02, stdev=128.70
>      lat (msec): min=16 , max=1156 , avg=146.86, stdev=128.77
>     bw (KB/s) : min= 6144, max=104448, per=29.22%, avg=42617.70, stdev=17118.84
>   cpu          : usr=1.63%, sys=2.52%, ctx=4086, majf=0, minf=94
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 20=0.37%, 50=9.02%, 100=38.42%, 250=39.22%, 500=10.12%
>      lat (msec): 750=2.09%, 1000=0.59%, 2000=0.18%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=207827KB/s, minb=212814KB/s, maxb=212814KB/s, mint=20162msec, maxt=20162msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=145832KB/s, minb=149332KB/s, maxb=149332KB/s, mint=28733msec, maxt=28733msec
> 
> Disk stats (read/write):
>   md1: ios=10912/10873, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=3018/4990, aggrmerge=79606/371231, aggrticks=152741/83319, aggrin_queue=236284, aggrutil=92.45%
>     sdc: ios=2988/5046, merge=79033/376737, ticks=129600/103552, in_queue=233412, util=84.14%
>     sdd: ios=3010/5140, merge=77101/390954, ticks=119032/103236, in_queue=222536, util=85.87%
>     sde: ios=3039/5009, merge=79935/374563, ticks=196200/159792, in_queue=356236, util=92.45%
>     sdf: ios=3021/4883, merge=80483/356643, ticks=29976/24956, in_queue=55100, util=49.53%
>     sdg: ios=3033/4872, merge=81481/357261, ticks=288900/25060, in_queue=314136, util=76.17%

#################################
4) 15GB RAID6 array, stripe 4096:
> read: (groupid=0, jobs=4): err= 0: pid=4411
>   read : io=4092.0MB, bw=214938KB/s, iops=139 , runt= 19495msec
>     slat (usec): min=192 , max=1468 , avg=226.97, stdev=87.18
>     clat (msec): min=4 , max=339 , avg=112.51, stdev=63.05
>      lat (msec): min=4 , max=339 , avg=112.73, stdev=63.05
>     bw (KB/s) : min=    0, max=96000, per=24.87%, avg=53457.49, stdev=13728.88
>   cpu          : usr=0.02%, sys=0.89%, ctx=2591, majf=0, minf=6241
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 10=0.15%, 20=4.62%, 50=13.56%, 100=26.43%, 250=52.20%
>      lat (msec): 500=3.04%
> write: (groupid=1, jobs=4): err= 0: pid=4419
>   write: io=4092.0MB, bw=146526KB/s, iops=95 , runt= 28597msec
>     slat (usec): min=822 , max=36057 , avg=1585.60, stdev=1174.08
>     clat (msec): min=14 , max=1132 , avg=142.49, stdev=126.05
>      lat (msec): min=15 , max=1134 , avg=144.08, stdev=126.08
>     bw (KB/s) : min=    0, max=83836, per=28.88%, avg=42315.69, stdev=18036.84
>   cpu          : usr=1.42%, sys=2.85%, ctx=2937, majf=0, minf=94
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 20=0.18%, 50=10.08%, 100=37.61%, 250=40.62%, 500=8.50%
>      lat (msec): 750=2.46%, 1000=0.44%, 2000=0.11%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=214937KB/s, minb=220096KB/s, maxb=220096KB/s, mint=19495msec, maxt=19495msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=146526KB/s, minb=150042KB/s, maxb=150042KB/s, mint=28597msec, maxt=28597msec
> 
> Disk stats (read/write):
>   md1: ios=10912/10895, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=3013/5053, aggrmerge=78083/371841, aggrticks=151707/88554, aggrin_queue=240554, aggrutil=92.72%
>     sdc: ios=2981/5124, merge=77153/379556, ticks=142800/116248, in_queue=259356, util=87.13%
>     sdd: ios=2990/5182, merge=75443/390196, ticks=128184/107752, in_queue=236264, util=86.87%
>     sde: ios=3034/5057, merge=77882/372755, ticks=185048/159352, in_queue=344636, util=92.72%
>     sdf: ios=3035/4941, merge=79423/356692, ticks=29196/28100, in_queue=57520, util=50.56%
>     sdg: ios=3026/4963, merge=80518/360009, ticks=273308/31320, in_queue=304996, util=76.24%

###################################################
5) 3TB LUKS volume (no raid, just one single disk):
> read: (groupid=0, jobs=4): err= 0: pid=31359
>   read : io=4092.0MB, bw=125032KB/s, iops=81 , runt= 33513msec
>     slat (usec): min=86 , max=1404 , avg=125.10, stdev=97.21
>     clat (msec): min=26 , max=323 , avg=195.52, stdev=39.04
>      lat (msec): min=26 , max=323 , avg=195.65, stdev=39.03
>     bw (KB/s) : min=21982, max=41890, per=25.12%, avg=31405.62, stdev=3662.77
>   cpu          : usr=0.02%, sys=0.31%, ctx=2738, majf=0, minf=6233
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 50=0.51%, 100=2.38%, 250=93.07%, 500=4.03%
> write: (groupid=1, jobs=4): err= 0: pid=31364
>   write: io=4092.0MB, bw=158193KB/s, iops=102 , runt= 26488msec
>     slat (usec): min=181 , max=673 , avg=442.78, stdev=67.26
>     clat (msec): min=21 , max=555 , avg=154.33, stdev=45.35
>      lat (msec): min=21 , max=555 , avg=154.77, stdev=45.35
>     bw (KB/s) : min=19097, max=45988, per=25.04%, avg=39617.62, stdev=5714.79
>   cpu          : usr=1.00%, sys=0.25%, ctx=2737, majf=0, minf=86
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 50=0.44%, 100=1.54%, 250=94.61%, 500=3.15%, 750=0.26%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=125032KB/s, minb=128033KB/s, maxb=128033KB/s, mint=33513msec, maxt=33513msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=158192KB/s, minb=161989KB/s, maxb=161989KB/s, mint=26488msec, maxt=26488msec
> 
> Disk stats (read/write):
>   dm-1: ios=8184/8196, merge=0/0, ticks=1521200/1235264, in_queue=2759104, util=99.58%, aggrios=8184/8225, aggrmerge=0/31, aggrticks=1421660/1137984, aggrin_queue=2559612, aggrutil=99.49%
>     sda: ios=8184/8225, merge=0/31, ticks=1421660/1137984, in_queue=2559612, util=99.49%

##############################
6) 6TB LUKS array, stripe 256:
> read: (groupid=0, jobs=4): err= 0: pid=31121
>   read : io=4092.0MB, bw=137700KB/s, iops=89 , runt= 30430msec
>     slat (usec): min=123 , max=1353 , avg=157.35, stdev=91.53
>     clat (msec): min=15 , max=545 , avg=148.80, stdev=61.30
>      lat (msec): min=15 , max=545 , avg=148.96, stdev=61.29
>     bw (KB/s) : min=    0, max=129024, per=29.75%, avg=40959.72, stdev=21470.47
>   cpu          : usr=0.01%, sys=0.51%, ctx=2797, majf=0, minf=6241
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 20=0.29%, 50=9.90%, 100=12.76%, 250=75.07%, 500=1.58%
>      lat (msec): 750=0.40%
> write: (groupid=1, jobs=4): err= 0: pid=31131
>   write: io=4092.0MB, bw=41225KB/s, iops=26 , runt=101643msec
>     slat (usec): min=197 , max=1309 , avg=557.69, stdev=124.14
>     clat (msec): min=42 , max=2648 , avg=586.07, stdev=393.18
>      lat (msec): min=43 , max=2649 , avg=586.63, stdev=393.19
>     bw (KB/s) : min=    0, max=35583, per=26.36%, avg=10867.00, stdev=5232.75
>   cpu          : usr=0.33%, sys=0.09%, ctx=2699, majf=0, minf=94
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 50=0.07%, 100=1.39%, 250=18.55%, 500=31.82%, 750=20.49%
>      lat (msec): 1000=12.57%, 2000=14.66%, >=2000=0.44%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=137699KB/s, minb=141004KB/s, maxb=141004KB/s, mint=30430msec, maxt=30430msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=41224KB/s, minb=42214KB/s, maxb=42214KB/s, mint=101643msec, maxt=101643msec
> 
> Disk stats (read/write):
>   dm-0: ios=10912/10906, merge=0/0, ticks=1385524/5596828, in_queue=6983364, util=99.89%, aggrios=10912/10940, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>     md2: ios=10912/10940, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=20710/27494, aggrmerge=358521/573067, aggrticks=208334/119186, aggrin_queue=327551, aggrutil=61.95%
>     sdc: ios=21005/27276, merge=366645/567533, ticks=224772/179916, in_queue=404728, util=61.95%
>     sdd: ios=21154/26926, merge=369215/564213, ticks=212876/160624, in_queue=373552, util=60.42%
>     sde: ios=20460/27449, merge=354440/571659, ticks=127008/102188, in_queue=229220, util=48.28%
>     sdf: ios=20464/27908, merge=350591/581422, ticks=241608/78180, in_queue=319784, util=55.24%
>     sdg: ios=20470/27915, merge=351718/580509, ticks=235408/75024, in_queue=310472, util=55.91%

###############################
7) 6TB LUKS array, stripe 2048:
> read: (groupid=0, jobs=4): err= 0: pid=30910
>   read : io=4092.0MB, bw=237500KB/s, iops=154 , runt= 17643msec
>     slat (usec): min=134 , max=1511 , avg=165.25, stdev=96.45
>     clat (msec): min=16 , max=859 , avg=101.07, stdev=61.40
>      lat (msec): min=17 , max=859 , avg=101.23, stdev=61.40
>     bw (KB/s) : min=32807, max=97523, per=25.40%, avg=60325.02, stdev=15396.63
>   cpu          : usr=0.02%, sys=0.76%, ctx=2709, majf=0, minf=6233
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=2728/0/0, short=0/0/0
> 
>      lat (msec): 20=0.07%, 50=13.38%, 100=48.90%, 250=34.38%, 500=3.08%
>      lat (msec): 750=0.15%, 1000=0.04%
> write: (groupid=1, jobs=4): err= 0: pid=30915
>   write: io=4092.0MB, bw=90652KB/s, iops=59 , runt= 46223msec
>     slat (usec): min=173 , max=983 , avg=599.60, stdev=141.06
>     clat (msec): min=34 , max=1185 , avg=258.48, stdev=135.97
>      lat (msec): min=34 , max=1185 , avg=259.08, stdev=135.98
>     bw (KB/s) : min=    0, max=88722, per=25.95%, avg=23524.06, stdev=9036.31
>   cpu          : usr=0.77%, sys=0.22%, ctx=2576, majf=0, minf=86
>   IO depths    : 1=0.1%, 2=0.3%, 4=99.6%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=0/2728/0, short=0/0/0
> 
>      lat (msec): 50=0.48%, 100=7.00%, 250=49.01%, 500=37.72%, 750=5.10%
>      lat (msec): 1000=0.59%, 2000=0.11%
> 
> Run status group 0 (all jobs):
>    READ: io=4092.0MB, aggrb=237499KB/s, minb=243199KB/s, maxb=243199KB/s, mint=17643msec, maxt=17643msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4092.0MB, aggrb=90652KB/s, minb=92827KB/s, maxb=92827KB/s, mint=46223msec, maxt=46223msec
> 
> Disk stats (read/write):
>   dm-0: ios=10912/10875, merge=0/0, ticks=544880/2481824, in_queue=3026996, util=99.57%, aggrios=10912/10930, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>     md2: ios=10912/10930, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=5058/6798, aggrmerge=153871/404343, aggrticks=195870/113487, aggrin_queue=309447, aggrutil=92.15%
>     sdc: ios=5024/7100, merge=152571/421782, ticks=332612/204936, in_queue=537660, util=92.15%
>     sdd: ios=4961/7109, merge=150591/422166, ticks=257308/161200, in_queue=418608, util=88.11%
>     sde: ios=5019/6697, merge=154781/395583, ticks=226120/152068, in_queue=378296, util=85.49%
>     sdf: ios=5118/6463, merge=156068/385905, ticks=65716/23932, in_queue=89724, util=55.85%
>     sdg: ios=5172/6624, merge=155347/396280, ticks=97596/25300, in_queue=122948, util=60.00%





Am 22.12.2013 09:12, schrieb Stan Hoeppner:
> On 12/21/2013 8:35 PM, Kevin Richter wrote:
>> Okay, well, I've run your fio config... but with so many results and
> 
> I'm glad you changed to size=1G instead of size=10G lest the test would
> have read/written 80GB instead of 8GB, and taken forever.  I often
> forget the size parameter is per job (thread) not global.
> 
>> abbrevations I currently feel a bit overchallenged :)
>> So, please dont take badly, if I just paste the whole results.
>> I have tried with a stripe cache size of 1024, 2048 and 4096.
> 
> The full output is good.  Going from 1024 to 2048 gained you ~17MB/s
> throughput with this job file.  But you didn't run with the default 256
> for comparison, which is very useful to know.  That's ok, as you can do
> so with the next set of test runs.  Given the huge latencies I'm
> thinking this config may be seeking the disks too much.  Modify your fio
> job file as follows:
> 
> numjobs=4
> blocksize=1536k
> iodepth=4
> size=1g
> 
> as this may yield a little better results.  ~190MB/s read and 75MB/s
> write is very low for three effective 7.2K RPM SATA spindles, especially
> the write throughput.  Compare to a similar FIO job with 2 threads,
> iodepth 16, directio, run against a single 500GB 7.2K WD SATA drive, NQC
> disabled, w/deadline elevator:
> 
> Run status group 0 (all jobs):
>    READ: io=2048MB, aggrb=88663KB/s, minb=90791KB/s, maxb=90791KB/s
> Run status group 1 (all jobs):
>   WRITE: io=2048MB, aggrb=108089KB/s, minb=110683KB/s, maxb=110683KB/s
> 
> 88MB/s read, 108MB/s write.  Write is faster apparently due to the small
> 16MB drive write cache.  With your eight 2.4GHz SandyBridge cores and
> md-RAID6 on much newer larger 7.2K drives w/larger caches, you should
> have significantly greater write speed than this old single SATA drive.
>  Currently you're showing 30MB/s slower write throughput, some 40%
> slower than this single drive.  With aligned writes, thus no RMW, you
> should be getting at least 2 spindles worth of throughput, or ~200MB/s.
> 
> So, run FIO again with the mods above, once with stripe_cache_size 256
> and once with 2048.  Something seems to be seriously dragging down your
> throughput.  I'm sure you'd like to know what, and how to fix it.
> 
>> Btw, I also have /dev/md1, this is a 15GB unencrypted array using the
>> same 5 disks like my LUKS-md2 array, so nearly the same just without
>> this LUKS layer. If helpful, I can execute some fio tests on this
>> filesystem, too.
> 
> This is also a RAID6 array, without dm-crypt?  If so this will afford a
> great comparison, and may be very informative.  Run FIO against this
> filesystem (I assume it's also XFS) as well with stripe_cache_size 512
> and 2048.  Four FIO tests total including the two on the big array.
> 
> It'll be interesting to see where this leads.  At this point the
> candidates I see are a single dm-crypt thread peaking a core, dm-crypt
> taking aligned writes and misaligning them causing all writes to be
> RMWs, or AF drives with misaligned partitions causing every write to be
> an internal RMW.  Or maybe something I've not considered.
> 
> 
>>
>> So long :)
>> Kevin
>>
>>
>> $ echo 1024 > /sys/block/md2/md/stripe_cache_size
>>> Jobs: 1 (f=1): [____________W___] [99.7% done] [0K/99.24M /s] [0 /193  iops] [eta 00m:06s]
>>> read: (groupid=0, jobs=8): err= 0: pid=12987
>>>   read : io=81920MB, bw=189835KB/s, iops=370 , runt=441890msec
>>>     slat (usec): min=32 , max=4561 , avg=76.28, stdev=28.66
>>>     clat (msec): min=5 , max=1115 , avg=334.19, stdev=151.18
>>>      lat (msec): min=5 , max=1115 , avg=334.26, stdev=151.18
>>>     bw (KB/s) : min=    0, max=261120, per=12.79%, avg=24288.95, stdev=11586.29
>>>   cpu          : usr=0.05%, sys=0.50%, ctx=157180, majf=0, minf=16982
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=163840/0/0, short=0/0/0
>>>
>>>      lat (msec): 10=0.52%, 20=0.71%, 50=3.01%, 100=6.17%, 250=14.59%
>>>      lat (msec): 500=68.81%, 750=4.87%, 1000=1.08%, 2000=0.25%
>>> write: (groupid=1, jobs=8): err= 0: pid=13202
>>>   write: io=81920MB, bw=58504KB/s, iops=114 , runt=1433851msec
>>>     slat (usec): min=45 , max=1729 , avg=212.20, stdev=56.68
>>>     clat (msec): min=14 , max=11691 , avg=1101.17, stdev=1116.82
>>>      lat (msec): min=14 , max=11691 , avg=1101.39, stdev=1116.82
>>>     bw (KB/s) : min=    0, max=106666, per=14.35%, avg=8395.94, stdev=6752.35
>>>   cpu          : usr=0.28%, sys=0.10%, ctx=117451, majf=0, minf=3410
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=0/163840/0, short=0/0/0
>>>
>>>      lat (msec): 20=0.01%, 50=0.17%, 100=2.03%, 250=17.02%, 500=22.20%
>>>      lat (msec): 750=12.22%, 1000=8.66%, 2000=20.04%, >=2000=17.64%
>>>
>>> Run status group 0 (all jobs):
>>>    READ: io=81920MB, aggrb=189834KB/s, minb=194390KB/s, maxb=194390KB/s, mint=441890msec, maxt=441890msec
>>>
>>> Run status group 1 (all jobs):
>>>   WRITE: io=81920MB, aggrb=58504KB/s, minb=59908KB/s, maxb=59908KB/s, mint=1433851msec, maxt=1433851msec
>>>
>>> Disk stats (read/write):
>>>   dm-0: ios=327681/327756, merge=0/0, ticks=78591352/353235376, in_queue=431834680, util=100.00%, aggrios=327681/327922, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>>     md2: ios=327681/327922, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=171660/222845, aggrmerge=4561629/9494657, aggrticks=16341417/4008187, aggrin_queue=20351472, aggrutil=85.78%
>>>     sdc: ios=181512/222455, merge=4583055/9505634, ticks=15650600/5944080, in_queue=21596560, util=85.78%
>>>     sdd: ios=180545/224362, merge=4526197/9587956, ticks=14356708/5542120, in_queue=19900820, util=85.42%
>>>     sde: ios=179853/224317, merge=4519718/9540999, ticks=13375156/5676828, in_queue=19053876, util=83.90%
>>>     sdf: ios=157605/222569, merge=4551205/9459549, ticks=18828608/1234632, in_queue=20065204, util=75.36%
>>>     sdg: ios=158787/220525, merge=4627970/9379150, ticks=19496016/1643276, in_queue=21140904, util=77.26%
>>
>> $ echo 2048 > /sys/block/md2/md/stripe_cache_size
>>> Jobs: 1 (f=1): [_________W______] [99.6% done] [0K/92182K /s] [0 /175  iops] [eta 00m:06s]
>>> read: (groupid=0, jobs=8): err= 0: pid=6392
>>>   read : io=81920MB, bw=185893KB/s, iops=363 , runt=451259msec
>>>     slat (usec): min=32 , max=524 , avg=75.08, stdev=26.00
>>>     clat (msec): min=8 , max=1849 , avg=335.65, stdev=149.76
>>>      lat (msec): min=8 , max=1849 , avg=335.72, stdev=149.76
>>>     bw (KB/s) : min=    0, max=105860, per=13.08%, avg=24308.99, stdev=7467.64
>>>   cpu          : usr=0.05%, sys=0.49%, ctx=157968, majf=0, minf=17171
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=163840/0/0, short=0/0/0
>>>
>>>      lat (msec): 10=0.01%, 20=0.06%, 50=2.32%, 100=7.44%, 250=15.36%
>>>      lat (msec): 500=69.09%, 750=4.50%, 1000=0.87%, 2000=0.35%
>>> write: (groupid=1, jobs=8): err= 0: pid=6663
>>>   write: io=81920MB, bw=75377KB/s, iops=147 , runt=1112887msec
>>>     slat (usec): min=46 , max=6453.8K, avg=988.13, stdev=46664.22
>>>     clat (msec): min=10 , max=8631 , avg=854.18, stdev=683.37
>>>      lat (msec): min=10 , max=8631 , avg=855.17, stdev=684.82
>>>     bw (KB/s) : min=    0, max=100352, per=14.04%, avg=10581.97, stdev=6871.80
>>>   cpu          : usr=0.34%, sys=0.11%, ctx=92502, majf=0, minf=1531
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=0/163840/0, short=0/0/0
>>>
>>>      lat (msec): 20=0.01%, 50=0.09%, 100=1.14%, 250=11.19%, 500=24.64%
>>>      lat (msec): 750=18.78%, 1000=13.40%, 2000=24.53%, >=2000=6.23%
>>>
>>> Run status group 0 (all jobs):
>>>    READ: io=81920MB, aggrb=185893KB/s, minb=190354KB/s, maxb=190354KB/s, mint=451259msec, maxt=451259msec
>>>
>>> Run status group 1 (all jobs):
>>>   WRITE: io=81920MB, aggrb=75376KB/s, minb=77186KB/s, maxb=77186KB/s, mint=1112887msec, maxt=1112887msec
>>>
>>> Disk stats (read/write):
>>>   dm-0: ios=327701/328169, merge=0/0, ticks=79402348/261890568, in_queue=341301888, util=100.00%, aggrios=327701/328481, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>>     md2: ios=327701/328481, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=127112/146994, aggrmerge=3364061/7997232, aggrticks=18091347/5817941, aggrin_queue=23914356, aggrutil=94.20%
>>>     sdc: ios=135729/149357, merge=3341205/8134447, ticks=18312932/8398716, in_queue=26721324, util=92.77%
>>>     sdd: ios=135561/151584, merge=3312121/8238249, ticks=16877204/8190968, in_queue=25077332, util=92.44%
>>>     sde: ios=135741/146023, merge=3345948/7981968, ticks=17659792/8659780, in_queue=26322124, util=94.20%
>>>     sdf: ios=114396/143768, merge=3413295/7801050, ticks=18551976/1652924, in_queue=20207384, util=72.89%
>>>     sdg: ios=114134/144241, merge=3407738/7830447, ticks=19054832/2187320, in_queue=21243620, util=74.96%
>>
>> $ echo 4096 > /sys/block/md2/md/stripe_cache_size
>>> Jobs: 1 (f=1): [________W_______] [100.0% done] [0K/95848K /s] [0 /182  iops] [eta 00m:00s]
>>> read: (groupid=0, jobs=8): err= 0: pid=11787
>>>   read : io=81920MB, bw=189274KB/s, iops=369 , runt=443200msec
>>>     slat (usec): min=31 , max=4511 , avg=75.47, stdev=29.74
>>>     clat (msec): min=5 , max=1338 , avg=336.39, stdev=155.14
>>>      lat (msec): min=5 , max=1338 , avg=336.47, stdev=155.14
>>>     bw (KB/s) : min=    0, max=253455, per=12.77%, avg=24162.01, stdev=11368.71
>>>   cpu          : usr=0.05%, sys=0.49%, ctx=157193, majf=0, minf=17313
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=163840/0/0, short=0/0/0
>>>
>>>      lat (msec): 10=0.47%, 20=0.66%, 50=2.95%, 100=6.33%, 250=14.56%
>>>      lat (msec): 500=68.12%, 750=5.42%, 1000=1.15%, 2000=0.33%
>>> write: (groupid=1, jobs=8): err= 0: pid=12060
>>>   write: io=81920MB, bw=64993KB/s, iops=126 , runt=1290687msec
>>>     slat (usec): min=61 , max=16991 , avg=197.22, stdev=110.87
>>>     clat (msec): min=14 , max=2820 , avg=980.92, stdev=366.56
>>>      lat (msec): min=14 , max=2821 , avg=981.12, stdev=366.56
>>>     bw (KB/s) : min=    0, max=103770, per=13.11%, avg=8517.92, stdev=3794.28
>>>   cpu          : usr=0.28%, sys=0.08%, ctx=84352, majf=0, minf=723
>>>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.9%, 32=0.0%, >=64=0.0%
>>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
>>>      issued r/w/d: total=0/163840/0, short=0/0/0
>>>
>>>      lat (msec): 20=0.01%, 50=0.03%, 100=0.28%, 250=0.22%, 500=5.37%
>>>      lat (msec): 750=22.02%, 1000=31.66%, 2000=39.27%, >=2000=1.16%
>>>
>>> Run status group 0 (all jobs):
>>>    READ: io=81920MB, aggrb=189273KB/s, minb=193816KB/s, maxb=193816KB/s, mint=443200msec, maxt=443200msec
>>>
>>> Run status group 1 (all jobs):
>>>   WRITE: io=81920MB, aggrb=64993KB/s, minb=66553KB/s, maxb=66553KB/s, mint=1290687msec, maxt=1290687msec
>>>
>>> Disk stats (read/write):
>>>   dm-0: ios=327681/327629, merge=0/0, ticks=78990724/301988444, in_queue=380991692, util=100.00%, aggrios=327681/327709, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>>>     md2: ios=327681/327709, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=120158/119573, aggrmerge=2858405/7663126, aggrticks=17291831/9119008, aggrin_queue=26414023, aggrutil=99.60%
>>>     sdc: ios=135579/119976, merge=2813832/7324879, ticks=13974928/2192484, in_queue=16167996, util=66.57%
>>>     sdd: ios=136115/127048, merge=2826584/7736191, ticks=12932248/2477796, in_queue=15410924, util=68.08%
>>>     sde: ios=136007/130908, merge=2844473/7936354, ticks=12642232/3141268, in_queue=15784336, util=71.86%
>>>     sdf: ios=78473/94458, merge=2882361/7865984, ticks=29053772/37421808, in_queue=66488856, util=99.60%
>>>     sdg: ios=114620/125479, merge=2924777/7452224, ticks=17855976/361684, in_queue=18218004, util=54.84%

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
