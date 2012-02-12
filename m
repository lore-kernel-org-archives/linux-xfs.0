Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CK6qmW202240 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 14:06:53 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TIPae5soL7q2jWGw for <xfs@oss.sgi.com>;
	Sun, 12 Feb 2012 12:06:50 -0800 (PST)
Date: Mon, 13 Feb 2012 07:06:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Disk spin down
Message-ID: <20120212200647.GI12836@dastard>
References: <4F3803B1.1090205@ashurst.eu.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3803B1.1090205@ashurst.eu.org>
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
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: xfs@oss.sgi.com

On Sun, Feb 12, 2012 at 06:23:45PM +0000, Andy Bennett wrote:
> Hi,
> 
> Can someone help me work out where writes are coming from on my system?
> They don't seem to be originating from a user process and it looks like
> [xfsbufd] might be to blame.
> 
> I have recently bought a Samsung NC110 nebook with an Hitachi
> HTS543232A7A384 320GB SATA disk.
> 
> I have installed Debian Squeeze. This comes with Linux 2.6.32-5-amd64
> but I upgraded to the Linux-3.2.0-0.bpo.1-amd64 kernel in
> squeeze-backports to get the appropriate firmware for the wireless card.
> 
> My partitions are mostly XFS, except /boot which is ext4.
> 
> I notice that the 3.2 kernel constantly spins the disk up and down at an
> interval of about 10 seconds. Under the 2.6 one the interval is much
> larger but it still happens.
> 
> In order to investigate I used 'iotop' invoked both as 'iotop' and
> 'iotop -oa'. On a quiescent system this shows periodic overall writes of
> a few KB/s but it doesn't show any writes for a particular process. No
> reads are ever shown on a quiescent system.
> 
> I used blktrace which suggested that sda6 (/var) was to blame. I used
> 'lsof |grep /var' to see what was running and switched off a bunch of
> daemons just to be sure:
> 
> -----
>   sudo /etc/init.d/gdm stop; sudo /etc/init.d/cron stop; sudo
> /etc/init.d/dbus stop; sudo /etc/init.d/rsyslog stop; sudo
> /etc/init.d/atd stop; sudo /etc/init.d/acpid stop
> -----
> 
> I used 'tail -f' on the remaining open files in /var to ensure that
> nothing was being written.
> 
> 
> The disk still spun up and down frequently.
> 
> I took some blktraces with 'sudo btrace /dev/sda >
> /dev/shm/blktrace.Linux-...':
> 
....
> -----
> $ cat blktrace.Linux-3.2.0-0.bpo.1-amd64
>   8,0    1        1     0.000000000     9  A WBSM 28595407 + 2 <- (8,6) 3947727
>   8,0    1        2     0.000003771     9  Q WBSM 28595407 + 2 [kworker/1:0]
>   8,0    1        3     0.000014736     9  G WBSM 28595407 + 2 [kworker/1:0]
>   8,0    1        4     0.000024165     9  I WBSM 28595407 + 2 [kworker/1:0]
>   8,0    3        1     0.000174603     0  D WSM 28595407 + 2 [swapper/1]
>   8,0    1        5     0.000363663     0  C WSM 28595407 + 2 [0]

That's a log write, probably from the periodic xfssync code.

 491 STATIC void
 492 xfs_sync_worker(
 493         struct work_struct *work)
 494 {
 495         struct xfs_mount *mp = container_of(to_delayed_work(work),
 496                                         struct xfs_mount, m_sync_work);
 497         int             error;
 498
 499         if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 500                 /* dgc: errors ignored here */
 501                 if (mp->m_super->s_frozen == SB_UNFROZEN &&
 502                     xfs_log_need_covered(mp))
 503                         error = xfs_fs_log_dummy(mp);
 504                 else
 505                         xfs_log_force(mp, 0);

This branch here - an async log force.

 506
 507                 /* start pushing all the metadata that is currently dirty */
 508                 xfs_ail_push_all(mp->m_ail);

Which will wake the xfsaild, which triggers the xfsbufd to write metadata.

 509         }
 510
 511         /* queue us up again */
 512         xfs_syncd_queue_sync(mp);
 513 }
 

>   8,0    1        6     0.037216442   936  A  WM 24647680 + 1 <- (8,6) 0
>   8,0    1        7     0.037219166   936  Q  WM 24647680 + 1 [xfsbufd/sda6]
>   8,0    1        8     0.037230480   936  G  WM 24647680 + 1 [xfsbufd/sda6]
>   8,0    1        9     0.037233903   936  P   N [xfsbufd/sda6]
>   8,0    1       10     0.037239001   936  I  WM 24647680 + 1 [xfsbufd/sda6]

xfsbufd is now writing a single sector buffer, it plugged.

>   8,0    0        1     0.037009992     0  C WSM 28595407 [0]

Log IO completes.

>   8,0    1       11     0.037254506   936  U   N [xfsbufd/sda6] 1

xfsbufd unplugs.

>   8,0    1       12     0.037309401   936  D  WM 24647680 + 1 [xfsbufd/sda6]
>   8,0    1       13     0.037518785     0  C  WM 24647680 + 1 [0]

IO completes.

50ms passes. That's the xfsaild backoff time when it's walked all
the metadata in the dirty list. Then it starts again:

>   8,0    1       14     0.087965523   936  A  WM 28618208 + 16 <- (8,6) 3970528
>   8,0    1       15     0.087968386   936  Q  WM 28618208 + 16 [xfsbufd/sda6]
>   8,0    1       16     0.087978443   936  G  WM 28618208 + 16 [xfsbufd/sda6]
>   8,0    1       17     0.087981935   936  P   N [xfsbufd/sda6]
>   8,0    1       18     0.087987592   936  I  WM 28618208 + 16 [xfsbufd/sda6]
>   8,0    1       19     0.087999255   936  U   N [xfsbufd/sda6] 1
>   8,0    1       20     0.088048214   936  D  WM 28618208 + 16 [xfsbufd/sda6]
>   8,0    1       21     0.088291817     0  C  WM 28618208 + 16 [0]

And finds more work to do, which triggers the xfsbufd to flush an
8k buffer - most likely an inode buffer - and goes back to sleep.

Seems to me that something is still dirtying an inode regularly.

Perhaps you need to look at the XFS and writeback event traces to
find out what process is dirtying the inode. trace-cmd is your
friend...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
