Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3QMXhVW102354 for <xfs@oss.sgi.com>; Thu, 26 Apr 2012 17:33:44 -0500
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id DMylnXvsTUaIOWZP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Apr 2012 15:33:41 -0700 (PDT)
Message-ID: <4F99CD43.5070306@sauce.co.nz>
Date: Fri, 27 Apr 2012 10:33:39 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
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
To: stefanrin@gmail.com
Cc: xfs@oss.sgi.com

I know you were interested in hardware RAID controllers, but out of 
curiosity, this is the result on a 16 x 1TB SATA linux md software RAID6 
array.

Formatted xfs, with external journal on an independent SATA device, 
mounted delaylog,inode64,logbsize=256k,logdev=/dev/md0,noatime,pquota.

Operations performed:  0 Read, 26065 Write, 0 Other = 26065 Total
Read 0b  Written 203.63Mb  Total transferred 203.63Mb  (13.575Mb/sec)
  1737.65 Requests/sec executed

Filesystem is 44% full, kernel 2.6.39.2.

xfs_bmap test_file.0
test_file.0:
         0: [0..8388607]: 9565100544..9573489151
         1: [8388608..16777215]: 9578354176..9586742783

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
