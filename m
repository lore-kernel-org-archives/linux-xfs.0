Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CINLEq194241 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 12:23:21 -0600
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id V0DxRBNwEQIsI4CP
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 Feb 2012 10:23:11 -0800 (PST)
Received: from [31.185.58.229] (helo=[192.168.1.82])
	by pavilion.ashurst.eu.org with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <andyjpb@ashurst.eu.org>) id 1Rwe4r-00025y-3r
	for xfs@oss.sgi.com; Sun, 12 Feb 2012 18:23:10 +0000
Message-ID: <4F3803B1.1090205@ashurst.eu.org>
Date: Sun, 12 Feb 2012 18:23:45 +0000
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
Subject: Disk spin down
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

Hi,

Can someone help me work out where writes are coming from on my system?
They don't seem to be originating from a user process and it looks like
[xfsbufd] might be to blame.

I have recently bought a Samsung NC110 nebook with an Hitachi
HTS543232A7A384 320GB SATA disk.

I have installed Debian Squeeze. This comes with Linux 2.6.32-5-amd64
but I upgraded to the Linux-3.2.0-0.bpo.1-amd64 kernel in
squeeze-backports to get the appropriate firmware for the wireless card.

My partitions are mostly XFS, except /boot which is ext4.

I notice that the 3.2 kernel constantly spins the disk up and down at an
interval of about 10 seconds. Under the 2.6 one the interval is much
larger but it still happens.

In order to investigate I used 'iotop' invoked both as 'iotop' and
'iotop -oa'. On a quiescent system this shows periodic overall writes of
a few KB/s but it doesn't show any writes for a particular process. No
reads are ever shown on a quiescent system.

I used blktrace which suggested that sda6 (/var) was to blame. I used
'lsof |grep /var' to see what was running and switched off a bunch of
daemons just to be sure:

-----
  sudo /etc/init.d/gdm stop; sudo /etc/init.d/cron stop; sudo
/etc/init.d/dbus stop; sudo /etc/init.d/rsyslog stop; sudo
/etc/init.d/atd stop; sudo /etc/init.d/acpid stop
-----

I used 'tail -f' on the remaining open files in /var to ensure that
nothing was being written.


The disk still spun up and down frequently.

I took some blktraces with 'sudo btrace /dev/sda >
/dev/shm/blktrace.Linux-...':

-----
$ cat blktrace.Linux-2.6.32-5-amd64
  8,0    0        1     0.000000000   644  A   W 28618136 + 8 <- (8,6)
3970456
  8,0    0        2     0.000002934   644  Q   W 28618136 + 8 [flush-8:0]
  8,0    0        3     0.000013899   644  G   W 28618136 + 8 [flush-8:0]
  8,0    0        4     0.000020464   644  P   N [flush-8:0]
  8,0    0        5     0.000024096   644  I   W 28618136 + 8 [flush-8:0]
  8,0    0        0     0.000032197     0  m   N cfq280 insert_request
  8,0    0        0     0.000035899     0  m   N cfq280 add_to_rr
  8,0    0        0     0.000041346     0  m   N cfq280 preempt
  8,0    0        0     0.000044559     0  m   N cfq644 slice expired t=1
  8,0    0        0     0.000047911     0  m   N cfq644 resid=-30761
  8,0    0        0     0.000054616     0  m   N cfq280 set_active
  8,0    0        0     0.000059994     0  m   N cfq280 fifo=(null)
  8,0    0        0     0.000062857     0  m   N cfq280 dispatch_insert
  8,0    0        0     0.000066419     0  m   N cfq280 del_from_rr
  8,0    0        0     0.000070121     0  m   N cfq280 dispatched a request
  8,0    0        0     0.000074521     0  m   N cfq280 activate rq, drv=1
  8,0    0        6     0.000076756   644  D   W 28618136 + 8 [flush-8:0]
  8,0    0        7     0.000139753   644  A  WS 28618208 + 16 <- (8,6)
3970528
  8,0    0        8     0.000142197   644  Q  WS 28618208 + 16 [flush-8:0]
  8,0    0        9     0.000147645   644  G  WS 28618208 + 16 [flush-8:0]
  8,0    0       10     0.000152603   644  P   N [flush-8:0]
  8,0    0       11     0.000155118   644  I   W 28618208 + 16 [flush-8:0]
  8,0    0        0     0.000159588     0  m   N cfq644 insert_request
  8,0    0        0     0.000162521     0  m   N cfq644 add_to_rr
  8,0    0        0     0.000166921     0  m   N cfq644 preempt
  8,0    0        0     0.000169784     0  m   N cfq280 slice expired t=1
  8,0    0        0     0.000174673     0  m   N cfq644 set_active
  8,0    0        0     0.000178375     0  m   N cfq644 fifo=(null)
  8,0    0        0     0.000181099     0  m   N cfq644 dispatch_insert
  8,0    0        0     0.000184311     0  m   N cfq644 del_from_rr
  8,0    0        0     0.000187664     0  m   N cfq644 dispatched a request
  8,0    0        0     0.000191086     0  m   N cfq644 activate rq, drv=2
  8,0    0       12     0.000192972   644  D   W 28618208 + 16 [flush-8:0]
  8,0    0       13     1.854932267     0  C   W 28618136 + 8 [0]
  8,0    0        0     1.854957131     0  m   N cfq280 complete
  8,0    0       14     1.866415850     0  C   W 28618208 + 16 [0]
  8,0    0        0     1.866432402     0  m   N cfq644 complete
  8,0    0        0     1.866436453     0  m   N cfq644 set_slice=25
CPU0 (8,0):
 Reads Queued:           0,        0KiB  Writes Queued:           2,
   12KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        2,
   12KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        2,
   12KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
    0KiB
 Read depth:             0               Write depth:             2
 IO unplugs:             0               Timer unplugs:           0

Throughput (R/W): 0KiB/s / 6KiB/s
Events (8,0): 38 entries
Skips: 3 forward (29 -  43.3%)
-----


-----
$ cat blktrace.Linux-3.2.0-0.bpo.1-amd64
  8,0    1        1     0.000000000     9  A WBSM 28595407 + 2 <- (8,6)
3947727
  8,0    1        2     0.000003771     9  Q WBSM 28595407 + 2 [kworker/1:0]
  8,0    1        3     0.000014736     9  G WBSM 28595407 + 2 [kworker/1:0]
  8,0    1        4     0.000024165     9  I WBSM 28595407 + 2 [kworker/1:0]
  8,0    3        1     0.000174603     0  D WSM 28595407 + 2 [swapper/1]
  8,0    1        5     0.000363663     0  C WSM 28595407 + 2 [0]
  8,0    1        6     0.037216442   936  A  WM 24647680 + 1 <- (8,6) 0
  8,0    1        7     0.037219166   936  Q  WM 24647680 + 1 [xfsbufd/sda6]
  8,0    1        8     0.037230480   936  G  WM 24647680 + 1 [xfsbufd/sda6]
  8,0    1        9     0.037233903   936  P   N [xfsbufd/sda6]
  8,0    1       10     0.037239001   936  I  WM 24647680 + 1 [xfsbufd/sda6]
  8,0    0        1     0.037009992     0  C WSM 28595407 [0]
  8,0    1        0     0.037248988     0  m   N cfq202A / insert_request
  8,0    1       11     0.037254506   936  U   N [xfsbufd/sda6] 1
  8,0    1        0     0.037261211     0  m   N cfq202A / slice expired t=0
  8,0    1        0     0.037267496     0  m   N / served: vt=6391808
min_vt=6371328
  8,0    1        0     0.037274201     0  m   N cfq202A / sl_used=10
disp=1 charge=10 iops=0 sect=8
  8,0    1        0     0.037280626     0  m   N cfq workload slice:10
  8,0    1        0     0.037285236     0  m   N cfq202A / set_active
wl_prio:0 wl_type:0
  8,0    1        0     0.037289287     0  m   N cfq202A / Not idling.
st->count:1
  8,0    1        0     0.037294525     0  m   N cfq202A / fifo=
  (null)
  8,0    1        0     0.037298017     0  m   N cfq202A / dispatch_insert
  8,0    1        0     0.037303953     0  m   N cfq202A / dispatched a
request
  8,0    1        0     0.037307515     0  m   N cfq202A / activate rq,
drv=1
  8,0    1       12     0.037309401   936  D  WM 24647680 + 1 [xfsbufd/sda6]
  8,0    1       13     0.037518785     0  C  WM 24647680 + 1 [0]
  8,0    1        0     0.037539947     0  m   N cfq202A / complete
rqnoidle 0
  8,0    1        0     0.037545115     0  m   N cfq202A / set_slice=10
  8,0    1        0     0.037547629     0  m   N cfq schedule dispatch
  8,0    1       14     0.087965523   936  A  WM 28618208 + 16 <- (8,6)
3970528
  8,0    1       15     0.087968386   936  Q  WM 28618208 + 16
[xfsbufd/sda6]
  8,0    1       16     0.087978443   936  G  WM 28618208 + 16
[xfsbufd/sda6]
  8,0    1       17     0.087981935   936  P   N [xfsbufd/sda6]
  8,0    1       18     0.087987592   936  I  WM 28618208 + 16
[xfsbufd/sda6]
  8,0    1        0     0.087994995     0  m   N cfq202A / insert_request
  8,0    1       19     0.087999255   936  U   N [xfsbufd/sda6] 1
  8,0    1        0     0.088004563     0  m   N cfq202A / slice expired t=0
  8,0    1        0     0.088009871     0  m   N / served: vt=6412288
min_vt=6391808
  8,0    1        0     0.088016017     0  m   N cfq202A / sl_used=10
disp=1 charge=10 iops=0 sect=1
  8,0    1        0     0.088021255     0  m   N cfq workload slice:10
  8,0    1        0     0.088025725     0  m   N cfq202A / set_active
wl_prio:0 wl_type:0
  8,0    1        0     0.088029776     0  m   N cfq202A / Not idling.
st->count:1
  8,0    1        0     0.088034246     0  m   N cfq202A / fifo=
  (null)
  8,0    1        0     0.088037528     0  m   N cfq202A / dispatch_insert
  8,0    1        0     0.088042696     0  m   N cfq202A / dispatched a
request
  8,0    1        0     0.088046328     0  m   N cfq202A / activate rq,
drv=1
  8,0    1       20     0.088048214   936  D  WM 28618208 + 16
[xfsbufd/sda6]
  8,0    1       21     0.088291817     0  C  WM 28618208 + 16 [0]
  8,0    1        0     0.088311442     0  m   N cfq202A / complete
rqnoidle 0
  8,0    1        0     0.088316680     0  m   N cfq202A / set_slice=10
  8,0    1        0     0.088319055     0  m   N cfq schedule dispatch
CPU0 (8,0):
 Reads Queued:           0,        0KiB  Writes Queued:           0,
    0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        0,
    0KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        1,
    0KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
    0KiB
 Read depth:             0               Write depth:             1
 IO unplugs:             0               Timer unplugs:           0
CPU1 (8,0):
 Reads Queued:           0,        0KiB  Writes Queued:           3,
    9KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        2,
    8KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        3,
    9KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
    0KiB
 Read depth:             0               Write depth:             1
 IO unplugs:             2               Timer unplugs:           0
CPU3 (8,0):
 Reads Queued:           0,        0KiB  Writes Queued:           0,
    0KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        1,
    1KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        0,
    0KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
    0KiB
 Read depth:             0               Write depth:             1
 IO unplugs:             0               Timer unplugs:           0

Total (8,0):
 Reads Queued:           0,        0KiB  Writes Queued:           3,
    9KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:        3,
    9KiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:        0,        0KiB  Writes Completed:        4,
    9KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
    0KiB
 IO unplugs:             2               Timer unplugs:           0

Throughput (R/W): 0KiB/s / 102KiB/s
Events (8,0): 51 entries
Skips: 5 forward (71 -  58.2%)
-----

The blktrace from Linux 3.2 seems much more incriminating for XFS than
the Linux 2.6 one.


Does anyone have any hints about whether this is an XFS bug or
regression or where I can look for more information?


Many thanks for your time.





Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
