Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UM0OGs138512 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 16:00:25 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id zVBBL6zmO9eTw5Uy for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 14:00:23 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 28A6364D4
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 17:00:22 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 1F79664D3
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 17:00:22 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [31.185.235.168]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	796CA64D2 for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 17:00:21 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id LYMT4J-000ZBZ-R1 for
	xfs@oss.sgi.com; Mon, 30 Jan 2012 22:00:19 +0000
Date: Mon, 30 Jan 2012 22:00:19 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Performance problem - reads slower than writes
Message-ID: <20120130220019.GA45782@nsrc.org>
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
To: xfs@oss.sgi.com

I am doing some performance testing of XFS. I am using Ubuntu 11.10 amd64
(server), on an i3-2130 (3.4GHz) with 8GB RAM.

This will eventually run with a bunch of Hitachi 3TB Deskstar drives, but
the performance issue can be shown with just one.

Writing and reading large files using dd is fine. Performance is close to
what I get if I dd to the drive itself (which is 125MB/sec near the start of
the disk, down to 60MB/sec near the end of the disk, both reading and
writing).

However I'm getting something strange when I try using bonnie++ to write and
read a bunch of individual files - in this case 100,000 files with sizes
between 500k and 800k, spread over 1000 directories.

# time bonnie++ -d /data/sdb -s 16384k -n 98:800k:500k:1000 -u root
...
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
storage1        16G  1900  93 97299   3 49909   4  4899  96 139565   5 270.7   4
Latency              5251us     222ms     394ms   10705us   94111us     347ms
Version  1.96       ------Sequential Create------ --------Random Create--------
storage1            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
98:819200:512000/1000   112   3    37   2 12659  32   106   3    39   2  8148  31
Latency              6791ms     134ms   56383us    5161ms     459ms    3664ms
1.96,1.96,storage1,1,1327926367,16G,,1900,93,97299,3,49909,4,4899,96,139565,5,270.7,4,98,819200,512000,,1000,112,3,37,2,12659,32,106,3,39,2,8148,31,5251us,222ms,394ms,10705us,94111us,347ms,6791ms,134ms,56383us,5161ms,459ms,3664ms

real	129m3.450s
user	0m6.684s
sys	3m22.421s

Writing is fine: it writes about 110 files per second, and iostat shows
about 75MB/sec of write data throughput during that phase.

However when bonnie++ gets to the reading stage it reads only ~38 files per
second, and iostat shows only about 22MB/sec of data being read from the
disk.  There are about 270 disk operations per second seen at the time, so
the drive is clearly saturated with seeks.  It seems to be doing about 7
seeks for each stat+read.

root@storage1:~# iostat 5 | grep sdb
...
sdb             270.40     22119.20         0.00     110596          0
sdb             269.60     21948.80         0.00     109744          0
sdb             257.80     20969.60         0.00     104848          0

Now of course this might be symptomatic of something that bonnie++ is doing,
but strace'ing the program just shows it doing stat, open, repeated reads,
and close:

# strace -p 14318 2>&1 | grep -v '= 8192' | head -20
Process 14318 attached - interrupt to quit
read(3, "00999\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0"..., 2214) = 2214
close(3)                                = 0
stat("00248/Jm00000061ec", {st_mode=S_IFREG|0600, st_size=706711, ...}) = 0
open("00248/Jm00000061ec", O_RDONLY)    = 3
read(3, "00999\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0"..., 2199) = 2199
close(3)                                = 0
stat("00566/000000df91", {st_mode=S_IFREG|0600, st_size=637764, ...}) = 0
open("00566/000000df91", O_RDONLY)      = 3
read(3, "00999\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0"..., 6980) = 6980
close(3)                                = 0
stat("00868/7ndVASazO4I00000156bb", {st_mode=S_IFREG|0600, st_size=813560, ...}) = 0
open("00868/7ndVASazO4I00000156bb", O_RDONLY) = 3
read(3, "00999\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0"..., 2552) = 2552
close(3)                                = 0
stat("00759/vGTNHcCtfQ0000012bb6", {st_mode=S_IFREG|0600, st_size=786576, ...}) = 0
open("00759/vGTNHcCtfQ0000012bb6", O_RDONLY) = 3
read(3, "00999\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0 \266Z\1\0\0\0\0"..., 144) = 144
close(3)                                = 0
stat("00736/0RYuGyy00000122a4", {st_mode=S_IFREG|0600, st_size=758003, ...}) = 0

I can't see anything unusual there, not even O_DIRECT on the open().

The filesystem was created like this:

# mkfs.xfs -i attr=2,maxpct=1 /dev/sdb

Does anyone have any suggestions as to why there is so much seek activity
going on, or anything I can do to trace this further?

Thanks,

Brian Candler.

P.S. When dd'ing large files ontp XFS I found that bs=8k gave a lower
performance than bs=16k or larger.  So I wanted to rerun bonnie++ with
larger chunk sizes.  Unfortunately that causes it to crash (and fairly
consistently) - see below.

Is the 8k block size likely to be the performance culprit here?

# time bonnie++ -d /data/sdb -s 16384k:32k -n 98:800k:500k:1000:32k -u root
Using uid:0, gid:0.
Writing a byte at a time...done
Writing intelligently...done
Rewriting...done
Reading a byte at a time...done
Reading intelligently...
done
start 'em...done...done...done...done...done...
*** glibc detected *** bonnie++: double free or corruption (out): 0x00000000024430a0 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x78a96)[0x7f42a0317a96]
/lib/x86_64-linux-gnu/libc.so.6(cfree+0x6c)[0x7f42a031bd7c]
bonnie++[0x404dd7]
bonnie++[0x402e90]
bonnie++[0x403bb6]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xed)[0x7f42a02c030d]
bonnie++[0x402219]
======= Memory map: ========
00400000-0040c000 r-xp 00000000 08:01 3683058                            /usr/sbin/bonnie++
0060b000-0060c000 r--p 0000b000 08:01 3683058                            /usr/sbin/bonnie++
0060c000-0060d000 rw-p 0000c000 08:01 3683058                            /usr/sbin/bonnie++
02438000-02484000 rw-p 00000000 00:00 0                                  [heap]
7f4298000000-7f4298021000 rw-p 00000000 00:00 0 
7f4298021000-7f429c000000 ---p 00000000 00:00 0 
7f429d25e000-7f429d25f000 ---p 00000000 00:00 0 
7f429d25f000-7f429da5f000 rw-p 00000000 00:00 0 
7f429da5f000-7f429da60000 ---p 00000000 00:00 0 
7f429da60000-7f429e260000 rw-p 00000000 00:00 0 
7f429e260000-7f429e261000 ---p 00000000 00:00 0 
7f429e261000-7f429ea61000 rw-p 00000000 00:00 0 
7f429ea61000-7f429ea62000 ---p 00000000 00:00 0 
7f429ea62000-7f429f262000 rw-p 00000000 00:00 0 
7f429f262000-7f429f263000 ---p 00000000 00:00 0 
7f429f263000-7f429fa63000 rw-p 00000000 00:00 0 
7f429fa63000-7f429fa6f000 r-xp 00000000 08:01 1179679                    /lib/x86_64-linux-gnu/libnss_files-2.13.so
7f429fa6f000-7f429fc6e000 ---p 0000c000 08:01 1179679                    /lib/x86_64-linux-gnu/libnss_files-2.13.so
7f429fc6e000-7f429fc6f000 r--p 0000b000 08:01 1179679                    /lib/x86_64-linux-gnu/libnss_files-2.13.so
7f429fc6f000-7f429fc70000 rw-p 0000c000 08:01 1179679                    /lib/x86_64-linux-gnu/libnss_files-2.13.so
7f429fc70000-7f429fc7a000 r-xp 00000000 08:01 1179685                    /lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f429fc7a000-7f429fe7a000 ---p 0000a000 08:01 1179685                    /lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f429fe7a000-7f429fe7b000 r--p 0000a000 08:01 1179685                    /lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f429fe7b000-7f429fe7c000 rw-p 0000b000 08:01 1179685                    /lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f429fe7c000-7f429fe93000 r-xp 00000000 08:01 1179674                    /lib/x86_64-linux-gnu/libnsl-2.13.so
7f429fe93000-7f42a0092000 ---p 00017000 08:01 1179674                    /lib/x86_64-linux-gnu/libnsl-2.13.so
7f42a0092000-7f42a0093000 r--p 00016000 08:01 1179674                    /lib/x86_64-linux-gnu/libnsl-2.13.so
7f42a0093000-7f42a0094000 rw-p 00017000 08:01 1179674                    /lib/x86_64-linux-gnu/libnsl-2.13.so
7f42a0094000-7f42a0096000 rw-p 00000000 00:00 0 
7f42a0096000-7f42a009e000 r-xp 00000000 08:01 1179667                    /lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f42a009e000-7f42a029d000 ---p 00008000 08:01 1179667                    /lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f42a029d000-7f42a029e000 r--p 00007000 08:01 1179667                    /lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f42a029e000-7f42a029f000 rw-p 00008000 08:01 1179667                    /lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f42a029f000-7f42a0434000 r-xp 00000000 08:01 1179676                    /lib/x86_64-linux-gnu/libc-2.13.so
7f42a0434000-7f42a0633000 ---p 00195000 08:01 1179676                    /lib/x86_64-linux-gnu/libc-2.13.so
7f42a0633000-7f42a0637000 r--p 00194000 08:01 1179676                    /lib/x86_64-linux-gnu/libc-2.13.so
7f42a0637000-7f42a0638000 rw-p 00198000 08:01 1179676                    /lib/x86_64-linux-gnu/libc-2.13.so
7f42a0638000-7f42a063e000 rw-p 00000000 00:00 0 
7f42a063e000-7f42a0653000 r-xp 00000000 08:01 1179692                    /lib/x86_64-linux-gnu/libgcc_s.so.1
7f42a0653000-7f42a0852000 ---p 00015000 08:01 1179692                    /lib/x86_64-linux-gnu/libgcc_s.so.1
7f42a0852000-7f42a0853000 r--p 00014000 08:01 1179692                    /lib/x86_64-linux-gnu/libgcc_s.so.1
7f42a0853000-7f42a0854000 rw-p 00015000 08:01 1179692                    /lib/x86_64-linux-gnu/libgcc_s.so.1
7f42a0854000-7f42a08d7000 r-xp 00000000 08:01 1179686                    /lib/x86_64-linux-gnu/libm-2.13.so
7f42a08d7000-7f42a0ad6000 ---p 00083000 08:01 1179686                    /lib/x86_64-linux-gnu/libm-2.13.so
7f42a0ad6000-7f42a0ad7000 r--p 00082000 08:01 1179686                    /lib/x86_64-linux-gnu/libm-2.13.so
7f42a0ad7000-7f42a0ad8000 rw-p 00083000 08:01 1179686                    /lib/x86_64-linux-gnu/libm-2.13.so
7f42a0ad8000-7f42a0bc0000 r-xp 00000000 08:01 3674840                    /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16
7f42a0bc0000-7f42a0dc0000 ---p 000e8000 08:01 3674840                    /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16
7f42a0dc0000-7f42a0dc8000 r--p 000e8000 08:01 3674840                    /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16
7f42a0dc8000-7f42a0dca000 rw-p 000f0000 08:01 3674840                    /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16
7f42a0dca000-7f42a0ddf000 rw-p 00000000 00:00 0 
7f42a0ddf000-7f42a0df7000 r-xp 00000000 08:01 1179684                    /lib/x86_64-linux-gnu/libpthread-2.13.so
7f42a0df7000-7f42a0ff6000 ---p 00018000 08:01 1179684                    /lib/x86_64-linux-gnu/libpthread-2.13.so
7f42a0ff6000-7f42a0ff7000 r--p 00017000 08:01 1179684                    /lib/x86_64-linux-gnu/libpthread-2.13.so
7f42a0ff7000-7f42a0ff8000 rw-p 00018000 08:01 1179684                    /lib/x86_64-linux-gnu/libpthread-2.13.so
7f42a0ff8000-7f42a0ffc000 rw-p 00000000 00:00 0 
7f42a0ffc000-7f42a101d000 r-xp 00000000 08:01 1179683                    /lib/x86_64-linux-gnu/ld-2.13.so
7f42a1210000-7f42a1215000 rw-p 00000000 00:00 0 
7f42a121a000-7f42a121c000 rw-p 00000000 00:00 0 
7f42a121c000-7f42a121d000 r--p 00020000 08:01 1179683                    /lib/x86_64-linux-gnu/ld-2.13.so
7f42a121d000-7f42a121f000 rw-p 00021000 08:01 1179683                    /lib/x86_64-linux-gnu/ld-2.13.so
7ffff2c84000-7ffff2ca5000 rw-p 00000000 00:00 0                          [stack]
7ffff2cc1000-7ffff2cc2000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
Aborted

real    14m38.760s
user    0m0.832s
sys     0m32.670s

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
