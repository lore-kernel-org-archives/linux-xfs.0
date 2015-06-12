Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 588227F58
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 15:19:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29D93304043
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2015 13:19:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xr0aW5QLaHzGCkD9 for <xfs@oss.sgi.com>;
	Fri, 12 Jun 2015 13:19:42 -0700 (PDT)
Message-ID: <557B3EDD.3030502@sandeen.net>
Date: Fri, 12 Jun 2015 15:19:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>
	<5579AE85.5080203@sandeen.net>	<5579B034.4070503@sandeen.net>
	<5579B804.9050707@skylable.com>	<20150612122108.GB60661@bfoster.bfoster>	<557AD4D4.3010901@skylable.com>
	<20150612135404.GC60661@bfoster.bfoster>
In-Reply-To: <20150612135404.GC60661@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Karanvir Singh <karanvir.singh@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 6/12/15 8:54 AM, Brian Foster wrote:

>>> I managed to get an updated kernel on a beaglebone I had sitting around,
>>> but I don't reproduce any errors with the "corrupted" image (I think
>>> we've established that the image is fine on-disk and something is going
>>> awry at runtime):
>>>
>>> root@beaglebone:~# uname -a
>>> Linux beaglebone 3.14.1+ #5 SMP Thu Jun 11 20:58:02 EDT 2015 armv7l GNU/Linux
>>> root@beaglebone:~# mount ./xfs2.test.corrupted /mnt/
>>> root@beaglebone:~# ls -al /mnt/a/
>>> total 12
>>> drwxr-xr-x 3 root root   14 Jun 11 16:11 .
>>> drwxr-xr-x 3 root root   14 Jun 11 16:11 ..
>>> drwxr-x--- 2 root root 8192 Jun 11 16:11 b
>>> root@beaglebone:~# ls -al /mnt/a/b/
>>> total 17996
>>> drwxr-x--- 2 root root    8192 Jun 11 16:11 .
>>> drwxr-xr-x 3 root root      14 Jun 11 16:11 ..
>>> -rw-r--r-- 1 root root   12288 Jun 11 16:11 events.db
>>> -rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000000.db
>>> -rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000001.db
>>> -rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000002.db
>>> -rw-r--r-- 1 root root   15360 Jun 11 16:11 f00000003.db
>>> ...
>>> root@beaglebone:~#
>>>
>>> I echo Dave's suggestion down thread with regard to toolchain. This
>>> kernel was compiled with the following cross-gcc (installed via Fedora
>>> package):
>>>
>>> 	gcc version 4.9.2 20150212 (Red Hat Cross 4.9.2-5) (GCC) 
>>>
>>> Are you using something different?
>>
>> /proc/version says:
>>
>> Linux version 3.14.3-00088-g7651c68 (jenkins@boulder-jenkins) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #24 Thu Apr 9 16:13:46 MDT 2015
>>
>> I'll get back to you when I have a new kernel running.
>>
> 
> Ok. FWIW, I just tried rebuilding with the following 4.6.3 toolchain:
> 
> https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/x86_64-gcc-4.6.3-nolibc_arm-unknown-linux-gnueabi.tar.xz
> 
> ... and still didn't reproduce any errors. Of course, this probably
> doesn't have whatever patches and whatnot might be included in the
> distro 4.6.3 toolchain. It could be worth a try depending on what
> happens with a newer kernel, though.

FWIW, I tried mounting the corrupted image and running the ls on
Fedora 22, kernel 4.0.4-303.fc22.armv7hl, gcc version 5.1.1, and had no
problems there either.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
