Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 249117F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 07:42:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1343E30404E
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 05:42:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JSpNlZlQyZBmehYS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 05:42:12 -0800 (PST)
Date: Fri, 14 Nov 2014 08:42:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Mismatch UUID
Message-ID: <20141114134208.GB36731@bfoster.bfoster>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
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
To: Robert Tench <robtench@hotmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 14, 2014 at 07:57:42PM +1100, Robert Tench wrote:
>                                                             Robert has a file to share with you on OneDrive. To view it, click the link below.                                                                                                        xfs.log                                                                            So finally have managed to find a way to save the complete log of running xfs_repair -n /dev.md4
> 
> And below is the output of xfs_check /dev/md4
> 
> root@ubuntu:~# xfs_check /dev/md4
> * ERROR: mismatched uuid in log
> *            SB : 813833a7-1bd3-4447-b575-09d1471bb652
> *            log: ea3833af-25ce-9f91-b575-018fb49df3b1
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> 

You want to use xfs_repair (-n) rather than xfs_check. I think you
mentioned in your other email you've tried xfs_repair..? The above
message indicates a dirty log, have you attempted to mount the device to
replay the log?

> And the output from mdadm -D /dev/md4 is as follows
> 

How did you put the array back together? Did it assemble fine or did you
have to recreate it? If the latter, how are you sure the geometry is
correct (it looks like it's syncing)?

Brian

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
> 
>     Update Time : Fri Nov 14 15:58:16 2014
>           State : clean 
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>            Name : (none):4
>            UUID : e0829810:9782b51f:25529f65:8823419c
>          Events : 1243386
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        6       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        5       8       50        3      active sync   /dev/sdd2
>        4       8       66        4      active sync   /dev/sde2
> 
> 
> And then the response from mdadm -E /dev/md4
> 
> root@ubuntu:~# mdadm -E /dev/md4
> mdadm: No md superblock detected on /dev/md4.
> 
> Not sure what to do, any help would be appreciated
> 
> Regards,
> 
> Rob
> 
> 
> 
>                  		 	   		  

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
