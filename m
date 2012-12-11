Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBB8TchA049038 for <xfs@oss.sgi.com>; Tue, 11 Dec 2012 02:29:38 -0600
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id 6Yqho5H1GhaU09xw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Dec 2012 00:32:07 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id hz1so2496345pad.26
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2012 00:32:06 -0800 (PST)
Date: Tue, 11 Dec 2012 16:45:21 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: A huge latency in ext4 and xfs because of stable page write
Message-ID: <20121211084520.GA13277@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu, david@fromorbit.com, hch@infradead.org, darrick.wong@oracle.com

Hi all,

At Tao Bao we meet a problem in our product system which causes a huge latency
because of stable page write.  This problem is easy to reproduce in a testing
environment, and I can reproduce it in my desktop with a SATA disk.  Here is the
fio config file that is used to reproduce this problem.

config file
-----------
[global]
iodepth=1
directory=/mnt/sda3
direct=0
group_reporting
thread
fallocate=0
runtime=120

[log-append]
ioengine=sync
rw=write
bs=1k
size=10g
filesize=10g
rate=5m
numjobs=1

I run this test case in ext4 and xfs, and both of them are affected by stable
page write.  The result shows as below.  Please notice the result of latency.

ext4 w/ stable page write
-------------------------
log-append: (groupid=0, jobs=1): err= 0: pid=3455: Tue Dec 11 14:41:27 2012
  write: io=614401KB, bw=5119.1KB/s, iops=5119 , runt=120001msec
    clat (usec): min=3 , max=225702 , avg= 7.32, stdev=411.95
     lat (usec): min=3 , max=225702 , avg= 7.50, stdev=411.95
    clat percentiles (usec):
     |  1.00th=[    3],  5.00th=[    3], 10.00th=[    3], 20.00th=[    4], 
     | 30.00th=[    4], 40.00th=[    4], 50.00th=[    4], 60.00th=[    5], 
     | 70.00th=[    6], 80.00th=[   12], 90.00th=[   13], 95.00th=[   14],
     | 99.00th=[   15], 99.50th=[   16], 99.90th=[   18], 99.95th=[   19],
     | 99.99th=[   25] 
    bw (KB/s)  : min= 5108, max= 5134, per=100.00%, avg=5120.92, stdev= 1.58
    lat (usec) : 4=15.93%, 10=59.05%, 20=24.98%, 50=0.03%, 100=0.01%
    lat (usec) : 250=0.01%
    lat (msec) : 20=0.01%, 250=0.01%
  cpu          : usr=0.18%, sys=4.31%, ctx=118850, majf=18446744073709551605,
minf=18446744073709538970
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=614401/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=614401KB, aggrb=5119KB/s, minb=5119KB/s, maxb=5119KB/s,
mint=120001msec, maxt=120001msec

Disk stats (read/write):
  sda: ios=79/1287, merge=5/151907, ticks=702/147202, in_queue=147861, util=6.25%

ext4 w/o stable page write
--------------------------
log-append: (groupid=0, jobs=1): err= 0: pid=3062: Tue Dec 11 14:52:32 2012
  write: io=614400KB, bw=5119.1KB/s, iops=5119 , runt=120001msec
    clat (usec): min=3 , max=14565 , avg= 6.15, stdev=25.35
     lat (usec): min=3 , max=14566 , avg= 6.29, stdev=25.35
    clat percentiles (usec):
     |  1.00th=[    3],  5.00th=[    3], 10.00th=[    3], 20.00th=[    4], 
     | 30.00th=[    4], 40.00th=[    4], 50.00th=[    4], 60.00th=[    4], 
     | 70.00th=[    5], 80.00th=[   12], 90.00th=[   12], 95.00th=[   13],
     | 99.00th=[   15], 99.50th=[   15], 99.90th=[   17], 99.95th=[   18],
     | 99.99th=[   64] 
    bw (KB/s)  : min= 5108, max= 5140, per=100.00%, avg=5122.26, stdev= 4.54
    lat (usec) : 4=17.33%, 10=57.65%, 20=24.98%, 50=0.02%, 100=0.01%
    lat (usec) : 250=0.01%
    lat (msec) : 2=0.01%, 20=0.01%
  cpu          : usr=4.12%, sys=0.00%, ctx=58904, majf=18446744073709551605,
minf=18446744073709538969
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=614400/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=614400KB, aggrb=5119KB/s, minb=5119KB/s, maxb=5119KB/s,
mint=120001msec, maxt=120001msec

Disk stats (read/write):
  sda: ios=34/1254, merge=4/152032, ticks=157/144066, in_queue=147725, util=5.82%

xfs w/ stable page write
------------------------
log-append: (groupid=0, jobs=1): err= 0: pid=2848: Tue Dec 11 15:39:25 2012
  write: io=614401KB, bw=5119.1KB/s, iops=5119 , runt=120002msec
    clat (usec): min=1 , max=635643 , avg= 5.02, stdev=1141.37
     lat (usec): min=1 , max=635643 , avg= 5.17, stdev=1141.37
    clat percentiles (usec):
     |  1.00th=[    1],  5.00th=[    1], 10.00th=[    1], 20.00th=[    1], 
     | 30.00th=[    2], 40.00th=[    2], 50.00th=[    2], 60.00th=[    2], 
     | 70.00th=[    4], 80.00th=[    5], 90.00th=[    6], 95.00th=[    6], 
     | 99.00th=[    9], 99.50th=[   10], 99.90th=[   11], 99.95th=[   12],
     | 99.99th=[   13] 
    bw (KB/s)  : min= 1388, max=11632, per=100.00%, avg=5147.03, stdev=675.82
    lat (usec) : 2=21.76%, 4=46.03%, 10=31.65%, 20=0.56%, 50=0.01%
    lat (msec) : 20=0.01%, 750=0.01%
  cpu          : usr=1.09%, sys=1.18%, ctx=58250, majf=18446744073709551605,
minf=18446744073709538970
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=614401/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=614401KB, aggrb=5119KB/s, minb=5119KB/s, maxb=5119KB/s,
mint=120002msec, maxt=120002msec

Disk stats (read/write):
  sda: ios=15/1101, merge=0/28, ticks=150/554585, in_queue=554731, util=4.18%

xfs w/o stable page write
-------------------------
log-append: (groupid=0, jobs=1): err= 0: pid=3678: Tue Dec 11 15:01:10 2012
  write: io=614401KB, bw=5119.1KB/s, iops=5119 , runt=120001msec
    clat (usec): min=1 , max=20866 , avg= 3.50, stdev=26.72
     lat (usec): min=1 , max=20866 , avg= 3.60, stdev=26.72
    clat percentiles (usec):
     |  1.00th=[    1],  5.00th=[    1], 10.00th=[    1], 20.00th=[    2], 
     | 30.00th=[    2], 40.00th=[    2], 50.00th=[    2], 60.00th=[    2], 
     | 70.00th=[    5], 80.00th=[    6], 90.00th=[    6], 95.00th=[    8], 
     | 99.00th=[   10], 99.50th=[   10], 99.90th=[   12], 99.95th=[   12],
     | 99.99th=[   14] 
    bw (KB/s)  : min= 5110, max= 5132, per=100.00%, avg=5120.84, stdev= 2.25
    lat (usec) : 2=15.33%, 4=44.93%, 10=38.33%, 20=1.41%, 50=0.01%
    lat (usec) : 500=0.01%
    lat (msec) : 50=0.01%
  cpu          : usr=2.83%, sys=0.00%, ctx=119423, majf=18446744073709551605,
minf=18446744073709538968
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=614401/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=614401KB, aggrb=5119KB/s, minb=5119KB/s, maxb=5119KB/s,
mint=120001msec, maxt=120001msec

Disk stats (read/write):
  sda: ios=106/1055, merge=3/35, ticks=1042/522739, in_queue=523780, util=4.56%

We can see that the max of latency is very high with stable page write in ext4
and xfs, and it reduces to a lower value after stable page write is reverted.  I
summarize as below.

      ext4    xfs  (usec, lower is better)
w/  225702 635643
w/o  14565  20866

Hence, I wonder whether or not we could revert stable page write temporarily.
After it is improved, we could add it back again.

Thanks,
						- Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
