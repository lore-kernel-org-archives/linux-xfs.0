Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3FA47F6B
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 12:56:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7D638F8074
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 10:56:18 -0700 (PDT)
Received: from smtp.hier.us (smtp.hier.us [74.207.254.171]) by cuda.sgi.com
	with ESMTP id Zq2zlvloYwZeoQDb for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 10:56:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.hier.us (Postfix) with ESMTP id 07CBC80B2
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 13:49:47 -0400 (EDT)
Received: from smtp.hier.us ([127.0.0.1])
	by localhost (smtp.hier.us [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P2i0j-dqbzQk for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 13:49:34 -0400 (EDT)
Received: from [192.168.3.10] (unknown [192.168.3.10])
	by smtp.hier.us (Postfix) with ESMTPSA id 6D47380B1
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 13:49:34 -0400 (EDT)
From: Tap <tap@anti-paladin.com>
Subject: Exponential memory usage?
Message-Id: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
Date: Fri, 28 Mar 2014 10:53:54 -0700
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
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
To: xfs@oss.sgi.com

I have a Linux CentOs-based (6.5) system, running Linux 3.10.29 beneath xen 4.2.3-26 with a raid array as follows:

        Version : 1.2
  Creation Time : Mon Apr 29 22:50:41 2013
     Raid Level : raid6
     Array Size : 14650667520 (13971.97 GiB 15002.28 GB)
  Used Dev Size : 2930133504 (2794.39 GiB 3000.46 GB)
   Raid Devices : 7
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Fri Mar 28 10:31:08 2014
          State : active 
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : s2013:0
           UUID : ec5acf05:2c840b70:166cde66:5e21e5c7
         Events : 386

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       7       8      113        1      active sync   /dev/sdh1
       8       8       81        2      active sync   /dev/sdf1
       3       8       97        3      active sync   /dev/sdg1
       4       8       17        4      active sync   /dev/sdb1
       5       8       49        5      active sync   /dev/sdd1
       6       8      129        6      active sync   /dev/sdi1

       9       8       65        -      spare   /dev/sde1

xfs_info shows:

meta-data=/dev/md127             isize=256    agcount=32, agsize=114458368 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=3662666880, imaxpct=5
         =                       sunit=128    swidth=640 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


The system currently has 32 GB of RAM.

I was hoping to use this as the main data-stor for various (small) xen machines, one of which  was going to be a zoneminder system.  Zoneminder makes lots of "small" files (JPG's) from the various HD IP cameras that are connected.

Anyway at some point the system had become unusable.  Something as simple as:

  find  /raid -type f
-- or --
  ls -lR /raid

Would walk the entire system out of RAM.  Looking at slabtop it looks like this is due mostly to xfs_inode memory usage.  Note that since these problems began I stopped running all sub-ordinate domains and am now only running dom0.  In fact I've allocated all 32 GB to that domain, and memory problems still persist.

(At 83% FS utilization) I decided I have to do something to get out of this unusable state and therefore started removing ( rm -rf targetDir ) all of the files that the zoneminder system had generated.  Even this, after a fresh reboot with thing else running, will run the system out of RAM (all 32 GB of it).  The delete of this area is still in progress as I have to periodically restart the machine to get RAM back (as I compose this email it is down to 66% space used).

I've googled and can't really find anything that describes these kinds of problems.  I've tried the few limited tunable values (XFS and VS) and nothing seems to have any positive impact on this run-away memory usage.

My questions are:

1.  Is this expected?

2.  Are there any XFS memory calculators that would have shown me this is a problem to begin with?


Given it walks out of 32 GB of memory I can't be sure that upgrading to 64 or 128 GB will *ever* help this situation.

Note:  FWIW Un-mounting the filesystem also recovers the memory.


Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
