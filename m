Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBDCsnhP029368 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 06:54:49 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F30B1ABEF
	for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 04:54:46 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id RyNWL1jBQSiVtEDh for
	<xfs@oss.sgi.com>; Sat, 13 Dec 2008 04:54:46 -0800 (PST)
Date: Sat, 13 Dec 2008 07:54:45 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
 [xfs]
In-Reply-To: <493A9BE7.3090001@sandeen.net>
Message-ID: <alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<493A9BE7.3090001@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com



On Sat, 6 Dec 2008, Eric Sandeen wrote:

> Justin Piszcz wrote:
>> Someone should write a document with XFS and barrier support, if I recall,
>> in the past, they never worked right on raid1 or raid5 devices, but it
>> appears now they they work on RAID1, which slows down performance ~12 times!!
>
>> There is some mention of it here:
>> http://oss.sgi.com/projects/xfs/faq.html#wcache_persistent
>>
>> But basically I believe it should be noted in the kernel logs, FAQ or somewhere
>> because just through the process of upgrading the kernel, not changing fstab
>> or any other part of the system, performance can drop 12x just because the
>> newer kernels implement barriers.
>
> Perhaps:
>
> printk(KERN_ALERT "XFS is now looking after your metadata very
> carefully; if you prefer the old, fast, dangerous way, mount with -o
> nobarrier\n");
>
> :)
>
> Really, this just gets xfs on md raid1 in line with how it behaves on
> most other devices.
>
> But I agree, some documentation/education is probably in order; if you
> choose to disable write caches or you have faith in the battery backup
> of your write cache, turning off barriers would be a good idea.  Justin,
> it might be interesting to do some tests with:
>
> barrier,   write cache enabled
> nobarrier, write cache enabled
> nobarrier, write cache disabled
>
> a 12x hit does hurt though...  If you're really motivated, try the same
> scenarios on ext3 and ext4 to see what the barrier hit is on those as well.
>
> -Eric
>

No, I have not forgotten about this I have just been quite busy, I will test
this now, as before, I did not use sync because I was in a hurry and did not
have the ability to test, I am using a different machine/hw type but the
setup is the same, md/raid1 etc.

Since I will only be measuring barriers, per esandeen@ I have changed the mount
options from what I typically use to the defaults.

Here is the /etc/fstab entry:
/dev/md2        /               xfs     defaults        0       1

And the nobarrier entry:
/dev/md2        /               xfs     defaults,nobarrier        0       1

Stop cron and make sure nothing else is using the disk I/O, done:

# /etc/init.d/cron stop
Stopping periodic command scheduler: crond.

The benchmark:
# /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
# echo 1 > /proc/sys/vm/drop_caches # (between tests)

== The tests ==

  KEY:
  barriers = "b"
  write_cache = "w"

  SUMMARY:
   b=on,w=on: 1:19.53 elapsed @ 2% CPU [BENCH_1]
  b=on,w=off: 1:23.59 elapsed @ 2% CPU [BENCH_2]
  b=off,w=on: 0:21.35 elapsed @ 9% CPU [BENCH_3]
b=off,w=off: 0:42.90 elapsed @ 4% CPU [BENCH_4]

So it depends on your settings as far as how slow barriers affect the I/O.

Scheduler used: CFQ.
[    0.168390] io scheduler cfq registered (default)

The raw details:

BENCH_1
# /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
0.16user 1.85system 1:19.53elapsed 2%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+970minor)pagefaults 0swaps

BENCH_2
(turn off write-cache)

# hdparm -W0 /dev/sda

/dev/sda:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
# hdparm -W0 /dev/sdb

/dev/sdb:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
#

# /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
0.16user 1.86system 1:23.59elapsed 2%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (14major+953minor)pagefaults 0swaps

BENCH_3
(barriers=off; write_cache=on)
# /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
0.18user 1.86system 0:21.35elapsed 9%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (14major+952minor)pagefaults 0swaps

BENCH_4
(turn off write-cache)

# hdparm -W0 /dev/sda

/dev/sda:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
# hdparm -W0 /dev/sdb

/dev/sdb:
  setting drive write-caching to 0 (off)
  write-caching =  0 (off)
#

# /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
0.18user 1.76system 0:42.90elapsed 4%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (14major+954minor)pagefaults 0swaps








_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
