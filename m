Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IHgcer047627 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:42:43 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EBD26361243
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:45:34 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with SMTP id o1FK0eOzP3uuQiP3 for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:45:34 -0700 (PDT)
Date: Fri, 18 Mar 2011 13:45:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <201103181659.46558.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1103181259480.21715@p34.internal.lan>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
	<201103181659.46558.arnd@arndb.de>
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
Cc: Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Tim Soderstrom <tim@moocowproductions.org>



On Fri, 18 Mar 2011, Arnd Bergmann wrote:

> On Friday 18 March 2011, Tim Soderstrom wrote:
>
>>>
>>> However, after some amount of time, the errors occur below, is this USB
>>> stick failing?  Since it has no SMART, is there any other way to verify
>>> the 'health' of a USB stick?
>>
>> What prompted you to go with XFS over, say, ext2? The journal will generally
>> cause quite a bit more writes onto your USB device. I use ext2 on my CF card
>> in my NAS for that reason (the spinning media is on XFS of course). I know
>> that's not an answer to your problem but thought I would add it as a suggestion :)
>
> Using ext2 on flash media instead of ext3 or other file systems is
> recommended a lot, but the situation is actually much more complex.
> In https://lwn.net/Articles/428584/, I explain how these things work
> under the cover. For a drive that can only have very few erase blocks
> open, using a journaled file system will always mean thrashing, but
> for drives with more open erase blocks, it's probably better to
> use a journal than not.
>
> I still need to do simulations to figure out how this exactly
> ends up on various file systems, and I had not considered XFS
> so far.
Ok, I performed all of the tests and I did not notice any type of failures,
unless I am not interpreting the results correctly..

>
> Getting back to the rogiinal question, I'd recommend testing the
> stick by doing raw accesses instead of a file system. A simple
>
> dd if=/dev/sdX of=/dev/zero iflag=direct bs=4M

root@sysresccd /root % time dd if=/dev/sda of=/dev/zero iflag=direct bs=4M
1960+0 records in
1960+0 records out
8220835840 bytes (8.2 GB) copied, 234.265 s, 35.1 MB/s
dd if=/dev/sda of=/dev/zero iflag=direct bs=4M  0.01s user 1.88s system 0% cpu 3:54.28 total
root@sysresccd /root %

>
> will read the entire stick and report any errors. The corresponding
>
> dd of=/dev/zero of=/dev/sdX oflag=direct bs=4M

.. yes I took a second backup (before wiping) before doing this (below) ..

>
> writes the entire stick. Some media won't report errors on write,
> though, so this might not help you at all.

Ok, here are the results:

root@sysresccd /root % time dd if=/dev/zero of=/dev/sda oflag=direct bs=4M
dd: writing `/dev/sda': No space left on device
1961+0 records in
1960+0 records out
8220835840 bytes (8.2 GB) copied, 283.744 s, 29.0 MB/s
dd if=/dev/zero of=/dev/sda oflag=direct bs=4M  0.01s user 7.14s system 2% cpu 4:43.75 total
root@sysresccd /root %

> I'm also interested in results from flashbench
> (git://git.linaro.org/people/arnd/flashbench.git, e.g. like
> http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html)
> That might help explain how the stick failed.

Certainly, testing below, following this:
http://lists.linaro.org/pipermail/flashbench-results/2011-March/000039.html

# ./flashbench --open-au --open-au-nr=1  /dev/sda --blocksize=8192   --erasesize=$[2* 1024 * 1024]  --random
2MiB    29.5M/s 
1MiB    29.1M/s 
512KiB  28.5M/s 
256KiB  22.8M/s 
128KiB  23.8M/s 
64KiB   24.4M/s 
32KiB   18.9M/s 
16KiB   13.1M/s 
8KiB    8.22M/s

# ./flashbench --open-au --open-au-nr=4  /dev/sda --blocksize=8192 --erasesize=$[2* 1024 * 1024]  --random
2MiB    25.9M/s 
1MiB    21.8M/s 
512KiB  15M/s 
256KiB  11.9M/s 
128KiB  12.1M/s 
64KiB   13.6M/s 
32KiB   9.81M/s 
16KiB   6.41M/s 
8KiB    3.88M/s

# ./flashbench --open-au --open-au-nr=5  /dev/sda --blocksize=8192 --erasesize=$[2* 1024 * 1024]  --random
2MiB    29.2M/s 
1MiB    27.8M/s 
512KiB  18.4M/s 
256KiB  7.82M/s 
128KiB  4.62M/s 
64KiB   2.47M/s 
32KiB   1.26M/s 
16KiB   642K/s 
8KiB    327K/s 
#

# ./flashbench --open-au --open-au-nr=6  /dev/sda --blocksize=1024 --erasesize=$[2* 1024 * 1024]  --random
2MiB    29.2M/s 
1MiB    25.6M/s 
512KiB  15.2M/s 
256KiB  7.8M/s 
128KiB  4.73M/s 
64KiB   2.53M/s 
32KiB   1.3M/s 
16KiB   659K/s 
8KiB    333K/s 
^C
#

(did not run one with 7)

# ./flashbench --findfat --fat-nr=10 /dev/sda --blocksize=1024 --erasesize=$[2* 1024 * 1024]   --random
2MiB    22.7M/s  19.1M/s  15.5M/s  13.1M/s  29.5M/s  29.5M/s  29.6M/s  29.6M/s  29.5M/s  29.5M/s 
1MiB    20.6M/s  13.3M/s  13.3M/s  20.8M/s  18.1M/s  17.8M/s  18M/s    18.3M/s  18.8M/s  18.6M/s 
512KiB  18.4M/s  18.6M/s  18.3M/s  18.1M/s  23.5M/s  23.2M/s  23.5M/s  23.5M/s  23.4M/s  23.4M/s 
256KiB  26.9M/s  21.3M/s  21.2M/s  21M/s    21.1M/s  21.2M/s  21.1M/s  21.1M/s  20.6M/s  21M/s 
128KiB  22.2M/s  22.3M/s  22.6M/s  21.4M/s  21.5M/s  21.3M/s  21.6M/s  21.3M/s  21.4M/s  21.4M/s 
64KiB   23.9M/s  22.6M/s  22.9M/s  23M/s    22.5M/s  22.4M/s  22.4M/s  22.4M/s  22.5M/s  22.4M/s 
32KiB   18.2M/s  18.3M/s  18.3M/s  18.3M/s  18.3M/s  18.4M/s  18.3M/s  18.2M/s  18.3M/s  18.3M/s 
16KiB   12.9M/s  12.9M/s  13M/s    13M/s    12.9M/s  13M/s    12.9M/s  12.9M/s  12.9M/s  12.9M/s 
8KiB    8.14M/s  8.15M/s  8.15M/s  8.15M/s  8.15M/s  8.14M/s  8.14M/s  8.15M/s  8.15M/s  8.06M/s 
4KiB    4.07M/s  4.08M/s  4.07M/s  4.06M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s  4.04M/s 
2KiB    2.02M/s  2.02M/s  2.02M/s  2.02M/s  2.02M/s  2.01M/s  2.01M/s  2.01M/s  2.01M/s  2.02M/s 
1KiB    956K/s   954K/s   956K/s   953K/s   947K/s   947K/s   947K/s   950K/s   947K/s   948K/s

Ideas?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
