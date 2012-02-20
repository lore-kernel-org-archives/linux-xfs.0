Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KC6woB079179 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 06:06:58 -0600
Received: from extern.innogames.de (extern.innogames.de [80.252.99.240]) by
	cuda.sgi.com with ESMTP id e2LLP0bSq7vHbn9M for
	<xfs@oss.sgi.com>; Mon, 20 Feb 2012 04:06:56 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by extern.innogames.de (Postfix) with ESMTP id 5C3AF5E8013
	for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 13:06:55 +0100 (CET)
Received: from extern.innogames.de ([127.0.0.1])
	by localhost (extern.innogames.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LcbyZYFi87DC for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 13:06:55 +0100 (CET)
Received: from [172.16.5.29] (unknown [212.48.107.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by extern.innogames.de (Postfix) with ESMTPSA id 45C4F28F681
	for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 13:06:55 +0100 (CET)
Message-ID: <4F42375E.7000309@innogames.de>
Date: Mon, 20 Feb 2012 13:06:54 +0100
From: Bernhard Schrader <bernhard.schrader@innogames.de>
MIME-Version: 1.0
Subject: Re: Problems with filesizes on different Kernels
References: <4F3E3F5A.9000202@innogames.de> <20120217123335.GA9671@citd.de>
	<4F420726.6060000@innogames.de> <20120220110614.GA17526@citd.de>
In-Reply-To: <20120220110614.GA17526@citd.de>
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
To: xfs@oss.sgi.com

On 02/20/2012 12:06 PM, Matthias Schniedermeyer wrote:
> On 20.02.2012 09:41, Bernhard Schrader wrote:
>> On 02/17/2012 01:33 PM, Matthias Schniedermeyer wrote:
>>> On 17.02.2012 12:51, Bernhard Schrader wrote:
>>>> Hi all,
>>>>
>>>> we just discovered a problem, which I think is related to XFS. Well,
>>>> I will try to explain.
>>>>
>>>> The environment i am working with are around 300 Postgres databases
>>>> in separated VM's. All are running with XFS. Differences are just in
>>>> kernel versions.
>>>> - 2.6.18
>>>> - 2.6.39
>>>> - 3.1.4
>>>>
>>>> Some days ago i discovered that the file nodes of my postgresql
>>>> tables have strange sizes. They are located in
>>>> /var/lib/postgresql/9.0/main/base/[databaseid]/
>>>> If I execute the following commands i get results like this:
>>>>
>>>> Command: du -sh | tr "\n" " "; du --apparent-size -h
>>>> Result: 6.6G	. 5.7G	.
>>>
>>> Since a few kernel-version XFS does speculative preallocations, which is
>>> primarily a measure to prevent fragmentation.
>>>
>>> The preallocations should go away when you drop the caches.
>>>
>>> sync
>>> echo 3>   /proc/sys/vm/drop_caches
>>>
>>> XFS can be prevented to do that with the mount-option "allocsize".
>>> Personally i use "allocsize=64k", since i first encountered that
>>> behaviour, my workload primarily consists of single-thread writing which
>>> doesn't benefit from this preallocation.
>>> Your workload OTOH may benefit as it should prevent/lower the
>>> fragmentation of the database files.
>>
>> Hi Matthias,
>> thanks for the reply, as far as i can say the "echo 3>
>> /proc/sys/vm/drop_caches" didn't work. the sizes didnt shrink.
>
> You did "sync" before?
> drop caches only drops "clean" pages, everything that is dirty isn't
> dropped. Hence the need to "sync" before.
>
> Also i persume that you didn't stop Postgres?
> I don't know if the process works for files that are currently opened.
>
> When i tested the behaviour i tested it with files copied by "cp", so
> they weren't open by any program when i droped the caches.
>
>> Today
>> i had the chance to test the allocsize=64k. Well, first i thought it
>> worked, i added the mountoption, restarted the server, everything
>> shrink to normal sizes. but right now its more or less "flapping". I
>> have 5.7GB real data and the sizes flap between 6.9GB to 5.7GB.
>> But I am wondering a little about the mount output:
>>
>> # mount
>> /dev/xvda1 on / type xfs
>> (rw,noatime,nodiratime,logbufs=8,nobarrier,allocsize=64k)
>> tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
>> proc on /proc type proc (rw,noexec,nosuid,nodev)
>> sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
>> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
>> devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
>>
>>
>> # cat /proc/mounts
>> rootfs / rootfs rw 0 0
>> /dev/root / xfs rw,noatime,nodiratime,attr2,delaylog,nobarrier,noquota 0 0
>> tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
>> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
>> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
>> tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
>> devpts /dev/pts devpts
>> rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
>>
>>
>> In normal mount output i see the allocsize, but not in cat /proc/mounts?!?
>>
>> Is there a way to completly disable speculative prealocations? or
>> the behavior how it works right now?
>
> In /proc/mounts on my computer allocsize is there:
> /dev/mapper/x1 /x1 xfs rw,nosuid,nodev,noatime,attr2,delaylog,allocsize=64k,noquota 0 0
>
> I tracked down the patch. It went into 2.6.38
>
> - snip -
> commit 055388a3188f56676c21e92962fc366ac8b5cb72
> Author: Dave Chinner<dchinner@redhat.com>
> Date:   Tue Jan 4 11:35:03 2011 +1100
>
>      xfs: dynamic speculative EOF preallocation
>
>      Currently the size of the speculative preallocation during delayed
>      allocation is fixed by either the allocsize mount option of a
>      default size. We are seeing a lot of cases where we need to
>      recommend using the allocsize mount option to prevent fragmentation
>      when buffered writes land in the same AG.
>
>      Rather than using a fixed preallocation size by default (up to 64k),
>      make it dynamic by basing it on the current inode size. That way the
>      EOF preallocation will increase as the file size increases.  Hence
>      for streaming writes we are much more likely to get large
>      preallocations exactly when we need it to reduce fragementation.
>
>      For default settings, the size of the initial extents is determined
>      by the number of parallel writers and the amount of memory in the
>      machine. For 4GB RAM and 4 concurrent 32GB file writes:
>
>      EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET                 TOTAL
>         0: [0..1048575]:         1048672..2097247      0 (1048672..2097247)      1048576
>         1: [1048576..2097151]:   5242976..6291551      0 (5242976..6291551)      1048576
>         2: [2097152..4194303]:   12583008..14680159    0 (12583008..14680159)    2097152
>         3: [4194304..8388607]:   25165920..29360223    0 (25165920..29360223)    4194304
>         4: [8388608..16777215]:  58720352..67108959    0 (58720352..67108959)    8388608
>         5: [16777216..33554423]: 117440584..134217791  0 (117440584..134217791) 16777208
>         6: [33554424..50331511]: 184549056..201326143  0 (184549056..201326143) 16777088
>         7: [50331512..67108599]: 251657408..268434495  0 (251657408..268434495) 16777088
>
>      and for 16 concurrent 16GB file writes:
>
>       EXT: FILE-OFFSET           BLOCK-RANGE          AG AG-OFFSET                 TOTAL
>         0: [0..262143]:          2490472..2752615      0 (2490472..2752615)       262144
>         1: [262144..524287]:     6291560..6553703      0 (6291560..6553703)       262144
>         2: [524288..1048575]:    13631592..14155879    0 (13631592..14155879)     524288
>         3: [1048576..2097151]:   30408808..31457383    0 (30408808..31457383)    1048576
>         4: [2097152..4194303]:   52428904..54526055    0 (52428904..54526055)    2097152
>         5: [4194304..8388607]:   104857704..109052007  0 (104857704..109052007)  4194304
>         6: [8388608..16777215]:  209715304..218103911  0 (209715304..218103911)  8388608
>         7: [16777216..33554423]: 452984848..469762055  0 (452984848..469762055) 16777208
>
>      Because it is hard to take back specualtive preallocation, cases
>      where there are large slow growing log files on a nearly full
>      filesystem may cause premature ENOSPC. Hence as the filesystem nears
>      full, the maximum dynamic prealloc size ?s reduced according to this
>      table (based on 4k block size):
>
>      freespace       max prealloc size
>        >5%             full extent (8GB)
>        4-5%             2GB (8GB>>  2)
>        3-4%             1GB (8GB>>  3)
>        2-3%           512MB (8GB>>  4)
>        1-2%           256MB (8GB>>  5)
>        <1%            128MB (8GB>>  6)
>
>      This should reduce the amount of space held in speculative
>      preallocation for such cases.
>
>      The allocsize mount option turns off the dynamic behaviour and fixes
>      the prealloc size to whatever the mount option specifies. i.e. the
>      behaviour is unchanged.
>
>      Signed-off-by: Dave Chinner<dchinner@redhat.com>
> - snip -
>
>
>
>
>
> Bis denn
>

Yes, I did the sync, and you are right, I didn't restarted the postgres 
process.
Well, but today i restarted the whole server. And regarding the last 
paragraph you wrote, the allocsize=64K should stop the dynamic 
preallocation... but right now it doesnt seem so, the sizes always get 
back to the 5.7GB, but in between it raises up.
Could it be possible, because of the different mount outputs, that it 
didnt get loaded well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
