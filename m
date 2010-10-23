Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9NJtAnV060174 for <xfs@OSS.SGI.com>; Sat, 23 Oct 2010 14:55:10 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE1D0F5ADB4
	for <xfs@OSS.SGI.com>; Sat, 23 Oct 2010 13:11:42 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 47KZv6DDpwSpfZNA
	for <xfs@OSS.SGI.com>; Sat, 23 Oct 2010 13:11:42 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P9kCV-0000Yd-96
	for <xfs@OSS.SGI.com>; Sat, 23 Oct 2010 20:56:23 +0100
MIME-Version: 1.0
Message-ID: <19651.15840.54770.942761@tree.ty.sabi.co.uk>
Date: Sat, 23 Oct 2010 20:56:16 +0100
Subject: Re: XFS use within multi-threaded apps
In-Reply-To: <AANLkTikqHvSmr=WSZ3t8m3wKOGcUmQQ1v9Qx9MqGArS+@mail.gmail.com>
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
	<87eibm4xon.fsf@willster.local.flamingspork.com>
	<AANLkTikqHvSmr=WSZ3t8m3wKOGcUmQQ1v9Qx9MqGArS+@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

>>> I have a use case where I'd like to forward the use of XFS. This is for
>>> large (multi-GB, say anywhere from 5GB to 300GB) individual files, such as
>>> what you'd see under a database's data file / tablespace.

>> Step 1) Use XFS.
>> Nothing, and I do mean nothing comes close to reliability and consistent
>> performance.

> I have been running iozone benchmarks, [ ... ]

I think that it is exceptionally difficult to get useful results
out of Iozone...

>>> My database vendor (who, coincidentally markets their own
>>> filesystems and operating systems) says that there are
>>> certain problems under XFS with specific mention of
>>> corruption issues, if a single root or the metadata become
>>> corrupted, the entire filesystem is gone,

If that's bad enough it applies to any file system out there
except FAT and Reiser, as they store some metadata with each
block. ZFS and BTRFS may have something similar. But it is not
an issue.

>>> and it has performance issues on a multi-threaded workload,
>>> caused by the single root filesystem for metadata becoming a
>>> bottleneck.

That's actually more of a problem with Lustre, in extreme cases.

>> XFS has anything but performance problems on multithreaded
>> workloads. It is *the* best of the Linux filesystems
>> (actually... possibly any file system anywhere) for
>> multithreaded IO.

That's actually multithreaded IO to the same file, for
multithreaded IO to different files JFS (and allegedly 'ext4') are
also fairly good. 

> Well - I mentioned it above. Their current recommendation for
> Linux is to stick with ext3... and for big file/big IO
> operations, switch to ext4.

That's just about because those are the file systems that are
"qualified", and 'ext3' defaults give the lowest risks in case the
application environment is misdesigned and relies on 'O_PONIES'.

> [ ... ] "well, ext3 has problems whenever the kernel journal
> thread wakes up to flush under heavy I/O,

That actually happens with every file system, and it is one of
several naive misdesigns in the Linux IO subsystem. The default
Linux page cache flusher parameters are often too "loose" by a 1-2
orders of magnitude, and this can cause serious problems. Nedver
mind that the page cache


In any case the Linux page cache itself is also a bit of a joke, a
(hopefully) a DBMS will not use it anyhow, but use direct IO, and
XFS is targeted at direct IO, large file, multistreaming loads.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
