Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC9B77F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 08:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8EE008F8065
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 06:30:20 -0700 (PDT)
Received: from mail.host2max.com (mail.host2max.com [72.29.91.110]) by
	cuda.sgi.com with ESMTP id a5SuZtZ9NDVDZfJ9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 06:30:19 -0700 (PDT)
From: "Ronnie Tartar" <rtartar@host2max.com>
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>	<5244234D.1010603@hardwarefreak.com>
	<100f01cebaba$0ae84280$20b8c780$@host2max.com>
In-Reply-To: <100f01cebaba$0ae84280$20b8c780$@host2max.com>
Subject: RE: Issues and new to the group
Date: Thu, 26 Sep 2013 09:30:17 -0400
Message-ID: <101601cebabc$8acb99a0$a062cce0$@host2max.com>
MIME-Version: 1.0
Content-Language: en-us
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

Stan, looks like I have directory fragmentation problem.

xfs_db> frag -d
actual 65057, ideal 4680, fragmentation factor 92.81%

What is the best way to fix this?

Thanks


-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of
Ronnie Tartar
Sent: Thursday, September 26, 2013 9:12 AM
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com
Subject: RE: Issues and new to the group

Stan,

Thanks for the reply.

My fragmentation is:

[root@AP-FS1 ~]# xfs_db -c frag -r /dev/xvdb1 actual 10470159, ideal
10409782, fragmentation factor 0.58%

xfs_db> freesp
   from      to extents  blocks    pct
      1       1   52343   52343   0.08
      2       3   34774   86290   0.13
      4       7  122028  732886   1.08
      8      15  182345 1898531   2.80
     16      31  147747 3300501   4.87
     32      63  111134 4981898   7.35
     64     127   93359 8475962  12.50
    128     255   51914 9069884  13.38
    256     511   25548 9200077  13.57
    512    1023   23027 17482586  25.79
   1024    2047    8662 10600931  15.64
   2048    4095     808 1915158   2.82

The volume is 57% full.

I have removed allocsize=64m from the fstab and rebooted.  These are not
large files and this could definitely cause issues.  
Would copying them to new folder and renaming the folder back help?

This is running virtualized, definitely not a rust bucket.  It's x5570 cpus
with MD3200 Array with light I/O. 

Seems like i/o wait is not problem, system% is problem.  Is this the OS
trying to find spot for these files?

Thanks





-----Original Message-----
From: Stan Hoeppner [mailto:stan@hardwarefreak.com]
Sent: Thursday, September 26, 2013 8:07 AM
To: Ronnie Tartar
Cc: xfs@oss.sgi.com
Subject: Re: Issues and new to the group

On 9/26/2013 6:47 AM, Ronnie Tartar wrote:

> I have a 600GB xfs file system mounted that suddenly started running 
> slow on writes.  It takes about 2.5 to 3.5 seconds to write a single 
> file.  Some

This typically occurs when the filesystem gets near full and free space is
heavily fragmented.  Writing to these free space fragments requires lots of
seeking.  Seeking causes latency.  I assume your storage device is spinning
rust, yes?

> folders (with less number of files) work well.  But it will copy fast, 
> then slow for long periods of time.

Some allocation groups may have less fragmented free space than others.
 Put another way, they may have more contiguous free space.  Thus less
seeking.

> This is a virtualized CentOS 5.9 64 bit box on Citrix Xenserver 
> 5.6SP2.  Doesn't seem to be a load i/o issue as most of
> the load is system%.  My fragmentation is less than 1 %.    Any help would
> be greatly appreciated.  I was looking to see if there was a better 
> way to mount this partition or allocate more memory, whatever it 
> takes.  The folders are image folders that have anywhere between 5 to
> 10 million images in each folder.

> Fstab mount is: 
> /dev/xvdb1              /images xfs
> defaults,nodiratime,nosuid,nodev,allocsize=64m 1 1
                                   ^^^^^^^^^^^^^ This tells XFS to allocate
64MB of free space at the end of each file being allocated.  If free space
is heavily fragmented and the fragments are all small, this will exacerbate
the seek problem.  Given the 64MB allocsize, I assume these image files are
quite large.  If this is correct, writing them over scattered small free
space fragments also requires seeking.  Thus, I'd guess you're seeking your
disk, or array, to death.

How full is the XFS volume, and what does your free space fragmentation map
look like?

--
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
