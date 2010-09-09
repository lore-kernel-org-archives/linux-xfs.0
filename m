Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89EC6uE103350 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 09:12:06 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3B115D047
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 07:12:51 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id BbSLO1sojxyGRcLX for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 07:12:51 -0700 (PDT)
Message-ID: <4C88EB62.5060000@sandeen.net>
Date: Thu, 09 Sep 2010 09:12:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: fragmentation question
References: <C8AC2AC5.6CA9%bchang@greenplum.com>
In-Reply-To: <C8AC2AC5.6CA9%bchang@greenplum.com>
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
To: Brady Chang <bchang@greenplum.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Brady Chang wrote:
> Hello All,
> I have an issue with fragmentation on a particular device
> thanks for any advice.
> 
> -Brady
> 
> I have a Dell r510 with 12 disks
> 2xraid 5 (6 disks each)
> raid group1:
> 48 GB   carved out for os mounted as /
> remaining space  2.7 TB for xfs mounted as /data1
> raid group2:
> 48 GB  for swap
> remaining space 2.7 TB for xfs mounted as /data2
> 
> The strange thing is that /data1 never gets fragmented where as /data2
> is badly fragmented.
> I believe increase allocsize would help, but not sure how to explain why
> /data2(/dev/sdd) always gets fragmented and not /data1(/dev/sdb)
> 
> It's a data warehouse application.  the I/O is balanced between /data1
> and /data2:
> output of xfs_db
> [root@sdw4 data1]# xfs_db -c frag -r /dev/sdb
> actual 14353, ideal 13702, fragmentation factor 4.54%
> [root@sdw4 data1]# xfs_db -c frag -r /dev/sdd
> actual 408674, ideal 13719, fragmentation factor 96.64%

so each file has 30 extents on average (actual/ideal)

> df output
> /dev/sdb              2.7T  967G  1.8T  36% /data1
> /dev/sdd              2.7T  1.1T  1.7T  39% /data2

1.1T/408674 extents is ~3M per extent, not so good.

How many files are on each fs?

> LABEL=/data1        /data1     xfs
>     allocsize=1048576,logbufs=8,noatime,nodiratime 0 0
> LABEL=/data2        /data2     xfs
>     allocsize=1048576,logbufs=8,noatime,nodiratime 0 0

Everything but the first option is default, BTW.

Is xfs_info output on the 2 filesystems the same?

Otherwise Emmanuel's idea is a good one, maybe it's not
as balanced as you think it is, or maybe they have aged
differently and have different amounts of freespace
(see the freesp command in xfs_db)

> By the way, the os is RHEL 5.5 kernel 2.6.18-194.11.1.el5

Was Red Hat support not helpful?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
