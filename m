Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04AA57F59
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:21:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 897E5AC008
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:21:18 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id adfjQMzHNFGhNiug
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:21:17 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: higher agcount on LVM2 thinp volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130830025819.GB23571@dastard>
Date: Thu, 29 Aug 2013 21:21:15 -0600
Message-Id: <B40ABF48-E2CB-4C02-9DF9-B68BB84341C3@colorremedies.com>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
	<DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
	<20130830025819.GB23571@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com


On Aug 29, 2013, at 8:58 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> Check the contents of
> /sys/block/<dev>/queue/{minimum,optimal}_io_size for the single
> device, the standard LV and the thinp device.

physical device:

[root@f19s ~]# cat /sys/block/sda/queue/minimum_io_size 
512
[root@f19s ~]# cat /sys/block/sda/queue/optimal_io_size 
0

conventional LV on that physical device:
     
[root@f19s ~]# cat /sys/block/dm-0/queue/minimum_io_size 
512
[root@f19s ~]# cat /sys/block/dm-0/queue/optimal_io_size 
0


thinp pool and LV:

lrwxrwxrwx. 1 root root       7 Aug 29 20:46 vg1-thinp -> ../dm-3

[root@f19s ~]# cat /sys/block/dm-3/queue/minimum_io_size 
512
[root@f19s ~]# cat /sys/block/dm-3/queue/optimal_io_size 
262144
[root@f19s ~]# 

lrwxrwxrwx. 1 root root       7 Aug 29 20:47 vg1-data -> ../dm-4

[root@f19s ~]# cat /sys/block/dm-4/queue/minimum_io_size 
512
[root@f19s ~]# cat /sys/block/dm-4/queue/optimal_io_size 
262144


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
