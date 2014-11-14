Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F29DC7F47
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 16:31:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF0BE8F8039
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 14:31:44 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id nWv5DK2xkYRVyALW
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2014 14:31:43 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Mismatch UUID
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
Date: Fri, 14 Nov 2014 15:31:42 -0700
Message-Id: <6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Robert Tench <robtench@hotmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Nov 14, 2014, at 1:57 AM, Robert Tench <robtench@hotmail.com> wrote:

> Robert has a file to share with you on OneDrive. To view it, click the li=
nk below.
>  xfs.log
> So finally have managed to find a way to save the complete log of running=
 xfs_repair -n /dev.md4
> =

> And below is the output of xfs_check /dev/md4
> =

> root@ubuntu:~# xfs_check /dev/md4
> * ERROR: mismatched uuid in log
> *            SB : 813833a7-1bd3-4447-b575-09d1471bb652
> *            log: ea3833af-25ce-9f91-b575-018fb49df3b1
> ERROR: The filesystem has valuable metadata changes in a log which needs =
to
> be replayed.  Mount the filesystem to replay the log, and unmount it befo=
re
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mou=
nt
> of the filesystem before doing this.
> =

> And the output from mdadm -D /dev/md4 is as follows
> =

> root@ubuntu:~# mdadm -D /dev/md4
> /dev/md4:
>         Version : 1.0
>   Creation Time : Fri Jan  1 01:31:17 2010
>      Raid Level : raid5
>      Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
>   Used Dev Size : 2928240640 (2792.59 GiB 2998.52 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
> =

>     Update Time : Fri Nov 14 15:58:16 2014
>           State : clean =

>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
> =

>          Layout : left-symmetric
>      Chunk Size : 512K
> =

>            Name : (none):4
>            UUID : e0829810:9782b51f:25529f65:8823419c
>          Events : 1243386
> =

>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        6       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        5       8       50        3      active sync   /dev/sdd2
>        4       8       66        4      active sync   /dev/sde2
> =

> =

> And then the response from mdadm -E /dev/md4
> =

> root@ubuntu:~# mdadm -E /dev/md4
> mdadm: No md superblock detected on /dev/md4.

-D is for examining the logical md device, -E is for examining the individu=
al members so you=92d use:

mdadm -E /dev/sd[abcde]2

Hopefully you haven=92t used mdadm -C/=97create ? The web is full of such s=
uggestions and it=92s almost always the wrong thing to do, it=92s a near la=
st resort in any case.

> =

> Not sure what to do, any help would be appreciated

It=92s very good to ask instead of haphazardly trying things. Trying to nor=
mally mount the file system should be safe; and then use dmesg to check for=
 kernel messages. The xfs kernel code is responsible for log replay and mak=
ing most kinds of repairs, anything it can=92t deal with will be reported a=
s a kernel message. If mount fails, report kernel xfs related messages, and=
 also the results from xfs_check -n.

Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
