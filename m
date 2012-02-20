Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K8fDsd067765 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 02:41:13 -0600
Received: from extern.innogames.de (extern.innogames.de [80.252.99.240]) by
	cuda.sgi.com with ESMTP id j31FllAz9gt6LQXV for
	<xfs@oss.sgi.com>; Mon, 20 Feb 2012 00:41:12 -0800 (PST)
Message-ID: <4F420726.6060000@innogames.de>
Date: Mon, 20 Feb 2012 09:41:10 +0100
From: Bernhard Schrader <bernhard.schrader@innogames.de>
MIME-Version: 1.0
Subject: Re: Problems with filesizes on different Kernels
References: <4F3E3F5A.9000202@innogames.de> <20120217123335.GA9671@citd.de>
In-Reply-To: <20120217123335.GA9671@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On 02/17/2012 01:33 PM, Matthias Schniedermeyer wrote:
> On 17.02.2012 12:51, Bernhard Schrader wrote:
>> Hi all,
>>
>> we just discovered a problem, which I think is related to XFS. Well,
>> I will try to explain.
>>
>> The environment i am working with are around 300 Postgres databases
>> in separated VM's. All are running with XFS. Differences are just in
>> kernel versions.
>> - 2.6.18
>> - 2.6.39
>> - 3.1.4
>>
>> Some days ago i discovered that the file nodes of my postgresql
>> tables have strange sizes. They are located in
>> /var/lib/postgresql/9.0/main/base/[databaseid]/
>> If I execute the following commands i get results like this:
>>
>> Command: du -sh | tr "\n" " "; du --apparent-size -h
>> Result: 6.6G	. 5.7G	.
>
> Since a few kernel-version XFS does speculative preallocations, which is
> primarily a measure to prevent fragmentation.
>
> The preallocations should go away when you drop the caches.
>
> sync
> echo 3>  /proc/sys/vm/drop_caches
>
> XFS can be prevented to do that with the mount-option "allocsize".
> Personally i use "allocsize=64k", since i first encountered that
> behaviour, my workload primarily consists of single-thread writing which
> doesn't benefit from this preallocation.
> Your workload OTOH may benefit as it should prevent/lower the
> fragmentation of the database files.
>
>
>
>
>
>
> Bis denn
>

Hi Matthias,
thanks for the reply, as far as i can say the "echo 3 > 
/proc/sys/vm/drop_caches" didn't work. the sizes didnt shrink. Today i 
had the chance to test the allocsize=64k. Well, first i thought it 
worked, i added the mountoption, restarted the server, everything shrink 
to normal sizes. but right now its more or less "flapping". I have 5.7GB 
real data and the sizes flap between 6.9GB to 5.7GB.
But I am wondering a little about the mount output:

# mount
/dev/xvda1 on / type xfs 
(rw,noatime,nodiratime,logbufs=8,nobarrier,allocsize=64k)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)


# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / xfs rw,noatime,nodiratime,attr2,delaylog,nobarrier,noquota 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
devpts /dev/pts devpts 
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0


In normal mount output i see the allocsize, but not in cat /proc/mounts?!?

Is there a way to completly disable speculative prealocations? or the 
behavior how it works right now?


regards
Bernhard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
