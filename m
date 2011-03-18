Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2IJNpBV051539 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 14:23:56 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2A9CB07580
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:26:47 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 5gEOxKZ99dku8ZvV for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:26:47 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:26:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <201103182010.37455.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<201103181659.46558.arnd@arndb.de>
	<alpine.DEB.2.02.1103181259480.21715@p34.internal.lan>
	<201103182010.37455.arnd@arndb.de>
MIME-Version: 1.0
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, flashbench-results@lists.linaro.org, Alan Piszcz <ap@solarrain.com>



On Fri, 18 Mar 2011, Arnd Bergmann wrote:

> On Friday 18 March 2011 18:45:34 Justin Piszcz wrote:
>> On Fri, 18 Mar 2011, Arnd Bergmann wrote:
>>> Getting back to the rogiinal question, I'd recommend testing the
>>> stick by doing raw accesses instead of a file system. A simple
>>
>> Ok, here are the results:
>>
>> root@sysresccd /root % time dd if=/dev/zero of=/dev/sda oflag=direct bs=4M
>> dd: writing `/dev/sda': No space left on device
>> 1961+0 records in
>> 1960+0 records out
>> 8220835840 bytes (8.2 GB) copied, 283.744 s, 29.0 MB/s
>
> Ok, so no immediate problem there.
>
>>> I'm also interested in results from flashbench
>>> (git://git.linaro.org/people/arnd/flashbench.git, e.g. like
>>> http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html)
>>> That might help explain how the stick failed.
>>
>> Certainly, testing below, following this:
>> http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html
>
> I'm sorry, I should have been more specific. Unfortunately, running flashbench
> is not very user friendly yet.
>
> The results indicate that the device does not have a 2 MB erase block size
> but rather 4 or 8, which is more common on 8 GB media.
>
>> # ./flashbench --open-au --open-au-nr=1  /dev/sda --blocksize=8192   --erasesize=$[2* 1024 * 1024]  --random
>> 2MiB    29.5M/s
>> 1MiB    29.1M/s
>> 512KiB  28.5M/s
>> 256KiB  22.8M/s
>> 128KiB  23.8M/s
>> 64KiB   24.4M/s
>> 32KiB   18.9M/s
>> 16KiB   13.1M/s
>> 8KiB    8.22M/s
>>
>> # ./flashbench --open-au --open-au-nr=4  /dev/sda --blocksize=8192 --erasesize=$[2* 1024 * 1024]  --random
>> 2MiB    25.9M/s
>> 1MiB    21.8M/s
>> 512KiB  15M/s
>> 256KiB  11.9M/s
>> 128KiB  12.1M/s
>> 64KiB   13.6M/s
>> 32KiB   9.81M/s
>> 16KiB   6.41M/s
>> 8KiB    3.88M/s
>
> The numbers are jumping around a bit with the incorrectly guessed erasesize.
> These values should be more like the ones in the first test. Can you rerun
> with --erasesize=$[4 * 1024 * 1024]?
Hi, I put the box back into production with ext2, if it fails again I can 
re-run.

>
> Also, what is the output of 'lsusb' for this stick? I'd like to add the
> data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
Sure,
Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive

>
>> # ./flashbench --open-au --open-au-nr=5  /dev/sda --blocksize=8192 --erasesize=$[2* 1024 * 1024]  --random
>> 2MiB    29.2M/s
>> 1MiB    27.8M/s
>> 512KiB  18.4M/s
>> 256KiB  7.82M/s
>> 128KiB  4.62M/s
>> 64KiB   2.47M/s
>> 32KiB   1.26M/s
>> 16KiB   642K/s
>> 8KiB    327K/s
>
> This is where your drive stops coping with the accesses: Writing small
> blocks to four different erase blocks (2MB for the test, probably
> larger) works fine, but writing to five of them is devestating for
> performance, going from 30 MB/s to 300 KB/s, or lower if you were
> to write smaller than 8 KB blocks.
>
> The cutoff at --open-au-nr=4 is coincidentally the same as for the
> SD card I was testing. This is what happens in the animation in
> http://lwn.net/Articles/428799/. The example given there is for
> a drive that can only have two open AUs (allocation units aka
> erase blocks), while yours does 4.
>
>> (did not run one with 7)
>
> Note that the test results I had with 6 and 7 are without --random,
> so the cut-off there was higher for that card when writing an
> multiple erase blocks from start to finish instead of writing random
> sectors inside of them.
>
>> # ./flashbench --findfat --fat-nr=10 /dev/sda --blocksize=1024 --erasesize=$[2* 1024 * 1024]   --random
>> 2MiB    22.7M/s  19.1M/s  15.5M/s  13.1M/s  29.5M/s  29.5M/s  29.6M/s  29.6M/s  29.5M/s  29.5M/s
>> 1MiB    20.6M/s  13.3M/s  13.3M/s  20.8M/s  18.1M/s  17.8M/s  18M/s    18.3M/s  18.8M/s  18.6M/s
>> 512KiB  18.4M/s  18.6M/s  18.3M/s  18.1M/s  23.5M/s  23.2M/s  23.5M/s  23.5M/s  23.4M/s  23.4M/s
>> 256KiB  26.9M/s  21.3M/s  21.2M/s  21M/s    21.1M/s  21.2M/s  21.1M/s  21.1M/s  20.6M/s  21M/s
>> 128KiB  22.2M/s  22.3M/s  22.6M/s  21.4M/s  21.5M/s  21.3M/s  21.6M/s  21.3M/s  21.4M/s  21.4M/s
>> 64KiB   23.9M/s  22.6M/s  22.9M/s  23M/s    22.5M/s  22.4M/s  22.4M/s  22.4M/s  22.5M/s  22.4M/s
>> 32KiB   18.2M/s  18.3M/s  18.3M/s  18.3M/s  18.3M/s  18.4M/s  18.3M/s  18.2M/s  18.3M/s  18.3M/s
>> 16KiB   12.9M/s  12.9M/s  13M/s    13M/s    12.9M/s  13M/s    12.9M/s  12.9M/s  12.9M/s  12.9M/s
>> 8KiB    8.14M/s  8.15M/s  8.15M/s  8.15M/s  8.15M/s  8.14M/s  8.14M/s  8.15M/s  8.15M/s  8.06M/s
>> 4KiB    4.07M/s  4.08M/s  4.07M/s  4.06M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s
>> 2KiB    2.02M/s  2.02M/s  2.02M/s  2.02M/s  2.02M/s  2.01M/s  2.01M/s  2.01M/s  2.01M/s  2.02M/s
>> 1KiB    956K/s   954K/s   956K/s   953K/s   947K/s   947K/s   947K/s   950K/s   947K/s   948K/s
>>
>
> One thing that is very clear from this is that this stick has a page size
> of 8KB, and that it requires at least 64 KB transfers for the maximum speed.
>
> If your partition is not aligned to 8 KB or more (better: to the erase
> block size, e.g. 4 MB) or if the file system writes smaller than 8 KB
> naturally aligned blocks at once, the drive has to do read-modify-write
> cycles that severely impact performance and the expected life-time.
>
> I cannot see any block that is optimzied for storing the FAT, which is
> good, as this means that the manufacturer did not exclusively design
> the stick for FAT32, as is normally the case with flash memory cards.
>
> For this stick, I would strongly recommend creating the file system
> in a way that writes at least 16 KB naturally aligned blocks at all
> times, but I don't know if that's supported by XFS.
>
> Also, the limitation of forcing a garbage collection when writing to
> more than four 4 MB (or so) segments may be a problem, depending on
> how XFS stores its metadata. The good news is that it can do random
> write access inside of the erase blocks.
>
> 	Arnd
>

Thanks for your response, per the recommendations earlier I've migrated to ext2
and am running that now and I still need to read that article.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
